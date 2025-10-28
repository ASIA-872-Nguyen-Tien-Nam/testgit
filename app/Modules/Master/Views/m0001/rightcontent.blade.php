<?php
$SSO_use_typ = 1;
if(isset($row1['SSO_use_typ'])&&$row1['SSO_use_typ']!=''){
	$SSO_use_typ = (int)$row1['SSO_use_typ'];
}
?>
<div class="row">
	<div class="col-md-6">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.customer_name')}}</label>
			<span class="num-length">
				<input type="hidden" class="form-control" id="company_cd" value="{{isset($row1['company_cd'])?$row1['company_cd']:''}}">
				<input type="text" class="form-control required" id="company_nm" maxlength="50" tabindex="1" value="{{isset($row1['company_nm'])?$row1['company_nm']:''}}">
			</span>
		</div><!--/.form-group -->
	</div>
	<div class="col-md-3">
		<div class="form-group">
			<label class="control-label">{{__('messages.abbreviation')}}</label>
			<span class="num-length">
				<input type="text" class="form-control" id="company_ab_nm" maxlength="20" tabindex="2" value="{{isset($row1['company_ab_nm'])?$row1['company_ab_nm']:''}}">
			</span>
		</div><!--/.form-group -->
	</div>
</div>
{{-- tạo tab --}}
<ul class="nav nav-tabs tab-style">
	<li class="nav-item " id="">
		<a class="nav-link treatment_applications_no active show" data-toggle="tab" href="#tab1" role="tab" aria-selected="true">
			{{__('messages.basic_information')}}
			<div class="caret"></div>
		</a>
	</li>
	<li class="nav-item " id="">
		<a class="nav-link treatment_applications_no" data-toggle="tab" href="#tab2" role="tab">
			 {{ __('messages.basic_info')}}
			<div class="caret"></div>
		</a>
	</li>
	<li class="nav-item " id="">
		<a class="nav-link treatment_applications_no" data-toggle="tab" href="#tab3" role="tab">
			{{ __('messages.sso_settings')}}
			<div class="caret"></div>
		</a>
	</li>
</ul>
{{-- tab body --}}
<div class="tab-content list_detail ">
	<div class="tab-pane fade active show" id="tab1">
		<div class="row div-zip-cd">
			<div class="col-md-3 col-lg-3 col-xl-2">
				<div class="form-group">
					<label class="control-label">{{__('messages.address')}}</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control zip_cd " id="zip_cd" placeholder="001-0001" maxlength="7" tabindex="3" value="{{isset($row1['zip_cd'])?$row1['zip_cd']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" tabindex="3" disabled="">〒</button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-9 col-lg-9 col-xl-10">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control prefecture" maxlength="100" tabindex="4" id="address1" value="{{isset($row1['address1'])?$row1['address1']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control" maxlength="100" tabindex="5" id="address2" value="{{isset($row1['address2'])?$row1['address2']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" class="form-control" maxlength="100" tabindex="6" id="address3" value="{{isset($row1['address3'])?$row1['address3']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
		</div>
		<div class="row">
			<div class="col-md-3">
				<div class="form-group">
					<label class="control-label">{{__('messages.phone_number')}}</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" id="tel" class="form-control tel-haifun" maxlength="20" tabindex="7" value="{{isset($row1['tel'])?$row1['tel']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-3">
				<div class="form-group">
					<label class="control-label">{{__('messages.fax_number')}}</label>
					<span class="num-length">
						<div class="input-group-btn btn-left">
							<input type="text" id="fax" class="form-control tel-haifun" maxlength="20" tabindex="8" value="{{isset($row1['fax'])?$row1['fax']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
							</div>
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-5">
				<div class="form-group">
					<label class="control-label">{{__('messages.other_party_ pic')}}</label>
					<span class="num-length">
						<div class="input-group-btn">
							<input type="text" class="form-control" id="incharge_nm" maxlength="30" tabindex="9" value="{{isset($row1['incharge_nm'])?$row1['incharge_nm']:''}}">
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
		</div>

		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">	&nbsp;</label>
					<div class="checkbox" style="line-height: unset">
						<div class="md-checkbox-v2">
							<input name="evaluation_use_typ" id="evaluation_use_typ" value="{{$row1['evaluation_use_typ']??1 }}" {{($row1['evaluation_use_typ']??1)!=1?'':'checked'}} type="checkbox"  tabindex="10" >
							<label for="evaluation_use_typ">{{__('messages.label_007')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
			<div class="col-md-6 col-xl-3 col-lg-3" style="max-width: 200px">
				<div class="form-group">
					<label class="control-label">{{__('messages.contract_period')}}</label>
					<select name="evaluation_contract_attribute" id="evaluation_contract_attribute" class="form-control" tabindex="11">
						@if(isset($library_data))
							@if($library_data[0]['number_cd'] !='')
								@foreach($library_data as $row)
									<option {{isset($row1['evaluation_contract_attribute']) &&($row1['evaluation_contract_attribute']== $row['number_cd'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
								@endforeach
							@endif
						@endif
					</select>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-6 col-xl-6 col-lg-6 date-m0001">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<div class="" style="display: flex">
						<div class="input-group  input-group-btn btn-date-btn" style="">
							<input type="text" id="evaluation_use_start_dt" class="form-control right-radius date date-start date-start-1" placeholder="yyyy/mm/dd" tabindex="12" value="{{isset($row1['evaluation_use_start_dt'])?$row1['evaluation_use_start_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-start" type="button" tabindex="-1" data-dtp="dtp_Jgb4P"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
						<span class="input-group-text" style="padding: 0px;justify-content: center;">
							<div class="">~</div>
						</span>
						<div class="input-group input-group-btn btn-date-btn" style="">
							<input type="text" id="evaluation_user_end_dt" class="form-control right-radius date date-end date-end-1" placeholder="yyyy/mm/dd" tabindex="13" value="{{isset($row1['evaluation_user_end_dt'])?$row1['evaluation_user_end_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-end" type="button" tabindex="-1" data-dtp="dtp_sZOlu"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div><!-- /.input-group -->
				</div>
			</div>

		</div>
		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">	&nbsp;</label>
					<div class="checkbox" style="line-height: unset">
						<div class="md-checkbox-v2">
							<input name="oneonone_use_typ" id="oneonone_use_typ" value="{{$row1['oneonone_use_typ']??1 }}" {{($row1['oneonone_use_typ'] ?? 1) !=1?'':'checked'}} type="checkbox"  tabindex="14" >
							<label for="oneonone_use_typ">{{__('messages.use_1_on_1_function')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
			<div class="col-md-6 col-xl-3 col-lg-3" style="max-width: 200px">
				<div class="form-group">
					<label class="control-label">{{__('messages.contract_period')}}</label>
					<select name="oneonone_contract_attribute" id="oneonone_contract_attribute" class="form-control" tabindex="15">
						@if(isset($library_data))
							@if($library_data[0]['number_cd'] !='')
								@foreach($library_data as $row)
									<option {{isset($row1['oneonone_contract_attribute']) &&($row1['oneonone_contract_attribute']== $row['number_cd'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
								@endforeach
							@endif
						@endif
					</select>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-6 col-xl-6 col-lg-6 date-m0001">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<div class="" style="display: flex">
						<div class="input-group input-group-btn btn-date-btn" style="">
							<input type="text" id="oneonone_use_start_dt" class="form-control right-radius date date-start date-start-1" placeholder="yyyy/mm/dd" tabindex="16" value="{{isset($row1['oneonone_use_start_dt'])?$row1['oneonone_use_start_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-start" type="button" tabindex="-1" data-dtp="dtp_Jgb4P"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
						<span class="input-group-text" style="padding: 0px;justify-content: center;">
							<div class="">~</div>
						</span>
						<div class="input-group input-group-btn btn-date-btn" style="">
							<input type="text" id="oneonone_user_end_dt" class="form-control right-radius date date-end date-end-1" placeholder="yyyy/mm/dd" tabindex="17" value="{{isset($row1['oneonone_user_end_dt'])?$row1['oneonone_user_end_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-end" type="button" tabindex="-1" data-dtp="dtp_sZOlu"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div><!-- /.input-group -->
				</div>
			</div>

		</div>
		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">	&nbsp;</label>
					<div class="checkbox" style="line-height: unset">
						<div class="md-checkbox-v2">
							<input name="multireview_use_typ" id="multireview_use_typ" value="{{$row1['multireview_use_typ']??1 }}" {{($row1['multireview_use_typ']??1) !=1?'':'checked'}} type="checkbox"  tabindex="18" >
							<label for="multireview_use_typ">{{__('messages.use_mr_function')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
			<div class="col-md-6 col-xl-3 col-lg-3" style="max-width: 200px">
				<div class="form-group">
					<label class="control-label">{{__('messages.contract_period')}}</label>
					<select name="multireview_contract_attribute" id="multireview_contract_attribute" class="form-control" tabindex="19">
						@if(isset($library_data))
							@if($library_data[0]['number_cd'] !='')
								@foreach($library_data as $row)
									<option {{isset($row1['multireview_contract_attribute']) &&($row1['multireview_contract_attribute']== $row['number_cd'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
								@endforeach
							@endif
						@endif
					</select>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-6 col-xl-6 col-lg-6 date-m0001">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<div class="" style="display: flex">
						<div class="input-group-btn btn-date-btn input-group" style="">
							<input type="text" id="multireview_use_start_dt" class="form-control right-radius date date-start date-start-1" placeholder="yyyy/mm/dd" tabindex="20" value="{{isset($row1['multireview_use_start_dt'])?$row1['multireview_use_start_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-start" type="button" tabindex="-1" data-dtp="dtp_Jgb4P"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
						<span class="input-group-text" style="padding: 0px;justify-content: center;">
							<div class="">~</div>
						</span>
						<div class="input-group-btn btn-date-btn input-group" style="">
							<input type="text" id="multireview_user_end_dt" class="form-control right-radius date date-end date-end-1" placeholder="yyyy/mm/dd" tabindex="21" value="{{isset($row1['multireview_user_end_dt'])?$row1['multireview_user_end_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-end" type="button" tabindex="-1" data-dtp="dtp_sZOlu"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div><!-- /.input-group -->
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">	&nbsp;</label>
					<div class="checkbox" style="line-height: unset">
						<div class="md-checkbox-v2">
							<input name="report_use_typ" id="report_use_typ" value="{{$row1['report_use_typ']??1 }}" {{($row1['report_use_typ']??1) !=1?'':'checked'}} type="checkbox"  tabindex="18" >
							<label for="report_use_typ">{{__('messages.use_report_function')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
			<div class="col-md-6 col-xl-3 col-lg-3" style="max-width: 200px">
				<div class="form-group">
					<label class="control-label">{{__('messages.contract_period')}}</label>
					<select name="report_contract_attribute" id="report_contract_attribute" class="form-control" tabindex="19">
						@if(isset($library_data))
							@if($library_data[0]['number_cd'] !='')
								@foreach($library_data as $row)
									<option {{isset($row1['report_contract_attribute']) &&($row1['report_contract_attribute']== $row['number_cd'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
								@endforeach
							@endif
						@endif
					</select>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-6 col-xl-6 col-lg-6 date-m0001">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<div class="" style="display: flex">
						<div class="input-group-btn btn-date-btn input-group" style="">
							<input type="text" id="report_use_start_dt" class="form-control right-radius date date-start date-start-1" placeholder="yyyy/mm/dd" tabindex="20" value="{{isset($row1['report_use_start_dt'])?$row1['report_use_start_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-start" type="button" tabindex="-1" data-dtp="dtp_Jgb4P"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
						<span class="input-group-text" style="padding: 0px;justify-content: center;">
							<div class="">~</div>
						</span>
						<div class="input-group-btn btn-date-btn input-group" style="">
							<input type="text" id="report_user_end_dt" class="form-control right-radius date date-end date-end-1" placeholder="yyyy/mm/dd" tabindex="21" value="{{isset($row1['report_user_end_dt'])?$row1['report_user_end_dt']:''}}">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent date-end" type="button" tabindex="-1" data-dtp="dtp_sZOlu"><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div><!-- /.input-group -->
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">	&nbsp;</label>
					<div class="checkbox" style="line-height: unset">
						<div class="md-checkbox-v2">
							<input name="marcopolo_use_typ" id="marcopolo_use_typ" value="{{$row1['marcopolo_use_typ']??1 }}" {{($row1['marcopolo_use_typ']??1) !=1?'':'checked'}} type="checkbox"  tabindex="18" >
							<label for="marcopolo_use_typ">{{__('messages.using_marco_polo_analysis')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">{{__('messages.contract_cd')}}</label>
					<span class="num-length">
						<div class="input-group-btn">
							<input type="text" id="contract_cd" class="form-control input-code" maxlength="10" tabindex="22" value="{{isset($row1['contract_cd'])?$row1['contract_cd']:''}}">
						</div>
					</span>
				</div><!--/.form-group -->
			</div>
			<div class="col-md-12 col-xl-3 col-lg-3">
				<div class="form-group">
					<label class="control-label">&nbsp</label>
					<div class="full-width">
						<a href="javascript:;" class="btn btn-primary btn-issue" tabindex="23" data-toggle="tooltip" data-original-title="{{__('messages.label_029')}}"   >
							<i class="fa fa-check"></i>
							{{__('messages.issue')}}
						</a>
					</div><!-- end .full-width -->
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="table-responsive">
					<table class="table table-bordered table-hover table-striped" id="table-target">
						<thead>
							<tr>
								<th>{{__('messages.pic')}}</th>
								<th style="width: 40px">
									<button class="btn btn-rm blue btn-sm" id="btn-add-row"  tabindex="24" >
										<i class="fa fa-plus"></i>
									</button>
								</th>
							</tr>
						</thead>
						<tbody>
							@if(isset($row2[0]))
							@foreach($row2 as $row)
							<tr class="table_m0002">
								<td scope="row">
									<div class="input-group-btn input-group div_employee_customer_cd">
										<span class="num-length">
											<input type="hidden" class="detail_no" value="{{$row['detail_no']}}">
											<input type="hidden" class="incharge_cd" id="incharge_cd" value="{{$row['incharge_cd']}}"/>
											<input type="text"  class="form-control indexTab employee_customer_nm " tabindex="24" maxlength="20" old_employee_nm="{{$row['employee_nm']}}" value="{{$row['employee_nm']}}" style="padding-right: 40px;"/>
										</span>
										<div class="input-group-append-btn">
											<button class="btn btn-transparent btn_employee_customer_cd_popup" type="button" tabindex="-1">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
								</td>
								<td class="text-center">
									<button class="btn btn-rm btn-sm btn-remove-row"  tabindex="24">
										<i class="fa fa-remove"></i>
									</button>
								</td>
							</tr>
							@endforeach
							@else
							<tr class="table_m0002">
								<td scope="row">
									<div class="input-group-btn input-group div_employee_customer_cd">
										<span class="num-length">
											<input type="hidden" class="detail_no">
											<input type="hidden" class="incharge_cd" id="incharge_cd"/>
											<input type="text" customer_typ="1" class="form-control indexTab employee_customer_nm " tabindex="24" maxlength="20"  style="padding-right: 40px;" />
										</span>
										<div class="input-group-append-btn">
											<button class="btn btn-transparent btn_employee_customer_cd_popup" type="button" tabindex="-1">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
								</td>
								<td class="text-center">
									<button class="btn btn-rm btn-sm btn-remove-row"  tabindex="24">
										<i class="fa fa-remove"></i>
									</button>
								</td>
							</tr>
							@endif
						</tbody>
					</table>
				</div><!-- end .table-responsive -->
			</div>
			<div class="col-md-6">
				<div class="table-responsive">
					<table class="table table-bordered table-hover table-striped" id="table-target2">
						<thead>
							<tr>
								<th width="40%" class="text-overfollow">{{__('messages.user_id')}}</th>
								<th width="25%" class="text-overfollow">{{__('messages.mail_password')}}</th>
								<th width="35%"  id="sso_header" class="{{$SSO_use_typ !=1?'hidden':''}} text-overfollow">{{__('messages.sso_user_id')}}</th>
							</tr>
						</thead>
						<tbody>
							@if(isset($row3[0]))
							@foreach($row3 as $row)
							<tr>
								<td  class="text-left" >

									<div style="max-width: 250px" class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['user_id']}}">{{$row['user_id']}}
								</td>
								<td class="text-left" >
									{{$row['password']}}
								</td>
								<td class="text-left {{$SSO_use_typ !=1?'hidden':''}}  sso_body" >
									<div style="max-width: 350px" class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['sso_user']}}">{{$row['sso_user']}}
								</td>
							</tr>
							@endforeach
							@else
							<tr class="tr-nodata">
								<td colspan="{{$SSO_use_typ !=1?'2':'3'}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
							</tr>
							@endif
						</tbody>
					</table>
				</div><!-- end .table-responsive -->
			</div>
		</div>
	</div>
	{{-- tab 2 --}}
	<div class="tab-pane fade" id="tab2">
		<div class="line-border-bottom">
			<label class="control-label">{{__('messages.basic_info')}}</label>
		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="form-group">
					<div class="checkbox">
						<div class="md-checkbox-v2">
							<input name="billing_to_typ" id="billing_to_typ" value="{{isset($row1['billing_to_typ'])?$row1['billing_to_typ']:'1'}}" {{isset($row1['billing_to_typ'])&&$row1['billing_to_typ']!=1?'':'checked'}} type="checkbox"  tabindex="15">
							<label for="billing_to_typ">{{__('messages.same_as_customer_info')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
		</div>
		<div id="div_billing_to_typ" class="{{isset($row1['billing_to_typ'])&&$row1['billing_to_typ']!=1?'':'hidden'}}">
			<div class="row">
				<div class="col-md-6 col-lg-6 col-xl-6">
					<div class="form-group">
						<label class="control-label">{{__('messages.address')}}</label>
						<span class="num-length">
							<input type="text" id="destination_nm" value="{{isset($row1['destination_nm'])?$row1['destination_nm']:''}}"  class="form-control" maxlength="50" tabindex="16">
						</span>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-6 col-lg-6 col-xl-3">
					<div class="form-group">
						<label class="control-label">{{__('messages.other_party_ pic')}}</label>
						<span class="num-length">
							<input type="text" id="Billing_incharge_nm"  class="form-control" maxlength="30" tabindex="17" value="{{isset($row1['Billing_incharge_nm'])?$row1['Billing_incharge_nm']:''}}">
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
			<div class="row div-zip-cd">
				<div class="col-md-4 col-lg-3 col-xl-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.address')}}</label>
						<span class="num-length">
							<div class="input-group-btn btn-left">
								<input type="text" id="Billing_zip_cd" class="form-control zip_cd" placeholder="001-0001" maxlength="7" tabindex="18" value="{{isset($row1['Billing_zip_cd'])?$row1['Billing_zip_cd']:''}}">
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" disabled="">〒</button>
								</div>
							</div>

						</span>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-8 col-lg-9 col-xl-10">
					<div class="form-group">
						<label class="control-label">&nbsp</label>
						<span class="num-length">
							<div class="input-group-btn btn-left">
								<input type="text" id="Billing_address1"  class="form-control prefecture" maxlength="100" tabindex="19" value="{{isset($row1['Billing_address1'])?$row1['Billing_address1']:''}}">
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
								</div>
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<span class="num-length">
							<div class="input-group-btn btn-left">
								<input type="text" id="Billing_address2" class="form-control city_nm" maxlength="100" tabindex="20" value="{{isset($row1['Billing_address2'])?$row1['Billing_address2']:''}}">
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
								</div>
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<span class="num-length">
							<div class="input-group-btn btn-left">
								<input type="text" id="Billing_address3" class="form-control" maxlength="100" tabindex="21" value="{{isset($row1['Billing_address3'])?$row1['Billing_address3']:''}}">
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
								</div>
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
			<div class="row">
				<div class="col-md-4 col-lg-4 col-xl-3 ">
					<div class="form-group">
						<label class="control-label">{{__('messages.phone_number')}}</label>
						<span class="num-length">
							<div class="input-group-btn btn-left">
								<input type="text" id="Billing_tel" class="form-control tel-haifun" maxlength="20" tabindex="22"  value="{{isset($row1['Billing_tel'])?$row1['Billing_tel']:''}}">
								<div class="input-group-append-btn">
									<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
								</div>
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
		</div>
	</div>
	{{-- tab 3 --}}
	<div class="tab-pane fade" id="tab3">
		<div class="row">
			<div class="col-md-7 col-sm-6 col-lg-4 col-xl-3">
				<div class="form-group">
					<label class="control-label">{{__('messages.version_used')}}</label>
					<div class="checkbox">

						<div class="md-checkbox-v2">
							<input name="SSO_use_typ" id="SSO_use_typ" value="{{$SSO_use_typ }}" {{$SSO_use_typ !=1?'':'checked'}} type="checkbox"  tabindex="14" >
							<label for="SSO_use_typ">{{__('messages.use_sso_version')}}</label>
						</div>
					</div><!-- end .checkbox -->
				</div>
			</div>
			<div class="col-md-5 col-sm-6 col-lg-4 col-xl-3">
				<div class="form-group ">
					<label class="control-label  {{$row1['sso_label']??''}}" lb-required="{{ __('messages.required') }}">{{__('messages.tools_used')}}</label>
					<select name="SSO_typ" id="SSO_typ" class="form-control  {{$row1['sso_input']??''}}" tabindex="15">
						<option value="0"></option>
						@if(isset($library_sso))
							@if($library_sso[0]['number_cd'] !='')
								@foreach($library_sso as $row)
									<option {{isset($row1['SSO_typ']) &&($row1['SSO_typ']== $row['number_cd'])?'selected':''}} value="{{$row['number_cd']}}">{{$row['name']}}</option>
								@endforeach
							@endif
						@endif
					</select>
				</div><!--/.form-group -->
			</div>
			{{-- <div class="col-md-4">
				<div class="form-group">
					<label class="control-label  {{isset($row1['sso_label'])&&$SSO_use_typ == 1 ?'lb-required':''}}" lb-required="{{ __('messages.required') }}">URL</label>
					<span class="num-length">
						<div class="input-group-btn">
							<input type="text" id="SSO_URL" class="form-control  {{isset($row1['sso_input'])&&$SSO_use_typ == 1 ?'required':''}}" maxlength="30" tabindex="15" value="{{isset($row1['SSO_URL'])?$row1['SSO_URL']:''}}">
						</div>
					</span>
				</div><!--/.form-group -->
			</div> --}}
		</div>
		<div class="set-sso {{$SSO_use_typ !=1?'hidden':''}}">
			<?php
				$required='';
				$lbrequired = '';
				if($SSO_use_typ ==1){
					$required ='required'; $lbrequired ='lb-required' ;
				}
			?>
			<div class="row">
				<div class="col-md-12">
					<div class="line-border-bottom">
						<label class="control-label">{{__('messages.sp_information')}}</label>
					</div>
				</div><!-- end .col-md-4 -->
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}}" lb-required="{{ __('messages.required') }}">NameIDFormat</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="sp_NameIDFormat" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_sp_NameIDFormat'])?$row1['SSO_sp_NameIDFormat']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div>{{-- 	end .row --}}
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">x509cert</label>
						<span class="num-length text-area">
							<div class="input-group-btn">
								 <textarea  rows="3" type="text" class="form-control input-sm {{$required}}" maxlength="1500" id="sp_x509cert" tabindex="15">{{isset($row1['SSO_sp_x509cert'])?$row1['SSO_sp_x509cert']:''}}</textarea>
								{{-- <input type="" id="sp_x509cert" class="form-control required" maxlength="1000" tabindex="15" value="{{isset($row1['SSO_sp_x509cert'])?$row1['SSO_sp_x509cert']:''}}"> --}}
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label">privateKey</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="sp_privateKey" class="form-control" maxlength="255" tabindex="15" value="{{isset($row1['SSO_sp_privateKey'])?$row1['SSO_sp_privateKey']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">entityId</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="sp_entityId" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_sp_entityId'])?$row1['SSO_sp_entityId']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">singleLogoutService</label>
						<span class="num-length ">
							<div class="input-group-btn">
								<input type="text" id="sp_singleLogoutService" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_sp_singleLogoutService'])?$row1['SSO_sp_singleLogoutService']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="line-border-bottom">
						<label class="control-label {{$lbrequired}}" lb-required="{{ __('messages.required') }}">{{__('messages.idp_info')}}</label>
					</div>
				</div><!-- end .col-md-12 -->
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">entityId</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="idp_entityId" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_idp_entityId'])?$row1['SSO_idp_entityId']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">singleSignOnService</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="idp_singleSignOnService" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_idp_singleSignOnService'])?$row1['SSO_idp_singleSignOnService']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">singleLogoutService</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="idp_singleLogoutService" class="form-control {{$required}}" maxlength="255" tabindex="15" value="{{isset($row1['SSO_idp_singleLogoutService'])?$row1['SSO_idp_singleLogoutService']:''}}">
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group text-area">
						<label class="control-label {{$lbrequired}} " lb-required="{{ __('messages.required') }}">x509cert</label>
						<span class="num-length">
							<div class="input-group-btn">
								<textarea  rows="3" type="text" class="form-control input-sm {{$required}}" maxlength="1500" id="idp_x509cert" tabindex="15">{{isset($row1['SSO_idp_x509cert'])?$row1['SSO_idp_x509cert']:''}}</textarea>
								{{-- <input type="text" id="idp_x509cert" class="form-control required" maxlength="1000" tabindex="15" value="{{isset($row1['SSO_idp_x509cert'])?$row1['SSO_idp_x509cert']:''}}"> --}}
							</div>
						</span>
					</div><!--/.form-group -->
				</div>
			</div><!-- end .row -->
		</div><!-- end .st-sso -->
	</div>

</div>
{{-- <input type='hidden' id='api_err' value='{{$err??''}}'/>
<input type='hidden' id='api_company_id' value='{{$companies[0]['id']??''}}'/>
<input type='hidden' id='api_company_nm' value='{{$companies[0]['name']??''}}'/> --}}

{{-- <div class="row">
	<div class="col-md-4">
		<div class="form-group">
			<label class="control-label">{{__('messages.system_linkage')}}</label>
			<div class="checkbox">
				<div class="md-checkbox-v2">
					<input name="cooperation_typ" id="cooperation_typ" value="{{isset($row1['cooperation_typ'])?$row1['cooperation_typ']:'1'}}" {{(isset($row1['cooperation_typ'])&&($row1['cooperation_typ']!=1))?'':'checked'}} type="checkbox"  tabindex="14" >
					<label for="cooperation_typ">{{__('messages.link_with_勤怠trust')}}</label>
				</div>
			</div><!-- end .checkbox -->
		</div>
	</div>
</div> --}}




<table class="table table-bordered table-hover table-striped hidden" id="table-data">
	<tbody>
		<tr>
			<td scope="row">
				<div class="input-group-btn input-group div_employee_customer_cd">
					<span class="num-length">
						<input type="hidden" class="detail_no">
						<input type="hidden" class="incharge_cd" id="incharge_cd"/>
						<input type="text" id="employee_nm" class="form-control indexTab employee_customer_nm " tabindex="24" maxlength="20" customer_typ="1" style="padding-right: 40px;" />
					</span>
					<div class="input-group-append-btn">
						<button class="btn btn-transparent btn_employee_customer_cd_popup" type="button" tabindex="-1">
							<i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</td>
			<td class="text-center">
				<button class="btn btn-rm btn-sm btn-remove-row"  tabindex="24">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
		<tr class="tr-nodata">
            <td colspan="{{$SSO_use_typ !=1?'2':'3'}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
        </tr>
	</tbody>
</table>