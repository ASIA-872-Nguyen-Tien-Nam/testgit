@extends('weeklyreport/layout')

@section('asset_header')
{!! public_url('template/css/weeklyreport/rm0200/rm0200.index.css') !!}
@stop

@section('asset_footer')
{!! public_url('template/js/weeklyreport/rm0200/rm0200.index.js') !!}
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
					@include('WeeklyReport::rm0200.leftcontent')
				</div>
			</div>
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="row inner">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" id="right-respon">
						@include('WeeklyReport::rm0200.rightcontent')
					</div>
				</div>
			</div>

		</div>
	</div><!-- end .container-fluid -->
@stop