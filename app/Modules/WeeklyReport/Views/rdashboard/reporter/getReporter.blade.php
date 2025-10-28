@extends('weeklyreport/layout')
@push('header')
{!!public_url('template/css/weeklyreport/rdashboard/rdashboard_reporter.css')!!}
@endpush
@section('asset_footer')
{!!public_url('template/js/weeklyreport/dashboard/reporter.js')!!}
@stop
@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card pe-w">
                <div class="card-body" style="padding-top: 16px;">
                    <div class="row">
                        <div class="col-md-8" id="member_div">
                            <!-- Target -->
                            <div class="row">
                                <div class="col-md-12" id="left_target_member_div">
                                    @include('WeeklyReport::rdashboard.reporter.referTargetReporter')
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 mt-3 mb-3" id="left_times_member_div">
                                    @include('WeeklyReport::rdashboard.reporter.referLeftReportsForReporter')
                                </div>
                            </div>
                        </div><!-- end .col-md-7 -->
                        <!-- Right member content -->
                        <div class="col-md-4" id="right_member_div">
                            <div class="row mb-4">
                                <div class="col-md-4 col-lg-5 col-xl-5 col-5" style="display:flex">
                                    {{-- login user is report then dont show approver dashboard --}}
                                    @if (isset($report_authority_typ) && $report_authority_typ != 1)
                                    <div class="btn-rdashboard margin-left-button-mobile link_rdashboardapprover pl-1 pr-1" style="min-width: 120px" tabindex="3">
                                        <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                                        <p class="text-center">{{ __('rdashboard.rdashboard_approver_button') }}</p>
                                    </div>    
                                    @endif
                                    <div  class="btn-rdashboard margin-left-button-mobile link_rdashboard pl-1 pr-1" style="margin-left:20px;min-width: 120px" tabindex="4">
                                        <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                                        <p class="text-center">{{ __('rdashboard.rdashboard_button') }}</p>
                                    </div>
                                </div>
                            </div>
                            @include('WeeklyReport::rdashboard.reporter.referRightForReporter')
                        </div>
                    </div><!-- end .row -->
                </div><!-- end .card-body -->
            </div><!-- end .card -->
        </div><!-- end .col-md-6 -->
    </div><!-- end .row -->
</div>
@stop