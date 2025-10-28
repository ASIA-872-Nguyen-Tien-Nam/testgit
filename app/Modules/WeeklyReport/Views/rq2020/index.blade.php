@extends('weeklyreport/layout')
@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/rq2020/rq2020.index.css') !!}
@stop
@section('asset_footer')
    {!! public_url('template/js/weeklyreport/rq2020/rq2020.index.js') !!}
    <!-- START LIBRARY JS -->
@stop

@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['downloadButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-6 col-md-3 col-lg-2" style="min-width:160px">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('rq2020.year') }}</label>
                            <select id="fiscal_year" tabindex="1" class="form-control required" autofocus tabindex='1'>
                                <option value="-1"></option>
                                @isset($fiscal_year)
                                    @foreach ($fiscal_year as $fiscal_year)
                                        <option value="{{ $fiscal_year['fiscal_year'] }}"
                                            {{ $fiscal_year_param == $fiscal_year['fiscal_year'] ? 'selected' : '' }}>
                                            {{ $fiscal_year['fiscal_year'] }}{{ __('ri1021.fiscal_year') }}
                                        </option>
                                    @endforeach
                                @endisset
                            </select>
                        </div>
                    </div>

                    <div id="range_date" class="col-sm-3 col-md-2 col-lg-5 col-xl-3  character2 date_row"
                        style="padding-right:0px;">
                        <div class="form-group">
                            <label class="control-label" style="height: 16px;"></label>
                            <div style="display: flex;">
                                <div class="input-group-btn input-group col-5" style="padding-left:0px;padding-right:0px">
                                    <input type="text" class="form-control right-radius month" placeholder="yyyy/mm"
                                        value="{{$year_month_from_param??''}}" tabindex="1" autofocus id="year_month_start">
                                </div>
                                <div class="multi-select-full mr-3 ml-3">
                                    ~
                                </div>
                                <div class="input-group-btn input-group col-5" style="padding-left:0px;padding-right:0px">
                                    <input type="text" class="form-control right-radius month" placeholder="yyyy/mm"
                                        value="{{$year_month_to_param??''}}" tabindex="1" id="year_month_end">
                                </div>

                            </div>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-sm-6 col-md-3 col-lg-2" id="select_type" style="min-width:160px;">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('rq2020.report_type') }}</label>
                            <select id="report_kinds" tabindex="1" class="form-control required" autofocus tabindex='1'>
                                <option value="-1"></option>
                                @isset($report_kinds)
                                    @foreach ($report_kinds as $report_kind)
                                        <option value="{{ $report_kind['report_kind'] }}" {{$report_kind_param == $report_kind['report_kind'] ?'selected':''}}>
                                            {{ $report_kind['report_nm'] }}</option>
                                    @endforeach
                                @endisset
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3 col-lg-2" style="">
                        <label class="control-label lb-required"
                            lb-required="{{ __('messages.required') }}">{{ __('rq2020.employee_name') }}</label>
                        {{-- @if (isset(session_data()->report_authority_typ) && session_data()->report_authority_typ == 1)
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden" id="employee_cd"
                                        value="{{ session_data()->m0070->employee_cd }}">
                                    <input type="text" fiscal_year_weeklyreport="{{ $fiscal_year_today ?? 0 }}"
                                        id="employee_nm"
                                        class="form-control indexTab employee_nm_weeklyreport ui-autocomplete-input required"
                                        disabled tabindex="1" maxlength="101"
                                        value="{{ session_data()->m0070->employee_nm }}" autocomplete="off">
                                </span>
                            </div>
                        @else --}}
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden" id="employee_cd" value="{{$employee_cd_param??''}}">
                                    <input type="text" fiscal_year_weeklyreport="{{ $fiscal_year_today ?? 0 }}"
                                        id="employee_nm"
                                        class="form-control indexTab employee_nm_weeklyreport ui-autocomplete-input required"
                                        tabindex="1" maxlength="101" value="{{$employee_nm_param??''}}" autocomplete="off">
                                </span>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button"
                                        tabindex="-1">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        {{-- @endif --}}
                    </div>
                    <div class="col-sm-3 col-md-2 col-lg-1 character0" id="button_search">
                        <div class="form-group">
                            <label class="control-label">&nbsp;</label>
                            <div class="full-width">
                                <a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="7">
                                    <i class="fa fa-search"></i>
                                    {{ __('messages.search') }}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div><!-- end .row -->
            </div>
        </div>
        <div class="card">
            <div class="card-body p-0">
                <div class="" id="result">
                    @include('WeeklyReport::rq2020.refer')
                </div>
            </div>
        </div>
    </div><!-- end .container-fluid -->
@stop
