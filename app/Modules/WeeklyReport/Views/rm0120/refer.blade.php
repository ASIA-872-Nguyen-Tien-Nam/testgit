<div class="card pe-w">
    <div class="card-body">
        <div>
            <div class="row" style="margin-left : -10px">
                <div class="col-sm-12 col-md-12 col-lg-4 col-xl-4">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                            style="white-space: nowrap;">{{ __('rm0110.kinds') }}</label>
                        <div style="padding-left: 0px">
                            <span class="num-length">
                                <select id="mark_kbn" tabindex="1" class="form-control required">
                                    @if (isset($data_select[0]))
                                        @foreach ($data_select as $item)
                                            <option value="{{ $item['number_cd'] }}"
                                                {{ ($data_header['mark_kbn'] ?? 1) == $item['number_cd'] ? 'selected' : '' }}>
                                                {{ $item['name'] }}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </span>
                        </div><!-- end .col-md-3 -->
                    </div>
                </div>
                @isset($data_header['check_exits'])
                    <div class="col-2">
                        <div class="form-group">
                            <div style="margin-top: 38px;" class="{{ $data_header['check_exits'] != 1 ? '' : 'd-none' }}">
                                <span style="color: blue;">{{ __('messages.unregistered') }}</span>
                            </div><!-- end .col-md-3 -->
                        </div>
                    </div>
                @endisset
            </div><!-- end .col-md-12 -->
            <div class="row" style="margin-left : -10px">
                <div class="col-md-12 col-lg-5 col-xl-5">
                    <div class="form-group">
                        <div>
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.name') }}</label>
                        </div>
                        <span class="num-length">
                            <input type="hidden" id="check_exits" value={{ $data_header['check_exits'] ?? 0 }}>
                            <input type="text" id="name" class="form-control required" placeholder=""
                                maxlength="20" value="{{ $data_header['name'] ?? '' }}" tabindex="2">
                        </span>
                    </div>
                </div>
                <div class="col-md-12 col-lg-7 col-xl-7">
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.mark_type') }}&nbsp;
                        </label>
                        <div class="radio" id="mark_typ">
                            @if (isset($data_radio[0]))
                                @foreach ($data_radio as $key => $item)
                                    <div class="md-radio-v2 inline-block">
                                        <input name="mark_typ1" type="radio" class="mark_typ"
                                            id="YY{{ $key }}" checked
                                            value="{{ $item['number_cd'] }}" maxlength="3">
                                        <label for="YY{{ $key }}" tabindex="3">{{ $item['name'] }}</label>
                                    </div>
                                @endforeach
                            @endif
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
            </div><!-- end .col-md-12 -->
            <div class="row" id="body-inner">
                <div class="col-md-12 col-lg-8 col-xl-6">
                    <div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells"
                        style="" id="table_detail">
                        <table class="table table-bordered table-hover fixed-header" id="table-data"
                            style="width: 83%;">
                            <thead>
                                <tr>
                                    <th  style="width: 25%;" class="text-center w-size">{{ __('messages.mark') }}</th>
                                    <th style="width: 55%;" class="text-center">{{ __('messages.content') }}</th>
                                    <th style="width: 20%;" class="text-center show">{{ __('messages.points') }}</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($data_image2 as $item_no => $row)
                                    <tr class="tr mark_typ_2" style="height: 68px;">
                                        <td class="mid-cate text-center">
                                            <span><img class="img"
                                                    src="/template/image/icon/weeklyreport/{{ $row['remark1'] }}"
                                                    /></span>
                                        </td>
                                        <td class="mid-cate">
                                            <span>{{ $row['name'] }}</span>
                                        </td>
                                        <td class="text-right show">
                                            <input type="text" class="hidden point"
                                                value="{{ (float) $points[$item_no] }}">
                                            {{ (float) $points[$item_no] }}
                                        </td>
                                    </tr>
                                @endforeach
                                @foreach ($data_image3 as $item_no => $row)
                                    <tr class="tr mark_typ_3 d-none" style="height: 68px;">
                                        <td class="mid-cate text-center">
                                            <span><img class="img"
                                                    src="/template/image/icon/weeklyreport/{{ $row['remark1'] }}"
                                                    /></span>
                                        </td>
                                        <td class="mid-cate">
                                            <span>{{ $row['name'] }}</span>
                                        </td>
                                        <td class="text-right show hide">
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div>
            </div>
        </div>
        <div class="row justify-content-md-center">
            {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
        </div>
    </div>
</div>
