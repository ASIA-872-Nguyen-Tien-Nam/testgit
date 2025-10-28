<div class="row">
    <div class="col-md-12">
        <div id="topTable" class="wmd-view table-responsive _width" style="background-attachment: fixed;max-height: 500px;margin-top: 10px;">
            <table class="table table-bordered table-hover table_sort one-table table-special ofixed-boder" id="table-data" style="margin-bottom: 10px;">
                <thead>
                    <tr>
                        <th style="max-width:200px;min-width:150px" class="th_view_unit "></th>
                        @if(isset($header) && !empty($header))
                        @foreach ($header as $row)
                        <th style="width: 7%;">@if(session_data()->language == 'en') {{__('messages.num_month'.$row['month_num'])}} @else {{$row['month_num']}}{{__('messages.num_month'.$row['month_num'])}}  @endif</th>
                        @endforeach
                        @endif
                        <th style="width: 9%;">{{__('messages.annual_average')}}</th>
                    </tr>
                </thead>
                <tbody>
                @if(isset($list[0]) && count($list) > 0)
                    <!-- check if 集計単位 = 全社 then don't show this content -->
                    @if($target_typ != 0)
                        @foreach($list as $row)
                        <tr>
                            <td class="text-center text-overfollow " style="max-width:200px" data-container="body" data-toggle="tooltip" data-original-title="{{$row['target_nm']}}">
                                {{$row['target_nm']}}
                            </td>
                            @if(isset($header) && !empty($header))
                            @foreach ($header as $hd)
                            @php
                            $data_detail = json_decode(htmlspecialchars_decode($row["{$hd['month_num']}"]),true);
                            $averaged_point_year_month = $hd['averaged_point_year_month'];
                            @endphp
                            <td class="text-center">
                                {{ $averaged_point_year_month > 0 ? $data_detail['averaged_point'] : '' }}
                            </td>
                            @endforeach
                            @endif
                            <!-- annual_average -->
                            @php
                            $annual_average = json_decode(htmlspecialchars_decode($row["1"]),true);
                            @endphp
                            <td class="text-center">{{ $annual_average['averaged_point_year'] }}</td>
                        </tr>
                        @endforeach
                    @endif
                    <!-- 平均 -->
                    <tr>
                        <td class="text-center"><b>{{__('messages.average')}}</b></td>
                        @if(isset($header[0]))
                        @foreach ($header as $total)
                        <td class="text-center">
                            {{$total['averaged_point_year_month'] > 0 ? $total['averaged_point_year_month'] : ''}}
                        </td>
                        @endforeach
                        @endif
                        <!-- annual_average -->
                        <td class="text-center">{{$header[0]['averaged_point_year'] > 0 ? $header[0]['averaged_point_year'] : ''}}</td>
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