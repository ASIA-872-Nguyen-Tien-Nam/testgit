@extends('oneonone/layout')

@section('asset_header')
{!! public_url('template/css/oneonone/om0200/om0200.index.css') !!}
@stop

@section('asset_footer')
<script>
	var pawn = '{{ __('messages.pawn') }}';
	var answer = '{{ __('messages.answer') }}';
	var free_entry_field = '{{ __('messages.free_entry_field') }}';
	var member_comment = "{!! __('messages.member_comment') !!}";
	var coach_comment = "{!!__('messages.coach_comment')!!}";
	var label_013 = '{{ __('messages.label_013') }}';
	var label_012 = '{{ __('messages.label_012') }}';
</script>
{!! public_url('template/js/oneonone/om0200/om0200.index.js') !!}
@stop
@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','copyButton','addNewButton','deleteButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('OneOnOne::om0200.leftcontent')
				</div>
			</div>
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" id="right-respon">
						@include('OneOnOne::om0200.rightcontent')
					</div>
				</div>

			</div>

		</div>
	</div><!-- end .container-fluid -->
@stop