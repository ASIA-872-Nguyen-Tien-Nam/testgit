@extends('oneonone/layout')

@section('asset_header')

{!! public_url('template/css/common/master.css') !!}
{!! public_url('template/css/oneonone/om0400/om0400.index.css') !!}
@stop

@section('asset_footer')
    {!!public_url('template/js/oneonone/om0400/om0400.index.js')!!}
@stop

@push('asset_button')
{!!
    Helper::dropdownRender1on1(['saveButton','addNewButton','copyButton','deleteButton','backButton'])
!!}
@endpush

@section('content')
        <!-- START CONTENT -->
<div class="container-fluid">
    <div class="row">
        <div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
            <div class="inner">
                @include('OneOnOne::om0400.leftcontent')
            </div> <!-- end .inner -->
        </div> <!-- end #leftcontent -->
        <div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
            <div class="card calHe inner " id="result">
                @include('OneOnOne::om0400.rightcontent')
            </div> <!-- end #rightcontent -->
        </div>
    </div>
</div>
@stop


