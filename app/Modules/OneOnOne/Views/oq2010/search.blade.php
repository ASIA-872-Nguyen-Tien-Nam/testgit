@php
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
<nav class="pager-wrap">
</nav>

<div class="row" style="margin-bottom: 7px;">
    <div class="col-md-10 row-month" style="margin: 0 auto">
        <div class="row text-center">
            <div class="col-md-2 btn-group" style="max-width: 193px">
                <button class="btn focusin button-1on1" id="hide-group-x" tabindex="15" style="height: 39px">
                    <i class="fa fa-pencil-square-o" aria-hidden="true"></i> <span id="btn_text">{{__('messages.item_settings')}}</span>
                </button>
            </div>
            <div class="col-md-10">
                <div class="row">
                    <div class="col-md-4 col-sm-6 col-12 month-search">
                        <span style="line-height: 0px">
                            <div class="md-radio-v2 inline-block" style="margin-top: 8px">
                                <input name="point_calculation_typ1" id='radio-0' tabindex="15" type="radio" checked maxlength="3">
                                <label style="line-height: 20px" class="form-check-label" for="radio-0" text-radio>
                                {{__('messages.show_all_episodes')}}
                                </label>
                            </div>
                        </span>
                    </div>
                    @if(isset($group_time))
                    @foreach ($group_time as $row)
                    <div class="col-md-4 col-sm-6 col-12 month-search">
                        <span style="line-height: 0px">
                            <div class="md-radio-v2 inline-block group_times_select" style="margin-top: 8px">
                                <input type="hidden" class="times_start" value="{{$row['times_start']??''}}" />
                                <input type="hidden" class="times_end" value="{{$row['times_end']??''}}" />
                                <input name="point_calculation_typ1" class="select_group_times" id="radio-{{$row['id']}}" tabindex="15" type="radio" maxlength="3">
                                <label style="line-height: 20px" class="form-check-label" for="radio-{{$row['id']}}" text-radio>
                                {{ __('messages.th_time', ['number' =>$row['times_start']]).ordinal($row['times_start']) }}ー{{ __('messages.th_time', ['number' =>$row['times_end']]).ordinal($row['times_end']) }}
                                </label>
                            </div>
                        </span>
                    </div>
                    @endforeach
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
        <nav class="pager-wrap row">
            {{Paging::show($paging??[])}}
        </nav>
    </div>
    <div class="col-md-12">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>

    <div class="col-md-12">
        <div id="topTable" class="wmd-view table-responsive _width wrapper" style="background-attachment: fixed;max-height: 500px;">
            <table class="table table-bordered table-hover table_sort one-table table-special ofixed-boder" id="table-data" style="min-width:1500px !important">
                <thead>
                    <tr>
                        <th class="th_header1" colspan="{{$times['colspan_header']??$group_hd_default}}" group="X" id="hide-text">{{__('messages.member_info')}}</th>
                        @if(isset($times) && $times['colspan_group'] > 0)
                        <th class="th_header1" colspan="{{$times['colspan_group']}}" group="" id="view-all-month">{{__('messages.1on1_overview')}}</th>
                        @endif
                    </tr>
                    <tr>
                        @if(isset($info_column))
                            @foreach($info_column as $key => $column)
                                <th rowspan="2" group="X" class="th_header2 {{$key==0?'sticky-cell-1':''}} {{$key==1?'sticky-cell-2 change-col':''}} {{$key > 1?'hide-group-x':''}}  {{$column['col_nm']}}">
                                    <div class="text-overfollow header-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$column['item_nm']}}">
                                        {{$column['item_nm']}}
                                    </div>
                                </th>
                            @endforeach
                        @else
                            <th rowspan="2" group="X" class="th_header2 sticky-cell-1">{{__('messages.employee_no')}}</th>
                            <th rowspan="2" group="X" class="th_header2 sticky-cell-2 change-col">{{__('messages.employee_name')}}</th>
                            <th rowspan="2" group="X" class="th_header2 _w120">{{__('messages.base_style')}}</th>
                            @if(isset($organization_group[0]) && !isset($organization_header[0]))
                                @foreach($organization_group as $dt)
                                <th class="th_header2 hide-group-x _w100 text-overfollow" rowspan="2" group="X" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}">
                                    {{$dt['organization_group_nm']}}
                                </th>
                                @endforeach
                            @endif
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w100">{{__('messages.position')}}</th>
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w100">{{__('messages.job')}}</th>
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w100">{{__('messages.grade')}}</th>
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w150">{{__('messages.employee_classification')}}</th>
                            @if((isset($data_target[0][0]['target1_nm']) && isset($data_target[0][0]['target1_use_typ']) && $data_target[0][0]['target1_use_typ'] == 1))
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w120">
                                <div class="text-overfollow header-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_target[0][0]['target1_nm']}}">
                                    {{$data_target[0][0]['target1_nm']}}
                                </div>
                            </th>
                            @endif
                            @if((isset($data_target[0][0]['target2_nm']) && isset($data_target[0][0]['target2_use_typ']) && $data_target[0][0]['target2_use_typ'] == 1))
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w120">
                                <div class="text-overfollow header-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_target[0][0]['target2_nm']}}">
                                    {{$data_target[0][0]['target2_nm']}}
                                </div>
                            </th>
                            @endif
                            @if((isset($data_target[0][0]['target3_nm']) && isset($data_target[0][0]['target3_use_typ']) && $data_target[0][0]['target3_use_typ'] == 1))
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w120">
                                <div class="text-overfollow header-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_target[0][0]['target3_nm']}}">
                                    {{$data_target[0][0]['target3_nm']}}
                                </div>
                            </th>
                            @endif
                            @if((isset($data_target[0][0]['comment_nm']) && isset($data_target[0][0]['comment_use_typ']) && $data_target[0][0]['comment_use_typ'] == 1))
                            <th rowspan="2" group="X" class="th_header2 hide-group-x _w120">
                                <div class="text-overfollow header-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_target[0][0]['comment_nm']}}">
                                    {{$data_target[0][0]['comment_nm']}}
                                </div>
                            </th>
                            @endif
                        @endif
                        @if(isset($group_header[0]))
                            @foreach ($group_header as $row)
                            <th colspan="{{$row['num_cl_detail']??5}}" group="{{$row['times_group']}}" class="th_header2 group_times_detail group_{{$row['times_group']}}">{{($row['times_group']??'').time_custom($row['times_group'])}}</th>
                            @endforeach
                        @endif
                    </tr>
                    <tr class="">
                    @if(isset($times))
                    @for($i = 1 ; $i <= $times['times_group'];$i++) 
                        @if(isset($check) && $check['display_coach_cd'] == 1) 
                        <th group="{{$i}}" class="th_header3 _w120 group_times_detail group_{{$i}}">{{__('messages.coach')}}</th>
                        @endif
                        @if(isset($check) && ($check['display_base_style'] == 1 && $check['authority_typ'] == 4))
                        <th group="{{$i}}" class="th_header3 _w120 group_times_detail group_{{$i}}">{{__('messages.base_style')}}</th>
                        @endif
                        <th group="{{$i}}" num="{{$i}}" class="th_header3 text-sort group_times_detail group_{{$i}}" style="width: 100px;">
                            <span class="text-nowrap">{{__('messages.adequacy')}}
                                <span><i class="fa fa-sort sort"></i></span>
                            </span>
                        </th>
                        <th group="{{$i}}" class="th_header3 _w120 group_times_detail group_{{$i}}">{{__('messages.next_action')}}</th>
                        <th group="{{$i}}" class="th_header3 _w120 group_times_detail group_{{$i}}">{{__('messages.implementation_date')}}</th>
                    @endfor
                    @endif
                    </tr>
                </thead>
                <tbody>
                    @if(isset($list[0]))
                    @foreach ($list as $row)
                    <tr style="cursor: pointer;">
                        @if(isset($info_column))
                            @foreach($info_column as $key =>  $column)
                                @if($column['col_nm'] =='employee_cd')
                                    <td group="X" class="{{$key==0?'sticky-col sticky-cell-1':''}} {{$key==1?'sticky-col sticky-cell-2 change-col':''}} {{$key > 1?'hide-group-x':''}} text-center">
                                        <a href="#" class="employee_detail" employee_cd="{{$row['employee_cd']}}">{{$row['employee_cd']}}</a>
                                    </td>
                                @else
                                    <td group="X" class="{{$key==0?'sticky-col sticky-cell-1':''}} {{$key==1?'sticky-col sticky-cell-2 change-col':''}} {{$key > 1?'hide-group-x':''}} {{$column['col_nm']}}">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! nl2br($row[$column['col_nm']]) !!}">
                                            {{$row[$column['col_nm']]}}
                                        </div>
                                    </td>
                                @endif
                            @endforeach
                        @endif
                        @for($i = 1 ; $i <= $times['times_group'];$i++) 
                            @php 
                                $data_detail=json_decode(str_replace('&quot;', '"' , $row['A'.$i]),true); 
                            @endphp 
                            @if(isset($check) && $check['display_coach_cd']==1 ) 
                            <td class="group_times_detail group_{{$i}} _w120" group="{{$i}}">
                            @if(isset($data_detail['coach_nm']))
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_detail['coach_nm']}}">
                                    {{$data_detail['coach_nm']}}
                                </div>
                            @endif
                            </td>
                            @endif
                            @if(isset($check) && ($check['display_base_style'] == 1 && $check['authority_typ'] == 4))
                            <td class="group_times_detail group_{{$i}} _w120" group="{{$i}}">
                            @if(isset($data_detail['base_style_nm']))
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$data_detail['base_style_nm']}}">
                                    {{$data_detail['base_style_nm']}}
                                </div>
                            @endif
                            </td>
                            @endif




                            <td group="{{$i}}" class="text-center list-img group_times_detail group_{{$i}}" num="{{$i}}">
                            @if(isset($data_detail['is_coach']))
                                @if(
                                    ($data_detail['is_coach'] == 1) 
                                ||  ($data_detail['is_coach'] == 0 && $data_detail['check_f2200_coach_inserted'] == 1)
                                )
                                    @if($data_detail['remark1'] != '')
                                    <img tabindex="-1" src="/uploads/ver1.7/odashboard/{{$data_detail['remark1']}}" />
                                    <input type="hidden" class="fullfillment_type order_by" value="{{$data_detail['fullfillment_type']??'0'}}" />
                                    @endif
                                @endif
                                @endif
                            </td>
                            <td class="group_times_detail group_{{$i}} _w120" group="{{$i}}">
                            @if(isset($data_detail['is_coach']) &&isset($data_detail['next_action']) && isset($data_detail['check_f2200_coach_inserted']))   
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-html="true" data-original-title="{!! nl2br($data_detail['next_action']) !!}">                          
                                @if(
                                        ($data_detail['is_coach'] == 1) 
                                    ||  ($data_detail['is_coach'] == 0 && $data_detail['check_f2200_coach_inserted'] == 1)
                                    )
                                        {!! nl2br($data_detail['next_action']) !!}
                                    @endif
                                </div>
                                @endif
                            </td>
                            <td class="text-center group_times_detail group_{{$i}} _w160" group="{{$i}}">
                                <!-- if login is not coach -->    
                                @if(isset($data_detail['is_coach']) && isset($data_detail['interview_date']))                               
                                @if(
                                    ($data_detail['is_coach'] == 0)
                                ||  ($data_detail['is_coach'] == 1 && $data_detail['check_ex_f2200'] == 1)  
                                )
                                    {{$data_detail['interview_date']}}
                                @else
                                    <div class="gflex div_popup_meeting" fiscal_year="{{$row['fiscal_year']}}" employee_cd="{{$row['employee_cd']}}" times="{{$data_detail['times']}}" from="oQ2010">
                                        <div class="input-group-btn input-group" style="width: 100%">
                                            <input type="text" class="form-control input-sm date right-radius interview_date oneonone_schedule_date" placeholder="yyyy/mm/dd" value="{{$data_detail['interview_date']??''}}" tabindex="16" />
                                            <div class="input-group-append-btn">
                                                <button class=" btn-transparent popup btn_popup_meeting" type="button" tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                @endif
                                @endif
                            </td>
                        @endfor
                    </tr>
                    @endforeach
                    @else
                    <tr style="border: 1px solid white">
                        <td class="text-center" colspan="{{$times['colspan_nodata']??$group_hd_default}}">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
                </tbody>
            </table>

        </div><!-- end .row -->
    </div>
</div><!-- end .card-body -->

<input type="hidden" id="colspan_group" value="{{$times['colspan_group']??0}}" />
<input type="hidden" id="colspan_header" value="{{$times['colspan_header']??$group_hd_default}}" />
<input type="hidden" id="num_cl_detail" value="{{$times['num_cl_detail']??5}}" />