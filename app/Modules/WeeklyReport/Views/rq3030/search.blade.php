<div class="table-responsive wmd-view  sticky-table sticky-headers sticky-ltr-cells" style="max-height: 606px">
    <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="myTable" style="">
        <thead>
            <tr>
                <th class="th_view_unit" style="max-width:200px; min-width:200px">{{ $header[0]['sufficiency_nm'] ?? '' }}</th>
                @if (isset($header) && !empty($header))
                @foreach ($header as $hd)
                <th style="min-width: 80px;">{{ $hd['year_month_times_nm'] ?? '' }}</th>    
                @endforeach
                @endif
                <th style="min-width: 150px;">{{ __('messages.annual_average') }}</th>
            </tr>
        </thead>
        <tbody>
            @if (!empty($list))
                @foreach ($list as $row)
                    <tr>
                        <td class="text-left">{{ $row['target_nm'] }}</td>
                        @if(isset($header) && !empty($header))
                        @foreach ($header as $hd)
                            @php
                            $data_detail = json_decode(htmlspecialchars_decode($row["{$hd['year_month_times']}"]),true);
                            $year_adequacy_score_avg = $data_detail['year_adequacy_score_avg'] ?? '';
                            @endphp
                            <td class="text-center">{{ $data_detail['adequacy_score_avg']  }}</td>
                        @endforeach
                        @endif
                        <td class="text-center">{{ $year_adequacy_score_avg ?? '' }}</td>
                    </tr>
                @endforeach
                <tr style="border: 1px solid white;background: #e5e6e8" id="total_line">
                    <td class="text-center">
                        <b>{{ __('rq3010.average') }}</b>
                    </td>
                    @if(isset($header) && !empty($header))
                        @foreach ($header as $hd)
                        <td class="text-center">{{ $hd['adequacy_score_avg'] }}</td>
                        @endforeach
                        <td class="text-center">{{ $header[0]['year_footer_adequacy_score_avg'] }}</td>
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
