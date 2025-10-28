@extends('popup')

@push('header')
    {!! public_url('template/css/popup/eq0100.index.css') !!}
@endpush

@section('asset_footer')
    {!!public_url('template/js/common/bootstrap_multiselect.js')!!}
    {!!public_url('template/js/common/uniform.min.js')!!}
    {!! public_url('template/js/popup/eq0100.index.js') !!}
@stop
<script>
        var display = '{{ __('messages.display_attribute_info') }}';
        var employee_information_output = '{{ __('messages.employee_information_output') }}';
    </script>
@section('content')
<div class="row" style="margin-top: 10px">
    <div class="col-md-12">
        <div style="margin-bottom: 5px">
        {{__('messages.please_output')}}
        </div>
        <div class="table-responsive table-popup" style="height:414px;margin-bottom: 15px ">
            <table class="table table-bordered table-hover ofixed-boder" style="max-width: 423px;max-height:300px" id="table_popup">
                <thead>
                    <tr class="tr_checkall active">
                        <td class="header" style="font-weight: 700">
                            <label for="ckb_all" class="lbl-text">
                                {{__('messages.select_all')}}
                            </label>
                        </td> 
                        <td style="text-align: center;">
                            <div class="md-checkbox-v2 checkbox-div">
                                <input name="1" id="check-all" type="checkbox" value="" class="chk-all" tabindex="15">
                                <label class="label-error container"style="min-width: 100%" for="check-all"></label>
                            </div>
                        </td>
                    </tr>
                </thead>
                <tbody id="main">
                    @if(checkM0070TabIsUsed('M0070_01', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.employee_information_2_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-1" type="checkbox" value="1" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-1"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_02', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.credentials_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-2" type="checkbox" value="2" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-2"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.personnel_assessment')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-14" type="checkbox" value="3" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-14"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_03', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.training_history_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-3" type="checkbox" value="4" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-3"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_04', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.work_history_inf_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-4" type="checkbox" value="5" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-4"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_05', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.academic_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-5" type="checkbox" value="6" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-5"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_06', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.contact_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-6" type="checkbox" value="7" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-6"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_07', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.commute_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-7" type="checkbox" value="8" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-7"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_08', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.family_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-8" type="checkbox" value="9" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-8"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_09', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.leave_of_absence_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-9" type="checkbox" value="10" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-9"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_10', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.fixed_term_employment_contract_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-10" type="checkbox" value="11" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-10"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_11', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.social_insurance_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-11" type="checkbox" value="12" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-11"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_12', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.tab_salary')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-12" type="checkbox" value="13" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-12"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                    @if(checkM0070TabIsUsed('M0070_13', 1))
                    <tr class="pop_tr active list_check_display">
                        <td class="multi-select-lb" style="font-size: 0.875rem;">
                            <div class="text-overfollow header-overfollow" style="width:340px;max-width: 340px !important;">
                            {{__('messages.reward_and_punishment_information_tab')}}
                            </div>
                        </td>
                        <td style="text-align: center;">
						<div class="md-checkbox-v2 checkbox-div">
							<input name="1" id="chk-item-13" type="checkbox" value="14" class="chk-item" tabindex="15">
							<label class="label-error container"style="min-width: 100%" for="chk-item-13"></label>
						</div>
					    </td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="row">
    <div class="full-width text-center">
        <button class="btn-menu-show btn btn-outline-primary" id="output_excel" tabindex="15">
            <i class="fa fa-print"></i>
            {{__('messages.output')}}
        </button>
    </div>
</div>
@stop
<input type="hidden" class="anti_tab" name="">