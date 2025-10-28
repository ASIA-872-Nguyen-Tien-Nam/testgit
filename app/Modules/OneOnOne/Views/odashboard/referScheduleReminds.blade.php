<div class="row mt-3">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5><b>{{ __('messages.remind') }}</b></h5>
		<div class="table-responsive-right table-responsive">
			<table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
				<thead>
					<th>{{ __('messages.title') }}</th>
					<th>{{ __('messages.member_name') }}</th>
					<th>{{ __('messages.datetime') }}</th>
				</thead>
				<tbody>
					@if(isset($schedules) && count($schedules) > 0)
					@foreach($schedules as $schedule)
					<tr class="list2">
						<td width="40%">
							<a class="schedule_link" href="javascript:;">{{$schedule['title']}}</a>
							<input type="hidden" class="schedule_fiscal_year" value="{{ $schedule['fiscal_year'] }}" />
							<input type="hidden" class="schedule_employee_cd" value="{{ $schedule['employee_cd'] }}" />
							<input type="hidden" class="schedule_times" value="{{ $schedule['times'] }}" />
							<input type="hidden" class="schedule_group_cd_1on1" value="{{ $schedule['group_cd_1on1'] }}" />
						</td>
						<td width="30%">
							{{$schedule['employee_nm']}}
						</td>
						<td width="30%" class="borderRight">
							{{ $schedule['schedule_date_1on1'].' '. $schedule['time'] }}
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