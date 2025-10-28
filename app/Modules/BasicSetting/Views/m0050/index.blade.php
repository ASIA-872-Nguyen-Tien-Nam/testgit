@extends('slayout')

@section('asset_header')
	<!-- START LIBRARY CSS -->
	{!! public_url('template/css/basicsetting/m0050/m0050.index.css') !!}
@stop

@section('asset_footer')
	<!-- START LIBRARY JS -->
	{!! public_url('template/js/common/Sortable.min.js') !!}
	{!! public_url('template/js/common/jquery-sortable.js') !!}
	{!! public_url('template/js/basicsetting/m0050/m0050.index.js') !!}
@stop

@push('asset_button')
{!!
Helper::buttonRender(['saveButton' , 'backButton'])
!!}
@endpush

@section('content')
<style>
	#table_data {
		width: 100%;
	}
	@media (max-width: 575px) {
		#table_data {
			min-width: 400px !important;
		}
	}
</style>
<!-- START CONTENT -->
<div class="container-fluid" >
	<div class="row">
		<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" >
		<div class="card " style="min-height: 82vh;">
			<div class="card-body">
				<div class="row">
					<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6" >
						<div class="table-responsive">
							<table class="table table-bordered table-hover table-striped" style="" id="table_data">
								<thead>
									<th class="text-center" style="width: 15%">{{__('messages.code')}}</th>
									<th class="text-center" style="">{{__('messages.grade_name')}}</th>
									<th class="text-center next-col" style="width: 20px;">
										<button class="btn btn-rm blue btn-sm" id="add_new_row">
											<i class="fa fa-plus"></i>
										</button>
									</th>
									<th class="no-border" style="width: 50px;"></th>
								</thead>
								<tbody id='main'>
									@if ( !empty($rows) )
										@foreach ($rows as $item)
										<tr class="tr">
											<td>
											<span class="num-length">
												<input type="text" class="form-control input-sm  grade" value="{{ $item['grade']}}" maxlength="3" disabled="">
											</span>
											</td>
											<td>
												<span class="num-length">
													<input type="text" class="form-control input-sm required grade_nm" value="{{ $item['grade_nm'] }}" maxlength="10">
												</span>
											</td>
											<td class="next-col" style="text-align: center;">
												<button class="btn btn-rm red btn-sm btn_remove">
													<i class="fa fa-remove"></i>
												</button>
											</td>
											<td class="row-hover no-border text-center"><i class="fa fa-arrows" aria-hidden="true"></i></td>
										</tr>
										@endforeach
									@else
										<tr class="tr">
											<td>
												<span class="num-length">
													<input type="text" class="form-control input-sm  grade" value="1" maxlength="3" disabled="">
												</span>
											</td>
											<td>

												<span class="num-length">
													<input type="text" class="form-control input-sm required grade_nm" value="" maxlength="10">
												</span>
											</td>

											<td class="next-col" style="text-align: center;">
												<button class="btn btn-rm red btn-sm btn_remove">
													<i class="fa fa-remove"></i>
												</button>
											</td>
											<td class="row-hover no-border text-center"><i class="fa fa-arrows" aria-hidden="true"></i></td>
										</tr>
									@endif

								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		</div>
	</div>
	
</div><!-- end .container-fluid -->
@stop

@section('asset_common')
<table class="hidden" id="table_row_add">
	<tbody class="">
		<tr>
            <td>
				<span class="num-length">
					<input type="text" class="form-control input-sm  grade" value="" maxlength="3" disabled="">
				</span>
			</td>
			<td>
				<span class="num-length">
					<input type="text" class="form-control input-sm required grade_nm" value="" maxlength="10">
				</span>
			</td>
			<td class="next-col" style="text-align: center;">
				<button class="btn btn-rm red btn-sm btn_remove">
					<i class="fa fa-remove"></i>
				</button>
			</td>
			<td class="row-hover no-border text-center"><i class="fa fa-arrows" aria-hidden="true"></i></td>
		</tr>
	</tbody>
</table><!-- /.hidden -->
@stop