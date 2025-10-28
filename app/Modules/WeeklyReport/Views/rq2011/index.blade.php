@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/rq2011/rq2011.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/weeklyreport/rq2011/rq2011.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['addNewSignupButton','saveButton', 'deleteButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="row">
            <div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
                <div class="inner">
                    @include('WeeklyReport::rq2011.leftcontent')
                </div> <!-- end .inner -->
            </div> <!-- end #leftcontent -->
            <div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
                <div class="inner">
                    @include('WeeklyReport::rq2011.rightcontent')
                </div> <!-- end #rightcontent -->
            </div>
        </div>
    </div>
    <input type="hidden" id="fiscal_year" value="{{$fiscal_year_today??0}}">
@stop
