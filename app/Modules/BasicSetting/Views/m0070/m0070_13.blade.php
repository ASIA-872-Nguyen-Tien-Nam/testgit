<div class="tab-pane fade" id="tab13">
    <div class=" line-border-bottom">
        <label class="control-label">{{ __('messages.reward_and_punishment_information_tab') }}</label>
    </div>
    <div class="col-md-12" style="margin-top : 10px">
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 480px">
			<table class="table table-bordered table-hover table-oneheader ofixed-boder table-head" id="table-data" style="margin-bottom: 20px !important;">
				<thead>
					<tr>
						<th class="text-center" style="width: 3%">
							<span class="item-right">
							@if (isset($disabled) && $disabled == '' && (isset($tab_13['disabled_tab13'] ) && $tab_13['disabled_tab13']  == ''))
								<button class="btn btn-rm blue btn-sm btn-add-new-row" id="add-new-row-tab13" tabindex="-1">
									<i class="fa fa-plus"></i>
								</button>
							@endif
							</span>
						</th>
						<th class="text-center" style="width: 10%;">{{ __('messages.type_reward_punish') }}</th>
						<th class="text-center" style="width: 8%;">{{ __('messages.date_reward_punish') }}</th>
                        <th class="text-center" style="width: 20%;">{{ __('messages.reason_reward_punish') }}</th>
                        <th class="text-center" style="width: 20%;">{{ __('messages.remarks') }}</th>
						@if (isset($disabled) && $disabled == '' && (isset($tab_13['disabled_tab13'] ) && $tab_13['disabled_tab13']  == ''))
						<th style="width: 3%"></th>
						@endif
					</tr>
				</thead>
				<tbody>
					@foreach($tab_13['list'] as $index => $row)
					<tr class="tr list_tab_13" cate_no="1">
						<td rowspan="1" class="text-center no">
							<span>{{ $index + 1 }}</span>
							<input type="text" class="form-control input-sm text-left d-none detail_no"
								value="{{ $row['detail_no'] ?? '' }}">
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<div>
								<div class="input-group-btn input-group">
								<span class="num-length">
									<input type="text" 
										class="form-control ui-autocomplete-input autocomplete-down-tab_13 name_trp"
										availableData = "{{ $tab_13['group_trp']}}"
										tabindex="9" maxlength="50" value="{{ $row['label'] ?? '' }}" style="padding-right: 40px;" autocomplete="off" {{$disabled}} {{$tab_13['disabled_tab13'] }}>
									<input type="text"
											class="form-control input-sm text-left reward_punishment_typ d-none"
											value="{{ $row['reward_punishment_typ'] ?? 0 }}">
								</span>
								</div>
							</div>
							@else
							{{ $row['label'] ?? '' }}
							@endif
						</td>
                        <td rowspan="1" class="low-cate text-center input_date" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" class="form-control input-sm date decision_date"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="{{ $row['decision_date'] ?? '' }}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
							@else
							{{ $row['decision_date'] ?? '' }}
							@endif
						</td>
						@if (isset($disabled) && $disabled == '')
							<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" tabindex="9" class="form-control input-sm text-left reason" value="{{ $row['reason'] ?? '' }}" maxlength="100">
							</span>
							</td>
						@else
						<td class="w-100px">
							<div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['reason'] ?? ''}}">
								{{$row['reason'] ?? ''}}
							</div>
						</td>
						@endif
						@if (isset($disabled) && $disabled == '')
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" tabindex="9" class="form-control input-sm text-left remarks" value="{{ $row['remarks'] ?? '' }}" maxlength="100">
							</span>
						</td>
						@else
						<td class="w-100px">
							<div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['remarks'] ?? ''}}">
								{{$row['remarks'] ?? ''}}
							</div>
						</td>
						@endif
						@if (isset($disabled) && $disabled == '' && (isset($tab_13['disabled_tab13'] ) && $tab_13['disabled_tab13']  == ''))
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="remove-row-tab13">
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
					<tr class="tr list_tab_13" cate_no="1">
						<td rowspan="1" class="text-center no">
							<span>1</span>
							<input type="text" class="form-control input-sm text-left d-none detail_no"
								value="0"></td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<div>
								<div class="input-group-btn input-group">
								<span class="num-length">
									<input type="text" class="form-control ui-autocomplete-input autocomplete-down-tab_13 name_trp" 
									availableData = "{{ $tab_13['group_trp'] }}"
									tabindex="9" maxlength="50" value="" style="padding-right: 40px;" autocomplete="off" {{$disabled}} {{$tab_13['disabled_tab13'] }}>
									<input type="text"
                                                class="form-control input-sm text-left reward_punishment_typ d-none"
                                                value="">
								</span>
								</div>
							</div>
						</td>
                        <td rowspan="1" class="low-cate input_date" low_cate_cd="1">
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" class="form-control input-sm date decision_date"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" tabindex="9" class="form-control input-sm text-left reason" value="" maxlength="100">
							</span>
						</td>
						<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_13['disabled_tab13'] }} type="text" tabindex="9" class="form-control input-sm text-left remarks" value="" maxlength="100">
							</span>
						</td>
						@if (isset($disabled) && $disabled == '' && (isset($tab_13['disabled_tab13'] ) && $tab_13['disabled_tab13']  == ''))
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="remove-row-tab13">
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