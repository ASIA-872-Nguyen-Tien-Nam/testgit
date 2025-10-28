<div class="row">
    <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
        <nav class="pager-wrap row">
            {!! Paging::show($paging) !!}
        </nav>
    </div>
</div>

<div class="col-12 col-sm-12 col-md-12 col-xl-12 col-lg-12">
    <div class="table-responsive employee-share">
        <table class="table table-bordered table-hover table-striped" id="employee_share_tbl">
            <thead>
                <tr>
                    <th class="sticky-cell text-center nosort" style="width: 20px">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input name="ck_all" class="check_all" id="ck_all" type="checkbox" tabindex="11">
                            <label for="ck_all"></label>
                        </div>
                    </th>
                    <th style="width: 80px;">{{__('messages.employee_no')}}</th>
                    <th style="width: 100px">{{__('messages.employee_name')}}</th>
                    <th style="width: 100px">{{__('messages.employee_classification')}}</th>
                    @foreach($organization_group as $dt)
                    <th class="text-overfollow"
                        data-container="body" data-toggle="tooltip"
                        data-original-title="{{$dt['organization_group_nm']}}" style="width: 150px;max-width: 150px">
                        {{$dt['organization_group_nm']}}
                    </th>
                    @endforeach
                    <th style="width: 100px">{{__('messages.job')}}</th>
                    <th style="width: 100px">{{__('messages.position')}}</th>
                </tr>
            </thead>
            <tbody>
                @if (isset($shares) && !empty($shares))
                    @foreach($shares as $key => $row)
                        <tr employee_cd="{{$row['employee_cd']}}" employee_nm="{{$row['employee_nm']}}">
                            <td class="sticky-cell text-center">
                                <div class="md-checkbox-v2 inline-block lb">
                                    <input class="ck_item" name="ck{{$key}}" id="ck{{$key}}" type="checkbox" value="1" tabindex="12">
                                    <label for="ck{{$key}}"></label>
                                </div>
                            </td>
                            <td>
                                <div class="text-overfollow" style="width: 75px;"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$row['employee_cd']}}">
                                    {{$row['employee_cd']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow" style="width: 95px;"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$row['employee_nm']}}">
                                    {{$row['employee_nm']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow" style="width: 95px;"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$row['employee_typ_nm']}}">
                                    {{$row['employee_typ_nm']}}
                                </div>
                            </td>
                            @foreach($organization_group as $dt)
                                <td class="td-width">
                                    <div class="text-overfollow" style="width: 145px;max-width: 145px"
                                        data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$row['organization_nm'.$dt['organization_step']]}}">
                                        {{$row['organization_nm'.$dt['organization_step']]}}
                                    </div>
                                </td>
                            @endforeach

                            <td class="td-width">
                                <div class="text-overfollow" style="width: 95px;"
                                    data-container="body" data-toggle="tooltip"
                                    data-original-title="{{$row['job_nm']}}">
                                    {{$row['job_nm']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow" style="width: 95px;"
                                    data-container="body" data-toggle="tooltip" data-placement="left"
                                    data-original-title="{{$row['position_nm']}}">
                                    {{$row['position_nm']}}
                                </div>
                            </td>
                        </tr>
                    @endforeach
                @else
                    <tr class="tr-nodata">
                        <td colspan="{{10+count($organization_group)}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </tbody>
        </table>
    </div>
</div> <!-- end .card-body -->
<div class="row">
    <div class="col-12 col-sm-12 col-md-12 col-lg-2 col-xl-2">
        <div class="full-width mt-3 ml-2">
            <a href="javascript:;" id="btn-choice" class="btn btn-outline-primary">
                {{ __('ri2010.add_target') }}
            </a>
        </div>   
    </div>
</div>