@extends('popup')

@push('header')
    {{-- {!! public_url('template/css/popup/ri0020.index.css') !!} --}}
@endpush

@section('asset_footer')
    {{-- {!! public_url('template/js/popup/ri0020.index.js') !!} --}}
@stop

@section('content')
<div class="card">
	<div class="card-body search-condition">
		<div id="collapseExample" class="collapse show">
			<div class="row">
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
							<input type="text" id="employee_ab_nm" class="form-control" maxlength="50" placeholder="{{__('messages.label_006')}}"  tabindex="1">
						</span>
					</div>
				</div>
			</div> <!-- end .row -->
			<div class="row">
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織１
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織１
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織２
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織３
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織４
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
				<div class="col-md-2 col-xs-12 col-lg-2">
					<div class="form-group">
						<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="" style="width:150px">
							組織５
						</label>
						<select id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
							<option value="0"></option>
						</select>
					</div>
				</div>
			</div>
			{{-- <div class="row">
				@if(isset($organization_group[0]))
					<div class="col-md-2 col-xs-12 col-lg-2">
						<div class="form-group">
							<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}"
							style="width:150px">
							{{$organization_group[0]['organization_group_nm']}}
							</label>
							<select system="{{ $system ?? 1 }}" id="organization_step1" class="form-control organization_cd1" tabindex="1" organization_typ='1'>
								<option value="0"></option>
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
								<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}"
									style="width:150px">
									{{$dt['organization_group_nm']}}
								</label>
								<select system="{{ $system ?? 1 }}" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="1" organization_typ = "{{$dt['organization_typ']}}">
									<option value="0"></option>
								</select>
							</div>
							<!--/.form-group -->
						</div>
					@endif
				@endforeach
			</div><!-- end .row --> --}}
			<div class="row">
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.credentials_tab')}}</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.work_history_infor')}}</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
            </div>
			
			<div class="row">
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}1</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}2</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
            </div>
            <div class="row">
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}3</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}4</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
            </div>
            <div class="row">
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}5</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
                <div class="col-md-4">
					<div class="form-group">
						<label class="control-label">{{__('messages.item')}}6</label>
						<span class="num-length">
							<input type="text" class="form-control" maxlength="100" tabindex="1" placeholder="{{ __('messages.search_like') }}">
						</span>
					</div>
				</div>
                <div class="col-md-4 search-common">
                    <div class="form-group text-right">
                        <label class="control-label">&nbsp;</label>
                        <div class="full-width setheight-common">
                            <a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="1" placeholder="{{ __('messages.search_like') }}">
                                <i class="fa fa-search"></i>
                                {{__('messages.search')}}
                            </a>
                        </div><!-- end .full-width -->
                    </div>
                </div>
            </div>
		</div>
	</div> <!-- end .card-body -->
</div> <!-- end .card -->
@stop
