@php
	function times_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  ':number';
    else
        return  $message;
	}
@endphp
<div class="row ">
	<div class="col-md-5 mb-3">
		<input type="hidden" id="employee_cd_login" value="{{$employee_cd_login??''}}">
		<select id="fiscal_year_1on1" tabindex="1" autocomplete="off" class="form-control required fiscal_year_1on1">
			<option value="0"></option>
			@if(!empty($F2001))
				@foreach($F2001 as $temp)
				<option value="{{$temp['fiscal_year']}}" {{$fiscal_year_1on1 == $temp['fiscal_year']?'selected':'' }}>{{ __('messages.list_of_1on1_in', ['year' => $temp['fiscal_year']]) }}</option>
				@endforeach
			@endif
		</select>
	</div>
	<div class="hidden div_append">
	</div>
	<div class="col-md-3 mb-3">
		<select id="times_select" tabindex="1" autocomplete="off" class="form-control required ">
			@if(!empty($members[1]))
				@foreach($members[1] as $key => $row)
					<option value="{{$row['index_from']}}" {{$row['index_from'] == $members[0][0]['times_from']?'selected':'' }}>{{$row['index_txt']}}</option>
				@endforeach
			@endif
		</select>
	</div>
	<div class="col-md-4 mb-3">
		<select id="group_cd_1on1" autocomplete="off" class="form-control group_cd_1on1" tabindex="3">
			<option value="-1"></option>
			@if(!empty($group_oneonone) && isset($group_oneonone[0]))
				@foreach($group_oneonone as $temp)
				<option value="{{$temp['group_cd_1on1']}}" {{$group_cd_1on1 == $temp['group_cd_1on1'] ? 'selected':''}}>{{$temp['group_nm_1on1']}}</option>
				@endforeach
			@endif
		</select>
	</div>
</div>

	@if (isset($members[1]) && $members[1] != [])
	@php
	function ordinal($number) {
    $ends = array('th','st','nd','rd','th','th','th','th','th','th');
	if( \Session::get('website_language', config('app.locale')) != 'en')
		return  '';
    elseif ((($number % 100) >= 11) && (($number%100) <= 13))
        return  'th';
    else
        return  $ends[$number % 10];
	}
	@endphp
	<div class="row mb-3">
		<div class="col-md-12">
			<div class="table-responsive wmd-view   table-data tableFixHead" style="margin-bottom: 10px;max-height: 64vh !important" >
				<table class="table table-bordered table-hover ofixed-boder table-special member-list" id="data_table" >
					<thead>
						<tr class="tr-table">
							<th colspan="{{$members[0][0]['times_to'] + 1}}">{{ __('messages.member_list') }}</th>
						</tr>
						<tr class="tr-table table1 tr_header1">
							<th width="14%"></th>
							@for($i = $members[0][0]['times_from'] ; $i <= $members[0][0]['times_to'] ; $i++)
							<th width="14%">
								<a fiscal_year_1on1="{{$fiscal_year_1on1}}" times="{{$i}}" group_cd_1on1="{{$group_cd_1on1}}" href="#" class="times_link">{{ __(times_english(__('messages.th_time')),['number' => $i]).ordinal($i) }}</a>
							</th>
							@endfor
						</tr>
						<tr class="tr-table tr_header2">
							<th width="14.28%" style="color: #fc933c;">{{ __('messages.questionnaire') }}</th>
							@if(!empty($members[2]))
								@foreach ($members[2] as $row)
									@if($row['is_questionnaire'] == 1 && $row['questionnaire_cd'] > 0)
									<th width="14%">
										<i class="fa fa-pencil fa-fw" aria-hidden="true"></i>
									</th>
									@elseif ($row['is_interview'] == 1  && $row['questionnaire_cd'] > 0)
									<th width="14%">
										<span class="oi3010_link" times= "{{$row['times']}}" questionnaire_cd="{{$row['questionnaire_cd']}}"><i class="fa fa-pencil fa-fw fa-active" aria-hidden="true"></i></span>
									</th>
									@else
									<th width="14%"></th>
									@endif
								@endforeach
							@endif
						</tr>
					</thead>
					<tbody>
						@if(!empty($members[5]))
						@foreach($members[5] as $member)
						<tr class="list">
							<td width="14%" class="table2">
								<a tabindex="9" href="#" employee_cd = "{{$member['employee_cd']}}" class="oq2020_link">{!!$member['employee_nm']!!}</a>
							</td>
							@for($i = $members[0][0]['times_from'] ; $i <= $members[0][0]['times_to'] ; $i++)
							<td width="14%" class="table2">
								@php
									$member_val = json_decode(str_replace('&quot;', '"', $member[$i]),true);
									$fullfillment_type = $member_val[0]['fullfillment_type']??'';
								@endphp
								@if($fullfillment_type != ''&& $fullfillment_type != 0 && $fullfillment_type != 0)
									<img class="fullfillment_click" 
										fiscal_year="{{ $member['fiscal_year'] ?? 0 }}" 
										employee_cd="{{ $member['employee_cd'] ?? '' }}"
										group_cd_1on1="{{ $member['group_cd_1on1'] ?? 0}}"
										times="{{ $i }}"
										style="cursor: pointer;" src="/uploads/ver1.7/odashboard/{{$combo_remark[$fullfillment_type]['remark1']}}"/>
								@endif
							</td>
							@endfor
						</tr>
						@endforeach
						@endif
					</tbody>
				</table>
			</div><!-- end .table-responsive -->
		</div>
	</div>
	@else
		<div class="row mb-3">
			<div class="col-md-12">
				<ul class="breadcrumb-arrow-noData">
					<div class="div-bar" style="width:100%;background-color: rgba(0,0,0,.05);">
						<li class="text-center">
							{{ $_text[21]['message'] }}
						</li>
					</div>
				</ul>
			</div>
		</div>
	@endif
