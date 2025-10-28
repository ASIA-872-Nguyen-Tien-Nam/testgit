<div class="tab-pane fade" id="tab15">
    @if (isset($tab_04['list_data_1']) && !empty($tab_04['list_data_1']))
	<div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.current_position_infor') }}</label>
    </div>
    <div class="col-md-12" style="margin-top : 10px"> 
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 400px">
            @if ((isset($disabled) && $disabled == '') && (isset($tab_04['disabled_tab04']) && $tab_04['disabled_tab04'] == ''))
            <div class="full-width full-width-head">
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue btn-add-new-row-15" tabindex="9">
                    +
                </a>
            </div>
            @endif
            <div class="detail-content full-width">
                @foreach ($tab_04['list_data_1'] as $index => $data)
                <div class="row detail-sub detail {{$index > 0 ? 'tr-head' : ''}}" style="align-items: center;width: 100%;margin-left: 0px;background: #eaeaea;">
                    <div class="no-detail" style="width: 3.8%;">
                        <input type="text" class="detail_no" value="{{ $data['detail_no'] == 0 ? '' :  $data['detail_no']}}" hidden>
                        <input type="text" class="work_history_kbn" value="1" hidden>
                        <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                        <div class="form-group no">{{ $index + 1 }}</div>
                    </div>
                    <div class='row item-group' style="width: 95%">
                    @foreach ($data as $key => $item)
                        {{-- @php
                            if ($i == 20 || $i == 21) {
                                continue;
                            }
                            $json = html_entity_decode($data[$i]);
                            $array = json_decode($json, true) ?? [];
                            $row = $array[0] ?? [];
                        @endphp --}}
                        @php
                            if ($key == 'detail_no') {
                                continue;
                            }
                            $json = html_entity_decode($data[$key]);
                            $array = json_decode($json, true) ?? [];
                            $row = $array[0] ?? [];
                        @endphp
                        @if(isset($row['item_id']) && $row['item_id'] == 1)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-1" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"  value="1"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_1"
                                        value="{{$row['item_title']??__('messages.period')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <div class="p-item" style="display: flex;">
                                <div style="flex: 1;">
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control input-sm date date_from"
                                                placeholder="yyyy/mm/dd" tabindex="1" value="{{$row['date_from']??''}}" >
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                                    tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                </div>
                                <div style="padding: 6px;">
                                    <div class="contain-radio">～</div>
                                </div>
                                <div style="flex: 1;">
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control input-sm date date_to"
                                                placeholder="yyyy/mm/dd" tabindex="1" value="{{$row['date_to']??''}}" >
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                                    tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                </div>
                            </div>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 2)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-2" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id" value="2"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_2"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}}  type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 3)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-3" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id" value="3"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_3"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 4)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-4" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>    
                            <input type="text" hidden class="item_id" value="4"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_4"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 5)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-5" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"  value="5"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_5"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 6)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-6" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_6" value="6"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_6"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 7)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-7" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>    
                            <input type="text" hidden class="item_id"          id="item_id_7" value="7"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_7"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 8)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-8" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_8" value="8"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_8"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div> 
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 9)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-9" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_9" value="9"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_9"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 28)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-28" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_28" value="28"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_28"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 29)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-29" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_29" value="29"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_29"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 30)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-30" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_30" value="30"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_30"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 10)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-10" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_10" value="10"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_10"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 11)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-11" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_11" value="11"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_11"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 26)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-26" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_26" value="26"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_26"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 27)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-27" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_27" value="27"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_27"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 12)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-12" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_12" value="12"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_12"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 13)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-13" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_13" value="13"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_13"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 14)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-14" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_14" value="14"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_14"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 15)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-15" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_15" value="15"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_15"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 16)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }

                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-16" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_16" value="16"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_16"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 17)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-17" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_17" value="17"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_17"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 18)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }

                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-18" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_18" value="18"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_18"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 19)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }

                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-19" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_19" value="19"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_19"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 20)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }

                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-20" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_20" value="20"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_20"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 21)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-21" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_21" value="21"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_21"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 22)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-22" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_22" value="22"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_22"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 23)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-23" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_23" value="23"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_23"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 24)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-24" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_24" value="24"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_24"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 25)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-25" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="1" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_25" value="25"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_25"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                    @endforeach 
                    </div>
                    @if ((isset($disabled) && $disabled == '') && (isset($tab_04['disabled_tab04']) && $tab_04['disabled_tab04'] == ''))
                    <div class="">
                        <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-15">
                            <i class="fa fa-remove" style="font-size: 19px;"></i>
                        </button>
                    </div>
                    @endif
                </div>
                @endforeach
            </div>
		</div><!-- end .table-responsive -->
	</div>
    @endif

    @if(isset($tab_04['list_data_2']) && !empty($tab_04['list_data_2']))
	<div class="line-border-bottom" style="margin-top : 10px">
        <label class="control-label">{{ __('messages.Pre_joining_infor') }}</label>
    </div>
	<div class="col-md-12" style="margin-top : 10px"> 
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 400px">
            @if ((isset($disabled) && $disabled == '') && (isset($tab_04['disabled_tab04']) && $tab_04['disabled_tab04'] == ''))
            <div class="full-width full-width-head">
                <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue btn-add-new-row-15" tabindex="9">
                    +
                </a>
            </div>
            @endif
            <div class="detail-content full-width">
                @foreach ($tab_04['list_data_2'] as $index => $data)
                <div class="row detail-sub detail {{$index > 0 ? 'tr-head' : ''}}" style="align-items: center;width: 100%;margin-left: 0px;background: #eaeaea;">
                    <div class="no-detail" style="width: 3.8%;">
                        <input type="text" class="detail_no" value="{{ $data['detail_no'] == 0 ? '' :  $data['detail_no']}}" hidden>
                        <input type="text" class="work_history_kbn" value="2" hidden>
                        <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                        <div class="form-group no">{{ $index + 1 }}</div>
                    </div>
                    <div class='row item-group' style="width: 95%">
                    @foreach ($data as $key => $item)
                        {{-- @php
                            if ($i == 20 || $i == 21) {
                                continue;
                            }
                            $json = html_entity_decode($data[$i]);
                            $array = json_decode($json, true) ?? [];
                            $row = $array[0] ?? []
                        @endphp --}}
                        @php
                            if ($key == 'detail_no') {
                                continue;
                            }
                            $json = html_entity_decode($data[$key]);
                            $array = json_decode($json, true) ?? [];
                            $row = $array[0] ?? [];
                        @endphp
                        @if(isset($row['item_id']) && $row['item_id'] == 1)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-1" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"  value="1"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_1"
                                        value="{{$row['item_title']??__('messages.period')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <div class="p-item" style="display: flex;">
                                <div style="flex: 1;">
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control input-sm date date_from"
                                                placeholder="yyyy/mm/dd" tabindex="1" value="{{$row['date_from']??''}}" >
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                                    tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                </div>
                                <div style="padding: 6px;">
                                    <div class="contain-radio">～</div>
                                </div>
                                <div style="flex: 1;">
                                    <span class="num-length">
                                        <div class="input-group-btn input-group">
                                            <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control input-sm date date_to"
                                                placeholder="yyyy/mm/dd" tabindex="1" value="{{$row['date_to']??''}}" >
                                            <div class="input-group-append-btn">
                                                <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                                    tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    </span>
                                </div>
                            </div>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 2)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-2" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id" value="2"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_2"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 3)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-3" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id" value="3"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_3"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 4)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-4" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>    
                            <input type="text" hidden class="item_id" value="4"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_4"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}}  type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 5)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-5" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"  value="5"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_5"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 6)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-6" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_6" value="6"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_6"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 7)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-7" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>    
                            <input type="text" hidden class="item_id"          id="item_id_7" value="7"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_7"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="50" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 8)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-8" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}"hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_8" value="8"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_8"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div> 
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 9)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-9" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_9" value="9"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_9"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 28)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-28" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_28" value="28"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_28"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 29)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-29" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_29" value="29"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_29"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 30)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 33%" id="li-30" col-size="2">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_30" value="30"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_30"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="100" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 10)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-10" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_10" value="10"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_10"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 11)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-11" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_11" value="11"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_11"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 26)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-26" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_26" value="26"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_26"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 27)
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 99.4%" id="li-27" col-size="6">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_27" value="27"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_27"
                                        value="{{$row['item_title']??__('messages.character_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control text_item" maxlength="150" tabindex="1" value="{{$row['text_item']??''}}" >
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 12)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-12" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_12" value="12"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_12"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 13)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-13" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_13" value="13"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_13"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 14)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-14" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_14" value="14"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_14"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 15)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-15" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_15" value="15"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_15"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 16)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-16" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_16" value="16"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_16"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}}  tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 17)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-17" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_17" value="17"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_17"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 18)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-18" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_18" value="18"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_18"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 19)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-19" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_19" value="19"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_19"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 20)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-20" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_20" value="20"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_20"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 21)
                        @php
                            if(isset($row['combobox'])){
                                $json = html_entity_decode($row['combobox']);
                                $array = json_decode($json, true) ?? [];
                            }
                        @endphp
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-21" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_21" value="21"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_21"
                                        value="{{$row['item_title']??__('messages.selected_items')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item">
                                <select {{$disabled}} {{$tab_04['disabled_tab04']}} tabindex="1" class="form-control select_item" >
                                    <option value="0"></option>
                                    @if(count($array[0]) == 3)
                                    @foreach($array??[] as $cb)
                                        <option value="{{$cb['selected_items_no']}}" {{($row['select_item']??0)==$cb['selected_items_no']?'selected':''}}>{{$cb['selected_items_nm']}}</option>
                                    @endforeach
                                    @endif
                                </select>
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 22)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-22" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_22" value="22"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_22"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 23)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-23" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_23" value="23"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_23"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}}  type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 24)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-24" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_24" value="24"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_24"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                        @if(isset($row['item_id']) && $row['item_id'] == 25)
                        <div class="option-item list_item {{$row['item_display_kbn'] == 1 ? 'list1_tab_04':'d-none'}}" style="width: 16.5%" id="li-25" col-size="1">
                            <input type="text" class="check_new_row" value="{{ $index + 1 }}" hidden>
                            <input type="text" class="work_history_kbn" value="2" hidden>
                            <input type="text" hidden class="item_id"          id="item_id_25" value="25"/>
                            <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                            <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                            <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                            <input type="text" hidden class="numeric_value1" value="{{$row['numeric_value1'] ?? '' }}"/>
                            <div class="d-flex justify-content-between sort-li">
                                <span class="ics-textbox num-length">
                                    <input
                                        type="text"
                                        class="form-control form-control-sm item_title"
                                        id="item_title_25"
                                        value="{{$row['item_title']??__('messages.numerical_item')}}"
                                        readonly=""
                                        tabindex="-1"
                                    />
                                </span>
                            </div>
                            <span class="num-length p-item" style="">
                                <input {{$disabled}} {{$tab_04['disabled_tab04']}} type="text" class="form-control number_item numeric text-right" tabindex="1" maxlength="11" decimal="2" negative="true" value="{{$row['number_item'] ?? ''}}">
                            </span>
                        </div>
                        @endif
                    @endforeach
                    </div>
                    @if ((isset($disabled) && $disabled == '') && (isset($tab_04['disabled_tab04']) && $tab_04['disabled_tab04'] == ''))
                    <div class="">
                        <button tabindex="9" class="btn btn-rm btn-sm btn-remove-row-15">
                            <i class="fa fa-remove" style="font-size: 19px;"></i>
                        </button>
                    </div>
                    @endif
                </div>
                @endforeach
            </div>
		</div><!-- end .table-responsive -->
	</div>
    @endif
</div>