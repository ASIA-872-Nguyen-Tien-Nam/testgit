@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/i1030.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
<script>
	var emp_del = [];
</script>
{!!public_url('template/js/common/ansplugin.js')!!}
{!!public_url('template/js/form/i1030.index.js')!!}
@stop
@push('asset_button')
    {!!
        Helper::buttonRender(['saveButton','backButton'])
    !!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<input type="hidden" class="anti_tab" name="">
	<div class="card">
		@include('Master::i1030.header_content')
		<div class="row mg_row">
			<div class="col-md-12" style="margin-left: 10px;margin-top: -10px">
				<div class="form-group">
					<div class="full-width text-right">
						<a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_search" tabindex="4">
							<i class="fa fa-user-o"></i>
							{{ __('messages.extract_employee') }}
						</a>
						<a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_add" tabindex="5">
							<i class="fa fa-user-plus"></i>
							{{ __('messages.add_employee') }}
						</a>
						<a href="javascript:;" class="btn vt-3" id="btn_delete" tabindex="6">
							<i class="fa fa-user-times"></i>
							{{ __('messages.delete_employee') }}
						</a>
						<a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_csv_output" tabindex="7">
							<i class="fa fa-upload "></i>
							{{ __('messages.output_csv') }}
						</a>
						<a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_evaluation_import" tabindex="8">
							<i class="fa fa-download"></i>
							{{ __('messages.import_rater') }}
						</a>
						<a href="javascript:;" class="btn btn-key-primary vt-3" id="btn_apply_latest" tabindex="9">
							<i class="fa fa-check"></i>
							{{ __('messages.apply_pa_flow_setting') }}
						</a>
					</div><!-- end .full-width -->
				</div>
			</div>
	</div><!-- end .card -->
	<div class="hide">
		<table class="table table-bordered table-hover" id="table_data">
			<tbody>
			<tr class="tr_first">
				<input type="hidden" class="row_employee_cd" value=""/>
				<td class="sticky-cell text-center">
					<div class="md-checkbox-v2 inline-block lb">
						<input name="ckb" id="ckb" class="checkbox_row" type="checkbox" tabindex="10">
						<label for="ckb"></label>
					</div>
				</td>
				<td class="sticky-cell" style="min-width:100px">
                	<span class="num-length">
                        <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
							<input type="hidden"/>
                                <span class="num-length">
                                    <input type="hidden" class="rater_employee_cd" value="" />
                                    <input type="text" class="form-control indexTab add_emp add_employee_cd error_rater_emp_5 min-width emp_nm" id="employee_cd" tabindex="10" maxlength="20" old_rater_employee_nm=""
										   value="" style="padding-right: 40px;"/>
                                </span>
							<div class="input-group-append-btn">
								<button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2">
									 <i class="fa fa-search"></i>
								</button>
							</div>
						</div>
                    </span>
				</td>
				<td class="sticky-cell"></td>
				<td></td>
				@foreach($M0022 as $item)
                <th></th>
                @endforeach
				<td></td>
				<td></td>
				<td></td>
				<td class="{{ $Rater['Rater1']??''}} td_rate1">
                    <span class="num-length">
                        <div class="input-group-btn">
							<input type="text" class="form-control" maxlength="20" value="" readonly="readonly">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button">
									<i class="fa fa-search"></i>
								</button>
							</div>
						</div>
                    </span>
				</td>
				<td class="{{ $Rater['Rater2']??''}} td_rate2">
                    <span class="num-length">
                        <div class="input-group-btn">
							<input type="text" class="form-control" maxlength="20" value="" readonly="readonly">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button">
									<i class="fa fa-search"></i>
								</button>
							</div>
						</div>
                    </span>
				</td>
				<td class="{{ $Rater['Rater3']??''}} td_rate3">
                    <span class="num-length">
                        <div class="input-group-btn">
							<input type="text" class="form-control" maxlength="20" value="" readonly="readonly">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button">
									<i class="fa fa-search"></i>
								</button>
							</div>
						</div>
                    </span>
				</td>
				<td class="{{ $Rater['Rater4']??''}} td_rate4">
                    <span class="num-length">
                        <div class="input-group-btn">
							<input type="text" class="form-control" maxlength="20" value="" readonly="readonly">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button">
									<i class="fa fa-search"></i>
								</button>
							</div>
						</div>
                    </span>
				</td>
				<td></td>
				<td>
					<select name="" id="" class="form-control input-sm" readonly="readonly">
					</select>
				</td>
			</tr>

			</tbody>
		</table>
	</div>
	<!-- <div class="row mg_row"> -->
	<div id="card_import" class="card">
		@include('Master::i1030.list_content')
	</div>
</div><!-- end .container-fluid -->
<template id="refer-table">
	 <div class="card-body">
        <div class="row">
            <div class="col-md-12 ">
                <div class="wmd-view-topscroll">
                    <div class="scroll-div1"></div>
                </div>
            </div>
        </div><!-- end .row -->
        <div class="wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
            <table class="table sortable table-bordered table-hover fixed-header" id="table_result">
                <thead>
            <tr>
                <th class="text-center">
                    <div class="md-checkbox-v2 inline-block lb">
                        <input name="ckball" id="ckball" class="" type="checkbox" tabindex="10">
                        <label for="ckball"></label>
                    </div>
                </th>
                <th class="min-w90px">{{ __('messages.employee_no') }}</th>
                <th class="min-w90px">{{ __('messages.employee_name') }}</th>
                <th class="min-w90px">{{ __('messages.employee_classification') }}</th>
                <th class="min-w90px">{{ __('messages.department') }}</th>
                <th class="min-w90px">{{ __('messages.division') }}</th>
                <th class="min-w90px">{{ __('messages.job') }}</th>
                <th class="min-w90px">{{ __('messages.position') }}	</th>
                <th class="min-w90px">{{ __('messages.grade') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater1']:'' }}">{{ __('messages.1st_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater2']:'' }}">{{ __('messages.2nd_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater3']:'' }}">{{ __('messages.3rd_rater') }}</th>
                <th class="min-w90px {{ isset($list[0])?$Rater['Rater4']:'' }}">{{ __('messages.4th_rater') }}</th>
                <th colspan="2" class="min-w350px">{{ __('messages.evaluation_sheet') }}</th>
            </tr>
            </thead>
            <tbody id="list"></tbody>
        </table>
		<input type="file" id="import_file" style="display: none" accept=".csv">
    </div><!-- end .table-responsive -->
</template>
<template id="row2">
	<tr class="tr_first tr-odd" row_emp="">
		<input type="hidden" class="number" value="{-{$key}-}"/>
		<input type="hidden" class="key_emp" value="{-{$row['employee_cd']}-}"/>
		<input type="hidden" class="row_number" value="{-{$row['row_number']}-}"/>
		<input type="hidden" class="key_group_cd" value="{-{$row['group_cd']}-}"/>
		<input type="hidden" class="treatment_applications_no_b" value="{-{$row['treatment_applications_no']}-}"/>
		<td class="td_sheet_cd col14" style="min-width:150px">
		    {-{$row['sheet_nm1']}-}
		</td>
		<td class="col15">
		    <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_b" sheet_cd_f0032="{-{  $row['sheet_cd_f0032'] }-}">
		        <option value="-1"></option>
		    </select>
		</td>
	</tr>
</template>
<template id="refer-row">
	<tr class="tr_first tr-odd first-em-cd" row_emp="">
	    <input type="hidden" class="number" value=""/>
	    <input type="hidden" class="pos_emp" value=""/>
	    <input type="hidden" class="key_emp" value=""/>
	    <input type="hidden" class="key_group_cd" value=""/>
	    <input type="hidden" class="treatment_applications_no_a" value=""/>
	    <input type="hidden" class="row_number" value=""/>
	    <input type="hidden" class="row_span" value=""/>
	    <input type="hidden" class="rater_employee_nm_1" value=""/>
	    <input type="hidden" class="rater_employee_nm_2" value=""/>
	    <input type="hidden" class="rater_employee_nm_3" value=""/>
	    <input type="hidden" class="rater_employee_nm_4" value=""/>

	    <td class="text-center lblCheck col1" rowspan="">
	        <div class="md-checkbox-v2 inline-block lb">
	            <input name="ckb0" id="ckb0" class="checkbox_row" type="checkbox">
	            <label for="ckb0"></label>
	        </div>
	    </td>
	    <td class="min-w30px col2" rowspan="">
	        {-{ $row['employee_cd'] }-}
	    </td>
	    <td class="min-w90px col3" rowspan="">
	        {-{ $row['employee_nm'] }-}
	    </td>
	    <td class="min-w90px col4" rowspan="">
	        <input type="hidden" class="r_employee_typ" value=""/>
	        <input type="hidden" class="r_employee_typ_nm" value=""/>
	    </td>
	    <td class="min-w90px col5" rowspan="">
	        <input type="hidden" class="r_belong_cd1" value=""/>
	        <input type="hidden" class="r_organization_nm1" value=""/>
	    </td>
	    <td class="min-w90px col6" rowspan="">
	        <input type="hidden" class="r_belong_cd2" value=""/>
	        <input type="hidden" class="r_organization_nm2" value=""/>
	    </td>
	    <td class="min-w90px col7" rowspan="">
	        <input type="hidden" class="r_job_cd" value=""/>
	        <input type="hidden" class="r_job_nm" value=""/>
	    </td>
	    <td class="min-w90px col8" rowspan="">
	        <input type="hidden" class="r_position_cd" value=""/>
	        <input type="hidden" class="r_position_nm" value=""/>
	    </td>
	    <td class="min-w30px col9" rowspan="">
	        <input type="hidden" class="r_grade" value=""/>
	        <input type="hidden" class="r_grade_nm" value=""/>
	    </td>
	    <td class="min-w200px col10" rowspan="">
	        <span class="num-length">
	             <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
	                    <span class="num-length">
	                        <input type="hidden" class="rater_employee_cd rater_employee_cd_1" value="{-{ $row['rater_employee_cd_1'] }-}" />
	                        <input type="text" class="form-control indexTab rate_emp rater_employee_nm_1 error_rater_emp_1 min-width" tabindex="1" maxlength="101" old_rater_employee_nm="" value="" style="padding-right: 40px;" />
	                    </span>
	                 <div class="input-group-append-btn">
	                     <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="1">
	                         <i class="fa fa-search"></i>
	                     </button>
	                 </div>
	             </div>
	        </span>
	    </td>
	    <td class="min-w200px col11" rowspan="">
	        <span class="num-length">
	             <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
	                    <span class="num-length">
	                        <input type="hidden" class="rater_employee_cd rater_employee_cd_2" value="" />
	                        <input type="text" class="form-control indexTab rate_emp rater_employee_nm_2 error_rater_emp_2 min-width" id="employee_cd" tabindex="1" maxlength="101" old_rater_employee_nm=""
	                        value="" style="padding-right: 40px;"/>
	                    </span>
	                 <div class="input-group-append-btn">
	                     <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="2">
	                         <i class="fa fa-search"></i>
	                     </button>
	                 </div>
	             </div>
	        </span>
	    </td>
	    <td class="min-w200px col12" rowspan="">
	        <span class="num-length">
	             <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
	                    <span class="num-length">
	                         <input type="hidden" class="rater_employee_cd rater_employee_cd_3" value="" />
	                        <input type="text" class="form-control indexTab rate_emp rater_employee_nm_3 error_rater_emp_3" min-width id="employee_cd" tabindex="1" maxlength="101" old_rater_employee_nm=""
	                            value="" style="padding-right: 40px;" />
	                    </span>
	                 <div class="input-group-append-btn">
	                     <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="3">
	                         <i class="fa fa-search"></i>
	                     </button>
	                 </div>
	             </div>
	        </span>
	    </td>
	    <td class="min-w200px col13" rowspan=""rowspan="">
	        <span class="num-length">
	             <div class="input-group-btn input-group div_employee_cd" style="max-width: 230px">
	                    <span class="num-length">
	                         <input type="hidden" class="rater_employee_cd rater_employee_cd_4" value="" />
	                        <input type="text" class="form-control indexTab rate_emp rater_employee_nm_4 error_rater_emp_4 min-width" id="employee_cd" tabindex="1" maxlength="101" old_rater_employee_nm=""
	                            value="" style="padding-right: 40px;" />
	                    </span>
	                 <div class="input-group-append-btn">
	                     <button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1" rater="4">
	                         <i class="fa fa-search"></i>
	                     </button>
	                 </div>
	             </div>
	        </span>
	    </td>
	    <td class="td_sheet_cd col14 col-x" style="min-width:150px">
	        {-{$row['sheet_nm1']}-}
	    </td>
	    <td class="col15 col-x">
	        <select name="" id="" class="form-control input-sm err_sheet_cd sheet_cd_a" sheet_cd_f0032="">
	            <option value="-1"></option>
	        </select>
	    </td>
	</tr>

</template>
<template id="sheetX">
	@if (isset($sheetX) && !empty($sheetX))
		@foreach ($sheetX as $item)
			<option value="{{$item['sheet_cd']}}">{{$item['sheet_nm']}}</option>
		@endforeach
	@endif
</template>
@stop