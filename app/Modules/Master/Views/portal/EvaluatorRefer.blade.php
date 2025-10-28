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
<input type="hidden" id ="screen_from2" value="{{$screen_from2??''}}">
<div class="row">
<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12 col-12">
<div class="dash_hyouka_left">
    <div class="form-group">
        <select name="" id="list_fiscal_year" class="form-control input-sm  list_fiscal_year">
            <!--                 <option value="-1" point="0"></option> -->
            @foreach($list_fiscal_year as $item)
            <option value="{{$item['fiscal_year']}}"   {{isset($current_year)&&($current_year == $item['fiscal_year']) ? 'selected' : ''}}>
                {{$item['fiscal_year_nm']}}
            </option>
            @endforeach
        </select>
    </div>
    <div class="hyouka-left_stepBox">
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
</div>
<div class="col-xl-6 col-lg-6 col-md-12 col-sm-12 col-12">
    <div class="dash_hyouka_right">
        <!-- <div class="hyouka-right_Box">
            <b class="rightBox-icon_hyokataisho"><i class="fa fa-file-text"></i> 評価対象シート一覧</b>
            <ul>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
                <li>
                    <a href="">
                        <span>2018/06/22</span>シート名　ステータス名　被評価者名</a>
                </li>
            </ul>
        </div> -->

        <div class="hyouka-right_Box">
            <div class="p-title mb-0">
                <h4 class="block"><i class="fa fa-file-text-o fa-flip-vertical"></i> {{ __('messages.information') }}</h4>
            </div><!-- end .p-title -->
            <ul class="lth" style="overflow-y: auto; max-height: 80vh;">
                @if($list_infomation)
                @foreach($list_infomation as $item)
                <li class="list_infomation" company_cd="{{$item['company_cd']}}" category="{{$item['category']}}" status_cd="{{$item['status_cd']}}" infomationn_typ="{{$item['infomationn_typ']}}" infomation_date="{{$item['infomation_date']}}" target_employee_cd="{{$item['target_employee_cd']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}"  fiscal_year="{{$item['fiscal_year']}}">
                    <a href="#">
                        <span>{{$item['infomation_date']}}</span>{{$item['infomation_title']}}
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
</div>