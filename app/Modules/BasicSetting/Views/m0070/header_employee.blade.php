@php
$check_lang = \Session::get('website_language', config('app.locale'));
@endphp

        <div class="row header_employee">
            <div class="col-auto">
                <div class="row">
                    <div class="col-md-4 col-xl-3 col-lg-3  col-xxl-2 div_parent_employee_cd">
                        <div class="form-group rq">
                            <label class="control-label lb-required {{$check_lang=='en'?'lb-size':''}}"
                                lb-required="{{ __('messages.required') }}"
                                style="min-width: 160px;">{{ __('messages.employee_no') }}
                            </label>
                            <div class="input-group-btn input-group div_employee_cd">
                                <span class="num-length">
                                    <input autocomplete="off" type="text"
                                        class="form-control indexTab employee_cd required Convert-Halfsize "
                                        id="employee_cd" tabindex="1" maxlength="10"
                                        value="{{$keep_emp==1?($employee_cd??''):''}}" style="padding-right: 40px;" />
                                    <input type="hidden" value="0" id="is_refer" hidden/>
                                </span>
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent btn_employee_cd_popup" type="button"
                                        tabindex="-1">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-xl-3 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.surname') }}</label>
                            <span class="num-length">
                                <input autocomplete="off" type="text" class="form-control" tabindex="1" maxlength="50" id="employee_last_nm"
                                    value="{{$table1['employee_last_nm']??''}}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-6 col-xl-3 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label {{$check_lang=='en'?'lb-size':''}}">{{ __('messages.first_name') }}
                            </label>
                            <span class="num-length">
                                <input autocomplete="off" type="text" class="form-control" tabindex="1" maxlength="50"
                                    id="employee_first_nm" value="{{$table1['employee_first_nm']??''}}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                    <div class="col-md-6 col-xl-3 col-xxl-4 div_parent_employee_nm">
                        <div class="form-group {{$check_lang=='en'?'rq1':''}}">
                            <label class="control-label lb-required {{$check_lang=='en'?'lb-size':''}}"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.full_name') }}<div
                                    class="{{$check_lang=='en'?'aaa':'bbb'}}"></div></label>
                            <span class="num-length">
                                <input autocomplete="off" type="text" class="form-control required" tabindex="1" maxlength="101"
                                    id="employee_nm" value="{{$table1['employee_nm']??''}}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
                </div> <!-- .row -->

                <div class="row">
                    <!-- <div class="col-md-6 col-xl-3 col-lg-4">
						<div class="form-group">
							<label class="control-label">{{ __('messages.name_abbreviation') }}</label>
							<span class="num-length">
								<input autocomplete="off" type="text" class="form-control" tabindex="5" maxlength="10" id="employee_ab_nm" value="{{$table1['employee_ab_nm']??''}}" />
							</span>
						</div>
					</div> -->
                    <div class="col-md-2 col-xl-2 col-lg-4  {{$check_lang=='en'?'hidden':''}}">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.furigana') }}
                            </label>
                            <span class="num-length">
                                <input autocomplete="off" type="text" class="form-control kana" tabindex="1" maxlength="50" id="furigana"
                                    value="{{$table1['furigana']??''}}" />
                            </span>
                        </div>
                        <!--/.form-group -->
                    </div>
					<div class="col-md-col3">
                        <div class="form-group">
                            <label class="control-label lb-required"
                                lb-required="{{ __('messages.required') }}">{{ __('messages.join_date') }}
                            </label>
                            <div class="input-group-btn input-group ">
                                <input autocomplete="off" type="text" id="company_in_dt"
                                    class="form-control input-sm date right-radius required" placeholder="yyyy/mm/dd"
                                    tabindex="1" value="{{$table1['company_in_dt']??''}}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1" style="background: none !important"><i
                                            class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-col5">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.seniority') }}</label>
                            <div>
                                <input autocomplete="off" type="text" id="period_date" class="form-control wd"
                                    value="{{$table1['period_date']??''}}" disabled>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-col1 ">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.date_birth') }}
                            </label>
                            <div class="input-group-btn input-group">
                                <input autocomplete="off" type="text" id="birth_date" class="form-control input-sm date right-radius"
                                    placeholder="yyyy/mm/dd" tabindex="1" value="{{$table1['birth_date']??''}}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                        tabindex="-1"><i class="fa fa-calendar"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 col-lg-2 col-xl-2">
                        <div class="form-group">
                            <label class="control-label ">{{ __('messages.age') }}</label>
                            <div>
                                @if(isset($table1['year_old'])&&$table1['year_old']!=0)
                                <input autocomplete="off" type="text" id="year_old" class="form-control"
                                    value="{{$table1['year_old']??''}}" tabindex="-1" disabled>
                                    @else
                                <input autocomplete="off" type="text" id="year_old" class="form-control"
                                    value="" tabindex="-1" disabled>
                                @endif
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2 col-xl-2 col-lg-4">
                        <div class="form-group">
                            <label
                                class="control-label  {{$check_lang=='en'?'lable-check1':''}}">{{ __('messages.sex') }}
                            </label>
                            <div class="radio" id="radio-aaa" style="white-space: nowrap;min-width:225px">
                                <div class="md-radio-v2 inline-block">
                                    <input autocomplete="off" name="gender" type="radio" id="rd1" value="1" tabindex="1"
                                        {{($table1['gender']??1) == 1?'checked':''}}>
                                    <label for="rd1"  tabindex="1">{{ __('messages.male') }}</label>
                                </div>
                                <div class="md-radio-v2 inline-block">
                                    <input autocomplete="off" name="gender" type="radio" id="rd2" value="2" tabindex="1"
                                        {{($table1['gender']??1) == 2?'checked':''}}>
                                    <label for="rd2"  tabindex="1">{{ __('messages.female') }}</label>
                                </div>
                                <div class="md-radio-v2 inline-block">
                                    <input autocomplete="off" name="gender" type="radio" id="rd3" value="3" tabindex="1"
                                        {{($table1['gender']??1) == 3?'checked':''}}>
                                    <label for="rd3"  tabindex="1" >{{ __('messages.others') }}</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> <!-- end .row -->
            </div>

            <input autocomplete="off" type="hidden" id="modePic" value="N" />
            <div class="col-auto2" >
                <div class="avatar">
                    <div class="img ">
                        <div
                            class="d-flex flex-box {{(!isset($table1['picture']) || $table1['picture'] == '')?"flex-box-image":""}}">
                            @if(!isset($table1['picture']) || $table1['picture'] == '')
                            <p class="w100">{{ __('messages.photo') }}</p>
                            <img id="img-upload" class="thumb" />
                            @else
                            <img id='img-upload' class="thumb imgs" src="{{$table1['picture']}}?v={{time()}}" />
                            {{--<div class="thumb" src="{{$table1['picture']}}?v={{time()}}">
                        </div>--}}
                        @endif


                    </div><!-- end .d-flex -->
                </div>
                {{-- 	<div class="img" style="margin-top: 5px;">
						<div class="d-flex flex-box portrait">
							 @if(isset($table1['picture'])&& $table1['picture'] !='')
							 	<div class="portrait-img" style="background: url({{$table1['picture']}}) center center;">
            </div>
            @else
            <div class="portrait-img"></div>
            @endif
        </div>
    </div> --}}

    <div id="imageMain" class="text-center">
        <label id="btn-upload" for="realupload" class="face-file-btn" tabindex="1">
            <i class="fa fa-folder-open fa1"></i>
        </label>
        <button id="btn-delete-file" class="btn-clearfile" tabindex="1">
            <i class="fa fa-trash fa3"></i>
        </button>
        <div id="avatar_block" >
            <div id="file_error" style="margin-bottom:30px;display:none"></div>
        </div>
        {{--<button type="file" id="btn-upload" class="btn btn-primary btn-sm"></button>--}}
        <div class="input-group hidden">
            <span class="input-group-btn">
                <span class="btn btn-default btn-file">
                    Browse… <input autocomplete="off" type="file" id="imgInp" accept="image/*">
                </span>
            </span>
            <input type="text" class="form-control" readonly>
        </div>

    </div>
</div>
