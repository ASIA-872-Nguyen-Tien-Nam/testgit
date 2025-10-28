@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/rq3040/rq3040.index.css') !!}
@stop
@section('asset_footer')
    {!! public_url('template/js/weeklyreport/rq3040/rq3040.index.js') !!}
    <!-- START LIBRARY JS -->
@stop

@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['excel', 'backButton']) !!}
@endpush

@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card box-search-card-common">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-5 col-5"></div>
                    <div class="col-md-7 col-7">
                        <button type="button" class="btn button-card"><span><i
                                    class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
                    </div>
                </div>
                <br>
                <div class="group-search-condition">
                    <div class="row">
                        <div class=" col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label lb-required"
                                    lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                                <select id="fiscal_year" class="form-control required" tabindex="1">
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
                            </div><!-- end .p-title -->
                        </div>
                        <div class=" col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label lb-required"
                                    lb-required="{{ __('messages.required') }}">{{ __('rq3040.combination_1') }}</label>
                                <select id="combination_vertical" class="form-control required" tabindex="1">
                                    <option value="1">{{ __('messages.implementation_status') }}</option>
                                    <option value="2">{{ __('messages.adequacy') }}</option>
                                    <option value="3">{{ __('rq3040.reactions') }}</option>
                                </select>
                            </div><!-- end .p-title -->
                        </div>
                        <div class=" col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">&nbsp;</label>
                                <select id="combination_horizontal" class="form-control required" tabindex="1">
                                    <option value="1">{{ __('messages.implementation_status') }}</option>
                                    <option value="2">{{ __('messages.adequacy') }}</option>
                                    <option value="3">{{ __('rq3040.reactions') }}</option>
                                </select>
                            </div><!-- end .p-title -->
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('rq3040.adequacy_type') }}</label>
                                <select name="adequacy_type" id="adequacy_type" class="form-control adequacy_type"
                                    tabindex="2">
                                    <option value="1">{{ __('rq3020.adequacy') }}</option>
                                    <option value="2">{{ __('rq3020.busyness') }}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('rq3040.employee_role') }}</label>
                                <select name="employee_role" id="employee_role" class="form-control employee_role"
                                    tabindex="2">
                                    <option value="1">{{ __('rq3030.approver_reaction') }}</option>
                                    <option value="2">{{ __('rq3030.viewer_reaction') }}</option>
                                </select>
                            </div>
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
                                            class="form-control organization_cd1 multiselect" tabindex="6"
                                            organization_typ='1' multiple="multiple" system="5">
                                            @foreach ($combo_organization as $row)
                                                <option value="{{ $row['organization_cd_1'] }}">
                                                    {{ $row['organization_nm'] }}
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
                    <div class="row">
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.group') }}</label>
                                <div class="multi-select-full">
                                    <select id="group_cd" tabindex="6" class="form-control multiselect group_cd"
                                        multiple="multiple">
                                        @if (isset($report_group))
                                            @foreach ($report_group as $item)
                                                <option value="{{ $item['group_cd'] }}">{{ $item['group_nm'] }}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.position') }}</label>
                                <select tabindex="6" name="position_cd" id="position_cd" class="form-control position_cd">
                                    <option value="-1"></option>
                                    @if (isset($combo_position))
                                        @foreach ($combo_position as $row)
                                            <option value="{{ $row['position_cd'] }}">{{ $row['position_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>

                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.job') }}</label>
                                <select tabindex="6" name="job_cd" id="job_cd" class="form-control job_cd">
                                    <option value="-1"></option>
                                    @if (isset($job))
                                        @foreach ($job as $row)
                                            <option value="{{ $row['job_cd'] }}">{{ $row['job_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.grade') }}</label>
                                <div class="multi-select-full">
                                    <select id="grade" tabindex="6" class="form-control multiselect"
                                        multiple="multiple">
                                        @if (isset($combo_grade))
                                            @foreach ($combo_grade as $row)
                                                <option value="{{ $row['grade'] }}">{{ $row['grade_nm'] }}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('rq3020.authorizer') }}</label>
                                <div class="input-group-btn input-group div_employee_cd">
                                    <span class="num-length">
                                        <input type="hidden" class="employee_cd_hidden" id="approver_cd"
                                            value="">
                                        <input type="text" fiscal_year_weeklyreport="{{ $fiscal_year_today ?? 0 }}"
                                            id="approver_employee_nm"
                                            class="form-control indexTab employee_nm_weeklyreport ui-autocomplete-input"
                                            tabindex="6" maxlength="101" value="" autocomplete="off">
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport"
                                            type="button" tabindex="-1">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-9 col-xl-2">
                            <div class="form-group" style="float:right">
                                <label class="control-label">&nbsp;</label>
                                <div class="input-group-btn input-group ">
                                    <div class="form-group text-right">
                                        <div class="full-width">
                                            <a href="javascript:;" id="btn_search" class="btn btn-outline-primary"
                                                tabindex="7">
                                                <i class="fa fa-search"></i>
                                                {{ __('messages.search') }}
                                            </a>
                                        </div><!-- end .full-width -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> <!-- end .row -->
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-body" id="result">
                @include('WeeklyReport::rq3040.search')
            </div><!-- end .card-body -->
        </div><!-- end .card -->
    </div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop
