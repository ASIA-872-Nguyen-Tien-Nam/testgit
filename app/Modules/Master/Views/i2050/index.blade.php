@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/i2050.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/form/i2050.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
	Helper::buttonRender(['backStatus','backButton'])
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
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
							<select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
								<option value="-1"></option>
								@foreach($F0010 as $temp)
								<option value="{{$temp['fiscal_year']}}">{{$temp['fiscal_year']}}</option>
								@endforeach
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.treatment_use') }}</label>
							<div class="multi-select-full">
								<select id="treatment_applications_no" tabindex="2" class="form-control required multiselect treatment_applications_no" multiple="multiple">
									
								</select>
							</div>
						</div>

					</div>
				</div><!-- end .row -->
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">{{ __('messages.employee_classification') }}</label>
							<select id="employee_typ" tabindex="7" class="form-control">
								<option value="-1"></option>
								@foreach($M0060 as $temp)
								<option value="{{$temp['employee_typ']}}">{{$temp['employee_typ_nm']}}</option>
								@endforeach
							</select>
						</div>
					</div>
						@foreach($M0022 as $item)
							@if($item['organization_step'] == 1)
								<div class="col-sm-6 col-md-3 col-lg-2">
									<div class="form-group">
										<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
										<div class="multi-select-full">
											<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd1" multiple="multiple">
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
												<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control multiselect organization_cd{{$item['organization_step']}}" multiple="multiple">
												</select>
											</div>
									</div>
								</div>
							@endif
						@endforeach	
				</div><!-- end .row -->
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<div class="text-overfollow" data-container="body" style="margin-bottom: .5rem;">{{ __('messages.position') }}</div>
							<div class="multi-select-full">
								<select id="position_cd" tabindex="9" class="form-control multiselect" multiple="multiple">
									@foreach($M0040 as $temp)
									<option value="{{$temp['position_cd']}}">{{$temp['position_nm']}}</option>
									@endforeach
								</select>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<div class="text-overfollow" data-container="body" style="margin-bottom: .5rem;">{{ __('messages.grade') }}</div>
							<div class="multi-select-full">
								<select id="grade" tabindex="10" class="form-control multiselect" multiple="multiple">
									@foreach($M0050 as $temp)
								<option value="{{$temp['grade']}}">{{$temp['grade_nm']}}</option>
								@endforeach
								</select>
							</div>
						</div>
					</div>	
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{ __('messages.evaluator') }}</label>
							<div class="input-group-btn input-group div_employee_cd">
								<span class="num-length">
									<input type="hidden" class="employee_cd_hidden" id="employee_cd" value="" />
									<input type="text" id="employee_nm" class="form-control indexTab employee_nm" tabindex="11" maxlength="101" value="" style="padding-right: 40px;" />
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
							<label class="control-label ">{{ __('messages.rater') }}</label>
							<div class="input-group-btn input-group div_employee_cd">
								@if($authority_typ == 2 || $authority_typ == 6)
								<span class="num-length">
									<input type="hidden" class="employee_cd_hidden" id="employee_cd" value="{{$employee_cd ?? ''}}" />
									<input type="text" id="rater_employee_nm" class="form-control indexTab employee_nm" tabindex="11" maxlength="101" value="{{$employee_nm ?? ''}}" style="padding-right: 40px;" disabled="disabled" />
								</span>
								<div class="input-group-append-btn">
									<button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" disabled="disabled">
										<i class="fa fa-search"></i>
									</button>
								</div>
								@else
								<span class="num-length">
									<input type="hidden" class="employee_cd_hidden" id="rater_employee_cd" value="" />
									<input type="text" id="rater_employee_nm" class="form-control indexTab employee_nm" tabindex="11" maxlength="101" value="" style="padding-right: 40px;" />
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
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{ __('messages.evaluation_step') }}</label>
							<div class="form-group">
								<select id="evaluation_step" tabindex="10" class="form-control ">
									<option value="-1"></option>
									@foreach($library_14 as $temp)
									<option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
									@endforeach
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">					
						<div class="form-group text-right">						
							<div class="full-width">
								<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="12" >
									<i class="fa fa-search"></i>
									{{ __('messages.search') }}
								</a>
							</div><!-- end .full-width -->
						</div>
					</div>	
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<div class="card">
			<div class="card-body" id="result">
				@include('Master::i2050.search')
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		@endif
		<input type="hidden" class="hidden anti_tab"  name="">
	</div><!-- end .container-fluid -->
	@stop