<div class="row " id="hide-show-table">
    <div class="col-md-12 col-lg-12 col-xl-12 col-sm-12 col-12 table-1">
        <label class="control-label">{{ __('messages.purpose') }}</label>
        <div class="table-responsive wmd-view  table-data">
            <table class="table table-bordered table-bordered-hover table-hover ofixed-boder">
                <thead>
                    <tr class="tr-table">
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle=""
                                data-placement="left" data-html="true" data-original-title="{!! __('messages.position') !!}">
                                {{ __('ri1010.ogr_name') }}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle=""
                                data-placement="left" data-html="true" data-original-title="{!! __('messages.position') !!}">
                                {{ __('messages.position') }}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle=""
                                data-placement="left" data-html="true" data-original-title="{!! __('messages.job') !!}">
                                {{ __('messages.job') }}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle=""
                                data-placement="left" data-html="true" data-original-title="{!! __('messages.grade') !!}">
                                {{ __('messages.grade') }}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle=""
                                data-placement="left" data-html="true" data-original-title="{!! __('messages.employee_classification') !!}">
                                {{ __('messages.employee_classification') }}
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @if (isset($table_info))
                        <tr class="list">
                            <td class="text-center" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-placement="left" data-html="true"
                                    data-original-title="{{ $table_info['organization_nm'] ?? '' }}">
                                    {!! html_entity_decode($table_info['organization_nm']) ?? '' !!}
                                </div>
                            </td>
                            <td class="text-center" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-placement="left" data-html="true"
                                    data-original-title="{{ $table_info['position_nm'] ?? '' }}">
                                    {{ $table_info['position_nm'] ?? '' }}
                                </div>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-placement="left" data-html="true"
                                    data-original-title="{{ $table_info['job_nm'] ?? '' }}">
                                    {{ $table_info['job_nm'] ?? '' }}
                                </div>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-placement="left" data-html="true"
                                    data-original-title="{{ $table_info['grade_nm'] ?? '' }}">
                                    {{ $table_info['grade_nm'] ?? '' }}
                                </div>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    data-placement="left" data-html="true"
                                    data-original-title="{{ $table_info['employee_typ_nm'] ?? '' }}">
                                    {{ $table_info['employee_typ_nm'] ?? '' }}
                                </div>
                            </td>
                        </tr>
                    @else
                        <tr>
                            <td colspan="5" class="w-popup-nodata no-hover text-center"> {{ $_text[21]['message'] }}
                            </td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div>
<div class="row">
    <div class="col-md-12 col-lg-12 col-xl-12 col-sm-12 col-12 table-2">
        <div class="table-responsive wmd-view  table-data sticky-table sticky-headers sticky-ltr-cells">
            <table class="table table-bordered table-hover  ofixed-boder">
                <thead>
                    <tr>
                        <th class="col-tb2">{{ __('messages.title') }}</th>
                        <th class="col-tb2 " style="max-width: 170px;width: 170px">{{ __('messages.start_dates') }}
                        </th>
                        <th style="width: 40px !important"></th>
                        <th class="col-tb2 "style="max-width: 170px;width: 170px">{{ __('messages.time_limit') }}</th>
                        <th class="col-tb2 ">{{ __('messages.remind') }}</th>
                        <th class="col-tb2 ">{{ __('messages.alert') }}</th>
                        <th class="col-tb2 ">{{ __('ri1010.usage_category') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @if (isset($table_schedule[0]))
                        @foreach ($table_schedule as $row)
                            <tr class="list_schedule">
                                <td class="text-center">
                                    <span class="num-length">
                                        <input type="hidden" class="detail_no" value="{{ $row['detail_no'] ?? 0 }}">
                                        <input type="hidden" class="year_n" value="{{ $row['year'] ?? 0 }}">
                                        <input type="hidden" class="month_n" value="{{ $row['month'] ?? 0 }}">
                                        <input type="hidden" class="title_df" value="{{ $row['title_df'] ?? '' }}">
                                        <input type="text" class="form-control title" maxlength="20" placeholder="{{ $row['title_df'] ??''}}"
                                            value="{{ $row['title'] ??''}}" tabindex="5">
                                    </span>
                                </td>
                                <td class="text-center">

                                    <div class="gflex">
                                        <div class="input-group-btn input-group" style="width: 170px">
                                            <input type="text"
                                                class="form-control input-sm date right-radius start_date required"
                                                placeholder="yyyy/mm/dd" value="{{ $row['start_date'] ?? ''}}"
                                                tabindex="5">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button"
                                                    data-dtp="dtp_JGtLk" tabindex="-1"
                                                    style="background: none !important;"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </div><!-- end .gflex -->
                                </td>
                                <td class="text-center">
                                    <span style="font-size: 25px">~</span>
                                </td>
                                <td class="text-center">
                                    <div class="gflex">
                                        <div class="input-group-btn input-group" style="width: 170px">
                                            <input type="text"
                                                class="form-control input-sm date right-radius deadline_date required"
                                                placeholder="yyyy/mm/dd" value="{{ $row['deadline_date'] }}"
                                                tabindex="5">
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button"
                                                    data-dtp="dtp_JGtLk" tabindex="-1"
                                                    style="background: none !important;"><i
                                                        class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </div><!-- end .gflex -->
                                </td>
                                <td class="text-center">
                                    <select name="" id=""
                                        class="form-control required report_notice" tabindex="5">
                                        <option {{ ($row['notice']??0) == 0 ? 'selected' : '' }} value="0">
                                            {{ __('messages.dont_notify') }}</option>
                                        <option {{ ($row['notice']??0) == 1 ? 'selected' : '' }} value="1">
                                            {{ __('messages.notify') }}</option>
                                    </select>
                                </td>
                                <td class="text-center">
                                    <select name="" id=""
                                        class="form-control required report_alert" tabindex="5">
                                        <option {{ ($row['alert']??0) == 0 ? 'selected' : '' }} value="0">
                                            {{ __('messages.dont_notify') }}</option>
                                        <option {{ ($row['alert']??0) == 1 ? 'selected' : '' }} value="1">
                                            {{ __('messages.notify') }}</option>
                                    </select>
                                </td>
                                <td class="text-center">
                                    <select name="" id=""
                                        class="form-control required report_user_typ" tabindex="5">
                                        <option {{ ($row['user_typ']??0) == 0 ? 'selected' : '' }} value="0">
                                            {{ __('messages.not_use') }}</option>
                                        <option {{ ($row['user_typ']??0) == 1 ? 'selected' : '' }} value="1">
                                            {{ __('ri1010.use') }}</option>
                                    </select>
                                </td>
                            </tr>
                        @endforeach
                    @else
                        <tr>
                            <td colspan="100%" class="w-popup-nodata no-hover text-center">
                                {{ $_text[21]['message'] }}</td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>

</div>
