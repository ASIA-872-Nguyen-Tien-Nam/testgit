@extends('layout')
@section('asset_header')
		<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/m0150.index.css')!!}
@stop
@section('asset_footer')
{!!public_url('template/js/form/m0150.index.js')!!}
		<!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
Helper::buttonRender(['addNewButton','saveButton' , 'deleteButton' , 'copyButton', 'backButton'])
!!}
@endpush
@section('content')
<style>
	.btn-number {
		width: 100px;
		max-width: 100px;
	}
</style>
		<!-- START CONTENT -->
<div class="container-fluid">
	<div class="row">

		<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
			<div class="card inner">
				<div class="card-body p-0">
					<div class="row">
						<div class="col-xs-12 col-md-12 col-lg-12 calHe2">
							<div class="form-group">
		                        <span class="num-length">
		                           <div class="input-group-btn">
									   <input type="text"  class="form-control" placeholder="" maxlength="20" id="keyword">
									   <div class="input-group-append-btn">
										   <button class="btn btn-transparent" type="button"><i class="fa fa-search"></i></button>
									   </div>
								   </div>
		                        </span>
							</div>
						</div>
					</div>
					<div class="row" id="left-respon">
						@include('Master::m0150.leftcontent')
					</div><!-- end #response -->
				</div>
				<!-- end .card-body -->
			</div>
			<!-- end .card -->
		</div>
		<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
			<div class="card calHe inner" >
				<div class="card-body p-0">
					<div class="row">
						<div class="col-md-3 col-lg-2 col-xl-1 col-xs-12">
							<div class="form-group">
								<label class="control-label ">{{__('messages.code')}}</label>
								<span class="num-length">
									<input type="text" id="group_cd"  class="form-control " maxlength="3"  tabindex="1" value="" disabled="">
								</span>
							</div><!--/.form-group -->
						</div>
						<div class="col-md-5 col-lg-4 col-xl-4 col-xs-12">
							<div class="form-group">
								<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.group_name')}}</label>
								<span class="num-length">
									<input type="text" class="form-control indexTab required" tabindex="2" maxlength="50" value="" id="group_nm"/>
								</span>
							</div><!--/.form-group -->
						</div>
						<div class="col-md-2 col-lg-2 col-xl-2 col-xs-12 btn-number">
							<div class="form-group">
								<label class="control-label">{{__('messages.sort_order')}}</label>
								<span class="num-length">
									<input type="text" class="form-control indexTab only-number" tabindex="3" maxlength="4" value="" id="arrange_order">
								</span>
							</div><!-- end .form-group -->
						</div>
					</div>
					<div class="row">
						<label class="control-label col-xs-12 col-md-12">{{__('messages.attribute_condition')}}</label>
						<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" id="right-respon">
							@include('Master::m0150.rightcontent')
						</div>
					</div>
				</div>
				<!-- end .card-body -->
			</div>
			<!-- end .card -->
		</div>
	</div><!-- end .row -->
</div>
<!-- end .container-fluid -->
@stop
