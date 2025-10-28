<div class="row">
    @if (isset($is_coach_member['is_coach']) && $is_coach_member['is_coach'] == 1)
        <div  class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-button-mobile link_odashboard" style="margin-left:10px">
            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('messages.coach_portal') }}</p>
        </div>
    @endif
    @if (isset($is_coach_member['is_member']) && $is_coach_member['is_member'] == 1)
        <div  class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-button-mobile link_odashboardmember" style="{{$is_coach_member['is_coach'] == 1?'margin-left:20px':'margin-left:10px'}}">
            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
            <p class="text-center">{{ __('messages.my_page') }}</p>
        </div>
    @endif
    <div class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard link_oq0010" style="{{isset($is_coach_member['is_coach']) &&($is_coach_member['is_member'] == 1 || $is_coach_member['is_coach'] == 1)?'margin-left:20px':'margin-left:10px'}}">
            <img class="img_icon_video1" src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_03_2.png')!!}>
            <img class="img_icon_video2" style="display: none" src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_03_3.png')!!}>
        <p class="text-center">{{ __('messages.1on1_commentary') }}</p>
    </div>
</div>
<div class="clearfix"></div><!-- end .clearfix -->