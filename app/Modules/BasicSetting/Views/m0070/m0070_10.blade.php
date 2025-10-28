<input type="text" hidden class="form-control input-sm language" tabindex="9"
    value="{{ $tab_10['language']['language'] ?? 1 }}">
<div class="hidden add_block_tab_11_hidden add_block_tab_11_row ">
    <div class="line-border-bottom border_block hidden" style="border-left:0px !important">
    </div>
    <div class="row">
        <div class="col-xl-1 col-lg-2 col-md-1 col-sm-12 mb_no_padding">
            <div class="form-group">
                <label
                    class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }} {{ $check_lang == 'en' ? 'lable-check' : '' }}">&nbsp;
                </label>
                <div class="full-width">
                    <a href="javascript:;" style="width:70px" class="btn btn-primary btn-basic-setting-menu btn-issue"
                        id="add_block_tab_10_btn" tabindex="1"
                        {{ isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') ? '' : 'hidden' }}>
                        +
                    </a>
                </div><!-- end .full-width -->
            </div>
        </div>
        <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.total_contract_period') }}</label>
                <span class="num-length">
                    <input type="text" id="" class="form-control total_contract_period" value=""
                        maxlength="10" disabled>
                </span>
            </div>
            <!--/.form-group -->
        </div>

        <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.number_of_contract_renewals') }}</label>
                <span class="num-length">
                    <input type="text" id="" class="form-control number_of_contract_renewals" value=""
                        maxlength="10" disabled>
                </span>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 480px">
        <table id="table-data" class="table table-bordered table-hover table-oneheader ofixed-boder table-target table-head"
            style="margin-bottom: 20px !important;">
            <thead>
                <tr>
                    <th class="text-center" style="width: 3%">
                        <span class="item-right">
                            @if (isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == ''))
                                <button class="btn btn-rm blue btn-sm btn-add-new-row_11" id="" tabindex="-1">
                                    <i class="fa fa-plus"></i>
                                </button>
                            @endif
                        </span>
                    </th>
                    <th class="text-center" style="width: 20%;">{{ __('messages.first_employment_start_date') }}</th>
                    <th class="text-center" style="width: 20%;">{{ __('messages.contract_expiration_date') }}</th>
                    <th class="text-center" style="width: 14%;">{{ __('messages.renew_contract?') }}</th>
                    <th class="text-center" style="width: 25%;">{{ __('messages.retire_s_reason') }}</th>
                    <th class="text-center" style="width: 25%;">{{ __('messages.remarks') }}</th>
                    @if (isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == ''))
                        <th style="width: 3%"></th>
                    @endif
                </tr>
            </thead>
            <tbody>
                <tr class="tr tr_tab10" cate_no="1">
                    <td rowspan="1" class="text-center no">1</td>
                    <td rowspan="1" class="low-cate input_date" low_cate_cd="1">
                        <input type="text" hidden class="form-control input-sm detail_no" tabindex="9"
                            value="0">
                        <input type="text" id="" class="form-control employment_contract_no" value="0"
                            hidden>
                        <input type="text" id="" class="form-control contract_no" value="0" hidden>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                    class="form-control input-sm date start_date" placeholder="yyyy/mm/dd"
                                    tabindex="9" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </td>
                    <td rowspan="1" class="low-cate input_date" low_cate_cd="1">
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                    class="form-control input-sm date expiration_date" placeholder="yyyy/mm/dd"
                                    tabindex="9" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent button-date" type="button"
                                        data-dtp="dtp_wH14i" tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </td>
                    <td rowspan="1" class="low-cate" low_cate_cd="1">
                        <span class="num-length">
                            <select {{ $disabled }} {{ $tab_10['disabled_tab10'] }} name=""
                                id="contract_renewal_kbn" class="form-control contract_renewal_kbn" tabindex="1"
                                organization_typ="">
                                <option value="0"></option>
                                @foreach ($tab_10['data_76'] as $data)
                                    <option value="{{ $data['number_cd'] }}">{{ $data['name'] }}</option>
                                @endforeach
                            </select>
                        </span>
                    </td>
                    <td rowspan="1" class="low-cate" low_cate_cd="1">
                        <span class="num-length">
                            <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text" tabindex="9"
                                class="form-control input-sm text-left reason_resignation" value=""
                                maxlength="100" decimal="2">
                        </span>
                    </td>
                    <td rowspan="1" class="low-cate" low_cate_cd="1">
                        <span class="num-length">
                            <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text" tabindex="9"
                                class="form-control input-sm text-left remarks" value="" maxlength="100"
                                decimal="2">
                        </span>
                    </td>
                    <td class="text-center"
                        {{ isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') ? '' : 'hidden' }}>
                        <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row_tab10">
                            <i class="fa fa-remove"></i>
                        </button>
                    </td>
                </tr>
            </tbody>

        </table><!-- /.hidden -->
    </div>
</div>

@foreach ($tab_10['m0088'] as $index => $data)
    <div class="col_tab11 add_block_tab_11_row">
        <div class="row">
            @if (isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == ''))
                <div
                    class="col-xl-1 col-lg-2 col-md-1 col-sm-12 mb_no_padding  {{ $check_lang == 'en' ? 'padding_tab_11' : '' }} ">
                    <div class="form-group">
                        <label
                            class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }} {{ $check_lang == 'en' ? 'lable-check' : '' }}">&nbsp;
                        </label>
                        @if ($index < 1)
                            <div class="full-width">
                                <a href="javascript:;" style="width:70px"
                                    class="btn btn-primary btn-basic-setting-menu btn-issue @if (isset($disabled) &&
                                            (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') &&
                                            $disabled == 'disabled') d-none @endif"
                                    id="add_block_tab_10_btn" tabindex="1"
                                    {{ isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') ? '' : 'hidden' }}>
                                    +
                                </a>
                            </div><!-- end .full-width -->
                        @endif
                    </div>
                </div>
                <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.total_contract_period') }}</label>
                        <span class="num-length">
                            <input type="text" id="" class="form-control total_contract_period"
                                value="{{ $data['total_contract_period'] ?? '' }}" maxlength="10" disabled>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>

                <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.number_of_contract_renewals') }}</label>
                        <span class="num-length">
                            <input type="text" id="" class="form-control number_of_contract_renewals"
                                value="{{ $data['number_of_contract_renewals'] ?? '' }}" maxlength="10" disabled>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            @else
                <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.total_contract_period') }}</label>
                        <span class="num-length">
                            <input type="text" id="" class="form-control total_contract_period"
                                value="{{ $data['total_contract_period'] ?? '' }}" maxlength="10" disabled>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>

                <div class="col-md-4 col-xl-1 col-xs-12 col-lg-4 mb_no_padding" style="min-width:140px">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.number_of_contract_renewals') }}</label>
                        <span class="num-length">
                            <input type="text" id="" class="form-control number_of_contract_renewals"
                                value="{{ $data['number_of_contract_renewals'] ?? '' }}" maxlength="10" disabled>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>

                <div
                    class="col-xl-1 col-lg-2 col-md-1 col-sm-12 mb_no_padding  {{ $check_lang == 'en' ? 'padding_tab_11' : '' }} ">
                    <div class="form-group">
                        <label
                            class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }} {{ $check_lang == 'en' ? 'lable-check' : '' }}">&nbsp;
                        </label>
                        @if ($index < 1)
                            <div class="full-width">
                                <a href="javascript:;" style="width:70px"
                                    class="btn btn-primary btn-basic-setting-menu btn-issue @if (isset($disabled) &&
                                            (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') &&
                                            $disabled == 'disabled') d-none @endif"
                                    id="add_block_tab_10_btn" tabindex="1"
                                    {{ isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') ? '' : 'hidden' }}>
                                    +
                                </a>
                            </div><!-- end .full-width -->
                        @endif
                    </div>
                </div>
            @endif
        </div>
        <div class="wmd-view table-responsive-right table-responsive _width " style="max-height: 480px">
            <table class="table table-bordered table-hover table-oneheader table-target ofixed-boder table-head"
                id="" style="margin-bottom: 20px !important;" id="table-data">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 3%">
                            <span class="item-right">
                                @if (isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == ''))
                                    <button class="btn btn-rm blue btn-sm btn-add-new-row_11" id=""
                                        tabindex="-1">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                @endif
                            </span>
                        </th>
                        <th class="text-center" style="width: 20%;">{{ __('messages.first_employment_start_date') }}
                        </th>
                        <th class="text-center" style="width: 20%;">{{ __('messages.contract_expiration_date') }}
                        </th>
                        <th class="text-center" style="width: 14%;">{{ __('messages.renew_contract?') }}</th>
                        <th class="text-center" style="width: 25%;">{{ __('messages.retire_s_reason') }}</th>
                        <th class="text-center" style="width: 25%;">{{ __('messages.remarks') }}</th>
                        @if (isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == ''))
                            <th style="width: 3%"></th>
                        @endif
                    </tr>
                </thead>
                <tbody>
                    @php
                        $json = html_entity_decode($data['detail_json'] ?? []);
                        $array = json_decode($json, true) ?? [];
                    @endphp
                    @foreach ($array as $i => $row)
                        <tr class="tr tr_tab10" cate_no="1">
                            <td rowspan="1" class="text-center no">{{ $i + 1 }}</td>
                            <td rowspan="1" class="low-cate text-center input_date" low_cate_cd="1">
                                <input type="text" hidden class="form-control input-sm detail_no" tabindex="9"
                                    value="{{ $row['detail_no'] }}">
                                <input type="text" id="" class="form-control employment_contract_no"
                                    value="{{ $row['employment_contract_no'] ?? 0 }}" hidden>
                                <input type="text" id="" class="form-control contract_no"
                                    value="{{ $row['employment_contract_no'] ?? 0 }}" hidden>
                                @if (isset($disabled) && $disabled == '')
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                                class="form-control input-sm date start_date" placeholder="yyyy/mm/dd"
                                                tabindex="9" value="{{ $row['start_date'] ?? '' }}">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent button-date" type="button"
                                                    data-dtp="dtp_wH14i" tabindex="-1"
                                                    style="background: none !important"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                @else
                                    {{ $row['start_date'] ?? '' }}
                                @endif
                            </td>
                            <td rowspan="1" class="low-cate text-center input_date" low_cate_cd="1">
                                @if (isset($disabled) && $disabled == '')
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                                class="form-control input-sm date expiration_date"
                                                placeholder="yyyy/mm/dd" tabindex="9"
                                                value="{{ $row['expiration_date'] ?? '' }}">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent button-date" type="button"
                                                    data-dtp="dtp_wH14i" tabindex="-1"
                                                    style="background: none !important"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                @else
                                    {{ $row['expiration_date'] ?? '' }}
                                @endif
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1">
                                @if (isset($disabled) && $disabled == '')
                                    <span class="num-length">

                                        <select {{ $disabled }} {{ $tab_10['disabled_tab10'] }} name=""
                                            id="contract_renewal_kbn" class="form-control contract_renewal_kbn"
                                            tabindex="1" organization_typ="">
                                            <option value="0"></option>
                                            @foreach ($tab_10['data_76'] as $data)
                                                <option value="{{ $data['number_cd'] }}"
                                                    {{ $data['number_cd'] == ($row['contract_renewal_kbn'] ?? 0) ? 'selected' : '' }}>
                                                    {{ $data['name'] }}</option>
                                            @endforeach
                                        </select>
                                    </span>
                                @else
                                    {{ $row['contract_renewal_kbn_nm'] ?? '' }}
                                @endif
                            </td>
                            @if (isset($disabled) && $disabled == '')
                                <td rowspan="1" class="low-cate" low_cate_cd="1">
                                    <span class="num-length">
                                        <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                            tabindex="9" class="form-control input-sm text-left reason_resignation"
                                            value="{{ $row['reason_resignation'] ?? '' }}" maxlength="100"
                                            decimal="2">
                                    </span>
                                </td>
                            @else
                                <td class="">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        title="{{ $row['reason_resignation'] ?? '' }}"
                                        style="width: 390px;min-width: -webkit-fill-available;">
                                        {{ $row['reason_resignation'] ?? '' }}
                                    </div>
                                </td>
                            @endif
                            @if (isset($disabled) && $disabled == '')
                                <td rowspan="1" class="low-cate" low_cate_cd="1">
                                    <span class="num-length">
                                        <input {{ $disabled }} {{ $tab_10['disabled_tab10'] }} type="text"
                                            tabindex="9" class="form-control input-sm text-left remarks"
                                            value="{{ $row['remarks'] ?? '' }}" maxlength="100" decimal="2">
                                    </span>
                                </td>
                            @else
                                <td class="">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        title="{{ $row['remarks'] ?? '' }}"
                                        style="width: 390px;min-width: -webkit-fill-available;">
                                        {{ $row['remarks'] ?? '' }}
                                    </div>
                                </td>
                            @endif
                            </td>
                            <td class="text-center"
                                {{ isset($disabled) && $disabled == '' && (isset($tab_10['disabled_tab10']) && $tab_10['disabled_tab10'] == '') ? '' : 'hidden' }}>
                                <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row_tab10">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
@endforeach
