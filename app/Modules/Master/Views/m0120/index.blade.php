@extends('layout')

@section('asset_header')
{!! public_url('template/css/common/master.css') !!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/m0120.index.js')!!}
@stop
@push('asset_button')
	{!! Helper::buttonRender(['addNewButton','saveButton' , 'deleteButton' , 'backButton'])!!}
@endpush
@section('content')
<style>
	@media (max-width: 767px) and (min-width: 576px) {
        #table-data {
            min-width: 1200px !important;
        }
	}
	@media (max-width: 575px) {
        #table-data {
            min-width: 1200px;
        }
    }
</style>
	<!-- START CONTENT -->
	<div class="container-fluid" >
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('Master::m0120.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('Master::m0120.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div><!-- end .container-fluid -->
	<table class="hidden" id="table-target">
		<tbody>
			<tr>
				<td>
					<span class="num-length">
						<input type="hidden" class="mode" value="A">
						<input type="hidden" class="point_cd" value="0">
						<input type="text" class="form-control point_nm input-sm" maxlength="20" value="" tabindex="9999"/>
					</span>
				</td>
				<td>
					<span class="num-length">
						<input type="text" class="form-control point only-number hyouka-score" negative="true" maxlength="3" negative="true" value="" tabindex="9999">
					</span>
				</td>
				<td>
					<span class="num-length">
						<input type="text" class="form-control point_criteria input-sm required" maxlength="50" value="" tabindex="9999"/>
					</span>
				</td>
				<td class="text-center">
					<button class="btn btn-rm btn-sm btn-remove-row" tabindex="9999">
						<i class="fa fa-remove"></i>
					</button>
				</td>
			</tr>
		</tbody>
	</table><!-- /.hidden -->
@stop
