@extends('layout')

@section('asset_header')
{!! public_url('template/css/form/m0160.index.css') !!}
@stop

@section('asset_footer')
<script>
	var text_total_points  = '{{__('messages.total_points')}}';
	var text_average_score = '{{__('messages.average_score')}}';
	var text_weight 	   = '{{__('messages.weight')}}';
	var text_coefficient   = '{{__('messages.coefficient')}}';
</script>
{!! public_url('template/js/form/m0160.index.js') !!}
@stop
@push('asset_button')
{!!
	Helper::buttonRender(['addNewButton','saveButton','deleteButton','copyButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('Master::m0160.leftcontent')
				</div>
			</div>
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="card calHe inner" >
					<div class="card-body p-0">
						<div class="row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" id="right-respon">
								@include('Master::m0160.rightcontent')
							</div>
						</div>
					</div><!-- end .card-body -->
				</div><!-- end .card -->
			</div>

		</div>

	</div><!-- end .container-fluid -->
@stop