@extends('slayout')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!! public_url('template/css/basicsetting/a0003/a0003.index.css') !!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
	{!! public_url('template/js/basicsetting/a0003/a0003.index.js') !!}
<!-- {!!public_url('template/js/common/zipcode.js')!!} -->
<!-- <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD-SuUsQXWnWMeFRDzOk1MAtJcdurZFYcM&callback=initMap&language=ja"></script> -->
@stop
@push('asset_button')
    {!!
        Helper::buttonRender(['backButton'])
    !!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div id="a0003-body">
	<div class="card">
		<div class="card-body">
		{{-- tab 4 --}}
			<div class="row">
				<div class="col-md-6">
					<div class="form-group">
						<div class="checkbox">
							<div class="md-checkbox-v2 ">
								@if (isset($api_use_typ) && $api_use_typ == 1)
								<input class="cb-api" name="api_use_typ" id="api_use_typ" value="{{$api_use_typ}}" checked type="checkbox"  tabindex="1" >
								@else
								<input class="cb-api" name="api_use_typ" id="api_use_typ" value="{{$row1['api_use_typ']??'0'}}" {{isset($row1['api_use_typ'])&&$row1['api_use_typ']==1?'checked':''}} type="checkbox" tabindex="1">									
								@endif
								<label for="api_use_typ">{{ __('messages.freeapi_linkage') }}</label>
							</div>
						</div><!-- end .checkbox -->
					</div>
				</div>
			</div>
			<div class="row">
				<div class=" button_freee">
					<div class="form-group">
						<label class="control-label">&nbsp</label>
						<div class="full-width">
							@if (isset($api_use_typ) && $api_use_typ == 1)
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary btn-get-accesstoken mw-150" tabindex="1">
								<i class="fa fa-check"></i>
								{{ __('messages.get_office') }}
							</a>
							@else
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary btn-get-accesstoken mw-150" tabindex="1" {{isset($row1['api_use_typ'])&&$row1['api_use_typ']==1?'':'disabled'}} >
								<i class="fa fa-check"></i>
								{{ __('messages.get_office') }}
							</a>	
							@endif
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-4 col-lg-3">
					<div class="form-group">
						<label class="control-label">{{ __('messages.office_code') }}</label>
						<span class="num-length">
							<input type="text" id="api_office_cd"  class="form-control hidden" maxlength="255" tabindex="-1" value="{{$companies[0]['id']??($row1['api_office_cd']??'')}}">
							<input type="text" id="api_office_nm"  class="form-control" disabled="disabled" maxlength="255" tabindex="-1" value="{{$companies[0]['name']??($row1['api_office_nm']??'')}}">
						</span>
					</div><!--/.form-group -->
				</div>

			</div>
			<div class="row">
				<div class="  button_freee">
					<div class="form-group">
						<div class="full-width">
							@if (isset($api_use_typ) && $api_use_typ == 1)
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary btn-issue-api mw-150" tabindex="1" >
								<i class="fa fa-check"></i>
								{{ __('messages.execution') }}
							</a>	
							@else
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary btn-issue-api mw-150" tabindex="1" {{isset($row1['api_use_typ'])&&$row1['api_use_typ']==1?'':'disabled'}} >
								<i class="fa fa-check"></i>
								{{ __('messages.execution') }}
							</a>
							@endif
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-8 col-lg-9 col-xl-8">
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api" name="api_employee_use" id="api_employee_use" value="{{isset($row1['api_employee_use'])?$row1['api_employee_use']:'0'}}" {{isset($row1['api_employee_use'])&&$row1['api_employee_use']==1?'checked':''}} type="checkbox"  tabindex="1">
										<label for="api_employee_use">{{ __('messages.link_employees_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input  class="cb-api" name="api_position_use" id="api_position_use" value="{{isset($row1['api_position_use'])?$row1['api_position_use']:'0'}}" {{isset($row1['api_position_use'])&&$row1['api_position_use']==1?'checked':''}} type="checkbox"   tabindex="1">
										<label for="api_position_use">{{ __('messages.link_positions_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api" name="api_organization_use" id="api_organization_use" value="{{isset($row1['api_organization_use'])?$row1['api_organization_use']:'0'}}" {{isset($row1['api_organization_use'])&&$row1['api_organization_use']==1?'checked':''}} type="checkbox" tabindex="1">
										<label for="api_organization_use">{{ __('messages.link_organizations_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
					</div>
				</div>


			</div>
		</div>
		</div>
	</div>
</div>
<div class="container-fluid">
	<div id="a0003-body">
	<div class="card">
		<div class="card-body">
		{{-- tab 4 --}}
			<div class="row">
				<div class="col-md-6">
					<div class="form-group">
						<div class="checkbox">
							<div class="md-checkbox-v2 ">
								@if (isset($kot_api_use_typ) && $kot_api_use_typ == 1)
								<input class="cb-api" name="api_kot_use_typ" id="api_kot_use_typ" value="{{$kot_api_use_typ}}" checked type="checkbox" tabindex="1">
								@else
								<input class="cb-api" name="api_kot_use_typ" id="api_kot_use_typ" value="{{$row1['kot_api_use_typ']??'0'}}" {{isset($row1['kot_api_use_typ'])&&$row1['kot_api_use_typ']==1?'checked':''}} type="checkbox" tabindex="1">									
								@endif
								<label for="api_kot_use_typ">{{ __('messages.link_with_KING_of_Time_API') }}</label>   
							</div>
						</div><!-- end .checkbox -->
					</div>
				</div>
			</div>
			<div class="row" >
				<div class="div_button_exe" style="width:330px">
					<div class="form-group">
						<label class="control-label">&nbsp</label>
						<div class="full-width">
							@if (isset($kot_api_use_typ) && $kot_api_use_typ == 1)
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" id="btn-get-accesstoken_kot" class="full-width btn btn-primary btn-get-accesstoken_kot mw-150" tabindex="1">
								<i class="fa fa-check"></i>
								{{ __('messages.issuance_of_access_token') }}
							</a>
							@else
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" id="btn-get-accesstoken_kot" class="full-width btn btn-primary btn-get-accesstoken_kot mw-150" tabindex="1" {{isset($row1['kot_api_use_typ'])&&$row1['kot_api_use_typ']==1?'':'disabled'}} >
								<i class="fa fa-check"></i>
								{{ __('messages.issuance_of_access_token') }}
							</a>	
							@endif
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-4 col-lg-3">
					<div class="form-group" hidden>
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.kot_client_id') }}</label>
						<span class="num-length">
							<input type="text" id="kot_client_id"  class="form-control required" maxlength="255" tabindex="1" value="{{($row1['kot_client_id']??'')}}" autofocus>
						</span>
					</div><!--/.form-group -->
				</div>

				<div class="col-md-4 col-lg-3">
					<div class="form-group" hidden>
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.kot_client_secret') }}</label>
						<span class="num-length">
							<input  type="text" id="kot_client_secret"  class="form-control  required"  maxlength="255" tabindex="1" value="{{$row1['kot_client_secret']??''}}">
						</span>
					</div><!--/.form-group -->
				</div>
			</div>
			<div class="row last_row" >
				<div class="div_button_exe" style="width:330px">
					<div class="form-group">
						<div class="full-width">
							@if (isset($kot_api_use_typ) && $kot_api_use_typ == 1)
							<a href="javascript:;" id="btn-issue-api_kot" lh-language="{{ __('messages.required') }}" class="btn btn-primary full-width btn-issue-api_kot mw-150" tabindex="1">
								<i class="fa fa-check"></i>
								{{ __('messages.link_data_to_MIRAIC') }}
							</a>	
							@else
							<a href="javascript:;" id="btn-issue-api_kot"  lh-language="{{ __('messages.required') }}" class="btn btn-primary full-width btn-issue-api_kot mw-150" tabindex="1" {{isset($row1['kot_api_use_typ'])&&$row1['kot_api_use_typ']==1?'':'disabled'}} >
								<i class="fa fa-check"></i>
								{{ __('messages.link_data_to_MIRAIC') }}
							</a>
							@endif
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-8 col-lg-9 col-xl-8">
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api-kot" name="kot_api_employee_use" id="kot_api_employee_use" value="{{isset($row1['kot_api_employee_use'])?$row1['kot_api_employee_use']:'0'}}" {{isset($row1['kot_api_employee_use'])&&$row1['kot_api_employee_use']==1?'checked':''}} type="checkbox"  tabindex="1">
										<label for="kot_api_employee_use">{{ __('messages.link_employees_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api-kot" name="kot_api_organization_use" id="kot_api_organization_use" value="{{isset($row1['kot_api_organization_use'])?$row1['kot_api_organization_use']:'0'}}" {{isset($row1['kot_api_organization_use'])&&$row1['kot_api_organization_use']==1?'checked':''}} type="checkbox"  tabindex="1">
										<label for="kot_api_organization_use">{{ __('messages.link_organizations_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api-kot" name="kot_api_employee_typ_use" id="kot_api_employee_typ_use" value="{{isset($row1['kot_api_employee_typ_use'])?$row1['kot_api_employee_typ_use']:'0'}}" {{isset($row1['kot_api_employee_typ_use'])&&$row1['kot_api_employee_typ_use']==1?'checked':''}} type="checkbox"  tabindex="1">
										<label for="kot_api_employee_typ_use">{{ __('messages.link_employeeType_information') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="div_button_exe" style="width:330px">
					<div class="form-group">
						<div class="full-width">
							@if (isset($kot_api_use_typ) && $kot_api_use_typ == 1)
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary full-width btn-issue-api_kot mw-150" id="btn-issue-api_kot_upload" tabindex="1">
								<i class="fa fa-check"></i>
								{{ __('messages.link_data_to_KING_of_time') }}
							</a>	
							@else
							<a href="javascript:;" lh-language="{{ __('messages.required') }}" class="btn btn-primary full-width btn-issue-api_kot mw-150" tabindex="1" id="btn-issue-api_kot_upload"  {{isset($row1['kot_api_use_typ'])&&$row1['kot_api_use_typ']==1?'':'disabled'}} >
								<i class="fa fa-check"></i>
								{{ __('messages.link_data_to_KING_of_time') }}
							</a>
							@endif
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-8 col-lg-9 col-xl-8">
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<div class="checkbox">
									<div class="md-checkbox-v2">
										<input class="cb-api cb-api-kot_upload cb-api-kot" name="kot_api_employee_get" id="kot_api_employee_upload_use" value="{{isset($row1['kot_api_employee_get'])?$row1['kot_api_employee_get']:'0'}}" {{isset($row1['kot_api_employee_get'])&&$row1['kot_api_employee_get']==1?'checked':''}} type="checkbox"  tabindex="1">
										<label for="kot_api_employee_upload_use">{{ __('messages.link_employees_info') }}</label>
									</div>
								</div><!-- end .checkbox -->
							</div>
						</div>
					</div>
				</div>
			</div>			
		</div>
		</div>
	</div>
</div>
<div class="div_loading">
    <div class="image_loading_popup">
        <img src="{{ asset('template/image/system/loading.gif') }}">
    </div>
</div>
<input type='hidden' id='api_err' value='{{$err??''}}'/>
<input type='hidden' id='api_company_id' value='{{$id??''}}'/>
<input type='hidden' id='api_company_nm' value='{{$name??''}}'/>
<input type='hidden' id='data_api' value='{{$data_api??''}}'/>
@stop