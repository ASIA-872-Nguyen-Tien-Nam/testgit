
@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
	@endphp
<div class="row mb-3">
    <div class="col-md-4 col-xs-6">
        <div style="padding-top: 10px;">
            <select tabindex="1" id="fiscal_year_1on1_target" class="form-control required">
                <option value="-1"></option>
                @if(isset($years))
                @foreach($years as $year)
                @if($current_year == $year)
                <option value="{{$year}}" selected="selected">
                {{$year}}{{year_english(__('messages.fiscal_year'))}}
                </option>
                @else
                <option value="{{$year}}">{{$year}}{{year_english(__('messages.fiscal_year'))}}</option>
                @endif
                @endforeach
                @endif
            </select>
        </div>
    </div>
</div>
@if(count($target) > 0)
@if($target['target1_use_typ'] == 1)
    <div class="row">
        <div class="col-md-12 col-12">
            <div class="form-group">
                <label class="control-label label-itemimportant">{{$target['target1_nm']??''}}</label>
                <span class="num-length">
                    <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target1" value="{{$target['target1']??''}}" >{{$target['target1']??''}}</textarea>
                </span>
            </div>
        </div>
    </div>
@endif
@if($target['target2_use_typ'] == 1)
<div class="row">
    <div class="col-md-12 col-12">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{$target['target2_nm']??''}}</label>
            <span class="num-length">
                <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target2" value="{{$target['target2']??''}}" >{{$target['target2']??''}}</textarea>
            </span>
        </div>
    </div>
</div>
@endif
@if($target['target3_use_typ'] == 1)
    <div class="row">
        <div class="col-md-12 col-12">
            <div class="form-group">
                <label class="control-label label-itemimportant">{{$target['target3_nm']??''}}</label>
                <span class="num-length">
                    <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target3" value="{{$target['target3']??''}}" >{{$target['target3']??''}}</textarea>
                </span>
            </div>
        </div>
    </div>
@endif
@if($target['comment_use_typ'] == 1)
<div class="row">
    <div class="col-md-12 col-12">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{$target['comment_nm']??__('messages.expectations_from_coaches_to_member') }}</label>
            <span class="num-length">
                <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="400" id="comment">{{$target['comment']??''}}</textarea>
            </span>
        </div>
    </div>
</div>
@endif
@else
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells mt-10">
    <table class="table sortable table-bordered table-hover fixed-header table-striped">
        <thead>
        <tr>
            <th class="w-120px text-left">WILL</th>
        </tr>
        </thead>
        <tbody>
            <tr class="tr_employee">
                <td class="w-120px">
                    <textarea class="form-control" style="min-height: 70px;" cols="30" rows="1" maxlength="400" id="target1" tabindex="2"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells mt-10">
    <table class="table sortable table-bordered table-hover fixed-header table-striped">
        <thead>
        <tr>
            <th class="w-120px text-left">CAN</th>
        </tr>
        </thead>
        <tbody>
            <tr class="tr_employee">
                <td class="w-120px">
                    <textarea class="form-control" style="min-height: 70px;" cols="30" rows="1" maxlength="400" id="target2" tabindex="3"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells mt-10">
    <table class="table sortable table-bordered table-hover fixed-header table-striped">
        <thead>
        <tr>
            <th class="w-120px text-left">MUST</th>
        </tr>
        </thead>
        <tbody>
            <tr class="tr_employee">
                <td class="w-120px">
                    <textarea class="form-control" style="min-height: 70px;" cols="30" rows="1" maxlength="400" id="target3" tabindex="4"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells mt-10">
    <table class="table sortable table-bordered table-hover fixed-header table-striped">
        <thead>
        <tr>
            <th class="w-120px text-left">{{ __('messages.expectations_from_coaches_to_member') }}</th>
        </tr>
        </thead>
        <tbody>
            <tr class="tr_employee">
                <td class="w-120px">
                    <textarea class="form-control" disabled="disabled" style="min-height: 70px;" cols="30" rows="1" maxlength="400" id="comment" tabindex="11"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</div>
@endif