<div class="card-body box-input-search">
    <div class="row">
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group fiscalYear">
                <label class="control-label lb-required"  lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                <select id="fiscal_year" class="form-control required fiscal_year" tabindex="1">
                    <option value="-1"></option>
                    @if (isset($combo_year[0]))
                        @foreach($combo_year as $row)
                            <option value="{{$row['fiscal_year']}}" {{ $row['fiscal_year'] == $row['year_current']?'selected':'' }}>{{$row['fiscal_year']}}</option>
                        @endforeach
                    @endif
                </select>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.treatment_use') }}</label>&nbsp;
                <div class="multi-select-full">
                    <select id="treatment_applications_no" class="form-control multiselect required treatment_applications_no" tabindex="1" multiple="multiple">
                       
                    </select>
                </div>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.group') }}</label>&nbsp;
                <select id="group_cd" name="group_cd" class="form-control" import_status="false" tabindex="2">
                    <option value="-1"></option>
                    <!-- @if (isset($combo_group[0]))
                        @foreach($combo_group as $row)
                            <option value="{{$row['group_cd']}}">{{$row['group_nm']}}</option>
                        @endforeach
                    @endif -->
                </select>
            </div><!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label">&nbsp;</label>
                <div class="checkbox">
                    <div class="md-checkbox-v2 check-width">
                        <input name="ck111" id="ck_search" type="checkbox" tabindex="3" value="1" >
                        <label for="ck_search">{{ __('messages.not_matched_group') }}</label>
                    </div>
                </div>
            </div><!--/.form-group -->
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="form-group">
                <label class="control-label">{{ __('messages.employee_number_name') }}</label>
                <div class="input-group-btn input-group div_employee_cd">
                    <span class="num-length">
                        <input type="hidden" class="employee_cd_hidden" id="employee_cdX" />
                        <input type="text" id="employee_nm" class="form-control indexTab employee_nm" tabindex="3" maxlength="101" value="" style="padding-right: 40px;" />
                    </span>
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
                            <i class="fa fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        @foreach($M0022 as $item)
            @if($item['organization_step'] == 1)
                <div class=" col-md-4 col-xl-2 col-lg-3">
                    <div class="form-group">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                        <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}"  class="form-control  organization_cd1" tabindex="3">
                            <option value=""></option>
                            @foreach($M0020 as $temp)
                            <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
            @else
                <div class="col-md-4 col-xl-2 col-lg-3">
                    <div class="form-group">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                        <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="3" class="form-control  organization_cd{{$item['organization_step']}}">
                        </select>
                    </div>
                </div>
            @endif
        @endforeach
    </div>
    <div id="resultGroup" class="row">
        <div class="col-md-12">
            <div id="tbl1" class="mg_bottom">
                <table class="table table-bordered table-hover table-striped fixed-header" style="table-layout: fixed;">
                    <thead>
                    <tr>
                        <th width="25%">{{ __('messages.employee_classification') }}</th>
                        <th width="25%">{{ __('messages.job') }}</th>
                        <th width="25%">{{ __('messages.position') }}</th>
                        <th width="25%">{{ __('messages.grade') }}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td id="group1" class="text-center"  style="height: 32px"></td>
                        <td id="group2" class="text-center"  style="height: 32px"></td>
                        <td id="group3" class="text-center"  style="height: 32px"></td>
                        <td id="group4" class="text-center"  style="height: 32px"></td>
                    </tr>
                    </tbody>
                </table>
            </div><!-- end .table-responsive -->
        </div>
    </div>
</div><!-- end .card-body -->