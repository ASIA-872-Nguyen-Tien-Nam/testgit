<div class="row">
	<div class="col-md-1 ln-1">					
		<div class="form-group">
			<label class="control-label ">{{ __('messages.code') }}</label>
			<span class="num-length">
				<input type="text" class="form-control " tabindex="1" maxlength="3" id="job_cd" value="" disabled=""/>
			</span>
		</div><!--/.form-group -->
	</div>
    <div class="col-md-9 col-lg-10">					
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.job_name') }}</label>
			<span class="num-length">
				<input type="text" class="form-control required" tabindex="1" maxlength="50" id="job_nm" value="" />
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-6">					
		<div class="form-group">
			<label class="control-label">{{ __('messages.job_abbreviation') }} </label>
			<span class="num-length">
				<input type="text" id="job_ab_nm" class="form-control" tabindex="2" maxlength="10" value="" />
			</span>
		</div>
	</div>
	<div class="col-md-1 ln-1">					
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<span class="num-length">
				<input type="text" id="arrange_order" class="form-control only-number" tabindex="3" maxlength="4" value="" />
			</span>
		</div>
	</div>
</div>