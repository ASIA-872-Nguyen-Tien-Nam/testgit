@extends('mlayout')
 
@push('header')
{!!public_url('template/css/mulitiview/mdashboard/mdashboard.index.css')!!}
@endpush

@section('asset_footer')
{!! public_url('template/js/mulitiview/mdashboard/manager.index.js') !!}
@stop

@section('content')
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div id="result">
                @include('Multiview::mdashboard.manager.search')
            </div>
        </div>
    </div>
    <input type="hidden" class="anti_tab">
</div>
@stop