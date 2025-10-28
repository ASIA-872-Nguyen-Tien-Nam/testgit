<div class="tab-pane fade" id="tab7">
    <div class="row">
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3" style="min-width:190px">
            <div class="form-group">
                <label class=" control-label " data-container="body"
                    data-toggle="tooltip" data-original-title=""
                    style="display: block">{{ __('messages.ownership_classification') }}
                </label>
                <select {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" name="" id="owning_house_kbn" class="form-control" tabindex="1" organization_typ="">
                    <option></option>
                    @foreach($tab_06['owning_house_kbn'] as $row)
                    <option value="{{$row['number_cd']}}" {{($tab_06['data_tab_06']['owning_house_kbn']??'')==$row['number_cd']?'selected':''}}>
                    {{$row['name']}}</option>
                    @endforeach
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.head_of_household') }}</label>
                <span class="num-length">
                    <div class="input-group-btn btn-left md-checkbox-v2">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="checkbox" name="head_household" id="head_household" {{isset($tab_06['data_tab_06']['head_household'])&&$tab_06['data_tab_06']['head_household']==1?'checked':''}} value="{{$tab_06['data_tab_06']['head_household']??''}}" tabindex="1">
                        <label id="" for="head_household"></label>
                    </div>
                </span>
            </div>
            <!--/.form-group -->
            <!--/.form-group -->
        </div>
    </div>
    <div class="div-zip-cd">
        <div class="row">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4">
                <div class="form-group">
                    <label class=" control-label " data-container="body"
                        data-toggle="tooltip" data-original-title="" style=" display: block">
                        {{ __('messages.post_code') }}
                    </label>
                    <span class="num-length">
                        <div class="input-group-btn btn-left">
                        <input type="text" class="form-control zip_cd" id="post_code" 
                        @if (isset($screen_use ) && $screen_use == 'M0070') placeholder="0010001" @endif
                        maxlength="7" {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" value="{{$tab_06['data_tab_06']['post_code']??''}}">
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled="">〒</button>
                        </div>
                    </div>
                    </span>

                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                <div class="form-group">
                    <label class=" control-label">{{ __('messages.prefectures') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="address1" class="form-control prefectures" value="{{$tab_06['data_tab_06']['address1']??''}}" maxlength="10">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            @if (isset($disabled) && $disabled == 'disabled')
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group ">
                    <label class="control-label ">{{ __('messages.city_ward_town') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="address2" class="form-control city_ward_town" value="{{$tab_06['data_tab_06']['address2']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            @endif

            <!--/.form-group -->
        </div>

        @if (isset($disabled) && $disabled == '')
        <div class="row">
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group ">
                    <label class="control-label ">{{ __('messages.city_ward_town') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="address2" class="form-control city_ward_town" value="{{$tab_06['data_tab_06']['address2']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.street_address') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="address3" class="form-control street_address" value="{{$tab_06['data_tab_06']['address3']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
        @endif
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.home_phone') }}</label>
                <span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.placeholder_number_phone') : ''}}" id="home_phone_number" class="form-control tel-haifun" maxlength="20" tabindex="7" value="{{$tab_06['data_tab_06']['home_phone_number']??''}}">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
					</div>
				</div>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.personal_phone') }}</label>
                <span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.placeholder_number_phone') : ''}}" id="personal_phone_number" class="form-control tel-haifun" maxlength="20" tabindex="7" value="{{$tab_06['data_tab_06']['personal_phone_number']??''}}">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
					</div>
				</div>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.personal_email') }}
                </label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} type="text" class="form-control email" id="personal_email_address" maxlength="100" tabindex="1"
                            value="{{$tab_06['data_tab_06']['personal_email_address']??''}}" tabindex="10">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} type="text" maxlength="100" id="language_pass" value="{{$tab_06['language']??''}}" hidden>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled="">@</button>
                        </div>
                    </div>
                </span>
            </div>
            <!--/.form-group -->
        </div>
    </div>
    <div class=" line-border-bottom">
        <label class="control-label ">{{ __('messages.emergency_contact') }}</label>
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class=" control-label " data-container="body"
                    data-toggle="tooltip" data-original-title="" style="max-width: 150px;    display: block">
                    {{ __('messages.full_nm') }}
                </label>
                <span class="num-length">
                    <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_name" class="form-control" value="{{$tab_06['data_tab_06']['emergency_contact_name']??''}}" maxlength="50">
                </span>

            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label">{{ __('messages.relationship') }}</label>
                <div class="input-group-btn input-group">
                    <span class="num-length">
                        <input hidden type="text" id="relationship" class="form-control" value="{{$tab_06['data_tab_06']['relationship_cd']??''}}">
                        <input type="text" class="form-control ui-autocomplete-input autocomplete-down-06 relationship" tabindex="1" availableData = "{{ $tab_06['relationship']}}"
                            maxlength="10" value="{{$tab_06['data_tab_06']['relationship']??''}}" style="padding-right: 40px;" autocomplete="off" {{$disabled}} {{$tab_06['disabled_tab06']}}>
                    </span>
                </div>
            </div>
            <!--/.form-group -->
        </div>
        <div class="col-md-2 col-xl-2 col-xs-6 col-lg-2">
            <div class="form-group input_date">
                <label class=" control-label " data-container="body"
                    data-toggle="tooltip" data-original-title="" style="max-width: 150px;    display: block">
                    {{ __('messages.date_birth') }}
                </label>
                <div class="input-group-btn input-group ">
                    <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_birthday"
                        class="form-control input-sm date right-radius emergency_contact_birthday" placeholder="yyyy/mm/dd" tabindex="1"
                        value="{{$tab_06['data_tab_06']['emergency_contact_birthday']??''}}">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                            tabindex="-1" style="background: none !important"><i
                                class="fa fa-calendar"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-2 col-xl-2 col-xs-6 col-lg-3">
                <div class="form-group">
                    <label class=" control-label " data-container="body"
                        data-toggle="tooltip" data-original-title="" style="max-width: 150px;    display: block">
                        {{ __('messages.age') }}
                    </label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} disabled tabindex="1" type="text" id="" class="form-control year_old" value="{{$tab_06['data_tab_06']['year_old']??''}}"
                            maxlength="50">
                    </span>
                </div>
        </div>
    </div>
    <div class="div-zip-cd">
        <div class="row">
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-4">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.post_code') }}</label>
                    <span class="num-length">
                        <div class="input-group-btn btn-left">
                        <input type="text" class="form-control zip_cd" id="emergency_contact_post_code" @if (isset($screen_use ) && $screen_use == 'M0070') placeholder="0010001" @endif maxlength="7" {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" value="{{$tab_06['data_tab_06']['emergency_contact_post_code']??''}}">
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled="">〒</button>
                        </div>
                    </div>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.prefectures') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_addres1" class="form-control prefectures" value="{{$tab_06['data_tab_06']['emergency_contact_addres1']??''}}" maxlength="10">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            @if (isset($disabled) && $disabled == 'disabled')
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.city_ward_town') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_addres2" class="form-control city_ward_town" value="{{$tab_06['data_tab_06']['emergency_contact_addres2']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            @endif
        </div>
        @if (isset($disabled) && $disabled == '')
        <div class="row">
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.city_ward_town') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_addres2" class="form-control city_ward_town" value="{{$tab_06['data_tab_06']['emergency_contact_addres2']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
            <div class="col-md-4 col-xl-6 col-xs-12 col-lg-6">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.street_address') }}</label>
                    <span class="num-length">
                        <input {{$disabled}} {{$tab_06['disabled_tab06']}} tabindex="1" type="text" id="emergency_contact_addres3" class="form-control street_address" value="{{$tab_06['data_tab_06']['emergency_contact_addres3']??''}}" maxlength="50">
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
        @endif
    </div>
    <div class="row">
        <div class="col-md-4 col-xl-4 col-xs-12 col-lg-4">
            <div class="form-group">
                <label class="control-label ">{{ __('messages.phone_number') }}</label>
                <span class="num-length">
				<div class="input-group-btn btn-left">
					<input type="text" {{$disabled}} {{$tab_06['disabled_tab06']}}   placeholder="{{isset ($disabled) && $disabled == '' ? __('messages.placeholder_number_phone') : ''}}" tabindex="1" id="emergency_contact_phone_number" class="form-control tel-haifun" maxlength="20" tabindex="7" value="{{$tab_06['data_tab_06']['emergency_contact_phone_number']??''}}">
					<div class="input-group-append-btn">
						<button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-phone"></i></button>
					</div>
				</div>
			</span>
            </div>
            <!--/.form-group -->
        </div>
    </div>
</div>