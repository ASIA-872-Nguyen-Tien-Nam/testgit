<div class="row">
	<div class="col-lg-2 col-xl-1 col-xs-4">
		<div class="form-group">
			<label class="control-label ">{{__('messages.code')}}</label>
			<span class="num-length">
				<input type="text" id="employee_typ" class="form-control indexTab " tabindex="1" maxlength="3" value="{{ $employee_typ ?? '' }}" disabled=""/>
			</span>
		</div>
		<!--/.form-group -->
	</div>
    <div class="col-lg-7 col-xl-8 col-xs-6 ">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.classification_name')}}</label>
			<span class="num-length">
				<input type="text" id="employee_typ_nm" class="form-control indexTab required" tabindex="1" maxlength="50" value="{{ $employee_typ_nm ?? '' }}" />
			</span>
		</div>
		<!--/.form-group -->
	</div>
	<div class="col-lg-3 col-xl-2 col-xs-2">
		<div class="form-group">
			<label class="control-label ">{{__('messages.sort_order')}}</label>
			<span class="num-length">
				<input type="text" id="arrange_order" class="form-control only-number" tabindex="2" maxlength="4" value="{{ $arrange_order ?? '' }}"/>
			</span>
		</div>
		<!--/.form-group -->
	</div>
</div><!-- end .row -->
<div class="row deploy">
    <div class="col-lg-11">
		<div class="form-group">
			<label class="control-label">{{ __('messages.import_cd') }}</label>
			<span class="num-length">
				<textarea type="text" class="form-control" tabindex="4" style="height: 130px;" id="import_cd" maxlength="255" value="{{$import_cd??''}}"></textarea>
			</span>
		</div>
	</div>
</div>