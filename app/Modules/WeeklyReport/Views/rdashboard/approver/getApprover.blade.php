@extends('weeklyreport/layout')

@push('header')
{!!public_url('template/css/weeklyreport/rdashboard/rdashboard.css')!!}
@endpush
@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/weeklyreport/dashboard/approver.js')!!}
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
                                <div class="col-md-12" id="left_target_member_div">
                                    @include('WeeklyReport::rdashboard.approver.referFilter')
                                </div>
                                <div class="col-md-12 mt-3 mb-3" id="left_times_member_div">
                                    @include('WeeklyReport::rdashboard.referLeftReports',['screen'=>'approver'])
                                </div>
                            </div>
                        </div><!-- end .col-md-7 -->
                        <!-- Right member content -->
                        <div class="col-md-4" id="right_member_div">
                            <div class="row mb-4">
                                <div class="col-md-4 col-lg-5 col-xl-5 col-5" style="display:flex">
                                    <div class="btn-rdashboard margin-left-button-mobile link_rdashboardreporter pl-1 pr-1" style="min-width: 120px">
                                        <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                                        <p class="text-center">{{ __('rdashboard.rdashboard_reporter_button') }}</p>
                                    </div>
                                    <div class="btn-rdashboard margin-left-button-mobile link_rdashboard pl-1 pr-1" style="margin-left:20px;min-width: 120px">
                                        <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                                        <p class="text-center">{{ __('rdashboard.rdashboard_button') }}</p>
                                    </div>
                                </div>
                            </div>
                            @include('WeeklyReport::rdashboard.approver.referRightForApprover')
                        </div>
                    </div><!-- end .row -->
                </div><!-- end .card-body -->
            </div><!-- end .card -->
        </div><!-- end .col-md-6 -->
    </div><!-- end .row -->
</div>
@stop