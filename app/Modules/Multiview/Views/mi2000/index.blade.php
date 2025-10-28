@extends('mlayout')

@section('asset_header')
{!!public_url('template/css/mulitiview/mi2000/mi2000.index.css')!!}
@stop

@section('asset_footer')
{!!public_url('template/js/mulitiview/mi2000/mi2000.index.js')!!}
@stop

@push('asset_button')

@if($permission == 2)
{!!
	Helper::dropdownRenderMulitireview(['saveButton','deleteButton','backButton'])
!!}
@else
{!!
	Helper::dropdownRenderMulitireview(['backButton'])
!!}
@endif
@endpush

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-sm-6 col-md-6 col-lg-6" style="min-width:185px">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.employee_name')}}</label>
						<div class="input-group-btn input-group div_employee_cd">
							<span class="num-length">
								<input type="hidden" class="employee_cd_hidden"  id="employee_cd" value="{{ $employee_data['employee_cd'] ??'' }}" />
								<input type="hidden" class="" id="supporter_cd" value="{{ $supporter_data['supporter_cd'] ?? '' }}" />
								<input type="hidden" class="" id="detail_no" value="{{ $result['detail_no'] ?? 0 }}" />
								<input type="hidden" class="" id="fiscal_year" value="{{ $fiscal_year ?? 0 }}" />
								<input fiscal_year_mulitireview="{{ $fiscal_year ?? 0 }}"  type="text" id="employee_nm" 
									class="form-control employee_nm_mulitireview employee_nm  required" old_employee_nm="{{ $employee_data['employee_nm'] ??'' }}" tabindex="1" maxlength="20" 
									value="{{ $employee_data['employee_nm'] ??'' }}" style="padding-right: 40px;" disabled/>
							</span>
						</div>
					</div>
				</div>
			</div>

			<div class="row mt-10">
				<div class="col-sm-4 col-md-3 col-lg-3  select-width-multi">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.review_date')}}</label>
						<div class="multi-select-full">
							<div class="gflex">
								<div class="input-group-btn input-group" style="width: 100%">
									<input style="width: 100%"  type="text" class="form-control input-sm date right-radius start_date required" 
									placeholder="yyyy/mm/dd" id="review_date" value="{{$result['review_date'] ?? ''}}" tabindex="2" {{$permission == 1 ? 'disabled' : ''}} >
									<div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1"></button>
                                    </div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-4 col-md-6 col-lg-5">
					<div class="form-group">
						<label class="control-label">{{__('messages.supporter')}}</label>
						<div class="multi-select-full">
							<div class="gflex">
								<div class="input-group-btn input-group" style="width: 100%">
									<input type="text" class="form-control" disabled="disabled" placeholder="" value="{{ $supporter_data['supporter_nm'] ??''}}" tabindex="3">
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-4 col-md-6 col-lg-5">
					<div class="form-group">
						<label class="control-label">{{__('messages.1st_rater')}}</label>
						<div class="gflex" style="justify-content:unset;">
							<div class=" text-overfollow"  data-toggle="tooltip" data-original-title="{{ $employee_data['rater_employee_nm_1_string'] ??'' }}"
									style="max-width:100%; display:unset !important;">
								{{ $employee_data['rater_employee_nm_1_string'] ??'' }}
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row mt-10">
				<div class="col-md-6 col-lg-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.title_project_issue_name')}}</label>
						<span class="num-length">
							<div class="input-group-btn">
								<input type="text" id="project_title" class="form-control" {{$permission == 1 ? 'disabled' : ''}} value="{{ $result['project_title'] ?? ''}}" maxlength="50" tabindex="4">
							</div>
						</span>
					</div>
				</div>
			</div>
			<div class="row mt-10">
				<div class="col-sm-6 col-md-3 col-lg-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.evaluation')}}</label>
						<span class="num-length">
							<div class="input-group-btn">
								@php
								$evaluation_point = $result['evaluation_point'] ?? 0;
								@endphp
								<select type="text" {{$permission == 1 ? 'disabled' : ''}}  id="evaluation_typ" class="form-control" maxlength="50" tabindex="5">
									<option {{ $evaluation_point == 3 ?'selected':''}} value="3">3 {{__('messages.point')}}</option>
									<option {{ $evaluation_point == 2 ?'selected':''}}  value="2">2 {{__('messages.point')}}</option>
									<option {{ $evaluation_point == 1 ?'selected':''}} value="1">1 {{__('messages.point')}}</option>
									<option {{ $from == 'mdashboardsupporter' || $from == '' ? 'selected' :($evaluation_point == 0 ?'selected':'') }} value="0" >--</option>
									<option {{ $evaluation_point == -1 ?'selected':''}} value="-1">-1 {{__('messages.point')}}</option>
									<option {{ $evaluation_point == -2 ?'selected':''}} value="-2">-2 {{__('messages.point')}}</option>
									<option {{ $evaluation_point == -3 ?'selected':''}} value="-3">-3 {{__('messages.point')}}</option>
								</select>
							</div>
						</span>
					</div>
				</div>
			</div>
			<div class="row mt-10">
				<div class="col-md-6">
					<div class="form-group">
						<label class="control-label">{{__('messages.label_004')}}</label>
						<div class="multi-select-full select-width-multi2" style="margin-bottom: 15px">
							<div class="gflex">
								<div class="input-group-btn input-group" style="width: 100%">
									<input type="text" id="comment_date" class="form-control input-sm date right-radius start_date " placeholder="yyyy/mm/dd" 
									value="{{ $result['comment_date'] ?? ''}}" tabindex="5" {{$permission == 1 ? 'disabled' : ''}} >
									<div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1"></button>
                                    </div>
								</div>	
							</div>
						</div>
						<div class="input-group-btn">
							<span class="num-length">
								<textarea class="form-control" {{$permission == 1 ? 'disabled' : ''}} id="comment" rows="4" placeholder="" maxlength="200" tabindex="6">{{ $result['comment'] ?? ''}}</textarea>
							</span>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 col-sm-12 col-md-6 col-lg-4">
					<table>
						<tr>
							<td style="height: 38px;">
								<div class="md-checkbox-v2 checkbox-div">
									<label for="use_typ" style="margin: 0;" class="lbl-text container">&nbsp;{{__('messages.label_005')}}
										<input name="use_typ" {{$permission == 1 ? 'disabled' : ''}} id="use_typ" checked value="1" type="checkbox" tabindex="6" tab>
										<span class="checkmark"></span>
									</label>
								</div>
							</td>

						</tr>
					</table>
				</div>
			</div>
			@if($permission == 2)
			<div class="row justify-content-md-center">
				{!!
				Helper::buttonRenderMulitireview(['saveButton'])
				!!}
			</div>
			@endif
		</div>
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
<input type="hidden" id="from" name="" value="{{ $from ?? '' }}">
@stop