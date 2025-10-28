@extends('employee_information/elayout')

@push('header')
    {!! public_url('template/css/employeeinfo/eq0200.index.css') !!}
    <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
@endpush

@section('asset_footer')
    <!-- <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script> -->
    {!! public_url('template/js/common/jquery.ui.touch-punch.min.js') !!}
    {!! public_url('template/js/employeeinfo/eq0200.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::dropdownRenderEmployeeInformation(['backButton']) !!}
@endpush
@section('content')
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row" style="margin-left: 3px">
                    <div class="col-md-3">
                        <div class="form-group">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <span class="num-length">
                                        <input type="text" id="key_search" class="form-control" maxlength="100"
                                            value="" autocomplete="off" tabindex="1">
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" id="btn_search" type="button" tabindex="1">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </span>
                        </div>
                    </div>
                    @if(isset($open_popup)&&$open_popup>=1)
                    <div class="col-md-9">
                        <div class="personal_setting">
                            <i id="personal_setting_btn" class="fa fa-user" aria-hidden="true" tabindex="1"></i>
                        </div>
                    </div>
                    @endif
                </div>
                {{-- Tab --}}
                @if (isset($init_data) && !empty($init_data))
                    <ul class="nav nav-tabs tab-style">
                        {{-- 組織図 --}}
                        @if ($init_data['organization_chart_use_typ'] == 1)
                            @if ($init_data['initial_display'] == 1)
                                <li class="nav-item">
                                    <a class="nav-link hei active show eq0200_tab" data-toggle="tab" href="#tab1" role="tab"
                                        aria-selected="true" tab_id="organization">
                                        {{ __('messages.organization_chart') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @else
                                <li class="nav-item">
                                    <a class="nav-link hei eq0200_tab" data-toggle="tab" href="#tab1" role="tab" tab_id="organization">
                                        {{ __('messages.organization_chart') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @endif
                        @endif
                        {{-- 座席表 --}}
                        @if ($init_data['seating_chart_use_typ'] == 1)
                            @if ($init_data['initial_display'] == 2)
                                <li class="nav-item">
                                    <a class="nav-link hei active show eq0200_tab" data-toggle="tab" href="#tab2" role="tab"
                                        aria-selected="true" tab_id="seat">
                                        {{ __('messages.seat_chart') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @else
                                <li class="nav-item">
                                    <a class="nav-link hei eq0200_tab" data-toggle="tab" href="#tab2" role="tab" tab_id="seat">
                                        {{ __('messages.seat_chart') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @endif
                        @endif
                        {{-- 検索 --}}
                        @if ($init_data['search_function_use_typ'] == 1)
                            @if ($init_data['initial_display'] == 3)
                                <li class="nav-item">
                                    <a class="nav-link hei active show eq0200_tab" data-toggle="tab" href="#tab3" role="tab"
                                        aria-selected="true" tab_id="search">
                                        {{ __('messages.search') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @else
                                <li class="nav-item">
                                    <a class="nav-link hei eq0200_tab" data-toggle="tab" href="#tab3" role="tab" tab_id="search">
                                        {{ __('messages.search') }}
                                        <div class="caret"></div>
                                    </a>
                                </li>
                            @endif
                        @endif
                    </ul>

                    <div class="tab-content list_detail w-result-tabs">
                        {{-- tab1 content --}}
                        {{-- 組織図 --}}
                        @if ($init_data['organization_chart_use_typ'] == 1)
                            <div class="tab-pane fade {{ $init_data['initial_display'] == 1 ? 'active show' : '' }}"
                                id="tab1" style="position: relative;">
                                @include('EmployeeInfo::eq0200.organization')
                            </div>
                        @endif
                        {{-- tab2 content --}}
                        {{-- 座席表 --}}
                        @if ($init_data['seating_chart_use_typ'] == 1)
                            <div class="tab-pane fade {{ $init_data['initial_display'] == 2 ? 'active show' : '' }}"
                                id="tab2">
                                <!-- scroll top -->
                                <div class="row" style="margin-top: -20px">
                                    <div class="col-md-12">
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div id="rightcontent1" class="col-sm-12 col-md-10 col-lg-9 col-ltx-10 wrapper1" style="padding-left: 0px;overflow: auto">
                                                    <div class="seat_content">
                                                        <div class="layout">
                                                            <div class="layout-width" style="width: 1464px"></div>
                                                        </div>
                                                    </div>
                                                </div> <!-- end #leftcontent -->
                                                <div id="leftcontent1" class="col-sm-12 col-md-2 col-lg-3 col-ltx-2" style="padding-right: 0px">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="row">
                                            <div class="col-md-2" style="padding-left: 14px;">
                                                <div class="form-group">
                                                    <select id="seat_area_select" class="form-control" tabindex="1">
                                                        <option value="0">{{ __('messages.select_floor') }}</option>
                                                        @isset($floors)
                                                            @foreach ($floors as $item)
                                                                @if ($floor_id == $item['floor_id'])
                                                                <option value="{{ $item['floor_id'] }}" selected="selected">{{ $item['floor_name'] }}</option>    
                                                                @else
                                                                <option value="{{ $item['floor_id'] }}">{{ $item['floor_name'] }}</option>
                                                                @endif
                                                            @endforeach
                                                        @endisset
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-lg-3 col-xxl-4">
                                                <button class="btn btn-outline-primary btn-refresh" mode="4" style="margin-left: 10px;margin-right: 5px;">
                                                    <i class="fa fa-refresh" aria-hidden="true"></i>
                                                </button>
                                                <span class="sys_refer">{{ $floor['date_refer'] ?? ''}}</span>
                                            </div>
                                            <div class="col-sm-12 col-md-5 col-lg-5 col-xxl-7">
                                                <label class="suggest_text">{{ __('messages.seat_drag_label') }}</label>
                                                <input type="hidden" id="seat_mode" value="0">
                                                <input type="hidden" id="employee_cd_login" value="{{ $employee_cd }}">
                                            </div>
                                            <div class="col-md-1 col-lg-2 btn-seat" style="{{ (($seating_chart_typ == 1 && $btn_seat_register == 1) || $seating_chart_typ == 2) ? 'display: flex;justify-content: flex-end;' : 'display: none' }}">
                                            {!! Helper::buttonRenderEmployeeInformation(['addNewButton']) !!}  
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12 communication_content">
                                                @include('EmployeeInfo::eq0200.seat')                                                    
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endif
                        {{-- tab3 content --}}
                        @if ($init_data['search_function_use_typ'] == 1)
                            <div class="tab-pane fade {{ $init_data['initial_display'] == 3 ? 'active show' : '' }}"
                                id="tab3">
                                @include('EmployeeInfo::eq0200.search')
                            </div>
                        @endif
                    </div>
                @endif
            </div>
        </div>
    </div>
@stop
