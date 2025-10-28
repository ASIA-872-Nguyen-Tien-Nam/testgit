@if (isset($status))
<label id="action_value" status_cd="{{isset($status['status_cd'])?$status['status_cd']:''}}" company_cd="{{$company_cd??''}}">
	<b>{{isset($status['status_nm'])? __('messages.status') .': '.$status['status_nm']:''}}</b>
</label>
<div class="chart-link">
	<div class="table-responsive wmd-view table-fixed-header  sticky-table sticky-headers sticky-ltr-cells" style="overflow-y: auto; max-height: 60vh;">
		<table class="table sortable table-bordered table-hover table-striped fixed-header table_sort" id="myTable">
			<thead>
				<tr>
					<th class="minw150 x" num='0' style="min-width: 94px">
					{{ __('messages.employee_no') }}
						<span><i class="fa fa-sort sort"></i></span>
					</th>
					<th class="minw150 x" num='1'>
					{{ __('messages.employee_name') }}
						<span><i class="fa fa-sort sort"></i></span>
					</th>
					<th class="minw150 x" num='2'>
					{{ __('messages.employee_classification') }}
						<span><i class="fa fa-sort sort"></i></span>
					</th>
					@if (isset($m0022) && count($m0022) > 0)
					@foreach ($m0022 as $k => $item)
						<th class="minw150 x" num='{{$k+3}}'>
							<div class="text-overfollow x" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}">{{$item['organization_group_nm']}}</div><span><i class="fa fa-sort sort"></i></span>
						</th>
					@endforeach
					@endif
					<th class="minw150 x" num='8'>
					{{ __('messages.position') }}
						<span><i class="fa fa-sort sort"></i></span>
					</th>
					<th class="minw150 x" num='9'>
					{{ __('messages.grade') }}
						<span><i class="fa fa-sort sort"></i></span>
					</th>
				</tr>
			</thead>
			<tbody>
				@if(isset($listemployee[0]))
				@foreach($listemployee as $row)
				<tr>
					<td class="text-right" num='0'>
						{{$row['employee_cd']}}
						<input type="hidden" class="order_by" value="{{$row['employee_cd_order_by']}}" />
					</td>
					<td class="text-left" num='1'>
						<input type="hidden" class="order_by" value="{{$row['furigana']}}" />
						<a href="#" class="refer_status"  fiscal_year="{{$row['fiscal_year']}}" sheet_cd="{{$row['sheet_cd']}}" employee_cd="{{$row['employee_cd']}}" sheet_kbn="{{$row['sheet_kbn']}}" tabindex="-1">
							<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">{{$row['employee_nm']}}</div>
						</a>
					</td>
					<td class="text-left" num='2'>
						<input type="hidden" class="order_by" value="{{$row['employee_typ']}}" />
						<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_typ_nm']}}">{{$row['employee_typ_nm']}}</div>
					</td>
					@if (isset($m0022) && count($m0022) > 0)
					@foreach ($m0022 as $k => $item)
						<td class="text-left" num='{{$k+3}}'>
							<input type="hidden" class="order_by" value="{{$row['belong_cd'.($k+1)]}}" />
							<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['org_nm_'.($k+1)]}}">{{$row['org_nm_'.($k+1)]}}</div>
						</td>
					@endforeach
					@endif
					<td class="text-left" num='8'>
						<input type="hidden" class="order_by" value="{{$row['position_cd']}}" />
						<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['position_nm']}}">{{$row['position_nm']}}</div>
					</td>
					<td class="text-left" num='9'>
						<input type="hidden" class="order_by" value="{{$row['grade']}}" />
						<div class="text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['grade_nm']}}">{{$row['grade_nm']}}</div>
					</td>
				</tr>
				@endforeach
				@else
				<tr>
					<td colspan="10"  class="text-center">
						{{ $_text[21]['message'] }}
					</td>
				</tr>
				@endif
			</tbody>
		</table>
	</div>
</div>
@endif