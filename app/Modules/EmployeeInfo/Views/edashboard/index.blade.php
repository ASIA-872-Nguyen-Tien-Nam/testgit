@extends('slayout')

@push('header')
{!!public_url('template/css/form/dashboard.css')!!}
@endpush

@section('asset_footer')

@stop

@section('content')
<div class="container-fluid">
@php
	$auth = session_data();
	$excepts = $auth->excepts;
	$navbars = navbar_group($excepts,[5]);
	//dd($navbars);
@endphp
	<div class="row">
		<div class="col-md-4">
			@if(isset($navbars[1]))
				@foreach($navbars[1] as $key=>$val)
					@if($val->authority > 0)
					<div class="row mt-3">
						<div class="col-md-12">
							<a href="{{url($val->function_id)}}" class="btn btn-basic-setting-menu btn-block">
								{{$val->function_nm}}
							</a>
						</div>
					</div>
					@endif
				@endforeach
			@endif
			{{-- <div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/es0020')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm8')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/es0030')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm9')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0100')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm5')}}
					</a>
				</div>
			</div> --}}
		</div>
		<div class="col-md-4">
			@if(isset($navbars[2]))
				@foreach($navbars[2] as $key=>$val)
					@if($val->authority > 0)
					<div class="row mt-3">
						<div class="col-md-12">
							<a  href="{{  url($val->function_id)}}" class="btn btn-basic-setting-menu btn-block">
								{{$val->function_nm}}
							</a>
						</div>
					</div>
					@endif
				@endforeach
			@endif
			{{--<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0010')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm1')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0030')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm3')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0020')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm2')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/eo0100')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm4')}}
					</a>
				</div>
			</div>--}}
		</div> 
		<div class="col-md-4">
			@if(isset($navbars[3]))
				@foreach($navbars[3] as $key=>$val)
					@if($val->authority > 0)
					<div class="row mt-3">
						<div class="col-md-12">
							<a href="{{url($val->function_id)}}" class="btn btn-basic-setting-menu btn-block">
								{{$val->function_nm}}
							</a>
						</div>
					</div>
					@endif
				@endforeach
			@endif
			{{--<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0200')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm6')}}
					</a>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col-md-12">
					<a href="{{url('employeeinfo/em0201')}}" class="btn btn-basic-setting-menu btn-block">
					{{__('messages.function_nm7')}}
					</a>
				</div>
			</div>--}}
		</div>

	</div>
</div>
@stop