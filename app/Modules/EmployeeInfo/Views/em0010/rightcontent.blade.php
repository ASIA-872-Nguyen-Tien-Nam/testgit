<div class="row">
    <div class="col-md-1 ln-1" style="max-width: 220px;">
        <div class="form-group">
            <label class="control-label ">{{ __('messages.code') }}</label>
            <span class="num-length">
                <input type="text" class="form-control " tabindex="1" maxlength="3" id="qualification_cd"
                    value="" disabled="" />
                <input type="hidden" id="mode" value="0" />
            </span>
        </div>
    </div>
    <div class="col-md-9">
        <div class="form-group">
            <label class="control-label lb-required"
                lb-required="{{ __('messages.required') }}">{{ __('messages.qualification_name') }}</label>
            <span class="num-length">
                <input type="text" class="form-control required" tabindex="1" maxlength="50" id="qualification_nm"
                    value="" />
            </span>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-3">
        <div class="form-group">
            <label class="control-label">{{ __('messages.qualification_type') }}</label>
            <select id="qualification_typ" class="form-control" tabindex="1" organization_typ='1'>
                @if (!empty($L0010_57))
                    @foreach ($L0010_57 as $item)
                        <option value="{{ $item['number_cd'] }}">{{ $item['name'] }}</option>
                    @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="col-md-1 ln-1" style="max-width: 220px;">
        <div class="form-group">
            <label class="control-label ">{{ __('messages.sort_order') }}</label>
            <span class="num-length">
                <input type="text" class="form-control only-number" id="arrange_order" tabindex="1" maxlength="4"
                    value="" />
            </span>
        </div>
    </div>
</div>
