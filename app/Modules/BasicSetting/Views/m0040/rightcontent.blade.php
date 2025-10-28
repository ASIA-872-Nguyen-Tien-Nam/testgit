<div class="row">
	<div class="col-md-1 ln-1">					
		<div class="form-group">
			<label class="control-label ">{{__('messages.code')}}</label>
			<span class="num-length">
				<input type="text" class="form-control" tabindex="1" maxlength="3" id="position_cd" value="" disabled=""/>
			</span>
		</div><!--/.form-group -->
	</div>
    <div class="col-md-8 col-lg-9">					
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.job_title')}} </label>
			<span class="num-length">
				<input type="text" class="form-control required" tabindex="1" maxlength="50" id="position_nm" value="" />
			</span>
		</div><!--/.form-group -->
	</div>
</div>

<div class="row">
	<div class="col-md-6">					
		<div class="form-group">
			<label class="control-label">{{ __('messages.position_abbreviation')}}</label>
			<span class="num-length">
				<input type="text" id="position_ab_nm" class="form-control" tabindex="2" maxlength="10" value="" />
			</span>
		</div>
	</div>
	<div class="col-md-1 ln-1">					
		<div class="form-group">
			<label class="control-label">{{ __('messages.rank_order')}}</label>
			<span class="num-length">
				<input type="text" id="arrange_order" class="form-control only-number" tabindex="3" maxlength="4" value="" />
			</span>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-11">
		<div class="form-group">
			<label class="control-label">{{ __('messages.import_cd') }}</label>
			<span class="num-length">
				<textarea type="text" class="form-control" tabindex="4" style="height: 130px" id="import_cd" maxlength="255" value=""></textarea>
			</span>
		</div>
	</div>
</div>