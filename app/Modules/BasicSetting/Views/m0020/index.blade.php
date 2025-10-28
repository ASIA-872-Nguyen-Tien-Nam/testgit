@extends('slayout')

@section('asset_header')
	{!! public_url('template/css/basicsetting/m0020/m0020.index.css') !!}
@stop

@section('asset_footer')
	{!! public_url('template/js/basicsetting/m0020/m0020.index.js') !!}
@stop

@push('asset_button')
    {!! Helper::buttonRender(['changeNameOrg','createNewOrg','CreateDivisionButton','saveButton','deleteButton','backButton'],[],$button)!!}
@endpush

@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="row">
			<div id="leftcontent" class="col-sm-12 col-md-4 col-lg-3 col-ltx-2">
				<div class="inner">
					<input type="hidden" class="anti_comon" name="">
					<div class="row">
					    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
					        <div class="form-group" style="margin-bottom: 0;">
					            <span class="num-length">
					                <div class="input-group-btn">
					                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key ?? ''}}" maxlength="50">
					                    <div class="input-group-append-btn">
					                        <button id="btn-search-key" class="btn btn-transparent" type="button"><i class="fa fa-search"></i></button>
					                    </div>
					                </div>
					            </span>
					        </div>
					    </div>
					</div>
					<div id="leftul" class="row">@include('BasicSetting::m0020.leftcontent')</div>
				</div>
				<!-- end .card -->
			</div>
			<div id="rightcontent" class="col-sm-12 col-md-8 col-lg-9 col-ltx-10">
				<div class="inner">
					@include('BasicSetting::m0020.rightcontent')
				</div><!-- end .inner -->
			</div>
		</div><!-- end .row -->
	</div><!-- end .container-fluid -->
@stop