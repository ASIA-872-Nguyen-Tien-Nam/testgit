<div class="row">
    @php
        $w_1on1_authority_typ  = session_data()->w_1on1_authority_typ ?? 0;
    @endphp
    @if($w_1on1_authority_typ > 2)
        <div  class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-button-mobile link_odashboardadmin" style="margin-left:10px">
                <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('messages.admin_portal') }}</p>
        </div>
    @endif
    @if (isset($is_coach_member['is_coach']) && $is_coach_member['is_coach'] == 1 && $w_1on1_authority_typ > 1)
        <div  class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-button-mobile link_odashboard" style="{{$w_1on1_authority_typ < 3?'margin-left:10px':'margin-left:20px'}}">
                <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('messages.coach_portal') }}</p>
        </div>
    @endif
    <div class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard link_oq0010" style="{{isset($is_coach_member['is_coach']) && $is_coach_member['is_coach'] == 0 && $w_1on1_authority_typ < 3?'margin-left:10px':'margin-left:20px'}}">
            <img class="img_icon_video1" src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_03_2.png')!!}>
            <img class="img_icon_video2" style="display: none" src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_03_3.png')!!}>
        <p class="text-center">{{ __('messages.1on1_commentary') }}</p>
    </div>
</div>
<div class="clearfix"></div><!-- end .clearfix -->
<!-- 1on1日程 -->
@include('OneOnOne::odashboard.referSchedules')
<!-- アラート -->
@include('OneOnOne::odashboard.referAlerts')
<!-- 通知 -->
@include('OneOnOne::odashboard.referNotifications')
<!-- リマインド -->
<!-- {{-- @include('OneOnOne::odashboard.referReminds') --}} -->