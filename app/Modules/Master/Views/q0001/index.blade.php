@extends('customer')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/q0001.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/q0001.index.js')!!}
@stop
@push('asset_button')
{!!
Helper::buttonRender(['addNewButton' , 'outputButton'])
!!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body box-input-search" id="search-box">
			<input type="hidden" class="anti_tab" name="">

			<div class="row">
				<div class="col-md-4 col-lg-3 col-xl-2  min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.customer_cd')}}</label>
						<span class="num-length">
							<input type="text" class="form-control only-number" value="{{isset($cache['company_cd'])?$cache['company_cd']:''}}" tabindex="1" style="" maxlength="10" id="company_cd" />
						</span>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-4 col-lg-3 col-xl-2  min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.customer_name')}}</label>
						<span class="num-length">
							<input type="text" class="form-control" tabindex="2" value="{{isset($cache['company_nm'])?$cache['company_nm']:''}}" maxlength="100" id="company_nm" />
						</span>
					</div>
				</div>
				<div class="col-md-4 col-lg-3 col-xl-2  min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.pic')}}</label>
						<div class="input-group-btn input-group div_employee_customer_cd">
							<span class="num-length">
								<input type="hidden" class="detail_no">
								<input type="hidden" class="incharge_cd" id="incharge_cd" value="{{isset($cache['incharge_cd'])?$cache['incharge_cd']:''}}" />
								<input type="text" id="employee_nm" class="form-control indexTab employee_customer_nm " value="{{isset($cache['employee_nm'])?$cache['employee_nm']:''}}" tabindex="3" maxlength="20" customer_typ="1" style="padding-right: 40px;" />
							</span>
							<div class="input-group-append-btn">
								<button class="btn btn-transparent btn_employee_customer_cd_popup" type="button" tabindex="-1">
									<i class="fa fa-search"></i>
								</button>
							</div>
						</div>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-2">
				</div>


			</div>
			<div class="row">
				<div class="col-md-4 col-lg-3 col-xl-2 min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.label_011')}}</label>
						<select class="form-control" tabindex="3" id="evaluation_contract">
							<option value="0"></option>
							@foreach($library_data as $item)
							<option value="{{$item['number_cd']}}" {{isset($cache['number_cd'])&&($cache['number_cd'] == $item['number_cd']) ? 'selected' : ''}}>
								{{$item['name']}}
							</option>
							@endforeach
						</select>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-4 col-lg-3 col-xl-2 min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.1on1_function_contract_status')}}</label>
						<select class="form-control" tabindex="3" id="oneonone_contract">
							<option value="0"></option>
							@foreach($library_data as $item)
							<option value="{{$item['number_cd']}}" {{isset($cache['number_cd'])&&($cache['number_cd'] == $item['number_cd']) ? 'selected' : ''}}>
								{{$item['name']}}
							</option>
							@endforeach
						</select>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-4 col-lg-3 col-xl-2 min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.multi_review_contract_status')}}</label>
						<select class="form-control" tabindex="3" id="multiview_contract">
							<option value="0"></option>
							@foreach($library_data as $item)
							<option value="{{$item['number_cd']}}" {{isset($cache['number_cd'])&&($cache['number_cd'] == $item['number_cd']) ? 'selected' : ''}}>
								{{$item['name']}}
							</option>
							@endforeach
						</select>
					</div><!--/.form-group -->
				</div>
				<div class="col-md-4 col-lg-3 col-xl-2 min_w200">
					<div class="form-group">
						<label class="control-label">{{__('messages.reporting_feature_contract_status')}}</label>
						<select class="form-control" tabindex="3" id="report_contract">
							<option value="0"></option>
							@foreach($library_data as $item)
							<option value="{{$item['number_cd']}}" {{isset($cache['number_cd'])&&($cache['number_cd'] == $item['number_cd']) ? 'selected' : ''}}>
								{{$item['name']}}
							</option>
							@endforeach
						</select>
					</div><!--/.form-group -->
				</div>
				<div style="width:180px">
					<div class="w-150" style="line-height: 2.0;min-width:180px; padding-left:10px;padding-right:10px">
						<div class="form-group">
							<label></label>
							<div class="checkbox">
								<div class="md-checkbox-v2 inline-block">
									<input name="check_account" id="check_account" type="checkbox" value="0" tabindex="5">
									<label for="check_account">{{__('messages.account_verification')}}</label>
								</div>
							</div><!-- end .checkbox -->
						</div>
					</div>
				</div>
				<!-- <div class="col-md-12 col-lg-9 min_w500 div_year_search_button"> -->
					<!-- <div class="row"> -->
						<div class="" style="min-width:155px;max-width:155px;padding-left:10px;padding-right:10px">
							<div class="form-group">
								<label class="control-label">{{__('messages.year')}}</label>
								<div class="input-group-btn input-group" style="">
									<input type="text" class="form-control right-radius month" placeholder="yyyy/mm" value="{{$cache['year_month']??date('Y/m', strtotime('-1 month', time()))}}" tabindex="5" id="year_month">
									<div class="input-group-append-btn">
										<button class="btn btn-transparent" type="button" tabindex="-1" data-dtp="dtp_WMg6K"><i class="fa fa-calendar"></i></button>
									</div>
								</div>
							</div><!--/.form-group -->
						</div>
						<div class="ml-auto" style="margin-right: 10px;">
							<div class="form-group text-right">
								<label class="control-label">&nbsp;</label>
								<div class="full-width">
									<a href="javascript:;" class="btn btn-outline-primary" tabindex="6" id="search_company" tabindex="-1">
										<i class="fa fa-search"></i>
										{{__('messages.search')}}
									</a>
								</div><!-- end .full-width -->
							</div>
						</div>
					<!-- </div> -->
				<!-- </div> -->
			</div><!-- end .row -->
		</div><!-- end .card-body -->
	</div><!-- end .card -->
	<div class="card">
		<div id="result">
			@include('Master::q0001.refer')
		</div>
	</div><!-- end .card -->
	@php
	$language = Config::get('app.locale');
	@endphp
	<input type="hidden" id="language_jmessages" value="{{$language}}">
	<input type="hidden" value="{{isset($cache['page'])?$cache['page']:''}}" id="history_page" />
	<input type="hidden" value="{{isset($cache['page_size'])?$cache['page_size']:''}}" id="history_page_size" />
</div><!-- end .container-fluid -->
@stop