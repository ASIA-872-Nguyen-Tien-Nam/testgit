@php
    $check_lang = \Session::get('website_language', config('app.locale'));
@endphp
<div class="card calHe inner" style="padding-bottom: 0px;">
    <div class="card-body p-0">
        <div class="row">
            <input {{ $disabled }} type="hidden" id="modePic" value="N" />
            <div class="col-auto2">
                <div class="avatar">
                    <div class="img">
                        <div
                            class="d-flex flex-box {{ !isset($table1['picture']) || $table1['picture'] == '' ? 'flex-box-image' : '' }}">
                            @if (!isset($table1['picture']) || $table1['picture'] == '')
                                <p class="w100">{{ __('messages.photo') }}</p>
                                <img id="img-upload" class="thumb" />
                            @else
                                <img id='img-upload' class="thumb imgs"
                                    src="{{ $table1['picture'] }}?v={{ time() }}" />
                            @endif
                        </div><!-- end .d-flex -->
                    </div>
                    {{-- <div id="imageMain" class="text-center">
                    <label id="btn-upload" for="realupload" class="face-file-btn" tabindex="10">
                        <i class="fa fa-folder-open fa1"></i>
                    </label>
                    <button id="btn-delete-file" class="btn-clearfile" tabindex="10">
                        <i class="fa fa-trash fa3"></i>
                    </button>
                    <div class="input-group hidden">
                        <span class="input-group-btn">
                            <span class="btn btn-default btn-file">
                                Browse… <input {{$disabled}} type="file" id="imgInp" accept="image/*">
                            </span>
                        </span>
                        <input {{$disabled}} type="text" class="form-control" readonly>
                    </div>
                </div> --}}
                </div>
            </div>
            <div class="col-auto">
                <div class="row">
                    <div class="col-md-4 col-xl-3 col-lg-3  col-xxl-2 div_parent_employee_cd">
                        <div class="form-group rq">
                            <label class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}"
                                style="min-width: 160px;">{{ __('messages.employee_no') }}
                            </label>
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input {{ $disabled }} type="tel"
                                        class="form-control indexTab employee_cd required Convert-Halfsize "
                                        id="employee_cd" tabindex="1" maxlength="10"
                                        {{-- value="{{ $keep_emp == 1 ? $employee_cd ?? '' : '' }}" --}}
                                        value="{{ $employee_cd ?? '' }}"
                                        style="padding-right: 40px;" />
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-xl-3 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.surname') }}</label>
                            <span class="num-length">
                                <input {{ $disabled }} type="tel" class="form-control" tabindex="2"
                                    maxlength="50" id="employee_last_nm"
                                    value="{{ $table1['employee_last_nm'] ?? '' }}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-6 col-xl-3 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.first_name') }}
                            </label>
                            <span class="num-length">
                                <input {{ $disabled }} type="tel" class="form-control" tabindex="3"
                                    maxlength="50" id="employee_first_nm"
                                    value="{{ $table1['employee_first_nm'] ?? '' }}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-6 col-xl-3 col-xxl-4 div_parent_employee_nm">
                        <div class="form-group {{ $check_lang == 'en' ? 'rq1' : '' }}">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.full_name') }}
                                <div class="{{ $check_lang == 'en' ? 'aaa' : 'bbb' }}"></div>
                            </label>
                            <span class="num-length">
                                <input {{ $disabled }} type="tel" class="form-control required" tabindex="4"
                                    maxlength="101" id="employee_nm" value="{{ $table1['employee_nm'] ?? '' }}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                </div> <!-- .row -->
                <div class="row">
                    <div class="col-md-2 col-xl-2 col-lg-4  {{ $check_lang == 'en' ? 'hidden' : '' }}">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.furigana') }}
                            </label>
                            <span class="num-length">
                                <input {{ $disabled }} type="tel" class="form-control" tabindex="6"
                                    maxlength="50" id="furigana" value="{{ $table1['furigana'] ?? '' }}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>

                    <div class="col-md-col3">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.join_date') }}
                            </label>
                            <div class="input-group-btn input-group ">
                                <input {{ $disabled }} type="text" id="company_in_dt"
                                    class="form-control input-sm date right-radius required" placeholder="yyyy/mm/dd"
                                    tabindex="13" value="{{ $table1['company_in_dt'] ?? '' }}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-col5">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.seniority') }}</label>
                            <div>
                                <input {{ $disabled }} type="text" id="period_date" class="form-control wd"
                                    value="{{ $table1['period_date'] ?? '' }}" disabled>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-col1 ">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.date_birth') }}
                            </label>
                            <div class="input-group-btn input-group">
                                <input {{ $disabled }} type="text" id="birth_date"
                                    class="form-control input-sm date right-radius" placeholder="yyyy/mm/dd"
                                    tabindex="9" value="{{ $table1['birth_date'] ?? '' }}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.age') }}</label>
                            <div>
                                <input {{ $disabled }} type="text" id="year_old" class="form-control"
                                    value="{{ $table1['year_old'] ?? '' }}" tabindex="-1" disabled>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 col-xl-2 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label  {{ $check_lang == 'en' ? 'lable-check1' : '' }}">{{ __('messages.sex') }}
                            </label>
                            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                                <div class="md-radio-v2 inline-block">
                                    <input {{ $disabled }} name="gender" type="radio" id="rd1"
                                        value="1" tabindex="7"
                                        {{ ($table1['gender'] ?? 1) == 1 ? 'checked' : '' }}>
                                    <label for="rd1">{{ __('messages.male') }}</label>
                                </div>
                                <div class="md-radio-v2 inline-block">
                                    <input {{ $disabled }} name="gender" type="radio" id="rd2"
                                        value="2" tabindex="8"
                                        {{ ($table1['gender'] ?? 1) == 2 ? 'checked' : '' }}>
                                    <label for="rd2">{{ __('messages.female') }}</label>
                                </div>
                                <div class="md-radio-v2 inline-block">
                                    <input {{ $disabled }} name="gender" type="radio" id="rd3"
                                        value="3" tabindex="8"
                                        {{ ($table1['gender'] ?? 1) == 3 ? 'checked' : '' }}>
                                    <label for="rd3">{{ __('messages.others') }}</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {{-- @if ($SSO_use_typ == 1)
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="control-label">SSO{{ __('messages.user_id') }}</label>
                        <span class="num-length">
                            <div class="input-group-btn btn-left">
                                <input {{ $disabled }} type="text" class="form-control text-left"
                                    id="sso_user" maxlength="255" value="{{ $table1['sso_user'] ?? '' }}"
                                    tabindex="12">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" disabled=""><i
                                            class="fa fa-user" aria-hidden="true"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                </div>
            </div>
        @endif --}}

        {{-- tabs for mobile --}}
        <nav class=" navbar navbar_m0070 navbar-expand-lg navbar-light bg-light menu_m0070_mobile"
            style="padding:0px">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav nav flex-column" style="background: #707070 ; width:100%;margin:0 auto">
                    <li class="nav-item " id="">
                        <a class="nav-link treatment_applications_no hei active show" data-toggle="tab"
                            href="#tab2" role="tab">
                            {{ __('messages.employee_information') }}
                            <div class="caret"></div>
                        </a>
                    </li>
                    <li class="nav-item " id="">
                        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab3"
                            role="tab">
                            {{ __('messages.affiliation_history_information_tab') }}
                            <div class="caret"></div>
                        </a>
                    </li>
                    @if (checkM0070TabIsUsed('M0070_01', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab4"
                                role="tab">
                                {{ __('messages.employee_information_2_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_02', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab5"
                                role="tab">
                                {{ __('messages.credentials_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab18"
                                role="tab">
                                {{ __('messages.personnel_evaluation') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_03', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab14"
                                role="tab">
                                {{ __('messages.training_history_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_04', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab15"
                                role="tab">
                                {{ __('messages.work_history_inf_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif

                    @if (checkM0070TabIsUsed('M0070_05', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab6"
                                role="tab">
                                {{ __('messages.academic_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_06', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab7"
                                role="tab">
                                {{ __('messages.contact_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_07', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab8"
                                role="tab">
                                {{ __('messages.commute_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_08', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab9"
                                role="tab">
                                {{ __('messages.family_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_09', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab10"
                                role="tab">
                                {{ __('messages.leave_of_absence_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_10', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab11"
                                role="tab">
                                {{ __('messages.fixed_term_employment_contract_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_11', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab12"
                                role="tab">
                                {{ __('messages.social_insurance_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_12', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab17"
                                role="tab">
                                {{ __('messages.tab_salary') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    @if (checkM0070TabIsUsed('M0070_13', 1))
                        <li class="nav-item " id="">
                            <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab13"
                                role="tab">
                                {{ __('messages.reward_and_punishment_information_tab') }}
                                <div class="caret"></div>
                            </a>
                        </li>
                    @endif
                    <li class="nav-item " id="">
                        <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab16"
                            role="tab">
                            {{ __('messages.employee_optional_information_tab') }}
                            <div class="caret"></div>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        {{-- tabs for pc --}}
        <ul class="nav nav-tabs tab-style menu_m0070_pc">
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei active show" data-toggle="tab" href="#tab2"
                    role="tab">
                    {{ __('messages.employee_information') }}
                    <div class="caret"></div>
                </a>
            </li>
            <li class="nav-item " id="">
                <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab3" role="tab">
                    {{ __('messages.affiliation_history_information_tab') }}
                    <div class="caret"></div>
                </a>
            </li>
            @if (checkM0070TabIsUsed('M0070_01', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab4"
                        role="tab">
                        {{ __('messages.employee_information_2_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_02', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab5"
                        role="tab">
                        {{ __('messages.credentials_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab18"
                        role="tab">
                        {{ __('messages.personnel_evaluation') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_03', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab14"
                        role="tab">
                        {{ __('messages.training_history_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_04', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab15"
                        role="tab">
                        {{ __('messages.work_history_inf_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_05', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab6"
                        role="tab">
                        {{ __('messages.academic_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_06', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab7"
                        role="tab">
                        {{ __('messages.contact_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_07', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab8"
                        role="tab">
                        {{ __('messages.commute_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_08', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab9"
                        role="tab">
                        {{ __('messages.family_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_09', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab10"
                        role="tab">
                        {{ __('messages.leave_of_absence_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_10', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab11"
                        role="tab">
                        {{ __('messages.fixed_term_employment_contract_information_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_11', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab12"
                        role="tab">
                        {{ __('messages.social_insurance_tab') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_12', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab17"
                        role="tab">
                        {{ __('messages.tab_salary') }}
                        <div class="caret"></div>
                    </a>
                </li>
            @endif
            @if (checkM0070TabIsUsed('M0070_13', 1))
                <li class="nav-item " id="">
                    <a class="nav-link treatment_applications_no hei" data-toggle="tab" href="#tab13"
                        role="tab">
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
            @include('BasicSetting::m0070.m0070_01')
            {{-- @include('BasicSetting::m0070.m0070_02') --}}
            {{-- @include('BasicSetting::m0070.m0070_03') --}}
            {{-- @include('BasicSetting::m0070.m0070_04') --}}
            @include('EmployeeInfo::eq0101.m0070_02')
            @include('EmployeeInfo::eq0101.m0070_03')
            @include('EmployeeInfo::eq0101.m0070_04')
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
            @include('BasicSetting::m0070.personnel_assessment')
            {{-- @include('BasicSetting::m0070.employee_information') --}}
            @include('EmployeeInfo::eq0101.employee_information')
            {{-- @include('BasicSetting::m0070.department_information') --}}
            @include('EmployeeInfo::eq0101.department_information')
            @include('BasicSetting::m0070.employee_voluntary')
        </div>
    </div>
</div>
