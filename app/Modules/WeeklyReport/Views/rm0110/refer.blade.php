@if (empty($data_header))
    <div class="row" style="margin-left : -10px">
        <div class="col-md-3 col-lg-2 col-xl-2">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                    style="white-space: nowrap;">{{ __('rm0110.kinds') }}</label>
                <div style="padding-left: 0px">
                    <span class="num-length">
                        <select id="mark_kbn" tabindex="1" class="form-control required" autofocus>
                            @if (isset($data_select[0]))
                                @foreach ($data_select as $item)
                                    <option value="{{ $item['number_cd'] }}"
                                        {{ ($data_name[0]['mark_kbn'] ?? 1) == $item['number_cd'] ? 'selected' : '' }}>
                                        {{ $item['name'] }}</option>
                                @endforeach
                            @endif
                        </select>
                    </span>
                </div><!-- end .col-md-3 -->
            </div>
        </div>
        <div class="col-md-3 col-lg-2 col-xl-2">
            <div class="form-group">
                <div>
                    <label class="control-label lb-required"
                        lb-required="{{ __('messages.required') }}">{{ __('messages.name') }}</label>
                </div>
                <span class="num-length">
                    <input type="text" id="name" class="form-control required" placeholder="" maxlength="10"
                        value="{{ $data_name[0]['name'] ?? '' }}" tabindex="2">
                </span>
            </div>
        </div>
        <div class="col-md-6 col-lg-8 col-xl-8">
            <div class="form-group">
                <label class="control-label">{{ __('messages.mark_type') }}&nbsp;
                </label>
                <div class="radio" id="mark_typ">
                    @if (isset($data_radio[0]))
                        @foreach ($data_radio as $key => $item)
                            <div class="md-radio-v2 inline-block">
                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY{{ $key }}"
                                    {{ $item['number_cd'] == ($data_name[0]['mark_type'] ?? 1) ? 'checked' : '' }}
                                    value="{{ $item['number_cd'] }}" maxlength="3">
                                <label for="YY{{ $key }}" tabindex="3">{{ $item['name'] }}</label>
                            </div>
                        @endforeach
                    @endif
                    <span style="color: blue; margin-left: 20px;">{{ __('messages.unregistered') }}</span>
                </div>
            </div>
            <!--/.form-group -->
        </div>
    </div><!-- end .col-md-12 -->
@else
    <div class="row" style="margin-left : -10px">
        <div class="col-md-3 col-lg-2 col-xl-2">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                    style="white-space: nowrap;">{{ __('rm0110.kinds') }}</label>
                <div style="padding-left: 0px">
                    <span class="num-length">
                        <select id="mark_kbn" tabindex="1" class="form-control required" autofocus>
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
        <div class="col-md-3 col-lg-2 col-xl-2">
            <div class="form-group">
                <div>
                    <label class="control-label lb-required"
                        lb-required="{{ __('messages.required') }}">{{ __('messages.name') }}</label>
                </div>
                <span class="num-length">
                    <input type="text" id="name" class="form-control required" placeholder="" maxlength="10"
                        value="{{ $data_header['name'] ?? 'ssssss' }}" tabindex="2">
                </span>
            </div>
        </div>
        <div class="col-md-6 col-lg-8 col-xl-8">
            <div class="form-group">
                <label class="control-label">{{ __('messages.mark_type') }}&nbsp;
                </label>
                <div class="radio" id="mark_typ">
                    @if (isset($data_radio[0]))
                        @foreach ($data_radio as $key => $item)
                            <div class="md-radio-v2 inline-block">
                                <input name="mark_typ1" type="radio" class="mark_typ" id="YY{{ $key }}"
                                    {{ $item['number_cd'] == ($data_header['mark_type'] ?? 1) ? 'checked' : '' }}
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
@endif

<div class="row">
    <div class="col-md-12">
        <div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells" style=""
            id="table_detail">
            <table class="table table-bordered table-hover fixed-header" id="table-data">
                <thead>
                    <tr>
                        <th class="text-center" style="width:8%">{{ __('messages.mark') }}</th>
                        <th class="text-center" style="width:85%">{{ __('messages.content') }} </th>
                        <th class="text-center" style="width:7%">{{ __('messages.points') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($data_table as $item_no => $row)
                        @php
                            $placeholder = '';
                            switch ($item_no) {
                                case 0:
                                    if ($data_name[0]['mark_kbn'] == 1) {
                                        $placeholder = trans('rm0110.substantial');
                                    } elseif ($data_name[0]['mark_kbn'] == 2) {
                                        $placeholder = trans('rm0110.spare');
                                    } else {
                                        $placeholder = '';
                                    }
                                    break;
                                case 1:
                                    if ($data_name[0]['mark_kbn'] == 1) {
                                        $placeholder = trans('rm0110.fulfilling');
                                    } elseif ($data_name[0]['mark_kbn'] == 2) {
                                        $placeholder = trans('rm0110.right');
                                    } else {
                                        $placeholder = '';
                                    }
                                    break;
                                case 2:
                                    if ($data_name[0]['mark_kbn'] == 1) {
                                        $placeholder = trans('rm0110.very_fulfilling');
                                    } elseif ($data_name[0]['mark_kbn'] == 2) {
                                        $placeholder = trans('rm0110.busy');
                                    } else {
                                        $placeholder = '';
                                    }
                                    break;
                                case 3:
                                    if ($data_name[0]['mark_kbn'] == 1) {
                                        $placeholder = trans('rm0110.fulfilling_1');
                                    } elseif ($data_name[0]['mark_kbn'] == 2) {
                                        $placeholder = trans('rm0110.very_busy');
                                    } else {
                                        $placeholder = '';
                                    }
                                    break;
                                default:
                                    $placeholder = '';
                                    break;
                            }
                        @endphp
                        <tr class="tr">
                            <td class="mid-cate text-center">
                                <input type="text" class="hidden item_no" value="{{ $item_no * 1 + 1 }}">
                                <input type="text" class="hidden mark_cd" value="{{ $item_no * 1 + 1 }}">
                                <span><img src="/template/image/icon/weeklyreport/{{ $row['remark1'] }}"
                                        width=50px /></span>
                            </td>
                            <td>
                                <span class="num-length">
                                    <textarea tabindex="4" class="form-control explanation" cols="30" rows="3" maxlength="50">{{ ($row['explanation'] ?? '') == '' ? $placeholder : $row['explanation'] ?? '' }}</textarea>
                                </span>
                            </td>
                            <td class="text-right">
                                <input type="text" class="hidden point" value="{{ (float) $row['point'] }}">
                                {{ (float) $row['point'] }}
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div
