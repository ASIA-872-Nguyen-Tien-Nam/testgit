@extends('layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/form/i1020.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!!public_url('template/js/form/i1020.index.js')!!}
@stop

@push('asset_button')
{!!
Helper::buttonRender(['saveButton','copyButton','backButton'])
!!}
@endpush

@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card">
            <div class="card-body w-result-tabs">
                <div class="row" id="row-header">
                    <div class="col-auto col-fiscal-year">
                        <div class="form-group">
                            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.fiscal_year') }}</label>
                            <span class="num-length">
                                <select class="form-control required" id="fiscal_year" style="width: 90px;">
                                    @foreach($f0010 as $item)
                                        <option {{$fiscal==$item['fiscal_year']?'selected':''}} value="{{$item['fiscal_year']}}">
                                            {{$item['fiscal_year']}}
                                        </option>
                                    @endforeach
                                </select>
                            </span>
                        </div>
                    </div>
                    <div class="col-auto" hidden>
                        <div class="form-group">
                            <label class="control-label fill-label">&nbsp</label>
                            <div class="d-flex flex-row align-items-center gap-2 responsive-flex" style="gap: 10px;">
                                <button id="btn-evaluation-master-confirmation" class="btn btn-primary focusin" {{$btn??''}}>{{ __('ri1020.evaluation_master_confirmation') }}</button>
                                
                                <div id="cannot-be-changed"  {{$btn != ''?'':'hidden'}}>{{ __('ri1020.cannot_be_changed') }}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="prev_treatment" value=""></div>
                <div class="" id="tabs">
                @include('Master::i1020.refer')
                </div>
            </div><!-- end .card -->
        </div><!-- end .container-fluid -->
    </div>
@stop

@section('asset_common')
<table class="hidden" id="table-target-1">
    <tbody>
        <tr class="tr-main">
            <td scope="row" class="text-left w40">
                <input type="hidden" class="detail_no" value=""/>
                <select class="form-control input-sm required sheet_cd">
                    <option value="0">{{ __('messages.exclude') }}</option>
                </select>
            </td>
            <td class="">
                <span class="num-length">
                    <div class="input-group-btn">
                        <input type="text" class="form-control numeric weight" maxlength="3" max="100" min="0">
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent" type="button" disabled=""><i
                                        class="fa fa-percent"></i></button>
                        </div>
                    </div>
                </span>
            </td>
            <td class="text-center">
                <button class="btn btn-rm btn-sm btn-remove-row">
                    <i class="fa fa-remove"></i>
                </button>
            </td>
        </tr>
    </tbody>
</table>
     {{-- <input type="hidden" class="anti_tab" name=""> --}}
<div id="m0200_option" class="hidden">
    <option value="0">{{ __('messages.exclude') }}</option>
    @foreach($m0200 as $item)
        <option value="{{$item['sheet_cd']}}">{{$item['sheet_nm']}}</option>
    @endforeach
</div>
@stop