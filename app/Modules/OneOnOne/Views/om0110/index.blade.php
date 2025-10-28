@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!! public_url('template/css/oneonone/om0110/om0110.index.css') !!}
@stop

@section('asset_footer')
<script>
	var question_master = '{{ __('messages.question_master') }}';
</script>
<!-- START LIBRARY JS -->
{!!public_url('template/js/oneonone/om0110/om0110.index.js')!!}
@stop
@push('asset_button')
	{!!
		Helper::dropdownRender1on1(['saveButton','v17ImportButton','exportButton','addNewButton', 'deleteButton','backButton'])
	!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner" >
					@include('OneOnOne::om0110.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('OneOnOne::om0110.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div>

@stop
