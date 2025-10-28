<div class="row list_detail" id="">
    <div class="row tab-content col-md-12 select-treatment">
        <div class="form-group calHe w41">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.treatment_use')}}</label>
            <span class="num-length">
            <select class="form-control required" id="treatment_applications_no">
                @foreach($treatment as $item)
                    <option value="{{$item['treatment_applications_no']}}" {{$item['selected']}}>
                        {{$item['treatment_applications_nm']}}
                    </option>
                @endforeach
            </select>
        </span>
        </div>
    </div>
</div>
<div id="evaluation-master-set" hidden value='{{ $text === 'confirm' ? '1' : '0' }}' ></div>
@if (!empty($group))
    <div class="list_detail row">
        <div class="row tab-content col-md-12">
            <div class="table-responsive">
                <table class="table table-bordered" id="table-data">
                    <thead>
                        <tr>
                            <th class="w40">{{ __('messages.group') }}&nbsp;</th>
                            <th class="w40">{{ __('messages.evaluation_sheet') }}&nbsp;</th>
                            <th>{{ __('messages.allocation_rate') }}&nbsp;</th>
                            <th style="width: 40px;">
                            </th>

                            <th style="background:white;width: 40px;border:none; ">
                            </th>
                        </tr>
                    </thead>
                    @php
                        $prevGroupCd = null;
                        $totalRows = count($group);
                    @endphp

                    @foreach($group as $index => $row)
                        @php
                            $nextRow = $group[$index + 1] ?? null;
                            $isGroupStart = $prevGroupCd === null || $prevGroupCd != $row['group_cd'];
                            $isGroupEnd = !$nextRow || $nextRow['group_cd'] != $row['group_cd'];
                        @endphp

                        @if ($isGroupStart)
                            <tbody class="group-body tbd{{ $row['group_cd'] }}{{ $row['treatment_applications_no'] }}"
                                   group_cd="{{ $row['group_cd'] }}"
                                   treatment_applications_no="{{ $row['treatment_applications_no'] }}">
                        @endif

                        <tr class="tr-main">
                            @if ($isGroupStart)
                                <td class="td-span td-group td-error"
                                    rowspan="{{ $row['count_row'] }}">
                                    <div></div><span>{{ $row['group_nm'] }}</span>
                                </td>
                            @endif

                            <td class="w40">
                                <input type="hidden" class="detail_no" value="{{ $row['detail_no'] }}"/>
                                <select class="form-control input-sm required sheet_cd"
                                        use_typ="{{ $row['sheet_cd'] == 0 ? 0 : 1 }}"
                                        value_sheet_cd="{{ $row['sheet_cd'] }}">
                                    <option value="{{ $row['sheet_cd'] }}">
                                        {{ $row['sheet_cd'] == 0 ? __('messages.exclude') : $row['sheet_nm'] }}
                                    </option>
                                </select>
                            </td>

                            <td class="w30">
                                <span class="num-length">
                                    <div class="input-group-btn">
                                        <input class="form-control numeric weight"
                                               maxlength="3" max="100" min="0"
                                               value="{{ $row['weight'] }}"
                                               {{ $row['class_weight'] == 'disabled' ? 'disabled' : '' }}>
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" disabled="">
                                                <i class="fa fa-percent"></i>
                                            </button>
                                        </div>
                                    </div>
                                </span>
                            </td>

                            <td class="text-center" style="width: 40px;">
                                <button class="btn btn-rm btn-sm btn-remove-row">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                            @if($isGroupStart==true)
                            <td style="width: 40px;text-align:center; vertica-align:middle">
                                <button class="btn btn-rm blue btn-sm" id="btn-add-new">
                                    <i class="fa fa-plus"></i>
                                </button>
                            </td>
                            @endif
                        </tr>

                        @if ($isGroupEnd)
                            </tbody>
                        @endif

                        @php $prevGroupCd = $row['group_cd']; @endphp
                    @endforeach
                </table>
            </div>
        </div>
    </div>
@endif
