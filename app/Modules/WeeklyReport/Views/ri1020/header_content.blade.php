<div class="card-body">
    <div class="row" style="margin: -10px;">
        <div class="col-md-5 col-5"></div>
        <div class="col-md-7 col-7">
            <button type="button"  class="btn button-card"><span><i
                        class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
        </div>
    </div>
    <br/>
    <div class="row">
        <div class="col-sm-12 col-md-4 col-lg-3 col-xl-2">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                    style="white-space: nowrap;">{{ __('rm0100.report_type') }}</label>
                <div style="padding-left: 0px">
                    <span class="num-length">
                        <select id="report_kinds" tabindex="1" autofocus class="form-control required">
                        <option value="-1"></option>
                            @if(isset($report_kinds[0]))
                            @foreach($report_kinds as $res_report)
                            <option value="{{$res_report['report_kind']}}">{{$res_report['report_nm']}}</option>
                            @endforeach
                            @endif
                        </select>
                    </span>
                </div><!-- end .col-md-3 -->
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-lg-2">
            <div class="form-group fiscalYear">
                <label class="control-label lb-required"
                    lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                <select name="" id="fiscal_year" class="form-control required" tabindex="1">
                        @if(isset($fiscal_year_weekly))
                            @foreach($fiscal_year_weekly as $fiscal_year_weekly)
                        <option value="{{ $fiscal_year_weekly['fiscal_year'] }}" {{ $fiscal_year_weekly['fiscal_year'] == $fiscal_year ? 'selected' : '' }}>
                            {{ $fiscal_year_weekly['fiscal_year'] }}{{ \Session::get('website_language', config('app.locale')) == 'en' ? '' : __('messages.fiscal_year') }}
                        </option>
                    @endforeach
                    @endif
                    
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xs-12 col-lg-2" id="block_month" style="display:none">
            <div class="form-group">
            <label class="div_month control-label"
                   >{{ __('ri1010.month') }}&nbsp;</label>
                <select name="" id="month" class="div_month_select form-control" tabindex="2">
                <option value="-1"></option>
                </select>
            </div>
        </div>
        <div class="col-md-3 col-xs-12 col-lg-2" id="block_detail" style="display:none">
            <div class="form-group">
                <label class="control-label">{{ __('ri1020.times') }}&nbsp;</label>
                <select name="" id="times" class="form-control" tabindex="1">
                    <option value="-1"></option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}"
                >{{ __('messages.group') }}</label>&nbsp;
                <select id="group_cd" name="group_cd" class="form-control required" import_status="false" tabindex="1">
                    <option value="-1"></option>
                    @if(isset($group))
                    @foreach($group as $res_data_group)
                    <option value="{{ $res_data_group['group_cd'] }}">{{ $res_data_group['group_nm'] }}</option>
                    @endforeach
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label">&nbsp;</label>
                <div class="checkbox">
                    <div class="md-checkbox-v2 check-width">
                        <input name="ck111" id="ck_search" type="checkbox" tabindex="1" value="1">
                        <label for="ck_search">{{ __('messages.not_matched_group') }}</label>
                    </div>
                </div>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-lg-3 report_block">
        <div class="form-group">
                <label class="control-label">{{ __('messages.approver_name') }}</label>
                <div class="input-group-btn input-group div_employee_cd">
                    <span class="num-length">
                        <input type="hidden" class="employee_cd_hidden" id="reporter_cd" />
                        <input type="text" id="employee_nm" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}"  class="form-control indexTab employee_nm_weeklyreport" tabindex="3" maxlength="101" value="" style="padding-right: 40px;" />
                    </span>
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        @if(isset($organization_group))
        @if(isset($organization_group[0]) && !empty($organization_group[0]))
            @foreach($organization_group as $item)
                @if($item['organization_step'] == 1)
                    <div class="col-md-2 col-xs-12 col-lg-2 init_organization">
                        <div class="form-group">
                            <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$item['organization_group_nm']}}" style="max-width: 190px;    display: block">
                                {{$item['organization_group_nm']}}
                            </label>
                                <select system="5" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control  organization_cd1" >
                                    <option value="-1"></option>
                                    @foreach($combo_organization as $temp)
                                    <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                    @endforeach+
                                </select>
                        </div>
                    </div>
                @else
                    <div class="col-md-2 col-xs-12 col-lg-2 init_organization">
                        <div class="form-group">
                            <label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$item['organization_group_nm']}}" style="max-width: 190px;    display: block">
                                {{$item['organization_group_nm']}}
                            </label>
                                    <select system="5" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control  organization_cd{{$item['organization_step']}}">
                                    </select>
                        </div>
                    </div>
                @endif
            @endforeach
        @endif
        @endif
      
    </div>
    <div id="resultGroup" class="row">
        <div class="col-md-12">
            <div id="tbl1" class="mg_bottom">
                <table class="table table-bordered table-hover table-striped fixed-header" style="table-layout: fixed;">
                    <thead>
                        <tr>
                            <th width="25%">{{ __('messages.position') }}</th>
                            <th width="25%">{{ __('messages.job') }}</th>
                            <th width="25%">{{ __('messages.grade') }}</th>
                            <th width="25%">{{ __('messages.employee_classification') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td id="group1" class="text-center" style="height: 32px"></td>
                            <td id="group2" class="text-center" style="height: 32px"></td>
                            <td id="group3" class="text-center" style="height: 32px"></td>
                            <td id="group4" class="text-center" style="height: 32px"></td>
                        </tr>
                    </tbody>
                </table>
            </div><!-- end .table-responsive -->
        </div>
    </div>
</div><!-- end .card-body -->
