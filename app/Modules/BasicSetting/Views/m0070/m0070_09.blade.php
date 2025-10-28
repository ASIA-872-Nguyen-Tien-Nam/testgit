
    <div class="col-md-12" style="margin-top : 10px">
		<div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 480px">
			<table class="table table-bordered table-hover table-oneheader ofixed-boder table-head" id="table-data" style="margin-bottom: 20px !important;">
				<thead>
					<tr>
						<th class="text-center" style="width: 3%">
							<span class="item-right">
							@if (isset($disabled) && $disabled == '' && (isset($tab_09['disabled_tab09'] ) && $tab_09['disabled_tab09']  == ''))
								<button class="btn btn-rm blue btn-sm btn-add-new-row" id="add-new-row-tab09" tabindex="-1">
									<i class="fa fa-plus"></i>
								</button>
							@endif
							</span>
						</th>
						<th class="text-center" style="width: 10%;">{{ __('messages.leave_absence_st') }}</th>
						<th class="text-center" style="width: 10%;">{{ __('messages.leave_absence_end') }}</th>
                        <th class="text-center" style="width: 40%;">{{ __('messages.reason_leave_absence') }}</th>
						@if (isset($disabled) && $disabled == '' && (isset($tab_09['disabled_tab09'] ) && $tab_09['disabled_tab09']  == ''))
						<th style="width: 3%"></th>
						@endif
					</tr>
				</thead>
				<tbody>
					@foreach($tab_09['list'] as $index => $row)
					<tr class="tr list_tab_09" cate_no="1">
						<td rowspan="1" class="text-center no">
							<span>{{ $index + 1 }}</span>
							<input type="text" class="form-control input-sm text-left d-none detail_no"
								value="{{ $row['detail_no'] ?? '' }}">
						</td>
                        <td rowspan="1" class="low-cate text-center" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" class="form-control input-sm date leave_absence_startdate"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="{{$row['leave_absence_startdate'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
							@else
							{{$row['leave_absence_startdate'] ?? ''}}
							@endif
						</td>
                        <td rowspan="1" class="low-cate text-center" low_cate_cd="1">
							@if (isset($disabled) && $disabled == '')
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" class="form-control input-sm date leave_absence_enddate"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="{{$row['leave_absence_enddate'] ?? ''}}">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
							@else
							{{$row['leave_absence_enddate'] ?? ''}}
							@endif
						</td>
						@if (isset($disabled) && $disabled == '')
							<td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="hidden" class="category3_cd" value="">
								<input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" tabindex="9" class="form-control input-sm text-left remarks" value="{{$row['remarks'] ?? ''}}" maxlength="100" decimal="2">
							</span>
							</td>
						@else
							<td class="w-100px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{$row['remarks'] ?? ''}}">
									{{$row['remarks'] ?? ''}}
                                </div>
                            </td>
						@endif
						@if (isset($disabled) && $disabled == '' && (isset($tab_09['disabled_tab09'] ) && $tab_09['disabled_tab09']  == ''))
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="remove-row-tab09">
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
                    <tr class="tr list_tab_09" cate_no="1">
						<td rowspan="1" class="text-center no">
							<span>1</span>
							<input type="text" class="form-control input-sm text-left d-none detail_no"
								value="0">
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" class="form-control input-sm date leave_absence_startdate"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
                                <div class="input-group-btn input-group">
                                    <input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" class="form-control input-sm date leave_absence_enddate"
                                        placeholder="yyyy/mm/dd" tabindex="9" value="">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent date" type="button" data-dtp="dtp_wH14i"
                                            tabindex="-1"><i class="fa fa-calendar"></i></button>
                                    </div>
                                </div>
							</span>
						</td>
                        <td rowspan="1" class="low-cate" low_cate_cd="1">
							<span class="num-length">
								<input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="hidden" class="category3_cd" value="">
								<input {{$disabled}} {{$tab_09['disabled_tab09'] }}  type="text" tabindex="9" class="form-control input-sm text-left remarks" value="" maxlength="100" decimal="2">
							</span>
						</td>
						<td class="text-center">
							<button tabindex="9" class="btn btn-rm btn-sm btn-remove-row" id="remove-row-tab09">
								<i class="fa fa-remove"></i>
							</button>
						</td>
					</tr>
                </tbody>
            </table><!-- /.hidden -->
		</div><!-- end .table-responsive -->
	</div>
