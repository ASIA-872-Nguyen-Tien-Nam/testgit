@php
$total_percent_3 = 0;
$total_percent_2 = 0;
$total_percent_1 = 0;
$total_percent_0 = 0;
$total_0 = 0;
$total_1 = 0;
$total_2 = 0;
$total_3 = 0;
$total_number = 0;

$point_typ_1 = 0;
$point_typ_2 = 0;
$point_typ_3 = 0;
$point_typ_4 = 0;

if(session_data()->language == 'en'){
    $space = ' ' ;
}
else{
    $space = '' ;
}
@endphp

<div>
    <div class=" wmd-view table-responsive _width">
        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="table4">
            <thead>
                <tr>
                    <th class="w-160px" colspan="2" rowspan="2">&nbsp;</th>
                    <th colspan="11">{{__('messages.adequacy')}}</th>
                </tr>
                <tr>
                    @if(isset($remark))
                    @php
                    if(isset($remark[1]['point'])){
                    $point_typ_1 = $remark[0]['point'];
                    }
                    if(isset($remark[2]['point'])){
                    $point_typ_2 = $remark[1]['point'];
                    }
                    if(isset($remark[3]['point'])){
                    $point_typ_3 = $remark[2]['point'];
                    }
                    if(isset($remark[4]['point'])){
                    $point_typ_4 = $remark[3]['point'];
                    }
                    @endphp
                    @foreach ($remark as $row)
                    <th class="text-center list-img">
                        <img tabindex="-1" src="/template/image/icon/weeklyreport/{{$row['remark1']}}" />
                    </th>
                    @endforeach
                    @endif
                    <th>{{__('messages.average_score')}}</th>
                    <th class="total_last">{{__('messages.total')}}</th>
                </tr>
            </thead>
            <tbody>
                @if(isset($list))
                    @for($i = 1 ;$i <= 4; $i++) 
                        @php 
                        $data_detail = $list['item_no_'.$i]; 
                        $point_average = 0;
                        $total_percent_0 = $total_percent_0 + $data_detail['reactions_percent_1'];
                        $total_percent_1 = $total_percent_1 + $data_detail['reactions_percent_2'];
                        $total_percent_2 = $total_percent_2 + $data_detail['reactions_percent_3'];
                        $total_percent_3 = $total_percent_3 + $data_detail['reactions_percent_4'];

                        $total_3 = $total_3 + $data_detail['reactions_4'];
                        $total_2 = $total_2 + $data_detail['reactions_3'];
                        $total_1 = $total_1 + $data_detail['reactions_2'];
                        $total_0 = $total_0 + $data_detail['reactions_1'];
                        $total_number = $total_number + $data_detail['sub_total'];
                        if(($data_detail['sub_total']) > 0){
                            $point_average = round(((
                                ($data_detail['reactions_1'] * $point_typ_1) 
                            +   ($data_detail['reactions_2'] * $point_typ_2) 
                            +   ($data_detail['reactions_3'] * $point_typ_3) 
                            +   ($data_detail['reactions_4'] * $point_typ_4)
                            )/($data_detail['sub_total'])),2);
                        }      
                        @endphp 
                    <tr>
                        @if ($i===1)
                        <td class="w-120px text-center" rowSpan="6">
                            <div class="table-caption">
                                <div>{{__('rq3040.reactions')}}</div>
                            </div>
                        </td>
                        @endif
                        <td class="w-120px text-center list-img">
                        @if(isset($remark_reactions[$i-1]['remark1']))
                            <label class="form-control-plaintext txt text-center">
                                <img tabindex="-1" src="/template/image/icon/weeklyreport/{{$remark_reactions[$i-1]['remark1']}}"/>
                            </label>
                        @endif
                        </td>
                        <td class="w-120px text-center">
                            <label class="form-control-plaintext txt">
                                {{$data_detail['reactions_1']}}{{$space}}{{__('messages.person')}}
                                <div>({{$data_detail['reactions_percent_1']}}%)</div>
                            </label>
                        </td>
                        <td class="w-120px text-center">
                            <label class="form-control-plaintext txt">
                                {{$data_detail['reactions_2']}}{{$space}}{{__('messages.person')}}
                                <div>({{$data_detail['reactions_percent_2']}}%)</div>
                            </label>
                        </td>
                        <td class="w-120px text-center">
                            <label class="form-control-plaintext txt">
                                {{$data_detail['reactions_3']}}{{$space}}{{__('messages.person')}}
                                <div>({{$data_detail['reactions_percent_3']}}%)</div>
                            </label>
                        </td>
                        <td class="w-120px text-center">
                            <label class="form-control-plaintext txt">
                                {{$data_detail['reactions_4']}}{{$space}}{{__('messages.person')}}
                                <div>({{$data_detail['reactions_percent_4']}}%)</div>
                            </label>
                        </td>
                        <td class="w-120px text-center">
                            <label class="form-control-plaintext txt text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{!!$point_average!!}" >{!!$point_average!!}</label>
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
                            <b>{!!$total_0!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_0!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_1!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_1!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_2!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_2!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_3!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_3!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
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