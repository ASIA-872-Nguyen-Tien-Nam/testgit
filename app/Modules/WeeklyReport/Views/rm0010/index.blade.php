@extends('weeklyreport/layout')
@section('asset_header')
{!! public_url('template/css/weeklyreport/rm0010/rm0010.index.css') !!}
@stop
@section('asset_footer')
<!-- START LIBRARY JS -->
{!! public_url('template/js/common/jquery.autonumeric.min.js') !!}
{!! public_url('template/js/weeklyreport/rm0010/rm0010.index.js') !!}
@stop
@push('asset_button')
{!! Helper::dropdownRenderWeeklyReport(['saveButton', 'backButton']) !!}
@endpush
@section('content')
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-12 col-xs-12" style="overflow: hidden">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group" style="margin-bottom:8px !important">
                                <div class="line-border-bottom">
                                    <label class="control-label">{{ __('rm0010.report_typ') }}</label>
                                </div>
                                <div class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="col-lg-3 col-xl-2 col-md-3 col-sm-6 col-12 col-md-auto first_block_row" style="padding: 0 10px;">
                                        <a href="javascript:;" id="annual_report_typ" value="{{ isset($data[0]['annualreport_user_typ']) ? $data[0]['annualreport_user_typ'] : '0' }}" class="btn btn-outline-brand-xl nw target_typ {{ isset($data[0]['annualreport_user_typ_class']) ? $data[0]['annualreport_user_typ_class'] : '' }}" style="" target_typ="1">
                                            {{ __('rm0010.annual_report') }}
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="first_annual_report_typ" value="{{ isset($data[0]['first_annual_report_typ']) ? $data[0]['first_annual_report_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{ isset($data[0]['annualreport_user_typ_class'])&&$data[0]['annualreport_user_typ_class']=='active' ? '' : '' }} disabled {{ isset($data[0]['first_annual_report_typ_class']) ? $data[0]['first_annual_report_typ_class'] : '' }}" target_typ="2">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_primary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="second_annual_report_typ" value="{{ isset($data[0]['second_annual_report_typ']) ? $data[0]['second_annual_report_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{ isset($data[0]['first_annual_report_typ_class'])&&$data[0]['first_annual_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['second_annual_report_typ_class']) ? $data[0]['second_annual_report_typ_class'] : '' }}" target_typ="3">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_secondary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="third_annual_report_typ" value="{{ isset($data[0]['third_annual_report_typ']) ? $data[0]['third_annual_report_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{ isset($data[0]['second_annual_report_typ_class'])&&$data[0]['second_annual_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['third_annual_report_typ_class']) ? $data[0]['third_annual_report_typ_class'] : '' }}" target_typ="4">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_third_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="fourth_annual_report_typ" value="{{ isset($data[0]['fourth_annual_report_typ']) ? $data[0]['fourth_annual_report_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{ isset($data[0]['third_annual_report_typ_class'])&&$data[0]['third_annual_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['fourth_annual_report_typ_class']) ? $data[0]['fourth_annual_report_typ_class'] : '' }}" target_typ="5">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_fourth_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                </div><!-- end .row -->

                                <div class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="col-lg-3 col-xl-2 col-md-3 col-sm-6 col-12 col-md-auto first_block_row" style="padding: 0 10px;">
                                        <a href="javascript:;" id="semi_annual_report_typ" value="{{ isset($data[0]['semi_annualreport_user_typ']) ? $data[0]['semi_annualreport_user_typ'] : '0' }}" class="btn btn-outline-brand-xl w175  {{ isset($data[0]['semi_annualreport_user_typ_class']) ? $data[0]['semi_annualreport_user_typ_class'] : '' }} evaluation_typ" evaluation_typ="1">
                                            {{ __('rm0010.semi_annual_report') }}
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="first_semi_annual_report_typ" value="{{ isset($data[0]['first_semi_annualreport_user_typ']) ? $data[0]['first_semi_annualreport_user_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['semi_annualreport_user_typ_class'])&&$data[0]['semi_annualreport_user_typ_class']=='active' ? '' : '' }} disabled {{ isset($data[0]['first_semi_annualreport_user_typ_class']) ? $data[0]['first_semi_annualreport_user_typ_class'] : '' }} evaluation_typ" evaluation_typ="2">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.semi_annual_report_primary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="second_semi_annual_report_typ" value="{{ isset($data[0]['second_semi_annualreport_user_typ']) ? $data[0]['second_semi_annualreport_user_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['first_semi_annualreport_user_typ_class'])&&$data[0]['first_semi_annualreport_user_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['second_semi_annualreport_user_typ_class']) ? $data[0]['second_semi_annualreport_user_typ_class'] : '' }} evaluation_typ" evaluation_typ="3">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.semi_annual_report_secondary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="third_semi_annual_report_typ" value="{{ isset($data[0]['third_semi_annualreport_user_typ']) ? $data[0]['third_semi_annualreport_user_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['second_semi_annualreport_user_typ_class'])&&$data[0]['second_semi_annualreport_user_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['third_semi_annualreport_user_typ_class']) ? $data[0]['third_semi_annualreport_user_typ_class'] : '' }} evaluation_typ" evaluation_typ="4">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.semi_annual_report_third_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="fourth_semi_annual_report_typ" value="{{ isset($data[0]['fourth_semi_annualreport_user_typ']) ? $data[0]['fourth_semi_annualreport_user_typ'] : '0' }}" class="qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['third_semi_annualreport_user_typ_class'])&&$data[0]['third_semi_annualreport_user_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['fourth_semi_annualreport_user_typ_class']) ? $data[0]['fourth_semi_annualreport_user_typ_class'] : '' }} evaluation_typ" evaluation_typ="5">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.semi_annual_report_fourth_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                </div><!-- end .row -->
                                <!-- 3 -->
                                <div class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="col-lg-3 col-xl-2 col-md-3 col-sm-6 col-12 col-md-auto first_block_row">
                                        <a href="javascript:;" id="quarterly_report_typ" class="quarterly_report_typ qq btn btn-outline-brand-xl w175 {{ isset($data[0]['quarterlyreport_user_typ_class']) ? $data[0]['quarterlyreport_user_typ_class'] : '0' }}" value="{{ isset($data[0]['quarterlyreport_user_typ']) ? $data[0]['quarterlyreport_user_typ'] : '0' }}" quarterly_report_typ="1">
                                            {{ __('rm0010.quarterly_report') }}
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="first_quarterly_report_typ" value="{{ isset($data[0]['first_quarterly_report_typ']) ? $data[0]['first_quarterly_report_typ'] : '0' }}" class="quarterly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['quarterlyreport_user_typ_class'])&&$data[0]['quarterlyreport_user_typ_class']=='active' ? '' : '' }} disabled {{ isset($data[0]['first_quarterly_report_typ_class']) ? $data[0]['first_quarterly_report_typ_class'] : '' }}" quarterly_report_typ="2">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.quarterly_report_primary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="second_quarterly_report_typ" value="{{ isset($data[0]['second_quarterly_report_typ']) ? $data[0]['second_quarterly_report_typ'] : '0' }}" class="quarterly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['first_quarterly_report_typ_class'])&&$data[0]['first_quarterly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['second_quarterly_report_typ_class']) ? $data[0]['second_quarterly_report_typ_class'] : '' }}" quarterly_report_typ="3">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.quarterly_report_secondary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="third_quarterly_report_typ" value="{{ isset($data[0]['third_quarterly_report_typ']) ? $data[0]['third_quarterly_report_typ'] : '0' }}" class="quarterly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['second_quarterly_report_typ_class'])&&$data[0]['second_quarterly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['third_quarterly_report_typ_class']) ? $data[0]['third_quarterly_report_typ_class'] : '' }}" quarterly_report_typ="4">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.quarterly_report_third_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="fourth_quarterly_report_typ" value="{{ isset($data[0]['fourth_quarterly_report_typ']) ? $data[0]['fourth_quarterly_report_typ'] : '0' }}" class="quarterly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['third_quarterly_report_typ_class'])&&$data[0]['third_quarterly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['fourth_quarterly_report_typ_class']) ? $data[0]['fourth_quarterly_report_typ_class'] : '' }}" quarterly_report_typ="5">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.quarterly_report_fourth_approval') }}
                                        </a>
                                    </div>
                                </div><!-- end .row -->
                                <div class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="col-lg-3 col-xl-2 col-md-3 col-sm-6 col-12 col-md-auto first_block_row" style="padding: 0 10px;">
                                        <a href="javascript:;" id="monthly_report_typ" value="{{ isset($data[0]['monthly_report_typ']) ? $data[0]['monthly_report_typ'] : '0' }}" class="monthly_report_typ btn btn-outline-brand-xl nw {{ isset($data[0]['monthly_report_typ_class']) ? $data[0]['monthly_report_typ_class'] : '' }}" style="" monthly_report_typ="1">
                                            {{ __('rm0010.monthly_report') }}
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="first_monthly_report_typ" value="{{ isset($data[0]['first_monthly_report_typ']) ? $data[0]['first_monthly_report_typ'] : '0' }}" class="monthly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['monthly_report_typ_class'])&&$data[0]['monthly_report_typ_class']=='active' ? '' : '' }} disabled {{ isset($data[0]['first_monthly_report_typ_class']) ? $data[0]['first_monthly_report_typ_class'] : '' }}" monthly_report_typ="2">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_primary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="second_monthly_report_typ" value="{{ isset($data[0]['second_monthly_report_typ']) ? $data[0]['second_monthly_report_typ'] : '0' }}" class="monthly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['first_monthly_report_typ_class'])&&$data[0]['first_monthly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['second_monthly_report_typ_class']) ? $data[0]['second_monthly_report_typ_class'] : '' }}" monthly_report_typ="3">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_secondary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="third_monthly_report_typ" value="{{ isset($data[0]['third_monthly_report_typ']) ? $data[0]['third_monthly_report_typ'] : '0' }}" class="monthly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['second_monthly_report_typ_class'])&&$data[0]['second_monthly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['third_monthly_report_typ_class']) ? $data[0]['third_monthly_report_typ_class'] : '' }}" monthly_report_typ="4">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_third_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="fourth_monthly_report_typ" value="{{ isset($data[0]['fourth_monthly_report_typ']) ? $data[0]['fourth_monthly_report_typ'] : '0' }}" class="monthly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['third_monthly_report_typ_class'])&&$data[0]['third_monthly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['fourth_monthly_report_typ_class']) ? $data[0]['fourth_monthly_report_typ_class'] : '' }}" monthly_report_typ="5">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.annual_report_fourth_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="pl-2 row_range_date">
                                        <div class="col-md-auto2 small_block pb-2" style="display: flex;min-width: 210px; padding:0px">
                                            <div>
                                                <p class="pr-2" style="margin-bottom: 0rem;margin-top:8px">
                                                    {{ __('rm0010.monthly_deadline') }}
                                                </p>
                                            </div>
                                            <div style="width:135px">
                                                <select style="width: 100%;" class="form-control required" id="monthlyreport_deadline" tabindex="1" autofocus>
                                                    @if (isset($date[0]))
                                                    @if ($date[0] != '')
                                                    @foreach ($date as $date)
                                                    <option value="{{ isset($date['number_cd']) ? $date['number_cd'] : '0' }}" {{isset($data[0]['monthlyreport_deadline'])&&isset($date['number_cd'])&&$data[0]['monthlyreport_deadline'] == $date['number_cd'] ? 'selected' : ''}}>{{ $date['name'] }}</option>
                                                    @endforeach
                                                    @endif
                                                    @endif
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div><!-- end .row -->
                                <div class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="col-lg-3 col-xl-2 col-md-3 col-sm-6 col-12 col-md-auto first_block_row" style="padding: 0 10px;">
                                        <a href="javascript:;" id="weekly_report_typ" value="{{ isset($data[0]['weekly_report_typ']) ? $data[0]['weekly_report_typ'] : '0' }}" class="weekly_report_typ btn btn-outline-brand-xl nw {{ isset($data[0]['weekly_report_typ_class']) ? $data[0]['weekly_report_typ_class'] : '' }}" style="" weekly_report_typ="1">
                                            {{ __('rm0010.weekly_report') }}
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="first_weekly_report_typ" value="{{ isset($data[0]['first_weekly_report_typ']) ? $data[0]['first_weekly_report_typ'] : '0' }}" class="weekly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['weekly_report_typ_class'])&&$data[0]['weekly_report_typ_class']=='active' ? '' : '' }} disabled {{ isset($data[0]['first_weekly_report_typ_class']) ? $data[0]['first_weekly_report_typ_class'] : '' }}" weekly_report_typ="2">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.weekly_report_primary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="second_weekly_report_typ" value="{{ isset($data[0]['second_weekly_report_typ']) ? $data[0]['second_weekly_report_typ'] : '0' }}" class="weekly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['first_weekly_report_typ_class'])&&$data[0]['first_weekly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['second_weekly_report_typ_class']) ? $data[0]['second_weekly_report_typ_class'] : '' }}" weekly_report_typ="3">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.weekly_report_secondary_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="third_weekly_report_typ" value="{{ isset($data[0]['third_weekly_report_typ']) ? $data[0]['third_weekly_report_typ'] : '0' }}" class="weekly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['second_weekly_report_typ_class'])&&$data[0]['second_weekly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['third_weekly_report_typ_class']) ? $data[0]['third_weekly_report_typ_class'] : '' }}" weekly_report_typ="4">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.weekly_report_third_approval') }}
                                        </a>
                                    </div><!-- end .col-md-2 -->
                                    <div class="col-md-auto2 small_block">
                                        <a href="javascript:;" id="fourth_weekly_report_typ" value="{{ isset($data[0]['fourth_weekly_report_typ']) ? $data[0]['fourth_weekly_report_typ'] : '0' }}" class="weekly_report_typ qq btn btn-outline-brand-x btn-block text-left {{ isset($data[0]['third_weekly_report_typ_class'])&&$data[0]['third_weekly_report_typ_class']=='active' ? '' : 'disabled' }} {{ isset($data[0]['fourth_weekly_report_typ_class']) ? $data[0]['fourth_weekly_report_typ_class'] : '' }}" weekly_report_typ="5">
                                            <i class="fa fa-check"></i>
                                            {{ __('rm0010.weekly_report_fourth_approval') }}
                                        </a>
                                    </div>
                                    <div class="pl-2 row_range_date">
                                        <div class="col-md-auto2 small_block pb-2" style="display: flex;min-width: {{ isset($lang)&&$lang=='en' ? '210px' : '190px' }}; padding:0px">
                                            <div>
                                                <p class="pr-2" style="margin-bottom: 0rem;margin-top:8px">
                                                    {{ __('rm0010.start_date') }}
                                                </p>
                                            </div>
                                            <div style="width: 135px">
                                                <select style="width: 100%;" class="form-control required" id="weeklyreport_deadline" tabindex="2" value="{{ isset($data[0]['weeklyreport_deadline']) ? $data[0]['weeklyreport_deadline'] : '0' }}">
                                                    @if (isset($days[0]))
                                                    @if ($days[0] != '')
                                                    @foreach ($days as $day)
                                                    <option value="{{ isset($day['number_cd']) ? $day['number_cd'] : '0' }}" {{isset($data[0]['weeklyreport_deadline']) && $data[0]['weeklyreport_deadline'] == $day['number_cd'] ? 'selected' : ''}}>{{ $day['name'] }}</option>
                                                    @endforeach
                                                    @endif
                                                    @endif
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-auto2 small_block pb-2" style="display: flex;min-width: 250px; padding:0px">
                                            <div>
                                                @if(isset($lang))
                                                @if($lang == 'en')
                                                <p class="pr-2" style="min-width: 115px;margin-bottom: 0rem;margin-top:8px">
                                                    {{ __('rm0010.end_date') }}
                                                </p>
                                                @else
                                                <p class="pr-2" style="min-width: 80px;margin-bottom: 0rem;margin-top:8px">
                                                    {{ __('rm0010.end_date') }}
                                                </p>
                                                @endif
                                                @endif
                                            </div>
                                            <div style="width: 135px">
                                                <select style="width: 100%;" class="form-control required" id="weeklyreport_judgment_date" tabindex="3" value="{{ isset($data[0]['weeklyreport_judgment_date']) ? $data[0]['weeklyreport_judgment_date'] : '0' }}">
                                                    @if (isset($days_end[0]))
                                                    @if ($days_end[0] != '')
                                                    @foreach ($days_end as $day)
                                                    <option value="{{ isset($day['number_cd']) ? $day['number_cd'] : '0' }}" {{isset($data[0]['weeklyreport_judgment_date'])&&$data[0]['weeklyreport_judgment_date'] == $day['number_cd'] ? 'selected' : ''}}>{{ $day['name'] }}</option>
                                                    @endforeach
                                                    @endif
                                                    @endif
                                                </select>
                                            </div>
                                        </div>

                                    </div>

                                </div><!-- end .row -->
                                <div class="form-group block_bottom">
                                    <div class="line-border-bottom">
                                        <label class="control-label">{{ __('rm0010.comment_opt') }}</label>
                                    </div>
                                    <div class="row pb-2" style="display: flex;height: 30px; margin-bottom:12px">
                                        <div class=" col-sm-6 col-md-6 col-lg-4 col-xl-8 pb-2">
                                            <div style="width: 135px">
                                                <select style="width: 100%;" class="form-control required" id="comment_option_use_typ" tabindex="3" value="{{ isset($data[0]['weeklyreport_judgment_date']) ? $data[0]['weeklyreport_judgment_date'] : '0' }}">
                                                    <option value="0" {{isset($data[0]['comment_option_use_typ'])&&$data[0]['comment_option_use_typ'] == '0' ? 'selected' : ''}}>{{ __('messages.not_use') }}</option>
                                                    <option value="1" {{isset($data[0]['comment_option_use_typ'])&&$data[0]['comment_option_use_typ'] == '1' ? 'selected' : ''}}>{{ __('messages.use') }}</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-6 col-md-6 col-lg-6 col-xl-8 row" style="padding-left:20px;padding-right:20px">
                                        <div class="col-sm-4 col-md-6 col-lg-5 col-xl-2" style="padding-left:0px;min-width:135px">
                                            <p class="pr-2" style="margin-bottom: 0rem;margin-top:8px">
                                                {{ __('rm0010.avai_user') }}
                                            </p>
</div>
                                            <div class="col-sm-4 col-md-6 col-lg-3 col-xl-2">
                                                <div id="bor_authority" class="checkbox-wrapper md-checkbox-v2 inline-block bor_authority " style="margin-right: 10px;">
                                                    <label class="container  label_ckb {{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? 'label_disabled' : '' }}" style="padding-right:0px" for="approver">{{ __('rm0010.approver') }}
                                                        <input type="checkbox" name="ck1" id="approver" value="{{ isset($data[0]['comment_option_authorizer_use_typ']) ? $data[0]['comment_option_authorizer_use_typ'] : '0' }}" {{isset($data[0]['comment_option_authorizer_use_typ']) && $data[0]['comment_option_authorizer_use_typ'] == 1 ? 'checked' : ''}} {{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? 'disabled' : '0' }}  />
                                                        <span for="approver" tabindex="{{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? '-1' : '3' }}" id="approver_span" class="checkmark" style="top: 0px !important;left: 0px !important;"></span>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-sm-4 col-md-6 col-lg-3 col-xl-2">
                                                <div id="bor_authority" class="checkbox-wrapper md-checkbox-v2 inline-block bor_authority " style="margin-right: 10px;">
                                                    <label class="container label_ckb {{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? 'label_disabled' : '' }}" style="padding-right:0px" for="viewer">{{ __('rm0010.viewer') }}
                                                        <input type="checkbox" name="ck2" id="viewer" value="{{ isset($data[0]['comment_option_viewer_use_typ']) ? $data[0]['comment_option_viewer_use_typ'] : '0' }}" {{isset($data[0]['comment_option_viewer_use_typ']) && $data[0]['comment_option_viewer_use_typ'] == 1 ? 'checked' : ''}} {{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? 'disabled' : '' }} />
                                                        <span class="checkmark" for="viewer" id="viewer_span" tabindex="{{ isset($data[0]['comment_option_use_typ']) && $data[0]['comment_option_use_typ'] == 0 ? '-1' : '3' }}"  style="top: 0px !important;left: 0px !important;"></span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group block_bottom">
                                        <div class="line-border-bottom">
                                            <label class="control-label">{{ __('rm0010.report_sharing') }}</label>
                                        </div>
                                        <div class="row row_custom">
                                            <div class="col-sm-6 col-md-6 col-lg-4 col-xl-3">
                                                <div>
                                                    <div id="bor_authority" class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
                                                        <label class="container" style="padding-right:0px" for="viewer_sharing">{{ __('rm0010.reader') }}
                                                            <input type="checkbox" name="ck1" id="viewer_sharing" value="{{ isset($data[0]['viewer_sharing']) ? $data[0]['viewer_sharing'] : '0' }}" {{isset($data[0]['viewer_sharing']) && $data[0]['viewer_sharing'] == 1 ? 'checked' : ''}} />
                                                            <span for="viewer_sharing" class="checkmark" style="top: 0px !important;left: 0px !important;" tabindex="7" ></span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-6 col-md-6 col-lg-4 col-xl-3">
                                                <div>
                                                    <div id="bor_authority" class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
                                                        <label class="container" style="padding-right:0px" for="share_notify_reporter">{{ __('rm0010.notify_reporter_of_sharing') }}
                                                            <input type="checkbox" name="ck2" id="share_notify_reporter" value="{{ isset($data[0]['share_notify_reporter']) ? $data[0]['share_notify_reporter'] : '0' }}" {{isset($data[0]['share_notify_reporter']) && $data[0]['share_notify_reporter'] == 1 ? 'checked' : ''}} />
                                                            <span class="checkmark" for="share_notify_reporter" style="top: 0px !important;left: 0px !important;" tabindex="7" ></span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="line-border-bottom">
                                            <label class="control-label">{{ __('rm0010.sticky_note') }}</label>
                                        </div>

                                        <div class="" style="min-height:20vh">
                                            <div id="row_sticky_2" class="row" style="margin-bottom: 20px;">
                                                <div class="mr-4 label_row_sticky" style="min-width: 200px;display: flex;align-items: center;">
                                                    <p class="">
                                                        @if(isset($label_stickies[0]))
                                                    <p>{{ $label_stickies[0]['name'] }}</p>
                                                    @endif
                                                    </p>
                                                </div>
                                                <div class="col-lg-2 mr-2 sticky_2 sticky_2_div_1 col-md-2 col-sm-6 col-12 sticky_readonly col-md-auto btn-outline-brand-xl unactive" style="display: flex; min-height: 52px; padding: 7px; background:{{ $result_original[0]['color_value'] ?? 'rgb(129, 199, 132)'}};">
                                                    @if($mode == 0)
                                                    <input class="detail_no" value="" type="hidden" hidden />
                                                    @else
                                                    <input class="detail_no" value="1" type="hidden" hidden />
                                                    @endif
                                                    <div class="dropdown" style="padding-top: 6px;">
                                                        <i class="fa fa-ellipsis-h mr-2" aria-hidden="true" id="option_icon2_1" style="display:none;font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
                                                        <div class="dropdown-menu" id="color" aria-labelledby="dropdownMenuButton">
                                                            @if (isset($stickies_color[0]))
                                                            @if ($stickies_color[0] != '')
                                                            @foreach ($stickies_color as $color)
                                                            <a value_color="{{$color['number_cd']}}" class="dropdown-item dropdown-item_1" style="height: 32px;background: {{$color['name']}}" value="{{$color['name']}}"></a>
                                                            @endforeach
                                                            @endif
                                                            @endif
                                                            <input class="note_color" hidden value="{{ $result_original[0]['note_color'] ?? 5 }}" />
                                                        </div>
                                                    </div>
                                                    <div cols="30" id="sticky_2_div_text_1" class="label_stick">
                                                        @if($mode == 0)
                                                        <p style="color:black;" id="label_text2_1">{{__('messages.sticky_green')}}</p>
                                                        <input class="note_name" hidden value="{{__('messages.sticky_green')}}" />
                                                        <input class="note_color" hidden value="5" />
                                                        @else
                                                        <p style="color:black;" id="label_text2_1">{{ $sticky_default[0]['note_name'] }}</p>
                                                        <input class="note_name" hidden value="{{ $sticky_default[0]['note_name'] }}" />
                                                        <input class="note_color" hidden value="5" />
                                                        @endif

                                                    </div>

                                                </div>

                                                <div class="col-lg-2 mr-2 sticky_2 sticky_2_div_2 col-md-2 col-sm-6 col-12 sticky_readonly col-md-auto btn-outline-brand-xl unactive" style="display:flex;min-height: 52px;  padding:7px; background:{{ $result_original[1]['color_value'] ?? '#FFF176'}}">
                                                    @if($mode == 0)
                                                    <input class="detail_no" value="" type="hidden" hidden />
                                                    @else
                                                    <input class="detail_no" value="2" type="hidden" hidden />
                                                    @endif
                                                    <div class="dropdown" style="padding-top: 6px;">
                                                        <i class="fa fa-ellipsis-h mr-2" aria-hidden="true" id="option_icon2_2" style="display:none;font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
                                                        <div class="dropdown-menu" id="color" aria-labelledby="dropdownMenuButton">
                                                            @if (isset($stickies_color[0]))
                                                            @if ($stickies_color[0] != '')
                                                            @foreach ($stickies_color as $color)
                                                            <a value_color="{{$color['number_cd']}}" class="dropdown-item dropdown-item_2" style="height: 32px;background: {{$color['name']}}" value="{{$color['name']}}"></a>
                                                            @endforeach
                                                            @endif
                                                            @endif
                                                            <input class="note_color" hidden value="{{ $result_original[1]['note_color'] ?? 2 }}" />
                                                        </div>
                                                    </div>
                                                    <div cols="30" id="sticky_2_div_text_2" class="label_stick">
                                                        @if($mode == 0)
                                                        <p style="color:black;" id="label_text2_2">{{__('messages.sticky_yellow')}}</p>
                                                        <input class="note_name" hidden value="{{__('messages.sticky_yellow')}}" />
                                                        <input class="note_color" hidden value="2" />
                                                        @else
                                                        <p style="color:black;" id="label_text2_2">{{ $sticky_default[1]['note_name'] }}</p>
                                                        <input class="note_name" hidden value="{{ $sticky_default[1]['note_name'] }}" />

                                                        @endif

                                                    </div>

                                                </div>

                                                <div class="col-lg-2 mr-2 sticky_2 sticky_2_div_3 col-md-2 col-sm-6 col-12 sticky_readonly col-md-auto btn-outline-brand-xl unactive" style="display:flex;min-height: 52px;  padding:7px; background:{{ $result_original[2]['color_value'] ?? '#E57373'}}">
                                                    @if($mode == 0)
                                                    <input class="detail_no" value="" type="hidden" hidden />
                                                    @else
                                                    <input class="detail_no" value="3" type="hidden" hidden />
                                                    @endif
                                                    <div class="dropdown" style="padding-top: 6px;">
                                                        <i class="fa fa-ellipsis-h mr-2" aria-hidden="true" id="option_icon2_3" style="display:none;font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
                                                        <div class="dropdown-menu" id="color" aria-labelledby="dropdownMenuButton">
                                                            @if (isset($stickies_color[0]))
                                                            @if ($stickies_color[0] != '')
                                                            @foreach ($stickies_color as $color)
                                                            <a value_color="{{$color['number_cd']}}" class="dropdown-item dropdown-item_3" style="height: 32px;background: {{$color['name']}}" value="{{$color['name']}}"></a>
                                                            @endforeach
                                                            @endif
                                                            @endif
                                                            <input class="note_color" hidden value="{{ $result_original[2]['note_color'] ?? 1}}" />
                                                        </div>
                                                    </div>
                                                    <div cols="30" id="sticky_2_div_text_3" class="label_stick">
                                                        @if($mode == 0)
                                                        <p style="color:black;" id="label_text2_3">{{__('messages.sticky_red')}}</p>
                                                        <input class="note_name" hidden value="{{__('messages.sticky_red')}}" />
                                                        <input class="note_color" hidden value="1" />
                                                        @else
                                                        <p style="color:black;" id="label_text2_3">{{ $sticky_default[2]['note_name'] }}</p>
                                                        <input class="note_name" hidden value="{{ $sticky_default[2]['note_name'] }}" />
                                                        @endif

                                                    </div>


                                                </div>
                                                @if (isset($stickies_approver[0]))
                                                @if ($stickies_approver[0] != '')
                                                @foreach ($stickies_approver as $sticky)
                                                @if ($sticky['id'] != '0')
                                                <div class="col-lg-2 mr-2 col-md-2 col-sm-6 col-12 sticky_2_div_{{ $sticky['id'] }} sticky_2 col-md-auto btn-outline-brand-xl unactive" style="display:flex;min-height: 52px;  padding:7px; background:{{ $sticky['color_value'] }}">
                                                    <input class="detail_no" value="{{ $sticky['detail_no'] }}" type="hidden" hidden />
                                                    <div class="dropdown" style="padding-top: 6px;">
                                                        <i class="fa fa-ellipsis-h mr-2" aria-hidden="true" id="option_icon2_{{ $sticky['id'] }}" style="display:none;font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
                                                        <div class="dropdown-menu" id="color" aria-labelledby="dropdownMenuButton">
                                                            @if (isset($stickies_color[0]))
                                                            @if ($stickies_color[0] != '')
                                                            @foreach ($stickies_color as $color)
                                                            <a value_color="{{$color['number_cd']}}" class="dropdown-item dropdown-item_{{ $sticky['id'] }}" style="height: 32px;background: {{$color['name']}}" value="{{$color['name']}}"></a>
                                                            @endforeach
                                                            @endif
                                                            @endif
                                                            <input class="note_color" hidden value="{{ $sticky['note_color'] }}" />
                                                        </div>
                                                    </div>
                                                    <div cols="30" id="sticky_2_div_text_{{ $sticky['id'] }}" class="label_stick">
                                                        <p style="color:black" id="label_text2_{{ $sticky['id'] }}">{{ $sticky['note_name'] }}</p>
                                                        <input class="note_name" hidden value="{{ $sticky['note_name'] }}" />
                                                    </div>
                                                    <input id="color_selected" value="{{ $sticky['color_value'] }}" type="hidden">
                                                    <i class="fa fa-close" number="{{ $sticky['id'] }}" id="close_icon2_{{ $sticky['id'] }}" aria-hidden="true"></i>
                                                </div>
                                                @endif
                                                @endforeach
                                                @endif
                                                @endif
                                                @if (!isset($stickies_approver[1]))
                                                <button class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                                                @endif
                                            </div>
                                            {{-- <div class="row border-bottom mb-3">
                                        <div class="radio pl-3" id="mark_typ" style="display: flex;width:100%">
                                            <div class="inline-block" style="width:10%">
                                                <p class="">{{ __('rm0010.viewing_range') }}</p>
                                        </div>
                                        <div class="inline-block" style="width:90%">
                                            <div class="md-radio-v2 inline-block pl-1">
                                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY0" value="weather_" maxlength="3" tabindex="9">
                                                <label for="YY0">{{ __('rm0010.all_allowed') }}</label>
                                            </div>
                                            <div class="md-radio-v2 inline-block pl-2">
                                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY1" value="face_" maxlength="3" tabindex="10">
                                                <label for="YY1">{{ __('rm0010.only_person') }}</label>
                                            </div>
                                            <div class="md-radio-v2 inline-block pl-2">
                                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY4" value="letter_" maxlength="3" tabindex="11">
                                                <label for="YY4">{{ __('rm0010.only_admin') }}</label>
                                            </div>
                                            <div class="md-radio-v2 inline-block pl-2">
                                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY3" value="letter_" maxlength="3" tabindex="12">
                                                <label for="YY3">{{ __('rm0010.higher_person') }}</label>
                                            </div>
                                        </div>
                                    </div>
                                </div> --}}
                                <div id="row_sticky" class="row border-bottom" style="margin-bottom: 20px;">
                                    <div class="mr-4 label_row_sticky" style="min-width: 200px;display: flex;align-items: center; padding-left:15px">
                                        @if(isset($label_stickies[1]))
                                        <p>{{ $label_stickies[1]['name'] }}</p>
                                        @endif
                                    </div>
                                    @if (isset($stickies_reporter[0]))
                                    @if ($stickies_reporter[0] != '')
                                    @foreach ($stickies_reporter as $sticky)
                                    @if ($sticky['id'] != '0')
                                    <div class="col-lg-2 mr-2 col-md-2 col-sm-6 col-12 sticky_div_{{ $sticky['id'] }} sticky col-md-auto btn-outline-brand-xl unactive" style="display:flex;min-height: 52px;  padding:7px; background:{{ $sticky['color_value'] }}">
                                        <input class="detail_no" value="{{ $sticky['detail_no'] }}" type="hidden" hidden />
                                        <div class="dropdown" style="padding-top: 6px;">
                                            <i class="fa fa-ellipsis-h mr-2" aria-hidden="true" id="option_icon_{{ $sticky['id'] }}" style="display:none;font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i>
                                            <div class="dropdown-menu" id="color" aria-labelledby="dropdownMenuButton">
                                                @if (isset($stickies_color[0]))
                                                @if ($stickies_color[0] != '')
                                                @foreach ($stickies_color as $color)
                                                <a value_color="{{$color['number_cd']}}" class="dropdown-item dropdown-item_{{ $sticky['id'] }}" style="height: 32px;background: {{$color['name']}}" value="{{$color['name']}}"></a>
                                                @endforeach
                                                @endif
                                                @endif
                                                <input class="note_color" hidden value="{{ $sticky['note_color'] }}" />
                                            </div>
                                        </div>
                                        <div cols="30" id="sticky_div_text_{{ $sticky['id'] }}" class="label_stick">
                                            <p style="color:black" id="label_text_{{ $sticky['id'] }}">{{ $sticky['note_name'] }}</p>
                                            <input class="note_name" hidden value="{{ $sticky['note_name'] }}" />
                                        </div>
                                        <input id="color_selected" value="{{ $sticky['color_value'] }}" type="hidden">
                                        <i class="fa fa-close" number="{{ $sticky['id'] }}" id="close_icon_{{ $sticky['id'] }}" aria-hidden="true"></i>
                                    </div>
                                    @endif
                                    @endforeach
                                    @endif

                                    @endif
                                    @if (!isset($stickies_reporter[4]))
                                    <button class=" btn btn-rm blue btn-lg col-md-auto border border-primary" style="" id="btn_add_sticky">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                    @endif
                                </div>
                            </div><!-- end .table-responsive -->

                            <div class="line-border-bottom">
                                <label class="control-label">
                                    {{ __('rm0010.view_weekly_report_of_past_approver') }}
                                </label>
                            </div>
                            <div class="row" style="display: flex;height: 60px;">
                                <div class="col-12">
                                    <div>
                                        <div id="weeklyreport_view" class="md-checkbox-v2 inline-block weeklyreport_view" style="margin-right: 10px;">
                                            <label class="container" style="padding-right:0px;" for="viewable_deadline_kbn">{{ __('rm0010.view_weekly_report_of_past_approver_chk') }}
                                                <input type="checkbox" name="viewable_deadline_kbn" id="viewable_deadline_kbn" value="{{ isset($data[0]['viewable_deadline_kbn']) ? $data[0]['viewable_deadline_kbn'] : '0' }}" {{isset($data[0]['viewable_deadline_kbn']) && $data[0]['viewable_deadline_kbn'] == 1 ? 'checked' : ''}}  />
                                                <span for="viewable_deadline_kbn" class="checkmark" style="top: 0px !important;left: 0px !important;" tabindex="7" ></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div><!-- end .card-body -->
        <div class="row justify-content-md-center">
            {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
        </div>
    </div><!-- end .card -->
</div><!-- end .container-fluid -->
@foreach($stickies_color as $value_color)
<div id="color_value_{{$value_color['number_cd']}}" hidden value="{{$value_color['name']}}"></div>
@endforeach
@section('asset_common')
<table class="hidden" id="table-target-1">
    <tbody>
        <tr>
            <td class="text-center">
                <span class="num-length">
                    <input type="hidden" class="detail_no">
                    <input type="text" class="form-control input-sm period_nm" maxlength="50" tabindex="3">
                </span>
            </td>
            <td class="text-center">
                <div class="gflex">
                    <div class="input-group-btn input-group" style="width: 120px">
                        <input type="text" class="form-control text-center  mmdd mmdd_from" placeholder="mm/dd" tabindex="3">
                        <input type="hidden" class="yyyymmdd period_from_full">
                    </div>
                </div><!-- end .gflex -->
            </td>
            <td class="text-center">
                <div class="gflex">
                    <div class="input-group-btn input-group" style="width: 120px">
                        <input type="text" class="form-control text-center  mmdd mmdd_to" placeholder="mm/dd" tabindex="3">
                        <input type="hidden" class="yyyymmdd period_to_full">
                    </div>
                </div><!-- end .gflex -->
            </td>
            <td class="text-center">
                <button class="btn btn-rm btn-sm btn-remove-row" tabindex="3">
                    <i class="fa fa-remove"></i>
                </button>
            </td>
        </tr>
    </tbody>
</table><!-- /.hidden -->
@stop
@stop