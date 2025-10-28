@extends('slayout')

@section('asset_header')
	{!! public_url('template/css/basicsetting/m0010/m0010.index.css') !!}
@stop

@section('asset_footer')
		<!-- START LIBRARY JS -->
	{!! public_url('template/js/basicsetting/m0010/m0010.index.js') !!}
@stop
@push('asset_button')
{!! Helper::buttonRender(['addNewButton','saveButton','deleteButton','backButton'],[],$button) !!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">
		<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
			<div class="inner">
				@include('BasicSetting::m0010.leftcontent')
			</div> <!-- end .inner -->
		</div> <!-- end #leftcontent -->
		<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
			<div class="inner">
				@include('BasicSetting::m0010.rightcontent')
			</div> <!-- end #rightcontent -->
		</div>
	</div>
</div>
@stop