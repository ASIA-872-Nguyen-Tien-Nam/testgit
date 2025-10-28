@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/i2040.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/pop_i2040.index.js')!!}
@stop
@section('content')
<div class="" style="margin-bottom: 15px " >
    <table class="table table-bordered table-hover table-striped"  style="width: 100%;height:{{(count($data??[])==0?1:count($data??[]))*60}}px" id="table_data">
        <tbody id='main'>
            <tr class=" tr_checkall" style="height: 25px">
                    <td style="width: 15%">

                    </td>
                    <td class="text-center bold" style="font-weight: 700">
                        {{ __('messages.comment') }}
                    </td>
                </tr>
            @foreach($data as $dt)
                <tr class="pop_tr">
                    <td style="width: 15% ;font-weight: 700">
                        {{$dt['evaluation_step']}}
                    </td>
                    <td class="text-left">
                        {{$dt['comment']}}
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div>
@stop
