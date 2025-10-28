@if (isset($target) && !empty($target))
<div class="row bar__title align-items-center">
    <div class="form-group mb-0">
        <div class="full-width">
            <a id="btn_target_show" class="btn btn-outline-primary bar__button" tabindex="-1">
                {{ __('ri2010.target_show') }}
            </a>
        </div>
    </div>
    <div class="form-group mb-0">
        <span>{{ __('ri2010.target_label') }}</span>
    </div>
</div>
<div class="row hide" id="target">
    @if($target['target1_use_typ'] == 1)
    <div class="col-md-4 col-lg-4 col-xl-4">
        <div class="form-group">
            <label class="text-overfollow control-label label-itemimportant" style="width: 270px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target1_nm'] }}">{{ $target['target1_nm'] }}</label>
            <span class="num-length" style="top:10px">
                <textarea style="height: 118px" class="form-control target" cols="30" rows="4"  maxlength="1000" disabled >{{ $target['target1'] }}</textarea>
            </span>
        </div>
    </div>
    @endif
    @if($target['target2_use_typ'] == 1)
    <div class="col-md-4 col-lg-4 col-xl-4">
        <div class="form-group">
            <label class="text-overfollow control-label label-itemimportant" style="width: 270px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target2_nm'] }}">{{ $target['target2_nm'] }}</label>
            <span class="num-length" style="top:10px">
                <textarea style="height: 118px" class="form-control target" cols="30" rows="4"  maxlength="1000" disabled >{{ $target['target2'] }}</textarea>
            </span>
        </div>
    </div>
    @endif
    @if($target['target3_use_typ'] == 1)
    <div class="col-md-4 col-lg-4 col-xl-4">
        <div class="form-group">
            <label class="text-overfollow control-label label-itemimportant" style="width: 270px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target3_nm'] }}">{{ $target['target3_nm'] }}</label>
            <span class="num-length" style="top:10px">
                <textarea style="height: 118px" class="form-control target" cols="30" rows="4"  maxlength="1000" disabled >{{ $target['target3'] }}</textarea>
            </span>
        </div>
    </div>
    @endif
    @if($target['target4_use_typ'] == 1)
    <div class="col-md-4 col-lg-4 col-xl-4">
        <div class="form-group">
            <label class="text-overfollow control-label label-itemimportant" style="width: 270px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target4_nm'] }}">{{ $target['target4_nm'] }}</label>
            <span class="num-length" style="top:10px">
                <textarea style="height: 118px" class="form-control target" cols="30" rows="4"  maxlength="1000" disabled >{{ $target['target4'] }}</textarea>
            </span>
        </div>
    </div>
    @endif
    @if($target['target5_use_typ'] == 1)
    <div class="col-md-4 col-lg-4 col-xl-4">
        <div class="form-group">
            <label class="text-overfollow control-label label-itemimportant" style="width: 270px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target5_nm'] }}">{{ $target['target5_nm'] }}</label>
            <span class="num-length" style="top:10px">
                <textarea style="height: 118px" class="form-control target" cols="30" rows="4"  maxlength="1000" disabled >{{ $target['target5'] }}</textarea>
            </span>
        </div>
    </div>
    @endif
</div>
@endif