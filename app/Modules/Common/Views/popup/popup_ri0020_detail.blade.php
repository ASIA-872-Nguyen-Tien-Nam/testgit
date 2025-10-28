<div class="row">
    <div class="col-md-4 col-xs-6">
        <div style="padding-top: 20px;">
            <div class="form-group">
                <select tabindex="1" id="fiscal_year_weeklyreport_target" class="form-control required">
                    @if (isset($years))

                        @foreach ($years as $key => $year)
                            @if ($year['fiscal_year'] == $fiscal_year)
                                <option selected value="{{ $year['fiscal_year'] }}">{{ $year['fiscal_year'] }}
                                    {{ __('rdashboard.fiscal_year') }}</option>
                            @else
                                <option value="{{ $year['fiscal_year'] }}">{{ $year['fiscal_year'] }}
                                    {{ __('rdashboard.fiscal_year') }}</option>
                            @endif
                        @endforeach
                    @endif
                </select>
            </div>
        </div>
    </div>
    @if (isset($is_registered) && $is_registered == 1)
        <div class="col-md-4 col-xs-6">
            {{-- Nothing --}}
        </div>
    @else
        <div class="col-md-4 col-xs-6">
            <div style="padding-top: 30px;" id="unregistered">
                <span style="color: blue">{{ __('messages.unregistered') }}</span>
            </div>
        </div>
    @endif
</div>
@if (isset($target1_use_typ) &&
        $target1_use_typ == 0 &&
        (isset($target2_use_typ) && $target2_use_typ == 0) &&
        (isset($target3_use_typ) && $target3_use_typ == 0) &&
        (isset($target4_use_typ) && $target4_use_typ == 0) &&
        (isset($target5_use_typ) && $target5_use_typ == 0))
    <div class="row">
        <div class="col-md-12 col-12">  
        <table class="table table-bordered table_alert table-cursor table-hover table-oneheader ofixed-boder">
            <tbody>
                <tr>
                    <td colspan="3" class="text-center" style="cursor: auto;">
                        {{ __('messages.no_setting') }}
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
    </div>
@else
    {{-- 目標 1 --}}
    @if (isset($target1_use_typ) && $target1_use_typ == 1)
        <div class="row">
            <div class="col-md-12 col-12">
                <div class="form-group" style="margin-bottom:0px">
                    <label class="control-label label-itemimportant" id="target1_nm">{{ $target1_nm ?? '' }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target1"
                            value="{{ $target1 ?? '' }}">{{ $target1 ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
    @endif
    {{-- 目標 2 --}}
    @if (isset($target2_use_typ) && $target2_use_typ == 1)
        <div class="row">
            <div class="col-md-12 col-12">
                <div class="form-group" style="margin-bottom:0px">
                    <label class="control-label label-itemimportant" id="target2_nm">{{ $target2_nm ?? '' }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target2"
                            value="{{ $target2 ?? '' }}">{{ $target2 ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
    @endif
    {{-- 目標 3 --}}
    @if (isset($target3_use_typ) && $target3_use_typ == 1)
        <div class="row">
            <div class="col-md-12 col-12">
                <div class="form-group" style="margin-bottom:0px">
                    <label class="control-label label-itemimportant" id="target3_nm">{{ $target3_nm ?? '' }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target3"
                            value="{{ $target3 ?? '' }}">{{ $target3 ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
    @endif
    {{-- 目標 4 --}}
    @if (isset($target4_use_typ) && $target4_use_typ == 1)
        <div class="row">
            <div class="col-md-12 col-12">
                <div class="form-group" style="margin-bottom:0px">
                    <label class="control-label label-itemimportant" id="target4_nm">{{ $target4_nm ?? '' }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target4"
                            value="{{ $target4 ?? '' }}">{{ $target4 ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
    @endif
    {{-- 目標 5 --}}
    @if (isset($target5_use_typ) && $target5_use_typ == 1)
        <div class="row">
            <div class="col-md-12 col-12">
                <div class="form-group" style="margin-bottom:0px">
                    <label class="control-label label-itemimportant" id="target5_nm">{{ $target5_nm ?? '' }}</label>
                    <span class="num-length">
                        <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="1000" id="target5"
                            value="{{ $target5 ?? '' }}">{{ $target5 ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
    @endif
    <div class="row">
        <div class="col-md-12 mt-3">
            <div class="group-btn" style="justify-content: center;margin-top: 10px;margin-bottom: 20px;display: flex">
                {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
            </div>
        </div>
    </div>
    <input type="hidden" class="anti_tab">
@endif
