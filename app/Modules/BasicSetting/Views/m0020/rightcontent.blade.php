<nav aria-label="breadcrumb">
  <ol id="breadcrumbX" class="breadcrumb"></ol>
</nav>
<div class="row deploy" >
	<div class="col-md-3" style="max-width: 220px;">
		<div class="form-group">
			<label class="control-label"> {{ __('messages.code') }}</label>
			<span class="num-length">
				<input type="text" class="form-control " tabindex="1" maxlength="3"  id="organization_cd" value="" disabled=""/>
			</span>
		</div><!--/.form-group -->
	</div>
    <div class="col-md-7 ln-7">
		<div class="form-group">
			<label class="control-label lb-required " lb-required="{{ __('messages.required') }}">{{ __('messages.ogr_name') }}</label>
			<span class="num-length">
				<input type="text" class="form-control required" tabindex="1" maxlength="50"  id="organization_nm" value="" />
			</span>
		</div><!--/.form-group -->
	</div>

</div>
<div class="row deploy">
    <div class="col-lg-6 ln-6c">
		<div class="form-group">
			<label class="control-label">{{ __('messages.org_abbreviation') }}</label>
			<span class="num-length">
				<input type="text" class="form-control" id="organization_ab_nm" tabindex="2" maxlength="10" value="" />
			</span>
		</div>
	</div>
	<div class="col-lg-3 ln-3">
		<div class="form-group">
			<label class="control-label">{{ __('messages.person_in_charge') }}</label>
			<span class="num-length">
				<div class="input-group-btn input-group div_employee_cd">
					<span class="num-length">
						<input type="hidden" class="employee_cd_hidden employee_cd" id="responsible_cd" />
						<input type="text" id="employee_nm" class="form-control indexTab employee_nm " tabindex="3" maxlength="20" value="" style="padding-right: 40px;" />
					</span>
					<div class="input-group-append-btn">
						<button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
							<i class="fa fa-search"></i>
						</button>
					</div>
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
	<div class="col-lg-1 ln-1">
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order_m0020') }}</label>
			<span class="num-length">
				<div class="input-group">
					<input type="text" class="form-control only-number" id="arrange_order" placeholder="" tabindex="4" maxlength="4" value="">
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row deploy">
    <div class="col-lg-11">
		<div class="form-group">
			<label class="control-label">{{ __('messages.import_cd') }}</label>
			<span class="num-length">
				<textarea type="text" class="form-control" tabindex="4" style="height: 130px;" id="import_cd" maxlength="255" value=""></textarea>
			</span>
		</div>
	</div>
</div>
<input type="hidden" id="organization_typ" value="1">
<input type="hidden" id="organization_cd_1">
<input type="hidden" id="organization_cd_2">
<input type="hidden" id="organization_cd_3">
<input type="hidden" id="organization_cd_4">
<input type="hidden" id="organization_cd_5">
<input type="hidden" id="same_level" value="0">
<input type="hidden" id="editing" value="0">