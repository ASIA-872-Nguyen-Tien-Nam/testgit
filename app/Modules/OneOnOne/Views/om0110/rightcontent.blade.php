<div class="row" style="margin-left : 0px">
	<div class="col-md-12">
		<div class="col-md-3">
			<div class="row">
				<div class="form-group">
					<label class="control-label text-overfollow lb-required" lb-required="{{ __('messages.required') }}" style="margin-bottom: 0px;width: 265px;">
					{{ __('messages.large_category_name') }}
					</label>
					<span class="num-length">
						<input type="hidden" tabindex="-1" id="category1_cd" value="{{isset($data[0]['category1_cd'])? $data[0]['category1_cd']:'0'}}">
						<input type="hidden" tabindex="-1" id="company_cd_refer" value="{{isset($data[0]['company_cd'])? $data[0]['company_cd']:'-1'}}">
						<input type="hidden" tabindex="-1" id="refer_kbn" value="{{isset($data[0]['refer_kbn'])? $data[0]['refer_kbn']:'0'}}">
						<input type="text" class="form-control required text-left" tabindex="1" maxlength="50" value="{{isset($data[0]['category1_nm'])? $data[0]['category1_nm']:''}}" id="category1_nm">
					</span>
				</div><!-- end .col-md-3 -->
			</div>
		</div>
	</div><!-- end .col-md-12 -->
	<div class="col-md-12" style="margin-top : 10px">
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 480px">
			<table class="table table-bordered table-hover table-oneheader ofixed-boder" id="table-data" style="margin-bottom: 20px !important;">
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
						<th class="text-center">{{ __('messages.question') }}
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
					@if(isset($data[0]['category1_cd']) !='0')
					@foreach($data as $key=>$row)
					<tr class="tr" cate_no="{{$row['category2_cd']}}">
						<td rowspan="{{$row['row_span_cate2']}}" class="mid-cate {{$row['num_cate2'] == 1?'':'hidden'}}">
							<span class="num-length">
								<input type="hidden" class="category2_cd" value="{{isset($row['category2_cd'])?$row['category2_cd']:''}}">
								<input type="text" tabindex="2" class="form-control input-sm text-left category2_nm required " maxlength="50" value="{{isset($row['category2_nm'])?$row['category2_nm']:''}}">
							</span>
						</td>
						<td rowspan="{{$row['row_span_cate3']}}" class="low-cate  {{$row['num_cate3'] == 1?'':'hidden'}}" low_cate_cd="{{$row['category3_cd']}}">
							<span class="num-length">
								<input type="hidden" class="category3_cd" value="{{isset($row['category3_cd'])?$row['category3_cd']:''}}">
								<input type="text" tabindex="2" class="form-control input-sm text-left category3_nm" maxlength="50" value="{{isset($row['category3_nm'])?$row['category3_nm']:''}}" decimal="2">
							</span>
						</td>
						<td class="small-cate">
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
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input type="hidden" class="category3_cd" value="">
								<input type="text" tabindex="2" class="form-control input-sm text-left category3_nm" value="" maxlength="50" decimal="2">
							</span>
						</td>
						<td class="small-cate">
							<span class="num-length">
								<input type="hidden" class="question_cd" value="">
								<input type="text" tabindex="2" class="form-control input-sm text-left question required" value="" maxlength="200">
							</span>
						</td>
						<td class="text-center">
							<button tabindex="2" class="btn btn-rm btn-sm btn-remove-row">
								<i class="fa fa-remove"></i>
							</button>
						</td>
					</tr>
					@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div><!-- end .col-md-12 -->

</div><!-- end .row -->

<div class="row justify-content-md-center" style="margin-top: 30px;">
	{!!
		Helper::buttonRender1on1(['saveButton'])
	!!}
</div>

<table class="hidden" id="table-target">
	<tbody>
		<tr>
			<td class="mid-cate" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category2_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category2_nm required " maxlength="50" value="">
				</span>
			</td>
			<td class="low-cate" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category3_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category3_nm" value="" maxlength="50" decimal="2">
				</span>
			</td>
			<td class="small-cate">
				<span class="num-length">
					<input type="hidden" class="question_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left question required" value="" maxlength="200">
				</span>
			</td>
			<td class="text-center">
				<button tabindex="2" class="btn btn-rm btn-sm btn-remove-row">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
		{{-- low-cate --}}
		<tr class='new-tr'>
			<td class="mid-cate hidden" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category2_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category2_nm required " maxlength="50" value="">
				</span>
			</td>
			<td class="low-cate" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category3_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category3_nm" maxlength="50" decimal="2" value="">
				</span>
			</td>
			<td class="small-cate">
				<span class="num-length">
					<input type="hidden" class="question_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left question required" maxlength="200" value="">
				</span>
			</td>
			<td class="text-center">
				<button tabindex="2" class="btn btn-rm btn-sm btn-remove-row">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
		{{-- detail --}}
		<tr class='new-tr'>
			<td class="mid-cate hidden" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category2_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category2_nm required " maxlength="50" value="">
				</span>
			</td>
			<td class="low-cate hidden" rowspan="1">
				<span class="num-length">
					<input type="hidden" class="category3_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left category3_nm" maxlength="50" decimal="2" value="">
				</span>
			</td>
			<td class="td-detail">
				<span class="num-length">
					<input type="hidden" class="question_cd" value="">
					<input tabindex="2" type="text" class="form-control input-sm text-left question required" maxlength="200" value="">
				</span>
			</td>
			<td class="text-center">
				<button tabindex="2" class="btn btn-rm btn-sm btn-remove-row">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
	</tbody>
</table>
<!-- /.hidden -->
<input type="file" class="inputfile" id="import_file" maxlength="100" accept="application/csv">