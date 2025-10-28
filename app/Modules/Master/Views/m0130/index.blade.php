@extends('layout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/common/master.css') !!}
    {!! public_url('template/css/form/m0130.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!!public_url('template/js/form/m0130.index.js')!!}
@stop
@push('asset_button')
    {!!
    Helper::buttonRender(['saveButton' , 'deleteButton' , 'backButton'])
    !!}
@endpush
@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  'Evaluation Remarks';
    else
        return  $message;
	}
	@endphp
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid" >
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-xl-8 col-lg-10">
                <div class="form-group" style="padding: 0 10px;margin-top: 1rem;">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.treatment_use') }}</label>
                    <select id="detail_no" class="form-control required">
                        <option value="-1"></option>
                        @foreach ($combobox as $v)
                        <option value="{{$v['detail_no']}}">{{$v['treatment_applications_nm']}}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        </div>
        <div class="col-xs-12 col-md-12">
            <div class="card calHe">
                <div class="col-12 col-sm-12 col-md-12 col-lg-10 col-xl-8 card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover table-striped " id="table-data">
                            <thead>
                            <tr>
                                <th class="th-rank">{{year_english(__('messages.rank'))}}</th>
                                <th colspan="4">{{ __('messages.score_range') }}</th>
                                <th style="width: 3%">
                                    <button class="btn btn-rm blue btn-sm" id="btn-add-new-row">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </th>
                            </tr>
                            </thead>
                            <tbody id="data-refer">
                                @include('Master::M0130.refer')
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div><!-- end .card-body -->
            </div><!-- end .card -->

        </div>
    </div><!-- end .container-fluid -->
@stop
@section('asset_common')
    <table class="hidden" id="table-target">
        <tbody>
        <tr class="">
            <td>
                <span class="num-length">
                    <input type="hidden" class="form-control input-sm rank_cd" maxlength="3" value="" />
                    <input type="text" class="form-control input-sm rank_nm required" maxlength="10" value="" />
                </span>
            </td>
            <td class="td-none" style="border-right: none">
                <span class="num-length">
                    <input type="tel" class="form-control numeric points_from td-from" maxlength="6" decimal="2" negative="true" value=""/>
                </span>
            </td>
            <td class="text-center" style="width: 50px; border-right: none; border-left: none">
                {{__('messages.more_than')}}
            </td>
            <td class="td-none" style="border-left: none; border-right: none;">
                <span class="num-length">
                    <input type="tel" class="form-control numeric points_to td-to" maxlength="6" decimal="2" negative="true" value=""/>
                </span>
            </td>
            <td class="text-center" style="width: 50px; border-right: none; border-left: none">
            {{__('messages.less_than')}}
            </td>
            <td class="text-center">
                <button class="btn btn-rm btn-sm btn-remove-row">
                    <i class="fa fa-remove"></i>
                </button>
            </td>
        </tr>
        </tbody>
    </table><!-- /.hidden -->
@stop