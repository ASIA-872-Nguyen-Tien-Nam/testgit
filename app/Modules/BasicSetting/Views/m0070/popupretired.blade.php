@extends('popup')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/basicsetting/m0070/m0070.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/basicsetting/m0070/popup_m0070.js')!!}
@stop

@section('content')
    @php
		$auth = session_data();
	@endphp
        <div class="language" value="{{$auth->language??'en'}}"></div>
		<div class="text-center hid">
		</div>
		<div id="collapseExample" class="collapse show">
                <div class="card calHe inner" >
                    <div class="card-body">
                        <div class="row">
                        <input type="text" class="hidden" id="selected_employee_cd" value="{{$employee_cd??0}}">
                            <div class="col-xs-8 col-md-col3">
                                <div class="form-group">
                                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}" style="white-space: nowrap;width: 270px;">{{ __('messages.retire_date') }}
                                    </label>
                                    <div class="input-group-btn input-group ">
                                    <input type="text" id="company_out_dt" value="{{$condition['company_out_dt']??''}}" class="form-control  date  required" placeholder="yyyy/mm/dd" tabindex="14" >
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_wH14i" tabindex="-1" style="background: none !important"><i class="fa fa-calendar"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6 col-md-2">
                                <div class="form-group">
                                    <label class="control-label">{{ __("messages.retire_s_reason") }}&nbsp;
                                    </label>
                                    <select name="" id="retirement_reason_typ" class="form-control " tabindex="20">
                                        <option value="0"></option>
                                        @foreach($L0010 as $dt)
                                            <option value='{{$dt['number_cd']}}' {{$dt['number_cd'] == ($condition['retirement_reason_typ']??'') ? 'selected' : ''}}>{{$dt['name']}}</option>
                                        @endforeach
                                    </select>
                                </div>
                                <!--/.form-group -->
                            </div>
                            <div class="col-xs-6 col-md-10">
                                <div class="form-group">
                                    <label class="control-label">&nbsp;
                                    </label>
                                    <span class="num-length">
                                        <input type="text" id="retirement_reason" class="form-control" maxlength="50" value="{{$condition['retirement_reason']??''}}">
                                    </span>
                                </div>
                                <!--/.form-group -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card calHe inner" style="max-height: 260px;overflow-y: scroll;">
                    <div class="card-body">
                        <div class="col-md-12" style="margin-bottom: 10px">
                        {{ __('messages.del_evaluation') }}
                        </div>
                        <div class="col-md-12" id="data-table">
                            @include('BasicSetting::m0070.popupRetiredRefer')
                        </div>
                    </div>
            </div>
            <div class="">
                <div class="form-group text-right " style="display: flex; float: right;">
                    <div class="" style="margin-right:10px">
                        <a href="javascript:;" id="btn-save-popup" class="btn btn-outline-primary" {{$disable_status == 0?'disabled':''}} tabindex="5">
                            <i class="fa fa-pencil-square-o"></i>
                            {{ __('messages.register') }}
                        </a>
                    </div><!-- end . -->
                    <div class="">
                        <a href="javascript:;" id="btn-cancel" class="btn btn-outline-primary"  tabindex="5">
                            <i class="fa fa-reply"></i>
                            {{ __('messages.cancel') }}
                            <!-- 取消 -->
                        </a>
                    </div><!-- end . -->
                </div>
            </div>
		</div>
@stop
