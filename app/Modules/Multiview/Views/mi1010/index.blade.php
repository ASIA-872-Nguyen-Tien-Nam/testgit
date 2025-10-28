@extends('mlayout')

@push('header')
{!! public_url('template/css/mulitiview/mi1010/mi1010.index.css') !!}
@endpush

@section('asset_footer')
{!! public_url('template/js/mulitiview/mi1010/mi1010.index.js') !!}
@stop
@push('asset_button'){!!
Helper::dropdownRenderMulitireview(['saveButton','supportPopup','downloadButton4','exportButton','v17ImportButton','backButton'])
!!}
@endpush
@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
	@endphp
@section('content')
 
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div class="row condition-search">
                <div class="col-md-2" style="min-width:160px">
                    <div class="form-group">
                        <label class="control-label lb-required \5FC5\9808" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
                        <select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
                            @for ($i = $fiscal_year - 3; $i <= $fiscal_year + 3 ; $i++) <option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year'))}}</option>
                                @endfor
                        </select>
                    </div>
                </div>
                <div class="col-sm-6 col-md-4 col-lg-5" style="min-width:250px">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.target_employee_name')}}</label>
                        <div class="input-group-btn input-group div_employee_cd">
                            <span class="num-length">
                                <input type="hidden" class="employee_cd_hidden employee_cd" id="employee_cd" value="" />
                                <input type="text" fiscal_year_mulitireview="{{isset($fiscal_year)?$fiscal_year:''}}" id="employee_nm" class="form-control indexTab employee_nm_mulitireview required" old_employee_nm is_callback tabindex="2" maxlength="101" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4 col-md-3 col-lg-5">
					<div class="form-group">
						<label class="control-label">{{__('messages.1st_rater')}}</label>
						<div class="gflex">
							<div class="input-group-btn input-group">
                                <span class="text-overfollow" data-toggle="tooltip" data-original-title=""
									style="max-width:100%" id="rater_employee_nm_1_string"></span>
							</div>
						</div>
					</div>
				</div>

            </div>
            @php
                $language = Config::get('app.locale');
            @endphp
            <input type="hidden" id="language_jmessages" value="{{$language}}">
            <!-- search -->
            <div class="" id="result" style="padding-top: 0px;">
                @include('Multiview::mi1010.search')
            </div>

        </div>
    </div>
</div>
@stop