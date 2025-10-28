<div class="table-responsive copy-content">
	<table class="table table-bordered table-hover table-striped ">
		<thead>
			<tr>
				<th class="w25" >{{__('messages.employee_classification')}}</th>
				<th class="w25" >{{__('messages.job')}}</th>
				<th class="w25" >{{__('messages.position')}}</th>
				<th class="w25" >{{__('messages.grade')}}</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td scope="row" class="text-center">
					<div>
						<ul class="multiselect-list2">
							@foreach($m0060 as $row)
							<li class="active m0060">
								<div class="md-checkbox-v2">
									<label for="m0060{{$loop->index}}"  class="label-error mb-0"></label >
									<label data-toggle="tooltip" for="m0060{{$loop->index}}" class="label-title 1 text-overfollow mb-0" data-title="{{$row['employee_typ_nm']}}"></label >
						            <input class="chk form-control" name="ck111" id="m0060{{$loop->index}}" type="checkbox" {{$row['detail_no'] ? 'checked' : ''}} value="1" tabindex="4">
						            <label for="m0060{{$loop->index}}" class="m-0 text-overflow 2 text-overfollow" >{{$row['employee_typ_nm']}}</label>
						        </div>
								<input type="hidden" class="code" value="{{$row['employee_typ']}}" />
							</li>
							@endforeach
						</ul>
					</div>
				</td>
				<td scope="row" class="text-center">
					<div>
						<ul class="multiselect-list2">
							@foreach($m0030 as $row)
							<li class="active m0030">
								<div class="md-checkbox-v2">
									<label data-toggle="tooltip" for="m0030{{$loop->index}}" class="label-title text-overfollow mb-0" data-title="{{$row['job_nm']}}"></label >
						            <input class="chk form-control" name="ck111" id="m0030{{$loop->index}}" type="checkbox" {{$row['detail_no'] ? 'checked' : ''}}  value="1" tabindex="5">
						            <label data-toggle="tooltip" for="m0030{{$loop->index}}" class="m-0  text-overflow text-overfollow" data-title="{{$row['job_nm']}}">{{$row['job_nm']}}</label>
						        </div>
								<input type="hidden" class="code" value="{{$row['job_cd']}}" />
							</li>
							@endforeach
						</ul>
					</div>
				</td>
				<td scope="row" class="text-center">
					<div>
						<ul class="multiselect-list2">
							@foreach($m0040 as $row)
							<li class="active m0040">
								<div class="md-checkbox-v2">
									<label data-toggle="tooltip" for="m0040{{$loop->index}}" class="label-title text-overfollow mb-0 " data-title="{{$row['position_nm']}}"></label >
						            <input class="chk form-control" name="ck111" id="m0040{{$loop->index}}" type="checkbox" {{$row['detail_no'] ? 'checked' : ''}}  value="1" tabindex="6">
						            <label data-toggle="tooltip" for="m0040{{$loop->index}}" class="m-0 text-overflow text-overfollow" data-title="{{$row['position_nm']}}">{{$row['position_nm']}}</label>
						        </div>
								<input type="hidden" class="code" value="{{$row['position_cd']}}" />
							</li>
							@endforeach
						</ul>
					</div>
				</td>
				<td scope="row" class="text-center">
					<div>
						<ul class="multiselect-list2">
							@foreach($m0050 as $row)
							<li class="active m0050">
								<div class="md-checkbox-v2">
									<label data-toggle="tooltip" for="m0050{{$loop->index}}" class="label-title text-overfollow mb-0" data-title="{{$row['grade_nm']}}"></label >
						            <input class="chk form-control" name="ck111" id="m0050{{$loop->index}}" type="checkbox" {{$row['detail_no'] ? 'checked' : ''}}  value="1" tabindex="7">
						            <label data-toggle="tooltip" for="m0050{{$loop->index}}" class="m-0 text-overflow text-overfollow" data-title="{{$row['grade_nm']}}">{{$row['grade_nm']}}</label>
						        </div>
								<input type="hidden" class="code" value="{{$row['grade']}}" />
							</li>
							@endforeach
						</ul>
					</div>
				</td>
				{{--<td class="text-center">
					<button class="btn btn-rm btn-sm btn-remove">
						<i class="fa fa-remove"></i>
					</button>
				</td>--}}
			</tr>
		</tbody>
	</table>
</div>