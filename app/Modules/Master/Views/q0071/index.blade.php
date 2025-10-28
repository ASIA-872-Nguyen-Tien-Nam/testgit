@extends('layout')
@section('asset_header')
<!-- START LIBRARY CSS -->

{!!public_url('template/css/form/q0071.index.css')!!}

@stop
@section('asset_footer')
{!!public_url('template/js/form/q0071.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
    Helper::buttonRender(['backButton'])
!!}
@endpush
@section('content')
<!-- START CONTENT -->
<input type="hidden" id="from" value="{{$from ?? ''}}" />
<input type="hidden" id="from_source" value="{{$from_source ?? ''}}" />
	<div class="container-fluid">
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-md-3 col-sm-12 col-12 col-lg-3 col-xl-2">
						<div class="table-responsive ln-name">
							<table class="table table_avatar">
								<tbody>
									<tr>
										<td>
											@if(isset($data[0][0]['picture']) && $data[0][0]['picture'] != '')
											<div class="avatar">
												<div class="img">
													<div class="d-flex flex-box {{(!isset($data[0][0]['picture']) || $data[0][0]['picture'] == '')?"flex-box-image":""}}">
														@if(!isset($data[0][0]['picture']) || $data[0][0]['picture'] == '')
														<p class="w100">{{__('messages.photo')}}</p>
														<img id="img-upload" class="thumb" />
														@else
														<img id="img-upload" class="thumb imgs" src="{{$data[0][0]['picture']}}?v={{time()}}" />
														@endif
													</div>
												</div>
											</div>
											@else
											<div class="avatar">
												<div class="img">
													<div class="d-flex flex-box portrait">
														<p class="w100">{{__('messages.photo')}}</p>
														<img id="img-upload" class="thumb" />
													</div>
												</div>
											</div>
											@endif
											<div class="text-center text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$data[0][0]['employee_nm'] ?? ''}}" id="employee_nm">{{$data[0][0]['employee_nm'] ?? ''}}</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="col-md-9 col-sm-12 col-12 col-lg-9 col-xl-10" >
						<div class="table-responsive ln-table">
							<table id="tb-top" class="tbl-header" language="{{__('messages.language')}}">
								<thead>
									<tr style="height:50px;">
										
									</tr>
								</thead>
								<tbody>
								<tr>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.employee_no')}}">{{__('messages.employee_no')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div id="employee_cd" class="text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{ (isset($data[0][0])?$data[0][0]['employee_cd']:'') }}">
															{{ (isset($data[0][0])?$data[0][0]['employee_cd']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.employee_name')}}">{{__('messages.employee_name')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div class="text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{ (isset($data[0][0])?$data[0][0]['employee_nm']:'') }}">
															{{ (isset($data[0][0])?$data[0][0]['employee_nm']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>

										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl  ln-text text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.employee_classification')}}">{{__('messages.employee_classification')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div class="text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{ (isset($data[0][0])?$data[0][0]['employee_typ_nm']:'') }}">
															{{ (isset($data[0][0])?$data[0][0]['employee_typ_nm']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.job')}}">{{__('messages.job')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div class="text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{ (isset($data[0][0])?$data[0][0]['job_nm']:'') }}">
														{{ (isset($data[0][0])?$data[0][0]['job_nm']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.position')}}">{{__('messages.position')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ (isset($data[0][0])?$data[0][0]['position_nm']:'') }}">
															{{ (isset($data[0][0])?$data[0][0]['position_nm']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>
										<td>
											<div class="form-inline finline">
												<div class="form-group">
													<label class="form-control-plaintext lbl text-overfollow ln-text" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.grade')}}">{{__('messages.grade')}}</label>
												</div>
												<div class="form-group">
													<label class="form-control-plaintext txt">
														<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ (isset($data[0][0])?$data[0][0]['grade_nm']:'') }}">
														{{ (isset($data[0][0])?$data[0][0]['grade_nm']:'') }}
														</div>
													</label>
												</div>
											</div>
										</td>
									</tr>
									<tr class="ln-tr-text">
										@foreach($organization_group as $dt)
											<td>
												<div class="form-inline finline">
													<div class="form-group">
														<label class="form-control-plaintext lbl text-overfollow ln-org" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}">{{$dt['organization_group_nm']}}</label>
													</div>
													@if(isset($data[0][0]))
														<div class="form-group">
															<label class="form-control-plaintext txt">
																<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$data[0][0]['belong_cd'.$dt['organization_typ'].'_nm']}}">
																	{{$data[0][0]['belong_cd'.$dt['organization_typ'].'_nm']}}
																</div>
															</label>
														</div>
													@endif
												</div>
											</td>
										@endforeach
									</tr>
									<tr>
									</tr>
								</tbody>
							</table>
						</div>

					</div>
				</div>
				<p></p>
				<div class=" line-border-bottom">
					<label class="control-label">{{__('messages.transfer_history_info')}}
					</label>
				</div>
				{{--<div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells" style="max-height: 30vh;">
					<table id="tb-middle" class="table table-bordered table-hover table-striped fixed-header" >--}}
				@php
					$count_organization_cd = $data[6][0]['count_organizaion_cd'];
					if($count_organization_cd < count($data['organization_group'])){
						$count_organization_cd = count($data['organization_group']);
					}
				@endphp
				<div id="tbl1 " class="table-responsive mg_bottom">
					<table class="table table-bordered table-hover table-striped fixed-header">
						<thead>
						<tr>
							<th class="minw150 ">{{__('messages.application_date')}}</th>
							<th class="minw150 ">{{__('messages.office')}}</th>
							@for ($i = 0; $i < $count_organization_cd; $i++)
		                        <th class="w-detail-col7 minw150 ">
								<div class="text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{$data[5][$i]['organization_group_nm']??'組織'.($i+1)}}" style="width: 150px">
									{{$data[5][$i]['organization_group_nm']??'組織'.($i+1)}}
								</div><!-- end .text-overfollow -->
		                        </th>
		                    @endfor
							<th class="minw150 ">{{__('messages.position')}}</th>
							<th class="minw150 ">{{__('messages.job')}}</th>
							<th class="minw150 text-overfollow" data-container="body" data-toggle="tooltip"  data-original-title="{{__('messages.employee_classification')}}">{{__('messages.employee_classification')}}</th>
							<th class="w-detail-col10">{{__('messages.grade')}}</th>
						</tr>
						</thead>
						<tbody>
							@if(isset($data[1][0]))
								@foreach($data[1] as $row)
									<tr>
										<td class="w-120px text-center">
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['application_date']}}">
												{{$row['application_date']}}
											</div>
										</td>
										<td class="w-120px">
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['office_nm']}}">
												{{$row['office_nm']}}
											</div>
										</td>
										@for ($i = 1; $i <= $count_organization_cd; $i++)
										<td class="w-120px">
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['belong_cd'.$i.'_nm']??''}}">
												{{ $row['belong_cd'.$i.'_nm']??''}}
											</div>
										</td>
				                        @endfor
										<td class="w-120px">
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['position_nm']}}">
												{{$row['position_nm']}}
											</div>
										</td>
										<td class="w-120px">
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['job_nm']}}">
												{{$row['job_nm']}}
											</div>
										</td>
										<td class="w-120px">
							
											<div class="text-overfollow setTooltip w_div"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['employee_typ_nm']}}">
												{{$row['employee_typ_nm']}}
											</div>
										</td>
										<td class="">
											<div class="text-overfollow setTooltip"
												 data-container="body" data-toggle="tooltip"
												 data-original-title="{{$row['grade_nm']}}">
												{{$row['grade_nm']}}
											</div>
										</td>
									</tr>
								@endforeach
							@else
								<tr class="text-center">
									<td colspan="8">{{ $_text[21]['message'] }}</td>
								</tr>
							@endif
						</tbody>
					</table>
				</div>
				{{--check feedback_use_typ--}}
				@if(isset($data[4][0]) && $data[4][0]['feedback_use_typ'] ==1)
				<div class=" line-border-bottom">
					<label class="control-label">{{__('messages.eval_history_info')}}
					</label>
				</div>
				<div class="col-xs-12 col-md-12 col-lg-12 p0">
					<div class="table-responsive table-fixed-header2" style="max-height: 30vh;">
						<table class="table table-bordered table-hover table-striped fixed-header" style="overflow-y: scroll">
							<thead>
								<tr>
									<th class="w-80px">{{__('messages.fiscal_year')}}</th>
									<th class="w-160px">{{__('messages.treatment_use')}}</th>
									<th class="w-120px">{{__('messages.rank')}}</th>
									@if(isset($data[3][0]))
									@for($i = 1; $i <= $data[3][0]['sheet_num']; $i++)
									<th class="">{{__('messages.eval_element')}}{{$i}}</th>
									{{-- <th class="w-120px">評価点</th> --}}
									@endfor
									@endif
								</tr>
							</thead>
							<tbody>
								@if(isset($data[2][0]) && isset($data[2][0]['fiscal_year']))
									@foreach($data[2] as $row)
										<tr>
											<td class="w-80px text-center">
												<label class="form-control-plaintext txt">
													<div class="text-overfollow fiscal_year"
														 data-container="body" data-toggle="tooltip"
														 data-original-title="{{$row['fiscal_year']}}">
													{{$row['fiscal_year']}}
													</div>
												</label>
											</td>
											<td class="w-160px text-center">
												<label class="form-control-plaintext txt">
													<div class="text-overfollow"
														 data-container="body" data-toggle="tooltip"
													 data-original-title="{{$row['treatment_applications_nm']}}">
													{{$row['treatment_applications_nm']}}
													</div>
												</label>
											</td>
											<td class="w-120px text-center">
												<label class="form-control-plaintext txt">
													<div class="text-overfollow"
														 data-container="body" data-toggle="tooltip"
													 	data-original-title="{{$row['rank_nm']}}">
													{{$row['rank_nm']}}
												</div>
												</label>
											</td>
											@if(isset($data[3]))
											@for($i = 1; $i <= $data[3][0]['sheet_num'];$i++)
											<?php
												$string_array = json_decode(html_entity_decode($row[$i]), true);
												$point_sum = $string_array['point_sum'] ?? '';
												$sheet_nm  = $string_array['sheet_nm'] ?? '';
												$sheet_cd  = $string_array['sheet_cd'] ?? '';
												$sheet_kbn = $string_array['sheet_kbn'] ?? '';
											?>
											<td class="w-160px">
												<label class="form-control-plaintext txt">
													<div class="text-overfollow"
														 data-container="body" data-toggle="tooltip"
													 	data-original-title="{{$sheet_nm}}">
														@if($sheet_kbn == 1)
															<a href="" class="sheet_cd_link"  data-toggle="i2010" data-sheet_kbn="1" data-sheet_cd = '{{$sheet_cd}}'
															tabindex='-1' >{{$sheet_nm}}</a>
														@else
															<a href="" class="sheet_cd_link" data-toggle="i2020" data-sheet_kbn="2" data-sheet_cd = '{{$sheet_cd}}' tabindex="-1" >{{$sheet_nm}}</a>
														@endif
													</div>
												</label>
											</td>
											{{-- <td class="w-120px text-right">
												<label class="form-control-plaintext txt">
													<div class="text-overfollow"
														 data-container="body" data-toggle="tooltip"
													 	data-original-title="{{$point_sum}}">
													{{$point_sum}}
												</div>
												</label>
											</td> --}}
											@endfor
											@endif
										</tr>
									@endforeach
								@else
									<tr class="text-center">
										<td colspan="7">{{ $_text[21]['message'] }}</td>
									</tr>
								@endif
							</tbody>
						</table>
					</div>
				</div>
				@endif
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<input type="hidden" class="anti_tab" name="">
	</div><!-- end .container-fluid -->
@stop