<div class="row ">
	<div class="col-md-3 col-lg-3 col-xl-2 input-1">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
			<select id="fiscal_year" tabindex="1" class="form-control fiscal_year required">
				<option value="0"></option>
				@foreach($F0010 as $temp)
					<option value="{{$temp['fiscal_year']}}"{{$temp['fiscal_year']==$fiscal_year?'selected':''}}>{{$temp['fiscal_year']}}</option>
				@endforeach
			</select>
		</div>
	</div>
	<div class="col-md-5 col-lg-4 col-xl-3">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.eval_period') }}
			</label>
			<select name="" id="period_cd" class="form-control required" tabindex="2">
				<option value=""></option>
				@foreach($M0101 as $temp)
					<option value="{{$temp['detail_no']}}"{{$temp['detail_no']==$period_cd?'selected':''}}>{{$temp['period_nm']}}</option>
				@endforeach
			</select>
		</div>
	</div>
	<div class="col-md-4 col-lg-3 col-xl-3 input-3" >
		<div class="form-group" id="lb-period">
			<label class="control-label">&nbsp;</label>
			<input class="form-control text-center" type="text" readonly="readonly" value="{{$period_year['period_year']??''}}" />
			<input class="form-control hidden" type="text" readonly="readonly" value="{{$period_year['period_from']??''}}" id="period_from" />
			<input class="form-control hidden" type="text" readonly="readonly" value="{{$period_year['period_to']??''}}" id="period_to" />
		</div>
	</div>
</div> <!-- end .row -->

<div class="row">
	<div class="col-md-12" id="table-data">
		<div class="table-responsive">
			<table class="table table-bordered table-hover table-striped" id="table-data-1">
				<thead>
					<tr>
						<th width="10%">{{ __('messages.classification_i1040') }}</th>
						<th width="20%">{{ __('messages.item') }}</th>
						<th width="12%">{{ __('messages.implement_start_date') }}</th>
						<th width="12%">{{ __('messages.implement_deadline') }}</th>
						<th width="18%">{{ __('messages.notice') }}</th>
						<th width="18%">{{ __('messages.alert') }}</th>
					</tr>
				</thead>
				@for ($i = 0; $i < $count; $i++)
				<tbody>
					@if($result !=[])
					@foreach($result as $row)
					<tr class="list">
						@if ($row['category_num'] == 1)
						<td width="10%" class="back-fff" rowspan="{{ $row['category_count'] }}" style="vertical-align: top;">
							{{ $row['name'] }}
						</td>
						@endif
						<td width="10%" class="hidden">
							<input type="text"  class="hidden category" value="{{ $row['category'] }}"  />
							{{ $row['name'] }}
						</td>
						<td width="20%">
							<a href="#" class="screen_i1041" >{{$row['status_nm']}}</a>
							<input type="text" class="hidden status_cd" value="{{$row['status_cd']}}" />
						</td>
						<td width="12%" class="text-center">
							<div class="gflex">
								<div class="input-group-btn input-group" style="width: 160px">
									<input type="text" class="form-control input-sm date right-radius start_date" placeholder="yyyy/mm/dd" value="{{$row['start_date']??''}}" tabindex="3">
									<div class="input-group-append-btn">
										<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-calendar"></i></button>
									</div>
								</div>
							</div><!-- end .gflex -->
						</td>
						<td width="12%" class="text-center">
							<div class="gflex">
								<div class="input-group-btn input-group" style="width: 160px">
									<input type="text" class="form-control input-sm date right-radius deadline_date" placeholder="yyyy/mm/dd" value="{{$row['deadline_date']??''}}" tabindex="3">
									<div class="input-group-append-btn">
										<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-calendar"></i></button>
									</div>
								</div>
							</div><!-- end .gflex -->
						</td>
						<td width="18%">
							<select name="" id="" class="form-control input-sm notice_information" tabindex="3">
								@foreach($mess_typ as $dt)
									<option value="{{$dt['number_cd']}}" {{$dt['number_cd']==$row['notice_information']?'selected':''}}>{{$dt['name']}}</option>
								@endforeach
							</select>
						</td>
						<td width="18%">
							<select name="" id="" class="form-control input-sm alert_information" tabindex="3">
								@foreach($mess_typ as $dt)
									<option value="{{$dt['number_cd']}}" {{$dt['number_cd']==$row['alert_information']?'selected':''}}>{{$dt['name']}}</option>
								@endforeach
							</select>
						</td>
					</tr>
					@endforeach
					@else
					<tr class="tr-nodata">
						<td colspan="6" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
					</tr>
					@endif
				</tbody>
				@endfor
			</table>
		</div>
	</div>
</div> <!-- end .row -->
