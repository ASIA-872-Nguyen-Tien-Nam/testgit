@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/m0140.index.js')!!}
@stop
@push('asset_button')
	{!!
		Helper::buttonRender(['addNewButton','saveButton' , 'deleteButton', 'backButton'])
	!!}
@endpush
@section('content')
<style>
	@media (max-width: 767px) and (min-width: 576px) {
        #table-data {
            min-width: 1000px !important;
        }
	}
	@media (max-width: 575px) {
        #table-data {
            min-width: 1000px !important;
        }
	}
	@media (min-width: 1200px) {
        .number-code {
            min-width: 100px !important;
            width: 100px !important;
        }
    }
</style>
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner" >
					@include('Master::m0140.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('Master::m0140.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div>

@stop
