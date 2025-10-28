@extends('popup')

@push('header')
    {!! public_url('template/css/popup/em0030.index.css') !!}
@endpush

@section('asset_footer')
    {!! public_url('template/js/popup/em0030.index.js') !!}
@stop

@section('content')
    <div class="row">
        <input type="hidden" id="training_cd" value="">
        <input type="hidden" id="mode" value="{{$mode}}">
        <div class="col-md-2 col-lg-1 ln-1">
            <div class="form-group">
                <label class="control-label">{{ __('messages.sort_order') }}</label>
                <span class="num-length">
                    <input tabindex="2" type="text" id="arrange_order" class="form-control only-number" placeholder="" value="" maxlength="3">
                </span>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-8">					
            <div class="form-group">
                <label class="control-label">{{ __('messages.name') }}</label>
                <span class="num-length">
                    <input type="text" class="form-control required" tabindex="2" maxlength="50" id="training_nm" value="" />
                </span>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-2">
            <div class="full-width">
                <a id="btn-add-row" class="btn btn-outline-primary" tabindex="2">
                <i class="fa fa-pencil-square-o"></i>
                    {{ __('messages.register') }}
                </a>
            </div>
        </div>
    </div>
    <br>
    <div class="row" id="result">
        @include('EmployeeInfo::em0030.popup_em0030_search')    
    </div>
@stop
