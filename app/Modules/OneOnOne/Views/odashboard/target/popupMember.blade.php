@extends('popup')

@push('header')
{!!public_url('template/css/oneonone/dashboard/member.css')!!}
@endpush

@section('asset_footer')
{!! public_url('template/js/oneonone/dashboard/member.popup.js') !!}
@stop

@section('content')
        <div class="row">
            <div class="col-md-12">
                <div id="popup_detail_div">
                @include('OneOnOne::odashboard.target.popupMemberDetail')
                </div>
                <div class="row">
                    <div class="col-md-12 mt-3" >
                        <div class="group-btn" style="justify-content: center;margin-top: 10px;margin-bottom: 20px;">
                            {!!
                                Helper::buttonRender1on1(['saveButton'])
                            !!}
                        </div>
                    </div>
                </div>
                <input type="hidden" class="anti_tab">
            </div>
        </div>
@stop
