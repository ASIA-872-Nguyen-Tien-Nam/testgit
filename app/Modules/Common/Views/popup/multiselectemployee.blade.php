@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_employee.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_multiselect_employee.index.js')!!}
@stop

@section('content')
<div class="card">
	<div class="card-body search-condition">
		<div class="text-center hid">
			<a href="javascript:void(0)" data-toggle="collapse" data-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample" style="font-size: 25px;">
				<i class="fa fa-caret-up" aria-hidden="true"></i>
				<i class="fa fa-caret-down" aria-hidden="true"></i>
			</a>
		</div>
		<div id="collapseExample" class="collapse show">
			<div class="row  " style="margin-top: 5px;">
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.employee_no')}}</label>
						<span class="num-length">
							<input type="tel" id="employee_cd" class="form-control" maxlength="10"  tabindex="1">
						</span>
					</div>
				</div>
				<div class="col-md-3">
					<div class="form-group">
						<label class="control-label">{{__('messages.name_s')}}</label>
						<span class="num-length">
							<input type="text" id="employee_ab_nm" class="form-control" maxlength="20" placeholder="{{__('messages.label_006')}}"  tabindex="2">
						</span>
					</div>
				</div>
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.office')}}</label>
						<select name="office_cd" id="office_cd" class="form-control"  tabindex="3">
							<option value="-1"></option>
							@if(isset($data_init[0][0]))
								@foreach($data_init[0] as $row)
									<option value="{{$row['office_cd']}}">{{$row['office_nm']}}</option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				{{-- <div class="col-md-2">
					<div class="form-group">
						<label class="control-label">部署</label>
						<select name="organization_cd1" id="organization_cd1" class="form-control organization_cd1"  tabindex="4"  {{($authority_typ == 2)&&($organization_cd1 !=0)?'disabled':''}}>
							<option value="-1"></option>
							@if(isset($data_init[1][0]))
								@foreach($data_init[1] as $row)
									<option value="{{$row['organization_cd']}}" {{isset($organization_cd1)&&($organization_cd1 == $row['organization_cd'])&&($organization_cd1 !=0) ? 'selected' : ''}} >{{$row['organization_nm']}}</option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">課</label>
						<select name="organization_cd2" id="organization_cd2" class="form-control organization_cd2"  tabindex="5"   {{($authority_typ == 2)&&($organization_cd2 !=0)?'disabled':''}}>
							<option value="-1"></option>
							@if(isset($m0020_2))
							@foreach($m0020_2 as $row)
								@if($row['organization_typ'] == 2)
									<option value="{{$row['organization_cd']}}" {{isset($organization_cd2)&&($organization_cd2 == $row['organization_cd']) ? 'selected' : ''}}>
										{{$row['organization_nm']}}
									</option>
								@endif
							@endforeach
							@endif
						</select>
					</div>
				</div> --}}
			</div> <!-- end .row -->
			<div class="row">

				@if(isset($organization_group[0]))
					<div class="col-md-2 col-xs-12 col-lg-2">
						<div class="form-group">
							<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}"
							style="width:150px">
							{{$organization_group[0]['organization_group_nm']}}
							</label>
							<select name="" id="organization_step1" class="form-control organization_cd1" tabindex="4" organization_typ='1'>
								<option value="0"></option>
								@foreach($combo_organization as $row)
								<option value="{{$row['organization_cd_1']}}" >{{$row['organization_nm']}}</option>
								@endforeach
							</select>
						</div>
						<!--/.form-group -->
					</div>
				@endif
				@foreach($organization_group as $dt)
					@if($dt['organization_typ'] >=2)
						<div class="col-md-2 col-xs-12 col-lg-2">
							<div class="form-group">
								<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}"
									style="width:150px">
									{{$dt['organization_group_nm']}}
								</label>
								<select name="" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="5" organization_typ = "{{$dt['organization_typ']}}">
									<option value="0"></option>
								</select>
							</div>
							<!--/.form-group -->
						</div>
					@endif
				@endforeach
			</div><!-- end .row -->
			<div class="row "  style="margin-top: 5px;">
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.job')}}</label>
						<select name="job_cd" id="job_cd" class="form-control"  tabindex="6">
							<option value="-1"></option>
							@if(isset($data_init[2][0]))
								@foreach($data_init[2] as $row)
									<option value="{{$row['job_cd']}}">{{$row['job_nm']}}</option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.position')}}</label>
						<select name="position_cd" id="position_cd" class="form-control"  {{isset($data_init[6][0]['rater_position_cd'])?'disabled':''}}  tabindex="7">
							<option value="-1"></option>
							@if(isset($data_init[3][0]))
								@foreach($data_init[3] as $row)
									<option {{(isset($data_init[6][0]['rater_position_cd'])&& $data_init[6][0]['rater_position_cd']==$row['position_cd'])?'selected':''}} value="{{$row['position_cd']}}">{{$row['position_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-4">
					<div class="form-group">
						<label class="control-label">&nbsp;</label>
						<div class="checkbox">
							<div class="md-checkbox-v2 inline-block">
								<input name="company_out_dt_flg" id="company_out_dt_flg" {{($company_out_dt_flg??0)==1?'checked':''}} type="checkbox" value="1" tabindex="8">
								<label for="company_out_dt_flg">{{__('messages.include_retired_employees')}}</label>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
				<div class="col-md-1">
					<div class="form-group text-right ">
						<label for="">&nbsp;</label>
						<div class="full-width">
							<a href="javascript:;" id="btn-apply" class="btn btn-outline-primary" tabindex="9">
								{{__('messages.apply')}}
							</a>
						</div><!-- end .full-width -->
					</div>
				</div>
				<div class="col-md-1">
					<div class="form-group text-right ">
						<label for="">&nbsp;</label>
						<div class="full-width">
							<a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="9">
								<i class="fa fa-search"></i>
								{{__('messages.search')}}
							</a>
						</div><!-- end .full-width -->
					</div>
				</div>
			</div> <!-- end .row -->
		</div>
	</div> <!-- end .card-body -->

</div> <!-- end .card -->
<input type="hidden" id="rater_position_cd" value="{{ $data_init[6][0]['rater_position_cd']??''}}" />
<input type="hidden" id="mulitiselect_mode" value="{{ $mulitiselect_mode ?? 1}}" />
<input type="hidden" id="fiscal_year" value="{{ $fiscal_year ?? 0}}" />
<input type="hidden" id="class_select" value="{{ $class_select}}" />
<div id="result" class="card">
	@include('Common::popup.search_multiselect_employee')
</div> <!-- end .card -->
@stop
