@extends('layout')


@push('header')
	{!! public_url('template/css/form/portal.css') !!}
@endpush

@section('asset_footer')
{!!public_url('template/js/form/portal.evaluator.js')!!}
@stop

@section('content')

<div class="container-fluid" id="div_result">
    @include('Master::portal.EvaluatorRefer')
</div>
@stop