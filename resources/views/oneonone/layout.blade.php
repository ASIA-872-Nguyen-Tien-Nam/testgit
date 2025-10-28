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
	{!!public_url('template/css/common/vertical-menu.css')!!}
	{!!public_url('template/css/oneonone/common/oneonone.css')!!}
	{!!public_url('template/css/oneonone/common/common_1on1.css')!!}
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
	$navbars = navbar_group($excepts,[2,999]);
	$contract_company_attribute = $auth->contract_company_attribute ?? 0;
	@endphp
	<div class="language" value="{{$auth->language??'en'}}"></div>
	<nav class="navbar navbar-expand-lg navbar-light navbar-mobile" style="padding-right: 0px;padding-left:0px">
		<div class="row" style="width:100%">
			<div class="col-2">
				<a tabindex="-1" class="navbar-brand logo" href="/menu">
					<img src="/template/image/logo/logo-icon.png" height="40px">
				</a>
			</div>
			<div class="col-8"  style="display:flex">
			@isset(session_data()->m0070->mypurpose_use_typ)
				@if (session_data()->m0070->mypurpose_use_typ == 1)
					<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class=" form-control indexTab Convert-Halfsize">
					<button class="btn btn-outline-primary my_purpose_btn" mode="2" style="left: 10px;padding-right: 20px;border-color: #FC933C">
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
					<div class="row" style="background: #FC933C ; width:100%;margin:0 auto">
						<div class="col-6" >
							<ul class="nav flex-column">
								@if($navbars)
								@foreach($navbars as $key=>$row)
									@if($key == 0 && count($row) == 1)
									<li class="nav-item">
										<a class="nav-link active" aria-current="page" href="{{url($row[0]->function_id)}}"><span><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-home.svg')!!}></span> {{ __('messages.home') }}</a>
									</li>
									@elseif ($contract_company_attribute == 1 && $key == 1)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample1" role="button" aria-expanded="false" aria-controls="collapseExample1">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('template/image/icon/icon_2_write.png')!!}> 1on1 <span><i class="fa fa-chevron-right"></i></span></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample1">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($key == 1)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample1" role="button" aria-expanded="false" aria-controls="collapseExample1">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-enforce.svg')!!}> {{ __('messages.implement') }} <span><i class="fa fa-chevron-right"></i></span></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample1">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($contract_company_attribute == 1 && $key == 2)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample2" role="button" aria-expanded="false" aria-controls="collapseExample2">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('template/image/icon/icon4.png')!!}> {{ __('messages.weekly_master') }} <span><i class="fa fa-chevron-right"></i></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample2">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($key == 2)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample2" role="button" aria-expanded="false" aria-controls="collapseExample2">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-search.svg')!!}> {{ __('messages.analysis') }} <span><i class="fa fa-chevron-right"></i></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample2">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($contract_company_attribute == 1 && $key == 3)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample3" role="button" aria-expanded="false" aria-controls="collapseExample3">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('template/image/icon/icon_4_write.png')!!}>{{ __('messages.set') }}<span><i class="fa fa-chevron-right"></i></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample3">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($key == 3)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample3" role="button" aria-expanded="false" aria-controls="collapseExample3">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-prepare.svg')!!}>{{ __('messages.preparation') }}<span><i class="fa fa-chevron-right"></i></a>
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
								
								@endif
							</ul>
						</div>
						<div class="col-6" >
							<ul class="nav flex-column">
								@if($navbars)
								@foreach($navbars as $key=>$row)
									@if ($key == 4)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample4" role="button" aria-expanded="false" aria-controls="collapseExample4">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-master.svg')!!}>{{ __('messages.1on1_master') }}<span><i class="fa fa-chevron-right"></i></a>
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
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-movie.svg')!!}>{{ __('messages.video_list') }}<span><i class="fa fa-chevron-right"></i></a>
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
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-sheet.svg')!!}>{{ __('messages.questionnaire') }}<span><i class="fa fa-chevron-right"></i></a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample6">
											@foreach($row as $screen)
											<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
											@endforeach
										</div>
									</ul>
									@elseif ($key == 7)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample7" role="button" aria-expanded="false" aria-controls="collapseExample7">
										<a class="nav-link" href="#"><img style="" class="pictute-menu-common" src={!!public_url('uploads/ver1.7/icon/icon-setting.svg')!!}> {{ __('messages.set') }} <span><i class="fa fa-chevron-right"></i></a>
									</li>
									@elseif ($key == 8 && count($row) == 1)
									<li class="nav-item nav-item-common" data-toggle="collapse" href="#collapseExample8" role="button" aria-expanded="false" aria-controls="collapseExample8">
										<a class="nav-link" href="/oneonone/oq9001" target="_blank">{{ __('messages.my_purpose') }}</a>
									</li>
									<ul class="nav flex-column">
										<div class="collapse menu-child-common" id="collapseExample7">
											@foreach($row as $screen)
												@if ($screen->function_id != 'oneonone/guide')
													<a class="nav-link" href="{{url($screen->function_id)}}">{{$screen->function_nm}}</a>
												@else
													<a class="nav-link" to="#help" href="{{env('GUIDE_ONEONE_ADMIN_URL')}}" target="_blank"><span>{{__('messages.how_to_use_faq')}}<br>{{__('messages.admin_use')}}</span></a>
												@endif
											@endforeach
										</div>
									</ul>
									@endif
								@endforeach
								@endif
								<li class="nav-item nav-item-common">
									<a class="nav-link" to="#help" href="{{env('GUIDE_ONEONE_USER_URL')}}" target="_blank">{{__('messages.how_to_use_faq')}}<br>({{__('messages.for_member_coach')}})</a>
								</li>
								<li class="nav-item nav-item-common">
									<a class="nav-link active" id="btn-change-password" style="color:white; cursor:pointer" aria-current="page"><span></span> {{ __('messages.change_password') }}</a>
									@if(isset($auth->authority_typ) && ($auth->authority_typ !='4'))
										<a class="nav-link active"  onclick="location.href='/master/q0071'" style="display: none;">{{ __('messages.search_history') }}</a>
									@endif
								</li>
								<li class="nav-item nav-item-common">
									<a class="nav-link active" id="btn-change-language" style="color:white; cursor:pointer" aria-current="page"><span></span> {{ __('messages.language_setting') }}</a>
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
	<nav class="navbar navbar-expand-md fixed-top header-oneonone header navbar-pc">
		@if($contract_company_attribute == 1)
		<a tabindex="-1" class="navbar-brand logo" href="#">
			<img src="/template/image/logo/logo-icon.png" height="40px">
		</a>
		@else
		<a tabindex="-1" class="navbar-brand logo" href="/menu">
			<img src="/template/image/logo/logo-icon.png" height="40px">
		</a>
		@endif
		<div class="collapse navbar-collapse" id="navbarCollapse">
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
			<ul class="navbar-nav mr-auto layout_input">
				@isset(session_data()->m0070->mypurpose_use_typ)
					@if (session_data()->m0070->mypurpose_use_typ == 1)
						<input type="text" value="{{ session_data()->m0070->mypurpose ?? '' }}" disabled class="search_layout_input form-control indexTab Convert-Halfsize">
						<button class="btn btn-outline-primary my_purpose_btn" mode="2" style="margin-left: 10px; border-color: #FC933C">
							<i class="fa fa-pencil" aria-hidden="true"></i>
						</button>
					@endif
				@endisset
			</ul>
			<ul class="navbar-nav right">
				<li class="nav-item" style="background-color: #FC933C">
					<a tabindex="-1" class="nav-link nav-link-oneonone icon" to="#help" href="{{env('GUIDE_ONEONE_USER_URL')}}" target="_blank">
						<span style="color: white">{{__('messages.how_to_use_faq')}}<br>({{__('messages.for_member_coach')}})</span>
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
						<button class="dropdown-item"  id="btn-change-language" type="button">{{ __('messages.language_setting') }}</button>
					</div>
				</li>
				<li class="nav-item">
					<a tabindex="-1" class="nav-link icon logout" href={{url('logout')}}>
						<i class="fa fa-sign-out" aria-hidden="true"></i>
						<span>{{__('messages.logout')}}</span>
					</a>
				</li>
			</ul>
		</div>
	</nav>
	<div class="main-oneonone ">
		<div class="main-nav main-pc">
			<ul class="list-group mcd-menu">
				@if($navbars)
					@foreach($navbars as $key=>$row)
					<li class="parent-list" @if($key >= 7) style="position: relative;" @endif>
						@if($key == 0 && count($row) == 1)
						<a tabindex="-1" id="home_url" href="{{url($row[0]->function_id)}}">
							<p><img src= {!!public_url('uploads/ver1.7/icon/icon-home.svg')!!}></p>
							<div>{{ __('messages.home') }}</div>
						</a>
						@elseif($contract_company_attribute == 1 && $key == 1)
						<a tabindex="-1" href="#">
							<p><img style="width:50px;height:50px" src={!!public_url('template/image/icon/icon_2_write.png')!!}> </p> <div>1on1</div>
						</a>
						@elseif($key == 1)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-enforce.svg')!!}> </p> <div>{{ __('messages.implement') }}</div>
						</a>
						@elseif($contract_company_attribute == 1 && $key == 2)
						<a tabindex="-1" href="#">
							<p><img style="width:50px;height:50px" src={!! public_url('template/image/icon/icon4.png') !!}> </p>
							<div>{{ __('messages.weekly_master') }}</div>
						</a>
						@elseif($key == 2)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-search.svg')!!}></p>
							<div>{{ __('messages.analysis') }}</div>
						</a>
						@elseif($contract_company_attribute == 1 && $key == 3)
						<a tabindex="-1" href="#">
							<p><img style="width:50px;height:50px" src={!! public_url('template/image/icon/icon_4_write.png') !!}></p>
							<div>{{ __('messages.set') }}</div>
						</a>
						@elseif($key==3)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-prepare.svg')!!}></p>
							<div>{{ __('messages.preparation') }}</div>
						</a>
						@elseif($key==4)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-master.svg')!!}></p>
							<div>{{ __('messages.1on1_master') }}</div>
						</a>
						@elseif($key==5)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-movie.svg')!!}></p>
							<div>{{ __('messages.video_list') }}</div>
						</a>
						@elseif($key==6)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-sheet.svg')!!}></p>
							<div>{{ __('messages.questionnaire') }}</div>
						</a>
						@elseif($key==7)
						<a tabindex="-1" href="#">
							<p><img src={!!public_url('uploads/ver1.7/icon/icon-setting.svg')!!}></i></p>
							<div>{{ __('messages.set') }}</div>
						</a>
						@elseif($key == 8 && count($row) == 1)
						<a tabindex="-1" href="{{url($row[0]->function_id)}}" target="_blank">
							<p><img src= {!!public_url('uploads/ver1.7/icon/icon-purpose.png')!!}></p>
							<div>{{ __('messages.my_purpose') }}</div>
						</a>
						@endif
						@if(count($row) > 0 && !in_array($key, [0,8]))
						<ul @if($key===7) style="bottom:0" @endif>
							@foreach($row as $screen)
								@if ($screen->function_id != 'oneonone/guide')
									<li><a tabindex="-1" href="{{url($screen->function_id)}}"><i class="fa fa-genderless"></i>{{$screen->function_nm}}</a></li>
								@else
									<li>
										<a tabindex="-1" to="#help" href="{{env('GUIDE_ONEONE_ADMIN_URL','')}}" target="_blank"><i class="fa fa-genderless"></i>{{__('messages.how_to_use_faq')}}<br>{{__('messages.admin_use')}}</a>
									</li>
								@endif
							@endforeach
						</ul>
						@endif
					</li>
				@endforeach
			</ul>
		@endif
		</div>
		<div class="content">
			<div class="container-fluid">
				<div class="row" style="height:58px;position:relative">
					<div class="col-10 col-sm-5 col-md-3 col-lg-4 col-xl-6 header-left-function ">
						<h5 class="title-screen">{{ $title??'' }}</h5>
					</div>
					@stack('asset_button')
				</div>
			</div>
			@yield('content')
		</div>
	</div> <!-- end .main -->
	@php
		$language = Config::get('app.locale');
	@endphp
	<input type="hidden" id="language_jmessages" value="{{$language}}">
	<script>
        var _text = {!! json_encode($_text)  !!}
    </script>
	<!-- domain js-->
	{!! public_url('template/js/common/domain.js') !!}
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	{!! public_url('template/js/common/jquery.min.js') !!}
	{!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	{!! public_url('template/js/common/popper.js') !!}
	{!! public_url('template/js/common/bootstrap.min.js') !!}
	{!! public_url('template/js/common/moment-with-locales.min.js') !!}
	{!!public_url('template/js/common/bootstrap-material-datetimepicker.js')!!}
	{!!public_url('template/js/common/ansplugin.js')!!}
	{!! public_url('template/js/common/jmessages.js') !!}
	{!!public_url('template/js/common/common.js')!!}
	{!!public_url('template/js/common/tabindex.js')!!}
	{!!public_url('template/js/common/app.js')!!}
	{!!public_url('template/js/common/jquery.colorbox-min.js')!!}
	{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
	{{-- {!!public_url('template/js/common/jquery-ui.js')!!} --}}
	{!!public_url('template/js/common/jquery.resizableColumns.js')!!}
	{!!public_url('template/js/common/bootstrap_multiselect.js')!!}
	{!!public_url('template/js/common/uniform.min.js')!!}

	@yield('asset_common')
	{{-- @include('common') --}}
	<div class="div_loading">
		<div class="image_loading_popup">
			<img src="{{ asset('template/image/system/loading.gif') }}">
		</div>
	</div>
	@yield('asset_footer')
</body>
</html>