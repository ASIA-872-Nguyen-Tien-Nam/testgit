<nav class="pager-wrap row">
    {!! Paging::show($paging) !!}
</nav>
<div class="row">
    <div class="col-md-12">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
    <table class="table sortable table-bordered table-hover fixed-header table-striped" id="myTable">
        <thead>
            <tr>
                <th class="w-50px">
                    <div id="checkboxAll" class="md-checkbox-v2 inline-block">
                        <input name="check-all" class="check_all" id="check-all" type="checkbox">
                        <label for="check-all"></label>
                    </div>
                </th>
                @php
                @endphp
                <th class="w-80px">{{ __('messages.employee_no') }}</th>
                <th class="w-160px">{{ __('messages.employee_name') }}</th>
                <th class="w-160px invi_head">{{ __('messages.employee_classification') }}</th>
                {{-- <th class="w-120px">{{ __('messages.org') }}1</th>
                <th class="w-120px">{{ __('messages.org') }}2</th>
                <th class="w-120px">{{ __('messages.org') }}3</th>
                <th class="w-120px">{{ __('messages.org') }}4</th>
                <th class="w-120px">{{ __('messages.org') }}5</th> --}}
                @if (isset($group_typ[0]))
                    @if ($group_typ[0]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                data-original-title="{{ $group_typ[0]['organization_group_nm'] }}"
                                style="margin-bottom: .5rem;">{{ $group_typ[0]['organization_group_nm'] }}</div>
                        </th>
                    @endif
                    @if ($group_typ[1]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                data-original-title="{{ $group_typ[1]['organization_group_nm'] }}"
                                style="margin-bottom: .5rem;">{{ $group_typ[1]['organization_group_nm'] }}</div>
                        </th>
                    @endif
                    @if ($group_typ[2]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                data-original-title="{{ $group_typ[2]['organization_group_nm'] }}"
                                style="margin-bottom: .5rem;">{{ $group_typ[2]['organization_group_nm'] }}</div>
                        </th>
                    @endif
                    @if ($group_typ[3]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                data-original-title="{{ $group_typ[3]['organization_group_nm'] }}"
                                style="margin-bottom: .5rem;">{{ $group_typ[3]['organization_group_nm'] }}</div>
                        </th>
                    @endif
                    @if ($group_typ[4]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                data-original-title="{{ $group_typ[4]['organization_group_nm'] }}"
                                style="margin-bottom: .5rem;">{{ $group_typ[4]['organization_group_nm'] }}</div>
                        </th>
                    @endif
                @endif
                <th class="w-120px invi_head">{{ __('messages.job') }}</th>
                <th class="w-120px ">{{ __('messages.position') }}</th>
                <th class="w-120px ">{{ __('messages.grade') }}</th>
                <th class="w-120px">{{ __('messages.office') }}</th>
                <th class="w-120px">{{ __('messages.user_id') }}</th>
                <th class="w-200px ">{{ __('messages.current_permissions') }}</th>
            </tr>
        </thead>
        <tbody>
            @if (isset($list[0]))
                @foreach ($list as $row)
                    <tr class="tr_employee">
                        <td class="text-center w-50px">
                            <div class="md-checkbox-v2 inline-block ck-nolabel">
                                <input type="checkbox" name="ck{{ $row['id'] }}" id="ck{{ $row['id'] }}"
                                    class="chk-item ck{{ $row['employee_cd'] }}">
                                <label for="ck{{ $row['id'] }}"></label>
                                <input type="hidden" class="tb_employee_cd" value="{{ $row['employee_cd'] }}" />
                            </div>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_cd'] }}">
                                    {{ $row['employee_cd'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_nm'] }}">
                                    {{ $row['employee_nm'] }}
                                </div>
                            </label>

                        </td>
                        <td class="w-120px invi_head">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['employee_typ_nm'] }}">
                                    {{ $row['employee_typ_nm'] }}
                                </div>
                            </label>
                        </td>
                        @if ($group_typ[0]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['organization_nm_1'] }}">
                                        {{ $row['organization_nm_1'] }}
                                    </div>
                                </label>
                            </td>
                        @endif
                        @if ($group_typ[1]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['organization_nm_2'] }}">
                                        {{ $row['organization_nm_2'] }}
                                    </div>
                                </label>
                            </td>
                        @endif
                        @if ($group_typ[2]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['organization_nm_3'] }}">
                                        {{ $row['organization_nm_3'] }}
                                    </div>
                                </label>
                            </td>
                        @endif
                        @if ($group_typ[3]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['organization_nm_4'] }}">
                                        {{ $row['organization_nm_4'] }}
                                    </div>
                                </label>
                            </td>
                        @endif
                        @if ($group_typ[4]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['organization_nm_5'] }}">
                                        {{ $row['organization_nm_5'] }}
                                    </div>
                                </label>
                            </td>
                        @endif
                        <td class="w-120px invi_head">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['job_nm'] }}">
                                    {{ $row['job_nm'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['position_nm'] }}">
                                    {{ $row['position_nm'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['grade_nm'] }}">
                                    {{ $row['grade_nm'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['office_nm'] }}">
                                    {{ $row['office_nm'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-120px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['user_id'] }}">
                                    {{ $row['user_id'] }}
                                </div>
                            </label>
                        </td>
                        <td class="w-200px">
                            <label class="form-control-plaintext txt">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $row['authority_nm'] }}">
                                    {{ $row['authority_nm'] }}
                                </div>
                            </label>
                        </td>
                    </tr>
                @endforeach
            @else
                <tr class="tr-nodata">
                    <td colspan="{{ 10 + count($organization_group) }}" class="w-popup-nodata no-hover text-center">
                        {{ $_text[21]['message'] }}</td>
                </tr>
            @endif
            {{-- <tr class="tr_employee">
                <td class="text-center w-50px">
                    <div class="md-checkbox-v2 inline-block ck-nolabel">
                        <input type="checkbox" name="ck0" id="ck0" class="check_all chk-item">
                        <label for="ck0"></label>
                    </div>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            10
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業　部長
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            正社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業部
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            部長
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            １等級
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
            </tr>
            <tr class="tr_employee">
                <td class="text-center w-50px">
                    <div class="md-checkbox-v2 inline-block ck-nolabel">
                        <input type="checkbox" name="ck1" id="ck1" class="check_all chk-item">
                        <label for="ck1"></label>
                    </div>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            101
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            中村　健
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            正社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業部
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業一課
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            課長
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            ３等級
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
            </tr>
            <tr class="tr_employee">
                <td class="text-center w-50px">
                    <div class="md-checkbox-v2 inline-block ck-nolabel">
                        <input type="checkbox" name="ck2" id="ck2" class="check_all chk-item">
                        <label for="ck2"></label>
                    </div>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            1011
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            社員　花子
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            正社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業部
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業一課
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            一般社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            ６等級
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
            </tr>
            <tr class="tr_employee">
                <td class="text-center w-50px">
                    <div class="md-checkbox-v2 inline-block ck-nolabel">
                        <input type="checkbox" name="ck3" id="ck3" class="check_all chk-item">
                        <label for="ck3"></label>
                    </div>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            1012
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            西川
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            正社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業部
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業一課
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            一般社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            ８等級
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
            </tr>
            <tr class="tr_employee">
                <td class="text-center w-50px">
                    <div class="md-checkbox-v2 inline-block ck-nolabel">
                        <input type="checkbox" name="ck4" id="ck4" class="check_all chk-item">
                        <label for="ck4"></label>
                    </div>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            102
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            松本
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            正社員
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業部
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業二課
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            営業
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            課長
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div>
                            ５等級
                        </div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
                <td>
                    <label class="form-control-plaintext txt">
                        <div></div>
                    </label>
                </td>
            </tr> --}}
        </tbody>
    </table>
</div>
