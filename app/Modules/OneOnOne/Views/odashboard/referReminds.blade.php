<div class="row mt-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5><b>{{ __('messages.remind') }}</b></h5>
		<div class="table-responsive-right table-responsive">
			<table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
				<thead>
					<th>{{ __('messages.content') }}</th>
					<th>{{ __('messages.subject') }}</th>
					<th>{{ __('messages.plan_date') }}</th>
				</thead>
				<tbody>
					@if(isset($reminds) && !empty($reminds))
					@foreach($reminds as $remind)
					<tr class="list2">
						<td width="45%">
							<a class="information_link" href="javascript:;">{{$remind['infomation_title']}}</a>
						</td>
						<td width="33.33%">
							{{$remind['target_employee_nm']}}
						</td>
						<td width="21.67%" class="borderRight text-center">
							{{$remind['infomation_date']}}
						</td>
					</tr>
					@endforeach
					@else
					<tr>
						<td colspan="3" class="text-center">
							{{ $_text[21]['message'] }}
						</td>
					</tr>
					@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div>
</div>