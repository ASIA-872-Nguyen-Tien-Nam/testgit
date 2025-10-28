<div class="card">
    <div class="card-body">
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
            <table class="table sortable table-bordered table-hover fixed-header table-striped" id="myTable" style="min-width: 1200px">
                <thead>
                <tr>
                    <th class="w-80px">{{ __('messages.employee_no') }}</th>
                    <th class="w-120px">{{ __('messages.employee_name') }}</th>
                    @isset($M0022)
                        @foreach ($M0022 as $item)
                        <th class="w-160px invi_head">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ $item['organization_group_nm'] }}">{{ $item['organization_group_nm'] }}</div>
                        </th>
                        @endforeach
                    @endisset
                    <th class="w-120px">{{ __('messages.position') }}</th>
                </tr>
                </thead>
                <tbody>
                    @if(isset($views[0]))
                        @foreach ($views as $view)
                        <tr class="tr_employee" employee_cd="{{ $view['employee_cd'] ?? '' }}">
                            <td>
                                <label class="form-control-plaintext txt" style="cursor: pointer;">
                                    <div>
                                        <a href="javascript:void(0);" class="employee_link">
                                            {{ $view['employee_cd'] }}
                                        </a>
                                    </div>
                                </label>
                            </td>
                            <td>
                                <label class="text-overfollow"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $view['employee_nm'] }}"
                                    style="display: block;width: 180px;">
                                    {{ $view['employee_nm'] }}
                                </label>
                            </td>
                            @isset($M0022)
                                @foreach ($M0022 as $item)
                                <td>
                                    <label class="text-overfollow"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{ $view['belong_nm_'.$item['organization_typ']] }}"
                                        style="display: block; width: 233px;">
                                        {{ $view['belong_nm_'.$item['organization_typ']] }}
                                    </label>
                                </td>
                                @endforeach
                            @endisset
                            <td>
                                <label class="text-overfollow"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{ $view['position_nm'] }}"
                                    style="display: block;width: 180px;">
                                    {{ $view['position_nm'] }}
                                </label>
                            </td>
                        </tr>
                        @endforeach
                    @else
                        <tr class="tr-nodata">
                            <td colspan="{{ 10 + count($M0022) }}" class="w-popup-nodata no-hover text-center">
                                {{ $_text[21]['message'] }}</td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .row -->
    </div>
</div>