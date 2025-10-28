@php
$total_percent_9 = 0;
$total_percent_8 = 0;
$total_percent_7 = 0;
$total_percent_6 = 0;  
$total_percent_5 = 0;
$total_percent_4 = 0;
$total_percent_3 = 0;
$total_percent_2 = 0;
$total_percent_1 = 0;
$total_percent_0 = 0;
$total_0 = 0;
$total_1 = 0;
$total_2 = 0;
$total_3 = 0;
$total_4 = 0;
$total_5 = 0;
$total_6 = 0;
$total_7 = 0;
$total_8 = 0;
$total_9 = 0;
$total_number = 0;
if(session_data()->language == 'en'){
    $space = ' ' ;
}
else{
    $space = '' ;
}
@endphp

<div>
    <div class=" wmd-view table-responsive _width">
        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="table3">
            <thead>
                <tr>
                    <th class="w-160px" colspan="2" rowspan="2">&nbsp;</th>
                    <th colspan="11">{{__('messages.implementation_status')}}</th>
                </tr>
                <tr>
                    <th class="w-140px">90％{{$space}}{{__('messages.more_than')}}</th>
                    <th class="w-140px">80％{{$space}}{{__('messages.more_than')}}{{$space}}90％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">70％{{$space}}{{__('messages.more_than')}}{{$space}}80％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">60％{{$space}}{{__('messages.more_than')}}{{$space}}70％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">50％{{$space}}{{__('messages.more_than')}}{{$space}}60％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">40％{{$space}}{{__('messages.more_than')}}{{$space}}50％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">30％{{$space}}{{__('messages.more_than')}}{{$space}}40％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">20％{{$space}}{{__('messages.more_than')}}{{$space}}30％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">10％{{$space}}{{__('messages.more_than')}}{{$space}}20％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="w-140px">10％{{$space}}{{__('messages.less_than')}}</th>
                    <th class="total_last">{{__('messages.total')}}</th>
                </tr>
            </thead>
            <tbody>
                @if(isset($list))
                @for($i = 1 ;$i <= 4;$i++) 
                    @php $data_detail = $list['item_no_'.$i]; 
                    $total_percent_0 = $total_percent_0 + $data_detail['0_percent'];
                    $total_percent_1 = $total_percent_1 + $data_detail['10_percent'];
                    $total_percent_2 = $total_percent_2 + $data_detail['20_percent'];
                    $total_percent_3 = $total_percent_3 + $data_detail['30_percent'];
                    $total_percent_4 = $total_percent_4 + $data_detail['40_percent'];
                    $total_percent_5 = $total_percent_5 + $data_detail['50_percent'];
                    $total_percent_6 = $total_percent_6 + $data_detail['60_percent'];
                    $total_percent_7 = $total_percent_7 + $data_detail['70_percent'];
                    $total_percent_8 = $total_percent_8 + $data_detail['80_percent'];
                    $total_percent_9 = $total_percent_9 + $data_detail['90_percent'];
                    
                    $total_9 = $total_9 + $data_detail[90];
                    $total_8 = $total_8 + $data_detail[80];
                    $total_7 = $total_7 + $data_detail[70];
                    $total_6 = $total_6 + $data_detail[60];
                    $total_5 = $total_5 + $data_detail[50];
                    $total_4 = $total_4 + $data_detail[40];
                    $total_3 = $total_3 + $data_detail[30];
                    $total_2 = $total_2 + $data_detail[20];
                    $total_1 = $total_1 + $data_detail[10];
                    $total_0 = $total_0 + $data_detail[0];
                    $total_number = $total_number + $data_detail['sub_total'];
                    @endphp 
                <tr>
                    @if ($i===1)
                    <td class="w-120px text-center" rowSpan="6">
                        <div class="table-caption">
                            @if ($combination == 31)
                            <div>{{__('rq3040.reactions')}}</div>
                            @elseif($combination == 21)
                            <div>{{__('messages.adequacy')}}</div>
                            @endif
                        </div>
                    </td>
                    @endif
                    <td class="w-120px text-center list-img">
                    @if(isset($remark[$i-1]['remark1']))
                        <label class="form-control-plaintext txt text-center">
                            <img tabindex="-1" src="/template/image/icon/weeklyreport/{{$remark[$i-1]['remark1']}}"/>
                        </label>
                    @endif
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[90]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['90_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[80]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['80_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['70']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['70_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['60']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['60_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[50]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['50_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[40]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['40_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[30]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['30_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[20]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['20_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[10]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['10_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail[0]}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['0_percent']}}%)</div>
                        </label>
                    </td>
                    <td class="w-80px text-center total_last">
                        <label class="form-control-plaintext txt">
                        {{$data_detail['sub_total']}}{{$space}}{{__('messages.person')}}
                        </label>
                    </td>
                </tr>
                @endfor
                @endif
                <tr>
                    <td class="w-120px total_last">
                        <label class="form-control-plaintext txt text-center">
                            <b>{{__('messages.total')}}</b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_9!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_9!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_8!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_8!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_7!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_7!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_6!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_6!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_5!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_5!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_4!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_4!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_3!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_3!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_2!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_2!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_1!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_1!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_0!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_0!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-80px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_number!!}{{$space}}{{__('messages.person')}}</b>
                        </label>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>