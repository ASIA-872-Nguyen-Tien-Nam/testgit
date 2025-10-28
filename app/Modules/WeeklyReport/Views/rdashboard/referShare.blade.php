<div class="row mb-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12 row noti_div" style="padding-right:0px">
		<div style="min-width: 150px;padding-left:10px;padding-right:10px">
			<h5><b>{{ __('rdashboard.shares') }}</b></h5>
		</div>
			<div style="padding-bottom:8px">
				<button type="button" class="btn btn_noti btn_share_show" style="bottom:4px">
					<i class="fa fa-plus" id="icon_add_noti"></i>
				</button>
				<button type="button" class="btn btn_noti btn_share_hide" style="display:none;bottom:4px">
					<i class="fa fa-minus" id="icon_add_noti"></i>
				</button>
			</div>
			<div>
				@if(isset($shares) && !empty($shares))
				<p style="display:inline; font-size:0.875rem;margin-left: 8px">
					<input type="hidden" class="noti_total" value="{{ count($shares) }}">
					<span class="noti_total_label">{{ count($shares) }}</span>{{ __('rdashboard.shares_total') }}</p>
				@endif
			</div>
		<div class="table-responsive table-responsive-right" style="padding-left:10px;">
			<table style="display:none" class="table table_share table-bordered table-cursor table-hover table-oneheader ofixed-boder">
				<tbody>
					@if(isset($shares) && !empty($shares))
					@foreach($shares as $share)
					<tr class="list2"
						fiscal_year="{{ $share['fiscal_year'] }}" 
						infomation_typ="{{ $share['infomation_typ'] }}" 
						employee_cd="{{ $share['employee_cd'] }}" 
						report_kind="{{ $share['report_kind'] }}" 
						report_no="{{ $share['report_no'] }}"
						from_employee_cd="{{ $share['from_employee_cd'] }}"
						to_employee_cd="{{ $share['to_employee_cd'] }}">
						<td style="display: flex">
							<div class="text-overfollow infomation_message" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($share['infomation_message'] ?? '')!!}">
								{{$share['infomation_message']}}
							</div>
							<div class="infomation_delete">
								<i class="fa fa-times btn_delete" aria-hidden="true"></i>
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