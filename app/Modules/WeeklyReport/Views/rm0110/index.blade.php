@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/rm0110/rm0110.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/weeklyreport/rm0110/rm0110.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['saveButton', 'deleteButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card pe-w">
            <div class="card-body">
                <div id="body-inner">
                    @include('WeeklyReport::rm0110.refer')
                </div>
            </div>
            <div class="row justify-content-md-center">
                {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
            </div>
        </div>
    </div>
@stop
