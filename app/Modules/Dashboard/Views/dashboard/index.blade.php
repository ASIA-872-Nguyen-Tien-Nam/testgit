@extends('layout')

@push('header')
{!!public_url('template/css/form/dashboard.css')!!}
@endpush

@section('asset_footer')

{!!public_url('template/js/common/jmessages.js')!!}
{!!public_url('template/js/common/highcharts.min.js')!!}
{!!public_url('template/js/form/dashboard.js')!!}

@stop
@push('asset_button')
	@if($authority_typ == '3' || $authority_typ == '6')
		<div class="col-2 col-xl-6 col-lg-6 header-right-function">
			<select class="form-control" id="authority_typ">
				<option value="3" {{($authority_typ ==3)?'selected':''}}>{{ __('messages.admin_authority') }}</option>
				<option value="6" {{($authority_typ ==6)?'selected':''}}>{{ __('messages.rater_authority') }}</option>
			</select>
		</div>
	@endif
@endpush
@section('content')
@php
	$auth = session_data();
	$excepts = $auth->excepts;
@endphp
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="card pe-w">
				<div class="card-body">
					<div class="row">
						<div class="col-md-7">
							<div class="p-title row" style="align-items: center">
								<div class="col-md-12 col-lg-6 col-xl-4">
									<h6 style="margin-bottom: 0px"><i class="fa fa-bar-chart" aria-hidden="true"></i> {{ __('messages.evaluation_sheet_progress') }} </h6>
								</div>
								<div class="col-md-12 col-lg-3 col-xl-2 select-row">
									<select id="fiscal_year" tabindex="1" class="form-control required " from_screen_id ="I2040">
										@if(!empty($F0010))
											@foreach($F0010 as $temp)
												<option value="{{$temp['fiscal_year']}}" {{$temp['fiscal_year'] == ($fiscal_year??-1)?'selected':''}}>{{$temp['fiscal_year']}}</option>
											@endforeach
										@endif
									</select>
								</div>
								<div class="col-md-12 col-lg-3 col-xl-2 select-row">
									<select class="form-control" id="organization_cd" tabindex="5">
										<option value=""></option>
										@if(!empty($m0020))
											@foreach($m0020 as $item)
												<option value="{{$item['organization_cd_1']}}">
													{{$item['organization_nm']}}
												</option>
											@endforeach
										@endif
									</select>
								</div>
								<div class="col-md-12 col-lg-3 col-xl-2 select-row">
									<select id="select_period" class="form-control ml-1">
										<option value="0"></option>
										@if(!empty($list_period))
											@foreach($list_period as $item)
											<option {{(isset($select_period)&&($select_period ==$item['detail_no']))?'selected':''}} value="{{$item['detail_no']}}">
												{{$item['period_nm']}}
											</option>
											@endforeach
										@endif
									</select>
								</div>
								<div class="col-md-12 col-lg-3 col-xl-2 select-row">
									<select id="select_category_typ" class="form-control ml-1">
										<option value="0" {{$select_category_typ == 0 ? 'selected="selected"' : ''}}>{{ __('messages.target') }}</option>
										<option value="1" {{$select_category_typ == 1 ? 'selected="selected"' : ''}}>{{ __('messages.qualitative_evaluation') }}</option>
									</select>
								</div>
							</div><!-- end .p-title -->
							<div class="col-md-12">
								<div id="result_liststatus">
									@include('Dashboard::dashboard.liststatus')
								</div><!-- end .row -->
							</div>
							<div id="result_listemployee">
								@include('Dashboard::dashboard.listemployee')
							</div><!-- end .row -->

					</div><!-- end .col-md-7 -->

					<div class="col-md-5" style="margin-top: 20px;">
						<ul class="p-title-btn">
							@if($authority_typ != '3')
								@if(isset($employee_login_typ) && $employee_login_typ == 2)
									<li id="refer_portal_evaluator" class="refer_screen">
										<a href="/master/portal" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-paper-plane-o"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.my_page') }}</div>
												@else
												<div>{{ __('messages.my_page') }}</div>
												@endif
											</div>
										</a>
									</li>
								@else
									<li id="refer_portal_evaluator" class="refer_screen">
										<a href="/master/portal/evaluator?from=dashboard" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-paper-plane-o"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.my_page') }}</div>
												@else
												<div>{{ __('messages.my_page') }}</div>
												@endif
											</div>
										</a>
									</li>
								@endif
							@endif
							@if (property_exists($excepts, 'screen_master_i1010'))
								@php
									$authority = 0;
									$screen2 = 'screen_master_i1010';
									$authority = $excepts->$screen2->authority ?? 0;
								@endphp
								@if ($authority <> 0)
									<li id="refer_i1010" class="refer_screen">
										<a href="/master/i1010" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-refresh"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.update_fiscal_year') }}</div>
												@else
												<div>{{ __('messages.update_fiscal_year') }}</div>
												@endif
											</div>
										</a>
									</li>
								@endif
							@endif
							@if (property_exists($excepts, strtolower('screen_master_q0070')))
								@php
									$authority = 0;
									$screen2 = 'screen_master_q0070';
									$authority = $excepts->$screen2->authority ?? 0;
								@endphp
								@if ($authority <> 0)
									<li id="refer_q0070" class="refer_screen">
										<a href="/master/q0070" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-users"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.employee_master_dashboard_up') }}</div>
												@else
												<div>{{ __('messages.employee_master_dashboard') }}</div>
												@endif
											</div>
										</a>
									</li>
								@endif
							@endif
							@if (property_exists($excepts, strtolower('screen_master_i2040')))
								@php
									$authority = 0;
									$screen2 = 'screen_master_i2040';
									$authority = $excepts->$screen2->authority ?? 0;
								@endphp
								@if ($authority <> 0)
									<li id="refer_i2040" class="refer_screen">
										<a href="/master/i2040" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-file-text-o"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.overall_evaluation') }}</div>
												@else
												<div>{{ __('messages.overall_evaluation') }}</div>
												@endif
											</div>
										</a>
									</li>
								@endif
							@endif
							@if (property_exists($excepts, strtolower('screen_master_q2030')))
								@php
									$authority = 0;
									$screen2 = 'screen_master_q2030';
									$authority = $excepts->$screen2->authority ?? 0;
								@endphp
								@if ($authority <> 0)
									<li  id="refer_q2030" class="refer_screen">
										<a href="/master/q2030" class="btn btn-outline-primary btn-horizontal lg">
											<div class="inner">
												<i class="fa fa-cog"></i>
												@if(session_data()->language != 'en')
												<div style="font-size:12px;margin-top:4px;">{{ __('messages.eval_analysis') }}</div>
												@else
												<div>{{ __('messages.eval_analysis') }}</div>
												@endif
											</div>
										</a>
									</li>
								@endif
							@endif
						</ul><!-- end .btn-group -->
						<div class="clearfix"></div><!-- end .clearfix -->
						<div class="p-title mb-0">
							<h4 class="block"><i class="fa fa-file-text-o fa-flip-vertical"></i> {{ __('messages.information') }}</h4>
						</div><!-- end .p-title -->
						<ul class="list-group lst-content" style="overflow-y: auto; max-height: 60vh;">
							@if(!empty($list_infomation))
                			@foreach($list_infomation as $item)
                			<li class="list-group-item list_infomation" company_cd="{{$item['company_cd']}}" category="{{$item['category']}}" status_cd="{{$item['status_cd']}}" infomationn_typ="{{$item['infomationn_typ']}}" infomation_date="{{$item['infomation_date']}}" target_employee_cd="{{$item['target_employee_cd']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}"   fiscal_year="{{$item['fiscal_year']}}">
                    			<a>
                    			    <span style="width:100px">{{$item['infomation_date']}}</span>
                    			    <div class="text-overfollow infomation_title"  data-container="body" data-toggle="tooltip" data-original-title="{{$item['infomation_title'].' ('.$item['target_employee_nm'].'様)'}}">{{$item['infomation_title'].' ('.$item['target_employee_nm'].'様)'}}
                    			    </div>
                    			</a>
                			</li>
                			@endforeach
                			@else
                			<li class="text-center">
                			    {{ $_text[21]['message'] }}
                			</li>
                			@endif
						</ul>

					</div><!-- end .col-md-5 -->
				</div><!-- end .row -->
			</div><!-- end .card-body -->
		</div><!-- end .card -->
	</div><!-- end .col-md-6 -->
</div><!-- end .row -->
</div><!-- end .container-fluid -->
@stop
