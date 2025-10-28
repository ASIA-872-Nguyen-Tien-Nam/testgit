<nav class="pager-wrap">
    {!! Paging::show($paging ?? []) !!}
</nav>
{{-- <div class="row">
        <div class="col-md-12 ">
            <div class="wmd-view-topscroll">
                <div class="scroll-div1"></div>
            </div>
        </div>
    </div><!-- end .row --> --}}
<div class="hide">
    <table class="table table-bordered table-hover" id="table_data">
        <tbody>
            <tr class="tr_first">
                <input type="hidden" class="pos_emp" value=""/>
                <input type="hidden" class="employee_cd emp_add_cd key_emp" value="" />
                <td class="sticky-cell text-center">
                    <div id="" class="md-checkbox-v2 inline-block">
                            <input name="chk-item" class="checkbox_row chk-item" id="ckb" type="checkbox">
                            <label for="ckb"></label>
                            <input type="hidden" class="check_exist" />
                    </div>
                </td>
                <td class="sticky-cell emp_add_cd" style="min-width:100px">
                    <span class="num-length">
                        <div class="input-group-btn input-group">
                            <span class="num-length">
                                <input type="hidden" class="employee_cd" />
                                <input type="text" id="" class="form-control indexTab  add_emp add_approver_employee_nm" tabindex="-1" maxlength="20" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn row_add_emp_cd">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                <td class="sticky-cell emp_add_nm"></td>
                @if(isset($organization_group))
                @if(isset($organization_group[0]['organization_group_nm']))
                <td class="belong_nm_1"></td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=2)
                <td class="belong_nm_2"></td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=3)
                <td class="belong_nm_3"></td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=4)
                <td class="belong_nm_4"></td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=5)
                <td class="belong_nm_5"></td>
                @endif
                @endif
                <td class="position"></td>
                <td class="job_title"></td>
                <td class="rank"></td>
                <td class="emp_typ"></td>
                @if(isset($col[0]) && $col[0]['first_col']!=0)
                <td class="min-w150px col12  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="" class="rate" data-approver="1" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_1" value="" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm approver_employee_nm_1 error_approver_emp_1 employee_nm_weeklyreport min-width" maxlength="101" old_approver_employee_nm="" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['second_col']!=0)
                <td class="min-w150px col13  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="" data-approver="2" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_2" value="" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_2 approver_employee_nm_2 error_approver_emp_2 employee_nm_weeklyreport min-width" id="employee_cd" maxlength="101" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="2">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['third_col']!=0)
                <td class="min-w150px col14  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver="3" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_3" value="" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_3 approver_employee_nm_3 employee_nm_weeklyreport error_approver_emp_3 min-width" id="employee_cd" maxlength="101"  value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="3">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['fourth_col']!=0)
                <td class="min-w150px col15 ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="" data-approver="4" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_4" value="" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_4 approver_employee_nm_4 employee_nm_weeklyreport error_approver_emp_4 min-width" maxlength="101" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="4">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                <td class="td_sheet_cd" style="min-width:150px">
                    <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="">
                        {{ $list[0]['schedule_sheet_nm'] ?? '' }}
                    </label>
                    <input type="hidden" class="schedule_sheet_cd" value=" {{ $list[0]['schedule_sheet_cd'] ?? '' }}" />
                    <input type="hidden" class="schedule_adaption_date" value="{{  $list[0]['schedule_adaption_date'] ?? '' }}" />
                </td>
                <td style="min-width:150px">
                    <select class="form-control input-sm sheet err_sheet_cd sheet_cd_a">
                        <option value="0"></option>
                        @if (isset($sheet[0]))
                        @foreach($sheet as $fill)
                        <option adaption_date={{ $fill['adaption_date'] ?? '' }} value="{{$fill['sheet_cd']}}" >{{$fill['sheet_nm']}}</option>
                        @endforeach
                        @endif
                    </select>
                    <input type="hidden" class="adaption_date" value="">
                </td>
            </tr>

        </tbody>
    </table>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
    <table class="table table-bordered fixed-header sortable" id="table_result">
        <thead>
            <tr>
                <th class="sticky-cell  min-w30px">
                    <div id="checkboxAll" class="md-checkbox-v2 inline-block">
                        <label for="check-all" class="container checkbox-os0030">
                            <input name="check-all" class="check_all" id="check-all" type="checkbox">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </th>
                <th class="sticky-cell min-w90px">{{ __('messages.employee_no') }}</th>
                <th class="sticky-cell min-w90px">{{ __('messages.employee_name') }}</th>
                @if(isset($organization_group))
                @if(isset($organization_group[0]['organization_group_nm']))
                <th class="min-w90px">{{ $organization_group[0]['organization_group_nm'] }}</th>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=2)
                @if(isset($organization_group[1]['organization_group_nm']))
                <th class="min-w90px">{{ $organization_group[1]['organization_group_nm'] }}</th>
                @endif
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=3)
                @if(isset($organization_group[2]['organization_group_nm']))
                <th class="min-w90px">{{ $organization_group[2]['organization_group_nm'] }}</th>
                @endif
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=4)
                @if(isset($organization_group[3]['organization_group_nm']))
                <th class="min-w90px">{{ $organization_group[3]['organization_group_nm'] }}</th>
                @endif
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=5)
                @if(isset($organization_group[4]['organization_group_nm']))
                <th class="min-w90px">{{ $organization_group[4]['organization_group_nm'] }}</th>
                @endif
                @endif
                @endif
                <th class="min-w90px">{{ __('messages.position') }}</th>
                <th class="min-w90px">{{ __('messages.job') }}</th>
                <th class="min-w90px">{{ __('messages.grade') }}</th>
                <th class="min-w90px">{{ __('ri1020.employee_typ') }}</th>
                @if(isset($col[0]) && $col[0]['first_col']!=0)
                <th class="min-w150px">{{ __('ri1020.primary_approver') }}</th>
                @elseif(!isset($col[0]))
                <th class="min-w150px">{{ __('ri1020.primary_approver') }}</th>
                @endif
                @if(isset($col[0]) && $col[0]['second_col']!=0)
                <th class="min-w150px">{{ __('ri1020.secondary_approver') }}</th>
                @elseif(!isset($col[0]))
                <th class="min-w150px">{{ __('ri1020.secondary_approver') }}</th>
                @endif
                @if(isset($col[0]) && $col[0]['third_col']!=0)
                <th class="min-w150px">{{ __('ri1020.third_approver') }}</th>
                @elseif(!isset($col[0]))
                <th class="min-w150px">{{ __('ri1020.third_approver') }}</th>
                @endif
                @if(isset($col[0]) && $col[0]['fourth_col']!=0)
                <th class="min-w150px">{{ __('ri1020.fourth_approver') }}</th>
                @elseif(!isset($col[0]))
                <th class="min-w150px">{{ __('ri1020.fourth_approver') }}</th>
                @endif
                <th colspan="2" class="min-w150px">{{ __('ri1020.basic') }}</th>
            </tr>
        </thead>
        <tbody id="list">
            @if(isset($list[0]))
            @foreach($list as $key=> $row)
            <tr class="tr_first_value emcd {{$row['employee_cd']}}">
            <input type="hidden" class="pos_emp" value="{{$key}}"/>
                <td class="sticky-cell">
                    <div class="md-checkbox-v2 inline-block lb" style="left:15px">
                        <input name="ckb0" id="{{ "ckb0".$row['employee_cd'] }}" class="checkbox_row chk-item" type="checkbox">
                        <label for="{{ "ckb0".$row['employee_cd'] }}"></label>
                        <input type="text" class="row_result" hidden value="{{ $key +1 }}">
                        <input type="text" class="report_no" hidden value="{{ $row['report_no'] }}">
                    </div>
                </td>
                <td class="sticky-cell min-w30px">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" style="width: 90px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_cd']}}">
                            {{$row['employee_cd']}}
                        </div>
                    </label>
                    <input type="hidden" class="employee_cd key_emp" value="{{ $row['employee_cd'] }}" />
                </td>
                <td class="sticky-cell min-w90px">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">
                            {{$row['employee_nm']}}
                        </div>
                    </label>
                </td>
                @if(isset($organization_group))
                @if(isset($organization_group[0]['organization_group_nm']))
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm1']}}">
                            {{$row['belong_nm1']}}
                        </div>
                    </label>
                </td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=2)
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm2']}}">
                            {{$row['belong_nm2']}}
                        </div>
                    </label>
                </td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=3)
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm3']}}">
                            {{$row['belong_nm3']}}
                        </div>
                    </label>
                </td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=4)
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm4']}}">
                            {{$row['belong_nm4']}}
                        </div>
                    </label>
                </td>
                @endif
                @endif
                @if(isset($organization_group))
                @if(count($organization_group)>=5)
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm5']}}">
                            {{$row['belong_nm5']}}
                        </div>
                    </label>
                </td>
                @endif
                @endif
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['position_nm']}}">
                            {{$row['position_nm']}}
                        </div>
                    </label>
                </td>
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['job_nm']}}">
                            {{$row['job_nm']}}
                        </div>
                    </label>
                </td>
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['grade_nm'] }}">
                        {{ $row['grade_nm'] }}
                    </label>
                </td>
                <td class="min-w90px  ">
                    <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['employee_typ_nm'] }}">
                        {{ $row['employee_typ_nm'] }}
                    </label>
                </td>
                @if(isset($col[0]) && $col[0]['first_col']!=0)
                <td class="min-w150px col12  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="{{ $row['approver_employee_cd_1'] }}" class="rate" data-approver="1" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_1" value="{{ $row['approver_employee_cd_1'] }}" />
                                <input type="tel"  fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm approver_employee_nm_1 error_approver_emp_1 employee_nm_weeklyreport min-width" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_1'] }}" value="{{ $row['approver_employee_nm_1'] }}" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['second_col']!=0)
                <td class="min-w150px col13  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="{{ $row['approver_employee_cd_2'] }}" data-approver="2" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_2" value="{{ $row['approver_employee_cd_2'] }}" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_2 approver_employee_nm_2 employee_nm_weeklyreport error_approver_emp_2 min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_2'] }}" value="{{ $row['approver_employee_nm_2'] }}" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="2">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['third_col']!=0)
                <td class="min-w150px col14  ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="{{ $row['approver_employee_cd_3'] }}" data-approver="3" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_3" value="{{ $row['approver_employee_cd_3'] }}" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_3 approver_employee_nm_3 employee_nm_weeklyreport error_approver_emp_3 min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_3'] }}" value="{{ $row['approver_employee_nm_3'] }}" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="3">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                @if(isset($col[0]) && $col[0]['fourth_col']!=0)
                <td class="min-w150px col15 ">
                    <span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                            <input type="hidden" data-approver_position_cd="{{ $row['approver_employee_cd_4'] }}" data-approver="4" />
                            <span class="num-length">
                                <input type="hidden" class="approver_employee_cd approver_employee_cd_4" value="{{ $row['approver_employee_cd_4'] }}" />
                                <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm error_approver_emp_4 approver_employee_nm_4 employee_nm_weeklyreport error_approver_emp_4 min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_4'] }}" value="{{ $row['approver_employee_nm_4'] }}" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1" approver="4">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                @endif
                <td class="td_sheet_cd" style="min-width:150px">
                    <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="">
                        {{ $row['schedule_sheet_nm'] ?? '' }}
                    </label>
                    <input type="hidden" class="schedule_sheet_cd" value="{{ $row['schedule_sheet_cd'] ?? '' }}" />
                    <input type="hidden" class="schedule_adaption_date" value="{{ $row['schedule_adaption_date'] ?? '' }}" />
                </td>
                <td style="min-width:150px">
                    <select class="form-control input-sm sheet err_sheet_cd sheet_cd_a {{ (isset($row['schedule_sheet_cd']) && $row['schedule_sheet_cd']>0) ? '':'required_sheet'}}">
                        <option value="0"></option>
                        @if (isset($sheet[0]))
                        @foreach($sheet as $fill)
                        <option adaption_date={{ $fill['adaption_date'] ?? '' }} value="{{$fill['sheet_cd']}}" {{ (isset($row['sheet_cd']) && $row['sheet_cd'] == $fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                        @endforeach
                        @endif
                    </select>
                    <input type="hidden" class="adaption_date" value="{{ $row['adaption_date'] ?? '' }}">
                </td>
            </tr>
            @endforeach
            @else
            <tr class="">
                <td colspan="100" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
            </tr>
            @endif
        </tbody>
    </table>
    <input type="hidden" id="status" value="{{ isset($check[0]) ? $check[0]['status'] : 'OK' }}" />
    <input type="file" id="import_file" style="display: none" accept=".csv">
</div><!-- end .table-responsive -->
<div class="row block_save_button_bottom justify-content-md-center">
    {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
</div>