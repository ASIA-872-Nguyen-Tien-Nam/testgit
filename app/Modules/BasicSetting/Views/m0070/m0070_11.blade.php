<div class="row">
    <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
        <div class="form-group">
            <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                style="display: block">
                {{ __('messages.employment_insurance_number') }}
            </label>
            <span class="num-length">
                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="employment_insurance_no" tabindex="1" maxlength="13" class="form-control employment_insurance_no" value="{{ $tab_11['m0090']['employment_insurance_no'] ?? ''}}">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
        <div class="form-group">
            <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                style="display: block">
                {{ __('messages.basic_pension_number') }}
            </label>
            <span class="num-length">
                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" tabindex="1" maxlength="11" id="basic_pension_no" class="form-control basic_pension_no" value="{{ $tab_11['m0090']['basic_pension_no'] ?? ''}}">
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>

<div class="line-border-bottom">
    <label class="control-label">{{ __('messages.welfare_pension') }}</label>
</div>
<div class="row">
    <div class="col-md-2 col-xl-2 col-lg-4">
        <div class="form-group">
            <label class="control-label  ">{{ __('messages.membership_status') }}
            </label>
            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="employment_insurance_status" type="radio" id="ins_rd1" value="1" {{ ($tab_11['m0090']['employment_insurance_status'] ?? 0) == 1 ?'checked':''  }}>
                    <label for="ins_rd1" tabindex="1">{{ __('messages.join') }}</label>
                </div>
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="employment_insurance_status" type="radio" id="ins_rd2" value="2" {{ ($tab_11['m0090']['employment_insurance_status'] ?? 0) == 2 ?'checked':''  }}>
                    <label for="ins_rd2" tabindex="1">{{ __('messages.no_join') }}</label>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="table_12_add_1 row">
    <div class="button_12_add_1 px-4">
        <label class="control-label ">&nbsp;
        </label>
        <div class="form-group">
            <div class="full-width">
                @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="button_12_add_1"
                    data-toggle="tooltip" title="" tabindex="1">
                    +
                </a>
                @endif
            </div><!-- end .full-width -->
        </div>
    </div>
    <div class="flex-fill">
        <div class="row row_tab_11 row_12_add_1 row_12_add_1_hidden" hidden>
            <input type="text" hidden class="social_insurance_kbn" value="1">
            <input type="text" hidden class="detail_no" value="0">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_1"
                                placeholder="yyyy/mm/dd" tabindex="1" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                    class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_1"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                    class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <div class="input-group-btn input-group">
                            <label class="control-label  " data-container="body" data-toggle="tooltip"
                                data-original-title="" style="max-width: 150px;">
                                {{ __('messages.reason_for_loss') }}
                            </label>
                            <span class="num-length">
                                <select {{$disabled}} {{$tab_11['disabled_tab11'] }} tabindex="1" name="" id="reason_for_loss_kbn" class="form-control reason_for_loss_kbn" tabindex="1" organization_typ="">
                                    <option></option>
                                    @foreach($tab_11['data_71'] as $row)
                                    <option value="{{$row['number_cd']}}">
                                    {{$row['name']}}</option>
                                    @endforeach
                                </select>
                            </span>
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @foreach ($tab_11['list'][1] as $item)
        <div class="row row_tab_11 row_12_add_1">
            <input type="text" hidden class="social_insurance_kbn" value="1">
            <input type="text" hidden class="detail_no" value="{{ $item['detail_no'] ?? 0}}">    
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_1"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['joining_date'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important">
                                        <i class="fa fa-calendar"></i>
                                    </button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_1"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['date_of_loss']}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important">
                                        <i class="fa fa-calendar"></i>
                                    </button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <div class="input-group-btn input-group">
                            <label class="control-label  " data-container="body" data-toggle="tooltip"
                                data-original-title="" style="max-width: 150px;">
                                {{ __('messages.reason_for_loss') }}
                            </label>
                            <span class="num-length">
                                <select {{$disabled}} {{$tab_11['disabled_tab11'] }} tabindex="1" name="" id="reason_for_loss_kbn" class="form-control reason_for_loss_kbn" tabindex="1" organization_typ="">
                                    <option></option>
                                    @foreach($tab_11['data_71'] as $row)
                                    <option value="{{$row['number_cd']}}" {{($item['reason_cd']??'')==$row['number_cd']?'selected':''}}>
                                    {{$row['name']}}</option>
                                    @endforeach
                                </select>
                            </span>
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>        
        @endforeach
    </div>
</div>
<div class="line-border-bottom">
    <label class="control-label">{{ __('messages.health_ins') }}</label>
</div>
<div class="row">
    <div class="col-md-2 col-xl-2 col-lg-4">
        <div class="form-group">
            <label class="control-label  "> {{ __('messages.membership_status') }}
            </label>
            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="health_insurance_status" type="radio" id="ins_rd21" value="1" tabindex="1" {{ ($tab_11['m0090']['health_insurance_status'] ?? 0) == 1 ?'checked':''  }}>
                    <label for="ins_rd21" tabindex="1">{{ __('messages.join') }}</label>
                </div>
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="health_insurance_status" type="radio" id="ins_rd22" value="2" tabindex="1" {{ ($tab_11['m0090']['health_insurance_status'] ?? 0) == 2 ?'checked':''  }}>
                    <label for="ins_rd22" tabindex="1">{{ __('messages.no_join') }}</label>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4" style="min-width:240px">
        <div class="form-group">
            <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                style="display: block">
                {{ __('messages.insured_person_reference_number') }}
            </label>
            <span class="num-length">
                @if (isset($tab_11['m0090']['health_insurance_reference_no']) && $tab_11['m0090']['health_insurance_reference_no'] == 0)
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="health_insurance_reference_no" tabindex="1" maxlength="8" class="form-control health_insurance_reference_no" value="">
                @else
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="health_insurance_reference_no" tabindex="1" maxlength="8" class="form-control health_insurance_reference_no" value="{{ $tab_11['m0090']['health_insurance_reference_no'] ?? '' }}">
                @endif
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="table_12_add_2 row">
    <div class="button_12_add_2 px-4">
        <label class="control-label ">&nbsp;
        </label>
        <div class="form-group">
            <div class="full-width">
                @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="button_12_add_2"
                    data-toggle="tooltip" title="" tabindex="1">
                    +
                </a>
                @endif
            </div><!-- end .full-width -->
        </div>
    </div>
    <div class="flex-fill">
        <div class="row row_tab_11 row_12_add_2 row_12_add_2_hidden" hidden>
            <input type="text" hidden class="social_insurance_kbn" value="2">
            <input type="text" hidden class="detail_no" value="0">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_2"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                        <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_2"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_72'] }}" tabindex="9" maxlength="10"
                                    value=""
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @foreach ($tab_11['list'][2] as $item)
        <div class="row row_tab_11 row_12_add_2">
            <input type="text" hidden class="social_insurance_kbn" value="2">
            <input type="text" hidden class="detail_no" value="{{ $item['detail_no'] ?? 0}}">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_2"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['joining_date'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_2"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['date_of_loss'] ?? ''}}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_72'] }}" tabindex="9" maxlength="10"
                                    value="{{ $item['reason_for_loss'] ?? ''}}"
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @endforeach
    </div>
</div>
<div class="line-border-bottom">
    <label class="control-label">{{ __('messages.welfare_pension_insurance') }}</label>
</div>
<div class="row">
    <div class="col-md-2 col-xl-2 col-lg-4">
        <div class="form-group">
            <label class="control-label  "> {{ __('messages.membership_status') }}
            </label>
            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="employees_pension_insurance_status" type="radio" id="ins_rd31" value="1" tabindex="1" {{ ($tab_11['m0090']['employees_pension_insurance_status'] ?? 0) == 1 ?'checked':''  }}>
                    <label for="ins_rd31" tabindex="1">{{ __('messages.join') }}</label>
                </div>
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="employees_pension_insurance_status" type="radio" id="ins_rd32" value="2" tabindex="1" {{ ($tab_11['m0090']['employees_pension_insurance_status'] ?? 0) == 2 ?'checked':''  }}>
                    <label for="ins_rd32" tabindex="1">{{ __('messages.no_join') }}</label>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4">
        <div class="form-group">
            <label class=" control-label " style="min-width:240px" data-container="body" data-toggle="tooltip"
                data-original-title="" style="display: block">
                {{ __('messages.insured_person_reference_number') }}
            </label>
            <span class="num-length">
                @if (isset($tab_11['m0090']['employees_pension_reference_no']) && $tab_11['m0090']['employees_pension_reference_no'] == 0)
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="employees_pension_reference_no" tabindex="1" maxlength="6" class="form-control only-number employees_pension_reference_no text-left" value="">
                @else
                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="employees_pension_reference_no" tabindex="1" maxlength="6" class="form-control only-number employees_pension_reference_no text-left" value="{{ $tab_11['m0090']['employees_pension_reference_no'] ?? ''}}">
                @endif
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="table_12_add_3 row">
    <div class="button_12_add_3 px-4">
        <label class="control-label ">&nbsp;
        </label>
        <div class="form-group">
            <div class="full-width">
                @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="button_12_add_3"
                    data-toggle="tooltip" title="" tabindex="1">
                    +
                </a>
                @endif
            </div><!-- end .full-width -->
        </div>
    </div>
    <div class="flex-fill">
        <div class="row row_tab_11 row_12_add_3 row_12_add_3_hidden" hidden>
            <input type="text" hidden class="social_insurance_kbn" value="3">
            <input type="text" hidden class="detail_no" value="0">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_3"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <div class="input-group-btn input-group ">
                            <span class="num-length">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_3"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                            </div>
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_73'] }}" tabindex="9" maxlength="10"
                                    value=""
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @foreach ($tab_11['list'][3] as $item)
        <div class="row row_tab_11 row_12_add_3">
            <input type="text" hidden class="social_insurance_kbn" value="3">
            <input type="text" hidden class="detail_no" value="{{ $item['detail_no'] ?? 0}}">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;     display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_3"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['joining_date'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_3"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['date_of_loss'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                        class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_73'] }}" tabindex="9" maxlength="10"
                                    value="{{ $item['reason_for_loss'] ?? ''}}"
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @endforeach
    </div>
</div>
<div class="line-border-bottom">
    <label class="control-label">{{ __('messages.employee_pension_fund') }}</label>
</div>
<div class="row">
    <div class="col-md-2 col-xl-2 col-lg-4">
        <div class="form-group">
            <label class="control-label  "> {{ __('messages.membership_status') }}
            </label>
            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="welfare_pension_status" type="radio" id="ins_rd41" value="1" tabindex="1"  {{ ($tab_11['m0090']['welfare_pension_status'] ?? 0) == 1 ?'checked':''  }}>
                    <label for="ins_rd41" tabindex="1"> {{ __('messages.join') }}</label>
                </div>
                <div class="md-radio-v2 inline-block">
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} name="welfare_pension_status" type="radio" id="ins_rd42" value="2" tabindex="1"  {{ ($tab_11['m0090']['welfare_pension_status'] ?? 0) == 2 ?'checked':''  }}>
                    <label for="ins_rd42" tabindex="1">{{ __('messages.no_join') }}</label>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-2 col-xl-3 col-xs-12 col-lg-4">
        <div class="form-group">
            <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                style="min-width:300px" style="display: block">
                {{ __('messages.membership_number') }}
            </label>
            <span class="num-length">
                @if (isset($tab_11['m0090']['employees_pension_member_no']) && $tab_11['m0090']['employees_pension_member_no'] == 0)
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="employees_pension_member_no" tabindex="1" maxlength="10" class="form-control employees_pension_member_no" value="">
                @else
                    <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="employees_pension_member_no" maxlength="10" class="form-control employees_pension_member_no" tabindex="1" value="{{ $tab_11['m0090']['employees_pension_member_no'] ?? ''}}">
                @endif
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="table_12_add_4 row">
    <div class="button_12_add_4 px-4">
        <label class="control-label ">&nbsp;
        </label>
        <div class="form-group">
            <div class="full-width">
                @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="button_12_add_4"
                    data-toggle="tooltip" title="" tabindex="1">
                    +
                </a>
                @endif
            </div><!-- end .full-width -->

        </div>
    </div>
    <div class="flex-fill">
        <div class="row row_tab_11 row_12_add_4 row_12_add_4_hidden" hidden>
            <input type="text" hidden class="social_insurance_kbn" value="4">
            <input type="text" hidden class="detail_no" value="0">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_4"
                                placeholder="yyyy/mm/dd" tabindex="1" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                    class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_4"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_74'] }}" tabindex="9" maxlength="10"
                                    value=""
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @foreach ($tab_11['list'][4] as $item)
        <div class="row row_tab_11 row_12_add_4">
            <input type="text" hidden class="social_insurance_kbn" value="4">
            <input type="text" hidden class="detail_no" value="{{ $item['detail_no'] ?? 0}}">
            <div class="col-lg-10 col-sm-12 row">
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.joining_date') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius joining_date jd_4"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['joining_date'] ?? ''}}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                    class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-2 col-xs-12 col-lg-2 max_180_yyyy input_date" style="min-width: 170px !important">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.date_of_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group ">
                                <input {{$disabled}} {{$tab_11['disabled_tab11'] }} type="text" id="" class="form-control input-sm date right-radius date_of_loss dol_4"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{ $item['date_of_loss'] ?? ''}}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                    tabindex="-1" style="background: none !important"><i
                                    class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-2 col-xl-7 col-xs-12 col-lg-5">
                    <div class="form-group">
                        <label class=" control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                            style="max-width: 150px;    display: block">
                            {{ __('messages.reason_for_loss') }}
                        </label>
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text"
                                    class="form-control ui-autocomplete-input autocomplete-down-tab_11 reason_for_loss" id=""
                                    availableData = "{{ $tab_11['data_74'] }}" tabindex="9" maxlength="10"
                                    value="{{ $item['reason_for_loss'] ?? ''}}"
                                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_11['disabled_tab11'] }}>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_11['disabled_tab11'] ) && $tab_11['disabled_tab11']  == ''))
            <div class="col-lg-1 col-sm-12">
                <div class="form-group">
                    <label class="control-label ">&nbsp</label>
                    <span class="num-length text_left_pc">
                        <span tabindex="1" style="border:none" class="btn-remove btn-remove_12">
                            <i class="fa fa-remove"></i>
                        </span>
                    </span>
                </div>
            </div>
            @endif
        </div>
        @endforeach
    </div>
</div>