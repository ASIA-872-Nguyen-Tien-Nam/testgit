@extends('oneonone/layout')

@section('asset_header')
    {!!public_url('template/css/oneonone/oi2010/oi2010.css')!!}
@stop

@section('asset_footer')
    {!!public_url('template/js/oneonone/oi2010/oi2010.index.js')!!}
@stop
@push('asset_button')

@if(isset($screen_mode) && ($screen_mode == 11)&& $permission == 2)
{!!
	Helper::dropdownRender1on1(['temporarySave','startasign','backButton'])
!!}
<!--admin member-->
@elseif (isset($screen_mode) && ($screen_mode == 12)&& $permission == 2 && ($w_1on1_authority_typ == 5 || $w_1on1_authority_typ == 4 || $w_1on1_authority_typ == 3))
{!!
	Helper::dropdownRender1on1(['temporarySave','previousDeregistration','beginasign','excel','backButton'])
!!}	
<!--member-->
@elseif (isset($screen_mode) && ($screen_mode == 12)&& $permission == 2)
{!!
	Helper::dropdownRender1on1(['temporarySave','beginasign','excel','backButton'])
!!}	
@elseif (isset($screen_mode) && ($screen_mode == 22)&& $permission == 2)
{!!
	Helper::dropdownRender1on1(['temporarySave','previousDeregistration','beginasign','excel','backButton'])
!!}	
@elseif (isset($screen_mode) && ($screen_mode == 23) && $over_30_day == 0 && $permission == 2)
{!!
	Helper::dropdownRender1on1(['finishasign','backButton'])
!!}	
@elseif (isset($screen_mode) && ($screen_mode == 22 || $screen_mode == 12) && $permission != 2)
{!!
	Helper::dropdownRender1on1(['excel','backButton'])
!!}	
@else
{!!
	Helper::dropdownRender1on1(['backButton'])
!!}
@endif
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid" id="i2010_body">
	<input type="hidden" id="from" value="{{$screen_from??''}}" />
	<input type="hidden" id="login_employee_cd" value="{{$login_employee_cd??''}}" />
	<input type="hidden" id="screen_mode" value="{{$screen_mode}}" />
	<input type="hidden" id="fiscal_year" value="{{$fiscal_year??0}}" />
	<input type="hidden" id="times" value="{{$times??0}}" />

	<div class="card">
        <div class="card-body">
		    <div class="row">
				<div class="col-md-12 col-12">
					<button type="button" class="btn  button-card notAuto_tabindex" tabindex="-1" ><span><i class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="col-md-3 ">
					<div class="form-group">
						<label class="control-label">{{ __('messages.title') }}</label>
						<div class="control-label text-overfollow " data-toggle="tooltip"
						data-original-title="{{$data_refer['title']??''}}" style="margin-bottom: 0px">
							<input readonly="readonly" type="text" class="form-control"  tabindex="-1" maxlength="20" id="1on1_title" value="{{$data_refer['title']??''}}" />
						</div>
					</div>
					<!--/.form-group -->
				</div>

				<div class="col-md-3 ">
					<div class="form-group">
						<label class="control-label">{{ __('messages.sheet_name') }}</label>
						<input type="hidden" tabindex="-1" id="interview_cd" value="{{$data_refer['interview_cd']??''}}">
						<div class="control-label text-overfollow " data-toggle="tooltip"
						data-original-title="{{$data_refer['interview_nm']??''}}" style="margin-bottom: 0px">
							<input readonly="readonly" type="text" class="form-control"  tabindex="-1" maxlength="20"value="{{$data_refer['interview_nm']??''}}" />
						</div>
					</div>
					<!--/.form-group -->
				</div>

				<div class="col-md-3 ">
					<div class="form-group">
						<label class="control-label">{{ __('messages.coach') }}</label>
						<input type="hidden" tabindex="-1" id="coach_cd" value="{{$data_refer['coach_cd']??''}}">
						<div class="control-label text-overfollow " data-toggle="tooltip"
						data-original-title="{{$data_refer['coach_nm']??''}}" style="margin-bottom: 0px">
							<input readonly="readonly" type="text" class="form-control"  tabindex="-1" maxlength="101" value="{{$data_refer['coach_nm']??''}}" />
						</div>
					</div>
					<!--/.form-group -->
				</div>
				<div class="col-md-3 ">
					<div class="form-group">
						<label class="control-label">{{ __('messages.member') }}</label>
						<input type="hidden" tabindex="-1" id="member_cd" value="{{$data_refer['member_cd']??''}}">
						<div class="control-label text-overfollow " data-toggle="tooltip"
						data-original-title="{{$data_refer['member_nm']??''}}" style="margin-bottom: 0px">
							<input readonly="readonly" type="text" class="form-control"  tabindex="-1" maxlength="101" value="{{$data_refer['member_nm']??''}}" />
						</div>
					</div>
					<!--/.form-group -->
				</div>
				<input type="hidden" class="anti_tab" name="">

				</div>
			<hr>
				<!-- leftcontent -->
			<div class="row leftcontent screen_oi2010">
				<div class="col-lg-2 col-md-3">
					<div class="form-group">
						<label class="lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.1on1_date') }}</label>
						<div class="input-group-btn input-group div_popup_meeting" employee_cd="{{$data_refer['member_cd']??''}}" from="oI2010" fiscal_year="{{$fiscal_year??0}}" times="{{$times??0}}" style="max-width:175px;min-width: 140px;">
							@if(($screen_mode != 12 && $screen_mode != 13 && $screen_mode != 22 && $screen_mode != 23 && $screen_mode != 0) || ($w_1on1_authority_typ == 2 && $screen_mode == 13))
								<input type="text" class="form-control input-sm date right-radius oneonone_schedule_date required" placeholder="yyyy/mm/dd" value="{{$data_refer['oneonone_schedule_date']??''}}" tabindex="1" id="oneonone_schedule_date">
							@else
								<input type="text" class="form-control input-sm date right-radius oneonone_schedule_date required" placeholder="yyyy/mm/dd" value="{{$data_refer['oneonone_schedule_date']??''}}" disabled tabindex="-1" id="oneonone_schedule_date">
							@endif
							<div class="input-group-append-btn ">
								<button class="btn-transparent popup btn_popup_meeting" {{(($screen_mode != 12 && $screen_mode != 13 && $screen_mode != 22 && $screen_mode != 23 && $screen_mode != 0) || ($w_1on1_authority_typ == 2 && $screen_mode == 13))?'':'disabled'}} type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-2 col-md-3">
					<div class="form-group">
						<label class="control-label">{{ __('messages.time_of_day') }}</label>
						<h6 class="time" style="text-align: unset;" >{{$data_refer['time']??''}}</h6>
					</div>
				</div>
				<div class="col-lg-3 col-md-5">
					<div class="form-group">
						<label class="control-label">{{ __('messages.place') }}</label>
						<h6 class="place">{!! !empty($data_refer)?nl2br($data_refer['place']):''!!}</h6>
					</div>
				</div>
				<div class="" style="max-width: 230px;padding-right: 10px;padding-left: 10px;">
					<label class="control-label  remark_name lb-required" lb-required="{{ __('messages.required') }}" style="max-width: 100%" >
						{{$data_refer['remark_name']??''}}
					</label>
				</div>
				<div class="col-lg-2 col-md-7 img-weather">
					<div class="form-group dropdown-weather">
						<div id="fullfillment_type" class="dropdown remark_dropdown" style="width: 100%">
							<table class="table one-table table-dropdown" style="width:90px ;table-layout: fixed;margin-left: auto;margin-bottom: 0px">
								@php
									$mark_cd  = $data_refer['mark_cd']??0;
								@endphp
								<tbody class="table-select">
									<tr>
										<td style="padding: 0px;border-top: none;" class="tr_fullfillment_type">
											<dt>
												{{-- disbaled --}}
												@if ($screen_mode >= 12 || $screen_mode == 0)
												<a tabindex="2" style="width: 90%;" class="disabled readonly_img">
													<span id="span-selected" style="height: 75px;">
														<input type="hidden" class="value_fullfillment_type" value="{{$combo_remark[$mark_cd]['mark_cd']??0}}">
														@if (isset($combo_remark[$mark_cd]['remark1']) && !empty($combo_remark[$mark_cd]['remark1']))
															<img src="/uploads/ver1.7/odashboard/{{$combo_remark[$mark_cd]['remark1']}}" width="100%"/>
														@endif
													</span>
												</a>
												@else
												{{-- enabled --}}
												<a tabindex="2" style="width: 100%">
													<span id="span-selected" style="height: 75px;">
														<input type="hidden" class="value_fullfillment_type" value="{{$combo_remark[$mark_cd]['mark_cd']??0}}">
														@if (isset($combo_remark[$mark_cd]['remark1']) && !empty($combo_remark[$mark_cd]['remark1']))
															<img src="/uploads/ver1.7/odashboard/{{$combo_remark[$mark_cd]['remark1']}}" width="100%"/>
														@endif
													</span>
												</a>
												@endif
											</dt>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="" id="data-select">
						<table class="table one-table table-select table-select-data" style="border: 1px solid #dee2e6;table-layout: fixed;margin-bottom: 0px">
							<tbody style='z-index : 99'>
								@if (isset($combo_remark) && !empty($combo_remark))
									@foreach($combo_remark as $rm)
									<tr class="tr-select">
										<td style="padding: 10px;width: 87px;border-right: 1px solid #dee2e6;">
											<a  title="Select this card" class="select-item image_select">
												<input type="hidden" class="value_fullfillment_type" value="{{$rm['mark_cd']??''}}">
												<img src="/uploads/ver1.7/odashboard/{{$rm['remark1']??''}}" width="100%"/>
											</a>
										</td>
										<td>
											{{$rm['explanation']}}
										</td>
									</tr>
									@endforeach
							 	@endif
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<hr>
				{{-- CR 2022/03/10 vietdt --}}
				{{-- @if($screen_mode ==12)
					<div class="row">
						<!-- add vietdt is 2022/01/17 setting screen m0010 > screen om0200-->
						@if (($year_target_service['target1_use_typ']??0 == 1) && ($data_header['target1_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target1_nm']??''}}">{{$year_target_service['target1_nm']??'WILL'}}</label>
									<span class="num-length">
										<textarea id="target1" type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="" value="{{$data_refer['target1']??''}}" >{{$data_refer['target1']??''}}</textarea>
									</span>
								</div>
							</div>
						@endif
						@if (($year_target_service['target2_use_typ']??0 == 1) && ($data_header['target2_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target2_nm']??''}}">{{$year_target_service['target2_nm']??'CAN'}}</label>
									<span class="num-length">
										<textarea  id="target2" type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="" value="{{$data_refer['target2']??''}}" >{{$data_refer['target2']??''}}</textarea>
									</span>
								</div>
							</div>
						@endif
						@if (($year_target_service['target3_use_typ']??0 == 1) && ($data_header['target3_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target3_nm']??''}}">{{$year_target_service['target3_nm']??'MUST'}}</label>
									<span class="num-length">
										<textarea id="target3" type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="" value="{{$data_refer['target3']??''}}" >{{$data_refer['target3']??''}}</textarea>
									</span>
								</div>
							</div>
						@endif
					</div>
				@else --}}
					<div class="row">
						@if (($year_target_service['target1_use_typ']??0 == 1) && ($data_header['target1_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target1_nm']??''}}">{{$year_target_service['target1_nm']??'WILL'}}</label>
									<textarea id="target1"  class="form-control p_article" disabled>{{$data_refer['target1']??''}}</textarea>
								</div>
							</div>
						@endif
						@if (($year_target_service['target2_use_typ']??0 == 1) && ($data_header['target2_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target2_nm']??''}}">{{$year_target_service['target2_nm']??'CAN'}}</label>
									<textarea id="target2" class="form-control p_article" disabled>{{$data_refer['target2']??''}}</textarea>
								</div>
							</div>
						@endif
						@if (($year_target_service['target3_use_typ']??0 == 1) && ($data_header['target3_use_typ']??0 == 1))
							<div class="col-md-4 col-12">
								<div class="form-group">
									<label class="text-overfollow  control-label label-itemimportant infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['target3_nm']??''}}">{{$year_target_service['target3_nm']??'MUST'}}</label>
									<textarea id="target3" class="form-control p_article" disabled>{{$data_refer['target3']??''}}</textarea>
								</div>
							</div>
						@endif
					</div>
				{{-- @endif --}}
				@if (($year_target_service['comment_use_typ']??0 == 1) && ($data_header['comment_use_typ']??0 == 1))
					<div class="row">
						<div class="col-md-12 col-12">
							<div class="form-group">
								<label class="text-overfollow  control-label label-itemimportant infomation_title"   data-container="body" data-toggle="tooltip" data-original-title="{{$year_target_service['comment_nm']??''}}">{{$year_target_service['comment_nm']??__('messages.expectations_from_coaches_to_member')}}</label>
								<textarea id="comment"  class="form-control p_article" disabled>{{$data_refer['comment']??''}}</textarea>
							</div>
						</div>
					</div>
				@endif
		</div>
	</div>
	<div class="card">
        <div class="card-body">
			<div class="row">
				<div class="col-md-12 col-12">
					<label class="control-label" style="color: dodgerblue !important;font-size: 20px;font-weight: bold;">{{ __('messages.fill_in_before_1on1') }}</label>
					<button type="button" class="btn  button-card notAuto_tabindex" tabindex="-1"><span><i class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
				</div>
			</div>
			<br>

			<div class="row mb-3">
            	<div class="col-md-12">
            	</div>
            	<div class="col-md-12">
            		<div class=" wmd-view table-fixed-header table-data">
						<table class="table table-bordered table-hover fixed-header table-striped one-table">
							<thead>
								<tr class="tr-table">
									<th class="w-120px" style="text-align: left;width:33.33%" >{{$data_header['question_nm']??__('messages.pawn')}}</th>
									<th class="w-120px" style="text-align: left;width:33.33%" >{{$data_header['answer_nm']??__('messages.answer')}}</th>
								</tr>
							</thead>
							<tbody >
								@if (isset($table_question) && !empty($table_question))
									@foreach($table_question as $item)
									<tr class="list_question">
										<td width="33.33%" style="max-width: 130px">
											{{$item['question']??''}}
											<input type="hidden" value="{{$item['interview_gyocd']??''}}" class="interview_gyocd">
										</td>
										<td width="33.33%" style="max-width: 130px">
											@if($screen_mode == 11 )
												<span class="num-length">
													<textarea class="form-control required answer" maxlength="200" tabindex="3" value="{{	$item['answer']	??	''}}">{{	$item['answer']	??	''}}</textarea>
												</span>
											@else
												{!! nl2br($item['answer'] ?? '') !!}
												<input type="hidden" class="hidden answer"  value="{{$item['answer']??''}}" tabindex="-1">
											@endif
										</td>
									</tr>
									@endforeach
								@endif
							</tbody>
						</table>
					</div><!-- end . -->
				</div>
			</div>
			<div class="row mb-3 {{($data_header['free_question_use_typ']??'1') == 0 ?'hidden':''}}">
            	<div class="col-md-12">
            	</div>
            	<div class="col-md-12">
            		<div class=" wmd-view table-fixed-header table-data">
						<table class="table table-bordered table-hover fixed-header table-striped one-table">
							<thead>
								<tr class="tr-table">
									<th class="w-120px" colSpan='2' style="text-align: left;" >{{$data_header['free_question_nm']??__('messages.free_entry_field')}}</th>
								</tr>
							</thead>
							<tbody >
								<tr class="list">
									<td width="100%" style="max-width: 130px;">
										@if($screen_mode == 11 )
											<span class="num-length">
												<input type="text" id="free_question" class="form-control " maxlength="500" value="{{$data_refer['free_question']??''}}" tabindex="4">
											</span>
										@else
											{{$data_refer['free_question']??''}}
											<input type="hidden" id="free_question" class="form-control"  value="{{$data_refer['free_question']??''}}" tabindex="-1">
										@endif
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- end . -->
				</div>
			</div>
			<div class="row justify-content-md-center mb-3">
				@if(isset($screen_mode) && ($screen_mode == 11) && $permission == 2)
					{!!
						Helper::buttonRender1on1(['startasign'])
					!!}
				@endif
			</div>
		</div>
	</div>
	@php
		$is_hidden   = '';
		$class_arrow = 'fa fa-chevron-down';
		$btn_text    = trans('messages.hidden');
		if(isset($screen_mode) && $screen_mode == 11 ){
			$is_hidden   = 'hide-card-common';
			$class_arrow = 'fa fa-chevron-right';
			$btn_text    = 'Show';
		}
	@endphp
	<div class="card {{$is_hidden}}">
        <div class="card-body">
			<div class="row">
				<div class="col-md-12 col-12">
					<label class="control-label" style="color: #92D050 !important;font-size: 20px;font-weight: bold;">{{ __('messages.fill_in_after_1on1') }}</label>
					<button type="button" class="btn  button-card notAuto_tabindex" tabindex="-1"><span><i class="{{$class_arrow}}"></i></span>{{$btn_text}}</button>
				</div>
			</div>
			<br>
			<div class="row mb-3 {{($data_header['member_comment_typ']??'1') == 0 ?'hidden':''}}">
            	<div class="col-md-12">
            	</div>
            	<div class="col-md-12">
            		<div class=" wmd-view table-fixed-header table-data">
						<table class="table table-bordered table-hover fixed-header table-striped one-table">
							<thead>
								<tr class="tr-table">
									<th class="w-120px" style="text-align: left;width:100%" >{{$data_header['member_comment_nm']??__('messages.member_comment')}}</th>
							</thead>
							<tbody >
								<tr class="list">
									<td width="33.33%" style="max-width: 130px;">
										@if($screen_mode == 12)
											<span class="num-length">
												<textarea  id="member_comment" class="form-control" maxlength="400"  tabindex="6">{{$data_refer['member_comment']??''}}</textarea>
											</span>
										@else
											<h7>{!! !empty($data_refer['member_comment']??'')?nl2br($data_refer['member_comment']??''):''!!}</h7>
											<div class="control-label text-overfollow " data-toggle="tooltip"
												data-original-title="{{$data_refer['member_comment']??''}}" style="margin-bottom: 0px">
												<textarea  id="member_comment" class="form-control" hidden maxlength="400" tabindex="-1">{{$data_refer['member_comment']??''}}</textarea>
											</div>
										@endif
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- end . -->
				</div>
			</div>
			{{-- 次回までのアクション（メンバーが記入） --}}
			@if (isset($data_header['next_action_typ']) && $data_header['next_action_typ'] == 1)
			<div class="row mb-3">
            	<div class="col-md-12">
            		<div class=" wmd-view table-fixed-header table-data">
						<table class="table table-bordered table-hover fixed-header table-striped one-table">
							<thead>
								<tr class="tr-table">
									<th class="w-120px" style="text-align: left;width:100%" >{{$data_header['next_action_nm']??__('messages.label_013')}}</th>
							</thead>
							<tbody>
								<tr class="list">
									<td width="33.33%" style="max-width: 130px;">
										@if($screen_mode == 12)
											<span class="num-length">
												<textarea type="textarea" id="next_action" class="form-control " maxlength="400" tabindex="6">{{$data_refer['next_action']??''}}</textarea>
											</span>
										@else
											<h7>{!! !empty($data_refer['next_action']??'')?nl2br($data_refer['next_action']??''):''!!}</h7>
											<div class="control-label text-overfollow " data-toggle="tooltip"
												data-original-title="{{$data_refer['next_action']??''}}" style="margin-bottom: 0px">
												<textarea type="textarea" id="next_action" class="form-control" hidden maxlength="400" tabindex="-1">{{$data_refer['next_action']??''}}</textarea>
											</div>
										@endif
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- end . -->
				</div>
			</div>				
			@endif
			{{-- コーチコメント --}}
			@if (isset($data_header['coach_comment1_typ']) && $data_header['coach_comment1_typ'] == 1)
			<div class="row mb-3">
            	<div class="col-md-12">
            		<div class=" wmd-view table-fixed-header table-data">
						<table class="table table-bordered table-hover fixed-header table-striped one-table">
							<thead>
								<tr class="tr-table">
									<th class="w-120px" style="text-align: left;width:100%" >{{$data_header['coach_comment1_nm']??__('messages.coach_comment')}}</th>
							</thead>
							<tbody >
								<tr class="list">
									<td width="33.33%" style="max-width: 130px;">
										{{-- if coach is 22.coach save before --}}
										{{-- or 4,5.General manager is 12. member save before  --}}
										@if($screen_mode == 22 || ($screen_mode == 12 && ($w_1on1_authority_typ == 5 || $w_1on1_authority_typ == 4)))
											<span class="num-length">
												<textarea type="textarea" id="coach_comment1" class="form-control " maxlength="400" value="{{$data_refer['coach_comment1']??''}}" tabindex="6">{{$data_refer['coach_comment1']??''}}</textarea>
											</span>
										@else
											<h7>{!! !empty($data_refer['coach_comment1']??'')?nl2br($data_refer['coach_comment1']??''):''!!}</h7>
											<div class="control-label text-overfollow " data-toggle="tooltip"
												data-original-title="{{$data_refer['coach_comment1']??''}}" style="margin-bottom: 0px">
												<textarea type="textarea" id="coach_comment1" class="form-control " hidden maxlength="400" value="{{$data_refer['coach_comment1']??''}}" tabindex="-1">{{$data_refer['coach_comment1']??''}}</textarea>
											</div>
										@endif
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- end . -->
				</div>
			</div>
			@endif
		
			{{-- コーチコメント(人事部門のみ閲覧可) --}}
			{{-- check coach & authority_typ = 4,5 then show --}}
			@if(isset($coach_comment2_typ) && $coach_comment2_typ == 1)
				{{-- check master M2200.coach_comment2_typ = 1 then show --}}
				@if (isset($data_header['coach_comment2_typ']) && $data_header['coach_comment2_typ'] == 1)
				<div class="row mb-3">
					<div class="col-md-12">
						<div class=" wmd-view table-fixed-header table-data">
							<table class="table table-bordered table-hover fixed-header table-striped one-table">
								<thead>
									<tr class="tr-table">
										<th class="w-120px admin_comment" style="text-align: left;width:100%;" >
											<div style="margin-top: 6px;">
												{{$data_header['coach_comment2_nm']??__('messages.label_012')}}
											</div>
											<div class="input-group-btn input-group" style="border-radius: .25rem;margin-left: 10px;width: 137px;">
												<div class="form-group text-right" style="background-color: white;">
													<div class="full-width">
														<a href="javascript:;" id="btn_popup_search_employee" class="btn btn-outline-primary" tabindex="14" style="padding-right: 10px;">
															<i class="fa fa-search"></i>
															{{ __('messages.administrator_list') }}
														</a>
													</div><!-- end .full-width -->
												</div>
											</div>
										</th>
								</thead>
								<tbody >
									{{-- if coach is 22.coach save before --}}
									{{-- or 4,5.General manager is 12. member save before  --}}
									@if ($screen_mode == 22 || ($screen_mode == 12 && ($w_1on1_authority_typ == 5 || $w_1on1_authority_typ == 4)))
										<tr style="background-color: white;">
											<td class="text-center">
												<select class="form-control select-class " id="combo_coach_comment2" save_value = "0" tabindex="6">
													<option value="">{{ __('messages.please_select') }}</option>
													@if (isset($combo_coach_comment2) && !empty($combo_coach_comment2))
														@foreach($combo_coach_comment2 as $temp)
															<option value="{{$temp['name']}}">{{$temp['name']}}</option>
														@endforeach
													@endif
												</select>
											</td>
										</tr>
									@endif
									<tr class="list">
										<td width="33.33%" style="max-width: 130px;">
											@if($screen_mode == 22 || ($screen_mode == 12 && ($w_1on1_authority_typ == 5 || $w_1on1_authority_typ == 4)))
												<span class="num-length">
													<textarea type="textarea" id="coach_comment2" placeholder="{{ __('messages.label_016') }}" class="form-control " maxlength="400" value="{{$data_refer['coach_comment2']??''}}" tabindex="6">{{$data_refer['coach_comment2']??''}}</textarea>
												</span>
											@else
												<h7>{!! !empty($data_refer['coach_comment2']??'')?nl2br($data_refer['coach_comment2']??''):''!!}</h7>
												<div class="control-label text-overfollow " data-toggle="tooltip"
													data-original-title="{{$data_refer['coach_comment2']??''}}" style="margin-bottom: 0px">
													<textarea type="textarea" id="coach_comment2" class="form-control" hidden maxlength="400" value="{{$data_refer['coach_comment2']??''}}" tabindex="-1">{{$data_refer['coach_comment2']??''}}</textarea>
												</div>
											@endif
										</td>
									</tr>
								</tbody>
							</table>
						</div><!-- end . -->
					</div>
				</div>
				@endif
			@endif

			<div class="row justify-content-md-center mb-3">
				@if(isset($screen_mode) && ($screen_mode == 22||$screen_mode == 12) && $permission == 2)
					{!!
						Helper::buttonRender1on1([ 'beginasign'])
					!!}
				@endif
				@if(isset($screen_mode) && $screen_mode == 23 & $over_30_day == 0 && $permission == 2)
					{!!
						Helper::buttonRender1on1(['finishasign'])
					!!}
				@endif
			</div>
		</div>
	</div>

</div>
@stop