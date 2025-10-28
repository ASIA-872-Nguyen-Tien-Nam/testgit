@extends('slayout')
@section('asset_header')
		<!-- START LIBRARY CSS -->
	{!!public_url('template/css/basicsetting/m0070/m0070.index.css')!!}
	{!!public_url('template/css/employeeinfo/eq0101.index.css')!!}
@stop
@section('asset_footer')
	<script>
        var photo = '{{ __('messages.photo') }}';
    </script>
	{!!public_url('template/js/employeeinfo/eq0101.index.js')!!}
	{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
		<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
	Helper::dropdownRenderEmployeeInformation(['employeeInformationOutput', 'backButton'])
!!}
@endpush
@section('content')
		<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">
		<div id="rightcontent" class="col-sm-12 col-md-12 col-lg-12 col-ltx-12">
			@include('EmployeeInfo::eq0101.refer')
		</div>
	</div><!-- end .row -->
	<input type="hidden" id ="screen_from" value="{{$screen_from??''}}">
</div>
<!-- end .container-fluid -->
@stop