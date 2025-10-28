@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/oq2030/oq2030.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/oneonone/oq2031/oq2031.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::dropdownRender1on1(['excel', 'backButton'])
!!}
@endpush
@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
@endphp

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	@if(isset($html) && $html != '')
	{!! $html !!}
	@else
	<div class="card box-search-card-common">
		<div class="card-body">
			<div class="row">
				<div class="col-md-5 col-5"></div>
				<div class="col-md-7 col-7">
					<button type="button" class="btn button-card"><span><i class="fa fa-chevron-down"></i></span>{{__('messages.hidden')}}</button>
				</div>
			</div>
			<br>
			<div class="group-search-condition">
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2" style="min-width:160px">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
							<select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
								@for ($i = $fiscal_year - 3; $i <= $fiscal_year + 3 ; $i++) <option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year'))}}</option>
									@endfor
							</select>
						</div>
					</div>
					<!-- <div class="col-sm-12 col-md-6 col-lg-4"> -->
					<div class="" style="padding-right: 10px;padding-left: 10px;">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.aggregation_unit')}}</label>
							<div class="radio">
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" checked type="radio" id="rd5" value="0" tabindex="2">
									<label for="rd5">{{__('messages.whole_company')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd6" value="1" tabindex="2">
									<label for="rd6">{{__('messages.department')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd7" value="2" tabindex="2">
									<label for="rd7">{{__('messages.job')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd8" value="3" tabindex="2">
									<label for="rd8">{{__('messages.grade')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd9" value="4" tabindex="2">
									<label for="rd9">{{__('messages.age')}}</label>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group ln-white-text">
							<div class="text-overfollow multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="" style="margin-bottom: .5rem;">{{__('messages.1on1_group')}}&nbsp;</div>
							<div class="multi-select-full">
								<select id="group_cd_1on1" tabindex="3" class="form-control multiselect group_cd" multiple="multiple">
									@if(isset($oneonone_group[0]))
									@foreach ($oneonone_group as $item)
									<option value="{{$item['oneonone_group_cd']}}" times={{$item['times']}}>{{$item['oneonone_group_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					@if(isset($organization_group[0]))
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group ln-white-text">
							<div class="text-overfollow multi-select-lb" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="margin-bottom: .5rem;">
								{{$organization_group[0]['organization_group_nm']}}
							</div>
							<div class="multi-select-full">
								<select name="" id="organization_step1" class="form-control organization_cd1 multiselect" tabindex="4" organization_typ='1' system="2" multiple="multiple">
									@foreach($combo_organization as $row)
									<option value="{{$row['organization_cd_1']}}">{{$row['organization_nm']}}</option>
									@endforeach
								</select>
							</div>
						</div>
					</div>
					@endif
					@foreach($organization_group as $dt)
					@if($dt['organization_typ'] >=2)
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group ln-white-text">
							<div class="text-overfollow multi-select-lb" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}" style="margin-bottom: .5rem;">
								{{$dt['organization_group_nm']}}
							</div>
							<div class="multi-select-full">
								<select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}} multiselect" tabindex="4" organization_typ="{{$dt['organization_typ']}}" system="2" multiple="multiple">
								</select>
							</div>
						</div>
					</div>
					@endif
					@endforeach
				</div>

				<div class="row">
					<div class="col-sm-6 col-md-3 col-xl-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.position')}}</label>
							<select id="position_cd" tabindex="5" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_position as $item)
								<option value="{{$item['position_cd']}}">{{$item['position_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-xl-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.job')}}</label>
							<select id="job_cd" tabindex="6" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_job[0]))
								@foreach ($combo_job as $item)
								<option value="{{$item['job_cd']}}">{{$item['job_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-xl-2">
						<div class="form-group">
							<div class="text-overfollow multi-select-lb" data-container="body" style="margin-bottom: .5rem;">{{__('messages.grade')}}</div>
							<div class="multi-select-full">
								<select id="grade" tabindex="7" class="form-control multiselect" multiple="multiple">
									@if(isset($combo_grade[0]))
									@foreach ($combo_grade as $item)
									<option value="{{$item['grade']}}">{{$item['grade_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-4 col-lg-3 col-xl-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.employee_classification')}}</label>
							<select id="employee_typ" tabindex="8" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_employee_type[0]))
								@foreach ($combo_employee_type as $item)
								<option value="{{$item['employee_typ']}}">{{$item['employee_typ_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-xl-2">
						<div class="form-group">
							<label class="control-label">{{__('messages.coach')}}</label>
							<div class="input-group-btn input-group div_employee_cd">
								<span class="num-length">
									<input type="hidden" class="employee_cd_hidden employee_cd" id="coach_cd" value="" />
									<input type="text" fiscal_year_1on1="{{isset($fiscal_year)?$fiscal_year:''}}" id="coach_nm" class="form-control indexTab employee_nm_1on1" tabindex="9" maxlength="20" value="" style="padding-right: 40px;" />
								</span>
								<div class="input-group-append-btn">
									<button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div>
					</div>

					<div class="col-md-3 col-lg-2">
						<div class="form-group" style="float:right">
							<label class="control-label">&nbsp;</label>
							<div class="input-group-btn input-group div_employee_cd">
								<div class="form-group text-right">
									<div class="full-width">
										<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="10">
											<i class="fa fa-search"></i>
											{{__('messages.search')}}
										</a>
									</div><!-- end .full-width -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div><!-- end .card-body -->
	</div><!-- end .card -->

	<div class="card">
		<div class="card-body" id="result" style="padding-bottom: 1.25rem !important;">
			@include('OneOnOne::oq2031.search')
		</div><!-- end .card-body -->
	</div><!-- end .card -->
	@endif
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
@stop