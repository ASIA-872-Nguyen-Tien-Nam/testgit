<style type="text/css" media="screen">
    .table td {
        vertical-align: unset !important;
    }

    .md-checkbox-v2 input[type="checkbox"]:checked+label {
        white-space: unset !important;
    }
</style>
<div class="row">
    <div class="col-md-5 col-lg-4 col-xl-3 col-sm-12 col-12 group_cd">
        <div class="form-group">
            <label class="control-label">{{ __('messages.group_cd') }}</label>
            <input type="text" id="group_cd" class="form-control text-left" value="{{ $listm4600['group_cd'] ?? '' }}" tabindex="-1" readonly />
        </div>
    </div>
    <div class="col-md-6 col-lg-5 col-xl-4 col-sm-12 col-12">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.group_name') }}</label>
            <span class="num-length">
                <input type="text" id="group_nm" class="form-control required " placeholder="{{ __('messages.general_group') }}" maxlength="20" value="{{ $listm4600['group_nm'] ?? '' }}" tabindex="1">
            </span>
        </div>
    </div>
</div>

<div class="row">
    @if(isset($organization_group[0]) && !empty($organization_group[0]))
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
        <div class="form-group">
        @if (is_array($organization_group) &&is_array($organization_group[0]) && isset($organization_group[0]['organization_group_nm'])) 
            <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="max-width: 150px;    display: block">
                {{$organization_group[0]['organization_group_nm']}}
            </label>
        @endif
            <select name="" id="organization_step1" class="form-control organization_cd1" tabindex="36" organization_typ='1'>
                <option value="-1"></option>
                @foreach($combo_organization as $row)
                @if(isset($row['organization_cd_1']))
                <option value="{{$row['organization_cd_1']}}" {{($listm4600['belong_cd1']??'')==$row['organization_cd_1']?'selected':''}}>{{$row['organization_nm']}}</option>
                @endif
                @endforeach
            </select>
        </div>
        <!--/.form-group -->
    </div>
    @endif
    @php
    if($count_organization_cd < count($organization_group)){ $count_organization_cd=count($organization_group); } @endphp @foreach($organization_group as $dt) 
    @if (is_array($dt) && isset($dt['organization_typ'])) 
    @if($dt['organization_typ']>=2)
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}" style="max-width: 150px;    display: block">
                    {{$dt['organization_group_nm']}}
                </label>
                <select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="37" organization_typ="{{$dt['organization_typ']}}">
                    <option value="-1"></option>
                    @if (is_array($dt) && isset($dt['organization_typ']) && isset($organization_group_total[$dt['organization_typ']])) 
                    @if($organization_group_total[$dt['organization_typ']] != null && count($organization_group_total[$dt['organization_typ']]) > 0)
                    @foreach($organization_group_total[$dt['organization_typ']] as $row)
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" {{($listm4600['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']]?'selected':''}}>
                        {{$row['organization_nm'] }}
                    </option>
                    @endforeach
                    {{-- @foreach($organization_group_total['2']) as $row)
											<option value="0"></option>

											<option value="{{$row['organization_cd']}}" {{($listm4600['belong_cd'.$dt['organization_typ']]??0)==$row['organization_cd']?'selected':''}}>{{$row['organization_nm']}} {{}}</option>
                    @endforeach --}}
                    @endif
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
        @endif
        @endif
        @endforeach
</div>
<div class="row">
    <div class="col-md-12">
        <div class="table-responsive">
            <table class="table table-bordered table-hover" id="table-data_1" style="">
                <thead>
                    <tr>
                        <th style="width: 250px;max-width: 250px">{{ __('messages.position') }}</th>
                        <th style="width: 250px;max-width: 250px">{{ __('messages.job') }}</th>
                        <th style="width: 250px;max-width: 250px">{{ __('messages.grade') }}</th>
                        <th style="width: 250px;max-width: 250px">{{ __('messages.employee_classification') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td scope="row" class="text-left listm0040" style="max-width: 250px !important">
                            <div>
                                <ul class="multiselect-list2">
                                    @if (!empty($list_m0040))
                                    @foreach ($list_m0040 as $key => $m0040)
                                    <li class="active m0040">
                                        <div class="md-checkbox-v2 ">
                                            <input name="1" id="{{ $key . 'm0040' }}" {{ isset($m0040['checked']) && $m0040['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0040['position_cd'] ?? '' }}" class="list_m0040" tabindex="7">
                                            <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0040['position_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0040' }}">{{ $m0040['position_nm'] ?? '' }}
                                            </label>
                                        </div>
                                    </li>
                                    @endforeach
                                    @endif
                                </ul>
                            </div>
                        </td>
                        <td scope="row" class="text-left listm0030" style="max-width: 250px !important">
                            <div>
                                <ul class="multiselect-list2">
                                    @if (!empty($list_m0030))
                                    @foreach ($list_m0030 as $key => $m0030)
                                    <li class="active m0030">
                                        <div class="md-checkbox-v2 ">
                                            <input name="2" id="{{ $key . 'm0030' }}" {{ isset($m0030['checked']) && $m0030['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0030['job_cd'] ?? '' }}" class="list_m0030" tabindex="8">
                                            <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0030['job_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0030' }}">{{ $m0030['job_nm'] ?? '' }}
                                            </label>
                                        </div>
                                    </li>
                                    @endforeach
                                    @endif
                                </ul>
                            </div>
                        </td>
                        <td scope="row" class="text-left listm0050" style="max-width: 250px !important">
                            <div>
                                <ul class="multiselect-list2">
                                    @if (!empty($list_m0050))
                                    @foreach ($list_m0050 as $key => $m0050)
                                    <li class="active m0050">
                                        <div class="md-checkbox-v2 ">
                                            <input name="3" id="{{ $key . 'm0050' }}" {{ isset($m0050['checked']) && $m0050['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0050['grade'] ?? '' }}" class="list_m0050" tabindex="9">
                                            <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0050['grade_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0050' }}">{{ $m0050['grade_nm'] ?? '' }}
                                            </label>
                                        </div>
                                    </li>
                                    @endforeach
                                    @endif
                                </ul>
                            </div>
                        </td>
                        <td scope="row" class="text-left listm0060" style="max-width: 250px !important">
                            <div>
                                <ul class="multiselect-list2">
                                    @if (!empty($list_m0060))
                                    @foreach ($list_m0060 as $key => $m0060)
                                    <li class="active m0060">
                                        <div class="md-checkbox-v2 ">
                                            <input name="4" id="{{ $key . 'm0060' }}" {{ isset($m0060['checked']) && $m0060['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0060['employee_typ'] ?? '' }}" class="list_m0060" tabindex="10">
                                            <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0060['employee_typ_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0060' }}">{{ $m0060['employee_typ_nm'] ?? '' }}
                                            </label>
                                        </div>
                                    </li>
                                    @endforeach
                                    @endif
                                </ul>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div>

<hr style="height: 2px;width: 100%;border-top: 2px solid rgba(0,0,0,.1);">

<div class="row">
    <div class="col-md-12 col-lg-2 col-xl-1">
        <div class="form-group">
            <label class="control-label">{{ __('rm0300.viewing_range') }}</label>
        </div>
    </div>
    <div class="col-md-12 col-lg-10 col-xl-11">
        <div class="row">
            <div class="md-checkbox-v2 " style="margin-left: 10px">
                <input   {{isset($listm4600['browse_position_typ']) && $listm4600['browse_position_typ'] == 1 ? 'checked' : ''}} value="{{isset($listm4600['browse_position_typ']) && $listm4600['browse_position_typ'] == 1 ? 1 : 0}}" name="2" id="browse_position_typ" type="checkbox" class="list_m0030" tabindex="11">
                <label class="label-error container label-error_browse_position_typ" data-toggle="tooltip" style="min-width: 100%" for="browse_position_typ">{{ __('rm0300.lb2') }}
                </label>
            </div>
        </div>
        <div class="row">
            <div class="md-checkbox-v2 " style="margin-left: 10px">
                <input name="2"  {{isset($listm4600['browse_department_typ']) && $listm4600['browse_department_typ'] == 1 ? 'checked' : ''}} value="{{isset($listm4600['browse_department_typ']) && $listm4600['browse_department_typ'] == 1 ? 1 : 0}}" id="browse_department_typ" type="checkbox" class="list_m0030" tabindex="12">
                <label class="label-error label-error_browse_department_typ container" data-toggle="tooltip" style="min-width: 100%" for="browse_department_typ">{{ __('rm0300.lb1') }}
                </label>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12 col-lg-2 col-xl-1">
        <div class="form-group">
            <label class="control-label">{{ __('rm0300.individual_setting') }}</label>
        </div>
    </div>
    <div class="col-md-12 col-lg-10 col-xl-11">
    <div class="row">
    @if(isset($organization_group[0]) && !empty($organization_group[0]))
    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
        <div class="form-group">
            <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="max-width: 150px;    display: block">
                {{$organization_group[0]['organization_group_nm']}}
            </label>
            <select name="" id="organization_step2_1" class="form-control organization_cd21 " {{isset($listm4600['browse_department_typ']) && $listm4600['browse_department_typ'] == 1 ? 'disabled' : ''}} tabindex="36" organization_typ='1' system="5">
                <option value="-1"></option>
                @foreach($combo_organization as $row)
                <option value="{{$row['organization_cd_1']}}" {{($listm4600['belong_cd2_1']??'')==$row['organization_cd_1']?'selected':''}}>{{$row['organization_nm']}}</option>
                @endforeach
            </select>
        </div>
        <!--/.form-group -->
    </div>
    @endif
    @php
    if($count_organization_cd < count($organization_group)){ $count_organization_cd=count($organization_group); } @endphp @foreach($organization_group as $dt) 
    @if (is_array($dt) && isset($dt['organization_typ'])) 
    @if($dt['organization_typ']>=2)
        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
            <div class="form-group">
                <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}" style="max-width: 150px;    display: block">
                    {{$dt['organization_group_nm']}}
                </label>
                <select name="" system="5" id="{{'organization_step2_'.$dt['organization_typ']}}" {{isset($listm4600['browse_department_typ']) && $listm4600['browse_department_typ'] == 1 ? 'disabled' : ''}} class="form-control {{'organization_cd2'.$dt['organization_typ']}}" tabindex="37" organization_typ="{{$dt['organization_typ']}}">
                    <option value="-1"></option>
                    @if (is_array($organization_group_total2) && isset($organization_group_total2[$dt['organization_typ']])) 
                    @if($organization_group_total2[$dt['organization_typ']] != null && count($organization_group_total2[$dt['organization_typ']]) > 0)
                    @foreach($organization_group_total2[$dt['organization_typ']] as $row)
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" {{($listm4600['belong_cd2_'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']]?'selected':''}}>
                        {{$row['organization_nm']}}
                    </option>
                    @endforeach
                    {{-- @foreach($organization_group_total2['2']) as $row)
											<option value="0"></option>

											<option value="{{$row['organization_cd']}}" {{($listm4600['belong_cd2_'.$dt['organization_typ']]??0)==$row['organization_cd']?'selected':''}}>{{$row['organization_nm']}}</option>
                    @endforeach --}}
                    @endif
                    @endif
                </select>
            </div>
            <!--/.form-group -->
        </div>
        @endif
        @endif
        @endforeach
</div>
        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="table-data_2" style="">
                        <thead>
                            <tr>
                                <th style="width: 250px;max-width: 250px">{{ __('messages.position') }}</th>
                                <th style="width: 250px;max-width: 250px">{{ __('messages.job') }}</th>
                                <th style="width: 250px;max-width: 250px">{{ __('messages.grade') }}</th>
                                <th style="width: 250px;max-width: 250px">{{ __('messages.employee_classification') }}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td scope="row" class="text-left listm0040_2" style="max-width: 250px !important">
                                    <div>
                                        <ul class="multiselect-list2">
                                            @if (!empty($list_m0040_2))
                                            @foreach ($list_m0040_2 as $key => $m0040)
                                            <li class="active m0040">
                                                <div class="md-checkbox-v2 ">
                                                    <input name="1" id="{{ $key . 'm0040_2' }}" {{ isset($m0040['checked']) && $m0040['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0040['position_cd'] ?? '' }}" class="list_m0040" tabindex="18">
                                                    <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0040['position_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0040_2' }}">{{ $m0040['position_nm'] ?? '' }}
                                                    </label>
                                                </div>
                                            </li>
                                            @endforeach
                                            @endif
                                        </ul>
                                    </div>
                                </td>
                                <td scope="row" class="text-left listm0030_2" style="max-width: 250px !important">
                                    <div>
                                        <ul class="multiselect-list2">
                                            @if (!empty($list_m0030_2))
                                            @foreach ($list_m0030_2 as $key => $m0030)
                                            <li class="active m0030">
                                                <div class="md-checkbox-v2 ">
                                                    <input name="2" id="{{ $key . 'm0030_2' }}" {{ isset($m0030['checked']) && $m0030['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0030['job_cd'] ?? '' }}" class="list_m0030" tabindex="18">
                                                    <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0030['job_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0030_2' }}">{{ $m0030['job_nm'] ?? '' }}
                                                    </label>
                                                </div>
                                            </li>
                                            @endforeach
                                            @endif
                                        </ul>
                                    </div>
                                </td>
                                <td scope="row" class="text-left listm0050_2" style="max-width: 250px !important">
                                    <div>
                                        <ul class="multiselect-list2">
                                            @if (!empty($list_m0050_2))
                                            @foreach ($list_m0050_2 as $key => $m0050)
                                            <li class="active m0050">
                                                <div class="md-checkbox-v2 ">
                                                    <input name="3" id="{{ $key . 'm0050_2' }}" {{ isset($m0050['checked']) && $m0050['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0050['grade'] ?? '' }}" class="list_m0050" tabindex="18">
                                                    <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0050['grade_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0050_2' }}">{{ $m0050['grade_nm'] ?? '' }}
                                                    </label>
                                                </div>
                                            </li>
                                            @endforeach
                                            @endif
                                        </ul>
                                    </div>
                                </td>
                                <td scope="row" class="text-left listm0060_2" style="max-width: 250px !important">
                                    <div>
                                        <ul class="multiselect-list2">
                                            @if (!empty($list_m0060_2))
                                            @foreach ($list_m0060_2 as $key => $m0060)
                                            <li class="active m0060">
                                                <div class="md-checkbox-v2 ">
                                                    <input name="4" id="{{ $key . 'm0060_2' }}" {{ isset($m0060['checked']) && $m0060['checked'] == 1 ? 'checked' : '' }} type="checkbox" value="{{ $m0060['employee_typ'] ?? '' }}" class="list_m0060" tabindex="18">
                                                    <label class="label-error container option_container" data-toggle="tooltip" data-original-title="{{ $m0060['employee_typ_nm'] }}" style="min-width: 100%" for="{{ $key . 'm0060_2' }}">{{ $m0060['employee_typ_nm'] ?? '' }}
                                                    </label>
                                                </div>
                                            </li>
                                            @endforeach
                                            @endif
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div><!-- end .table-responsive -->
            </div>
        </div>
    </div>
</div>
<div class="row justify-content-md-center">
{!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
</div>