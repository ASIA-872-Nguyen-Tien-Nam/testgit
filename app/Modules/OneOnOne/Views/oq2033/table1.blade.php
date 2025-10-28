@php
$total_questionnaire_10 = 0;
$total_questionnaire_9 = 0;
$total_questionnaire_8 = 0;
$total_questionnaire_7 = 0;
$total_questionnaire_6 = 0;
$total_questionnaire_5 = 0;
$total_questionnaire_4 = 0;
$total_questionnaire_3 = 0;
$total_questionnaire_2 = 0;
$total_questionnaire_1 = 0;
$total_percent_1 = 0;
$total_percent_2 = 0;
$total_percent_3 = 0;
$total_percent_4 = 0;
$total_percent_5 = 0;
$total_percent_6 = 0;
$total_percent_7 = 0;
$total_percent_8 = 0;
$total_percent_9 = 0;
$total_percent_10 = 0;
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
        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="table1">
            <thead>
                <tr>
                    <th class="w-160px" colspan="2" rowspan="2">&nbsp;</th>
                    <th class="w-120px" colspan="11">{{__('messages.questionnaire_results')}}</th>
                </tr>
                <tr>
                    <th>10{{$space}}{{__('messages.point')}}</th>
                    <th>9{{$space}}{{__('messages.point')}}</th>
                    <th>8{{$space}}{{__('messages.point')}}</th>
                    <th>7{{$space}}{{__('messages.point')}}</th>
                    <th>6{{$space}}{{__('messages.point')}}</th>
                    <th>5{{$space}}{{__('messages.point')}}</th>
                    <th>4{{$space}}{{__('messages.point')}}</th>
                    <th>3{{$space}}{{__('messages.point')}}</th>
                    <th>2{{$space}}{{__('messages.point')}}</th>
                    <th>1{{$space}}{{__('messages.point')}}</th>
                    <th class="total_last">{{__('messages.total')}}</th>
                </tr>
            </thead>
            <tbody>
                @if(isset($list[0]))
                @for($i = 90 ;$i >= 0;$i-=10)
                @php
                $percent_info='';
               
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
                $total_questionnaire_10 = $total_questionnaire_10 + $data_detail['questionnaire_10'];
                $total_questionnaire_9 = $total_questionnaire_9 + $data_detail['questionnaire_9'];
                $total_questionnaire_8 = $total_questionnaire_8 + $data_detail['questionnaire_8'];
                $total_questionnaire_7 = $total_questionnaire_7 + $data_detail['questionnaire_7'];
                $total_questionnaire_6 = $total_questionnaire_6 + $data_detail['questionnaire_6'];
                $total_questionnaire_5 = $total_questionnaire_5 + $data_detail['questionnaire_5'];
                $total_questionnaire_4 = $total_questionnaire_4 + $data_detail['questionnaire_4'];
                $total_questionnaire_3 = $total_questionnaire_3 + $data_detail['questionnaire_3'];
                $total_questionnaire_2 = $total_questionnaire_2 + $data_detail['questionnaire_2'];
                $total_questionnaire_1 = $total_questionnaire_1 + $data_detail['questionnaire_1'];
                $total_percent_1 = $total_percent_1 + $data_detail['questionnaire_percent_1'];
                $total_percent_2 = $total_percent_2 + $data_detail['questionnaire_percent_2'];
                $total_percent_3 = $total_percent_3 + $data_detail['questionnaire_percent_3'];
                $total_percent_4 = $total_percent_4 + $data_detail['questionnaire_percent_4'];
                $total_percent_5 = $total_percent_5 + $data_detail['questionnaire_percent_5'];
                $total_percent_6 = $total_percent_6 + $data_detail['questionnaire_percent_6'];
                $total_percent_7 = $total_percent_7 + $data_detail['questionnaire_percent_7'];
                $total_percent_8 = $total_percent_8 + $data_detail['questionnaire_percent_8'];
                $total_percent_9 = $total_percent_9 + $data_detail['questionnaire_percent_9'];
                $total_percent_10 = $total_percent_10 + $data_detail['questionnaire_percent_10'];
                $total_number = $total_number + $data_detail['sub_total'];
                @endphp 
                <tr class="">
                    @if ($i===90)
                    <td class="w-120px text-center" rowSpan="11">
                        <div class="table-caption">
                            <div>{{__('messages.implementation_status')}}</div>
                        </div>
                    </td>
                    @endif
                    <td class="w-140px">
                        <label class="form-control-plaintext txt">
                            {!!$percent_info!!}
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_10']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_10']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_9']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_9']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_8']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_8']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_7']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_7']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_6']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_6']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_5']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_5']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_4']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_4']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_3']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_3']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_2']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_2']}}%)</div>
                        </label>
                    </td>
                    <td class="w-120px text-center">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['questionnaire_1']}}{{$space}}{{__('messages.person')}}
                            <div>({{$data_detail['questionnaire_percent_1']}}%)</div>
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
                <tr class="">
                    <td class="w-135 total_last">
                        <label class="form-control-plaintext txt">
                            <b>{{__('messages.total')}}</b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_10!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_10!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_9!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_9!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_8!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_8!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_7!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_7!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_6!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_6!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_5!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_5!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_4!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_4!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_3!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_3!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_2!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_2!!}%)</div></b>
                        </label>
                    </td>
                    <td class="w-120px text-center total_last">
                        <label class="form-control-plaintext txt">
                            <b>{!!$total_questionnaire_1!!}{{$space}}{{__('messages.person')}}<div>({!!$total_percent_1!!}%)</div></b>
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