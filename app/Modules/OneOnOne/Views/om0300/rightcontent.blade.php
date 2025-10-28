<style type="text/css" media="screen">
	.table td {
	    vertical-align: unset !important;
	}
	.md-checkbox-v2 input[type="checkbox"]:checked+label {
     	white-space: unset !important; 
	}
</style>
<div class="row">
	<div class="col-md-5 col-lg-4 col-xl-3 col-sm-12 col-12 group_cd">
		<div class="form-group">
			<label class="control-label">{{__('messages.group_cd')}}</label>
			<input type="text" id="group_cd" class="form-control text-left" value="{{$listm2600['group_cd']??''}}" tabindex="-1" readonly />
		</div>
	</div>
	<div class="col-md-6 col-lg-5 col-xl-4 col-sm-12 col-12">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.group_name')}}</label>
            <span class="num-length">
                <input type="text" id="group_nm" class="form-control required " placeholder="{{__('messages.general_group')}}" maxlength="20" value="{{$listm2600['group_nm']??''}}" tabindex="1">
            </span>
        </div>
    </div>
</div>
<div class="row">
	<div class="col-md-12">
		<div class="table-responsive">
			<table class="table table-bordered table-hover" id="table-data" style="">
				<thead>
					<tr>
						<th style="width: 250px;max-width: 250px">{{__('messages.position')}}</th>
						<th style="width: 250px;max-width: 250px">{{__('messages.job')}}</th>
						<th style="width: 250px;max-width: 250px">{{__('messages.grade')}}</th>
						<th style="width: 250px;max-width: 250px">{{__('messages.employee_classification')}}</th>
					</tr>
				</thead>
				<tbody >
					<tr>
						<td scope="row" class="text-left listm0040" style="max-width: 250px !important">
							<div>
								<ul class="multiselect-list2">
									@if(!empty($list_m0040))
										@foreach($list_m0040 as $key => $m0040)
											<li class="active m0040">
												<div class="md-checkbox-v2 ">
													<input name="1" id="{{$key.'m0040'}}" {{isset($m0040['checked']) && $m0040['checked'] ==1?'checked':''}} type="checkbox" value="{{$m0040['position_cd']??''}}" class="list_m0040" tabindex="1">
													<label class="label-error container"  data-toggle="tooltip" data-original-title="{{$m0040['position_nm']}}" style="min-width: 100%" for="{{$key.'m0040'}}">{{$m0040['position_nm']??''}}
													</label>
												</div>
											</li>
										@endforeach
									@endif
								</ul>
							</div>
						</td>
						<td scope="row" class="text-left listm0030" style="max-width: 250px !important">
							<div>
								<ul class="multiselect-list2">
									@if(!empty($list_m0030))
										@foreach($list_m0030 as $key => $m0030)
										<li class="active m0030">
											<div class="md-checkbox-v2 ">
												<input name="2" id="{{$key.'m0030'}}" {{isset($m0030['checked']) && $m0030['checked'] ==1?'checked':''}} type="checkbox" value="{{$m0030['job_cd']??''}}" class="list_m0030" tabindex="1">
												<label class="label-error container" data-toggle="tooltip" data-original-title="{{$m0030['job_nm']}}" style="min-width: 100%" for="{{$key.'m0030'}}">{{$m0030['job_nm']??''}}
												</label>
											</div>
										</li>
										@endforeach
									@endif
								</ul>
							</div>
						</td>
						<td scope="row" class="text-left listm0050" style="max-width: 250px !important">
							<div>
								<ul class="multiselect-list2">
									@if(!empty($list_m0050))
										@foreach($list_m0050 as $key => $m0050)
											<li class="active m0050">
												<div class="md-checkbox-v2 ">
													<input name="3" id="{{$key.'m0050'}}" {{isset($m0050['checked']) && $m0050['checked'] ==1?'checked':''}} type="checkbox" value="{{$m0050['grade']??''}}" class="list_m0050" tabindex="1">
													<label class="label-error container" data-toggle="tooltip" data-original-title="{{$m0050['grade_nm']}}" style="min-width: 100%" for="{{$key.'m0050'}}">{{$m0050['grade_nm']??''}}
													</label>
												</div>
											</li>
										@endforeach
									@endif
								</ul>
							</div>
						</td>
						<td scope="row" class="text-left listm0060" style="max-width: 250px !important">
							<div>
								<ul class="multiselect-list2">
									@if(!empty($list_m0060))
										@foreach($list_m0060 as $key => $m0060)
											<li class="active m0060">
												<div class="md-checkbox-v2 ">
													<input name="4" id="{{$key.'m0060'}}" {{isset($m0060['checked']) && $m0060['checked'] ==1?'checked':''}} type="checkbox" value="{{$m0060['employee_typ']??''}}" class="list_m0060" tabindex="1">
													<label class="label-error container" data-toggle="tooltip" data-original-title="{{$m0060['employee_typ_nm']}}" style="min-width: 100%" for="{{$key.'m0060'}}">{{$m0060['employee_typ_nm']??''}}
													</label>
												</div>
											</li>
										@endforeach
									@endif
								</ul>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div>
</div>
<div class="row justify-content-md-center">
    {!! Helper::buttonRender1on1(['saveButton']) !!}
</div>