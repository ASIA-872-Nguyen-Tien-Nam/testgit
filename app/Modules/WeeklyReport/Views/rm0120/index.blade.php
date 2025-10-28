@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/rm0120/rm0120.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/weeklyreport/rm0120/rm0120.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['saveButton', 'deleteButton', 'backButton']) !!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">
		<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
			<div class="inner">
				@include('WeeklyReport::rm0120.leftcontent')
			</div> <!-- end .inner -->
		</div> <!-- end #leftcontent -->
		<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
			<div class="inner">
				@include('WeeklyReport::rm0120.refer')
			</div> <!-- end #rightcontent -->
		</div>
	</div>
</div>
@stop
