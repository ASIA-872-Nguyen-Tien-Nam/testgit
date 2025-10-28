<div class="tab-pane fade" id="tab4">
    <input type="hidden" class="company_cd" value="{{($tab_01['company_cd']??'')}}"/>
    <div class="row">
        <div class="col-md-2 col-xl-2 col-lg-4">
            <div class="form-group">
                <label class="control-label  {{$check_lang=='en'?'lable-check1':''}}">{{ __('messages.blood_typ') }}
                </label>
                
                <div class="radio" id="blood_type" style="white-space: nowrap;min-width:225px">
                    @foreach($tab_01['blood_type'] as $key=>$item)
                        <div class="md-radio-v2 inline-block">
                            <input {{$disabled}} {{$tab_01['disabled_tab01']}} name="blood_type" type="radio" id="blood_rd{{$key}}" value="{{$item['number_cd']}}" {{($tab_01['data_tab_01']['blood_type']??0) == $item['number_cd']?'checked':''}}>
                            <label tabindex="1" for="blood_rd{{$key}}">{{$item['name']}}</label>
                        </div>
                    @endforeach
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label " style="display: block">
                    {{ __('messages.headquarters') }}
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="headquarters_prefectures" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_01['headquarters_prefectures'] as $row)
                    <option value="{{$row['number_cd']}}"
                        {{($tab_01['data_tab_01']['headquarters_prefectures']??'')==$row['number_cd']?'selected':''}}>
                        {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.headquarters_others') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="headquarters_other" 
                        @if (isset($screen_use) && $screen_use == 'M0070')
                            placeholder="{{ __('messages.enter_area') }}"
                        @endif
                        class="form-control" tabindex="1" value="{{$tab_01['data_tab_01']['headquarters_other']??''}}" maxlength="20">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label " data-container="body" data-toggle="tooltip" data-original-title=""
                    style="   display: block">
                    {{ __('messages.possibility_of_transfer') }}
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="possibility_transfer" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_01['possibility_transfer'] as $row)
                    <option value="{{$row['number_cd']}}"
                        {{($tab_01['data_tab_01']['possibility_transfer']??'')==$row['number_cd']?'selected':''}}>
                        {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="row"></div>
        <div class="row"></div>
        <div class="row"></div>
        <div class="row"></div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="{{$check_lang=='en'?'lb-size':''}} control-label {{$check_lang=='en'?'lable-check':''}}"
                    data-container="body" data-toggle="tooltip" data-original-title="" style="   display: block">
                    {{ __('messages.nationality') }}
                </label>
                <input hidden type="text" id="nationality" class="form-control" value="{{$tab_01['data_tab_01']['nationality_cd']??''}}">
                <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" class="form-control ui-autocomplete-input autocomplete-down-01 nationality" tabindex="1" 
                availableData = "{{$tab_01['nationality']}}"
                maxlength="3" value="{{$tab_01['data_tab_01']['nationality']??''}}" style="padding-right: 40px;" autocomplete="off">
            </div>
            <!--/.form-group -->
        </div>
        @if (isset($disabled) && $disabled == '')
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.residence_card_number') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="residence_card_no" class="form-control halfsize-numberic" tabindex="1" value="{{$tab_01['data_tab_01']['residence_card_no']??''}}" maxlength="12">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        @endif
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="{{$check_lang=='en'?'lb-size':''}} control-label {{$check_lang=='en'?'lable-check':''}}"
                    data-container="body" data-toggle="tooltip" data-original-title="" style="   display: block">
                    {{ __('messages.status_of_residence') }}
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="status_residence" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_01['status_residence'] as $row)
                    <option value="{{$row['number_cd']}}"
                        {{($tab_01['data_tab_01']['status_residence']??'')==$row['number_cd']?'selected':''}}>
                        {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.expire_date_of_stay') }}
                </label>
                <div class="input-group-btn input-group ">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="expiry_date" class="form-control input-sm date right-radius"
                        placeholder="yyyy/mm/dd" tabindex="1" value="{{$tab_01['data_tab_01']['expiry_date']??''}}">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i" tabindex="-1"
                            style="background: none !important"><i class="fa fa-calendar"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label {{$check_lang=='en'?'lb-size':''}} {{$check_lang=='en'?'lable-check':''}}"
                    data-container="body" data-toggle="tooltip" data-original-title="" style="   display: block">
                    {{ __('messages.extra_status_act') }}
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="permission_activities" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_01['permission_activities'] as $row)
                    <option value="{{$row['number_cd']}}"
                        {{($tab_01['data_tab_01']['permission_activities']??'')==$row['number_cd']?'selected':''}}>
                        {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="{{$check_lang=='en'?'lb-size':''}} control-label {{$check_lang=='en'?'lable-check':''}}"
                    data-container="body" data-toggle="tooltip" data-original-title="" style="   display: block">
                    {{ __('messages.disability_notebook_classification') }}
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="disability_classification" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_01['disability_classification'] as $row)
                    <option value="{{$row['number_cd']}}"
                        {{($tab_01['data_tab_01']['disability_classification']??'')==$row['number_cd']?'selected':''}}>
                        {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.disability_recognition_date') }}</label>

                <div class="input-group-btn input-group ">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="disability_recognition_date" class="form-control input-sm date right-radius"
                        placeholder="yyyy/mm/dd" tabindex="1" value="{{$tab_01['data_tab_01']['disability_recognition_date']??''}}">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i" tabindex="1"
                            style="background: none !important"><i class="fa fa-calendar"></i></button>
                    </div>
                </div>
            </div>
            <!--/.form-group -->
        </div>
       
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label
                    class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.failure_content') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="disability_content" class="form-control" tabindex="1" value="{{$tab_01['data_tab_01']['disability_content']??''}}" maxlength="50">
                </span>
            </div>
            <!--/.form-group -->
        </div>

    </div>
    <div class="row">
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.common_nm') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="common_name" class="form-control" tabindex="1" value="{{$tab_01['data_tab_01']['common_name']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.common_name_kana') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="common_name_furigana" class="form-control kana" tabindex="1" value="{{$tab_01['data_tab_01']['common_name_furigana']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.maiden_nm') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="maiden_name" class="form-control" tabindex="1" value="{{$tab_01['data_tab_01']['maiden_name']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.maiden_name_kana') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="maiden_name_furigana" class="form-control kana" tabindex="1" value="{{$tab_01['data_tab_01']['maiden_name_furigana']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class="row">
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.bussiness_nm') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="business_name" class="form-control" tabindex="1" value="{{$tab_01['data_tab_01']['business_name']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-3 col-xl-3 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.business_name_kana') }}</label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="text" id="business_name_furigana" class="form-control kana" tabindex="1" value="{{$tab_01['data_tab_01']['business_name_furigana']??''}}" maxlength="100">
                </span>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    @if (isset($disabled) && $disabled == '')
    <div class=" line-border-bottom">
        <label class="control-label ">{{ __('messages.attached_documents') }}</label>
    </div>
    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12 col-lg-9 col-xl-8" style="position:relative">
            <span class="num-length">
                <div class="form-group" style="position:absolute;z-index:-1">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="file" id="upload_file_1" class="form-control import_file" placeholder="" accept="application/pdf"
                        tabindex="1">
                    <input type="hidden" class="attached_file_name" id="attached_file1_name" value="{{($tab_01['data_tab_01']['attached_file1_name']??'')}}"/>
                    <input id="attached_file1" class="attached_file" type="hidden" value="{{($tab_01['data_tab_01']['attached_file1']??'')}}">
                    <input id="attached_file1_uploaddatetime" class="attached_file_uploaddatetime" type="hidden" value="{{($tab_01['data_tab_01']['attached_file1_uploaddatetime']??'')}}">
                </div>
                <div class="form-group form-control lh-input-custom " tabindex="1" readonly="readonly"
                    style="padding: 2px;margin-bottom: 0px;">
                    <div class="fake_input" style="">
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span class="face-file-btn btn_import" tabindex="1" style="padding-left: 6px;padding-right: 3px;">
                            <i class="fa fa-folder-open"></i>
                        </span>
                        @endif
                        <p class="file-name text-overflow" style="padding-top: 8px; margin-bottom:4px; width:70%">{{($tab_01['data_tab_01']['attached_file1_name']??'')}}</p>
                        <div class="ln-text-file text-overflow" style="padding: 0.375rem 2px;">&nbsp
                        </div>
                    </div>
                    <div style="float: right;margin-top: -32px;">
                        @if (isset($tab_01['data_tab_01']['attached_file1_uploaddatetime']) && $tab_01['data_tab_01']['attached_file1_uploaddatetime'] != '')
                        <span tabindex="1" class="btn-down uploadtime-01">
                            {{($tab_01['data_tab_01']['attached_file1_uploaddatetime']??'')}}
                        </span>
                        @endif
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span tabindex="1" class="btn-down btn-down-01">
                            <i class="fa fa-download"></i>
                        </span>
                        <span tabindex="1" class="btn-remove">
                            <i class="fa fa-remove"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </span>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12 col-lg-9 col-xl-8" style="position:relative">
            <span class="num-length">
                <div class="form-group" style="position:absolute;z-index:-1">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="file" id="upload_file_2" class="form-control import_file" placeholder="" accept="application/pdf"
                        tabindex="1">
                    <input type="hidden" class="attached_file_name" id="attached_file2_name" value="{{($tab_01['data_tab_01']['attached_file2_name']??'')}}"/>
                    <input id="attached_file2" class="attached_file" type="hidden" value="{{($tab_01['data_tab_01']['attached_file2']??'')}}">
                    <input id="attached_file2_uploaddatetime" class="attached_file_uploaddatetime" type="hidden" value="{{($tab_01['data_tab_01']['attached_file2_uploaddatetime']??'')}}">
                </div>
                <div class="form-group form-control lh-input-custom " tabindex="1" readonly="readonly"
                    style="padding: 2px;margin-bottom: 0px;">
                    <div class="fake_input" style="">
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span class="face-file-btn btn_import" tabindex="1" style="padding-left: 6px;padding-right: 3px;">
                            <i class="fa fa-folder-open"></i>
                        </span>
                        @endif
                        <p class="file-name text-overflow" style="padding-top: 8px; margin-bottom:4px; width:70%">{{($tab_01['data_tab_01']['attached_file2_name']??'')}}</p>
                        <div class="ln-text-file text-overflow" style="padding: 0.375rem 2px;">&nbsp
                        </div>
                    </div>
                    <div style="float: right;margin-top: -32px;">
                        @if (isset($tab_01['data_tab_01']['attached_file2_uploaddatetime']) && $tab_01['data_tab_01']['attached_file2_uploaddatetime'] != '')
                        <span tabindex="1" class="btn-down uploadtime-01">
                            {{($tab_01['data_tab_01']['attached_file2_uploaddatetime']??'')}}
                        </span>
                        @endif
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span tabindex="1" class="btn-down btn-down-01">
                            <i class="fa fa-download"></i>
                        </span>
                        <span tabindex="1" class="btn-remove">
                            <i class="fa fa-remove"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </span>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12 col-lg-9 col-xl-8" style="position:relative">
            <span class="num-length">
                <div class="form-group" style="position:absolute;z-index:-1">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="file" id="upload_file_3" class="form-control import_file" placeholder="" accept="application/pdf"
                        tabindex="1">
                    <input type="hidden" class="attached_file_name" id="attached_file3_name" value="{{($tab_01['data_tab_01']['attached_file3_name']??'')}}"/>
                    <input id="attached_file3" class="attached_file" type="hidden" value="{{($tab_01['data_tab_01']['attached_file3']??'')}}">
                    <input id="attached_file3_uploaddatetime" class="attached_file_uploaddatetime" type="hidden" value="{{($tab_01['data_tab_01']['attached_file3_uploaddatetime']??'')}}">
                </div>
                <div class="form-group form-control lh-input-custom " tabindex="1" readonly="readonly"
                    style="padding: 2px;margin-bottom: 0px;">
                    <div class="fake_input" style="">
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span class="face-file-btn btn_import" tabindex="1" style="padding-left: 6px;padding-right: 3px;">
                            <i class="fa fa-folder-open"></i>
                        </span>
                        @endif
                        <p class="file-name text-overflow" style="padding-top: 8px; margin-bottom:4px; width:70%">{{($tab_01['data_tab_01']['attached_file3_name']??'')}}</p>
                        <div class="ln-text-file text-overflow" style="padding: 0.375rem 2px;">&nbsp
                        </div>
                    </div>
                    <div style="float: right;margin-top: -32px;">
                        @if (isset($tab_01['data_tab_01']['attached_file3_uploaddatetime']) && $tab_01['data_tab_01']['attached_file3_uploaddatetime'] != '')
                        <span tabindex="1" class="btn-down uploadtime-01">
                            {{($tab_01['data_tab_01']['attached_file3_uploaddatetime']??'')}}
                        </span>
                        @endif
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span tabindex="1" class="btn-down btn-down-01">
                            <i class="fa fa-download"></i>
                        </span>
                        <span tabindex="1" class="btn-remove">
                            <i class="fa fa-remove"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </span>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12 col-lg-9 col-xl-8" style="position:relative">
            <span class="num-length">
                <div class="form-group" style="position:absolute;z-index:-1">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="file" id="upload_file_4" class="form-control import_file" placeholder="" accept="application/pdf"
                        tabindex="1">
                    <input type="hidden" class="attached_file_name" id="attached_file4_name" value="{{($tab_01['data_tab_01']['attached_file4_name']??'')}}"/>
                    <input id="attached_file4" class="attached_file" type="hidden" value="{{($tab_01['data_tab_01']['attached_file4']??'')}}">
                    <input id="attached_file4_uploaddatetime" class="attached_file_uploaddatetime" type="hidden" value="{{($tab_01['data_tab_01']['attached_file4_uploaddatetime']??'')}}">
                </div>
                <div class="form-group form-control lh-input-custom " tabindex="1" readonly="readonly"
                    style="padding: 2px;margin-bottom: 0px;">
                    <div class="fake_input" style="">
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span class="face-file-btn btn_import" tabindex="1" style="padding-left: 6px;padding-right: 3px;">
                            <i class="fa fa-folder-open"></i>
                        </span>
                        @endif
                        <p class="file-name text-overflow" style="padding-top: 8px; margin-bottom:4px; width:70%">{{($tab_01['data_tab_01']['attached_file4_name']??'')}}</p>
                        <div class="ln-text-file text-overflow" style="padding: 0.375rem 2px;">&nbsp
                        </div>
                    </div>
                    <div style="float: right;margin-top: -32px;">
                        @if (isset($tab_01['data_tab_01']['attached_file4_uploaddatetime']) && $tab_01['data_tab_01']['attached_file4_uploaddatetime'] != '' )
                        <span tabindex="1" class="btn-down uploadtime-01">
                            {{($tab_01['data_tab_01']['attached_file4_uploaddatetime']??'')}}
                        </span>
                        @endif
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span tabindex="1" class="btn-down btn-down-01">
                            <i class="fa fa-download"></i>
                        </span>
                        <span tabindex="1" class="btn-remove">
                            <i class="fa fa-remove"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </span>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-12 col-lg-9 col-xl-8" style="position:relative">
            <span class="num-length">
                <div class="form-group" style="position:absolute;z-index:-1">
                    <input {{$disabled}} {{$tab_01['disabled_tab01']}} type="file" id="upload_file_5" class="form-control import_file" placeholder="" accept="application/pdf"
                        tabindex="1">
                    <input type="hidden" class="attached_file_name" id="attached_file5_name" value="{{($tab_01['data_tab_01']['attached_file5_name']??'')}}"/>
                    <input id="attached_file5" class="attached_file" type="hidden" value="{{($tab_01['data_tab_01']['attached_file5']??'')}}">
                    <input id="attached_file5_uploaddatetime" class="attached_file_uploaddatetime" type="hidden" value="{{($tab_01['data_tab_01']['attached_file5_uploaddatetime']??'')}}">
                </div>
                <div class="form-group form-control lh-input-custom " tabindex="1" readonly="readonly"
                    style="padding: 2px;margin-bottom: 0px;">
                    <div class="fake_input" style="">
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span class="face-file-btn btn_import" tabindex="1" style="padding-left: 6px;padding-right: 3px;">
                            <i class="fa fa-folder-open"></i>
                        </span>
                        @endif
                        <p class="file-name text-overflow" style="padding-top: 8px; margin-bottom:4px; width:70%">{{($tab_01['data_tab_01']['attached_file5_name']??'')}}</p>
                        <div class="ln-text-file text-overflow" style="padding: 0.375rem 2px;">&nbsp
                        </div>
                    </div>
                    <div style="float: right;margin-top: -32px;">
                        @if (isset($tab_01['data_tab_01']['attached_file5_uploaddatetime']) && $tab_01['data_tab_01']['attached_file5_uploaddatetime'] != '')
                        <span tabindex="1" class="btn-down uploadtime-01">
                            {{($tab_01['data_tab_01']['attached_file5_uploaddatetime']??'')}}
                        </span>
                        @endif
                        @if ((isset($disabled) && $disabled == '') && (isset($tab_01['disabled_tab01']) && $tab_01['disabled_tab01'] == ''))
                        <span tabindex="1" class="btn-down btn-down-01">
                            <i class="fa fa-download"></i>
                        </span>
                        <span tabindex="1" class="btn-remove">
                            <i class="fa fa-remove"></i>
                        </span>
                        @endif
                    </div>
                </div>
            </span>
        </div>
    </div>
    @endif
    @if (isset($marcopolo_use_typ) && $marcopolo_use_typ == 1)
    <div class=" line-border-bottom">
        <label class="control-label ">{{ __('messages.result_analysis') }}</label>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.base_style') }}&nbsp;
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="base_style" class="form-control " tabindex="1">
                    <option value="0"></option>
                    @foreach($tab_01['style'] as $dt)
                    <option value="{{$dt['number_cd']}}" {{($tab_01['data_tab_01']['base_style']??0)==$dt['number_cd']?'selected':''}}>
                        {{$dt['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.sub_style') }}&nbsp;
                </label>
                <select {{$disabled}} {{$tab_01['disabled_tab01']}} name="" id="sub_style" class="form-control " tabindex="1">
                    <option value="0"></option>
                    @foreach($tab_01['style'] as $dt)
                    <option value="{{$dt['number_cd']}}" {{($tab_01['data_tab_01']['sub_style']??0)==$dt['number_cd']?'selected':''}}>
                        {{$dt['name']}}</option>
                    @endforeach
                </select>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="row">
                <div class="col-9">
                    <div class="form-group">
                        <label class="control-label " style=" min-width: 75px;">{{ __('messages.driver') }}&nbsp;
                        </label>
                        <input {{$disabled}} {{$tab_01['disabled_tab01']}} id="driver_point" type="text" value="{{($tab_01['data_tab_01']['driver_point']??'')}}"
                            class="form-control only-number numeric_range text-right" tabindex="1">
                    </div>
                </div>
                <div class="col-3" style="padding-left: 0px;width: 35px">
                    <label class="control-label ">&nbsp;</label>
                    <p class="ten_ten">{{ __('messages.point') }}</p>
                </div>
            </div>

            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="row">
                <div class="col-9">
                    <div class="form-group">
                        <label style="min-width: 120px;" class="control-label ">{{ __('messages.analytical') }}&nbsp;
                        </label>
                        <input {{$disabled}} {{$tab_01['disabled_tab01']}} id="analytical_point" value="{{($tab_01['data_tab_01']['analytical_point']??'')}}"
                            type="text" class="form-control only-number numeric_range text-right" tabindex="1">
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-3" style="padding-left: 0px;width: 35px">
                    <label class="control-label ">&nbsp;</label>
                    <p class="ten_ten">{{ __('messages.point') }}</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="row">
                <div class="col-9">
                    <div class="form-group">
                        <label style="min-width: 120px;" class="control-label">{{ __('messages.expressive') }}&nbsp;
                        </label>
                        <input {{$disabled}} {{$tab_01['disabled_tab01']}} id="expressive_point" value="{{($tab_01['data_tab_01']['expressive_point']??'')}}"
                            type="text" class="form-control only-number numeric_range text-right" tabindex="1">
                    </div>
                </div>
                <div class="col-3" style="padding-left: 0px">
                    <label class="control-label ">&nbsp;</label>
                    <p class="ten_ten">{{ __('messages.point') }}</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="row">
                <div class="col-9">
                    <div class="form-group">
                        <label class="control-label " style=" min-width: 75px;">{{ __('messages.amiable') }}&nbsp;
                        </label>
                        <div>
                            <input {{$disabled}} {{$tab_01['disabled_tab01']}} id="amiable_point" value="{{($tab_01['data_tab_01']['amiable_point']??'')}}"
                                type="text" class="form-control only-number numeric_range text-right"
                                style="text-align: left;" tabindex="1">
                        </div>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-3" style="padding-left: 0px">
                    <label class="control-label ">&nbsp;</label>
                    <p class="ten_ten">{{ __('messages.point') }}</p>
                </div>
            </div>
        </div>

    </div> <!-- end .row -->
    @endif
</div>