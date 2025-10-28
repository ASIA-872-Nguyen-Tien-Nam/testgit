<div class="row">
	<div class=" col-sm-12 col-md-8 col-lg-10 col-xl-10">
		<div class="form-group">
			<label class="control-label  lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.point_type_name') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="hidden" id="point_kinds" value="{{isset($data[0][0]['point_kinds'])? $data[0][0]['point_kinds']:'0'}}">
					<input type="text" id="point_kinds_nm" class="form-control required" maxlength="50" value="{{isset($data[0][0]['point_kinds_nm'])? $data[0][0]['point_kinds_nm']:''}}" tabindex="1">
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
	<div class="col-sm-12 col-md-4 col-lg-2 col-xl-2">
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="text" id="arrange_order" class="form-control only-number" maxlength="4" value="{{isset($data[0][0]['arrange_order'])? $data[0][0]['arrange_order']:''}}" tabindex="2"/>
				</span>
			</div>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="table-responsive">
			<table class="table table-bordered table-hover table-striped " id="table-data">
				<thead>
				<tr>
					<th style="width: 13%">{{ __('messages.point_name') }}</th>
					<th style="width: 8%">{{ __('messages.score') }}</th>
					<th style="width: 65%">{{ __('messages.eval_standard') }}</th>
					<th style="width: 3%">
						<button class="btn btn-rm blue btn-sm" id="btn-add-new-row">
							<i class="fa fa-plus"></i>
						</button>
					</th>
				</tr>
				</thead>
				<tbody>
					@if(isset($data[1][0]['point_cd']) !='0')
						@foreach($data[1] as $key=>$row)
							<tr class="list_point_kinds">
								<td>
									<span class="num-length">
										<input type="hidden" class="mode" value="U">
										<input type="hidden" class="point_cd" value="{{$row['point_cd']}}">
										<input type="text" class="form-control point_nm input-sm" maxlength="20" value="{{$row['point_nm']}}" tabindex="{{3+($key*3)}}"/>
									</span>
								</td>
								<td >
									<span class="num-length">
										<input  type="text" class="form-control point input-sm  hyouka-score text-right" negative="true" maxlength="3" value="{{$row['point']}}" tabindex="{{4+($key*3)}}"/>
									</span>
								</td>
								<td>
									<span class="num-length">
										<input type="text" class="form-control point_criteria input-sm required" maxlength="50" value="{{$row['point_criteria']}}" tabindex="{{5+($key*3)}}"/>
									</span>
								</td>
								<td class="text-center">
									<button class="btn btn-rm btn-sm btn-remove-row" tabindex="{{6+($key*3)}}">
										<i class="fa fa-remove"></i>
									</button>
								</td>
							</tr>
						@endforeach
					@else
						<tr class="list_point_kinds">
							<td >
								<span class="num-length">
									<input type="hidden" class="mode" value="A">
									<input type="hidden" class="point_cd" value="">
									<input type="text" class="form-control point_nm input-sm" maxlength="20" value="" tabindex="3"/>
								</span>
							</td>
							<td >
								<span class="num-length">
									<input type="text" class="form-control point input-sm hyouka-score text-right" negative="true" maxlength="3" value="" tabindex="4"/>
								</span>
							</td>
							<td>
								<span class="num-length">
									<input type="text" class="form-control point_criteria input-sm required" maxlength="50" value="" tabindex="5"/>
								</span>
							</td>
							<td class="text-center">
								<button class="btn btn-rm btn-sm btn-remove-row" tabindex="6">
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
