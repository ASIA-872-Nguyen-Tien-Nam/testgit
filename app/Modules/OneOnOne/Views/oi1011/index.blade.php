@extends('oneonone/layout')

@section('asset_header')
	{!!public_url('template/css/oneonone/oi1011/oi1011.index.css')!!}
@stop

@section('asset_footer')
	{!!public_url('template/js/oneonone/oi1011/oi1011.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::dropdownRender1on1(['saveButton','deleteButton','backButton'])
!!}
@endpush

@section('content')
@php
    $list_sending_target = array (
        [
            'number_cd'=> '1',
            'name'=>__('messages.everyone'),
        ],
        [
            'number_cd'=> '2',
            'name'=>__('messages.coach_only'),
        ],
        [
            'number_cd'=> '3',
            'name'=>__('messages.members_only'),
        ],
        [
            'number_cd'=> '4',
            'name'=>__('messages.untested_person'),
        ],
    );
@endphp
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-xl-3 col-lg-4 col-md-6">
					<div class="form-group">
		                <select name="" id="mail_kbn" class="form-control required" tabindex="1">
							<option value="1">{{__('messages.1on1_reminder_email')}}</option>
							<option value="2">{{__('messages.1on1_alert_mail')}}</option>
							<option value="3">{{__('messages.questionnaire_alert_email')}}</option>
						</select>
			        </div>
				</div>
			</div>

			<div class="row mt-10">
				<div class="col-md-6 col-xl-3 col-lg-3 col-12 col-sm-6 chechbox-width">
					<div class="md-checkbox-v2">
						<label for="information" class="container">{{__('messages.notify_by_information')}}
							<input name="information"  type="checkbox" checked id="information" class="required" value="1" tabindex="2">
							<span class="checkmark"></span>
						</label>
					</div>
				</div>
				<div class="col-md-6 col-xl-3 col-lg-3 col-12 col-sm-6">
					<div class="md-checkbox-v2">
						<label for="mail" class="container">{{__('messages.notify_by_email')}}
							<input name="mail"  type="checkbox" checked id="mail" class="required" value="1" tabindex="3">
							<span class="checkmark"></span>
						</label>
					</div>
				</div>
			</div>

			<div class="row mt-10">
				<div class="col-xl-8 col-lg-10 col-md-10">
					<div class="form-group">
			        	<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.title')}}</label>
			            <span class="num-length">
			                <div class="input-group-btn">
			                    <input type="text" id="title" class="form-control required" placeholder="{{__('messages.label_36')}}" value="" maxlength="50" tabindex="4">
			                </div>
			            </span>
			        </div>
				</div>
			</div>

			<div class="row mt-10">
				<div class="col-xl-8 col-lg-10 col-md-10">
					<div class="form-group">
			        	<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.message')}}</label>
						<div class="input-group-btn">
							<span class="num-length mess_len">
								<textarea class="form-control required" id="message" rows="4" placeholder="{!!__('messages.label_37')!!}
								" maxlength="200" tabindex="5"></textarea>
							</span>
						</div>
			        </div>
				</div>
			</div>

			<div class="row">
				<div class="col-xl-3 col-lg-4 col-md-4 ln-md-5">
					<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.sending_target')}}</label>
					<div class="form-group">
		                <select name="" id="sending_target" class="form-control required" tabindex="6">
							<option value="-1"></option>
		                	@foreach($list_sending_target as $item)
								<option value="{{$item['number_cd']}}">{{$item['name']}}</option>
							@endforeach
						</select>
			        </div>
				</div>
				<div class="col-xl-3 col-lg-3 col-md-3 ln-xl-3 ln-md-3">
					<div class="form-group">
			        	<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.sending_date')}}</label>
			            <span class="num-length">
			                <div class="input-group-btn">
			                    <input type="text" id="send_date" class="form-control required only-number" placeholder="" value="" maxlength="10" tabindex="7">
			                </div>
			            </span>
			        </div>
				</div>

				<div class="col-xl-2 col-lg-3 col-md-3 ln-xl-2 ln-md-4">
					<div class="form-group lh-custom">
						<label for="">&nbsp;</label>
		                <select name="" id="send_kbn" class="form-control required" tabindex="7" disabled>
							<option value="1">{{__('messages.days_before_1')}}</option>
							<option value="2">{{__('messages.days_after_1')}}</option>
						</select>
			        </div>
				</div>
			</div>
			<div class="row justify-content-md-center">
			{!! Helper::buttonRender1on1(['saveButton']) !!}
		</div>
		</div>
		
		<br/>
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
@stop
