<div class="row">
	<div class="col-md-3" style="max-width: 220px;">					
		<div class="form-group">
			<label class="control-label ">{{ __('messages.code') }}</label>
			<span class="num-length">
				<input type="text" class="form-control " tabindex="1" maxlength="3" id="training_cd" value="" disabled=""/>
			</span>
		</div><!--/.form-group -->
	</div>
    <div class="col-md-7">					
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.training_name') }}</label>
			<span class="num-length">
				<input type="text" class="form-control required" tabindex="1" maxlength="50" id="training_nm" value="" />
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-3">
		<div class="form-group">
			<label class="control-label">{{ __('messages.training_category') }}</label>
			<select name="" id="training_category_cd" class="form-control " tabindex="1" organization_typ='1'>
				<option value="0"></option>
				@if(isset($M5031))
				@foreach($M5031 as $dt)
				<option value="{{$dt['training_category_cd']}}">{{$dt['training_category_nm']}}</option>
				@endforeach
				@endif
			</select>
		</div>
	</div>
	<div class="col-md-3">
		<div class="form-group">
			<label class="control-label" >{{ __('messages.course_format') }}</label>
			<select name=""  id="training_course_format_cd" class="form-control " tabindex="1" organization_typ='1'>
				<option value="0"></option>
				@if(isset($M5032))
				@foreach($M5032 as $dt)
				<option value="{{$dt['training_course_format_cd']}}">{{$dt['training_course_format_nm']}}</option>
				@endforeach
				@endif
			</select>
		</div>
	</div>
	<div class="col-md-3 col-lg-1 ln-1">
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<span class="num-length">
				<input tabindex="1" type="text" id="arrange_order" class="form-control only-number" placeholder="" maxlength="4" value="">
			</span>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-12" style="margin-top: 12px;">
		<div class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
            <input type="checkbox" name="ck1" id="editable_kbn" value="1" tabindex="1">
            <label for="editable_kbn">{{__('messages.editing_category')}}</label>
        </div>
	</div>
</div>