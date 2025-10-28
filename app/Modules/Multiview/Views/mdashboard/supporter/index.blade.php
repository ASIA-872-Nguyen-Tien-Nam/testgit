@extends('mlayout')
 
@push('header')
{!!public_url('template/css/mulitiview/mdashboard/mdashboard.index.css')!!}
@endpush

@section('asset_footer')
{!! public_url('template/js/mulitiview/mdashboard/supporter.index.js') !!}
@stop

@push('asset_button')
@if($multireview_authority_typ >= 3 || ($multireview_authority_typ == 2 && $user_is_rater_1 == 1) )
{!!
Helper::dropdownRenderMulitireview(['backButton']);
!!}
@endif
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
        <div class="card-body ">
            <div class="row">
                <div class="col-md-3">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                        <select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
                            @if(isset($years) && !empty($years))
                            @foreach($years as $key=>$val) 
                                <option value="{{$val}}" {{$val==$fiscal_year?'selected':''}}>{{$val}}{{year_english(__('messages.fiscal_year'))}}</option>
                            @endforeach
                            @endif
                        </select>
                    </div>
                </div>
            </div>
            <div id="result"> 
                @include('Multiview::mdashboard.supporter.search')
            </div>
        </div>
    </div>
    <input type="hidden" class="anti_tab">
</div>
@stop