@extends('popup')

@section('asset_header')
    <!-- START LIBRARY CSS -->

@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/popup/reject.js') !!}
@stop

@section('content')
    <div class="card-body">
        <div class="row mt-2">
            <div class="col-md-12">
                <div class="form-group">
                    <span class="num-length">
                        <textarea class="form-control {{isset($is_required) && $is_required == true ?'required':''}}" id="reject_comment" maxlength="500" style="height: 200px;" placeholder="{{ __('ri2010.reject_reason_placeholder') }}" tabindex="2">{{ $my_purpose['comment'] ?? '' }}</textarea>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="row justify-content-md-center">
            <div class="col-md-5 col-lg-5 col-sm-12 col-xl-3 col-12 mt-3 button-1">
                <button id="btn_reject_save" type="button"
                    class="btn button--action btn-block">{{ __('messages.save') }}</button>
            </div>
        </div>
    </div>
@stop
