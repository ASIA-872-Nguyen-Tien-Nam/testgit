<div class="row row_display">
    @if (isset($disabled) && $disabled == '' && (isset($tab_07['disabled_tab07']) && $tab_07['disabled_tab07'] == ''))
        <div class="col-xl-1 col-sm-12 col-md-1" style="min-width:60px">
            <div class="form-group">
                <label
                    class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }} {{ $check_lang == 'en' ? 'lable-check' : '' }}">{{ __('messages.commuting_route') }}&nbsp;
                </label>
                <div class="full-width">
                    <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="add_row_data_08"
                        tabindex="1">
                        +
                    </a>
                </div><!-- end .full-width -->
            </div>
        </div>

        <div class="col-md-11 col-lg-11 col-xl-11 col-sm-12 row">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-2" style="min-width: 180px">
                <div class="form-group">
                    <label
                        class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.total_commuting_allowance') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control numeric" id="total_expenses" maxlength="20" tabindex="1"
                            value="{{ $tab_07['total_expenses']['total_expenses'] ?? '' }}" disabled {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
    @else
        <div class="col-xl-1 col-sm-12 col-md-1 dis-n" style="{{isset ($disabled) && $disabled == '' ? '' : 'flex: 0 0 3%;'}}"></div>
        <div class="col-xl-10 col-sm-12 col-md-11 row">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                <div class="form-group">
                    <label
                        class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.total_commuting_allowance') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control numeric" id="total_expenses" maxlength="20" tabindex="1"
                            value="{{ $tab_07['total_expenses']['total_expenses'] ?? '' }}" disabled {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
    @endif
    
</div>
{{-- ---- --}}
<div class="table_data_08">
    @foreach ($tab_07['data_tab_07'] as $index => $row)
        <div class="row row_display list_tab_07">
            <div class="col-xl-1 col-sm-12 col-md-1" style="{{isset ($disabled) && $disabled == '' ? '' : 'flex: 0 0 3%;'}}">
                <div class="form-group" style="{{isset ($disabled) && $disabled == '' ? 'width:60px' : ''}}">
                    <label class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}"
                        style="width:100%">&nbsp</label>
                    <label class="id_08 label_number_id_8" style="padding-left:4px">{{ $index + 1 }}</label>
                    <input type="text" class="form-control input-sm text-left d-none detail_no_tab07"
                        value="{{ $row['detail_no'] ?? '' }}">
                </div>
            </div>
            <div class="col-xl-10 col-sm-12 col-md-11 row_append_08 row">
                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 ">
                    <div class="form-group">
                        <label
                            class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.means_of_commuting') }}</label>
                        <select name="" id="commuting_method"
                            class="form-control vehicle_select commuting_method" tabindex="1" organization_typ=""
                            {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            <option></option>
                            @foreach ($tab_07['commuting_method'] as $com)
                                <option value="{{ $com['number_cd'] }}"
                                    {{ ($row['commuting_method'] ?? 0) == $com['number_cd'] ? 'selected' : '' }}>
                                    {{ $com['name'] }}</option>
                            @endforeach
                        </select>
                    </div>
                    <!--/.form-group -->
                </div>
                @if ($row['commuting_method'] == 1)
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
                        <div class="col-9" style="padding-left:0px">
                            <div class="form-group">
                                <label
                                    class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_distance') }}</label>
                                <span class="num-length">
                                    <input type="text"
                                        class="form-control numeric points_to td-to commuting_distance"
                                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                                        value="{{ $row['commuting_distance'] ?? '' }}"
                                        {{ $disabled }} {{$tab_07['disabled_tab07']}} />
                                </span>
                            </div>
                        </div>
                        <div class="col-3 row" style="padding-left:0px; ">
                            <label class="control-label" style="width:100%">&nbsp</label>
                            <label class="control-label">km</label>
                        </div>

                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4 block_append_8" style="min-width:190px">
                        <div class="form-group">
                            <label
                                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label {{ $check_lang == 'en' ? 'lable-check' : '' }}"
                                data-container="body" data-toggle="tooltip" data-original-title=""
                                style="display: block">
                                {{ __('messages.driving_license_renewal_deadline') }}
                            </label>
                            <div class="input-group-btn input-group ">
                                <input type="text" id="drivinglicense_renewal_deadline"
                                    class="form-control input-sm date right-radius drivinglicense_renewal_deadline"
                                    placeholder="yyyy/mm/dd" tabindex="1"
                                    value="{{ $row['drivinglicense_renewal_deadline'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_allowance') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses"  @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-2" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 2)
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
                        <div class="col-9" style="padding-left:0px">
                            <div class="form-group">
                                <label
                                    class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_distance') }}</label>

                                <span class="num-length">
                                    <input type="text"
                                        class="form-control numeric points_to td-to commuting_distance"
                                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                                        value="{{ $row['commuting_distance'] ?? '' }}"
                                        {{ $disabled }} {{$tab_07['disabled_tab07']}} />
                                </span>
                            </div>
                        </div>
                        <div class="col-3 row" style="padding-left:0px">
                            <label class="control-label" style="width:100%">&nbsp</label>
                            <label class="control-label">km</label>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_allowance') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-1" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 3)
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_home') }}</label>
                            <span class="num-length">
                                <input type="text" id="departure_point" tabindex="1"
                                    class="form-control departure_point" value="{{ $row['departure_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_workplace') }}</label>
                            <span class="num-length">
                                <input type="text" id="arrival_point" tabindex="1"
                                    class="form-control arrival_point" value="{{ $row['arrival_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
                            <select name="" id="commuter_ticket_classification-3"
                                class="form-control commuter_ticket_classification" tabindex="1"
                                organization_typ="" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                @foreach ($tab_07['commuter_ticket_classification1'] as $com)
                                    <option value="{{ $com['number_cd'] }}"
                                        numeric_value1="{{ $com['numeric_value1'] }}"
                                        {{ ($row['commuter_ticket_classification'] ?? 0) == $com['number_cd'] ? 'selected' : '' }}>
                                        {{ $com['name'] }}</option>
                                @endforeach
                            </select>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-3" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 4)
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.bus_start') }}</label>
                            <span class="num-length">
                                <input type="text" id="departure_point" tabindex="1"
                                    class="form-control departure_point" value="{{ $row['departure_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.end_of_bus_section') }}</label>
                            <span class="num-length">
                                <input type="text" id="arrival_point" tabindex="1"
                                    class="form-control arrival_point" value="{{ $row['arrival_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
                            <select name="" id="commuter_ticket_classification-5"
                                class="form-control commuter_ticket_classification" tabindex="1"
                                organization_typ="" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                @foreach ($tab_07['commuter_ticket_classification1'] as $com)
                                    <option value="{{ $com['number_cd'] }}"
                                        numeric_value1="{{ $com['numeric_value1'] }}"
                                        {{ ($row['commuter_ticket_classification'] ?? 0) == $com['number_cd'] ? 'selected' : '' }}>
                                        {{ $com['name'] }}</option>
                                @endforeach
                            </select>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-5" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 5)
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
                        <div class="col-9" style="padding-left:0px">
                            <div class="form-group">
                                <label
                                    class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_distance') }}</label>
                                <span class="num-length">
                                    <input type="text"
                                        class="form-control numeric points_to td-to commuting_distance"
                                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                                        value="{{ $row['commuting_distance'] ?? '' }}"
                                        {{ $disabled }} {{$tab_07['disabled_tab07']}} />
                                </span>
                            </div>
                        </div>
                        <div class="col-3 row" style="padding-left:0px; ">
                            <label class="control-label" style="width:100%">&nbsp</label>
                            <label class="control-label">km</label>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4 block_append_8" style="min-width:190px">
                        <div class="form-group">
                            <label
                                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label {{ $check_lang == 'en' ? 'lable-check' : '' }}"
                                data-container="body" data-toggle="tooltip" data-original-title=""
                                style="display: block">
                                {{ __('messages.driving_license_renewal_deadline') }}
                            </label>
                            <div class="input-group-btn input-group ">
                                <input type="text" id="drivinglicense_renewal_deadline"
                                    class="form-control input-sm date right-radius drivinglicense_renewal_deadline"
                                    placeholder="yyyy/mm/dd" tabindex="1"
                                    value="{{ $row['drivinglicense_renewal_deadline'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button"
                                        data-dtp="dtp_wH14i" tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_allowance') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-2" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 6)
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_home') }}</label>
                            <span class="num-length">
                                <input type="text" id="departure_point" tabindex="1"
                                    class="form-control departure_point" value="{{ $row['departure_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_workplace') }}</label>
                            <span class="num-length">
                                <input type="text" id="arrival_point" tabindex="1"
                                    class="form-control arrival_point" value="{{ $row['arrival_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
                            <select name="" id="commuter_ticket_classification-4"
                                class="form-control commuter_ticket_classification" tabindex="1"
                                organization_typ="" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                @foreach ($tab_07['commuter_ticket_classification2'] as $com)
                                    <option value="{{ $com['number_cd'] }}"
                                        numeric_value1="{{ $com['numeric_value1'] }}"
                                        {{ ($row['commuter_ticket_classification'] ?? 0) == $com['number_cd'] ? 'selected' : '' }}>
                                        {{ $com['name'] }}</option>
                                @endforeach
                            </select>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-4" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 7)
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
                        <div class="col-9" style="padding-left:0px">
                            <div class="form-group">
                                <label
                                    class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_distance') }}</label>

                                <span class="num-length">
                                    <input type="text"
                                        class="form-control numeric points_to td-to commuting_distance"
                                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                                        value="{{ $row['commuting_distance'] ?? '' }}"
                                        {{ $disabled }} {{$tab_07['disabled_tab07']}} />
                                </span>
                            </div>
                        </div>
                        <div class="col-3 row" style="padding-left:0px">
                            <label class="control-label" style="width:100%">&nbsp</label>
                            <label class="control-label">km</label>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_allowance') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-1" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @elseif ($row['commuting_method'] == 8)
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_method_details') }}</label>
                            <span class="num-length">
                                <input type="text" id="commuting_method_detail" tabindex="1"
                                    class="form-control commuting_method_detail"
                                    value="{{ $row['commuting_method_detail'] ?? '' }}" maxlength="20"
                                    {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.point_departure') }}</label>
                            <span class="num-length">
                                <input type="text" id="departure_point" tabindex="1"
                                    class="form-control departure_point" value="{{ $row['departure_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.point_arrival') }}</label>
                            <span class="num-length">
                                <input type="text" id="arrival_point" tabindex="1"
                                    class="form-control arrival_point" value="{{ $row['arrival_point'] ?? '' }}"
                                    maxlength="20" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
                        <div class="form-group">
                            <label
                                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_allowance') }}</label>
                            <span class="num-length">
                                <div class="input-group-btn btn-left input_money">
                                    <input type="text" class="form-control money commuting_expenses" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                                        id="commuting_expenses-6" maxlength="9" tabindex="1"
                                        value="{{ $row['commuting_expenses'] ?? '' }}" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" disabled=""><i
                                                class="fa fa-yen"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                @else
                    <div></div>
                @endif
            </div>
            @if (isset($disabled) && $disabled == '' && (isset($tab_07['disabled_tab07']) && $tab_07['disabled_tab07'] == ''))
                <div class="col-xl-1 col-sm-12 col-md-11 ">
                    <div class="form-group">
                        <label class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">&nbsp</label>
                        <span class="num-length" style="text-align:center;margin-top:5px">
                            <span tabindex="1" style="border:none" class="btn-remove btn-remove_08">
                                <i class="fa fa-remove"></i>
                            </span>
                        </span>
                    </div>
                </div>
            @endif
        </div>
    @endforeach
    <div class="row row_data_08 list_tab_07" hidden>
        <div class="col-xl-1 col-sm-12 col-md-1">
            <div class="form-group" style="width:60px">
                <label class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}"
                    style="width:100%">&nbsp</label>
                <label class="id_08 label_number_id_8" style="padding-left:4px">1</label>
                <input type="text" class="form-control input-sm text-left d-none detail_no_tab07" value="0">
            </div>
        </div>
        <div class="col-xl-10 col-sm-12 col-md-11 row_append_08 row ">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 ">
                <div class="form-group">
                    <label
                        class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.means_of_commuting') }}</label>
                    <select name="" id="commuting_method" class="form-control vehicle_select commuting_method"
                        tabindex="1" organization_typ="" {{ $disabled }} {{$tab_07['disabled_tab07']}}>
                        <option></option>
                        @foreach ($tab_07['commuting_method'] as $com)
                            <option value="{{ $com['number_cd'] }}"
                                {{ ($tab_07['data_tab_07']['commuting_method'] ?? '') == $com['number_cd'] ? 'selected' : '' }}>
                                {{ $com['name'] }}</option>
                        @endforeach
                    </select>
                </div>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-xl-1 col-sm-12 col-md-11 ">
            <div class="form-group">
                <label class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">&nbsp</label>
                <span class="num-length" style="text-align:center;margin-top:5px">
                    <span tabindex="1" style="border:none" class="btn-remove btn-remove_08">
                        <i class="fa fa-remove"></i>
                    </span>
                </span>
            </div>
        </div>
    </div>
</div>
<div class="vehicle_hidden_1" hidden>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
        <div class="col-9" style="padding-left:0px">
            <div class="form-group">
                <label
                    class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_distance') }}</label>

                <span class="num-length">
                    <input type="text" class="form-control numeric points_to td-to commuting_distance"
                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                        value="" />
                </span>
            </div>
        </div>
        <div class="col-3 row" style="padding-left:0px">
            <label class="control-label" style="width:100%">&nbsp</label>
            <label class="control-label">km</label>
        </div>

        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_allowance') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-1" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="vehicle_hidden_2" hidden>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8" style="display:flex">
        <div class="col-9" style="padding-left:0px">
            <div class="form-group">
                <label
                    class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_distance') }}</label>
                <span class="num-length">
                    <input type="text" class="form-control numeric points_to td-to commuting_distance"
                        id="commuting_distance" maxlength="8" decimal="2" tabindex="1"
                        value="" />
                </span>
            </div>
        </div>
        <div class="col-3 row" style="padding-left:0px; ">
            <label class="control-label" style="width:100%">&nbsp</label>
            <label class="control-label">km</label>
        </div>

        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4 block_append_8" style="min-width:190px">
        <div class="form-group">
            <label
                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label {{ $check_lang == 'en' ? 'lable-check' : '' }}"
                data-container="body" data-toggle="tooltip" data-original-title="" style="display: block">
                {{ __('messages.driving_license_renewal_deadline') }}
            </label>
            <div class="input-group-btn input-group ">
                <input type="text" id="drivinglicense_renewal_deadline"
                    class="form-control input-sm date right-radius drivinglicense_renewal_deadline"
                    placeholder="yyyy/mm/dd" tabindex="1" value="">
                <div class="input-group-append-btn">
                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                        tabindex="-1" style="background: none !important"><i class="fa fa-calendar"></i></button>
                </div>
            </div>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="{{ $check_lang == 'en' ? 'lb-size' : '' }} control-label">{{ __('messages.commuting_allowance') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-2" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="vehicle_hidden_3" hidden>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_home') }}</label>
            <span class="num-length">
                <input type="text" id="departure_point" tabindex="1" class="form-control departure_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_workplace') }}</label>
            <span class="num-length">
                <input type="text" id="arrival_point" tabindex="1" class="form-control arrival_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
            <select name="" id="commuter_ticket_classification-3"
                class="form-control commuter_ticket_classification" tabindex="1" organization_typ="">
                @foreach ($tab_07['commuter_ticket_classification1'] as $com)
                    <option value="{{ $com['number_cd'] }}" numeric_value1="{{ $com['numeric_value1'] }}">
                        {{ $com['name'] }}</option>
                @endforeach
            </select>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-3" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="vehicle_hidden_4" hidden>

    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_home') }}</label>
            <span class="num-length">
                <input type="text" id="departure_point" tabindex="1" class="form-control departure_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.station_closest_to_workplace') }}</label>
            <span class="num-length">
                <input type="text" id="arrival_point" tabindex="1" class="form-control arrival_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
            <select name="" id="commuter_ticket_classification-4"
                class="form-control commuter_ticket_classification" tabindex="1" organization_typ="">
                @foreach ($tab_07['commuter_ticket_classification2'] as $com)
                    <option value="{{ $com['number_cd'] }}" numeric_value1="{{ $com['numeric_value1'] }}">
                        {{ $com['name'] }}</option>
                @endforeach
            </select>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-4" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="vehicle_hidden_5" hidden>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.bus_start') }}</label>
            <span class="num-length">
                <input type="text" id="departure_point" tabindex="1" class="form-control departure_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.end_of_bus_section') }}</label>
            <span class="num-length">
                <input type="text" id="arrival_point" tabindex="1" class="form-control arrival_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuter_ticket_classification') }}</label>
            <select name="" id="commuter_ticket_classification-5"
                class="form-control commuter_ticket_classification" tabindex="1" organization_typ="">
                @foreach ($tab_07['commuter_ticket_classification1'] as $com)
                    <option value="{{ $com['number_cd'] }}" numeric_value1="{{ $com['numeric_value1'] }}">
                        {{ $com['name'] }}</option>
                @endforeach
            </select>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.communication_ticket_amount') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-5" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
<div class="vehicle_hidden_6" hidden>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_method_details') }}</label>
            <span class="num-length">
                <input type="text" id="commuting_method_detail" tabindex="1"
                    class="form-control commuting_method_detail" value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.point_departure') }}</label>
            <span class="num-length">
                <input type="text" id="departure_point" tabindex="1" class="form-control departure_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.point_arrival') }}</label>
            <span class="num-length">
                <input type="text" id="arrival_point" tabindex="1" class="form-control arrival_point"
                    value="" maxlength="20">
            </span>
        </div>
        <!--/.form-group -->
    </div>
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 block_append_8">
        <div class="form-group">
            <label
                class="control-label {{ $check_lang == 'en' ? 'lb-size' : '' }}">{{ __('messages.commuting_allowance') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left input_money">
                    <input type="text" class="form-control money commuting_expenses" id="commuting_expenses-6" @if(isset($screen_use) && $screen_use == 'EQ0101') placeholder="" @else placeholder="{{ __('messages.halfsize_number') }}" @endif
                        maxlength="9" tabindex="1" value="">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i
                                class="fa fa-yen"></i></button>
                    </div>
                </div>
            </span>
        </div>
        <!--/.form-group -->
    </div>
</div>
