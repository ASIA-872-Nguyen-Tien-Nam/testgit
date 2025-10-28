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
$total_number = 0; 
if(session_data()->language == 'en'){
    $space = ' ' ;
}
else{
    $space = '' ;
} 
@endphp

<div>
    <div class="wmd-view table-responsive _width">
        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="table6">
            <thead>
                <tr>
                    <th class="w-160px" colspan="2" rowspan="2">&nbsp;</th>
                    <th class="w-120px" colspan="6">{{__('messages.adequacy')}}</th>
                </tr>
                <tr>
                    @if(isset($remark))
                    @foreach ($remark as $row)
                    <th class="text-center list-img">
                        <img tabindex="-1" src="/uploads/ver1.7/odashboard/{{$row['remark1']}}" />
                    </th>
                    @endforeach
                    @else
                    <th></th>
                    <th></th>
                    <th></th>
                    <th></th>
                    <th></th>
                    @endif
                    <th class="total_last">{{__('messages.total')}}</th>
                </tr>
            </thead>
            <tbody>
                @if(isset($list))
                @for($i = 10 ;$i >= 1;$i--)
                @php $data_detail = $list['questionnaire_'.$i];
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
                @endphp
                <tr class="tr_employee">
                    @if ($i===10)
                    <td class="w-120px text-center" rowSpan="11">
                        <div class="table-caption">
                            <div>{{__('messages.questionnaire_results')}}</div>
                        </div>
                    </td>
                    @endif
                    <td class="w-80px">
                        <label class="form-control-plaintext txt text-center">
                            {{$i}}{{$space}}{{__('messages.point')}}
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
                    <td class="w-80px text-center total_last">
                        <label class="form-control-plaintext txt">
                            {{$data_detail['sub_total']}}{{$space}}{{__('messages.person')}}
                        </label>
                    </td>
                </tr>
                @endfor
                @endif
                <tr class="tr_employee">
                    <td class="w-80px total_last">
                        <label class="form-control-plaintext txt text-center">
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