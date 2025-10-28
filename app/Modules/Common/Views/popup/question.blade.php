@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_question.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_question.index.js')!!}
@stop

@section('content')
    <div class="row mt-30">
        <div class="col-md-12">
            <div id="result">
                @include('Common::popup.search_question')
            </div>
        </div>
    </div>

@stop
