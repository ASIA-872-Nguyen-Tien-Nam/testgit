<div class="card-body">
    <div class="row" style="margin: -10px;">
        <div class="col-md-5 col-5"></div>
        <div class="col-md-7 col-7">
            <button type="button" class="btn button-card"><span><i
                        class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-12 col-md-12 col-lg-3 col-xl-2">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                    style="white-space: nowrap;">{{ __('rm0100.report_type') }}</label>
                <div style="padding-left: 0px">
                    <span class="num-length">
                        <select id="report_kinds" tabindex="1" class="form-control required" autofocus>
                            <option value="-1"></option>
                            @isset($report_kinds)
                                @foreach ($report_kinds as $report_kind)
                                    <option value="{{ $report_kind['report_kind'] }}">
                                        {{ $report_kind['report_nm'] }}</option>
                                @endforeach
                            @endisset
                        </select>
                    </span>
                </div><!-- end .col-md-3 -->
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group fiscalYear">
                <label class="control-label lb-required"
                    lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                <select name="" id="fiscal_year" class="form-control required" tabindex="2">
                    <option value="-1"></option>
                    @isset($fiscal_year)
                        @foreach ($fiscal_year as $fiscal_year)
                            <option value="{{ $fiscal_year['fiscal_year'] }}"
                                {{ $fiscal_year_today == $fiscal_year['fiscal_year'] ? 'selected' : '' }}>
                                {{ $fiscal_year['fiscal_year'] }}{{ __('ri1021.fiscal_year') }}
                            </option>
                        @endforeach
                    @endisset
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label lb-required"
                    lb-required="{{ __('messages.required') }}">{{ __('messages.group') }}</label>&nbsp;
                <select id="report_group" name="report_group" class="form-control required" tabindex="3">
                    <option value="-1"></option>
                    @if (isset($report_group))
                        @foreach ($report_group as $item)
                            <option value="{{ $item['group_cd'] }}">{{ $item['group_nm'] }}</option>
                        @endforeach
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class="row">
        @if (isset($organization_group[0]) && !empty($organization_group[0]))
            <div class="col-md-4 col-lg-3 col-xl-2">
                <div class="form-group">
                    <label class="control-label text-overfollow" data-toggle="tooltip"
                        data-original-title="{{ $organization_group[0]['organization_group_nm'] }}"
                        style="margin-bottom: 0px;width:100%">
                        {{ $organization_group[0]['organization_group_nm'] }}
                    </label>
                    <div class="multi-select-full">
                        <select autocomplete="off" name="" id="organization_step1"
                            class="form-control organization_cd1 multiselect" tabindex="6" organization_typ='1'
                            multiple="multiple" system="5">
                            @foreach ($combo_organization as $row)
                                <option value="{{ $row['organization_cd_1'] }}">{{ $row['organization_nm'] }}
                                </option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <!--/.form-group -->
            </div>
            @foreach ($organization_group as $dt)
                @if ($dt['organization_typ'] >= 2)
                    <div class="col-md-4 col-lg-3 col-xl-2">
                        <div class="form-group">
                            <label class="control-label text-overfollow" data-toggle="tooltip"
                                data-original-title="{{ $dt['organization_group_nm'] }}"
                                style="margin-bottom: 0px;width:100%">
                                {{ $dt['organization_group_nm'] }}
                            </label>
                            <div class="multi-select-full">
                                <select autocomplete="off" name=""
                                    id="{{ 'organization_step' . $dt['organization_typ'] }}"
                                    class="form-control {{ 'organization_cd' . $dt['organization_typ'] }} multiselect"
                                    tabindex="6" organization_typ="{{ $dt['organization_typ'] }}" multiple="multiple"
                                    system="5">
                                </select>
                            </div>
                        </div>
                        <!--/.form-group -->
                    </div>
                @endif
            @endforeach
        @endif
    </div>
    <div class="row">
        <div class="col-md-4 col-lg-3 col-xl-2">
            <div class="form-group">
                <label class="control-label"
                    style="white-space:pre;">{{ __('messages.employee_classification') }}</label>
                <select class="form-control" tabindex="9" id="employee_typ">
                    <option value="-1"></option>
                    @if (isset($combo_employee_type))
                        @foreach ($combo_employee_type as $row)
                            <option value="{{ $row['employee_typ'] }}">{{ $row['employee_typ_nm'] }}</option>
                        @endforeach
                    @endif
                </select>
            </div>
        </div>
        <div class="col-md-4 col-lg-3 col-xl-2">
            <div class="form-group">
                <label class="control-label text-overfollow" data-toggle="tooltip" data-original-title=""
                    style="margin-bottom: 0px;width:100%">
                    {{ __('messages.position') }}
                </label>
                <div class="multi-select-full">
                    <select autocomplete="off" name="" id="position_cd"
                        class="form-control organization_cd1 multiselect" tabindex="9" organization_typ='1'
                        multiple="multiple">
                        @if (isset($combo_position))
                            @foreach ($combo_position as $row)
                                <option value="{{ $row['position_cd'] }}">{{ $row['position_nm'] }}</option>
                            @endforeach
                        @endif
                    </select>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-lg-3 col-xl-2 div_parent_employee_cd">
            <div class="form-group">
                <label class="control-label">{{ __('ri1021.reporter') }}</label>
                <div class="input-group-btn input-group div_employee_cd">
                    <span class="num-length">
                        <input type="hidden" class="employee_cd_hidden" id="employee_cdX" />
                        <input type="text" fiscal_year_weeklyreport={{ $fiscal_year_today ?? 0 }} id="employee_nm"
                            class="form-control indexTab employee_nm_weeklyreport ui-autocomplete-input"
                            tabindex="10" maxlength="101" value="" style="padding-right: 40px;" />
                    </span>
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button"
                            tabindex="-1">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div><!-- end .card-body -->
