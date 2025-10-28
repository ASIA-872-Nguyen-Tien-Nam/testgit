@extends('popup')

@push('header')
{!!public_url('template/css/oneonone/oq2010/oq2010.index.css')!!}
@endpush

@section('asset_footer')
{!!public_url('template/js/popup/popup_oq2010.index.js')!!}
@stop

@section('content')
<div class="row mt-30">
    <div class="col-md-12">
        <div style="margin-bottom: 10px">
            <button type="button" class="btn btn-primary one-btn focusin" style="padding: 0;width: 38px;height: 38px;margin-right: 5px" id="move_up">
                <i class="fa fa-chevron-up"></i>
            </button>
            <button type="button" class="btn btn-primary one-btn focusin" style="padding: 0;width: 38px;height: 38px;" id="move_down">
                <i class="fa fa-chevron-down"></i>
            </button>
        </div>
        <div class="table-responsive table-popup" style="height:400px;margin-bottom: 15px ">
            <table class="table table-bordered table-hover ofixed-boder" style="max-width: 423px;height:300px" id="table_popup">
                <tbody id="main">
                    <tr class="tr_checkall active">
                        <td class="header" style="font-weight: 700">
                            <label for="ckb_all" class="lbl-text">
                                {{__('messages.select_all')}}
                            </label>
                        </td> 
                        <td class="text-center" style="width: 50px;background: #e5e5e5;">
                            <div class="md-checkbox-v2 inline-block lb">
                                <label for="ckb_all" class="container lbl-text">
                                    <input class="cb_focus" name="ckb_all" id="ckb_all" {{$chk_all==1?'checked':''}} type="checkbox" tabindex="1">
                                    <span class="checkmark"></span>
                                </label>
                            </div>
                        </td>
                    </tr>
                    @if (isset($list[0]))
                        @foreach ($list as $row)
                        <tr class="pop_tr active list_check_display">
                            <td class="multi-select-lb" style="font-size: 0.875rem;">
                                <div class="text-overfollow header-overfollow" data-container="body" style="width:340px;max-width: 340px !important;" data-toggle="tooltip" data-original-title="{{$row['item_nm']}}">
                                    {{$row['item_nm']}}
                                </div>
                                <input type="text" class="hidden item_cd" value="{{ $row['item_cd'] }}">
                                <input type="text" class="hidden order_no" value="{{ $row['order_no'] }}">
                            </td>
                            <td class="text-center" style="width: 50px">
                                <div class="md-checkbox-v2 inline-block lb">
                                    <label for="ckb_{{$row['item_cd']}}" class="container lbl-text">
                                        <input class="display_kbn checkbox_row" name="ckb_{{$row['item_cd']}}" id="ckb_{{$row['item_cd']}}"
                                        {{$row['display_kbn']==1?'checked':''}} type="checkbox" value="{{$row['display_kbn']}}" tabindex="1">
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    @endif
                </tbody>
            </table>
        </div>
        <!-- <div class="form-group text-right ">
            <div class="full-width">
                <a href="javascript:;" id="btn-save-popup" class="btn btn-outline-primary" tabindex="5">
                    <i class="fa fa-pencil-square-o"></i>
                    登録
                </a>
            </div>
        </div> -->
        <div class="row justify-content-md-center" style="margin-top: 10px;">
            {!!
            Helper::buttonRender1on1(['saveButtonSetup'])
            !!}
        </div>
    </div>
</div>
@stop
<input type="hidden" class="anti_tab" name="">
<input type="hidden" id="group_cd_1on1" value="{{$group_cd_1on1}}" />