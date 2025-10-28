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
		$navbars = navbar_group($excepts,[1]);
		// dd($excepts);
	@endphp
	<div class="language" value="{{$auth->language??'en'}}"></div>
	<nav class="navbar navbar-expand-lg navbar-light navbar-mobile" style="padding-right: 0px;padding-left:0px">
		<div class="row" style="width:100%">
			<div class="col-2">
				<a tabindex="-1" class="navbar-brand logo" href="/menu">
					<img src="/template/image/logo/logo-icon.png" height="40px">
				</a>
			</div>
			<div class="col-5" style="display:flex">
			@isset(session_data()->m0070->mypurpose_use_typ)
				@if (session_data()->m0070->mypurpose_use_typ == 1)
					<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class=" form-control indexTab Convert-Halfsize">
					<button class="btn btn-outline-primary my_purpose_btn" mode="1" style="left: 10px;padding-right: 20px;">
						{{-- <a class="nav-link" style="color:white;padding:0px">{{ __('messages.edit') }}</a> --}}
						<i class="fa fa-pencil" aria-hidden="true"></i>
					</button>
				@endif	
			@endisset
			</div>
			<div class="col-5" style="padding-right: 0px;">
				<button style="float:right" class="navbar-toggler button-menu-common" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<a tabindex="-1" style="float:right;padding: 0.25rem 0.75rem;font-size: 1.25rem;" class="nav-link icon btn-information" href="#">
					<i class="fa fa-commenting-o number-comment" aria-hidden="true">
						@if(isset($auth->m0070->countInfromation)&&($auth->m0070->countInfromation>0))
							<i>{{$auth->m0070->countInfromation??'0'}}</i>
						@endif
					</i>
				</a>
			</div>
		</div>
		<div class="" style="width:100%">
			<div class="col-12" style="padding: 0px">
				<div class="collapse navbar-collapse menu-common" id="navbarSupportedContent">
					<div class="row" style="background: #2b71b9 ; width:100%;margin:0 auto">
						<div class="col-6" >
							<ul class="nav flex-column">
								@if($navbars)
								@foreach($navbars as $key=>$row)
									@if($key == 0 && count($row) == 1)
									<li class="nav-item">
										<a class="nav-link active" id="home_url" aria-current="page" href="{{url($row[0]->function_id)}}">
											<span><img class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-home.svg')!!}></span>{{ __('messages.home') }}
										</a>
									</li>
									@elseif($key == 1 && count($row) == 1)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample1" role="button" aria-expanded="false" aria-controls="collapseExample1">
										<a class="nav-link" href="/master/q0071?feedback=1"><i class="fa fa-comments" aria-hidden="true"></i> {{ __('messages.feedback_half') }} <span></span></a>
									</li>
									@elseif($key == 2 && count($row)==1)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample2" role="button" aria-expanded="false" aria-controls="collapseExample2">
										<a class="nav-link" href="{{url($row[0]->function_id)}}"><i class="fa fa-book" aria-hidden="true"></i> {{$row[0]->function_nm}} <span></span></a>
									</li>
									@elseif ($key == 3)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample3" role="button" aria-expanded="false" aria-controls="collapseExample3">
										<a class="nav-link" href="#"><i class="fa fa-line-chart" aria-hidden="true"></i> {{ __('messages.personnel_assessment') }} <span><i class="fa fa-chevron-right"></i></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample3">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@endif
								@endforeach
								<li class="nav-item">
									<a class="nav-link active" id="btn-change-password" style="color:white; cursor:pointer" aria-current="page"><i class="fa fa-repeat" aria-hidden="true"></i> {{ __('messages.change_password') }}<span></span></a>
									@if(isset($auth->authority_typ) && ($auth->authority_typ !='4'))
										<a class="nav-link active"  onclick="location.href='/master/q0071'" style="display: none; ">{{ __('messages.search_history') }}</a>
									@endif
								</li>
								<li class="nav-item">
									<a class="nav-link active" id="btn-change-language" style="color:white"  aria-current="page"><i class="fa fa-repeat" aria-hidden="true" style="cursor:pointer"></i> {{ __('messages.language_setting') }}<span></span></a>
								</li>
								@endif
							</ul>
						</div>
						<div class="col-6" >
							<ul class="nav flex-column">
								@if($navbars)
									@foreach($navbars as $key=>$row)
										@if ($key == 4)
										<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample4" role="button" aria-expanded="false" aria-controls="collapseExample4">
											<a class="nav-link" href="#"><i class="fa fa-refresh" aria-hidden="true"></i> {{ __('messages.process_fiscal_year') }} <span><i class="fa fa-chevron-right"></i></a>
										</li>
										<ul class="nav flex-column">
											<div class="collapse menu-child-common" id="collapseExample4">
												@foreach($row as $screen)
												<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
												@endforeach
											</div>
										</ul>
										@elseif ($key == 5)
										<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample5" role="button" aria-expanded="false" aria-controls="collapseExample5">
											<a class="nav-link" href="#"><i class="fa fa-server" aria-hidden="true"></i> {{ __('messages.evaluation_master') }} <span><i class="fa fa-chevron-right"></i></a>
										</li>
										<ul class="nav flex-column">
											<div class="collapse menu-child-common" id="collapseExample5">
												@foreach($row as $screen)
												<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
												@endforeach
											</div>
										</ul>
										@elseif ($key == 6)
										<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample6" role="button" aria-expanded="false" aria-controls="collapseExample6">
											<a class="nav-link" href="#">
												<img class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-setting.svg')!!}> {{ __('messages.personnel_assessment_setting') }} <span><i class="fa fa-chevron-right"></i>
											</a>
										</li>
										@elseif($key == 7 && count($row) == 1)
										<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample7" role="button" aria-expanded="false" aria-controls="collapseExample7">
											<a class="nav-link" href="/master/q9001" target="_blank">{{ __('messages.my_purpose') }}</a>
										</li>
										<ul class="nav flex-column">
											<div class="collapse menu-child-common" id="collapseExample6">
												@foreach($row as $screen)
													@if ($screen->function_id != 'master/guide')
														<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
													@else
														<a class="nav-link" to="#help" href="{{env('GUIDE_EVALUATION_ADMIN_URL')}}" target="_blank">{{ __('messages.how_to_use_faq') }}<br>{{ __('messages.admin_use') }}</a>
													@endif
												@endforeach
											</div>
										</ul>
										@endif
									@endforeach
								@endif
								<li class="nav-item nav-item-common">
									<a class="nav-link" to="#help" href="{{env('GUIDE_EVALUATION_USER_URL')}}" target="_blank">{{ __('messages.how_to_use_faq') }}<br>({{__('messages.for_rated_rater')}})</a>
								</li>
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
	<nav class="navbar navbar-expand-md fixed-top header navbar-pc">
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
				<ul class="navbar-nav mr-auto layout_input master_layout_input">
					@isset(session_data()->m0070->mypurpose_use_typ)
						@if (session_data()->m0070->mypurpose_use_typ == 1)
						<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class="search_layout_input form-control indexTab Convert-Halfsize">
						<button class="btn btn-outline-primary my_purpose_btn" mode="1" style="margin-left: 10px;">
							{{-- <a class="nav-link" style="color:white;padding:0px">{{ __('messages.edit') }}</a> --}}
							<i class="fa fa-pencil" aria-hidden="true"></i>
						</button>
						@endif
					@endisset
				</ul>
				<ul class="navbar-nav right">
					<li class="nav-item" style="background-color: #2b71b9">
						<a tabindex="-1" class="nav-link icon div_small_header" to="#help" href="{{env('GUIDE_EVALUATION_USER_URL','')}}"target="_blank">
							<span style="color: white">{{__('messages.how_to_use_faq')}}<br>({{__('messages.for_rated_rater')}})</span>
						</a>
					</li>
					<li class="nav-item active">
						<a tabindex="-1" class="nav-link icon btn-information" href="#">
							<i class="fa fa-commenting-o number-comment" aria-hidden="true">
								@if(isset($auth->m0070->countInfromation)&&($auth->m0070->countInfromation>0))
									<i>{{$auth->m0070->countInfromation??'0'}}</i>
								@endif
							</i>
						</a>
					</li>
					<li class="dropdown">
						<a tabindex="-1" class="nav-link dropdown-toggle" href="javascript:void(0)" role="button" id="dropdownMenu2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<table>
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
							@if(isset($auth->authority_typ) && ($auth->authority_typ !='4'))
							<button class="dropdown-item" type="button" onclick="location.href='/master/q0071'" style="display: none;">{{ __('messages.search_history') }}</button>
							@endif
							<button class="dropdown-item"  id="btn-change-language" type="button">{{ __('messages.language_setting') }}</button>
						</div>
					</li>
				    <li class="nav-item">
						<!-- <a tabindex="-1" class="nav-link icon logout" href="{{url('/logout')}}"> -->
						<a tabindex="-1" class="nav-link icon logout" href={{url('logout')}}>
							<i class="fa fa-sign-out" aria-hidden="true"></i>
							<span>{{__('messages.logout')}}</span>
						</a>
					</li>
				</ul>
			</div>
		</nav>
		<div class="main">
			<div class="main-nav main-pc">
				<ul class="list-group mcd-menu">
				@if($navbars)
					@foreach($navbars as $key=>$row)
						<li class="parent-list {{$key >= 4 ?'menu-config':''}}">
							@if($key == 0 && count($row) == 1)
							<a tabindex="-1" id="home_url" href="{{url($row[0]->function_id)}}" >
								<p><img src= {!!public_url('uploads/ver1.7/icon/icon-home.svg')!!}></p>
								<div>{{ __('messages.home') }}</div>
							</a>
							@elseif($key == 1 && count($row) == 1)
							<a tabindex="-1" href="/master/q0071?feedback=1">
								<p><i class="fa fa-comments" aria-hidden="true"></i></p>
								<div>{{ __('messages.feedback_half') }}</div>
							</a>
							@elseif($key == 2 && count($row)==1)
							<a tabindex="-1" href="{{url($row[0]->function_id)}}">
								<p><i class="fa fa-book" aria-hidden="true"></i></p>
								<div>{{$row[0]->function_nm}}</div>
							</a>
							@elseif($key==3)
							<a tabindex="-1" href="#">
								<p><i class="fa fa-line-chart" aria-hidden="true"></i></p>
								<div>{{ __('messages.personnel_assessment') }}</div>
							</a>
							@elseif($key==4)
							<a tabindex="-1" href="#">
								<p><i class="fa fa-refresh" aria-hidden="true"></i></p>
								<div>{{ __('messages.process_fiscal_year') }}</div>
							</a>
							@elseif($key==5)
							<a tabindex="-1" href="#">
								<p><i class="fa fa-server" aria-hidden="true"></i></p>
								<div>{{ __('messages.evaluation_master') }}</div>
							</a>
							@elseif($key==6)
							<a tabindex="-1" href="#">
								<!-- <p><i class="fa fa-cogs" aria-hidden="true"></i></p> -->
								<p><img src={!!public_url('uploads/ver1.7/icon/icon-setting.svg')!!}></i></p>
								<div>{{ __('messages.personnel_assessment_setting') }}</div>
							</a>
							@elseif($key==7)
							<a tabindex="-1" href="{{url($row[0]->function_id)}}" target="_blank">
								<p><img src= {!!public_url('uploads/ver1.7/icon/icon-purpose.png')!!}></p>
								<div>{{ __('messages.my_purpose') }}</div>
							</a>
							@endif
							@if(count($row) > 0 && !in_array($key,[0,1,2,7]))
							<ul class="{{'ul'.$key}}">
								@foreach($row as $screen)
									@if ($screen->function_id != 'master/guide')
										<li><a tabindex="-1" href="{{url($screen->function_id)}}"><i class="fa fa-genderless"></i>{{$screen->function_nm}}</a></li>
									@else
										<li>
										<a tabindex="-1" to="#help" href="{{env('GUIDE_EVALUATION_ADMIN_URL')}}" target="_blank"><i class="fa fa-genderless"></i>{{ __('messages.how_to_use_faq') }}<br>{{ __('messages.admin_use') }}</a>
									</li>
									@endif
								@endforeach
							</ul>
							@endif
						</li>
					@endforeach
				</ul>
				@endif

			</div> <!-- end .main-nav -->
			<div class="content master-content {{isset($button_active)?$button_active:'' }} " language="{{ __('messages.language') }}">
				<div class="container-fluid" language="{{ __('messages.language') }}">
					<div class="row" style="height:58px;position:relative">
						<div class="col-10 col-xl-6 col-lg-6  header-left-function ">
							<h5 class="title-screen">@section('screen_title') {{$title or ''}} @show</h5>
						</div>
						@stack('asset_button')
					</div>
				</div>
				@yield('content')
			</div> <!-- end .content -->
		</div> <!-- end .main -->
		<footer class="footer footer-master">
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
	<!-- domain js-->
	{!! public_url('template/js/common/domain.js') !!}
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	{!! public_url('template/js/common/jquery.min.js') !!}
	{!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	{!! public_url('template/js/common/popper.js') !!}
	{!! public_url('template/js/common/bootstrap.min.js') !!}
	<script>
        var _text = {!! json_encode($_text)  !!}
    </script>
	{!! public_url('template/js/common/moment-with-locales.min.js') !!}
	{!!public_url('template/js/common/bootstrap-material-datetimepicker.js')!!}
	{!!public_url('template/js/common/ansplugin.js')!!}
	{!! public_url('template/js/common/jmessages.js') !!}
	{!!public_url('template/js/common/common.js')!!}
	{!!public_url('template/js/common/app.js')!!}
	{!!public_url('template/js/common/jquery.colorbox-min.js')!!}
	{{-- {!!public_url('template/js/common/jquery-ui.js')!!} --}}
	{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
	{!!public_url('template/js/common/jquery.resizableColumns.js')!!}
	{!!public_url('template/js/common/bootstrap_multiselect.js')!!}
	{!!public_url('template/js/common/uniform.min.js')!!}

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