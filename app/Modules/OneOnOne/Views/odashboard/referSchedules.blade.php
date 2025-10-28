<div class="" style="margin-top: 20px">
	<div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5 class="card-title"><b>{{ __('messages.1on1_schedule') }}</b></h5>
		<div class="row">
			@if(isset($schedules) && count($schedules) > 0)
				@foreach($schedules as $schedule)
			<div class="col-md-6 col-12  mb-3" >
				<div class="right-div-odashboard" style="height: 100%">
					<p><b>{{$schedule['title']}}</b></p>
					<p>
						@if ($schedule['is_coach'] == 1)
							{{$schedule['employee_nm']}}
						@else
							{{$schedule['coach_nm']}}
						@endif
					</p>
					<div class="row">
						<div class="col-md-12 col-lg-12 col-xl-6" style="min-width: 110px">
							<p >{{$schedule['schedule_date_1on1']}}</p>
						</div>
						<div class="col-md-12 col-lg-12 col-xl-6" style="min-width: 120px">
							<p >{{$schedule['time']}}</p>
						</div>
					</div>
					<p class="margin-bottom-text">{!!nl2br($schedule['place'])!!}</p>
					<input type="hidden" class="schedule_fiscal_year" value="{{ $schedule['fiscal_year'] ?? 0 }}" />
					<input type="hidden" class="schedule_employee_cd" value="{{ $schedule['employee_cd'] ?? '' }}" />
					<input type="hidden" class="schedule_times" value="{{ $schedule['times'] ?? 0 }}" />
					<input type="hidden" class="schedule_group_cd_1on1" value="{{ $schedule['group_cd_1on1'] ?? 0}}" />
				</div>
			</div>
			@endforeach
			@else
			<table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
                <tbody>
					<tr>
						<td colspan="3" class="text-center">
							{{ $_text[21]['message'] }}
						</td>
					</tr>
				</tbody>
            </table>
			{{-- <div class="col-md-12">
				<p class="margin-bottom-text">{{app('messages')->getText(21)->message}}</p>
			</div> --}}
			@endif
		</div>

	</div>
</div>