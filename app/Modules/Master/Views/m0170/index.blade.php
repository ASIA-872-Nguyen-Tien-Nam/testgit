@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->

{!!public_url('template/css/form/m0170.index.css')!!}
@stop
@section('asset_footer')
<script>
	var text_total_points  = '{{__('messages.total_points')}}';
	var text_average_score = '{{__('messages.average_score')}}';
	var text_weight 	   = '{{__('messages.weight')}}';
	var text_coefficient   = '{{__('messages.coefficient')}}';
</script>
{!!public_url('template/js/form/m0170.index.js')!!}
<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
	Helper::buttonRender(['addNewButton','saveButton','deleteButton','copyButton','ItemEvaluationInputButton','ItemEvaluationOutputButton','backButton'])
	!!}
	@endpush
	@section('content')
	<div class="container-fluid" >
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('Master::m0170.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="card calHe inner">
					@include('Master::m0170.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div><!-- end .container-fluid -->
	<input type="hidden" id="mode" value="A"/>
	<input type="hidden" id="flag" value="Y"/>
	<input type="hidden" id="nn_csv" value="{{__('messages.eval_item')}}"/>
@stop