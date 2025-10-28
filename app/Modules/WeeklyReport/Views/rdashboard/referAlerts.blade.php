<div class="row mb-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5 style="margin-bottom:10px"><b>{{ __('rdashboard.alert') }}</b>
		</h5>
		<div class="table-responsive table-responsive-right">
			<table class="table table-bordered table_alert table-cursor table-hover table-oneheader ofixed-boder">
				<tbody>
					@if(isset($alerts) && !empty($alerts))
					@foreach($alerts as $alert)
					<tr class="list2"
						fiscal_year="{{ $alert['fiscal_year'] }}" 
						infomation_typ="{{ $alert['infomation_typ'] }}" 
						employee_cd="{{ $alert['employee_cd'] }}" 
						report_kind="{{ $alert['report_kind'] }}" 
						report_no="{{ $alert['report_no'] }}">
						<td style="display: flex">
							<div class="text-overfollow infomation_message" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($alert['infomation_title'] ?? '')!!}">
								{{$alert['infomation_title']}}
							</div>
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