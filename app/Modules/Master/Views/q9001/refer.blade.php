<nav class="pager-wrap row">
    {!! Paging::show($paging ?? []) !!}
</nav>
<div class="table-responsive wmd-view table-fixed-header" style="height: 450px;">
    <table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder"
        style="table-layout: fixed;" id="tbl-data">
        <thead>
            <tr>
                <th style="width:10%;">{{ __('q9001.employee_number') }}</th>
                <th style="width:20%;">{{ __('q9001.employee_name') }}</th>
                <th style="width:30%;">{{ __('q9001.my_purpose') }}</th>
                <th style="width:40%;">{{ __('messages.reasion_for_setting') }}</th>
            </tr>
        </thead>
        <tbody>
            @if (isset($purposes) && !empty($purposes))
                @foreach ($purposes as $purpose)
                    <tr>
                        <td>
                            <div data-toggle="tooltip" title=""
                                class="text-overfollowlink">
                                {{ $purpose['employee_cd'] }}
                            </div>
                        </td>
                        <td>
                            <div data-toggle="tooltip" class="text-overfollow text-left" data-container="body" data-html="true"
                            data-toggle="tooltip" data-original-title="{{ $purpose['employee_nm'] }}">
                                {{ $purpose['employee_nm'] }}
                            </div>
                        </td>
                        <td>
                            <div class="text-overfollow text-left" data-container="body" data-html="true"
                                data-toggle="tooltip" data-original-title="{{ $purpose['mypurpose'] }}">
                                {{ $purpose['mypurpose'] }}
                            </div>
                        </td>
                        <td>
                            <div class="text-overfollow text-left" data-container="body" data-html="true"
                                data-toggle="tooltip" data-original-title="{{ $purpose['comment'] }}">
                                {{ $purpose['comment'] }}
                            </div>
                        </td>

                    </tr>
                @endforeach
            @else
                <tr class="tr-nodata">
                    <td colspan="4" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                </tr>
            @endif
        </tbody>
    </table>
</div><!-- end .table-responsive -->