@if(isset($target) && !empty($target))
<div class="row">
    <div class="col-md-1 col-lg-2 my-auto">
        <label>&nbsp</label>
        <div class="form-group">
            <div class="full-width">
                <a href="javascript:;" id="btn-target-member" class="btn btn-outline-primary">
                    {{ __('messages.input') }}
                    <i class="fa fa-pencil" aria-hidden="true"></i>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-11 col-lg-10">
        <div class="row">
            @if($target['target1_use_typ'] == 1)
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="text-overfollow control-label label-itemimportant" style="width: 180px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target1_nm'] }}">{{ $target['target1_nm'] }}</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control input-sm textarea_noresize" maxlength="1000" disabled >{{ $target['target1'] }}</textarea>
                        </span>
                    </div>
                </div>
            @endif
            @if($target['target2_use_typ'] == 1)
            <div class="col-md-4">
                <div class="form-group">
                    <label class="text-overfollow control-label label-itemimportant" style="width: 180px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target2_nm'] }}">{{ $target['target2_nm'] }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm textarea_noresize" tabindex="1" maxlength="1000" id="" disabled  >{{$target['target2']??''}}</textarea>
                    </span>
                </div>
            </div>
            @endif
            @if($target['target3_use_typ'] == 1)
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="text-overfollow  control-label label-itemimportant" style="width: 180px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target3_nm'] }}">{{ $target['target3_nm'] }}</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control input-sm textarea_noresize" tabindex="1" maxlength="1000" id="" disabled  >{{$target['target3']??''}}</textarea>
                        </span>
                    </div>
                </div>
             @endif
             @if($target['target4_use_typ'] == 1)
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="text-overfollow  control-label label-itemimportant" style="width: 180px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target3_nm'] }}">{{ $target['target4_nm'] }}</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control input-sm textarea_noresize" tabindex="1" maxlength="1000" id="" disabled  >{{$target['target4']??''}}</textarea>
                        </span>
                    </div>
                </div>
             @endif
             @if($target['target5_use_typ'] == 1)
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="text-overfollow  control-label label-itemimportant" style="width: 180px" data-container="body" data-toggle="tooltip" data-original-title="{{ $target['target3_nm'] }}">{{ $target['target5_nm'] }}</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control input-sm textarea_noresize" tabindex="1" maxlength="1000" id="" disabled  >{{$target['target5']??''}}</textarea>
                        </span>
                    </div>
                </div>
             @endif
        </div>
    </div>
</div>
@endif