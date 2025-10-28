@extends('weeklyreport/layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/weeklyreport/ri1021/ri1021.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/weeklyreport/ri1021/ri1021.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderWeeklyReport(['saveButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <input type="hidden" class="anti_tab" name="">
        <div class="card" id='header_content'>
            @include('WeeklyReport::ri1021.header_content')
        </div><!-- end .card -->
        <!-- <div class="row mg_row"> -->
        <div class="pl-3 pr-3">
            <div id="card_import" class="card">
                <div class="card-body">
                    <div class="row mg_row">
                        <div class="col-md-12" style="margin-left: 10px;margin-top: -10px">
                            <div class="form-group">
                                <div class="full-width text-right">
                                    <a href="javascript:;" id="btn_search" class="btn btn-outline-primary vt-3"
                                        tabindex="12">
                                        <i class="fa fa-user-o"></i>
                                        {{ __('messages.extract_employee') }}
                                    </a>
                                    <a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_popup" tabindex="12">
                                        <i class="fa fa-edit"></i>
                                        {{ __('messages.edit') }}
                                    </a>
                                    <a href="javascript:;" class="btn vt-3" id="btn_delete" tabindex="6">
                                        <i class="fa fa-user-times"></i>
                                        {{ __('messages.delete_viewer') }}
                                    </a>
                                    <a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_csv_output"
                                        tabindex="13">
                                        <i class="fa fa-upload "></i>
                                        {{ __('messages.output_csv') }}
                                    </a>
                                    <a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_evaluation_import"
                                        tabindex="14">
                                        <i class="fa fa-download"></i>
                                        {{ __('ri1021.capture') }}
                                    </a>
                                    <a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_apply_latest" tabindex="15">
                                        <i class="fa fa-check"></i>
                                        {{ __('ri1021.apply_settings') }}
                                    </a>
                                </div><!-- end .full-width -->
                            </div>
                        </div>
                    </div>
                    <div id="result">
                        @include('WeeklyReport::ri1021.list_content')
                    </div>
                    <div class="row justify-content-md-center mb-3">
                        {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
                    </div>
                </div><!-- end .card -->
            </div>
        </div>
    </div><!-- end .container-fluid -->
    <input type="file" id="import_file" style="display: none" accept=".csv">
@stop
