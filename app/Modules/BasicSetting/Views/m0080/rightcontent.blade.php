<div class="row">
	<div class="col-md-8 col-lg-8 col-xl-8">
		<div class="form-group">
			<label class="control-label  lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.item_name') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="hidden" id="item_cd" value="{{isset($listm0080['item_cd'])? $listm0080['item_cd']:''}}">
					<input type="text" id="item_nm" class="form-control required item_nm" maxlength="20" value="{{isset($listm0080['item_nm'])? $listm0080['item_nm']:''}}" tabindex="1">
				</span>
			</div><!-- end .col-md-3 -->
		</div>
	</div>
	<div class="col-md-2 col-lg-2">
		<div class="form-group">
			<label class="control-label">{{ __('messages.sort_order') }}</label>
			<div style="padding-left: 0px">
				<span class="num-length">
					<input type="text" id="arrange_order" tabindex="2" class="form-control only-number" maxlength="3" value="{{isset($listm0080['arrange_order']) && $listm0080['arrange_order'] != 0 ? $listm0080['arrange_order']:''}}" />
				</span>
			</div>
		</div><!--/.form-group -->
	</div>
</div>
<div class="row">
	<div class="col-sm-12 col-md-12 col-lg-7 col-xl-6">
		<div class="row">
			<div class="col-md-8 col-lg-8 col-xl-4 select-width">
				<div class="form-group">
					<label class="control-label  lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.item_type') }}</label>
					<div style="padding-left: 0px">
						<span class="num-length">
							<select id="item_kind" class="form-control required item_kind" tabindex="3">
								<option value="-1"></option>
							@if(isset($library_19))
							@foreach($library_19 as $value)
								<option value={{$value['number_cd']}} {{isset($listm0080['item_kind']) && ($value['number_cd'] == $listm0080['item_kind']) ? 'selected':''}}>{{$value['name']}}</option>
							@endforeach
							@endif
							</select>
						</span>
					</div><!-- end .col-md-3 -->
				</div>
			</div>
			<div class="col-md-4 col-lg-4 col-xl-4 max_width_250">
				<div class="form-group">
					<label class="control-label {{isset($listm0080['item_kind']) && ($listm0080['item_kind'] ==1 || $listm0080['item_kind'] ==2) ? 'lb-required':''}}" id="item_digits_label" style="white-space: nowrap;" lb-required="必須">{{ __('messages.digit') }}</label>
					<div style="padding-left: 0px">
						<span class="num-length">
							<input type="text" id="item_digits" class="form-control  numeric {{isset($listm0080['item_kind']) && ($listm0080['item_kind'] ==1 || $listm0080['item_kind'] ==2) ? 'required':''}}"  {{isset($listm0080['item_kind']) && ($listm0080['item_kind'] ==4 || $listm0080['item_kind'] ==5 || $listm0080['item_kind'] ==3) ? 'readonly':''}} maxlength="3" value="{{isset($listm0080['item_digits']) && $listm0080['item_digits'] != 0 ? $listm0080['item_digits']:''}}" tabindex={{isset($listm0080['item_kind']) && ($listm0080['item_kind'] ==4 || $listm0080['item_kind'] ==5 || $listm0080['item_kind'] ==3) ? -1:3}}/>
						</span>
					</div>
				</div><!--/.form-group -->
			</div>
		</div>
		<div class="row">
			<div class="col-sm-6 col-md-6 col-lg-6 col-xl-6 select-width2" style="margin-bottom: 12px;">
				<div class="form-group">
					<label class="control-label " style="white-space: nowrap;">{{ __('messages.display_division') }}</label>
					<div style="padding-left: 0px">
						<span class="num-length">
							<select id="item_display_kbn" tabindex="5" class="form-control ">
								<option {{isset($listm0080['item_display_kbn']) && (0 == $listm0080['item_display_kbn']) ? 'selected':''}} value="0">{{ __('messages.hide') }}</option>
								<option {{isset($listm0080['item_display_kbn']) && (1 == $listm0080['item_display_kbn']) ? 'selected':''}} value="1">{{ __('messages.display') }}</option>
							</select>
						</span>
					</div><!-- end .col-md-3 -->
				</div>
			</div>
			<div class="check-check-box" >
				<div class="form-group">
					<label class="control-label">&nbsp;</label>
	                <div class="checkbox" style="line-height: unset; padding-left:10px">
	                    <div class="md-checkbox-v2">
	                        <input name="search_item_kbn" id="search_item_kbn" {{isset($listm0080['search_item_kbn']) && (1 == $listm0080['search_item_kbn']) ? 'checked':''}} type="checkbox" tabindex="6" value="1" >
	                        <label for="search_item_kbn">{{ __('messages.include_search_condition_m0080') }}</label>
	                    </div>
	                </div>
				</div><!--/.form-group -->
			</div>
		</div>
		<div class="row {{(isset($listm0080['item_kind']) &&  ($listm0080['item_kind'] ==4 || $listm0080['item_kind'] == 5)) ?'':'hidden'}}" id="row-table-one">
			<div class="col-sm-12 col-md-12">
                <div class="wmd-view table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells" style="max-height: 337px;overflow-y: auto">
                    <table class="table table-bordered table-hover table-striped table-data fixed-header" id="table-data">
                        <thead>
                        <tr>
                            <th class="text-center" style="width: 80px;">{{ __('messages.code') }}</th>
                            <th class="text-center" >{{ __('messages.content') }}</th>
                            <th style="width: 10px;">
                                <button class="btn btn-rm blue btn-sm" id="btn-add-new-row" tabindex="6">
                                    <i class="fa fa-plus"></i>
                                </button>
                            </th>
                        </tr>
                        </thead>
                        <tbody id='main'>
                            @if (!empty($listm0081))
                            @foreach ($listm0081 as $listmxt)
                            <tr class="tr choice_field">
                                <td> 
                                	<span class="num-length">
                                        <input type="text" tabindex="6" class="form-control input-sm detail_no required numeric" maxlength="3" value="{{isset($listmxt['detail_no'])?$listmxt['detail_no']:''}}">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input tabindex="6" type="text" class="form-control input-sm text-left  detail_nm required" maxlength="50" value="{{isset($listmxt['detail_name'])?$listmxt['detail_name']:''}}" >
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button tabindex="6" class="btn btn-rm btn-sm btn-remove-row">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            </tr>
                            @endforeach
                            @else
                            <tr class="tr choice_field">
                                <td>
                                    <span class="num-length">
                                        <input tabindex="6" type="text" class="form-control input-sm challenge_level_nm required detail_no numeric" maxlength="3">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input tabindex="6" type="text" class="form-control input-sm text-left  explanation required detail_nm" maxlength="50"  >
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button  tabindex="6" class="btn btn-rm btn-sm btn-remove-row">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            </tr>
                            @endif
                        </tbody>
                    </table>
                </div><!-- end .table-responsive -->
			</div>
		</div>
	</div>
	<div class="col-md-0 col-lg-1 col-xl-2">
	</div>
	{{-- div-left-right --}}
	<div class="col-md-12 col-lg-4 col-xl-4">
		<div class="row">
			<div class="col-md-12">
				<div class="form-group" style="margin-bottom:0px;">
					<label class="control-label ">{{ __('messages.viewable_authority') }}</label>
					<div class="checkbox" style="padding-left: 10px;line-height: unset">
	                    <div class="md-checkbox-v2">
	                        <input name="rater_browsing_kbn" id="rater_browsing_kbn" {{isset($listm0080['rater_browsing_kbn']) && (1 == $listm0080['rater_browsing_kbn']) ? 'checked':''}} type="checkbox" tabindex="4" value="1" >
	                        <label for="rater_browsing_kbn">{{ __('messages.rater_can_view') }}</label>
	                    </div>
	                </div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="form-group ">
					<label class="control-label ">{{ __('messages.persons_can_view') }}</label>
					<div class="col-sm-12 col-md-12">
		                <div class="table-responsive" style="overflow-x: unset;height: 405px;width: 100%;overflow-y: auto;overflow-x: hidden">
		                    <table class="table table-bordered table-hover table-striped " id="table-data-right">
		                        <thead>
		                        <tr>
		                        </tr>
		                        </thead>
		                        <tbody>
		                            @if ( !empty($list_authority))
		                            @foreach ($list_authority as $key => $list_aut)

		                            <tr class="tr browsing_setting">
		                            	<td>
		                                    <span class="num-length">
		                                        <input type="hidden" class="form-control challenge_level">
	                        					<div class="checkbox" style="padding-left: 10px;line-height: unset">
								                    <div class="md-checkbox-v2" style="text-align: center;">
								                        <input class="chk" {{isset($list_aut['browsing_kbn']) && $list_aut['browsing_kbn'] == 1 ? 'checked' : '' }} type="checkbox" tabindex="8" value="1" name={{'checkbox'.$key}} id={{'checkbox'.$key}}>
								                        <label  style="margin-bottom: 0px" for={{'checkbox'.$key}}></label>
								                    </div>
								                </div>
		                                    </span>
		                                </td>
		                                <td >
		                                    <span class="num-length text-overflow span-width" data-toggle="tooltip" data-original-title="{{isset($list_aut['authority_nm'])?$list_aut['authority_nm']:''}}">
		                                        <input type="text" class="form-control hidden challenge_level authority_cd " value="{{isset($list_aut['authority_cd'])?$list_aut['authority_cd']:''}}">
		                                     {{isset($list_aut['authority_nm'])?$list_aut['authority_nm']:''}}
		                                    </span>
		                                </td>
		                            </tr>
		                            @endforeach
		                            @else
		                            <tr class="tr">
		                                <td>
		                                    <span class="num-length">
		                                        <input type="hidden" class="form-control challenge_level">
	                        					<div class="checkbox" style="padding-left: 10px;">
								                    <div class="md-checkbox-v2" style="text-align: center;">
								                        <input name="ck111" id="ck_search" type="checkbox" tabindex="8" value="1" >
								                        <label for="ck_search" style="margin-bottom: 0px"></label>
								                    </div>
								                </div>
		                                    </span>
		                                </td>
		                                <td>
		                                    <span class="num-length">
		                                        
		                                    </span>
		                                </td>
		                            </tr>
		                            @endif
		                        </tbody>
		                    </table>
		                </div><!-- end .table-responsive -->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@section('asset_common')
<table class="hidden" id="table_row_add">
	<tbody class="">
		<tr class="tr">
            <td>
				<span class="num-length">
					<input type="text" tabindex="6" class="form-control input-sm numeric required detail_no" maxlength="3">
				</span>
			</td>
			<td>
				<span class="num-length">
					<input type="text" tabindex="6" class="form-control input-sm required detail_nm"  maxlength="50">
				</span>
			</td>
			<td class="next-col" style="text-align: center;">
				<button tabindex="6" class="btn btn-rm red btn-sm btn-remove-row">
					<i class="fa fa-remove"></i>
				</button>
			</td>
		</tr>
	</tbody>
</table><!-- /.hidden -->
@stop