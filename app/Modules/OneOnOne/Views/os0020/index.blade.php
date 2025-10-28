@extends('oneonone/layout')

@section('asset_header')
<style type="text/css">
    .ck-nolabel label {
        margin-bottom: 0;
        width: 16px;
        outline: none;
    }
    .md-checkbox-v2 input[type="checkbox"]+label:before {
        margin: 0;
    }
    label[for="check-all"]:focus::before, .focusin:focus::before {
        background-color: #2192de7a !important;
    }
    .lbl-text:focus {
        outline: none;
    }
    .lbl-text:focus::before {
      background-color: #2192de7a !important;
    }
</style>

{!! public_url('template/css/common/master.css') !!}
{!! public_url('template/css/oneonone/os0020/index.css') !!}
@stop

@section('asset_footer')
    {!!public_url('template/js/oneonone/os0020/os0020.index.js')!!}
@stop

@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','addNewSignupButton', 'deleteButton' , 'backButton'])
!!}
@endpush

@section('content')
        <!-- START CONTENT -->
<div class="container-fluid">
    <div class="row">
        <div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
            <div class="inner">
                @include('OneOnOne::os0020.leftcontent')
            </div> <!-- end .inner -->
        </div> <!-- end #leftcontent -->
        <div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
            <div class="inner" id="result">
                @include('OneOnOne::os0020.rightcontent')
            </div> <!-- end #rightcontent -->
        </div>
    </div>
</div>
@stop


