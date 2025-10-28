<div class="tab-pane fade {{isset ($disabled) && $disabled == 'disabled' ? '' : 'active show'}}" id="tab1">
    <div class="row">
        <div class="col-md-6 col-lg-4 col-xl-3 ee">
            <div class="form-group">
                <label class="control-label">{{ __('messages.user_id') }}</label>
                <span class="num-length">
                    <div class="input-group-btn btn-left">
                        <input  type="tel" class="form-control text-left " id="user_id" maxlength="50" placeholder="{{ __('messages.enter_halfwidth_character') }}"
                            value="{{$table1['user_id']??''}}" tabindex="1">
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-user"
                                    aria-hidden="true"></i></button>
                        </div>
                    </div>
                </span>
            </div>
        </div>
        <div class="col-md-9 col-lg-6 col-xl-4">
            <div class="row">
                <div class="col-md-8 col-8 col-lg-8 col-xl-8">
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.mail_password') }}</label>
                        <span class="num-length">
                            <div class="input-group-btn btn-left">
                                <input  type="text" class="form-control text-left show_typePassWord" id="password"
                                    maxlength="20" value="{{$table1['password']??''}}" tabindex="1" id="password"
                                    autocomplete="new-password" placeholder="{{ __('messages.enter_halfwidth_character') }}">
                                <div class="input-group-append-btn">
                                    <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-lock"
                                            aria-hidden="true"></i></button>
                                </div>
                            </div>
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>
                <div class="col-md-4 col-xl-4 col-lg-4 col-4">
                    <label class="control-label">&nbsp</label>
                    <div class="full-width">
                        <button id="btn_show_password" class="mb-1 btn btn-outline-primary btn-sm notview"
                            tabindex="1">
                            <i class="fa fa-eye-slash"></i>
                        </button>
                    </div><!-- end .full-width -->
                </div>

            </div>

        </div>
        <div class="col-md-4 col-xl-2 col-lg-3">
            <div class="col-md-">
                <div class="form-group">
                    <label class="control-label">&nbsp</label>
                    <div class="full-width">
                        <a href="javascript:;" class="btn btn-primary btn-basic-setting-menu btn-issue"
                            id="btn-random-pass" data-toggle="tooltip" title="{{__('messages.lable_25') }}"
                            tabindex="1">
                            {{ __('messages.auto_issue') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
            </div>
        </div><!-- end .col-md-4 -->
    </div><!-- end .row -->
    @if($SSO_use_typ == 1)
<div class="row">
    <div class="col-md-6">
        <div class="form-group">
            <label class="control-label">SSO{{ __('messages.user_id') }}</label>
            <span class="num-length">
                <div class="input-group-btn btn-left">
                    <input  type="text" class="form-control text-left" id="sso_user" maxlength="255"
                        value="{{$table1['sso_user']??''}}" tabindex="1">
                    <div class="input-group-append-btn">
                        <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-user"
                                aria-hidden="true"></i></button>
                    </div>
                </div>
            </span>
        </div>
    </div>
</div>
@endif

    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.sys_fun_authority') }}</label>
    </div>
    <div class="row s0010_info">
        <div class="col-md-6 col-xl-12 col-lg-12 col-xs-12" style="padding: 0 10px;">
            <div class="row">
                <div class="col-md-12 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.bs_authority') }}&nbsp;
                        </label>

                        <select name="" id="setting_authority_cd" class="form-control " tabindex="1"
                            {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @if (isset($commbo_setting_authority[0]))
                            @foreach($commbo_setting_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['setting_authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                            @endif

                        </select>
                    </div>
                </div>
                <div class="col-md-12 col-lg-3">

                    <div class="form-group">
                        <label class="control-label">{{ __('messages.emp_authority_infor') }}&nbsp;
                        </label>
                        <select name="" id="empinfo_authority_cd" class="form-control " tabindex="1"
                            {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @foreach($combo_empinfo_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['empinfo_authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="col-md-12 col-lg-1">
                    <div class="form-group">                    
                        <label
                        class="text-overfollow control-label"
                        data-container="body" data-toggle="tooltip"
                        data-original-title="{{ __('messages.general_manager') }}" style="display: block;width: 150%">
                        {{ __('messages.general_manager') }}
                        </label>
    
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="director_typ" id="director_typ"
                                    {{isset($table1['director_typ'])&&$table1['director_typ']==0?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="director_typ"></label>
                            </div>
                        </div>
                    </div>
                </div>
                @if(isset($multilingual_option_use_typ)&&$multilingual_option_use_typ==1)
                {{--  --}}
                <div class="col-md-12 col-lg-2">
                    <div class="form-group" style="margin-left: 20%;">
                        {{-- <label class="control-label text-overfollow">{{ __('messages.support_multiple_languages') }}</label> --}}

                        <label
                        class="text-overfollow control-label"
                        data-container="body" data-toggle="tooltip"
                        data-original-title="{{ __('messages.support_multiple_languages') }}" style="display: block">
                        {{ __('messages.support_multiple_languages') }}
                        </label>
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="multilingual_typ" id="multilingual_typ"
                                    {{isset($table1['multilingual_typ'])&&$table1['multilingual_typ']==1?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="multilingual_typ" id="multilingual_typ_lable"></label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-12 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.supported_lang') }}</label>   
                        <select name="" id="supported_languages" class="form-control" tabindex="1" {{isset($table1['multilingual_typ'])&&$table1['multilingual_typ']==1?'':'disabled'}}>
                            @foreach($l0014 as $dt)
                            <option value='{{$dt['language_cd']}}'
                                {{$dt['is_check'] != '' ? 'selected' : ''}}>
                                {{$dt['language_name']}}</option>
                            @endforeach                     
                        </select>
                    </div>
                </div>
                @endif
            </div>

        </div>
    </div>
    <div class="row s0010_info">
        @if (isset($evaluation_use_typ) && $evaluation_use_typ == 1)
        <div class="col-md-6 col-sm-6 col-xs-12 col-lg-3 col-xl-3" style="padding: 0 10px;">
            <div class="row">
                <div class="col-md-12">
                    @if (isset($evaluation_use_typ) && $evaluation_use_typ == 1)
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.pa_authority') }}&nbsp;
                        </label>
                        <select name="" id="authority_cd" class="form-control " tabindex="1"
                        {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @foreach($combo_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                    <!--/.form-group -->
                    @endif
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label text-overfollow mw-135" data-toggle="tooltip"
                            data-original-title="{{ __('messages.not_evaluation_subject') }}">
                            {{ __('messages.not_evaluation_subject') }}
                        </label>
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="evaluated_typ" id="evaluated_typ"
                                    {{isset($table1['evaluated_typ'])&&$table1['evaluated_typ']==0?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="evaluated_typ"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        @endif
        @if (isset($oneonone_use_typ) && $oneonone_use_typ == 1)
        <div class="col-md-6 col-sm-6 col-xs-12 col-lg-3 col-xl-3" style="padding: 0 10px;">
            <div class="row">
                <div class="col-md-12">
                    @if (isset($oneonone_use_typ) && $oneonone_use_typ == 1)
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.1on1_authority') }}&nbsp;
                        </label>
                        <select name="" id="oneonone_authority_cd" class="form-control " tabindex="1"
                        {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @foreach($combo_oneonone_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['oneonone_authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                    <!--/.form-group -->
                    @endif
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label text-overfollow mw-135" data-toggle="tooltip"
                            data-original-title="{{ __('messages.not_1on1_subject') }}">
                            {{ __('messages.not_1on1_subject') }}
                        </label>
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="oneonone_typ" id="oneonone_typ"
                                    {{isset($table1['oneonone_typ'])&&$table1['oneonone_typ']==0?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="oneonone_typ"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        @endif
        @if (isset($multireview_use_typ) && $multireview_use_typ == 1)
        <div class="col-md-6 col-sm-6 col-xs-12 col-lg-3 col-xl-3 " style="padding: 0 10px;">
            <div class="row">
                <div class="col-md-12">
                    @if (isset($multireview_use_typ) && $multireview_use_typ == 1)
                    <div class="form-group">
                        <label style="min-width: 140px;" class="control-label">{{ __('messages.mr_authority') }}&nbsp;
                        </label>
                        <select name="" id="multireview_authority_cd" class="form-control " tabindex="1"
                        {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @foreach($combo_multi_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['multireview_authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                    <!--/.form-group -->
                    @endif
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label text-overfollow mw-135" data-toggle="tooltip"
                            data-original-title="{{ __('messages.not_mr_subject') }}">{{ __('messages.not_mr_subject') }}</label>
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="multireview_typ" id="multireview_typ"
                                    {{isset($table1['multireview_typ'])&&$table1['multireview_typ']==0?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="multireview_typ"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        @endif
        @if (isset($report_use_typ) && $report_use_typ == 1)
        <div class="col-md-6 col-sm-6 col-xs-12 col-lg-3 col-xl-3 " style="padding: 0 10px;">
            <div class="row">
                <div class="col-md-12">
                    @if (isset($report_use_typ) && $report_use_typ == 1)
                    <div class="form-group">
                        <label style="min-width: 140px;"
                            class="control-label">{{ __('messages.weekly_report_authorization_master') }}&nbsp;
                        </label>
                        <select name="" id="report_authority_cd" class="form-control " tabindex="1"
                        {{($table1['director_typ']??'0') != 1?'disabled':'' }}>
                            <option value="0"></option>
                            @foreach($combo_weekly_report_authority as $dt)
                            <option value='{{$dt['authority_cd']}}'
                                {{$dt['authority_cd'] == ($table1['report_authority_cd']??'') ? 'selected' : ''}}>
                                {{$dt['authority_nm']}}</option>
                            @endforeach
                        </select>
                    </div>
                    <!--/.form-group -->
                    @endif
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label class="control-label text-overfollow mw-135" data-toggle="tooltip"
                            data-original-title="{{ __('messages.not_mr_subject') }}">{{ __('messages.not_ubject_to_weekly_report') }}</label>
                        <div class="checkbox">
                            <div class="md-checkbox-v2">
                                <input  name="report_typ" id="report_typ"
                                    {{isset($table1['report_typ'])&&$table1['report_typ']==0?'checked':''}}
                                    type="checkbox" value="1" tabindex="1">
                                <label for="report_typ"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        @endif
    </div>
    <!--/.end.row -->

</div>