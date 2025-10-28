@if(!empty($items[0]))
<div class="row">
    @foreach ($items[0] as $item)
        @if($item['item_kind'] == 1)
            @php
                $max_length = $item['item_digits'];
                $class = '';
                if($item['item_digits'] < 20 ){
                    $class = 'col-md-6 col-xl-3 col-xs-12 col-lg-4 list_character';
                }
                if($item['item_digits'] >= 20 && $item['item_digits'] < 100 ){
                    $class = 'col-md-4 col-xs-12 col-lg-4 list_character';
                }
                if($item['item_digits'] >= 100 && $item['item_digits'] <= 200 ){
                    $class = 'col-md-6 col-xs-12 col-lg-6 list_character';
                }
            @endphp
            <div class="{{$class}}">
                <div class="form-group">
                    <label class="control-label ">
                        {{$item['item_nm']}}&nbsp;
                    </label>
                    <span class="num-length">
                    <input {{isset($disabled) ? $disabled : ''}}  value="{{$item['character_item']}}" type="text" class="form-control  character_item" maxlength="{{$item['item_digits']}}" tabindex="39">
                        <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        @endif
        @if($item['item_kind'] == 2)
            @if ( isset($screen_use) && ($screen_use = 'M0070' || $screen_use = 'EQ0101') )
                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-2 list_number_item" item_typ = "input">
                    <div class="form-group group_input_ ">
                        <label class="control-label ">
                            {{$item['item_nm']}}&nbsp;
                        </label>
                        @if ($item['item_digits'] == 1)
                                <span class="num-length">
                                    <input  {{isset($disabled) ? $disabled : ''}}  value="{{$item['number_item']!=''?$item['number_item']:'0.0'}}" type="text" class="form-control number_item1 number_item_blade number_item  text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                    maxlength="{{$item['item_digits']}}" tabindex="39" id="{{'item_'.$item['item_cd']}}" zero>
                                    <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                                </span>
                            @else
                                <span class="num-length">
                                    <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['number_item']!=''?$item['number_item']:'0.0'}}" type="text" class="form-control number_item1 number_item_blade number_item  text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                    decimal="1" maxlength="{{$item['item_digits']+2}}" tabindex="39" id="{{'item_'.$item['item_cd']}}" zero>
                                    <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                                </span>
                            @endif
                    </div>
                </div>
            @else
                <div class="col-md-6 col-xl-4 col-xs-12 col-lg-6 list_number_item" item_typ = "input">
                    <div class="form-group group_input_ ">
                        <label class="control-label ">
                            {{$item['item_nm']}}&nbsp;
                        </label>
                        @if ($item['item_digits'] == 1)
                            <div class="" style="display: flex" >
                                <div class="" style="width: 45%;min-width: 150px; max-width: 170px">
                                    <span class="num-length">
                                        <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['number_item']}}" type="text" class="form-control number_item1 number_item_blade from_number_item   text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                        maxlength="{{$item['item_digits']}}" tabindex="39" id="{{'from_item_'.$item['item_cd']}}">
                                    </span>
                                </div>
                                    <span style="margin-left: 10px;margin-right: 10px;line-height: 38px">~</span>
                                <div class=" " style="width: 45%;min-width: 150px; max-width: 170px">
                                    <span class="num-length">
                                        <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['number_item']}}" type="text" class="form-control number_item1 number_item_blade to_number_item   text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                        maxlength="{{$item['item_digits']}}" tabindex="39" id="{{'to_item_'.$item['item_cd']}}">
                                    </span>
                                </div>
                                <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                            </div>
                        @else
                            <div class="" style="display: flex" >
                                <div class="" style="width: 45%;min-width: 150px; max-width: 170px">
                                    <span class="num-length">
                                        <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['number_item']}}" type="text" class="form-control number_item1 number_item_blade from_number_item   text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                        decimal="1" maxlength="{{$item['item_digits']+2}}" tabindex="39" id="{{'from_item_'.$item['item_cd']}}">
                                    </span>
                                </div>
                                <span style="margin-left: 10px;margin-right: 10px;line-height: 38px">~</span>
                                <div class="" style="width: 45%;min-width: 150px; max-width: 170px">
                                    <span class="num-length">
                                        <input  {{isset($disabled) ? $disabled : ''}}   value="{{$item['number_item']}}" type="text" class="form-control number_item1 number_item_blade to_number_item   text-right" message_length="{{ __('messages.message_length_1'). $item['item_digits'] . __('messages.message_length_2')  }}"
                                        decimal="1" maxlength="{{$item['item_digits']+2}}" tabindex="39" id="{{'to_item_'.$item['item_cd']}}">
                                    </span>
                                </div>
                            </div>
                            <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                        @endif
                    </div>
                </div>
            @endif
        @endif
        @if($item['item_kind'] == 5)
            <div class="col-md-6 col-xl-3 col-xs-12 col-lg-4 list_number_item" item_typ = "selectbox">
                <div class="form-group">
                    <label class="control-label ">
                        {{$item['item_nm']}}&nbsp;
                    </label>
                    <select {{isset($disabled) ? $disabled : ''}}  name=""  class="form-control number_item" tabindex="39">
                        <option value="" ></option>
                        @if (isset($items[1][$item['item_cd']]))
                            @foreach($items[1][$item['item_cd']] as $dt)
                                <option value='{{$dt['detail_no']}}' {{$dt['selected_status']}}>{{$dt['detail_name']}}</option>
                            @endforeach
                        @endif

                    </select>
                    <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                </div>
                <!--/.form-group -->
            </div>
        @endif
        @if($item['item_kind'] == 4)
            <div class="col-md-6 col-xl-3 col-xs-12 col-lg-4  list_number_item" item_typ = "radiobox">
                <div class="form-group">
                    <label class="control-label ">
                        {{$item['item_nm']}}&nbsp;
                    </label>
                    {{-- @if (isset($screen_use) && $screen_use = 'M0070')
                        <div class="radio" style="word-break: break-all">
                            @if (isset($items[1][$item['item_cd']]))
                                @foreach($items[1][$item['item_cd']] as $index=> $value)
                                    <div class="md-radio-v2 inline-block " >
                                    <input {{isset($disabled) ? $disabled : ''}}   name="{{$value['item_cd']}}" class="number_item radio_box" type="radio" id="YY{{$value['item_cd'].$index}}"
                                        value="{{$value['detail_no']}}" {{($item['number_item']??0) ==$value['detail_no']?"checked":""}} maxlength="3" tabindex="39">
                                        <label for="YY{{$value['item_cd'].$index}}" class="" style="height: unset !important">
                                            <span>{{$value['detail_name']}}</span>
                                        </label>
                                    </div>
                                @endforeach
                            @endif
                        </div>
                    @else --}}
                        <div class="checkbox" style="word-break: break-all">
                            @if (isset($items[1][$item['item_cd']]))
                                @foreach($items[1][$item['item_cd']] as $index=> $value)
                                    <div class="md-checkbox-v2 inline-block">
                                        <input {{isset($disabled) ? $disabled : ''}}   name="{{$value['item_cd']}}" class="number_item radio_box" id="YY{{$value['item_cd'].$index}}" {{$value['selected_status']}}
                                        type="checkbox" value="{{$value['detail_no']}}" tabindex="39">
                                        <label for="YY{{$value['item_cd'].$index}}" class="" style="height: unset !important">
                                            <span>
                                                {{$value['detail_name']}}
                                            </span>
                                        </label>
                                    </div>
                                @endforeach
                            @endif
                        </div><!-- end .checkbox -->
                    {{-- @endif --}}
                </div><!--/.form-group -->
                <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
            </div>
        @endif
        @if($item['item_kind'] == 3)

                @if (isset($screen_use) && ($screen_use = 'M0070' || $screen_use = 'EQ0101') )
                    <div class="col-md-4 col-xs-12  col-lg-3 col-xl-3 list_date">
                        <div class="form-group">
                            <label class="control-label ">
                            {{$item['item_nm']}}&nbsp;
                            </label>
                            <div class="input-group-btn input-group input_date">
                                <input {{isset($disabled) ? $disabled : ''}}   type="text" class="form-control input-sm date right-radius date_item"  placeholder="yyyy/mm/dd" tabindex="39"
                                value="{{$item['date_item']??''}}" />
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i" tabindex="-1" style="background: none!important"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                            <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                        </div>
                        <!--/.form-group -->
                    </div>
                @else
                    <div class="col-md-6 col-xs-12  col-lg-6 col-xl-4 list_date">
                        <div class="form-group">
                            <label class="control-label ">
                            {{$item['item_nm']}}&nbsp;
                            </label>
                            <div class="input-group-btn input-group" >
                                <div class="input-group-btn input-group" style="width: 45%;min-width: 140px; max-width: 170px">
                                    <input {{isset($disabled) ? $disabled : ''}}  type="text" class="form-control input-sm date right-radius from_date_item"  placeholder="yyyy/mm/dd" tabindex="39"
                                    value="{{$item['date_item']??''}}" />
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i" tabindex="-1" style="background: none!important"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                                    <span style="margin-left: 10px;margin-right: 10px;line-height: 38px">~</span>
                                <div class="input-group-btn input-group" style="width: 45%;min-width: 140px; max-width: 170px">
                                    <input {{isset($disabled) ? $disabled : ''}}  type="text" class="form-control input-sm date right-radius to_date_item"  placeholder="yyyy/mm/dd" tabindex="39"
                                    value="{{$item['date_item']??''}}" />
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i" tabindex="-1" style="background: none!important"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
                            </div>
                            <input  value="{{$item['item_cd']}}" type="text" class="form-control hidden item_cd">
                        </div>
                        <!--/.form-group -->
                    </div>
                @endif


        @endif
    @endforeach
</div>
@endif