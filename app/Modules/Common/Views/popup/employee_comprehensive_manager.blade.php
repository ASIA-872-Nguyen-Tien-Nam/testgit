@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_employee_comprehensive_manager.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_employee_comprehensive_manager.index.js')!!}
@stop

@section('content')
<div id="result" class="card">
	@include('Common::popup.search_employee_comprehensive_manager')
</div> <!-- end .card -->
@stop
