@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/oq3010/q3010.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/oneonone/oq3010/q3010.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','backButton'])
!!}
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
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="date-fiscal-year col-sm-3 col-md-2 col-lg-2 col-xl-1 col-12 ">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                        <select id="fiscal_year" tabindex="1" class="form-control required fiscal_year" >
                            @for ($i = $today - 3; $i <= $today + 3 ; $i++) 
									<option value="{{$i}}" {{$i == $today ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year')) }}</option>
							@endfor
                        </select>
                    </div>
                </div>
                <input type="hidden" class="anti_tab" name="">
            </div> <!-- end .row -->
        </div>
        <div class="" id="result">
            @include('OneOnOne::oq3010.rightcontent')
        </div><!-- end .card -->
    </div>
</div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop