@php
    $lib2 = array (
        [
            'number_cd'=> '1',
            'name'=>trans('messages.coach'),
        ],
        [
            'number_cd'=> '2',
            'name'=>trans('messages.member'),
        ],
    );
    $lib3 = array (
        [
            'value'=> '1',
            'name'=>trans('messages.use'),
        ],
        [
            'value'=> '2',
            'name'=>trans('messages.not_use'),
        ],
    );
    $data = array(
        [
            '1'=>'<span class="num-length"><textarea class="form-control question required" style="height: 65px" tabindex="7" cols="30" rows="2" maxlength="200" ></textarea></span>',
            '2'=>'<select tabindex="7" class="form-control required sentence_use_typ">
                    <option value="-1"></option>
                    <option value="1">'.trans('messages.use').'</option>
                    <option value="2">'.trans('messages.not_use').'</option>
                </select>',
            '3'=>'<div class="col-sm-12 col-md-12 col-lg-12 col-ltx-12">

                    <div class="row">
                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3">
                            <select  tabindex="7" class="form-control score_no required points_use_typ">
                                <option value="-1"></option>
                                <option value="1">'.trans('messages.use').'</option>
                                <option value="2">'.trans('messages.not_use').'</option>
                            </select>
                        </div>
                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                            <div class="col-sm-12 col-md-12 pa-0">
                                <div class="row">
                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span style="width: 50px;" class="sp-o-clock">'.trans('messages.10_points').'</span></div>
                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                    <span class="num-length">
                                        <input type="text" tabindex="7" class="form-control guideline_10point required" maxlength="20" value="" decimal="2">
                                    </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                            <div class="col-sm-12 col-md-12 pa-0">
                                <div class="row">
                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">'.trans('messages.5_points').'</span></div>
                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                    <span class="num-length">
                                        <input type="text" tabindex="7" class="form-control guideline_5point required" maxlength="20" value="" decimal="2">
                                    </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                            <div class="col-sm-12 col-md-12 pa-0">
                                <div class="row">
                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">'.trans('messages.0_points').'</span></div>
                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                    <span class="num-length">
                                        <input type="text" tabindex="7" class="form-control guideline_0point required" maxlength="20" value="" decimal="2">
                                    </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>',
            '4'=>'<button class="btn btn-rm btn-sm btn-remove-row" tabindex="7">
                    <i class="fa fa-remove"></i>
                </button>',
        ],
    );
@endphp

<div class="row">
    <div class="col-md-5 col-xl-3 col-lg-4 col-12 col-sm-6">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.questionnaire_name') }}</label>
                <div class="input-group">
                <span class="num-length">
                    <input type="hidden" id="company_cd_refer" value={{$listm2400['company_cd']??'-1'}}>
                    <input type="hidden" id="company_cd_login" value={{session_data()->company_cd??''}}>
                    <input type="hidden" id="questionnaire_cd" value={{$listm2400['questionnaire_cd']??''}}>
                    <input type="hidden" id="refer_questionnaire_cd" value={{$listm2400['refer_questionnaire_cd']??''}}>
                    <input type="hidden" id="refer_kbn" value={{$listm2400['refer_kbn']??''}}>
                    <input type="hidden" id="contract_company_attribute" value={{session_data()->contract_company_attribute??0}}>
                    <input style="border-radius: 4px" type="text" id="questionnaire_nm" class="form-control required" maxlength="20"  tabindex="1" value="{{isset($listm2400)?$listm2400['questionnaire_nm']:''}}">
                </span>
                </div>
        </div>
    </div>
{{--     <div class="col-md-1">
    </div> --}}
    <div class="col-md-12 col-xl-4 col-lg-6 col-12 col-sm-12 checkbox-text">
        <div class="form-group">
            <label>{{ __('messages.sending_target') }}</label>
                <div class="row">
                @foreach($lib2 as $key=>$item)
                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                        <label class="container" for="radio-{{$key}}"  for="exampleRadios1">{{$item['name']}}
                            <input name="submit" {{isset($listm2400) && $listm2400['submit']==$item['number_cd']?'checked':''}} id='radio-{{$key}}' value="{{$item['number_cd']}}" type="radio" maxlength="3" tabindex="2">
                            <span class="checkradio"></span>
                        </label>
                    </div>
                @endforeach
                </div>
        </div><!--/.form-group -->
    </div>
    <div class="col-md-5 col-xl-2 col-lg-2 col-12 col-sm-12 checkbox-text">
        <div class="form-group">
            <label class="control-label">&nbsp;</label>
            <span class="num-length">
                    <button class="btn  one-btn show-all button-1on1" type="button" data-dtp="dtp_JGtLk" tabindex="3"><i class="fa fa-eye-slash"> {{ __('messages.redisplay') }}</i></button>
            </span>
        </div><!--/.form-group -->
    </div>
</div> <!-- end .row -->
<label class="control-label">{{ __('messages.questionnaire_purpose') }}</label>
<div class="row show-all-table {{isset($listm2400) && $listm2400['purpose_use_typ']==0?'hidden':''}}">
    <div class=" textarea-div">  
        <span class="num-length">
            <input type="hidden" id="purpose_use_typ" value="{{isset($listm2400)?$listm2400['purpose_use_typ']:'1'}}">
            <textarea name="" maxlength="200" tabindex="4" id="purpose" class="form-control">{{$listm2400['purpose']??''}}</textarea>
        </span>
    </div>
    <div class=" eye-div textcenter setHeight">
        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="4">
            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
        </a>
    </div>
</div>
<br/>
<label class="control-label">{{ __('messages.supplementary_matter') }}</label>
<div class="row show-all-table {{isset($listm2400) && $listm2400['complement_use_typ']==0?'hidden':''}}">
    <div class=" textarea-div">
        <span class="num-length">
            <input type="hidden" id="complement_use_typ" value="{{isset($listm2400)?$listm2400['complement_use_typ']:'1'}}">
            <textarea name="" maxlength="200" tabindex="5" id="complement" class="form-control">{{$listm2400['complement']??''}}</textarea>
        </span>
    </div>
    <div class=" eye-div textcenter setHeight">
        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="5">
            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
        </a>
    </div>
</div>
<br/>
<div class="row">
    <div class="col-md-12">
        <div id="topTable" class="table-responsive wmd-view  table-fixed-header  sticky-headers sticky-ltr-cells _width" style="background-attachment: fixed;">
            <table class="table table-bordered table-hover table-striped fixed-header one-table table-not-cursor table-special" style="margin-bottom:20px !important" id="table-data">
                <thead>
                <tr>
                    <th width="20%">{{ __('messages.question') }}</th>
                    <th width="10%" >{{ __('messages.sentence') }}</th>
                    <th width="65%" >{{ __('messages.points') }}</th>
                    <th width="5%" >
                        <button class="btn btn-rm blue btn-sm" tabindex="6" id="btn-add-row">
                            <i class="fa fa-plus"></i>
                        </button>
                    </th>
                </tr>
                </thead>
                <tbody>
                    @if(!empty($listm2401))
                        @foreach ($listm2401 as $row)
                        <tr class="show-popup browsing_setting" style="cursor: pointer;">
                            <td class=" w-detail-col12 list-img" style="line-break: anywhere;">
                                @if (!($row['question_typ'] !=1 || $mode =='MC'))
                                    {{$row['question'] ?? ''}}
                                    <input type="hidden" class="question" value="{{$row['question'] ?? ''}}" >
                                @else
                                    <span class="num-length">
                                        <textarea class="form-control question required" style="height: 65px" tabindex="7" {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} cols="30" rows="2" maxlength="200" >{{$row['question'] ?? ''}}</textarea>
                                    </span>
                                @endif
                                <input type="hidden" class="question_typ" value="{{$row['question_typ'] ?? ''}}" >
                                <input type="hidden"  class="form-control questionnaire_gyono" value="{{$row['questionnaire_gyono'] ?? ''}}" tabindex="7">
                            </td>
                            <td class=" w-detail-col4 list-img">
                                <select id="treatment_applications_no" {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} tabindex="7" class="form-control required sentence_use_typ">
                                    <option value="-1"></option>
                                    @foreach($lib3 as $key=>$item)
                                        <option value="{{$item['value']??'1'}}" {{$row['sentence_use_typ']==$item['value']?'selected':''}}>
                                            {{$item['name']}}
                                        </option>
                                    @endforeach
                                </select>
                            </td>
                            <td class="w-detail-col5 list-img">
                                <div class="col-sm-12 col-md-12 col-lg-12 col-ltx-12">
                                    <div class="row">
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3">
                                            <select id="score_no_1" {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} tabindex="7" class="form-control required score_no points_use_typ">
                                                <option value="-1"></option>
                                                @foreach($lib3 as $key=>$item)
                                                    <option value="{{$item['value']??'1'}}" {{$row['points_use_typ']==$item['value']?'selected':''}}>
                                                    {{$item['name']}}
                                                </option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block {{isset($row['points_use_typ']) && $row['points_use_typ'] == 2?'hidden':''}}">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span style="width: 50px;" class="sp-o-clock">{{ __('messages.10_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                                        <span class="num-length">
                                                        <input type="text" tabindex="7"  class="form-control guideline_10point required" {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} maxlength="20" value="{{$row['guideline_10point']=='-1'?'':$row['guideline_10point']}}">
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block {{isset($row['points_use_typ']) && $row['points_use_typ'] == 2?'hidden':''}}">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">{{ __('messages.5_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                                        <span class="num-length">
                                                        <input type="text" tabindex="7"  class="form-control guideline_5point required " {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} maxlength="20" value="{{$row['guideline_5point']=='-1' ? '':$row['guideline_5point']}}">
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block {{isset($row['points_use_typ']) && $row['points_use_typ'] == 2?'hidden':''}}">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">{{ __('messages.0_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                                        <span class="num-length">
                                                        <input type="text" {{$row['question_typ'] !=1 || $mode =='MC'?'':'disabled'}} tabindex="7" class="form-control guideline_0point required" maxlength="20" value="{{$row['guideline_0point']=='-1' ?'':$row['guideline_0point']}}">
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="w-detail-col6 text-center list-img">
                                <button class="btn btn-rm btn-sm btn-remove-row" tabindex="7">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                        </tr>
                        @endforeach
                    @else
                        <tr class="show-popup browsing_setting" style="cursor: pointer;">
                            <td class=" w-detail-col12 list-img">
                                <span class="num-length">
                                    <textarea class="form-control question required" style="height: 65px" tabindex="7" cols="30" rows="2" maxlength="200" ></textarea>
                                </span>
                               <input type="hidden"  class=" form-control questionnaire_gyono" value="1" tabindex="7">
                            </td>
                            <td class=" w-detail-col4 list-img">
                                <select  tabindex="7" class="form-control required sentence_use_typ">
                                    <option value="-1"></option>
                                    <option value="1">{{ __('messages.use') }}</option>
                                    <option value="2">{{ __('messages.not_use') }}</option>
                                </select>
                            </td>
                            <td class="w-detail-col5 list-img">
                                <div class="col-sm-12 col-md-12 col-lg-12 col-ltx-12">
                                    <div class="row">
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3">
                                            <select tabindex="7" class="form-control required score_no points_use_typ">
                                                <option value="-1"></option>
                                                <option value="1">{{ __('messages.use') }}</option>
                                                <option value="2">{{ __('messages.not_use') }}</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="ccol-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span style="width: 50px;" class="sp-o-clock">{{ __('messages.10_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                                    <span class="num-length">
                                                        <input type="text" tabindex="7" class="form-control guideline_10point required" maxlength="20" value="" decimal="2">
                                                    </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">{{ __('messages.5_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0>
                                                        <span class="num-length">
                                                        <input type="text" tabindex="7" class="form-control guideline_5point required" maxlength="20" value="" decimal="2">
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 col-3 col-sm-3 col-xl-3 col-lg-3 score-block">
                                            <div class="col-sm-12 col-md-12 pa-0">
                                                <div class="row">
                                                    <div class="col-md-3 col-3 col-xl-4 col-lg-4 col-sm-3 pa-0"><span class="sp-o-clock">{{ __('messages.0_points') }}</span></div>
                                                    <div class="col-md-8 col-8 col-xl-8 col-lg-8 col-sm-8 pa-0">
                                                        <span class="num-length">
                                                        <input type="text" tabindex="7" class="form-control guideline_0point required" maxlength="20" value="" decimal="2">
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="w-detail-col6 text-center list-img">
                                <button class="btn btn-rm btn-sm btn-remove-row" tabindex="7">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="row" style="display: none">
    <div class="col-md-12">
        <div id="topTable" class="table-responsive wmd-view  table-fixed-header  sticky-headers sticky-ltr-cells _width" style="background-attachment: fixed">
            <table class="table table-bordered table-hover table-striped fixed-header one-table table-not-cursor table-special" style="margin-bottom:20px !important" id="table-target-1">
                <thead>
                <tr>
                    <th width="20%">{{ __('messages.question') }}</th>
                    <th width="10%" >{{ __('messages.answer') }}</th>
                    <th width="65%" >{{ __('messages.points') }}</th>
                    <th width="5%" >
                        <button class="btn btn-rm blue btn-sm" id="btn-add-new">
                            <i class="fa fa-plus"></i>
                        </button>
                    </th>
                </tr>
                </thead>
                <tbody>
                    @foreach ($data as $row)
                    <tr class="show-popup" style="cursor: pointer;">
                        <td class="w-detail-col12 list-img">
                            {!!$row['1']!!}
                            <input type="hidden"  class="form-control questionnaire_gyono" value="" tabindex="7">

                        </td>
                        <td class=" w-detail-col4 list-img">
                            {!!$row['2']!!}
                        </td>
                        <td class="w-detail-col5 list-img">
                            {!!$row['3']!!}
                        </td>
                        <td class="w-detail-col6 text-center list-img">
                            {!!$row['4']!!}
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>
<br/>
<div class="row show-all-table {{isset($listm2400) && $listm2400['comment_use_typ']==0?'hidden':''}}" >
    <div class=" textarea-div">
        <input type="hidden" id="comment_use_typ" value="{{isset($listm2400)?$listm2400['comment_use_typ']:'1'}}">
        <textarea readonly="readonly" class="form-control" name="" maxlength="300">{{ __('messages.free_entry_field') }}</textarea>
    </div>
    <div class="eye-div textcenter eye-div-disable">
        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="9">
            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
        </a>
    </div>
</div>
<div class="row justify-content-md-center">
    {!! Helper::buttonRender1on1(['saveButton']) !!}
</div>
<input type="hidden" id="mode" value="{{$mode??''}}">
