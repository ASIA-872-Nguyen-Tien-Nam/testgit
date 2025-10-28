<nav class="pager-wrap ">
	<input type="hidden" class="display_attr" value="{{__('messages.display_attribute_info')}}">
    <input type="hidden" class="hide_attr"    value="{{__('messages.hide_attribute_info')}}">
	 <div class="btn-group show_button_div btn-pagging-center">
		<button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="13">
			<i class="fa fa-eye-slash"></i>
			<span id="btn_text">{{__('messages.hide_attribute_info')}}</span>
		</button>
	</div>
    {{Paging::show($paging??[])}}
</nav>
<div class="row">
	<div class="col-md-12 ">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
	</div>
</div>
@php $col = 10;@endphp
<!-- end .row -->
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
	<table class="table sortable table-bordered table-hover fixed-header table_sort table-striped" id="myTable">
		<thead>
			<tr>
				<th class="sticky-cell text-center">
					<div class="md-checkbox-v2 inline-block lb">
						<input name="ckball" class="checkAll check_all" item="1" num="6" id="ckball" checked="" type="checkbox" >
						<label for="ckball"></label>
					</div>
				</th>
				<th class="sticky-cell min-w100 text-overfollow" num="1">{{__('messages.employee_no')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="sticky-cell min-w150 text-overfollow" num="2" >{{__('messages.employee_name')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="invi_head min-w100 text-overfollow" num="3">{{__('messages.employee_classification')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@foreach($M0022 as $item)
				<th class="invi_head min-w150" num="4">{{$item['organization_group_nm']}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endforeach
				<th class="invi_head min-w150" num="6">{{__('messages.job')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="min-w150" num="7">{{__('messages.position')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="min-w85"  num="8">{{__('messages.grade')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th num="9" style="min-width: 210px">
					<span class="text-nowrap">{{__('messages.eval_sheet_category')}}
					<span><i class="fa fa-sort sort"></i></span>
					</span>
				</th>

				<th class="min-w150" num="10">{{__('messages.evaluation_sheet')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="min-w150" num="11">{{__('messages.status')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@if (($sheet_khn == 1 && $target_self_assessment_typ == 1) || ($sheet_khn == 2 && $evaluation_self_assessment_typ == 1))
				<th class="min-w85" num="12">{{__('messages.eval_self')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_1 == 1) || ($sheet_khn == 2 && $evaluation_typ_1 == 1))
				<th class="min-w85"  num="13">{{__('messages.eval_1st')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_2 == 1) || ($sheet_khn == 2 && $evaluation_typ_2 == 1))
				<th class="min-w85"  num="14">{{__('messages.eval_2nd')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_3 == 1) || ($sheet_khn == 2 && $evaluation_typ_3 == 1))
				<th class="min-w85"  num="15">{{__('messages.eval_3rd')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_4 == 1) || ($sheet_khn == 2 && $evaluation_typ_4 == 1))
				<th class="min-w85" num="16">{{__('messages.eval_4th')}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endif
			</tr>
		</thead>
		<tbody>
			@forelse($views as $temp)
			<tr>
				<td class="sticky-cell text-center">
					<div class="md-checkbox-v2 inline-block lb">
						<input type="hidden" class="employee_cd" value="{{$temp['employee_cd']}}" />
						<input type="hidden" class="sheet_cd" value="{{$temp['sheet_cd']}}" />
						<input name="ckb1" id="ckb{{$temp['id']}}" class="ck_item" checked="" type="checkbox" value="{{$temp['sheet_cd']}}">
						<label for="ckb{{$temp['id']}}"></label>
					</div>
				</td>
				<td class="sticky-cell text-right" num="1">
					<a href="" id="row_index{{$temp['id']}}" class="employee_cd_link" data-toggle="q0071" tabindex="-1">{{$temp['employee_cd']}}</a>
					<input type="hidden" class="order_by" value="{{$temp['employee_cd_orderby']}}" tabindex="-1" />
				</td>
				<td class="sticky-cell" num="2">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['employee_nm']}}">
						{{$temp['employee_nm']}}
                    </div>					
					<input type="hidden" class="order_by" value="{{$temp['furigana']}}" />
				</td>
				<td class="invi" num="3">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['employee_typ_nm']}}">
                        {{$temp['employee_typ_nm']}}
                    </div>
					<input type="hidden" class="order_by" value="{{$temp['employee_typ']}}" />
				</td>
				@foreach($M0022 as $item)
					@if($item['organization_step'] == 1)
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_1']}}">
							{{$temp['belong_nm_1']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_1']}}" />
					</td>
					@elseif ($item['organization_step'] == 2)
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_2']}}">
							{{$temp['belong_nm_2']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_2']}}" />
					</td>
					@elseif ($item['organization_step'] == 3)
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_3']}}">
							{{$temp['belong_nm_3']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_3']}}" />
					</td>
					@elseif ($item['organization_step'] == 4)
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_4']}}">
							{{$temp['belong_nm_4']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_4']}}" />
					</td>
					@elseif ($item['organization_step'] == 5)
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_5']}}">
							{{$temp['belong_nm_5']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_5']}}" />
					</td>
					@else
					<td class="invi" num="4">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_1']}}">
							{{$temp['belong_nm_1']}}
						</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_cd_1']}}" />
					</td>
					@endif
				@endforeach
				<td class="invi" num="6">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['job_nm']}}">
						{{$temp['job_nm']}}
					</div>
					<input type="hidden" class="order_by" value="{{$temp['job_cd']}}" />
				</td>
				<td num="7">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['position_nm']}}">
						{{$temp['position_nm']}}
					</div>
					<input type="hidden" class="order_by" value="{{$temp['position_cd']}}" />
				</td>
				<td num="8">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['grade_nm']}}">
						{{$temp['grade_nm']}}
					</div>
					<input type="hidden" class="order_by" value="{{$temp['grade']}}" />
				</td>
				<td num="9">
					{{$temp['sheet_kbn_nm']}}
					<input type="hidden" class="order_by" value="{{$temp['sheet_kbn']}}" />
				</td>
				<td num="10">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['sheet_nm']}}">	
						<a id="sheet_cd{{$temp['sheet_cd']}}" href="" sheet_kbn="{{$temp['sheet_kbn']}}" class="sheet_cd_click" data-toggle="i2010" tabindex="-1">{{$temp['sheet_nm']}}</a>
					</div>
					<input type="hidden" class="order_by" value="{{$temp['sheet_cd']}}" />
				</td>
				<td class="" num="11">
					<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$temp['status_nm']}}">
						{{$temp['status_nm']}}
					</div>
					<input type="hidden" class="order_by" value="{{$temp['status_cd_order_by']}}" />
				</td>

				@if (($sheet_khn == 1 && $target_self_assessment_typ == 1) || ($sheet_khn == 2 && $evaluation_self_assessment_typ == 1))
					<td class="text-right" num="12">
						{{$temp['point_sum_0']}}
						<input type="hidden" class="order_by" value="{{$temp['point_sum_0_order_by']}}" />
					</td>
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_1 == 1) || ($sheet_khn == 2 && $evaluation_typ_1 == 1))
					<td class="text-right" num="13">
						{{$temp['point_sum_1']}}
						<input type="hidden" class="order_by" value="{{$temp['point_sum_1_order_by']}}" />
					</td>
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_2 == 1) || ($sheet_khn == 2 && $evaluation_typ_2 == 1))
					<td class="text-right" num="14">
						{{$temp['point_sum_2']}}
						<input type="hidden" class="order_by" value="{{$temp['point_sum_2_order_by']}}" />
					</td>
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_3 == 1) || ($sheet_khn == 2 && $evaluation_typ_3 == 1))
					<td class="text-right" num="15">
						{{$temp['point_sum_3']}}
						<input type="hidden" class="order_by" value="{{$temp['point_sum_3_order_by']}}" />
					</td>
				@endif
				@if (($sheet_khn == 1 && $target_evaluation_typ_4 == 1) || ($sheet_khn == 2 && $evaluation_typ_4 == 1))
					<td class="text-right" num="16">
						{{$temp['point_sum_4']}}
						<input type="hidden" class="order_by" value="{{$temp['point_sum_4_order_by']}}" />
					</td>
				@endif
			</tr>
			@empty
			<tr>
                <td colspan="{{$col}}" class="text-center">
                    {{app('messages')->getText(21)->message}}
                </td>
            </tr>
			@endforelse
		</tbody>
	</table>
</div><!-- end .table-responsive -->