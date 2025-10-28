@extends('oneonone/layout')
@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/oq2020/q2020.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/oneonone/oq2020/q2020.index.js')!!}
<!-- START LIBRARY JS -->
@stop

@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','downloadButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		@if(isset($html) && $html != '')
			{!! $html !!}
		@else
	@php
	function ordinal($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'th time';
    else
		return  $message;
	}
	@endphp	
	@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
	@endphp
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2" style="min-width:160px">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
							<select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
								@for ($i = $current_year - 3; $i <= $current_year + 3 ; $i++) 
									<option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}} {{year_english(__('messages.fiscal_year'))}}</option>
								@endfor
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.member_name') }}</label>
						<div class="input-group-btn input-group div_employee_cd">
							<span class="num-length">
								<input type="hidden" class="employee_cd_hidden" id="employee_cd" value="{{ $employee_check_cd??'' }}" />
								<input type="text" fiscal_year_1on1="{{ $fiscal_year ?? $today}}" id="employee_nm" class="form-control indexTab employee_nm_1on1 required" is_callback old_employee_nm="{{ isset($employee_name)?$employee_name:'' }}"
								{{ isset(session_data()->w_1on1_authority_typ) && session_data()->w_1on1_authority_typ == 1?'disabled':'' }} tabindex="2" maxlength="101" value="{{ isset($employee_name)?$employee_name:'' }}" style="padding-right: 40px;" />
							</span>
							@if(isset(session_data()->w_1on1_authority_typ) && session_data()->w_1on1_authority_typ != 1)
							<div class="input-group-append-btn">
								<button class="btn btn-transparent btn_employee_cd_popup_1on1"  type="button" tabindex="-1">
									<i class="fa fa-search"></i>
								</button>
							</div>
							@else 
								<span></span>
							@endif
						</div>
					</div>
					<div class="col-sm-3 col-md-2 col-lg-1 character0">
						<div class="form-group">
							<label class="control-label">{{ __('messages.implementation_date') }}</label>
							<div class="multi-select-full">
								<div class="gflex">
				                    <div class="input-group-btn input-group">
				                        <input type="text" class="form-control input-sm date right-radius start_date" id="start_date" placeholder="yyyy/mm/dd" value="" tabindex="3">
				                        <div class="input-group-append-btn">
											<button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1"></button>
										</div>
				                    </div>
				                </div>
							</div>
						</div>
					</div>
					<div class="col-sm-1 col-md-1 col-lg-1 character">
						<div class="form-group">
							<label class="control-label"></label>
							<div class="multi-select-full">
								~
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-md-2 col-lg-1 character2">
						<div class="form-group">
							<label class="control-label"></label>
							<div class="multi-select-full">
								<div class="gflex">
				                    <div class="input-group-btn input-group">
				                        <input type="text" class="form-control input-sm date right-radius finish_date" id="finish_date" placeholder="yyyy/mm/dd" value="" tabindex="4">
				                        <div class="input-group-append-btn">
											<button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1"></button>
										</div>
				                    </div>
				                </div>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-md-2 col-lg-1 character3">
						<div class="form-group">
							<label class="control-label" style="min-width: 108px;">{{ __('messages.implement_times') }}</label>
							<div class="multi-select-full">
								<div class="gflex">
				                    <div class="input-group-btn input-group" style="width: 100%">
                    					<input type="text" class="form-control only-number time_from" id="time_from"  maxlength="4" value="" tabindex="5">
                    					<span>{{ ordinal(__('messages.th_time',['number'=>''])) }}</span>
				                    </div>
				                </div>
							</div>
						</div>
					</div>
					<div class="col-sm-1 col-md-1 col-lg-1 character5">
						<div class="form-group">
							<label class="control-label"></label>
							<div class="multi-select-full">
								~
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-md-2 col-lg-1 character4">
						<div class="form-group">
							<label class="control-label"></label>
							<div class="multi-select-full">
								<div class="gflex">
				                    <div class="input-group-btn input-group" style="width: 100%">
				                       <input type="text" class="form-control only-number time_to" id="time_to" maxlength="4" value="" tabindex="6">
                    					<span>{{ ordinal(__('messages.th_time',['number'=>''])) }}</span>
				                    </div>
				                </div>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-md-2 col-lg-1 character0">
						<div class="form-group" >
							<label class="control-label">&nbsp;</label>
							<div class="full-width">
								<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="7" >
									<i class="fa fa-search"></i>
									{{ __('messages.search') }}
								</a>
							</div><!-- end .full-width -->
						</div>
					</div>
				</div><!-- end .row -->
			</div>
		</div>		
		<div class="card">
			<div class="card-body">
				<div class="" id="result">
						@include('OneOnOne::oq2020.search')
				</div>
			</div>
		</div>
		@endif
		<input type="hidden" class="hidden anti_tab"  name="">
		<input type="hidden" class="hidden employee_check_cd"  value="{{$employee_check_cd ??''}}">
		<input type="hidden" class="hidden w_1on1_authority_typ"  value="{{ $w_1on1_authority_typ??'' }}">
		<input type="hidden" class="hidden employee_cd_1on1" id="employee_cd_1on1" value={{ session_data()->employee_cd }}  name="">
		<input type="hidden" class="" id="from" value="{{ $from ??'' }}">
	</div><!-- end .container-fluid -->
	@stop