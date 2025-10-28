<div class="tab-pane fade" id="tab18">
<div class="row">
		<div class="col-md-12">
			<div class="table-responsive">
				@if (isset($tab_18['list'][0]))
				<table class="table table-bordered" style="min-width: 680px">
					<thead>
						<tr>
							<th style="color: #707070 !important;width: 8%">
								<div>{{__('messages.fiscal_year')}}</div>
							</th>
							@foreach($tab_18['head'] as $key=>$item)
								<th style="color: #707070 !important;width: 15.5%">
									<div>{{$item['treatment_applications_nm']}}</div>
								</th>
							@endforeach
						</tr>
					</thead>
					<tbody >
						@foreach($tab_18['list'] as $key=>$item)
						<tr style="background: #f1f1f1;height: 38px;">
							@foreach($item as $key1=>$item1)
							@if ($key1 == 'fiscal_year')
							<td style="text-align: center;">
								<div>{{$item1}}</div>
							</td>
							@else
							<td>
								<div>{{$item1}}</div>
							</td>
							@endif
							@endforeach
						</tr>
						@endforeach
					</tbody>
				</table>
				@endif
			</div><!-- end .table-responsive -->
		</div>
	</div>
</div>