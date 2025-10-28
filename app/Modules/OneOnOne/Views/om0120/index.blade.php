@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/om0120/om0120.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->name
{!!public_url('template/js/oneonone/om0120/om0120.index.js')!!}
@stop
@push('asset_button')
    {!!
        Helper::dropdownRender1on1(['saveButton','deleteButton','backButton'])
    !!}
@endpush
@section('content')
<!-- START CONTENT -->
@php
	function cutText($mes) {
	if( \Session::get('website_language', config('app.locale')) != 'en')
		return  $mes;
    else
        return '';
	}
@endphp
<div class="container-fluid">
    <div class="card pe-w">
        <div class="card-body" >
            <div >
                <div class="row" style="margin-left : -10px">
                    <div class="col-md-4 col-lg-3 col-xl-3">
                        <div class="form-group">
                            <div>
                                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.name') }}</label>
                                @if (empty($data_header))
                                    <span style="color: blue">{{ __('messages.unregistered') }}</span>
                                @endif
                            </div>
                            <span class="num-length">
                            <input type="text" id="name" class="form-control required" placeholder="" maxlength="10" value="{{$data_header['name']??cutText(__('messages.adequacy'))}}" tabindex="1">
                            </span>
                        </div>
                    </div>
                    <div class="col-lg-9 col-xl-9">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.mark_type') }}&nbsp;
                            </label>
                            <div class="radio" id="mark_typ">
                                @if (isset($data_radio[0]) && !empty($data_radio[0]))
                                    @foreach($data_radio as $key=>$item)
                                        <div class="md-radio-v2 inline-block">
                                            <input name="mark_typ1" type="radio" class="mark_typ" id="YY{{$key}}" {{$item['number_cd']==($mark_type??1)?'checked':''}}
                                                value="{{$item['number_cd']}}"  maxlength="3" tabindex="2" >
                                            <label for="YY{{$key}}">{{$item['name']}}</label>
                                        </div>
                                    @endforeach
                                @endif
                            </div>
                        </div><!--/.form-group -->
                    </div>
                </div><!-- end .col-md-12 -->
                <div class="row" id="body-inner">
                    @include('OneOnOne::om0120.refer')
                </div>
            </div>
            <div class="row justify-content-md-center">
                {!!
                    Helper::buttonRender1on1(['saveButton'])
                !!}
            </div>
        </div>

    </div>
    <input type="hidden" class="anti_tab">
</div>
@stop