<div class="row">
    <div class="col-md-12">
        <div id="topTable" class="wmd-view table-responsive _width" style="background-attachment: fixed;max-height: 500px;">
            <table class="table table-bordered table-hover table_sort one-table table-special ofixed-boder" id="table-data" style="margin: 10px 0px;">
                <thead>
                    <tr>
                        <th colspan="2">{{__('messages.implementation_status')}}</th>
                        @if(isset($header[0]))
                        @foreach ($header as $row)
                        <th style="width: 6%;"> @if(session_data()->language == 'en') {{__('messages.num_month'.$row['month_num'])}} @else {{$row['month_num']}}{{__('messages.num_month'.$row['month_num'])}}  @endif </th>
                        @endforeach
                        @endif
                        <th style="width: 9%;">{{__('messages.annual_average')}}</th>
                    </tr>
                </thead>
                <tbody>
                    @if(isset($list) && count($list) > 0)
                    <tr style="border: 1px solid white">
                        <td class="text-center" colspan="2">{{__('messages.completion')}}</td>
                        @if(isset($header[0]))
                        @foreach ($header as $row)
                        @php
                        $data_detail = json_decode(htmlspecialchars_decode($list[0]["{$row['month_num']}"]),true);
                        @endphp
                        <td class="text-center">
                            @if($data_detail['finished_number'] > 0 || $data_detail['unfinished_number'] > 0)
                            {{$data_detail['finished_number']}}
                            <p style="margin-bottom: 0px">{{$data_detail['finished_percent'] == '' ? '0%' : $data_detail['finished_percent'].'%'}}</p>
                            @endif
                        </td>
                        @endforeach
                        @endif
                        <td class="text-center">
                            @if($list[0]['finsihed_averaged_number'] > 0 || $list[0]['unfinsihed_averaged_number'] > 0)
                            {{$list[0]['finsihed_averaged_number']}}
                            <p style="margin-bottom: 0px">{{$list[0]['finsihed_averaged_percent'].'%'}}</p>
                            @endif
                        </td>
                    </tr>

                    <tr style="border: 1px solid white">
                        <td class="text-center" colspan="2">{{__('messages.incomplete')}}</td>
                        @if(isset($header[0]))
                        @foreach ($header as $row)
                        @php
                        $data_detail = json_decode(htmlspecialchars_decode($list[0]["{$row['month_num']}"]),true);
                        @endphp

                        <td class="text-center">
                            @if($data_detail['finished_number'] > 0 || $data_detail['unfinished_number'] > 0)
                            {{$data_detail['unfinished_number']}}
                            <p style="margin-bottom: 0px">{{$data_detail['unfinished_percent'] == '' ? '0%' : $data_detail['unfinished_percent'].'%'}}</p>
                            @endif
                        </td> 
                        @endforeach
                        @endif
                        <td class="text-center">
                            @if($list[0]['finsihed_averaged_number'] > 0 || $list[0]['unfinsihed_averaged_number'] > 0)
                            {{$list[0]['unfinsihed_averaged_number']}}
                            <p style="margin-bottom: 0px">{{$list[0]['unfinsihed_averaged_percent'].'%'}}</p>
                            @endif
                        </td>
                    </tr>

                    <tr style="border: 1px solid white" id="total_line">
                        <td class="text-center" colSpan="2">
                            <b>{{__('messages.total')}}</b>
                        </td>
                        @if(isset($header[0]))
                        @foreach ($header as $row)
                        @php
                        $data_detail = json_decode(htmlspecialchars_decode($list[0]["{$row['month_num']}"]),true);
                        @endphp
                        <td class="text-center">
                            @if($data_detail['finished_number'] > 0 || $data_detail['unfinished_number'] > 0)
                            <b>{{$data_detail['total_number']}}</b>
                            @endif
                        </td>
                        @endforeach
                        @endif
                        <td class="text-center"></td>
                    </tr>
                    @else
                    <tr style="border: 1px solid white">
                        <td class="text-center" colspan="15">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .row -->
    </div>
</div><!-- end .card-body -->