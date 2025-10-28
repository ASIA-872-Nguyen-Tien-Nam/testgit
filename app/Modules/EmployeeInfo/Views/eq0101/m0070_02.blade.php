<div class="tab-pane fade" id="tab5">
    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.qualifications_held') }}</label>
    </div>
    <div class="col-md-12" style="margin-top : 10px">
        <div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 644px">
            <table class="table table-bordered table-hover table-oneheader ofixed-boder table-head" id="table-data"
                style="margin-bottom: 20px !important;">
                <thead>
                    <tr>
                        <th class="text-center" style="width: 3%">
                            <span class="item-right">
                                @if (isset($disabled) && $disabled == ''  && (isset($tab_02['disabled_tab02']) && $tab_02['disabled_tab02'] == ''))
                                    <button class="btn btn-rm blue btn-sm btn-add-new-row" id="btn-add-row-tab-02"
                                        tabindex="9">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                @endif
                            </span>
                        </th>
                        <th class="text-center" style="width: 19%;">{{ __('messages.qualification_name') }}</th>
                        <th class="text-center" style="width: 14%;">{{ __('messages.qualification_type') }}</th>
                        <th class="text-center" style="width: 12%;">{{ __('messages.qualification_date') }}</th>
                        <th class="text-center" style="width: 12%;">{{ __('messages.qualification_ex_date') }}</th>
                        <th class="text-center" style="width: 27%;">{{ __('messages.remarks') }}</th>
                        @if (isset($disabled) && $disabled == ''  && (isset($tab_02['disabled_tab02']) && $tab_02['disabled_tab02'] == ''))
                            <th style="width: 3%"></th>
                        @endif
                    </tr>
                </thead>
                <tbody>
                    @foreach ($tab_02['list'] as $index => $row)
                        <tr class="tr list_tab_02" cate_no="1">
                            <td rowspan="1" class="text-center no">
                                <span>{{ $index + 1 }}</span>
								{{-- <input type="text" class="form-control input-sm text-left d-none detail_no"
                                    value="{{ $row['detail_no'] ?? '' }}"> --}}
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1" style="max-width: 180px;">
                                <span class="num-length text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['qualification_nm'] ?? '' }}">
                                    {{ $row['qualification_nm'] ?? '' }}
                                </span>
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1">
                                <span class="num-length">
                                    {{-- <input disabled type="text" tabindex="9"
                                        class="form-control input-sm text-left qualification_typ_nm"
                                        value="{{ $row['qualification_typ_nm'] ?? '' }}">
                                    <input type="text" tabindex="9"
                                        class="form-control input-sm text-left qualification_typ d-none"
                                        value="{{ $row['qualification_typ'] ?? 0}}"> --}}
                                        {{ $row['qualification_typ_nm'] ?? '' }}
                                </span>
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1">
                                <span class="num-length text-center">
                                    {{-- <div class="input-group-btn input-group">
                                        <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text"
                                            class="form-control input-sm date headquarters_other"
                                            placeholder="yyyy/mm/dd" tabindex="9"
                                            value="{{ $row['headquarters_other'] ?? '' }}">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                                tabindex="-1"><i class="fa fa-calendar"></i></button>
                                        </div>
                                    </div> --}}
                                    {{ $row['headquarters_other'] ?? '' }}
                                </span>
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1">
                                <span class="num-length text-center">
                                    {{-- <div class="input-group-btn input-group">
                                        <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text"
                                            class="form-control input-sm date possibility_transfer" 
                                            placeholder="yyyy/mm/dd" tabindex="9"
                                            value="{{ $row['possibility_transfer'] ?? '' }}">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent button-date" type="button"
                                                data-dtp="dtp_wH14i" tabindex="-1"><i
                                                    class="fa fa-calendar"></i></button>
                                        </div>
                                    </div> --}}
                                    {{ $row['possibility_transfer'] ?? '' }}
                                </span>
                            </td>
                            <td rowspan="1" class="low-cate" low_cate_cd="1">
                                <span class="num-length text-overfollow" 
                                data-container="body"
                                data-toggle="tooltip"
                                data-original-title="{{ $row['remarks'] ?? '' }}">
                                    {{-- <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="hidden" class="category3_cd" value="">
                                    <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text" tabindex="9"
                                        class="form-control input-sm text-left category3_nm remarks"
                                        value="{{ $row['remarks'] ?? '' }}" maxlength="50" decimal="2"> --}}
                                        {{ $row['remarks'] ?? '' }}
                                </span>
                            </td>
                            @if (isset($disabled) && $disabled == ''  && (isset($tab_02['disabled_tab02']) && $tab_02['disabled_tab02'] == ''))
                                <td class="text-center">
                                    <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row"
                                        id="btn-remove-row-tab-02">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            @endif
                        </tr>
                    @endforeach
                </tbody>
            </table>
            <table class="hidden table-target">
                <tbody>
                    <tr class="tr list_tab_02" cate_no="1">
                        <td rowspan="1" class="text-center no">
                            <span>1</span>
							<input type="text" class="form-control input-sm text-left d-none detail_no"
                                    value="0">
                        </td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
                            <div>
                                <div class="input-group-btn input-group">
                                    <span class="num-length">
                                        <input type="text"
                                            class="form-control ui-autocomplete-input autocomplete-down-tab_02 qualification_nm"
                                            availableData = "{{ $tab_02['qualification_cd'] }}" tabindex="9" maxlength="50"
                                            value="" style="padding-right: 40px;" autocomplete="off"
                                            {{ $disabled }} {{$tab_02['disabled_tab02']}}>
                                        <input type="text"
                                            class="form-control input-sm text-left qualification_cd d-none"
                                            value="">
                                    </span>
                                </div>
                            </div>
                        </td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
                            <span class="num-length">
                                <input disabled type="text" tabindex="9"
                                    class="form-control input-sm text-left qualification_typ_nm" value="">
                                <input type="text" class="form-control input-sm text-left qualification_typ d-none"
                                    value="">
                            </span>
                        </td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text"
                                        class="form-control input-sm date headquarters_other" placeholder="yyyy/mm/dd"
                                        tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text"
                                        class="form-control input-sm date possibility_transfer"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
                            <span class="num-length">
                                <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="hidden" class="category3_cd" value="">
                                <input {{ $disabled }} {{$tab_02['disabled_tab02']}} type="text" tabindex="9"
                                    class="form-control input-sm text-left category3_nm remarks" value=""
                                    maxlength="50" decimal="2">
                            </span>
                        </td>
                        @if (isset($disabled) && $disabled == ''  && (isset($tab_02['disabled_tab02']) && $tab_02['disabled_tab02'] == ''))
                            <td class="text-center">
                                <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row"
                                    id="btn-remove-row-tab-02">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                        @endif
                    </tr>
                </tbody>
            </table><!-- /.hidden -->

        </div><!-- end .table-responsive -->

    </div>
</div>
