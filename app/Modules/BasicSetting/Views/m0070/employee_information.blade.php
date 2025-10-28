{{-- tab 2 --}}
@php
$check_lang = \Session::get('website_language', config('app.locale'));
@endphp

<div class="tab-pane fade {{isset ($disabled) && $disabled == '' ? '' : 'active show'}}" id="tab2">
    <div class="row">
        <div class="col-md-6 col-lg-4 col-xl-3 ee">
            <div class="form-group">
                <label class="control-label">{{ __('messages.email') }}
                </label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input {{$disabled}}  type="text" class="form-control mail" id="mail" maxlength="50"
                            tabindex="1" value="{{$table1['mail']??''}}" tabindex="10">
                        <input {{$disabled}}  type="text" maxlength="50" id="language_pass"
                            value="{{$table1['language']??''}}" hidden>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled="">@</button>
                        </div>
                    </div>
                </span>
            </div>
        </div>
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.company_mobile_number') }}</label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input type="text" {{$disabled}}  tabindex="1" class="form-control  tel-haifun" id="tel" maxlength="20"
                            tabindex="7" value="{{$table1['tel']??''}}">
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled=""><i
                                    class="fa fa-phone"></i></button>
                        </div>
                    </div>
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.extension_number') }}</label>
                <span class="num-length">
                    <div class="input-group-btn">
                        <input type="text" {{$disabled}}  tabindex="1" class="form-control tel_extends tel" id="tel_extends" maxlength="20"
                            tabindex="7" value="{{$table1['tel_extends']??''}}">
                    </div>
                </span>
            </div>
            <!--/.form-group -->
        </div>


    </div><!-- end .row -->
    <div class="row">
        <div class="" @if (isset($disabled) && $disabled=='' ) style="padding-left:10px; padding-right:10px" @endif>
            <div class="col-md2" style="margin-right: 0px">
                <div class="form-group">
                    @if (isset($disabled) && $disabled == '')
                    <label class="control-label {{$check_lang=='en'?'lable-chek':''}}">&nbsp</label>
                    <div class="full-width">
                        <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="btn-retired"
                            tabindex="14">
                            {{ __('messages.retire_process') }}
                        </a>
                    </div><!-- end .full-width -->
                    @endif
                </div>
            </div>
        </div><!-- end .col-md-4 -->
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group" >
                <label data-toggle="tooltip" data-original-title="{{ __('messages.retire_date') }}"
                    class="retire_date_label text-overfollow control-label">{{ __('messages.retire_date') }}&nbsp;
                </label>
                <div data-toggle="tooltip" data-original-title="{{$table1['company_out_dt']??''}}">
                    <input {{$disabled}}  type="text" class="form-control input-sm date right-radius" tabindex="1" id="company_out_dt" 
                        value="{{$table1['company_out_dt']??''}}" disabled="" style="text-align: center;">
                </div>

            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-7 col-xs-12 col-lg-3">
            <label
                class="control-label ">{{ __('messages.retire_s_reason') }}&nbsp;
            </label>
            <div data-toggle="tooltip" data-original-title="{{$table1['retirement_reason']??''}}">
                
                <input {{$disabled}}  type="text" class="form-control " tabindex="1" id="retirement_reason"
                    value="{{$table1['retirement_reason']??''}}" disabled="" style="text-align: left;">
            </div>

        </div>
        <!--/.form-group -->
    </div>
    <div class=" line-border-bottom" style="margin-top:12px">
        <label class="control-label">{{ __('messages.affiliation_info') }}</label>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-lg-3" style="max-width:180px">
            <div class="form-group">
                <label class="control-label lb-required {{$check_lang=='en'?'lable-check':''}}"
                    lb-required="{{ __('messages.required') }}">{{ __('messages.application_date') }}
                </label>
                <div class="input-group-btn input-group" style="">
                    <input {{$disabled}}  type="text" class="form-control input-sm date right-radius required"
                        id="application_date" tabindex="1" placeholder="yyyy/mm/dd"
                        value="{{$table4['application_date']??''}}" />
                    <input type="text" class="form-control change_data_emp" hidden
                        id="change_data_emp" 
                        value="0" />
                    <div class="input-group-append-btn">
                        @if (isset($disabled) && $disabled == '')
                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i" tabindex="-1"
                            style="background: none!important"><i class="fa fa-calendar"></i></button>
                        @endif
                    </div>
                </div>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.grade') }}&nbsp;
                </label>
                <select {{$disabled}}  name="" id="grade" class="form-control" tabindex="1">
                    <option value="0"></option>
                    @if (isset($combo_grade[0]) && !empty($combo_grade[0]))
                    @foreach($combo_grade as $dt)
                    @if(isset($dt['grade']))
                    <option value="{{$dt['grade']??'0'}}" {{($table4['grade']??0)==$dt['grade']?'selected':''}}>
                        {{$dt['grade_nm']??''}}</option>
                    @endif
                    @endforeach
                    @endif

                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.years_of_stay_grade') }}
                </label>
                <div data-toggle="tooltip" data-original-title="">
                    <input {{$disabled}}  type="text" class="form-control " id="" value="{{$year_grade['year_grade']??''}}" tabindex="1" disabled=""
                        style="text-align: left;">
                </div>

            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label style="min-width: 120px;"
                    class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.salary') }}
                </label>
                <span class="num-length">
                <input {{$disabled}}  id="salary_grade" value="{{($table1['salary_grade']??'')}}" type="text"
                    class="form-control only-number text-right" maxlength="3" tabindex="1">
                                        </span>                             
            </div>
            <!--/.form-group -->

        </div>
    </div>
    <div class="row list_organization row_data_02">
        @if(isset($organization_group[0]) && !empty($organization_group[0]))
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
            <input type="text" id="" class="form-control detail_no_data_row" tabindex="3" hidden
                                    maxlength="4" value="-1" />
                <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}
                        data-container=" body" data-toggle="tooltip"
                    data-original-title="{{$organization_group[0]['organization_group_nm']}}"
                    style="max-width: 150px;    display: block">
                    {{$organization_group[0]['organization_group_nm']}}
                </label>
                <select {{$disabled}}  name=""  class="form-control organization_cd1 belong_cd1" tabindex="1"
                    organization_typ='1'>
                    <option value="-1"></option>
                    @foreach($combo_organization as $row)
                    @if(isset($row['organization_cd_1']))
                    <option value="{{$row['organization_cd_1']??''}}"
                        {{($table4['belong_cd1']??'')==$row['organization_cd_1']?'selected':''}}>
                        {{$row['organization_nm']}}</option>
                    @endif
                    @endforeach
                   
                </select>
            </div>
            <!--/.form-group -->
        </div>
        @endif
        @php
        if($count_organization_cd < count($organization_group)){ $count_organization_cd=count($organization_group); }
            @endphp @foreach($organization_group as $dt) @if($dt['organization_typ']>=2)
            <div class="col-md-4 col-xl-2 col-lg-3">
                <div class="form-group">
                    <label
                        class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}"
                        data-container="body" data-toggle="tooltip"
                        data-original-title="{{$dt['organization_group_nm']}}"
                        style="max-width: 150px;    display: block">
                        {{$dt['organization_group_nm']}}
                    </label>
                    <select {{$disabled}}  name="" id="{{'organization_step'.$dt['organization_typ'].'_pre'}}"
                        class="form-control {{'belong_cd'.$dt['organization_typ']}} {{'organization_cd'.$dt['organization_typ']}}" tabindex="1"
                        organization_typ="{{$dt['organization_typ']}}">
                        <option value="-1"></option>
                        @if($organization_group_total[$dt['organization_typ']] != null &&
                        count($organization_group_total[$dt['organization_typ']]) > 0)
                        @foreach($organization_group_total[$dt['organization_typ']] as $row)
                        @if($row['step'] == $dt['organization_typ'] && $row['detail_no'] == '0' )
                        <option
                            value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}"
                            {{($table4['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']]?'selected':''}}>
                            {{$row['organization_nm']??''}}
                        </option>
                        @endif
                        @endforeach
                        {{-- @foreach($organization_group_total['2']) as $row)
											<option value="0"></option>

											<option value="{{$row['organization_cd']}}"
                        {{($table4['belong_cd'.$dt['organization_typ']]??0)==$row['organization_cd']&&$row['step'] == '1'&&$row['detail_no'] == '0'?'selected':''}}>{{$row['organization_nm']??''}}
                        </option>
                        @endforeach --}}
                        @endif
                    </select>
                </div>
                <!--/.form-group -->
            </div>
            @endif
            @endforeach
            @if(count($organization_group) > 0)
            <div class="col-md-4 col-xl-2 col-lg-3">
                <div class="form-group">
                    <label
                        class="control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}"
                        style="width:100%">{{ __('messages.years_of_stay_affiliation') }}
                    </label>
                    <div data-toggle="tooltip" data-original-title="{{$year_depart['year_depart']??'' }}">
                        <input {{$disabled}}  type="text" class="form-control " id="year_depart" tabindex="1"
                            value="{{$year_depart['year_depart']??'' }}" disabled="">
                    </div>

                </div>
                <!--/.form-group -->
            </div>
            @endif


    </div> <!-- end .row -->

    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.position') }}
                </label>
                <select {{$disabled}}  name="" id="position_cd" class="form-control position_cd" tabindex="1">
                    <option value="-1"></option>
                    @if(isset($combo_position_cd[0]) && !empty($combo_position_cd[0]))
                    @foreach($combo_position_cd as $dt)
                    @if(isset($dt['position_cd']))
                    <option value="{{$dt['position_cd']??''}}"
                        {{($table4['position_cd']??0)==$dt['position_cd']?'selected':''}}>{{$dt['position_nm']??''}}
                    </option>
                    @endif
                    @endforeach
                    @endif

                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.job') }}&nbsp;
                </label>
                <select {{$disabled}}  name="" id="job_cd" class="form-control " tabindex="1">
                    <option value="0"></option>
                    @if (isset($combo_job_cd[0]) && !empty($combo_job_cd[0]))
                    @foreach($combo_job_cd as $dt)
                    @if(isset($dt['job_cd']))
                    <option value="{{$dt['job_cd']}}" {{($table4['job_cd']??0)==$dt['job_cd']?'selected':''}}>
                        {{$dt['job_nm']}}</option>
                    @endif
                    @endforeach
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.office') }}&nbsp;
                </label>
                <select {{$disabled}}  name="" id="office_cd" class="form-control " tabindex="1">
                    <option value="0"></option>
                    @if (isset($combo_office_cd[0]) && !empty($combo_office_cd[0]))
                    @foreach($combo_office_cd as $dt)
                    <option value="{{$dt['office_cd']}}" {{($table4['office_cd']??0)==$dt['office_cd']?'selected':''}}>
                        {{$dt['office_nm']}}</option>
                    @endforeach
                    @endif
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lable-check':''}} {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.employee_classification') }}&nbsp;
                </label>
                <select {{$disabled}}  name="" id="employee_typ" class="form-control " tabindex="1">
                    <option value="0"></option>
                    @if(isset($combo_employee_typ[0]) && !empty($combo_employee_typ[0]))
                    @foreach($combo_employee_typ as $dt)
                    <option value="{{$dt['employee_typ']}}"
                        {{($table4['employee_typ']??0)==$dt['employee_typ']?'selected':''}}>
                        {{$dt['employee_typ_nm']}}</option>
                    @endforeach
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
    </div>
  
    
    @if(isset($list_org[0]) && !empty($list_org[0]))
    @foreach($list_org as $key => $org)
    
    <div class="row_data_02  list list_organization">
    <div class=" line-border-bottom" style="border-left:0px !important">
    </div>
        <div class="row data_row_02">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 ">
                <div class="row ">

                    <div class="col-xl-5 col-lg-5 col-sm-12">
                    @if ($key==0)
                        <div class="form-group button_add_02_div">
                            <label data-container="body" data-toggle="tooltip" data-original-title=""
                                class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                style="width:100%;margin-bottom: 0px;">{{ __('messages.current_post_info') }}
                            </label>
                            <div class="full-width">
                                @if (isset($disabled) && $disabled == '')
                                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue"
                                    id="add_data_row_02" data-toggle="tooltip" title="" tabindex="1">
                                    +
                                </a>
                                @endif
                            </div><!-- end .full-width -->

                        </div>
                    @else
                    <div class="form-group button_add_02_div" hidden>
                            <label data-container="body" data-toggle="tooltip" data-original-title=""
                                class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                style="width:100%;margin-bottom: 0px;">{{ __('messages.current_post_info') }}
                            </label>
                            <div class="full-width">
                                @if (isset($disabled) && $disabled == '')
                                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue"
                                    id="add_data_row_02" data-toggle="tooltip" title="" tabindex="1">
                                    +
                                </a>
                                @endif
                            </div><!-- end .full-width -->

                        </div>
                    @endif
                    </div>
                    <div class="col-xl-7 col-lg-7 col-sm-12 block_sort">
                        <div class="form-group">
                            <label
                                class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.sort_order') }}</label>
                            <span class="num-length">
                                @if(isset($org['arrange_order']))
                                <input {{$disabled}}  type="text" id="" class="form-control arrange_order only-number" tabindex="3"
                                    maxlength="4" value="{{$org['arrange_order']}}" />
                                @else
                                <input {{$disabled}}  type="text" id="" class="form-control arrange_order only-number" tabindex="3"
                                    maxlength="4" value="" />
                                @endif
                                <input type="text" id="" class="form-control detail_no_data_row" tabindex="3" hidden
                                    maxlength="4" value="{{$org['detail_no']}}" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8 col-xl-10 col-xs-12 col-lg-9 block_data_tab_02">
                <div class="row row_data_tab_2_inside">
                    <div class="col-md-11 col-xl-12 col-xs-12 col-lg-12">
                        <div class="row">

                            @if(isset($organization_group[0]) && !empty($organization_group[0]))
                            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                <div class="form-group">
                                    <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$organization_group[0]['organization_group_nm']}}"
                                        style="max-width: 150px;    display: block">
                                        {{$organization_group[0]['organization_group_nm']}}
                                    </label>
                                    <select {{$disabled}}  name="" 
                                        class="form-control organization_cd1 belong_cd1" tabindex="1" organization_typ='1'>
                                        <option value="-1"></option>
                                        @foreach($combo_organization as $row)
                                        <option value="{{$row['organization_cd_1']??''}}"
                                            {{($org['belong_cd1']??'')==$row['organization_cd_1']?'selected':''}}>
                                            {{$row['organization_nm']??''}}</option>
                                        @endforeach
                                    </select>
                                </div>


                                <!--/.form-group -->
                            </div>
                            @endif
                            @php

                            if($count_organization_cd < count($organization_group)){
                                $count_organization_cd=count($organization_group); } @endphp
                                @foreach($organization_group as $dt) @if($dt['organization_typ']>=2)
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                      
                                        <label
                                            class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$dt['organization_group_nm']}}"
                                            style="max-width: 150px;    display: block">
                                            {{$dt['organization_group_nm']}}
                                        </label>
                                        <select {{$disabled}}  name=""
                                            id="{{'organization_step'.$dt['organization_typ']}}"
                                            class="form-control  {{'belong_cd'.$dt['organization_typ']}} {{'organization_cd'.$dt['organization_typ']}}"
                                            tabindex="1" organization_typ="{{$dt['organization_typ']}}">
                                            <option value="-1"></option>
                                            @if($organization_group_total[$dt['organization_typ']] != null &&
                                            count($organization_group_total[$dt['organization_typ']]) > 0)
                                            @foreach($organization_group_total[$dt['organization_typ']] as $row)
                                            @if($row['step']==$dt['organization_typ']&&$row['detail_no']==$org['detail_no'])
                                            <option
                                                value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}"
                                                {{($org['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']]?'selected':''}}>
                                                {{$row['organization_nm']??''}}
                                            </option>
                                            @endif
                                            @endforeach
                                            {{-- @foreach($organization_group_total['2']) as $row)
											<option value="0"></option>

											<option value="{{$row['organization_cd']}}"
                                            {{($org['belong_cd'.$dt['organization_typ']]??0)==$row['organization_cd']?'selected':''}}>{{$row['organization_nm']??''}}
                                            </option>
                                            @endforeach --}}
                                            @endif
                                        </select>
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                @endif
                                @endforeach
                                </div>
                            <div class="row">                    
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                        <label
                                            class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.position') }}&nbsp;
                                        </label>
                                        <select name="" class="form-control position_cd" tabindex="1"
                                            {{$disabled}} >
                                            <option value="-1"></option>
                                            @if(isset($combo_position_cd[0]) && !empty($combo_position_cd[0]))
                                            @foreach($combo_position_cd as $dt)
                                            <option value="{{$dt['position_cd']??''}}"
                                                {{($org['position_cd']??0)==$dt['position_cd']?'selected':''}}>
                                                {{$dt['position_nm']??''}}
                                            </option>
                                            @endforeach
                                            @endif
                                        </select>
                                    </div>
                                </div>
                                @if (isset($disabled) && $disabled == '')
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                        <label
                                            class="control-label {{$check_lang=='en'?'lable-check':''}}">&nbsp</label>
                                        <span class="num-length btn_remove_left" style="margin-top:4px">
                                            <span tabindex="1" style="border:none" class="btn-remove btn-remove_02">
                                                <i class="fa fa-remove"></i>
                                            </span>
                                        </span>
                                    </div>
                                </div>
                                @endif
                        </div>
                    </div>

                </div>
            </div>

        </div>
        </div>
    @endforeach
    @else
    
    <div class="row_data_02  list list_organization">
    <div class=" line-border-bottom" style="border-left:0px !important">
    </div>
        <div class="row data_row_02">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 ">
                <div class="row ">


                    <div class="col-xl-5 col-lg-5 col-sm-12">
                        <div class="form-group button_add_02_div">
                            <label data-container="body" data-toggle="tooltip" data-original-title=""
                                class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                style="width:100%;margin-bottom: 0px;">{{ __('messages.current_post_info') }}
                            </label>
                            <div class="full-width">
                                @if (isset($disabled) && $disabled == '')
                                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue"
                                    id="add_data_row_02" data-toggle="tooltip" title="" tabindex="1">
                                    +
                                </a>
                                @endif
                            </div><!-- end .full-width -->

                        </div>
                    </div>
                    <div class="col-xl-7 col-lg-7 col-sm-12 block_sort">
                        <div class="form-group">
                            <label
                                class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.sort_order') }}</label>
                            <span class="num-length">
                                <input {{$disabled}}  type="text" id="" class="form-control arrange_order only-number" tabindex="3"
                                    maxlength="4" value="" />
                                    <input type="text" id="" class="form-control detail_no_data_row" tabindex="3" hidden
                                    maxlength="4" value="0" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8 col-xl-10 col-xs-12 col-lg-9 block_data_tab_02">
                <div class="row row_data_tab_2_inside">
                    <div class="col-md-11 col-xl-12 col-xs-12 col-lg-12">
                        <div class="row">

                            @if(isset($organization_group[0]) && !empty($organization_group[0]))
                            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                <div class="form-group">
                                    <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$organization_group[0]['organization_group_nm']}}"
                                        style="max-width: 150px;    display: block">
                                        {{$organization_group[0]['organization_group_nm']}}
                                    </label>
                                    <select {{$disabled}}  name="" 
                                        class="form-control organization_cd1 belong_cd1" tabindex="1" organization_typ='1'>
                                        <option value="-1"></option>
                                        @foreach($combo_organization as $row)
                                        <option value="{{$row['organization_cd_1']??''}}"
                                            >
                                            {{$row['organization_nm']??''}}</option>
                                        @endforeach
                                    </select>
                                </div>


                                <!--/.form-group -->
                            </div>
                            @endif
                            @php

                            if($count_organization_cd < count($organization_group)){
                                $count_organization_cd=count($organization_group); } @endphp
                                @foreach($organization_group as $dt) @if($dt['organization_typ']>=2)
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                        <label
                                            class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$dt['organization_group_nm']}}"
                                            style="max-width: 150px;    display: block">
                                            {{$dt['organization_group_nm']}}
                                        </label>
                                        <select {{$disabled}}  name=""
                                            id="{{'organization_step'.$dt['organization_typ']}}"
                                            class="form-control  {{'belong_cd'.$dt['organization_typ']}} {{'organization_cd'.$dt['organization_typ']}}"
                                            tabindex="1" organization_typ="{{$dt['organization_typ']}}">
                                            <option value="-1"></option>
                                            @if($organization_group_total[$dt['organization_typ']] != null &&
                                            count($organization_group_total[$dt['organization_typ']]) > 0)
                                            @foreach($organization_group_total[$dt['organization_typ']] as $row)
                                            <option
                                                value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}"
                                                >
                                                {{$row['organization_nm']??''}}
                                            </option>
                                            @endforeach
                                            {{-- @foreach($organization_group_total['2']) as $row)
											<option value="0"></option>

											<option value="{{$row['organization_cd']}}"
                                            >{{$row['organization_nm']??''}}
                                            </option>
                                            @endforeach --}}
                                            @endif
                                        </select>
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                @endif
                                @endforeach
                                </div>
                            <div class="row">                    
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                        <label
                                            class="control-label {{$check_lang=='en'?'lable-check':''}}">{{ __('messages.position') }}&nbsp;
                                        </label>
                                        <select name="" class="form-control position_cd" tabindex="1"
                                            {{$disabled}} >
                                            <option value="-1"></option>
                                            @if(isset($combo_position_cd[0]) && !empty($combo_position_cd[0]))
                                            @foreach($combo_position_cd as $dt)
                                            <option value="{{$dt['position_cd']??''}}"
                                                >
                                                {{$dt['position_nm']??''}}
                                            </option>
                                            @endforeach
                                            @endif
                                        </select>
                                    </div>
                                </div>
                                @if (isset($disabled) && $disabled == '')
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                    <div class="form-group">
                                        <label
                                            class="control-label {{$check_lang=='en'?'lable-check':''}}">&nbsp</label>
                                        <span class="num-length btn_remove_left" style="margin-top:4px">
                                            <span tabindex="1" style="border:none" class="btn-remove btn-remove_02">
                                                <i class="fa fa-remove"></i>
                                            </span>
                                        </span>
                                    </div>
                                </div>
                                @endif
                        </div>
                    </div>

                </div>
            </div>

        </div>
        </div>
    @endif
   

</div>