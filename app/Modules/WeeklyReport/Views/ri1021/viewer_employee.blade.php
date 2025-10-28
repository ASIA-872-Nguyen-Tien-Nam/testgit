@extends('popup')

@section('title', $title)

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!!public_url('template/css/common/jquery-ui.css')!!}
    {!! public_url('template/css/weeklyreport/ri1021/ri1021.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/weeklyreport/ri1021/viewer_employee.index.js') !!}
@stop

@section('content')

    <div class="card">
        <div class="card-body search-condition">
            <div class="text-center hid">
                <a href="javascript:void(0)" data-toggle="collapse" data-target="#collapseExample" aria-expanded="true"
                    aria-controls="collapseExample" style="font-size: 25px;">
                    <i class="fa fa-caret-up" aria-hidden="true" style="color: var(--primary-pink)"></i>
                    <i class="fa fa-caret-down" aria-hidden="true" style="color: var(--primary-pink)"></i>
                </a>
            </div>
            <div id="collapseExample" class="collapse show">
                <div class="col-md-4 pl-0">
                    <div class="form-group">
                        <label class="control-label">{{ __('ri1021.reporter') }}</label>
                        <span class="num-length">
                            <input type="text" id="popup_employee_nm" value="{{ $info['employee_nm'] ?? '' }}" disabled
                                class="form-control" maxlength="10" tabindex="1">
                        </span>
                    </div>
                </div>
                <input type="hidden" id="popup_employee_cd" value="{{ $info['employee_cd'] ?? '' }}" />
                <input type="hidden" id="popup_report_kind" value="{{ $info['report_kind'] ?? 0 }}" />
                <input type="hidden" id="popup_fiscal_year" value="{{ $info['fiscal_year'] ?? 0 }}" />
                <input type="hidden" id="popup_group_cd" value="{{ $info['group_cd'] ?? 0 }}" />
                <input type="hidden" id="fiscal_year" value="{{ $info['fiscal_year'] ?? 0 }}" />
            </div>
        </div>
    </div>
    <!-- end .card -->
    <div id="result" class="card">
        <div class="row mg_row mt-3">
            <div class="col-md-12" style="margin-left: 10px; padding-right:24px; padding-top:16px">
                <div class="form-group">
                    <div class="full-width text-right">
                        <a href="javascript:;" class="btn btn-key-primary" id="btn_add" tabindex="5">
                            <i class="fa fa-user-plus"></i>
                            {{ __('messages.add_employee') }}
                        </a>
                        <a href="javascript:;" class="btn btn-key-primary" id="btn_apply" tabindex="15">
                            <i class="fa fa-check"></i>
                            {{ __('messages.apply') }}
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="popup_result">
            @include('WeeklyReport::ri1021.viewer_employee_search')
        </div> <!-- end .card -->
    </div> <!-- end .card -->
    <table class="d-none" id="table_row_add">
        <tbody class="">
            <tr class="tr_employee">
                <td class="text-center lblCheck">
                    <div id="" class="md-checkbox-v2 inline-block">
                        <label for="cck10" class="container checkbox-os0030 lab_chk">
                            <input name="check-all" class="chk-item inp_chk" id="cck1" type="checkbox">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </td>
                <td style="max-width:80px;min-width: 80px">
                    <input type="hidden" class="tb_employee_cd" value="">
                    <div class="input-group-btn input-group employee_cd div_employee_cd">
                        <span class="num-length">
                            <input type="hidden" class="employee_cd_hidden employee_cd employee_cd_add"/>
                            <input type="text" fiscal_year_weeklyreport="{{$info['fiscal_year'] ?? 0}}" id="employee_nm"
                                class="form-control indexTab add_employee_cd employee_nm_weeklyreport ui-autocomplete-input"
                                tabindex="10" maxlength="101" value="" style="padding-right: 40px;" />
                        </span>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent btn_employee_cd_popup_weeklyreport" type="button"
                                tabindex="-1">
                                <i class="fa fa-search"></i>
                            </button>
                        </div>
                    </div>
                </td>
                <td class="" style="max-width:150px;min-width: 150px">
                    <input type="hidden" class="tb_employee_nm" value="">
                    <div class="text-overfollow employee_nm" data-container="body" data-toggle="tooltip"
                        data-original-title=""></div>
                </td>
                <td class="" style="max-width:150px;min-width: 150px">
                    <div class="text-overfollow employee_typ_nm" data-container="body" data-toggle="tooltip"
                        data-original-title=""></div>
                </td>
                @isset($organization_group)
                    @foreach ($organization_group as $key => $item)
                        <td class="" style="max-width:150px;min-width: 150px">
                            <div class="text-overfollow organization_nm_{{ $key + 1 }}" data-container="body"
                                data-toggle="tooltip" data-original-title=""></div>
                        </td>
                    @endforeach
                @endisset
                <td class="" style="max-width:150px;min-width: 150px">
                    <div class="text-overfollow position_nm" data-container="body" data-toggle="tooltip"
                        data-original-title=""></div>
                </td>
            </tr>
        </tbody>
    </table><!-- /.hidden -->
@stop
