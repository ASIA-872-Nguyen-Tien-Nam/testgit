<div class="row mb-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5><b>{{ __('messages.alert') }}</b></h5>
		<div class="table-responsive table-responsive-right">
			<table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
				<tbody>
					@if(isset($alerts) && !empty($alerts))
					@foreach($alerts as $alert)
					<tr class="list2">
						<td width="45%">
							{{$alert['infomation_title']}}
						</td>
						<td width="33.33%">
							{{$alert['target_employee_nm']}}
						</td>
						<td width="21.67%" class="borderRight text-center">
							{{$alert['infomation_date']}}
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