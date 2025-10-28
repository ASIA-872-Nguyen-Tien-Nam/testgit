@extends('layout')
@section('asset_header')
		<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/m0190.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/form/m0190.index.js')!!}
		<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
Helper::buttonRender(['saveButton', 'backButton'])
!!}
@endpush
@section('content')
		<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-7 ">
				<input type="hidden" class="anti_tab" name="">
					<div class="table-responsive">
						<table class="table table-bordered table-hover table-striped" id="table-data">
							<thead>
								<tr>
									<th class="minw100">{{__('messages.classification')}}</th>
									<th class="">{{__('messages.current_stage')}}</th>
									<th class="">{{__('messages.name_title')}}</th>
								</tr>
							</thead>
							<tbody>
								@foreach($data0 as $row)
								<tr class="function_list">
									@if($row['row_num'] == 1)
										<td rowspan="{{count($data0)}}" class="back-fff" style="vertical-align:top">{{$library10[$row['category']-1]['name']}}</td>
									@endif
									<td>
										{{$row['status_nm']}}
										<input type="hidden" class="status_cd" value="{{$row['status_cd']}}">
										<input type="hidden" class="category" value="{{$row['category']}}">
									</td>
									<td>
										<span class="num-length">
											@if($row['disabled_status'] == 1)
												<input type="text" readonly="readonly" tabindex="-1" class="form-control status_nm" maxlength="50" value="{{$row['status_nm_item']}}">
											@else
												<input type="text" class="form-control status_nm" tabindex="1" maxlength="50" value="{{$row['status_nm_item']}}">
											@endif
										</span>
										<input type="hidden" class="status_use_typ" value="{{$row['status_use_typ']}}">
									</td>
								</tr>
								@endforeach
								@foreach($data1 as $row)
								<tr class="function_list">
									@if($row['row_num'] == 1)
										<td rowspan="{{count($data1)}}" class="back-fff" style="vertical-align:top">{{$library10[$row['category']-1]['name']}}</td>
									@endif
									<td>
										{{$row['status_nm']}}
										<input type="hidden" class="status_cd" value="{{$row['status_cd']}}">
										<input type="hidden" class="category" value="{{$row['category']}}">
									</td>
									<td>
										<span class="num-length">
											@if($row['disabled_status'] == 1)
												<input type="text" readonly="readonly" tabindex="-1" class="form-control status_nm" maxlength="50" value="{{$row['status_nm_item']}}">
											@else
												<input type="text" class="form-control status_nm" maxlength="50" tabindex="1" value="{{$row['status_nm_item']}}">
											@endif
										</span>
										<input type="hidden" class="status_use_typ" value="{{$row['status_use_typ']}}">
									</td>
								</tr>
								@endforeach
							</tbody>
						</table>
					</div>
				</div>
				<div class="col-md-5">
					<div class="table-responsive">
						<table class="table table-bordered table-hover table-striped" id="table-data">
							<thead>
								<tr>
									<th class="minw100">{{__('messages.interview_stages')}}</th>
									<th class="">{{__('messages.name_title')}}</th>
									<th class="minw100">{{__('messages.implement_1')}}</th>
								</tr>
							</thead>
							<tbody>
								@foreach($data2 as $row)
									<tr class="function_list">
										<td>
											{{$row['status_nm']}}
											<input type="hidden" class="status_cd" value="{{$row['status_cd']}}">
											<input type="hidden" class="category" value="{{$row['category']}}">
										</td>										
										<td>
										   <span class="num-length">
											@if($row['disabled_status'] == 1)
												<input type="text" readonly="readonly" tabindex="-1" class="form-control status_nm" maxlength="50" value="{{$row['status_nm_item']}}">
											@else

												<input type="text" class="form-control status_nm" tabindex="1" maxlength="50" value="{{$row['status_nm_item']}}">
											@endif
											</span>
										</td>
										<td>
											@if($row['status_cd'] == 12)
												<select class="form-control input-sm status_use_typ" tabindex="-1" disabled="disabled">
													@if(isset($library8))
														@foreach($library8 as $temp)
															@if($temp['number_cd'] == $row['status_use_typ'])
																<option value="{{$temp['number_cd']}}" selected="selected">{{$temp['name']}}</option>
															@else
																<option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
															@endif
														@endforeach
													@endif
												</select>
											@elseif($row['disabled_status'] == 1)
												<select class="form-control input-sm status_use_typ" tabindex="-1" disabled="disabled">
													@if(isset($library8))
														@foreach($library8 as $temp)
															@if($temp['number_cd'] == $row['status_use_typ'])
																<option value="{{$temp['number_cd']}}" selected="selected">{{$temp['name']}}</option>
															@else
																<option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
															@endif
														@endforeach
													@endif
												</select>
											@else
												@if(isset($target_management_typ) && $target_management_typ == 1 && $row['status_cd'] == 1)
													<select class="form-control input-sm status_use_typ" tabindex="1" disabled="disabled">
														@if(isset($library8))
															@foreach($library8 as $temp)
																@if($temp['number_cd'] == 1)
																	<option value="{{$temp['number_cd']}}" selected="selected">{{$temp['name']}}</option>
																@else
																	<option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
																@endif
															@endforeach
														@endif
													</select>
												@else
													<select class="form-control input-sm status_use_typ" tabindex="1">
														@if(isset($library8))
															@foreach($library8 as $temp)
																@if($temp['number_cd'] == $row['status_use_typ'])
																	<option value="{{$temp['number_cd']}}" selected="selected">{{$temp['name']}}</option>
																@else
																	<option value="{{$temp['number_cd']}}">{{$temp['name']}}</option>
																@endif
															@endforeach
														@endif
													</select>
												@endif
											@endif	
										</td>
									</tr>	
								@endforeach
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- end .table-responsive -->
		</div>
		<!-- end .card-body -->
	</div>
</div>
<!-- end .container-fluid -->
@stop