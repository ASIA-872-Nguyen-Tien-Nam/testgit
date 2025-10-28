
<div class="card">
	<div class="card-body box-input-search">
		<div class="row">
			<div class="col-md-2 div_parent_employee_cd">
				<div class="form-group">
					<label class="control-label">{{__('messages.employee_no')}}</label>
					<div class="form-group">
						<span class="num-length">
							<div class="input-group-btn input-group div_employee_cd">
								<span class="num-length">
									<input type="text" id="employee_cd" screen="eq0200" class="form-control indexTab employee_cd refer_employee_cd Convert-Halfsize" maxlength="10" value="" autocomplete="off" tabindex="1">
								</span>
								<div class="input-group-append-btn">
									<button class="btn btn-transparent btn_employee_cd_popup_employee_information" type="button" tabindex="1">
										<i class="fa fa-search"></i>
									</button>
								</div>
								<input type="hidden" class="system" value="61">
							</div>
						</span>
					</div>
				</div>
			</div>
			<div class="col-md-3 div_parent_employee_nm">
				<div class="form-group">
					<label class="control-label">{{__('messages.name_s')}}</label>
					<span class="num-length">
						<input type="hidden" class="employee_cd_hidden">
						<input type="text" id="employee_nm" class="form-control employee_name" maxlength="50" placeholder="{{__('messages.label_eq0200')}}"  tabindex="1">
					</span>
				</div>
			</div>
		</div> <!-- end .row -->
		<div class="row">
			@if(isset($organization_group[0]))
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow org" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}">
						{{$organization_group[0]['organization_group_nm']}}
						</label>
						<select system="61" id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="-1"></option>
							@isset($combo_organization)
								@foreach($combo_organization as $row)
									@isset($row['organization_cd_1'])
										<option value="{{$row['organization_cd_1']}}" >{{$row['organization_nm']}}</option>
									@endisset
								@endforeach
							@endisset
						</select>
					</div>
					<!--/.form-group -->
				</div>
			@endif
			@foreach($organization_group as $dt)
				@if($dt['organization_typ'] >=2)
					<div class="col-md-2 col-xs-12 col-lg-2">
						<div class="form-group">
							<label class="control-label text-overfollow org" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}">
								{{$dt['organization_group_nm']}}
							</label>
							<select system="61" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="1" organization_typ = "{{$dt['organization_typ']}}">
								<option value="-1"></option>
							</select>
						</div>
						<!--/.form-group -->
					</div>
				@endif
			@endforeach
		</div><!-- end .row -->
		<div class="row">
			{{-- 資格 --}}
			@if (isset($cert_use_typ) && $cert_use_typ == 1)
			<div class="col-md-4">
				<div class="form-group">
					<label class="control-label">{{__('messages.credentials_tab')}}</label>
					<div class="input-group-btn input-group">
						<span class="num-length">
							<input type="text" class="form-control"tabindex="1" maxlength="50" value="" style="padding-right: 40px;" id="cert_use_typ">
						</span>
					</div>
				</div>
			</div>	
			@endif
			@if (isset($resume_use_typ) && $resume_use_typ == 1)
			<div class="col-md-4">
				<div class="form-group">
					<label class="control-label">{{__('messages.work_history_infor')}}</label>
					<span class="num-length">
						<input type="text" class="form-control" maxlength="50" tabindex="1" id="resume_use_typ">
					</span>
				</div>
			</div>
			@endif
		</div>
		@if (isset($items) && !empty($items))
		<div class="row">
			@foreach ($items as $item)
			@if ($item['search_kbn'] == 1)
			<div class="col-md-4">
				<div class="form-group">
					<label class="control-label text-overfollow field" data-toggle="tooltip" data-original-title="{{ $item['field_nm'] }}">
						{{ $item['field_nm'] }}
					</label>
					<span class="num-length">
						<input type="text" class="form-control field_nm" maxlength="50" tabindex="1" field_cd="{{ $item['field_cd'] }}">
					</span>
				</div>
			</div>	
			@endif
			@endforeach
		</div>
		@endif
		<div class="row">
			<div class="col-md-12 search-common">
				<div class="form-group text-right">
					<label class="control-label">&nbsp;</label>
					<div class="full-width setheight-common">
						<a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="1">
							<i class="fa fa-search"></i>
							{{__('messages.search')}}
						</a>
					</div><!-- end .full-width -->
				</div>
			</div>
		</div>
	</div> <!-- end .card-body -->
</div> <!-- end .card -->

<div id="result">
	{{-- @include('EmployeeInfo::eq0200.search_result') --}}
</div>




