@extends('slayout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/BasicSetting/o0100/o0100.index.css')!!}
@stop

@section('asset_footer')
<script>
	var office_master = '{{ __('messages.office_master') }}';
	var organization_master = '{{ __('messages.organization_master') }}';
	var job_mater = '{{ __('messages.job_mater') }}';
	var position_master = '{{ __('messages.position_master') }}';
	var grade_master = '{{ __('messages.grade_master') }}';
	var employee_classification_master = '{{ __('messages.employee_classification_master') }}';
	var employee_master = '{{ __('messages.employee_master_default') }}';
	var employee_transfer_history_master = '{{ __('messages.employee_transfer_history_master') }}';
	var optional_info = '{{ __('messages.optional_info') }}';
	var mail_password = '{{ __('messages.mail_password') }}';
	var employee_setting_info = '{{ __('messages.employee_setting_info') }}';
	var employee_setting_qualification = '{{ __('messages.employee_setting_qualification') }}';
	var employee_setting_academic = '{{ __('messages.employee_setting_academic') }}';
	var employee_setting_contact = '{{ __('messages.employee_setting_contact') }}';
	var employee_setting_work = '{{ __('messages.employee_setting_work') }}';
	var employee_setting_family = '{{ __('messages.employee_setting_family') }}';
	var employee_setting_leave = '{{ __('messages.employee_setting_leave') }}';
	var employee_setting_contract = '{{ __('messages.employee_setting_contract') }}';
	var employee_setting_social_insurance = '{{ __('messages.employee_setting_social_insurance') }}';
	var employee_setting_salary = '{{ __('messages.employee_setting_salary') }}';
	var employee_setting_training_history = '{{ __('messages.employee_setting_training_history') }}';
	var employee_setting_work_history = '{{ __('messages.employee_setting_work_history') }}';
	var export_all = '{{ __('messages.export_all') }}';
	var employee_setting_rewards = '{{ __('messages.employee_setting_rewards') }}';
	var employee_add = '{{ __('messages.optional_info') }}';
	var error = '{{ __('messages.error') }}';
</script>
<!-- START LIBRARY JS -->
{!!public_url('template/js/basicsetting/o0100/o0100.index.js')!!}
@stop
@push('asset_button')
{!!
Helper::buttonRender(['dataInputButton','dataOutoutButton','backButton'])
!!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-3" >
					<div class="form-group">
						<label class="control-label">{{ __('messages.target_data') }}</label>
						<select name="" id="table_key" class="form-control" tabindex="1" style=" min-width: 300px;">
							{{--<option value=''></option>--}}
							<option value='1'>{{ __('messages.star') }}{{ __('messages.office_master') }}</option>
							<option value='2'>{{ __('messages.star') }}{{ __('messages.organization_master') }}</option>
							<option value='3'>{{ __('messages.star') }}{{ __('messages.job_mater') }}</option>
							<option value='4'>{{ __('messages.star') }}{{ __('messages.position_master') }}</option>
							<option value='5'>{{ __('messages.star') }}{{ __('messages.grade_master') }}</option>
							<option value='6'>{{ __('messages.star') }}{{ __('messages.employee_classification_master') }}</option>
							<option value='7'>{{ __('messages.star') }}{{ __('messages.employee_master_default') }}</option>
							<option value='10'>{{ __('messages.star') }}{{ __('messages.mail_password') }}</option>
							<option value='8'>{{ __('messages.employee_transfer_history_master') }}</option>
							@if(checkM0070TabIsUsed('M0070_01'))
							<option value='11' data-auth="{{ checkM0070TabIsUsed('M0070_01') }}">{{ __('messages.employee_master') }} ({{ __('messages.employee_information_2_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_02'))
							<option value='12' data-auth="{{ checkM0070TabIsUsed('M0070_02') }}">{{ __('messages.employee_master') }} ({{ __('messages.credentials_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_03'))
							<option value='21' data-auth="{{ checkM0070TabIsUsed('M0070_03') }}">{{ __('messages.employee_master') }} ({{ __('messages.training_history_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_04'))
							<option value='22' data-auth="{{ checkM0070TabIsUsed('M0070_04') }}">{{ __('messages.employee_master') }} ({{ __('messages.work_history_infor') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_05'))
							<option value='13' data-auth="{{ checkM0070TabIsUsed('M0070_05') }}">{{ __('messages.employee_master') }} ({{ __('messages.academic_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_06'))
							<option value='14' data-auth="{{ checkM0070TabIsUsed('M0070_06') }}">{{ __('messages.employee_master') }} ({{ __('messages.contact_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_07'))
							<option value='15' data-auth="{{ checkM0070TabIsUsed('M0070_07') }}">{{ __('messages.employee_master') }} ({{ __('messages.commute_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_08'))
							<option value='16' data-auth="{{ checkM0070TabIsUsed('M0070_08') }}">{{ __('messages.employee_master') }} ({{ __('messages.family_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_09'))
							<option value='17' data-auth="{{ checkM0070TabIsUsed('M0070_09') }}">{{ __('messages.employee_master') }} ({{ __('messages.leave_of_absence_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_10'))
							<option value='18' data-auth="{{ checkM0070TabIsUsed('M0070_10') }}">{{ __('messages.employee_master') }} ({{ __('messages.fixed_term_employment_contract_information_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_11'))
							<option value='19' data-auth="{{ checkM0070TabIsUsed('M0070_11') }}">{{ __('messages.employee_master') }} ({{ __('messages.social_insurance_tab') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_12'))
							<option value='20' data-auth="{{ checkM0070TabIsUsed('M0070_12') }}">{{ __('messages.employee_master') }} ({{ __('messages.salary_1') }})</option>
							@endif
							@if(checkM0070TabIsUsed('M0070_13'))
							<option value='24' data-auth="{{ checkM0070TabIsUsed('M0070_13') }}">{{ __('messages.employee_master') }} ({{ __('messages.reward_and_punishment_information_tab') }})</option>
							@endif
							<option value='9'>{{ __('messages.optional_info') }}</option>
							<option value='23'>{{ __('messages.output_all_export_only') }}</option>
						</select>
						<div class="control-label only_show_mobile label_common " style="margin-top:8px">
							{{__('messages.star')}}：{{__('messages.common_item')}}
						</div>
					</div><!--/.form-group -->
				</div><!-- end .col-md-3 -->
				<div class="col-md-6 only_show_pc label_common" >
				<div class="form-group">
				<label class="control-label">&nbsp</label>
				<div class="control-label" style="margin-top:8px">
					{{__('messages.star')}}：{{__('messages.common_item')}}
				</div>
				
				</div>
				</div>
			</div><!-- end .row -->

			<div class="row">
				<div class="col-md-5" style="position:relative">
				   <input type="hidden" id="text_no_file" value="{{__('messages.no_file_chosen')}}"/>
					<div class="form-group" style="position:absolute;z-index:-1">
						<input type="file" class="form-control" id="import_file" placeholder="" maxlength="100" accept=".csv" tabindex="2">
					</div>
					<div class="form-group form-control lh-input-custom " tabindex="0">
						<div class="fake_input"><button class="ln-btn-input">{{__('messages.choose_file')}}</button><span class="ln-text-file">{{__('messages.no_file_chosen')}}</span></div>
					</div>
				</div>
			</div>
		</div><!-- end .card-body -->
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
@stop
