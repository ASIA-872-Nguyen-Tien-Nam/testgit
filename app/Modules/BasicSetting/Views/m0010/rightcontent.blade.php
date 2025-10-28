
<div class="row">
    <div class="col-md-1 ln-1">
        <div class="form-group">
            <label class="control-label ">{{ __('messages.code') }}</label>
            <span class="num-length">
                <input type="text" id="office_cd" class="form-control " maxlength="3"  tabindex="1" value="" disabled="">
            </span>
        </div><!--/.form-group -->
	</div>
	<div class="col-lg-10 col-md-8">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.office_name') }}</label>
			<span class="num-length">
				<input type="text" id="office_nm" class="form-control required" maxlength="50"  tabindex="1" value="">
			</span>
		</div><!--/.form-group -->
	</div>
</div>

<div class="row">
	<div class="col-md-6">
		<div class="form-group">
			<label class="control-label">{{ __('messages.abbreviation') }}</label>
				<span class="num-length">
					<input type="text" id="office_ab_nm" class="form-control office_ab_nm" maxlength="20" tabindex="2" value="">
				</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row div-zip-cd">
	<div class="col-md-4 col-lg-2">
		<div class="form-group">
			<label class="control-label">{{ __('messages.address') }}</label>
			<span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" id="zip_cd" class="form-control" placeholder="001-0001" maxlength="7" tabindex="3" value="">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled="">〒</button>
					</div>
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
	<div class="col-lg-10 col-md-8">
		<div class="form-group">
			<label class="control-label">&nbsp</label>
			<span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" id="address1" class="form-control prefecture" maxlength="100" tabindex="4" value="">
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
					<input type="text" id="address2" class="form-control" maxlength="100" tabindex="5"value="">
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
					<input type="text" id="address3" class="form-control" maxlength="100" tabindex="6">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-map-marker"></i></button>
					</div>
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-4 col-lg-3">
		<div class="form-group">
			<label class="control-label">{{ __('messages.phone_number') }}</label>
			<span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" id="tel" class="form-control tel-haifun" maxlength="20" tabindex="7" value="">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
					</div>
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
	<div class="col-md-4 col-lg-3">
		<div class="form-group">
			<label class="control-label">{{ __('messages.fax_number') }}</label>
			<span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" id="fax" class="form-control tel-haifun" maxlength="20" tabindex="8" value="">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
					</div>
				</div>
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-6 col-lg-3">
		<div class="form-group">
			<label class="control-label">{{ __('messages.person_in_charge') }}
			</label>
			<div class="input-group-btn input-group div_employee_cd">
				<span class="num-length">
					<input type="hidden" class="employee_cd_hidden" id="employee_cd" />
					<input type="text" id="employee_nm" class="form-control indexTab employee_nm" tabindex="9" maxlength="20" value="" style="padding-right: 40px;" />
				</span>
				<div class="input-group-append-btn">
					<button class="btn btn-transparent btn_employee_cd_popup" type="button" tabindex="-1">
						<i class="fa fa-search"></i>
					</button>
				</div>
			</div>
		</div>

	</div>
	<div class="col-md-3 col-lg-1 ln-1">
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<span class="num-length">
				<input tabindex="10" type="text" id="arrange_order" class="form-control only-number" placeholder="" maxlength="4" value="">
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<input type="hidden" id="mode" value="A"/>