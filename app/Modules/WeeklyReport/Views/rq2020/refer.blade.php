<div id="result">
    <div class="card-body p-0 pt-2" style="padding-top: 4px;">
        <div class="row">
            <div class="col-sm-12 col-lg-6 col-xl-6" style="padding-left: 32px;padding-top:26px">
                <div class="table-bordered" style="height: 98.9%; padding:24px;">
                    <div
                        class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells ">
                        <table style=""
                            class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder member-list"
                            id="myTable">
                            <thead>
                                <tr>
                                    <th style="min-width: 120px;max-width:120px">{{ __('rdashboard.title') }}</th>
                                    <th style="min-width: 70px;max-width: 90px;">{{ __('rq2020.fullfillment') }}
                                    </th>
                                    <th style="min-width: 70px;max-width: 90px;">{{ __('rq2020.business') }}</th>
                                    <th style="min-width: 70px;max-width: 90px;">{{ __('rq2020.other') }}</th>
                                    <th colspan="2" style="min-width: 290px;max-width:290px">
                                        {{ __('rq2020.content') }}</th>
                                </tr>
                            </thead>
                            <tbody>
                                @if (isset($reports) && count($reports) > 0)
                                    @foreach ($reports as $time)
                                        <tr class="tr_employee">
                                            <td class="w-120px invi_head">
                                                <label class="form-control-plaintext txt {{ $time['can_link'] == 1?'weekly_tab': ''}}"
                                                    fiscal_year="{{ $time['fiscal_year'] }}"
                                                    employee_cd="{{ $time['employee_cd'] }}"
                                                    report_kind="{{ $time['report_kind'] }}"
                                                    report_no="{{ $time['report_no'] }}">
                                                    <div class="text-overfollow" data-container="body" data-html="true"
                                                        data-toggle="tooltip"
                                                        data-original-title="{!! nl2br($time['title']) !!}">
                                                        @if ($time['can_link'] == 1)
                                                        <a style="" href=""> {{ $time['title'] }}</a>
                                                        @else
                                                            <span> {{ $time['title'] }}</span>
                                                        @endif
                                                    </div>
                                                </label>
                                            </td>
                                            <td class="w-40px invi_head text-center" style="min-width: 70px;">
                                                @if (isset($time['adequacy_kbn']) && $time['adequacy_kbn'] > 0)
                                                    @if (isset($adequacy) && !empty($adequacy))
                                                        @foreach ($adequacy as $item)
                                                            @if ($item['mark_cd'] == $time['adequacy_kbn'])
                                                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}"
                                                                    width=30px />
                                                            @endif
                                                        @endforeach
                                                    @endif
                                                @else
                                                    <span></span>
                                                @endif
                                            </td>
                                            <td class="w-40px invi_head text-center" style="min-width: 70px;">
                                                @if (isset($time['busyness_kbn']) && $time['busyness_kbn'] > 0)
                                                    @if (isset($busyness) && !empty($busyness))
                                                        @foreach ($busyness as $item)
                                                            @if ($item['mark_cd'] == $time['busyness_kbn'])
                                                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}"
                                                                    width=30px />
                                                            @endif
                                                        @endforeach
                                                    @endif
                                                @else
                                                    <span></span>
                                                @endif
                                            </td>
                                            <td class="w-40px invi_head text-center" style="min-width: 70px;">

                                                @if (isset($time['other_kbn']) && $time['other_kbn'] > 0)
                                                    @if (isset($other) && !empty($other))
                                                        @foreach ($other as $item)
                                                            @if ($item['mark_cd'] == $time['other_kbn'])
                                                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}"
                                                                    width=30px />
                                                            @endif
                                                        @endforeach
                                                    @endif
                                                @else
                                                    <span></span>
                                                @endif
                                            </td>
                                            <td class="text-left" style="max-width:145px;">
                                                <label class="form-control-plaintext txt">
                                                    <div class="text-overfollow" data-container="body" data-html="true"
                                                        data-toggle="tooltip"
                                                        data-original-title="{{ $time['question'] }}">
                                                        {{ $time['question'] }}
                                                    </div>
                                                </label>
                                            </td>
                                            <td class="text-left" style="max-width:145px;">
                                                <label class="form-control-plaintext txt">
                                                    <div class="text-overfollow" data-container="body" data-html="true"
                                                        data-toggle="tooltip"
                                                        data-original-title="{{ $time['answer'] }}">
                                                        {{ $time['answer'] }}
                                                    </div>
                                                </label>
                                            </td>
                                        </tr>
                                    @endforeach
                                @else
                                    <tr class="tr_employee">
                                        <td colspan="100%" class="text-center" style="max-width:145px;">
                                            {{ $_text[21]['message'] }}
                                        </td>
                                    </tr>
                                @endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            {{-- LIST RIGHT --}}
            <div class="col-sm-12 col-lg-6 col-xl-6" style="padding-left: 32px;padding-right: 32px;">
                @if (isset($target) && !empty($target))
                    @if ($target['target1_use_typ'] == 1)
                        <p class="label_right_block">{{ $target['target1_nm'] }}</p>
                        <div class="table-bordered right_block" data-container="body" data-html="true">
                            {{ $target['target1'] }}
                        </div>
                    @endif
                    @if ($target['target2_use_typ'] == 1)
                        <p class="label_right_block">{{ $target['target2_nm'] }}</p>
                        <div class="table-bordered right_block" data-container="body" data-html="true">
                            {{ $target['target2'] }}
                        </div>
                    @endif
                    @if ($target['target3_use_typ'] == 1)
                        <p class="label_right_block">{{ $target['target3_nm'] }}</p>
                        <div class="table-bordered right_block" data-container="body" data-html="true">
                            {{ $target['target3'] }}
                        </div>
                    @endif
                    @if ($target['target4_use_typ'] == 1)
                        <p class="label_right_block">{{ $target['target4_nm'] }}</p>
                        <div class="table-bordered right_block" data-container="body" data-html="true">
                            {{ $target['target4'] }}
                        </div>
                    @endif
                    @if ($target['target5_use_typ'] == 1)
                        <p class="label_right_block">{{ $target['target5_nm'] }}</p>
                        <div class="table-bordered right_block" data-container="body" data-html="true">
                            {{ $target['target5'] }}
                        </div>
                    @endif

                @endif
            </div>
        </div>
    </div><!-- end .card-body -->
</div>
