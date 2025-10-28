@extends('weeklyreport/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!! public_url('template/css/weeklyreport/rm0310/rm0310.index.css') !!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/weeklyreport/rm0310/rm0310.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::dropdownRenderWeeklyReport(['saveButton','deleteButton','backButton'])
!!}
@endpush

@section('content')
<!-- START CONTENT -->
<div class="container-fluid">
	<div class="card" style="min-height: 85vh;padding:28px">
		<div class="row" style="margin-bottom:16px">
			<div class="col-sm-12 col-md-4 col-lg-3 col-xl-2" style="padding-left:0px">
				<div class="form-group">
					<label class="control-label"
						style="white-space: nowrap;">{{ __('rm0100.report_type') }}</label>
					<div style="padding-left: 0px">
						<span class="num-length">
							<select id="report_kinds" tabindex="1" autofocus class="form-control">
							<option value="-1"></option>
								@if(isset($report_kinds[0]))
								@foreach($report_kinds as $res_report)
								<option value="{{$res_report['report_kind']}}">{{$res_report['report_name']}}</option>
								@endforeach
								@endif
							</select>
						</span>
					</div><!-- end .col-md-3 -->
				</div>
			</div>	
			<div class="col-md-4 col-xl-2 col-lg-3"  style="padding-left:0px">
				<div class="form-group">
					<label class="control-label"
					>{{ __('messages.group') }}</label>&nbsp;
					<select id="group_cd" name="group_cd" class="form-control" import_status="false" tabindex="1">
						<option value="-1"></option>
						@foreach($group as $res_data_group)
						<option value="{{ $res_data_group['group_cd'] }}">{{ $res_data_group['group_nm'] }}</option>
						@endforeach
					</select>
				</div>
				<!--/.form-group -->
			</div>
		</div
		<div class="card-body">
			<div class="row" id="result">
				@include('WeeklyReport::rm0310.search')
			</div>

			<div class="row justify-content-md-center" style="margin-top: 30px; position: absolute; bottom:20px; width:100%">
				{!!
				Helper::buttonRenderWeeklyReport(['saveButton'])
				!!}
			</div>
		</div><!-- end .card-body -->
	</div><!-- end .card -->
</div><!-- end .container-fluid -->
@stop