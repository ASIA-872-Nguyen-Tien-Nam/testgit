<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>{{$title or ''}}</title>
	<meta name="csrf-token" content="{{ csrf_token() }}">
	<meta name="google" value="notranslate">
	<link href="/template/image/logo/logo-icon.png" rel="shortcut icon">
	<!-- Bootstrap -->
	{!! public_url('template/css/common/bootstrap.min.css') !!}
	{!! public_url('template/css/common/font-awesome.min.css') !!}
	{!!public_url('template/css/common/bootstrap-material-datetimepicker.css')!!}
	{!!public_url('template/css/common/jquery.datetimepicker.css')!!}
	{!!public_url('template/css/common/colorbox.css')!!}
	{!!public_url('template/css/common/sticky.css')!!}
	{!!public_url('template/css/common/jmessages.css')!!}
	{{-- public_url('template/css/form/layout.css') --}}
	{!!public_url('template/css/common/common.css')!!}
	{!!public_url('template/css/common/vertical-menu.css')!!}
	{!!public_url('template/css/basicsetting/common/basicsetting.css')!!}
	{!!public_url('template/css/common/jquery.resizableColumns.css')!!}
	{!!public_url('template/css/common/jquery.multiSelect.css')!!}
	{!!public_url('template/css/common/jquery-ui.css')!!}

	@yield('asset_header')
	@stack('header')
</head>
<body>
	@php
		$auth = session_data();
		$excepts = $auth->excepts;
		$navbars = navbar_group($excepts,[0]);
		// dd($navbars);
	@endphp
	    <div class="language" value="{{$auth->language??'en'}}"></div>
	<nav class="navbar navbar-expand-lg navbar-light navbar-mobile" style="padding-right: 0px;padding-left:0px">
		<div class="row" style="width:100%">
			<div class="col-2">
				<a tabindex="-1" class="navbar-brand logo" href="/menu">
					<img src="/template/image/logo/logo-icon.png" height="40px">
				</a>
			</div>
			<div class="col-8" style="display:flex">
			@isset(session_data()->m0070->mypurpose_use_typ)
				@if (session_data()->m0070->mypurpose_use_typ == 1)
					<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class=" form-control indexTab Convert-Halfsize">
					<button class="btn btn-outline-primary my_purpose_btn" mode="4" style="left: 10px;padding-right: 20px;">
						<i class="fa fa-pencil" aria-hidden="true"></i>
					</button>
				@endif
			@endisset
			</div>
			<div class="col-2" style="padding-right: 0px;">
				<button style="float:right" class="navbar-toggler button-menu-common" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
			</div>
		</div>
		<div class="" style="width:100%">
			<div class="col-12" style="padding: 0px">
				<div class="collapse navbar-collapse menu-common" id="navbarSupportedContent">
					<div class="row" style="background: #707070 ; width:100%;margin:0 auto">
						<div class="col-12" >
							<ul class="nav flex-column">
								@if (isset(session_data()->setting_authority_typ) && session_data()->setting_authority_typ > 2)
								<li class="nav-item">
									<a class="nav-link active" aria-current="page" href="/basicsetting/sdashboard">
										<i class="fa fa-cogs" aria-hidden="true"></i>
										{{ __('messages.basic_setting') }}
									</a>
								</li>
								@endif
								@if (isset(session_data()->empinf_use_typ) && session_data()->empinf_use_typ == 1 && isset(session_data()->empinfo_authority_typ) && session_data()->empinfo_authority_typ >= 3)
								<li class="nav-item">
									<a class="nav-link active" href="/employeeinfo/edashboard" style="color:white; cursor:pointer" aria-current="page"><i class="fa fa-user" aria-hidden="true"></i> {{ __('messages.employee_information_settings_menu') }}</a>
								</li>
								@endif
								<li class="nav-item">
									<a class="nav-link active" id="btn-change-password" style="color:white" aria-current="page"><span></span></i> {{ __('messages.change_password') }}</a>
									@if(isset($auth->authority_typ) && ($auth->authority_typ !='4'))
										<a class="nav-link active"  onclick="location.href='/master/q0071'" style="display: none;">{{ __('messages.search_history') }}</a>
									@endif
								</li>
								<li class="nav-item">
									<a class="nav-link active" id="btn-change-language" style="color:white; cursor:pointer" aria-current="page"><span></span></i> {{ __('messages.language_setting') }}</a>
								</li>
								<li class="nav-item">
									<a class="nav-link active" to="#help" href="{{env('GUIDE_SETTING_ADMIN_URL')}}" target="_blank">{{ __('messages.how_to_use_faq') }}<br>{{ __('messages.admin_use') }}</a>
								</li>
								@isset($navbars[4])
									@if (count($navbars[4]) == 1)
									<li class="nav-item">
										<a class="nav-link active" href="/basicsetting/sq9001" target="_blank">{{ __('messages.my_purpose') }}</a>
									</li>
									@endif
								@endisset
							</ul>
						</div>
						<div class="col-12" style="margin:0 auto;margin-top:20px;margin-bottom:20px">
							<button class="btn btn-primary" style="background: #f7f7f7;margin:0 auto;width:100%">
								<a class="nav-link" href="{{url('logout')}}" style="color:black;padding:0px"><span><i class="fa fa-sign-out" aria-hidden="true"></i></span>{{ __('messages.logout') }}</a>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</nav>
	<nav class="navbar navbar-expand-md fixed-top header-oneonone header header-xam navbar-pc">
			<a tabindex="-1" class="navbar-brand logo" href="/menu">
				<img src="/template/image/logo/logo-icon.png" height="40px">
			</a>
			<div class="collapse navbar-collapse" id="navbarCollapse" >
				<ul class="navbar-nav">
					<li>
						<a tabindex="-1" class="nav-link" style="color: red;">
							@if($auth->change_pass_status??0 == 1)
								<i class="fa fa-exclamation-circle" aria-hidden="true" style="font-size: 20px;"></i>
								<span style="margin-left: 10px;">{{ __('messages.please_change_your_password') }}（{{ __('messages.day_left_until_expiration') }} {{$auth->pass_remain??0}} {{ __('messages.day') }}）</span>
							@endif
						</a>
					</li>
				</ul>

				<ul class="navbar-nav mr-auto">
					@isset(session_data()->m0070->mypurpose_use_typ)
						@if (session_data()->m0070->mypurpose_use_typ == 1)
							<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class="search_layout_input form-control indexTab Convert-Halfsize">
							<button class="btn btn-outline-primary my_purpose_btn" mode="4" style="margin-left: 10px;">
								<i class="fa fa-pencil" aria-hidden="true"></i>
							</button>
						@endif
					@endisset
				</ul>
				<ul class="navbar-nav right">
					<li class="nav-item" style="background-color: #707070">
						<a tabindex="-1" class="nav-link icon" to="#help" href="{{env('GUIDE_SETTING_ADMIN_URL','')}}" target="_blank" style="color: #707070;">
							<span style="color: white">{{ __('messages.how_to_use_faq') }}<br>{{ __('messages.admin_use') }}</span>
						</a>
					</li>
					<li class="dropdown">
						<a tabindex="-1" class="nav-link dropdown-toggle" href="javascript:void(0)" role="button" id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<table style="margin-bottom:0px !important">
								<tr>
									@if($auth  && isset($auth->company_nm))
								    <td class="txt">
									<div data-toggle="tooltip" title="{{htmlspecialchars($auth->company_nm)}}" class="ellipsis" style="width: 220px;">
											{{htmlspecialchars($auth->company_nm)}}
										</div>
								    </td>
									@endif
								</tr>
								<tr>
									<td class="txt">
										<div data-toggle="tooltip" title="{{isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : ''}}" class="text-overflow text-wrap" style="width: 220px; padding-left:4px;">
											{{isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : ''}}
										</div>
									</td>
								</tr>
							</table>
						</a>
						<div class="dropdown-menu" aria-labelledby="dropdownMenu2">
							<button class="dropdown-item" type="button" id="btn-change-password">{{ __('messages.change_password') }}</button>
							<button class="dropdown-item"  id="btn-change-language" type="button">{{ __('messages.language_setting') }}</button>
						</div>
					</li>
				    <li class="nav-item">
						<!-- <a tabindex="-1" class="nav-link icon logout" href="{{url('/logout')}}"> -->
						<a tabindex="-1" class="nav-link icon logout" href={{url('logout')}}>
							<i class="fa fa-sign-out" aria-hidden="true"></i>
							<span>{{ __('messages.logout') }}</span>
						</a>
					</li>
				</ul>
			</div>
		</nav>
		<div class="main-xam main ">
			<div class="main-nav main-pc">
				<ul class="list-group mcd-menu">
					{{-- 基本設定 --}}
					@if (isset(session_data()->setting_authority_typ) && session_data()->setting_authority_typ > 2)
					<li class="parent-list">
						<a tabindex="-1" id="home_url" href="/basicsetting/sdashboard" >
							<p>
								<i class="fa fa-cogs" aria-hidden="true"></i>
							</p>
							<div>{{ __('messages.basic_setting') }}</div>
						</a>
					<li>
					@endif
					{{-- 社員情報 --}}
					@if (isset(session_data()->empinf_use_typ) && session_data()->empinf_use_typ == 1 && isset(session_data()->empinfo_authority_typ) && session_data()->empinfo_authority_typ >= 3)
					<li class="parent-list">
						<a tabindex="-1" href="/employeeinfo/edashboard" >
							<p>
								<i class="fa fa-user" aria-hidden="true"></i>
							</p>
							<div>{{ __('messages.employee_information_settings_menu') }}</div>
						</a>
					<li>	
					@endif
					@isset($navbars[4])
						@if (count($navbars[4]) == 1)
							<li class="parent-list">
								<a tabindex="-1" href="/basicsetting/sq9001" target="_blank">
									<p><img src= {!!public_url('uploads/ver1.7/icon/icon-purpose.png')!!}></p>
									<div>{{ __('messages.my_purpose') }}</div>
								</a>
							<li>
						@endif
					@endisset
				</ul>
			</div> <!-- end .main-nav -->
			<div class="content master-content {{isset($button_active)?$button_active:'' }}">
				<div class="container-fluid" language="{{ __('messages.language') }}">
					<div class="row" style="height:58px;position:relative">
						<div class="col-10 col-xl-6 col-lg-6  header-left-function ">
							<h5 class="title-screen">{{ $title??'' }}</h5>
						</div>
						@stack('asset_button')
					</div>
				</div>
				@yield('content')
			</div> <!-- end .content -->
		</div> <!-- end .main -->
		<footer class="footer-xam">
	    	<div class="container" style="margin-right: 0px">
	    		<ol class="breadcrumb hide">
					<li class="breadcrumb-item">&nbsp;</li>
					<li class="breadcrumb-item"><a tabindex="-1" href="#">{{ __('messages.help') }}</a></li>
					<li class="breadcrumb-item active" aria-current="page">{{ __('messages.inquiry') }}</li>
				</ol>
	    	</div>
	    </footer>
	@php
		$language = Config::get('app.locale');
	@endphp
	<input type="hidden" id="language_jmessages" value="{{$language}}">
	<input type="hidden" id="google_key" value="{{$_google_key}}">
	<!-- domain js-->
	{!! public_url('template/js/common/domain.js') !!}
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	{!! public_url('template/js/common/jquery.min.js') !!}
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	{!! public_url('template/js/common/popper.js') !!}
	{!! public_url('template/js/common/bootstrap.min.js') !!}
	<script>
        var _text = {!! json_encode($_text)  !!}
    </script>
	{!! public_url('template/js/common/moment-with-locales.min.js') !!}
	{!!public_url('template/js/common/bootstrap-material-datetimepicker.js')!!}
	{!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
	{!!public_url('template/js/common/ansplugin.js')!!}
	{!! public_url('template/js/common/jmessages.js') !!}
	{!!public_url('template/js/common/common.js')!!}
	{!!public_url('template/js/common/app.js')!!}
	{!!public_url('template/js/common/jquery.colorbox-min.js')!!}
	{{-- {!!public_url('template/js/common/jquery-ui.js')!!} --}}
	{!!public_url('template/js/common/jquery.resizableColumns.js')!!}
	{!!public_url('template/js/common/bootstrap_multiselect.js')!!}
	{!!public_url('template/js/common/uniform.min.js')!!}
	{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	{!! public_url('template/js/common/html5shiv.min.js') !!}
	{!! public_url('template/js/common/respond.min.js') !!}
	<![endif]-->
	@yield('asset_common')
	{{-- @include('common') --}}
	<div class="div_loading">
		<div class="image_loading_popup">
			<img src="{{ asset('template/image/system/loading.gif') }}">
		</div>
	</div>
	@yield('asset_footer')
	<script type="text/javascript">
		$(document).ready(function() {
			var link = '<li><p></p><div></div></li>';
		});
	</script>
</body>
</html>