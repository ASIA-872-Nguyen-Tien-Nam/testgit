@extends('oneonone/layout')
@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/oneonone/oq2010/oq2010.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/oneonone/oq2010/oq2010.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
Helper::dropdownRender1on1(['backButton'])
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
					<div class="col-sm-6 col-md-3 col-lg-3 col-xl-2">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
							<select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
								@for ($i = $current_fiscal_year - 3; $i <= $current_fiscal_year + 3 ; $i++)
									<option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year'))}}</option>
								@endfor
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-3 col-xl-2">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.1on1_group')}}</label>
							<div class="multi-select-full">
								<select id="group_cd" tabindex="2" class="form-control required group_cd">
									<option value="-1"></option>
									@if(isset($oneonone_group[0]))
									@foreach ($oneonone_group as $item)
									<option value="{{$item['oneonone_group_cd']}}" times={{$item['times']}} {{$item['oneonone_group_cd'] == $group_cd_1on1 ? 'selected' : ''}}>{{$item['oneonone_group_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
						<div class="form-group">
							<label class="control-label">{{__('messages.adequacy')}}</label>
							<dl id="fullfillment_type" class="dropdown">
								<table>
									<tbody>
										<tr>
											<td style="padding: 0px" class="has-weather">
												<dt style="min-height: 38px;max-height: 38px;">
													<a tabindex="2" href="#" style="height: 36px">
														<span class="img-selected" style="height: 36px">
															<input type="hidden" class="fullfillment_type" value="-1">
															<img src="" width="100%" />
														</span>
													</a>
												</dt>
												<dd>
													<ul style='z-index : 99'>
														<li>
															<a href="#" title="Select this card">
																<input type="hidden" class="fullfillment_type" value="-1">
																<img src="" width="100%" />
															</a>
														</li>
														@if(!empty($combo_remark))
														@foreach($combo_remark as $item)
														<li>
															<a href="#" title="Select this card">
																<input type="hidden" class="fullfillment_type" value="{{$item['mark_cd']}}">
																<img src="/uploads/ver1.7/odashboard/{{$item['remark1']}}" width="100%" />
															</a>
														</li>
														@endforeach
														@endif
													</ul>
												</dd>
											</td>
										</tr>
									</tbody>
								</table>
							</dl>
						</div>
					</div>
					<div class="col-sm-6 col-md-6 col-lg-4">
						<label class="control-label col-md-remove">&nbsp;</label>
						<div>
							<div id="bor_authority" class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
								<label class="container" style="padding-right:0px" for="only_admin_comments">{{__('messages.label_024')}}
									<input type="checkbox" name="ck1" id="only_admin_comments" value="1" tabindex="7"/>
									<span class="checkmark" style="top: 0px !important;left: 0px !important;"></span>
								</label>
							</div>
                    	</div>
                	</div>
				</div><!-- end .row -->
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2">
						<label class="control-label">{{__('messages.member_name')}}</label>
						<div class="input-group-btn input-group div_employee_cd">
							<span class="num-length">
								<input type="hidden" class="employee_cd_hidden" id="employee_cd" value="{{isset($employee_cd)?$employee_cd:''}}" />
								<input type="text" fiscal_year_1on1="{{isset($fiscal_year)?$fiscal_year:''}}" id="employee_nm" class="form-control indexTab employee_nm_1on1" old_employee_nm="{{isset($employee_name)?$employee_name:''}}" tabindex="3" maxlength="101" value="{{isset($employee_name)?$employee_name:''}}" style="padding-right: 40px;" {{ isset($authority_typ_1on1) && $authority_typ_1on1 == 1?'disabled':'' }} />
							</span>
							@if(isset($authority_typ_1on1) && $authority_typ_1on1 != 1)
							<div class="input-group-append-btn">
								<button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
									<i class="fa fa-search"></i>
								</button>
							</div>
							@else
							<span></span>
							@endif
						</div>
					</div>
					@if(isset($organization_group[0]))
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<div class="text-overfollow multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="margin-bottom: .5rem;">
								{{$organization_group[0]['organization_group_nm']}}
							</div>
							<div class="multi-select-full">
								<select name="" id="organization_step1" class="form-control organization_cd1 multiselect" tabindex="6" organization_typ='1' system="2" multiple="multiple">
									@foreach($combo_organization as $row)
									<option value="{{$row['organization_cd_1']}}">{{$row['organization_nm']}}</option>
									@endforeach
								</select>
							</div>
						</div>
						<!--/.form-group -->
					</div>
					@endif
					@foreach($organization_group as $dt)
					@if($dt['organization_typ'] >=2)
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<div class="text-overfollow multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}" style="margin-bottom: .5rem;">
								{{$dt['organization_group_nm']}}
							</div>
							<div class="multi-select-full">
								<select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}} multiselect" tabindex="6" organization_typ="{{$dt['organization_typ']}}" system="2" multiple="multiple">
								</select>
							</div>
						</div>
						<!--/.form-group -->
					</div>
					@endif
					@endforeach

				</div><!-- end .row -->
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.position')}}</label>
							<select id="position_cd" tabindex="9" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_position as $item)
								<option value="{{$item['position_cd']}}">{{$item['position_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.job')}}</label>
							<select id="job_cd" tabindex="10" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_job as $item)
								<option value="{{$item['job_cd']}}">{{$item['job_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.grade')}}</label>
							<select id="grade" tabindex="11" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_grade as $item)
								<option value="{{$item['grade']}}">{{$item['grade_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2" style="min-width:170px">
						<div class="form-group">
							<label class="control-label ">{{__('messages.employee_classification')}}</label>
							<select id="employee_typ" tabindex="12" class="form-control ">
								<option value="-1"></option>
								@if(isset($combo_position[0]))
								@foreach ($combo_employee_type as $item)
								<option value="{{$item['employee_typ']}}">{{$item['employee_typ_nm']}}</option>
								@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label">{{__('messages.coach')}}</label>
							<div class="input-group-btn input-group div_employee_cd">
								<span class="num-length">
									<input type="hidden" class="employee_cd_hidden" id="coach_cd" value="{{isset($coach_cd)?$coach_cd:''}}" />
									<input type="text" fiscal_year_1on1="{{isset($fiscal_year)?$fiscal_year:''}}" id="coach_nm" class="form-control indexTab employee_nm_1on1" old_employee_nm="{{isset($coach_name)?$coach_name:''}}" tabindex="13" maxlength="101" value="{{isset($coach_name)?$coach_name:''}}" style="padding-right: 40px;"/>
								</span>
								<div class="input-group-append-btn">
									<button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
										<i class="fa fa-search"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-2">
						<div class="form-group" style="float:right">
							<label class="control-label">&nbsp;</label>
							<div class="input-group-btn input-group div_employee_cd">
								<div class="form-group text-right">
									<div class="full-width">
										<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="14">
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
		<div class="card-body" id="result" style="padding-top: 0px;">
			@include('OneOnOne::oq2010.search')
		</div><!-- end .card-body -->
	</div><!-- end .card -->
	@endif
	<input type="hidden" class="anti_tab" name="">
	<input type="hidden" id="redirect_flg" value="{{isset($redirect_flg)?$redirect_flg:0}}">
	<input type="hidden" id="redirect_times" value="{{isset($redirect_times)?$redirect_times:0}}">
</div><!-- end .container-fluid -->
@stop