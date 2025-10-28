@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
    {!!public_url('template/css/oneonone/om0300/om0300.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
    {!!public_url('template/js/oneonone/om0300/om0300.index.js')!!}
@stop

@section('content')
<!-- START CONTENT -->
@push('asset_button')
{!!
Helper::dropdownRender1on1(['saveButton','addNewButton', 'deleteButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid" >
	<input type="hidden" class="anti_tab" name="">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('OneOnOne::om0300.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('OneOnOne::om0300.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div><!-- end .container-fluid -->
@stop
