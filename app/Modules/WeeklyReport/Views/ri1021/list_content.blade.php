    <nav class="pager-wrap">
        {!! Paging::show($paging ?? []) !!}
    </nav>
    <div class="table-responsive table-fixed-header  sticky-table sticky-headers sticky-ltr-cells">
        <table class="table table-bordered wmd-view table-hover fixed-header outline-none table_sort" maxrate="4"
            final_step="0" style="margin-top: 0px !important;min-width:1500px" id="myTable">
            <thead>
                <tr>
                    <th class="" id="" colSpan="{{ 5 + count($organization_group ?? []) }}">
                        {{ __('messages.employee_info') }}
                    </th>
                    <th class="text-center" rowspan="2" num="5"
                        style="width: 800px;position: relative; outline: rgb(221, 221, 221) solid 0.5px; z-index: 22; top: 0px; left: 0px;">
                        {{ __('ri1021.viewer') }}
                    </th>
                </tr>
                <tr>
                    <th class="sticky-cell ">
                        <div id="checkboxAll" class="sticky-cell md-checkbox-v2 inline-block" style="outline: 0px">
                            <label for="check-all" class="container checkbox-os0030">
                                <input name="check-all" class="check_all" id="check-all" type="checkbox">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                    </th>
                    <th class="sticky-cell text-center" num="1" style="min-width:80px;">
                        {{ __('messages.employee_no') }}
                    </th>
                    <th class="sticky-cell text-center" num="2" style="width:150px;">
                        <div style="display:flex">
                            <div style="width:130px" class="text-overfollow  employee-overfollow" data-container="body"
                                data-toggle="tooltip" title="">{{ __('messages.employee_name') }}
                            </div>
                        </div>

                    </th>
                    <th class="" num="3" style="width:150px;">
                        <div style="display:flex">
                            <div style="width:130px" class="text-overfollow  employee-overfollow" data-container="body"
                                data-toggle="tooltip" data-original-title="{{ __('messages.employee_classification') }}"
                                title="">
                                {{ __('messages.employee_classification') }}
                            </div>
                        </div>
                    </th>
                    @isset($organization_group)
                        @foreach ($organization_group as $item)
                            <th class="text-center   " num="3" style="width:150px;">
                                <div style="display:flex">
                                    <div style="width:130px" class="text-overfollow  employee-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title=" {{ $item['organization_group_nm'] }}" title="">
                                        {{ $item['organization_group_nm'] }}
                                    </div>
                                </div>
                            </th>
                        @endforeach
                    @endisset
                    <th class="text-center   " num="3" style="width:150px;">
                        <div style="display:flex">
                            <div style="width:130px" class="text-overfollow  employee-overfollow" data-container="body"
                                data-toggle="tooltip" data-original-title=" {{ __('messages.position') }}"
                                title="">
                                {{ __('messages.position') }}
                            </div>
                        </div>
                    </th>
                </tr>
            </thead>
            <tbody id="list" class="list_table">
                @if (isset($list[0]))
                    @foreach ($list as $key => $row)
                        <tr class="noneHover" employee_cd="{{ $row['employee_cd'] }}">
                            <td class="text-center lblCheck sticky-cell ">
                                <div id="" class="md-checkbox-v2 inline-block">
                                    <label for="{{ 'ckb0' . $row['employee_cd'] }}" style="width:95%"
                                        class="container checkbox-os0030">
                                        <input name="check-all" class="chk-item"
                                            id="{{ 'ckb0' . $row['employee_cd'] }}" type="checkbox"
                                            {{ ($row['check_box'] ?? '') != '' ? 'checked' : '' }}>
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </td>
                            <td class="sticky-cell employee_cd_er" num="1" style="left: 0px;max-width:80px;min-width: 80px">
                                <div class="text-overfollow employee-overfollow" style="width:95%" data-container="body"
                                    data-toggle="tooltip" data-original-title="" title="">
                                    {{ $row['employee_cd'] }}</div>
                                <input type="hidden" class="tb_employee_cd" value="{{ $row['employee_cd'] }}">
                            </td>
                            <td class="sticky-cell" num="2" style="left: 0px;max-width:150px;min-width: 150px">
                                <div class="text-overfollow  employee-overfollow" data-container="body"
                                    data-toggle="tooltip" data-original-title="{{ $row['employee_nm'] }}"
                                    title="">{{ $row['employee_nm'] }}</div>
                            </td>
                            <td class="" num="3" style="left: 0px;max-width:150px;min-width: 150px">
                                <div class="text-overfollow  employee-overfollow" style="width:95%"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_typ_nm'] }}" title="">
                                    {{ $row['employee_typ_nm'] }}</div>
                            </td>

                            @isset($organization_group)
                                @foreach ($organization_group as $key => $item)
                                    <td class="" num="3" style="left: 0px;max-width:150px;min-width: 150px">
                                        <div class="text-overfollow  employee-overfollow" style="width:95%"
                                            data-container="body" data-toggle="tooltip"
                                            data-original-title="{{ $row['organization_nm_' . ($key + 1)] ?? '' }}"
                                            title="">
                                            {{ $row['organization_nm_' . ($key + 1)] ?? '' }}</div>
                                    </td>
                                @endforeach
                            @endisset
                            <td class="" num="5" style="left: 0px;max-width:150px;min-width: 150px">
                                <div class="text-overfollow  employee-overfollow" style="width:95%"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['position_nm'] }}" title="">
                                    {{ $row['position_nm'] }}</div>
                            </td>
                            @php
                                $viewers = json_decode(htmlspecialchars_decode($row['list_viewer']), true);
                                $list_viewer_employee_nm = '';
                            @endphp
                            <td class="color-error" num="4" style="left: 0px;max-width:800px;min-width: 800px">
                                <div class="list_viewer_employee_cd">
                                    @if (isset($viewers) && !empty($viewers))
                                        @foreach ($viewers as $key => $viewer)
                                            <input type="hidden" class="viewer_employee_cd"
                                                value="{{ $viewer['viewer_employee_cd'] }}">
                                            @php
                                                $list_viewer_employee_nm .= $viewer['viewer_employee_nm'];
                                                if (next($viewers) == true) {
                                                    $list_viewer_employee_nm .= '、';
                                                }
                                            @endphp
                                        @endforeach
                                    @endif
                                </div>
                                <div class="text-overfollow  list_viewer_employee_nm" style="width:95%"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $list_viewer_employee_nm }}" title="">
                                    {{ $list_viewer_employee_nm }}
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
    </div>
