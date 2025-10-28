@extends('weeklyreport/layout')

@section('asset_header')
    {!! public_url('template/css/weeklyreport/ri2010/ri2010.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/weeklyreport/ri2010/ri2010.index.js') !!}
@stop

@php
    $button = [];
    if (isset($permissions['btn_temporary_header']) && $permissions['btn_temporary_header'] == 1) {
        $button[] = 'memoryButton';
    }
    if (isset($permissions['btn_submit_header']) && $permissions['btn_submit_header'] == 1) {
        $button[] = 'submitButton';
    }
    $button[] = 'backButton';
@endphp
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport($button) !!}
@endpush

@section('content')

@section('screen_title')
    {{ $screen_title }}
@stop

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    {{-- Header --}}
                    @include('WeeklyReport::ri2010.header')
                    {{-- 目標 --}}
                    @include('WeeklyReport::ri2010.target')
                    {{-- Content --}}
                    {{-- <div class="row">
                        <div class=""> --}}
                            {{-- Tab --}}
                            <ul class="nav nav-tabs tab-style">
                                <li class="nav-item " id="">
                                    <a class="nav-link treatment_applications_no nav-link-tab hei active show" data-toggle="tab"
                                        href="#tab1" role="tab" aria-selected="true" report_no={{$report_no_current}}>
                                        {{ __('ri2010.report') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                                @if (isset($report_no_prev_1) && $report_no_prev_1 > 0)
                                    <li class="nav-item " id="">
                                        <a class="nav-link treatment_applications_no nav-link-tab hei" data-toggle="tab"
                                            href="#tab2" role="tab" report_no={{$report_no_prev_1}}>
                                            {{ __('ri2010.previous_report') }}
                                            <div class="caret"></div>
                                        </a>
                                    </li>
                                @endif
                                @if (isset($report_no_prev_2) && $report_no_prev_2 > 0)
                                    <li class="nav-item " id="">
                                        <a class="nav-link treatment_applications_no nav-link-tab hei" data-toggle="tab"
                                            href="#tab3" role="tab" report_no={{$report_no_prev_2}}>
                                            {{ __('ri2010.before_last_report') }}
                                            <div class="caret"></div>
                                        </a>
                                    </li>
                                @endif
                                @if (isset($report_no_prev_3) && $report_no_prev_3 > 0)
                                    <li class="nav-item " id="">
                                        <a class="nav-link treatment_applications_no nav-link-tab hei" data-toggle="tab"
                                            href="#tab4" role="tab" report_no={{$report_no_prev_3}}>
                                            {{ __('ri2010.3rd_last_past_report') }}
                                            <div class="caret"></div>
                                        </a>
                                    </li>
                                @endif
                            </ul>
                            {{-- Tab Content --}}
                            <div class="tab-content list_detail w-result-tabs row">
                                @include('WeeklyReport::ri2010.report')
                            </div>
                        {{-- </div>
                       
                    </div> --}}
                </div>
            </div>
        </div><!-- end .col-md-12 -->
    </div><!-- end .row -->
    <input type="hidden" class="anti_tab" name="">
    <input type="hidden" id="fiscal_year" value="{{ $fiscal_year ?? 0 }}">
    <input type="hidden" id="report_kind" value="{{ $report_kind ?? 0 }}">
    <input type="hidden" id="employee_cd" value="{{ $employee_cd ?? '' }}">
    <input type="hidden" id="report_no" value="{{ $report_no_current ?? 0 }}">
    <input type="hidden" id="from" value="{{ $from ?? '' }}">
    <input type="hidden" id="list_report_no" value="{{ $list_report_no ?? '' }}">
    <input type="hidden" id="login_use_typ" value="{{ $permissions['login_use_typ'] ?? 0 }}">
    <input type="hidden" id="admin_and_is_approver" value="{{ $permissions['admin_and_is_approver'] ?? 0 }}">
    <input type="hidden" id="admin_and_is_viewer" value="{{ $permissions['admin_and_is_viewer'] ?? 0 }}">
    <input type="hidden" id="language_name" value="{{ $language_name ?? '' }}">
    <input type="hidden" id="multilingual_use_typ" value="{{ $multilingual_use_typ ?? 0 }}">
</div><!-- end .container-fluid -->
{{-- Paging --}}
@if (isset($report_total) && $report_total > 0 && $is_paging > 0)
    <div class="content-footer row">
        <div class="col-2 col-sm-4 col-md-3 col-xl-2 screen__back">
            <a href="#" id="btn_dashboard"><i class="fa fa-angle-double-left" aria-hidden="true"></i>
                <span>{{ __('ri2010.back') }}</span> </a>
        </div>
        {{-- 報告者以外は利用可能 --}}
        @if (isset($permissions['login_use_typ']) && $permissions['login_use_typ'] != 1)
            <div class="col-10 col-sm-8 col-md-6 col-xl-8 screen__paging justify-content-md-center">
                <button id="btn-prev" class="btn btn-outline-primary btn-sm" tabindex="6"
                    {{ $report_no_prev == 0 ? 'disabled' : '' }} fiscal_year_prev="{{ $fiscal_year_prev ?? 0 }}"
                    employee_cd_prev="{{ $employee_cd_prev ?? '' }}" report_kind_prev="{{ $report_kind_prev ?? 0 }}"
                    report_no_prev="{{ $report_no_prev ?? 0 }}">
                    <i class="fa fa-chevron-left"></i>
                    <span>{{ __('ri2010.prev') }}</span>
                </button>
                <button id="btn-next" class="btn btn-outline-primary btn-sm" tabindex="6"
                    {{ $report_no_next == 0 ? 'disabled' : '' }} fiscal_year_next="{{ $fiscal_year_next ?? 0 }}"
                    employee_cd_next="{{ $employee_cd_next ?? '' }}" report_kind_next="{{ $report_kind_next ?? 0 }}"
                    report_no_next="{{ $report_no_next ?? 0 }}">
                    <span>{{ __('ri2010.next') }}</span>
                    <i class="fa fa-chevron-right"></i>
                </button>
                <div class="screen__paging__label">
                    <span class="">{{ $report_total ?? 0 }} {{ __('ri2010.report_in') }}
                        {{ $report_index ?? 0 }}
                        {{ __('ri2010.report_total') }}</span>
                </div>
            </div>
        @endif
    </div><!-- end .content-footer -->
@endif

@stop
