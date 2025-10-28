<div class="row">
	<div class="col-xs-12 col-md-12 col-lg-12 calHe2">
		<div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
					<input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key}}" maxlength="50">
					<div class="input-group-append-btn">
						<button id="btn-search-key" class="btn btn-transparent" type="button"><i class="fa fa-search"></i></button>
					</div>
				</div>
            </span>
		</div>
		<div class="form-group">
			<label class="control-label">{{ __('messages.org1') }}</label>
			<select name="" id="organization_nm" class="form-control" >
				<option value="0"></option>
				@if (isset($drop_org[0]))
					@foreach($drop_org as $opt)
						<option value='{{$opt['organization_cd_1']}}' {{$opt['organization_cd_1'] == $organization_cd?'selected':''}}>{{$opt['organization_nm']}}</option>
						{{-- <option value='{{$opt['organization_cd']}}'>{{$opt['organization_nm']}}</option> --}}
					@endforeach
				@endif
			</select>
		</div>
		<div class="form-group">
			<div class="checkbox">
				<div class="md-checkbox-v2 inline-block">
					<input name="company_out_dt_flg" id="company_out_dt_flg" {{($company_out_dt_flg??0)==1?'checked':''}} type="checkbox" value="1" >
					<label for="company_out_dt_flg" tabindex="-1">{{ __('messages.include_retired_employees') }}</label>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-md-12 col-xs-12 col-lg-12">
		<nav class="pager-wrap pagin-fix">
			{{Paging::show($paging)}}
		</nav>
	</div>
	<div class="col-md-12 col-xs-12 col-lg-12">
		<div class="list-search-v">
			<div class="list-search-head">
			{{ __('messages.registration_list') }}
			</div>

			<div class="list-search-content">
				@if ( isset($list[0]) )
					@foreach($list as $row)
					<div class="list-search-child {{request('employee_cd') == $row['employee_cd'] ? 'active' : ''}} {{isset($row['company_out_dt'])&&$row['company_out_dt']!=''?'div_left_company_out_dt':''}} {{$row['evaluated_typ_label']==1||$row['oneonone_typ_label']==1||$row['report_typ_label']==1||$row['multireview_typ_label']==1?'div_valuated_typ':''}}" id="{{ $row['employee_cd'] }}"  >
						<div class="text-overfollow " style="{{$row['company_out_dt'] == '' ? 'float:left;width: 90%':'float:left;width: 65%'}}" data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}" >
								{{$row['employee_nm']}}
						</div>
						<span id="{{$row['employee_cd'].'_span'}}" style="float: right;">{{$row['company_out_dt']}}</span>
					</div>
					@endforeach
				@else
					<div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
				@endif
			</div>
		</div>
	</div>
</div>
