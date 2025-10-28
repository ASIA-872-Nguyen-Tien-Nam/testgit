<nav class="pager-wrap ">
    <div class="btn-group btn-pagging-center {{($paging['totalRecord']??0) == 0?'btn-show1':'btn-show2'}}" id="div-btn-list-title">
        <button id="btn-list-title" class="mb-1 btn btn-outline-primary btn-sm" tabindex="11">
            <i class="fa fa-pencil-square-o"></i>
            <span id="btn_text">{{ __('messages.item_settings') }}</span>
        </button>
    </div>
    {{Paging::show($paging??[])}}

</nav>
<div class="top-scroll" style="width: 100%;">
    <div class="scroll" style="min-width: 3940px;"></div><!-- end .scroll -->
</div><!-- end .top-scroll -->
<div id="sample2">
    <div class="table-responsive table-fixed-header  sticky-table sticky-headers sticky-ltr-cells">
        @php
            $Reputation = [];
            $sheet_num = 1;
            $count_emp_info_header = 0;
            $count_prev_year_header = 0;
            if(!empty($emp_info_header)){
                $count_emp_info_header = count($emp_info_header);
            }
            if(!empty($prev_year_header)){
                $count_prev_year_header = count($prev_year_header);
            };
        @endphp
        <table class="table table-bordered table-hover table-striped fixed-header outline-none table_sort" maxrate = '{{($f0100_step??0) > ($table[0]['max_rate_status_1']??0)?($table[0]['max_rate_status_1']??0):($f0100_step??0)}}'
            final_step='{{(($table[0]['final_rater_status']??0) == 5 && ($table[0]['max_last_confirm']??0) == 1) || ($table[0]['max_feedback_status']??0) == 1 ?0:2}}'
            style="min-width: 3940px;margin-top: 0!important;" id="myTable">
            @if(isset($table[0]) && $table[0] != [])
            <thead>
                <tr>
                    <th class="sticky-cell " style="outline: none !important;width:50px">{{ __('messages.select') }}</th>
                    @if($count_emp_info_header > 0)
                        <th class="sticky-cell change-col" colspan="{{$count_emp_info_header}}" class="text-center" style="max-width: 500px">{{ __('messages.employee_info') }}</th>
                    @endif
                    @if($count_prev_year_header > 0)
                        <th class=" change-col" colspan="{{$count_prev_year_header}}" class="text-center" style="max-width: 100px">{{ __('messages.past_eval') }}</th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=1 || $table[0]['rater_step'] == 5 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 1 && $sheet_use_typ??1 == 1)
                    <th colspan="3" class="text-center">{{ __('messages.eval_1st') }}</th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=2 || $table[0]['rater_step'] == 5 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 2 && $sheet_use_typ??1 == 1)
                    <th colspan="3" class="text-center">{{ __('messages.eval_2nd') }}</th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=3 || $table[0]['rater_step'] == 5 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 3 && $sheet_use_typ??1 == 1)
                    <th colspan="3" class="text-center">{{ __('messages.eval_3rd') }}</th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=4 || $table[0]['rater_step'] == 5 || $table[0]['max_feedback_status'] == 1)&& $table[0]['m0100_step'] >= 4 && $sheet_use_typ??1 == 1)
                    <th colspan="3" class="text-center">{{ __('messages.eval_4th') }}</th>
                    @endif
                    @if($table[0]['rater_step'] == 5||($table[0]['final_rater_status'] == 5 &&$table[0]['max_last_confirm'] == 1) || $table[0]['max_feedback_status'] == 1)
                    <th colspan="2" class="text-center">{{ __('messages.final_eval') }}</th>
                    @endif
                    <th colspan="2" class="text-center">{{ __('messages.comment') }}</th>
                    @if($sheet_use_typ??1 == 1)
                        @for ($i = 1; $i <= $max_sheet; $i++)
                            <th colspan="{{((($table[0]['rater_step'] == 5 || $table[0]['max_feedback_status'] == 1||$table[0]['rater_step'] == 5))?$table[0]['m0100_step']:$table[0]['max_rate_status_1'])+2}}" class="text-center">
                                {{ __('messages.eval_element') }}
                                {{$sheet_num ++}}
                            </th>
                        @endfor
                    @endif
                </tr>
                <tr>
                    <th class="sticky-cell text-center nosort" style="width: 20px">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input name="ck_all" class="check_all" id="ck_all" type="checkbox">
                            <label for="ck_all"></label>
                        </div>
                    </th>
                    @foreach($emp_info_header as $hd)
                        <th class="sticky-cell text-center  w_col_detail1" num="{{$hd['item_cd']}}">
                            {{-- <div class="text-overfollow  employee-overfollow header-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$hd['item_nm']}}"> --}}
                                {{$hd['item_nm']}}
                            {{-- </div> --}}
                            <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endforeach
                    @foreach($prev_year_header as $hd2)
                        <th class="text-center  w_col_detail1" num="{{$hd2['item_cd']}}">
                            {{$hd2['item_nm']}}
                    </th>
                    @endforeach

                    @if( ($table[0]['max_rate_status_1'] >=1 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 1 && $sheet_use_typ??1 == 1)
                    <th class="text-center" style="min-width: 60px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px" num="16">{{ __('messages.rank') }}
                        <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=2 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 2 && $sheet_use_typ??1 == 1)
                    <th class="text-center" style="min-width: 60px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px" num="17">{{ __('messages.rank') }}
                        <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=3 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 3 && $sheet_use_typ??1 == 1)
                    <th class="text-center" style="min-width: 60px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px" num="18">{{ __('messages.rank') }}
                        <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endif
                    @if( ($table[0]['max_rate_status_1'] >=4 || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 4 && $sheet_use_typ??1 == 1)
                    <th class="text-center" style="min-width: 60px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px" num="19">{{ __('messages.rank') }}
                        <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endif
                    @if($table[0]['rater_step'] == 5 ||($table[0]['rater_step'] == 5 &&$table[0]['max_last_confirm'] == 1)|| $table[0]['max_feedback_status'] == 1 || $sheet_use_typ == 0)
                    <th class="text-center" style="min-width: 60px">{{ __('messages.eval_points') }}</th>
                    {{-- <th class="text-center" style="min-width: 70px">加減点</th> --}}
                    <th class="text-center" style="min-width: 100px" num="20">{{ __('messages.rank') }}
                        <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endif
                    <th style="min-width: 300px;max-width: 350px">{{ __('messages.comment') }}</th>
                    <th style="white-space: nowrap;">{{ __('messages.treatment_use') }}</th>
                    @if($sheet_use_typ??1 == 1)
                        @for ($i = 1; $i <= $max_sheet; $i++)
                            <th class="text-center" style="min-width: 90px">{{ __('messages.evaluation_sheet') }}</th>
                            @if( ($table[0]['max_rate_status_1'] >=1  || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 1)
                            <th class="text-center" style="min-width: 70px">{{ __('messages.eval_1st') }}</th>
                            @endif
                            @if( ($table[0]['max_rate_status_1'] >=2  || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 2)
                            <th class="text-center" style="min-width: 70px">{{ __('messages.eval_2nd') }}</th>
                            @endif
                            @if( ($table[0]['max_rate_status_1'] >=3  || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 3)
                            <th class="text-center" style="min-width: 70px">{{ __('messages.eval_3rd') }}</th>
                            @endif
                            @if( ($table[0]['max_rate_status_1'] >=4  || $table[0]['max_feedback_status'] == 1) && $table[0]['m0100_step'] >= 4)
                            <th class="text-center" style="min-width: 70px">{{ __('messages.eval_4th') }}</th>
                            @endif
                            <th class="text-center" style="min-width: 70px">{{ __('messages.weight') }}</th>
                            <th class="text-center" style="display: none">{{ __('messages.weight') }}</th>
                        @endfor
                    @endif
                </tr>
            </thead>


            <tbody id="mock-data1" class="list_table">
                <?php $j=0?>
                @foreach($table AS $key=>$row)
                @php
                    $rank_combo = json_decode((htmlspecialchars_decode($row['rank_json'])),true)??[];
                    $j++;
                @endphp
                <tr class="row_data" data-order="" employee_cd="{{$row['employee_cd']}}" treatment_applications_no="{{$row['treatment_applications_no']}}"
                        adjust_point = "{{(float)$row['adjust_point']}}"
                        >
                    <td class="hidden">
                        <input type="text" class="hidden valuation_step" value="{{(($row['rater_status']==0&&$row['final_rater_status']>0)||($row['confirm_last_step_final']==1&&$row['final_rater_status']>0))?$row['final_rater_status']:($row['rater_status']>0?$row['rater_status']:$row['current_rater_step'])}}" />
                        <input type="text" class="hidden employee_cd" value="{{$row['employee_cd']}}" />
                    </td>
                    <td class="sticky-cell text-center">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input class="ck_item" name="ck{{$j}}" id="ck{{$j}}" type="checkbox" value="1">
                            <label for="ck{{$j}}"></label>
                        </div>
                    </td>
                    @foreach($emp_info_header as $hd)
                        @if($hd['col_nm'] =='employee_nm')
                            <td class="sticky-cell employee_cd_link" employee_cd="{{$row['employee_cd']}}" num="{{$hd['item_cd']}}">
                                <a  href="#">
                                    <div class="text-overfollow  employee-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row[$hd['col_nm']]}}">{{$row[$hd['col_nm']]}}</div>
                                </a>
                                <input type="hidden" class="order_by" value="{{$row[$hd['item_order']]}}" />
                                <input type="text" class="hidden list_employee_nm" value="{{$row[$hd['col_nm']]}}" />
                            </td>
                        @else
                            <td class="sticky-cell " num="{{$hd['item_cd']}}">
                                <div class="text-overfollow  employee-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row[$hd['col_nm']]}}">{{$row[$hd['col_nm']]}}</div>
                                <input type="hidden" class="order_by" value="{{$row[$hd['item_order']]}}" />
                                <input type="text" class="hidden {{$hd['col_nm']}}" value="{{$row[$hd['col_nm']]}}" />
                            </td>
                        @endif
                    @endforeach
                    @foreach($prev_year_header as $hd)
                        <td class="" num="{{$hd['item_cd']}}">
                            <div class="text-overfollow  employee-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row[$hd['col_nm']]}}">{{$row[$hd['col_nm']] == '0'?'':$row[$hd['col_nm']]}}</div>
                        </td>
                    @endforeach

                    {{-- rater 1 --}}
                @if($sheet_use_typ??1 == 1)
                    @if( ($row['rater_status'] == 1 || $row['final_rater_status'] == 5) && $row['current_rater_step'] == 1 && $row['confirm_last_step'] != 1  &&$row['m0100_step'] >= 1 &&$row['accept_input'] <> 0  )
                        <td class="numeric"   >
                            <span class="point_sum1_view">{{(float)$row['point_sum1']== '0'?'':(float)$row['point_sum1']}}</span>
                            <input type="text" class="hidden point_sum point_sum1"  value="{{(float)$row['point_sum1']}}" />
                        </td>
                        @if($row['adjustpoint_input_1'] == 1)
                            <td class="" style="width: 100px" >
                                <span class="num-length text-overfollow " data-toggle="tooltip" title="{{(float)$row['adjustpoint_from_1']}}~{{(float)$row['adjustpoint_to_1']}}">
                                    <input type="tel" class="form-control numeric adjust_point reduce_point1 adjust_point1 text-right" maxlength="6" value="{{(float)$row['adjust_point1'] == '0'?'':(float)$row['adjust_point1']}}" negative='true' decimal='2' maxlengthfixed='6' fixed  point_sum = 'point_sum1'>
                                    <input type="text" class="step1_point_status hidden" value="{{((float)$row['adjustpoint_input_1'] == 0)?0:1 }}" />
                                    <input type="text" class="adjustpoint_from hidden" value="{{(float)$row['adjustpoint_from_1']}}" />
                                    <input type="text" class="adjustpoint_to hidden" value="{{(float)$row['adjustpoint_to_1']}}" />
                                </span>
                            </td>
                        @else
                            <td class="" style="width: 100px" >
                                {{(float)$row['adjust_point1'] == '0'?'':(float)$row['adjust_point1']}}
                            </td>
                        @endif
                        @if($row['rank_change_1'] == 1)

                            <td class="text-left td_rank_nm1" style="width: 100px" num="16">
                                <select name="" id="" class="form-control input-sm rank_kinds1 rank_kinds" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds1'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds1']??0}}" />
                            </td>
                        @else
                            <td class="text-left" style="width: 100px" num="16">
                                <span class="td_rank_nm">{{$row['rank_nm1']}}</span>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds1']}}" />
                                <select class="form-control input-sm rank_kinds1 rank_kinds hidden" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds1'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                            </td>
                        @endif
                    @elseif( (($row['rater_status'] > 1 && $row['confirm_at_step'] >= 1 )|| ($row['rater_status'] == 1 && $row['accept_input'] != 0)  || ($row['final_rater_status'] == 5 &&($row['current_rater_step'] > 1||($row['current_rater_step'] == 1 && $row['accept_input'] != 0))) || $row['feed_back_status'] == 1) && $row['m0100_step'] >= 1 )
                        <td class="numeric"   >
                            <span class="point_sum1_view">{{(float)$row['point_sum1']== '0'?'':(float)$row['point_sum1']}}</span>
                            <input type="text" class="hidden point_sum point_sum1"  value="{{(float)$row['point_sum1']}}" />
                        </td>
                        <td class="text-right numericX1" style="width: 100px">
                            {{(float)$row['adjust_point1'] == '0'?'':(float)$row['adjust_point1']}}
                        </td>
                        <td class="text-left td_rank_nm1" style="width: 100px" num="16">
                            <span class="td_rank_nm">{{$row['rank_nm1']}}</span>
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds1']}}" />
                            <select class="form-control input-sm rank_kinds1 rank_kinds hidden" >
                                <option value=""></option>
                                @foreach($rank_combo as $list)
                                    <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds1'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                        {{$list['rank_nm']}}
                                    </option>
                                @endforeach
                            </select>
                        </td>
                    @elseif( ($row['max_rate_status_1'] >= 1 ||$table[0]['rater_step'] == 5 || $row['max_feedback_status'] == 1)&& $row['m0100_step'] >= 1 )
                    <td></td>
                    <td class=''></td>
                    <td num="16"><input type="hidden" class="order_by" value="0" /></td>
                    @endif

                    {{-- rater 2 --}}
                    @if( ($row['rater_status'] == 2 || $row['final_rater_status'] == 5) && $row['current_rater_step'] == 2 && $row['confirm_last_step'] != 1 &&$row['m0100_step'] >= 2 && $row['accept_input'] <> 0)

                    <td class="numeric"   >
                            <span class="point_sum2_view">{{(float)$row['point_sum2']== '0'?'':(float)$row['point_sum2']}}</span>
                            <input type="text" class="hidden point_sum point_sum2"  value="{{(float)$row['point_sum2']}}" />
                        </td>
                        @if($row['adjustpoint_input_2'] == 1 && $row['accept_input'] <> 0)
                            <td class="" style="width: 100px">
                                <span class="num-length text-overfollow numericX2" data-toggle="tooltip" title="{{(float)$row['adjustpoint_from_2']}}~{{(float)$row['adjustpoint_to_2']}}" >
                                    <input type="tel" class="form-control numeric adjust_point reduce_point2 adjust_point2 text-right" maxlength="6" value="{{(float)$row['adjust_point2'] == '0'?'':(float)$row['adjust_point2']}}" negative='true' decimal='2' maxlengthfixed='6' fixed
                                        point_sum = 'point_sum2'
                                    >
                                    <input type="text" class="step2_point_status hidden" value="{{(float)($row['adjustpoint_input_2'] == 0)?0:1 }}" />
                                    <input type="text" class="adjustpoint_from hidden" value="{{(float)$row['adjustpoint_from_2']}}" />
                                    <input type="text" class="adjustpoint_to hidden" value="{{(float)$row['adjustpoint_to_2']}}" />
                                </span>
                            </td>


                        @elseif($row['confirm_typ'] == 1)
                            <td class="text-right numericX2" style="width: 100px">
                                {{(float)$row['adjust_point2'] == '0'?'':(float)$row['adjust_point2']}}
                            </td>
                        @else
                            <td></td>
                        @endif
                        @if($row['rank_change_2'] == 1 &&  $row['accept_input'] <> 0)
                            <td class="text-left" style="width: 100px" num="17">
                                <select name="" id="" class="form-control input-sm rank_kinds2 rank_kinds" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds2'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds2']??0}}" />
                            </td>
                        @elseif($row['confirm_typ'] == 1 || ($row['accept_input'] <> 0 && $row['current_rater_step'] == 2 ))
                            <td class="text-left" style="width: 100px" num="17">
                                <span class="td_rank_nm">{{$row['rank_nm2']}}</span>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds2']}}" />
                                <select name="" id="" class="form-control input-sm rank_kinds2 rank_kinds hidden" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds2'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                            </td>
                        @else
                            <td></td>
                        @endif
                    @elseif( (($row['rater_status'] > 2 && $row['confirm_at_step'] >= 2 )
                             || ($row['accept_input'] != 0 && $row['rater_status'] == 2)
                            || ($row['final_rater_status'] == 5 &&($row['current_rater_step'] > 2
                            || ($row['current_rater_step'] == 2 && $row['accept_input'] != 0)))
                            || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 2)
                        <td class="numeric"   >
                            <span class="point_sum2_view">{{(float)$row['point_sum2'] == '0'?'':(float)$row['point_sum2']}}</span>
                            <input type="text" class="hidden point_sum point_sum2"  value="{{(float)$row['point_sum2']}}" />
                        </td>
                        <td class="text-right " style="width: 100px">
                            {{(float)$row['adjust_point2'] == '0'?'':(float)$row['adjust_point2']}}
                        </td>
                        <td class="text-left" style="width: 100px" num="17">
                            <span class="td_rank_nm">{{$row['rank_nm2']}}</span>
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds2']}}" />
                            <select name="" id="" class="form-control input-sm rank_kinds2 rank_kinds hidden" >
                                <option value=""></option>
                                @foreach($rank_combo as $list)
                                    <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds2'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                        {{$list['rank_nm']}}
                                    </option>
                                @endforeach
                            </select>
                        </td>
                    @elseif( ($row['max_rate_status_1'] >= 2 ||$table[0]['rater_step'] == 5 || $row['max_feedback_status'] == 1)&& $row['m0100_step'] >= 2)
                    <td></td>
                    <td class=""></td>
                    <td num="17"><input type="hidden" class="order_by" value="0" /></td>
                    @endif

                    {{-- rater 3 --}}
                    @if( ($row['rater_status'] == 3 || $row['final_rater_status'] == 5) && $row['current_rater_step'] == 3 && $row['confirm_last_step'] != 1 &&$row['m0100_step'] >= 3 && $row['accept_input'] <> 0)
                        <td class="numeric"   >
                            <span class="point_sum3_view">{{(float)$row['point_sum3']  == '0'?'':(float)$row['point_sum3']}}</span>
                            <input type="text" class="hidden point_sum point_sum3"  value="{{(float)$row['point_sum3']}}" />
                        </td>
                        @if($row['adjustpoint_input_3'] == 1 &&  $row['accept_input'] <> 0)
                            <td class="" style="width: 100px">
                                <span class="num-length text-overfollow" data-toggle="tooltip" title="{{(float)$row['adjustpoint_from_3']}}~{{(float)$row['adjustpoint_to_3']}}">
                                    <input type="tel" class="form-control adjust_point reduce_point3 adjust_point3 numeric text-right" maxlength="6" value="{{(float)$row['adjust_point3'] == '0'?'':(float)$row['adjust_point3']}}" negative='true' decimal='2' maxlengthfixed='6' fixed
                                        point_sum = 'point_sum3'
                                    >
                                    <input type="text" class="step3_point_status hidden" value="{{((float)$row['adjustpoint_input_3'] == 0)?0:1 }}" />
                                    <input type="text" class="adjustpoint_from hidden" value="{{(float)$row['adjustpoint_from_3']}}" />
                                    <input type="text" class="adjustpoint_to hidden" value="{{(float)$row['adjustpoint_to_3']}}" />
                                </span>
                            </td>
                        @elseif($row['confirm_typ'] == 1)
                            <td class="text-right numericX3" style="width: 100px">
                                {{(float)$row['adjust_point3'] == '0'?'':(float)$row['adjust_point3']}}
                            </td>
                        @else
                            <td></td>
                        @endif
                        @if($row['rank_change_3'] == 1 &&  $row['accept_input'] <> 0)
                            <td class="text-left" style="width: 100px" num="18">
                                <select name="" id="" class="form-control input-sm rank_kinds3 rank_kinds" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds3'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds3']??0}}" />
                            </td>
                        @elseif($row['confirm_typ'] == 1 || ($row['accept_input'] <> 0 && $row['current_rater_step'] == 3 ))
                            <td class="text-left" style="width: 100px" num="18">
                                <span class="td_rank_nm">{{$row['rank_nm3']}}</span>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds3']}}" />
                                <select name="" id="" class="form-control input-sm rank_kinds3 rank_kinds hidden" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds3'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                            </td>
                        @else
                            <td></td>
                        @endif
                    @elseif( (($row['rater_status'] > 3 && $row['confirm_at_step'] >= 3 )
                             || ($row['rater_status'] == 3 && $row['accept_input'] != 0)
                            || ($row['final_rater_status'] == 5 &&($row['current_rater_step'] > 3
                            || ($row['current_rater_step'] == 3 && $row['accept_input'] != 0)))
                            || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 3)
                        <td class="numeric"   >
                            <span class="point_sum3_view">{{(float)$row['point_sum3'] == '0'?'':(float)$row['point_sum3']}}</span>
                            <input type="text" class="hidden point_sum point_sum3"  value="{{(float)$row['point_sum3']}}" />
                        </td>
                        <td class="text-right numericX3" style="width: 100px">
                            {{(float)$row['adjust_point3'] == '0'?'':(float)$row['adjust_point3']}}
                        </td>
                        <td class="text-left" style="width: 100px" num="18">
                            <span class="td_rank_nm">{{$row['rank_nm3']}}</span>
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds3']}}" />
                            <select name="" id="" class="form-control input-sm rank_kinds3 rank_kinds hidden" >
                                <option value=""></option>
                                @foreach($rank_combo as $list)
                                    <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds3'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                        {{$list['rank_nm']}}
                                    </option>
                                @endforeach
                            </select>
                        </td>
                    @elseif( ($row['max_rate_status_1'] >= 3 ||$table[0]['rater_step'] == 5 || $row['max_feedback_status'] == 1)&& $row['m0100_step'] >= 3)
                    <td></td>
                    <td class="numericX3"></td>
                    <td num="18"><input type="hidden" class="order_by" value="0" /></td>
                    @endif

                    {{-- rater 4 --}}
                    @if( ($row['rater_status'] == 4 || $row['final_rater_status'] == 5) && $row['current_rater_step'] == 4 && $row['confirm_last_step'] != 1 && $row['m0100_step'] >= 4 && $row['accept_input'] <> 0)
                        <td class="numeric"   >
                            <span class="point_sum4_view">{{(float)$row['point_sum4']  == '0'?'':(float)$row['point_sum4']}}</span>
                            <input type="text" class="hidden point_sum point_sum4"  value="{{(float)$row['point_sum4']}}" />
                        </td>
                        @if($row['adjustpoint_input_4'] == 1 &&  $row['accept_input'] <> 0)
                            <td class="" style="width: 100px">
                                <span class="num-length text-overfollow" data-toggle="tooltip" title="{{(float)$row['adjustpoint_from_4']}}~{{(float)$row['adjustpoint_to_4']}}">
                                    <input type="tel" class="form-control adjust_point reduce_point4 numeric adjust_point4 text-right" maxlength="6" value="{{(float)$row['adjust_point4'] == '0'?'':(float)$row['adjust_point4']}}" negative='true' decimal='2' maxlengthfixed='6' fixed
                                    point_sum = 'point_sum4'>
                                    <input type="text" class="step4_point_status hidden" value="{{((float)$row['adjustpoint_input_4'] == 0)?0:1 }}" />
                                    <input type="text" class="adjustpoint_from hidden" value="{{(float)$row['adjustpoint_from_4']}}" />
                                    <input type="text" class="adjustpoint_to hidden" value="{{(float)$row['adjustpoint_to_4']}}" />
                                </span>
                            </td>
                        @elseif($row['confirm_typ'] == 1)
                            <td class="text-right numericX4" style="width: 100px">
                                {{(float)$row['adjust_point4'] == '0'?'':(float)$row['adjust_point4']}}
                            </td>
                        @else
                            <td></td>
                        @endif
                        @if($row['rank_change_4'] == 1 &&  $row['accept_input'] <> 0)
                            <td class="text-left" style="width: 100px" num="19">
                                <select name="" id="" class="form-control input-sm rank_kinds4 rank_kinds" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds4'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds4']??0}}" />
                            </td>
                        @elseif($row['confirm_typ'] == 1 || ($row['accept_input'] <> 0 && $row['current_rater_step'] == 4 ))
                            <td class="text-left" style="width: 100px" num="19">
                                <span class="td_rank_nm">{{$row['rank_nm4']}}</span>
                                <input type="hidden" class="order_by" value="{{$row['rank_kinds4']}}" />
                                <select name="" id="" class="form-control input-sm rank_kinds4 rank_kinds hidden" >
                                    <option value=""></option>
                                    @foreach($rank_combo as $list)
                                        <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds4'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                            {{$list['rank_nm']}}
                                        </option>
                                    @endforeach
                                </select>
                            </td>
                        @else
                            <td></td>
                        @endif
                    @elseif( (($row['rater_status'] > 4 && $row['confirm_at_step'] >= 4 )
                            || ($row['rater_status'] == 4 && $row['accept_input'] != 0)
                            || ($row['final_rater_status'] == 5 &&($row['current_rater_step'] > 4
                            ||($row['current_rater_step'] == 4 && $row['accept_input'] != 0)))
                            || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 4)
                        <td class="numeric">
                            <span class="point_sum4_view">{{(float)$row['point_sum4']  == '0'?'':(float)$row['point_sum4']}}</span>
                            <input type="text" class="hidden point_sum point_sum4"  value="{{(float)$row['point_sum4']}}" />
                        </td>
                        <td class="text-right " style="width: 100px">
                            {{(float)$row['adjust_point4'] == '0'?'':(float)$row['adjust_point4']}}
                        </td>
                        <td class="text-left" style="width: 100px" num="19">
                            <span class="td_rank_nm">{{$row['rank_nm4']}}</span>
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds4']}}" />
                            <select name="" id="" class="form-control input-sm rank_kinds4 rank_kinds hidden" >
                                <option value=""></option>
                                @foreach($rank_combo as $list)
                                    <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds4'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                        {{$list['rank_nm']}}
                                    </option>
                                @endforeach
                            </select>
                        </td>
                    @elseif( ($row['max_rate_status_1'] >= 4 ||$table[0]['rater_step'] == 5|| $row['max_feedback_status'] == 1)&& $row['m0100_step'] >= 4)
                    <td></td>
                    <td class="numericX4"></td>
                    <td num="19"><input type="hidden" class="order_by" value="0" /></td>
                    @endif
                @endif
                {{-- rater 5 最終評価 --}}
                    @if(($row['final_rater_status'] == 5 && ($row['confirm_last_step_final'] == 1|| ($row['sheet_use_typ'] == 0 && $row['authority'] == 0))))
                        <!-- 評価点 -->
                        @if($row['final_evaluation_can_edited'] > 0)
                        <td class="numeric">
                            <span class="point_sum5_view">{{(float)$row['point_sum5']== '0'?'':(float)$row['point_sum5']}}</span>
                            <input type="text" class="hidden point_sum point_sum5"  value="{{(float)$row['point_sum5']}}" />
                        </td>
                        @else
                        <td class="numeric">
                            <input type="text" class="hidden point_sum point_sum5"  value="{{(float)$row['point_sum5']}}" />
                        </td>
                        @endif
                        <!-- 評語 -->
                        @if($row['final_evaluation_can_edited'] == 2)
                        <td class="text-left" style="width: 150px" num="20">
                            <select name="" id="" class="form-control input-sm rank_kinds5 rank_kinds" >
                                <option value=""></option>
                                @foreach($rank_combo as $list)
                                    <option value="{{$list['rank_cd']}}" {{$list['rank_cd'] == $row['rank_kinds5'] ? 'selected' : ''}} point_from = "{{$list['points_from']}}" point_to = "{{$list['points_to']}}">
                                        {{$list['rank_nm']}}
                                    </option>
                                @endforeach

                            </select>
                            <input type="hidden" class="m0050_rank" value="" />
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds5']??0}}" />
                        </td>
                        @elseif ($row['final_evaluation_can_edited'] == 1)
                        <td num="20">
                            {{$row['rank_nm5']}}
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds5']??0}}" />
                        </td>
                        @else
                        <td num="20"><input type="hidden" class="order_by" value="0" /></td>                        
                        @endif
                    @elseif($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)
                        <!-- 評価点 -->
                        <td class="numeric">
                            <span class="point_sum5_view">{{(float)$row['point_sum5']== '0'?'':(float)$row['point_sum5']}}</span>
                            <input type="text" class="hidden point_sum point_sum5"  value="{{(float)$row['point_sum5']}}" />
                        </td>
                        <!-- 評語 -->
                        <td class="text-left" style="width: 100px" num="20">
                            {{$row['rank_nm5']}}
                            <input type="hidden" class="order_by" value="{{$row['rank_kinds5']}}" />
                        </td>
                    @elseif($row['max_feedback_status'] == 1 || ($row['max_last_confirm']??0 == 1)&& $row['final_rater_status'] == 5 || $row['rater_step'] == 5)
                        <!-- 評価点 -->
                        <td></td>
                        <!-- 評語 -->
                        <td num="20"><input type="hidden" class="order_by" value="0" /></td>
                    @endif
                    <td class="text-left td_comment" >
                        <div class="input-group">
                            <!-- when step rater 2 then show prev comment -->
                            @if($row['sheet_use_typ'] == 1 && $row['current_rater_step'] > 1)
                                <div class="input-group-prepend">
                                    <div class="input-group-text" style="padding: 0px">
                                        <button class="btn btn-transparent btn_show_comment" type="button" tabindex="-1">
                                            <i class="fa fa-search"></i>
                                    </div>
                                </div>
                            @endif
                            <span class="num-length wd-85">
                                <textarea  rows="1" type="text" class="form-control input-sm comment" maxlength="100" >{{$row['comment']}}</textarea>
                            </span>
                        </div>
                    </td>
                    <td>
                        <div class="text-overfollow  employee-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['treatment_applications_nm']}}">{{$row['treatment_applications_nm']}}</div>
                        <input type="text" class="form-control input-sm treatment_applications_no_1 hidden" maxlength="100" value="{{$row['treatment_applications_no']}}">
                        <input type="text" class="form-control input-sm treatment_applications_nm hidden" maxlength="100" value="{{$row['treatment_applications_nm']}}">
                    </td>
                    @if($sheet_use_typ ?? 1 == 1)
                        @for ($i = 1; $i <= $max_sheet; $i++)
                            <?php
                                $pieces_of_sheet =  [];
                                $pieces_of_sheet =  explode("/",$row[$i]);
                            ?>
                            <td class="text-left {{isset($pieces_of_sheet[5])?'sheet_cd_click':''}}" style="width: 130px">
                                <a  href="#">
                                    <div class="text-overfollow  employee-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$pieces_of_sheet[5]??''}}">{{$pieces_of_sheet[5]??''}}</div>
                                </a>
                                <input type="text" class="hidden sheet_cd"  value="{{$pieces_of_sheet[6]??''}}" />
                                <input type="text" class="hidden sheet_kbn"  value="{{$pieces_of_sheet[7]??''}}" />
                            </td>
                            @if((($row['current_rater_step'] == 1 && ($pieces_of_sheet[8]??'') == 1)||($row['current_rater_step'] > 1)) && ($row['max_rate_status_1'] >= 1 || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 1  )
                            <td class="text-right" style="width: 100px">{{isset($pieces_of_sheet[0])?((float)$pieces_of_sheet[0] == 0 ? '' :(float)$pieces_of_sheet[0]):''}}</td>
                            @elseif( ( $row['max_rate_status_1'] >= 1 || $row['max_feedback_status']  == 1)&&$row['m0100_step'] >= 1)
                            <td></td>
                            @endif
                            @if((($row['current_rater_step'] == 2 && ($pieces_of_sheet[8]??'') == 1)||($row['current_rater_step'] > 2 ))&& ($row['max_rate_status_1'] >= 2 || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1))&& $row['m0100_step'] >= 2  )
                            <td class="text-right" style="width: 100px">{{isset($pieces_of_sheet[1])?((float)$pieces_of_sheet[1] == 0?'':(float)$pieces_of_sheet[1]):''}}</td>
                            @elseif( ($row['max_rate_status_1'] >= 2 || $row['max_feedback_status']  == 1) &&$row['m0100_step'] >= 2)
                            <td></td>
                            @endif
                            @if((($row['current_rater_step'] == 3 && ($pieces_of_sheet[8]??'') == 1)||($row['current_rater_step'] > 3 ))&& ($row['max_rate_status_1'] >= 3 || ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 3  )
                            <td class="text-right" style="width: 100px">{{isset($pieces_of_sheet[2])?((float)$pieces_of_sheet[2]==0?'':(float)$pieces_of_sheet[2]):''}}</td>
                            @elseif( ($row['max_rate_status_1'] >= 3 || $row['max_feedback_status']  == 1)&&$row['m0100_step'] >= 3)
                            <td></td>
                            @endif
                            @if((($row['current_rater_step'] == 4 && ($pieces_of_sheet[8]??'') == 1)||($row['current_rater_step'] > 4 ))&& ($row['max_rate_status_1'] >= 4|| ($row['feed_back_status'] == 1 && $row['rater_status'] >= 1)) && $row['m0100_step'] >= 4  )
                            <td class="text-right" style="width: 100px">{{isset($pieces_of_sheet[3])?((float)$pieces_of_sheet[3]==0?'':(float)$pieces_of_sheet[3]):''}}</td>
                            @elseif( ($row['max_rate_status_1'] >= 4 || $row['max_feedback_status']  == 1)&&$row['m0100_step'] >= 4)
                            <td></td>
                            @endif
                            <td class="text-right" style="width: 100px"><span>{{isset($pieces_of_sheet[4])&&$pieces_of_sheet[4]!=''?$pieces_of_sheet[4].'%':''}}</span></td>
                        @endfor
                    @endif
                </tr>
                @endforeach
            </tbody>
            @else
                <thead>
                <tr>
                    <th class="sticky-cell " style="outline: none !important width:50px">{{ __('messages.select') }}</th>
                    @if($count_emp_info_header > 0)
                    <th class="sticky-cell change-col" colspan="{{$count_emp_info_header}}" class="text-center" style="max-width: 500px">{{ __('messages.employee_info') }}</th>
                    @endif
                    @if($count_prev_year_header > 0)
                    <th class=" change-col" colspan="{{$count_prev_year_header}}" class="text-center" style="max-width: 100px">{{ __('messages.past_eval') }}</th>
                    @endif
                    @if($sheet_use_typ??1 == 1)
                        <th colspan="3" style="min-width: 100px" class="text-center">{{ __('messages.eval_1st') }}</th>
                        <th colspan="3" style="min-width: 100px" class="text-center">{{ __('messages.eval_2nd') }}</th>
                        <th colspan="3" style="min-width: 100px" class="text-center">{{ __('messages.eval_3rd') }}</th>
                        <th colspan="3" style="min-width: 100px" class="text-center">{{ __('messages.eval_4th') }}</th>
                    @endif
                    <th colspan="2" style="min-width: 100px" class="text-center">{{ __('messages.final_eval') }}</th>
                    <th colspan="2" style="min-width: 100px" class="text-center">{{ __('messages.comment') }}</th>
                    @if($sheet_use_typ??1 == 1)
                        <th colspan="6" style="min-width: 100px" class="text-center"></th>
                    @endif
                </tr>
                <tr>
                    <th class="sticky-cell text-center nosort">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input name="ck_all" id="ck_all" type="checkbox">
                            <label for="ck_all"></label>
                        </div>
                    </th>
                    @if(!empty($emp_info_header) )
                    @foreach($emp_info_header as $hd)
                        <th class="sticky-cell text-center  w_col_detail1" num="{{$hd['item_cd']}}">
                            {{-- <div class="text-overfollow  employee-overfollow header-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$hd['item_nm']}}"> --}}
                                {{$hd['item_nm']}}
                            {{-- </div> --}}
                            <span><i class="fa fa-sort sort"></i></span>
                    </th>
                    @endforeach
                    @endif
                    @if(!empty($prev_year_header))
                    @foreach($prev_year_header as $hd2)
                        <th class="text-center  w_col_detail1" num="{{$hd2['item_cd']}}">
                            {{$hd2['item_nm']}}
                    </th>
                    @endforeach
                    @endif
                {{-- end of 社員情報--}}
                    @if($sheet_use_typ??1 == 1 )
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.rank') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.rank') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.rank') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.adjustment_point') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.rank') }}</th>
                    @endif
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_points') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.rank') }}</th>
                    <th style="min-width: 100px" >{{ __('messages.comment') }}</th>
                    <th style="min-width: 100px" style="white-space: nowrap;">{{ __('messages.treatment_use') }}</th>
                    @if($sheet_use_typ??1 == 1 )
                    <th xxx class="text-center" style="min-width: 100px">{{ __('messages.evaluation_sheet') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_1st') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_2nd') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_3rd') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.eval_4th') }}</th>
                    <th class="text-center" style="min-width: 100px">{{ __('messages.weight') }}</th>
                    @endif
                </tr>
            </thead>
            <tbody>
                <tr class="tr_first">
                    <td colspan="{{32+$count_prev_year_header+$count_emp_info_header}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                </tr>
            </tbody>
            @endif
        </table>
    </div><!-- end .table-responsive -->
</div><!-- end #sample2 -->