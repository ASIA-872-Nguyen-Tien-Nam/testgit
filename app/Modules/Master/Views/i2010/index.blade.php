@extends('layout')

@push('asset_button')

@if($authority_typ == 1)
{!!
Helper::buttonRender(['memoryButton', 'confirmButton2', 'interviewButton','backButton'],[],$data0)
!!}
@else
{!!
Helper::buttonRender(['memoryButton', 'confirmButton2', 'approveButton','sendBackButton' , 'interviewButton','backButton'],[],$data0)
!!}
@endif

@endpush

@section('asset_header')
{!!public_url('template/css/form/i2010.index.css')!!}
@stop

@section('asset_footer')
{!!public_url('template/js/form/i2010.index.js')!!}
@stop

@section('content')
@section('screen_title')
{{ $screen_title }}
@stop
@php
	function difficulty_level_cri() {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'Difficulty Level Criteria';
    else
        return  '難易度';
}
@endphp
<input type="hidden" id="sheet_cd" value="{{$data1['sheet_cd'] ?? 0}}" />
<input type="hidden" id="employee_cd" value="{{$data1['employee_cd'] ?? ''}}" />
<input type="hidden" id="fiscal_year" value="{{$data1['fiscal_year'] ?? 0}}" />
<input type="hidden" id="from" value="{{$from ??''}}">
<input type="hidden" id="from_source" value="{{$from_source ??''}}">
<input type="hidden" id="mail" value="{{$data1['mail'] ?? ''}}" />
<input type="hidden" id="weight_display_typ" value="{{$data1['weight_display_typ'] ?? 0}}" />
<div class="container-fluid">
	<div style="overflow-x: hidden;">
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-md-3 col-sm-12 col-12 col-lg-3 col-xl-2">
								<div class="">
									<table class="table table_avatar">
										<tbody>
											<tr>
												<td>
													@if(isset($data1['picture']) && $data1['picture'] != '')
													<div class="avatar">
														<div class="img">
															<div class="d-flex flex-box {{(!isset($data1['picture']) || $data1['picture'] == '')?"flex-box-image":""}}">
																@if(!isset($data1['picture']) || $data1['picture'] == '')
																<p class="w100">{{ __('messages.photo') }}</p>
																<img id="img-upload" class="thumb" />
																@else
																<img id="img-upload" class="thumb imgs" src="{{$data1['picture']}}?v={{time()}}" />
																@endif
															</div>
														</div>
													</div>
													@else
													<div class="avatar">
														<div class="img">
															<div class="d-flex flex-box portrait">
																<p class="w100">{{ __('messages.photo') }}</p>
																<img id="img-upload" class="thumb" />
															</div>
														</div>
													</div>
													@endif
													<div class="text-center" style="word-break: break-all;" id="employee_nm">{{$data1['employee_nm'] ?? ''}}</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="col-md-9 col-sm-12 col-12 col-lg-9 col-xl-10">
								<div class="row">
									<div class="col-md-3">
										<div class="table-responsive">
											<table class="table table-bordered table-hover table-striped">
												<tbody>
													<tr>
														<td class="text-center" style="width: 90px;background-color: #EAEBEE">{{ __('messages.status') }}</td>
														<td class="text-center" style="color: red;">{{$data1['status_nm'] ?? ''}}</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="col-md-9">
										<nav class="clearfix">
											<ul class="pagination step" style="min-width: {{ !empty($data9)?(count($data9)-1) * 60:'' }}px">
												{{-- <li class="line">&nbsp;</li> --}}
												@if(isset($data9))
													@foreach($data9 as $row)
														@if($row['status_use_typ'] == 1)
															@if(isset($data1['status_cd']) && $row['id'] <= $data1['status_cd'])
																<li class="page-item"><a class="page-link st{{$row['id']}} fixed" href="#">{{$row['detail_no']}}</a>
																	<div></div>
																</li>
															@else
																<li class="page-item"><a class="page-link st{{$row['id']}}" href="#">{{$row['detail_no']}}</a>
																	<div></div>
																</li>
															@endif
														@endif
													@endforeach
												@endif
											</ul>
										</nav>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<div class="table-responsive">
										<table class="tbl-header" id="table-data">
											<tbody>
												<tr>
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.employee_classification') }}">{{ __('messages.employee_classification') }}</label>
															</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['employee_typ_nm'] ?? ''}}">{{$data1['employee_typ_nm'] ?? ''}}</label>
															</div>
														</div>
													</td>
													<td>
														<div class="form-inline finline">
														<div class="form-group">
															<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.job')}}">{{__('messages.job')}}</label>
														</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['job_nm'] ?? ''}}">{{$data1['job_nm'] ?? ''}}</label>
															</div>
														</div>
													</td>
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.position')}}">{{__('messages.position')}}</label>
															</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['position_nm'] ?? ''}}">{{$data1['position_nm'] ?? ''}}</label>
															</div>
														</div>
													</td>
													<td>
														<div class="form-inline finline">
														<div class="form-group">
															<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.grade')}}">{{__('messages.grade')}}</label>
														</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['grade_nm'] ?? ''}}">{{$data1['grade_nm'] ?? ''}}</label>
															</div>
														</div>
													</td>
													<td>
														<div class="form-inline finline">
														<div class="form-group">
															<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.salary')}}">{{__('messages.salary')}}</label>
														</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['salary_grade'] ?? ''}}">{{$data1['salary_grade'] ?? ''}}</label>
															</div>
														</div>
													</td>
												</tr>
												@if(!empty($data8))
												<tr>
													@foreach($data8 as $temp)
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['organization_group_nm']}}">{{$temp['organization_group_nm']}}</label>
															</div>
															<div class="form-group">
																@if ($temp['organization_typ'] == 1)
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['belong_nm1'] ?? ''}}">{{$data1['belong_nm1'] ?? ''}}</label>
																@elseif ($temp['organization_typ'] == 2)
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['belong_nm2'] ?? ''}}">{{$data1['belong_nm2'] ?? ''}}</label>
																@elseif ($temp['organization_typ'] == 3)
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['belong_nm3'] ?? ''}}">{{$data1['belong_nm3'] ?? ''}}</label>
																@elseif ($temp['organization_typ'] == 4)
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['belong_nm4'] ?? ''}}">{{$data1['belong_nm4'] ?? ''}}</label>
																@elseif ($temp['organization_typ'] == 5)
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['belong_nm5'] ?? ''}}">{{$data1['belong_nm5'] ?? ''}}</label>
																@else
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title=""></label>
																@endif
															</div>
														</div>
													</td>
													@endforeach
												</tr>
												@endif
												<tr>
													@if(isset($data1['rater_employee_cd_1']) && $data1['rater_employee_cd_1'] != '')
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.1st_rater') }}">{{ __('messages.1st_rater') }}</label>
															</div>
															
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['rater_employee_cd_1'] ?? ''}}">{{$data1['rater_employee_cd_1'] ?? ''}}</label>
															</div>
														</div>
													</td>
													@endif
													@if(isset($data1['rater_employee_cd_2']) && $data1['rater_employee_cd_2'] != '')
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.2nd_rater') }}">{{ __('messages.2nd_rater') }}</label>
															</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['rater_employee_cd_2'] ?? ''}}">{{$data1['rater_employee_cd_2'] ?? ''}}</label>
															</div>
														</div>
													</td>
													@endif
													@if(isset($data1['rater_employee_cd_3']) && $data1['rater_employee_cd_3'] != '')
													<td>
														<div class="form-inline finline">
															<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.3rd_rater') }}">{{ __('messages.3rd_rater') }}</label>
															</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['rater_employee_cd_3'] ?? ''}}">{{$data1['rater_employee_cd_3'] ?? ''}}</label>
															</div>
														</div>
													</td>
													@endif
													@if(isset($data1['rater_employee_cd_4']) && $data1['rater_employee_cd_4'] != '')
													<td>
														<div class="form-inline finline">
														<div class="form-group">
																<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.4th_rater') }}">{{ __('messages.4th_rater') }}</label>
															</div>
															<div class="form-group">
																<label class="form-control-plaintext txt text-overfollow" style="width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$data1['rater_employee_cd_4'] ?? ''}}">{{$data1['rater_employee_cd_4'] ?? ''}}</label>
															</div>
														</div>
													</td>
													@endif
												</tr>
											</tbody>
										</table>
									</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<div class="table-responsive">
							<table class="table-striped table table-bordered" id="table-2">
								<thead>
									<tr>
										@if($generic_comment_status1 > 0)
										<th>{{$data2['generic_comment_title_1']}}</th>
										@endif
										@if($generic_comment_status2 > 0)
										<th>{{$data2['generic_comment_title_2']}}</th>
										@endif
										@if($generic_comment_status8 > 0)
										<th>{{$data2['generic_comment_title_8']}}</th>
										@endif
										@if($generic_comment_status3 > 0)
										<th>{{$data2['generic_comment_title_3']}}</th>
										@endif
										@if($generic_comment_status4 > 0)
										<th>{{$data2['generic_comment_title_4']}}</th>
										@endif
										@if($generic_comment_status5 > 0)
										<th>{{$data2['generic_comment_title_5']}}</th>
										@endif
										@if($generic_comment_status6 > 0)
										<th>{{$data2['generic_comment_title_6']}}</th>
										@endif
										@if($generic_comment_status7 > 0)
										<th>{{$data2['generic_comment_title_7']}}</th>
										@endif
									</tr>
								</thead>
								<tbody>
									<tr>
										@if($generic_comment_status1 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_1" readonly="readonly" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_1']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status1 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_1']) !!}
											<input type="hidden" id="generic_comment_1" value="{{$data2['generic_comment_1']}}" />
										</td>
										@endif
										@if($generic_comment_status2 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_2" readonly="readonly" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_2']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status2 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_2']) !!}
											<input type="hidden" id="generic_comment_2" value="{{$data2['generic_comment_2']}}" />
										</td>
										@endif
										@if($generic_comment_status8 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_8" readonly="readonly" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_8']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status8 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_8']) !!}
											<input type="hidden" id="generic_comment_8" value="{{$data2['generic_comment_8']}}" />
										</td>
										@endif
										@if($generic_comment_status3 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_3" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_3']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status3 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_3']) !!}
											<input type="hidden" id="generic_comment_3" value="{{$data2['generic_comment_3']}}" />
										</td>
										@endif
										@if($generic_comment_status4 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_4" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_4']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status4 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_4']) !!}
											<input type="hidden" id="generic_comment_4" value="{{$data2['generic_comment_4']}}" />
										</td>
										@endif
										@if($generic_comment_status5 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_5" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_5']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status5 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_5']) !!}
											<input type="hidden" id="generic_comment_5" value="{{$data2['generic_comment_5']}}" />
										</td>
										@endif
										@if($generic_comment_status6 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_6" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_6']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status6 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_6']) !!}
											<input type="hidden" id="generic_comment_6" value="{{$data2['generic_comment_6']}}" />
										</td>
										@endif
										@if($generic_comment_status7 == 1)
										<td style="width: {{$generic_comment_width}}vw">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_7" maxlength="400" rows="3" cols="20">{{$data2['generic_comment_7']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status7 == 2)
										<td style="width: {{$generic_comment_width}}vw">
											{!! nl2br($data2['generic_comment_7']) !!}
											<input type="hidden" id="generic_comment_7" value="{{$data2['generic_comment_7']}}" />
										</td>
										@endif
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div> <!-- end .row -->
				<div class="row button-midd-div">
					<div class="col-md-9">
						<div class="clearfix">
							<p class="pull-left" style="margin: 10px 0 0;"><b>{{ __('messages.evaluation_sheet_input') }}</b></p>
							<button id="btn-collapse" class="btn btn-primary pull-right" data-status="0" tabindex="-1">
								<i class="fa fa-caret-left" aria-hidden="true"></i>
							</button>
							@if (isset($data1['upload_file']) && $data1['upload_file'] != '')
							<button class="btn btn-primary pull-right" id="btn-download" file-name="{{$data1['upload_file'] ?? ''}}" file-address="{{$data1['file_address'] ?? ''}}" style="margin-right: 10px;font-size: 12px; padding: 9px" tabindex="-1">{{ __('messages.download_manual') }}</button>								
							@endif
						</div>
						<hr style="margin-top: 0;">
					</div>
				</div> <!-- end .row -->
				<div class="row">
					<div class="col-md-12">
						<div class="wmd-view-topscroll">
							<div class="scroll-div1"></div>
						</div>
					</div>
				</div><!-- end .row -->
				<div class="row">
					<div class="col-md-12 marb20">
						<div class="table-responsive wmd-view">
							<table id="list-item" class="table table-bordered table-striped table-hover ofixed-boder" data-resizable-columns-id="demo-table-v2">
								<thead>
									<tr>
										<?php
										$col 			=	0;
										$col_evaluation	=	0;
										?>
										@if($item_title_status > 0)
										<th data-resizable-column-id="#1" class="col-fix">
											{{$data2['item_title_title']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($item_display_status_1 > 0)
										<th data-resizable-column-id="#1">
											{{$data2['item_title_1']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($item_display_status_2 > 0)
										<th data-resizable-column-id="#2">
											{{$data2['item_title_2']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($item_display_status_3 > 0)
										<th data-resizable-column-id="#3">
											{{$data2['item_title_3']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($item_display_status_4 > 0)
										<th data-resizable-column-id="#4">
											{{$data2['item_title_4']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($item_display_status_5 > 0)
										<th data-resizable-column-id="#5">
											{{$data2['item_title_5']}}
										</th>
										@php $col++;@endphp
										@endif
										@if($weight_display_status == 1)
										<th class="col-fix-option">{{$weight_display_nm}}</th>
										@php $col++;@endphp
										@elseif($weight_display_status == 2)
										<th class="col-fix-option view">{{$weight_display_nm}}</th>
										@php $col++;@endphp
										@endif
										@if($challenge_level_display_status == 1)
										<th class="col-fix">{{ __('messages.level') }}</th>
										@php $col++;@endphp
										@elseif($challenge_level_display_status == 2)
										<th class="col-fix view">{{ __('messages.level') }}</th>
										@php $col++;@endphp
										@endif
										<!-- 明細自己進捗コメント -->
										@if($detail_self_progress_comment_display_status == 1)
										<th class="col-fix-comment">
											<div class="justify-content-between">
												<span style="word-break: break-all;">{{$data2['detail_self_progress_comment_title']}}</span>
												<div class="ics-group ics-group-unset">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_self_progress_comment_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_self_progress_comment_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</th>
										@php $col++;@endphp
										@elseif($detail_self_progress_comment_display_status == 2)
										<th class="col-fix-comment view">
											{{$data2['detail_self_progress_comment_title']}}
										</th>
										@php $col++;@endphp
										@endif
										<!-- 明細進捗コメント -->
										@if($detail_progress_comment_display_status == 1)
										<th class="col-fix-comment">
											<div class="justify-content-between">
												<span style="word-break: break-all;">{{$data2['detail_progress_comment_title']}}</span>
												<div class="ics-group ics-group-unset">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</th>
										@php $col++;@endphp
										@elseif($detail_progress_comment_display_status == 2)
										<th class="col-fix-comment view">
											{{$data2['detail_progress_comment_title']}}
										</th>
										@php $col++;@endphp
										@endif
										<!-- 自己評価 -->
										@if($evaluation_display_status0 == 1)
										<th class="togcol col-fix">{{ __('messages.eval_self') }}</th>
										@php $col++;@endphp
										@elseif($evaluation_display_status0 == 2)
										<th class="togcol col-fix view">{{ __('messages.eval_self') }}</th>
										@php $col++;@endphp
										@endif
										<!-- 一次評価 -->
										@if($evaluation_display_status1 == 1)
										<th class="togcol col-fix">{{ __('messages.eval_1st') }}</th>
										@php $col_evaluation++;@endphp
										@elseif($evaluation_display_status1 == 2)
										<th class="togcol col-fix view">{{ __('messages.eval_1st') }}</th>
										@php $col_evaluation++;@endphp
										@endif
										<!-- 二次評価 -->
										@if($evaluation_display_status2 == 1)
										<th class="togcol col-fix">{{ __('messages.eval_2nd') }}</th>
										@php $col_evaluation++;@endphp
										@elseif($evaluation_display_status2 == 2)
										<th class="togcol col-fix view">{{ __('messages.eval_2nd') }}</th>
										@php $col_evaluation++;@endphp
										@endif
										<!-- 三次評価 -->
										@if($evaluation_display_status3 == 1)
										<th class="togcol col-fix">{{ __('messages.eval_3rd') }}</th>
										@php $col_evaluation++;@endphp
										@elseif($evaluation_display_status3 == 2)
										<th class="togcol col-fix view">{{ __('messages.eval_3rd') }}</th>
										@php $col_evaluation++;@endphp
										@endif
										<!-- 四次評価 -->
										@if($evaluation_display_status4 == 1)
										<th class="togcol col-fix">{{ __('messages.eval_4th') }}</th>
										@php $col_evaluation++;@endphp
										@elseif($evaluation_display_status4 == 2)
										<th class="togcol col-fix view">{{ __('messages.eval_4th') }}</th>
										@php $col_evaluation++;@endphp
										@endif
										<!-- 自己評価コメント -->
										@if($detail_myself_comment_display_status > 0)
										<th class="togcol">{{ __('messages.self_evaluation_comment') }}</th>
										@endif
										@if($detail_comment_display_status1 > 0)
										<th class="togcol">{{ __('messages.1st_rater_s_comment') }}</th>
										@endif
										@if($detail_comment_display_status2 > 0)
										<th class="togcol">{{ __('messages.2st_rater_s_comment') }}</th>
										@endif
										@if($detail_comment_display_status3 > 0)
										<th class="togcol">{{ __('messages.3st_rater_s_comment') }}</th>
										@endif
										@if($detail_comment_display_status4 > 0)
										<th class="togcol">{{ __('messages.4st_rater_s_comment') }}</th>
										@endif
									</tr>
								</thead>
								<tbody>
									@foreach($data3 as $row)
									<tr class="function_list" item_no="{{$row['item_no']}}">
										<input type="hidden" class="item_no" value="{{$row['item_no']}}">
										@if($item_title_status > 0)
										<td class="sticky-cell">
											{!! nl2br($row['item_title']) !!}
											<input type="hidden" class="item_title" value="{{$row['item_title']}}" />
										</td>
										@endif

										@if($item_display_status_1 == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['item_required_status'] == 0)
												<textarea class="form-control item_1 required" maxlength="400" rows="3" cols="20">{{$row['item_1']}}</textarea>
												@else
												<textarea class="form-control item_1" maxlength="400" rows="3" cols="20">{{$row['item_1']}}</textarea>
												@endif
											</span>
										</td>
										@elseif($item_display_status_1 == 2)
										<td class="sticky-cell">
											{!! nl2br($row['item_1']) !!}
											<input type="hidden" class="item_1" value="{{$row['item_1']}}" />
										</td>
										@endif
										@if($item_display_status_2 == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['item_required_status'] == 0)
												<textarea class="form-control item_2 required" maxlength="400" rows="3" cols="20">{{$row['item_2']}}</textarea>
												@else
												<textarea class="form-control item_2" maxlength="400" rows="3" cols="20">{{$row['item_2']}}</textarea>
												@endif
											</span>
										</td>
										@elseif($item_display_status_2 == 2)
										<td class="sticky-cell">
											{!! nl2br($row['item_2']) !!}
											<input type="hidden" class="item_2" value="{{$row['item_2']}}" />
										</td>
										@endif
										@if($item_display_status_3 == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['item_required_status'] == 0)
												<textarea class="form-control item_3 required" maxlength="400" rows="3" cols="20">{{$row['item_3']}}</textarea>
												@else
												<textarea class="form-control item_3" maxlength="400" rows="3" cols="20">{{$row['item_3']}}</textarea>
												@endif
											</span>
										</td>
										@elseif($item_display_status_3 == 2)
										<td class="sticky-cell">
											{!! nl2br($row['item_3']) !!}
											<input type="hidden" class="item_3" value="{{$row['item_3']}}" />
										</td>
										@endif
										@if($item_display_status_4 == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['item_required_status'] == 0)
												<textarea class="form-control item_4 required" maxlength="400" rows="3" cols="20">{{$row['item_4']}}</textarea>
												@else
												<textarea class="form-control item_4" maxlength="400" rows="3" cols="20">{{$row['item_4']}}</textarea>
												@endif
											</span>
										</td>
										@elseif($item_display_status_4 == 2)
										<td class="sticky-cell">
											{!! nl2br($row['item_4']) !!}
											<input type="hidden" class="item_4" value="{{$row['item_4']}}" />
										</td>
										@endif
										@if($item_display_status_5 == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['item_required_status'] == 0)
												<textarea class="form-control item_5 required" maxlength="400" rows="3" cols="20">{{$row['item_5']}}</textarea>
												@else
												<textarea class="form-control item_5" maxlength="400" rows="3" cols="20">{{$row['item_5']}}</textarea>
												@endif
											</span>
										</td>
										@elseif($item_display_status_5 == 2)
										<td class="sticky-cell">
											{!! nl2br($row['item_5']) !!}
											<input type="hidden" class="item_5" value="{{$row['item_5']}}" />
										</td>
										@endif
										@if($weight_display_status == 1)
										<td class="xxx">
											<span class="num-length">
												<div class="input-group-btn btn-right">
													@if($row['weight_required_status'] == 1)
													<input type="text" class="form-control numeric weight required" maxlength="3" max="999" min="0" value="{{$row['weight']}}">
													@else
													<input type="text" class="form-control numeric weight" maxlength="3" max="999" min="0" value="{{$row['weight']}}">
													@endif
													@if($weight_display_nm == 'ｳｪｲﾄ' || $weight_display_nm == 'Weight')
													<div class="input-group-append-btn">
														<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
													</div>
													@endif
												</div>
											</span>
										</td>
										@elseif($weight_display_status == 2)
										<td class="xxx text-right">
											{{$row['weight']}}
											@if($weight_display_nm == 'ｳｪｲﾄ'|| $weight_display_nm == 'Weight')
											%
											@endif
											<input type="hidden" class="form-control weight" maxlength="3" value="{{$row['weight']}}">
										</td>
										@endif
										@if($challenge_level_display_status == 1)
										<td class="sticky-cell">
											<span class="num-length">
												@if($row['weight_required_status'] == 1)
												<select class="form-control challenge_level required">
													<option value="-1"></option>
													@if(count($data6) > 0)
													@foreach($data6 as $temp)
													@if($temp['challenge_level'] == $row['challenge_level'])
													<option selected="selected" value="{{$temp['challenge_level']}}">{{$temp['challenge_level_nm']}}</option>
													@else
													<option value="{{$temp['challenge_level']}}">{{$temp['challenge_level_nm']}}</option>
													@endif
													@endforeach
													@endif
												</select>
												@else
												<select class="form-control challenge_level">
													<option value="-1"></option>
													@if(count($data6) > 0)
													@foreach($data6 as $temp)
													@if($temp['challenge_level'] == $row['challenge_level'])
													<option selected="selected" value="{{$temp['challenge_level']}}">{{$temp['challenge_level_nm']}}</option>
													@else
													<option value="{{$temp['challenge_level']}}">{{$temp['challenge_level_nm']}}</option>
													@endif
													@endforeach
													@endif
												</select>
												@endif
											</span>
										</td>
										@elseif($challenge_level_display_status == 2)
										<td class="sticky-cell">
											{{$row['challenge_level_nm']}}
											<input type="hidden" class="form-control challenge_level" value="{{$row['challenge_level']}}" />
										</td>
										@endif
										<!-- 明細自己進捗コメント -->
										@if($detail_self_progress_comment_display_status == 1)
										<td>
											<span class="self_progress_comment_hide">{!! nl2br($row['self_progress_comment']) !!}</span>
											<span class="num-length">
												<textarea class="form-control self_progress_comment hide" id="self_progress_comment" maxlength="1000" rows="3" cols="20">{{$row['self_progress_comment']}}</textarea>
											</span>
										</td>
										@elseif($detail_self_progress_comment_display_status == 2)
										<td>
											<span>{!! nl2br($row['self_progress_comment']) !!}</span>
											<span class="num-length">
												<input type="hidden" class="form-control self_progress_comment" id="self_progress_comment" value="{{$row['self_progress_comment']}}" />
											</span>
										</td>
										@endif
										<!-- 明細進捗コメント -->
										@if($detail_progress_comment_display_status == 1)
										<td>
											<span class="progress_comment_hide">{!! nl2br($row['progress_comment']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment hide" id="progress_comment" maxlength="1000" rows="3" cols="20">{{$row['progress_comment']}}</textarea>
											</span>
										</td>
										@elseif($detail_progress_comment_display_status == 2)
										<td>
											<span>{!! nl2br($row['progress_comment']) !!}</span>
											<span class="num-length">
												<input type="hidden" class="form-control progress_comment" id="progress_comment" value="{{$row['progress_comment']}}" />
											</span>
										</td>
										@endif
										@if($evaluation_display_status0 == 1)
										<td class="togcol">
											<select class="form-control point_cd_0 required" step="0" point_calculation_typ2="{{$row['point_calculation_typ2']}}" point_calculation_typ1="{{$row['point_calculation_typ1']}}" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@if(count($data7) > 0)
												@foreach($data7 as $temp)
												@if($temp['point_cd'] == $row['point_cd_0'])
												<option selected="selected" point="{{$temp['point']}}" value="{{$temp['point_cd']}}">{{$temp['point_nm']}}</option>
												@else
												<option value="{{$temp['point_cd']}}" point="{{$temp['point']}}">{{$temp['point_nm']}}</option>
												@endif
												@endforeach
												@endif
											</select>
										</td>
										@elseif($evaluation_display_status0 == 2)
										<td class="togcol text-center">
											{{$row['point_nm_0']}}
											<input type="hidden" class="form-control point_cd_0" value="{{$row['point_cd_0']}}" />
										</td>
										@endif
										@if($evaluation_display_status1 == 1)
										<td class="togcol">
											<select class="form-control point_cd_1 required" step="1" point_calculation_typ2="{{$row['point_calculation_typ2']}}" point_calculation_typ1="{{$row['point_calculation_typ1']}}" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@if(count($data7) > 0)
												@foreach($data7 as $temp)
												@if($temp['point_cd'] == $row['point_cd_1'])
												<option selected="selected" point="{{$temp['point']}}" value="{{$temp['point_cd']}}">{{$temp['point_nm']}}</option>
												@else
												<option value="{{$temp['point_cd']}}" point="{{$temp['point']}}">{{$temp['point_nm']}}</option>
												@endif
												@endforeach
												@endif
											</select>
										</td>
										@elseif($evaluation_display_status1 == 2)
										<td class="togcol text-center">
											{{$row['point_nm_1']}}
											<input type="hidden" class="form-control point_cd_1" value="{{$row['point_cd_1']}}" />
										</td>
										@endif
										@if($evaluation_display_status2 == 1)
										<td class="togcol">
											<select class="form-control point_cd_2 required" step="2" point_calculation_typ2="{{$row['point_calculation_typ2']}}" point_calculation_typ1="{{$row['point_calculation_typ1']}}" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@if(count($data7) > 0)
												@foreach($data7 as $temp)
												@if($temp['point_cd'] == $row['point_cd_2'])
												<option selected="selected" point="{{$temp['point']}}" value="{{$temp['point_cd']}}">{{$temp['point_nm']}}</option>
												@else
												<option value="{{$temp['point_cd']}}" point="{{$temp['point']}}">{{$temp['point_nm']}}</option>
												@endif
												@endforeach
												@endif
											</select>
										</td>
										@elseif($evaluation_display_status2 == 2)
										<td class="togcol text-center">
											{{$row['point_nm_2']}}
											<input type="hidden" class="form-control point_nm_2" value="{{$row['point_nm_2']}}" />
										</td>
										@endif
										@if($evaluation_display_status3 == 1)
										<td class="togcol">
											<select class="form-control point_cd_3 required" step="3" point_calculation_typ2="{{$row['point_calculation_typ2']}}" point_calculation_typ1="{{$row['point_calculation_typ1']}}" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@if(count($data7) > 0)
												@foreach($data7 as $temp)
												@if($temp['point_cd'] == $row['point_cd_3'])
												<option selected="selected" point="{{$temp['point']}}" value="{{$temp['point_cd']}}">{{$temp['point_nm']}}</option>
												@else
												<option value="{{$temp['point_cd']}}" point="{{$temp['point']}}">{{$temp['point_nm']}}</option>
												@endif
												@endforeach
												@endif
											</select>
										</td>
										@elseif($evaluation_display_status3 == 2)
										<td class="togcol text-center">
											{{$row['point_nm_3']}}
											<input type="hidden" class="form-control point_nm_3" value="{{$row['point_nm_3']}}" />
										</td>
										@endif
										@if($evaluation_display_status4 == 1)
										<td class="togcol">
											<select class="form-control point_cd_4 required" step="4" point_calculation_typ2="{{$row['point_calculation_typ2']}}" point_calculation_typ1="{{$row['point_calculation_typ1']}}" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@if(count($data7) > 0)
												@foreach($data7 as $temp)
												@if($temp['point_cd'] == $row['point_cd_4'])
												<option selected="selected" point="{{$temp['point']}}" value="{{$temp['point_cd']}}">{{$temp['point_nm']}}</option>
												@else
												<option value="{{$temp['point_cd']}}" point="{{$temp['point']}}">{{$temp['point_nm']}}</option>
												@endif
												@endforeach
												@endif
											</select>
										</td>
										@elseif($evaluation_display_status4 == 2)
										<td class="togcol text-center">
											{{$row['point_nm_4']}}
											<input type="hidden" class="form-control point_nm_4" value="{{$row['point_nm_4']}}" />
										</td>
										@endif
										<!--  -->
										@if($detail_myself_comment_display_status == 1)
										<td class="togcol">
											<span class="num-length">
												<textarea class="form-control evaluation_comment_0" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment_0']}}</textarea>
											</span>
										</td>
										@elseif ($detail_myself_comment_display_status == 2)
										<td class="togcol">
											{!! nl2br($row['evaluation_comment_0']) !!}
											<input type="hidden" class="form-control evaluation_comment_0" value="{{$row['evaluation_comment_0']}}" />
										</td>
										@endif
										@if($detail_comment_display_status1 == 1)
										<td class="togcol">
											<span class="num-length">
												<textarea class="form-control evaluation_comment_1" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment_1']}}</textarea>
											</span>
										</td>
										@elseif($detail_comment_display_status1 == 2)
										<td class="togcol">
											{!! nl2br($row['evaluation_comment_1']) !!}
											<input type="hidden" class="form-control evaluation_comment_1" value="{{$row['evaluation_comment_1']}}" />
										</td>
										@endif
										@if($detail_comment_display_status2 == 1)
										<td class="togcol">
											<span class="num-length">
												<textarea class="form-control evaluation_comment_2" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment_2']}}</textarea>
											</span>
										</td>
										@elseif($detail_comment_display_status2 == 2)
										<td class="togcol">
											{!! nl2br($row['evaluation_comment_2']) !!}
											<input type="hidden" class="form-control evaluation_comment_2" value="{{$row['evaluation_comment_2']}}" />
										</td>
										@endif
										@if($detail_comment_display_status3 == 1)
										<td class="togcol">
											<span class="num-length">
												<textarea class="form-control evaluation_comment_3" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment_3']}}</textarea>
											</span>
										</td>
										@elseif($detail_comment_display_status3 == 2)
										<td class="togcol">
											{!! nl2br($row['evaluation_comment_3']) !!}
											<input type="hidden" class="form-control evaluation_comment_3" value="{{$row['evaluation_comment_3']}}" />
										</td>
										@endif
										@if($detail_comment_display_status4 == 1)
										<td class="togcol">
											<span class="num-length">
												<textarea class="form-control evaluation_comment_4" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment_4']}}</textarea>
											</span>
										</td>
										@elseif($detail_comment_display_status4 == 2)
										<td class="togcol">
											{!! nl2br($row['evaluation_comment_4']) !!}
											<input type="hidden" class="form-control evaluation_comment_4" value="{{$row['evaluation_comment_4']}}" />
										</td>
										@endif
									</tr>
									@endforeach
									<!-- total -->
									@if($col_evaluation > 0 && $total_score_display_status > 0)
									<tr class="togcol">
										@if($col > 0)
										<td colspan="{{$col - 1}}" class="baffbo"></td>
										@endif
										<th class="ba55 text-left">
											@if ($data1['point_calculation_typ2'] == 2)
											{{ __('messages.average_score') }}												
											@else
											{{ __('messages.total_points') }}												
											@endif
										</th>
										@if($evaluation_display_status1 > 0)
										<td class="text-center">
											<span id="point_sum1_total">{{$data4['point_sum1']}}</span>
										</td>
										@endif
										@if($evaluation_display_status2 > 0)
										<td class="text-center">
											<span id="point_sum2_total">{{$data4['point_sum2']}}</span>
										</td>
										@endif
										@if($evaluation_display_status3 > 0)
										<td class="text-center">
											<span id="point_sum3_total">{{$data4['point_sum3']}}</span>
										</td>
										@endif
										@if($evaluation_display_status4 > 0)
										<td class="text-center">
											<span id="point_sum4_total">{{$data4['point_sum4']}}</span>
										</td>
										@endif
									</tr>
									@endif
								</tbody>
							</table>
							<input type="hidden" id="point_sum0" value="{{$data4['point_sum0'] ?? 0}}" />
							<input type="hidden" id="point_sum1" value="{{$data4['point_sum1'] ?? 0}}" />
							<input type="hidden" id="point_sum2" value="{{$data4['point_sum2'] ?? 0}}" />
							<input type="hidden" id="point_sum3" value="{{$data4['point_sum3'] ?? 0}}" />
							<input type="hidden" id="point_sum4" value="{{$data4['point_sum4'] ?? 0}}" />
						</div>
					</div>
				</div> <!-- end .row -->
				@if(	$progress_comment_display_status > 0 
					|| 	$progress_comment_display_status1 > 0 
					|| 	$progress_comment_display_status2 > 0
					|| 	$progress_comment_display_status3 > 0
					|| 	$progress_comment_display_status4 > 0
				)
				<div class="row">
					<div class="col-md-12">
						<p style="margin-bottom: 5px;"><b>{{ __('messages.input_comment_process') }}</b></p>
						<hr style="margin-top: 0;">
					</div>
				</div> <!-- end .row -->
				<div class="row">
					<div class="col-md-12">
						<div class="table-responsive">
							<table class="table table-bordered btm-progress-comment table-hover" style="min-width: 650px;">
								<tbody>
									{{-- 自己進捗コメント --}}
									@if($progress_comment_display_status == 1)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex justify-content-between">
												{{$data2['self_progress_comment_title']}}
												<div class="ics-group">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_self_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_self_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</td>
										<td>
											<span class="progress_comment_self_hide">{!! nl2br($data2['progress_comment_self']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment_self hide" id="progress_comment_self" maxlength="1000" rows="3" cols="20">{{$data2['progress_comment_self']}}</textarea>
											</span>
										</td>
									</tr>
									@elseif($progress_comment_display_status == 2)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											{{$data2['self_progress_comment_title']}}
										</td>
										<td>
											{!! nl2br($data2['progress_comment_self']) !!}
											<input type="hidden" class="form-control progress_comment_self" id="progress_comment_self" value="{{$data2['progress_comment_self']}}" />
										</td>
									</tr>
									@endif
									{{-- 一次評価者進捗コメント --}}
									@if($progress_comment_display_status1 == 1)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex justify-content-between">
												<div class="d-flex flex-column">
													<span>{{ __('messages.1st_rater') }}</span>
													<span>{{ $data2['progress_comment_title'] }}</span>				
												</div>
												<div class="ics-group">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</td>
										<td>
											<span class="progress_comment_rater_hide">{!! nl2br($data2['progress_comment_rater']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment_rater hide" id="progress_comment_rater" maxlength="1000" rows="3" cols="20">{{$data2['progress_comment_rater']}}</textarea>
											</span>
										</td>
									</tr>
									@elseif($progress_comment_display_status1 == 2)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex flex-column">
												<span>{{ __('messages.1st_rater') }}</span>
												<span>{{ $data2['progress_comment_title'] }}</span>				
											</div>
										</td>
										<td>
											{!! nl2br($data2['progress_comment_rater']) !!}
											<input type="hidden" class="form-control progress_comment_rater" id="progress_comment_rater" value="{{$data2['progress_comment_rater']}}" />
										</td>
									</tr>
									@endif
									{{-- 二次評価者進捗コメント --}}
									@if($progress_comment_display_status2 == 1)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex justify-content-between">
												<div class="d-flex flex-column">
													<span>{{ __('messages.2nd_rater') }}</span>
													<span>{{ $data2['progress_comment_title'] }}</span>				
												</div>
												<div class="ics-group">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_2_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_2_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</td>
										<td>
											<span class="progress_comment_rater_2_hide">{!! nl2br($data2['progress_comment_rater_2']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment_rater_2 hide" id="progress_comment_rater_2" maxlength="1000" rows="3" cols="20">{{$data2['progress_comment_rater_2']}}</textarea>
											</span>
										</td>
									</tr>
									@elseif($progress_comment_display_status2 == 2)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex flex-column">
												<span>{{ __('messages.2nd_rater') }}</span>
												<span>{{ $data2['progress_comment_title'] }}</span>				
											</div>
										</td>
										<td>
											{!! nl2br($data2['progress_comment_rater_2']) !!}
											<input type="hidden" class="form-control progress_comment_rater_2" id="progress_comment_rater_2" value="{{$data2['progress_comment_rater_2']}}" />
										</td>
									</tr>
									@endif
									{{-- 三次評価者進捗コメント --}}
									@if($progress_comment_display_status3 == 1)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex justify-content-between">
												<div class="d-flex flex-column">
													<span>{{ __('messages.3rd_rater') }}</span>
													<span>{{ $data2['progress_comment_title'] }}</span>				
												</div>
												<div class="ics-group">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_3_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_3_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</td>
										<td>
											<span class="progress_comment_rater_3_hide">{!! nl2br($data2['progress_comment_rater_3']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment_rater_3 hide" id="progress_comment_rater_3" maxlength="1000" rows="3" cols="20">{{$data2['progress_comment_rater_3']}}</textarea>
											</span>
										</td>
									</tr>
									@elseif($progress_comment_display_status3 == 2)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex flex-column">
												<span>{{ __('messages.3rd_rater') }}</span>
												<span>{{ $data2['progress_comment_title'] }}</span>				
											</div>
										</td>
										<td>
											{!! nl2br($data2['progress_comment_rater_3']) !!}
											<input type="hidden" class="form-control progress_comment_rater_3" id="progress_comment_rater_3" value="{{$data2['progress_comment_rater_3']}}" />
										</td>
									</tr>
									@endif
									{{-- 四次評価者進捗コメント --}}
									@if($progress_comment_display_status4 == 1)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex justify-content-between">
												<div class="d-flex flex-column">
													<span>{{ __('messages.4th_rater') }}</span>
													<span>{{ $data2['progress_comment_title'] }}</span>				
												</div>
												<div class="ics-group">
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_4_edit">
														{{ __('messages.input') }}
													</a>
													<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_progress_comment_rater_4_approve">
														{{ __('messages.save') }}
													</a>
												</div><!-- end .ics-group -->
											</div>
										</td>
										<td>
											<span class="progress_comment_rater_4_hide">{!! nl2br($data2['progress_comment_rater_4']) !!}</span>
											<span class="num-length">
												<textarea class="form-control progress_comment_rater_4 hide" id="progress_comment_rater_4" maxlength="1000" rows="3" cols="20">{{$data2['progress_comment_rater_4']}}</textarea>
											</span>
										</td>
									</tr>
									@elseif($progress_comment_display_status4 == 2)
									<tr>
										<td style="background: #e5e5e5;font-weight: bold;">
											<div class="d-flex flex-column">
												<span>{{ __('messages.4th_rater') }}</span>
												<span>{{ $data2['progress_comment_title'] }}</span>				
											</div>
										</td>
										<td>
											{!! nl2br($data2['progress_comment_rater_4']) !!}
											<input type="hidden" class="form-control progress_comment_rater_4" id="progress_comment_rater_4" value="{{$data2['progress_comment_rater_4']}}" />
										</td>
									</tr>
									@endif
								</tbody>
							</table>
						</div>
					</div>
				</div>
				@endif
				@if($evaluation_comment_display_status > 0 || $self_assessment_comment_display_status > 0 || $challengelevel_criteria_display_status > 0 || $point_criteria_display_status >0)
				<div class="row">
					<div class="col-md-12">
						<p style="margin-bottom: 5px;"><b>{{ __('messages.input_evaluation_comment') }}</b></p>
						<hr style="margin-top: 0;">
					</div>
				</div> <!-- end .row -->
				@endif
				<div class="row">
					<div class="col-md-5">
						<table class="table table-bordered btm-comment table-hover">
							<tbody>
								@foreach($data5 as $row)
								@if($row['evaluation_step'] == 0 && $row['evaluation_comment_status0'] == 1)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.self_evaluation_comment') }}</td>
									<td>
										<span class="num-length">
											<textarea class="form-control" id="evaluation_comment0" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment']}}</textarea>
										</span>
									</td>
								</tr>
								@elseif($row['evaluation_step'] == 0 && $row['evaluation_comment_status0'] == 2)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.self_evaluation_comment') }}</td>
									<td style="background: #f6f7f9">
										{!! nl2br($row['evaluation_comment']) !!}
									</td>
								</tr>
								@endif
								@if($row['evaluation_step'] == 1 && $row['evaluation_comment_status1'] == 1)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.1st_eval_comment') }}</td>
									<td>
										<span class="num-length ">
											<textarea class="form-control" id="evaluation_comment1" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment']}}</textarea>
										</span>
									</td>
								</tr>
								@elseif($row['evaluation_step'] == 1 && $row['evaluation_comment_status1'] == 2)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.1st_eval_comment') }}</td>
									<td style="background: #f6f7f9">
										{!! nl2br($row['evaluation_comment']) !!}
									</td>
								</tr>
								@endif
								@if($row['evaluation_step'] == 2 && $row['evaluation_comment_status2'] == 1)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.2nd_eval_comment') }}</td>
									<td>
										<span class="num-length">
											<textarea class="form-control" id="evaluation_comment2" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment']}}</textarea>
										</span>
									</td>
								</tr>
								@elseif($row['evaluation_step'] == 2 && $row['evaluation_comment_status2'] == 2)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.2nd_eval_comment') }}</td>
									<td style="background: #f6f7f9">
										{!! nl2br($row['evaluation_comment']) !!}
									</td>
								</tr>
								@endif
								@if($row['evaluation_step'] == 3 && $row['evaluation_comment_status3'] == 1)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.3rd_eval_comment') }}</td>
									<td>
										<span class="num-length">
											<textarea class="form-control" id="evaluation_comment3" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment']}}</textarea>
										</span>
									</td>
								</tr>
								@elseif($row['evaluation_step'] == 3 && $row['evaluation_comment_status3'] == 2)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.3rd_eval_comment') }}</td>
									<td style="background: #f6f7f9">
										{!! nl2br($row['evaluation_comment']) !!}
									</td>
								</tr>
								@endif
								@if($row['evaluation_step'] == 4 && $row['evaluation_comment_status4'] == 1)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.4th_eval_comment') }}</td>
									<td>
										<span class="num-length">
											<textarea class="form-control" id="evaluation_comment4" maxlength="1000" rows="3" cols="20">{{$row['evaluation_comment']}}</textarea>
										</span>
									</td>
								</tr>
								@elseif($row['evaluation_step'] == 4 && $row['evaluation_comment_status4'] == 2)
								<tr>
									<td style="background: #e5e5e5;font-weight: bold;">{{ __('messages.4th_eval_comment') }}</td>
									<td style="background: #f6f7f9">
										{!! nl2br($row['evaluation_comment']) !!}
									</td>
								</tr>
								@endif
								@endforeach
							</tbody>
						</table>
					</div>
					@if($challengelevel_criteria_display_status > 0)
					<div class="col-md-4">
						<table class="table table-bordered table-striped table-hover">
							<thead>
								<tr>
									<th class="text-center" width="90px">{{ difficulty_level_cri() }}</th>
									<th class="text-center" width="60px">{{ __('messages.coefficient') }}</th>
									<th class="text-center">{{ __('messages.description') }}</th>
								</tr>
							</thead>
							<tbody>
								@foreach($data6 as $row)
								<tr>
									<td class="th1">{{$row['challenge_level_nm']}}</td>
									<td class="th1 text-right">{{$row['betting_rate']}}</td>
									<td class="th1">{{$row['explanation']}}</td>
								</tr>
								@endforeach
							</tbody>
						</table>
					</div>
					@endif
					@if($point_criteria_display_status > 0)
					<div class="col-md-3">
						<table class="table table-bordered table-striped table-hover">
							<thead>
								<tr>
									<th width="100" class="text-center">{{ __('messages.eval_points') }}</th>
									<th class="text-center">{{ __('messages.eval_standard') }}</th>
								</tr>
							</thead>
							<tbody>
								@foreach($data7 as $row)
								<tr>
									<td class="th1">{{$row['point_nm']}}</td>
									<td class="th1">{{$row['point_criteria']}}</td>
								</tr>
								@endforeach
							</tbody>
						</table>
					</div>
					@endif
				</div> <!-- end .row -->
			</div><!-- end .col-md-12 -->
		</div><!-- end .row -->
		<input type="hidden" class="anti_tab" name="">
	</div><!-- end .container-fluid -->
</div>
@stop