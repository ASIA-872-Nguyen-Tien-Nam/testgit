@extends('layout')

@section('asset_header')
{!!public_url('template/css/form/i2020.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/form/i2020.index.js')!!}
@stop
@push('asset_button')
{!!
Helper::buttonRender(['memoryButton','confirmButton2','interviewButton','backButton'],[],$button)
!!}
@endpush
@section('content')
@section('screen_title')
	{{ $screen_title }}
@stop
<div class="container-fluid">
<div class="" style="overflow-x: hidden;">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-3 col-sm-12 col-12 col-lg-3 col-xl-2">
					<div class="">
					    <table class="table table_avatar">
					        <tbody>
					            <tr>
					                <td>
					                	@if(isset($list['picture']) && $list['picture'] != '')
											<div class="avatar">
												<div class="img ">
													<div class="d-flex flex-box {{(!isset($list['picture']) || $list['picture'] == '')?"flex-box-image":""}}">
															@if(!isset($list['picture']) || $list['picture'] == '')
																<p class="w100">{{ __('messages.photo') }}</p>
																<img id="img-upload" class="thumb"/>
															@else
																<img id='img-upload' class="thumb imgs" src="{{$list['picture']}}?v={{time()}}" />
															@endif
							
													</div>
												</div><!-- end .d-flex -->
											</div>
										@else
											<div class="avatar">
												<div class="img">
													<div class="d-flex flex-box portrait">
														<p class="w100">{{ __('messages.photo') }}</p>
														<img id="img-upload" class="thumb"/>
													</div>
												</div>
											</div>
										@endif
										<div class="text-center" style="word-break: break-all;" id="employee_nm">{{isset($list['employee_nm'])?$list['employee_nm']:''}}</div>
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
							                <td class="text-center" style="color: red; word-break:break-all;">{{isset($list['status_nm'])?$list['status_nm']:''}}</td>
							            </tr>
							        </tbody>
							    </table>
							</div>
						</div>
						<div class="col-md-9">
							<nav class="clearfix">
							  <ul class="pagination step" style="min-width: {{ !empty($data11)?(count($data11)-1) * 60:'' }}px">
							    {{-- <li class="line">&nbsp;</li> --}}
								@if(isset($data11))
									@foreach($data11 as $row)
										@if($row['status_use_typ'] == 1)
											@if(isset($list['status_cd']) && $row['id'] <= $list['status_cd'])
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
					<input type="hidden" id="fiscal_year" value="{{$fiscal_year??''}}">
					<input type="hidden" id="employee_cd_refer" value="{{$employee_cd_refer??''}}">
					<input type="hidden" id="sheet_cd" value="{{$sheet_cd??''}}">
					<input type="hidden" id="status_cd" value="{{isset($list['status_cd'])?$list['status_cd']:''}}">
					<input type="hidden" id="evaluation_step" value="{{isset($list['evaluation_step'])?$list['evaluation_step']:''}}">
					<input type="hidden" id="point_calculation_typ1" value="{{isset($list['point_calculation_typ1'])?$list['point_calculation_typ1']:''}}">
					<input type="hidden" id="point_calculation_typ2" value="{{isset($list['point_calculation_typ2'])?$list['point_calculation_typ2']:''}}">
					<input type="hidden" id="from" value="{{$from ??''}}" />
					<input type="hidden" id="from_source" value="{{$from_source ??''}}">
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
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['employee_typ_nm'] ?? ''}}">{{$list['employee_typ_nm'] ?? ''}}</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
												<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.job') }}">{{ __('messages.job') }}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['job_nm'] ?? ''}}">{{$list['job_nm'] ?? ''}}</label>
												</div>
											</div>
										</td>		
										<td>
											<div class="form-inline finline">
												<div class="form-group">
												<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.position') }}">{{ __('messages.position') }}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['position_nm'] ?? ''}}">{{$list['position_nm'] ?? ''}}</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
											   		<label class="form-control-plaintext lbl">{{ __('messages.grade') }}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['grade_nm'] ?? ''}}">{{$list['grade_nm'] ?? ''}}</label>
												</div>
											</div>
										</td>		
										<td>
											<div class="form-inline finline">
												<div class="form-group">
											   		<label class="form-control-plaintext lbl">{{ __('messages.salary') }}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['salary_grade'] ?? ''}}">{{$list['salary_grade'] ?? ''}}</label>
												</div>
											</div>
										</td>						
									</tr>
									@if(!empty($data10))
									<tr>
										@foreach($data10 as $temp)
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['organization_group_nm']}}">{{$temp['organization_group_nm']}}</label>
												</div>
												<div class="form-group">
													@if ($temp['organization_typ'] == 1)
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['belong_nm1'] ?? ''}}">{{$list['belong_nm1'] ?? ''}}</label>
													@elseif ($temp['organization_typ'] == 2)
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['belong_nm2'] ?? ''}}">{{$list['belong_nm2'] ?? ''}}</label>
													@elseif ($temp['organization_typ'] == 3)
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['belong_nm3'] ?? ''}}">{{$list['belong_nm3'] ?? ''}}</label>
													@elseif ($temp['organization_typ'] == 4)
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['belong_nm4'] ?? ''}}">{{$list['belong_nm4'] ?? ''}}</label>
													@elseif ($temp['organization_typ'] == 5)
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['belong_nm5'] ?? ''}}">{{$list['belong_nm5'] ?? ''}}</label>
													@else
													<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title=""></label>
													@endif
												</div>
											</div>
										</td>
										@endforeach
									</tr>
									@endif
									<tr>
									@if(isset($list['rater_employee_nm_1']) && $list['rater_employee_nm_1'] != '')
									<td>
										<div class="form-inline finline">
											<div class="form-group">
												<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.1st_rater') }}">{{ __('messages.1st_rater') }}</label>
											</div>
											<div class="form-group">
										    	<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['rater_employee_nm_1'] ?? ''}}">{{$list['rater_employee_nm_1'] ?? ''}}</label>
											</div>
										</div>
									</td>
									@endif
									@if(isset($list['rater_employee_nm_2']) && $list['rater_employee_nm_2'] != '')
									<td>
										<div class="form-inline finline">
											<div class="form-group">
											<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.2nd_rater') }}">{{ __('messages.2nd_rater') }}</label>
											</div>
											<div class="form-group">
										    	<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['rater_employee_nm_2'] ?? ''}}">{{$list['rater_employee_nm_2'] ?? ''}}</label>
											</div>
										</div>
									</td>
									@endif	
									@if(isset($list['rater_employee_nm_3']) && $list['rater_employee_nm_3'] != '')
									<td>
										<div class="form-inline finline">
											<div class="form-group">
											<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.3rd_rater') }}">{{ __('messages.3rd_rater') }}</label>
											</div>
											<div class="form-group">
										    	<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['rater_employee_nm_3'] ?? ''}}">{{$list['rater_employee_nm_3'] ?? ''}}</label>
											</div>
										</div>
									</td>
									@endif
									@if(isset($list['rater_employee_nm_4']) && $list['rater_employee_nm_4'] != '')
									<td>
										<div class="form-inline finline">
											<div class="form-group">
											<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.4th_rater') }}">{{ __('messages.4th_rater') }}</label>
											</div>
											<div class="form-group">
										    	<label class="form-control-plaintext txt text-overfollow" style="max-width: 180px;" data-container="body" data-toggle="tooltip" data-original-title="{{$list['rater_employee_nm_4'] ?? ''}}">{{$list['rater_employee_nm_4'] ?? ''}}</label>
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
			<div class="row">
					<div class="col-md-12">
						<div class="table-responsive">
							<table class="table-striped table table-bordered" id="table-2">
								<thead>
									<tr>
										@if($generic_comment_status1 > 0)
											<th>{{$M0200['generic_comment_title_1']}}</th>
										@endif
										@if($generic_comment_status2 > 0)
											<th>{{$M0200['generic_comment_title_2']}}</th>
										@endif
										@if($generic_comment_status8 > 0)
											<th>{{$M0200['generic_comment_title_8']}}</th>
										@endif
										@if($generic_comment_status3 > 0)
											<th>{{$M0200['generic_comment_title_3']}}</th>
										@endif
										@if($generic_comment_status4 > 0)
											<th>{{$M0200['generic_comment_title_4']}}</th>
										@endif
										@if($generic_comment_status5 > 0)
											<th>{{$M0200['generic_comment_title_5']}}</th>
										@endif
										@if($generic_comment_status6 > 0)
											<th>{{$M0200['generic_comment_title_6']}}</th>
										@endif
										@if($generic_comment_status7 > 0)
											<th>{{$M0200['generic_comment_title_7']}}</th>
										@endif
									</tr>
								</thead>
								<tbody>
									<tr>
										@if($generic_comment_status1 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_1" readonly="readonly" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_1']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status1 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_1']) !!}
											<input type="hidden" id="generic_comment_1" value="{{$M0200['generic_comment_1']}}" />
										</td>
										@endif
										@if($generic_comment_status2 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_2" readonly="readonly" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_2']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status2 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_2']) !!}
											<input type="hidden" id="generic_comment_2" value="{{$M0200['generic_comment_2']}}" />
										</td>
										@endif
										@if($generic_comment_status8 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_8" readonly="readonly" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_8']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status8 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_8']) !!}
											<input type="hidden" id="generic_comment_8" value="{{$M0200['generic_comment_8']}}" />
										</td>
										@endif
										@if($generic_comment_status3 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_3" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_3']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status3 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_3']) !!}
											<input type="hidden" id="generic_comment_3" value="{{$M0200['generic_comment_3']}}" />
										</td>
										@endif
										@if($generic_comment_status4 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_4" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_4']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status4 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_4']) !!}
											<input type="hidden" id="generic_comment_4" value="{{$M0200['generic_comment_4']}}" />
										</td>
										@endif
										@if($generic_comment_status5 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_5" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_5']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status5 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_5']) !!}
											<input type="hidden" id="generic_comment_5" value="{{$M0200['generic_comment_5']}}" />
										</td>
										@endif
										@if($generic_comment_status6 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_6" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_6']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status6 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_6']) !!}
											<input type="hidden" id="generic_comment_6" value="{{$M0200['generic_comment_6']}}" />
										</td>
										@endif
										@if($generic_comment_status7 == 2)
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											<span class="num-length">
												<textarea class="form-control" id="generic_comment_7" maxlength="400" rows="3" cols="20">{{$M0200['generic_comment_7']}}</textarea>
											</span>
										</td>
										@elseif($generic_comment_status7 == 1)	
										<td style="width: {{$generic_comment_width}}vw;word-break: break-all;">
											{!! nl2br($M0200['generic_comment_7']) !!}
											<input type="hidden" id="generic_comment_7" value="{{$M0200['generic_comment_7']}}" />
										</td>
										@endif
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div> <!-- end .row -->
		</div>
	</div>
	<div class="d-flex justify-content-end mb-1 button-midd-div">
		@if (isset($M0200['upload_file']) && $M0200['upload_file'] != '')
		<a class="btn btn-primary btn-upload" id="btn-download" file-name="{{isset($M0200['upload_file'])?($M0200['upload_file']):''}}" file-adress="{{isset($M0200['file_adress'])?($M0200['file_adress']):''}}" style="font-size: 12px; padding: 9px">
			{{ __('messages.download_manual') }}
		</a>
		@endif
	</div><!-- end .d-flex -->
	<div class="row">
		<div class="col-md-12">
	        <div class="wmd-view-topscroll">
	            <div class="scroll-div1"></div>
	        </div>
		</div>
	</div><!-- end .row -->
	<div class="row">
		<div class="col-md-12">
			<div class="table-responsive wmd-view">
				<table class="table table-bordered table-hover table-striped table-resize ofixed-boder" data-resizable-columns-id="demo-table-v2" id="table_result" >
					<thead>
						@php
							$col 			=	0;
							$col_evaluation	=	0;
						@endphp
						<tr>
							@if(isset($M0200['item_display_typ_1']) && ($M0200['item_display_typ_1'] != 0))
								<th data-resizable-column-id="1" class="">{{(isset($M0200['item_display_typ_1']) ? $M0200['item_title_1'] :'')}}</th>
								@php $col++;@endphp
							@endif
							@if(isset($M0200['item_display_typ_2']) && ($M0200['item_display_typ_2'] != 0))
								<th data-resizable-column-id="2" class="">{{(isset($M0200['item_display_typ_2']) ? $M0200['item_title_2'] :'')}}</th>
								@php $col++;@endphp
							@endif
							@if(isset($M0200['item_display_typ_3']) && ($M0200['item_display_typ_3'] != 0))
								<th data-resizable-column-id="3" class="">{{(isset($M0200['item_display_typ_3']) ? $M0200['item_title_3'] :'')}}</th>
								@php $col++;@endphp
							@endif
							@if(isset($M0200['weight_display_typ']) && ($M0200['weight_display_typ'] != 0))
								<th data-resizable-column-id="4"  class="col-fix-option view">{{$weight_display_nm}}</th>
								@php $col++;@endphp
							@endif
							<!-- 明細自己進捗コメント -->
							@if(isset($ItemFLG['detail_self_progress_comment_display_typ_flg']) && $ItemFLG['detail_self_progress_comment_display_typ_flg'] == 2)
								@if(isset($M0200['detail_self_progress_comment_display_typ']) && ($M0200['detail_self_progress_comment_display_typ'] != 0))
									<th data-resizable-column-id="6" class="col-fix-comment">
										<div class="justify-content-between">
											<span style="word-break: break-all">{{ isset($M0200['detail_self_progress_comment_title']) ? $M0200['detail_self_progress_comment_title'] : ''}}</span>
											<div class="ics-group">
												<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_self_progress_comment_edit">
													{{ __('messages.input') }}
												</a>
												<a href="javascript:;" class="btn btn-outline-primary btn-comment-edit" id="btn_self_progress_comment_approve">
													{{ __('messages.save') }}
												</a>
											</div>
										</div>
									</th>
									@php $col++;@endphp
								@endif
							@elseif(isset($ItemFLG['detail_self_progress_comment_display_typ_flg']) && $ItemFLG['detail_self_progress_comment_display_typ_flg'] == 1)
								@if(isset($M0200['detail_self_progress_comment_display_typ']) && ($M0200['detail_self_progress_comment_display_typ'] != 0))
									<th data-resizable-column-id="6" class="col-fix-comment view">
										{{ isset($M0200['detail_self_progress_comment_title']) ? $M0200['detail_self_progress_comment_title'] : ''}}
									</th>
									@php $col++;@endphp
								@endif
							@endif
							<!-- 明細進捗コメント -->
							@if(isset($ItemFLG['detail_progress_comment_display_typ_flg']) && $ItemFLG['detail_progress_comment_display_typ_flg'] == 2)
								@if(isset($M0200['detail_progress_comment_display_typ']) && ($M0200['detail_progress_comment_display_typ'] != 0))
									<th data-resizable-column-id="6" class="col-fix-comment">
										<div class="justify-content-between">
											<span style="word-break: break-all">{{ isset($M0200['detail_progress_comment_title']) ? $M0200['detail_progress_comment_title'] : ''}}</span>
											<div class="ics-group">
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
								@endif
							@elseif(isset($ItemFLG['detail_progress_comment_display_typ_flg']) && $ItemFLG['detail_progress_comment_display_typ_flg'] == 1)
								@if(isset($M0200['detail_progress_comment_display_typ']) && ($M0200['detail_progress_comment_display_typ'] != 0))
									<th data-resizable-column-id="6" class="col-fix-comment view">
										{{ isset($M0200['detail_progress_comment_title']) ? $M0200['detail_progress_comment_title'] : ''}}
									</th>
									@php $col++;@endphp
								@endif
							@endif
							<!-- 自己評価 -->
							@if (isset($M0200['evaluation_self_typ']) && ($M0200['evaluation_self_typ'] != 0))
								@if(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] == 1))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
										<th data-resizable-column-id="5" class="col-fix view">{{ __('messages.eval_self') }}</th>
										@php $col++;@endphp
									@endif
								@elseif(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] == 2))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
										<th data-resizable-column-id="5" class="col-fix">{{ __('messages.eval_self') }}</th>
										@php $col++;@endphp
									@endif
								@endif
							@endif
							<!-- 一次評価 -->
							@if(isset($ItemFLG['evaluation_1_flg']) && ($ItemFLG['evaluation_1_flg'] == 1))
								@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								<th data-resizable-column-id="8"  class="col-fix view">{{ __('messages.eval_1st') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@elseif(isset($ItemFLG['evaluation_1_flg']) && ($ItemFLG['evaluation_1_flg'] == 2))
								@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								<th data-resizable-column-id="8"  class="col-fix">{{ __('messages.eval_1st') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@endif
							<!-- 二次評価 -->
							@if(isset($ItemFLG['evaluation_2_flg']) && ($ItemFLG['evaluation_2_flg'] == 1))
								@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
								<th data-resizable-column-id="9" class="col-fix view">{{ __('messages.eval_2nd') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@elseif(isset($ItemFLG['evaluation_2_flg']) && ($ItemFLG['evaluation_2_flg'] == 2))
								@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
								<th data-resizable-column-id="9" class="col-fix">{{ __('messages.eval_2nd') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@endif
							<!-- 三次評価 -->
							@if(isset($ItemFLG['evaluation_3_flg']) && ($ItemFLG['evaluation_3_flg'] == 1))
								@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								<th data-resizable-column-id="10"  class="col-fix view">{{ __('messages.eval_3rd') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@elseif(isset($ItemFLG['evaluation_3_flg']) && ($ItemFLG['evaluation_3_flg'] == 2))
								@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								<th data-resizable-column-id="10"  class="col-fix">{{ __('messages.eval_3rd') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@endif
							<!-- 四次評価 -->
							@if(isset($ItemFLG['evaluation_4_flg']) && ($ItemFLG['evaluation_4_flg'] == 1))
								@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								<th data-resizable-column-id="11"  class="col-fix view">{{ __('messages.eval_4th') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@elseif(isset($ItemFLG['evaluation_4_flg']) && ($ItemFLG['evaluation_4_flg'] == 2))
								@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								<th data-resizable-column-id="11"  class="col-fix">{{ __('messages.eval_4th') }}</th>
								@php $col_evaluation++;@endphp
								@endif
							@endif
							<!-- 自己評価コメント -->
							@if (isset($M0200['evaluation_self_typ']) && ($M0200['evaluation_self_typ'] != 0))
								@if(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] == 1))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
										@if(isset($M0200['detail_comment_display_typ_0']) && ($M0200['detail_comment_display_typ_0'] != 0))
											<th data-resizable-column-id="6" class="">{{ __('messages.self_evaluation_comment') }}</th>
										@endif
									@endif
								@elseif(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] == 2))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
										@if(isset($M0200['detail_comment_display_typ_0']) && ($M0200['detail_comment_display_typ_0'] != 0))
											<th data-resizable-column-id="6" class="">{{ __('messages.self_evaluation_comment') }}</th>
										@endif
									@endif
								@endif
							@endif
							<!-- 一次評価コメント -->
							@if(isset($M0200['detail_comment_display_typ_1']) && ($M0200['detail_comment_display_typ_1'] != 0))
							@if(isset($ItemFLG['evaluation_comment_detail_flg_1']) && ($ItemFLG['evaluation_comment_detail_flg_1'] != 0))
							@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								<th data-resizable-column-id="7" class="">{{ __('messages.1st_eval_comment') }}</th>
							@endif
							@endif
							@endif
							<!-- 二次評価コメント -->
							@if(isset($M0200['detail_comment_display_typ_2']) && ($M0200['detail_comment_display_typ_2'] != 0))
							@if(isset($ItemFLG['evaluation_comment_detail_flg_2']) && ($ItemFLG['evaluation_comment_detail_flg_2'] != 0))
							@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
								<th data-resizable-column-id="7" class="">{{ __('messages.2nd_eval_comment') }}</th>
							@endif
							@endif
							@endif
							<!-- 三次評価コメント -->
							@if(isset($M0200['detail_comment_display_typ_3']) && ($M0200['detail_comment_display_typ_3'] != 0))
							@if(isset($ItemFLG['evaluation_comment_detail_flg_3']) && ($ItemFLG['evaluation_comment_detail_flg_3'] != 0))
							@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								<th data-resizable-column-id="7" class="">{{ __('messages.3rd_eval_comment') }}</th>
							@endif
							@endif
							@endif
							<!-- 四次評価コメント -->
							@if(isset($M0200['detail_comment_display_typ_4']) && ($M0200['detail_comment_display_typ_4'] != 0))
							@if(isset($ItemFLG['evaluation_comment_detail_flg_4']) && ($ItemFLG['evaluation_comment_detail_flg_4'] != 0))
							@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								<th data-resizable-column-id="7" class="">{{ __('messages.4th_eval_comment') }}</th>
							@endif
							@endif
							@endif
						</tr>
					</thead>
					<tbody>
						@if($table)
							@foreach($table as $row)
							<tr class="tr_list">
								<input type="hidden" class="item_no" value="{{$row['item_no']??''}}">
								<input type="hidden" class="weight" value="{{$row['weight']??''}}">
								@if(isset($M0200['item_display_typ_1']) && ($M0200['item_display_typ_1'] != 0))
								<td class ="text-left">{!! nl2br($row['item_detail_1']) !!}</td>
								@endif
								@if(isset($M0200['item_display_typ_2']) && ($M0200['item_display_typ_2'] != 0))
								<td class ="text-left">{!! nl2br($row['item_detail_2']) !!}</td>
								@endif
								@if(isset($M0200['item_display_typ_3']) && ($M0200['item_display_typ_3'] != 0))
								<td class ="text-left">{!! nl2br($row['item_detail_3']) !!}</td>
								@endif
								@if(isset($M0200['weight_display_typ']) && ($M0200['weight_display_typ'] != 0))
								<td class="xxx text-right">
									@if($weight_display_nm == 'ｳｪｲﾄ')
									{{isset($row['weight'])?$row['weight'].'%':''}}
									@elseif($weight_display_nm == 'Weight')
									{{isset($row['weight'])?$row['weight'].'%':''}}
									@else
									{{isset($row['weight'])?$row['weight']:''}}
									@endif
								</td>
								@endif
								<!-- 明細自己進捗コメント -->
								@if(isset($ItemFLG['detail_self_progress_comment_display_typ_flg']) && ($ItemFLG['detail_self_progress_comment_display_typ_flg'] == 2))
									@if(isset($M0200['detail_self_progress_comment_display_typ']) && ($M0200['detail_self_progress_comment_display_typ'] != 0))
									<td class ="text-left" style="height:100px">
										<span class="self_progress_comment_hide">{!! nl2br($row['self_progress_comment']) !!}</span>
										<span class="div_self_progress_comment hide">
											<span class="num-length span_evaluation_comment">
												<textarea class="form-control self_progress_comment" id="self_progress_comment" maxlength="1000" rows="2" cols="10">{{$row['self_progress_comment']}}</textarea>
											</span>
										</span>
									</td>	
									@endif
								@elseif(isset($ItemFLG['detail_self_progress_comment_display_typ_flg']) && ($ItemFLG['detail_self_progress_comment_display_typ_flg'] == 1))
									@if(isset($M0200['detail_self_progress_comment_display_typ']) && ($M0200['detail_self_progress_comment_display_typ'] != 0))
									<td>
										{!! nl2br($row['self_progress_comment']) !!}
										<input type="hidden" class="form-control self_progress_comment" id="self_progress_comment" value="{{$row['self_progress_comment']}}" />
									</td>
									@endif
								@endif
								<!-- 明細進捗コメント -->
								@if(isset($ItemFLG['detail_progress_comment_display_typ_flg']) && ($ItemFLG['detail_progress_comment_display_typ_flg'] == 2))
									@if(isset($M0200['detail_progress_comment_display_typ']) && ($M0200['detail_progress_comment_display_typ'] != 0))
									<td class ="text-left"  style="height:100px">
										<span class="progress_comment_hide">{!! nl2br($row['progress_comment']) !!}</span>
										<span class="div_progress_comment hide">
											<span class="num-length span_evaluation_comment">
												<textarea class="form-control progress_comment" id="progress_comment" maxlength="1000" rows="2" cols="10">{{$row['progress_comment']}}</textarea>
											</span>
										</span>
									</td>	
									@endif
								@elseif(isset($ItemFLG['detail_progress_comment_display_typ_flg']) && ($ItemFLG['detail_progress_comment_display_typ_flg'] == 1))
									@if(isset($M0200['detail_progress_comment_display_typ']) && ($M0200['detail_progress_comment_display_typ'] != 0))
									<td>
										{!! nl2br($row['progress_comment']) !!}
										<input type="hidden" class="form-control progress_comment" id="progress_comment" value="{{$row['progress_comment']}}" />
									</td>
									@endif
								@endif
								<!-- 自己評価 -->
								@if (isset($M0200['evaluation_self_typ']) && ($M0200['evaluation_self_typ'] != 0))
									@if(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] != 0))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
									<td class ="text-left">
										@if($ItemFLG['listItemFLG0'] == 2)
										<select name="" id="" class="form-control input-sm point_cd_0 required" step="0" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
											<option value="-1" point="0"></option>
											@foreach($combobox as $item)
												<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_0'])&&($row['point_cd_0'] == $item['point_cd']) ? 'selected' : ''}}>
														{{$item['point_nm']}}
													</option>
											@endforeach
										</select>
										@else
										{{$row['point_nm_0']}}
										<select name="" id="" class="form-control input-sm point_cd_0 hidden" step="0" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}" disabled>
											<option value="-1" point="0"></option>
											@foreach($combobox as $item)
												<option value="{{$item['point_cd']}}"  point="{{$item['point']}}"   {{isset($row['point_cd_0'])&&($row['point_cd_0'] == $item['point_cd']) ? 'selected' : ''}}>
														{{$item['point_nm']}}
													</option>
											@endforeach
										</select>
										@endif
									</td>
									@endif
									@endif	
								@endif
								<!-- 一次評価 -->
								@if(isset($ItemFLG['evaluation_1_flg']) && ($ItemFLG['evaluation_1_flg'] != 0))
								@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								@if($ItemFLG['evaluation_1_flg'] == 2)
								<td>
									<select name="" id="point_cd_1" class="form-control input-sm point_cd_1 required" step="1" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1" point="0"></option>
										@foreach($combobox as $item)
										<option value="{{$item['point_cd']}}" point="{{$item['point']}}"  {{isset($row['point_cd_1'])&&($row['point_cd_1'] == $item['point_cd']) ? 'selected' : ''}}>
											{{$item['point_nm']}}
										</option>
										@endforeach
									</select>
				                </td>
				                @else
								<td class ="text-left">
									{{$row['point_nm_1']}}
									<select class="form-control input-sm point_cd_1 hidden" step="1" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1"></option>
										@foreach($combobox as $item)
											<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_1'])&&($row['point_cd_1'] == $item['point_cd']) ? 'selected' : ''}}>
												{{$item['point_nm']}}
											</option>
										@endforeach
									</select>
								</td>
								@endif
								@endif
								@endif
								<!-- 二次評価 -->
								@if(isset($ItemFLG['evaluation_2_flg']) && ($ItemFLG['evaluation_2_flg'] != 0))
									@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
										@if($ItemFLG['evaluation_2_flg'] == 2)
						                <td>
											<select name="" id="point_cd_2" class="form-control input-sm point_cd_2 required" step="2" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1" point="0"></option>
												@foreach($combobox as $item)
													<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_2'])&&($row['point_cd_2'] == $item['point_cd']) ? 'selected' : ''}}>
															{{$item['point_nm']}}
													</option>
												@endforeach
											</select>
						                </td>
						                @else
										<td class ="text-left">
											{{$row['point_nm_2']}}
											<select class="form-control input-sm point_cd_2 hidden" step="2" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
												<option value="-1"></option>
												@foreach($combobox as $item)
													<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_2'])&&($row['point_cd_2'] == $item['point_cd']) ? 'selected' : ''}}>
															{{$item['point_nm']}}
														</option>
												@endforeach
											</select>
										</td>
										@endif
					                @endif
								@endif
								<!-- 三次評価 -->
								@if(isset($ItemFLG['evaluation_3_flg']) && ($ItemFLG['evaluation_3_flg'] != 0))
								@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								@if($ItemFLG['evaluation_3_flg'] == 2)
				                <td>
									<select name="" id="point_cd_3" class="form-control input-sm point_cd_3 required" step="3" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1" point="0"></option>
										@foreach($combobox as $item)
											<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_3'])&&($row['point_cd_3'] == $item['point_cd']) ? 'selected' : ''}}>
													{{$item['point_nm']}}
												</option>
										@endforeach
									</select>
				                </td>
				                @else
								<td class ="text-left">
									{{$row['point_nm_3']}}
									<select class="form-control input-sm point_cd_3 hidden" step="3" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1"></option>
										@foreach($combobox as $item)
											<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_3'])&&($row['point_cd_3'] == $item['point_cd']) ? 'selected' : ''}}>
													{{$item['point_nm']}}
												</option>
										@endforeach
									</select>
								</td>
								@endif
				                @endif
								@endif
								<!-- 四次評価 -->
								@if(isset($ItemFLG['evaluation_4_flg']) && ($ItemFLG['evaluation_4_flg'] != 0))
								@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								@if($ItemFLG['evaluation_4_flg'] == 2)
				                <td>
									<select name="" id="point_cd_4" class="form-control input-sm point_cd_4 required" step="4" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1" point="0"></option>
										@foreach($combobox as $item)
											<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_4'])&&($row['point_cd_4'] == $item['point_cd']) ? 'selected' : ''}}>
													{{$item['point_nm']}}
												</option>
										@endforeach
									</select>
				                </td>
				                @else
								<td class ="text-left">
									{{$row['point_nm_4']}}
									<select class="form-control input-sm point_cd_4 hidden" step="4" betting_rate="{{$row['betting_rate']}}" weight="{{$row['weight']}}">
										<option value="-1"></option>
										@foreach($combobox as $item)
											<option value="{{$item['point_cd']}}" point="{{$item['point']}}" {{isset($row['point_cd_4'])&&($row['point_cd_4'] == $item['point_cd']) ? 'selected' : ''}}>
													{{$item['point_nm']}}
												</option>
										@endforeach
									</select>
								</td>
								@endif
				                @endif
								@endif
								<!-- 自己評価コメント -->
								@if (isset($M0200['evaluation_self_typ']) && ($M0200['evaluation_self_typ'] != 0))
									@if(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] != 0))
									@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
										<!-- 自己評価コメント -->
										@if(isset($M0200['detail_comment_display_typ_0']) && ($M0200['detail_comment_display_typ_0'] != 0))
										<td class ="text-left"  style="height:100px">
											@if ($ItemFLG['listItemFLG0'] == 2)
											<span class="num-length span_evaluation_comment">
													<textarea class="form-control evaluation_comment"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment']}}">{{$row['evaluation_comment']}}</textarea>
											</span>
											@else
												{!! nl2br($row['evaluation_comment']) ?? '' !!}
												<textarea  class="form-control evaluation_comment hidden"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment']}}">{{$row['evaluation_comment']}}</textarea>
											@endif
										</td>
										@endif
									@endif
									@endif
								@endif
								<!-- 一次評価コメント -->
								@if(isset($M0200['detail_comment_display_typ_1']) && ($M0200['detail_comment_display_typ_1'] != 0))
								@if(isset($ItemFLG['evaluation_comment_detail_flg_1']) && ($ItemFLG['evaluation_comment_detail_flg_1'] != 0))
								@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								<td style="height:100px">
									@if ($ItemFLG['evaluation_comment_detail_flg_1'] == 2)
									<span class="num-length span_evaluation_comment">
										<textarea style="height: 100%" {{$ItemFLG['evaluation_comment_detail_flg_1'] == 2?'':'disabled'}} class="form-control evaluation_comment_detail_1"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment_detail_1']}}">{{$row['evaluation_comment_detail_1']}}</textarea>
									</span>
									@else
										{!! nl2br($row['evaluation_comment_detail_1']) ?? '' !!}
										<textarea class="form-control evaluation_comment_detail_1 hidden"  maxlength="1000" rows="2" cols="20" value="{{$row['evaluation_comment_detail_1']}}">{{$row['evaluation_comment_detail_1']}}</textarea>
									@endif
								</td>
								@endif
								@endif
								@endif
								<!-- 二次評価コメント -->
								@if(isset($M0200['detail_comment_display_typ_2']) && ($M0200['detail_comment_display_typ_2'] != 0))
								@if(isset($ItemFLG['evaluation_comment_detail_flg_2']) && ($ItemFLG['evaluation_comment_detail_flg_2'] != 0))
								@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
								<td>
									@if ($ItemFLG['evaluation_comment_detail_flg_2'] == 2)
									<span class="num-length span_evaluation_comment">
										<textarea {{$ItemFLG['evaluation_comment_detail_flg_2'] == 2?'':'disabled'}} class="form-control evaluation_comment_detail_2"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment_detail_2']}}">{{$row['evaluation_comment_detail_2']}}</textarea>
									</span>
									@else
										{!! nl2br($row['evaluation_comment_detail_2']) ?? ''!!}
										<textarea class="form-control evaluation_comment_detail_2 hidden"  maxlength="1000" rows="2" cols="20" value="{{$row['evaluation_comment_detail_2']}}">{{$row['evaluation_comment_detail_2']}}</textarea>
									@endif
								</td>
								@endif
								@endif
								@endif
								<!-- 三次評価コメント -->
								@if(isset($M0200['detail_comment_display_typ_3']) && ($M0200['detail_comment_display_typ_3'] != 0))
								@if(isset($ItemFLG['evaluation_comment_detail_flg_3']) && ($ItemFLG['evaluation_comment_detail_flg_3'] != 0))
								@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								<td>
									@if ($ItemFLG['evaluation_comment_detail_flg_3'] == 2)
									<span class="num-length span_evaluation_comment">
										<textarea {{$ItemFLG['evaluation_comment_detail_flg_3'] == 2?'':'disabled'}} class="form-control evaluation_comment_detail_3"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment_detail_3']}}">{{$row['evaluation_comment_detail_3']}}</textarea>
									</span>
									@else
										{!! nl2br($row['evaluation_comment_detail_3']) ?? ''!!}
										<textarea class="form-control evaluation_comment_detail_3 hidden"  maxlength="1000" rows="2" cols="20" value="{{$row['evaluation_comment_detail_3']}}">{{$row['evaluation_comment_detail_3']}}</textarea>
									@endif
								</td>
								@endif
								@endif
								@endif
								<!-- 四次評価コメント -->
								@if(isset($M0200['detail_comment_display_typ_4']) && ($M0200['detail_comment_display_typ_4'] != 0))
								@if(isset($ItemFLG['evaluation_comment_detail_flg_4']) && ($ItemFLG['evaluation_comment_detail_flg_4'] != 0))
								@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								<td style="height:100px">
									@if ($ItemFLG['evaluation_comment_detail_flg_4'] == 2)
									<span class="num-length span_evaluation_comment">
										<textarea style="height: 100%;" {{$ItemFLG['evaluation_comment_detail_flg_4'] == 2?'':'disabled'}} class="form-control evaluation_comment_detail_4"  maxlength="1000" rows="2" cols="10" value="{{$row['evaluation_comment_detail_4']}}">{{$row['evaluation_comment_detail_4']}}</textarea>
									</span>
									@else
										{!! nl2br($row['evaluation_comment_detail_4']) ?? '' !!}
										<textarea class="form-control evaluation_comment_detail_4 hidden"  maxlength="1000" rows="2" cols="20" value="{{$row['evaluation_comment_detail_4']}}">{{$row['evaluation_comment_detail_4']}}</textarea>
									@endif
								</td>
								@endif
								@endif
								@endif
							</tr>
							@endforeach
							<tr class="hidden TOTAL">
								@if(isset($total)&&$total['TOTAL_0']!='')
								<input type="hidden" id="TOTAL_0" value="{{$total['TOTAL_0'][0]=='.'?'0'.$total['TOTAL_0']:$total['TOTAL_0']}}">
								<input type="hidden" id="TOTAL_1" value="{{$total['TOTAL_1'][0]=='.'?'0'.$total['TOTAL_1']:$total['TOTAL_1']}}">
								<input type="hidden" id="TOTAL_2" value="{{$total['TOTAL_2'][0]=='.'?'0'.$total['TOTAL_2']:$total['TOTAL_2']}}">
								<input type="hidden" id="TOTAL_3" value="{{$total['TOTAL_3'][0]=='.'?'0'.$total['TOTAL_3']:$total['TOTAL_3']}}">
								<input type="hidden" id="TOTAL_4" value="{{$total['TOTAL_4'][0]=='.'?'0'.$total['TOTAL_4']:$total['TOTAL_4']}}">
								@endif
							</tr>
							@if($col_evaluation > 0)
							@if(isset($M0200['total_score_display_typ']) && ($M0200['total_score_display_typ'] != 0))
							@if(isset($M0100['total_score_display_typ']) && ($M0100['total_score_display_typ'] != 0))
							<tr>
								@if($col > 0)
									<td colspan="{{$col - 1}}" class="born backfff"></td>
								@endif
								@if(isset($ItemFLG['TotalFLG']) && ($ItemFLG['TotalFLG'] != 0))
								<th class="backe5">
									@if ($list['point_calculation_typ2'] == 2)
									{{ __('messages.average_score') }}
									@else
									{{ __('messages.total_points') }}
									@endif
								</th>
								@endif
								@if(isset($ItemFLG['evaluation_1_flg']) && ($ItemFLG['evaluation_1_flg'] != 0))
								@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
								<td class="text-right">
									<span id="TOTAL_1_Show">{{$total['TOTAL_1'][0]=='.'?'0'.$total['TOTAL_1']:$total['TOTAL_1']}}</span>
								</td>
								@endif
								@endif
								@if(isset($ItemFLG['evaluation_2_flg']) && ($ItemFLG['evaluation_2_flg'] != 0))
								@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
								<td class="text-right">
									<span id="TOTAL_2_Show">{{$total['TOTAL_2'][0]=='.'?'0'.$total['TOTAL_2']:$total['TOTAL_2']}}</span>
								</td>
								@endif
								@endif
								@if(isset($ItemFLG['evaluation_3_flg']) && ($ItemFLG['evaluation_3_flg'] != 0))
								@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
								<td class="text-right">
									<span id="TOTAL_3_Show">{{$total['TOTAL_3'][0]=='.'?'0'.$total['TOTAL_3']:$total['TOTAL_3']}}</span>
								</td>
								@endif
								@endif
								@if(isset($ItemFLG['evaluation_4_flg']) && ($ItemFLG['evaluation_4_flg'] != 0))
								@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
								<td class="text-right">
									<span id="TOTAL_4_Show">{{$total['TOTAL_4'][0]=='.'?'0'.$total['TOTAL_4']:$total['TOTAL_4']}}</span>
								</td>
								@endif
								@endif
							</tr>
							@endif
							@endif
							@endif
		        		@else
			        	    <tr class="tr-nodata">
			        	        <td colspan="11" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
			        	    </tr>
		        	    @endif
						</tbody>
				</table>
			</div>
		</div>
	</div>
	<div class="row mt-4">
		<div class="col-md-12">
			{{-- 進捗コメント入力 --}}
			@if (
				(isset($M0200['self_progress_comment_display_typ']) && $M0200['self_progress_comment_display_typ'] == 1)
			||	(isset($M0200['progress_comment_display_typ']) && $M0200['progress_comment_display_typ'] == 1)
			)
			<div>
				<p style="margin-bottom: 5px;"><b>{{ __('messages.input_comment_process') }}</b></p>
				<hr style="margin-top: 0;">
			</div>
			<div class="table-responsive">
				<table class="table table-bordered btm-progress-comment table-hover">
					<tbody>
						{{-- 自己進捗コメント --}}
						@if (isset($M0200['self_progress_comment_display_typ']) && $M0200['self_progress_comment_display_typ'] == 1)
							@if(isset($ItemFLG['progress_comment_display_status']) && $ItemFLG['progress_comment_display_status'] == 2)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex justify-content-between">
										{{$M0200['self_progress_comment_title']}}
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
									<span class="progress_comment_self_hide">{!! nl2br($list['progress_comment_self']) !!}</span>
									<span class="num-length">
										<textarea class="form-control progress_comment_self hide" id="progress_comment_self" maxlength="1000" rows="3" cols="20">{{$list['progress_comment_self']}}</textarea>
									</span>
								</td>
							</tr>
							@elseif(isset($ItemFLG['progress_comment_display_status']) && $ItemFLG['progress_comment_display_status'] == 1)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									{{$M0200['self_progress_comment_title']}}
								</td>
								<td>
									{!! nl2br($list['progress_comment_self']) !!}
									<input type="hidden" class="form-control progress_comment_self" id="progress_comment_self" value="{{$list['progress_comment_self']}}" />
								</td>
							</tr>
							@endif
						@endif
						{{-- 一次評価者進捗コメント --}}
						@if (isset($M0200['progress_comment_display_typ']) && $M0200['progress_comment_display_typ'] == 1
						&& 	isset($M0100['evaluation_typ_1']) && $M0100['evaluation_typ_1'] == 1
						)
							@if(isset($ItemFLG['progress_comment_display_status1']) && $ItemFLG['progress_comment_display_status1'] == 2)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex justify-content-between">
										<div class="d-flex flex-column">
											<span>{{ __('messages.1st_rater') }}</span>
											<span>{{ $M0200['progress_comment_title'] }}</span>				
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
									<span class="progress_comment_rater_hide">{!! nl2br($list['progress_comment_rater']) !!}</span>
									<span class="num-length">
										<textarea class="form-control progress_comment_rater hide" id="progress_comment_rater" maxlength="1000" rows="3" cols="20">{{$list['progress_comment_rater']}}</textarea>
									</span>
								</td>
							</tr>
							@elseif(isset($ItemFLG['progress_comment_display_status1']) && $ItemFLG['progress_comment_display_status1'] == 1)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex flex-column">
										<span>{{ __('messages.1st_rater') }}</span>
										<span>{{ $M0200['progress_comment_title'] }}</span>				
									</div>
								</td>
								<td>
									{!! nl2br($list['progress_comment_rater']) !!}
									<input type="hidden" class="form-control progress_comment_rater" id="progress_comment_rater" value="{{$list['progress_comment_rater']}}" />
								</td>
							</tr>
							@endif
						@endif
						{{-- 二次評価者進捗コメント --}}
						@if (isset($M0200['progress_comment_display_typ']) && $M0200['progress_comment_display_typ'] == 1
						&& 	isset($M0100['evaluation_typ_2']) && $M0100['evaluation_typ_2'] == 1
						)
							@if(isset($ItemFLG['progress_comment_display_status2']) && $ItemFLG['progress_comment_display_status2'] == 2)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex justify-content-between">
										<div class="d-flex flex-column">
											<span>{{ __('messages.2nd_rater') }}</span>
											<span>{{ $M0200['progress_comment_title'] }}</span>				
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
									<span class="progress_comment_rater_2_hide">{!! nl2br($list['progress_comment_rater_2']) !!}</span>
									<span class="num-length">
										<textarea class="form-control progress_comment_rater_2 hide" id="progress_comment_rater_2" maxlength="1000" rows="3" cols="20">{{$list['progress_comment_rater_2']}}</textarea>
									</span>
								</td>
							</tr>
							@elseif(isset($ItemFLG['progress_comment_display_status2']) && $ItemFLG['progress_comment_display_status2'] == 1)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex flex-column">
										<span>{{ __('messages.2nd_rater') }}</span>
										<span>{{ $M0200['progress_comment_title'] }}</span>				
									</div>
								</td>
								<td>
									{!! nl2br($list['progress_comment_rater_2']) !!}
									<input type="hidden" class="form-control progress_comment_rater_2" id="progress_comment_rater_2" value="{{$list['progress_comment_rater_2']}}" />
								</td>
							</tr>
							@endif
						@endif
						{{-- 三次評価者進捗コメント --}}
						@if (isset($M0200['progress_comment_display_typ']) && $M0200['progress_comment_display_typ'] == 1
						&& 	isset($M0100['evaluation_typ_3']) && $M0100['evaluation_typ_3'] == 1
						)
							@if(isset($ItemFLG['progress_comment_display_status3']) && $ItemFLG['progress_comment_display_status3'] == 2)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex justify-content-between">
										<div class="d-flex flex-column">
											<span>{{ __('messages.3rd_rater') }}</span>
											<span>{{ $M0200['progress_comment_title'] }}</span>				
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
									<span class="progress_comment_rater_3_hide">{!! nl2br($list['progress_comment_rater_3']) !!}</span>
									<span class="num-length">
										<textarea class="form-control progress_comment_rater_3 hide" id="progress_comment_rater_3" maxlength="1000" rows="3" cols="20">{{$list['progress_comment_rater_3']}}</textarea>
									</span>
								</td>
							</tr>
							@elseif(isset($ItemFLG['progress_comment_display_status3']) && $ItemFLG['progress_comment_display_status3'] == 1)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex flex-column">
										<span>{{ __('messages.3rd_rater') }}</span>
										<span>{{ $M0200['progress_comment_title'] }}</span>				
									</div>
								</td>
								<td>
									{!! nl2br($list['progress_comment_rater_3']) !!}
									<input type="hidden" class="form-control progress_comment_rater_3" id="progress_comment_rater_3" value="{{$list['progress_comment_rater_3']}}" />
								</td>
							</tr>
							@endif
						@endif
						{{-- 四次評価者進捗コメント --}}
						@if (isset($M0200['progress_comment_display_typ']) && $M0200['progress_comment_display_typ'] == 1
						&& 	isset($M0100['evaluation_typ_4']) && $M0100['evaluation_typ_4'] == 1
						)
							@if(isset($ItemFLG['progress_comment_display_status4']) && $ItemFLG['progress_comment_display_status4'] == 2)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex justify-content-between">
										<div class="d-flex flex-column">
											<span>{{ __('messages.4th_rater') }}</span>
											<span>{{ $M0200['progress_comment_title'] }}</span>				
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
									<span class="progress_comment_rater_4_hide">{!! nl2br($list['progress_comment_rater_4']) !!}</span>
									<span class="num-length">
										<textarea class="form-control progress_comment_rater_4 hide" id="progress_comment_rater_4" maxlength="1000" rows="3" cols="20">{{$list['progress_comment_rater_4']}}</textarea>
									</span>
								</td>
							</tr>
							@elseif(isset($ItemFLG['progress_comment_display_status4']) && $ItemFLG['progress_comment_display_status4'] == 1)
							<tr>
								<td style="background: #e5e5e5;font-weight: bold;">
									<div class="d-flex flex-column">
										<span>{{ __('messages.4th_rater') }}</span>
										<span>{{ $M0200['progress_comment_title'] }}</span>				
									</div>
								</td>
								<td>
									{!! nl2br($list['progress_comment_rater_4']) !!}
									<input type="hidden" class="form-control progress_comment_rater_4" id="progress_comment_rater_4" value="{{$list['progress_comment_rater_4']}}" />
								</td>
							</tr>
							@endif	
						@endif
					</tbody>
				</table>
			</div>
			@endif
		</div>
	</div>
	<div class="row mt-4">
		<div class="col-md-9">
			{{-- 進捗コメント入力 --}}
			{{-- 評価コメント入力 --}}
			<div>
				<p style="margin-bottom: 5px;"><b>{{ __('messages.input_evaluation_comment') }}</b></p>
				<hr style="margin-top: 0;">
			</div>
			<div class="table-responsive">
				<table class="table table-bordered table-hover table-striped" id="table-comment" style="margin-bottom: 10px;">		
					<tbody>
						{{-- 自己評価コメント --}}
						@if(
							isset($M0200['self_assessment_comment_display_typ']) && ($M0200['self_assessment_comment_display_typ'] != 0)
						&&	isset($M0200['evaluation_self_typ']) && ($M0200['evaluation_self_typ'] != 0)
						)
						@if(isset($M0100['evaluation_self_assessment_typ']) && ($M0100['evaluation_self_assessment_typ'] != 0))
						<tr>
							@if(isset($ItemFLG['listItemFLG0']) && ($ItemFLG['listItemFLG0'] != 0))
							<th>{{ __('messages.self_evaluation_comment') }}</th>
							<td style="word-break: break-all">
								@if ($ItemFLG['listItemFLG0'] == 2)
								<span class="num-length">
									<textarea class="form-control" id="evaluation_comment_0"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_0']}}">{{$comment['evaluation_comment_0']}}</textarea>
								</span>
								@else
									{!! nl2br($comment['evaluation_comment_0']) ?? '' !!}
									<textarea class="form-control hidden" id="evaluation_comment_0"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_0']}}">{{$comment['evaluation_comment_0']}}</textarea>
								@endif
							</td>
							@endif
						</tr>
						@endif
						@endif
						{{-- 評価コメント --}}
						@if(isset($M0200['evaluation_comment_display_typ']) && ($M0200['evaluation_comment_display_typ'] != 0))
							{{-- 一次評価コメント --}}
							@if(isset($M0100['evaluation_typ_1']) && ($M0100['evaluation_typ_1'] != 0))
							<tr>
								@if(isset($ItemFLG['evaluation_comment_1_flg']) && ($ItemFLG['evaluation_comment_1_flg'] != 0))
								<th>{{ __('messages.1st_eval_comment') }}</th>
								<td style="word-break: break-all">
									@if ($ItemFLG['evaluation_comment_1_flg'] == 2)
									<span class="num-length">
										<textarea  class="form-control" id="evaluation_comment_1"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_1']}}">{{$comment['evaluation_comment_1']}}</textarea>
									</span>
									@else
										{!! nl2br($comment['evaluation_comment_1']) ?? '' !!}
										<textarea  class="form-control hidden" id="evaluation_comment_1"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_1']}}">{{$comment['evaluation_comment_1']}}</textarea>
									@endif
								</td>
								@endif
							</tr>
							@endif
							{{-- 二次評価コメント --}}
							@if(isset($M0100['evaluation_typ_2']) && ($M0100['evaluation_typ_2'] != 0))
							<tr>
								@if(isset($ItemFLG['evaluation_comment_2_flg']) && ($ItemFLG['evaluation_comment_2_flg'] != 0))
								<th>{{ __('messages.2nd_eval_comment') }}</th>
								<td style="word-break: break-all">
									@if ($ItemFLG['evaluation_comment_2_flg'] == 2)
									<span class="num-length">
										<textarea  class="form-control" id="evaluation_comment_2"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_2']}}">{{$comment['evaluation_comment_2']}}</textarea>
									</span>
									@else
										{!! nl2br($comment['evaluation_comment_2']) ?? '' !!}
										<textarea  class="form-control hidden" id="evaluation_comment_2"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_2']}}">{{$comment['evaluation_comment_2']}}</textarea>
									@endif
								</td>
								@endif
							</tr>
							@endif
							{{-- 三次評価コメント --}}
							@if(isset($M0100['evaluation_typ_3']) && ($M0100['evaluation_typ_3'] != 0))
							<tr>
								@if(isset($ItemFLG['evaluation_comment_3_flg']) && ($ItemFLG['evaluation_comment_3_flg'] != 0))
								<th>{{ __('messages.3rd_eval_comment') }}</th>
								<td style="word-break: break-all">
									@if ($ItemFLG['evaluation_comment_3_flg'] == 2)
									<span class="num-length">
										<textarea  class="form-control" id="evaluation_comment_3"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_3']}}">{{$comment['evaluation_comment_3']}}</textarea>
									</span>
									@else
										{!! nl2br($comment['evaluation_comment_3']) ?? '' !!}
										<textarea  class="form-control hidden" id="evaluation_comment_3"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_3']}}">{{$comment['evaluation_comment_3']}}</textarea>
									@endif
								</td>
								@endif
							</tr>
							@endif
							{{-- 四次評価コメント --}}
							@if(isset($M0100['evaluation_typ_4']) && ($M0100['evaluation_typ_4'] != 0))
							<tr>
								@if(isset($ItemFLG['evaluation_comment_4_flg']) && ($ItemFLG['evaluation_comment_4_flg'] != 0))
								<th>{{ __('messages.4th_eval_comment') }}</th>
								<td style="word-break: break-all">
									@if ($ItemFLG['evaluation_comment_4_flg'] == 2)
									<span class="num-length">
										<textarea  class="form-control" id="evaluation_comment_4"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_4']}}">{{$comment['evaluation_comment_4']}}</textarea>
									</span>
									@else
										{!! nl2br($comment['evaluation_comment_4']) ?? '' !!}
										<textarea  class="form-control hidden" id="evaluation_comment_4"  maxlength="1000" rows="3" cols="20" value="{{$comment['evaluation_comment_4']}}">{{$comment['evaluation_comment_4']}}</textarea>
									@endif
								</td>
								@endif
							</tr>
							@endif
						@endif
					</tbody>
				</table>
			</div>
		</div><!-- end .col-md-9 -->
		@if(isset($M0200['point_criteria_display_typ']) && ($M0200['point_criteria_display_typ'] != 0))
		<div class="col-md-3">
			<div class="table-responsive">
				<table class="table table-bordered pull-left table-hover table-striped mb-1">
					<thead>
						<tr>
							<th width="100" class="text-center">{{ __('messages.eval_points') }}</th>
							<th class="text-center">{{ __('messages.eval_standard') }}</th>
						</tr>
					</thead>
					<tbody>
						@if($point)
						@foreach($point as $row)
						<tr>
							<td class="th1 text-right">{{$row['point_nm']}}</td>
							<td class="th1">{{$row['point_criteria']}}</td>
						</tr>
						@endforeach
        				@else
        	    		<tr class="tr-nodata">
        	    		    <td colspan="2" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
        	    		</tr>
        	    		@endif
					</tbody>
				</table>
			</div><!-- end .table-responsive -->
		</div><!-- end .col-md-3 -->
		@endif
	</div><!-- end .row -->
</div> <!-- end .container-fluid -->
</div>
@stop