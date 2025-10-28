@extends('weeklyreport/layout')
@section('asset_header')
    {!! public_url('template/css/weeklyreport/rm0020/rm0020.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/weeklyreport/rm0020/rm0020.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['saveButton', 'deleteButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="row" style="justify-content: space-between">
                            <div class="col-xl-3 col-lg-4 col-md-5 col-8">
                                <div class="">
                                    <label for="" class="lb-required"
                                        lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                                    <div style="display: flex;">
                                        <select id="fiscal_year" class="form-control required" tabindex="1">
                                            @for ($i = $today - 3; $i <= $today + 3; $i++)
                                                <option value="{{ $i }}" {{ $i == $today ? 'selected' : '' }}>
                                                    {{ $i }}
                                                    {{ \Session::get('website_language', config('app.locale')) == 'en' ? '' : __('messages.fiscal_year') }}
                                                </option>
                                            @endfor
                                        </select>
                                        <div class="input-group-btn input-group" style="margin-left: 10px;">
                                            <div class="{{ ($data['count_data'] ?? 0) == 0 ? '' : 'hidden' }}"
                                                id="unregistered" style="color: blue;margin-top: 7px;">
                                                {{ __('messages.unregistered') }}</div>
                                        </div>
                                    </div>
                                </div><!-- end .p-title -->
                            </div>
                            <div class="col-md-2 " style="max-width: 132px">
                                <div class="form-group">
                                    <label for="" class="">&nbsp;</label>
                                    <span class="num-length">
                                        <button class="btn  button-1on1 show-all" type="button" data-dtp="dtp_JGtLk"
                                            tabindex="-1"><i class="fa fa-eye"> {{ __('messages.redisplay') }}</i></button>
                                    </span>
                                </div>
                                <!--/.form-group -->
                            </div>
                        </div>
                        <div class="row " id="target-content">
                            @include('WeeklyReport::rm0020.refer')
                        </div>
                        <div class="row justify-content-md-center">
                            {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" class="anti_tab">
    </div><!-- end .container-fluid -->
@stop
