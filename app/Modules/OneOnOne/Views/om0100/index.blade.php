@extends('oneonone/layout')
@section('asset_header')
{!! public_url('template/css/oneonone/om0100/om0100.index.css') !!}
@stop

@section('asset_footer')
<script>
        var string = "{!! __('messages.expectations_from_coaches_to_member') !!}";
    </script>
{!! public_url('template/js/oneonone/om0100/om0100.index.js') !!}
@stop
@push('asset_button')
{!!
	Helper::dropdownRender1on1(['saveButton','deleteButton','backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<div class="card" >
			<div class="card-body">
		<div class="row">
				<div class="col-md-12">
					<div class="row" style="justify-content: space-between">
						<div class="col-xl-3 col-lg-4 col-md-5 col-8">
							<div class="">
								<label for="" class="lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
								<div style="display: flex;">
									<select id="fiscal_year" class="form-control required" tabindex="1">
										@for ($i = $today - 3; $i <= $today + 3 ; $i++)
											<option value="{{$i}}" {{$i == $today ? 'selected' : ''}}>{{$i}} {{\Session::get('website_language', config('app.locale')) == 'en'?'':__('messages.fiscal_year') }}</option>
										@endfor
									</select>
									<div class="input-group-btn input-group" style="margin-left: 10px;">
										@if (($data['count_data'] ?? 0) == 1)
											<div class="" id="unregistered" style="color: blue;margin-top: 7px;">{{ __('messages.unregistered') }}</div>
										@endif
									</div>
								</div>
							</div><!-- end .p-title -->
						</div>
						<div class="col-md-2 " style="max-width: 132px">
							<div class="form-group">
								<label for="" class="">&nbsp;</label>
								<span class="num-length">
										<button class="btn  button-1on1 show-all" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-eye"> {{ __('messages.redisplay') }}</i></button>
								</span>
							</div><!--/.form-group -->
						</div>
					</div>
					<div class="row ">
						<div class="col-md-6 col-lg-6 col-xl-4 wrapper {{(isset($result['target1_use_typ']) && $result['target1_use_typ'] == 1)|| ( isset($data['count_data']) && $data['count_data'] == 0 )?'':'hidden'}}">
							<div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
								<table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
									<thead>
									<tr>
										<th class="w-120px text-left">
											<div class="d-flex justify-content-between">
												<span class="ics-textbox" style="width: 88%;">
													<span class="num-length">
														<input type="text" style="min-width:100px"
															class="form-control form-control-sm"
															value={{$result['target1_nm'] ?? 'WILL'}}
															id="target1_name" maxlength="50"
															readonly="" tabindex="-1" />
													</span>
												</span>
												<div class="ics-group">
													<a href="javascript:;" class="ics ics-edit" tabindex="-1">
														<span class="ics-inner"><i class="fa fa-pencil"></i></span>
													</a>
													<input type="hidden" value={{$result['target1_use_typ'] ?? '1'}} id="target1_use_typ">
													<a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
														<span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
													</a>
												</div><!-- end .ics-group -->
											</div>
										</th>
									</tr>
									</thead>
									<tbody>
										<tr class="tr_employee">
											<td class="w-120px">
												<textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="col-md-6 col-lg-6 col-xl-4 wrapper {{(isset($result['target2_use_typ']) && $result['target2_use_typ'] == 1) || ( isset($data['count_data']) && $data['count_data'] == 0 )?'':'hidden'}}">
							<div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
								<table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
									<thead>
										<tr>
											<th class="w-120px text-left">
												<div class="d-flex justify-content-between">
													<span class="ics-textbox" style="width: 88%;">
														<span class="num-length">
															<input type="text" style="min-width:100px"
																class="form-control form-control-sm"
																value={{$result['target2_nm'] ?? 'CAN'}}
																id="target2_name" maxlength="50"
																readonly="" tabindex="-1" />
														</span>
													</span>
													<div class="ics-group">
														<a href="javascript:;" class="ics ics-edit" tabindex="-1">
															<span class="ics-inner"><i class="fa fa-pencil"></i></span>
														</a>
														<input type="hidden" value={{$result['target2_use_typ'] ?? '1'}} id="target2_use_typ">
														<a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
															<span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
														</a>
													</div><!-- end .ics-group -->
												</div>
											</th>
										</tr>
									</thead>
									<tbody>
										<tr class="tr_employee">
											<td class="w-120px">
												<textarea class="form-control"  readonly cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="col-md-6 col-lg-6 col-xl-4 wrapper {{(isset($result['target3_use_typ']) && $result['target3_use_typ'] == 1) || ( isset($data['count_data']) && $data['count_data'] == 0 )?'':'hidden'}}">
							<div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
								<table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
									<thead>
										<tr>
											<th class="w-120px text-left">
												<div class="d-flex justify-content-between">
													<span class="ics-textbox" style="width: 88%;">
														<span class="num-length">
															<input type="text" style="min-width:100px"
																class="form-control form-control-sm"
																value={{$result['target3_nm'] ?? 'MUST'}}
																id="target3_name" maxlength="50"
																readonly="" tabindex="-1" />
														</span>
													</span>
													<div class="ics-group">
														<a href="javascript:;" class="ics ics-edit" tabindex="-1">
															<span class="ics-inner"><i class="fa fa-pencil"></i></span>
														</a>
														<input type="hidden" value={{$result['target3_use_typ'] ?? '1'}} id="target3_use_typ">
														<a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
															<span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
														</a>
													</div><!-- end .ics-group -->
												</div>
											</th>
										</tr>
									</thead>
									<tbody>
										<tr class="tr_employee">
											<td class="w-120px">
												<textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="table-responsive wmd-view table-fixed-header sticky-headers sticky-ltr-cells mt-10 wrapper {{(isset($result['comment_use_typ'])  && $result['comment_use_typ'] == 1) || ( isset($data['count_data']) && $data['count_data'] == 0 ) ?'':'hidden'}}">
						<table class="table table-bordered table-hover table-ics marginbottom15 " id="myTable">
							<thead>
								<tr>
									<th class="w-120px text-left">
										<div class="d-flex justify-content-between">
											<span class="ics-textbox" style="width: 88%">
												<input class="display_typ" type="hidden" id="generic_comment_display_typ_1" value="1"/>
												<span class="num-length">
													<input type="text" style="min-width:115px"
														class="form-control form-control-sm"
														value="{{$result['comment_nm'] ?? __('messages.expectations_from_coaches_to_member') }}"
														id="comment_name" maxlength="50"
														readonly="" tabindex="-1" />
												</span>
											</span>
											<div class="ics-group">
												<a href="javascript:;" class="ics ics-edit" tabindex="-1">
													<span class="ics-inner"><i class="fa fa-pencil"></i></span>
												</a>
												<input type="hidden" value={{$result['comment_use_typ'] ?? '1'}} id="comment_name_typ">
												<a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
													<span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
												</a>
											</div><!-- end .ics-group -->
										</div>
									</th>
								</tr>
							</thead>
							<tbody>
								<tr class="tr_employee">
									<td class="w-120px">
										<textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="11" disabled></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="row justify-content-md-center">
						{!! Helper::buttonRender1on1(['saveButton']) !!}
					</div>
				</div>
			</div>
		</div>
		</div>
		<input type="hidden" class="anti_tab">
		<input type="hidden" id="count_data" value={{$data['count_data'] ?? 0}}>
	</div><!-- end .container-fluid -->
@stop