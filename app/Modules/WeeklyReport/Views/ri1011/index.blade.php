@extends('weeklyreport/layout')

@section('asset_header')
    {!! public_url('template/css/weeklyreport/ri1011/ri1011.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/weeklyreport/ri1011/ri1011.index.js') !!}
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
                    <div class="col-xl-3 col-lg-4 col-md-6">
                        <div class="form-group">
                            <select name="" id="mail_kbn" class="form-control required" tabindex="1">
                                <option value="1">{{ __('ri1011.remind') }}</option>
                                <option value="2">{{ __('ri1011.alert') }}</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row mt-10">
                    <div class="col-md-6 col-xl-3 col-lg-3 col-12 col-sm-6 chechbox-width">
                        <div class="md-checkbox-v2">
                            <label for="information" class="container">{{ __('ri1011.notify_by_information') }}
                                <input name="information" type="checkbox" checked id="information" class="" 
                                    tabindex="2">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                    </div>
                    <div class="col-md-6 col-xl-3 col-lg-3 col-12 col-sm-6">
                        <div class="md-checkbox-v2">
                            <label for="mail" class="container">{{ __('ri1011.notify_by_email') }}
                                <input name="mail" type="checkbox" checked id="mail" class="" 
                                    tabindex="3">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="row mt-10">
                    <div class="col-xl-8 col-lg-10 col-md-10">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.title') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn">
                                    <input type="text" id="title" class="form-control required" placeholder=""
                                        value="" maxlength="50" tabindex="4">
                                </div>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="row mt-10">
                    <div class="col-xl-8 col-lg-10 col-md-10">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.message') }}</label>
                            <div class="input-group-btn">
                                <span class="num-length mess_len">
                                    <textarea class="form-control required" id="message" rows="4" placeholder="
								" maxlength="200"
                                        tabindex="5"></textarea>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-3 col-lg-4 col-md-4 ln-md-5">
                        <label class="control-label lb-required"
                            lb-required="{{ __('messages.required') }}">{{ __('messages.sending_target') }}</label>
                        <div class="form-group">
                            <select name="" id="sending_target" class="form-control required" tabindex="6">
                                <option value="-1"></option>
                                <option value="1">{{ __('ri1011.everyone') }}</option>
                                <option value="2">{{ __('ri1011.approver_only') }}</option>
                                <option value="3">{{ __('ri1011.reporter_only') }}</option>
                                <option value="4">{{ __('ri1011.untested_person') }}</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-3 ln-xl-3 ln-md-3">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.sending_date') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn">
                                    <input type="text" id="send_date" class="form-control required only-number"
                                        placeholder="" value="" maxlength="2" tabindex="7">
                                </div>
                            </span>
                        </div>
                    </div>

                    <div class="col-xl-2 col-lg-3 col-md-3 ln-xl-2 ln-md-4">
                        <div class="form-group lh-custom">
                            <label for="">&nbsp;</label>
                            <select name="" id="send_kbn" class="form-control required" tabindex="7" disabled>
                                <option value="1">{{ __('messages.days_before_1') }}</option>
                                <option value="2">{{ __('messages.days_after_1') }}</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row justify-content-md-center">
                    {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
                </div>
            </div>

            <br />
        </div><!-- end .card -->
    </div><!-- end .container-fluid -->
@stop
