<div class="card-body">
    <nav class="pager-wrap">
        {!! Paging::show($paging ?? []) !!}
    </nav>
    <div class="row">
        <div class="col-md-12 ">
            <div class="wmd-view-topscroll">
                <div class="scroll-div1"></div>
            </div>
        </div>
    </div><!-- end .row -->
    @php $col=8;@endphp
    <div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
        <table class="table table-bordered fixed-header sortable" id="table_result">
            <thead>
                <tr>
                    <th class="sticky-cell text-center">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input name="ckball" id="ckball" type="checkbox" tabindex="10">
                            <label for="ckball"></label>
                        </div>
                    </th>
                    <th class="sticky-cell min-w90px">{{ __('messages.employee_no') }}</th>
                    <th class="sticky-cell min-w90px">{{ __('messages.employee_name') }}</th>
                    <th class="min-w90px">{{ __('messages.employee_classification') }}</th>
                    @foreach($M0022 as $item)
                    <th class="min-90px">
                        <div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}">{{$item['organization_group_nm']}}</div>
                    </th>
                    @php $col++;@endphp
                    @endforeach
                    <th class="min-w90px">{{ __('messages.job') }}</th>
                    <th class="min-w90px">{{ __('messages.position') }}</th>
                    <th class="min-w90px">{{ __('messages.grade') }}</th>
                    @if($Rater['Rater1'] == '')
                    <th class="min-w90px {{ $Rater['Rater1']??'' }} ">{{ __('messages.1st_rater') }}</th>
                    @php $col++;@endphp
                    @endif
                    @if($Rater['Rater2'] == '')
                    <th class="min-w90px {{ $Rater['Rater2']??'' }} ">{{ __('messages.2nd_rater') }}</th>
                    @php $col++;@endphp
                    @endif
                    @if($Rater['Rater3'] == '')
                    <th class="min-w90px {{ $Rater['Rater3']??'' }} ">{{ __('messages.3rd_rater') }}</th>
                    @php $col++;@endphp
                    @endif
                    @if($Rater['Rater4'] == '')
                    <th class="min-w90px {{ $Rater['Rater4']??'' }} ">{{ __('messages.4th_rater') }}</th>
                    @php $col++;@endphp
                    @endif
                    <th colspan="2" class="min-w350px">{{ __('messages.evaluation_sheet') }}</th>
                </tr>
            </thead>
            <tbody id="list">
                @php $rand = rand();@endphp
                @if(isset($list[0]))
                    @foreach($list as $key=> $row)
                    <tr class="{{$row['classTr']}} data_db emcd {{$row['employee_cd']}}"
                        hasconfirm="{{(int)$row['hasConfirm']>0?1:''}}"
                        row_emp ="{{$row['employee_cd'].$row['group_cd']}}" 
                        del_emp="{{$rand}}"
                        data-emp_cd1="{{ $row['rater_employee_cd_1'] }}"
                        data-emp_cd2="{{ $row['rater_employee_cd_2'] }}"
                        data-emp_cd3="{{ $row['rater_employee_cd_3'] }}"
                        data-emp_cd4="{{ $row['rater_employee_cd_4'] }}"
                        data-emp_nm1= "{{ $row['rater_employee_nm_1'] }}"
                        data-emp_nm2= "{{ $row['rater_employee_nm_2'] }}"
                        data-emp_nm3= "{{ $row['rater_employee_nm_3'] }}"
                        data-emp_nm4= "{{ $row['rater_employee_nm_4'] }}"
                    >
                    {{-- if first row --}}
                    @if ($row['row_number'] == 1)
                        <input type="hidden" class="number" value="{{$key}}"/>
                        <input type="hidden" class="pos_emp" value=""/>
                        <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                        <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                        <input type="hidden" class="treatment_applications_no_a" value="{{$row['treatment_applications_no']}}"/>
                        <input type="hidden" class="row_number" value="{{$row['detail_no']}}"/>
                        <input type="hidden" class="row_span" value="{{$row['row']}}"/>
                        <input type="hidden" class="rater_position_cd_1 rater_employee_nm_2" value="{{$row['rater_employee_cd_1']}}"/>
                        <input type="hidden" class="rater_position_cd_2" value="{{$row['rater_employee_cd_2']}}"/>
                        <input type="hidden" class="rater_position_cd_3" value="{{$row['rater_employee_cd_3']}}"/>
                        <input type="hidden" class="rater_position_cd_4" value="{{$row['rater_employee_cd_4']}}"/>
                        <input type="hidden" class="rater_employee_nm_1" value="{{$row['rater_employee_nm_1']}}"/>
                        <input type="hidden" class="rater_employee_nm_2" value="{{$row['rater_employee_nm_2']}}"/>
                        <input type="hidden" class="rater_employee_nm_3" value="{{$row['rater_employee_nm_3']}}"/>
                        <input type="hidden" class="rater_employee_nm_4" value="{{$row['rater_employee_nm_4']}}"/>
                        <td class="sticky-cell text-center {{$row['classCheckFirstHidden']}} lblCheck" rowspan="{{$row['row']}}">
                            <div class="md-checkbox-v2 inline-block lb">
                                <input name="ckb0" id="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}" class="checkbox_row" type="checkbox" >
                                <label for="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}"></label>
                            </div>
                        </td>
                        <td class="sticky-cell min-w30px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" style="width: 90px;"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['employee_cd']}}">
                                    {{$row['employee_cd']}}
                                </div>
                            </label>
                            <input type="hidden" class="r_employee_cd" value=" {{ $row['employee_cd'] }}"/>
                        </td>
                        <td class="sticky-cell min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['employee_nm']}}">
                                    {{$row['employee_nm']}}
                                </div>
                            </label>
                            <input type="hidden" class="r_employee_nm" value=" {{ $row['employee_nm'] }}"/>
                        </td>
                        <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['employee_typ_nm']}}">
                                    {{$row['employee_typ_nm']}}
                                </div>
                            </label>
                            <input type="hidden" class="r_employee_typ" value=" {{ $row['employee_typ'] }}"/>
                            <input type="hidden" class="r_employee_typ_nm" value=" {{ $row['employee_typ_nm'] }}"/>
                        </td>
                        @foreach($M0022 as $item)
                            @if($item['organization_step'] == 1)
                            <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$row['belong_nm1']}}">
                                        {{$row['belong_nm1']}}
                                    </div>
                                </label>
                                <input type="hidden" class="r_belong_cd1" value=" {{ $row['belong_cd1'] }}"/>
                                <input type="hidden" class="r_organization_nm1" value=" {{ $row['belong_nm1'] }}"/>
                            </td>
                            @elseif ($item['organization_step'] == 2)
                            <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$row['belong_nm2']}}">
                                        {{$row['belong_nm2']}}
                                    </div>
                                </label>
                                <input type="hidden" class="r_belong_cd2" value=" {{ $row['belong_cd2'] }}"/>
                                <input type="hidden" class="r_organization_nm2" value=" {{ $row['belong_nm2'] }}"/>
                            </td>
                            @elseif ($item['organization_step'] == 3)
                            <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$row['belong_nm3']}}">
                                        {{$row['belong_nm3']}}
                                    </div>
                                </label>
                                <input type="hidden" class="r_belong_cd3" value=" {{ $row['belong_cd3'] }}"/>
                                <input type="hidden" class="r_organization_nm3" value=" {{ $row['belong_nm3'] }}"/>
                            </td>
                            @elseif ($item['organization_step'] == 4)
                            <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$row['belong_nm4']}}">
                                        {{$row['belong_nm4']}}
                                    </div>
                                </label>
                                <input type="hidden" class="r_belong_cd4" value=" {{ $row['belong_cd4'] }}"/>
                                <input type="hidden" class="r_organization_nm4" value=" {{ $row['belong_nm4'] }}"/>
                            </td>
                            @elseif ($item['organization_step'] == 5)
                            <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{$row['belong_nm5']}}">
                                        {{$row['belong_nm5']}}
                                    </div>
                                </label>
                                <input type="hidden" class="r_belong_cd5" value=" {{ $row['belong_cd5'] }}"/>
                                <input type="hidden" class="r_organization_nm5" value=" {{ $row['belong_nm5'] }}"/>
                            </td>
                            @endif
                        @endforeach
                        <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['job_nm']}}">
                                    {{$row['job_nm']}}
                                </div>
                            </label>
                            <input type="hidden" class="r_job_cd" value=" {{ $row['job_cd'] }}"/>
                            <input type="hidden" class="r_job_nm" value=" {{ $row['job_nm'] }}"/>
                        </td>
                        <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['position_nm']}}">
                                    {{$row['position_nm']}}
                                </div>
                            </label>
                            <input type="hidden" class="r_position_cd" value=" {{ $row['position_cd'] }}"/>
                            <input type="hidden" class="r_position_nm" value=" {{ $row['position_nm'] }}"/>
                        </td>
                        <td class="min-w160px  {{$row['classCheckFirstHidden']}}" rowspan="{{$row['row']}}">
                            <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['grade_nm'] }}">
                                {{ $row['grade_nm'] }}
                            </label>
                            <input type="hidden" class="r_grade" value=" {{ $row['grade'] }}"/>
                            <input type="hidden" class="r_grade_nm" value=" {{ $row['grade_nm'] }}"/>
                        </td>
                        <td class="min-w200px col12 {{$row['classCheckFirstHidden']}} {{$Rater['Rater1']}}" rowspan="{{$row['row']}}">
                            <span class="num-length">
                                    <div class="input-group-btn input-group div_employee_cd  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hiddenX'}}" style="max-width: 230px">
                                        <input type="hidden" data-rater_position_cd ="{{ $row['rater_position_cd_1'] }}" class="rate" data-rater="1"/>
                                        <span class="num-length">
                                            <input type="hidden" class="rater_employee_cd rater_employee_cd_1" value="{{ $row['rater_employee_cd_1'] }}" />
                                            <input type="text" class="form-control indexTab rate_emp rater_employee_nm_1 error_rater_emp_1  min-width"  maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_1'] }}"
                                                    value="{{ ($Rater['Rater1']=='hidden')?'':$row['rater_employee_nm_1'] }}" style="padding-right: 40px;" {{$Rater['Rater1']??''}}/>
                                        </span>
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="1" {{$Rater['Rater1']??''}}>
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                            </span>
                        </td>
                        <td class="min-w200px col13 {{$row['classCheckFirstHidden']}} {{$Rater['Rater2']}}" rowspan="{{$row['row']}}">
                            <span class="num-length">
                                    <div class="input-group-btn input-group div_employee_cd  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hiddenX'}}" style="max-width: 230px">
                                        <input type="hidden" data-rater_position_cd ="{{ $row['rater_position_cd_2'] }}" data-rater="2"/>
                                        <span class="num-length">
                                            <input type="hidden" class="rater_employee_cd rater_employee_cd_2" value="{{ $row['rater_employee_cd_2'] }}" />
                                            <input type="text" class="form-control indexTab rate_emp rater_employee_nm_2 error_rater_emp_2 min-width" id="employee_cd"  maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_2'] }}"
                                                    value="{{ ($Rater['Rater2'] =='hidden')?'':$row['rater_employee_nm_2'] }}" style="padding-right: 40px;"  {{$Rater['Rater2']??''}}/>
                                        </span>
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2" {{$Rater['Rater2']??''}}>
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                            </span>
                        </td>
                        <td class="min-w200px col14 {{$row['classCheckFirstHidden']}} {{$Rater['Rater3']}}" rowspan="{{$row['row']}}">
                            <span class="num-length">
                                    <div class="input-group-btn input-group div_employee_cd  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hiddenX'}}" style="max-width: 230px">
                                        <input type="hidden" data-rater_position_cd ="{{ $row['rater_position_cd_3'] }}" data-rater="3"/>
                                        <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_3" value="{{ $row['rater_employee_cd_3'] }}" />
                                            <input type="text" class="form-control indexTab rate_emp rater_employee_nm_3 error_rater_emp_3 min-width"  id="employee_cd"  maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_3'] }}"
                                                    value="{{ ($Rater['Rater3'] =='hidden')?"":$row['rater_employee_nm_3'] }}" style="padding-right: 40px;" {{$Rater['Rater3']??''}}/>
                                        </span>
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="3" {{$Rater['Rater3']??''}}>
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                            </span>
                        </td>
                        <td class="min-w200px col15 {{$row['classCheckFirstHidden']}} {{$Rater['Rater4']}}" rowspan="{{$row['row']}}">
                            <span class="num-length">
                                    <div class="input-group-btn input-group div_employee_cd  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hiddenX'}}" style="max-width: 230px">
                                        <input type="hidden" data-rater_position_cd ="{{ $row['rater_position_cd_4'] }}" data-rater="4"/>
                                        <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_4" value="{{ $row['rater_employee_cd_4'] }}" />
                                            <input type="text" class="form-control indexTab rate_emp rater_employee_nm_4 error_rater_emp_4 min-width" id="employee_cd"  maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_4'] }}"
                                                    value="{{ ($Rater['Rater4'] == 'hidden')?'':$row['rater_employee_nm_4'] }}" style="padding-right: 40px;" {{$Rater['Rater4']??''}}/>
                                        </span>
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="4" {{$Rater['Rater4']??''}}>
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                            </span>
                        </td>
                        <td class="td_sheet_cd {{$row['classCheckSecondHidden']}}" style="min-width:150px">
                            <label class="form-control-plaintext txt text-overfollow setTooltip  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hidden'}}" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['sheet_nm1'] }}">
                                {{ $row['sheet_nm1'] }}
                            </label>
                            <input type="hidden" class="row_sheet_cd r_sheet_cd1" value="{{$row['sheet_cd_f0021']}}"/>
                        </td>
                        <td class="{{$row['classCheckSecondHidden']}}"  style="min-width:150px">
                            <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_a  {{isset($row['group_cd'])&& $row['group_cd']!=-1?'':'hidden'}}" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}" >
                                <option value="-1"></option>
                                @if (isset($sheet[0]))
                                    @foreach($sheet as $fill)
                                        <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                    @endforeach
                                @endif
                            </select>
                        </td>
                    {{-- second row --}}
                    @else
                        <input type="hidden" class="number" value="{{$key}}"/>
                        <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                        <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                        <input type="hidden" class="row_number" value="{{$row['detail_no']}}"/>
                        <input type="hidden" class="treatment_applications_no_b" value="{{$row['treatment_applications_no']}}"/>
                        <td class="td_sheet_cd {{$row['classCheckSecondHidden']}}" style="min-width:150px">
                            <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['sheet_nm1'] }}">
                                {{ $row['sheet_nm1'] }}
                            </label>
                            <input type="hidden" class="row_sheet_cd r_sheet_cd2" value="{{$row['sheet_cd_f0021']}}"/>
                        </td>
                        <td class="{{$row['classCheckSecondHidden']}}"  style="min-width:150px">
                            <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_b" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}" >
                                <option value="-1"></option>
                                @if (isset($sheet[0]))
                                    @foreach($sheet as $fill)
                                        <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                    @endforeach
                                @endif
                            </select>
                        </td>
                    @endif
                    </tr>
                    @endforeach
                @else
                    <tr class="tr_first">
                        <td colspan="{{$col}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </tbody>
        </table>
        <input type="hidden" id="status" value="{{isset($check[0])?$check[0]['status']:'OK'}}"/>
        <input type="file" id="import_file" style="display: none" accept=".csv">        
    </div><!-- end .table-responsive -->
</div><!-- end .card -->