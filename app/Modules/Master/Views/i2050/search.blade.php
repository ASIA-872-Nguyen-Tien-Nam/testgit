<div class="pagin-poss">
	<nav class="pager-wrap">
	    {!! Paging::show($paging ?? []) !!}
	</nav>
	{{-- <div class="btn-group show_button_div">
		<button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="13">
			<i class="fa fa-eye-slash"></i> 
			<span id="btn_text">属性情報非表示</span> 
		</button>
	</div> --}}
</div>
<div class="row">
	<div class="col-md-12 ">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
	</div>
</div>
@php $col = 10;$sheet_num = 1;@endphp
<!-- end .row --> 
<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells">
	<table class="table sortable table-bordered table-hover fixed-header table_sort table-striped" id="myTable">
		<thead>
			<tr>
				<th class="min-w150" id="col-class"   colSpan={{isset($M0022)?7+count($M0022):''}}>
					{{ __('messages.employee_info') }}
				</th>
				@php $col++;@endphp
				@if(isset($max_sheetcd))
					@for($i=1;$i<=$max_sheetcd;$i++)
						<th class="min-w85" colspan="2" num="8">{{ __('messages.eval_element').$i}}</th>
					@endfor
				@endif 
			</tr>
			<tr>
				<th class="sticky-cell text-center" rowspan="2">
					<div class="md-checkbox-v2 inline-block lb">
						<input name="ckball" class="checkAll check_all"  item="1" num="6" id="ckball" type="checkbox" >
						<label for="ckball"></label>
					</div>
				</th>
				<th class="sticky-cell min-w100" rowspan="2" num="1">{{ __('messages.employee_no') }}
					<span><i class="fa fa-sort sort"></i></span>	
				</th>
				<th class="sticky-cell min-w100" rowspan="2" num="2" >{{ __('messages.employee_name') }}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="invi_head min-w100" rowspan="2" num="3">{{ __('messages.employee_classification') }}
					<span><i class="fa fa-sort sort"></i></span>	
				</th>
				@foreach($M0022 as $item)
				<th class="invi_head min-w100" rowspan="2" num="4">{{$item['organization_group_nm']}}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@endforeach
				<th class="invi_head min-w100" rowspan="2" num="6">{{ __('messages.job') }}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="min-w100" num="7" rowspan="2">{{ __('messages.position') }}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				<th class="min-w100" num="7" rowspan="2">{{ __('messages.grade') }}
					<span><i class="fa fa-sort sort"></i></span>
				</th>
				@php $col++;@endphp
				@if(isset($max_sheetcd))
					@for($i=1;$i<=$max_sheetcd;$i++)
						<th class="min-w200"  num="8">{{ __('messages.evaluation_sheet') }}
						</th>
						<th class="min-w200"  num="8">{{ __('messages.status') }}
						</th>
					@endfor
				@endif 
			</tr>
		</thead>
		<tbody>
			@forelse($views as $key => $temp)
			<tr>
				<td class="sticky-cell text-center">
					<div class="md-checkbox-v2 inline-block lb">
						<input type="hidden" class="employee_cd" value="{{$temp['employee_cd']??''}}" />
						<input name="ckb1" id="ckb{{$key}}"  class="ck_item" type="checkbox" value="{{$key+1}}" employee_cd={{$temp['employee_cd']??''}}>
						<label for="ckb{{$key}}"></label>
					</div>
				</td>
				<td class="sticky-cell text-right" id="row_index{{$key+1}}" num="1">
					<input type="hidden" class="order_by" value="{{$temp['employee_cd']??''}}" />
					{{$temp['employee_cd']??''}}
				</td>
				<td class="sticky-cell" num="2">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['employee_nm']??''}}">{{$temp['employee_nm']??''}}</div>
					<input type="hidden" class="order_by" value="{{$temp['employee_nm']??''}}" />
				</td>
				<td class="invi" num="3">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['employee_typ_nm']??''}}">{{$temp['employee_typ_nm']??''}}</div>
					<input type="hidden" class="order_by" value="{{$temp['employee_typ_nm']??''}}" />
				</td>
				@foreach($M0022 as $item)
					@if($item['organization_step'] == 1)
					<td class="invi" num="4">
						<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_1']??''}}">{{$temp['belong_nm_1']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_1']??''}}" />
					</td>
					@elseif ($item['organization_step'] == 2)
					<td class="invi" num="4">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_2']??''}}">{{$temp['belong_nm_2']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_2']??''}}" />
					</td>
					@elseif ($item['organization_step'] == 3)
					<td class="invi" num="4">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_3']??''}}">{{$temp['belong_nm_3']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_3']??''}}" />
					</td>
					@elseif ($item['organization_step'] == 4)
					<td class="invi" num="4">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_4']??''}}">{{$temp['belong_nm_4']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_4']??''}}" />
					</td>
					@elseif ($item['organization_step'] == 5)
					<td class="invi" num="4">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_5']??''}}">{{$temp['belong_nm_5']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_5']??''}}" />
					</td>
					@else
					<td class="invi" num="4">
					<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['belong_nm_1']??''}}">{{$temp['belong_nm_1']}}</div>
						<input type="hidden" class="order_by" value="{{$temp['belong_nm_1']??''}}" />
					</td>
					@endif
				@endforeach
				<td class="invi" num="6">
				<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['job_nm']??''}}">{{$temp['job_nm']??''}}</div>
					<input type="hidden" class="order_by" value="{{$temp['job_nm']??''}}" />
				</td>
				<td num="7">
				<div class="text-overfollow w-150"  data-container="body" data-toggle="tooltip" data-original-title="{{$temp['position_nm']??''}}">{{$temp['position_nm']??''}}</div>
					<input type="hidden" class="order_by" value="{{$temp['position_nm']??''}}" />
				</td>
				<td num="8">
				{{$temp['grade_nm']??''}}
					<input type="hidden" class="order_by" value="{{$temp['grade_nm']??''}}" />
				</td>
				@if(isset($max_sheetcd))
					@for($i=1;$i<=$max_sheetcd;$i++)
						@php
							$sheet_info =json_decode(htmlspecialchars_decode($temp[$i]));
						@endphp
						<input type="hidden" class="sheet_cd" value={{$sheet_info->sheet_cd??''}}>
						<td class="min-w200" num="8">
							<a  href=""  class="sheet_cd_click " data-toggle="i2010" tabindex="-1" sheet_cd={{$sheet_info->sheet_cd??''}} sheet_kbn={{$sheet_info->sheet_kbn??''}}  >{{$sheet_info->sheet_nm??''}}</a> 
						</td>
						<input type="hidden" class="sheet_kbn" class="order_by"  value={{$sheet_info->sheet_kbn??''}}>

						<input type="hidden" class="status_cd order_by" value={{$sheet_info->status_cd??''}}>
						<td class="min-w200" num="8">{{$sheet_info->status_nm??''}}</td>
					@endfor
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