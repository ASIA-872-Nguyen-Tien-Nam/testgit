<div id="result">
	<div class="card-body">
		<nav class="pager-wrap row">
			{!! Paging::show($paging?? []) !!}
			{{-- <div class="btn-group pl-4">
			        <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm">
			            <i class="fa fa-eye-slash"></i>
			            <span id="btn_text">属性情報非表示</span>
			        </button>
			    </div>--}}
		</nav>
		<div class="row">
			<div class="col-md-12">
				<div class="wmd-view-topscroll">
					<div class="scroll-div1"></div>
				</div>
			</div>
		</div>

		<div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells" id="wmd" >
            <table class="table sortable table-bordered table-hover fixed-header table-striped" id="tbl-data">
				<thead>
					<tr>
						<th style="max-width:150px; min-width: 70px" rowspan="2">{{__('messages.customer_cd')}}</th>
						<th class="text-nm" rowspan="2">{{__('messages.customer_name')}}</th>
						<th class="text-name" rowspan="2">{{__('messages.pic')}}</th>
						<th rowspan="2">{{__('messages.pic')}} ２</th>
						<th rowspan="2">{{__('messages.mc_user')}}</th>
						<th colspan="3">{{__('messages.personnel_evaluation_function')}}</th>
						<th colspan="3">{{__('messages.1on1_function')}}</th>
						<th colspan="3">{{__('messages.mr_function')}}</th>
						@if(isset($check_account['check_account'])&&$check_account['check_account']!=0)
						<th class="text-wrap chk_accounts_number" style="width: 100px"></th>
						@endif
						<th colspan="3">{{__('messages.report_function')}}</th>
					</tr>
					<tr>
						{{-- <th>{{__('messages.customer_cd')}}</th>
						<th>{{__('messages.customer_name')}}</th>
						<th>{{__('messages.pic')}}</th>
						<th>{{__('messages.pic')}} ２</th> --}}
						<th>{{__('messages.contract_attribute')}}</th>
						<th>{{__('messages.contract_start_date')}}</th>
						<th>{{__('messages.contract_completion_date')}}</th>
						<th>{{__('messages.contract_attribute')}}</th>
						<th>{{__('messages.contract_start_date')}}</th>
						<th>{{__('messages.contract_completion_date')}}</th>
						<th>{{__('messages.contract_attribute')}}</th>
						<th>{{__('messages.contract_start_date')}}</th>
						<th>{{__('messages.contract_completion_date')}}</th>
						@if(isset($check_account['check_account'])&&$check_account['check_account']!=0)
						<th class=" chk_accounts_number">{{__('messages.number_of_accounts')}}</th>
						@endif
						<th>{{__('messages.weekly_report_function_contract_attribute')}}</th>
						<th>{{__('messages.weekly_report_function_contract_start_date')}}</th>
						<th>{{__('messages.weekly_report_function_termination_of_contract')}}</th>
					</tr>
				</thead>
				<tbody>
					@if(isset($data[0]) && $data !=[])
					@foreach($data as $row)
					<tr>
						<td>
							<div data-toggle="tooltip" title="{{$row['company_cd']}}" class="text-overfollow text-right link">
								<a company_cd="1" href="" tabindex="-1">
									{{$row['company_cd']}}
								</a>
								<input type="text" class="hidden company_cd" value="{{$row['company_cd']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['company_nm']}}" class="text-overfollow text-left">
								{{$row['company_nm']}}
								<input type="text" class="hidden company_nm" value="{{$row['company_nm']}}" />
							</div>

						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['employee_nm1']}}" class="text-overfollow text-left">
								{{$row['employee_nm1']}}
								<input type="text" class="hidden employee_nm1" value="{{$row['employee_nm1']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['employee_nm2']}}" class="text-overfollow text-left" style="">
								{{$row['employee_nm2']}}
								<input type="text" class="hidden employee_nm2" value="{{$row['employee_nm2']}}" />
							</div>
						</td>
						<td>
							@if ($row['contract_company_attribute'] == 2)
							<div data-toggle="tooltip" title="{{$row['user_id']}}" class="text-overfollow text-left">
								<a href="{{$row['domain']}}/redirect_login/?param={{$row['param']}}" target="_blank" class="user-id" value="{{$row['user_id']}}">{{$row['user_id']}}</a>
							</div>
							@endif
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['name_eva']}}" class="text-overfollow text-left">
								{{$row['name_eva']}}
								<input type="text" class="hidden name_eva" value="{{$row['name_eva']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['eva_use_start_dt']}}" class="text-overfollow text-center" style="">
								{{$row['eva_use_start_dt']}}
								<input type="text" class="hidden eva_use_start_dt text-center" value="{{$row['eva_use_start_dt']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['eva_user_end_dt']}}" class="text-overfollow text-center">
								{{$row['eva_user_end_dt']}}
								<input type="text" class="hidden eva_user_end_dt text-center" value="{{$row['eva_user_end_dt']}}" />
							</div>
						</td>

						<td>
							<div data-toggle="tooltip" title="{{$row['name_oneonone']}}" class="text-overfollow text-left">
								{{$row['name_oneonone']}}
								<input type="text" class="hidden name_oneonone" value="{{$row['name_oneonone']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['oneonone_use_start_dt']}}" class="text-overfollow text-center" style="">
								{{$row['oneonone_use_start_dt']}}
								<input type="text" class="hidden oneonone_use_start_dt text-center" value="{{$row['oneonone_use_start_dt']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['oneonone_user_end_dt']}}" class="text-overfollow text-center">
								{{$row['oneonone_user_end_dt']}}
								<input type="text" class="hidden oneonone_user_end_dt text-center" value="{{$row['oneonone_user_end_dt']}}" />
							</div>
						</td>

						<td>
							<div data-toggle="tooltip" title="{{$row['name_multiview']}}" class="text-overfollow text-left">
								{{$row['name_multiview']}}
								<input type="text" class="hidden name_multiview" value="{{$row['name_multiview']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['multiview_use_start_dt']}}" class="text-overfollow text-center" style="">
								{{$row['multiview_use_start_dt']}}
								<input type="text" class="hidden multiview_use_start_dt text-center" value="{{$row['multiview_use_start_dt']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['multiview_user_end_dt']}}" class="text-overfollow text-center">
								{{$row['multiview_user_end_dt']}}
								<input type="text" class="hidden multiview_user_end_dt text-center" value="{{$row['multiview_user_end_dt']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['name_multiview']}}" class="text-overfollow text-center">
								{{$row['name_report']}} <!-- Weekly report function contract attribute -->
								<input type="text" class="hidden name_multiview text-center" value="{{$row['name_multiview']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['report_use_start_dt']}}" class="text-overfollow text-center">
								<!-- Weekly report function contract start date -->
								{{$row['report_use_start_dt']}}
								<input type="text" class="hidden report_use_start_dt text-center" value="{{$row['report_use_start_dt']}}" />
							</div>
						</td>
						<td>
							<div data-toggle="tooltip" title="{{$row['report_use_end_dt']}}" class="text-overfollow text-center">
								<!-- Weekly report function Termination of contract	 -->
								{{$row['report_use_end_dt']}}
								<input type="text" class="hidden report_use_end_dt text-center" value="{{$row['report_use_end_dt']}}" />
							</div>
						</td>
						@if(isset($check_account['check_account'])&&$check_account['check_account']!=0)
						<td class="chk_accounts_number">
							<div data-toggle="tooltip" title="{{$row['accounts_number']}}" class="text-overfollow text-right" style="width: 80px">
								{{$row['accounts_number']}}
								<input type="text" class="hidden accounts_number" value="{{$row['accounts_number']}}" />
							</div>
						</td>
						@endif
					</tr>
					@endforeach
					@else
					<tr class="tr-nodata">
						<td colspan="{{(isset($check_account['check_account'])&&$check_account['check_account']!=0)?'18':'17'}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
					</tr>
					@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div><!-- end .card-body -->
</div>