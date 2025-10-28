@extends('weeklyreport/layout')

@section('asset_header')
	{!! public_url('template/css/weeklyreport/rm0100/rm0100.index.css') !!}
@stop

@section('asset_footer')
	{!! public_url('template/js/weeklyreport/rm0100/rm0100.index.js') !!}
@stop

@push('asset_button')
{!!
Helper::dropdownRenderWeeklyReport(['addNewSignupButton','saveButton','deleteButton','backButton'])
!!}
@endpush

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">
		<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
			<div class="inner">
				@include('WeeklyReport::rm0100.leftcontent')
			</div> <!-- end .inner -->
		</div> <!-- end #leftcontent -->
		<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
			<div class="inner">
				@include('WeeklyReport::rm0100.rightcontent')
			</div> <!-- end #rightcontent -->
		</div>
	</div>
</div>
@stop