@php
	if(isset($screen) && $screen == 'sq0070'){
		$layout = 'slayout';
		$system = 4;
	}else{
		$layout = 'layout';
		$system = 1;
	}
@endphp

@extends($layout)

@section('asset_header')
	<!-- START LIBRARY CSS -->
	{!!public_url('template/css/form/q0070.index.css')!!}
@stop
@section('asset_footer')
<script>
	var list_of_employees = '{{ __('messages.list_of_employees') }}';
	var error = '{{ __('messages.error') }}';
	var label_010 = '{{ __('messages.label_010') }}';
	var lable_26 = '{{ __('messages.lable_26') }}';
</script>
	{!!public_url('template/js/form/q0070.index.js')!!}
	<!-- START LIBRARY JS -->
@stop

@push('asset_button')
	@if(isset($screen) && $screen == 'sq0070')
		{!!
			Helper::buttonRender(['addNewButton' ,'releasedPass','mailButton','staffOutputButton','backButton'],[])
		!!}
	@else
		{!!
			Helper::buttonRender(['staffHistryOutputButton','staffOutputButton','backButton'],[])
		!!}
	@endif
@endpush

@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		@if(isset($html) && $html != '')
			{!! $html !!}
		@else
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-body box-input-search">
						<div class="row">
							<div class="col-md-2 div_parent_employee_cd">
								<div class="form-group">
									<label class="control-label">{{ __('messages.employee_no') }}
									</label>
									<div class="input-group-btn input-group div_employee_cd">
										<span class="num-length">
											<input type="hidden" id="authority_typ" value="{{$authority_typ??''}}">
											<input type="text" class="form-control indexTab employee_cd refer_employee_cd  Convert-Halfsize" tabindex="1" maxlength="10" id="employee_cd" value="{{isset($cache['employee_cd'])?$cache['employee_cd']:''}}" style="padding-right: 40px;" />
										</span>
										<div class="input-group-append-btn">
											<button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-2 div_parent_employee_nm">
								<div class="form-group">
									<label class="control-label">{{ __('messages.name_s') }}</label>
									<div class="input-group-btn input-group">
										<span class="num-length">
											<input type="hidden" class="employee_cd_hidden">
											<input type="text" class="form-control text-gray employee_name" tabindex="2" maxlength="101" value="{{isset($cache['employee_name'])?$cache['employee_name']:''}}" placeholder="{{ __('messages.label_006') }}" id="employee_name"/>
										</span>
									</div>
								</div><!--/.form-group -->
							</div>
							<div class="col-md-2">
								<div class="form-group">
									<label class="control-label">{{ __('messages.employee_classification') }}</label>
									<select class="form-control" tabindex="3" id="employee_typ">
										<option value="-1"></option>
										@foreach($m0060 as $item)
											<option value="{{$item['employee_typ']}}" {{isset($cache['employee_typ'])&&($cache['employee_typ'] == $item['employee_typ']) ? 'selected' : ''}}>
												{{$item['employee_typ_nm']}}
											</option>
										@endforeach
									</select>
								</div><!--/.form-group -->
							</div>
							<div class="col-md-2">
								<div class="form-group">
									<label class="control-label">{{ __('messages.position') }}</label>
									<select class="form-control" tabindex="6" id="position_cd">
										<option value="-1"></option>
										@foreach($m0040 as $item)
											<option value="{{$item['position_cd']}}" {{isset($cache['position_cd'])&&($cache['position_cd'] == $item['position_cd']) ? 'selected' : ''}}>
												{{$item['position_nm']}}
											</option>
										@endforeach
									</select>
								</div><!--/.form-group -->
							</div>
							<div class="col-md-2">
								<div class="row">
									<div class="col-md-12">
										<div class="form-group">
											<label class="control-label">{{ __('messages.grade') }}</label>
											<select class="form-control" tabindex="7" id="grade">
												<option value="-1"></option>
												@foreach($m0050 as $item)
													<option value="{{$item['grade']}}" {{isset($cache['grade'])&&($cache['grade'] == $item['grade']) ? 'selected' : ''}}>
														{{$item['grade_nm']}}
													</option>
												@endforeach
											</select>
										</div><!--/.form-group -->
									</div><!-- end .col-md-9 -->
								</div><!-- end .row -->
							</div>
						</div> <!-- end .row -->
						<div class="row" id ="html_organization">
						@foreach($organization_group as $item)
							@if($item['organization_step'] == 1)
								<div class="col-md-2 col-xs-12 col-lg-2">
									<div class="form-group">
										<label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
												data-original-title="{{$item['organization_group_nm']}}" style="max-width: 190px;    display: block">
											{{$item['organization_group_nm']}}
										</label>
											<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control  organization_cd1" system="{{$system}}">
												<option value="-1"></option>
												@foreach($combo_organization as $temp)
												<option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
												@endforeach
											</select>
									</div>
								</div>
							@else
								<div class="col-md-2 col-xs-12 col-lg-2">
									<div class="form-group">
										<label class="text-overfollow control-label" data-container="body" data-toggle="tooltip"
												data-original-title="{{$item['organization_group_nm']}}" style="max-width: 190px;    display: block">
											{{$item['organization_group_nm']}}
										</label>
												<select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="8" class="form-control  organization_cd{{$item['organization_step']}}" system="{{$system}}">
												</select>
									</div>
								</div>
							@endif
						@endforeach
								{{-- @if(isset($organization_group[0]))
									<div class="col-md-2 col-xs-12 col-lg-2">
										<div class="form-group">
											<label class="control-label text-overfollow" data-toggle="tooltip"
												data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="width:185px">
												{{$organization_group[0]['organization_group_nm']}}
											</label>
											<select name="" id="organization_step{{$organization_group[0]['organization_step']}}" class="form-control organization_cd1" tabindex="19" organization_typ='{{$organization_group[0]['organization_step']}}'>
												<option value="0"></option>
												@foreach($combo_organization as $row)
													<option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" >{{$row['organization_nm']}}</option>
												@endforeach
											</select>
										</div>
										<!--/.form-group -->
									</div>
								@endif
								@foreach($organization_group as $dt)
									@if($dt['organization_typ'] >=2)
										<div class="col-md-2 col-xs-12 col-lg-2">
											<div class="form-group">
												<label class="control-label text-overfollow" data-toggle="tooltip"
												data-original-title="{{$dt['organization_group_nm']}}" style="width:185px">
													{{$dt['organization_group_nm']}}
												</label>
												<select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="19" organization_typ = "{{$dt['organization_typ']}}">
													<option value="0"></option>
												</select>
											</div>
											<!--/.form-group -->
										</div>
									@endif
								@endforeach --}}
							<div class="col-md-2" style="padding-left: 0px;">
								<div class="form-group">
									<label class="control-label">&nbsp;</label>
									<div class="checkbox">
										<div class="md-checkbox-v2 inline-block" style="width:200px">
											<input name="company_out_dt_flg" id="company_out_dt_flg" type="checkbox" value="1" tabindex="9">
											<label for="company_out_dt_flg">{{ __('messages.include_retired_employees') }}</label>
										</div>
									</div>
								</div>
							</div>
						</div> <!-- end .row -->
						<div class="row">
							<div class="col-md-2">
								<div class="form-group" >
									<label class="control-label">{{ __('messages.fiscal_year') }}</label>
									<select class="form-control" tabindex="10" id="fiscal_year">
										<option value="-1"></option>
										@foreach($f0010 as $item)
											<option value="{{$item['fiscal_year']}}" {{isset($cache['fiscal_year'])&&($cache['fiscal_year'] == $item['fiscal_year']) ? 'selected' : ''}}>
												{{$item['fiscal_year']}}
											</option>
										@endforeach
									</select>
								</div><!--/.form-group -->
							</div><!-- end .col-md-3 -->
							<div class="col-md-2">
								<div class="form-group">
									<label class="control-label">{{ __('messages.eval_group') }}</label>
									<select class="form-control" tabindex="11" id="group_cd">
										<option value="-1"></option>
										@foreach($m0150 as $item)
											<option value="{{$item['group_cd']}}" {{isset($cache['group_cd'])&&($cache['group_cd'] == $item['group_cd']) ? 'selected' : ''}}>
												{{$item['group_nm']}}
											</option>
										@endforeach
									</select>
								</div><!--/.form-group -->
							</div>

							<div class="col-md-auto" style="padding: 0 10px;">
								<div class="form-group">
									<label class="control-label">&nbsp;</label>
									<div class="checkbox" style="line-height: unset">
										<div class="md-checkbox-v2 pt-1">
											<input name="ck111" id="ck_search" type="checkbox" tabindex="12" value="1" {{ isset($cache['ck_search'])&&($cache['ck_search'] == 1) ? 'checked' : ''}} style="line-height: unset">
											<label for="ck_search">{{ __('messages.not_matched_group') }}</label>
										</div>
									</div>
								</div><!--/.form-group -->
							</div>
						</div>
						@include('Master::items.index')
						<div class="row">
							<div class="col-md-12">
								<div class="form-group text-right">
									<div class="full-width">
										<a href="javascript:;" class="btn btn-outline-primary btn-search" tabindex="40">
											<i class="fa fa-search"></i>
											{{ __('messages.search') }}
										</a>
									</div><!-- end .full-width -->
								</div>
							</div>
						</div> <!-- end .row -->
					</div><!-- end .card-body -->
				</div><!-- end .card -->
				<div class="card" style="min-height: 50vh">
            		<div class="card-body">
            			<div id="result">
							@include('Master::q0070.search')
						</div>
            		</div>
            	</div>
        		<input type="hidden" class="anti_tab" name="">
			</div><!-- end .col-md-12 -->
		</div><!-- end .row -->
		@endif
	</div><!-- end .container-fluid -->
@stop