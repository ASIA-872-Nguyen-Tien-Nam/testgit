@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/ri1010/ri1010.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/weeklyreport/ri1010/ri1010.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['saveButton', 'deleteButton', 'backButton']) !!}
@endpush

@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row div_month_times">
                    <div class="col-md-3 col-xs-12 col-lg-1" style="min-width: 160px">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}&nbsp;
                            </label>
                            <select name="" id="fiscal_year" class="form-control required r_fiscal_year"
                                screen="schedule" tabindex="1">
                                @for ($i = $fiscal_year - 3; $i <= $fiscal_year + 3; $i++)
                                    <option value="{{ $i }}" {{ $i == $fiscal_year ? 'selected' : '' }}>
                                        {{ $i }}{{ __('ri1021.fiscal_year') }}
                                    </option>
                                @endfor
                            </select>
                        </div>
                    </div>
                    @php
                        $hide_class = 'unset';
                        if (isset($report_kinds[0]['report_kind']) && $report_kinds[0]['report_kind'] < 4) {
                            $hide_class = 'none';
                        }
                    @endphp
                    <div class="col-md-3 col-xs-12 col-lg-1" id="block_month" style="min-width: 160px;display:{{ $hide_class }}">
                        <div class="form-group">
                            <label class="control-label">{{ __('ri1010.month') }}&nbsp;</label>
                            <select name="" id="month" class="form-control month_times" tabindex="2">
                                @isset($report_kinds[0]['report_kind'])
                                    @if ($report_kinds[0]['report_kind'] < 5)
                                        <option value="-1" class="full-month"></option>
                                    @endif
                                @endisset
                                @isset($month_s)
                                    @foreach ($month_s as $month_s)
                                        <option value="{{ $month_s['month'] }}">
                                            {{ $month_s['month_nm'] }}</option>
                                    @endforeach
                                @endisset
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3 col-xs-12 col-lg-2" style="min-width: 160px">
                        <div class="form-group">
                            <label style="white-space: nowrap" class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('rm0200.report_type') }}</label>
                            <div>
                                <select class="form-control r_report_kind required" id="report_kind" tabindex="3"
                                    screen="schedule">
                                    @isset($report_kinds)
                                        @foreach ($report_kinds as $report_kind)
                                            <option value="{{ $report_kind['report_kind'] }}">
                                                {{ $report_kind['report_name'] }}</option>
                                        @endforeach
                                    @endisset
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-xs-12 col-lg-3">
                        <div class="form-group">
                            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">
                                {{ __('messages.group_name1') }}&nbsp;</label>
                            <div class="multi-select-full">
                                <select id="report_group" tabindex="3"
                                    class="form-control multiselect required  report_group group_cd " multiple="multiple">
                                    @if (isset($report_group))
                                        @foreach ($report_group as $item)
                                            <option value="{{ $item['group_cd'] }}">{{ $item['group_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="refer_data">
                    @include('WeeklyReport::ri1010.refer')
                </div>
                <div class="row justify-content-md-center" style="margin-top: -1rem">
                    {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
                </div>
            </div><!-- end .card-body -->
        </div><!-- end .card -->
    </div><!-- end .container-fluid -->
@stop
