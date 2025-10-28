@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_viewer.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_viewers.index.js')!!}
@stop

@section('content')
<input type="hidden" id="popup_fiscal_year" value="{{ $fiscal_year ?? 0 }}">
<input type="hidden" id="popup_employee_cd" value="{{ $employee_cd ?? 0 }}">
<input type="hidden" id="popup_report_kind" value="{{ $report_kind ?? 0 }}">
<input type="hidden" id="popup_report_no" value="{{ $report_no ?? 0 }}">

<div id="result" class="card">
	@include('Common::popup.search_viewer')
</div> <!-- end .card -->
@stop
