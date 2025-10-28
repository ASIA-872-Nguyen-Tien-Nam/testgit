@extends('layout')

@push('asset_button')
	<!-- add button here -->
	{!!
        Helper::buttonRender(['saveButton', 'copyButton','backButton'])
    !!}
@endpush

@section('asset_header')
{!!public_url('template/css/form/i1040.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/i1040.index.js')!!}
@stop

@section('content')
<div class="container-fluid" >
	<div class="card inner calHe" >
		<div class="card-body " id="body">
			@include('Master::i1040.refer')
		</div> <!-- end .card-body -->
		<input type="hidden" class="anti_tab" name="">
	</div> <!-- end .card -->
</div> <!-- end .container-fluid -->
@stop