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
	$navbars = navbar_group($excepts,[0]);
	//dd($navbars);
@endphp
	<div class="row sdashboard" style="flex-wrap: nowrap !important;">
		<div class="col-md-4 col-border mr-25">
		<span class="title-menu">
			<h5><span>{{ __('messages.master_setting') }}</span></h5>
		</span>
			@if(isset($navbars[1]))
				@foreach($navbars[1] as $key=>$val)
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
		</div>
		<div class="col-md-4 col-border mr-25 mt-25">
		<span class="title-menu">
			<h5><span>{{ __('messages.data_linkage') }}</span></h5>
		</span>
			@if(isset($navbars[2]))
				@foreach($navbars[2] as $key=>$val)
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
		</div>
		<div class="col-md-4 col-border mt-25">
		<span class="title-menu">
			<h5><span>{{ __('messages.system_setting') }}</span></h5>
		</span>
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
		</div>
	</div>
</div>
@stop
