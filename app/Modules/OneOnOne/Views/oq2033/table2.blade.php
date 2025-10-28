@php
$total_item_no_1 = 0;
$total_item_no_2 = 0;
$total_item_no_3 = 0;
$total_item_no_4 = 0;
$total_item_no_5 = 0;
$total_percent_1 = 0;
$total_percent_2 = 0;
$total_percent_3 = 0;
$total_percent_4 = 0;
$total_percent_5 = 0;
$point_typ_1 = 0;
$point_typ_2 = 0;
$point_typ_3 = 0;
$point_typ_4 = 0;
$point_typ_5 = 0;
$total_number = 0;
@endphp

<div>
    <div class=" wmd-view table-responsive _width">
        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="table2">
            <thead>
                <tr>
                    <th class="w-160px" colspan="2" rowspan="2">&nbsp;</th>
                    <th class="w-120px" colspan="10">{{__('messages.adequacy')}}</th>
                </tr>
                <tr>
                    @if(isset($remark))
                    @php
                    if(isset($remark[1]['point'])){
                    $point_typ_1 = $remark[1]['point'];
                    }
                    if(isset($remark[2]['point'])){
                    $point_typ_2 = $remark[2]['point'];
                    }
                    if(isset($remark[3]['point'])){
                    $point_typ_3 = $remark[3]['point'];
                    }
                    if(isset($remark[4]['point'])){
                    $point_typ_4 = $remark[4]['point'];
                    }
                    if(isset($remark[5]['point'])){
                    $point_typ_5 = $remark[5]['point'];
                    }
                    @endphp
                    @foreach ($remark as $row)
                    <th class="text-center list-img">
                        <img tabindex="-1" src="/uploads/ver1.7/odashboard/{{$row['remark1']}}" />
                    </th>
                    @endforeach
                    @endif
                    <th>{{__('messages.average_score')}}</th>
                    <th class="total_last">{{__('messages.total')}}</th>
                </tr>
            </thead>
            <tbody>
                @if(isset($list[0]))
                @for($i = 90 ;$i >= 0;$i-=10)
                @php
                $percent_info='';
                if(session_data()->language == 'en'){
                    $space = ' ' ;
                }
                else{
                    $space = '' ;
                }
                if($i===90){
                $percent_info = '90％'.$space.__('messages.more_than');
                }elseif($i===80){
                $percent_info = '80%'.$space.__('messages.more_than').$space.'90％'.$space.__('messages.less_than');
                }elseif($i===70){
                $percent_info = '70%'.$space.__('messages.more_than').$space.'80％'.$space.__('messages.less_than');
                }elseif($i===60){
                $percent_info =  '60%'.$space.__('messages.more_than').$space.'70％'.$space.__('messages.less_than');
                }elseif($i===50){
                $percent_info =  '50%'.$space.__('messages.more_than').$space.'60％'.$space.__('messages.less_than');
                }elseif($i===40){
                $percent_info =  '40%'.$space.__('messages.more_than').$space.'50％'.$space.__('messages.less_than');
                }elseif($i===30){
                $percent_info = '30%'.$space.__('messages.more_than').$space.'40％'.$space.__('messages.less_than');
                }elseif($i===20){
                $percent_info = '20%'.$space.__('messages.more_than').$space.'30％'.$space.__('messages.less_than');
                }elseif($i===10){
                $percent_info =  '10%'.$space.__('messages.more_than').$space.'20％'.$space.__('messages.less_than');
                }else{
                $percent_info = '10％'.$space.__('messages.less_than');
                }
                $data_detail = $list[$i];
                $point_average = 0;
                $total_item_no_1 = $total_item_no_1 + $data_detail['item_no_1'];
                $total_item_no_2 = $total_item_no_2 + $data_detail['item_no_2'];
                $total_item_no_3 = $total_item_no_3 + $data_detail['item_no_3'];
                $total_item_no_4 = $total_item_no_4 + $data_detail['item_no_4'];
                $total_item_no_5 = $total_item_no_5 + $data_detail['item_no_5'];
                $total_percent_1 = $total_percent_1 + $data_detail['item_no_percent1'];
                $total_percent_2 = $total_percent_2 + $data_detail['item_no_percent2'];
                $total_percent_3 = $total_percent_3 + $data_detail['item_no_percent3'];
                $total_percent_4 = $total_percent_4 + $data_detail['item_no_percent4'];
                $total_percent_5 = $total_percent_5 + $data_detail['item_no_percent5'];
                $total_number = $total_number + $data_detail['sub_total'];
                if(($data_detail['sub_total']) > 0){
                $point_average = ((($data_detail['item_no_1']*$point_typ_1) + ($data_detail['item_no_2']*$point_typ_2) + ($data_detail['item_no_3']*$point_typ_3) + ($data_detail['item_no_4']*$point_typ_4) + ($data_detail['item_no_5']*$point_typ_5))/($data_detail['sub_total']));
                }  
                @endphp
                <tr class="">
                    @if ($i===90)
                    <td class="w-120px text-center" rowSpan="11">
                        <div class="table-caption">
                            <div>{{__('messages.implementation_status')}}</div>
                        </div>
                    </td>
                    @endif
                    <td class="w-140">
                        <label class="form-control-plaintext txt ">
                            {!!$percent_info!!}
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['item_no_1']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['item_no_percent1']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['item_no_2']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['item_no_percent2']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['item_no_3']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['item_no_percent3']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['item_no_4']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['item_no_percent4']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['item_no_5']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['item_no_percent5']}}%)</div>
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
                <tr class="">
                    <td class="w-120px total_last">
                        <label class="form-control-plaintext txt ">
                            <b>{{__('messages.total')}}</b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_item_no_1!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_1!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_item_no_2!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_2!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_item_no_3!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_3!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_item_no_4!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_4!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_item_no_5!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_5!!}%)</div></b>
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