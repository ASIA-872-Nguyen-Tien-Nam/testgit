@extends('layout')


@push('header')
	{!! public_url('template/css/form/portal.css') !!}
@endpush

@section('asset_footer')
{!!public_url('template/js/form/portal.index.js')!!}
@stop
@section('content')
<input type="hidden" class="anti_comon" name="">
<div class="container-fluid" style="overflow-y: visible" id="div_result">
    @include('Master::portal.indexRefer')
</div>
@stop