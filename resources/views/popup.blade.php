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
	{!!public_url('template/css/common/common.css')!!}
	{!!public_url('template/css/common/popup.css')!!}
	@php
		$url = '';
		$parent_url = explode('/',$_SERVER['HTTP_REFERER']);
		$prefix =$parent_url[3];
			switch ($prefix) {
				case 'oneonone':
					$url='template/css/oneonone/common/popup.css';
					$url='template/css/oneonone/common/common_1on1.css';
				break;
				case 'basicsetting':
					$url='template/css/basicsetting/common/popup.css';
				break;
				case 'employeeinfo':
					$url='template/css/employeeinfo/common/popup.css';
				break;
				case 'multiview':
					$url='template/css/mulitiview/common/popup.css';
				break;
				case 'weeklyreport':
					$url='template/css/weeklyreport/common/weeklyreport.css';
				break;
				default:
					$url='';
				break;
			}
	@endphp
	{!!public_url($url)!!}
	@yield('asset_header')
	@stack('header')
</head>
<body class="@stack('action')">
		<div class="popup-wrapper">
			<div class="p-head">
				{{$title??''}}
				<div class="heading-elements popup-header-heading-elements inline-block">
					<div class="m-icon m-danger" style="display: block;" id="btn-close-popup">
		        		<span class="m-x-mark-line-left"></span>
		        		<span class="m-x-mark-line-right"></span>
		        	</div>
	        	</div>
			</div><!-- end .p-head -->
			 @if(View::hasSection('asset_button'))
			<nav class="navbar navbar-expand-lg navbar-light bg-light navbar-act sticky p-0 custom">

			    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo03" aria-controls="navbarTogglerDemo03" aria-expanded="false" aria-label="Toggle navigation">
			        <span class="navbar-toggler-icon"></span>
			    </button>
			    <a class="navbar-brand" href="#"></a>

			    <div class="collapse navbar-collapse">
			        <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
			        	<!-- @stack('asset_button') -->
			        	@yield('asset_button')
			        </ul>
			    </div>
			</nav>
			@endif
			<div class="p-content">
				<div class="container-fluid">
					<div class="row">
						<div class="col">
							@yield('content')
						</div><!-- end .col-md-12 -->
					</div><!-- end .row -->
				</div><!-- end .container-fluid -->
			</div><!-- end .p-content -->

		</div> <!-- end .content -->
	@php
		$language = Config::get('app.locale');
	@endphp
	<input type="hidden" id="language_jmessages" value="{{$language}}">
	<!-- domain js-->
	{!! public_url('template/js/common/domain.js') !!}
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	{!! public_url('template/js/common/jquery.min.js') !!}
	{!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
	<script>
        var _text = {!! json_encode($_text)  !!}
    </script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	{!! public_url('template/js/common/popper.js') !!}
	{!! public_url('template/js/common/bootstrap.min.js') !!}
	{!! public_url('template/js/common/moment-with-locales.min.js') !!}
	{!!public_url('template/js/common/bootstrap-material-datetimepicker.js')!!}
	{!!public_url('template/js/common/ansplugin.js')!!}
	{!! public_url('template/js/common/jmessages.js') !!}
	{!!public_url('template/js/common/common.js')!!}
	{!!public_url('template/js/common/app.js')!!}
	{!!public_url('template/js/common/jquery.colorbox-min.js')!!}
	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	{!! public_url('template/js/common/html5shiv.min.js') !!}
	{!! public_url('template/js/common/respond.min.js') !!}
	<![endif]-->
	@yield('asset_footer')
	@yield('asset_common')
	@include('common')
</body>
</html>