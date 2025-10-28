{{-- 承認者の場合はこのタプを表示する --}}
@if (isset($screen) && $screen == 'approver')
    @if (isset($report_kinds) && !empty($report_kinds))
    <ul style="margin-left:0px" class="nav nav-tabs tab-style">    
        @foreach ($report_kinds as $key => $value)
        @if ($key == 0)
        <li class="nav-item" tab_index="{{$key+1}}">
            <a class="nav-link hei active show" data-toggle="tab" href="#tab{{$key+1}}" role="tab" aria-selected="true">
                {{ $value['report_name'] }}
                <div class="caret"></div>
            </a>
        </li>    
        @else 
        <li class="nav-item" tab_index="{{$key+1}}">
            <a class="nav-link hei" data-toggle="tab" href="#tab{{$key+1}}" role="tab">
                {{ $value['report_name'] }}
                <div class="caret"></div>
            </a>
        </li>
        @endif
        @endforeach
    </ul>
    @endif 
@endif
{{-- タプ明細 --}}
@if(isset($report_kinds) && count($report_kinds) > 0)
<div class="tab-content">
    @foreach ($report_kinds as $key => $report_kind)
        <div class="tab-pane fade {{ $key == 0 ? 'active show' : '' }}" id="tab{{ $key + 1 }}">
            <div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells ">
                <table class="table table-bordered table-cursor table-hover table-oneheader member-list" id="myTable">
                    <thead>
                        <tr>
                            <th class="label_filling_date">
                                <p style="width:90%; margin-left:5%;margin-bottom:0px" class="text-overfollow" data-toggle="tooltip" data-original-title="{{ __('rdashboard.filing_date') }}">{{ __('rdashboard.filing_date') }}</p>
                            </th>
                            <th class="label_reporter" data-container="body" data-html="true">
                                <div style="width:90%; margin-left:5%;margin-bottom:0px" class="text-overfollow"  data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ __('rdashboard.reporter') }}">
                                    {{ __('rdashboard.reporter') }}
                                </div>
                            </th>
                            <th class="label_title" data-container="body" data-html="true">
                                <p style="width:90%; margin-left:5%;margin-bottom:0px" class="text-overfollow" data-toggle="tooltip" data-original-title="{{ __('rdashboard.title') }}">{{ __('rdashboard.title') }}</p>
                            </th>
                            @if (isset($screen) && $screen == 'approver')
                            <th class="label_status">
                                <p style="margin-left:5%;margin-bottom:0px" class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ __('rdashboard.status') }}">{{ __('rdashboard.status') }}</p>
                            </th>
                            @endif
                            <th class="label_adequacy">
                                <p style="width:90%; margin-left:5%;margin-bottom:0px" class="text-overfollow" data-toggle="tooltip" data-original-title="{{ __('rdashboard.adequacy') }}">{{ __('rdashboard.adequacy') }}</p>
                            </th>
                            @if (isset($screen) && $screen == 'approver')
                            <th class="label_approval">
                                <p style=" margin-left:5%;margin-bottom:0px" class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ __('rdashboard.approval') }}">{{ __('rdashboard.approval') }}</p>
                            </th>
                            @else
                            <th class="label_approval">
                                <p style=" margin-left:5%;margin-bottom:0px" class="text-overfollow" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ __('rdashboard.confirm') }}">{{ __('rdashboard.confirm') }}</p>
                            </th>
                            @endif
                            <th class="label_comment">
                                <div style=" margin-bottom:0px" class="text-overfollow" data-placement="bottom" data-container="body" data-toggle="tooltip" data-original-title="{{ __('rdashboard.comment') }}">{{ __('rdashboard.comment') }}</div>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        @if (isset($reports[$key]) && count($reports[$key]) > 0)
                            @foreach ($reports[$key] as $item)
                            @php
                                $tr_class = '';
                                if ($screen == 'approver' && $item['submit_status'] == 0) {
                                    $tr_class = 'row_disabled';
                                }else if($screen == 'approver' && $item['approver_not_approved'] == 1){
                                    $tr_class = 'shared';
                                }else if ($screen == 'admin' && $item['sharewith_status'] == 1) {
                                    $tr_class = 'shared';
                                }
                            @endphp
                            <tr class="tr_employee {{ $tr_class ?? '' }}">
                                <td class="text-left">
                                <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($item['submission_datetime'] ?? '')!!}">
                                        {{ $item['submission_datetime'] ?? '' }}
                                    </div>
                                </td>
                                <td class="label_reporter">
                                    <label class="form-control-plaintext txt">
                                        <div class="" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ $item['employee_nm'] ?? '' }}">
                                            {{$item['employee_nm'] ?? ''}}
                                        </div>
                                    </label>
                                </td>
                                <td>
                                    <label class="form-control-plaintext txt" style="width:90%;padding-bottom: 6px;padding-top: 0px;">
                                        <div data-container="body" data-html="true">
                                            @if (($screen == 'approver' && $item['submit_status'] == 1 && $item['approver_can_link'] == 1) || ($screen != 'approver' && $item['submit_status'] == 1))
                                                <a class="link_ri2010"
                                                fiscal_year="{{ $item['fiscal_year'] }}" 
                                                employee_cd="{{ $item['employee_cd'] }}" 
                                                report_kind="{{ $item['report_kind'] }}" 
                                                report_no="{{ $item['report_no'] }}" href="#">{{ $item['title'] ?? '' }}</a>
                                            @else
                                                {{ $item['title'] ?? '' }}
                                            @endif
                                            {{-- 未読リアクションがある --}}
                                            @if ($item['reaction_read_status'] == 1)
                                            <i class="fa fa-comments" style="font-size:30px"></i>                                                
                                            @endif
                                        </div>
                                    </label>
                                </td>
                                @if (isset($screen) && $screen == 'approver')
                                <td class="text-center">
                                    <label class="form-control-plaintext txt">
                                        <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ $item['status_nm'] ?? '' }}">
                                            {{ $item['status_nm'] ?? '' }}
                                        </div>
                                    </label>
                                </td>
                                @endif
                                <td class="w-40px invi_head text-center label_icon_rdashboard">
                                    {{-- 充実度 --}}
                                    @if (isset($item['adequacy_kbn']) && $item['adequacy_kbn'] > 0)
                                        @if (isset($adequacy) && !empty($adequacy))
                                            @foreach ($adequacy as $value)
                                                @if ($value['mark_cd'] == $item['adequacy_kbn'])
                                                <img src="/template/image/icon/weeklyreport/{{ $value['remark1'] ?? '' }}" width=40px />        
                                                @endif                                                        
                                            @endforeach    
                                        @endif
                                    @endif
                                    {{-- 繁忙度 --}}
                                    @if (isset($item['busyness_kbn']) && $item['busyness_kbn'] > 0)
                                        @if (isset($busyness) && !empty($busyness))
                                            @foreach ($busyness as $value)
                                                @if ($value['mark_cd'] == $item['busyness_kbn'])
                                                <img src="/template/image/icon/weeklyreport/{{ $value['remark1'] ?? '' }}" width=40px />        
                                                @endif                                                        
                                            @endforeach
                                        @endif
                                    @endif
                                    {{-- その他 --}}
                                    @if (isset($item['other_kbn']) && $item['other_kbn'] > 0)
                                        @if (isset($other) && !empty($other))
                                            @foreach ($other as $value)
                                                @if ($value['mark_cd'] == $item['other_kbn'])
                                                <img src="/template/image/icon/weeklyreport/{{ $value['remark1'] ?? '' }}" width=40px />        
                                                @endif                                                        
                                            @endforeach
                                        @endif
                                    @endif
                                </td>
                                <td class="text-center">
                                    <label class="form-control-plaintext txt">
                                        <div class="text-overfollow" data-container="body" data-html="true">
                                            @if (isset($screen) && $screen == 'approver')
                                            {{ $item['approver_status'] }}
                                            @else
                                            {{ $item['viewer_status'] }}
                                            @endif
                                        </div>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="form-control-plaintext txt">
                                        <div class="text-overfollow" data-container="body" data-html="true">
                                            {{ $item['reaction_status'] }}
                                        </div>
                                    </label>
                                </td>
                            </tr>    
                            @endforeach
                        @else
                            <tr>
                                <td colspan="{{ $screen == 'approver' ? 7 : 6 }}" class="text-center">
                                    {{ $_text[21]['message'] }}
                                </td>
                            </tr>
                        @endif
                    </tbody>
                </table>
            </div>
        </div>
    @endforeach
</div>
@endif