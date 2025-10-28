@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/i2040.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/pop_i2040.index.js')!!}
@stop

@section('content')

		<div class="text-center hid">
		</div>
		<div id="collapseExample" class="collapse show">
			<div class="" style="margin-bottom: 10px">
				<button type="button" class="btn btn-primary  " style="padding: 5px;margin-right: 5px" id="move_up">
					<i class="fa fa-chevron-up"></i>
				</button>
				<button type="button" class="btn btn-primary  " style="padding: 5px;" id="move_down">
					<i class="fa fa-chevron-down"></i>
				</button>
			</div><!-- end .row -->
			<div class="">
				<div class="table-responsive" style="height:400px;margin-bottom: 15px " >
						<table class="table table-bordered table-hover table-striped" style="width: 100%;height:300px" id="table_data">
							<tbody id='main'>
								<tr class=" tr_checkall">
	                                    <td style="font-weight: 700">
	                                    	{{ __('messages.select_all') }}
	                                    </td>
										<td class="text-center" style="width: 50px">
											<div class="md-checkbox-v2 inline-block lb">
									            <input class="" name="ckb_all" id="ckb_all"  type="checkbox">
									            <label for="ckb_all"></label>
									        </div>
						                </td>
									</tr>
								@foreach($data as $dt)
									<tr class="pop_tr">
	                                    <td>
	                                    	{{$dt['item_nm']}}
	                                    	<input type="text" class='hidden item_cd' value="{{$dt['item_cd']}}" />
	                                    	<input type="text" class='hidden order_no' value="{{$dt['order_no']}}" />
	                                    </td>
										{{-- <td class="next-col" style="text-align: center;width: 50px">
											<div class="md-checkbox-v2">
									            <input class="chk form-control display_kbn" name="{{$dt['item_cd']}}"  type="checkbox"  {{$dt['display_kbn'] == 1? 'checked':''}} tabindex="5" value="{{$dt['display_kbn']}} ">
									            <label data-toggle="tooltip" for="{{$dt['item_cd']}}" class="m-0 text-overflow" ></label>
									        </div>
										</td> --}}
										<td class="text-center" style="width: 50px">
											<div class="md-checkbox-v2 inline-block lb">
									            <input class="display_kbn checkbox_row" name="ckb{{$dt['item_cd']}}" id="ckb{{$dt['item_cd']}}" {{$dt['display_kbn'] == 1? 'checked':''}} type="checkbox" value="{{$dt['display_kbn']}} ">
									            <label for="ckb{{$dt['item_cd']}}"></label>
									        </div>
						                </td>
									</tr>
								@endforeach
							</tbody>
						</table>
					</div>
				<div class="">
					<div class="form-group text-right ">
						<div class="full-width">
							<a href="javascript:;" id="btn-save-popup" class="btn btn-outline-primary" tabindex="5">
								<i class="fa fa-pencil-square-o"></i>
								{{ __('messages.register') }}
							</a>
						</div><!-- end .full-width -->
					</div>
				</div>
			</div>
		</div>


@stop
