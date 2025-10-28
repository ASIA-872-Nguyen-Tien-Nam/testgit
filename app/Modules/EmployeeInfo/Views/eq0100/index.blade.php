@extends('employee_information/elayout')

@section('asset_header')
        <!-- START LIBRARY CSS -->
    {!! public_url('template/css/employeeinfo/eq0100.index.css') !!}
@stop
@section('asset_footer')
    <script>
        var display = '{{ __('messages.display_attribute_info') }}';
    </script>
    {!!public_url('template/js/employeeinfo/eq0100.index.js')!!}
        <!-- START LIBRARY JS -->
@stop

@push('asset_button')
{!!
	Helper::dropdownRenderEmployeeInformation(['staffOutputButton', 'backButton'])
!!}
@endpush

@section('content')
    <!-- START CONTENT -->
<div class="container-fluid">
    <div class="card">
        <div class="card-body box-input-search">
            <div class = "group-search">
            </div>
            <div class="row" style="margin-left:0px;width:100%">
                <div class="form-group">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <div class="form-group text-right">
                            <div class="full-width">
                                <a href="javascript:;" id="btn-show" class="btn btn-outline-primary" tabindex="1">
                                    <i class="fa fa-plus-circle"></i>
                                    {{__('messages.btn_add_filter')}}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div>
                <span style="margin-left: 10px;margin-right: 10px;line-height: 38px"></span>
                <div class="form-group">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <div class="form-group text-right">
                            <div class="full-width">
                                <a href="javascript:;" id="btn-clear" class="btn btn-outline-danger" tabindex="1">
                                    <i class="fa fa-trash"></i>
                                    {{__('messages.clear_add_conditions')}}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="flex-direction: row-reverse;margin-right: 0px ">
                <div class="form-group">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <div class="form-group text-right">
                            <div class="full-width">
                                <a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="1">
                                    <i class="fa fa-search"></i>
                                    {{__('messages.search')}}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div>
            </div>
        </div> <!-- end .card-body -->
    </div><!-- end .card -->
    <div class="card">
        <div class="card-body">
            <div id="result">
                @include('EmployeeInfo::eq0100.search')
            </div>
        </div>
    </div>
</div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop