@extends('layout')
@section('asset_header')
<!-- START LIBRARY CSS -->
{!! public_url('template/css/common/master.css') !!}
{!!public_url('template/css/form/i2030.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/form/i2030.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
Helper::buttonRender(['saveButton','backButton'],[],$data2)
!!}
@endpush
@section('content')
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<input type="hidden" class="anti_comon" name="">
			<div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells _width" style="max-height: 78vh;margin-bottom: 2vh">
				<table class="table table-bordered table-hover table-striped fixed-header" id="table-data" style="margin-bottom: 1vh">
					<thead>
						<tr>
							<th style="width: 150px">{{ __('messages.interview_name') }}</th>
							<th style="width: 150px">{{ __('messages.interview_implementation_date') }}</th>
							<th>{{ __('messages.self_comment') }}</th>
							<th>{{ __('messages.1st_rater_s_comment') }}</th>
							@if (isset($hidden['rater_interview_use_typ']) && $hidden['rater_interview_use_typ'] == 1)
								@if (isset($hidden['rater_employee_cd_2']) && $hidden['rater_employee_cd_2'] != '')
								<th>{{ __('messages.2st_rater_s_comment') }}</th>								
								@endif
								@if (isset($hidden['rater_employee_cd_3']) && $hidden['rater_employee_cd_3'] != '')
								<th>{{ __('messages.3st_rater_s_comment') }}</th>								
								@endif
								@if (isset($hidden['rater_employee_cd_4']) && $hidden['rater_employee_cd_4'] != '')
								<th>{{ __('messages.4st_rater_s_comment') }}</th>								
								@endif
							@endif
						</tr>
					</thead>
					<tbody>
						@if($list)
						@foreach($list as $row)
						<tr class="tr_status">
							<td class="text-left">
								{{$row['status_nm']}}
								<input type="hidden" value="{{$row['status_nm']}}" class="status_nm">
								<input type="hidden" value="{{$row['interview_no']}}" class="interview_no">
								<input type="hidden" value="{{$row['period_detail_no']}}" class="period_detail_no">
								<input type="hidden" value="{{$row['sheet_cd']}}" class="sheet_cd">
							</td>
							@if($row['interview_date_status'] == 1)
							<td>
								<div class="gflex">
									<div class="input-group-btn input-group" style="width: 160px">
										<!-- 1.期首面談 ＆　12.フィードバック面談-->
										@if($row['status_cd'] == 1 || $row['status_cd'] == 12)
										<input type="text" class="form-control input-sm date right-radius interview_date required begin_fb_interview" placeholder="yyyy/mm/dd" maxlength="10" value="{{$row['interview_date']}}" tabindex="1">
										@elseif($row['interview_comment_self'] != '' || $row['interview_comment_rater'] != '')
										<input type="text" class="form-control input-sm date right-radius interview_date required" placeholder="yyyy/mm/dd" maxlength="10" value="{{$row['interview_date']}}" tabindex="1">
										@else
										<input type="text" class="form-control input-sm date right-radius interview_date" placeholder="yyyy/mm/dd" maxlength="10" value="{{$row['interview_date']}}" tabindex="1">
										@endif									
										<div class="input-group-append-btn">
											<button class="btn btn-transparent" type="button" data-dtp="dtp_nVZRc" tabindex="-1" style="background-color: unset !important;"><i class="fa fa-calendar"></i></button>
										</div>
									</div>
								</div>
							</td>
							@else
							<td class="text-center">
								{{$row['interview_date']}}
								<input type="hidden" class="interview_date" value="{{$row['interview_date']}}" tabindex="1">
							</td>
							@endif
							{{-- 本人コメント --}}
							<td>
								<!-- 1.被評価者 + 3.管理者-->
								@if($row['interview_comment_self_status'] == 1)
								<span class="num-length span_comment">
									<textarea class="form-control interview_comment_self" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_self']}}" tabindex="1">{{$row['interview_comment_self']}}</textarea>
								</span>
								@else
								<textarea disabled class="form-control interview_comment_self " maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_self']}}" tabindex="1">{{$row['interview_comment_self']}}</textarea>
								@endif
							</td>
							{{-- 一次評価者コメント --}}
							<td>
								<!-- 1.一次評価者 + 3.管理者-->
								@if($row['interview_comment_rater_status'] == 1)
								<span class="num-length span_comment">
									<textarea class="form-control interview_comment_rater" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater']}}" tabindex="1">{{$row['interview_comment_rater']}}</textarea>
								</span>
								@else
								<textarea disabled class="form-control interview_comment_rater " maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater']}}" tabindex="1">{{$row['interview_comment_rater']}}</textarea>
								@endif
							</td>
							{{-- when use 二次評価者以降の評価者も面談記録の入力を可能とする --}}
							@if (isset($hidden['rater_interview_use_typ']) && $hidden['rater_interview_use_typ'] == 1)
							{{-- 二次評価者コメント --}}
							@if (isset($hidden['rater_employee_cd_2']) && $hidden['rater_employee_cd_2'] != '')
							<td>
								<!-- 1.一次評価者 + 3.管理者-->
								@if($row['interview_comment_rater_status2'] == 1)
								<span class="num-length span_comment">
									<textarea class="form-control interview_comment_rater2" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater2']}}" tabindex="1">{{$row['interview_comment_rater2']}}</textarea>
								</span>
								@else
								<textarea disabled class="form-control interview_comment_rater2" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater2']}}" tabindex="1">{{$row['interview_comment_rater2']}}</textarea>
								@endif
							</td>
							@endif
							{{-- 三次評価者コメント --}}
							@if (isset($hidden['rater_employee_cd_3']) && $hidden['rater_employee_cd_3'] != '')
							<td>
								<!-- 1.一次評価者 + 3.管理者-->
								@if($row['interview_comment_rater_status3'] == 1)
								<span class="num-length span_comment">
									<textarea class="form-control interview_comment_rater3" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater3']}}" tabindex="1">{{$row['interview_comment_rater3']}}</textarea>
								</span>
								@else
								<textarea disabled class="form-control interview_comment_rater3" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater3']}}" tabindex="1">{{$row['interview_comment_rater3']}}</textarea>
								@endif
							</td>
							@endif
							{{-- 四次評価者コメント --}}
							@if (isset($hidden['rater_employee_cd_4']) && $hidden['rater_employee_cd_4'] != '')
							<td>
								<!-- 1.一次評価者 + 3.管理者-->
								@if($row['interview_comment_rater_status4'] == 1)
								<span class="num-length span_comment">
									<textarea class="form-control interview_comment_rater4" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater4']}}" tabindex="1">{{$row['interview_comment_rater4']}}</textarea>
								</span>
								@else
								<textarea disabled class="form-control interview_comment_rater4" maxlength="1000" rows="3" cols="20" value="{{$row['interview_comment_rater4']}}" tabindex="1">{{$row['interview_comment_rater4']}}</textarea>
								@endif
							</td>
							@endif
							@endif
						</tr>
						@endforeach
						@else
						<tr class="tr-nodata">
							<td colspan="4" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
						</tr>
						@endif
					</tbody>
				</table>
			</div><!-- end .table-responsive -->
		</div><!-- end .card-body -->
		<input type="hidden" id="employee_cd" value="{{$hidden['employee_cd']??''}}">
		<input type="hidden" id="evaluation_step" value="{{$hidden['evaluation_step']??'0'}}">
		<input type="hidden" id="fiscal_year" value="{{$hidden['fiscal_year']??'0'}}">
		<input type="hidden" id="status_cd" value="{{$hidden['status_cd']??'0'}}">
		<input type="hidden" id="sheet_cd" value="{{$sheet_cd ?? '0'}}">
		<input type="hidden" id="from" value="{{$from??''}}">
		<input type="hidden" id="from_source" value="{{$from_source??''}}">
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
@stop