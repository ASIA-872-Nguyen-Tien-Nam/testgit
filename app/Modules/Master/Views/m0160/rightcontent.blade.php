<div class="row">
    <div class="col-md-5 col-lg-3 col-xl-3 col-xxl-3">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.name')}}</label>
            <span class="num-length">
                <input type="hidden" id="sheet_cd" value=""/>
                <input type="text" class="form-control required"  id="sheet_nm" tabindex="1"
                       maxlength="50" value=""/>
            </span>
        </div><!--/.form-group -->
    </div>
    <div class="col-md-4 col-lg-4 col-xl-3 col-xxl-3">
        <div class="form-group">
            <label class="control-label">{{__('messages.abbreviation')}}</label>
            <span class="num-length">
                <input type="text" class="form-control" id="sheet_ab_nm" maxlength="10" tabindex="2"
                       value=""/>
            </span>
        </div>
    </div>
    <div class="col-md-3 col-lg-2 col-xl-2 col-xxl-2 ln-col">
        <div class="form-group">
            <label class="control-label">{{__('messages.sort_order')}}</label>
            <span class="num-length">
                    <input type="text" id="arrange_order" class="form-control only-number" placeholder="" maxlength="4" value="" tabindex="3" />
                </span>
        </div><!--/.form-group -->
    </div>
</div>

<div class="row">
    <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-4">
        <div class="form-group">
            <label class="control-label  lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.eval_standard')}}&nbsp;
            </label>
            <select name="" id="point_kinds"  class="form-control required" tabindex="4">
                <option value="-1"></option>
                @foreach($m0120 as $item)
                    <option value="{{$item['point_kinds']}}">{{$item['point_kinds_nm']}}</option>
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
                        <input name="point_calculation_typ1" type="radio" id="YY{{$key}}" value="{{$item['number_cd']}}"  maxlength="3" tabindex="5">
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
                        <input name="point_calculation_typ2" type="radio" id="ZZ{{$key}}" value="{{$item['number_cd']}}"  maxlength="3" tabindex="5" {{$key == 1?'disabled':''}}>
                        <label for="ZZ{{$key}}">{{$item['name']}}</label>
                    </div>
                @endforeach
            </div>
        </div><!--/.form-group -->
    </div>
    <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-4">
        <div class="form-group">
            <label class="control-label">{{__('messages.period_setting')}}&nbsp;
            </label>
            <div class="radio">
                @foreach($m0101 as $key=>$item)
                    <div class="md-radio-v2 inline-block">
                        <input name="evaluation_period" type="radio" id="XX{{$key}}" value="{{$item['detail_no']}}" maxlength="3" tabindex="6" >
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
                <div class="md-checkbox-v2 inline-block">
                    <input name="evaluation_self_typ" id="evaluation_self_typ" type="checkbox" tabindex="7"
                            value="{{$target_self_assessment_typ}}"
                            {{$target_self_assessment_typ==1?'checked':''}}>
                    <label for="evaluation_self_typ">{{__('messages.implement_self_eval')}}</label>
                </div>
            </div><!-- end .checkbox -->
        </div>
    </div>
    <div class=" col-lg-4 col-xl-4">
        <div class="form-group">
            <div class="checkbox">
                <div class="md-checkbox-v2 inline-block">
                    <input name="details_feedback_typ" id="details_feedback_typ" type="checkbox" value="0" tabindex="7">
                    <label for="details_feedback_typ">{{__('messages.can_view_eval_detail')}}</label>
                </div>
            </div><!-- end .checkbox -->
        </div>
    </div>
    <div class=" col-lg-4  col-xl-4">
        <div class="form-group">
            <div class="checkbox">
                <div class="md-checkbox-v2 inline-block">
                    <input name="comments_feedback_typ" id="comments_feedback_typ" type="checkbox" value="0" tabindex="8">
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
            <input type="text" id="file_name" name="fakeupload" class="form-control m012-textbox-80" readonly="readonly" value="">
            <input type="hidden" id="upload_file_nm" value=""/>
            <button id="btn-download" class="btn-download hidden" filename="" oldname="">
                <i class="fa fa-download fa-download_m"></i>
            </button>
            <button id="btn-delete-file" class="btn-clearfile hidden">
                <i class="fa fa-trash fa-trash_m"></i>
            </button>
            <input type="file" name="upload_file" class="realupload" value="" id="upload_file" accept="application/pdf">
            <input type="hidden" class="type-file" value="csv">
            <input class="new-file-name" type="hidden" value="">
            <input id="upload_file_old" type="hidden" value="">
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
    <div class="col-md-5 col-lg-4 col-xl-3 ln-min">
        <div class="form-group">
            <label class="control-label">  {{__('messages.number_of_targets')}}</label>
            <span class="num-length" id='goal_number_span'>
                <input type="text" class="form-control only-number" maxlength="3" value="" tabindex="9" id="goal_number"/>
            </span>
        </div>
    </div>
</div>
<!--table1 -->
<div class="row">
    <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-table1" style="width:100%;">
        <table class="table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1">
            <thead>
            <tr>
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_1" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '①'])}}"
                                       id="generic_comment_title_1" maxlength="20"
                                       readonly="" tabindex="-1" />
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_2" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '②'])}}"
                                       id="generic_comment_title_2" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_8" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '③'])}}" 
                                       id="generic_comment_title_8" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_3" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:120px"
                                       class="form-control form-control-sm" value="{{__('messages.gp_evaluator_comment',['num' => '①'])}}"
                                       id="generic_comment_title_3" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_4" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:120px"
                                       class="form-control form-control-sm" value="{{__('messages.gp_evaluator_comment',['num' => '②'])}}"
                                       id="generic_comment_title_4" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_5" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '①'])}}"
                                       id="generic_comment_title_5" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_6" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '②'])}}"
                                       id="generic_comment_title_6" maxlength="20"
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
                <th>
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_7" value="1"/>
                            <span class="num-length">
                                <input type="text" style="min-width:165px"
                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '③'])}}"
                                       id="generic_comment_title_7" maxlength="20"
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
            </tr>
            </thead>
            <tbody>
            <tr>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="11"></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_2" tabindex="12"></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_8" tabindex="12"></textarea>
                    </span>
                </td>
                <td class="text-center ">
                    <span class="num-length ">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_3" disabled=""></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_4" disabled=""></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_5" disabled=""></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_6" disabled=""></textarea>
                    </span>
                </td>
                <td class="text-center">
                    <span class="num-length">
                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_7" disabled=""></textarea>
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
            <table id="list-item" class="table table-bordered table-striped tbme table-ics tabl2 yyy"
                   data-resizable-columns-id="demo-table-v2">
                <thead>
                <tr >
                    <th id="item_title_display_typ">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}"
                                           readonly="" id="item_title_title" maxlength="20" tabindex="-1"/>
                                </span>
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                    <span class="ics-inner"><i class="fa fa-pencil" ></i></span>
                                </a>
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th id="item_display_typ_1">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}１"
                                           readonly="" id="item_title_1" maxlength="20" tabindex="-1"/>
                                </span>
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                    <span class="ics-inner"><i class="fa fa-pencil" ></i></span>
                                </a>
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th id="item_display_typ_2">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}２"
                                           readonly="" id="item_title_2" maxlength="20" tabindex="-1"/>
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
                    <th id="item_display_typ_3">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}３"
                                           readonly="" id="item_title_3" maxlength="20 " tabindex="-1"/>
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
                    <th id="item_display_typ_4">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}４"
                                           readonly="" id="item_title_4" maxlength="20" tabindex="-1"/>
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
                    <th id="item_display_typ_5">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" value="1"/>
                                <span class="num-length">
                                    <input type="text" style="min-width:115px"
                                           class="form-control form-control-sm" value="{{__('messages.target_title')}}５"
                                           readonly="" id="item_title_5" maxlength="20" tabindex="-1"/>
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
                    {{-- datnt  thay đổi tên theo 計算方法 (radio button trên màn hình)--}}
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="weight_display_typ" value="1"/>
                                <input type="text" style="min-width:115px"
                                       class="form-control form-control-sm" id="weight_display_typ_value" value="{{__('messages.weight')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th>
                        <input type="hidden" id="check_challenge_level" value="{{$check}}"/>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="challenge_level_display_typ" value="1"/>
                                <input type="text" style="min-width:115px"
                                       class="form-control form-control-sm" value="{{__('messages.level')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th class="td-64" id="detail_self_progress_comment_display_typ">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox num-length">
                                <input
                                    id="detail_self_progress_comment_title"
                                    type="text"
                                    style="min-width:205px"
                                    class="form-control form-control-sm"
                                    value="{{__('messages.self_progress_comment1')}}"
                                    readonly=""
                                    tabindex="-1"
                                    maxlength="50"
                                />
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
                    <th class="td-66" id="detail_progress_comment_display_typ">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox num-length">
                                <input
                                    id="detail_progress_comment_title"
                                    type="text"
                                    style="min-width:205px"
                                    class="form-control form-control-sm"
                                    value="{{__('messages.evaluator_progress_comments1')}}"
                                    readonly=""
                                    tabindex="-1"
                                    maxlength="50"
                                />
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
                    <th class="evaluate_col">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="evaluation_display_typ" value="1"/>
                                <input type="text" style="min-width:115px"
                                       class="form-control form-control-sm" value="{{__('messages.evaluation')}}"
                                       readonly="" tabindex="-1">
                            </span>
                        </div>
                    </th>
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="detail_comment_display_typ_0" value="1"/>
                                <input type="text" style="min-width:135px"
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
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="detail_comment_display_typ_1" value="1"/>
                                <input type="text" style="min-width:145px"
                                       class="form-control form-control-sm" value="{{__('messages.1st_rater_s_comment')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="detail_comment_display_typ_2" value="1"/>
                                <input type="text" style="min-width:145px"
                                       class="form-control form-control-sm" value="{{__('messages.2st_rater_s_comment')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="detail_comment_display_typ_3" value="1"/>
                                <input type="text" style="min-width:145px"
                                       class="form-control form-control-sm" value="{{__('messages.3st_rater_s_comment')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    <th>
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox">
                                <input class="display_typ" type="hidden" id="detail_comment_display_typ_4" value="1"/>
                                <input type="text" style="min-width:145px"
                                       class="form-control form-control-sm" value="{{__('messages.4st_rater_s_comment')}}"
                                       readonly="" tabindex="-1">
                            </span>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                </tr>
                </thead>

                <tbody id ="list_item_detail">
                @for($i=1;$i< 4;$i++)
                    <tr class="tr_generic_comment">
                        {{-- 目標タイトル --}}
                        <td class="text-center td">
                            <span class="num-length ">
                                <input type="text" class="form-control item_title" maxlength="400" value="">
                            </span>
                        </td>
                        {{-- 目標タイトル1 --}}
                        <td class="text-center td-1">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 目標タイトル2 --}}
                        <td class="text-center td-2">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 目標タイトル3 --}}
                        <td class="text-center td-3">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 目標タイトル4 --}}
                        <td class="text-center td-4">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 目標タイトル5 --}}
                        <td class="text-center td-5">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- ウェイト --}}
                        <td class="text-center td-6">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 難易度 --}}
                        <td class="text-center td-7">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15"
                                       disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-64">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15"
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 進捗コメント --}}
                        <td class="text-center td-8 td-66">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 評価 --}}
                        <td class="text-center td-9">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 自己評価コメント --}}
                        <td class="text-center td-10">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 一次評価者コメント --}}
                        <td class="text-center td-11">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 二次評価者コメント --}}
                        <td class="text-center td-12">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 三次評価者コメント --}}
                        <td class="text-center td-13">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                        {{-- 四次評価者コメント --}}
                        <td class="text-center td-14">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" value=""
                                       disabled="disabled">
                            </span>
                        </td>
                    </tr>
                @endfor
                <tr id="tr-total">
                    <td colspan="10" class="baffbo" id="td-colspan"></td>
                    <th class="ba55 text-left togcol">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox" id="text_total_score_display_typ" style="white-space: nowrap">{{__('messages.total_points')}}</span>
                            <input class="display_typ" type="hidden" id="total_score_display_typ" value="1"/>
                            <div class="ics-group">
                                <a href="javascript:;" class="ics ics-eye-total" data-target=".td-1" tabindex="-1">
                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                </a>
                            </div><!-- end .ics-group -->
                        </div>
                    </th>
                    {{-- <td class="baffbo baffbo9"></td> --}}
                    <td class="baffbo baffbo11"></td>
                    <td class="baffbo baffbo12"></td>
                    <td class="baffbo baffbo13"></td>
                    <td class="baffbo baffbo14"></td>
                    <td class="baffbo baffbo15"></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div><!-- end .row -->
<!--table3 -->
<div class="row container_table3">
    <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-100">
        <div class="w200">
            <table
                id="table-comment1"
                class="table table-bordered table-hover table-ics marginbottom15 calc"
            >
                <thead>
                <tr>
                    <th th_index="1" class="" id="self_progress_comment_display_typ" width="33.33%">
                        <div class="d-flex justify-content-between">
                            <span class="ics-textbox num-length">
                                <input
                                    id="self_progress_comment_title"
                                    type="text"
                                    class="form-control form-control-sm"
                                    value="{{__('messages.self_progres_comment')}}"
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
                        th_index="0"
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
                        th_index="1"
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
                    <td class="togcol">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="togcol">
                        <span class="num-length ">
                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                        </span>
                    </td>
                    <td class="togcol">
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
                <th th_index="1" class="" id="progress_comment_display_typ">
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox num-length">
                            <input
                                id="progress_comment_title"
                                type="text"
                                class="form-control form-control-sm"
                                value="{{__('messages.eval_progress_comment')}}"
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
                <td class="togcol">
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
                >
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox" style="width: 100%">
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
                <td class="togcol">
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
                    th_index="1"
                >
                    <div class="d-flex justify-content-between ">
                        <span class="ics-textbox">
                            <input type="text"  class="form-control form-control-sm"
                                   value="{{__('messages.evaluator_comment')}}" readonly="" tabindex="-1">
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
                <td class="togcol">
                    <span class="num-length ">
                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                    </span>
                </td>

            </tr>
            </tbody>
        </table>
    </div>
</div>
