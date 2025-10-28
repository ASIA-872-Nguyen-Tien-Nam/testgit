@extends('weeklyreport/layout')

@push('header')
{!!public_url('template/css/weeklyreport/rdashboard/rdashboard.css')!!}
@endpush
@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/weeklyreport/dashboard/rdashboard.index.js')!!}
@stop

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card pe-w">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8" id="member_div">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    @include('WeeklyReport::rdashboard.admin.referFilter')
                                    <div id="left_times_viewer_div">
                                        @include('WeeklyReport::rdashboard.referLeftReports',['screen'=>'admin'])
                                    </div>
                                </div>
                            </div>
                        </div><!-- end .col-md-7 -->
                        <div class="col-md-4" id="right_member_div">
                            @include('WeeklyReport::rdashboard.admin.referRightForAdmin')
                        </div>
                    </div><!-- end .row -->
                </div><!-- end .card-body -->
            </div><!-- end .card -->
        </div><!-- end .col-md-6 -->
    </div><!-- end .row -->
</div>
@stop