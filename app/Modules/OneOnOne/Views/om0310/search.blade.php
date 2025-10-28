@php
	function ordinal() {
	if( \Session::get('website_language', config('app.locale')) != 'en')
		return  '';
    else
        return 's';
	}
	@endphp
<div class="col-md-12">
	<div class="row">
		<div class="col-12 col-md-12 col-lg-12 wmd-view table-responsive sticky-table sticky-headers sticky-ltr-cells _width" style="max-height: 60vh">
			<table class="table table-bordered table-hover ofixed-boder" id="table-data">
				<thead>
					<tr>
						<th style="min-width: 150px">{{__('messages.group')}}</th>
						<th>{{__('messages.coach')}}</th>
						<th style="width: 340px;">{{__('messages.implementation_frequency')}}</th>
						<th>{{__('messages.sheet')}}</th>
					</tr>
				</thead>
				<tbody>
					@if(isset($list[0]['1on1_group_cd']) !='0')
					@foreach($list as $key=>$row)
					<tr class="data_group">
						<td class="text-left error_group">
							{{isset($row['1on1_group_nm'])?$row['1on1_group_nm']:''}}
							<input type="hidden" class="1on1_group_cd" value="{{$row['1on1_group_cd'] ?? ''}}">
						</td>

						<td class="text-center">
							<select class="form-control required select-class coach_position_cd" tabindex="1" style="width: 200px">
								<option value="-1"></option>
								@foreach($position as $temp)
								<option value="{{$temp['position_cd']}}" {{$row['coach_position_cd']==$temp['position_cd']?'selected':''}}>{{$temp['position_nm']}}</option>
								@endforeach
							</select>
						</td>

						<td class="">
							<form class="form-inline" style="width: 380px;margin-bottom: 0px">
								<div class="form-group mr-10 div_frequency display_block">
									<select class="form-control select-item required select-frequency frequency" tabindex="1" style="width: 200px">
										<option value="1" {{$row['frequency']==1?'selected':''}}>2 {{__('messages.month').ordinal()}}</option>
										<option value="2" {{$row['frequency']==2?'selected':''}}>1 {{__('messages.month')}}</option>
										<option value="3" {{$row['frequency']==3?'selected':''}}>2 {{__('messages.week').ordinal()}}</option>
										<option value="4" {{$row['frequency']==4?'selected':''}}>{{__('messages.others')}}</option>
									</select>
								</div>
								<div class="form-group times_other {{$row['times'] == '0'?'dis_none':''}}">
									<span class="num-length">
										<div class="input-group display_block">
											<input type="text" class="form-control only-number required times_interview" maxlength="3" value="{{$row['times'] != '0'?$row['times']:''}}" tabindex="1" style="width: 60px;border-radius: 5px;">
											<!-- <span style="margin: 10px">回／年</span> -->
										</div>
									</span>
								</div>
								<div class="div_frequency_nm {{$row['times'] == '0'?'dis_none':''}}" style="margin: 10px">{{__('messages.times_year')}}</div>
							</form>
						</td>

						<td class="text-center">
							<select class="form-control required select-name interview_cd" tabindex="1" style="width: 200px">
								<option value="-1"></option>
								@foreach($interview as $temp)
								<option value="{{$temp['interview_cd']}}" {{$row['interview_cd']==$temp['interview_cd']?'selected':''}}>{{$temp['interview_nm']}}</option>
								@endforeach
							</select>
						</td>
					</tr>
					@endforeach
					@else
					<tr style="border: 1px solid white">
                        <td class="text-center" colspan="4">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div>
</div>