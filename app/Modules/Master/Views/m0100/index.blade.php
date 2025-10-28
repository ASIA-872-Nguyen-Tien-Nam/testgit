@extends('layout')
@section('asset_header')
	{!!public_url('template/css/form/m0100.index.css')!!}
@stop

@push('asset_button')
{!!
Helper::buttonRender(['saveButton','backButton'])
!!}
@endpush

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
{!!public_url('template/js/form/m0100.index.js')!!}
@stop

@section('content')
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-12 col-xs-12" style="overflow: hidden">

					<div class="row">
						<div class="col-md-12">
							<div class="form-group">
								<div class="line-border-bottom">
									<label class="control-label">{{ __('messages.usage_items') }}</label>
								</div>
								<div class="row border-bottom" style="margin-bottom: 20px;">
									<div class="col-xl-auto col-lg-2 col-md-3 col-sm-6 col-12 col-md-auto" style="padding: 0 10px;">
										<a href="javascript:;" id="target_management_typ" value="{{isset($rows['target_management_typ'])?$rows['target_management_typ']:'0'}}" class="btn btn-outline-brand-xl nw target_typ {{isset($rows['target_management_typ_class'])?$rows['target_management_typ_class']:''}}" style="" target_typ="1">
											<i class="fa fa-list-ol" aria-hidden="true"></i>
											{{ __('messages.target_function') }}
											<i class="fa fa-check" aria-hidden="true"></i>
										</a>
									</div>
									<div class="col-md-auto2">
										<a href="javascript:;"id="target_self_assessment_typ" value="{{isset($rows['target_self_assessment_typ'])?$rows['target_self_assessment_typ']:'0'}}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{isset($rows['target_self_assessment_typ_class'])?$rows['target_self_assessment_typ_class']:'disabled'}}" target_typ="2">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_self') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="target_evaluation_typ_1" value="{{isset($rows['target_evaluation_typ_1'])?$rows['target_evaluation_typ_1']:'0'}}" class="qq btn btn-outline-brand-x btn-block text-left target_typ disabled {{isset($rows['target_evaluation_typ_1_class'])?$rows['target_evaluation_typ_1_class']:''}}" target_typ="3">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_1st') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="target_evaluation_typ_2" value="{{isset($rows['target_evaluation_typ_2'])?$rows['target_evaluation_typ_2']:'0'}}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{isset($rows['target_evaluation_typ_2_class'])?$rows['target_evaluation_typ_2_class']:'disabled'}}" target_typ="4">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_2nd') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="target_evaluation_typ_3" value="{{isset($rows['target_evaluation_typ_3'])?$rows['target_evaluation_typ_3']:'0'}}" class="qq btn btn-outline-brand-x btn-block text-left target_typ {{isset($rows['target_evaluation_typ_3_class'])?$rows['target_evaluation_typ_3_class']:'disabled'}}"
										target_typ="5">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_3rd') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2 vb-2">
										<a href="javascript:;" id="target_evaluation_typ_4" value="{{isset($rows['target_evaluation_typ_4'])?$rows['target_evaluation_typ_4']:'0'}}" class=" qq btn btn-outline-brand-x btn-block text-left target_typ {{isset($rows['target_evaluation_typ_4_class'])?$rows['target_evaluation_typ_4_class']:'disabled'}}"
										target_typ="6">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_4th') }}
										</a>
									</div><!-- end .col-md-2 -->
								</div><!-- end .row -->

								<div class="row border-bottom" style="margin-bottom: 20px;">
									<div class="col-xl-auto col-lg-2 col-md-3 col-sm-6 col-12 col-md-auto" style="padding: 0 10px;">
										<a href="javascript:;" id="evaluation_use_typ" value="{{isset($rows['evaluation_use_typ'])?$rows['evaluation_use_typ']:'0'}}" class="btn btn-outline-brand-xl w175 {{isset($rows['evaluation_use_typ_class'])?$rows['evaluation_use_typ_class']:''}} evaluation_typ" evaluation_typ="1">
											<i class="fa fa-line-chart" aria-hidden="true"></i>
											{{ __('messages.qualitative_function') }}
											<i class="fa fa-check" aria-hidden="true"></i>
										</a>
									</div>
									<div class="col-md-auto2">
										<a href="javascript:;" id="evaluation_self_assessment_typ" value="{{isset($rows['evaluation_self_assessment_typ'])?$rows['evaluation_self_assessment_typ']:'0'}}" class="qq btn btn-outline-brand-x btn-block text-left {{isset($rows['evaluation_self_assessment_typ_class'])?$rows['evaluation_self_assessment_typ_class']:'disabled'}} evaluation_typ" evaluation_typ="2">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_self') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="evaluation_typ_1" value="{{isset($rows['evaluation_typ_1'])?$rows['evaluation_typ_1']:'0'}}"  class="qq btn btn-outline-brand-x btn-block text-left disabled {{isset($rows['evaluation_typ_1_class'])?$rows['evaluation_typ_1_class']:''}} evaluation_typ" evaluation_typ="3" >
											<i class="fa fa-check"></i>
											{{ __('messages.eval_1st') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="evaluation_typ_2" value="{{isset($rows['evaluation_typ_2'])?$rows['evaluation_typ_2']:'0'}}"  class="qq btn btn-outline-brand-x btn-block text-left {{isset($rows['evaluation_typ_2_class'])?$rows['evaluation_typ_2_class']:'disabled'}} evaluation_typ" evaluation_typ="4">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_2nd') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2">
										<a href="javascript:;" id="evaluation_typ_3" value="{{isset($rows['evaluation_typ_3'])?$rows['evaluation_typ_3']:'0'}}"  class="qq btn btn-outline-brand-x btn-block text-left {{isset($rows['evaluation_typ_3_class'])?$rows['evaluation_typ_3_class']:'disabled'}} evaluation_typ" evaluation_typ="5">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_3rd') }}
										</a>
									</div><!-- end .col-md-2 -->
									<div class="col-md-auto2 vb-2">
										<a href="javascript:;" id="evaluation_typ_4" value="{{isset($rows['evaluation_typ_4'])?$rows['evaluation_typ_4']:'0'}}"  class="qq btn btn-outline-brand-x btn-block text-left {{isset($rows['evaluation_typ_4_class'])?$rows['evaluation_typ_4_class']:'disabled'}} evaluation_typ" evaluation_typ="6">
											<i class="fa fa-check"></i>
											{{ __('messages.eval_4th') }}
										</a>
									</div><!-- end .col-md-2-->
								</div><!-- end .row -->
								<div class="row border-bottom" style="margin-bottom: 20px;">
									<div class="col-xl-auto col-lg-2 col-md-3 col-sm-6 col-12 col-md-auto">
										<a href="javascript:;" class="qq btn btn-outline-brand-xl w175 {{isset($rows['interview_use_typ_class'])?$rows['interview_use_typ_class']:'0'}}" id="interview_use_typ" value="{{isset($rows['interview_use_typ'])?$rows['interview_use_typ']:'0'}}"
										>
											<i class="fa fa-user" aria-hidden="true"></i>
											{{ __('messages.intreview_function') }}
											<i class="fa fa-check" aria-hidden="true"></i>
										</a>
									</div>
								</div><!-- end .row -->
								<div class="row">
									<div class="col-xl-auto col-lg-2 col-md-3 col-sm-6 col-12 col-md-auto">
										<a href="javascript:;" class="btn btn-outline-brand-xl w175 {{isset($rows['feedback_use_typ_class'])?$rows['feedback_use_typ_class']:'0'}}" id="feedback_use_typ" value="{{isset($rows['feedback_use_typ'])?$rows['feedback_use_typ']:'0'}}"
										>
											<i class="fa fa-comments" aria-hidden="true"></i>
											{{ __('messages.feedback_function') }}
											<i class="fa fa-check" aria-hidden="true"></i>
										</a>
									</div>
								</div><!-- end .row -->
							<div class="form-group" style="padding-top: 20px">
								<div class="line-border-bottom">
									<label class="control-label">{{ __('messages.rater_authority') }}</label>
								</div>
									<div class="col-md-12 test" >
										<div class="row" style="padding-bottom: 10px ">

											<div class="col-md-3 col-12" >
												<div class="row">
													<div class="col-md-12">
														<a href="javascript:;" id="rank_change_1" value="{{isset($rows['rank_change_1'])?$rows['rank_change_1']:'0'}}" class="aaa btn btn-outline-brand-x btn-block vp-2 text-left {{isset($rows['rank_change_1_class'])?$rows['rank_change_1_class']:'disabled'}} rank_change text-overflow" rank_change="1" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_1st_evaluation_change') }}
														</a>
													</div>
													<div class="col-md-12 vt-3">
														<a href="javascript:;" id="adjustpoint_input_1" value="{{isset($rows['adjustpoint_input_1'])?$rows['adjustpoint_input_1']:'0'}}" class="aaa btn btn-outline-brand-x vp-2  btn-block text-left text-overflow {{isset($rows['adjustpoint_input_1_class'])?$rows['adjustpoint_input_1_class']:'disabled'}} adjustpoint_input" adjustpoint_input="1" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_1st_adjust_point') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12" >
														<label class="control-label ">{{ __('messages.add_sub_point_range') }}</label>
														<table class="tbl">
															<tr class="tr-adjustpoint">
																<td>
																	<span class="num-length">
																		<input type="tel"
																			id="adjustpoint_from_1"
																			class="form-control numericX1 adjustpoint_from {{isset($rows['adjustpoint_input_1_class'])&&$rows['adjustpoint_input_1_class']=='active'?'required':''}}"
																			negative="true"
																			maxlength="7" value="{{isset($rows['adjustpoint_from_1'])?$rows['adjustpoint_from_1']:''}}" {{isset($rows['adjustpoint_input_1_class'])&&$rows['adjustpoint_input_1_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2" />
																	</span>
																</td>
																<td class="td-adjustpoint">～</td>
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_to_1" class="form-control numericX2 adjustpoint_to {{isset($rows['adjustpoint_input_1_class'])&&$rows['adjustpoint_input_1_class']=='active'?'required':''}}" maxlength="7" value="{{isset($rows['adjustpoint_to_1'])?$rows['adjustpoint_to_1']:''}}" {{isset($rows['adjustpoint_input_1_class'])&&$rows['adjustpoint_input_1_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2" />
																	</span>
																</td>
															</tr>
														</table>
													</div>
												</div>
											</div><!-- end .col-md-3 -->
											<div class="col-md-3 col-12" >
												<div class="row">
													<div class="col-md-12">
														<a href="javascript:;" id="rank_change_2" value="{{isset($rows['rank_change_2'])?$rows['rank_change_2']:'0'}}" class="aaa btn btn-outline-brand-x btn-block vp-2  text-left {{isset($rows['rank_change_2_class'])?$rows['rank_change_2_class']:'disabled'}} rank_change text-overflow" rank_change="2" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_2nd_evaluation_change') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12 vt-3">
														<a href="javascript:;" id="adjustpoint_input_2" value="{{isset($rows['adjustpoint_input_2'])?$rows['adjustpoint_input_2']:'0'}}" class="aaa btn btn-outline-brand-x vp-2  btn-block text-left {{isset($rows['adjustpoint_input_2_class'])?$rows['adjustpoint_input_2_class']:'disabled'}} adjustpoint_input" adjustpoint_input="2" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_2nd_adjust_point') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12" style="">
														<label class="control-label ">{{ __('messages.add_sub_point_range') }}</label>
														<table class="tbl">
															<tr class="tr-adjustpoint">
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_from_2" class="form-control numericX3 adjustpoint_from {{isset($rows['adjustpoint_input_2_class'])&&$rows['adjustpoint_input_2_class']=='active'?'required':''}}"  negative="true" maxlength="7" value="{{isset($rows['adjustpoint_from_2'])?$rows['adjustpoint_from_2']:''}}" {{isset($rows['adjustpoint_input_2_class'])&&$rows['adjustpoint_input_2_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2"/>
																	</span>
																</td>
																<td class="td-adjustpoint">～</td>
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_to_2" class="form-control numericX4 adjustpoint_to {{isset($rows['adjustpoint_input_2_class'])&&$rows['adjustpoint_input_2_class']=='active'?'required':''}}" maxlength="7" value="{{isset($rows['adjustpoint_to_2'])?$rows['adjustpoint_to_2']:''}}" {{isset($rows['adjustpoint_input_2_class'])&&$rows['adjustpoint_input_2_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2"/>
																	</span>
																</td>
															</tr>
														</table>
													</div>
												</div>
											</div>
											<div class="col-md-3 col-12" >
												<div class="row">
													<div class="col-md-12">
														<a href="javascript:;" id="rank_change_3" value="{{isset($rows['rank_change_3'])?$rows['rank_change_3']:'0'}}" class="aaa btn btn-outline-brand-x btn-block vp-2  text-left {{isset($rows['rank_change_3_class'])?$rows['rank_change_3_class']:'disabled'}} rank_change text-overflow" rank_change="3" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_3rd_evaluation_change') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12 vt-3">
														<a href="javascript:;" id="adjustpoint_input_3" value="{{isset($rows['adjustpoint_input_3'])?$rows['adjustpoint_input_3']:'0'}}" class="aaa btn btn-outline-brand-x vp-2  btn-block text-left text-overflow {{isset($rows['adjustpoint_input_3_class'])?$rows['adjustpoint_input_3_class']:'disabled'}} adjustpoint_input" adjustpoint_input="3" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_3rd_adjust_point') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12">
														<label class="control-label ">{{ __('messages.add_sub_point_range') }}</label>
														<table class="tbl">
															<tr class="tr-adjustpoint">
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_from_3" class="form-control numericX5 adjustpoint_from {{isset($rows['adjustpoint_input_3_class'])&&$rows['adjustpoint_input_3_class']=='active'?'required':''}}" negative="true"  maxlength="7" constant_maxlength="10"  value="{{isset($rows['adjustpoint_from_3'])?$rows['adjustpoint_from_3']:''}}" {{isset($rows['adjustpoint_input_3_class'])&&$rows['adjustpoint_input_3_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2"/>
																	</span>
																</td>
																<td class="td-adjustpoint">～</td>
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_to_3" class="form-control numericX6 adjustpoint_to {{isset($rows['adjustpoint_input_3_class'])&&$rows['adjustpoint_input_3_class']=='active'?'required':''}}" maxlength="7" value="{{isset($rows['adjustpoint_to_3'])?$rows['adjustpoint_to_3']:''}}" {{isset($rows['adjustpoint_input_3_class'])&&$rows['adjustpoint_input_3_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2"/>
																	</span>
																</td>
															</tr>
														</table>
													</div>
												</div>
											</div>
											<div class="col-md-3 col-12" >
												<div class="row">
													<div class="col-md-12">
														<a href="javascript:;" id="rank_change_4" value="{{isset($rows['rank_change_4'])?$rows['rank_change_4']:'0'}}" class="aaa btn btn-outline-brand-x btn-block vp-2   text-left {{isset($rows['rank_change_4_class'])?$rows['rank_change_4_class']:'disabled'}} rank_change text-overflow" rank_change="4" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_4th_evaluation_change') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12 vt-3">
														<a href="javascript:;" id="adjustpoint_input_4" value="{{isset($rows['adjustpoint_input_4'])?$rows['adjustpoint_input_4']:'0'}}" class="aaa btn btn-outline-brand-x vp-2  btn-block text-left text-overflow {{isset($rows['adjustpoint_input_4_class'])?$rows['adjustpoint_input_4_class']:'disabled'}} adjustpoint_input" adjustpoint_input="4" >
															<i class="fa fa-check"></i>
															{{ __('messages.rater_4th_adjust_point') }}
														</a>
													</div><!-- end .col-md-3 -->
													<div class="col-md-12">
														<label class="control-label">{{ __('messages.add_sub_point_range') }}</label>
														<table class="tbl">
															<tr class="tr-adjustpoint">
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_from_4" class="numericX7 form-control adjustpoint_from {{isset($rows['adjustpoint_input_4_class'])&&$rows['adjustpoint_input_4_class']=='active'?'required':''}}"  negative="true" maxlength="7" value="{{isset($rows['adjustpoint_from_4'])?$rows['adjustpoint_from_4']:''}}" {{isset($rows['adjustpoint_input_4_class'])&&$rows['adjustpoint_input_4_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2">
																	</span>
																</td>
																<td class="td-adjustpoint">～</td>
																<td>
																	<span class="num-length">
																		<input type="tel" id="adjustpoint_to_4" class="numericX8 form-control adjustpoint_to {{isset($rows['adjustpoint_input_4_class'])&&$rows['adjustpoint_input_4_class']=='active'?'required':''}}" maxlength="7" constant_maxlength="5"   value="{{isset($rows['adjustpoint_to_4'])?$rows['adjustpoint_to_4']:''}}" {{isset($rows['adjustpoint_input_4_class'])&&$rows['adjustpoint_input_4_class']=='active'?"tabindex=1":"tabindex=-1 readonly"}} decimal="2">
																	</span>
																</td>
															</tr>
														</table>
													</div>
												</div>
											</div>
										</div><!-- end .row -->
										<div class="row">
											<div class="col-md-6">
												<a
													href="javascript:;"
													id="rater_interview_use_typ"
													value="{{isset($rows['rater_interview_use_typ'])?$rows['rater_interview_use_typ']:'0'}}"
													class="btn btn-outline-brand-x btn-block vp-2 text-left rank_change text-overflow {{isset($rows['rater_interview_use_typ'])?$rows['rater_interview_use_typ_class']:''}}"
												>
													<i class="fa fa-check"></i>
													{{ __('messages.label_m0100_1') }}
												</a>
											</div>
										</div>
									</div><!-- end .col-md-10 -->
								</div>
							</div>
							<div class="line-border-bottom">
								<label class="control-label">{{ __('messages.evaluation_periods') }}</label>
							</div>
							<div class="table-responsive" style="">
								<table class="table table-bordered table-hover table-striped" id="table-data-1">
									<thead>
										<tr>
											<th style="width: 50%">{{ __('messages.period_name') }}</th>
											<th style="width: 20%">{{ __('messages.start_dates') }}</th>
											<th style="width: 20%">{{ __('messages.end_date') }}</th>
											<th style="width: 10%">
												<button class="btn btn-rm blue btn-sm" id="btn-add-new-1">
													<i class="fa fa-plus"></i>
												</button>
											</th>
										</tr>
									</thead>
									<tbody>
										@if(isset($row2))
										@foreach($row2 as $row)
										<tr class="table_m0101">
											<td class="text-center">
												<span class="num-length">
													<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
													<input type="text" class="form-control input-sm period_nm" maxlength="50" value="{{$row['period_nm']}}" tabindex="3">
												</span>
											</td>
											<td >
												<div class="gflex">
													<div class="input-group-btn input-group" style="width: 120px">
														<input type="text" class="form-control text-center  mmdd mmdd_from {{$row['period_nm'] !=''?'required':''}}" placeholder="mm/dd"  value="{{$row['period_from']}}" maxlength="50"  tabindex="3">
														<input type="hidden" class="yyyymmdd period_from_full" value="{{isset($row['period_from_full'])?$row['period_from_full']:''}}">
													</div>
												</div><!-- end .gflex -->
											</td>
											<td >
												<div class="gflex">
													<div class="input-group-btn input-group" style="width: 120px">
														<input type="text" class="form-control text-center  mmdd mmdd_to {{$row['period_nm'] !=''?'required':''}}" placeholder="mm/dd" value="{{$row['period_to']}}" maxlength="50"  tabindex="3">
														<input type="hidden" class="yyyymmdd period_to_full" value="{{isset($row['period_to_full'])?$row['period_to_full']:''}}">
														<!-- <div class="input-group-append-btn">
															<button class="btn btn-transparent" type="button" tabindex="-1" data-dtp="dtp_WKpr0"><i class="fa fa-calendar"></i></button>
														</div> -->
													</div>
												</div><!-- end .gflex -->
											</td>
											<td class="text-center">
												@if($row['removeButton_flg']==1)
												<button class="btn btn-rm btn-sm btn-remove-row"  tabindex="3">
													<i class="fa fa-remove"></i>
												</button>
												@endif
											</td>
										</tr>
										@endforeach
										@endif
									</tbody>
								</table>
							</div><!-- end .table-responsive -->
							<div class="line-border-bottom">
								<label class="control-label">{{ __('messages.treatment_use') }}</label>
							</div>
							<div class="full-width form-group group-add-but div-m0102" >
								@if(isset($row3))
								@foreach($row3 as $i => $row)
									<span class="bl102">
										<a href="javascript:;" class="btn btn-primary circle mt-10 table_m0102 {{$row['detail_no']}}">
											<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
											<input type="hidden" class="input_treatment_applications_nm" value="{{$row['treatment_applications_nm']}}" maxlength="50">
											<span class="nm">{{$row['treatment_applications_nm']}}</span>
											<i class="fa fa-times mr0" aria-hidden="true" tabindex="-1" style="opacity: 0;"></i>
										</a>
										@if($row['removeButton_flg']==1)
										<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"  tabindex="4"></i>
										@endif
									</span>
								@endforeach
								@endif
							</div><!-- end .table-responsive -->
							<div class="col-xs-12 col-md-12 p0 full-width" style="height: 40px;margin-bottom: 20px;">
								<button class="btn btn-rm blue btn-sm float-left" id="btn-add-but-text" style="margin-right: 20px"  tabindex="5">
									<i class="fa fa-plus"></i>
								</button>
								<div id="group-but-text" detail_no="0" style="margin-top: 0px;display: none;" class="input-group-btn float-left" >
									<span class="num-length">
										<input type="text" name="textAdd" id="textAdd" class="form-control"  placeholder="{{ __('messages.treatment_usage') }}" maxlength="50"  tabindex="5">
									</span>
								</div>
							</div>
						</div>
					</div>
				</div><!-- end .card-body -->
			</div><!-- end .card -->
		</div><!-- end .container-fluid -->
		@section('asset_common')
		<table class="hidden" id="table-target-1">
			<tbody>
				<tr>
					<td class="text-center">
						<span class="num-length">
							<input type="hidden" class="detail_no">
							<input type="text" class="form-control input-sm period_nm" maxlength="50" tabindex="3">
						</span>
					</td>
					<td class="text-center">
						<div class="gflex">
							<div class="input-group-btn input-group" style="width: 120px">
								<input type="text" class="form-control text-center  mmdd mmdd_from" placeholder="mm/dd" tabindex="3">
								<input type="hidden" class="yyyymmdd period_from_full">
								<!-- <div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" tabindex="-1" data-dtp="dtp_WKpr0"><i class="fa fa-calendar"></i></button>
								</div> -->
							</div>
						</div><!-- end .gflex -->
					</td>
					<td class="text-center">
						<div class="gflex">
							<div class="input-group-btn input-group" style="width: 120px">
								<input type="text" class="form-control text-center  mmdd mmdd_to" placeholder="mm/dd" tabindex="3">
								<input type="hidden" class="yyyymmdd period_to_full">
								<!-- <div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" tabindex="-1" data-dtp="dtp_WKpr0"><i class="fa fa-calendar"></i></button>
								</div> -->
							</div>
						</div><!-- end .gflex -->
					</td>
					<td class="text-center">
						<button class="btn btn-rm btn-sm btn-remove-row" tabindex="3">
							<i class="fa fa-remove"></i>
						</button>
					</td>
				</tr>
			</tbody>
		</table><!-- /.hidden -->

		@stop
		@stop