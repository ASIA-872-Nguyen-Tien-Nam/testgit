<div class="row">
    <div class="col-md-5 col-lg-3 col-xl-3 col-xxl-3">
        <div class="form-group">
            <label class="control-label">{{__('messages.registration_division')}}</label>
            <select tabindex="1" class="form-control required focus" id="work_history_kbn">
                <option value="-1"></option>
                <option value="1" {{($work_history_kbn??0)==1?'selected':''}}>{{__('messages.current_position_infor')}}</option>
                <option value="2" {{($work_history_kbn??0)==2?'selected':''}}>{{__('messages.Pre_joining_infor')}}</option>
            </select>
        </div><!--/.form-group -->
    </div>
</div>

<div class="line-border-bottom d-flex justify-content-between">
    <label class="control-label">{{__('messages.registration_items')}}</label>
    <button id="btn-show-all" class="mb-1 btn btn-outline-primary btn-sm ics-toggle-all" tabindex="1"><i class="fa fa-eye"></i>
    {{__('messages.redisplay')}}
    </button>
</div>

<!--table1 -->
<div class="row container_table3">
    <ul id="sortable">
        @if(isset($list_item) && !empty($list_item))
            @foreach($list_item as $row)
                @if($row['item_id'] == 1)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-1" col-size="{{$row['numeric_value2']}}" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"  value="1"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_1"
                                value="{{$row['item_title']??__('messages.period')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            /> 
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.period')}}
                            </label>                          
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <div class="p-item" style="display: flex;">
                        <div style="flex: auto;">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input type="text" id="birth_date" class="form-control input-sm date right-radius"
                                        placeholder="yyyy/mm/dd" tabindex="1" value="{{$table1['birth_date']??''}}" disabled>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                        <div style="padding: 10px;">
                            <div class="contain-radio">～</div>
                        </div>
                        <div style="flex: auto;">
                            <span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input type="text" id="birth_date" class="form-control input-sm date right-radius"
                                        placeholder="yyyy/mm/dd" tabindex="1" value="{{$table1['birth_date']??''}}" disabled>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </span>
                        </div>
                    </div>
                </li>
                @endif
                @if($row['item_id'] == 2)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-2" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_2" value="2"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_2"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 3)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-3" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_3" value="3"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_3"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 4)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-4" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_4" value="4"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_4"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 5)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-5" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_5" value="5"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_5"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 6)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-6" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_6" value="6"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_6"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 7)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-7" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_7" value="7"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_7"
                                value="{{$row['item_title']??__('messages.character_item1')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.character_item1')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 8)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-8" col-size="2" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"          id="item_id_8" value="8"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_8"
                                value="{{$row['item_title']??__('messages.character_item2')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: ;">
                                    {{$row['item_title']??__('messages.character_item2')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                    </span>
                </li> 
                @endif
                @if($row['item_id'] == 9)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-9" col-size="2" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"          id="item_id_9" value="9"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_9"
                                value="{{$row['item_title']??__('messages.character_item2')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.character_item2')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 28)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-28" col-size="2" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"          id="item_id_28" value="28"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_28"
                                value="{{$row['item_title']??__('messages.character_item2')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: ;">
                                    {{$row['item_title']??__('messages.character_item2')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                    </span>
                </li> 
                @endif
                @if($row['item_id'] == 29)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-29" col-size="2" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"          id="item_id_29" value="29"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_29"
                                value="{{$row['item_title']??__('messages.character_item2')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: ;">
                                    {{$row['item_title']??__('messages.character_item2')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                    </span>
                </li> 
                @endif
                @if($row['item_id'] == 30)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-30" col-size="2" style="grid-column-end: span 2;">
                    <input type="text" hidden class="item_id"          id="item_id_30" value="30"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_30"
                                value="{{$row['item_title']??__('messages.character_item2')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: ;">
                                    {{$row['item_title']??__('messages.character_item2')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                    </span>
                </li> 
                @endif
                @if($row['item_id'] == 10)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-10" col-size="6" style="grid-column-end: span 6;">
                    <input type="text" hidden class="item_id"          id="item_id_10" value="10"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_10"
                                value="{{$row['item_title']??__('messages.character_item3')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.character_item3')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 11)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-11" col-size="6" style="grid-column-end: span 6;">
                    <input type="text" hidden class="item_id"          id="item_id_11" value="11"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_11"
                                value="{{$row['item_title']??__('messages.character_item3')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.character_item3')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 26)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-26" col-size="6" style="grid-column-end: span 6;">
                    <input type="text" hidden class="item_id"          id="item_id_26" value="26"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_26"
                                value="{{$row['item_title']??__('messages.character_item3')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.character_item3')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 27)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-27" col-size="6" style="grid-column-end: span 6;">
                    <input type="text" hidden class="item_id"          id="item_id_27" value="27"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_27"
                                value="{{$row['item_title']??__('messages.character_item3')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                    {{$row['item_title']??__('messages.character_item3')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.character_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                    </span>
                </li>
                @endif
               
                @if($row['item_id'] == 12)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-12" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_12" value="12"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_12"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 13)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-13" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_13" value="13"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_13"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 14)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-14" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_14" value="14"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_14"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 15)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-15" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_15" value="15"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_15"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 16)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-16" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_16" value="16"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_16"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 17)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-17" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_17" value="17"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_17"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 18)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-18" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_18" value="18"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_18"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 19)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-19" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_19" value="19"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_19"
                                value="{{$row['item_title']??__('messages.selected_items')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.selected_items')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.selected_items')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item">
                        <select tabindex="1" class="form-control" disabled>
                            <option value="-1"></option>
                        </select>
                    </span>
                </li>
                @endif
                

                @if($row['item_id'] == 22)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-22" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_22" value="22"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_22"
                                value="{{$row['item_title']??__('messages.numerical_item')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.numerical_item')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.numerical_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 23)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-23" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_23" value="23"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_23"
                                value="{{$row['item_title']??__('messages.numerical_item')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.numerical_item')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.numerical_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 24)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-24" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_24" value="24"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_24"
                                value="{{$row['item_title']??__('messages.numerical_item')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.numerical_item')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.numerical_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                    </span>
                </li>
                @endif
                @if($row['item_id'] == 25)
                <li class="ui-state-default list_item {{$row['item_display_kbn'] == 1 ? '' : 'ics-hide d-none'}}" id="li-25" col-size="{{$row['numeric_value2']}}">
                    <input type="text" hidden class="item_id"          id="item_id_25" value="25"/>
                    <input type="text" hidden class="item_display_kbn" value="{{$row['item_display_kbn']}}"/>
                    <input type="text" hidden class="item_arrangement_column" value="{{$row['item_arrangement_column']}}"/>
                    <input type="text" hidden class="item_arrangement_line" value="{{$row['item_arrangement_line']}}"/>
                    <div class="d-flex justify-content-between sort-li">
                        
                        <span class="ics-textbox num-length">
                            <input
                                type="text"
                                class="form-control form-control-sm item_title"
                                id="item_title_25"
                                value="{{$row['item_title']??__('messages.numerical_item')}}"
                                hidden=""
                                tabindex="-1"
                                maxlength="20"
                            />
                            <label class="control-label text-name"
                                    style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;    display: block">
                                    {{$row['item_title']??__('messages.numerical_item')}}
                            </label>
                            <!-- <span class="text-name" style="display:flex">{{$row['item_title']??__('messages.numerical_item')}}</span> -->
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                    <span class="num-length p-item" style="">
                        <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                    </span>
                </li>
                @endif
            @endforeach
        @else
            <li class="ui-state-default list_item" id="li-1" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"  value="1"/>
                <input type="text" hidden class="item_display_kbn" value="1"/>
                <input type="text" hidden class="item_arrangement_column" value="1"/>
                <input type="text" hidden class="item_arrangement_line" value="1"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_1"
                            value="{{__('messages.period')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.period')}}
                        </label>  
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <div class="p-item" style="display: flex;">
                    <div style="flex: auto;">
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text" id="birth_date" class="form-control input-sm date right-radius"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{$table1['birth_date']??''}}" disabled>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <div style="padding: 10px;">
                        <div class="contain-radio">～</div>
                    </div>
                    <div style="flex: auto;">
                        <span class="num-length">
                            <div class="input-group-btn input-group">
                                <input type="text" id="birth_date" class="form-control input-sm date right-radius"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{$table1['birth_date']??''}}" disabled>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                </div>
            </li>
            <li class="ui-state-default list_item" id="li-2" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_2" value="2"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_2" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_2" value="3"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_2" value="1"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_2"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label> 
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-3" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_3" value="3"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_3" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_3" value="4"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_3" value="1"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_3"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-4" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_4" value="4"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_4" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_4" value="5"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_4" value="1"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_4"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-5" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_5" value="5"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_5" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_5" value="6"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_5" value="1"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_5"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-6" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_6" value="6"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_6" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_6" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_6" value="2"/>
                <div class="d-flex justify-content-between sort-li">
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_6"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-7" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_7" value="7"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_7" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_7" value="2"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_7" value="2"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_7"
                            value="{{__('messages.character_item1')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.character_item1')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="20" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-8" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"          id="item_id_8" value="8"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_8" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_8" value="3"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_8" value="2"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_8"
                            value="{{__('messages.character_item2')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item2')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                </span>
            </li> 
            <li class="ui-state-default list_item" id="li-9" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"          id="item_id_9" value="9"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_9" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_9" value="5"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_9" value="2"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_9"
                            value="{{__('messages.character_item2')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item2')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-28" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"          id="item_id_28" value="28"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_28" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_28" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_28" value="3"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_28"
                            value="{{__('messages.character_item2')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item2')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-29" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"          id="item_id_29" value="29"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_29" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_29" value="3"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_29" value="3"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_29"
                            value="{{__('messages.character_item2')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item2')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-30" col-size="2" style="grid-column-end: span 2;">
                <input type="text" hidden class="item_id"          id="item_id_30" value="30"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_30" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_30" value="5"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_30" value="3"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_30"
                            value="{{__('messages.character_item2')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item2')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <input type="text" class="form-control" maxlength="100" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-10" col-size="6" style="grid-column-end: span 6;">
                <input type="text" hidden class="item_id"          id="item_id_10" value="10"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_10" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_10" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_10" value="4"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_10"
                            value="{{__('messages.character_item3')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item3')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-11" col-size="6" style="grid-column-end: span 6;">
                <input type="text" hidden class="item_id"          id="item_id_11" value="11"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_11" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_11" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_11" value="5"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_11"
                            value="{{__('messages.character_item3')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item3')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-26" col-size="6" style="grid-column-end: span 6;">
                <input type="text" hidden class="item_id"          id="item_id_26" value="26"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_26" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_26" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_26" value="6"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_10"
                            value="{{__('messages.character_item3')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item3')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-27" col-size="6" style="grid-column-end: span 6;">
                <input type="text" hidden class="item_id"          id="item_id_27" value="27"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_27" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_27" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_27" value="7"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_27"
                            value="{{__('messages.character_item3')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block;">
                                {{__('messages.character_item3')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="150" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-12" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_12" value="12"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_12" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_12" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_12" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_12"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-13" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_13" value="13"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_13" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_13" value="2"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_13" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_13"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-14" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_14" value="14"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_14" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_14" value="3"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_14" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_14"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-15" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_15" value="15"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_15" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_15" value="4"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_15" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_15"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-16" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_16" value="16"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_16" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_16" value="5"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_16" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_16"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-17" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_17" value="17"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_17" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_17" value="6"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_17" value="8"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_17"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-18" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_18" value="18"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_18" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_18" value="1"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_18" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_18"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-19" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_19" value="19"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_19" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_19" value="2"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_19" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_19"
                            value="{{__('messages.selected_items')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.selected_items')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item">
                    <select tabindex="1" class="form-control" disabled>
                        <option value="-1"></option>
                    </select>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-22" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_22" value="22"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_22" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_22" value="3"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_22" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_22"
                            value="{{__('messages.numerical_item')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.numerical_item')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-23" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_23" value="23"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_23" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_23" value="4"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_23" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_23"
                            value="{{__('messages.numerical_item')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.numerical_item')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-24" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_24" value="24"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_24" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_24" value="5"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_24" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_24"
                            value="{{__('messages.numerical_item')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.numerical_item')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                </span>
            </li>
            <li class="ui-state-default list_item" id="li-25" col-size="1">
                <input type="text" hidden class="item_id"          id="item_id_25" value="25"/>
                <input type="text" hidden class="item_display_kbn" id="item_display_kbn_25" value="1"/>
                <input type="text" hidden class="item_arrangement_column" id="item_arrangement_column_25" value="6"/>
                <input type="text" hidden class="item_arrangement_line"   id="item_arrangement_line_25" value="9"/>
                <div class="d-flex justify-content-between sort-li">
                    
                    <span class="ics-textbox num-length">
                        <input
                            type="text"
                            class="form-control form-control-sm item_title"
                            id="item_title_25"
                            value="{{__('messages.numerical_item')}}"
                            hidden=""
                            tabindex="-1"
                            maxlength="20"
                        />
                        <label class="control-label text-name"
                                style="text-align: start;margin-bottom: 4px;white-space: nowrap;overflow: hidden;display: block">
                                {{__('messages.numerical_item')}}
                        </label>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
                <span class="num-length p-item" style="">
                    <input type="text" class="form-control" maxlength="10" tabindex="1" disabled>
                </span>
            </li>
        @endif
    </ul>
</div>
