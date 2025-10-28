@extends('oneonone/layout')
@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/oq2032/oq2032.index.css')!!}

@stop
@section('asset_footer')
{!!public_url('template/js/oneonone/oq2032/oq2032.index.js')!!}
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
					<div class="col-sm-6 col-md-4 col-lg-3" id="set-width">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.respondent')}}</label>
							<div class="radio">
								<div class="md-radio-v2 inline-block mr-10">
									<input class="submit" name="rdx" checked type="radio" id="rd1" value="1" tabindex="2">
									<label for="rd1">{{__('messages.coach')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="submit" name="rdx" type="radio" id="rd2" value="2" tabindex="2">
									<label for="rd2">{{__('messages.member')}}</label>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-4 col-lg-3">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.purpose_1')}}</label>
							<div class="radio">
								<div class="md-radio-v2 inline-block mr-10">
									<input class="target" name="target" type="radio" class="target" id="rd3" checked value="0" tabindex="3">
									<label for="rd3">{{__('messages.points')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="target" name="target" type="radio" id="rd4" class="target" value="1" tabindex="3">
									<label for="rd4">{{__('messages.response_rate')}}</label>
								</div>

							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12 col-md-12 col-lg-6">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.aggregation_unit')}}</label>
							<div class="radio">
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" checked type="radio" id="rd5" value="0" tabindex="4">
									<label for="rd5">{{__('messages.whole_company')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd6" value="1" tabindex="4">
									<label for="rd6">{{__('messages.department')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd7" value="2" tabindex="4">
									<label for="rd7">{{__('messages.job')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd8" value="3" tabindex="4">
									<label for="rd8">{{__('messages.grade')}}</label>
								</div>
								<div class="md-radio-v2 inline-block mr-10">
									<input class="view_unit" name="rdz" type="radio" id="rd9" value="4" tabindex="4">
									<label for="rd9">{{__('messages.age')}}</label>
								</div>
							</div>
						</div>
					</div>

				</div>
				<div class="row">
					<div class="col-md-4 col-lg-2">
						<div class="form-group">
							<div class="multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="" style="margin-bottom: .5rem;">{{__('messages.1on1_group')}}&nbsp;</div>
							<div class="multi-select-full">
								<select id="group_cd_1on1" tabindex="5" class="form-control multiselect group_cd" multiple="multiple">
									@if(isset($oneonone_group[0]))
									@foreach ($oneonone_group as $item)
									<option value="{{$item['oneonone_group_cd']}}" times={{$item['times']}}>{{$item['oneonone_group_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>

					<div class="col-md-4 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.position')}}</label>
							<select id="position_cd" tabindex="6" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_position as $item)
								<option value="{{$item['position_cd']}}">{{$item['position_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>

					<div class="col-md-4 col-lg-2">
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

					<div class="col-md-4 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.job')}}</label>
							<select id="job_cd" tabindex="8" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_job[0]))
								@foreach ($combo_job as $item)
								<option value="{{$item['job_cd']}}">{{$item['job_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>

					<div class="col-md-4 col-lg-2">
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
					<div class="col-md-4 col-lg-2 ml-auto">
						<div class="form-group" style="float:right">
							<label class="control-label">&nbsp;</label>
							<div class="input-group-btn">
								<a href="javascript:;" class="btn btn-outline-primary" id="btn-search" tabindex="10">
									<i class="fa fa-search"></i>
									{{__('messages.search')}}
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div><!-- end .card-body -->
	</div><!-- end .card -->

	<div class="card">
		<div class="card-body" id="result" style="padding-bottom: 1.25rem !important;">
			@include('OneOnOne::oq2032.search')
		</div><!-- end .card-body -->
	</div><!-- end .card -->
	@endif
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
@stop