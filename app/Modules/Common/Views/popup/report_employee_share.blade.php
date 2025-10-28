@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/report_employee_share.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/sharing_employee_popup.index.js')!!}
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
			<div class="row" style="margin-top: 5px;">
				<div class="col-md-3">
					<div class="form-group">
						<label class="control-label">{{__('messages.employee_no')}}</label>
						<span class="num-length">
							<input type="tel" id="employee_cd_key" class="form-control" maxlength="10" autofocus  tabindex="1">
						</span>
					</div>
				</div>
				<div class="col-md-3">
					<div class="form-group">
						<label class="control-label">{{__('messages.name_s')}}</label>
						<span class="num-length">
							<input type="text" id="employee_nm_key" class="form-control" maxlength="50" placeholder="{{__('messages.label_006')}}"  tabindex="2">
						</span>
					</div>
				</div>
				<div class="col-md-3">
					<div class="form-group">
						<label class="control-label">{{__('ri2010.employee_classification')}}</label>
						<select name="employee_typ" id="employee_typ" class="form-control" tabindex="2">
							<option value="-1"></option>
							@if(isset($M0060) && !empty($M0060))
								@foreach($M0060 as $row)
									<option value="{{$row['employee_typ']}}">{{$row['employee_typ_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
			</div> <!-- end .row -->
			<div class="row">
				@if(isset($organization_group[0]))
					<div class="col-md-2 col-xs-12 col-lg-2">
						<div class="form-group">
							<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}"
							style="width:120px">
							{{$organization_group[0]['organization_group_nm']}}
							</label>
							<select system="5" id="organization_step1" class="form-control organization_cd1" tabindex="3" organization_typ='1'>
								<option value="-1"></option>
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
								<select system="5" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="4" organization_typ = "{{$dt['organization_typ']}}">
									<option value="-1"></option>
								</select>
							</div>
							<!--/.form-group -->
						</div>
					@endif
				@endforeach
			</div><!-- end .row -->
			<div class="row" style="margin-top: 5px;">
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.job')}}</label>
						<select name="job_cd" id="job_cd" class="form-control"  tabindex="5">
							<option value="-1"></option>
							@if(isset($M0030) && !empty($M0030))
								@foreach($M0030 as $row)
									<option value="{{$row['job_cd']}}">{{$row['job_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.position')}}</label>
						<select name="position_cd" id="position_cd" class="form-control" tabindex="6">
							<option value="-1"></option>
							@if(isset($M0040) && !empty($M0040))
								@foreach($M0040 as $row)
									<option value="{{$row['position_cd']}}">{{$row['position_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				
				
				@if(!isset($is_viewer))
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.group')}}</label>
						<select name="group_cd" id="group_cd" class="form-control" tabindex="8">
							<option value="-1"></option>
							@if(isset($M4600) && !empty($M4600))
								@foreach($M4600 as $row)
									<option value="{{$row['group_cd']}}">{{$row['group_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				<div class="col-md-2">
					<div class="form-group">
						<label class="control-label">{{__('messages.my_group')}}</label>
						<select name="mygroup_cd" id="mygroup_cd" class="form-control" tabindex="9">
							<option value="-1"></option>
							@if(isset($F4010) && !empty($F4010))
								@foreach($F4010 as $row)
									<option value="{{$row['mygroup_cd']}}">{{$row['mygroup_nm']}} </option>
								@endforeach
							@endif
						</select>
					</div>
				</div>
				@else
				<div class="col-md-2">
					&nbsp
				</div>
				<div class="col-md-2">
					&nbsp
				</div>
				@endif
				<div class="col-md-4 text-right">
					<div class="form-group">
						<label for="">&nbsp;</label>
						<div class="full-width">
							<a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="10">
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

<input type="hidden" id="popup_fiscal_year" value="{{ $fiscal_year ?? 0 }}">
<input type="hidden" id="popup_employee_cd" value="{{ $employee_cd ?? 0 }}">
<input type="hidden" id="popup_report_kind" value="{{ $report_kind ?? 0 }}">
<input type="hidden" id="popup_report_no" value="{{ $report_no ?? 0 }}">
<input type="hidden" id="login_employee_cd" value="{{ $login_employee_cd ?? '' }}">
@if(isset($group_cd_screen)) 
<input type="hidden" id="group_cd_screen" value="{{ $group_cd_screen ?? -1 }}">
@endif
<div class="card" id="result">
	@include('Common::popup.search_report_employee_share')
</div>
{{-- Apply employess --}}
@if(isset($is_viewer))
@if($is_viewer == true)
<div id="is_viewer_popup" value="1" hidden></div>
<div class="card">
    <div class="card-body">
        {{-- 共有 --}}
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <div class="checkbox employee_choice">
                        @if(isset($list))
                            @foreach($list as $key=>$viewer )
                            <div class="md-checkbox-v2 inline-block" style="margin-right:1rem">
                            <input class="employee_cd_apply" name="check_{{$key}}" id="check_{{$key}}" type="checkbox" value="{{$viewer['employee_cd']}}" tabindex="13" checked="">
                            <label for="check_{{$key}}"> {{ $viewer['employee_nm']}}</label></div>
                               
                            @endforeach
                        @endif
						{{-- apply here --}}
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-6 col-xl-6 col-lg-6 row">
                    <div class="form-group">
                        <label class="control-label">{{ __('ri1021.reporter') }}</label>
                        <span class="num-length">
                            <input type="text" id="popup_employee_nm" value="{{ $info['employee_nm'] ?? '' }}" disabled
                                class="form-control" maxlength="10" tabindex="1">
                        </span>
                    </div>
                    <div class="form-group" style="margin-left:16px">
                    <label class="control-label">&nbsp</label>
                    <span class="num-length">
                    	<a href="javascript:;" class="btn btn-key-primary" id="btn_apply" tabindex="15">
                            <i class="fa fa-check"></i>
                            {{ __('messages.apply') }}
                        </a>
					</span>
                    </div>   
            </div>
			@if (isset($setting['share_notify_reporter']) && $setting['share_notify_reporter'] == 1)
			<div class="col-12 col-md-4 col-xl-4 col-lg-4">
                <div class="form-group">
                    <div class="checkbox">
                        <div class="md-checkbox-v2 inline-block">
                            <input name="share_kbn" id="share_kbn" type="checkbox" value="1" tabindex="16">
                            <label for="share_kbn">{{__('ri2010.reporter_sharing_not_use')}}</label>
                        </div>
                    </div>
                </div>
            </div>	
			@endif
        </div>
    </div>
</div> 
@endif
@else
<div id="is_viewer_popup" value="0" hidden></div>
<div class="card">
    <div class="card-body">
        {{-- 共有 --}}
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12">
                <div class="form-group">
                    <div class="checkbox employee_choice">
						{{-- apply here --}}
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2 col-xl-2 col-lg-2">
                <div class="form-group">
                    <a href="javascript:;" id="btn_share_employee" class="btn btn-primary full-width btn-primary-layout" tabindex="14">
                        {{__('ri2010.share_action')}}
                    </a>
                </div>
            </div>

            <div class="col-12 col-md-6 col-xl-6 col-lg-6">
                <div class="form-group">
                    <span class="num-length">
                        <input type="text" id="share_explanation" class="form-control" maxlength="200" placeholder="{{ __('ri2010.comment_placeholder') }}"  tabindex="15">
                    </span>
                </div>
            </div>
			@if (isset($setting['share_notify_reporter']) && $setting['share_notify_reporter'] == 1)
			<div class="col-12 col-md-4 col-xl-4 col-lg-4">
                <div class="form-group">
                    <div class="checkbox">
                        <div class="md-checkbox-v2 inline-block">
                            <input name="share_kbn" id="share_kbn" type="checkbox" value="1" tabindex="16">
                            <label for="share_kbn">{{__('ri2010.reporter_sharing_not_use')}}</label>
                        </div>
                    </div>
                </div>
            </div>	
			@endif
        </div>
    </div>
</div>
@endif

@stop
