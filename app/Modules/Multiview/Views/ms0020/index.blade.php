@extends('mlayout')

@section('asset_header')
{!! public_url('template/css/common/master.css') !!}
{!! public_url('template/css/mulitiview/ms0020/index.css') !!}
@stop

@section('asset_footer')
    {!!public_url('template/js/mulitiview/ms0020/ms0020.index.js')!!}
@stop

@push('asset_button')
{!!
	Helper::dropdownRenderMulitireview(['saveButton','addNewSignupButton', 'deleteButton' , 'backButton'])
!!}
@endpush

@section('content')
        <!-- START CONTENT -->
<div class="container-fluid">
    <div class="row">
        <div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
            <div class="inner">
                @include('Multiview::ms0020.leftcontent')
            </div> <!-- end .inner -->
        </div> <!-- end #leftcontent -->
        <div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
            <div class="inner" id="result">
                @include('Multiview::ms0020.rightcontent')
            </div> <!-- end #rightcontent -->
        </div>
    </div>
</div>
@stop


