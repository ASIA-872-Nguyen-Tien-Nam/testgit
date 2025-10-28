<div class="card">
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
            <div class="col-sm-12 col-md-6">
                <div class="form-group">
                    <label class="control-label lb-required"
                        lb-required="{{ __('messages.required') }}">{{ __('rq2011.group_name') }}</label>
                    <span class="num-length">
                        <input type="text" id="mygroup_nm" class="form-control text-left required" maxlength="20"
                            value="{{ $mygroup['mygroup_nm'] ?? '' }}" tabindex="1" />
                        <input type="hidden" id="mygroup_cd" value="{{ $mygroup['mygroup_cd'] ?? -1 }}">
                    </span>
                </div>
            </div>
        </div>
        {{--  --}}
        <div class="row">
            <div class="col-md-2 div_parent_employee_cd">
                <div class="form-group">
                    <label class="control-label">{{ __('messages.employee_no') }}
                    </label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <span class="num-length">
                            <input type="text" fiscal_year_weeklyreport={{ $fiscal_year_today ?? 0 }}
                                class="form-control indexTab employee_cd refer_employee_cd  Convert-Halfsize"
                                tabindex="2" maxlength="10" id="employee_cd" value=""
                                style="padding-right: 40px;" />
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
            <div class="col-md-2 div_parent_employee_nm">
                <div class="form-group">
                    <label class="control-label">{{ __('messages.name_s') }}</label>
                    <div class="input-group-btn input-group">
                        <span class="num-length">
                            <input type="text" class="form-control text-gray employee_name" tabindex="3"
                                maxlength="101" value="" placeholder="{{ __('rq2011.placeholder') }}"
                                id="employee_name" />
                        </span>
                    </div>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label class="control-label"
                        style="white-space:pre;">{{ __('messages.employee_classification') }}</label>
                    <select class="form-control" tabindex="4" id="employee_typ">
                        <option value="-1"></option>
                        @if (isset($combo_employee_type))
                            @foreach ($combo_employee_type as $row)
                                <option value="{{ $row['employee_typ'] }}">{{ $row['employee_typ_nm'] }}</option>
                            @endforeach
                        @endif
                    </select>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label class="control-label">{{ __('messages.position') }}</label>
                    <select class="form-control" tabindex="5" id="position_cd">
                        <option value="-1"></option>
                        @if (isset($combo_position))
                            @foreach ($combo_position as $row)
                                <option value="{{ $row['position_cd'] }}">{{ $row['position_nm'] }}</option>
                            @endforeach
                        @endif
                    </select>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-2">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.grade') }}</label>
                            <select class="form-control" tabindex="6" id="grade">
                                <option value="-1"></option>
                                @if (isset($combo_grade))
                                    @foreach ($combo_grade as $row)
                                        <option value="{{ $row['grade'] }}">{{ $row['grade_nm'] }}</option>
                                    @endforeach
                                @endif
                            </select>
                        </div>
                        <!--/.form-group -->
                    </div><!-- end .col-md-9 -->
                </div><!-- end .row -->
            </div>
        </div>
        {{--  --}}
        <div class="row">
            @if (isset($organization_group[0]) && !empty($organization_group[0]))
                <div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
                    <div class="form-group">
                        <label class="control-label text-overfollow" data-toggle="tooltip"
                            data-original-title="{{ $organization_group[0]['organization_group_nm'] }}"
                            style="margin-bottom: 0px;width:100%">
                            {{ $organization_group[0]['organization_group_nm'] }}
                        </label>
                        <div class="multi-select-full">
                            <select autocomplete="off" name="" id="organization_step1"
                                class="form-control organization_cd1 multiselect" tabindex="6" organization_typ='1'
                                multiple="multiple" system="5" >
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
                        <div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
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
                                        tabindex="6" organization_typ="{{ $dt['organization_typ'] }}"
                                        multiple="multiple" system="5">
                                    </select>
                                </div>
                            </div>
                            <!--/.form-group -->
                        </div>
                    @endif
                @endforeach
            @endif
        </div>
    </div>
</div>
<div class="card" style="margin-bottom: 50px;">
    <div class="card-body">
        {{-- Button Action --}}
        <div class="row" style="margin: -10px;">
            <div class="col-12">
                <div class="form-group text-right">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="8">
                            <i class="fa fa-user-o"></i>
                            {{ __('messages.extract_employee') }}
                        </a>
                        <a href="javascript:;" id="btn_add" class="btn btn-outline-primary" tabindex="9">
                            <i class="fa fa-user-plus"></i>
                            {{ __('messages.add_employee') }}
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="data-search">
            @include('WeeklyReport::rq2011.search')
        </div>
    </div>
</div>
<div class="row justify-content-md-center mb-3" style="position: absolute;width: 100%;bottom: 0px;">
    {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
</div>
<input type="hidden" id="mode_find" value="{{$mode??0}}">
<table class="d-none" id="table_row_add">
    <tbody class="">
        <tr class="tr_employee">
            <td class="text-center w-50px check-color">
                <div class="md-checkbox-v2 inline-block ck-nolabel"><label for="ck1"
                        class="container checkbox-os0030-body lab_chk"><input type="checkbox" id="ck11"
                            class="chk-item ck1 inp_chk"><span class="checkmark" style="top:-7px"></span></label>
                </div>
            </td>
            <td class="w-120px"><input type="hidden" class="tb_employee_cd" value="">
                <div class="input-group-btn input-group employee_cd div_employee_cd">
                    <span class="num-length">
                        <input type="hidden" class="employee_cd_hidden employee_cd employee_cd_add" />
                        <input type="text" fiscal_year_weeklyreport={{ $fiscal_year_today ?? 0 }} id="employee_nm"
                            class="form-control indexTab employee_nm_weeklyreport add_employee_cd ui-autocomplete-input"
                            tabindex="33" maxlength="101" value="" style="padding-right: 40px;" />
                    </span>
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button"
                            tabindex="-1">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </td>
            <td class="w-120px">
                <div class="text-overfollow employee_nm" data-container="body" data-toggle="tooltip"
                    data-original-title=""></div>
            </td>
            <td class="w-120px ">
                <div class="text-overfollow employee_typ_nm" data-container="body" data-toggle="tooltip"
                    data-original-title=""></div>
            </td>
            @isset($organization_group)
                @foreach ($organization_group as $key => $item)
                    <td class="w-120px ">
                        <div class="text-overfollow organization_nm_{{ $key + 1 }}" data-container="body"
                            data-toggle="tooltip" data-original-title=""></div>
                    </td>
                @endforeach
            @endisset
            <td class="w-120px ">
                <div class="text-overfollow job_nm" data-container="body" data-toggle="tooltip"
                    data-original-title="">
                </div>
            </td>
            <td class="w-120px ">
                <div class="text-overfollow position_nm" data-container="body" data-toggle="tooltip"
                    data-original-title=""></div>
            </td>
            <td class="w-120px ">
                <div class="text-overfollow grade_nm" data-container="body" data-toggle="tooltip"
                    data-original-title=""></div>
            </td>
        </tr>
    </tbody>
</table><!-- /.hidden -->
