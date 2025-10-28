<div class="col-md-12">
    <div class="row">
        <div class="col-12 col-md-12 col-lg-12 wmd-view table-responsive sticky-table sticky-headers sticky-ltr-cells _width" style="max-height: 60vh">
            <table class="table table-bordered table-hover ofixed-boder" id="table-data">
                <thead>
                    <tr>
                        <th style="white-space: pre; padding-left:16px; padding-right:16px; min-width:110px">{{ __('rm0310.report_type') }}</th>
                        <th style="width:15%">{{ __('rm0310.group') }}</th>
                        <th style="width:15%">{{ __('rm0310.first_pos_approver') }}</th>
                        <th style="width:15%">{{ __('rm0310.second_pos_approver') }}</th>
                        <th style="width:15%">{{ __('rm0310.third_pos_approver') }}</th>
                        <th style="width:15%">{{ __('rm0310.fourth_pos_approver') }}</th>
                        <th>{{ __('rm0310.sheet') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @if(isset($data[0][0]['annualreport_first_approval']))
                    @foreach($data[0] as $row)
                    <tr class="data_group">
                        <td class="text-left error_group" value="{{$row['report_kind']}}">{{$row['report_nm']}}</td>
                        <td class="text-left error_group" value="{{$row['group_cd']}}">{{$row['group_nm']}}</td>
                        <input type="hidden" class="report" value="{{$row['report_kind']}}"></td>
                        <input type="hidden" class="group" value="{{$row['group_cd']}}"></td>

                        <td class="text-center">
                            @if($row['annualreport_first_approval'] == 1)
                            <select class="form-control item-first select-class_active select-class position_1" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_1'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                            <select class="form-control item-first  select-class position_1" disabled tabindex="1">
                            </select>
                            @endif
                        </td>
                        <td class="text-center">
                            @if($row['annualreport_second_approval'] == 1)
                            <select class="form-control item-first select-class_active select-class position_2" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_2'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                            <select class="form-control item-first  select-class position_2" disabled tabindex="1">
                            </select>
                            @endif
                        </td>
                        <td class="text-center">
                            @if($row['annualreport_third_approval'] == 1)
                            <select class="form-control item-first select-class_active select-class position_3" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_3'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                            <select class="form-control item-first  select-class position_3" disabled tabindex="1">
                            </select>
                            @endif
                        </td>
                        <td class="text-center">
                            @if($row['annualreport_fourth_approval'] == 1)
                            <select class="form-control item-first select-class_active select-class position_4" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_4'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                            <select class="form-control item-first  select-class position_4" disabled tabindex="1">
                            </select>
                            @endif
                        </td>
                        <td class="text-center">
                            <select class="form-control item-first  select-class required sheet_cd" tabindex="1">
                                <option hidden value="-1"></option>
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==0  && $row['sheet_cd'] !='' ? 'selected':''}} value="0">{{ __('rm0310.exclude') }}</option>
                                @if(isset($data[6]))
                                @foreach($data[6] as $row_sheet)
                                {{ $row_sheet['report_kind']}}
                                @if($row_sheet['report_kind'] == 1)
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==$row_sheet['sheet_cd'] ? 'selected':''}} value="{{$row_sheet['sheet_cd']}}">{{$row_sheet['sheet_nm']}}</option>
                                @endif
                                @endforeach
                                @else
                                <option value="0">{{ __('rm0310.exclude') }}</option>
                                @endif
                            </select>
                        </td>
                    </tr>
                    @endforeach
                    @endif
                    @if(isset($data[1][0]['semi_annualreport_second_approval']))
                    @foreach($data[1] as $row)
                    <tr class="data_group">
                        <td class="text-left error_group" value="{{$row['report_kind']}}">{{$row['report_nm']}}</td>
                        <td class="text-left error_group" value="{{$row['group_cd']}}">{{$row['group_nm']}}</td>
                        <input type="hidden" class="report" value="{{$row['report_kind']}}"></td>
                        <input type="hidden" class="group" value="{{$row['group_cd']}}"></td>

                        <td class="text-center">
                            @if($row['semi_annualreport_first_approval'] == 1)
                            <select class="form-control item-first select-class_active select-class position_1" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_1'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control item-first  select-class position_1" disabled tabindex="1">
                            </select>
                            @endif
                        </td>
                        <td class="text-center">
                            @if($row['semi_annualreport_second_approval'] == 1)
                            <select class="form-control select-class_active select-class position_2" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_2'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control item-first  select-class position_2" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['semi_annualreport_third_approval'] == 1)
                            <select class="form-control select-class_active select-class position_3" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_3'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control item-first  select-class position_3" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['semi_annualreport_fourth_approval'] == 1)
                            <select class="form-control select-class_active select-class position_4" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_4'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control item-first  select-class position_4" disabled tabindex="1">
                            </select>
                            @endif
                        </td>

                        <td class="text-center">
                            <select class="form-control item-first  select-class sheet_cd required" tabindex="1">
                            <option hidden value="-1"></option>
                            <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==0 && $row['sheet_cd'] !='' ? 'selected':''}} value="0">{{ __('rm0310.exclude') }}</option>
                                @if(isset($data[6]))
                                @foreach($data[6] as $row_sheet)
                                @if($row_sheet['report_kind'] == 2)
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==$row_sheet['sheet_cd'] ? 'selected':''}} value="{{$row_sheet['sheet_cd']}}">{{$row_sheet['sheet_nm']}}</option>
                                @endif
                                @endforeach
                                @else
                                <option value="0">{{ __('rm0310.exclude') }}</option>
                                @endif
                            </select>
                        </td>
                    </tr>
                    @endforeach
                    @endif
                    @if(isset($data[2][0]['quarterlyreport_first_approval']))
                    @foreach($data[2] as $row)
                    <tr class="data_group">
                        <td class="text-left error_group" value="{{$row['report_kind']}}">{{$row['report_nm']}}</td>
                        <td class="text-left error_group" value="{{$row['group_cd']}}">{{$row['group_nm']}}</td>
                        <input type="hidden" class="report" value="{{$row['report_kind']}}"></td>
                        <input type="hidden" class="group" value="{{$row['group_cd']}}"></td>

                        <td class="text-center">
                            @if($row['quarterlyreport_first_approval'] == 1)
                            <select class="form-control select-class_active select-class position_1" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_1'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control  select-class position_1" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['quarterlyreport_second_approval'] == 1)
                            <select class="form-control select-class_active select-class position_2" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_2'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_2" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['quarterlyreport_third_approval'] == 1)
                            <select class="form-control select-class_active select-class position_3" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_3'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control  select-class position_3" disabled tabindex="1">
                            </select>
                            @endif
                        </td>

                        <td class="text-center">
                            @if($row['quarterlyreport_fourth_approval'] == 1)
                            <select class="form-control select-class_active select-class position_4" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_4'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control item-first  select-class position_4" disabled tabindex="1">
                            </select>
                            @endif
                        </td>

                        <td class="text-center">
                            <select class="form-control item-first  select-class sheet_cd required" tabindex="1">
                                <option hidden value="-1"></option>
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==0 && $row['sheet_cd'] !='' ? 'selected':''}} value="0">{{ __('rm0310.exclude') }}</option>
                                @if(isset($data[6]))
                                @foreach($data[6] as $row_sheet)
                                @if($row_sheet['report_kind'] == 3)
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==$row_sheet['sheet_cd'] ? 'selected':''}} value="{{$row_sheet['sheet_cd']}}">{{$row_sheet['sheet_nm']}}</option>
                                @endif
                                @endforeach
                                @else
                                <option value="0">{{ __('rm0310.exclude') }}</option>
                                @endif
                            </select>
                        </td>
                    </tr>
                    @endforeach
                    @endif
                    @if(isset($data[3][0]['monthlyreport_first_approval']))
                    @foreach($data[3] as $row)
                    <tr class="data_group">
                        <td class="text-left error_group" value="{{$row['report_kind']}}">{{$row['report_nm']}}</td>
                        <td class="text-left error_group" value="{{$row['group_cd']}}">{{$row['group_nm']}}</td>
                        <input type="hidden" class="report" value="{{$row['report_kind']}}"></td>
                        <input type="hidden" class="group" value="{{$row['group_cd']}}"></td>

                        <td class="text-center">
                            @if($row['monthlyreport_first_approval'] == 1)
                            <select class="form-control select-class_active select-class position_1" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_1'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_1" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['monthlyreport_second_approval'] == 1)
                            <select class="form-control select-class_active select-class position_2" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_2'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control  select-class position_2" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['monthlyreport_third_approval'] == 1)
                            <select class="form-control select-class_active select-class select-class_active position_3" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_3'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_3" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['monthlyreport_fourth_approval'] == 1)
                            <select class="form-control select-class_active select-class select-class_active position_4" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_4'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class  position_4" disabled tabindex="1">
                            </select>
                            @endif
                        </td>

                        <td class="text-center">
                            <select class="form-control item-first  select-class sheet_cd required" tabindex="1">
                                <option hidden value="-1"></option>
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==0  && $row['sheet_cd'] !='' ? 'selected':''}} value="0">{{ __('rm0310.exclude') }}</option>
                                @if(isset($data[6]))
                                @foreach($data[6] as $row_sheet)
                                @if($row_sheet['report_kind'] == 4)
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==$row_sheet['sheet_cd'] ? 'selected':''}} value="{{$row_sheet['sheet_cd']}}">{{$row_sheet['sheet_nm']}}</option>
                                @endif
                                @endforeach
                                @else
                                <option value="0">{{ __('rm0310.exclude') }}</option>
                                @endif
                            </select>
                        </td>
                    </tr>
                    @endforeach
                    @endif
                    @if(isset($data[4][0]['weeklyreport_first_approval']))
                    @foreach($data[4] as $row)
                    <tr class="data_group">
                        <td class="text-left error_group" value="{{$row['report_kind']}}">{{$row['report_nm']}}</td>
                        <td class="text-left error_group" value="{{$row['group_cd']}}">{{$row['group_nm']}}</td>
                        <input type="hidden" class="report" value="{{$row['report_kind']}}"></td>
                        <input type="hidden" class="group" value="{{$row['group_cd']}}"></td>

                        <td class="text-center">
                            @if($row['weeklyreport_first_approval'] == 1)
                            <select class="form-control select-class_active select-class position_1" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_1'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_1" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['weeklyreport_second_approval'] == 1)
                            <select class="form-control select-class_active select-class position_2" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_2'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_2" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['weeklyreport_third_approval'] == 1)
                            <select class="form-control select-class_active select-class position_3" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_3'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control  select-class position_3" disabled tabindex="1">
                            </select>
                            @endif
                        </td>


                        <td class="text-center">
                            @if($row['weeklyreport_fourth_approval'] == 1)
                            <select class="form-control select-class_active select-class position_4" tabindex="1">
                                <option value="-1"></option>
                                @if(isset($data[5]))
                                @foreach($data[5] as $row_position)
                                <option {{$row['approver_position_cd_4'] == $row_position['position_cd'] ? 'selected':''}} value="{{$row_position['position_cd']}}">{{$row_position['position_nm']}}</option>
                                @endforeach
                                @endif
                            </select>
                            @else
                        <select class="form-control select-class position_4" disabled tabindex="1">
                            </select>
                            @endif
                        </td>

                        <td class="text-center">
                            <select class="form-control item-first  select-class sheet_cd required" tabindex="1">
                                <option hidden value="-1"></option>
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==0  && $row['sheet_cd'] !='' ? 'selected':''}} value="0">{{ __('rm0310.exclude') }}</option>
                                @if(isset($data[6]))
                                @foreach($data[6] as $row_sheet)
                                @if($row_sheet['report_kind'] == 5)
                                <option {{isset($row['sheet_cd']) && $row['sheet_cd'] ==$row_sheet['sheet_cd'] ? 'selected':''}} value="{{$row_sheet['sheet_cd']}}">{{$row_sheet['sheet_nm']}}</option>
                                @endif
                                @endforeach
                                @else
                                <option selected value="0">{{ __('rm0310.exclude') }}</option>
                                @endif
                            </select>
                        </td>
                    </tr>
                    @endforeach
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div>