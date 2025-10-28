<div class="row" style="margin-left : 0px">
	<div class="col-md-5 col-lg-4 col-xl-3" >
		<div class="form-group">
			<label class="control-label text-overfollow" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm'] ?? ''}}" 
				style="margin-bottom: 0px;width: 265px;">
				{{$organization_group[0]['organization_group_nm'] ?? '&nbsp;'}}
			</label>
			<select name="" id="organization_cd" class="form-control " tabindex="1">
				<option value=""></option>
				@foreach($combo_organization_cd as $item)
					<option value="{{$item['organization_cd_1']}}" {{$item['organization_cd_1'] == $organization_cd?'selected':''}}>
						{{$item['organization_nm']}}
					</option>
				@endforeach
			</select>
		</div><!--/.form-group -->
	</div><!-- end .col-md-3 -->
	<div class="col-md-2 col-lg-2 col-xl-2 ">
		<div class="form-group" >
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<span class="num-length">
				<input type="text" class="form-control text-right only-number number-code" tabindex="2" maxlength="4" value="{{$result[0]['arrange_order']??''}}" id="arrange_order">
			</span>
		</div>
	</div>
</div><!-- end .row -->
<div>
	<div class="col-md-12" >
		<div class="table-responsive  sticky-table sticky-headers sticky-ltr-cells" style="height: 480px">
			<table class="table table-bordered table-hover table-striped ofixed-boder" id="table-data" >
				<thead>
					<tr>
						<th style="width: 20%">{{ __('messages.position') }}</th>	
						<th style="width: 20%">{{ __('messages.1st_rater') }}</th>
						<th style="width: 20%">{{ __('messages.2nd_rater') }}</th>
						<th style="width: 20%">{{ __('messages.3rd_rater') }}</th>
						<th style="width: 20%">{{ __('messages.4th_rater') }}</th>
					</tr>
				</thead>
				<tbody>
					@if(isset($result)&&$result != [])
						@foreach($result as $row)
						<tr class="list">
							<td> 
								{{$row['position_nm']}}
								<input type="text" class="hidden position_cd" value="{{$row['position_cd']}}" />
								<input type="text" class="hidden organization_cd" value="{{$row['organization_cd']}}" />
							</td>
							<td>
								<select name="" id="" class="form-control input-sm rater_position_cd_1" {{$Rater['Rater1']??''}} tabindex="3"> 
									<option value="-1"></option>
									@foreach($combo_position_cd as $list)
										<option value="{{$list['position_cd']}}" {{$list['position_cd'] == $row['rater_position_cd_1'] ? 'selected' : ''}} >
											{{$list['position_nm']}}
										</option>
									@endforeach
								</select>
							</td>
							<td>
								<select name="" id="" class="form-control input-sm rater_position_cd_2 " {{$Rater['Rater2']??''}} tabindex="3">
									<option value="-1"></option>
									@foreach($combo_position_cd as $list)
										<option value="{{$list['position_cd']}}" {{$list['position_cd'] == $row['rater_position_cd_2'] ? 'selected' : ''}}>
											{{$list['position_nm']}}
										</option>
									@endforeach
								</select>
							</td>
							<td>
								<select name="" id="" class="form-control input-sm rater_position_cd_3" {{$Rater['Rater3']??''}} tabindex="3">
									<option value="-1"></option>
									@foreach($combo_position_cd as $list)
										<option value="{{$list['position_cd']}}" {{$list['position_cd'] == $row['rater_position_cd_3'] ? 'selected' : ''}}>
											{{$list['position_nm']}}
										</option>
									@endforeach
								</select>
							</td>
							<td>
								<select name="" id="" class="form-control input-sm rater_position_cd_4 " {{$Rater['Rater4']??''}} tabindex="3">
									<option value="-1"></option>
									@foreach($combo_position_cd as $list)
										<option value="{{$list['position_cd']}}" {{$list['position_cd'] == $row['rater_position_cd_4'] ? 'selected' : ''}}>
											{{$list['position_nm']}}
										</option>
									@endforeach
								</select>
							</td>
						</tr>
						@endforeach
					@else
						<tr class="tr-nodata">
							<td colspan="11" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
						</tr>
					@endif
				</tbody>
			</table>
		</div><!-- end .table-responsive -->
	</div><!-- end .col-md-12 -->
	
</div><!-- end .row -->

