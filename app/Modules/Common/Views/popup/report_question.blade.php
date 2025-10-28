@extends('popup')

@section('title', $title)

@section('asset_header')
    <!-- START LIBRARY CSS -->
    <style>
        .p-content {
            max-height: calc(100vh - 48px);
            margin-top: 48px;
        }
        #table-popup tbody tr:hover {
            background-color: var(--hover-pink-tr);
        }
    </style>
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/popup/popup_rquestion.index.js') !!}
@stop

@section('content')
    <div class="row mt-30">
        <div class="col-md-12">
            <div id="result">
                <div class="card pe-w">
                    <div class="card-body">
                        <div class="row" id="popup-rquestion">
                            @include('Common::popup.search_report_question')
                        </div>
                        <input type="text" hidden value="{{$report_kind??0}}"  id="report_kind_popup">
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
