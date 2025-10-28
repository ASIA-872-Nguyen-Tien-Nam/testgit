<div class="tab-pane fade" id="tab9">
    <div class="row col-md-12">
        <div class="col-md-12 col-xl-12 col-lg-12 col-xs-12 col-lg-12 " style="padding: 0 10px;">
            <div class="row">
                <div style="width: 7.5%;">
                    <div class="form-group">
                        <label class="control-label">{{ __('messages.marital_status') }}&nbsp;
                        </label>
                        <select {{$disabled}} {{$tab_08['disabled_tab08'] }}  name="" id="marital_status" class="form-control " tabindex="9">
                            <option value="0"></option>
							@foreach ($tab_08['marital_status'] as $data)
								<option value="{{ $data['number_cd'] }}"
									{{ $data['number_cd'] == ($tab_08['list'][0][0]['marital_status'] ?? 0) ? 'selected' : ''}}
								>{{ $data['name'] }}</option>
							@endforeach
                        </select>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.label9_em0100') }}</label>
    </div>
    <div class="col-md-12" style="margin-top : 10px">
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 480px">
			<table class="table table-bordered table-hover table-oneheader ofixed-boder table-head" id="table-data" style="margin-bottom: 20px !important;">
				<thead>
					<tr>
						<th class="text-center" style="width: 3%">
							<span class="item-right">
							@if (isset($disabled) && $disabled == '' && (isset($tab_08['disabled_tab08'] ) && $tab_08['disabled_tab08']  == ''))
								<button class="btn btn-rm blue btn-sm btn-add-new-row" id="btn-add-row-tab_08" tabindex="9">
									<i class="fa fa-plus"></i>
								</button>
							@endif
							</span>
						</th>
						<th class="text-center" style="width: 11.5%;">{{ __('messages.full_name') }}</th>
						<th class="text-center" style="width: 11.5%;">{{ __('messages.furigana') }}</th>
                        <th class="text-center" style="width: 11.5%;">{{ __('messages.relationship') }}</th>
                        <th class="text-center" style="width: 11.5%;">{{ __('messages.sex') }}</th>
                        <th class="text-center" style="width: 11.5%;">{{ __('messages.date_birth') }}</th>
                        <th class="text-center" style="width: 11.5%;">{{ __('messages.residential_classification') }}</th>
                        <th class="text-center" style="width: 12.5%;">{{ __('messages.profession') }}</th>
						@if (isset($disabled) && $disabled == '' && (isset($tab_08['disabled_tab08'] ) && $tab_08['disabled_tab08']  == ''))
						<th style="width: 3%"></th>
						@endif
					</tr>
				</thead>
				<tbody>
					@foreach ($tab_08['list'][1] as $index => $row)
					<tr class="tr list_tab_08" cate_no="1">
						<td rowspan="1" class="text-center no">{{$index + 1}}</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
								<input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" tabindex="9" class="form-control input-sm text-left full_name" id="" value="{{ $row['full_name'] ?? ''}}" maxlength="10" decimal="2">
							</span>
							@else
								{{ $row['full_name'] ?? ''}}
							@endif
							
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
								<input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" tabindex="9" class="form-control input-sm text-left   halfsize-kana full_name_furigana" id="" value="{{ $row['full_name_furigana'] ?? ''}}" maxlength="10" decimal="2">
							</span>
							@else
								{{ $row['full_name_furigana'] ?? ''}}
							@endif
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<div>
								<span class="num-length">
								<div class="input-group-btn input-group">
										<input type="hidden"
											class="form-control input-sm text-left detail_no" 
											value="{{ $row['detail_no'] }}">
										<input type="text"
											class="form-control ui-autocomplete-input autocomplete-down-tab_08" id=""
											availableData = "{{ $tab_08['relationship'] }}" tabindex="9" maxlength="10"
											value="{{ $row['relationship'] ?? ''}}"
											style="padding-right: 40px;" autocomplete="off" {{ $disabled }} {{$tab_08['disabled_tab08'] }}>
										<input type="hidden" id="relationship"
											class="form-control input-sm text-left relationship"
											value="{{$row['relationship_cd'] ?? ''}}">
										</div>
									</span>
							</div>
							@else
								{{$row['relationship'] ?? ''}}
							@endif
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <select {{$disabled}} {{$tab_08['disabled_tab08'] }}  name="" id="" class="form-control gender" tabindex="9">
									<option value="0"></option>
									@foreach ($tab_08['gender'] as $data)
										<option value="{{ $data['number_cd'] }}"
											{{ $data['number_cd'] == ($row['gender'] ?? 0) ? 'selected' : ''}}
										>{{ $data['name'] }}</option>
									@endforeach
                            	</select>
							</span>
							@else
							{{ $row['gender_nm'] }}
							@endif
						</td>
                        <td rowspan="1" class="low-cate text-center" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <div class="input-group-btn input-group input_date">
                                    <input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" class="form-control input-sm date birthday" id=""
                                        placeholder="yyyy/mm/dd" tabindex="9" value="{{ $row['birthday'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
							@else
								{{ $row['birthday'] }}
							@endif
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <select {{$disabled}} {{$tab_08['disabled_tab08'] }}  name="" id="" class="form-control residential_classification" tabindex="9">
									<option value="0"></option>
									@foreach ($tab_08['residential_classification'] as $data)
										<option value="{{ $data['number_cd'] }}"
										{{ $data['number_cd'] == ($row['residential_classification'] ?? 0) ? 'selected' : ''}}
										>{{ $data['name'] }}</option>
									@endforeach
                                </select>
							</span>
							@else
								{{ $row['residential_classification_nm'] }}
							@endif
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<div>
								<span class="num-length">
								<div class="input-group-btn input-group">
										<input type="text"
											class="form-control ui-autocomplete-input autocomplete-down-tab_08 profession" id="profession" 
											availableData = "{{ $tab_08['profession'] }}" tabindex="9" maxlength="10"
											value="{{ $row['profession'] ?? '' }}"
											style="padding-right: 40px;" autocomplete="off" {{$disabled}} {{$tab_08['disabled_tab08'] }}>
										{{-- <input type="hidden" id="profession"
											class="form-control input-sm text-left profession"
											value="{{ $row['profession_cd'] ?? '' }}"> --}}
									</div>
								</span>
							</div>
							@else
								{{ $row['profession_nm'] }}
							@endif
						</td>
						@if (isset($disabled) && $disabled == '' && (isset($tab_08['disabled_tab08'] ) && $tab_08['disabled_tab08']  == ''))
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="btn-remove-row-tab_08">
								<i class="fa fa-remove"></i>
							</button>
						</td>
						@endif
					</tr>							
					@endforeach
				</tbody>
			</table>
            <table class="hidden table-target">
				<tbody>
					<tr class="tr list_tab_08" cate_no="1">
						<td rowspan="1" class="text-center no">1</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								
								<input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" tabindex="9" class="form-control input-sm text-left full_name" value="" maxlength="10" decimal="2">
							</span>
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								
								<input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" tabindex="9" class="form-control input-sm text-left   halfsize-kana full_name_furigana" value="" maxlength="10" decimal="2">
							</span>
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<div>
								<span class="num-length">
								<div class="input-group-btn input-group">
										<input type="hidden"
											class="form-control input-sm text-left detail_no"
											value="0">
										<input type="text"
											class="form-control ui-autocomplete-input autocomplete-down-tab_08"
											availableData = "{{ $tab_08['relationship'] }}" tabindex="9" maxlength="10"
											value=""
											style="padding-right: 40px;" autocomplete="off" {{ $disabled }}>
										<input type="hidden" id="relationship"
											class="form-control input-sm text-left relationship"
											value="">
										</div>
									</span>
							</div>
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
                                <select {{$disabled}} {{$tab_08['disabled_tab08'] }}  name="" id="" class="form-control gender" tabindex="9">
                                <option value="0"></option>
                                @foreach ($tab_08['gender'] as $data)
									<option value="{{ $data['number_cd'] }}">{{ $data['name'] }}</option>
								@endforeach
                            </select>
							</span>
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
                                <div class="input-group-btn input-group input_date">
                                    <input {{$disabled}} {{$tab_08['disabled_tab08'] }}  type="text" class="form-control input-sm date birthday" id=""
                                        placeholder="yyyy/mm/dd" tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
                                <select {{$disabled}} {{$tab_08['disabled_tab08'] }}  name="" id="" class="form-control residential_classification" tabindex="9">
                                <option value="0"></option>
                                @foreach ($tab_08['residential_classification'] as $data)
									<option value="{{ $data['number_cd'] }}">{{ $data['name'] }}</option>
								@endforeach
                                </select>
							</span>
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<div>
								<span class="num-length">
								<div class="input-group-btn input-group">
										<input type="text"
											class="form-control ui-autocomplete-input autocomplete-down-tab_08 profession" id="profession"
											availableData = "{{ $tab_08['profession'] }}" tabindex="9" maxlength="10"
											value=""
											style="padding-right: 40px;" autocomplete="off" {{ $disabled }}>
											{{-- <input type="hidden" id="profession"
											class="form-control input-sm text-left profession"
											value=""> --}}
										</div>
									</span>
							</div>
						</td>
						@if (isset($disabled) && $disabled == '' && (isset($tab_08['disabled_tab08'] ) && $tab_08['disabled_tab08']  == ''))
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="btn-remove-row-tab_08">
								<i class="fa fa-remove"></i>
							</button>
						</td>
						@endif
					</tr>
				</tbody>
            </table><!-- /.hidden -->
		</div><!-- end .table-responsive -->
	</div>
</div>