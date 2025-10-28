
@if(isset($table_info)&&!empty($table_info))
    <tr class="list">
        <td class="text-center">
            <span style="word-break: break-all;" class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}"> {{$table_info['position_nm']??''}}</span>
        </td>
        <td class="text-center">
            <span style="word-break: break-all;" class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">{{$table_info['job_nm']??''}}</span>
        </td>
        <td class="text-center">
            <span style="word-break: break-all;" class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">{{$table_info['grade_nm']??''}}</span>
        </td>
        <td class="text-center">
            <span style="word-break: break-all;" class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">{{$table_info['employee_typ_nm']??''}}</span>
        </td>
        <td class="text-center">
            <span style="word-break: break-all;" class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">{{$table_info['interview_nm']??''}}</span>
        </td>
        <td class="text-center" style="word-break: break-all;">
            {{$table_info['times']??''}}
        </td>
    </tr>
@else
    <tr>
        <td colspan="6"  class="w-popup-nodata no-hover text-center"> {{ $_text[21]['message'] }}</td>
    </tr>
@endif
