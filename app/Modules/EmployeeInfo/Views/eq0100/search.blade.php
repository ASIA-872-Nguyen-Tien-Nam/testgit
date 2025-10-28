<nav class="pager-wrap row">
    {!! Paging::show($paging) !!}
</nav>
<div class="row">
    <div class="col-md-12">
        {{--<div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells _width">
            <table class="table table-bordered table-hover table-striped fixed-header">--}}
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
<input type="hidden" id="employee_cd" screen="eq0200" hidden>						
            <table class="table sortable table-bordered table-hover fixed-header table-striped" id="myTable">
                <thead>
                <tr>
                    <th class="w-50px ">
                        <div id="checkboxAll" class="md-checkbox-v2 inline-block">
                            <input name="check-all" class="check_all" id="check-all" type="checkbox">
                            <label for="check-all" ></label>
                        </div>
                    </th>
                    <th class="w-50px">{{ __('messages.view') }}</th>
                    <th class="w-120px">{{ __('messages.retirement_category') }}</th>
                    <th class="w-120px">{{ __('messages.employee_no') }}</th>
                    <th class="w-120px">{{ __('messages.employee_name') }}</th>
                    <th class="w-120px">{{ __('messages.employee_classification') }}</th>
                    @if (isset($organization_group))
                        @foreach($organization_group as $item)
                            <th class="w-160px invi_head">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $item['organization_group_nm'] }}">{{ $item['organization_group_nm'] }}</div>
                            </th>
                        @endforeach
                    @endif
                    <th class="w-120px">{{ __('messages.job') }}</th>
                    <th class="w-120px">{{ __('messages.position') }}</th>
                    <th class="w-120px">{{ __('messages.grade') }}</th>
                </tr>
                </thead>
                <tbody>
                @if (isset($views[0]))
                    @foreach ($views as $key => $row)
                        <tr class="tr_employee" employee_cd="{{ $row['employee_cd'] }}">
                            <td class="text-center w-50px">
                                <div class="md-checkbox-v2 inline-block ck-nolabel">
                                    <input type="checkbox" name="chk_{{$key}}" id="chk_{{$key}}" class="check_all chk-item">
                                    <label for="chk_{{$key}}"></label>
                                </div>
                            </td>
                            @if (isset($authority_eq0101) && $authority_eq0101>=1)
                            <td class="text-center w-detail-col2" style="">
                                <a  class="screen_eq0101 ics ics-edit check_all" style="cursor: pointer;">
                                    <span class="ics-inner"  ><i class="fa fa-address-book-o" ></i></span>
                                </a>
                            </td>
                            @else
                            <td class="text-center w-detail-col2" style="">
                                <a  class="ics ics-edit disabled" style="cursor: not-allowed; ">
                                    <span class="ics-inner" style="color: gray;border:1px solid gray" ><i class="fa fa-address-book-o" ></i></span>
                                </a>
                            </td>
                            @endif
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div>
                                        {{ $row['retirement_reason_typ_nm'] ?? ''}}
                                    </div>
                                </label>
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
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['employee_typ_nm'] ?? ''}}">
                                        {{ $row['employee_typ_nm'] ?? ''}}
                                    </div>
                                </label>
                            </td>
                            @if (isset($organization_group))
                                @foreach($organization_group as $item)
                                    @if ($item['organization_step'] == 1)
                                    <td class="w-120px">
                                        <label class="form-control-plaintext txt">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $row['belong_nm_1'] ?? ''}}">
                                                {{ $row['belong_nm_1'] ?? ''}}
                                            </div>
                                        </label>
                                    </td>
                                    @endif
                                    @if ($item['organization_step'] == 2)
                                    <td class="w-120px">
                                        <label class="form-control-plaintext txt">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $row['belong_nm_2'] ?? ''}}">
                                                {{ $row['belong_nm_2'] ?? ''}}
                                            </div>
                                        </label>
                                    </td>
                                    @endif
                                    @if ($item['organization_step'] == 3)
                                    <td class="w-120px">
                                        <label class="form-control-plaintext txt">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $row['belong_nm_3'] ?? ''}}">
                                                {{ $row['belong_nm_3'] ?? ''}}
                                            </div>
                                        </label>
                                    </td>
                                    @endif
                                    @if ($item['organization_step'] == 4)
                                    <td class="w-120px">
                                        <label class="form-control-plaintext txt">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $row['belong_nm_4'] ?? ''}}">
                                                {{ $row['belong_nm_4'] ?? ''}}
                                            </div>
                                        </label>
                                    </td>
                                    @endif
                                    @if ($item['organization_step'] == 5)
                                    <td class="w-120px">
                                        <label class="form-control-plaintext txt">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $row['belong_nm_5'] ?? ''}}">
                                                {{ $row['belong_nm_5'] ?? ''}}
                                            </div>
                                        </label>
                                    </td>
                                    @endif
                                @endforeach
                            @endif
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['job_nm'] ?? ''}}">
                                        {{ $row['job_nm'] ?? ''}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['position_nm'] ?? ''}}">
                                        {{ $row['position_nm'] ?? ''}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $row['grade_nm'] ?? ''}}">
                                        {{ $row['grade_nm'] ?? ''}}
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
                    
                    
                </tbody>
            </table>
</div><!-- end .row -->
