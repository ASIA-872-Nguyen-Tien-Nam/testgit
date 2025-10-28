@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!!public_url('template/css/oneonone/oi1010/oi1010.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
	{!!public_url('template/js/oneonone/oi1010/oi1010.index.js')!!}
@stop
@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','deleteButton','backButton'])
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
	<!-- START CONTENT -->
	<div class="container-fluid">

		<div class="card">
			<div class="card-body">

				<div class="row">
					<div class="col-md-3 col-xs-12 col-lg-2" style="min-width: 160px">
						<div class="form-group">
							<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}&nbsp;
							</label>
							<select name="" id="fiscal_year" class="form-control required" tabindex="1">
								@for ($i = $fiscal_year - 3; $i <= $fiscal_year + 3 ; $i++)
									<option value="{{$i}}" {{$i == $fiscal_year ? 'selected' : ''}}>{{$i}}{{year_english(__('messages.fiscal_year'))}}</option>
								@endfor
							</select>
						</div>
					</div>

					<div class="col-md-4 col-xs-12 col-lg-3">
						<div class="form-group">
							<div class=" lb-required" lb-required="{{ __('messages.required') }}" data-container="body" data-toggle="tooltip" data-original-title="" style="margin-bottom: .5rem;">{{__('messages.group_name1')}}&nbsp;</div>
							<div class="multi-select-full">
								<select id="oneonone_group" tabindex="2" class="form-control required multiselect oneonone_group" multiple="multiple">
									@if (isset($oneonone_group[0])&&!empty($oneonone_group[0]))
										@foreach ($oneonone_group as $item)
											<option value="{{$item['oneonone_group_cd']}}" times={{$item['times']}}>{{$item['oneonone_group_nm']}}</option>
										@endforeach
									@endif

								</select>
							</div>
						</div>
					</div>
				</div>
				<div id="refer_data">
					@include('OneOnOne::oi1010.refer')
				</div>

			</div><!-- end .card-body -->
		</div><!-- end .card -->

	</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
@stop
