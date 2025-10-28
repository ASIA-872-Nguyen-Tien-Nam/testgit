<div class="tab-pane fade" id="tab14">
    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.training_history_information_tab') }}</label>
    </div>
    <div class="col-md-12" style="margin-top : 10px">
        <div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 650px">
            @php
                $trainings = json_decode($tab_03['trainings'], true);
            @endphp
            @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                <div class="full-width">
                    <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue"
                        id="btn-add-new-row-tab3" tabindex="9">
                        +
                    </a>
                </div>
            @endif
            <table id="table-tab03"
                class="table table-head-tab table-bordered table-hover table-oneheader ofixed-boder">
                <thead>
                    <tr>
                        <th style="width: 3%"></th>
                        <th style="width: 10%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        <th style="width: 5.25%"></th>
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                            <th style="width: 3%"></th>
                        @endif
                    </tr>
                </thead>
                @if (!empty($tab_03['list']))
                    @foreach ($tab_03['list'] as $index => $row)
                        @php
                            foreach ($trainings as $key => $item) {
                                if ($item['training_cd'] == $row['training_cd']) {
                                    $editable_kbn = $item['editable_kbn'];
                                }
                            }
                        @endphp
                        <tbody class="list_tab_03">
                            <tr class="tr">
                                <td rowspan="8" class="text-center no">{{ $index + 1 }}</td>
                                <td class="no-head">{{ __('messages.training_code') }}</td>
                                <td colspan="4" class="no-head">{{ __('messages.training_name') }}</td>
                                <td colspan="4" class="no-head">{{ __('messages.training_category') }}</td>
                                <td colspan="4" class="no-head">{{ __('messages.course_format') }}</td>
                                <td colspan="4" class="no-head">{{ __('messages.lecturer_name') }}</td>
                                @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                                    <td rowspan="7" class="no-head"></td>
                                @endif
                            </tr>
                            <tr class="tr">
                                <td>
                                    <span class="num-length text-right">
                                        {{ $row['training_cd'] ?? '' }}
                                    </span>
                                </td>
                                <td colspan="4" style="max-width: 370px;">
                                    <span class="num-length text-overfollow d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['training_nm'] ?? '' }}">
                                        {{ $row['training_nm'] ?? '' }}
                                    </span>
                                </td>
                                <td colspan="4" style="max-width: 350px;">
                                    @if (!empty($tab_03['M5031']))
                                        @foreach ($tab_03['M5031'] as $item)
                                            @if (isset($row['training_category_cd']) && $row['training_category_cd'] == $item['training_category_cd'])
                                                <span class="text-overflow d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $item['training_category_nm'] ?? '' }}">
                                                    {{ $item['training_category_nm'] ?? '' }}
                                                </span>
                                            @endif
                                        @endforeach
                                    @endif
                                </td>
                                <td colspan="4" style="max-width: 350px;">
                                    @if (!empty($tab_03['M5032']))
                                        @foreach ($tab_03['M5032'] as $item)
                                            @if (isset($row['training_course_format_cd']) && $row['training_course_format_cd'] == $item['training_course_format_cd'])
                                                <span class="text-overflow d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $item['training_course_format_nm'] ?? '' }}">
                                                    {{ $item['training_course_format_nm'] ?? '' }}
                                                </span>
                                            @endif
                                        @endforeach
                                    @endif
                                </td>
                                <td colspan="4" style="max-width: 300px;">
                                    <span class="num-length text-overflow d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['lecturer_name'] ?? '' }}">
                                        {{ $row['lecturer_name'] ?? '' }}
                                    </span>
                                </td>
                            </tr>
                            <tr class="tr">
                                <td colspan="4" class="no-head">{{ __('messages.students_date') }}</td>
                                <td colspan="2" class="no-head">{{ __('messages.attendance_status') }}</td>
                                <td colspan="2" class="no-head">
                                    {{ __('messages.passing_date') }}・{{ __('messages.certification_date') }}</td>
                                <td colspan="9" class="no-head">
                                    @if (isset($disabled) && $disabled == '')
                                        {{ __('messages.certificate_data') }}
                                    @endif
                                </td>
                            </tr>
                            <tr class="tr">
                                <td colspan="4">
                                    <div class="d-flex">
                                        <span class="num-length text-center">
                                            {{-- <div class="input-group-btn input-group">
                                                <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                                    class="form-control input-sm date training_date_from"
                                                    value="{{ $row['training_date_from'] ?? '' }}"
                                                    placeholder="yyyy/mm/dd" tabindex="9">
                                                <div class="input-group-append-btn">
                                                    <button class="btn btn-transparent" type="button"
                                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div> --}}
                                            {{ $row['training_date_from'] ?? '' }}
                                        </span>
                                        <div class="d-flex align-items-center pr-1 pl-1"
                                            style="position: relative;min-width: 22px;">
                                            <div class="contain-radio" style="position: relative;top: 5px;">～</div>
                                        </div>
                                        <span class="num-length text-center">
                                            {{-- <div class="input-group-btn input-group">
                                                <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                                    class="form-control input-sm date training_date_to"
                                                    value="{{ $row['training_date_to'] ?? '' }}"
                                                    placeholder="yyyy/mm/dd" tabindex="9">
                                                <div class="input-group-append-btn">
                                                    <button class="btn btn-transparent" type="button"
                                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div> --}}
                                            {{ $row['training_date_to'] ?? '' }}
                                        </span>
                                    </div>
                                </td>
                                <td colspan="2">
                                    <span class="num-length">
                                        {{-- <select {{ $disabled }} {{$tab_03['disabled_tab03']}} class="form-control training_status"
                                            tabindex="9">
                                            @if (!empty($tab_03['L0010_59']))
                                                @foreach ($tab_03['L0010_59'] as $item)
                                                    <option value="{{ $item['number_cd'] }}"
                                                        @if (isset($row['training_status']) && $row['training_status'] == $item['number_cd']) selected @endif>
                                                        {{ $item['name'] }}</option>
                                                @endforeach
                                            @endif
                                        </select> --}}
                                        @if (!empty($tab_03['L0010_59']))
                                            @foreach ($tab_03['L0010_59'] as $item)
                                                @if (isset($row['training_status']) && $row['training_status'] == $item['number_cd'])
                                                    {{ $item['name'] }}
                                                @endif
                                            @endforeach
                                        @endif
                                    </span>
                                </td>
                                <td colspan="2">
                                    <span class="num-length text-center">
                                        {{-- <div class="input-group-btn input-group">
                                            <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                                class="form-control input-sm date passing_date"
                                                value="{{ $row['passing_date'] ?? '' }}" placeholder="yyyy/mm/dd"
                                                tabindex="9">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div> --}}
                                        {{ $row['passing_date'] ?? '' }}
                                    </span>
                                </td>
                                <td colspan="9">
                                    @if (isset($disabled) && $disabled == '')
                                        <div class="form-group mb-0">
                                            <input type="file" class="form-control d-none input-import-file"
                                                accept=".pdf">
                                            <input type="text" class="form-control d-none delete_file"
                                                value="0">
                                            <div class="fake-input" style="background-color: #EAEAEA;display: flex;justify-content: space-between;align-items: center;">
                                                @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))    
                                                <div class="button-upload"
                                                    style="width: 35px; height: 35px; top: 3px;">
                                                    <span class="face-file-btn d-block" tabindex="9">
                                                        <i class="fa fa-folder-open"></i>
                                                    </span>
                                                </div>
                                                @endif
                                                <input type="text" class="form-control display-input"
                                                    diploma_file="{{ $row['diploma_file'] ?? '' }}"
                                                    diploma_file_name="{{ $row['diploma_file_name'] ?? '' }}"
                                                    value="{{ $row['diploma_file_name'] ?? '' }}"
                                                    style="background: unset; border: unset;  overflow: hidden; text-overflow: ellipsis; white-space: nowrap" readonly $tab_03['disabled_tab03']>
                                                <span class="diploma_file_uploaddatetime"
                                                    style="padding: 0 3px; @if (isset($row['diploma_file_uploaddatetime']) && $row['diploma_file_uploaddatetime'] != '') border: 1px solid #ccc @endif ;height: 30px;line-height: 30px; min-width: 130px; white-space: nowrap; text-align: center;">{{ $row['diploma_file_uploaddatetime'] }}</span>
                                                @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))    
                                                <span
                                                    class="button-download d-flex align-items-center justify-content-center"
                                                    style="width: 30px;height: 30px;font-size: 20px;border: 1px solid #ccc;"
                                                    tabindex="9">
                                                    <i class="fa fa-download"></i>
                                                </span>
                                                <span
                                                    class="button-remove d-flex align-items-center justify-content-center"
                                                    style="width: 30px;height: 30px;font-size: 20px;color: #F72809;border: 1px solid #ccc;margin-right: 5px;"
                                                    tabindex="9">
                                                    <i class="fa fa-remove"></i>
                                                </span>
                                                @endif
                                            </div>
                                        </div>
                                    @endif
                                </td>
                            </tr>
                            <tr class="tr">
                                <td colspan="1" class="no-head">{{ __('messages.necessity_report_submit') }}</td>
                                <td colspan="2" class="no-head">{{ __('messages.report_submit_date') }}</td>
                                <td colspan="14" class="no-head">{{ __('messages.report_storage_location') }}</td>
                            </tr>
                            <tr class="tr">
                                <td colspan="1">
                                    <span class="num-length">
                                        @if (!empty($tab_03['L0010_60']))
                                            @foreach ($tab_03['L0010_60'] as $item)
                                                @if (isset($row['report_submission']) && $row['report_submission'] == $item['number_cd'])  
                                                    {{ $item['name'] }}
                                                    @endif
                                            @endforeach
                                        @endif
                                    </span>
                                </td>
                                <td colspan="2">
                                    <span class="num-length text-center">
                                        {{ $row['report_submission_date'] ?? '' }}
                                    </span>
                                </td>
                                <td colspan="14">
                                    <span class="num-length text-left">
                                        {{ $row['report_storage_location'] ?? '' }}
                                    </span>
                                </td>
                            </tr>
                            <tr class="tr">
                                <td colspan="17" class="no-head">{{ __('messages.remarks') }}</td>
                            </tr>
                            <tr class="tr">
                                <td colspan="17">
                                    {{-- <span class="num-length">
                                        <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text" tabindex="9"
                                            class="form-control input-sm text-left nationality"
                                            value="{{ $row['nationality'] ?? '' }}" maxlength="50">
                                    </span> --}}
                                    {{ $row['nationality'] ?? '' }}
                                </td>
                                @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                                    <td class="text-center no-head"
                                        style="position: relative;border-top: 2px solid #eaebee;">
                                        <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-tab3"
                                            style="position: relative;top:-127px;left: 0px;">
                                            <i class="fa fa-remove" style="font-size: 19px;"></i>
                                        </button>
                                    </td>
                                @endif
                            </tr>
                        </tbody>
                    @endforeach
                @else
                    <tbody class="list_tab_03">
                        <tr class="tr">
                            <td rowspan="8" class="text-center no">1</td>
                            <td class="no-head">{{ __('messages.training_code') }}</td>
                            <td colspan="4" class="no-head">{{ __('messages.training_name') }}</td>
                            <td colspan="4" class="no-head">{{ __('messages.training_category') }}</td>
                            <td colspan="4" class="no-head">{{ __('messages.course_format') }}</td>
                            <td colspan="4" class="no-head">{{ __('messages.lecturer_name') }}</td>
                            @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                                <td rowspan="7" class="no-head"></td>
                            @endif
                        </tr>
                        <tr class="tr">
                            <td>
                                <span class="num-length">
                                    {{-- <div class="input-group-btn">
                                        <input type="text" class="d-none detail_no" value="0">
                                        <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text" class="form-control training_cd"
                                            trainings="{{ $tab_03['trainings'] ?? '' }}" editable_kbn="1"
                                            maxlength="6" tabindex="9" autocomplete="off">
                                    </div> --}}
                                </span>
                            </td>
                            <td colspan="4">
                                <span class="num-length">
                                    {{-- <input disabled type="text" tabindex="9"
                                        class="form-control input-sm text-left training_nm" maxlength="50"
                                        decimal="2"> --}}
                                </span>
                            </td>
                            <td colspan="4">
                                <span class="num-length">
                                    {{-- <select disabled name=""
                                        class="form-control training_category_cd" tabindex="9">
                                        <option value="0"></option>
                                        @if (!empty($tab_03['M5031']))
                                            @foreach ($tab_03['M5031'] as $item)
                                                <option value="{{ $item['training_category_cd'] }}">
                                                    {{ $item['training_category_nm'] }}</option>
                                            @endforeach
                                        @endif
                                    </select> --}}
                                </span>
                            </td>
                            <td colspan="4">
                                <span class="num-length">
                                    {{-- <select disabled name=""
                                        class="form-control training_course_format_cd" tabindex="9">
                                        <option value="0"></option>
                                        @if (!empty($tab_03['M5032']))
                                            @foreach ($tab_03['M5032'] as $item)
                                                <option value="{{ $item['training_course_format_cd'] }}">
                                                    {{ $item['training_course_format_nm'] }}</option>
                                            @endforeach
                                        @endif
                                    </select> --}}
                                </span>
                            </td>
                            <td colspan="4">
                                <span class="num-length">
                                    {{-- <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text" tabindex="9"
                                        class="form-control input-sm text-left lecturer_name" maxlength="20"> --}}
                                </span>
                            </td>
                        </tr>
                        <tr class="tr">
                            <td colspan="4" class="no-head">{{ __('messages.students_date') }}</td>
                            <td colspan="2" class="no-head">{{ __('messages.attendance_status') }}</td>
                            <td colspan="2" class="no-head">
                                {{ __('messages.passing_date') }}・{{ __('messages.certification_date') }}</td>
                            <td colspan="9" class="no-head">
                                {{ __('messages.certificate_data') }}
                            </td>
                        </tr>
                        <tr class="tr">
                            <td colspan="4">
                                <div class="d-flex">
                                    <span class="num-length">
                                        {{-- <div class="input-group-btn input-group">
                                            <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                                class="form-control input-sm date training_date_from"
                                                placeholder="yyyy/mm/dd" tabindex="9">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div> --}}
                                    </span>
                                    <div class="d-flex align-items-center pr-1 pl-1"
                                        style="position: relative;min-width: 22px;">
                                        <div class="contain-radio" style="position: relative;top: 5px;">～</div>
                                    </div>
                                    <span class="num-length">
                                        {{-- <div class="input-group-btn input-group">
                                            <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                                class="form-control input-sm date training_date_to"
                                                placeholder="yyyy/mm/dd" tabindex="9">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div> --}}
                                    </span>
                                </div>
                            </td>
                            <td colspan="2">
                                <span class="num-length">
                                    {{-- <select {{ $disabled }} {{$tab_03['disabled_tab03']}} class="form-control training_status" tabindex="9">
                                        @if (!empty($tab_03['L0010_59']))
                                            @foreach ($tab_03['L0010_59'] as $item)
                                                <option value="{{ $item['number_cd'] }}">
                                                    {{ $item['name'] }}</option>
                                            @endforeach
                                        @endif
                                    </select> --}}
                                </span>
                            </td>
                            <td colspan="2">
                                <span class="num-length">
                                    {{-- <div class="input-group-btn input-group">
                                        <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                            class="form-control input-sm date passing_date" placeholder="yyyy/mm/dd"
                                            tabindex="9">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                    class="fa fa-calendar"></i></button>
                                        </div>
                                    </div> --}}
                                </span>
                            </td>
                            <td colspan="9">
                                @if (isset($disabled) && $disabled == '')
                                    <div class="form-group mb-0">
                                        <input type="file" class="form-control d-none input-import-file"
                                            accept=".pdf">
                                        <input type="text" class="form-control d-none delete_file" value="0">
                                        <div class="fake-input" style="background-color: #EAEAEA;display: flex;justify-content: space-between;align-items: center;">
                                            @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))        
                                            <div class="button-upload"
                                                style="width: 35px; height: 35px;top: 3px;">
                                                <span class="face-file-btn d-block" tabindex="9">
                                                    <i class="fa fa-folder-open"></i>
                                                </span>
                                            </div>
                                            @endif
                                            <input type="text" class="form-control display-input" diploma_file=""
                                                diploma_file_name="" style="text-indent: 30px; background: unset; border: unset;  overflow: hidden; text-overflow: ellipsis; white-space: nowrap" readonly>
                                            <span class="diploma_file_uploaddatetime"
                                                style="padding: 0 3px;height: 30px;line-height: 30px; min-width: 130px; white-space: nowrap; text-align: center;"></span>
                                            @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                                            <span
                                                class="button-download d-flex align-items-center justify-content-center"
                                                style="width: 30px;height: 30px;font-size: 20px;border: 1px solid #ccc;"
                                                tabindex="9">
                                                <i class="fa fa-download"></i>
                                            </span>
                                            <span
                                                class="button-remove d-flex align-items-center justify-content-center"
                                                style="width: 30px;height: 30px;font-size: 20px;color: #F72809;border: 1px solid #ccc;margin-right: 5px;"
                                                tabindex="9">
                                                <i class="fa fa-remove"></i>
                                            </span>
                                            @endif
                                        </div>
                                    </div>
                                @endif
                            </td>
                        </tr>
                        <tr class="tr">
                            <td colspan="1" class="no-head">{{ __('messages.necessity_report_submit') }}</td>
                            <td colspan="2" class="no-head">{{ __('messages.report_submit_date') }}</td>
                            <td colspan="14" class="no-head">{{ __('messages.report_storage_location') }}</td>
                        </tr>
                        <tr class="tr">
                            <td colspan="1">
                                <span class="num-length">
                                    {{-- <select {{ $disabled }} {{$tab_03['disabled_tab03']}} class="form-control report_submission"
                                        tabindex="9">
                                        @if (!empty($tab_03['L0010_60']))
                                            @foreach ($tab_03['L0010_60'] as $item)
                                                <option value="{{ $item['number_cd'] }}">
                                                    {{ $item['name'] }}</option>
                                            @endforeach
                                        @endif
                                    </select> --}}
                                </span>
                            </td>
                            <td colspan="2">
                                <span class="num-length">
                                    {{-- <div class="input-group-btn input-group">
                                        <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text"
                                            class="form-control input-sm date report_submission_date"
                                            placeholder="yyyy/mm/dd" tabindex="9">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                    class="fa fa-calendar"></i></button>
                                        </div>
                                    </div> --}}
                                </span>
                            </td>
                            <td colspan="14">
                                <span class="num-length">
                                    {{-- <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text" tabindex="9" maxlength="50"
                                        class="form-control input-sm text-left report_storage_location"> --}}
                                </span>
                            </td>
                        </tr>
                        <tr class="tr">
                            <td colspan="17" class="no-head">{{ __('messages.remarks') }}</td>
                        </tr>
                        <tr class="tr">
                            <td colspan="17">
                                <span class="num-length">
                                    {{-- <input {{ $disabled }} {{$tab_03['disabled_tab03']}} type="text" tabindex="9"
                                        class="form-control input-sm text-left nationality" maxlength="50"> --}}
                                </span>
                            </td>
                            @if ((isset($disabled) && $disabled == '') && (isset($tab_03['disabled_tab03']) && $tab_03['disabled_tab03'] == ''))
                                <td class="text-center no-head"
                                    style="position: relative;border-top: 2px solid #eaebee;">
                                    <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-tab3"
                                        style="position: relative;top:-127px;left: 0px;">
                                        <i class="fa fa-remove" style="font-size: 19px;"></i>
                                    </button>
                                </td>
                            @endif
                        </tr>
                    </tbody>
                @endif
            </table>
            {{-- <table id="table-empty" class="hidden table-target-1">
                <tbody>
                    <tr class="tr">
                        <td rowspan="8" class="text-center no">1</td>
                        <td class="no-head">{{ __('messages.training_code') }}</td>
                        <td colspan="4" class="no-head">{{ __('messages.training_name') }}</td>
                        <td colspan="4" class="no-head">{{ __('messages.training_category') }}</td>
                        <td colspan="4" class="no-head">{{ __('messages.course_format') }}</td>
                        <td colspan="4" class="no-head">{{ __('messages.lecturer_name') }}</td>
                        <td rowspan="7" class="no-head"></td>
                    </tr>
                    <tr class="tr">
                        <td>
                            <span class="num-length">
                                <div class="input-group-btn">
                                    <input type="text" class="d-none detail_no" value="0">
                                    <input type="text" class="form-control training_cd"
                                        trainings="{{ $tab_03['trainings'] ?? '' }}" editable_kbn="1" maxlength="6"
                                        tabindex="9" autocomplete="off">
                                </div>
                            </span>
                        </td>
                        <td colspan="4">
                            <span class="num-length">
                                <input type="text" tabindex="9"
                                    class="form-control input-sm text-left training_nm" maxlength="50" disabled
                                    decimal="2">
                            </span>
                        </td>
                        <td colspan="4">
                            <span class="num-length">
                                <select name="" class="form-control training_category_cd" disabled tabindex="9">
                                    <option value="0"></option>
                                    @if (!empty($tab_03['M5031']))
                                        @foreach ($tab_03['M5031'] as $item)
                                            <option value="{{ $item['training_category_cd'] }}">
                                                {{ $item['training_category_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </span>
                        </td>
                        <td colspan="4">
                            <span class="num-length">
                                <select name="" class="form-control training_course_format_cd" disabled tabindex="9">
                                    <option value="0"></option>
                                    @if (!empty($tab_03['M5032']))
                                        @foreach ($tab_03['M5032'] as $item)
                                            <option value="{{ $item['training_course_format_cd'] }}">
                                                {{ $item['training_course_format_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </span>
                        </td>
                        <td colspan="4">
                            <span class="num-length">
                                <input type="text" tabindex="9"
                                    class="form-control input-sm text-left lecturer_name" maxlength="20">
                            </span>
                        </td>
                    </tr>
                    <tr class="tr">
                        <td colspan="4" class="no-head">{{ __('messages.students_date') }}</td>
                        <td colspan="2" class="no-head">{{ __('messages.attendance_status') }}</td>
                        <td colspan="2" class="no-head">
                            {{ __('messages.passing_date') }}・{{ __('messages.certification_date') }}</td>
                        <td colspan="9" class="no-head">
                            {{ __('messages.certificate_data') }}
                        </td>
                    </tr>
                    <tr class="tr">
                        <td colspan="4">
                            <div class="d-flex">
                                <span class="num-length">
                                    <div class="input-group-btn input-group">
                                        <input type="text" class="form-control input-sm date training_date_from"
                                            placeholder="yyyy/mm/dd" tabindex="9">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                    class="fa fa-calendar"></i></button>
                                        </div>
                                    </div>
                                </span>
                                <div class="d-flex align-items-center pr-1 pl-1"
                                    style="position: relative;min-width: 22px;">
                                    <div class="contain-radio" style="position: absolute;top: 10px;">～</div>
                                </div>
                                <span class="num-length">
                                    <div class="input-group-btn input-group">
                                        <input type="text" class="form-control input-sm date training_date_to"
                                            placeholder="yyyy/mm/dd" tabindex="9">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                    class="fa fa-calendar"></i></button>
                                        </div>
                                    </div>
                                </span>
                            </div>
                        </td>
                        <td colspan="2">
                            <span class="num-length">
                                <select class="form-control training_status" tabindex="9">
                                    @if (!empty($tab_03['L0010_59']))
                                        @foreach ($tab_03['L0010_59'] as $item)
                                            <option value="{{ $item['number_cd'] }}">
                                                {{ $item['name'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </span>
                        </td>
                        <td colspan="2">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input type="text" class="form-control input-sm date passing_date"
                                        placeholder="yyyy/mm/dd" tabindex="9">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td colspan="9">
                            <div class="form-group mb-0">
                                <input type="file" class="form-control d-none input-import-file" accept=".pdf">
                                <input type="text" class="form-control d-none delete_file" value="0">
                                <div class="fake-input" style="position: relative; background-color: #EAEAEA;">
                                    <div class="button-upload"
                                        style="width: 35px; height: 35px; position: absolute; top: 3px;">
                                        <span class="face-file-btn d-block" tabindex="9">
                                            <i class="fa fa-folder-open"></i>
                                        </span>
                                    </div>
                                    <input type="text" class="form-control display-input" diploma_file=""
                                        diploma_file_name="" style="text-indent: 30px; background: unset; border: unset;  overflow: hidden; text-overflow: ellipsis; white-space: nowrap" readonly>
                                    <span class="diploma_file_uploaddatetime"
                                        style="position: absolute;top: 4px;right: 68px;padding: 0 3px;height: 30px;line-height: 30px; min-width: 130px; white-space: nowrap; text-align: center;"></span>
                                    <span class="button-download d-flex align-items-center justify-content-center"
                                        style="width: 30px;height: 30px;position: absolute;top: 4px;right: 35px;font-size: 20px;border: 1px solid #ccc;"
                                        tabindex="9">
                                        <i class="fa fa-download"></i>
                                    </span>
                                    <span class="button-remove d-flex align-items-center justify-content-center"
                                        style="width: 30px;height: 30px;position: absolute;top: 4px;right: 0px;font-size: 20px;color: #F72809;border: 1px solid #ccc;margin-right: 5px;"
                                        tabindex="9">
                                        <i class="fa fa-remove"></i>
                                    </span>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr class="tr">
                        <td colspan="1" class="no-head">{{ __('messages.necessity_report_submit') }}</td>
                        <td colspan="2" class="no-head">{{ __('messages.report_submit_date') }}</td>
                        <td colspan="14" class="no-head">{{ __('messages.report_storage_location') }}</td>
                    </tr>
                    <tr class="tr">
                        <td colspan="1">
                            <span class="num-length">
                                <select class="form-control report_submission" tabindex="9">
                                    @if (!empty($tab_03['L0010_60']))
                                        @foreach ($tab_03['L0010_60'] as $item)
                                            <option value="{{ $item['number_cd'] }}">
                                                {{ $item['name'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </span>
                        </td>
                        <td colspan="2">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input type="text" class="form-control input-sm date report_submission_date"
                                        placeholder="yyyy/mm/dd" tabindex="9">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" tabindex="-1"><i
                                                class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td colspan="14">
                            <span class="num-length">
                                <input type="text" tabindex="9" maxlength="50"
                                    class="form-control input-sm text-left report_storage_location">
                            </span>
                        </td>
                    </tr>
                    <tr class="tr">
                        <td colspan="17" class="no-head">{{ __('messages.remarks') }}</td>
                    </tr>
                    <tr class="tr">
                        <td colspan="17">
                            <span class="num-length">
                                <input type="text" tabindex="9"
                                    class="form-control input-sm text-left nationality" maxlength="50">
                            </span>
                        </td>
                        <td class="text-center no-head" style="position: relative;border-top: 2px solid #eaebee;">
                            <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-tab3"
                                style="position: relative;top:-127px;left: 0px;">
                                <i class="fa fa-remove" style="font-size: 19px;"></i>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table> --}}
        </div>
    </div>
</div>
