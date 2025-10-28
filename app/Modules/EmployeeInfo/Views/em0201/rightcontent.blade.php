<div class="row">
    <div class="col-md-1 col-responsive">
        <div class="form-group">
            <label class="control-label">{{ __('messages.code') }}</label>
            <span class="num-length">
                <input type="text" class="form-control" tabindex="1" maxlength="3" id="field_cd" value="" disabled=""/>
                <input type="hidden" id="mode" value="0" />
            </span>
        </div>
    </div>
    <div class="col-md-6">
        <div class="form-group">
            <label class="control-label lb-required"
                lb-required="{{ __('messages.required') }}">{{ __('messages.em0201.item_nm') }}</label>
            <span class="num-length">
                <input type="text" class="form-control required" tabindex="1" maxlength="50" id="field_nm" value="" />
            </span>
        </div>
    </div>
    <div class="col-md-1 col-responsive">
        <div class="form-group">
            <label class="control-label">{{ __('messages.sort_order') }}</label>
            <span class="num-length">
                <input type="text" class="form-control only-number" id="arrange_order"  tabindex="1" maxlength="4" />
            </span>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12 mt-12px">
        <div class="form-group">
			 <div class="md-checkbox-v2 inline-block">
                <input name="checkbox" class="" id="search_kbn" type="checkbox" value="1" tabindex="1">
                <label for="search_kbn">{{ __('messages.include_in_search_condition') }}</label>
            </div>
        </div>
    </div>
</div>
