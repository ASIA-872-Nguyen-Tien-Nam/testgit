    <nav class="pager-wrap row">
    {!! Paging::show($paging) !!}
</nav>
<input type="hidden" class="display_attr" value="{{__('messages.display_attribute_info')}}">
<input type="hidden" class="hide_attr"    value="{{__('messages.hide_attribute_info')}}">
{{--<div class="row">
    <div class="col-md-12 ">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
</div>--}}
<div class="row">
    <div class="col-md-12">
        {{--<div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells _width">
            <table class="table table-bordered table-hover table-striped fixed-header">--}}
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
</div>
        <div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
            <table class="table sortable table-bordered table-hover fixed-header table-striped" id="myTable">
                <thead>
                <tr>
                    <th class="w-50px ">
                        <div id="checkboxAll" class="md-checkbox-v2 inline-block">
                            <input name="check-all" class="check_all" id="check-all" type="checkbox">
                            <label for="check-all" ></label>
                        </div>
                    </th>
                    @php
                    @endphp
                    <th class="w-80px text-overfollow lh-145" data-container="body" data-toggle="tooltip" data-original-title="">{{__('messages.employee_no')}}</th>
                    <th class="w-160px">{{__('messages.employee_name')}}</th>
                    <th class="w-160px invi_head text-overfollow lh-170"  data-container="body" data-toggle="tooltip" data-original-title="">{{__('messages.employee_classification')}}</th>
                    @if(count($group_typ)>0 && isset($group_typ[0]))
                        @if(isset($group_typ[0]))
                            @if ($group_typ[0]['use_typ'] == 1)
                            <th class="w-160px invi_head">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$group_typ[0]['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$group_typ[0]['organization_group_nm']}}</div>
                            </th>
                            @endif
                        @endif
                        @if(isset($group_typ[1]))
                        @if ($group_typ[1]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$group_typ[1]['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$group_typ[1]['organization_group_nm']}}</div>
                        </th>
                        @endif
                        @endif
                        @if(isset($group_typ[2]))
                        @if ($group_typ[2]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$group_typ[2]['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$group_typ[2]['organization_group_nm']}}</div>
                        </th>
                        @endif
                        @endif
                        @if(isset($group_typ[3]))
                        @if ($group_typ[3]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$group_typ[3]['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$group_typ[3]['organization_group_nm']}}</div>
                        </th>
                        @endif
                        @endif
                        @if(isset($group_typ[4]))
                        @if ($group_typ[4]['use_typ'] == 1)
                        <th class="w-160px invi_head">
                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$group_typ[4]['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$group_typ[4]['organization_group_nm']}}</div>
                        </th>
                        @endif
                        @endif
                    @endif
                    <th class="w-120px invi_head">{{__('messages.job')}}</th>
                    <th class="w-120px ">{{__('messages.position')}}</th>
                    <th class="w-120px ">{{__('messages.grade')}}</th>
                    <th class="w-120px">{{__('messages.office')}}</th>
                    <th class="w-120px">{{__('messages.user_id')}}</th>
                    <th class="w-160px text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{__('messages.current_permissions')}}" >{{__('messages.current_permissions')}}</th>
                </tr>
                </thead>
                <tbody>
                @if(count($list)>0 && isset($list[0]))
                    @foreach($list as $row)
                        <tr class="tr_employee">
                            <td class="text-center w-50px">
                                <div class="md-checkbox-v2 inline-block ck-nolabel">
                                    <input type="checkbox" name="ck{{$row['id']}}" id="ck{{$row['id']}}" class="chk-item ck{{$row['employee_cd']}}">
                                    <label for="ck{{$row['id']}}"></label>
                                    <input type="hidden" class="tb_employee_cd" value="{{$row['employee_cd']}}"/>
                                </div>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['employee_cd']}}">
                                    {{$row['employee_cd']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['employee_nm']}}">
                                        {{$row['employee_nm']}}
                                    </div>
                                </label>

                            </td>
                            <td class="w-120px invi_head">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['employee_typ_nm']}}">
                                        {{$row['employee_typ_nm']}}
                                    </div>
                                </label>
                            </td>
                            @if(isset($group_typ[0]))
                            @if ($group_typ[0]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm_1']}}">
                                        {{$row['organization_nm_1']}}
                                    </div>
                                </label>
                            </td>
                            @endif
                            @endif
                            @if(isset($group_typ[1]))
                            @if ($group_typ[1]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm_2']}}">
                                        {{$row['organization_nm_2']}}
                                    </div>
                                </label>
                            </td>
                            @endif
                            @endif
                            @if(isset($group_typ[2]))
                            @if ($group_typ[2]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm_3']}}">
                                        {{$row['organization_nm_3']}}
                                    </div>
                                </label>
                            </td>
                            @endif
                            @endif
                            @if(isset($group_typ[3]))
                            @if ($group_typ[3]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm_4']}}">
                                        {{$row['organization_nm_4']}}
                                    </div>
                                </label>
                            </td>
                            @endif
                            @endif
                            @if(isset($group_typ[4]))
                            @if ($group_typ[4]['use_typ'] == 1)
                            <td class="w-120px invi_head XXX">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm_5']}}">
                                        {{$row['organization_nm_5']}}
                                    </div>
                                </label>
                            </td>
                            @endif
                            @endif
                            <td class="w-120px invi_head">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['job_nm']}}">
                                        {{$row['job_nm']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['position_nm']}}">
                                        {{$row['position_nm']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['grade_nm']}}">
                                        {{$row['grade_nm']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['office_nm']}}">
                                        {{$row['office_nm']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['user_id']}}">
                                        {{$row['user_id']}}
                                    </div>
                                </label>
                            </td>
                            <td class="w-120px">
                                <label class="form-control-plaintext txt">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['authority_nm']}}">
                                        {{$row['authority_nm']}}
                                    </div>
                                </label>
                            </td>
                        </tr>
                    @endforeach
                @else
                    <tr class="tr-nodata">
                        <td colspan="{{10 + count($organization_group)}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
                </tbody>
            </table>
        </div><!-- end .row -->
