<div class="row mb-3">
    <div class="col-sm-12 col-md-12 col-lg-12 col-12">
		<h5><b>{{ __('messages.notification') }}</b></h5>
        <div class="table-responsive table-responsive-right">
            <table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
                <tbody>

                    @if(isset($notifications) && !empty($notifications))
					@foreach($notifications as $notification)
					<tr class="list2">
						<td width="45%">
							{{$notification['infomation_title']}}
						</td>
						<td width="33.33%">
							{{$notification['times']}}
						</td>
						<td width="21.67%" class="borderRight text-center">
							{{$notification['deadline_date']}}
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
