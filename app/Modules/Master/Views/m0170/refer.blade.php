@php
$dt = isset($data_tbl2[0][0]) ? $data_tbl2[0][0]:[];
@endphp
<div class="card calHe inner">
    <div class="card-body p-0">
        <div class="row">
            <div class="col-md-6 col-lg-3 col-xl-3 col-xxl-3">
                <div class="form-group">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.name')}}</label>
                    <span class="num-length">
                        <input type="hidden" class="form-control required" tabindex="1" maxlength="10" id="r_sheet_cd" value="{{$data_single['sheet_cd']}}">
                        <input type="hidden" class="form-control required" tabindex="1" maxlength="10" id="im_sheet_cd" value="{{$data_single['sheet_cd']}}">
                        <input type="text" class="form-control required" tabindex="2" maxlength="50" id="r_sheet_nm" value="{{$data_single['sheet_nm']}}">
                    </span>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-6 col-lg-4 col-xl-3 col-xxl-3">
                <div class="form-group">
                    <label class="control-label">{{__('messages.abbreviation')}}</label>
                    <span class="num-length">
                        <input type="text" id="sheet_ab_nm" class="form-control" tabindex="3" maxlength="10" value="{{$data_single['sheet_ab_nm']}}">
                    </span>
                </div>
            </div>
            <div class="col-md-4 col-lg-3 col-xl-3">
                <div class="form-group">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.category')}}</label>
                    <select name="" id="category" tabindex="4" class="form-control required">
                        <option value="-1"></option>
                        @if (isset($combo_category[0]) )
                            @foreach($combo_category as $row)
                                <option value="{{$row['number_cd']}}" {{ ($data_single['category'] ==$row['number_cd'])?'selected':''}}>{{$row['name']}}</option>
                            @endforeach
                        @endif
                    </select>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-3 col-lg-1 col-xl-1 col-xxl-1 ln-min">
                <div class="form-group">
                    <label class="control-label">{{__('messages.sort_order')}}</label>
                    <span class="num-length">
                        <input tabindex="7" type="text" id="arrange_order" class="form-control only-number" placeholder="" maxlength="6" value="{{$dt['arrange_order']}}">
                    </span>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-3 col-lg-1 col-xl-1 col-xxl-1">
                <div class="copy__area">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-4">
                <div class="form-group">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.eval_standard_m0160')}}&nbsp;
                    </label>
                    <select name="" id="point_kinds" tabindex="5" class="form-control required">
                        <option value="-1"></option>
                        @if (isset($combo_point_kinds[0]) )
                            @foreach($combo_point_kinds as $row)
                                <option value="{{$row['point_kinds']}}" {{ ($data_single['point_kinds'] ==$row['point_kinds'])?'selected':''}}>{{$row['point_kinds_nm']}}</option>
                            @endforeach
                        @endif
                    </select>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-3">
                <div class="form-group">
                    <label class="control-label">{{__('messages.calculate_method')}}&nbsp;
                    </label>
                    <div class="radio" id="calculation_typ_change">
                        @foreach($lib2 as $key=>$item)
                            <div class="md-radio-v2 inline-block">
                                <input name="point_calculation_typ1" type="radio" id="YY{{$key}}" {{$data_single['point_calculation_typ1']==$item['number_cd']?'checked':''}}
                                    value="{{$item['number_cd']}}"  maxlength="3" tabindex="5">
                                <label for="YY{{$key}}">{{$item['name']}}</label>
                            </div>
                        @endforeach
                    </div>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3">
                <div class="form-group">
                    <label class="control-label">{{__('messages.compulate_method')}}&nbsp;
                    </label>
                    <div class="radio rad1" id="calculation_typ_change2">
                        @if (isset($rad_point_calculation_typ[0]) )
                            @foreach($rad_point_calculation_typ as $row)
                                <div class="md-radio-v2 inline-block">
                                    <input name="point_calculation_typ2" type="radio" id="{{'ZZ'.$row['number_cd']}}" {{$row['number_cd'] ==$data_single['point_calculation_typ2']?"checked":""}} value="{{$row['number_cd']}}" tabindex="5" {{($data_single['point_calculation_typ1'] == 1 && $row['number_cd'] == 2)?'disabled':''}}>
                                    <label for="{{'ZZ'.$row['number_cd']}}">{{$row['name']}}</label>
                                    
                                </div>
                            @endforeach
                        @endif
                    </div>
                </div><!--/.form-group -->
            </div>
            <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3">
                <div class="form-group">
                    <label class="control-label">{{__('messages.period_setting')}}&nbsp;
                    </label>
                    <div class="radio rad2">
                        @if (isset($rad_evaluation_period[0]) )
                            @foreach($rad_evaluation_period as $row)
                                <div class="md-radio-v2 inline-block">
                                    <input name="evaluation_period" type="radio" id="{{'XX'.$row['detail_no']}}" {{$row['detail_no'] ==$data_single['evaluation_period']?"checked":""}} value="{{$row['detail_no']}}" tabindex="6">
                                    <label class="text-overfollow lh-lable" data-container="body" data-toggle="tooltip"  data-original-title="{{$row['period_nm']}}" for="{{'XX'.$row['detail_no']}}">{{$row['period_nm']}}</label>
                                </div>
                            @endforeach
                        @endif
                    </div>
                </div><!--/.form-group -->
            </div>
        </div>
        <div class="line-border-bottom">
            <label class="control-label">{{__('messages.rated_s_authority_setting')}}</label>
        </div>
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <div class="checkbox">
                        <div class="md-checkbox-v2 inline-block">
                            <input
                                name="evaluation_self_typ"
                                id="evaluation_self_typ"
                                type="checkbox"
                                value="{{isset($dt['evaluation_self_typ']) && $dt['evaluation_self_typ']==1 ? '1':'0'}}"
                                tabindex="8"
                                {{isset($dt['evaluation_self_typ']) && $dt['evaluation_self_typ']==1 ? 'checked':''}}>
                            <label for="evaluation_self_typ">{{__('messages.implement_self_eval')}}</label>
                        </div>
                    </div><!-- end .checkbox -->
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <div class="checkbox">
                        <div class="md-checkbox-v2 inline-block">
                            <input name="details_feedback_typ" id="details_feedback_typ" {{ ($data_single['details_feedback_typ'] ==1)?'checked':''}} type="checkbox" value="{{$data_single['details_feedback_typ']}}" tabindex="8">
                            <label for="details_feedback_typ">{{__('messages.can_view_eval_detail')}}</label>
                        </div>
                    </div><!-- end .checkbox -->
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <div class="checkbox">
                        <div class="md-checkbox-v2 inline-block">
                            <input name="comments_feedback_typ" id="comments_feedback_typ" type="checkbox" {{ ($data_single['comments_feedback_typ'] ==1)?'checked':''}} value="{{$data_single['comments_feedback_typ']}}" tabindex="9">
                            <label for="comments_feedback_typ">{{__('messages.can_view_eval_comment')}}</label>
                        </div>
                    </div><!-- end .checkbox -->
                </div>
            </div>
        </div>
        <div class="line-border-bottom">
            <label class="control-label">{{__('messages.upload_pa_manual')}}</label>
        </div>
        {{-- begin upload file--}}
        <div class="col-md-5 w-item-search line-upload-bottom">
            <div class="form-rows upload m-div">
                <label for="realupload" class="face-file-btn">
                    <i class="fa fa-folder-open fa1"></i>
                </label>
                <div class="fakeupload">
                    <input type="text" id="file_name" name="fakeupload" class="form-control m012-textbox-80" value="{{$data_single['upload_file_nm']}}" readonly="readonly" tabindex="-1">
                    <input type="hidden" id="upload_file_nm" value="{{$data_single['upload_file']}}" tabindex="-1"/>
                    <input type="hidden" id="file_address" value="{{(isset($data_single['file_address']))?$data_single['file_address']:''}}" tabindex="-1"/>
                    <button id="btn-download" class="btn-download" filename="" oldname="" tabindex="-1"><i class="fa fa-download fa2"></i></button>
                    <button id="btn-delete-file" class="btn-clearfile" tabindex="-1">
                        <i class="fa fa-trash fa3"></i>
                    </button>
                    <input type="file" name="upload" class="realupload">
                    <input type="hidden" class="type-file" value="csv">
                    <input class="new-file-name" type="hidden" value="">
                </div>
            </div>
        </div>
        <input type="file" class="inputfile" id="upload_file" maxlength="100" accept="application/pdf" tabindex="-1">
        {{-- end upload file--}}
        <div class="line-border-bottom d-flex justify-content-between">
            <label class="control-label">{{__('messages.sheet_settings')}}</label>
            <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="10"><i class="fa fa-eye"></i> {{__('messages.redisplay')}}</button>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div id="testxx" class="table-responsive w-table1 sticky-table sticky-headers sticky-ltr-cells" style="width: {{ ($data_single['generic_count']*25)."%" }}">
                    <table class="table table-bordered table-hover table-ics table1 marginbottom15 tbl1" id="tbl1">
                        <thead>
                        <tr class="">
                            @php
                                $item = array(
                                    '0'=>'1'
                                    ,'1'=>'2'
                                    ,'2'=>'8'
                                    ,'3'=>'3'
                                    ,'4'=>'4'
                                    ,'5'=>'5'
                                    ,'6'=>'6'
                                    ,'7'=>'7'
                                );
                            @endphp
                            @foreach($item as $key=> $i)
                                <th class="{{$data_single['generic_comment_display_typ_'.$i] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_'.$i] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="num-length ics-textbox">
                                            <input type="text" id="{{'generic_comment_title_'.$i}}" style="min-width:60px" class="form-control form-control-sm" maxlength="20" value="{{$data_single['generic_comment_title_'.$i]}}" readonly="readonly" tabindex="-1">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;"  class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-{{$i}}" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                            @endforeach
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center {{$data_single['generic_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_1'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_1" maxlength="400" tabindex="11">{{$data_single['generic_comment_1']}}</textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_2'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_2" maxlength="400" tabindex="12">{{$data_single['generic_comment_2']}}</textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_8'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_8'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_8" maxlength="400" tabindex="11">{{$data_single['generic_comment_8']}}</textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_3'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_3" maxlength="400" disabled="" tabindex=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_4'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_4" maxlength="400" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_5'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_5'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_5" maxlength="400" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_6'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_6'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_6" maxlength="400" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center {{$data_single['generic_comment_display_typ_7'] =='0'?'ics-hide':''}}" style="display: {{$data_single['generic_comment_display_typ_7'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" id="generic_comment_7" maxlength="400" disabled=""></textarea>
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-md-12">
                <div id="item" class="table-responsive w-table2 sticky-table sticky-headers sticky-ltr-cells w-100">
                    <table id="tbl2" class="table table-bordered table-hover table-ics tabl2 marginbottom15 table-striped">
                        <thead>
                        <tr>
                            <th class="th-total">
                                <button class="btn btn-rm blue btn-sm" id="btn-add-new-row" tabindex="13">
                                    <i class="fa fa-plus"></i>
                                </button>
                            </th>
                            <th class="th-total {{$data_single['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_1'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="num-length ics-textbox">
                                            <input type="text" style="min-width:205px" id="item_title_1" maxlength="20" class="form-control form-control-sm" value="{{$data_single['item_title_1'] }}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="item_display_typ_1" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-6" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="th-total {{$data_single['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_2'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="num-length ics-textbox">
                                            <input type="text" style="min-width:205px" id="item_title_2" maxlength="20" class="form-control form-control-sm" value="{{$data_single['item_title_2'] }}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="item_display_typ_2" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-7" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="th-total {{$data_single['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_3'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="num-length ics-textbox">
                                            <input type="text" style="min-width:205px" id="item_title_3" maxlength="20" class="form-control form-control-sm" value="{{$data_single['item_title_3'] }}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="item_display_typ_3" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-8" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            {{-- ウェイト --}}
                            <th class="th-total {{$data_single['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['weight_display_typ'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:70px" id="weight_display_typ" class="form-control form-control-sm" value="{{$data_single['point_calculation_typ1'] == 1?__('messages.weight'):__('messages.coefficient')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-9" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                            <th
                                id="detail_self_progress_comment_display_typ"
                                number="4"
                                class="th-total {{$dt['detail_self_progress_comment_display_typ']==0?'ics-hide':''}}"
                                style="min-width:205px;{{$dt['detail_self_progress_comment_display_typ']==0?'display:none':''}}
                            ">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox num-length">
                                        <input type="text" id="detail_self_progress_comment_title" class="form-control form-control-sm" value="{{$dt['detail_self_progress_comment_title']}}" readonly="" tabindex="-1" style="min-width:205px;" maxlength="50">
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="detail_self_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-62" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            {{-- 進捗コメント(項目別)非表示ボタン --}}
                            <th
                                id="detail_progress_comment_display_typ"
                                class="th-total {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox num-length">
                                        <input
                                            id="detail_progress_comment_title"
                                            type="text"
                                            style="min-width:205px"
                                            class="form-control form-control-sm"
                                            value="{{$dt['detail_progress_comment_title']}}"
                                            readonly=""
                                            tabindex="-1"
                                            maxlength="50"
                                        />
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="detail_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-64" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            {{-- 評価 --}}
                            <th number="5">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox">
                                        <input type="text" style="min-width:100px;" id="evaluation_display_typ" class="form-control form-control-sm" value="{{__('messages.evaluation')}}" readonly="readonly" tabindex="-1">
                                    </span>
                                </div>
                            </th>
                            <th class="{{$data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_0'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox">
                                        <input class="display_typ" type="hidden" id="detail_comment_display_typ_0" value="1" tabindex="-1"/>
                                        <input type="text" style="min-width:115px"
                                                class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}"
                                                readonly="" tabindex="-1">
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:205px" id="detail_comment_display_typ_1" class="form-control form-control-sm" value="{{__('messages.1st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_2'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:205px" id="detail_comment_display_typ_2" class="form-control form-control-sm" value="{{__('messages.2st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_3'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:205px" id="detail_comment_display_typ_3" class="form-control form-control-sm" value="{{__('messages.3st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_4'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:205px" id="detail_comment_display_typ_4" class="form-control form-control-sm" value="{{__('messages.4st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <input type="hidden" id="mode_import" value=""/>
                        @if(isset($data_tbl2[1][0]['item_no']) !='0')
                            @foreach($data_tbl2[1] as $row)
                            <tr class="tr_generic_comment">
                                <td class="text-center td-0">
                                    <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                                <td class="text-center td-1 {{$data_single['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_1'] =='0'?'none':''}}">
                                    <input type="hidden" class="form-control mode_row" maxlength="3" value="{{$row['item_no'] !=''?'U':'A'}}">
                                    <input type="hidden" class="form-control item_no" maxlength="3" value="{{$row['item_no']}}" tabindex="5">
                                <span class="num-length">
                                    <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_1']}}</textarea>
                                </span>
                                </td>
                                <td class="text-center td-2 {{$data_single['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_2'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_2']}}</textarea>
                                </span>
                                </td>
                                <td class="text-center td-3 {{$data_single['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_3'] =='0'?'none':''}}">
                                <span class="num-length ">
                                    <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_3']}}</textarea>
                                </span>
                                </td>
                                {{-- ウェイト --}}
                                <td class="text-right td-4 {{$data_single['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['weight_display_typ'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <div class="input-group-btn">
                                            <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" value="{{$row['weight']}}" tabindex="13">
                                            <div class="input-group-append-btn icon-percent {{ $data_single['point_calculation_typ1'] == 2?'hidden':''}}">
                                                <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                </td>
                                {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                                <td
                                    class="text-center td-62 {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                    style="display: {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
                                >
                                    <span class="num-length">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                                {{-- 進捗コメント(項目別)非表示ボタン --}}
                                <td
                                    class="text-center td-64 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                    style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"
                                >
                                    <span class="num-length">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                                {{-- 評価 --}}
                                <td class="text-center td-6">
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="2" disabled="disabled">
                                    </span>
                                </td>
                                {{-- 自己評価コメント --}}
                                <td class="text-center td-7 {{$data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
                                    style="display: {{$data_single['detail_comment_display_typ_0'] =='0'?'none':''}}">
                                    <span class="num-length">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                                <td class="text-center td-8 {{$data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                                </td>
                                <td class="text-center td-9 {{$data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_2'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                                </td>
                                <td class="text-center td-10 {{$data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_3'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                                </td>
                                <td class="text-center td-11 {{$data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_4'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                                </td>
                            </tr>
                            @endforeach
                        @else
                        <tr class="tr_generic_comment">
                            <td class="text-center td-0">
                                <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                            <td class="text-center td-1 {{$data_single['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_1'] =='0'?'none':''}}">
                                <input type="hidden" class="form-control mode_row" maxlength="1" value="A">
                                    <input type="hidden" class="form-control item_no" maxlength="3" value="">
                            <span class="num-length">
                                <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                            </td>
                            <td class="text-center td-2 {{$data_single['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_2'] =='0'?'none':''}}">
                            <span class="num-length">
                                <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                            </td>
                            <td class="text-center td-3 {{$data_single['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_3'] =='0'?'none':''}}">
                            <span class="num-length ">
                                <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                            </td>
                            <td class="text-right td-4 {{$data_single['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['weight_display_typ'] =='0'?'none':''}}">
                                <span class="num-length">
                                <div class="input-group-btn">
                                    <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" value="" tabindex="13">
                                    <div class="input-group-append-btn icon-percent {{ $data_single['point_calculation_typ1'] == 2?'hidden':''}}">
                                        <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                                    </div>
                                </div>
                            </span>
                            </td>
                            {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                            <td
                                class="text-center td-62 {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
                            >
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            {{-- 進捗コメント(項目別)非表示ボタン --}}
                            <td
                                class="text-center td-64 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"
                            >
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            {{-- <td class="text-center td-5 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td> --}}
                            <td class="text-center td-6">
                                <span class="num-length ">
                                    <input type="text" class="form-control" maxlength="2" disabled="disabled">
                                </span>
                            </td>
                            <td class="text-center td-7 {{$data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_0'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            <td class="text-center td-8 {{$data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            <td class="text-center td-9 {{$data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_2'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            <td class="text-center td-10 {{$data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_3'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                            <td class="text-center td-11 {{$data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_4'] =='0'?'none':''}}">
                                <span class="num-length">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                        </tr>
                        @endif
                        {{-- Total --}}
                        <tr id="tr-total">
                            <td colspan="{{$data_single['colspan']}}" class="baffbo" id="td-colspan">

                            </td>
                            <th class="ba55 text-left togcol {{$data_single['total_score_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['total_score_display_typ'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox" style="white-space: nowrap" id="text_total_score_display_typ">@if($data_single['point_calculation_typ2'] == 1 ) {{__('messages.total_points')}}  @else {{__('messages.average_score')}} @endif</span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="total_score_display_typ" class="ics ics-eye-total" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <!-- <td class="baffbo baffbo5"></td>
                            <td class="baffbo baffbo6 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"></td> -->
                            <td class="baffbo baffbo8 {{$data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}"></td>
                            <td class="baffbo baffbo9 {{$data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}"></td>
                            <td class="baffbo baffbo10 {{$data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_2'] =='0'?'none':''}}"></td>
                            <td class="baffbo baffbo11 {{$data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_3'] =='0'?'none':''}}"></td>
                            <td class="baffbo baffbo12 {{$data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}"
                                style="display: {{$data_single['detail_comment_display_typ_4'] =='0'?'none':''}}"></td>

                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <table class="hidden" id="table-target">
                <tbody>
                <tr class="tr_generic_comment">
                    <td class="text-center td-0">
                        <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                            <i class="fa fa-remove"></i>
                        </button>
                    </td>
                    <td class="text-center td-1 {{$data_single['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_1'] =='0'?'none':''}}">
                        <input type="hidden" class="form-control mode_row" maxlength="3" value="A" tabindex="13">
                        <input type="hidden" class="form-control item_no" maxlength="15" value="" tabindex="13">
                        <span class="num-length ">
                            <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                        </span>
                    </td>
                    <td class="text-center td-2 {{$data_single['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_2'] =='0'?'none':''}}">
                        <span class="num-length ">
                            <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                        </span>
                    </td>
                    <td class="text-center td-3 {{$data_single['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['item_display_typ_3'] =='0'?'none':''}}">
                        <span class="num-length ">
                            <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                        </span>
                    </td>
                    <td class="text-right td-4 {{$data_single['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['weight_display_typ'] =='0'?'none':''}}">
                        <span class="num-length">
                            <div class="input-group-btn">
                            <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" tabindex="13">
                            <div class="input-group-append-btn icon-percent {{$data_single['point_calculation_typ1'] == 2?'hidden':''}}">
                                <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                            </div>
                        </div>
                        </span>
                    </td>
                    {{-- <td class="text-center td-5 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td> --}}
                    {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                    <td
                        class="text-center td-62 {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                        style="display: {{$data_single['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
                    >
                        <span class="num-length">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    {{-- 進捗コメント(項目別)非表示ボタン --}}
                    <td
                        class="text-center td-64 {{$data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                        style="display: {{$data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"
                    >
                        <span class="num-length">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-6">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-7 {{$data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_0'] =='0'?'none':''}}"">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-8 {{$data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_1'] =='0'?'none':''}}"">
                        <span class="num-length">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-9 {{$data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_2'] =='0'?'none':''}}"">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-10 {{$data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_3'] =='0'?'none':''}}"">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="text-center td-11 {{$data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$data_single['detail_comment_display_typ_4'] =='0'?'none':''}}"">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>
            <!--table3 -->

            <div class="col-md-12">
                <div id="tbl3" class="table-responsive sticky-table sticky-headers sticky-ltr-cells" style="margin-top: 15px;">
                    <div class="w200">
                        <table
                            id="table-comment1"
                            class="table table-bordered table-hover table-ics calc"
                            style="width:  {{($dt['self_progress_comment_display_typ']+$dt['point_criteria_display_typ'])*25}}%"
                        >
                            <thead>
                            <tr>
                                <th
                                    id="self_progress_comment_display_typ"
                                    class="{{$dt['self_progress_comment_display_typ']==0?'ics-hide':''}}"
                                    style="{{$dt['self_progress_comment_display_typ']==0?'display: none;':''}}"
                                >
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox num-length">
                                            <input
                                                type="text"
                                                id="self_progress_comment_title"
                                                style="min-width:115px"
                                                class="form-control form-control-sm"
                                                value="{{$dt['self_progress_comment_title']}}"
                                                readonly=""
                                                tabindex="-1"
                                                maxlength="50"
                                            >
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="self_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th class="{{$data_single['point_criteria_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['point_criteria_display_typ'] =='0'?'none':''}};width: 50% !important">
                                    <div class="d-flex justify-content-between">
                                            <span class="ics-textbox">
                                                <input type="text" style="min-width:115px" id="point_criteria_display_typ" class="form-control form-control-sm" value="{{__('messages.eval_standard_m0160')}}" readonly="readonly" tabindex="-1">
                                            </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-2" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td
                                    class="togcol w-366 {{$data_single['self_progress_comment_display_typ'] =='0'?'ics-hide':''}}""
                                    style="width: 50% !important;{{$dt['self_progress_comment_display_typ']==0?'display: none;':''}}"
                                >
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                                <td class="togcol {{$data_single['point_criteria_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['point_criteria_display_typ'] =='0'?'none':''}}" style="width: 50% !important;">
                                        <span class="num-length ">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled" tabindex="-1">
                                        </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- end .row -->

            <div
                class="col-md-12"
                style="margin-top: -1px;"
            >
                <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells w25 lh-refer" style="width: 25%;">
                    <table class="table table-bordered table-hover table-ics">
                        <thead>
                        <tr>
                            <th
                                id="progress_comment_display_typ"
                                class="{{$dt['progress_comment_display_typ']==0?'ics-hide':''}}"
                                style="{{$dt['progress_comment_display_typ']==0?'display: none;':''}}"
                            >
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox num-length">
                                        <input
                                            type="text"
                                            id="progress_comment_title"
                                            class="form-control form-control-sm"
                                            value="{{$dt['progress_comment_title']}}"
                                            readonly=""
                                            tabindex="-1"
                                            maxlength="50"
                                            style="min-width:115px"
                                        >
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" id="progress_comment_title" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>
                                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="togcol w-366 {{$dt['progress_comment_display_typ']==0?'ics-hide':''}}"
                                style="{{$dt['progress_comment_display_typ']==0?'display: none;':''}}">
                                <span class="num-length ">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div><!-- end .row -->

            <div class="col-md-12" style="margin-top: -1px;">
                <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-table3 w25" style="width: {{ ($data_single['evaluation_count']*($width_table3/2))."%" }};width: 25%;">
                    <table class="table table-bordered table-hover table-ics">
                        <thead>
                        <tr>
                            <th class="{{$data_single['self_assessment_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['self_assessment_comment_display_typ'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox" style="width:100%">
                                            <input type="text" id="self_assessment_comment_display_typ" style="min-width:115px" class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="togcol w-366 {{$data_single['self_assessment_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['self_assessment_comment_display_typ'] =='0'?'none':''}}">
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled" tabindex="-1">
                                    </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div><!-- end .row -->

            <!--table4 -->
            <div class="col-md-12" style="margin-top: -1px;">
                <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w25 lh-refer" style="width:{{$width_table3.'%'}};">
                    <table class="table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr>
                            <th class="{{$data_single['evaluation_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['evaluation_comment_display_typ'] =='0'?'none':''}}">
                                <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text" style="min-width:60px" id="evaluation_comment_display_typ" class="form-control form-control-sm" value="{{__('messages.evaluator_comment')}}" readonly="readonly" tabindex="-1">
                                        </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                        </tr>
                        <tr>
                            <td class="togcol {{$data_single['evaluation_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$data_single['evaluation_comment_display_typ'] =='0'?'none':''}}">
                                <span class="num-length ">
                                    <input type="text" class="form-control" maxlength="15" disabled="disabled" >
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div><!-- end .card-body -->
</div>
<input type="file" class="inputfile" id="import_file" maxlength="100" accept="application/csv">