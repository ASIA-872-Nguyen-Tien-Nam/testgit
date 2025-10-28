            <thead>
				<tr>
					<th class="text-center" style="width: 30%;">{{ __('messages.middle_category_name') }}
						<span class="item-right">
							<button class="btn btn-rm blue btn-sm" id="btn-add-mid" tabindex="-1">
								<i class="fa fa-plus"></i>
							</button>
						</span>
					</th>
					<th class="text-center" style="width: 30%;">{{ __('messages.minor_category_name') }}
						<span class="item-right">
							<button class="btn btn-rm blue btn-sm" id="btn-add-low" tabindex="-1">
								<i class="fa fa-plus"></i>
							</button>
						</span>
					</th>
					<th class="text-center" >{{ __('messages.question') }}
						<span class="item-right">
							<button class="btn btn-rm blue btn-sm" id="btn-add-detail" tabindex="-1">
								<i class="fa fa-plus"></i>
							</button>
						</span>
					</th>
					<th style="width: 10px;">

					</th>
				</tr>
				</thead>
				<tbody>
					@if(isset($data_import[0]['category1_cd']) !='0')
					@foreach($data_import as $key=>$row)
					<tr class="tr" cate_no="{{$row['category2_cd']}}">
						<td rowspan="{{$row['row_span_cate2']}}" class="mid-cate {{$row['num_cate2'] == 1?'':'hidden'}}" >
							<span class="num-length">
								<input type="hidden" class="category2_cd" value="{{isset($row['category2_cd'])?$row['category2_cd']:''}}">
								<input type="text" tabindex="2" class="form-control input-sm text-left category2_nm required " maxlength="50" value="{{isset($row['category2_nm'])?$row['category2_nm']:''}}">
							</span>
						</td>
						<td rowspan="{{$row['row_span_cate3']}}" class="low-cate  {{$row['num_cate3'] == 1?'':'hidden'}}"  low_cate_cd ="{{$row['category3_cd']}}">
							<span class="num-length">
								<input type="hidden" class="category3_cd" value="{{isset($row['category3_cd'])?$row['category3_cd']:''}}">
								<input type="text" tabindex="2" class="form-control input-sm text-left category3_nm" maxlength="50" value="{{isset($row['category3_nm'])?$row['category3_nm']:''}}" decimal="2">
							</span>
						</td>
						<td >
							<span class="num-length">
								<input type="hidden" class="question_cd" value="{{isset($row['question_cd'])?$row['question_cd']:''}}">
								<input type="text" tabindex="2" class="form-control input-sm text-left question required" maxlength="200" value="{{isset($row['question'])?$row['question']:''}}">
							</span>
						</td>
						<td class="text-center">
							<button tabindex="2" class="btn btn-rm btn-sm btn-remove-row">
								<i class="fa fa-remove"></i>
							</button>
						</td>
					</tr>
					@endforeach
					@else
					<tr class="tr" cate_no="1">
						<td rowspan="1" class="mid-cate">
							<span class="num-length">
								<input type="hidden" class="category2_cd" value="">
								<input type="text" tabindex="2" class="form-control input-sm text-left category2_nm required" value="" maxlength="50">
							</span>
						</td>
						<td rowspan="1" class="low-cate"  low_cate_cd ="1">
							<span class="num-length">
								<input type="hidden" class="category3_cd" value="">
								<input type="text" tabindex="2" class="form-control input-sm text-left category3_nm required" value="" maxlength="50" decimal="2">
							</span>
						</td>
						<td>
							<span class="num-length">
								<input type="hidden" class="question_cd" value="">
								<input type="text" tabindex="2" class="form-control input-sm text-left question required" value="" maxlength="200">
							</span>
						</td>
						<td class="text-center">
							<button class="btn btn-rm btn-sm btn-remove-row">
								<i class="fa fa-remove"></i>
							</button>
						</td>
					</tr>
					@endif
				</tbody>