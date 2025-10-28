@if(isset($row['employee_cd']) && $row['employee_cd'] != '')
<tr class="tr_first_value emcd {{$row['employee_cd']}}">
    <td class="sticky-cell">
        <div class="md-checkbox-v2 inline-block lb" style="left:15px">
            <input name="ckb0" id="{{ "ckb0".$row['employee_cd'] }}" class="checkbox_row chk-item" type="checkbox">
            <label for="{{ "ckb0".$row['employee_cd'] }}"></label>
            <input type="text" class="row_result" hidden value="">
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

    <td class="min-w90px  ">
        <label class="form-control-plaintext txt">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm1']}}">
                {{$row['belong_nm1']}}
            </div>
        </label>
    </td>
    @if(count($organization_group)>=2)
    <td class="min-w90px  ">
        <label class="form-control-plaintext txt">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm2']}}">
                {{$row['belong_nm2']}}
            </div>
        </label>
    </td>
    @endif
    @if(count($organization_group)>=3)
    <td class="min-w90px  ">
        <label class="form-control-plaintext txt">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm3']}}">
                {{$row['belong_nm3']}}
            </div>
        </label>
    </td>
    @endif
    @if(count($organization_group)>=4)
    <td class="min-w90px  ">
        <label class="form-control-plaintext txt">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm4']}}">
                {{$row['belong_nm4']}}
            </div>
        </label>
    </td>
    @endif
    @if(count($organization_group)>=5)
    <td class="min-w90px  ">
        <label class="form-control-plaintext txt">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm5']}}">
                {{$row['belong_nm5']}}
            </div>
        </label>
    </td>
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
        <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['grade_nm'] }}">
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
                    <input type="tel" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm_1 error_approver_emp_1 ui-autocomplete-input employee_nm_weeklyreport approver_employee_nm min-width" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_1'] }}" value="{{ $row['approver_employee_nm_1'] }}" style="padding-right: 40px;" />
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
                    <input type="tel"  fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm_2 error_approver_emp_2 ui-autocomplete-input employee_nm_weeklyreport min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_2'] }}" value="{{ $row['approver_employee_nm_2'] }}" style="padding-right: 40px;" />
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
                    <input type="tel"  fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm_3 error_approver_emp_3 ui-autocomplete-input employee_nm_weeklyreport min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_3'] }}" value="{{ $row['approver_employee_nm_3'] }}" style="padding-right: 40px;" />
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
                    <input type="tel"  fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" class="form-control indexTab rate_emp approver_employee_nm_4 error_approver_emp_4 ui-autocomplete-input employee_nm_weeklyreport min-width" id="employee_cd" maxlength="101" old_approver_employee_nm="{{ $row['approver_employee_nm_4'] }}" value="{{ $row['approver_employee_nm_4'] }}" style="padding-right: 40px;" />
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
        <select class="form-control input-sm sheet err_sheet_cd sheet_cd_a">
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
@endif