<div class="row div_month_times div_month_time_s" id="row_date_time">
    <div class="col-sm-3 col-md-3">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('rdashboard.fiscal_year') }}</label>
            <select class="form-control r_fiscal_year required" id="fiscal_year" tabindex="1" autofocus screen="schedule">
                <option value="-1"></option>
                @if (isset($years) && !empty($years))
                    @foreach ($years as $key => $item)
                        @if ($item['fiscal_year'] == $fiscal_year)
                            <option value="{{ $item['fiscal_year'] }}" selected>
                                {{ $item['fiscal_year'] }}{{ __('rdashboard.year') }}</option>
                        @else
                            <option value="{{ $item['fiscal_year'] }}">
                                {{ $item['fiscal_year'] }}{{ __('rdashboard.year') }}</option>
                        @endif
                    @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="col-sm-3 col-md-3">
        <div class="form-group">
            <label class="control-label">{{ __('rdashboard.year_month') }}</label>
            <input type="hidden" class="r_report_kind" value="5">
            <select class="form-control month_times" id="month" tabindex="1" autofocus>
                <option value="-1"></option>
                @if (isset($months) && !empty($months))
                    @foreach ($months as $key => $item)
                        @if ($item['month'] == $fiscal_year_month)
                            <option value="{{ $item['month'] }}" selected>{{ $item['month_nm'] }}</option>
                        @else
                            <option value="{{ $item['month'] }}">{{ $item['month_nm'] }}</option>
                        @endif
                    @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="col-sm-3 col-md-3">
        <div class="form-group">
            <label class="control-label">{{ __('rdashboard.week') }}</label>
            <select class="form-control times" id="times" tabindex="1" autofocus>
                <option value="-1"></option>
                @if (isset($times_list) && !empty($times_list))
                    @foreach ($times_list as $key => $item)
                        @if ($item['detail_no'] == $times)
                            <option value="{{ $item['detail_no'] }}" selected>{{ $item['title'] }}</option>
                        @else
                            <option value="{{ $item['detail_no'] }}">{{ $item['title'] }}</option>
                        @endif
                    @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="col-sm-3 col-md-3">
        <div class="form-group">
            <label class="control-label">{{ __('rq2010.my_group') }}</label>
            <select class="form-control" id="mygroup_cd" tabindex="3">
                <option value="-1"></option>
                @if (isset($mygroups) && !empty($mygroups))
                    @foreach ($mygroups as $item)
                        @if ($item['mygroup_cd'] == $mygroup_cd)
                            <option value="{{ $item['mygroup_cd'] }}" selected>{{ $item['mygroup_nm'] }}</option>
                        @else
                            <option value="{{ $item['mygroup_cd'] }}">{{ $item['mygroup_nm'] }}</option>
                        @endif
                    @endforeach
                @endif
            </select>
        </div>
    </div>
</div>

{{-- 組織 --}}
<div class="row">
    @if (isset($M0022) && !empty($M0022))
        @foreach ($M0022 as $key => $item)
            @if ($key < 3)
                @if ($item['organization_step'] == 1)
                    <div class="col-sm-3 col-md-3">
                        <div class="form-group">
                            <label class="text-overfollow control-label" style="max-width: 150px" data-container="body"
                                data-toggle="tooltip"
                                data-original-title="{{ $item['organization_group_nm'] }}">{{ $item['organization_group_nm'] }}</label>
                            <select id="organization_step{{ $item['organization_step'] }}"
                                organization_typ="{{ $item['organization_typ'] }}" tabindex="4"
                                class="form-control organization_cd1" system="5">
                                <option value="-1"></option>
                                @if (isset($M0020) && !empty($M0020))
                                    @foreach ($M0020 as $temp)
                                        <option
                                            value="{{ $temp['organization_cd_1'] . '|' . $temp['organization_cd_2'] . '|' . $temp['organization_cd_3'] . '|' . $temp['organization_cd_4'] . '|' . $temp['organization_cd_5'] }}">
                                            {{ $temp['organization_nm'] }}</option>
                                    @endforeach
                                @endif
                            </select>
                        </div>
                    </div>
                @else
                    <div class="col-sm-3 col-md-3">
                        <div class="form-group">
                            <label class="text-overfollow control-label" style="max-width: 150px" data-container="body"
                                data-toggle="tooltip"
                                data-original-title="{{ $item['organization_group_nm'] }}">{{ $item['organization_group_nm'] }}</label>
                            <select id="organization_step{{ $item['organization_step'] }}"
                                organization_typ="{{ $item['organization_typ'] }}" tabindex="4"
                                class="form-control organization_cd{{ $item['organization_step'] }}" system="5">
                                <option value="-1"></option>
                            </select>
                        </div>
                    </div>
                @endif
            @endif
        @endforeach
    @endif
</div>
{{-- CHECKBOX --}}
<div class="row">
    <div class="col-md-12 col-sm-12 col-lg-12 col-xl-12">
        <div class="md-checkbox-v2 inline-block mr-3">
            <label class="container pr-0" for="unapproved_only">{{ __('rdashboard.unapproved_only') }}
                <input type="checkbox" name="ck1" id="unapproved_only" value="1" />
                <span class="checkmark" tabindex="4"></span>
            </label>
        </div>
        <div class="md-checkbox-v2 inline-block">
            <label class="container pr-0" for="approved_show">{{ __('rdashboard.also_show_processed') }}
                <input type="checkbox" name="ck1" id="approved_show" value="1" />
                <span class="checkmark" tabindex="4"></span>
            </label>
        </div>
    </div>
</div>
