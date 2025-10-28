@extends('slayout')
@section('asset_header')
	{!!public_url('template/css/basicsetting/m0100/m0100.index.css')!!}
@stop

@push('asset_button')
{!!
Helper::buttonRender(['saveButton','backButton'])
!!}
@endpush

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/common/jquery.autonumeric.min.js')!!}
{!!public_url('template/js/basicsetting/m0100/m0100.index.js')!!}
<script>
	var _language_name = {!! json_encode($row5) !!}
</script>
@stop

@section('content')
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-12 col-xs-12" style="overflow: hidden">
					<div class="row">
						<div class="col-md-12">
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										@if($item_start_evaluation == 1)
										<div class="line-border-bottom">
											<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.evaluation_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date" class="form-control text-center mmdd tab-focus required input_border_radius" style="padding-right:12px"  placeholder="mm/dd" value="{{isset($rows['beginning_date'])?$rows['beginning_date']:''}}" maxlength="5" tabindex="1">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full"value="{{isset($rows['beginning_date_full'])?$rows['beginning_date_full']:''}}">
										</div>
										@else
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.evaluation_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date" class="form-control text-center mmdd tab-focus input_border_radius" style="padding-right:12px" disabled="disabled" placeholder="mm/dd" value="" maxlength="5" tabindex="1">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full"value="">
										</div>
										@endif
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
							</div><!-- end .row -->
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										@if($item_start_1on1 == 1)
										<div class="line-border-bottom">
											<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.1on1_year_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date_1on1" class="form-control text-center mmdd tab-focus required input_border_radius" style="padding-right:12px" placeholder="mm/dd" value="{{isset($rows['beginning_date_1on1'])?$rows['beginning_date_1on1']:''}}" maxlength="5" tabindex="2">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full_1on1"value="{{isset($rows['beginning_date_full_1on1'])?$rows['beginning_date_full_1on1']:''}}">
										</div>
										@else
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.1on1_year_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date_1on1" class="form-control text-center mmdd tab-focus input_border_radius" style="padding-right:12px" disabled="disabled"  placeholder="mm/dd" value="" maxlength="5" tabindex="2">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full_1on1"value="">
										</div>
										@endif
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
							</div><!-- end .row -->
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										@if($item_start_report == 1)
										<div class="line-border-bottom">
											<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.weekly_report_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date_report" class="form-control text-center mmdd tab-focus required input_border_radius" style="padding-right:12px" placeholder="mm/dd" value="{{isset($rows['beginning_date_report'])?$rows['beginning_date_report']:''}}" maxlength="5" tabindex="2">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full_report"value="{{isset($rows['beginning_date_full_report'])?$rows['beginning_date_full_report']:''}}">
										</div>
										@else
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.weekly_report_start_date') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 120px">
											<input type="text" id="beginning_date_report" class="form-control text-center mmdd tab-focus input_border_radius" disabled="disabled" style="padding-right:12px" placeholder="mm/dd" value="" maxlength="5" tabindex="2">
											<input type="hidden" class="yyyymmdd" id="beginning_date_full_report"value="">
										</div>
										@endif
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
							</div><!-- end .row -->
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.employee_info_function_menu') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 150px">
										<select name="empinf_user_typ"  class="form-control" id="empinf_user_typ" tabindex="3">
											@if(isset($row3))
											@foreach($row3 as $row)
												<option value="{{$row['number_cd']}}" {{ isset($rows['empinf_user_typ'])&&($rows['empinf_user_typ']==1)?'selected':''}}>{{$row['name']}}</option>
											@endforeach
											@endif
										</select>
										</div>
										<div class="row-group mt-20">
											<div class="input-group-row">
												<div id="checkbox-1" class="md-checkbox-v2 inline-block">
													<input name="empsrch_user_typ" {{ isset($rows['empsrch_user_typ'])&&($rows['empsrch_user_typ']==1)?'checked':''}}  class="check_all  empsrch_user_typ" id="empsrch_user_typ" type="checkbox" tabindex="4">
													<label for="empsrch_user_typ">&nbsp;{{__('messages.viewing_screen_usage')}}</label>
												</div>
											</div>
											<div class="input-group-row" style="padding-left: 18px;">
												<div id="checkbox-2" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
													<label >{{__('messages.default_infor')}}</label>
												</div>
												<div id="checkbox" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
													<input name="checkbox-title-4" class="check_all" id="checkbox-title-4" type="checkbox" checked disabled>
													<label for="checkbox-title-4">{{__('messages.employee_infor')}}</label>
												</div>
												<div id="checkbox" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
													<input name="checkbox-title-5" class="check_all" id="checkbox-title-5" type="checkbox" checked disabled>
													<label for="checkbox-title-5"  class="{{isset ($lang) && $lang == 'jp' ? '' : 'text-overfollow mw-111'}}"
													@if($lang != 'jp')
													data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.affiliation_history_infor')}}"
													@endif
													>{{__('messages.affiliation_history_infor')}}</label>
												</div>
												<div id="checkbox" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
													<input name="checkbox-title-6" class="check_all" id="checkbox-title-6" type="checkbox" checked disabled>
													<label for="checkbox-title-6">{{__('messages.optional_infor')}}</label>
												</div>
											</div>
											<div class="input-group-row row-dis" style="padding-left: 18px;">
												<div id="checkbox-2" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
													<label>{{__('messages.human_resorces_infor_to_manage')}}</label>
												</div>
												@if(isset($items_tab))
													@foreach($items_tab as $k => $item_tab)
														@if($k == 9)
															@break
														@endif
														<div id="key-{{$k}}" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
															<input name="checkbox-tab-{{$item_tab['tab_id']}}" tab_nm="{{$item_tab['tab_nm']}}" tab_id="{{$item_tab['tab_id']}}" {{ isset($item_tab['use_typ'])&&($item_tab['use_typ']==1)?'checked':''}} class="tab_checkbox" id="checkbox-tab-{{$item_tab['tab_id']}}" type="checkbox" value="" tabindex="4">
															<label for="checkbox-tab-{{$item_tab['tab_id']}}" class="control-label label-{{$item_tab['tab_id']}} {{isset ($lang) && $lang == 'jp' ? '' : 'text-overfollow mw-111'}}" 
															@if($lang != 'jp')
															data-container="body" data-toggle="tooltip" data-original-title="{{$item_tab['tab_nm']}}"
															@endif
															>{{$item_tab['tab_nm']}}</label>
														</div>
													@endforeach
												@endif
											</div>
											<div class="input-group-row row-dis" style="padding-left: 18px;">
												<div style="flex: 0 0 10%;padding-left: 6px;"></div>
												@if(isset($items_tab))
													@foreach($items_tab as $k => $item_tab)
														@if($k > 8)
															<div id="" class="md-checkbox-v2 inline-block" style="flex: 0 0 10%;padding-left: 6px;">
																<input name="checkbox-tab-{{$item_tab['tab_id']}}" tab_nm="{{$item_tab['tab_nm']}}" tab_id="{{$item_tab['tab_id']}}" {{ isset($item_tab['use_typ'])&&($item_tab['use_typ']==1)?'checked':''}} class="tab_checkbox" id="checkbox-tab-{{$item_tab['tab_id']}}" type="checkbox" value="" tabindex="4">
																<label for="checkbox-tab-{{$item_tab['tab_id']}}" class="control-label label-{{$item_tab['tab_id']}} {{isset ($lang) && $lang == 'jp' ? '' : 'text-overfollow mw-111'}}" 
																@if($lang != 'jp')
																data-container="body" data-toggle="tooltip" data-original-title="{{$item_tab['tab_nm']}}"
																@endif
																>{{$item_tab['tab_nm']}}</label>
															</div>
														@endif
													@endforeach
												@endif
											</div>
											<div class="input-group-row mt-20">
												<div id="checkbox-2" class="md-checkbox-v2 inline-block">
													<input name="empcom_user_typ" class="check_all empcom_user_typ" {{ isset($rows['empcom_user_typ'])&&($rows['empcom_user_typ']==1)?'checked':''}} id="empcom_user_typ" type="checkbox" tabindex="4">
													<label for="empcom_user_typ" >&nbsp;{{__('messages.use_communication_function')}}</label>
												</div>
											</div>
											<div class="input-group-row row-dis-2">
												<div id="checkbox" class="md-checkbox-v2 inline-block checkbox-scr" style="flex: 0 0 23%;padding-left: 25px;">
													<input name="cert_user_typ" {{ isset($rows['cert_user_typ'])&&($rows['cert_user_typ']==1)?'checked':''}} class="check_all cert_user_typ" id="cert_user_typ" type="checkbox" tabindex="4">
													<label for="cert_user_typ">{{__('messages.show_credentials')}}</label>
												</div>
												<div id="checkbox" class="md-checkbox-v2 inline-block" style="flex: 0 0 40%;">
													<input name="resume_user_typ" {{ isset($rows['resume_user_typ'])&&($rows['resume_user_typ']==1)?'checked':''}}  class="check_all" id="resume_user_typ" type="checkbox" tabindex="4">
													<label for="resume_user_typ">{{__('messages.view_work_history')}}</label>
												</div>
											</div>
										</div>
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
							</div><!-- end .row -->
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.multilingual_options') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 150px">
										<select name=""  class="form-control" id="multilingual_option_use_typ" tabindex="4">
										@if(isset($row3))
										@foreach($row3 as $row)
											<option {{isset($rows['multilingual_option_use_typ']) &&($row['number_cd']== $rows['multilingual_option_use_typ'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
										@endforeach
										@endif
										</select>
										</div>
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
								<div class="row form-group col-md-12">
									<div class="col-md-1" style="max-width:60px">
										<div class="form-group">
											<label
												class="control-labe" style="white-space: nowrap;">{{ __('messages.supported_languages') }}&nbsp;
											</label>
											<div class="full-width">
												<a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue" id="add_row_sm0100"
													tabindex="4">
													+
												</a>
											</div><!-- end .full-width -->
										</div>
									</div>								
									{{--  --}}
									<div class="col-md-11 col-lg-11 col-xl-11" id="add_row" style="display: flex; flex-wrap: wrap">
									@if (isset($row4) && !empty($row4))
									@foreach ($row4 as $r)
									<div class="col-auto">
										<div class="form-group" style="margin-bottom: 0rem !important;">
											<label class="control-label">&nbsp;</label>
											<div class="input-group-btn input-group" style="width: 145px">
												<input type="text" class="form-control language_find" tabindex="4" value ="{{$r['language_name']??''}}" autocomplete="off">
												<input type="hidden" class="language_cd" value="{{$r['language_cd']??''}}">
											</div>
										</div>
									</div>
									@endforeach	
									@else
									<div class="col-auto" >
										<div class="form-group" style="margin-bottom: 0rem !important;">
											<label class="control-label">&nbsp;</label>
											<div class="input-group-btn input-group" style="width: 145px">												
												<input type="text" class="form-control language_find" tabindex="4" value ="" autocomplete="off">
												<input type="hidden" class="language_cd" value="">
											</div>
										</div>
									</div>
									@endif								
								</div>
								</div>
								<div id="template_add_row" style="display: none;">
									<div class="col-auto" >
										<div class="form-group" style="margin-bottom: 0rem !important;">
											<label class="control-label">&nbsp;</label>
											<div class="input-group-btn input-group" style="width: 145px">
												<input type="text" class="form-control language_find" tabindex="4" value ="" autocomplete="off">
												<input type="hidden" class="language_cd" value="">
											</div>
										</div>
									</div>
								</div>
							</div><!-- end .row -->
							<div class="row">
								<div class="col-md-12" >
									<div class="form-group">
										<div class="line-border-bottom">
											<label class="control-label">{{ __('messages.use_my_purpose') }}</label>
										</div>
										<div class="input-group-btn input-group" style="width: 150px">
										<select name=""  class="form-control" id="mypurpose_use_typ" tabindex="4">
										@if(isset($row3))
										@foreach($row3 as $row)
											<option {{isset($rows['mypurpose_use_typ']) &&($row['number_cd']== $rows['mypurpose_use_typ'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
										@endforeach
										@endif
									</select>
										</div>
									</div><!-- end .form-group -->
								</div><!-- end .col-md-3 -->
							</div><!-- end .row -->
							<div class="line-border-bottom">
								<label class="control-label">{{ __('messages.password_policy') }}</label>
							</div>
							<div class="form-group row ">
								<div class="col-xs-12 col-md-1  float-left" style="min-width: 170px ">
									<label class="control-label" style="padding-left:0px;padding-right:0px ">{{ __('messages.number_of_characters') }}</label>
									<span class="num-length col-md-8" style="padding-left:0px;padding-right:0px;min-width: 150px ">
										<input type="text" class="form-control only-number text-right" maxlength="2" id="password_length" value="{{isset($rows['password_length'])&&$rows['password_length']!=0?$rows['password_length']:''}}"  tabindex="5"/>
									</span>
								</div>
								<div class="col-xs-12 col-md-1  float-left" style = "min-width: 100px;max-width: 100px;">
									<label class="control-label">&nbsp;</label>
									<span class="num-length">
										<div class="input-group-btn btn-left" style="line-height: 36px;">
										{{ __('messages.or_more') }}
										</div>
									</span>
								</div>						

								<div class="form-group col-xs-12 col-md-3 p0" style="padding-left:10px;padding-right:10px;min-width: 300px;">
									<label class="control-label">{{ __('messages.character_limit') }}</label>
									<select name=""  class="form-control" id="password_character_limit" tabindex="5">
										@if(isset($row2))
										@foreach($row2 as $row)
											<option {{isset($rows['password_character_limit']) &&($row['number_cd']== $rows['password_character_limit'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
										@endforeach
										@endif
									</select>
								</div>

								<div class="col-xs-12 col-md-1  float-left" style="min-width: 120px ">
									<label class="control-label">{{ __('messages.valid_period') }}</label>
									<span class="num-length">
										<input type="text" class="form-control only-number text-right" maxlength="2" id="password_age" value="{{isset($rows['password_age'])&&$rows['password_age']!=0?$rows['password_age']:''}}" tabindex="5"/>
									</span>
								</div>
								<div class="col-xs-12 col-md-2  float-left">
									<label class="control-label">&nbsp;</label>
									<span class="num-length">
										<div class="input-group-btn btn-left" style="line-height: 36px;">
										{{ __('messages.months') }}
										</div>
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
							<input type="text" class="form-control input-sm period_nm" maxlength="5" tabindex="6">
						</span>
					</td>
					<td class="text-center">
						<div class="gflex">
							<div class="input-group-btn input-group" style="width: 120px">
								<input type="text" class="form-control text-center  mmdd mmdd_from" placeholder="mm/dd" tabindex="6">
								<input type="hidden" class="yyyymmdd period_from_full">
							</div>
						</div><!-- end .gflex -->
					</td>
					<td class="text-center">
						<div class="gflex">
							<div class="input-group-btn input-group" style="width: 120px">
								<input type="text" class="form-control text-center  mmdd mmdd_to" placeholder="mm/dd" tabindex="6">
								<input type="hidden" class="yyyymmdd period_to_full">
							</div>
						</div><!-- end .gflex -->
					</td>
					<td class="text-center">
						<button class="btn btn-rm btn-sm btn-remove-row" tabindex="6">
							<i class="fa fa-remove"></i>
						</button>
					</td>
				</tr>
			</tbody>
		</table><!-- /.hidden -->
		@stop
@stop