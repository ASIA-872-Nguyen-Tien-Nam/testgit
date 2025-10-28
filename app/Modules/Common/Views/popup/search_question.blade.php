<div class="card pe-w">
	<div class="card-body">
	<div class="row" style="margin-bottom:20px">
		<div class=" col-md-4 col-xs-4 ">
			<div class="">
				<label class="control-label " >
				{{ __('messages.large_category') }}
				</label>
				<select id="category1_cd" class="form-control">
					<option value="0"></option>
					@foreach($category1  as $temp)
					<option value="{{$temp['category1_cd']}}" {{($temp['category1_cd'] == ($category1_cd??0) && $temp['refer_kbn'] ==($refer_kbn??0) ) ? 'selected':''}} {{$refer_kbn??0}} refer_kbn = "{{$temp['refer_kbn']??0}}">{{$temp['category1_nm']}}</option>
					@endforeach
				</select>
			</div><!-- end .p-title -->
		</div>
		<div class="col-md-4 col-xs-4 ">
			<div class="">
				<label class="control-label " >
				{{ __('messages.middle_category') }}
				</label>
				<select id="category2_cd" class="form-control">
					<option value="0"></option>
					@foreach($category2  as $temp)
					<option value="{{$temp['category2_cd']}}" {{$temp['category2_cd'] == ($category2_cd??0) ? 'selected':''}}>{{$temp['category2_nm']}}</option>
					@endforeach
				</select>
			</div><!-- end .p-title -->
		</div>
		<div class="col-md-4 col-xs-4 ">
			<div class="">
				<label class="control-label">
				{{ __('messages.minor_category') }}
				</label>
				<select id="category3_cd" class="form-control">
					<option value="0"></option>
					@foreach($category3  as $temp)
					<option value="{{$temp['category3_cd']}}" {{$temp['category3_cd'] == ($category3_cd??0) ? 'selected':''}}>{{$temp['category3_nm']}}</option>
					@endforeach
				</select>
			</div><!-- end .p-title -->
		</div>
	</div>
	</div>
</div>
<div class="card pe-w">
	<div class="card-body">
		<div class="row">
			<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
				<nav class="pager-wrap row">
					{{Paging::show($paging)}}
				</nav>
			</div>
			<div class="card-body col-md-12" style="padding: 0px">
				<div class="table-responsive  sticky-table sticky-headers sticky-ltr-cells" style="max-height: 380px">
					<table class="table one-table  table-bordered  ofixed-boder" id="table-popup">
						<thead>
							<tr>
								<th class="text-center" style="width:17%" >{{ __('messages.large_category_name') }}</th>
								<th class="text-center" style="width:17%">{{ __('messages.middle_category_name') }}</th>
								<th class="text-center" style="width:17%">{{ __('messages.minor_category_name') }}</th>
								<th class="text-center" style="width:35%">{{ __('messages.question') }}</th>
							</tr>
						</thead>
						<tbody>
							@if(isset($list[0]['category1_cd']) !='0')
							@foreach ($list as $key=>$row)
							<tr class="tr" refer_kbn="{{$row['refer_kbn']}}" category1_cd="{{$row['category1_cd']}}" category2_cd="{{$row['category2_cd']}}" category3_cd="{{$row['category3_cd']}}" question_cd="{{$row['question_cd']}}">
								<td rowspan="{{$row['row_span_cate1']}}" class="high-cate {{$row['num_cate1'] == 1?'':'hidden'}}">
									<span class="num-length">
										{{isset($row['category1_nm'])?$row['category1_nm']:''}}
									</span>
								</td>
								<td rowspan="{{$row['row_span_cate2']}}" class="mid-cate {{$row['num_cate2'] == 1?'':'hidden'}}">
									<span class="num-length">
										{{isset($row['category2_nm'])?$row['category2_nm']:''}}
									</span>
								</td>
								<td rowspan="{{$row['row_span_cate3']}}" class="low-cate  {{$row['num_cate3'] == 1?'':'hidden'}}"  low_cate_cd ="{{$row['category3_cd']}}">
									<span class="num-length">
										{{isset($row['category3_nm'])?$row['category3_nm']:''}}
									</span>
								</td>
								<td class="popup-detail" >
									<span class="num-length">
										{{isset($row['question'])?$row['question']:''}}
									</span>
								</td>
							</tr>
							@endforeach
							@endif
						</tbody>
					</table>
				</div><!-- end .table-responsive -->
			</div>
		</div>
	</div>
</div>