@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!! public_url('template/css/oneonone/om0310/om0310.index.css') !!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/oneonone/om0310/om0310.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::dropdownRender1on1(['saveButton','deleteButton','backButton'])
!!}
@endpush

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row" id="result">
				@include('OneOnOne::om0310.search')
			</div>

			<div class="row justify-content-md-center" style="margin-top: 30px;">
				{!!
				Helper::buttonRender1on1(['saveButton'])
				!!}
			</div>
		</div><!-- end .card-body -->
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
@stop