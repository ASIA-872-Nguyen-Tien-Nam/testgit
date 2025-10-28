<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>{{ $title or '' }}</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="google" value="notranslate">
    <link href="/template/image/logo/logo-icon.png" rel="shortcut icon">
    <!-- Bootstrap -->
    {!! public_url('template/css/common/bootstrap.min.css') !!}
    {!! public_url('template/css/common/font-awesome.min.css') !!}
    {!! public_url('template/css/common/bootstrap-material-datetimepicker.css') !!}
    {!! public_url('template/css/common/jquery.datetimepicker.css') !!}
    {!! public_url('template/css/common/colorbox.css') !!}
    {!! public_url('template/css/common/sticky.css') !!}
    {!! public_url('template/css/common/jmessages.css') !!}
    {{-- public_url('template/css/form/layout.css') --}}
    {!! public_url('template/css/common/common.css') !!}
    {!! public_url('template/css/common/vertical-menu.css') !!}
    {!! public_url('template/css/common/jquery.resizableColumns.css') !!}
    {!! public_url('template/css/common/jquery.multiSelect.css') !!}
    {!! public_url('template/css/common/jquery-ui.css') !!}
    {!! public_url('template/css/form/menu.css') !!}

    @yield('asset_header')
    @stack('header')
</head>

<body id="body-menu">
    @php
        $auth = session_data();
    @endphp
    <nav class="navbar fixed-top header-menu header  navbar-expand-lg navbar-light navbar-mobile"
        style="padding-right: 0px;padding-left:0px">
        <div class="row" style="width:100%">
            <div class="col-2">
                <a tabindex="-1" class="navbar-brand logo" href="#">
                    <img src="/template/image/logo/logo-icon.png" height="40px">
                </a>
            </div>
            @isset(session_data()->m0070->mypurpose_use_typ)
                @if (session_data()->m0070->mypurpose_use_typ == 1)
                    <div class="col-8" style="display:flex">
                        <input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled
                            class="form-control indexTab Convert-Halfsize">
                        <button class="btn btn-outline-primary my_purpose_btn" mode="0"
                            style="left: 10px;padding-right: 20px;">
                            <i class="fa fa-pencil" aria-hidden="true"></i>
                        </button>
                    </div>
                @endif
            @endisset
            @php
                $service_first_cnt = 0;
                $show_blank_div = 1;
            @endphp
            <div class="col-2" style="padding-right: 0px;">
                <button style="float:right" class="navbar-toggler button-menu-common" type="button"
                    data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </div>
        <div class="" style="width:100%">
            <div class="col-12" style="padding: 0px">
                <div class="collapse navbar-collapse menu-common menu-module" id="navbarSupportedContent">
                    <div class="row" style="background: #e8e7e68f ; width:100%;margin:0 auto">
                        <div class="col-6">
                            <ul class="nav flex-column">
                                @if (!isset($home_flg))
                                    <li class="d-flex align-items-center">
                                        <ul id="breadcrumb">
                                            <li><a tabindex="-1" href="#"><span
                                                        class="{{ $category_icon ?? '' }}"> </span>
                                                    {{ $category ?? '' }}</a></li>
                                            <li class="active"><a tabindex="-1" href="#">{{ $title ?? '' }}</a>
                                            </li>
                                        </ul>
                                    </li>
                                @endif
                                @if ($auth->change_pass_status ?? 0 == 1)
                                    <li>
                                        <a tabindex="-1" class="nav-link" style="color: red;">
                                            <i class="fa fa-exclamation-circle" aria-hidden="true"
                                                style="font-size: 20px;"></i>
                                            <span
                                                style="margin-left: 10px;">パスワードを変更してください。（有効期限まであと{{ $auth->pass_remain ?? 0 }}日）</span>
                                        </a>
                                    </li>
                                @endif
                                <li class="dropdown" style="padding-left: 17px;" data-toggle="collapse"
                                    href="#collapseExample3" role="button" aria-expanded="false"
                                    aria-controls="collapseExample3">
                                    <a tabindex="-1">
                                        <table>
                                            <tr>
                                                @if ($auth)
                                                    <td class="txt">
                                                        <div data-toggle="tooltip"
                                                            title="ID:{{ htmlspecialchars($auth->user_id) }}"
                                                            class="ellipsis" style="width: 220px;">
                                                            ID:{{ htmlspecialchars($auth->user_id) }}
                                                        </div>
                                                    </td>
                                                @endif
                                            </tr>
                                            <tr>
                                                <td class="txt">
                                                    <div data-toggle="tooltip"
                                                        title="{{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}"
                                                        class="text-overflow text-wrap" style="width: 220px;">
                                                        {{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="dropdownMenu2">
                                        <button class="dropdown-item" type="button"
                                            id="btn-change-password">{{ __('messages.change_password') }}</button>
                                        <button class="dropdown-item" id="btn-change-language"
                                            type="button">{{ __('messages.language_setting') }}</button>
                                        @if (isset($auth->authority_typ) && $auth->authority_typ != '4')
                                            <button class="dropdown-item" type="button"
                                                onclick="location.href='/master/q0071'"
                                                style="display: none;">{{ __('messages.search_history') }}</button>
                                        @endif
                                    </div>
                                </li>
                                <ul class="nav flex-column">
                                    <div class="collapse menu-child-common" id="collapseExample3"
                                        style="border-bottom: 1px dashed #3598db;">
                                        <a class="nav-link" href="#" id="btn-change-password"
                                            style="border-bottom: 1px dashed #3598db;">{{ __('messages.change_password') }}</a>
                                        @if (isset($auth->authority_typ) && $auth->authority_typ != '4')
                                            <a class="dropdown-item" type="button" src="/master/q0071"
                                                style="display: none;">{{ __('messages.search_history') }}</a>
                                        @endif
                                        <a class="nav-link" href="#"
                                            id="btn-change-language">{{ __('messages.language_setting') }}</a>
                                    </div>
                                </ul>
                            </ul>
                        </div>
                        <div class="col-12" style="margin:0 auto;margin-top:20px;margin-bottom:20px">
                            <button class="btn btn-primary" style="background: #2b71b9;margin:0 auto;width:100%">
                                <a class="nav-link logout" href="{{ url('logout') }}"
                                    style="color:white;padding:0px"><span><i class="fa fa-sign-out"
                                            aria-hidden="true"></i></span>ログアウト</a>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    <nav class="navbar navbar-expand-md fixed-top header-menu header navbar-pc">
        <a tabindex="-1" class="navbar-brand logo" href="/menu">
            <img src="/template/image/logo/logo-icon.png" height="40px">
        </a>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav mr-auto">
                @isset(session_data()->m0070->mypurpose_use_typ)
                    @if (session_data()->m0070->mypurpose_use_typ == 1)
                        <input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled
                            class="search_layout_input search_layout_input_menu form-control indexTab Convert-Halfsize">
                        <button class="btn btn-outline-primary my_purpose_btn" mode="0" style="margin-left: 10px;">
                            {{-- <a class="nav-link" style="color:white;padding:0px">{{ __('messages.edit') }}</a> --}}
                            <i class="fa fa-pencil" aria-hidden="true"></i>
                        </button>
                    @endif
                @endisset
                <li class="d-flex align-items-center">
                    @if (!isset($home_flg))
                        <ul id="breadcrumb">
                            <li><a tabindex="-1" href="#"><span class="{{ $category_icon ?? '' }}"> </span>
                                    {{ $category ?? '' }}</a></li>
                            <li class="active"><a tabindex="-1" href="#">{{ $title ?? '' }}</a></li>
                        </ul>
                    @endif
                </li>
                <li>
                    <a tabindex="-1" class="nav-link" style="color: red;">
                        @if ($auth->change_pass_status ?? 0 == 1)
                            <i class="fa fa-exclamation-circle" aria-hidden="true" style="font-size: 20px;"></i>
                            <span
                                style="margin-left: 10px;">パスワードを変更してください。（有効期限まであと{{ $auth->pass_remain ?? 0 }}日）</span>
                        @endif
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav right">
                {{-- <li class="nav-item">
					<a tabindex="-1" class="nav-link icon" href="#" id="download-manual">
						<i class="fa fa-download" aria-hidden="true"></i>
						<span>マニュアル</span>
					</a>
				</li> --}}
                <li class="dropdown">
                    <a tabindex="-1" class="nav-link dropdown-toggle" href="javascript:void(0)" role="button"
                        id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <table>
                            <tr>
                                @if ($auth  && isset($auth->company_nm))
                                    <td class="txt">
                                        <div data-toggle="tooltip" title="{{ htmlspecialchars($auth->company_nm) }}"
                                            class="ellipsis" style="width: 220px;">
                                            {{ htmlspecialchars($auth->company_nm) }}
                                        </div>
                                    </td>
                                @endif
                            </tr>
                            <tr>
                                <td class="txt">
                                    <div data-toggle="tooltip"
                                        title="{{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}"
                                        class="text-overflow text-wrap" style="width: 220px; padding-left:4px;">
                                        {{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenu2">
                        <button class="dropdown-item" type="button"
                            id="btn-change-password">{{ __('messages.change_password') }}</button>
                        <button class="dropdown-item" id="btn-change-language"
                            type="button">{{ __('messages.language_setting') }}</button>
                        @if (isset($auth->authority_typ) && $auth->authority_typ != '4')
                            <button class="dropdown-item" type="button" onclick="location.href='/master/q0071'"
                                style="display: none;">履歴検索</button>
                        @endif
                    </div>
                </li>
                <li class="nav-item">
                    <!-- <a tabindex="-1" class="nav-link icon logout" href="{{ url('/logout') }}"> -->
                    <a tabindex="-1" class="nav-link icon logout" href={{ url('logout') }}>
                        <i class="fa fa-sign-out" aria-hidden="true"></i>
                        <span>{{ __('messages.logout') }}</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
    <div class="container-fluid settingdashboard">
        <div class="row" id="row-container">
            <div class="col-md-12 row">
                <div class="col-md-1"></div>
				
                
                    @php
                        $multi_typ = 0;
                        $emp_typ = 0;
                        $report_typ = 0;
                        $eval_typ = 0;
                        $one_typ = 0;
						$setting_emp_typ = 0;
                        if ($_1on1_use_typ == 1 && $w_1on1_authority_typ != 0 && $oneonone_time_status == 1) {
                            $one_typ = 1;
                        }
                        if ($evaluation_use_typ == 1 && $evaluation_time_status == 1 && $authority_typ != 0) {
                            $eval_typ = 1;
                        }
                        if (($multireview_use_typ == 1 && $multireview_time_status == 1) && $multireview_authority_typ>=2) {
                            $multi_typ = 1;
                        }
                        if ($employee_information_use_typ == 1) {
                            $emp_typ = 1;
                        }
                        if ($report_use_typ == 1 && $report_time_status == 1) {
                            $report_typ = 1;
                        }
						if ($setting_authority_typ > 2 || ($empinf_use_typ == 1 && $empinfo_authority_typ >= 3)) {
                            $setting_emp_typ = 1;
                        }
                        $sum_typ = $eval_typ + $one_typ + $multi_typ + $emp_typ + $report_typ;
                    @endphp
				
					<div class="col-md-10 col-lg-10 col-xl-9 menu_block" style="margin-left: auto;margin-right: auto">
			
                    <div class="row menu-div justify-content-md-center">
                        @if ($sum_typ == 0)
                            <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3"
                                style=" text-align: center;font-size: 25px;height:240px">
                                &nbsp
                            </div>
                        @endif
                        {{-- 人事評価 --}}
                        @if ($evaluation_use_typ == 1 && $evaluation_time_status == 1 && $authority_typ != 0)
                            	@if ($sum_typ > 4 && $setting_emp_typ == 1)
									<div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard"
										style=" text-align: center;font-size: 25px;">
								@elseif ($sum_typ > 4 && $setting_emp_typ != 1)
									<div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard"
										style=" text-align: center;font-size: 25px;">
                                @else
                                    <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3 dashboard  order-1"
                                        style=" text-align: center;font-size: 25px;">
                            @endif


                            <div class="icon-wrapper" id="evalution_screen">
                                <img class="hidden-img-1 menu-img-1" src={!! public_url('template/image/icon/main_icon_01@2x.png') !!}>
                            </div>
                            <p>{{ __('messages.personnel_assessment') }}
                            <p>
							</div>
							@php $service_first_cnt++;@endphp
                    	@endif

                    @if ($_1on1_use_typ == 1 && $w_1on1_authority_typ != 0 && $oneonone_time_status == 1)
                        @php
                            $oneonone_id = 'oneonone_screen_admin';
                            if ($w_1on1_authority_typ == 1) {
                                $oneonone_id = 'oneonone_screen_member';
                            } elseif ($w_1on1_authority_typ == 2) {
                                $oneonone_id = 'oneonone_screen_coach';
                            }
                        @endphp
                        	@if ($sum_typ > 4 && $setting_emp_typ == 1)
                            <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard"
                                style=" text-align: center;font-size: 25px;">
							@elseif ($sum_typ > 4 && $setting_emp_typ != 1)
							<div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard"
                                style=" text-align: center;font-size: 25px;">
                            @else
                                <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3 dashboard  order-3"
                                    style=" text-align: center;font-size: 25px;">
                        @endif
                        <div class="icon-wrapper" id="{{ $oneonone_id }}">
                            <img class="hidden-img-2 menu-img-2" src={!! public_url('template/image/icon/main_icon_02@2x.png') !!}>
                        </div>
                        <p>1 on 1</p>
						</div>
						@php $service_first_cnt++;@endphp
					@endif
                {{-- マルチレビュー --}}
                @if ($employee_information_use_typ == 1)
						@if ($sum_typ > 4 && $setting_emp_typ == 1)
                        <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu"
                            style=" text-align: center;font-size: 25px;">
						@elseif ($sum_typ > 4 && $setting_emp_typ != 1)
						<div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu"
                            style=" text-align: center;font-size: 25px;">
                        @else
                            <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3 dashboard margintopMenu  order-5"
                                style=" text-align: center;font-size: 25px;">
                    @endif

                    {{-- 社員情報 --}}
                    <div class="icon-wrapper" id="{{ $screen_id }}">
                        <img class="hidden-img-1 menu-img-1" src={!! public_url('template/image/icon/main_icon_06_emp_inf.png') !!}>
                    </div>
                    <p>{{ __('messages.employee_info') }}</p>
					</div>
					@php $service_first_cnt++;@endphp
				@endif

            @if ($multireview_use_typ == 1 && $multireview_time_status == 1)
                @if ($multireview_authority_typ >= 2)
                    @php
                        $id_multi = '';
                        if ($multireview_authority_typ == 2 && $user_is_rater_1 == 0) {
                            $id_multi = 'mdashboardsupporter_screen';
                        } else {
                            $id_multi = 'mdashboard_screen';
                        }
                    @endphp
                    @if ($sum_typ > 4 && $setting_emp_typ == 1)
                        <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu mdashboard_screen"
                            style=" text-align: center;font-size: 25px;">
						@elseif ($sum_typ > 4 && $setting_emp_typ != 1)
                        <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu mdashboard_screen"
                            style=" text-align: center;font-size: 25px;">
                        @else
                            <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3 dashboard margintopMenu mdashboard_screen order-2"
                                style=" text-align: center;font-size: 25px;">
						 @endif
                    <div class="icon-wrapper" id="{{ $id_multi }}">
                        <img class="hidden-img-3 menu-img-3" src={!! public_url('template/image/icon/main_icon_03_1on1.png') !!}>
                    </div>
                    <p>{{ __('messages.multi_review') }}</p>
               
				
				</div>
				 @endif
				@php $service_first_cnt++;@endphp
			@endif

        {{-- 週報 --}}
        @if ($report_use_typ == 1 && $report_time_status == 1)
            @php
                $report_id = 'weekly_report_admin';
                if ($report_authority_typ == 1) {
                    $report_id = 'weekly_report_repoter';
                } elseif ($report_authority_typ == 2) {
                    $report_id = 'weekly_report_aproval';
                }
            @endphp
            
            @if ($sum_typ > 4 && $setting_emp_typ == 1)
                <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu"
                    style=" text-align: center;font-size: 25px;">
				@elseif ($sum_typ > 4 && $setting_emp_typ != 1)
                <div class="col-md-6 col-lg-4 col-sm-6 col-12 col-xl-4 dashboard margintopMenu"
                    style=" text-align: center;font-size: 25px;">
                @else
                    <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3 dashboard margintopMenu  order-4"
                        style=" text-align: center;font-size: 25px;">
            @endif
            <div class="icon-wrapper weeklyreport" id="{{ $report_id }}">
                <img class="hidden-img-1 menu-img-1" src={!! public_url('template/image/icon/icon4.png') !!}>
            </div>
            <p>{{ __('messages.weekly_report') }}</p>
			</div>
			@php $service_first_cnt++;@endphp
		@endif

    </div>
    </div>
    <div class="col-md-1"></div>
    </div>

    <div class="row mt-2">
        <div class="col-md-12">
            <div class="col-md-1"></div>
            <div class="col-md-10 col-lg-12 col-xl-9" style="margin-left: auto;margin-right: auto">
                <div class="row menu-div">
                    <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3">
                    </div>
                    <div class="col-md-6 col-lg-3 col-sm-6 col-12 col-xl-3">
                    </div>
                    {{-- 基本設定 --}}

                </div>
            </div>
            <div class="col-md-1">
            </div>
        </div>
    </div>
    </div>
    @if ($sum_typ == 5)
        <div class="row bottom_120" style="position: relative;">
        @else
            <div class="row bottom_0" style="position: relative;">
    @endif
    <div class="col-md-3 col-lg-3 col-sm-3 col-3 col-xl-3">
    </div>
    <div class="col-md-6 col-lg-8 col-sm-6 col-6 col-xl-7 block_setting_menu_icon">
        @if ($setting_authority_typ > 2 || ($empinf_use_typ == 1 && $empinfo_authority_typ >= 3))
            @php
                $settings_screen = '';
                if ($setting_authority_typ > 2) {
                    $settings_screen = 'sdashboard_screen';
                } elseif ($empinf_use_typ == 1 && $empinfo_authority_typ >= 1) {
                    $settings_screen = 'edashboard_screen';
                }
            @endphp
            <div class="margintopMenu menu-setting-icon" style="padding-top:0px; margin-right:0px">
                <div class="icon-wrapper icon-wrapper-small" style="text-align: right;" id="{{ $settings_screen }}">
                    <img class="hidden-img-4 menu-img-4" src={!! public_url('template/image/icon/main_icon_04@2x.png') !!}>
                </div>
                @if ($lang == 'en')
                    <p>{{ __('messages.basic_setting') }}</p>
                @else
                    <p id="label_basic_setting">{{ __('messages.basic_setting') }}</p>
                @endif
            </div>
        @endif
    </div>

    </div>
    <div class="col-md-3 col-lg-3 col-sm-3 col-3 col-xl-3">
    </div>
    </div>
    </div>

    {!! public_url('template/js/common/jquery.min.js') !!}
    {!! public_url('template/js/common/menu.js') !!}
    {!! public_url('template/js/common/domain.js') !!}

    {!! public_url('template/js/common/jquery.min.js') !!}
    {!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}

    {!! public_url('template/js/common/popper.js') !!}
    {!! public_url('template/js/common/bootstrap.min.js') !!}
    <script>
        var _text = {!! json_encode($_text) !!}
    </script>
    {!! public_url('template/js/common/moment-with-locales.min.js') !!}
    {!! public_url('template/js/common/bootstrap-material-datetimepicker.js') !!}
    {!! public_url('template/js/common/ansplugin.js') !!}
    {!! public_url('template/js/common/jmessages.js') !!}
    {!! public_url('template/js/common/common.js') !!}
    {!! public_url('template/js/common/app.js') !!}
    {!! public_url('template/js/common/jquery.colorbox-min.js') !!}
    {{-- {!!public_url('template/js/common/jquery-ui.js')!!} --}}
    {!! public_url('template/js/common/jquery.resizableColumns.js') !!}
    {!! public_url('template/js/common/bootstrap_multiselect.js') !!}
    {!! public_url('template/js/common/uniform.min.js') !!}
