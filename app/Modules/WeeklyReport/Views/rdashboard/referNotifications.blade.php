<div class="row mb-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12 row noti_div" style="padding-right:0px">
		<div style="min-width: 150px;padding-left:10px;padding-right:10px">
			<h5><b>{{ __('rdashboard.notifications') }}</b>
			</h5>
		</div>
		<div style="padding-bottom:8px">
			<button type="button" class="btn btn_noti btn_noti_show" style="bottom:6px">
				<i class="fa fa-plus" id="icon_add_noti"></i>
			</button>
			<button type="button" class="btn btn_noti btn_noti_hide" style="display:none;bottom:6px">
				<i class="fa fa-minus" id="icon_add_noti"></i>
			</button>
		</div>
		<div>
			@if(isset($notifications) && !empty($notifications))
			<p class="text-overfollow" data-toggle="tooltip" data-original-title="{{ __('rdashboard.comment') }}" style="display:inline; font-size:0.875rem;margin-left: 8px">
				<input type="hidden" class="noti_total" value="{{ count($notifications) }}">
				<span class="noti_total_label">{{ count($notifications) }}</span>{{ __('rdashboard.notifications_total') }}</p>
			@endif
		</div>
		<div style="padding-left:10px;" class="table-responsive table-responsive-right">
			<table style="display:none" class="table table-bordered table_noti table-cursor table-hover table-oneheader ofixed-boder">
				<tbody>
					@if(isset($notifications) && !empty($notifications))
					@foreach($notifications as $notification)
					<tr class="list2"
						fiscal_year="{{ $notification['fiscal_year'] }}" 
						infomation_typ="{{ $notification['infomation_typ'] }}" 
						employee_cd="{{ $notification['employee_cd'] }}" 
						report_kind="{{ $notification['report_kind'] }}" 
						report_no="{{ $notification['report_no'] }}"
						from_employee_cd="{{ $notification['from_employee_cd'] }}"
						to_employee_cd="{{ $notification['to_employee_cd'] }}">
						<td style="display: flex">
							<div class="text-overfollow infomation_message" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($notification['infomation_title'] ?? '')!!}">
								{{$notification['infomation_title']}}
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