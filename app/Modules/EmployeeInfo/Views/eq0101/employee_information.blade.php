<div class="tab-pane fade {{ isset($disabled) && $disabled == '' ? '' : 'active show' }}" id="tab2">
    <div class="row">
        <div class="col-md-6 col-lg-4 col-xl-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.email') }}
                </label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input type="text" class="form-control mail" id="mail" maxlength="50" tabindex="1"
                            value="{{ $table2['mail'] ?? '' }}" tabindex="10" disabled>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled="">@</button>
                        </div>
                    </div>
                </span>
            </div>
        </div>
        <div class="col-md-6 col-lg-4 col-xl-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.company_mobile_number') }}</label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input type="text" tabindex="1" class="form-control tel" id="tel" maxlength="20"
                            tabindex="7" value="{{ $table2['company_mobile_number'] ?? '' }}" disabled>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled=""><i
                                    class="fa fa-phone"></i></button>
                        </div>
                    </div>
                </span>
            </div>
        </div>
        <div class="col-md-6 col-lg-4 col-xl-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.extension_number') }}</label>
                <span class="num-length">
                    <div class="input-group-btn">
                        <input type="text" tabindex="1" class="form-control tel_extends tel" id="tel_extends"
                            maxlength="20" tabindex="7" value="{{ $table2['extension_number'] ?? '' }}" disabled>
                    </div>
                </span>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.retire_date') }}
                </label>
                <div data-toggle="tooltip" data-original-title="{{ $table2['company_out_dt'] ?? '' }}">
                    <input type="text" class="form-control input-sm date right-radius" tabindex="1"
                        id="company_out_dt" value="{{ $table2['company_out_dt'] ?? '' }}" disabled=""
                        style="text-align: center;" disabled>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-xl-7 col-xs-12 col-lg-3">
            <label class="control-label">{{ __('messages.retire_s_reason') }}&nbsp;
            </label>
            <div data-toggle="tooltip" data-original-title="{{ $table2['retirement_reason'] ?? '' }}">
                <input type="text" class="form-control " tabindex="1" id="retirement_reason"
                    value="{{ $table2['retirement_reason'] ?? '' }}" disabled="" style="text-align: left;" disabled>
            </div>
        </div>
    </div>
    <div class=" line-border-bottom" style="margin-top:12px">
        <label class="control-label">{{ __('messages.affiliation_info') }}</label>
    </div>

    <div class="row">
        <div class="col-md-4 col-xl-2 col-lg-3" style="max-width:180px">
            <div class="form-group">
                <label class="control-label">{{ __('messages.application_date') }}
                </label>
                <div class="input-group-btn input-group" style="">
                    <input type="text" class="form-control input-sm date right-radius required" id="application_date"
                        tabindex="1" placeholder="yyyy/mm/dd" disabled
                        value="{{ $table3['application_date'] ?? '' }}" />
                </div>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.grade') }}&nbsp;
                </label>
                <select name="" id="grade" class="form-control" tabindex="1" disabled>
                    <option value="" selected>{{ $table3['grade_nm'] ?? '' }}</option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{ $check_lang == 'en' ? 'lable-check' : '' }}">{{ __('messages.years_of_stay_grade') }}
                </label>
                <div data-toggle="tooltip" data-original-title="">
                    <input type="text" class="form-control " id="" {{-- value="{{ $table3['grade_length_stay'] ?? '' }}"  --}}
                        value="{{ $year_grade ?? '' }}" tabindex="1" disabled="" style="text-align: left;"
                        disabled>
                </div>

            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label style="min-width: 120px;"
                    class="control-label {{ $check_lang == 'en' ? 'lable-check' : '' }}">{{ __('messages.salary') }}
                </label>
                <span class="num-length">
                    <input id="salary_grade" value="{{ $table2['salary_grade'] ?? '' }}" type="text"
                        class="form-control only-number text-right" maxlength="3" tabindex="1" disabled>
                </span>
            </div>
        </div>
    </div>
    <div class="row">
        @if (!empty($organization_group))
            @foreach ($organization_group as $item)
                <div class="col-md-4 col-xl-2 col-lg-3">
                    <div class="form-group">
                        <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                            data-original-title="{{ $item['organization_group_nm'] }}"
                            style="max-width: 150px; display: block">
                            {{ $item['organization_group_nm'] }}
                        </label>
                        <select name="" class="form-control" tabindex="1" disabled>
                            <option value="">
                                {{ $table3['belong_cd' . $item['organization_typ'] . '_nm'] ?? '' }}
                            </option>
                        </select>
                    </div>
                </div>
            @endforeach
        @endif
        <div class="col-md-2">
            <div class="form-group">
                <label class="control-label">{{ __('messages.years_of_stay_affiliation') }}</label>
                <input type="text" class="form-control" {{-- value="{{ $table3['number_years_enrolled'] ?? '' }}" --}} value="{{ $year_depart ?? '' }}"
                    disabled>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.position') }}
                </label>
                <select id="position_cd" class="form-control position_cd" tabindex="1" disabled>
                    <option value="" selected>{{ $table3['position_nm'] ?? '' }}</option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.job') }}
                </label>
                <select id="job_cd" class="form-control" tabindex="1" disabled>
                    <option value="" selected>{{ $table3['job_nm'] ?? '' }}</option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.office') }}
                </label>
                <select id="office_cd" class="form-control" tabindex="1" disabled>
                    <option value="" selected>{{ $table3['office_nm'] ?? '' }}</option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.employee_classification') }}
                </label>
                <select id="employee_typ_cd" class="form-control" tabindex="1" disabled>
                    <option value="" selected>{{ $table3['employee_typ_nm'] ?? '' }}</option>
                </select>
            </div>
        </div>
    </div>
    <div class=" line-border-bottom" style="border-left:0px !important">
    </div>

    {{--  --}}
    <div class="row">
        <div class="col-md-12">
            <div class="table_m0073">
                @if (!empty($table4))
                    @foreach ($table4 as $index => $row)
                        <div class="tr">
                            <div class="row">
                                <div class="col-md-2">
                                    <div class="row">
                                        <div class="col" style="max-width: calc(100% - 150px)">
                                            @if (isset($index) && $index == 0)
                                                <span class="num-length">
                                                    <div class="form-group">
                                                        <label
                                                            class="control-label">{{ __('messages.current_post_info') }}</label>
                                                    </div>
                                                </span>
                                            @endif
                                        </div>
                                        <div class="col" style="max-width: 150px;">
                                            <span class="num-length">
                                                <div class="form-group">
                                                    <label
                                                        class="control-label">{{ __('messages.sort_order') }}</label>
                                                    <input type="text" class="form-control only-number"
                                                        tabindex="3" value="{{ $row['arrange_order'] ?? '' }}"
                                                        disabled />
                                                </div>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                @if (!empty($organization_group))
                                    @foreach ($organization_group as $item)
                                        <div class="col-md-4 col-xl-2 col-lg-3">
                                            <div class="form-group">
                                                <label class="text-overfollow control-label" data-container="body"
                                                    data-toggle="tooltip"
                                                    data-original-title="{{ $item['organization_group_nm'] }}"
                                                    style="max-width: 150px; display: block">
                                                    {{ $item['organization_group_nm'] }}
                                                </label>
                                                <select name="" class="form-control" tabindex="1" disabled>
                                                    <option value="" selected>
                                                        {{ $row['belong_cd' . $item['organization_typ'] . '_nm'] ?? '' }}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    @endforeach
                                @endif
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <div class="row justify-content-end">
                                        <div class="col" style="max-width: 120px;">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 col-xl-2 col-lg-3">
                                    <div class="form-group">
                                        <label class="text-overfollow control-label"
                                            style="max-width: 150px; display: block">
                                            {{ __('messages.position') }}
                                        </label>
                                        <select name="" class="form-control" tabindex="1" disabled>
                                            <option value="" selected>
                                                {{ $row['position_nm'] ?? '' }}
                                            </option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endforeach
                @else
                    @php
                        $index = 0;
                    @endphp
                    <div class="tr">
                        <div class="row">
                            <div class="col-md-2">
                                <div class="row">
                                    <div class="col" style="max-width: calc(100% - 150px)">
                                        @if (isset($index) && $index == 0)
                                            <span class="num-length">
                                                <div class="form-group">
                                                    <label
                                                        class="control-label">{{ __('messages.current_post_info') }}</label>
                                                </div>
                                            </span>
                                        @endif
                                    </div>
                                    <div class="col" style="max-width: 150px;">
                                        <span class="num-length">
                                            <div class="form-group">
                                                <label class="control-label">{{ __('messages.sort_order') }}</label>
                                                <input type="text" class="form-control only-number" tabindex="3"
                                                    value="{{ $row['arrange_order'] ?? '' }}" disabled />
                                            </div>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            @if (!empty($organization_group))
                                @foreach ($organization_group as $item)
                                    <div class="col-md-4 col-xl-2 col-lg-3">
                                        <div class="form-group">
                                            <label class="text-overfollow control-label" data-container="body"
                                                data-toggle="tooltip"
                                                data-original-title="{{ $item['organization_group_nm'] }}"
                                                style="max-width: 150px; display: block">
                                                {{ $item['organization_group_nm'] }}
                                            </label>
                                            <select name="" class="form-control" tabindex="1" disabled>
                                                <option value="" selected>
                                                    {{ $row['belong_cd' . $item['organization_typ'] . '_nm'] ?? '' }}
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                @endforeach
                            @endif
                        </div>
                        <div class="row">
                            <div class="col-md-2">
                                <div class="row justify-content-end">
                                    <div class="col" style="max-width: 120px;">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 col-xl-2 col-lg-3">
                                <div class="form-group">
                                    <label class="text-overfollow control-label"
                                        style="max-width: 150px; display: block">
                                        {{ __('messages.position') }}
                                    </label>
                                    <select name="" class="form-control" tabindex="1" disabled>
                                        <option value="" selected>
                                            {{ $row['position_nm'] ?? '' }}
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                @endif
            </div>
        </div>
    </div>
</div>
