@extends('weeklyreport/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
    {!!public_url('template/css/weeklyreport/rm0300/rm0300.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
    {!!public_url('template/js/weeklyreport/rm0300/rm0300.index.js')!!}
@stop

@section('content')
<!-- START CONTENT -->
@push('asset_button')
{!!
Helper::dropdownRenderWeeklyReport(['addNewButton','saveButton', 'deleteButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid" >
	<input type="hidden" class="anti_tab" name="">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('WeeklyReport::rm0300.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('WeeklyReport::rm0300.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div><!-- end .container-fluid -->
@stop
