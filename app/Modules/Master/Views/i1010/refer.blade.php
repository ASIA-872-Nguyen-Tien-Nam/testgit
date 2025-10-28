<div class="row">
	<div class="col-sm-12 col-md-12 col-lg-12 col-xl-8">
		<div class="table-responsive">
			<table class="table table-bordered table-hover table-striped" id="table-data-1">
				<thead>
					<tr>
						<th width="33.3%">{{ __('messages.treatment_use') }}</th>
						<th width="33.3%">{{ __('messages.usage_category') }}</th>
						<th width="33.3%">{{ __('messages.evaluation_sheet') }}</th>
					</tr>
				</thead>
				<tbody >
					@if($result !=[])
						@foreach($result as $dt)
						<tr class="list">
							<td width="33.3%">
								<input type="text" hidden="" class="treatment_applications_no" value="{{$dt['detail_no']}}" />
								{{$dt['treatment_applications_nm']}}
							</td>
							<td width="33.3%">
								<select class="form-control use_typ" tabindex="2">
									@foreach($library_data as $lb)
										<option value="{{$lb['number_cd']}}" {{$lb['number_cd'] == $dt['use_typ']?'selected':''}}>{{$lb['name']}}</option>
									@endforeach
								</select>
							</td>
							@if($dt['use_typ'] == 1)
								<td width="33.3%">
									<select class="form-control sheet_use_typ" tabindex="2">
										@foreach($library_data as $lb)
											<option value="{{$lb['number_cd']}}" {{$lb['number_cd'] == $dt['sheet_use_typ']?'selected':''}}>{{$lb['name']}}</option>
										@endforeach
									</select>
								</td>
							@else
								<td width="33.3%">
									<select class="form-control sheet_use_typ" tabindex="2" disabled = 'disabled'>
										@foreach($library_data as $lb)
											<option value="{{$lb['number_cd']}}" {{$lb['number_cd'] ==0?'selected':''}}>{{$lb['name']}}</option>
										@endforeach
									</select>
								</td>
							@endif
						</tr>
						@endforeach
					@else
						<tr class="tr-nodata">
							<td colspan="3" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
						</tr>
					@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div>
</div>