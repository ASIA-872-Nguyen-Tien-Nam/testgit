@extends('slayout')
@section('asset_header')
		<!-- START LIBRARY CSS -->
	{!!public_url('template/css/basicsetting/m0070/m0070.index.css')!!}
@stop
@section('asset_footer')
	<script>
        var photo = '{{ __('messages.photo') }}';
    </script>
	{!!public_url('template/js/common/zipcode.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_01.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_02.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_03.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_04.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_05.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_06.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_07.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_08.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_09.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_10.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_11.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_12.index.js')!!}
	{!!public_url('template/js/basicsetting/m0070/m0070_13.index.js')!!}
	{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
		<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
	Helper::buttonRender(['addNewButton' ,'saveButton','deleteButton','mailButton', 'backButton'])
	!!}
@endpush
@section('content')
		<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">
		<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
			<div class="inner">
				@include('BasicSetting::m0070.leftcontent')
			</div><!-- end .inner -->
		</div>
		<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
			@include('BasicSetting::m0070.refer')
		</div>
	</div><!-- end .row -->
	<input type="hidden" id ="screen_from" value="{{$screen_from??''}}">
</div>
<!-- end .container-fluid -->
@stop