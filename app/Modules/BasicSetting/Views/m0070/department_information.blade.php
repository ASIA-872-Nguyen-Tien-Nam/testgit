<div class="tab-pane fade" id="tab3">
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells"
                style="max-height: 510px;">
                <table class="table table-bordered table-hover table-striped fixed-header">
                    <thead>
                        <!-- <tr class="text-center" style="height: 60px;">
							</tr> -->
                        <tr class="text-center" style="height: 125px;">
                            <th width="120">{{ __('messages.application_date') }}</th>
                            <th width="40" class="text-overfollow control-label" style="max-width:40px" data-container="body" data-toggle="tooltip" data-original-title="{{ __('messages.concurrent_post') }}">{{ __('messages.concurrent_post') }}</th>
                            @isset($organization_group)
                                @foreach ($organization_group as $item)
                                    <th class="text-overfollow control-label" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="max-width: 100px">
                                        {{ $item['organization_group_nm'] ?? '' }}
                                    </th>
                                @endforeach
                            @endisset
                            <th width="100">{{ __('messages.position') }}</th>
                            <th width="100">{{ __('messages.grade') }}</th>
                            <th width="100">{{ __('messages.job') }}</th>
                            <th style="width: 100px">{{ __('messages.office') }}</th>
                            <th width="100">{{ __('messages.employee_classification') }}</th>
                            @if (isset($disabled) && $disabled == '')
                            <th width="30" style="Z-INDEX: 1"></th>
                            @endif
                        </tr>
                    </thead>
                    <tbody id="result">
                        @foreach($table2 as $row)
                        <tr class="list">
                            <td data-toggle="tooltip" title="{{$row['application_date']}}"
                                class="text-overfollow text-center" style="width: 120px">
                                {{$row['application_date']}}
                                <input type="text" class="hidden application_date"
                                    value="{{$row['application_date']}}" />
                                <input type="text" class="hidden detail_no"
                                    value="{{$row['detail_no']}}" hidden />
                            </td>
                         
                            <td data-toggle="tooltip" title=""
                                class="text-overfollow text-center">
                                @if($row['typ'] && $row['typ'] == 1)
                                *
                                @endif
                            </td>

                            @isset($organization_group)
                                @foreach ($organization_group as $item)
                                    @if ($item['organization_typ'] == 1)
                                    <td class="w-100px">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['belong_cd1_nm']}}">
                                            {{$row['belong_cd1_nm']}}
                                            <input type="text" class="hidden belong_cd1" value="{{$row['belong_cd1']}}" />
                                        </div>
                                    </td>
                                    @endif   
                                    @if ($item['organization_typ'] == 2)
                                    <td class="w-100px">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['belong_cd2_nm']}}">
                                            {{$row['belong_cd2_nm']}}
                                            <input type="text" class="hidden belong_cd2" value="{{$row['belong_cd2']}}" />
                                        </div>
                                    </td>
                                    @endif   
                                    @if ($item['organization_typ'] == 3)
                                    <td class="w-100px">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['belong_cd3_nm']}}">
                                            {{$row['belong_cd3_nm']}}
                                            <input type="text" class="hidden belong_cd3" value="{{$row['belong_cd3']}}" />
                                        </div>
                                    </td>
                                    @endif   
                                    @if ($item['organization_typ'] == 4)
                                    <td class="w-100px">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['belong_cd4_nm']}}">
                                            {{$row['belong_cd4_nm']}}
                                            <input type="text" class="hidden belong_cd4" value="{{$row['belong_cd4']}}" />
                                        </div>
                                    </td>
                                    @endif       
                                    @if ($item['organization_typ'] == 5)
                                    <td class="w-100px">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['belong_cd5_nm']}}">
                                            {{$row['belong_cd5_nm']}}
                                            <input type="text" class="hidden belong_cd5" value="{{$row['belong_cd5']}}" />
                                        </div>
                                    </td>
                                    @endif   
                                @endforeach
                            @endisset
                            <td class="w-100px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    title="{{$row['position_nm']}}">
                                    {{$row['position_nm']}}
                                    <input type="text" class="hidden position_cd" value="{{$row['position_cd']}}" />
                                </div>
                            </td>
                            <td class="w-100px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    title="{{$row['grade_nm']}}">
                                    {{$row['grade_nm']}}
                                    <input type="text" class="hidden grade" value="{{$row['grade']}}" />
                                </div>
                            </td>
                            <td class="w-100px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    title="{{$row['job_nm']}}">
                                    {{$row['job_nm']}}
                                    <input type="text" class="hidden job_cd" value="{{$row['job_cd']}}" />
                                </div>
                            </td>
                            <td class="w-100px">
                                <div class="text-overfollow" data-toggle="tooltip" title="{{$row['office_nm']}}">
                                    {{$row['office_nm']}}
                                    <input type="text" class="hidden office_cd" value="{{$row['office_cd']}}" />
                                </div>

                            </td>
                            <td class="w-100px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                    title="{{$row['employee_typ_nm']}}">
                                    {{$row['employee_typ_nm']}}
                                    <input type="text" class="hidden employee_typ" value="{{$row['employee_typ']}}" />
                                </div>
                            </td>
                            @if (isset($disabled) && $disabled == '')
                            <td class="text-center" width="30">
                                <button  class="btn btn-rm btn-sm btn-remove-row " id="del_row" tabindex="38">
                                    <i class="fa fa-remove"></i>
                                </button>
                            </td>
                            @endif
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>