@section('asset_header')
{!!public_url('template/css/weeklyreport/rq2010/rq2010.index.css')!!}
@stop
@extends('weeklyreport/layout')
@push('asset_button')
@if(isset($report_authority_typ))
@if($report_authority_typ > 2)
{!!
Helper::dropdownRenderWeeklyReport(['downloadButton', 'deleteButton','backButton'])
!!}
@else
{!!
Helper::dropdownRenderWeeklyReport(['downloadButton','backButton'])
!!}
@endif
@endif
@endpush
@section('asset_footer')
<!-- START LIBRARY JS -->

{!!public_url('template/js/weeklyreport/rq2010/rq2010.index.js')!!}
@stop
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
    <div class="card box-search-card-common">
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5"></div>
                <div class="col-md-7 col-7">
                    <button type="button" class="btn button-card"><span><i class="fa fa-chevron-down"></i></span>{{__('rq2010.set_to_private')}}</button>
                </div>
            </div>
            <br>
            <input type="hidden" class="anti_tab" name="">
            <div class="row">
                <div class="col-md-4 col-lg-4 col-xl-2" style="padding-right: 32px;min-width:295px">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('rq2010.fiscal_year')}}</label>
                        <div style="display: flex;">
                            <div class="input-group-btn input-group col-6" style="padding-left:0px;padding-right:0px">
                                <input type="text" class="form-control right-radius month required" style="min-width: 125px;height:38px;" placeholder="yyyy/mm" value="{{ $year_month_from ?? '' }}" tabindex="1" autofocus id="year_month_from">
                            </div>
                            <div class="span-symbol">~</div>
                            <div class="input-group-btn input-group col-6" style="padding-left:0px;padding-right:0px">
                                <input type="text" class="form-control right-radius month required" style="min-width: 125px;height:38px;" placeholder="yyyy/mm" value="{{ $year_month_to ?? '' }}" tabindex="1" id="year_month_to">
                            </div>

                        </div>
                    </div><!--/.form-group -->
                </div>
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3" id="select_type" style="min-width:160px;">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('rq2020.report_type') }}</label>
                        <select id="report_kind" class="required form-control report_kind" autofocus tabindex='3'>
                        <option value="-1"></option>
                            @if (isset($report_kinds))
                            @foreach ($report_kinds as $row)	
                            <option value="{{ $row['report_kind'] }}">{{ $row['report_nm'] }}</option>
                            @endforeach
                            @endif
                        </select>
                    </div>
                </div>
                @if(isset($report_authority_typ))
                @if($report_authority_typ >= 3)
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.group') }}</label>
                    <select class="form-control" id="group" tabindex="4">
                        <option value="-1"></option>
                        @if (isset($group))
                        @foreach ($group as $group)	
						<option value="{{ $group['group_cd'] }}">{{ $group['group_nm'] }}</option>
						@endforeach
						@endif
                    </select>
                </div>
                @else
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3" hidden>
                    <label class="control-label">{{ __('rq2010.group') }}</label>
                    <select class="form-control" id="group" tabindex="4">
                        <option value="-1"></option>
                    </select>
                </div>
                @endif
                @else
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3" hidden>
                    <label class="control-label">{{ __('rq2010.group') }}</label>
                    <select class="form-control" id="group" tabindex="4">
                        <option value="-1"></option>
                    </select>
                </div>
                @endif
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.my_group') }}</label>
                    <select class="form-control" id="my_group" tabindex="5">
                    <option value="-1"></option>
                    @if (isset($my_group[0]))
                        @foreach ($my_group as $my_group)	
						<option value="{{ $my_group['mygroup_cd'] }}">{{ $my_group['mygroup_nm'] }}</option>
						@endforeach
						@endif
                    </select>
                </div>
                
            </div><!-- end .card-body -->
            {{-- 状況 --}}
            <div class="row">
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <div class="form-group">
                        <label class="control-label text-overfollow" data-toggle="tooltip" data-container="body" data-original-title="" style="display: block;">
                            {{ __('rq2010.situation') }}
                        </label>
                        <div class="multi-select-full">
                            <select name="" id="status" class="form-control status multiselect" tabindex="6" organization_typ='1' multiple="multiple">
                                @if (isset($L0041))
                                    @foreach ($L0041 as $status)	
                                    <option value="{{ $status['status_cd'] }}">{{ $status['status_nm'] }}</option>
                                    @endforeach
                                    @endif
                            </select>
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.sticky_note') }}</label>
                    <select class="form-control" id="note_kind" tabindex="7">
                        <option value="-1"></option>
                            @if (isset($M4101))
                                @foreach ($M4101 as $note)
                                    @if ($note['note_kind'] == 1)
                                    <option value="{{ $note['note_no'] }}">{{ $note['note_name'] }}</option>                                    
                                    @endif	
                                @endforeach
                                @endif
                            </select>
                    </select>
                </div>
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.free_word') }}</label>
                    <input type="text" id="free_word" tabindex="8" class="form-control indexTab" placeholder="回答・コメント・リアクション内の合致したワード" />
                </div>
                <div class="col-sm-6 col-md-3 col-lg-1 col-xl-1" style="min-width:120px">
                    <div class="form-group">
                        <label class="control-label">{{ __('rq2010.adequacy') }}</label>
                        <dl id="adequacy" class="dropdown">
                            <table tabindex="8">
                                <tbody>
                                    <tr>
                                        <td style="padding: 0px" class="has-weather">
                                            <dt style="min-height: 38px;max-height: 38px;">
                                                <a href="#" style="height: 36px; border-color:#ced4da">
                                                    <span class="img-selected" style="height: 36px">
                                                        <input type="hidden" class="fullfillment_type" value="-1">
                                                        <img src="" style="height:36px" width="100%">
                                                    </span>
                                                </a>
                                            </dt>
                                            <dd>
                                                <ul style="z-index: 99; display: block;display: none;">
                                                <li>
                                                        <a href="#" title="Select this card"  style="height:36px">
                                                            <input type="hidden" class="adequacy" value="-1">
                                                            <img src="" width="100%"  style="height:36px">
                                                        </a>
                                                    </li>
                                                @if (isset($adequacy[0]))
                                                    @foreach ($adequacy as $adequacy)	
                                                    
                                                    <li>
                                                        <a href="#" title="Select this card">
                                                            <input type="hidden" class="adequacy" value="{{$adequacy['item_no']}}">
                                                            <img src="/template/image/icon/weeklyreport/{{$adequacy['remark1']}}" width="100%">
                                                        </a>
                                                    </li>
                                                    @endforeach
                                                @endif
                                                    
                                                </ul>
                                            </dd>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </dl>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 col-lg-1 col-xl-1" style="min-width:120px">
                    <div class="form-group">
                        <label class="control-label">{{ __('rq2010.busyness') }}</label>
                        <dl id="busyness" class="dropdown">
                            <table tabindex="8">
                                <tbody>
                                    <tr>
                                        <td style="padding: 0px" class="has-weather">
                                            <dt style="min-height: 38px;max-height: 38px;">
                                                <a href="#" style="height: 36px; border-color:#ced4da">
                                                    <span class="img-selected" style="height: 36px;">
                                                        <input type="hidden" class="fullfillment_type" value="-1">
                                                        <img src=""width="100%">
                                                    </span>
                                                </a>
                                            </dt>
                                            <dd>
                                                <ul style="z-index: 99; display: block;display: none;">
                                                <li>
                                                        <a href="#" title="Select this card"  style="height:36px">
                                                            <input type="hidden" class="busyness" value="-1">
                                                            <img src="" width="100%"  style="height:36px">
                                                        </a>
                                                    </li>
                                                @if (isset($busyness[0]))
                                                    @foreach ($busyness as $busyness)	
                                                    
                                                    <li>
                                                        <a href="#" title="Select this card">
                                                            <input type="hidden" class="busyness" value="{{$busyness['item_no']}}">
                                                            <img src="/template/image/icon/weeklyreport/{{$busyness['remark1']}}" width="100%">
                                                        </a>
                                                    </li>
                                                    @endforeach
                                                @endif
                                                    
                                                </ul>
                                            </dd>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </dl>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3 col-lg-1 col-xl-1" style="min-width:120px">
                    <div class="form-group">
                        <label class="control-label">{{ __('rq2010.other') }}</label>
                        <dl id="other" class="dropdown">
                            <table tabindex="8">
                                <tbody>
                                    <tr>
                                        <td style="padding: 0px" class="has-weather">
                                            <dt style="min-height: 38px;max-height: 38px;">
                                                <a href="#" style="height: 36px;  border-color:#ced4da">
                                                    <span class="img-selected" style="height: 36px;">
                                                        <input type="hidden" class="fullfillment_type" value="-1">
                                                        <img src="" width="100%">
                                                    </span>
                                                </a>
                                            </dt>
                                            <dd>
                                                <ul style="z-index: 99; display: block;display: none;">
                                                <li>
                                                        <a href="#" title="Select this card"  style="height:36px">
                                                            <input type="hidden" class="other" value="-1">
                                                            <img src="" width="100%"  style="height:36px">
                                                        </a>
                                                    </li>
                                                @if (isset($other[0]))
                                                    @foreach ($other as $other)	
                                                    <li>
                                                        <a href="#" title="Select this card">
                                                            <input type="hidden" class="other" value="{{$other['item_no']}}">
                                                            <img src="/template/image/icon/weeklyreport/{{$other['remark1']}}" width="100%">
                                                        </a>
                                                    </li>
                                                    @endforeach
                                                @endif
                                                    
                                                </ul>
                                            </dd>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </dl>
                    </div>
                </div>
                <div class="col-sm-6 col-md-6 col-lg-4 col-xl-2">
                    <label class="control-label col-md-remove">&nbsp;</label>
                    <div>
                        <div id="bor_authority" class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
                            <label class="container" style="padding-right:0px" for="is_shared">{{ __('rq2010.shared_report') }}
                                <input type="checkbox" name="ck1" id="is_shared" value="1" tabindex="9" />
                                <span class="checkmark" style="top: 0px !important;left: 0px !important;right:unset"></span>
                            </label>
                        </div>
                    </div>
                </div>

            </div>

            <div class="row mb-3">
                @if (isset($M0022) && !empty($M0022))
                    @foreach($M0022 as $item)
                        @if($item['organization_step'] == 1)
                            <div class="col-md-2 col-lg-2 col-xl-2">
                                <div class="form-group">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem; color:#707070 !important;max-width:240px">{{$item['organization_group_nm']}}</div>
                                    <div class="multi-select-full">
                                        <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd1" multiple="multiple">
                                            @foreach($M0020 as $temp)
                                            <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                            </div>
                        @else
                            <div class="col-md-2 col-lg-2 col-xl-2">
                                <div class="form-group">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem; color:#707070 !important;max-width:240px">{{$item['organization_group_nm']}}</div>
                                    <div class="multi-select-full">
                                            <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd{{$item['organization_step']}}" multiple="multiple">
                                            </select>
                                        </div>
                                </div>
                            </div>
                        @endif
                    @endforeach    
                    @endif
            </div>
            <div class="row">
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.director') }}</label>
                    <select class="form-control" id="position" tabindex="15">
                        <option value="-1"></option>
                                @if (isset($position))
                                @foreach ($position as $position)	
                                    <option value="{{ $position['position_cd'] }}">{{ $position['position_nm'] }}</option>
                                @endforeach
                                @endif
                    </select>
                </div>
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.occupation') }}</label>
                    <select class="form-control" id="job" tabindex="16">
                    <option value="-1"></option>
                                @if (isset($job))
                                @foreach ($job as $job)	
                                    <option value="{{ $job['job_cd'] }}">{{ $job['job_nm'] }}</option>
                                @endforeach
                                @endif
                    </select>
                </div>
                <div class="col-md-12 col-lg-2 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.grade') }}</label>
                    <select class="form-control" id="grade" tabindex="17">
                    <option value="-1"></option>
                                @if (isset($grade))
                                @foreach ($grade as $grade)	
                                    <option value="{{ $grade['grade'] }}">{{ $grade['grade_nm'] }}</option>
                                @endforeach
                                @endif
                    </select>
                </div>
                <div class="col-md-12 col-lg-3 col-xl-2 select-row mb-3">
                    <label class="control-label">{{ __('rq2010.employee_classification') }}</label>
                    <select class="form-control" id="employee_typ" tabindex="18">
                        <option value="-1"></option>
                                @if (isset($employee_typ))
                                @foreach ($employee_typ as $employee_typ)	
                                    <option value="{{ $employee_typ['employee_typ'] }}">{{ $employee_typ['employee_typ_nm'] }}</option>
                                @endforeach
                                @endif
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6 col-md-3 col-lg-2">
                    <label class="control-label">{{ __('rq2010.reporter') }}</label>
                    <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden reporter_cd" id="reporter_cd" value="" />
                                    <input type="text" id="reporter_nm" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab employee_nm_weeklyreport"  tabindex="19" maxlength="101" value="" />
								</span>
								<div class="input-group-append-btn">
                            
                                    <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>

								</div>
                            </div>
                </div>
                <div class="col-sm-6 col-md-3 col-lg-2">
                    <label class="control-label">{{ __('rq2010.approver') }}</label>
                    <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden approver_cd" id="approver_cd" value="" />
                                    @if(isset($system))
                                    @if ($system == 1 || $system == 4)
                                    <input type="text" id="employee_nm" class="form-control indexTab employee_nm"  tabindex="19" maxlength="101" value="" />    
                                    @elseif ($system == 2)
                                    <input type="text" fiscal_year_1on1="{{ $fiscal_year ?? 0 }}" id="employee_nm" class="form-control indexTab employee_nm_1on1"  tabindex="19" maxlength="101" value="" />
                                    @elseif ($system == 3)
                                    <input type="text" fiscal_year_mulitireview="{{ $fiscal_year ?? 0 }}" id="employee_nm" class="form-control indexTab employee_nm_mulitireview"  tabindex="19" maxlength="101" value="" />
                                    @elseif ($system == 5)
                                    <input type="text" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" id="employee_nm" class="form-control indexTab employee_nm_weeklyreport"  tabindex="19" maxlength="101" value="" />
                                    @endif
                                    @endif
								</span>
								<div class="input-group-append-btn">
                                    @if(isset($system))
                                    @if ($system == 1 || $system == 4)
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 2)
                                    <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 3)
                                    <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 5)
                                    <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @endif
                                    @endif
								</div>
                            </div>
                </div>
                <div class="col-sm-6 col-md-3 col-lg-8">
                <label class="control-label">&nbsp</label>
                            <div id="button_search" class="form-group">
                                <div class="full-width">
                                    <a href="javascript:;" class="btn btn-outline-primary btn-outline-primary_search" tabindex="20" id="search_company" tabindex="-1">
                                        <i class="fa fa-search"></i>
                                        {{__('messages.search')}}
                                    </a>
                                </div><!-- end .full-width -->
                            </div>

                </div>
            </div>
        </div><!-- end .card -->
    </div>
    <div class="card">
        <div id="result">
            @include('WeeklyReport::rq2010.refer')
        </div>
    </div><!-- end .card -->
    @php
    $language = Config::get('app.locale');
    @endphp
    <input type="hidden" id="language_jsq0100" value="{{$language}}">
    <input type="hidden" value="{{isset($cache['page'])?$cache['page']:''}}" id="history_page" />
    <input type="hidden" value="{{isset($cache['page_size'])?$cache['page_size']:''}}" id="history_page_size" />
    <input type="hidden" id="system" value="5" />
	<input type="hidden" id="fiscal_year" value="{{ $fiscal_year }}" />
</div><!-- end .container-fluid -->
</div>

@stop