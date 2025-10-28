@extends('customer')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!! public_url('template/css/common/master.css') !!}
	{!!public_url('template/css/form/m0001.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/m0001.index.js')!!}
<!-- {!!public_url('template/js/common/zipcode.js')!!} -->
<!-- <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD-SuUsQXWnWMeFRDzOk1MAtJcdurZFYcM&callback=initMap&language=ja"></script> -->
@stop
@push('asset_button')
    {!!
        Helper::buttonRender(['addNewButton','saveButton', 'deleteButton', 'idOutputButton', 'backButton'])
    !!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row" id='m0001-body'>
		@if(isset($html_m0001 ) && $html_m0001 !="")
		{!!$html_m0001 !!}
		@else
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('Master::m0001.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('Master::m0001.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		@endif
	</div>
	<input type='hidden' value='abc'/>
	<input type='hidden' id='api_err' value='{{$err??''}}'/>
	<input type='hidden' id='api_company_id' value='{{$id??''}}'/>
	<input type='hidden' id='api_company_nm' value='{{$name??''}}'/>
	@php
		$language = Config::get('app.locale');
	@endphp
	<input type="hidden" id="language_jmessages" value="{{$language}}">
</div>
@stop