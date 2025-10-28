@extends('layout')

@push('asset_button')
{!!
	Helper::buttonRender(['saveButton','deleteButton','backButton'])
!!}
@endpush

@section('asset_header')
{!!public_url('template/css/form/i1041.index.css')!!}

@stop
@section('asset_footer')
{!!public_url('template/js/form/i1041.index.js')!!}
@stop
@section('content')
<div class="container-fluid" >
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-3 col-lg-3 col-xl-3">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.eval_class') }}</label>
						<select name="" id="category" class="form-control required " tabindex="1">
							<option value="-1"></option>
							@foreach($category_cb as $dt)
								<option value="{{$dt['category']}}" {{$dt['category']==($cache['category']??'')?'selected':''}}>{{$dt['name']}}</option>
							@endforeach
						</select>
					</div>
				</div>
				<div class="col-md-5 col-lg-4 col-xl-3">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.status_item') }}</label>
						<select name="" id="status_cd" class="form-control required status_cd" tabindex="2">
							<option value="-1"></option>
								@foreach($status_cd_cb as $dt)
									<option value="{{$dt['status_cd']}}" {{$dt['status_cd']==($cache['status_cd']??'')?'selected':''}}>{{$dt['status_nm']}}</option>
								@endforeach
						</select>
					</div>
				</div>
			</div> <!-- end .row -->
		</div> <!-- end .card-body -->
		<input type="hidden" class="anti_tab" name="">
	</div> <!-- end .card -->
	<div class="card">
		<div class="card-body" id="body">
			@include('Master::i1041.refer')
		</div>
	</div>
</div> <!-- end .container-fluid -->
@stop