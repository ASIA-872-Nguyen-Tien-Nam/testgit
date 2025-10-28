@php
    if ($system == 1) {
        $layout = 'layout';
        $button = Helper::buttonRender(['downloadButton', 'backButton']);
    } else if ($system == 2) {
        $layout = 'oneonone/layout';
        $button = Helper::dropdownRender1on1(['downloadButton', 'backButton']);
    } elseif ($system == 3) {
        $layout = 'mlayout';
        $button = Helper::dropdownRenderMulitireview(['downloadButton', 'backButton']);
    } elseif ($system == 4) {
        $layout = 'slayout';
        $button = Helper::buttonRender(['downloadButton', 'backButton']);
    } elseif ($system == 5) {
        $layout = 'weeklyreport/layout';
        $button = Helper::dropdownRenderWeeklyReport(['downloadButton', 'backButton']);
    }
@endphp

@section('asset_header')
    {!! public_url('template/css/form/q9001.index.css') !!}
@stop
@extends($layout)
@push('asset_button')
    {!! $button !!}
    @section('asset_footer')
        <!-- START LIBRARY JS -->
        {!! public_url('template/js/form/q9001.index.js') !!}
	@stop
@endpush

@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid mt-2">
        <div class="card" style="margin-bottom: 15px;padding-bottom:4px">
            <div class="card-body box-input-search" id="search-box" style="padding-bottom: 0px;">
                <div class="row">
                    {{-- 社員名 --}}
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group rq">
                            <label class="control-label">{{ __('q9001.employee_name') }}</label>
                            </label>
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden" id="employee_cd" value="" />
                                    @if ($system == 1 || $system == 4)
                                    <input type="text" id="employee_nm" class="form-control indexTab employee_nm" autofocus tabindex="1" maxlength="101" value="" />    
                                    @elseif ($system == 2)
                                    <input type="text" fiscal_year_1on1="{{ $fiscal_year ?? 0 }}" id="employee_nm" autofocus class="form-control indexTab employee_nm_1on1" tabindex="1" maxlength="101" value="" />
                                    @elseif ($system == 3)
                                    <input type="text" fiscal_year_mulitireview="{{ $fiscal_year ?? 0 }}" id="employee_nm" autofocus class="form-control indexTab employee_nm_mulitireview" tabindex="1" maxlength="101" value="" />
                                    @elseif ($system == 5)
                                    <input type="text" fiscal_year_weeklyreport="{{ $fiscal_year ?? 0 }}" id="employee_nm" autofocus class="form-control indexTab employee_nm_weeklyreport" tabindex="1" maxlength="101" value="" />
                                    @endif
								</span>
								<div class="input-group-append-btn">
                                    @if ($system == 1 || $system == 4)
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 2)
                                    <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 3)
                                    <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @elseif ($system == 5)
                                    <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
                                    @endif
								</div>
                            </div>
                        </div>
                    </div>
                    {{-- 組織 --}}
                    @if (isset($M0022) && !empty($M0022))
                    @foreach($M0022 as $item)
                        @if($item['organization_step'] == 1)
                            <div class="col-md-2 col-lg-2 col-xl-2">
                                <div class="form-group">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                    <div class="multi-select-full">
                                        <select system="{{ $system }}" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="2" class="form-control multiselect organization_cd1" multiple="multiple">
                                            @foreach($M0020 as $temp)
                                            <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                            </div>
                        @else
                            <div class="col-md-2 col-lg-2 col-xl-2">
                                <div class="form-group">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                    <div class="multi-select-full">
                                            <select system="{{ $system }}" id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="2" class="form-control multiselect organization_cd{{$item['organization_step']}}" multiple="multiple">
                                            </select>
                                        </div>
                                </div>
                            </div>
                        @endif
                    @endforeach    
                    @endif
                </div>
                <div class="row">
                    {{-- 役職 --}}
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
							<label class="control-label ">{{__('messages.position')}}</label>
							<select id="position_cd" tabindex="3" class="form-control ">
								<option value="-1"></option>
                                @isset($M0040)
                                    @foreach($M0040 as $temp)
                                    <option value="{{$temp['position_cd']}}">{{$temp['position_nm']}}</option>
                                    @endforeach    
                                @endisset
							</select>
						</div>
                        <!--/.form-group -->
                    </div>
                    {{-- 職種 --}}
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{__('messages.job')}}</label>
							<select id="job_cd" tabindex="4" class="form-control ">
								<option value="-1"></option>
                                @isset($M0030)
                                    @foreach($M0030 as $temp)
                                    <option value="{{$temp['job_cd']}}">{{$temp['job_nm']}}</option>
                                    @endforeach
                                @endisset
							</select>
                        </div>
                        <!--/.form-group -->
                    </div>
                    {{-- 等級 --}}
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
							<label class="control-label ">{{__('messages.grade')}}</label>
							<select id="grade" tabindex="5" class="form-control ">
								<option value="-1"></option>
                                @isset($M0050)
                                    @foreach($M0050 as $temp)
                                    <option value="{{$temp['grade']}}">{{$temp['grade_nm']}}</option>
                                    @endforeach
                                @endisset
							</select>
						</div>
                        <!--/.form-group -->
                    </div>
                    {{-- 社員区分 --}}
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
							<label class="control-label">{{__('messages.employee_classification')}}</label>
							<select id="employee_typ" tabindex="6" class="form-control">
								<option value="-1"></option>
                                @isset($M0060)
                                    @foreach($M0060 as $temp)
                                    <option value="{{$temp['employee_typ']}}">{{$temp['employee_typ_nm']}}</option>
                                    @endforeach    
                                @endisset
							</select>
						</div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-4 col-lg-4 col-xl-4">
                        <div class="form-group">
                            <label class="control-label">&nbsp;</label>
                            <div class="full-width text-right">
                                <a href="javascript:;" class="btn btn-outline-primary btn-outline-primary_search" tabindex="7" id="btn_search">
                                    <i class="fa fa-search"></i>
                                    {{ __('q9001.search') }}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- end .card-body -->
        </div><!-- end .card -->
        <div class="card">
            <div class="card-body">
                <div id="result">
                    @include('Master::q9001.refer')
                </div>
            </div>
        </div><!-- end .card -->
		<input type="hidden" class="anti_tab" name="">
		<input type="hidden" id="system" value="{{ $system }}" />
		<input type="hidden" id="fiscal_year" value="{{ $fiscal_year }}" />
    </div><!-- end .container-fluid -->
@stop