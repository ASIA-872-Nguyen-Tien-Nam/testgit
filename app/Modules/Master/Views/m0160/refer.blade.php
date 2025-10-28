@foreach($result as $value)
    <div class="row">
        <div class="col-md-5 col-lg-3 col-xl-3 col-xxl-3">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.name')}}</label>
                <span class="num-length">
                    <input type="hidden" id="sheet_cd" value="{{$value['sheet_cd']}}"/>
                    <input type="text" class="form-control required" tabindex="1" id="sheet_nm"
                           maxlength="50" value="{{$value['sheet_nm']}}"/>
                </span>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-4 col-lg-4 col-xl-3 col-xxl-3">
            <div class="form-group">
                <label class="control-label">{{__('messages.abbreviation')}}</label>
                <span class="num-length">
                    <input type="text" class="form-control" tabindex="2" id="sheet_ab_nm" maxlength="10"
                           value="{{$value['sheet_ab_nm']}}"/>
                </span>
            </div>
        </div>
        <div class="col-md-3 col-lg-2 col-xl-2 col-xxl-2 ln-col">
            <div class="form-group">
                <label class="control-label">{{__('messages.sort_order')}}</label>
                <span class="num-length">
                    <input tabindex="3" type="text" id="arrange_order" class="form-control only-number"
                           placeholder="" maxlength="4" value="{{$value['arrange_order']}}">
                </span>
            </div><!--/.form-group -->
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-4">
            <div class="form-group">
                <label class="control-label  lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.eval_standard')}}&nbsp;
                </label>
                <select name="" id="point_kinds" tabindex="4" class="form-control required">
                    <option value="-1"></option>
                    @foreach($m0120 as $item)
                        <option {{$value['point_kinds']==$item['point_kinds']?'selected':''}} value="{{$item['point_kinds']}}">
                            {{$item['point_kinds_nm']}}
                        </option>
                    @endforeach
                </select>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-3">
            <div class="form-group">
                <label class="control-label">{{__('messages.calculate_method')}}&nbsp;
                </label>
                <div class="radio" id="calculation_typ_change1">
                    @foreach($lib2 as $key=>$item)
                        <div class="md-radio-v2 inline-block">
                            <input name="point_calculation_typ1" type="radio" id="YY{{$key}}" {{$value['point_calculation_typ1']==$item['number_cd']?'checked':''}}
                                value="{{$item['number_cd']}}"  maxlength="3" tabindex="5" >
                            <label for="YY{{$key}}">{{$item['name']}}</label>
                        </div>
                    @endforeach
                </div>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-2">
            <div class="form-group">
                <label class="control-label">{{__('messages.compulate_method')}}&nbsp;
                </label>
                <div class="radio" id="calculation_typ_change2">
                    @foreach($lib as $key=>$item)
                        <div class="md-radio-v2 inline-block">
                            <input name="point_calculation_typ2" type="radio" id="ZZ{{$key}}" {{$value['point_calculation_typ2']==$item['number_cd']?'checked':''}}
                                value="{{$item['number_cd']}}"  maxlength="3" tabindex="5" {{($value['point_calculation_typ1'] == 1 && $item['number_cd'] == 2)?'disabled':''}}>
                            <label for="ZZ{{$key}}">{{$item['name']}}</label>
                        </div>
                    @endforeach
                </div>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-2">
            <div class="form-group">
                <label class="control-label">{{__('messages.period_setting')}}&nbsp;
                </label>
                <div class="radio">
                    @foreach($m0101 as $key=>$item)
                        <div class="md-radio-v2 inline-block">
                            <input name="evaluation_period" type="radio" id="XX{{$key}}" {{$value['evaluation_period']==$item['detail_no']?'checked':''}}
                                value="{{$item['detail_no']}}" maxlength="3" tabindex="6">
                            <label class="text-overfollow lh-lable" data-container="body" data-toggle="tooltip"  data-original-title="{{$item['period_nm']}}" for="XX{{$key}}">{{$item['period_nm']}}</label>
                        </div>
                    @endforeach
                </div>
            </div><!--/.form-group -->
        </div>
    </div>

    <div class="line-border-bottom">
        <label class="control-label">{{__('messages.rated_s_authority_setting')}}</label>
    </div>
    <div class="row">
        <div class=" col-lg-4 col-xl-4">
            <div class="form-group">
                <div class="checkbox">
                    <div class="md-checkbox-v2 inline-block" style="margin-right: 15px;">
                        <input
                            name="evaluation_self_typ"
                            id="evaluation_self_typ"
                            type="checkbox"
                            value="{{$value['evaluation_self_typ']}}"
                            tabindex="7"
                            {{$value['evaluation_self_typ']==1?'checked':''}}
                        />
                        <label for="evaluation_self_typ">{{__('messages.implement_self_eval')}}</label>
                    </div>
                </div><!-- end .checkbox -->
            </div>
        </div>
        <div class=" col-lg-4 col-xl-4">
            <div class="form-group">
                <div class="checkbox">
                    <div class="md-checkbox-v2 inline-block" style="margin-right: 15px;">
                        <input name="details_feedback_typ" id="details_feedback_typ" {{$value['details_feedback_typ']==1?'checked':''}} type="checkbox" value="{{$value['details_feedback_typ']}}" tabindex="7">
                        <label for="details_feedback_typ">{{__('messages.can_view_eval_detail')}}</label>
                    </div>
                </div><!-- end .checkbox -->
            </div>
        </div>
        <div class=" col-lg-4 col-xl-4">
            <div class="form-group">
                <div class="checkbox">
                    <div class="md-checkbox-v2 inline-block">
                        <input name="comments_feedback_typ" id="comments_feedback_typ" type="checkbox" {{$value['comments_feedback_typ']==1?'checked':''}} value="{{$value['comments_feedback_typ']}}" tabindex="8">
                        <label for="comments_feedback_typ">{{__('messages.can_view_eval_comment')}}</label>
                    </div>
                </div><!-- end .checkbox -->
            </div>
        </div>
    </div>

    <div class="line-border-bottom">
        <label class="control-label">{{__('messages.upload_pa_manual')}}</label>
    </div>

    <div class="col-md-5 w-item-search line-upload-bottom">
        <div class="form-rows upload m-div">
            <label for="realupload" class="face-file-btn">
                <i class="fa fa-folder-open optionI"></i>
            </label>
            <div class="fakeupload">
                <input type="text" id="file_name" name="fakeupload" class="form-control m012-textbox-80" value="{{$value['upload_file_nm']}}" readonly="readonly">
                <input type="hidden" id="upload_file_nm" value="{{$value['upload_file_nm']}}"/>
                <input type="hidden" id="file_adress" value="{{$value['file_adress']}}"/>
                <button id="btn-download" class="btn-download hidden" filename="" oldname="">
                    <i class="fa fa-download fa-download_m"></i>
                </button>
                <button id="btn-delete-file" class="btn-clearfile hidden">
                    <i class="fa fa-trash fa-trash_m"></i>
                </button>
                <input type="file" name="upload_file" class="realupload" id="upload_file" accept="application/pdf">
                <input type="hidden" class="type-file" value="csv">
                <input class="new-file-name" type="hidden" value="">
                <input id="upload_file_old" type="hidden" value="{{$value['upload_file']}}">
            </div>
        </div>
    </div>

    <div class="line-border-bottom d-flex justify-content-between">
        <label class="control-label">{{__('messages.sheet_settings')}}</label>
        <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm ics-toggle-all" tabindex="9"><i class="fa fa-eye"></i>
            {{__('messages.redisplay')}}
        </button>
    </div>
    <div class="row">
        <div class="col-md-5 col-lg-4 col-xl-3">
            <div class="form-group">
                <label class="control-label">{{__('messages.number_of_targets')}}</label>
                <span class="num-length" id='goal_number_span'>
                    <input type="text" class="form-control only-number" maxlength="3" value="{{$value['goal_number']}}"
                           tabindex="9" id="goal_number"/>
                </span>
            </div>
        </div>
    </div>
    <!--table1 -->
    <div class="row">
        <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-table1" style="width:100%;">
            <table class="table table-bordered table-hover table-ics marginbottom15 tbl1 xxx" id="tbl1">
                <thead>
                <tr>
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
                        <th class="{{$value['generic_comment_display_typ_'.$i] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_'.$i] =='0'?'none':''}}">
                            <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="generic_comment_display_typ_{{$i}}"
                                       value="{{$value['generic_comment_display_typ_'.$i]}}"/>
                                <span class="num-length">
                                    {{-- <input type="text" style="min-width:115px" --}}
                                    <input type="text"
                                            style="min-width: 115px"
                                           class="form-control form-control-sm" value="{{$value['generic_comment_title_'.$i]}}"
                                           id="generic_comment_title_{{$i}}" maxlength="20"
                                           readonly="" tabindex="-1"/>
                                </span>
                            </span>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>
                                    <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </div>
                        </th>
                    @endforeach
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="text-center {{$value['generic_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_1'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_1" maxlength="400" tabindex="11">{{$value['generic_comment_1']}}</textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_2'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_2" maxlength="400" tabindex="11">{{$value['generic_comment_2']}}</textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_8'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_8'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_8" maxlength="400" tabindex="11">{{$value['generic_comment_8']}}</textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_3'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_3" maxlength="400" disabled=""></textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_4'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_4" maxlength="400" disabled=""></textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_5'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_5'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_5" maxlength="400" disabled=""></textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_6'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_6'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_6" maxlength="400" disabled=""></textarea>
                        </span>
                    </td>
                    <td class="text-center {{$value['generic_comment_display_typ_7'] =='0'?'ics-hide':''}}" style="display: {{$value['generic_comment_display_typ_7'] =='0'?'none':''}}">
                        <span class="num-length">
                            <textarea class="form-control" cols="30" rows="4" id="generic_comment_7" maxlength="400" disabled=""></textarea>
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <!--table2 -->
    <div class="row marginbottom15">
        <div class="table-responsive posire">
            <div id ="list_item_table">
                @include('Master::m0160.listRow')
            </div>
        </div>
    </div><!-- end .row -->
    <!--table3 -->
    @php
        $width1 = ((int)$value['self_progress_comment_display_typ'] + (int)$value['challengelevel_criteria_display_typ'] + (int)$value['point_criteria_display_typ'])*25;
    @endphp
    <div class="row container_table3" >
        <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells">
            <div class="w200">
                <table id="table-comment1" class="table table-bordered table-hover table-ics marginbottom15 calc" style="width: {{$width1}}%;">
                    <thead>
                    <tr>
                        <th
                            th_index="1"
                            class="{{$value['self_progress_comment_display_typ'] =='0'?'ics-hide d-none':''}} @if($value['point_criteria_display_typ'] =='0' || $value['challengelevel_criteria_display_typ'] =='0') ln-css @endif  "
                            id="self_progress_comment_display_typ"
                            style="width: 33.33%;"
                        >
                            <div class="d-flex justify-content-between">
                                <span class="ics-textbox num-length">
                                    <input
                                        id="self_progress_comment_title"
                                        type="text"
                                        class="form-control form-control-sm {{$value['self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                                        style="display: {{$value['self_progress_comment_display_typ'] =='0'?'none':''}}"
                                        value="{{$value['self_progress_comment_title']}}"
                                        readonly=""
                                        tabindex="-1"
                                        maxlength="50"
                                    />
                                </span>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>
                                    <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </div>
                        </th>
                        <th
                            id="challengelevel_criteria_display_typ"
                            th_index="1"
                            class="{{$value['challengelevel_criteria_display_typ'] =='0'?'ics-hide':''}} @if($value['self_progress_comment_display_typ'] =='0' && $value['challengelevel_criteria_display_typ'] =='1') ln-css @endif"
                            style="display: {{$value['challengelevel_criteria_display_typ'] =='0'?'none':''}}"
                            style="width: 33.33%;"
                        >
                            <div class="d-flex justify-content-between">
                                <span class="ics-textbox">
                                    <input type="text" style="" class="form-control form-control-sm" value="{{__('messages.difficulty_standard')}}"
                                           readonly="" tabindex="-1">
                                </span>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </div>
                        </th>

                        <th
                            id="point_criteria_display_typ"
                            th_index="2"
                            class="{{$value['point_criteria_display_typ'] =='0'?'ics-hide':''}} @if($value['self_progress_comment_display_typ'] =='0' && $value['challengelevel_criteria_display_typ'] =='0') ln-css @endif"
                            style="display: {{$value['point_criteria_display_typ'] =='0'?'none':''}}"
                        >
                            <div class="d-flex justify-content-between">
                                <span class="ics-textbox">
                                    <input type="text" style="" class="form-control form-control-sm" value="{{__('messages.eval_standard_m0160')}}"
                                           readonly="" tabindex="-1">
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
                        <td class="togcol {{$value['self_progress_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['self_progress_comment_display_typ'] =='0'?'none':''}}">
                            <span class="num-length ">
                                <input
                                    type="text"
                                    class="form-control"
                                    maxlength="15"
                                    disabled="disabled"
                                />
                            </span>
                        </td>
                        <td class="togcol {{$value['challengelevel_criteria_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['challengelevel_criteria_display_typ'] =='0'?'none':''}}">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="togcol {{$value['point_criteria_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['point_criteria_display_typ'] =='0'?'none':''}}">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div><!-- end .row -->
    <!--table4 -->
    <div class="row margintop15">
        <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w25" style="width: 25%">
            <table class="table table-bordered table-hover table-ics w-100">
                <thead>
                <tr>
                    <th
                        id="progress_comment_display_typ"
                        th_index="0"
                        class="w-25 {{$value['progress_comment_display_typ'] =='0'?'ics-hide':''}}"
                        style="display: {{$value['progress_comment_display_typ'] =='0'?'none':''}}"
                    >
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox num-length">
                                <input
                                    id="progress_comment_title"
                                    type="text"
                                    style=""
                                    class="form-control form-control-sm"
                                    value="{{$value['progress_comment_title']}}"
                                    readonly=""
                                    tabindex="-1"
                                    maxlength="50"
                                />
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-edit" tabindex="-1">
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
                     <td class="togcol {{$value['progress_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['progress_comment_display_typ'] =='0'?'none':''}}">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>

            <table class="table table-bordered table-hover table-ics w-100">
                <thead>
                <tr>
                    <th
                        id="self_assessment_comment_display_typ"
                        th_index="0"
                        class="w-25 {{$value['self_assessment_comment_display_typ'] =='0'?'ics-hide':''}}"
                        style="display: {{$value['self_assessment_comment_display_typ'] =='0'?'none':''}}"
                    >
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox" style="width:100%" >
                                <input class="display_typ" type="hidden" id="self_assessment_comment_display_typ"
                                       value="{{$value['self_assessment_comment_display_typ']}}"/>
                                <input type="text" style="" class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}"
                                       readonly="" tabindex="-1">
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
                    <td class="togcol {{$value['self_assessment_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['self_assessment_comment_display_typ'] =='0'?'none':''}}">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>


            <table class="table table-bordered table-hover table-ics marginbottom15 w-100">
                <thead>
                <tr>
                    <th
                        id="evaluation_comment_display_typ"
                        class="w-25 {{$value['evaluation_comment_display_typ'] =='0'?'ics-hide':''}}"
                        style="display: {{$value['evaluation_comment_display_typ'] =='0'?'none':''}}"
                    >
                        <div class="d-flex justify-content-between par">
                            <span class="ics-textbox">
                                <input type="text" style="min-width:150px" class="form-control form-control-sm"
                                       value="{{__('messages.evaluator_comment')}}" readonly="">
                            </span>
                            <div class="ics-group chil">
                                <a href="javascript:;" class="ics ics-eye2" data-target=".td-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="togcol {{$value['evaluation_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$value['evaluation_comment_display_typ'] =='0'?'none':''}}">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
@endforeach