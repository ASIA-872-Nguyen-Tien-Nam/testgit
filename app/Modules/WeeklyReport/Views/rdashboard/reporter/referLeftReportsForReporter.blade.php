<div class="row">
    <div class="col-sm-6 col-md-6 col-lg-2 col-xl-2" style="min-width:120px;max-width:120px">
        <p style="margin-bottom: 0.5rem;">{{ __('rdashboard.year_reporter') }}</p>
        <div class="row pl-2" style="display: flex;">
            <select class="form-control col-lg-12 col-xl-12 mr-2" id="year" autofocus tabindex="1">
                <option value="-1"></option>
                @if (isset($year) && !empty($year))
                    @foreach ($year as $key => $item)
                        @if ($item == $current_year)
                        <option value="{{ $item }}" selected>{{ $item }}{{ __('rdashboard.year') }}</option>                            
                        @else
                        <option value="{{ $item }}">{{ $item }}{{ __('rdashboard.year') }}</option>
                        @endif
                    @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="col-sm-6 col-md-6 col-lg-2 col-xl-2" style="min-width:120px;max-width:120px">
        <p style="margin-bottom: 0.5rem;">&nbsp;</p>
        <div class="row pl-2" style="display: flex;">
            <select class="form-control col-lg-12 col-xl-12 mr-2" id="month" autofocus tabindex="1">
                <option value="-1"></option>
                @for ($i = 1; $i <= 12; $i++)
                    @if (isset($month) && $i == $month)
                    <option value="{{$i}}" selected>{{ str_pad($i,2,'0',STR_PAD_LEFT)}}{{ __('rdashboard.month') }}</option>        
                    @else 
                    <option value="{{$i}}">{{ str_pad($i,2,'0',STR_PAD_LEFT)}}{{ __('rdashboard.month') }}</option>
                    @endif
                @endfor    
            </select>
        </div>
    </div>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells ">
    <table class="table table-bordered table-cursor table-hover table-oneheader member-list" id="myTable">
        <thead>
            <tr>
                <th class="label_situation_reporter">{{ __('rdashboard.situation') }}</th>
                <th style="width:18%">
                    <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip"  data-original-title="{{ __('rdashboard.title') }}">
                        {{ __('rdashboard.title') }}
                    </div>
                </th>
                <th style="width:18%" data-container="body" data-html="true">
                    <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip"  data-original-title="{{ __('rdashboard.target_period') }}">
                        {{ __('rdashboard.target_period') }}
                    </div>
                </th>
                </p>
                <th class="label_weekly_fullfill_comment_reporter" colspan="2" >
                    <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{{ __('rdashboard.title') }}">
                        {{ __('rdashboard.weekly_fullfill_comment') }}
                    </div>
                </th>
                <th style="width: 55px">{{ __('rdashboard.enter') }}</th>
            </tr>
        </thead>
        <tbody>
            @if(isset($reports) && count($reports) > 0)
            @foreach($reports as $time)
            <tr class="tr_employee  {{ $time['background_color']=='1'?'pink_background':'' }}">
                <td style="width: 100px;" class="text-center">
                    {{-- 未読リアクションがある --}}
                    @if ($time['reaction_read_status'] == 1)
                    <i class="fa fa-comments" style="font-size:24px"></i>
                    @endif
                    <a href="javascript:void(0)" class="link_ri2010"
                    fiscal_year="{{ $time['fiscal_year'] }}" 
                    employee_cd="{{ $time['employee_cd'] }}" 
                    report_kind="{{ $time['report_kind'] }}" 
                    report_no="{{ $time['report_no'] }}" >
                        {{ $time['status_nm'] }}
                    </a>
                </td>
                <td class="text-left">
                    <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($time['title'])!!}">
                        {{$time['title']}}
                    </div>
                </td>
                <td class="text-center">
                    <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($time['target_period'])!!}">
                        {{$time['target_period']}}
                    </div>
                </td>
                <td class="text-center" style="min-width: 120px;max-width: 120px">
                    {{-- 充実度 --}}
                    @if (isset($time['adequacy_kbn']) && $time['adequacy_kbn'] > 0)
                        @if (isset($adequacy) && !empty($adequacy))
                            @foreach ($adequacy as $item)
                                @if ($item['mark_cd'] == $time['adequacy_kbn'])
                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
                                @endif                                                        
                            @endforeach    
                        @endif
                    @endif
                    {{-- 繁忙度 --}}
                    @if (isset($time['busyness_kbn']) && $time['busyness_kbn'] > 0)
                        @if (isset($busyness) && !empty($busyness))
                            @foreach ($busyness as $item)
                                @if ($item['mark_cd'] == $time['busyness_kbn'])
                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
                                @endif                                                        
                            @endforeach
                        @endif
                    @endif
                    {{-- その他 --}}
                    @if (isset($time['other_kbn']) && $time['other_kbn'] > 0)
                        @if (isset($other) && !empty($other))
                            @foreach ($other as $item)
                                @if ($item['mark_cd'] == $time['other_kbn'])
                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
                                @endif                                                        
                            @endforeach
                        @endif
                    @endif
                </td>
                <td>
                    <label class="form-control-plaintext txt" style="max-width: 300px">
                        <div class="text-overfollow" style="width:90%" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!! nl2br($time['free_comment']) !!}">
                            {{$time['free_comment']}}
                        </div>
                    </label>
                </td>
                <td class="text-center" style="min-width : 50px; max-width: 50px;">
                    <input type="hidden" class="employee_data" fiscal_year="{{ $time['fiscal_year'] }}" employee_cd="{{ $time['employee_cd'] }}" report_kind="{{ $time['report_kind'] }}" report_no="{{ $time['report_no'] }}">
                    <i class="fa fa-pencil icon-pencil link_ri2010"
                        fiscal_year="{{ $time['fiscal_year'] }}" 
                        employee_cd="{{ $time['employee_cd'] }}" 
                        report_kind="{{ $time['report_kind'] }}" 
                        report_no="{{ $time['report_no'] }}"
                        aria-hidden="true"></i>
                </td>
            </tr>
            @endforeach
            @else
            <tr>
                <td colspan="6" class="text-center">{{ $_text[21]['message'] }}</td>
            </tr>
            @endif
        </tbody>
    </table>
</div>