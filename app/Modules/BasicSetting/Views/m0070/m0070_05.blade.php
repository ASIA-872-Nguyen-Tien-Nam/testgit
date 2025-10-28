<div class="tab-pane fade" id="tab6">
    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.final_education') }}</label>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 mb-4">
            <div class="form-group">
                <select {{$disabled}} {{$tab_05['disabled_tab05']}} dis="{{$tab_05['disabled_tab05']}}" name="" id="final_education_kbn" class="form-control final_education_kbn" tabindex="9">
                    <option value="0"></option>
                    @foreach ($tab_05['final_education_kbn'] as $data)
                        <option value="{{ $data['number_cd'] }}"
                            {{ $data['number_cd'] == ($tab_05['m0078'][0]['final_education_kbn'] ?? 0) ? 'selected' : ''}}
                        >{{ $data['name'] }}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-4">
            <span class="num-length">
                <div class="input-group-btn input-group">
                    <input {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="final_education_other" disabled tabindex="1" maxlength="50"
                        placeholder="" class="form-control final_education_other" value="{{ $tab_05['m0078'][0]['final_education_other'] ?? '' }}">
                </div>
            </span>
            <!--/.form-group -->
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-1 col-xs-12 col-lg-2 mb-4 year_input_2" >
            <span class="num-length">
                <div class="form-group">
                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip" data-original-title=""
                        style="max-width: 150px;    display: block">
                        {{ __('messages.graduation_year') }}
                    </label>
                    @if (isset($tab_05['m0078'][0]['graduation_year']) && $tab_05['m0078'][0]['graduation_year'] == 0)
                    
                        <input {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_year" class="form-control only-number graduation_year year_1" value="" maxlength="4"
                            tabindex="9">
                    @else
                        <input {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_year" class="form-control only-number graduation_year year_1" value="{{ $tab_05['m0078'][0]['graduation_year'] ?? '' }}" maxlength="4"
                            tabindex="9">
                    @endif
                </div>
            </span>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 mb-4">
            <span class="num-length">
                <div class="form-group">
                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.school') }}</label>
                    <input type="text"
                    class="form-control ui-autocomplete-input autocomplete-down-tab_05 graduation_school_nm cd_1" id="graduation_school_nm"
                    availableData = "{{ $tab_05['graduation_school_cd'] }}" tabindex="9" maxlength="50"
                    value="{{ $tab_05['m0078'][0]['school_name'] ?? '' }}"
                    style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_05['disabled_tab05']}}>
                    <input type="hidden"
                    class="form-control input-sm text-left graduation_school_cd" id="graduation_school_cd"
                    value="{{ $tab_05['m0078'][0]['graduation_school_cd'] ?? '' }}">
                </div>
            </span>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-4">
            <span class="num-length">
                <div class="form-group">
                <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip" data-original-title=""
                    style="max-width: 150px;    display: block">
                    &nbsp
                </label>
                    <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_school_other" tabindex="9"
                    placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.input_guide') : ''}}" class="form-control graduation_school_other nm_1" value="{{ $tab_05['m0078'][0]['graduation_school_other'] ?? '' }}">
                    </div>
                </span>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-4">
            <span class="num-length">
                <div class="form-group">
                <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip" data-original-title=""
                    style="">
                    {{ __('messages.faculty_dept_nm') }}
                </label>
                    <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" tabindex="9" id="faculty" class="form-control faculty" value="{{ $tab_05['m0078'][0]['faculty'] ?? '' }}">
                </div>
            </span>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2">
            <span class="num-length">
                <div class="form-group">
                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip" data-original-title=""
                        style="max-width: 150px;    display: block">
                        {{ __('messages.major') }}
                    </label>
                        <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="major" class="form-control major" value="{{ $tab_05['m0078'][0]['major'] ?? '' }}" tabindex="9">
                </div>
            </span>
            <!--/.form-group -->
        </div>
    </div>
    <div class="line-border-bottom">
        <label class="control-label">{{ __('messages.other_edu') }}</label>
    </div>
    @if (isset($disabled) && $disabled == '' && (isset($tab_05['disabled_tab05']) && $tab_05['disabled_tab05'] == ''))
    <div class="row">
        <div class="col-xl-1 col-lg-1 col-sm-12 mb-2">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lb-size':''}} {{$check_lang=='en'?'lable-check':''}}">&nbsp;
                </label>
                <div class="full-width">
                    <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="add_row_data_06"
                        tabindex="9">
                        +
                    </a>
                </div><!-- end .full-width -->
            </div>
        </div>
    </div>    
    @endif    
    <div class="row">
        <div class="col-xl-12 col-lg-12 col-sm-12 block_data_06">
            @if(isset($tab_05['m0079'][0]['graduation_school_cd']) && count($tab_05['m0079'])>0)
            @foreach ($tab_05['m0079'] as $index => $row)
                <div class="row row_data_06 list_tab_05">
                    <div class="col-xl-12 col-lg-12 col-sm-12 row">
                        <div class="col-md-4 col-xl-1 col-xs-12 col-lg-2 mb-2 year_input">
                            <span class="num-length">
                                <div class="form-group">
                                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                        data-original-title="" style="max-width: 150px;    display: block">
                                        {{ __('messages.graduation_year') }}
                                    </label>
                                    <input {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_year" class="form-control only-number graduation_year year_2" value="{{ $row['graduation_year'] ?? ''}}"
                                        maxlength="4" tabindex="9">
                                    <input type="text" class="form-control input-sm text-left d-none detail_no"
                                        value="{{ $row['detail_no'] ?? '' }}">
                                </div>
                            </span>
                            <!--/.form-group -->
                        </div>
                        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 mb-2 add_size">
                            <span class="num-length">
                                <div class="form-group">
                                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.school') }}</label>
                                    <input type="text"
                                        class="form-control ui-autocomplete-input autocomplete-down-tab_05 graduation_school_nm cd_2" id="graduation_school_nm" 
                                        availableData = "{{$tab_05['graduation_school_cd']}}" tabindex="9" maxlength="50"
                                        value="{{ $row['school_name'] ?? '' }}"
                                        style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_05['disabled_tab05'] ??''}}>
                                    <input type="hidden"
                                        class="form-control input-sm text-left graduation_school_cd" id="graduation_school_cd"
                                        value="{{ $row['graduation_school_cd'] ?? '' }}">
                                </div>
                            </span>
                            <!--/.form-group -->
                        </div>
                        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                            <span class="num-length">
                                <div class="form-group">
                                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                        data-original-title="" style="max-width: 150px;    display: block">
                                        &nbsp
                                    </label>
                                    <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_school_other" tabindex="9"
                                    placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.input_guide') : ''}}" class="form-control graduation_school_other nm_2" value="{{ $row['graduation_school_other'] ?? '' }}">
                                </div>
                            </span>
                            <!--/.form-group -->
                        </div>
                        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                            <span class="num-length">
                                <div class="form-group">
                                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                        data-original-title="" style="">
                                        {{ __('messages.faculty_dept_nm') }}
                                    </label>
                                    <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" tabindex="9" id="faculty" class="form-control faculty"
                                        value="{{ $row['faculty'] ?? '' }}">
                                </div>
                            </span>
                            <!--/.form-group -->
                        </div>
                        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                            <span class="num-length">
                                <div class="form-group">
                                    <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                        data-original-title="" style="max-width: 150px;    display: block">
                                        {{ __('messages.major') }}
                                    </label>
                                        <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="major" class="form-control major" value="{{ $row['major'] ?? '' }}"
                                            tabindex="9">
                                        @if (isset($disabled) && $disabled == '' && (isset($tab_05['disabled_tab05']) && $tab_05['disabled_tab05'] == ''))
                                        <span tabindex="9" style="border:none; font-size:17px; position:absolute; top: 33px; right:-33px" class="btn-remove btn-remove_06">
                                            <i class="fa fa-remove"></i>
                                        </span>
                                        @endif
                                </div>
                            </span>
                            <!--/.form-group -->
                        </div>
                    </div>
                </div>
            @endforeach
            @endif
        </div>
        {{-- hidden table --}}
        <div class="row row_data_06_hidden row_data_06 list_tab_05" hidden>
            <div class="col-xl-12 col-lg-12 col-sm-12 row">
                <div class="col-md-4 col-xl-1 col-xs-12 col-lg-2 mb-2 year_input" >
                    <span class="num-length">
                        <div class="form-group">
                            <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                data-original-title="" style="max-width: 150px;    display: block">
                                {{ __('messages.graduation_year') }}
                            </label>
                                <input {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_year" class="form-control only-number graduation_year year_2" value=""
                                    maxlength="4" tabindex="9">
                                <input type="text" class="form-control input-sm text-left d-none detail_no"
                                value="0">
                        </div>
                    </span>
                    <!--/.form-group -->
                </div>
                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 mb-2 add_size">
                    <span class="num-length">
                        <div class="form-group">
                            <label class=" control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.school') }}</label>
                            <input type="text"
                                class="form-control ui-autocomplete-input autocomplete-down-tab_05 graduation_school_nm cd_2" id="graduation_school_nm"
                                availableData = "{{ $tab_05['graduation_school_cd'] }}" tabindex="9" maxlength="50"
                                value=""
                                style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_05['disabled_tab05']}}>
                            <input type="hidden"
                                class="form-control input-sm text-left graduation_school_cd" id="graduation_school_cd"
                                value="">
                        </div>
                    </span>
                    <!--/.form-group -->
                </div>
                <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                    <span class="num-length">
                        <div class="form-group">
                            <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                data-original-title="" style="max-width: 150px;    display: block">
                                &nbsp
                            </label>
                                <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="graduation_school_other" tabindex="9"
                                placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.input_guide') : ''}}" class="form-control graduation_school_other nm_2" value="">
                            </div>
                    </span>
                    <!--/.form-group -->
                </div>
                <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                    <span class="num-length">
                    <div class="form-group">
                        <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                            data-original-title="" style="">
                            {{ __('messages.faculty_dept_nm') }}
                        </label>
                            <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" tabindex="9" id="faculty" class="form-control faculty"
                                value="">
                            </div>
                        </span>
                    <!--/.form-group -->
                </div>
                <div class="col-md-4 col-xl-3 col-xs-12 col-lg-4 mb-2 add_size2">
                    <span class="num-length">
                        <div class="form-group">
                            <label class=" control-label {{$check_lang=='en'?'lb-size':''}}" data-container="body" data-toggle="tooltip"
                                data-original-title="" style="max-width: 150px;    display: block">
                                {{ __('messages.major') }}
                            </label>
                            <input maxlength="50" {{$disabled}} {{$tab_05['disabled_tab05']}} type="text" id="major" class="form-control major" value=""
                                tabindex="9">
                            <span tabindex="9" style="border:none;font-size:17px; position:absolute; top: 33px; right:-33px" class="btn-remove btn-remove_06">
                                <i class="fa fa-remove"></i>
                            </span>
                        </div>
                    </span>
                    <!--/.form-group -->
                </div>
            </div>
        </div>
    </div>
</div>