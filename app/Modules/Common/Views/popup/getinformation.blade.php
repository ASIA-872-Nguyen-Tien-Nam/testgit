@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_getinformation.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_getinformation.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::buttonRender(['backButton'])
!!}
@endpush

@section('content')
<div class="card">
	<div class="card-body">
		<div>
			<div class="row">
				<input type="hidden" class="anti_tab" name="">
				<div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{ __('messages.noti_date') }}</label>
						<div class="input-group-btn input-group" style="width: 160px">
							<input type="text" class="form-control input-sm date right-radius infomation_date" placeholder="yyyy/mm/dd" value="{{$row['infomation_date']??''}}" disabled="">
							<div class="input-group-append-btn">
								<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" disabled=""><i class="fa fa-calendar"></i></button>
							</div>
						</div>
					</div>
				</div>
				
			</div> <!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label">{{ __('messages.title') }}</label>
						<input type="text" class="form-control infomation_title"  value="{{$row['infomation_title']??''}}" disabled="">	
					</div>
				</div>
			</div> <!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label">{{ __('messages.text') }}</label>	
						<textarea class="form-control infomation_message"  maxlength="1000" rows="5" cols="20" value="{{$row['infomation_message']??''}}" disabled>{{($row['infomation_message'])??''}}</textarea>
					</div>
				</div>
			</div> <!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group">
						<label class="control-label">{{ __('messages.target_sheet') }}</label>	
						<div class="col-md-12">
							<div class="table-responsive">
								<table class="table table-bordered table-hover table-striped">
									<thead>
										<tr>
											<th width="50%">{{ __('messages.rated_name') }}</th>
											<th width="90px">{{ __('messages.eval_year') }}</th>
											<th >{{ __('messages.sheet') }}</th>
										</tr>
									</thead>
									<tbody>
										@if((isset($row['target_employee_cd'])))
										<tr class="tr_target_employee">
											<td class="text-left" style="word-break: break-all;">
												{{ $row['target_employee_nm'] ??''}}
											</td>
											<td class="text-center">
												{{ $row['fiscal_year']??'' }}
											</td>
											<td class="text-left" style="word-break: break-all;">
												<a href="#" class="sheet_cd" fiscal_year="{{$row['fiscal_year']??''}}" employee_cd="{{$row['target_employee_cd']??''}}" sheet_cd="{{$row['sheet_cd']??''}}" screen_refer="{{$row['screen_refer']??''}}">{{ $row['sheet_nm']??''}}</a>
											</td>
										</tr>
										@else
										<tr class="tr-nodata">
											<td colspan="3" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
										</tr>
										@endif
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div> <!-- end .row -->
		</div>
	</div> <!-- end .card-body -->

</div> <!-- end .card -->
@stop
