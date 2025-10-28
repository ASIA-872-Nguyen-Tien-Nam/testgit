@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/q2030.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/q2030.index.js')!!}
@stop
@push('asset_button')
{!!
Helper::buttonRender(['outputButton' , 'backButton'])
!!}
@endpush

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card">
		<div class="card-body box-input-search">
			<div class="row">
				<div class="col-md-2" style="min-width: 120px">
					<div class="form-group">

						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
						<select class="form-control required" id="fiscal_year" tabindex="1">
							@foreach($f0010 as $item)
								<option {{$fiscal==$item['fiscal_year']?'selected':''}} value="{{$item['fiscal_year']}}">
									{{$item['fiscal_year']}}
								</option>
							@endforeach
						</select>
					</div>
				</div>
				<div class="col-md-4 col-lg-3">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.treatment_use')}}</label>&nbsp;
						<select class="form-control required" id="treatment_applications_no" tabindex="2">
							@if(isset($f0011['treatment_applications_no']))
								@foreach($f0011 as $item)
									<option value='{{$item['treatment_applications_no']}}'>
										{{$item['treatment_applications_nm']}}
									</option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-4 col-lg-3">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.eval_step')}}</label>&nbsp;
						<select class="form-control required" id="evaluation_step" tabindex="3">
							<option value="1">{{__('messages.1st_rater')}}</option>
							<option value="2">{{__('messages.2nd_rater')}}</option>
							<option value="3">{{__('messages.3rd_rater')}}</option>
							<option value="4">{{__('messages.4th_rater')}}</option>
							<option value="5" selected>{{__('messages.final_eval')}}</option>
						</select>
					</div>
				</div>
				<div class="col-md-3 col-lg-3 col-xl-2">
					<div class="form-group">
						<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.display_unit')}}</label>&nbsp;
						<select class="form-control required" id="select_target_1" tabindex="4">
							<option value="1">{{__('messages.group')}}</option>
							<option value="2">{{$M0022[0]['organization_group_nm'] ?? __('messages.org1') }}</option>
							<option value="3">{{__('messages.job')}}</option>
							<option value="4">{{__('messages.grade')}}</option>
							<option value="5">{{__('messages.rater')}}</option>
						</select>
					</div>
				</div>
				<div class="col-md-3 col-lg-2 col-xl-2">
					<div class="form-group">
					<label class="control-label lb-check-q2030 "  style="">
						<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$M0022[0]['organization_group_nm']?? __('messages.org1') }}" >{{$M0022[0]['organization_group_nm']?? __('messages.org1') }}</div>
					</label>
						<select class="form-control" id="organization_cd" tabindex="5">
							<option value="-1"></option>
							@foreach($m0020 as $item)
								<option value="{{$item['organization_cd']}}">
									{{$item['organization_nm']}}
								</option>
							@endforeach
						</select>
					</div>
				</div>
			</div>{{--end class row--}}
			<div class="row">
				<div class="col-md-12">
					<div class="form-group text-right">
						<div class="full-width">
							<a href="javascript:;" class="btn btn-outline-primary" tabindex="14" id="btn-search">
								<i class="fa fa-search"></i>
								{{__('messages.search')}}
							</a>
						</div><!-- end .full-width -->
					</div>
				</div>
			</div><!-- end .row -->
		</div><!-- end .card-body -->
	</div><!-- end .card -->

	<div class="card">
		<div class="card-body">
			<div class="row" id="result1">
				<div class="d-flex flex-lg-row flex-md-column">
					<div class="flex-start p-2 md-overflow">
						<div class="">
							<table class="table table-bordered table-hover " >
								<thead>
									<th class="text-center" style="width: 250px;">{{__('messages.rank')}}</th>
									@foreach($m0130 as $item)
										<th class="text-center" style="width: 150px;">{{$item['rank_nm']}}</th>
									@endforeach
									<th class="text-center" style="width: 150px;">{{__('messages.number_of_persons')}}</th>
								</thead>
								<tbody>
									<tr>
										<td colspan="17"  class="text-center">
											{{app('messages')->getText(21)->message}}
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div><!-- end .d-flex -->
			</div><!-- end .row -->
		</div><!-- end .card-body -->
		<input type="hidden" class='anti_tab' name="">
		<div class="card-body" id="result2">
		</div>
	</div><!-- end .card -->
</div>
@stop
