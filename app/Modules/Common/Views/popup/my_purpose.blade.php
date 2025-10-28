@extends('popup')

@section('asset_header')
    <!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/purpose_popup.css')!!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/popup/my_purpose.js') !!}
@stop

@section('content')
    <div class="card-body">
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <span class="num-length">
                        <input type="text" id="mypurpose" class="form-control required" maxlength="20" tabindex="1" placeholder="{{ __('messages.my_purpose') }}" value="{{ $my_purpose['mypurpose'] ?? '' }}" />
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
        <div class="row mt-2">
            <div class="col-md-12">
                <div class="form-group">
                    <span class="num-length">
                        <textarea class="form-control" id="comment" maxlength="400" style="height: 120px;" placeholder="{{ __('messages.reasion_for_setting') }}" tabindex="2">{{ $my_purpose['comment'] ?? '' }}</textarea>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="row justify-content-md-center">
            <div class="col-md-5 col-lg-5 col-sm-12 col-xl-3 col-12 mt-3 button-1">
                <button id="btn-save" type="button"
                    class="btn button--action btn-block">{{ __('messages.save') }}</button>
            </div>
        </div>
    </div>
@stop
