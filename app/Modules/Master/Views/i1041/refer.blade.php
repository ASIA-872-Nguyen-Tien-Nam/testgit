
<div class="row">
	<div class="col-md-6">
		<div class="line-border-bottom">
			<label class="control-label">{{ __('messages.notice_setting') }}</label>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<div class="checkbox">
						<div class="md-checkbox-v2 inline-block">
							<input name="notice_information" tabindex="3" value="1" id="notice_information" {{($result['notice_information']??0)==1?'checked':''}} 
							type="checkbox">
							<label for="notice_information" ><span style="color: black;">{{ __('messages.notify_by_information') }}</span></label>
						</div>
						<div class="md-checkbox-v2 inline-block">
							<input name="notice_mail" tabindex="4" id="notice_mail" value="1" type="checkbox" {{($result['notice_mail']??0)==1?'checked':''}}>
							<label for="notice_mail" ><span style="color: black;">{{ __('messages.notify_by_email') }}</span></label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label {{$result['label_required1']??''}}" lb-required="{{ __('messages.required') }}" >{{ __('messages.title') }}</label>
					<span class="num-length">
						<input type="text" tabindex="5" class="form-control {{$result['input_required1']??''}}" value="{{$result['notice_title']??''}}" maxlength="50" id="notice_title">
					</span>
				</div>
			</div>
		</div> <!-- end .row -->

		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<label class="control-label {{$result['label_required1']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.message') }}</label>
					<span class="num-length">
						<textarea tabindex="6" rows="6" class="form-control {{$result['input_required1']??''}}" maxlength="1000" id="notice_message">{{$result['notice_message']??''}}</textarea>
					</span>
				</div>
			</div>
		</div> <!-- end .row -->
		<div class="row">
			<div class="col-md-6 col-xl-4 col-lg-4">
				<div class="form-group">
					<label class="control-label {{$result['label_required1']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.sending_target') }}</label>
					<select tabindex="7" class="form-control {{$result['input_required1']??''}}" id="notice_sending_target">
						<option value="-1"></option>
						@foreach($L0010 as $dt)
							<option value='{{$dt['number_cd']}}' 
								{{$dt['number_cd'] == ($result['notice_sending_target']??'')?'selected':''}}>{{$dt['name']}}
							</option>
						@endforeach
					</select>
				</div>
			</div>
			<div class="col-md-12 col-xl-6 col-lg-8">
				<div class="form-group">
					<label class="control-label {{$result['label_required1']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.sending_date') }}</label>
					<table>
						<tr>
							<td  class ='td-text ln-text'><span class="mg_right">{{ __('messages.start_date') }}</span></td>
							<td>
								<span id="" class="num-length mg_before_date1">
									<input type="tel" tabindex="8" class="form-control numeric {{$result['input_required1']??''}}" style="width:70px" maxlength="3" 
									value="{{$result['notice_send_date']??''}}" id="notice_send_date">
								</span>
							</td>
							<td class ='td-text ln-text' ><span class="mg_left">{{ __('messages.days_before') }}</span></td>
						</tr>
					</table>
				</div>
			</div>
		</div> <!-- end .row -->
	</div>
	<div class="col-md-6">
		<div class="line-border-bottom">
			<label class="control-label">{{ __('messages.alert_settings') }}</label>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<div class="checkbox">
						<div class="md-checkbox-v2 inline-block">
							<input name="alert_information" tabindex="9"  value="1" id="alert_information" {{($result['alert_information']??0)==1?'checked':''}}  
									type="checkbox">
							<label for="alert_information" tabindex="-1" ><span tabindex="-1" style="color: black;">{{ __('messages.notify_by_information') }}</span></label>
						</div>
						<div class="md-checkbox-v2 inline-block">
							<input name="alert_mail" id="alert_mail" value="1"  tabindex="10" type="checkbox" {{($result['alert_mail']??0)==1?'checked':''}} >
							<label  for="alert_mail" tabindex="-1"><span tabindex="-1" style="color: black;">{{ __('messages.notify_by_email') }}</span></label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label {{$result['label_required2']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.title') }}</label>
					<span class="num-length">
						<input type="tel" tabindex="11" class="form-control {{$result['input_required2']??''}}" value="{{$result['alert_title']??''}}" maxlength="50" id="alert_title">
					</span>
				</div>
			</div>
		</div> <!-- end .row -->

		<div class="row">
			<div class="col-md-12">
				<div class="form-group">
					<label class="control-label {{$result['label_required2']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.message') }}</label>
					<span class="num-length">
						<textarea tabindex="12" rows="6" class="form-control {{$result['input_required2']??''}}" maxlength="1000" id="alert_message">{{$result['alert_message']??''}}</textarea>
					</span>
				</div>
			</div>
		</div> <!-- end .row -->
		<div class="row">
			<div class="col-md-6 col-xl-4 col-lg-4">
				<div class="form-group">
					<label class="control-label {{$result['label_required2']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.sending_target') }}</label>
					<span class="num-length">
						<select tabindex="13" class="form-control {{$result['input_required2']??''}}" id="alert_sending_target">
							<option value="-1"></option>
							@foreach($L0010 as $dt)
								<option value='{{$dt['number_cd']}}' 
									{{$dt['number_cd'] == ($result['alert_sending_target']??'')?'selected':''}}>{{$dt['name']}}
								</option>
							@endforeach
						</select>
					</span>
				</div>
			</div>
			<div class="col-md-12 col-xl-6 col-lg-8">
				<div class="form-group">
					<label class="control-label {{$result['label_required2']??''}}" lb-required="{{ __('messages.required') }}">{{ __('messages.sending_date') }}</label>
					<table>
						<tr {{$result['input_required2']??''}} class="1">
							<td class ='td-text'><span class="mg_right">{{ __('messages.deadline') }}</span></td>
							<td >
								<span class="num-length mg_before_date2">
									<input type="tel" tabindex="14" class="form-control numeric {{$result['input_required2']??''}}" id="alert_send_date" maxlength="3" value="{{$result['alert_send_date']??''}}" style="width: 70px;">
								</span>
							</td>
							<td class ='td-text' ><span class="mg_left">{{ __('messages.days_after') }}</span></td>
						</tr>
					</table>
				</div>
			</div>
		</div> <!-- end .row -->

	</div>
</div>
