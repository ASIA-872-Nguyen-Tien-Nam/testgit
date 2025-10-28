 <div class="card-body">
        <div class="row">
            <div class="col-md-12 ">
                <div class="wmd-view-topscroll">
                    <div class="scroll-div1"></div>
                </div>
            </div>
        </div><!-- end .row -->
        <div class=" wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
            <table class="table sortable table-bordered table-hover fixed-header" id="table_result">
                <thead>
            <tr>
                <th class="text-center">
                    <div class="md-checkbox-v2 inline-block lb">
                        <input name="ckball" id="ckball" type="checkbox" tabindex="3">
                        <label for="ckball"></label>
                    </div>
                </th>
                <th class="min-w90px">{{ __('messages.employee_no') }}</th>
                <th class="min-w90px">{{ __('messages.employee_name') }}</th>
                <th class="min-w90px">{{ __('messages.employee_classification') }}</th>
                <th class="min-w90px">{{ __('messages.department') }}</th>
                <th class="min-w90px">{{ __('messages.division') }}</th>
                <th class="min-w90px">{{ __('messages.job') }}</th>
                <th class="min-w90px">{{ __('messages.position') }}</th>
                <th class="min-w90px">{{ __('messages.grade') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater1']:'' }}">{{ __('messages.1st_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater2']:'' }}">{{ __('messages.2nd_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater3']:'' }}">{{ __('messages.3rd_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater4']:'' }}">{{ __('messages.4th_rater') }}</th>
                <th colspan="2" class="min-w350px">{{ __('messages.evaluation_sheet') }}zxcdzdasd</th>
            </tr>
            </thead>
            <tbody id="list">
            <div class="tr_employee">
                <?php $rand = rand();?>
                @if(isset($list[0]))
                    @foreach($list as $key=> $row)
                        <tr class="{{$row['classTr']}}" row_emp ="{{$row['employee_cd'].$row['group_cd']}}" del_emp="{{$rand}}"
                            data-emp_cd1="{{ $row['rater_employee_cd_1'] }}"
                            data-emp_cd2="{{ $row['rater_employee_cd_2'] }}"
                            data-emp_cd3="{{ $row['rater_employee_cd_3'] }}"
                            data-emp_cd4="{{ $row['rater_employee_cd_4'] }}"
                            data-emp_nm1= "{{ $row['rater_employee_nm_1'] }}"
                            data-emp_nm2= "{{ $row['rater_employee_nm_2'] }}"
                            data-emp_nm3= "{{ $row['rater_employee_nm_3'] }}"
                            data-emp_nm4= "{{ $row['rater_employee_nm_4'] }}"
                        >
                            <?php if($row['row_number'] == 1) {?>
                            <input type="hidden" class="number" value="{{$key}}"/>
                            <input type="hidden" class="pos_emp" value=""/>
                            <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                            <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                            <input type="hidden" class="treatment_applications_no_a" value="{{$row['treatment_applications_no']}}"/>
                            <input type="hidden" class="row_number" value="{{$row['row_number']}}"/>
                            <input type="hidden" class="row_span" value="{{$row['row']}}"/>
                            <input type="hidden" class="rater_employee_nm_1" value="{{$row['rater_employee_nm_1']}}"/>
                            <input type="hidden" class="rater_employee_nm_2" value="{{$row['rater_employee_nm_2']}}"/>
                            <input type="hidden" class="rater_employee_nm_3" value="{{$row['rater_employee_nm_3']}}"/>
                            <input type="hidden" class="rater_employee_nm_4" value="{{$row['rater_employee_nm_4']}}"/>

                            <td class="text-center {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <div class="md-checkbox-v2 inline-block lb">
                                    <input name="ckb0" id="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}" class="checkbox_row" type="checkbox">
                                    <label for="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}" class="lblCheck"></label>
                                </div>
                            </td>
                            <td class="min-w30px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['employee_cd'] }}">
                                    {{ $row['employee_cd'] }}
                                </label>
                                <input type="hidden" class="r_employee_cd" value=" {{ $row['employee_cd'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['employee_nm'] }}">
                                    {{ $row['employee_nm'] }}
                                </label>
                                <input type="hidden" class="r_employee_nm" value=" {{ $row['employee_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['employee_typ_nm'] }}">
                                    {{ $row['employee_typ_nm'] }}
                                </label>
                                <input type="hidden" class="r_employee_typ" value=" "/>
                                <input type="hidden" class="r_employee_typ_nm" value=" {{ $row['employee_typ_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['organization_nm1'] }}">
                                    {{ $row['organization_nm1'] }}
                                </label>
                                <input type="hidden" class="r_belong_cd1" value=" "/>
                                <input type="hidden" class="r_organization_nm1" value=" {{ $row['organization_nm1'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['organization_nm2'] }}">
                                    {{ $row['organization_nm2'] }}
                                </label>
                                <input type="hidden" class="r_belong_cd2" value=""/>
                                <input type="hidden" class="r_organization_nm2" value=" {{ $row['organization_nm2'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['job_nm'] }}">
                                    {{ $row['job_nm'] }}
                                </label>
                                <input type="hidden" class="r_job_cd" value=" "/>
                                <input type="hidden" class="r_job_nm" value=" {{ $row['job_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['position_nm'] }}">
                                    {{ $row['position_nm'] }}
                                </label>
                                <input type="hidden" class="r_position_cd" value=""/>
                                <input type="hidden" class="r_position_nm" value=" {{ $row['position_nm'] }}"/>
                            </td>
                            <td class="min-w30px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['grade_nm'] }}">
                                    {{ $row['grade_nm'] }}
                                </label>
                                <input type="hidden" class="r_grade" value=""/>
                                <input type="hidden" class="r_grade_nm" value=" {{ $row['grade_nm'] }}"/>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}} {{$Rater['Rater1']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                         <input type="hidden" class="rate" data-rater="1"/>
                                            <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_1" value="{{ $row['rater_employee_cd_1'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_1 error_rater_emp_1  min-width" tabindex="1" maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_1'] }}"
                                                value="{{ ($Rater['Rater1'] == 'hidden')?'':$row['rater_employee_nm_1'] }}" style="padding-right: 40px;" {{$Rater['Rater1']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="1" {{$Rater['Rater1']??''}}>
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}} {{$Rater['Rater2']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                         <input type="hidden" data-rater="2"/>
                                            <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_2" value="{{ $row['rater_employee_cd_2'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_2 error_rater_emp_2 min-width" id="employee_cd" tabindex="1" maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_2'] }}"
                                                       value="{{ ($Rater['Rater2'] == 'hidden')?'':$row['rater_employee_nm_2'] }}" style="padding-right: 40px;" {{$Rater['Rater2']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2" {{$Rater['Rater2']??''}}>
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}} {{$Rater['Rater3']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                         <input type="hidden" data-rater="3"/>
                                            <span class="num-length">
                                                 <input type="hidden" class="rater_employee_cd rater_employee_cd_3" value="{{ $row['rater_employee_cd_3'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_3 error_rater_emp_3 min-width"  id="employee_cd" tabindex="1" maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_3'] }}"
                                                       value="{{ ($Rater['Rater3'] == 'hidden')?'':$row['rater_employee_nm_3'] }}" style="padding-right: 40px;" {{$Rater['Rater3']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="3" {{$Rater['Rater3']??''}}>
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}} {{$Rater['Rater4']}}" rowspan="{{ $row['row'] }}"rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                         <input type="hidden" data-rater="4"/>
                                            <span class="num-length">
                                                 <input type="hidden" class="rater_employee_cd rater_employee_cd_4" value="{{ $row['rater_employee_cd_4'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_4 error_rater_emp_4 min-width" id="employee_cd" tabindex="1" maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_4'] }}"
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
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['sheet_nm1'] }}">
                                    {{ $row['sheet_nm1'] }}
                                </label>
                                <input type="hidden" class="row_sheet_cd r_sheet_cd1" value="{{$row['sheet_cd_f0021']}}"/>
                            </td>
                            <td class="{{$row['classCheckSecondHidden']}}">
                                <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_a" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}">
                                    <option value="-1"></option>
                                    @if (isset($sheet[0]))
                                        @foreach($sheet as $fill)
                                            <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </td>
                            <?php }else{ ?>
                            <input type="hidden" class="number" value="{{$key}}"/>
                            <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                            <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                            <input type="hidden" class="treatment_applications_no_b" value="{{$row['treatment_applications_no']}}"/>
                            <input type="hidden" class="row_number" value="{{$row['row_number']}}"/>
                            <td class="td_sheet_cd {{$row['classCheckSecondHidden']}}" style="min-width:150px">
                                <label class="form-control-plaintext txt text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['sheet_nm1'] }}">
                                    {{ $row['sheet_nm1'] }}
                                </label>
                                <input type="hidden" class="row_sheet_cd r_sheet_cd2" value="{{$row['sheet_cd_f0021']}}"/>
                            </td>
                            <td class="{{$row['classCheckSecondHidden']}}">
                                <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_b" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}">
                                    <option value="-1"></option>
                                    @if (isset($sheet[0]))
                                        @foreach($sheet as $fill)
                                            <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </td>
                            <?php } ?>
                        </tr>
                    @endforeach
                @else
                    <tr class="tr_first">
                        <td colspan="15" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </div>
            <div class="tr_employee">
                @if(isset($listDel[1]))
                    @foreach($listDel as $key=> $row)

                        <tr class="{{$row['classTr']}}" row_emp ="{{$row['employee_cd'].$row['group_cd']}}"
                            data-emp_cd1="{{ $row['rater_employee_cd_1'] }}"
                            data-emp_cd2="{{ $row['rater_employee_cd_2'] }}"
                            data-emp_cd3="{{ $row['rater_employee_cd_3'] }}"
                            data-emp_cd4="{{ $row['rater_employee_cd_4'] }}"
                            data-emp_nm1= "{{ $row['rater_employee_nm_1'] }}"
                            data-emp_nm2= "{{ $row['rater_employee_nm_2'] }}"
                            data-emp_nm3= "{{ $row['rater_employee_nm_3'] }}"
                            data-emp_nm4= "{{ $row['rater_employee_nm_4'] }}"
                        >
                            <?php if($row['row_number'] == 1) {?>
                            <input type="hidden" class="number" value="{{$key}}"/>
                            <input type="hidden" class="pos_emp" value=""/>
                            <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                            <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                            <input type="hidden" class="treatment_applications_no_a" value="{{$row['treatment_applications_no']}}"/>
                            <input type="hidden" class="row_number" value="{{$row['row_number']}}"/>
                            <input type="hidden" class="row_span" value="{{$row['row']}}"/>
                            <input type="hidden" class="rater_employee_nm_1" value="{{$row['rater_employee_nm_1']}}"/>
                            <input type="hidden" class="rater_employee_nm_2" value="{{$row['rater_employee_nm_2']}}"/>
                            <input type="hidden" class="rater_employee_nm_3" value="{{$row['rater_employee_nm_3']}}"/>
                            <input type="hidden" class="rater_employee_nm_4" value="{{$row['rater_employee_nm_4']}}"/>

                            <td class="text-center {{$row['classCheckFirstHidden']}} lblCheck" rowspan="{{ $row['row'] }}">
                                <div class="md-checkbox-v2 inline-block lb">
                                    <input name="ckb0" id="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}" class="checkbox_row" type="checkbox">
                                    <label for="{{ "ckb0".$row['employee_cd'].$row['group_cd'] }}"></label>
                                </div>
                            </td>
                            <td class="min-w30px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['employee_cd'] }}
                                <input type="hidden" class="r_employee_cd" value=" {{ $row['employee_cd'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['employee_nm'] }}
                                <input type="hidden" class="r_employee_nm" value=" {{ $row['employee_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['employee_typ_nm'] }}
                                <input type="hidden" class="r_employee_typ" value=" {{ $row['employee_typ'] }}"/>
                                <input type="hidden" class="r_employee_typ_nm" value=" {{ $row['employee_typ_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['organization_nm1'] }}
                                <input type="hidden" class="r_belong_cd1" value=" {{ $row['belong_cd1'] }}"/>
                                <input type="hidden" class="r_organization_nm1" value=" {{ $row['organization_nm1'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['organization_nm2'] }}
                                <input type="hidden" class="r_belong_cd2" value=" {{ $row['belong_cd2'] }}"/>
                                <input type="hidden" class="r_organization_nm2" value=" {{ $row['organization_nm2'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['job_nm'] }}
                                <input type="hidden" class="r_job_cd" value=" {{ $row['job_cd'] }}"/>
                                <input type="hidden" class="r_job_nm" value=" {{ $row['job_nm'] }}"/>
                            </td>
                            <td class="min-w90px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['position_nm'] }}
                                <input type="hidden" class="r_position_cd" value=" {{ $row['position_cd'] }}"/>
                                <input type="hidden" class="r_position_nm" value=" {{ $row['position_nm'] }}"/>
                            </td>
                            <td class="min-w30px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                {{ $row['grade_nm'] }}
                                <input type="hidden" class="r_grade" value=" {{ $row['grade'] }}"/>
                                <input type="hidden" class="r_grade_nm" value=" {{ $row['grade_nm'] }}"/>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                            <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_1" value="{{ $row['rater_employee_cd_1'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_1  min-width" tabindex="1" maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_1'] }}"
                                                       value="{{ ($Rater['Rater1'] == 'disabled')?'':$row['rater_employee_nm_1'] }}" style="padding-right: 40px;" {{$Rater['Rater1']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="1">
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                            <span class="num-length">
                                                <input type="hidden" class="rater_employee_cd rater_employee_cd_2" value="{{ $row['rater_employee_cd_2'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_2 min-width" id="employee_cd" tabindex="1" maxlength="101" old_rater_employee_nm="{{ $row['rater_employee_nm_2'] }}"
                                                       value="{{ ($Rater['Rater2'] == 'disabled')?'':$row['rater_employee_nm_2'] }}" style="padding-right: 40px;" {{$Rater['Rater2']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2">
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                            <span class="num-length">
                                                 <input type="hidden" class="rater_employee_cd rater_employee_cd_3" value="{{ $row['rater_employee_cd_3'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_3 " min-width id="employee_cd" tabindex="1" maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_3'] }}"
                                                       value="{{ ($Rater['Rater3'] == 'disabled')?'':$row['rater_employee_nm_3'] }}" style="padding-right: 40px;" {{$Rater['Rater3']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="3">
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="min-w200px  {{$row['classCheckFirstHidden']}}" rowspan="{{ $row['row'] }}"rowspan="{{ $row['row'] }}">
                                <span class="num-length">
                                     <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                                            <span class="num-length">
                                                 <input type="hidden" class="rater_employee_cd rater_employee_cd_4" value="{{ $row['rater_employee_cd_4'] }}" />
                                                <input type="tel" class="form-control indexTab rate_emp rater_employee_nm_4  min-width" id="employee_cd" tabindex="1" maxlength="101"  old_rater_employee_nm="{{ $row['rater_employee_nm_4'] }}"
                                                       value="{{ ($Rater['Rater4'] == 'disabled')?'':$row['rater_employee_nm_4'] }}" style="padding-right: 40px;" {{$Rater['Rater4']??''}}/>
                                            </span>
                                         <div class="input-group-append-btn">
                                             <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="4">
                                                 <i class="fa fa-search"></i>
                                             </button>
                                         </div>
                                     </div>
                                </span>
                            </td>
                            <td class="td_sheet_cd {{$row['classCheckSecondHidden']}}" style="min-width:150px">
                                {{$row['sheet_nm1']}}
                                <input type="hidden" class="row_sheet_cd r_sheet_cd1" value="{{$row['sheet_cd_f0021']}}"/>
                            </td>
                            <td class="{{$row['classCheckSecondHidden']}}">
                                <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_a" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}">
                                    <option value="-1"></option>
                                    @if (isset($sheet[0]))
                                        @foreach($sheet as $fill)
                                            <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </td>
                            <?php }else{ ?>
                            <input type="hidden" class="number" value="{{$key}}"/>
                            <input type="hidden" class="key_emp" value="{{$row['employee_cd']}}"/>
                            <input type="hidden" class="row_number" value="{{$row['row_number']}}"/>
                            <input type="hidden" class="key_group_cd" value="{{$row['group_cd']}}"/>
                            <input type="hidden" class="treatment_applications_no_b" value="{{$row['treatment_applications_no']}}"/>
                            <td class="td_sheet_cd {{$row['classCheckSecondHidden']}}" style="min-width:150px">
                                {{$row['sheet_nm1']}}
                                <input type="hidden" class="row_sheet_cd r_sheet_cd2" value="{{$row['sheet_cd_f0021']}}"/>
                            </td>
                            <td class="{{$row['classCheckSecondHidden']}}">
                                <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_b" sheet_cd_f0032="{{  $row['sheet_cd_f0032'] }}">
                                    <option value="-1"></option>
                                    @if (isset($sheet[0]))
                                        @foreach($sheet as $fill)
                                            <option value="{{$fill['sheet_cd']}}" {{ ($row["sheet_cd_f0032"]==$fill['sheet_cd'])?"selected":" "}}>{{$fill['sheet_nm']}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </td>
                            <?php } ?>
                        </tr>
                        <div id="neo"></div>
                    @endforeach
                @endif
            </div>
            </tbody>
        </table>
    </div><!-- end .table-responsive -->
    <div class="hide">
        <table class="table table-bordered table-hover" id="table_data">
            <tbody>
            <tr class="tr_first">
                <input type="hidden" class="row_employee_cd" value=""/>
                <td class="text-center">
                    <div class="md-checkbox-v2 inline-block lb">
                        <input name="ckb" id="ckb" class="checkbox_row" type="checkbox">
                        <label for="ckb"></label>
                    </div>
                </td>
                <td style="min-width:100px">
                    <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
                        <input type="hidden">
                                    <span class="num-length">
                                        <input type="hidden" class="rater_employee_cd" value="">
                                        <input type="tel" class="form-control indexTab add_emp add_employee_cd error_rater_emp_5 min-width emp_nm ui-autocomplete-input" id="employee_cd" tabindex="4" maxlength="20" old_rater_employee_nm="" value="" style="padding-right: 40px;" autocomplete="off">
                                    </span>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2">
                                <i class="fa fa-search"></i>
                            </button>
                        </div>
                    </div>
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>
                        <span class="num-length">
                            <div class="input-group-btn">
                                <input type="text" class="form-control" tabindex="6" maxlength="20" value="" readonly="readonly">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </span>
                </td>
                <td>
                        <span class="num-length">
                            <div class="input-group-btn">
                                <input type="text" class="form-control" maxlength="20" tabindex="6" value="" readonly="readonly">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </span>
                </td>
                <td>
								<span class="num-length">
									<div class="input-group-btn">
                                        <input type="text" class="form-control" tabindex="6" maxlength="20" value="" readonly="readonly">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
								</span>
                </td>
                <td>
								<span class="num-length">
									<div class="input-group-btn">
                                        <input type="text" class="form-control" tabindex="6" maxlength="20" value="" readonly="readonly">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
								</span>
                </td>
                <td></td>
                <td>
                    <select name="" id="" class="form-control input-sm" readonly="readonly">
                    </select>
                </td>
            </tr>

            </tbody>
        </table>
    </div>
</div><!-- end .card-body -->
<input type="hidden" id="status" value="{{isset($check[0])?$check[0]['status']:'OK'}}"/>
<input type="file" id="import_file" style="display: none" accept=".csv">

