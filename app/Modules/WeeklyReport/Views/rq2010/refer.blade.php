<div id="result">
	<div class="card-body" style="padding-top: 4px;">
		<nav class="pager-wrap row" style="display: block ;">
			<input type="hidden" class="display_attr" value="{{ __('messages.display_attribute_info') }}">
			<input type="hidden" class="hide_attr" value="{{ __('messages.hide_attribute_info') }}">
			<div class="btn-group show_button_div pb-3">
				<button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="23">
					<i style="padding-top: 7px;padding-bottom: 7px;" class="fa fa-eye-slash"></i>
					<span id="btn_text">{{ __('messages.hide_attribute_info') }}</span>
				</button>
			</div>
			{{Paging::show($paging??[])}}
		</nav>
		<div class="table-responsive wmd-view table-fixed-header" id="table_employee">
			<table style="" class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder" id="tbl-data">
				<thead>
					<tr>
						@if(isset($report_authority_typ))
						@if($report_authority_typ >=3)
						<th style="min-width:55px" class="">{{ __('ri1021.selection') }}</th>
						@endif
						@endif
						<th style="min-width:80px;max-width:80px">{{__('rq2010.employee_number')}}</th>
						<th style="min-width:170px;max-width:170px">{{__('rq2010.employee_name')}}</th>
						@if(isset($M0022))
						@if(isset($M0022[0]['organization_group_nm']))
						<th data-toggle="tooltip" class="text-overfollow text-left el_show" style="max-width:150px" data-original-title="{{ $M0022[0]['organization_group_nm'] }}" >{{ $M0022[0]['organization_group_nm'] }}</th>
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=2)
						@if(isset($M0022[1]['organization_group_nm']))
						<th data-toggle="tooltip" class="text-overfollow text-left el_show" style="max-width:150px" data-original-title="{{ $M0022[1]['organization_group_nm'] }}" >{{ $M0022[1]['organization_group_nm'] }}</th>
						@endif
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=3)
						@if(isset($M0022[2]['organization_group_nm']))
						<th data-toggle="tooltip" class="text-overfollow text-left el_show" style="max-width:150px" data-original-title="{{ $M0022[2]['organization_group_nm'] }}" >{{ $M0022[2]['organization_group_nm'] }}</th>
						@endif
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=4)
						@if(isset($M0022[3]['organization_group_nm']))
						<th data-toggle="tooltip" class="text-overfollow text-left el_show" style="max-width:150px" data-original-title="{{ $M0022[3]['organization_group_nm'] }}" >{{ $M0022[3]['organization_group_nm'] }}</th>
						@endif
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=5)
						@if(isset($M0022[4]['organization_group_nm']))
						<th data-toggle="tooltip" class="text-overfollow text-left el_show" style="max-width:150px" data-original-title="{{ $M0022[4]['organization_group_nm'] }}" >{{ $M0022[4]['organization_group_nm'] }}</th>
						@endif
						@endif
						@endif
						<th style="max-width:150px" class="text-overfollow  el_show" data-original-title="{{__('rq2010.director')}}">{{__('rq2010.director')}}</th>
						<th style="width:150px" class="text-overfollow  el_show">{{__('rq2010.occupation')}}</th>
						<th style="width:150px" class="text-overfollow  el_show">{{__('rq2010.grade')}}</th>
						<th style="min-width:60px;width:150px" class="text-overfollow  el_show">{{__('rq2010.employee_classification')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.title')}}" style="width:200px">{{__('rq2010.title')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.situation_table')}}" style="width:200px">{{__('rq2010.situation_table')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.adequacy')}}" style="width:150px">{{__('rq2010.adequacy')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.business')}}" style="width:150px">{{__('rq2010.business')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.other')}}" style="width:150px">{{__('rq2010.other')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.sticky note')}}" style="min-width:55px">{{__('rq2010.sticky note')}}</th>
						<th  class="text-overfollow" data-original-title="{{__('rq2010.free_entry_column')}}" style="min-width:200px">{{__('rq2010.free_entry_column')}}</th>
					</tr>
				</thead>
				<tbody>
				@if(isset($list[0]))
					@foreach($list as $result)
					<tr>
						@if(isset($report_authority_typ))
						@if($report_authority_typ >=3)
						<td style="width:75px" class="text-center lblCheck">
							<input type="text" hidden class="company_cd" value="{{$result['company_cd']}}"/>
							<input type="text" hidden class="fiscal_year" value="{{$result['fiscal_year']}}"/>
							<input type="text" hidden class="report_kind" value="{{$result['report_kind']}}"/>
							<input type="text" hidden class="report_no" value="{{$result['report_no']}}"/>
							<input type="text" hidden class="employee_cd" value="{{$result['employee_cd']}}"/>
							<div id="" class="md-checkbox-v2 inline-block">
								@if($result['checkbox_is_show'] == 1)
								<label for="{{ 'ckb0' . $result['id_checkbox']  }}" class="container checkbox-os0030">
									<input name="check-all" class="chk-item" id="{{ 'ckb0' . $result['id_checkbox']  }}" type="checkbox">
									<span class="checkmark"></span>
								</label>
								@endif
							</div>
						</td>
						@endif
						@endif
						<td style="width:110px">
							@if($result['can_linked'] == 1)
							<div data-toggle="tooltip" title="" fiscal_year="{{ $result['fiscal_year'] }}" 
													employee_cd="{{ $result['employee_cd'] }}" 
													report_kind="{{ $result['report_kind'] }}" 
													report_no="{{ $result['report_no'] }}" 
													employee_nm="{{ $result['employee_nm'] }}" 
													class="text-center text-overfollow text-right link_rq2020">
								<a href="">{{$result['employee_cd'] ?? '' }}</a>
							</div>
							@else
							<div data-toggle="tooltip" data-original-title="{{$result['employee_cd'] ?? '' }}" class="text-center text-overfollow text-right">
							{{$result['employee_cd'] ?? '' }}
							</div>
							@endif
						</td>
						<td style="max-width:200px">
							<div data-toggle="tooltip" class="text-overfollow text-left" data-original-title="{{$result['employee_nm']}}">
								{{$result['employee_nm']}}
							</div>
						</td>
						@if(isset($M0022))
						@if(isset($M0022[0]['organization_group_nm']))
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" style="max-width:150px" data-original-title="{{$result['organization_nm1']}}">
								{{$result['organization_nm1']}}
							</div>
						</td>
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=2)
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" style="max-width:150px" data-original-title="{{$result['organization_nm2']}}">
								{{$result['organization_nm2']}}
							</div>
						</td>
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=3)
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" style="max-width:150px" data-original-title="{{$result['organization_nm3']}}">
								{{$result['organization_nm3']}}
							</div>
						</td>
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=4)
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" style="max-width:150px" data-original-title="{{$result['organization_nm4']}}">
								{{$result['organization_nm4']}}
							</div>
						</td>
						@endif
						@endif
						@if(isset($M0022))
						@if(count($M0022)>=5)
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" style="max-width:150px" data-original-title="{{$result['organization_nm5']}}">
								{{$result['organization_nm5']}}
							</div>
						</td>
						@endif
						@endif
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" data-original-title="{{$result['position_nm']}}">
								{{$result['position_nm']}}
							</div>
						</td>
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" data-original-title="{{$result['job_nm']}}">
							{{$result['job_nm']}}
							</div>
						</td>
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" data-original-title="{{$result['grade_nm']}}">
							{{$result['grade_nm']}}
							</div>
						</td>
						<td class="el_show" style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" class="text-overfollow text-left" data-original-title="{{$result['employee_typ_nm']}}">
							{{$result['employee_typ_nm']}}
							</div>
						</td>
						<td style="min-width:150px;max-width:200px">
						@if($result['can_linked'] == 1)
							<div data-toggle="tooltip" data-original-title="{{$result['title']}}" title="" fiscal_year="{{ $result['fiscal_year'] }}" 
                                                employee_cd="{{ $result['employee_cd'] }}" 
                                                report_kind="{{ $result['report_kind'] }}" 
                                                report_no="{{ $result['report_no'] }}" class="text-center text-overfollow text-right link_ri2010">
								<a href="#">{{$result['title']}}</a>
							</div>
						@else
							<div data-toggle="tooltip" data-original-title="{{$result['title']}}" class="text-center text-overfollow text-right">
							{{$result['title']}}
							</div>
						@endif
						</td>
						<td style="min-width:150px;max-width:150px">
							<div data-toggle="tooltip" style="max-width:130px" class="text-overfollow text-left" data-original-title="{{$result['status_nm']}}">
							{{$result['status_nm']}}
							</div>
						</td>
						{{-- 充実度 --}}
						<td class="w-40px invi_head text-center" style="min-width: 120px;">
						@if (isset($result['adequacy_kbn']) && $result['adequacy_kbn'] > 0)
							@if (isset($adequacy) && !empty($adequacy))
								@foreach ($adequacy as $item)
									@if ($item['mark_cd'] == $result['adequacy_kbn'])
									<img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
									@endif                                                        
								@endforeach    
							@endif
						@endif
						</td>
						{{-- 繁忙度 --}}
						<td class="w-40px invi_head text-center" style="min-width: 120px;">
						@if (isset($result['busyness_kbn']) && $result['busyness_kbn'] > 0)
							@if (isset($busyness) && !empty($busyness))
								@foreach ($busyness as $item)
									@if ($item['mark_cd'] == $result['busyness_kbn'])
									<img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
									@endif                                                        
								@endforeach
							@endif
						@endif
						</td>
						{{-- その他 --}}
						<td class="w-40px invi_head text-center" style="min-width: 120px;">
						@if (isset($result['other_kbn']) && $result['other_kbn'] > 0)
							@if (isset($other) && !empty($other))
								@foreach ($other as $item)
									@if ($item['mark_cd'] == $result['other_kbn'])
									<img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width=30px />        
									@endif                                                        
								@endforeach
							@endif
						@endif
						</td>
						<td style="padding-bottom:0px;padding-top:5px;border-top:none;border-left:none;border-right:none;min-width:120px">
						<div style="display:flex;">
						@if (isset($result['note_json']) && !empty($result['note_json']))
									@foreach ($result['note_json'] as $item)

										<div style="width:115px" class="sticky__label sticky__bg--{{ $item['note_color'] }}" style="background-color: {{ $item['note_color_code'] ?? '' }}" data-container="body"
											data-toggle="tooltip" data-placement="top" data-html="true"
											data-original-title="{!! nl2br($item['note_employee_nm']) !!}">
											<span>{{ $item['note_name'] }}</span>
										</div>    
									@endforeach
								@endif   
								</div>
						</td>
						<td style="max-width:200px">
							<div data-toggle="tooltip" style="max-width:200px" class="text-overfollow text-left" data-original-title="{{ $result['free_comment'] ?? '' }}">
								{{ $result['free_comment'] ?? '' }}
							</div>
						</td>
					</tr>
					@endforeach
				@else
				<tr class="tr-nodata">
					<td colspan="100%" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
				</tr>
				@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div><!-- end .card-body -->
</div>