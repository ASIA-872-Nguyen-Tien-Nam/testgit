@extends('popup')

@push('header')
    {!! public_url('template/css/popup/eq0100.index.css') !!}
@endpush

@section('asset_footer')
    {!! public_url('template/js/common/bootstrap_multiselect.js') !!}
    {!! public_url('template/js/common/uniform.min.js') !!}
    {!! public_url('template/js/popup/eq0100.index.js') !!}
@stop

@section('content')
    <div class="row mb-3">
        <div class="col-md-1">
            <div class="full-width">
                <a class="btn btn-primary btn-basic-setting-menu btn-issue" tabindex="1" id="add_data_row_02">
                    <i class="fa fa-plus"></i>
                </a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive table-popup" style="height:400px;">
                <div class="table_data_02" style="max-width: 700px">
                    <div class="data_row_02 condition-row">
                        <div class="row" style="align-items: center;">
                            <div class="row col-md-11" style="align-items: flex-end;">
                                <div class="col-md-2">
                                    <div class="form-group no">
                                        1
                                    </div>
                                </div>
                                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 select_dropdown">
                                    <div class="form-group">
                                        <div class="text-overfollow" style="margin-bottom: .5rem;">
                                            {{ __('messages.add_pull_down') }}</div>
                                        <select tabindex="1" class="form-control mode_item">
                                            <option tag="" value="0"></option>
                                            @if(isset($combobox[0]))
                                                @foreach($combobox[0] as $cb)
                                                    <option tag="{{$cb['numeric_value2']}}" value="{{$cb['number_cd']}}">{{$cb['name']}}</option>
                                                @endforeach
                                            @endif
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4 col-lg-4 col-xl-3 group_item_1" style="display: none;">
                                    <div class="text-overfollow title" style="margin-bottom: .5rem;"></div>
                                    <div class="form-group character_input">
                                        <input type="text" class="form-control numeric_value2" value="1" hidden/>
                                        <input type="text" class="form-control field_cd" hidden/>
                                        <input type="text" class="form-control group_cd" hidden/>
                                        <input type="text" class="form-control field_and_or" value="AND" hidden/>
                                        <span class="num-length">
                                            <input type="text" class="form-control field_val" tabindex="1" maxlength="101"/>
                                        </span>
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                <div class="col-md-4 col-lg-4 col-xl-3 group_item_2" style="display: none;">
                                    <div class="text-overfollow title" style="margin-bottom: .5rem;"></div>
                                    <div class="form-group numeric_input">
                                        <input type="text" class="form-control numeric_value2" value="2" hidden/>
                                        <input type="text" class="form-control field_cd" hidden/>
                                        <input type="text" class="form-control group_cd" hidden/>
                                        <input type="text" class="form-control field_and_or" value="AND" hidden/>
                                        <div style="display: flex;">
                                            <div class="input-group-btn input-group"
                                                style="padding-left:0px;padding-right:0px">
                                                <input type="text" class="form-control right-radius only-number numeric_from"
                                                    style=";height:38px;" tabindex="1">
                                            </div>
                                            <span style="margin-left: 10px;margin-right: 10px;line-height: 38px">~</span>
                                            <div class="input-group-btn input-group"
                                                style="padding-left:0px;padding-right:0px">
                                                <input type="text" class="form-control right-radius only-number numeric_to"
                                                    style=";height:38px;" tabindex="1">
                                            </div>

                                        </div>
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                <div class="col-md-6 col-lg-5 col-xl-4 group_item_3" style="display: none;">
                                    <div class="text-overfollow title" style="margin-bottom: .5rem;"></div>
                                    <div class="form-group date_input">
                                        <input type="text" class="form-control numeric_value2" value="3" hidden/>
                                        <input type="text" class="form-control field_cd" hidden/>
                                        <input type="text" class="form-control group_cd" hidden/>
                                        <input type="text" class="form-control field_and_or" value="AND" hidden/>
                                        <div class="date_responsive" style="display: grid;grid-template-columns: repeat(7, 1fr);">
                                            <div class="gflex input-group" style="grid-column-end: span 3;">
                                                <div class="input-group-btn">
                                                    <input type="text" class="form-control input-sm date right-radius date_from"
                                                        placeholder="yyyy/mm/dd" tabindex="1" style="min-width: 148px">
                                                    <div class="input-group-append-btn">
                                                        <button class="btn btn-transparent" type="button"
                                                            data-dtp="dtp_JGtLk" tabindex="-1"
                                                            style="background: none !important;"><i
                                                                class="fa fa-calendar"></i></button>
                                                    </div>
                                                </div>
                                            </div><!-- end .gflex -->
                                            <span style="line-height: 38px;text-align: center;">~</span>
                                            <div class="gflex input-group" style="grid-column-end: span 3;">
                                                <div class="input-group-btn">
                                                    <input type="text" class="form-control input-sm date right-radius date_to"
                                                        id="" placeholder="yyyy/mm/dd" tabindex="1" style="min-width: 148px">
                                                    <div class="input-group-append-btn">
                                                        <button class="btn btn-transparent" type="button"
                                                            data-dtp="dtp_JGtLk" tabindex="-1"
                                                            style="background: none !important;"><i
                                                                class="fa fa-calendar"></i></button>
                                                    </div>
                                                </div>
                                            </div><!-- end .gflex -->
                                        </div><!-- /.input-group -->
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                <div class="col-md-4 col-lg-4 col-xl-3 group_item_4" style="display: none;">
                                    <div class="text-overfollow title" style="margin-bottom: .5rem;"></div>
                                    <div class="form-group ln-white-text select_input">
                                        <input type="text" class="form-control numeric_value2" value="4" hidden/>
                                        <input type="text" class="form-control field_cd" hidden/>
                                        <input type="text" class="form-control group_cd" hidden/>
                                        <input type="text" class="form-control field_and_or" value="AND" hidden/>
                                        <div class="multi-select-full" id_cd="6">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                                @foreach($gender as $row)
                                                <option value="{{$row['number_cd']}}">
                                                    {{$row['name']}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="7">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                                @foreach($yes_no as $row)
                                                <option value="{{$row['number_cd']}}">
                                                    {{$row['name']}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="9">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($M0040[0]['position_cd']))
                                                @if ($M0040[0]['position_cd'] != '')
                                                    @foreach ($M0040 as $row)
                                                        <option value="{{ $row['position_cd'] }}">{{ $row['position_nm'] }}</option>
                                                    @endforeach
                                                @endif
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="10">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (!empty($M0030))
                                                @foreach ($M0030 as $key => $m0030)
                                                    <li class="active m0050">
                                                        <option value="{{ $m0030['job_cd'] }}">{{ $m0030['job_nm'] }}</option>
                                                    </li>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="11">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($office_cd))
                                                @foreach ($office_cd as $row)
                                                    <option value="{{ $row['office_cd'] }}">{{ $row['office_nm'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="12">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if(isset($combo_employee_type[0]))
                                                @foreach ($combo_employee_type as $item)
                                                <option value="{{$item['employee_typ']}}">{{$item['employee_typ_nm']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="13">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if(isset($combo_grade[0]))
                                                @foreach ($combo_grade as $item)
                                                <option value="{{$item['grade']}}">{{$item['grade_nm']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="14">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($headquarters_prefectures))
                                                @foreach($headquarters_prefectures as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="16">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($possibility_transfer))
                                                @foreach($possibility_transfer as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="17">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($nationality))
                                                @foreach($nationality as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['label']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="18">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                                @foreach($l0010_56 as $row)
                                                <option value="{{$row['number_cd']}}">
                                                    {{$row['name']}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="19">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($style))
                                                @foreach($style as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="20">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($style))
                                                @foreach($style as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="21">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($qualification_cd))
                                                @foreach ($qualification_cd as $row)
                                                    <option value="{{ $row['qualification_cd'] }}">{{ $row['qualification_nm'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="22">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($rank_cd))
                                                @foreach ($rank_cd as $row)
                                                    <option value="{{ $row['rank_cd'] }}_{{ $row['treatment_applications_no'] }}">{{ $row['rank_nm'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="23">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($final_education_kbn))
                                                @foreach($final_education_kbn as $row)
                                                <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="26">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($owning_house_kbn))
                                                @foreach ($owning_house_kbn as $row)
                                                    <option value="{{ $row['number_cd'] }}">{{ $row['name'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="27">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                                @foreach($yes_no as $row)
                                                <option value="{{$row['number_cd']}}">
                                                    {{$row['name']}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="30">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                                @foreach($marital_status as $row)
                                                <option value="{{$row['number_cd']}}">
                                                    {{$row['name']}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="33">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($reward_punishment_typ))
                                                @foreach ($reward_punishment_typ as $row)
                                                    <option value="{{ $row['number_cd'] }}">{{ $row['name'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>
                                        <div class="multi-select-full" id_cd="34">
                                            <select tabindex="1" class="form-control multiselect field_val" multiple="multiple">
                                            @if (isset($trainings))
                                                @foreach ($trainings as $row)
                                                    <option value="{{ $row['training_cd'] }}">{{ $row['label'] }}</option>
                                                @endforeach
                                            @endif
                                            </select>
                                        </div>

                                    </div>
                                    <!--/.form-group -->
                                </div>
                                <div class="col-md-10 group_item_5" style="display: none;">
                                    <input type="text" class="form-control numeric_value2" value="5" hidden/>
                                    <input type="text" class="form-control field_cd" hidden/>
                                    <input type="text" class="form-control group_cd" hidden/>
                                    <input type="text" class="form-control field_and_or" value="AND" hidden/>
                                    <div class="form-group org_input">
                                        @foreach($M0022 as $item)
                                            @if($item['organization_step'] == 1)
                                                <div class="col-sm-6 col-md-3 col-lg-2" style="margin-left: -10px;">
                                                    <div class="form-group">
                                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                                        <div class="multi-select-full">
                                                            <select system="6" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd1" multiple="multiple">
                                                                @foreach($M0020 as $temp)
                                                                <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                                                @endforeach
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            @else
                                                <div class="col-sm-6 col-md-3 col-lg-2">
                                                    <div class="form-group">
                                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                                        <div class="multi-select-full">
                                                                <select system="6" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd{{$item['organization_step']}}" multiple="multiple">
                                                                </select>
                                                            </div>
                                                    </div>
                                                </div>
                                            @endif
                                        @endforeach
                                    </div>
                                    <!--/.form-group -->
                                </div>
                                <div class="col-md-1 and-or-val" style="display: none;flex: 0 0 2.333333%;padding-top: 33px;padding-bottom: 33px;text-align: center;">
                                    <span class="text">AND</span>
                                </div>
                                <div class="col-md-2 and-or-gr" style="display: none;">
                                    <div class="form-group">
                                        <div class="text-overfollow" style="margin-bottom: .5rem;">
                                            {{ __('messages.conditional_linkage') }}</div>
                                        <select tabindex="1" class="form-control and-or">
                                            <option value="0">AND</option>
                                            <option value="1">OR</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1 remove" style="padding-left: 8px;padding-top: 33px;padding-bottom: 33px;display: flex;justify-content: end;">
                                <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-popup" >
                                    <i class="fa fa-remove" style="font-size: 19px;"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row text-center mt-3">
        <div class="col-md-12">
            <div class="full-width">
                <a id="btn-add-search" class="btn btn-outline-primary" tabindex="14" style="top: -1px">
                <i class="fa fa-plus"></i>
                    {{ __('messages.addition') }}
                </a>
            </div>
        </div>
    </div>
@stop
