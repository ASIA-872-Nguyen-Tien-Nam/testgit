@extends('mlayout')
@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/mulitiview/mq2000/mq2000.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/mulitiview/mq2000/mq2000.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
@if($supporter_permission_typ == 1)
{!!
Helper::dropdownRenderMulitireview(['downloadButton2','backButton']);
!!}
@elseif($supporter_permission_typ >= 2)
{!!
Helper::dropdownRenderMulitireview(['saveButton','downloadButton2','downloadButton3','backButton'])
!!}
@endif
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
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-12 col-12">
					<button type="button" class="btn button-card"><span><i class="fa fa-chevron-down"></i></span> {{__('messages.hidden')}}</button>
				</div>
			</div>
			<br>
			<div class="group-search-condition">
				<div class="row">
					<div class="col-sm-4 col-md-3 col-lg-2" style="min-width:160px">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
							<select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
								@if(!empty($years))
									@foreach($years as $year)
										@if($current_year == $year)
										<option value="{{$year}}" {{$year==$current_year ? 'selected' : '' }}>{{$year}}{{year_english(__('messages.fiscal_year'))}}</option>
										@else
										<option value="{{$year}}">{{$year}}{{year_english(__('messages.fiscal_year'))}}</option>
										@endif
									@endforeach
								@endif
							</select>
						</div>
					</div>
					<div class="col-sm-6 col-md-7 col-lg-8">
						<div class="form-group" style="width: 400px">
							<label class="control-label">{{__('messages.review_date')}}</label>
							<div class="input-group date_responsive">
								<div class="gflex">
									<div class="input-group-btn input-group" style="width: 160px">
										<input type="text" class="form-control input-sm date right-radius " id="review_date_from" placeholder="yyyy/mm/dd" tabindex="2">
										<div class="input-group-append-btn">
											<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
										</div>
									</div>
								</div><!-- end .gflex -->
								<span class="input-group-text">
									<div class="">~</div>
								</span>
								<div class="gflex">
									<div class="input-group-btn input-group" style="width: 160px">
										<input type="text" class="form-control input-sm date right-radius " id="review_date_to" placeholder="yyyy/mm/dd" tabindex="3">
										<div class="input-group-append-btn">
											<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
										</div>
									</div>
								</div><!-- end .gflex -->
							</div><!-- /.input-group -->
						</div>
					</div>
					<div class="col-sm-2 col-md-2 col-lg-2">
						<div class="form-group" style="float:right;margin-bottom: 0px;">
							<label class="control-label">&nbsp;</label>
							<div class="input-group-btn input-group">
								<div class="form-group text-right">
									<div class="full-width">
										<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="10">
											<i class="fa fa-search"></i>
											{{ __('messages.search')}}
										</a>
									</div><!-- end .full-width -->
								</div>
							</div>
						</div>
					</div>
				</div><!-- end .row -->
				<div class="row">
					@if(!empty($M0022))
					@foreach($M0022 as $item)
					@if($item['organization_step'] == 1)
					<div class="col-sm-6 col-md-4 col-lg-3 col-sm-12 col-xl-2">
						<div class="form-group">
							<div class="text-overfollow multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
							<div class="multi-select-full">
								<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="4" class="form-control multiselect organization_cd1" system="3" multiple="multiple">
									@foreach($M0020 as $temp)
									<option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
									@endforeach
								</select>
							</div>
						</div>
					</div>
					@else
					<div class="col-sm-6 col-md-4 col-lg-3 col-sm-12 col-xl-2">
						<div class="form-group ">
							<div class="text-overfollow multi-select-lb" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
							<div class="multi-select-full">
								<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="4" class="form-control multiselect organization_cd{{$item['organization_step']}}" system="3" multiple="multiple">
								</select>
							</div>
						</div>
					</div>
					@endif
					@endforeach
					@endif
				</div><!-- end .row -->
				<div class="row">
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.position')}}</label>
							<div class="multi-select-full">
								<select id="position_cd" tabindex="5" class="form-control multiselect " multiple="multiple">
									@if(!empty($M0040))
									@foreach($M0040 as $temp)
									<option value="{{$temp['position_cd']}}">{{$temp['position_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div><!-- /.col-md-2 -->
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.grade')}}</label>
							<div class="multi-select-full">
								<select id="grade" tabindex="6" class="form-control multiselect " multiple="multiple">
									@if(!empty($M0050))
									@foreach($M0050 as $temp)
									<option value="{{$temp['grade']}}">{{$temp['grade_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2">
						<div class="form-group">
							<label class="control-label ">{{__('messages.job')}}</label>
							<div class="multi-select-full">
								<select id="job_cd" tabindex="7" class="form-control multiselect " multiple="multiple">
									@if(!empty($M0030))
									@foreach($M0030 as $temp)
									<option value="{{$temp['job_cd']}}">{{$temp['job_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-md-3 col-lg-2" style="min-width:170px">
						<div class="form-group">
							<label class="control-label ">{{__('messages.employee_classification')}}</label>
							<div class="multi-select-full">
								<select id="employee_typ" tabindex="8" class="form-control multiselect " multiple="multiple">
									@if(!empty($M0060))
									@foreach($M0060 as $temp)
									<option value="{{$temp['employee_typ']}}">{{$temp['employee_typ_nm']}}</option>
									@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="card">
					<div class="card-body box-input-search">
						<div class="row">
							<div class="col-sm-4 col-md-4 col-lg-3 div-check-2">
								<div class="multi-select-lb">{{__('messages.title_(project/issue_name)')}}</div>
								<div class="input-group-btn input-group" style="margin-bottom: 1em">
									<span class="num-length">
										<input type="text" id="project_title" class="form-control indexTab " tabindex="8" maxlength="20" value="" placeholder="{{__('messages.search_like')}}" />
									</span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="" style="padding-right: 10px;padding-left: 10px">
								<label class="control-label">{{__('messages.employee_name')}}</label>
								<div id="group-but-text" detail_no="0" style="margin-top: 0px" class="input-group-btn float-left input-group-btn input-group">
									<div class="" style="height: 40px;margin-bottom: 15px;">
										<div id="group-but-text" detail_no="0" style="margin-top: 0px;" class="input-group-btn float-left div_employee_cd">
											<span class="num-length">
												<input type='hidden' class="name_tag" value="list_employee_cd">
												<input type='hidden' class="employee_cd_hidden" class="employee_cd" value="{{isset($employee_cd)?$employee_cd:''}}">
												<input type="text" mulitiselect_mode="1" system='3' fiscal_year_mulitiselect="{{isset($current_year)?$current_year:''}}" name="textAdd" id="textAdd1" class="form-control employee_nm_mulitiselect" old_employee_nm value="{{isset($employee_name)?$employee_name:''}}" placeholder="" maxlength="101" tabindex="9">
											</span>
											<div class="input-group-append-btn">
												<button class="btn btn-transparent  btn_multi_select_employee_popup" class_select="textAdd1" type="button" tabindex="-1">
													<i class="fa fa-search"></i>
												</button>
											</div>
										</div>
									</div>
									<div class="full-width  group-add-but div-m0102" style="display: contents">
										@if(!empty($row3))
										@foreach($row3 as $i => $row)
										<span class="bl102">
											<a href="javascript:;" class="btn btn-primary circle  list_employee_cd {{$row['detail_no']}}">
												<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
												<input type="hidden" class="input_treatment_applications_nm" value="{{$row['treatment_applications_nm']}}">
												<span class="nm">{{$row['treatment_applications_nm']}}</span>
												<i class="fa fa-times mr0" aria-hidden="true" tabindex="-1" style="opacity: 0;"></i>
											</a>
											@if($row['removeButton_flg']==1)
											<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true" tabindex="4"></i>
											@endif
										</span>
										@endforeach
										@endif
									</div><!-- end .table-responsive -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="" style="padding-right: 10px ;margin-bottom: 0px;padding-left: 10px">
								<label class="control-label">{{__('messages.supporter')}}</label>
								<div id="group-but-text" detail_no="0" style="margin-top: 0px" class="input-group-btn float-left input-group-btn input-group">
									<div class="" style="height: 40px;margin-bottom: 15px;">
										<div id="group-but-text" detail_no="0" style="margin-top: 0px;" class="input-group-btn float-left div_employee_cd">
											<span class="num-length">
												<input type='hidden' class="name_tag" value="list_supporter_cd">
												<input type='hidden' class="employee_cd_hidden" class="employee_cd" value="">
												<input type="text" mulitiselect_mode="2" system='3' fiscal_year_mulitiselect="{{isset($current_year)?$current_year:''}}" name="textAdd" id="textAdd2" class="form-control employee_nm_mulitiselect" old_employee_nm placeholder="" maxlength="101" tabindex="9">
											</span>
											<div class="input-group-append-btn">
												<button class="btn btn-transparent btn_multi_select_employee_popup" class_select="textAdd2" type="button" tabindex="-1">
													<i class="fa fa-search"></i>
												</button>
											</div>
										</div>
									</div>
									<div class="full-width  group-add-but div-m0102" style="display: contents">
										@if(!empty($row3))
										@foreach($row3 as $i => $row)
										<span class="bl102">
											<a href="javascript:;" class="btn btn-primary circle  list_supporter_cd {{$row['detail_no']}}">
												<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
												<input type="hidden" class="input_treatment_applications_nm" value="{{$row['treatment_applications_nm']}}">
												<span class="nm">{{$row['treatment_applications_nm']}}</span>
												<i class="fa fa-times mr0" aria-hidden="true" tabindex="-1" style="opacity: 0;"></i>
											</a>
											@if($row['removeButton_flg']==1)
											<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true" tabindex="4"></i>
											@endif
										</span>
										@endforeach
										@endif
									</div><!-- end .table-responsive -->
								</div>
							</div>
						</div>
						<div class="row">
							<div class="" style="padding-right: 10px;padding-left: 10px">
								<label class="control-label">{{__('messages.1st_rater')}}</label>
								<div id="group-but-text" detail_no="0" style="margin-top: 0px" class="input-group-btn float-left input-group-btn input-group">
									<div class="" style="height: 40px;margin-bottom: 15px;">
										<div id="group-but-text" detail_no="0" style="margin-top: 0px;" class="input-group-btn float-left div_employee_cd">
											<span class="num-length">
												<input type='hidden' class="name_tag" value="list_rater_employee_cd">
												<input type='hidden' class="employee_cd_hidden" class="employee_cd" value="">
												<input type="text" mulitiselect_mode="3" system='3' fiscal_year_mulitiselect="{{isset($current_year)?$current_year:''}}" name="textAdd" id="textAdd3" class="form-control employee_nm_mulitiselect employee_nm" old_employee_nm placeholder="" maxlength="101" tabindex="9">
											</span>
											<div class="input-group-append-btn">
												<button class="btn btn-transparent btn_multi_select_employee_popup" class_select="textAdd3" type="button" tabindex="-1">
													<i class="fa fa-search"></i>
												</button>
											</div>
										</div>
									</div>
									<div class="full-width  group-add-but div-m0102" style="display: contents;">
										@if(!empty($row3))
										@foreach($row3 as $i => $row)
										<span class="bl102">
											<a href="javascript:;" class="btn btn-primary circle  list_rater_employee_cd {{$row['detail_no']}}">
												<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
												<input type="hidden" class="input_treatment_applications_nm" value="{{$row['treatment_applications_nm']}}">
												<span class="nm">{{$row['treatment_applications_nm']}}</span>
												<i class="fa fa-times mr0" aria-hidden="true" tabindex="-1" style="opacity: 0;"></i>
											</a>
											@if($row['removeButton_flg']==1)
											<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true" tabindex="4"></i>
											@endif
										</span>
										@endforeach
										@endif
									</div><!-- end .table-responsive -->
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
			@include('Multiview::mq2000.search')
		</div><!-- end .card-body -->
	</div><!-- end .card -->
	@endif
	<input type="hidden" class="anti_tab" name="">
	<input type="hidden" class="anti_tab" name="" id="redirect_flg" value="{{isset($redirect_flg)?$redirect_flg:'0'}}">
	<input type="hidden" id="mulitiselect_mode" value="1" />
	<input type="hidden" id="from" name="" value="{{ $from ?? '' }}">
</div><!-- end .container-fluid -->
@stop
