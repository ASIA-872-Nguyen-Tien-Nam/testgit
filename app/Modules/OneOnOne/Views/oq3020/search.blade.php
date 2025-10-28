<div class="row">
<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
<nav class="pager-wrap row">
	@if(isset($paging))
		{{Paging::show($paging)}}
	@endif
</nav>
</div>
</div>
<div class="table-responsive wmd-view  sticky-table sticky-headers sticky-ltr-cells" style="max-height: 606px">
    <table class="table one-table sortable table-bordered table-hover  ofixed-boder" id="myTable" style="">
        <thead>
        <tr>
            <th class="w-160px"style="width:75px">{{ __('messages.employee_no') }}</th>
            <th class="w-160px" style="width:120px">{{ __('messages.employee_name') }}</th>
            <th class="w-160px" style="width:120px">{{ __('messages.group_name') }}</th>
            <th class="w-120px" style="width:120px">{{ __('messages.1on1_name') }}</th>
            <th class="w-120px "style="width:70px">{{ __('messages.sex') }}</th>
            <th class="w-120px text-overfollow"style="width:70px">{{ __('messages.age') }}</th>
            @foreach($M0022 as $item)
                <th class="invi_head text-overfollow w_tr"  data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="" num="4">{{$item['organization_group_nm']}}
                </th>
            @endforeach
            <th class="w-120px"style="width:100px">{{ __('messages.position') }}</th>
            <th class="w-120px "style="width:80px">{{ __('messages.grade') }}</th>
            <th class="w-120px "style="width:150px">{{ __('messages.questionnaire_type') }} </th>
        </tr>
        </thead>
        <tbody>
        @if (!empty($views))
            @foreach($views as $row)
                <tr class="tr_employee">
                    <td class="w-120px ">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow text-left" style="width:75px;max-width: 75px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_cd']}}">
                                {{$row['employee_cd']}}
                            </div>
                        </label>
                    </td>
                    <td class="w-120px  text-overfollow">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:120px;max-width: 120px;"data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">
                                {{$row['employee_nm']}}
                            </div>
                        </label>

                    </td>
                    <td class="w-120px invi_head">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:120px;max-width: 120px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['group_nm']}}">
                                {{$row['group_nm']}}
                            </div>
                        </label>
                    </td>
                    <td class="w-120px invi_head">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:120px;max-width: 120px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['group_title']}}">
                                {{$row['group_title']}}
                            </div>
                        </label>
                    </td>
                    <td class="w-120px invi_head">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow text-center" style="width:60px;max-width: 60px;" data-container="body" data-toggle="tooltip" data-original-title="">
                                {{$row['gender']}}
                            </div>
                        </label>
                    </td>
                    <td class="w-120px invi_head">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow text-right" style="width:60px;max-width: 60px;" data-container="body" data-toggle="tooltip" data-original-title="">
                                {{$row['age']==0?'':$row['age']}}
                            </div>
                        </label>
                    </td>
                    @foreach($M0022 as $item)
                    @if($item['organization_step'] == 1)
                        <td>
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_1']}}">
                                {{$row['belong_nm_1']}}
                            </div>
                            {{-- <input type="hidden" class="order_by"  /> --}}
                        </td>
                        @elseif ($item['organization_step'] == 2)
                        <td >
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_2']}}">
                                {{$row['belong_nm_2']}}
                            </div>
                            {{-- {{$row['belong_nm_2']}}
                            <input type="hidden" class="order_by"  /> --}}
                        </td>
                        @elseif ($item['organization_step'] == 3)
                        <td >
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_3']}}">
                                {{$row['belong_nm_3']}}
                            </div>
                            {{-- {{$row['belong_nm_3']}}
                            <input type="hidden" class="order_by"  /> --}}
                        </td>
                        @elseif ($item['organization_step'] == 4)
                        <td >
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_4']}}">
                                {{$row['belong_nm_4']}}
                            </div>
                            {{-- {{$row['belong_nm_4']}}
                            <input type="hidden" class="order_by"  /> --}}
                        </td>
                        @elseif ($item['organization_step'] == 5)
                        <td >
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_5']}}">
                                {{$row['belong_nm_5']}}
                            </div>
                            {{-- {{$row['belong_nm_5']}}
                            <input type="hidden" class="order_by" /> --}}
                        </td>
                        @else
                        <td >
                            <div class="text-overfollow w_tr" data-container="body" data-toggle="tooltip" data-original-title="{{$row['belong_nm_1']}}">
                                {{$row['belong_nm_1']}}
                            </div>
                            {{-- {{$row['belong_nm_1']}}
                            <input type="hidden" class="order_by"  /> --}}
                        </td>
                    @endif
                    @endforeach
                    <td class="w-120px invi_head XXX">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:100px;max-width: 100px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['position_nm']}}">
                                {{$row['position_nm']}}
                            </div>
                        </label>
                    </td>
                    <td class="w-120px invi_head">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:80px;max-width: 80px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['grade_nm']}}">
                                {{$row['grade_nm']}}
                            </div>
                        </label>
                    </td>

                    <td class="w-120px">
                        <label class="form-control-plaintext txt">
                            <div class="text-overfollow" style="width:150px;max-width: 150px;" data-container="body" data-toggle="tooltip" data-original-title="{{$row['questionnaire_nm']}}">
                                {{$row['questionnaire_nm']}}
                            </div>
                        </label>
                    </td>
                </tr>
            @endforeach
        @else
        	<tr>
                <td colspan="14" class="text-center">
                    {{ $_text[21]['message'] }}
                </td>
            </tr>
        @endif
        </tbody>
    </table>
</div><!-- end .row -->
