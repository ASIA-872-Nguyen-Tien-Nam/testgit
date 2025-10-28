@if(isset($data[0][0]))
    @foreach($data[0] as $row)
        <tr>
            <td width="25%" style="height: 32px">
                <div class="text-overfollow setTooltip w_div"
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$row['employee_typ_nm']}}">
                   {{$row['employee_typ_nm']}}
                </div>
            </td>
            <td width="25%" style="height: 32px">
                <div class="text-overfollow setTooltip w_div"
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$row['job_nm']}}">
                    {{$row['job_nm']}}
                </div>
            </td>
            <td width="25%" style="height: 32px">
                <div class="text-overfollow setTooltip w_div"
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$row['position_nm']}}">
                    {{$row['position_nm']}}
                </div>
            </td>
            <td width="25%" style="height: 32px">
                <div class="text-overfollow setTooltip w_div"
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$row['grade_nm']}}">
                    {{$row['grade_nm']}}
                </div>
            </td>
        </tr>
    @endforeach
@else
    <tr>
        <td  class="text-center"  style="height: 32px"></td>
        <td  class="text-center"  style="height: 32px"></td>
        <td  class="text-center"  style="height: 32px"></td>
        <td  class="text-center"  style="height: 32px"></td>
    </tr>
@endif