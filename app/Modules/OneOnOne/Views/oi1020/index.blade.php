@extends('oneonone/layout')

@section('asset_header')
{!!public_url('template/css/oneonone/oi1020/i1020.index.css')!!}
<!-- START LIBRARY CSS -->
@stop
@section('asset_footer')
<script>
	var display_attribute_info = "{!! __('messages.display_attribute_info') !!}";
	var hide_attribute_info = "{!! __('messages.hide_attribute_info') !!}";
</script>
<!-- START LIBRARY JS -->
{!!public_url('template/js/oneonone/oi1020/oi1020.index.js')!!}
@stop

@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','exportButton','v17ImportButton','deleteButton','backButton'])
!!}
@endpush
@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
	@endphp
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">

		<div class="card">
			<div class="card-body ">
				<div class="row">
					<div class="col-md-12 col-12">
						<button type="button" class="btn  button-card"><span><i class="fa fa-chevron-down"></i></span>{{ __('messages.hidden') }}</button>
					</div>
				</div>
				<br>
				<div class="group-search-condition">
					<div class="row">
						<div class="col-md-4 col-xl-2">
							<div class="form-group">
								<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
								<select autocomplete="off"  name="" id="fiscal_year" class="form-control required" tabindex="1">
									@for ($i = $fiscal_year - 3; $i <= $fiscal_year + 3 ; $i++)
										<option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year'))}}</option>
									@endfor
								</select>
							</div>
						</div>
						<div class="col-md-4 col-xl-2">
							<div class="form-group">
								<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.group_name1') }}</label>
								<select autocomplete="off"  name="" id="group_cd" class="form-control required group_cd" tabindex="2">
									<option value="-1"></option>
									@if (isset($oneonone_group[0])&&!empty($oneonone_group[0]))
										@foreach ($oneonone_group as $item)
											<option value="{{$item['oneonone_group_cd']}}" times={{$item['times']}}>{{$item['oneonone_group_nm']}}</option>
										@endforeach
									@endif
								</select>
							</div>
						</div>
					</div>
					<div id="refer_data">
						<div class="row mt-10">
							<div class="col-md-12 col-xl-10">
								<label class="control-label">{{ __('messages.group_target') }}</label>
								<div class="table-responsive">
									<table class="table table-bordered table-hover table-striped one-table" id="table1">
										<thead>
											<tr>
												<th style="width:18%">{{ __('messages.position') }}</th>
												<th style="width:18%">{{ __('messages.job') }}</th>
												<th style="width:18%">{{ __('messages.grade') }}</th>
												<th style="width:18%">{{ __('messages.employee_classification') }}</th>
												<th style="width:15%">{{ __('messages.use_sheet') }}</th>
												<th style="width:13%">{{ __('messages.implement_times') }}</th>
											</tr>
										</thead>
										<tbody >
											@include('OneOnOne::oi1020.refer')
										</tbody>
									</table>
								</div><!-- end .table-responsive -->
							</div>
						</div>
					</div>
					<div class="row mt-10">
						<div class="col-md-2 col-xl-2">
							<div class="form-group">
								<label class="control-label">{{ __('messages.coach') }}</label>
								<div class="input-group-btn input-group div_employee_cd">
									<span class="num-length">
										<input type="hidden" class="employee_cd_hidden " id="coach_cd" value="" />
										<input type="text"  class="form-control indexTab  employee_nm_1on1 " tabindex="3" maxlength="101" value="" style="padding-right: 40px;" />
									</span>
									<div class="input-group-append-btn">
										<button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
							</div>
						</div>

						<div class="col-md-10">
							<div class="form-group" >
								<label class="control-label">{{ __('messages.implement_month') }}</label>
								<div class="input-group date_responsive">
									<div class="gflex">
										<div class="input-group-btn input-group" style="width: 160px">
											<input type="text" class="form-control input-sm date right-radius " id="date_from" placeholder="yyyy/mm/dd" tabindex="4">
											<div class="input-group-append-btn">
												<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
											</div>
										</div>
									</div><!-- end .gflex -->
									<span class="input-group-text">
										<div class="">~</div>
									</span>
									<div class="gflex">
										<div class="input-group-btn input-group" style="width: 160px">
											<input type="text" class="form-control input-sm date right-radius " id="date_to" placeholder="yyyy/mm/dd" tabindex="5">
											<div class="input-group-append-btn">
												<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
											</div>
										</div>
									</div><!-- end .gflex -->
								</div><!-- /.input-group -->
							</div>
						</div>
					</div>
					<div class="row mt-10">
						<div class="col-md-2">
							<div class="form-group">
								<label class="control-label">{{ __('messages.member') }}</label>
								<div class="input-group-btn input-group div_employee_cd">
									<span class="num-length">
										<input type="hidden" class="employee_cd_hidden" id="member_cd" value="" />
										<input type="text"  class="form-control indexTab employee_nm_1on1" tabindex="5" maxlength="101"   value="" style="padding-right: 40px;" />
									</span>
									<div class="input-group-append-btn">
										<button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
							</div>
						</div>
						<input type="hidden" id="count_organization" value="{{count($organization_group)}}">
						@if(isset($organization_group[0]) && !empty($organization_group[0]))
							<div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
								<div class="form-group">
									<label class="control-label text-overfollow" data-toggle="tooltip"
										data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="margin-bottom: 0px;width:100%">
										{{$organization_group[0]['organization_group_nm']}}
									</label>
										<div class="multi-select-full">
											<select autocomplete="off"  name="" id="organization_step1" class="form-control organization_cd1 multiselect" tabindex="6" organization_typ='1' multiple="multiple">
												@foreach($combo_organization as $row)
													<option value="{{$row['organization_cd_1']}}" >{{$row['organization_nm']}}</option>
												@endforeach
											</select>
										</div>
								</div>
								<!--/.form-group -->
							</div>
							@foreach($organization_group as $dt)
								@if($dt['organization_typ'] >=2)
									<div class="col-sm-6 col-md-3 col-lg-2 col-xl-2">
										<div class="form-group">
											<label class="control-label text-overfollow" data-toggle="tooltip"
											data-original-title="{{$dt['organization_group_nm']}}" style="margin-bottom: 0px;width:100%">
												{{$dt['organization_group_nm']}}
											</label>
											<div class="multi-select-full">
												<select autocomplete="off"  name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}} multiselect" tabindex="6" organization_typ = "{{$dt['organization_typ']}}" multiple="multiple">
												</select>
											</div>
										</div>
										<!--/.form-group -->
									</div>
								@endif
							@endforeach
						@endif
						<div class="col-md-2">
							<div class="form-group" style="margin-bottom: 0px;">
								<label class="control-label">{{ __('messages.position') }}</label>
								<span class="num-length">
									<div class="input-group-btn">
										<select autocomplete="off"   id="position_cd" class="form-control" placeholder="" value="" maxlength="20" tabindex="9">
											<option value="-1"></option>
											@if(isset($combo_position[0]) && !empty($combo_position[0]))
												@foreach ($combo_position as $item)
													<option value="{{$item['position_cd']}}">{{$item['position_nm']}}</option>
												@endforeach
											@endif
										</select>
										<div class="input-group-append-btn">
										</div>
									</div>
								</span>
							</div>
						</div>

						<div class="col-md-2 col-xl-2" style="margin-left: auto">
							<div class="form-group" style="margin-bottom: 0px;float: right;position: initial;">
								<label class="control-label">&nbsp;</label>
								<div class="input-group-btn input-group div_employee_cd">
									<div class="form-group text-right">
										<div class="full-width">
											<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="10" >
												<i class="fa fa-search"></i>
												{{ __('messages.search') }}
											</a>
										</div><!-- end .full-width -->
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
    	<div class="card" id="table__result">
			<div class="error__empty">
				{{ $_text[21]['message'] }}
			</div>
		</div>

	</div><!-- end .card-body -->
</div><!-- end .card -->
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
<input type="file" id="import_file" style="display: none" accept=".csv">
@stop
