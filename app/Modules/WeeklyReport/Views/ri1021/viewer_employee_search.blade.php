<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
    <nav class="pager-wrap row">
        {!! Paging::show($paging) !!}
    </nav>
    <div class="table-responsive">
        <div class="wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells" style="max-height: 100%;">
            <table class="table sortable table-bordered table-hover fixed-header" id="popup_myTable">
                <thead>
                    <tr>
                        <th class="" style="white-space: pre;">{{ __('ri1021.selection') }}</th>
                        <th class="">
                            <div style="width:70px" class="text-overfollow setTooltip  " data-container="body"
                                data-toggle="tooltip" data-original-title="{{ __('messages.employee_no') }}">
                                {{ __('messages.employee_no') }}</div>
                        </th>
                        <th class="">
                            <div style="width:140px" class="text-overfollow setTooltip  " data-container="body"
                                data-toggle="tooltip" data-original-title="{{ __('messages.employee_name') }}">
                                {{ __('messages.employee_name') }}</div>
                        </th>
                        <th class="">
                            <div style="width:140px" class="text-overfollow setTooltip  " data-container="body"
                                data-toggle="tooltip"
                                data-original-title="{{ __('messages.employee_classification') }}">
                                {{ __('messages.employee_classification') }}</div>
                        </th>
                        @isset($organization_group)
                            @foreach ($organization_group as $item)
                                <th class="">
                                    <div style="width:140px" class="text-overfollow setTooltip  " data-container="body"
                                        data-toggle="tooltip" data-original-title="{{ $item['organization_group_nm'] }}">
                                        {{ $item['organization_group_nm'] }}</div>
                                </th>
                            @endforeach
                        @endisset
                        <th class="">
                            <div style="width:140px" class="text-overfollow setTooltip  " data-container="body"
                                data-toggle="tooltip" data-original-title="{{ __('messages.position') }} ">
                                {{ __('messages.position') }} </div>
                        </th>
                    </tr>
                </thead>
                <tbody id="popup_list">
                    @if (isset($list[0]))
                        @foreach ($list as $key => $row)
                            <tr class="tr_employee">
                                <td class="text-center lblCheck">
                                    <div id="" class="md-checkbox-v2 inline-block">
                                        <label for="{{ 'ckb0' . $row['employee_cd'] }}"
                                            class="container checkbox-os0030">
                                            <input name="check-all" class="chk-item"
                                                id="{{ 'ckb0' . $row['employee_cd'] }}" type="checkbox"
                                                {{ ($row['check_box'] ?? 0) == 1 ? 'checked' : '' }}>
                                            <span class="checkmark"></span>
                                        </label>
                                    </div>
                                </td>
                                <td style="max-width:80px;min-width: 80px">
                                    <input type="hidden" class="tb_employee_cd" value="{{ $row['employee_cd'] }}">
                                    <div class="text-overfollow setTooltip  " data-container="body"
                                        data-toggle="tooltip" data-original-title="">
                                        {{ $row['employee_cd'] }}
                                    </div>
                                </td>
                                <td style="max-width:150px;min-width: 150px">
                                    <input type="hidden" class="tb_employee_nm" value="{{ $row['employee_nm'] }}">
                                    <div class="text-overfollow setTooltip employee_nm" data-container="body"
                                        data-toggle="tooltip" data-original-title="{{ $row['employee_nm'] }}">
                                        {{ $row['employee_nm'] }}
                                    </div>
                                </td>
                                <td style="max-width:150px;min-width: 150px">
                                    <div class="text-overfollow setTooltip  " data-container="body"
                                        data-toggle="tooltip" data-original-title="{{ $row['employee_typ_nm'] }}">
                                        {{ $row['employee_typ_nm'] }}
                                    </div>
                                </td>
                                @isset($organization_group)
                                    @foreach ($organization_group as $key => $item)
                                        <td style="max-width:150px;min-width: 150px">
                                            <div class="text-overfollow setTooltip  " data-container="body"
                                                data-toggle="tooltip"
                                                data-original-title=" {{ $row['organization_nm_' . ($key + 1)] ?? '' }}">
                                                {{ $row['organization_nm_' . ($key + 1)] ?? '' }}
                                            </div>
                                        </td>
                                    @endforeach
                                @endisset
                                <td style="max-width:150px;min-width: 150px">
                                    <div class="text-overfollow setTooltip  " data-container="body"
                                        data-toggle="tooltip" data-original-title=" {{ $row['position_nm'] }}">
                                        {{ $row['position_nm'] }}
                                    </div>
                                </td>
                            </tr>
                        @endforeach
                    @else
                        <tr class="tr-nodata">
                            <td colspan="100%" class="w-popup-nodata no-hover text-center">
                                {{ $_text[21]['message'] ?? '' }}</td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div> <!-- end .card-body -->
