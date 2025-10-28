@extends('popup')

@section('asset_header')
{!!public_url('template/css/popup/setting_meeting.css')!!}
@stop

@section('asset_footer')
{!!public_url('template/js/popup/popup_setting_meeting.index.js')!!}
@stop
@php
function datetimeEnglish($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'Scheduled Date';
    else
        return  $message;
}
function timeOfDayEnglish($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'Time';
    else
        return  $message;
}
@endphp
@section('content')
        <div class="row mt-30">
            <input type="hidden" id="fiscal_year" value="{{$fiscal_year}}">
            <input type="hidden" id="employee_cd" value="{{$employee_cd}}">
            <input type="hidden" id="times" value="{{$times}}">
            <input type="hidden" id="from" value="{{$from}}">
            <div class="col-md-12" style="padding-top: 10px">

                <div class="row">
                    <div class="col-md-12">
                        <label class="lb-required" lb-required="{{ __('messages.required') }}">
                            {{ __('messages.datetime') }}
                        </label>
                        <div class="input-group-btn input-group" style="width: 65%;min-width: 150px; max-width: 170px">
                            <input style="width:100%" type="text" class="form-control input-sm date right-radius required" id="oneonone_schedule_date" placeholder="yyyy/mm/dd" tabindex="99" {{$permission != 2?'disabled': ''}} value="{{$data['oneonone_schedule_date']??''}}">
                            <div class="input-group-append-btn">
                                <button style="padding: 10.8px;background:unset !important" class="btn btn-transparent" type="button" data-dtp="dtp_3tkYW" tabindex="-1" ><i class="fa fa-calendar"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <label class="lb-required" lb-required="{{ __('messages.required') }}">
                            {{ timeOfDayEnglish(__('messages.time_of_day')) }}
                        </label>
                        <div style="width: 65%;min-width: 150px; max-width: 170px">
                            <span class="num-length">
                                {{-- <input type="text" id="time" class="form-control required" maxlength="20"  value="{{$data['time']??''}}" tabindex="100" {{$permission != 2?'disabled': ''}}/> --}}
							    <input type="text" id="time" class="form-control required time" placeholder="hh:mm" maxlength="5"  value="{{$data['time']??''}}" tabindex="100" {{$permission != 2?'disabled': ''}}/>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <label class="" >
                            {{ __('messages.title') }}
                        </label>
                        <div class="" >
                            <span class="num-length">
                                <input type="text" id="title" class="form-control" maxlength="50"  value="{{$data['title']??''}}" tabindex="101" {{$permission != 2?'disabled': ''}}/>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <label class="" >
                            {{ __('messages.place') }}
                        </label>
                        <div class="" >
                            <span class="num-length">
                                <textarea type="text" id="place" class="form-control" maxlength="100" value="{{$data['place']??''}}" tabindex="102" {{$permission != 2?'disabled': ''}}>{{$data['place']??''}}</textarea>
                            </span>
                        </div>
                    </div>

                </div>
                <div class="row mt-3">
                    <div class="col-md-12">
                        <div class="" >
                            <div class="md-checkbox-v2">
                                <label for="send_message" class="container">{{ __('messages.notify_by_email') }}
                                    <input name="1" id="send_message" type="checkbox" class="required" value="0" tabindex="102" {{$permission != 2?'disabled': ''}}>
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row justify-content-md-center" {{$permission != 2?'hidden': ''}}>
                    <div class="col-md-5 col-lg-5 col-sm-12 col-xl-3 col-12 mt-3 button-1">
                        <button id="btn-save" type="button" class="btn button-1on1 btn-block">{{ __('messages.save') }}</button>
                    </div>
                    <div class="col-md-5 col-lg-5 col-sm-12 col-xl-3 col-12 mt-3 button-2">
                        <button id="btn-delete" type="button" class="btn button-1on1 btn-block btn-1on1-danger">{{ __('messages.delete') }}</button>
                    </div>

                </div>
            </div>
        </div>
@stop
<input type="hidden" class="anti_tab" name="">

