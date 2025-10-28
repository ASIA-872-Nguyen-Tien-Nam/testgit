@extends('slayout')

@section('asset_header')
{!! public_url('template/css/common/master.css') !!}
{!!public_url('template/css/BasicSetting/m0080/m0080.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/BasicSetting/m0080/m0080.index.js')!!}
@stop
@push('asset_button')
	{!! Helper::buttonRender(['addNewButton','saveButton' , 'deleteButton' , 'backButton'])!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid" >
	<input type="hidden" class="anti_tab" name="">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					@include('BasicSetting::m0080.leftcontent')
				</div> <!-- end .inner -->
			</div> <!-- end #leftcontent -->
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('BasicSetting::m0080.rightcontent')
				</div> <!-- end #rightcontent -->
			</div>
		</div>
	</div><!-- end .container-fluid -->
	<table class="hidden" id="table-target">
		<tbody>
			<tr>
				 <td>
                    <span class="num-length">
                        <input type="hidden" class="form-control challenge_level">
                        <input type="text" class="form-control input-sm challenge_level_nm required" maxlength="5">
                    </span>
                </td>
                <td>
                    <span class="num-length">
                        <input type="text" class="form-control input-sm text-left  explanation required" maxlength="50"  >
                    </span>
                </td>
                <td class="text-center">
                    <button class="btn btn-rm btn-sm btn-remove-row">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
			</tr>
		</tbody>
	</table><!-- /.hidden -->
@stop
