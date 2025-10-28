@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/common/datatables.min.css')!!}
{!!public_url('template/css/form/i2040.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/common/datatables.min.js')!!}
<!-- {!!public_url('template/js/common/jquery.doubleScroll.js')!!} -->
{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
{!!public_url('template/js/form/i2040.index.js')!!}
@stop

@push('asset_button'){!!
    Helper::buttonRender(['i2040SaveButton','i2040ConfirmButton2','I2040DecisionCancelButton','i2040FeedbackRaterButton','i2040FeedbackEvaluatorButton','i2040ImportButton','printButton','backButton'],[],$button)
    !!}
    @endpush

    @section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        @if(isset($html) && $html != '')
            {!! $html !!}
        @else
        <div class="card">
            <div class="card-body box-input-search">
                <div class="row">
                    <input class="hidden"  id="authority_typ"  type="text" value="{{$authority_typ??''}}" />
                    <input class="hidden"  id="screen_id"  type="text" value="{{$screen_id??''}}" />
                    <div class="col-md-2 col-lg-2 col-xl-1" style="min-width: 116px;">
                        <div class="form-group">
                            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                            <select id="fiscal_year" tabindex="1" class="form-control required fiscal_year" from_screen_id ="I2040">
                                <option value="-1"></option>
                                
                                @foreach($F0010 as $temp)
                                @if($fiscal_year_redirect == 0) 
                                    <option value="{{$temp['fiscal_year']}}" {{$temp['fiscal_year'] == ($fiscal_year??-1)?'selected':''}}>{{$temp['fiscal_year']}}</option>
                                @else
                                    <option value="{{$temp['fiscal_year']}}" {{$temp['fiscal_year'] == $fiscal_year_redirect?'selected':''}}>{{$temp['fiscal_year']}}</option>
                                @endif
                                @endforeach
                            </select>
                        </div>
                    </div>
                    @if($treatment_redirect>0)
                    <div id="treatment_redirect" value="{{$treatment_redirect}}" hidden>{{$treatment_redirect}}</div>
                    @endif
                    <div class="col-md-4 col-lg-3 col-xl-2" style="min-width: 185px;">
                        <div class="form-group">
                            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.treatment_use') }}</label>
                            <div class="multi-select-full">
                                <div class="multi-select-full">
                                    <select id="treatment_applications_no" tabindex="2" class="form-control required multiselect treatment_applications_no" multiple="multiple">
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div>

                    </div><!-- end .col-md-1 -->
                    <div class="col-md-4 col-lg-4 col-xl-3">
                        <div class="form-group">
                            <label class="control-label " id="treatment_label_1">{{ __('messages.3_years_ago_treatment_application') }}</label>
                            <div class="">
                                    <select id="treat3" tabindex="2" class="form-control   " >
                                        <option value="-1"></option>
                                    </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-4 col-xl-3">
                        <div class="form-group">
                            <label class="control-label " id="treatment_label_2">{{ __('messages.2_years_ago_treatment_application') }}</label>
                            <div class="">
                                    <select id="treat2" tabindex="2" class="form-control   " >
                                        <option value="-1"></option>
                                    </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-3 col-xl-3">
                        <div class="form-group">
                            <label class="control-label " id="treatment_label_3">{{ __('messages.1_years_ago_treatment_application') }}</label>
                            <div class="">
                                    <select id="treat1" tabindex="2" class="form-control   " >
                                        <option value="-1"></option>
                                    </select>
                            </div>
                        </div>
                    </div>

                </div><!-- /.row 1 -->
                <div class="row">
                    <div class="col-md-3 col-lg-3 col-xl-2">
                       <div class="form-group">
                            <label class="control-label">{{ __('messages.employee_classification') }}</label>
                            <select id="employee_typ" tabindex="3" class="form-control">
                                <option value="-1"></option>
                                @foreach($M0060 as $temp)
                                    <option value="{{$temp['employee_typ']}}">{{$temp['employee_typ_nm']}}</option>
                                @endforeach
                            </select>
                        </div>
                    </div><!-- /.col-md-2 -->
                    @if(isset($organization_group[0]))
                        <div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
                            <div class="form-group">
                                <label class="control-label text-overfollow" data-toggle="tooltip" data-container="body"
                                    data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="display: block;">
                                    {{$organization_group[0]['organization_group_nm']}}
                                </label>
                                    <div class="multi-select-full">
                                        <select name="" id="organization_step1" class="form-control organization_cd1 multiselect" tabindex="4" organization_typ='1' multiple="multiple">
                                            @foreach($combo_organization as $row)
                                                <option value="{{$row['organization_cd_1']}}" >{{$row['organization_nm']}}</option>
                                            @endforeach
                                        </select>
                                    </div>
                            </div>
                            <!--/.form-group -->
                        </div>
                    @endif
                    @foreach($organization_group as $dt)
                        @if($dt['organization_typ'] >=2)
                            <div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
                                <div class="form-group">
                                    <label class="control-label text-overfollow" data-toggle="tooltip" data-container="body"
                                    data-original-title="{{$dt['organization_group_nm']}}" style="display: block;">
                                        {{$dt['organization_group_nm']}}
                                    </label>
                                    <div class="multi-select-full">
                                        <select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}} multiselect" tabindex="5" organization_typ = "{{$dt['organization_typ']}}" multiple="multiple">
                                        </select>
                                    </div>
                                </div>
                                <!--/.form-group -->
                            </div>
                        @endif
                    @endforeach

                </div><!-- end .row -->
                <div class="row">
                     <div class="col-md-3 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.position') }}</label>
                            <div class="multi-select-full">
                                <select id="position_cd" tabindex="6" class="form-control multiselect " multiple="multiple">
                                    @foreach($M0040 as $temp)
                                    <option value="{{$temp['position_cd']}}">{{$temp['position_nm']}}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                    </div><!-- /.col-md-2 -->
                    <div class="col-md-3 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.grade') }}</label>
                            <div class="multi-select-full">
                                <select id="grade" tabindex="7" class="form-control multiselect " multiple="multiple">
                                    @foreach($M0050 as $temp)
                                    <option value="{{$temp['grade']}}">{{$temp['grade_nm']}}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                    </div><!-- /.col-md-1 -->
                    <div class="col-sm-6 col-md-3 col-lg-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.evaluator') }}</label>
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    @if($employee_cd_redirect != '')
                                    <input type="hidden" class="employee_cd_hidden employee_cd" id="employee_cd" value="{{$employee_cd_redirect}}" />
                                    @else
                                    <input type="hidden" class="employee_cd_hidden employee_cd" id="employee_cd" value="" />
                                    @endif
                                    <input type="text" id="employee_nm1" class="form-control indexTab employee_nm" tabindex="7" maxlength="101" value="{{$employee_nm_redirect}}" style="padding-right: 40px;" />
                                </span>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-3 col-lg-2">
                        <div class="form-group">
                            <label class="control-label " lb-required="{{ __('messages.required') }}">{{ __('messages.rater') }}</label>
                            <div class="input-group-btn input-group div_employee_cd">
                                @if($authority_typ == 2 || $authority_typ == 6)
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden" id="rater" value="{{$employee_cd ?? ''}}" />
                                    <input type="text" id="employee_nm2" class="form-control indexTab employee_nm" tabindex="7" maxlength="101" value="{{$employee_nm ?? ''}}" style="padding-right: 40px;" disabled="disabled" />
                                </span>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" disabled="disabled">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                                @else
                                <span class="num-length">
                                    <input type="hidden" class="employee_cd_hidden employee_cd" id="rater" value="" />
                                    <input type="text" id="rater_nm" class="form-control indexTab employee_nm" tabindex="7" maxlength="101" value="" style="padding-right: 40px;" />
                                </span>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                                @endif
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-xl-2">
                        <div class="form-group">
                            <label class="control-label label_evalute_step" lb-required="{{ __('messages.required') }}">{{ __('messages.evaluation_step') }}</label>
                            <div class="multi-select-full">
                                <select name="" id="evalute_step" class="form-control evalute_step multiselect" tabindex="4" organization_typ='1' multiple="multiple">
                                    @foreach($L0010 as $temp)
                                        <option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                    </div><!-- /.col-md-2 -->
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.rank') }}</label>
                            <select id="rank" tabindex="9" class="form-control  " >
                                <option value="-1"></option>

                            </select>
                        </div>
                    </div><!-- /.col-md-1 -->



                </div><!-- end .row -->
                @include('Master::items.index')

					<div class="mr-auto">
						<div class="form-group text-right">
							<div class="full-width">
								<a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="10" >
									<i class="fa fa-search"></i>
									{{ __('messages.search_update') }}
								</a>
							</div><!-- end .full-width -->
						</div>
					</div>
                <input type="hidden"  class="anti_tab" name="">
            </div><!--/.card-body -->
        </div><!--/.card -->
        <div class="card">
            <div class="card-body" id="result">
                @include('Master::i2040.search')
            </div><!-- .card-body -->
        </div><!-- .card -->
        @endif
    </div><!--/.container-fluid -->
    <input type="file" id="import_file" style="display: none" accept=".csv">
    @stop