@if(isset($times) && count($times) > 0)
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells ">
    <table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder member-list" id="myTable">
        <thead>
            <tr>
                <th colspan="8" class="w-120px ">{{ __('messages.1on1_history') }}</th>
            </tr>
            <tr>
                <th style="min-width: 50px; max-width:50px">{{ __('messages.number_times') }}</th>
                <th class="w-120px ">{{ __('messages.title') }}</th>
                <th style="min-width: 100px">{{ __('messages.execute_plan_date') }}</th>
                <th class="w-120px" style="min-width: 70px;">{{ __('messages.coach') }}</th>
                <th style="min-width: 92px;max-width: 92px;">{{ __('messages.questionnaire') }}</th>
                <th style="min-width: 60px;">{{ __('messages.mark') }}</th>
                <th class="w-120px "> {{ __('messages.next_action') }}</th>
                <th class="w-120px ">{{ __('messages.coach_comment') }}</th>
            </tr>
        </thead>
        <tbody>
            @foreach($times as $time)
            <tr class="tr_employee" coach_cd            = {{$time['coach_cd']}}
                                    employee_cd         = {{$time['employee_cd']}}
                                    group_cd_1on1       = {{$time['w_1on1_group_cd']}}
                                    times               = {{$time['times']}}>
                <td class="text-center">
                    <a href="" class="link_oi2010">{{ $time['times'] }}</a>
                </td>
                <td class="w-120px invi_head">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($time['title'])!!}">
                            {{$time['title']}}
                        </div>
                    </label>
                </td>
                <td class="text-center">
                    <label class="form-control-plaintext txt">
                        <div>
                            {{$time['interview_date']}}
                        </div>
                    </label>
                </td>
                <td class="w-120px invi_head">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!! nl2br($time['coach_cd_nm']) !!}">
                        {{$time['coach_cd_nm']}}
                        </div>
                    </label>
                </td>
                <td class="text-center">
                        @if($time['is_questionnaire_cd'] == 1)
                            <i class="fa fa-pencil fa-fw fa-disable" aria-hidden="true"></i>
                        @elseif($time['is_questionnaire_cd'] == 2)
                            <span class=" oi3010_link" times= "{{$time['times']}}" questionnaire_cd="{{$time['questionnaire_cd']}}"><i class="fa fa-pencil fa-fw fa-active" aria-hidden="true"></i></span>
                        @endif
                </td>
                <td class="invi_head text-center">
                    @if($time['fullfillment_type'] > 0)
                    <img src="/uploads/ver1.7/odashboard/{{$combo_remark[$time['fullfillment_type']]['remark1']}}" width=40px/>
                    @endif
                </td>
                <td class="w-120px invi_head">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!! nl2br($time['next_action']) !!}">
                            {{$time['next_action']}}
                        </div>
                    </label>
                </td>
                <td class="w-120px invi_head">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body"  data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($time['coach_comment1'])!!}">
                            {{$time['coach_comment1']}}
                        </div>
                    </label>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@else
<ul class="breadcrumb-arrow-noData">
    <div class="div-bar" style="width:100%;background-color: rgba(0,0,0,.05);">
        <li class="text-center">
            {{ $_text[21]['message'] }}
        </li>
    </div>
</ul>
@endif