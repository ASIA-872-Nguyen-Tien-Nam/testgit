<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>{{$title or 'Query Error!'}}</title>
	<meta name="csrf-token" content="{{ csrf_token() }}">
	<link href="\template\image\logo\logo1.ico" rel="shortcut icon">
	<!-- Bootstrap -->
	{!! public_url('template/css/common/bootstrap.min.css') !!}
	{!! public_url('template/css/common/font-awesome.min.css') !!}
	{!!public_url('template/css/common/bootstrap-material-datetimepicker.css')!!}
	{!!public_url('template/css/common/colorbox.css')!!}
	{{-- public_url('template/css/form/layout.css') --}}
	{!!public_url('template/css/common/common.css')!!}
	@yield('asset_header')
	<style>
            html, body {
                background-color: #fff;
                color: #636b6f;
                font-family: 'Raleway', sans-serif;
                font-weight: 100;
                height: 100vh;
                margin: 0;
            }
            .full-height {
                height: 80vh;
            }
            .flex-center {
                align-items: center;
                display: flex;
                justify-content: center;
            }
            .position-ref {
                position: relative;
            }
            .content {
                text-align: center;
            }
            .title {
                font-size: 84px;
            }
            .m-b-md {
                margin-bottom: 30px;
            }
    </style>
</head>
<body>
	<div id="content">
		<div class="flex">
			<div class="flex-center position-ref full-height">
	            <div class="content">
	                <div class="title m-b-md">
	                    {{$title or 'Query Error!!'}}
	                </div>
	                <p>
	                	Please check database connector
	                </p>
	            </div>
	        </div>
		</div><!-- /.flex -->
	</div><!--/#content --> 
</body>
</html>