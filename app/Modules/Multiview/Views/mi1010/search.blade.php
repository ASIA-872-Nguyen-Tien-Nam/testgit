@section('rater_employee_nm_1_string')
    sex
@endsection
<div style="margin: 10px 0px;">{{__('messages.employee_info')}}</div>
<div class="row">
    <div class="col-md-12">
        <div class="wmd-view table-responsive _width" style="background-attachment: fixed;">
            <table id="employee_info" class="table  table-bordered table-hover tbme ofixed-boder tabl2" data-resizable-columns-id="demo-table-v2">
                <thead>
                    <th style="width: 25%">{{__('messages.position')}}</th>
                    <th style="width: 25%">{{__('messages.job')}}</th>
                    <th style="width: 25%">{{__('messages.grade')}}</th>
                    <th style="width: 25%">{{__('messages.employee_classification')}}</th>
                    </tr>
                </thead>
                <tbody>
                    @if (isset($employee_info[0]['employee_cd']))
                    @foreach($employee_info as $info)
                    <tr>
                        <td class="text-center">{{$info['position_nm']}}</td>
                        <td class="text-center">{{$info['job_nm']}}</td>
                        <td class="text-center">{{$info['grade_nm']}}</td>
                        <td class="text-center">{{$info['employee_typ_nm']}}</td>
                    </tr>
                    @endforeach
                    @else
                    <tr>
                        <td class="text-center" colspan="4">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
</div>

<div style="margin: 10px 0px;">{{__('messages.employee_who_can_enter_comments')}}</div>
<div class="row">
    <div class="col-md-12">
        <div class="wmd-view table-responsive _width div-table-detail" style="background-attachment: fixed;max-height: 450px;">
            <table id="table_detail" class="table table-bordered table-hover tbme ofixed-boder tabl2" data-resizable-columns-id="demo-table-v2" style="margin-bottom: 20px !important;">
                <thead>
                    <tr>
                        <th style="width: 25%" class="emp_name">{{__('messages.employee_name')}}</th>
                        <th style="width: 10%">{{__('messages.position')}}</th>
                        <th style="width: 10%">{{__('messages.job')}}</th>
                        <th style="width: 10%">{{__('messages.grade')}}</th>
                        <th style="width: 15%">{{__('messages.employee_classification')}}</th>
                        <th class="support__column" style="width: 25%" style="min-width:300px !important">{{__('messages.other_supporter_info')}}</th>
                        <th style="width: 5%">
                            <div class="text-center">
                                <span>
                                    <button class="btn btn-rm blue btn-sm" id="btn-add-detail" tabindex="3">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </span>
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @if(isset($list[0]['supporter_cd']))
                    @foreach($list as $key=> $row)
                    <tr class="list_supporters" tr_id="{{$row['id']}}">
                        <td class="text-center">
                            <span class="num-length ">
                                <div class="input-group-btn input-group div_employee_cd">
                                    <span class="num-length">
                                        <input type="hidden" class="employee_cd_hidden employee_cd supporter_cd" value="{{$row['supporter_cd']??''}}" />
                                        <input type="text" fiscal_year_mulitireview="" class="form-control indexTab employee_nm_mulitireview required supporter_nm" old_employee_nm="{{$row['supporter_nm']??''}}" tabindex="4" maxlength="101" value="{{$row['supporter_nm']??''}}" style="padding-right: 40px;" />
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td class="text-center position_cd">
                            <div class="text-overfollow" style="max-width:340px" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$row['position_nm']}}">
                            {{$row['position_nm']}}
                            </div>
                        </td>
                        <td class="text-center job_cd">
                            <div class="text-overfollow" style="max-width:340px" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$row['job_nm']}}">
                            {{$row['job_nm']}}
                            </div>
                        </td>
                        <td class="text-center grade">
                            <div class="text-overfollow" style="max-width:260px" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$row['grade_nm']}}">
                            {{$row['grade_nm']}}
                            </div>
                        </td>
                        <td class="text-center employee_typ">
                            <div class="text-overfollow" style="max-width:260px" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$row['employee_typ_nm']}}">
                            {{$row['employee_typ_nm']}}
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="md-checkbox-v2">
                                <label for="checkbox_{{$row['id']}}" style="margin-top: 0;margin-bottom: 0;" class="lbl-text container">&nbsp;{{__('messages.viewable')}}
                                    <input class="check_box other_browsing_kbn" name="checkbox_{{$row['id']}}" id="checkbox_{{$row['id']}}" {{$row['other_browsing_kbn']==1?'checked':''}} value="1" type="checkbox" tabindex="4">
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-rm btn-sm btn-remove-row" tabindex="4">
                                <i class="fa fa-remove"></i>
                            </button>
                        </td>
                    </tr>
                    @endforeach
                    @else
                    <tr class="list_supporters" tr_id="1">
                        <td class="text-center">
                            <span class="num-length ">
                                <div class="input-group-btn input-group div_employee_cd">
                                    <span class="num-length">
                                        <input type="hidden" class="employee_cd_hidden employee_cd supporter_cd" value="" />
                                        <input type="text" fiscal_year_mulitireview="" class="form-control indexTab employee_nm_mulitireview required supporter_nm" old_employee_nm tabindex="4" maxlength="101" value="" style="padding-right: 40px;" />
                                    </span>
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </span>
                        </td>
                        <td class="text-center position_cd"></td>
                        <td class="text-center job_cd"></td>
                        <td class="text-center grade"></td>
                        <td class="text-center employee_typ"></td>
                        <td class="text-center">
                            <div class="md-checkbox-v2">
                                <label for="checkbox_1" style="margin-top: 0;margin-bottom: 0;" class="lbl-text container">&nbsp;{{__('messages.viewable')}}
                                    <input class="check_box other_browsing_kbn cb_focus" name="checkbox_1" id="checkbox_1" {{$browsing_kbn_flg==1?'checked':''}} value="1" type="checkbox" tabindex="4">
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-rm btn-sm btn-remove-row" tabindex="4">
                                <i class="fa fa-remove"></i>
                            </button>
                        </td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="row justify-content-md-center" style="margin-top: 30px;">
    {!!
    Helper::buttonRenderMulitireview(['saveButton'])
    !!}
</div>

<div class="hidden">
    <table id="table-target">
        <tbody>
            <tr class="" tr_id="">
                <td class="text-center">
                    <span class="num-length ">
                        <div class="input-group-btn input-group div_employee_cd">
                            <span class="num-length">
                                <input type="hidden" class="employee_cd_hidden employee_cd supporter_cd" value="" />
                                <input type="text" fiscal_year_mulitireview="" class="form-control indexTab employee_nm_mulitireview required supporter_nm" old_employee_nm tabindex="4" maxlength="20" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </span>
                </td>
                <td class="text-center position_cd"></td>
                <td class="text-center job_cd"></td>
                <td class="text-center grade"></td>
                <td class="text-center employee_typ"></td>
                <td class="text-center">
                    <div class="md-checkbox-v2">
                        <label for="" style="margin-top: 0;margin-bottom: 0;" class="lbl-text container lbl_check_box no">&nbsp;{{__('messages.viewable')}}
                            <input class="check_box other_browsing_kbn" name="" id="" {{$browsing_kbn_flg==1?'checked':''}} value="1" type="checkbox" tabindex="4">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </td>
                <td class="text-center">
                    <button class="btn btn-rm btn-sm btn-remove-row" tabindex="4">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="hidden">
    <table id="list_position_default">
        <tbody>
            @if(isset($list_position_cd[0]['browsing_position_cd']))
            @foreach($list_position_cd as $key=> $row)
            <tr>
                <td class="text-center browsing_position_cd">{{$row['browsing_position_cd']}}</td>
            </tr>
            @endforeach
            @endif
        </tbody>
    </table>
</div>
<!-- /.hidden -->
<input type="file" class="inputfile hidden" id="import_file" accept=".csv">
<input type="button" class="hidden" id="btn_reload">