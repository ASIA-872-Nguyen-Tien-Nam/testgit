<nav class="pager-wrap row">
    {!! Paging::show($paging_right ?? []) !!}
</nav>
<div class="table-responsive wmd-view sticky-table sticky-headers sticky-ltr-cells">
    <table class="table sortable table-bordered table-hover ofixed-boder table-striped" id="myTable">
        <thead>
            <tr>
                <th class="w-50px ">
                    <div id="checkboxAll" class="md-checkbox-v2 inline-block">
                        <label for="check-all" class="container checkbox-os0030">
                            <input name="check-all" class="check_all" id="check-all" type="checkbox" tabindex="11">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </th>
                <th class="w-90px invi_head">{{ __('messages.employee_no') }}</th>
                <th class="w-160px invi_head">{{ __('messages.employee_name') }}</th>
                <th class="w-160px invi_head">{{ __('messages.employee_classification') }}</th>
                @isset($organization_group)
                    @foreach ($organization_group as $item)
                        <th class="w-160px invi_head">
                            {{ $item['organization_group_nm'] }}
                        </th>
                    @endforeach
                @endisset
                <th class="w-120px invi_head">{{ __('messages.job') }}</th>
                <th class="w-120px ">{{ __('messages.position') }}</th>
                <th class="w-120px ">{{ __('messages.grade') }}</th>
            </tr>
        </thead>
        <tbody id="table-check">
            @if (isset($employees) && !empty($employees))
                @foreach ($employees as $row)
                    <tr class="tr_employee">
                        <td class="text-center w-50px check-color">
                            <div class="md-checkbox-v2 ck-nolabel">
                                <label for="ck{{ $row['employee_cd'] ?? '' }}" class="container checkbox-os0030-body">
                                    <input type="checkbox" tabindex="12" name="ck{{ $row['employee_cd'] ?? '' }}"
                                        id="ck{{ $row['employee_cd'] ?? '' }}"
                                        class="chk-item ck{{ $row['employee_cd'] ?? '' }}"
                                        {{ ($row['check_box'] ?? 0) == 1 ? 'checked' : '' }}>
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </td>
                        <td class="w-90px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_cd'] ?? '' }}">
                                    {{ $row['employee_cd'] ?? '' }}
                                </div>
                            </label>
                            <input type="hidden" class="tb_employee_cd" value="{{ $row['employee_cd'] ?? '' }}">
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_nm'] ?? '' }}">
                                    {{ $row['employee_nm'] ?? '' }}
                                </div>
                            </label>

                        </td>
                        <td class="w-120px invi_head">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_typ_nm'] ?? '' }}">
                                    {{ $row['employee_typ_nm'] ?? '' }}
                                </div>
                            </label>
                        </td>
                        @isset($organization_group)
                            @foreach ($organization_group as $key => $item)
                                <td class="w-120px invi_head XXX">
                                    <label class="form-control-plaintext txt">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                            data-original-title="{{ $row['organization_nm_' . ($key + 1)] ?? '' }}">
                                            {{ $row['organization_nm_' . ($key + 1)] ?? '' }}
                                        </div>
                                    </label>
                                </td>
                            @endforeach
                        @endisset
                        <td class="w-120px invi_head">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['job_nm'] ?? '' }}">
                                    {{ $row['job_nm'] ?? '' }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['position_nm'] ?? '' }}">
                                    {{ $row['position_nm'] ?? '' }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['grade_nm'] ?? '' }}">
                                    {{ $row['grade_nm'] ?? '' }}
                                </div>
                            </label>
                        </td>
                    </tr>
                @endforeach
            @else
                <tr class="tr-nodata">
                    <td colspan="12" class="w-popup-nodata no-hover text-center">
                        {{ $_text[21]['message'] ?? '' }}</td>
                </tr>
            @endif
        </tbody>
    </table>
</div><!-- end .row -->
