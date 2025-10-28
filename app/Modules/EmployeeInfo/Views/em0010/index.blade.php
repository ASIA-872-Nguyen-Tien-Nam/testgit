@extends('slayout')

@section('asset_header')
    {!! public_url('template/css/employeeinfo/em0010.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/employeeinfo/em0010.index.js') !!}
@stop

@push('asset_button')
    {!! Helper::dropdownRenderEmployeeInformation(['addNewButton','saveButton' , 'deleteButton' , 'backButton']) !!}
@endpush

@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="row">
            <div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
                <div class="inner">
                    @include('EmployeeInfo::em0010.leftcontent')
                </div>
            </div>
            <div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
                <div class="inner">
                    @include('EmployeeInfo::em0010.rightcontent')
                </div>
            </div>
        </div>
    </div>
@stop
