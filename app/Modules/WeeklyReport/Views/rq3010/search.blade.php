<div class="table-responsive wmd-view  sticky-table sticky-headers sticky-ltr-cells" style="max-height: 606px">
    <table class="table one-table sortable table-bordered table-hover  ofixed-boder" id="myTable" style="">
        <thead>
            <tr>
                <th style="width: 14%;">{{ __('rq3010.submission_rate') }}</th>
                @if (isset($header) && !empty($header))
                    @foreach ($header as $item)
                    <th style="width: 6%;">{{ $item['month_num_nm'] }}</th>        
                    @endforeach
                @endif
                <th style="width: 14%;">{{ __('messages.annual_average') }}</th>
            </tr>
        </thead>
        <tbody>
            @if ( isset($list) && !empty($list))
                @foreach ($list as $row)
                    <tr>
                        <td class="text-left">{{ $row['target_nm'] }}</td>
                        @if(isset($header) && !empty($header))
                        @foreach ($header as $hd)
                            @php
                            $data_detail = json_decode(htmlspecialchars_decode($row["{$hd['month_num']}"]),true);
                            $year_summited_percent = $data_detail['year_summited_percent'] ?? '';
                            @endphp
                            <td class="text-center">{{ $data_detail['summited_percent']. '%'}}</td>
                        @endforeach
                        @endif
                        <td class="text-center">{{ $year_summited_percent. '%' ?? '' }}</td>
                    </tr>
                @endforeach
                <tr style="border: 1px solid white;background: #e5e6e8" id="total_line">
                    <td class="text-center">
                        <b>{{ __('rq3010.average') }}</b>
                    </td>
                    @if(isset($header) && !empty($header))
                        @foreach ($header as $hd)
                        <td class="text-center">{{ $hd['summited_percent'].'%' }}</td>
                        @endforeach
                        <td class="text-center">{{ $header[0]['year_footer_summited_percent'] .'%' }}</td>
                    @endif
                </tr>
            @else
                <tr>
                    <td colspan="100%" class="text-center">
                        {{ $_text[21]['message'] }}
                    </td>
                </tr>
            @endif
        </tbody>
    </table>
</div><!-- end .row -->
