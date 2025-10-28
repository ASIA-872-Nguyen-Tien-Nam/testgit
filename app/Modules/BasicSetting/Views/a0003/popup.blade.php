@extends('popup')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!! public_url('template/css/common/master.css') !!}
	{!!public_url('template/css/popup/a0003p.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/a0003p.index.js')!!}
<!-- {!!public_url('template/js/common/zipcode.js')!!} -->
<!-- <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD-SuUsQXWnWMeFRDzOk1MAtJcdurZFYcM&callback=initMap&language=ja"></script> -->
@stop

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
    <div id="collapseExample" class="collapse show">
        <div class="">
            <div class="table-responsive" style="height:400px;margin-bottom: 15px " >
                    <table class="table table-bordered table-hover " style="width: 100%;height:300px" id="table_data">
                        <thead>
                            <tr class=" tr_checkall" style="height: 50px">
                                <th  class="text-center mw-100" style="font-weight: 700">
                                {{ __('messages.business_office_code') }}
                                </th>
                                <th class="text-center" style="font-weight: 700">
                                {{ __('messages.office_name') }}
                                </th>
                            </tr>
                        </thead>
                        <tbody id='main'>

                            @foreach($data as $dt)
                                <tr class="pop_tr">
                                    <td class="text-center"  id="office_cd">
                                        {{$dt['id']}}
                                    </td>
                                    <td class="text-left" id="office_nm">
                                        {{$dt['name']}}
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
        </div>
    </div>

</div>
@stop