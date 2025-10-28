@php
    $times       = $times??0;
    $start_for   = $start_for ??0;
    $end_for     = $end_for ??0;
    $sheet_combo = $sheet_combo??[];
	function ordinal($number) {
    $ends = array('th','st','nd','rd','th','th','th','th','th','th');
	if( \Session::get('website_language', config('app.locale')) != 'en')
		return  '';
    elseif ((($number % 100) >= 11) && (($number%100) <= 13))
        return  'th';
    else
        return  $ends[$number % 10];
	}
    function time_custom($number) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  ordinal($number).' time';
    else
        return  '回目';
	}
@endphp

<input type="hidden" id="oneonone_times" value="{{$times}}">
<div class="card-body">
    <nav class="pager-wrap row">
        {!! Paging::show($paging ?? []) !!}
    </nav>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive">
                <div id="topTable" class=" table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells _width" style="background-attachment: fixed;height:64vh;overflow: auto">
                @if (isset($table_data[0]) && !empty($table_data[0]))
                    <table class="table table-bordered table-hover one-table table-spec" id="table-data" style="min-width: {{1400 + $times*300 .'px'}};position: sticky;top: 0;z-index: 99;">
                        <thead>
                             <tr class="high_th">
                                    <th style="min-width: 450px" class="table-col" original_col_span = "{{6  + count($organization_group)}}" colspan="{{6  + count($organization_group)}}"></th>
                                    @if($times > 0)
                                        <th class="table-col-2" colspan="{{$times * 2}}"></th>
                                    @endif
                                </tr>
                        </thead>
                        <tbody>
                            <tr class="list">
                                <td class="text-center  table-colum1 th-1 header-button" style="background-color: white !important;">
                                    <div class=""  style="display: flex;z-index: 999">
                                        <div class="">
                                            <div class="form-group text-right">
                                                <div class="btn-group show_button_div">
                                                    <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="11">
                                                        <i style="padding-top: 7px;padding-bottom: 7px;" class="fa fa-eye-slash"></i>
                                                        <span  id="btn_text">{{ __('messages.hide_attribute_info') }}</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-1" id="hidd1" style="max-width: 115px;">
                                            <div class="form-group text-right">
                                                <div class="input-group-btn">
                                                    <a href="javascript:;" id="apply_value" class="btn btn-outline-primary" page={{isset($paging['page'])?$paging['page']:'1'}}  tabindex="11">{{ __('messages.apply_latest') }}</a>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 3gr -->
                                    </div>
                                </td>
                                @if (isset($organization_group[0])&& !empty($organization_group[0]))
                                    @foreach($organization_group as $dt)
                                    <td class="text-center hide-table m-width-100" ></td>
                                    @endforeach
                                    @endif
                                <td  class="text-center  table-colum1 hide-table  m-width-100"></td>
                                <td class="text-center m-width-100" ></td>
                                <td class="text-center m-width-100" ></td>
                                <td class="text-center m-width-100" ></td>
                                <td class="text-center btn-bulk-change" >
                                    <div class="form-group" style="margin-bottom: 0px;margin-top:-15px">
                                        <div class="input-group-btn" >
                                            <a href="javascript:;" id="bulk_change" style="margin-left: -23px" class="btn btn-outline-primary disabled"  times={{$times}} tabindex="-1">{{ __('messages.bulk_change') }}</a>
                                        </div>
                                    </div>
                                </td>
                                @for ($i = $start_for; $i <= $end_for; $i++)
                                    <td class="text-center hidden_apply" style="min-width: 150px;max-width:150px">
                                        <div class="form-group">
                                            <div class="input-group-btn input-group div_employee_cd">
                                                <span class="num-length">
                                                    <input type="hidden" class="employee_cd_hidden {{'hidden_search_'.$i}}" id="employee_cd" value="" />
                                                    <input type="text"  fiscal_year_1on1 = '{{$fiscal_year??0}}' class="form-control indexTab employee_nm_1on1 {{'search_'.$i}} buttonhide search_apply_bar"
                                                    tabindex="12" maxlength="101" value="" style="padding-right: 40px;"  />
                                                </span>
                                                <div class="input-group-append-btn">
                                                    <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
                                                        <i class="fa fa-search"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center hidden_apply" style="min-width: 150px;max-width:150px">
                                        <div class="form-group">
                                            <select autocomplete="off"  name="" id="" class="form-control {{'select_'.$i}} buttonhide select_apply_bar" tabindex="12">
                                                <option value="-1"></option>
                                                @if (isset($combo_interview[$i]) && !empty($combo_interview[$i]))
                                                    @foreach ($combo_interview[$i] as $item)
                                                        <option value="{{$item['interview_cd']}}">{{$item['interview_nm']}}</option>
                                                    @endforeach
                                                @endif
                                            </select>
                                        </div>
                                    </td>
                                @endfor
                            </tr>
                        </tbody>
                    </table>
                    <div id="table_detail_2">
                        <table class="table table-bordered table-hover table-striped one-table" id="table-data2" style="min-width: {{1400 + $times*300 .'px'}}">
                            <thead>
                                <tr class="tr-row1">
                                    <th style="max-width: 50px;min-width: 50px" class="th-1"></th>
                                    <th style="min-width: 400px" class="table-col th-1" original_col_span = "{{6  + count($organization_group)}}" colspan="{{6  + count($organization_group)}}">{{ __('messages.member_info') }}</th>
                                    @if($times > 0)
                                        <th class="table-col-2" colspan="{{$times * 2}}">{{ __('messages.1on1_info') }}</th>
                                    @endif
                                </tr>
                                <tr class="tr-row2">
                                    <th class= "text-center nosort th-1 th-1-width" style="width: 20px">
                                        <div class="md-checkbox-v2 inline-block lb">
                                            <label for="ck_all" class="container">
                                                <input name="ck_all" class="check_all" id="ck_all" type="checkbox">
                                                <span class="checkmark"></span>
                                            </label>
                                        </div>
                                    </th>
                                    <th class="text-center col-table-1 th-2 th-2-width">{{ __('messages.employee_no') }}</th>
                                    <th class="text-center col-table-2 th-3 th-3-width m-width-200">{{ __('messages.employee_name') }}</th>
                                    @if (isset($organization_group[0]) && !empty($organization_group[0]))
                                        @foreach($organization_group as $dt)
                                            <th class="w-detail-col7 text-overfollow list-search-child invi_head m-width-100"  data-container="body" data-toggle="tooltip"
                                                data-original-title="{{$dt['organization_group_nm']}}">
                                                {{$dt['organization_group_nm']}}
                                            </th>
                                        @endforeach
                                    @endif
                                    <th class="text-center invi_head m-width-100 width-position">{{ __('messages.position') }}</th>
                                    <th class="text-center invi_head m-width-100">{{ __('messages.job') }}</th>
                                    <th class="text-center invi_head m-width-100" >{{ __('messages.grade') }}</th>
                                    <th class="text-center invi_head m-width-110">{{ __('messages.employee_classification') }}</th>
                                    @for ($i = $start_for - 1 ; $i < $end_for; $i++)
                                        <th colspan="2" class="text-center">{{(($i+1).time_custom($i+1)??__('messages.th_time', ['number' => ($i+1)]).ordinal($i+1))}}<br/>{{(isset($table_header[$i]['start_date'])?($table_header[$i]['start_date'])."~" :'').($table_header[$i]['deadline_date']??'')  }}</th>
                                    @endfor
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($table_data as $key => $row)
                                <tr class="list_pair" member_cd={{$row['employee_cd']}}>
                                    <td class= "text-center th-1 sticky-background">
                                        <div class="md-checkbox-v2 inline-block lb">
                                            <label for="ck{{$key}}" class="container">
                                                <input type="hidden" class="employee_cd" value="{{$row['employee_cd']}}" />
                                                <input class="ck_item" name="ck{{$key}}" id="ck{{$key}}" type="checkbox" value="1">
                                                <span class="checkmark"></span>
                                            </label>
                                        </div>
                                    </td>
                                    <td  class="text-right table-colum1 th-2 emp_error  sticky-background">{{$row['employee_cd']}}</td>
                                    <td  class="text-left table-colum1 0 th-3 sticky-background m-width-100">
                                        <div class="text-overfollow list-search-child"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">
                                            {{$row['employee_nm']}}</div>
                                    </td>
                                     {{-- organization_typ = 1 --}}
                                    @if ($row['belong_cd1_is_used'] == 1)
                                    <td class="w-detail-col7 hide-table m-width-100">
                                        <div class="text-overfollow list-search-child" id="{{ $row['belong_cd1_nm'] }} hide-table"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd1_nm'] }}">
                                        {{ $row['belong_cd1_nm'] }}</div>
                                    </td>    
                                    @endif
                                    {{-- organization_typ = 2 --}}
                                    @if ($row['belong_cd2_is_used'] == 1)
                                    <td class="w-detail-col7 hide-table m-width-100">
                                        <div class="text-overfollow list-search-child" id="{{ $row['belong_cd2_nm'] }} hide-table"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd2_nm'] }}">
                                        {{ $row['belong_cd2_nm'] }}</div>
                                    </td>    
                                    @endif
                                    {{-- organization_typ = 3 --}}
                                    @if ($row['belong_cd3_is_used'] == 1)
                                    <td class="w-detail-col7 hide-table m-width-100">
                                        <div class="text-overfollow list-search-child" id="{{ $row['belong_cd3_nm'] }} hide-table"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd3_nm'] }}">
                                        {{ $row['belong_cd3_nm'] }}</div>
                                    </td>    
                                    @endif
                                    {{-- organization_typ = 4 --}}
                                    @if ($row['belong_cd4_is_used'] == 1)
                                    <td class="w-detail-col7 hide-table m-width-100">
                                        <div class="text-overfollow list-search-child" id="{{ $row['belong_cd4_nm'] }} hide-table"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd4_nm'] }}">
                                        {{ $row['belong_cd4_nm'] }}</div>
                                    </td>    
                                    @endif
                                    {{-- organization_typ = 5 --}}
                                    @if ($row['belong_cd5_is_used'] == 1)
                                    <td class="w-detail-col7 hide-table m-width-100">
                                        <div class="text-overfollow list-search-child" id="{{ $row['belong_cd5_nm'] }} hide-table"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd5_nm'] }}">
                                        {{ $row['belong_cd5_nm'] }}</div>
                                    </td>    
                                    @endif
                                    <td class="text-left hide-table m-width-100" >
                                        <div class="text-overfollow list-search-child"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['position_nm']}}">
                                            {{$row['position_nm']}}</div>
                                    </td>
                                    <td class="text-left hide-table m-width-100" >
                                        <div class="text-overfollow list-search-child"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['job_nm']}}">
                                            {{$row['job_nm']}}</div>
                                    </td>
                                    <td class="text-left hide-table m-width-100" >
                                        <div class="text-overfollow list-search-child"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['grade_nm']}}">
                                            {{$row['grade_nm']}}</div>
                                    </td>
                                    <td class="text-left hide-table m-width-100" >
                                        <div class="text-overfollow list-search-child"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_typ_nm']}}">
                                            {{$row['employee_typ_nm']}}</div>
                                    </td>
                                    @for ($i = $start_for; $i <= $end_for; $i++)

                                        <td class="text-center" style="min-width: 150px;max-width:150px">
                                            @php
                                                $temp_pair = json_decode(html_entity_decode($row['time'.$i]),true) ;
                                            @endphp
                                            <div class="input-group-btn ">
                                                <div class="input-group-btn input-group div_employee_cd">
                                                    <span class="num-length">
                                                    <input type="hidden" class="pair_each {{'hidden_val_search_'.$i}} employee_cd_hidden {{'coach_cd_'.$i}}"
                                                    employee_cd = "{{$row['employee_cd']}}" value = "{{$temp_pair['coach_cd']??''}}"
                                                    interview_cd = "{{$temp_pair['interview_cd']??''}}" time="{{$i}}" start_date='{{($table_header[$i-1]['start_date']??'')}}'>
                                                    <input type="text"  fiscal_year_1on1 = '{{$fiscal_year??0}}' class="form-control indexTab employee_nm_1on1 {{'coach_nm_'.$i}} {{'val_search_'.$i}}"
                                                     maxlength="101" value="{{$temp_pair['coach_nm']??''}}" style="padding-right: 40px;" tabindex="{{25+$key}}"
                                                     old_employee_nm="{{$temp_pair['coach_nm']??''}}"
                                                     />
                                                    </span>
                                                    <div class="input-group-append-btn">
                                                        <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
                                                            <i class="fa fa-search"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center" style="min-width: 150px;max-width:150px">
                                            <select autocomplete="off"  name="" id="" class="form-control {{'val_select_'.$i}} interview_cd {{'interview_cd_'.$i}}" times={{$i}} tabindex={{25+$key}}>
                                                <option value="-1"></option>
                                                @if (isset($combo_interview[$i]) && !empty($combo_interview[$i]))
                                                    @foreach ($combo_interview[$i] as $item)
                                                        <option value="{{$item['interview_cd']}}" {{$item['interview_cd'] == ($temp_pair['interview_cd']??'') ? 'selected': ''}}>{{$item['interview_nm']}}</option>
                                                    @endforeach
                                                @endif
                                            </select>
                                        </td>
                                    @endfor
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                <table class="table table-bordered table-hover one-table table-spec" id="table-data" style="min-width: 2600px;position: sticky;top: 0;z-index: 99;">
                    <thead>
                         <tr class="high_th">
                                <th style="min-width: 450px" class="table-col" original_col_span = "{{6  + count($organization_group)}}" colspan="{{6  + count($organization_group)}}"></th>
                                @if($times > 0)
                                    <th class="table-col-2" colspan="{{$times * 2}}"></th>
                                @endif
                            </tr>
                    </thead>
                    <tbody>
                        <tr class="list">
                            <td class="text-center  table-colum1 th-1 header-button" style="background-color: white !important;">
                                <div class=""  style="display: flex;z-index: 999">
                                    <div class="">
                                        <div class="form-group text-right">
                                            <div class="btn-group show_button_div">
                                                <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="11">
                                                    <i style="padding-top: 7px;padding-bottom: 7px;" class="fa fa-eye-slash"></i>
                                                    <span  id="btn_text">{{ __('messages.hide_attribute_info') }}</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-1" id="hidd1" style="max-width: 115px;">
                                        <div class="form-group text-right">
                                            <div class="input-group-btn">
                                                <a href="javascript:;" id="apply_value" class="btn btn-outline-primary" page={{isset($paging['page'])?$paging['page']:'1'}} tabindex="11">{{ __('messages.apply_latest') }}</a>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 3gr -->
                                </div>
                            </td>
                            <td  class="text-center  table-colum1 hide-table  m-width-100"></td>
                            @if (isset($organization_group[0])&& !empty($organization_group[0]))
                                @foreach($organization_group as $dt)
                                <td class="text-center hide-table m-width-100" ></td>
                                @endforeach
                            @endif
                            <td class="text-center hide-table m-width-100" ></td>

                            <td class="text-center m-width-100" >
                                <div class="form-group" style="margin-bottom: 0px;margin-top:-15px">
                                    <div class="input-group-btn" >
                                        <a href="javascript:;" id="bulk_change" style="margin-left: -23px" class="btn btn-outline-primary disabled"  times={{$times}} tabindex="-1">{{ __('messages.bulk_change') }}</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                    <div id="table_detail_2">
                        <table class="table table-bordered table-hover table-striped one-table" id="table-data2" style="min-width: 2600px">
                            <thead>
                                <tr>

                                    <th style="max-width: 50px;min-width: 50px"></th>
                                    <th style="min-width: 350px" class="table-col" original_col_span = "{{6  + count($organization_group)}}" colspan="{{6  + count($organization_group)}}">{{ __('messages.member_info') }}</th>
                                    <th class="table-col-2" colspan="2">{{ __('messages.1on1_info') }}</th>
                                </tr>
                                <tr>
                                    <th class="text-center nosort th-1 th-1-width" style="width: 20px">
                                        <div class="md-checkbox-v2 inline-block lb">
                                            <label for="ck_all" class="container">
                                                <input name="ck_all" class="check_all" id="ck_all" type="checkbox">
                                                <span class="checkmark"></span>
                                            </label>
                                        </div>
                                    </th>
                                    <th class="text-center col-table-1 th-2 th-2-width" style="">{{ __('messages.employee_no') }}</th>
                                    <th class="text-center col-table-2 th-3 th-3-width">{{ __('messages.employee_name') }}</th>
                                    @if (isset($organization_group[0]) && !empty($organization_group[0]))
                                        @foreach($organization_group as $dt)
                                            <th class="w-detail-col7 text-overfollow list-search-child invi_head"  data-container="body" data-toggle="tooltip"
                                                data-original-title="{{$dt['organization_group_nm']}}">
                                                {{$dt['organization_group_nm']}}
                                            </th>
                                        @endforeach
                                    @endif
                                    <th class="text-center invi_head">{{ __('messages.position') }}</th>
                                    <th class="text-center invi_head">{{ __('messages.job') }}</th>
                                    <th class="text-center invi_head" >{{ __('messages.grade') }}</th>
                                    <th class="text-center invi_head">{{ __('messages.employee_classification') }}</th>
                                    <th colspan="2" class="text-center"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                <td class="text-center hide-table" width="100px" colspan="{{9+count($organization_group)}}"> {{ $_text[21]['message'] }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                 @endif
                </div>
            </div><!-- end .table-responsive -->
            <div class="row justify-content-md-center">
                {!!
                    Helper::buttonRender1on1(['saveButton'])
                !!}
            </div>
        </div>
    </div>
</div>