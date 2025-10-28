@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/popup_formation.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/popup/popup_information.index.js')!!}
@stop

@section('content')
<div class="card">
	<div class="card-body search-condition">
		<div class="text-center hid">
			<a href="javascript:void(0)" data-toggle="collapse" data-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample" style="font-size: 25px;" tabindex="-1">
				<i class="fa fa-caret-up" aria-hidden="true"></i>
				<i class="fa fa-caret-down" aria-hidden="true"></i>
			</a>
		</div>
		<div id="collapseExample" class="collapse show">
			<input type="hidden" class="anti_tab" name="">
			<div class="row row-margin-top">
				<div class="col-md-6 col-xl-4 ">
					<div class="form-group">
						<label class="control-label">{{__('messages.notice_period')}}</label>
					<div class="flex">	
							<div class="input-group-btn input-group input-1" style="">
								<span class="num-length">
									<input type="text" id="infomation_date_from" class="form-control input-sm date right-radius infomation_date_from" placeholder="yyyy/mm/dd" maxlength="10" value="{{$cache['infomation_date_from']??''}}"  tabindex="1">
									<div class="input-group-append-btn">
										<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-calendar"></i></button>
									</div>
								</span>
							</div>
							<div class="span-symbol">~</div>
							<div class="input-group-btn input-group input-1" style="">
								<span class="num-length">
									<input type="text" id="infomation_date_to" class="form-control input-sm date right-radius infomation_date_to" placeholder="yyyy/mm/dd" maxlength="10" value="{{$cache['infomation_date_to']??''}}"  tabindex="2">
									<div class="input-group-append-btn">
										<button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-calendar"></i></button>
									</div>
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-4 col-xl-6">
					<div class="form-group">
						<label class="control-label">{{__('messages.title')}}</label>
						<span class="num-length">
							<input type="tel" id="infomation_title" class="form-control" maxlength="50" placeholder="{{__('messages.search_by_title')}}"  value="{{$cache['infomation_title']??''}}"  tabindex="3">
						</span>
					</div>
				</div>
				<div class="col-md-2 col-xl-2">
					<div class="form-group margin-top7">
						<label class="control-label"></label>
						<div class="md-checkbox-v2 checkbox-top">
        				    <input name="confirmation_datetime_flg" id="confirmation_datetime_flg"  value="" type="checkbox" {{isset($cache['confirmation_datetime_flg'])&&$cache['confirmation_datetime_flg']==1?'checked':''}}  tabindex="4">
        				    <label for="confirmation_datetime_flg" style="margin: 0;" class="lbl-text">&nbsp;{{__('messages.unread_only')}}</label>
        				</div>
					</div>
				</div>
			</div> <!-- end .row -->
			<div class="row">
				<div class="col-md-12">
					<div class="form-group text-right ">
						<div class="full-width">
							<a href="javascript:;" id="btn-search" class="btn btn-outline-primary" tabindex="5">
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
<div id="result" class="card">
	@include('Common::popup.search_information')
</div> <!-- end .card -->

@stop
