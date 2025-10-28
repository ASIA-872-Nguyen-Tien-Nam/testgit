@php
$check_lang = \Session::get('website_language', config('app.locale'));
@endphp
<div class="card calHe  inner" style="padding-bottom: 0px;">
    <div class="card-body p-0">
    @include('BasicSetting::m0070.header_employee')
</div>
</div>
<div class="row">
    <div class="col-12">


    </div>
</div>

<nav class=" navbar navbar_m0070 navbar-expand-lg navbar-light bg-light menu_m0070_mobile" style="padding:0px">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav nav flex-column" style="background: #707070 ; width:100%;margin:0 auto">
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei active show" data-toggle="tab" href="#tab1" role="tab"
                    aria-selected="true">
                    {{ __('messages.login_information') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>

            <!-- no authority -->
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab2" role="tab">
                    {{ __('messages.employee_information') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            <!-- affiliation_info -->
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab3" role="tab">
                    {{ __('messages.affiliation_history_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @if(checkM0070TabIsUsed('M0070_01'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab4" role="tab">
                    {{ __('messages.employee_information_2_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_02'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab5" role="tab">
                    {{ __('messages.credentials_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_03'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab14" role="tab">
                    {{ __('messages.training_history_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_04'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab15" role="tab">
                    {{ __('messages.work_history_inf_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_05'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab6" role="tab">
                    {{ __('messages.academic_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_06'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab7" role="tab">
                    {{ __('messages.contact_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_07'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab8" role="tab">
                    {{ __('messages.commute_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif

            @if(checkM0070TabIsUsed('M0070_08'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab9" role="tab">
                    {{ __('messages.family_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_09'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab10" role="tab">
                    {{ __('messages.leave_of_absence_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_10'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab11" role="tab">
                    {{ __('messages.fixed_term_employment_contract_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_11'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab12" role="tab">
                    {{ __('messages.social_insurance_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
			@if(checkM0070TabIsUsed('M0070_12'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab17" role="tab">
                    {{ __('messages.tab_salary') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif
            @if(checkM0070TabIsUsed('M0070_13'))
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab13" role="tab">
                    {{ __('messages.reward_and_punishment_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
            @endif

            

            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab16" role="tab">
                    {{ __('messages.employee_optional_information_tab') }}
                    <div class="caret"></div>
                </a>
				 <span style="color:white"></span>  
            </li>
        </ul>
    </div>
</nav>
{{-- tạo tab --}}
<ul class="nav nav-tabs tab-style menu_m0070_pc">
    <!-- no authority -->
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei active show" data-toggle="tab" href="#tab1" role="tab"
            aria-selected="true">
            {{ __('messages.login_information') }}
            <div class="caret"></div>
        </a>
    </li>

    <!-- no authority -->
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab2" role="tab">
            {{ __('messages.employee_information') }}
            <div class="caret"></div>
        </a>
    </li>
    <!-- affiliation_info -->
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab3" role="tab">
            {{ __('messages.affiliation_history_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @if(checkM0070TabIsUsed('M0070_01'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab4" role="tab">
            {{ __('messages.employee_information_2_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_02'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei employee_qualification" data-toggle="tab" href="#tab5" role="tab">
            {{ __('messages.credentials_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_03'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab14" role="tab">
            {{ __('messages.training_history_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_04'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab15" role="tab">
            {{ __('messages.work_history_inf_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_05'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei employee-academic" data-toggle="tab" href="#tab6" role="tab">
            {{ __('messages.academic_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_06'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei contact_information_tab" data-toggle="tab" href="#tab7" role="tab">
            {{ __('messages.contact_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_07'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab8" role="tab">
            {{ __('messages.commute_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif

    @if(checkM0070TabIsUsed('M0070_08'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei employee-family" data-toggle="tab" href="#tab9" role="tab">
            {{ __('messages.family_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_09'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei leave_absence_infor" data-toggle="tab" href="#tab10" role="tab">
            {{ __('messages.leave_of_absence_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_10'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei employment_contract_information_tab_10" data-toggle="tab" href="#tab11" role="tab">
            {{ __('messages.fixed_term_employment_contract_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_11'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei social_insurance" data-toggle="tab" href="#tab12" role="tab">
            {{ __('messages.social_insurance_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
	@if(checkM0070TabIsUsed('M0070_12'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab17" role="tab">
            {{ __('messages.tab_salary') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif
    @if(checkM0070TabIsUsed('M0070_13'))
    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei reward_and_punishment_information_tab" data-toggle="tab" href="#tab13" role="tab">
            {{ __('messages.reward_and_punishment_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
    @endif

    

    <li class="nav-item " id="">
        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab16" role="tab">
            {{ __('messages.employee_optional_information_tab') }}
            <div class="caret"></div>
        </a>
    </li>
</ul>
{{-- tab body --}}
{{-- TAB 1 --}}
<div class="tab-content list_detail w-result-tabs">
    @include('BasicSetting::m0070.login_information')
    <div class=" row_data_02  list row_data_02_hidden " hidden>
<div class=" line-border-bottom" style="border-left:0px !important">
    </div>
    <div class="row data_row_02 list_organization">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="row ">


                <div class="col-xl-5 col-lg-5 col-sm-12">
                    <div class="form-group button_add_02_div" hidden>
                        <label data-container="body" data-toggle="tooltip" data-original-title=""
                            class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                            style="width:100%;margin-bottom: 0px;">{{ __('messages.current_post_info') }}
                        </label>
                        <div class="full-width ">
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
                            <input {{$disabled}}  type="text" id="" class="form-control only-number arrange_order" tabindex="3"
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
                                    <option value="{{$row['organization_cd_1']??''}}">
                                        {{$row['organization_nm']??''}}</option>
                                    @endforeach
                                </select>
                            </div>


                            <!--/.form-group -->
                        </div>
                        @endif
                        @php

                        if($count_organization_cd < count($organization_group)){
                            $count_organization_cd=count($organization_group); } @endphp @foreach($organization_group as
                            $dt) @if($dt['organization_typ']>=2)
                            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 col_w_25_tab02">
                                <div class="form-group">
                                    <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$dt['organization_group_nm']}}"
                                        style="max-width: 150px;    display: block">
                                        {{$dt['organization_group_nm']}}
                                    </label>
                                    <select {{$disabled}}  name="" id="{{'organization_step'.$dt['organization_typ']}}"
                                        class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="1"
                                        organization_typ="{{$dt['organization_typ']}}">
                                        <option value="-1"></option>
                                        @if($organization_group_total[$dt['organization_typ']] != null &&
                                        count($organization_group_total[$dt['organization_typ']]) > 0)
                                        @foreach($organization_group_total[$dt['organization_typ']] as $row)
                                        <option
                                            value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}"
                                            >
                                            {{$row['organization_nm']}}
                                        </option>
                                        @endforeach
                                        {{-- @foreach($organization_group_total['2']) as $row)
                <option value="0"></option>

                <option value="{{$row['organization_cd']}}">{{$row['organization_nm']}}
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
                                    <label class="control-label {{$check_lang=='en'?'lable-check':''}}">&nbsp</label>
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
    @include('BasicSetting::m0070.employee_information')
    @include('BasicSetting::m0070.department_information')
    @include('BasicSetting::m0070.m0070_01')
    @include('BasicSetting::m0070.m0070_02')
    @include('BasicSetting::m0070.m0070_03')
    @include('BasicSetting::m0070.m0070_04')
    @include('BasicSetting::m0070.m0070_05')
    @include('BasicSetting::m0070.m0070_06')
    <div class="tab-pane fade" id="tab8">
    @include('BasicSetting::m0070.m0070_07')
    </div>
    @include('BasicSetting::m0070.m0070_08')
    <div class="tab-pane fade" id="tab10">
    @include('BasicSetting::m0070.m0070_09')
    </div>
    <div class="tab-pane fade add_block_tab_11_table" id="tab11">
    @include('BasicSetting::m0070.m0070_10')
    </div>
    <div class="tab-pane fade" id="tab12">
    @include('BasicSetting::m0070.m0070_11')
    </div>
    @include('BasicSetting::m0070.m0070_12')
    @include('BasicSetting::m0070.m0070_13')
    
    @include('BasicSetting::m0070.employee_voluntary')

</div>

</div>
<!-- end .card-body -->
</div>