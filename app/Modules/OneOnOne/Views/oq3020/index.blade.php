@extends('oneonone/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/oneonone/oq3020/oq3020.index.css') !!}
@stop
@section('asset_footer')
    {!! public_url('template/js/oneonone/oq3020/oq3020.index.js') !!}
    <!-- START LIBRARY JS -->
@stop

@push('asset_button')
    {!! Helper::dropdownRender1on1(['downloadButton', 'backButton']) !!}
@endpush
@php
    function year_english($message) {
    if( \Session::get('website_language', config('app.locale')) == 'en')
        return  '';
    else
        return  $message;
    }
@endphp
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
                                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                                <select id="fiscal_year" class="form-control required" tabindex="1">
                                    @for ($i = $year_time - 3; $i <= $year_time + 3; $i++)
                                        <option value="{{ $i }}" {{ $i == $year_time ? 'selected' : '' }}>{{ $i }}{{year_english(__('messages.fiscal_year'))}}</option>
                                    @endfor
                                </select>
                            </div><!-- end .p-title -->
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.questionnaire_type') }}</label>
                                <select name="employee_role" id="employee_role" class="form-control employee_role required"
                                    tabindex="2">
                                    <option value="-1"></option>
                                    <option value="1">{{ __('messages.coach') }}</option>
                                    <option value="2">{{ __('messages.member') }}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.group') }}</label>
                                <select name="group_cd" id="group_cd" class="form-control group_cd_1on1" tabindex="3">
                                    <option value="-1"></option>
                                    @if (!empty($list[0]))
                                        @foreach ($list as $row)
                                            <option class="text-overfollow list-search-child"
                                                value="{{ $row['1on1_group_cd'] }}">{{ $row['1on1_group_nm'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.number_of_interviews') }}</label>
                                <div class="multi-select-full">
                                    <select id="times" tabindex="4" class="form-control  multiselect times"
                                        multiple="multiple">
                                        @if (!empty($list_times))
                                            @foreach ($list_times as $ltimes)
                                                <option value="{{ $ltimes['times'] }}">{{ $ltimes['times'] }}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.employee_name') }}</label>
                                <div class="input-group-btn input-group div_employee_cd">
                                    <span class="num-length">
                                        <input type='hidden' class="employee_cd_hidden" id="employee_cd" value="">
                                        <input type="text" fiscal_year_1on1=""
                                            class="form-control employee_nm_1on1 indexTab employee_nm  Convert-Halfsize"
                                            id="" tabindex="5" maxlength="101" value="" style="padding-right: 40px;" />
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button"
                                            tabindex="-1">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        @foreach ($M0022 as $item)
                            @if ($item['organization_step'] == 1)
                                <div class="col-sm-6 col-md-4 col-lg-3 col-sm-12 col-xl-2">
                                    <div class="form-group">
                                        <div class="text-overfollow multi-select-lb" data-container="body"
                                            data-toggle="tooltip" data-original-title="{{ $item['organization_group_nm'] }}"
                                            style="margin-bottom: .5rem;">{{ $item['organization_group_nm'] }}</div>
                                        <div class="multi-select-full">
                                            <select system="2" tabindex="6"
                                                id="organization_step{{ $item['organization_step'] }}"
                                                organization_typ="{{ $item['organization_typ'] }}" tabindex="8"
                                                class="form-control multiselect organization_cd1" multiple="multiple">
                                                @foreach ($M0020 as $temp)
                                                    <option
                                                        value="{{ $temp['organization_cd_1'] . '|' . $temp['organization_cd_2'] . '|' . $temp['organization_cd_3'] . '|' . $temp['organization_cd_4'] . '|' . $temp['organization_cd_5'] }}">
                                                        {{ $temp['organization_nm'] }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            @else
                                <div class="col-sm-6 col-md-4 col-lg-3 col-sm-12 col-xl-2">
                                    <div class="form-group ">
                                        <div class="text-overfollow multi-select-lb" data-container="body"
                                            data-toggle="tooltip"
                                            data-original-title="{{ $item['organization_group_nm'] }}"
                                            style="margin-bottom: .5rem;">{{ $item['organization_group_nm'] }}</div>
                                        <div class="multi-select-full">
                                            <select system="2" tabindex="6"
                                                id="organization_step{{ $item['organization_step'] }}"
                                                organization_typ="{{ $item['organization_typ'] }}" tabindex="8"
                                                class="form-control multiselect organization_cd{{ $item['organization_step'] }}"
                                                multiple="multiple">
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            @endif
                        @endforeach
                    </div>
                    <div class="row" style="margin-top: 10px;">
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.position') }}</label>
                                <select tabindex="7" name="position_cd" id="position_cd" class="form-control position_cd">
                                    <option value="-1"></option>
                                    @if (!empty($list_m0040))
                                        @foreach ($list_m0040 as $key => $m0040)
                                            <li class="active m0040">
                                                <option value="{{ $m0040['position_cd'] }}">{{ $m0040['position_nm'] }}
                                                </option>
                                            </li>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.grade') }}</label>
                                <select tabindex="8" name="grade" id="grade" class="form-control grade">
                                    <option value="-1"></option>
                                    @if (!empty($list_m0050))
                                        @foreach ($list_m0050 as $key => $m0050)
                                            <li class="active m0050">
                                                <option value="{{ $m0050['grade'] }}">{{ $m0050['grade_nm'] }}</option>
                                            </li>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.job') }}</label>
                                <select tabindex="9" name="job_cd" id="job_cd" class="form-control job_cd">
                                    <option value="-1"></option>
                                    @if (!empty($list_m0030))
                                        @foreach ($list_m0030 as $key => $m0030)
                                            <li class="active m0050">
                                                <option value="{{ $m0030['job_cd'] }}">{{ $m0030['job_nm'] }}</option>
                                            </li>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.employee_classification') }}</label>
                                <select tabindex="10" name="employee_typ" id="employee_typ"
                                    class="form-control employee_typ">
                                    <option value="-1"></option>
                                    @if (!empty($list_m0060))
                                        @foreach ($list_m0060 as $key => $m0060)
                                            <li class="active m0050">
                                                <option value="{{ $m0060['employee_typ'] }}">
                                                    {{ $m0060['employee_typ_nm'] }}</option>
                                            </li>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.coach') }}</label>
                                <div class="input-group-btn input-group div_employee_cd">
                                    <span class="num-length">
                                        <input type='hidden' class="employee_cd_hidden" id="coach_cd" value="">
                                        <input type="text" fiscal_year_1on1=""
                                            class="form-control indexTab employee_nm employee_nm_1on1" id="coach_cd"
                                            tabindex="11" maxlength="101" value="" style="padding-right: 40px;" />
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button"
                                            tabindex="-1">
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
                                                tabindex="12">
                                                <i class="fa fa-search"></i>
                                                {{ __('messages.search') }}
                                            </a>
                                        </div><!-- end .full-width -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" class="anti_tab" name="">
                    </div> <!-- end .row -->
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-body" id="result">
                @include('OneOnOne::oq3020.search')
            </div><!-- end .card-body -->
        </div><!-- end .card -->
    </div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop
