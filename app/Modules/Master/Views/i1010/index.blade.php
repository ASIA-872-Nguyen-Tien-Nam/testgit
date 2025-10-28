@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/i1010.index.js')!!}
@stop
@push('asset_button')
@if ($chk == 1)
{!!
	Helper::buttonRender(['backButton'])
!!}
@else
    {!!
        Helper::buttonRender(['saveButton','backButton'])
    !!}
@endif
@endpush
<style>
	@media (max-width: 575px) {
		#table-data-1 {
			min-width: 500px;
		}
	}
	@media (min-width: 576px) and (max-width: 767px) {
		#table-data-1 {
			min-width: 500px;
		}
	}
	@media (min-width: 768px) and (max-width: 991px) {
		#table-data-1 {
			min-width: unset !important;
		}
	}
	@media (min-width: 992px) and (max-width: 1199px) {
	}
	.nav-menubar-pc .btn-horizontal{
		padding: .375rem .75rem !important;
	}
	.nav-menubar-mobile .btn-horizontal{
		padding: 4.25px 5px !important;
	}
</style>
@section('content')
<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-md-8">
						<div class="col-sm-4 col-12 col-md-3 col-lg-3 col-xl-2">
							<div class="form-group">
								<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
								<select name="" id="fiscal_year" class="form-control required" tabindex="1">
									@for ($i = $cur_year-5; $i <= $cur_year+1;$i++)
										<option value="{{$i}}" {{$i == $cur_year?'selected':''}}>{{$i}}</option>
									@endfor
								</select>
							</div><!--/.form-group -->
						</div>
					</div><!-- end .col-md-10 -->
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<div class="card">
			<div class="card-body" id="inner">
				@include('Master::i1010.refer')
				{{-- @include('Master::m0140.rightcontent') --}}
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		<input type="hidden" class="anti_tab" name="">
	</div><!-- end .container-fluid -->

<div id = "chk_btn" class= "hidden">
	{!!
        Helper::buttonRender(['saveButton','backButton'])
    !!}
</div>
@stop