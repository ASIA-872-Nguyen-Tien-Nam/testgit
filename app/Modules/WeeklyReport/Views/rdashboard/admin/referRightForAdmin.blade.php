<div class="clearfix"></div><!-- end .clearfix -->
<!-- 通知 -->
@if (isset($report_authority_typ) && $report_authority_typ > 0)
<div class="row mb-4">
    <div class="col-md-4 col-lg-5 col-xl-5 col-5" style="display:flex">
        
        <div class="btn-rdashboard margin-left-button-mobile link_rdashboardreporter pl-1 pr-1" style="min-width: 120px">
            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('rdashboard.rdashboard_reporter_button') }}</p>
        </div>    
        @if ($report_authority_typ > 1)
        <div  class="btn-rdashboard margin-left-button-mobile link_rdashboardapprover  pl-1 pr-1" style="margin-left:20px;min-width: 120px">
            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('rdashboard.rdashboard_approver_button') }}</p>
        </div>
        @endif
    </div>
</div>
@endif
@include('WeeklyReport::rdashboard.referNotifications')
@include('WeeklyReport::rdashboard.referReactions')
@include('WeeklyReport::rdashboard.referShare')