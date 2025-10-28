@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!!public_url('template/css/oneonone/om0010/om0010.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
	{!!public_url('template/js/oneonone/om0010/om0010.index.js')!!}
@stop
@push('asset_button')
{!!
Helper::dropdownRender1on1(['saveButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">

		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-md-10 col-lg-5 col-xl-5"  style="position:relative;">
						<input type="hidden" id="text_no_file" value="{{__('messages.no_file_chosen')}}"/>
						<div class="form-group" style="margin-bottom: 5px;position:absolute;z-index:-1 ">
							<input type="file" class="form-control" id="upload_file"  placeholder="" maxlength="100"
							tabindex="1" accept=".mp4,.avi,.wmv,.mov,.pdf,.ppt,.pptx,.xls,.xlsx,.doc,.docx">
						</div>
						<div class="form-group form-control lh-input-custom " style="margin-bottom: 5px" tabindex="0">
							<div class="fake_input"><button class="ln-btn-input">{{__('messages.choose_file')}}</button><span class="ln-text-file">{{__('messages.no_file_chosen')}}</span></div>
						</div>

					</div>
					<div class="col-md-2 col-lg-2 col-xl-2">
						<a href="#" id="btn-upload" class="btn btn-horizontal dropdown-item btn-outline-primary" style="max-width: 130px">
							<i class="fa fa-upload"></i>
							<div>{{__('messages.upload')}}</div>
						</a>
					</div>
					<div class="col-md-5 col-lg-5 col-xl-5">
						{{-- Mirac --}}
						@if ($contract_company_attribute == 1)
						<span class="notes">{{__('messages.label_022')}}</span>
						@else
						<span class="notes">{{__('messages.label_023')}}</span>
						@endif
					</div>
					<div class="col-md-5">
						<div id="progressBar" class="hidden" >
						 	<div id="progressBarFull" class="text-center" style="display: flex">0%</div>
						</div>
					</div>
				</div>

			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<div class="card">
			<div class="card-body" id="inner">
				@include('OneOnOne::om0010.refer')
			</div><!-- end .card-body -->
		</div><!-- end .card -->
	</div><!-- end .container-fluid -->
<input type="hidden" class="anti_tab" name="">
<input type="hidden" id="contract_company_attribute" value="{{ $contract_company_attribute }}" />
@stop
