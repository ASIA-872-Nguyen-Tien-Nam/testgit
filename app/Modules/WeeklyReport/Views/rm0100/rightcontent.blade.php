
<div class="row">
	<div class="col-sm-12 col-md-12 col-lg-2 col-xl-2">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}" style="white-space: nowrap;">{{ __('rm0100.report_type') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					@php
						$check = true;
			   		@endphp
					<select id="report_kind" tabindex="1" class="form-control required">
						<option value="0">{{ __('rm0100.common') }}</option>
						@isset($report_kinds)
							@foreach ($report_kinds as $report_kinds)
								@if (($m4125['report_kind'] ?? 0) == $report_kinds['report_kind'])
								<option value="{{$report_kinds['report_kind']}}" selected>{{$report_kinds['report_name']}}</option>
								@else
								<option value="{{$report_kinds['report_kind']}}">{{$report_kinds['report_name']}}</option>
								@endif
								@php
									if(($m4125['report_kind'] ?? 0) == $report_kinds['report_kind'] || ($m4125['report_kind'] ?? 0) == 0){
										$check = false;
									}
								@endphp
							@endforeach
						@endisset
						@if ($check)
							<option value="-1" selected></option>
						@endif
					</select>
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
</div>

<div class="row">
	<div class="col-sm-12 col-md-12 col-lg-9 col-xl-9">
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('rm0100.title') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="text" id="company_cd_refer" class="form-control hide" value="{{ $m4125['company_cd'] ?? -1}}" tabindex="-1">
					<input type="text" id="question_no" class="form-control hide" value="{{ $m4125['question_no'] ?? -1}}" tabindex="-1">
					<input type="text" id="question_title" class="form-control required" maxlength="50" value="{{ $m4125['question_title'] ?? ''}}" tabindex="2">
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
	<div class="col-sm-12 col-md-12 col-lg-3 col-xl-3">
		<div class="form-group">
			<label class="control-label">{{ __('rm0100.sort_order') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="text" id="arrange_order" tabindex="3" class="form-control only-number" maxlength="3" value="{{ $m4125['arrange_order'] ?? ''}}" />
				</span>
			</div>
		</div><!--/.form-group -->
	</div>
</div>

<div class="row">
    <div class="col-sm-12 col-md-12 col-lg-12">					
		<div class="form-group">
			<label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('rm0100.question')}} </label>
			<span class="num-length">
				<input type="text" class="form-control required" id="question" tabindex="4" maxlength="200"  value="{{ $m4125['question'] ?? ''}}" />
			</span>
		</div><!--/.form-group -->
	</div>
</div>


<div class="row">
	<div class="col-sm-12 col-md-12 col-lg-3 col-xl-3">
		<div class="form-group">
			<label class="control-label">{{ __('rm0100.answer_type') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<select id="answer_kind" class="form-control item_kind required" tabindex="5">
						@isset($answer_kind)
							@foreach ($answer_kind as $answer_kind)							
								@if (($m4125['answer_kind'] ?? 0) == $answer_kind['number_cd'])
								<option value="{{$answer_kind['number_cd']}}" selected>{{$answer_kind['name']}}</option>
								@else
								<option value="{{$answer_kind['number_cd']}}">{{$answer_kind['name']}}</option>
								@endif
							@endforeach
						@endisset
					</select>
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
	<div class="block_digit col-sm-6 col-md-6 col-lg-2 col-xl-3">
		<div class="form-group">
			<label class="control-label" style="white-space: nowrap;">{{ __('rm0100.digit') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="text" id="item_digits" class="form-control only-number required" tabindex="6" maxlength="4" value="{{ $m4125['answer_digits'] ?? ''}}"/>
				</span>
			</div>
		</div><!--/.form-group -->
	</div>
	<div class="col-sm-6 col-md-6 col-lg-1 col-xl-1">
		<div class="form-group" style="min-width: 155px">
			<label class="control-label" style="white-space: nowrap;">{{ __('rm0100.answer_category') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<select id="answer_kbn" tabindex="7" class="form-control required">
						@isset($answer_kbn)
							@foreach ($answer_kbn as $answer_kbn)							
								@if (($m4125['answer_kbn'] ?? 0) == $answer_kbn['number_cd'])
								<option value="{{$answer_kbn['number_cd']}}" selected>{{$answer_kbn['name']}}</option>
								@else
								<option value="{{$answer_kbn['number_cd']}}">{{$answer_kbn['name']}}</option>
								@endif
							@endforeach
						@endisset
					</select>
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
</div>


<div class="row {{($m4125['answer_kind'] ?? 1)==3?'':'d-none'}}" id='table-input'>
	<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-8" >
		<div class="table-responsive">
			<table class="table table-bordered table-hover table-striped" style="" id="table_data">
				<thead>
					<th class="text-center" style="width: 10%">{{__('rm0100.selection_code')}}</th>
					<th class="text-center" style="">{{__('rm0100.content')}}</th>
					<th class="text-center next-col" tabindex="8" style="width: 20px;">
						<button class="btn btn-rm blue btn-sm" id="add_new_row">
							<i class="fa fa-plus"></i>
						</button>
					</th>
				</thead>
				<tbody id='main'>
					@if (isset($m4126[0]))
						@foreach ($m4126 as $i => $m4126)
						<tr class="tr m4126">
							<td>
							<span class="num-length">
								<input type="hidden" class="grade_id" value="{{$i+1}}">
								<input type="hidden" class="detail_no" value="{{$m4126['detail_no'] ?? 0}}">
								<div type="text" class="text-center" tabindex="{{($i+1)*3-3+9}}" value="{{$m4126['detail_no'] ?? 0}}" maxlength="3" disabled>{{$m4126['detail_no'] ?? 0}}</div>
							</span>
							</td>
							<td>
								<span class="num-length">
									<input type="text" class="form-control input-sm grade_nm detail_name" tabindex="{{($i+1)*3-2+9}}" value="{{$m4126['detail_name'] ?? ''}}" maxlength="50">
								</span>
							</td>
							<td class="next-col" style="text-align: center;">
								<button class="btn btn-rm red btn-sm btn_remove" tabindex="{{($i+1)*3-1+9}}">
									<i class="fa fa-remove"></i>
								</button>
							</td>
						</tr>
						@endforeach
					@else
						@for ($i=1; $i< 2; $i++)
							<tr class="tr m4126">
								<td>
								<span class="num-length">
									<input type="hidden" class="grade_id" value="{{$i}}">
									<input type="hidden" class="detail_no" value="{{$i}}">
									<div type="text" class="text-center" tabindex="{{$i*3-3+9}}" value="" maxlength="3" disabled></div>
								</span>
								</td>
								<td>
									<span class="num-length">
										<input type="text" class="form-control input-sm grade_nm detail_name" tabindex="{{$i*3-2+9}}" value="" maxlength="50">
									</span>
								</td>
								<td class="next-col" style="text-align: center;">
									<button class="btn btn-rm red btn-sm btn_remove" tabindex="{{$i*3-1+9}}">
										<i class="fa fa-remove"></i>
									</button>
								</td>
							</tr>
						@endfor
					@endif
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="row justify-content-md-center">
	{!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
</div>
@section('asset_common')
<table class="d-none" id="table_row_add">
	<tbody class="">
		<tr>
            <td>
				<span class="num-length">
					<input type="hidden" class="grade_id">
					<input type="hidden" class="detail_no">
					<div disabled type="text" class="text-center" value="" maxlength="3" ></div>
				</span>
			</td>
			<td>
				<span class="num-length">
					<input type="text" class="form-control input-sm grade_nm detail_name" value="" maxlength="50">
				</span>
			</td>
			<td class="next-col" style="text-align: center;">
				<button class="btn btn-rm red btn-sm btn_remove">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
	</tbody>
</table><!-- /.hidden -->
@stop