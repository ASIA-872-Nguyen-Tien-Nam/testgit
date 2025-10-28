@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
    function period($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'Period';
    else
        return  $message;
	}
	@endphp
<div class="row">
<div class="col-lg-6 col-xl-6 dash_hyouka_left">
   <div class="form-group">
    <select name="" id="list_fiscal_year" class="form-control input-sm  list_fiscal_year" tabindex="1">
        @foreach($list_fiscal_year as $item)
        <option value="{{$item['fiscal_year']}}"   {{isset($current_year)&&($current_year == $item['fiscal_year']) ? 'selected' : ''}}>
           {{$item['fiscal_year_nm']}}
       </option>
       @endforeach
   </select>
</div>
<div class=" col-lg-12 col-xl-12 hyouka-left_stepBox">
   <ul style="overflow-y: auto; max-height: 80vh;">
        @if($list_status)
        @foreach($list_status as $item)
        <li class="left_stepBox_wrap {{$item['borderStep']}} list_status" screen_refer="{{$item['screen_refer']}}" fiscal_year="{{$item['fiscal_year']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}">
            <a href="#">
                <div class="left-stepBox_step {{$item['circleStep']}}">
                    <span class="stepName {{$item['colorStep']}}">STEP</span>
                    <span class="stepNamber {{$item['colorStep']}}">{{$item['status_cd']}}</span>
                </div>
                <div class="left-stepBox_shosai">
                    <b>
                        <span class="{{$item['colorStep']}}">{{$item['status_nm']}}</span>
                        {{$item['sheet_nm']}}
                    </b>
                    <ul>
                        <li>
                            <span>{{ __('messages.fiscal_year') }}</span>{{$item['fiscal_year']}}{{year_english(__('messages.fiscal_year'))}}
                        </li>
                        <li>
                            <span>{{ __('messages.rater') }}</span>
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['rater_employee_nm_1']}}">
                                {{$item['rater_employee_nm_1']}}
                            </div>
                        </li>
                        <li>
                        <span>{{ period(__('messages.period')) }}</span>{{$item['period_date']}}
                        </li>
                    </ul>
                </div>
            </a>
        </li>
        @endforeach
        @else
        <li class="left_stepBox_wrap text-center">
             {{app('messages')->getText(21)->message}}
        </li>
        @endif
        </ul>
    </div>
</div>

<div class="col-lg-6 col-xl-6 dash_hyouka_right">
    <div class="hyouka-right_Box">
        <div class="p-title mb-0">
            <h4 class="block"><i class="fa fa-file-text-o fa-flip-vertical"></i> {{ __('messages.list_of_sheets_to_be_evaluated') }}</h4>
        </div><!-- end .p-title -->
        <div class="row" style="padding-top:1.5rem">
                <div class="col-md-12 col-lg-3 col-xl-3 select-row mb-3">
                    <div class="form-group">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.evaluation_typ') }}" style="margin-bottom: .5rem;max-width:240px">{{ __('messages.evaluation_typ') }}</div>
                        <select id="evaluation_typ" tabindex="1"  class="form-control evaluation_typ" autofocus tabindex='3'>
                        <option value="-1"></option>
                            <option {{$evaluation_typ == 1?'selected':''}} value="1">{{__('messages.target_management')}}</option>
                            <option {{$evaluation_typ == 2?'selected':''}} value="2">{{__('messages.qualitative_evaluation')}}</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-12 col-lg-3 col-xl-3 select-row mb-3">
                    <div class="form-group">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.evaluation_stage') }}" style="margin-bottom: .5rem;max-width:240px">{{ __('messages.evaluation_stage') }}</div>
                        <select id="evaluation_stage" tabindex="1"  class="form-control status_cd" autofocus tabindex='3'>
                        <option value="-1"></option>
                        @if(isset($evaluation_stage_option[0]))
                        @foreach($evaluation_stage_option as $stage_option)
                            <option value="{{$stage_option['status_cd']}}">{{$stage_option['status_nm']}}</option>
                        @endforeach
                        @endif
                        </select>
                    </div>
                </div>
                <div class="col-md-12 col-lg-3 col-xl-3 select-row mb-3">
                    <div class="form-group">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.period_dashboard') }}" style="margin-bottom: .5rem;max-width:240px">{{ __('messages.period_dashboard') }}</div>
                        <select id="period" tabindex="1"  class="form-control status" autofocus tabindex='3'>
                        <option value="-1"></option>
                        @foreach($M0101 as $temp)
                            <option value="{{$temp['detail_no']}}">{{$temp['period_nm']}}</option>
                        @endforeach
                        </select>
                    </div>
                </div>
        </div>
        <div class="row mb-3">     
            @if (isset($M0022) && !empty($M0022))
                    <div class="ol-md-12 col-lg-3 col-xl-3 select-row mb-3">
                        <div class="form-group">
                            <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$M0022[0]['organization_group_nm']}}" style="max-width: 190px;    display: block">
                                {{$M0022[0]['organization_group_nm']}}
                            </label>
                                <select id="organization_step{{$M0022[0]['organization_step']}}" organization_typ="{{$M0022[0]['organization_typ']}}" tabindex="8" class="form-control  organization_cd1" >
                                    <option value="-1"></option>
                                    @foreach($M0020 as $temp)
                                    <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                    @endforeach
                                </select>
                        </div>
                    </div>
                    @if(isset($M0022[1]))
                    <div class="ol-md-12 col-lg-3 col-xl-3 select-row mb-3">
                        <div class="form-group">
                            <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$M0022[1]['organization_group_nm']}}" style="max-width: 190px;    display: block">
                                {{$M0022[1]['organization_group_nm']}}
                            </label>
                                    <select id="organization_step{{$M0022[1]['organization_step']}}" organization_typ="{{$M0022[1]['organization_typ']}}" tabindex="8" class="form-control  organization_cd{{$M0022[1]['organization_step']}}">
                                    </select>
                        </div>
                    </div>
                    @endif
                    @if(isset($M0022[2]))
                    <div class="ol-md-12 col-lg-3 col-xl-3 select-row mb-3" id="org_belong_3">
                        <div class="form-group">
                            <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$M0022[2]['organization_group_nm']}}" style="max-width: 190px; display: block">
                                {{$M0022[2]['organization_group_nm']}}
                            </label>
                                    <select id="organization_step{{$M0022[2]['organization_step']}}" organization_typ="{{$M0022[2]['organization_typ']}}" tabindex="8" class="form-control  organization_cd{{$M0022[2]['organization_step']}}">
                                    </select>
                        </div>
                    </div>
                    @endif
                    
                    @if(isset($M0022[1]) && !isset($M0022[2]))
                    <div class="ol-md-12 col-lg-6 col-xl-6 select-row mb-3" id="block_link_q2010" style="display:flex;position: relative;">
                        <span style="display:flex; height:24px; position: absolute;bottom: 18px;">   
                        <p>{{ __('messages.detail_dashboard_master')}}</p><a href="/master/q2010" class="link_to_rq2010" target=”_blank”>{{ __('messages.hr_link')}}</a><p>{{ __('messages.he')}}</p>   
                        </span>
                    </div>
                    @elseif(isset($M0022[2]))
                    <div class="ol-md-12 col-lg-3 col-xl-3 select-row mb-3" id="block_link_q2010_small" style="display:flex;position: relative;">
                        <span style="display:flex; height:24px; position: absolute;bottom: 18px;">   
                        <p>{{ __('messages.detail_dashboard_master')}}</p><a href="/master/q2010" class="link_to_rq2010" target=”_blank”>{{ __('messages.hr_link')}}</a><p>{{ __('messages.he')}}</p>   
                        </span>
                    </div>
                    @else
                    <div class="ol-md-12 col-lg-9 col-xl-9 select-row mb-3" id="block_link_q2010" style="display:flex;position: relative;">
                        <span style="display:flex; height:24px; position: absolute;bottom: 18px;">   
                        <p>{{ __('messages.detail_dashboard_master')}}</p><a href="/master/q2010" class="link_to_rq2010" target=”_blank”>{{ __('messages.hr_link')}}</a><p>{{ __('messages.he')}}</p>   
                        </span>
                    </div>
                    @endif
                    
        @endif
        </div>
        <ul class="lth" id="sheet_block" style="overflow-y: auto; max-height: 30vh">
            @if($list_employee)
            @foreach($list_employee as $item)
            <li class="refer_hyouka {{$item['rater_background']??''}}" screen_refer="{{$item['screen_refer']}}" fiscal_year="{{$item['fiscal_year']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}" >
                <a href="#">
                    <span style="width : 35%">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['status_nm']}}">{{$item['status_nm']}}</div>
                    </span>
                    <span style="width : 30%">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['sheet_nm']}}">{{$item['sheet_nm']}}</div>
                    </span>
                    <div style="height: 20px" class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['employee_nm']}}">{{$item['employee_nm']}}</div>
                </a>
            </li>
            @endforeach
            @else
            <li class="text-center">
                 {{app('messages')->getText(21)->message}}
            </li>
            @endif
        </ul>
    </div>

        <div class="hyouka-right_Box">
            <div class="p-title mb-0">
                <h4 class="block"><i class="fa fa-file-text-o fa-flip-vertical"></i> {{ __('messages.information') }}</h4>
            </div><!-- end .p-title -->
            <ul class="lth" style="overflow-y: auto; max-height: 30vh">
                @if($list_infomation)
                @foreach($list_infomation as $item)
                <li class="list_infomation" company_cd="{{$item['company_cd']}}" category="{{$item['category']}}" status_cd="{{$item['status_cd']}}" infomationn_typ="{{$item['infomationn_typ']}}" infomation_date="{{$item['infomation_date']}}" target_employee_cd="{{$item['target_employee_cd']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}"  fiscal_year="{{$item['fiscal_year']}}">
                    <a href="#">
                        <span style="width:100px">{{$item['infomation_date']}}</span>
                        <div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$item['infomation_title'].' ('.$item['target_employee_nm'].__('messages.mail_looks').')'}}">{{$item['infomation_title'].' ('.$item['target_employee_nm'].__('messages.mail_looks').')'}}
                        </div>
                    </a>
                </li>
                @endforeach
                @else
                <li class="text-center">
                     {{app('messages')->getText(21)->message}}
                </li>
                @endif
            </ul>
        </div>
    </div>
</div>