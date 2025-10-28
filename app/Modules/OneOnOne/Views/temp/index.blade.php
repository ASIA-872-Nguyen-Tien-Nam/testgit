@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
@stop

@section('asset_footer')
    {!!public_url('template/js/common/template.js')!!}
@stop

@push('asset_button')
{!!
		Helper::buttonRender(['importButton'])
!!}
@endpush
@section('content')
<!-- START CONTENT -->
<div class="col-md-12">
    <div class="card card-danger">
        <div class="card-body">
          <p class="card-text">実施⽇が近づいています。実施前の記⼊欄を登録しましょう。<span>→ ⼊⼒欄へ進む</span></p>
        </div>
    </div>
    <div class="card box-search-card-common">
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5">
                    <h5 class="card-title">Card title</h5>
                </div>
                <div class="col-md-7 col-7">
                    <button type="button" class="btn  button-card"><span><i class="fa fa-chevron-down"></i></span>元に戻す</button>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-2 col-lg-2">
                    <div class="form-group">
                        <label class="control-label">⽇時 </label>
                        <div class="multi-select-full">
                            <div class="gflex">
                                <div class="input-group-btn input-group">
                                    <input type="text" class="form-control input-sm right-radius date" id="" placeholder="yyyy/mm/dd" value="2019/06/06" tabindex="-1">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1">
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label lb-required">Required Input </label>
                        <span class="num-length">
                            <input type="text" class="form-control required input-sm" tabindex="1" maxlength="20" id="" value="" />
                        </span>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Input normal</label>
                        <span class="num-length">
                            <input type="text" class="form-control " tabindex="1" maxlength="20" id="" value="" />
                        </span>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Input small</label>
                        <span class="num-length">
                            <input type="text" class="form-control form-control-sm" tabindex="1" maxlength="20" id="" value="" />
                        </span>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Input Popup Employee
                        </label>
                        <div class="input-group-btn input-group div_employee_cd  ">
                            <span class="num-length">
                            <input type='hidden' class="employee_cd_hidden" id="employee_cd" value="">
                            <input type="text" class="form-control indexTab employee_nm  Convert-Halfsize" id="" tabindex="3" maxlength="20" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_1on1" type="button" tabindex="-1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Button Dialog </label>
                        <button type="text" class="form-control btn  button-1on1 " tabindex="1" maxlength="20" id="test-dialog" value="">Dialog</button>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Select Large</label>
                        <select class="form-control form-control-lg select-commont-1on1">
                            <option>Large select</option>
                            <option>Large select</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Select Normal</label>
                        <select class="form-control select-commont-1on1">
                            <option>Normal select</option>
                            <option>Normal select</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Multi Select</label>
                        <div class="multi-select-full">
                            <select id="" tabindex="4" class="form-control select-commont-1on1 multiselect " multiple="multiple">
                                <option>Multi select</option>
                                <option>Multi select</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="form-group">
                        <label class="control-label">Select Small</label>
                        <select class="form-control form-control-sm select-commont-1on1">
                            <option>Small select</option>
                            <option>Small select</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
					<div class="form-group" >
						<label class="control-label">&nbsp;</label>
						<div class="input-group-btn input-group div_employee_cd">
							<div class="form-group text-right">
								<div class="full-width">
									<a href="javascript:;" id="btn_search" class="btn btn-outline-primary" tabindex="14">
										<i class="fa fa-search"></i>
										検索
									</a>
								</div><!-- end .full-width -->
							</div>
						</div>
					</div>
				</div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-4 col-lg-3 col-12">
                    <label>Custom Checkboxes</label>
                    <label class="container">ェックを⼊れる
                    <input type="checkbox" checked="checked">
                    <span class="checkmark"></span>
                    </label>
                    <label class="container">ェックを⼊れる
                    <input type="checkbox">
                    <span class="checkmark"></span>
                    </label>
                </div>
                <div class="col-md-4 col-lg-3 col-12">
                    <label>Custom Radio Buttons</label>
                    <label class="container">ェックを⼊れる
                    <input type="radio" name="radio">
                    <span class="checkradio"></span>
                    </label>
                    <label class="container">ェックを⼊れる
                    <input type="radio" name="radio">
                    <span class="checkradio"></span>
                    </label>
                </div>

            </div>
        </div>
        <hr />
        <div class="card-body">
            <h5>Table Header</h5>
            <div class="row">
                <div class="col-md-6 col-12">
                    @php
                        $data = array(
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員C',
                                '3'=>'6/17(水)',
                            ],
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員B',
                                '3'=>'6/8(月)',
                            ],
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                        )
                    @endphp
                    <div class="table-responsive-right table-responsive">
                        <table class="table table-bordered table-hover table-oneheader">
                            <thead>
                                <tr class="tr-table">
                                    <th style="text-align: left;" colspan="7">リマインド</th>
                                </tr>
                            </thead>
                            <tbody >
                                @foreach($data as $value2)
                                <tr class="list2">
                                    <td width="45%">
                                        {{$value2['1']}}
                                    </td>
                                    <td width="33.33%">
                                        {{$value2['2']}}
                                    </td>
                                    <td width="21.67%" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <h5>Table No Header</h5>
            <div class="row">
                <div class="col-md-6 col-12">
                    @php
                        $data = array(
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員C',
                                '3'=>'6/17(水)',
                            ],
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員B',
                                '3'=>'6/8(月)',
                            ],
                            [
                                '1'=>'1on1日程が決まりました。',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                        )
                    @endphp
                    <div class="table-responsive-right  table-responsive">
                        <table class="table table-bordered table-hover table-oneheader">
                            <tbody >
                                @foreach($data as $value2)
                                <tr class="list2">
                                    <td width="45%">
                                        {{$value2['1']}}
                                    </td>
                                    <td width="33.33%">
                                        {{$value2['2']}}
                                    </td>
                                    <td width="21.67%" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <h5>Table Scroll X</h5>
            <div class="row">
                <div class="col-md-12 col-12">
                    @php
                        $data = array(
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員C',
                                '3'=>'6/17(水)',
                            ],
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員B',
                                '3'=>'6/8(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                        )
                    @endphp
                    <div id="topTable" class="wmd-view sticky-table sticky-headers sticky-ltr-cells table-responsive-right table-responsive">
                        <table class="table table-bordered table-hover table-oneheader ofixed-boder" style="min-width:2500px">
                            <thead>
                                <tr class="tr-table">
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                </tr>
                            </thead>
                            <tbody >
                                @foreach($data as $value2)
                                <tr class="list2">
                                    <td width="500px">
                                        {{$value2['1']}}
                                    </td>
                                    <td width="500px">
                                        {{$value2['2']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <h5>Table Scroll Y</h5>
            <div class="row">
                <div class="col-md-12 col-12">
                    @php
                        $data = array(
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員C',
                                '3'=>'6/17(水)',
                            ],
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員B',
                                '3'=>'6/8(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                        )
                    @endphp
                    <div id="topTable" class="wmd-view table-responsive-right table-responsive" style="background-attachment: fixed;max-height: 214px;">
                        <table class="table table-bordered table-hover table-oneheader ofixed-boder">
                            <thead>
                                <tr class="">
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                </tr>
                            </thead>
                            <tbody >
                                @foreach($data as $value2)
                                <tr class="">
                                    <td >
                                        {{$value2['1']}}
                                    </td>
                                    <td >
                                        {{$value2['2']}}
                                    </td>
                                    <td  class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <h5>Table Scroll XY</h5>
            <div class="row">
                <div class="col-md-12 col-12">
                    @php
                        $data = array(
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員C',
                                '3'=>'6/17(水)',
                            ],
                            [
                                '1'=>'1on1日程が決ま。',
                                '2'=>'社員B',
                                '3'=>'6/8(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                            [
                                '1'=>'1on1日程が決ま',
                                '2'=>'社員A',
                                '3'=>'6/1(月)',
                            ],
                        )
                    @endphp
                    <div id="topTable" class="wmd-view table-responsive-right  table-responsive" style="background-attachment: fixed;max-height: 198px;">
                        <table class="table table-bordered table-hover  table-oneheader ofixed-boder" style="min-width:2500px">
                            <thead>
                                <tr class="tr-table">
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                    <th style="text-align: left;" >リマインド</th>
                                </tr>
                            </thead>
                            <tbody >
                                @foreach($data as $value2)
                                <tr class="list2">
                                    <td width="500px">
                                        {{$value2['1']}}
                                    </td>
                                    <td width="500px">
                                        {{$value2['2']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                    <td width="500px" class="borderRight">
                                        {{$value2['3']}}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div><!-- end .table-responsive -->
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <div class="row">
                <div class="col-md-1">
                    <div class="form-group">
                        <label class="control-label">Image</label>
                        <div class="text-center img-icon-common">
                            <img src="{!!public_url('uploads/ver1.7/icon/mirai_UI_2_05.png')!!}" class="rounded" alt="...">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label class="control-label">Hide/Show</label>
                        <span class="num-length">
                        <button type="button" class="btn  button-card" style="float:unset">
                            <span><i class="fa fa-chevron-right"></i></span>
                            元に戻す
                        </button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <hr />
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5">
                    <h5 class="card-title hide-card">実施詳細 <span><i class="fa fa-chevron-down i-body"></i></span></h5>
                </div>
            </div>
            <br>

            <div class="row">
                <div class="col-md-5 col-lg-4">
                    <div class="form-group">
                        <label class="control-label lb-required">時刻  </label>
                        <div class="input-group-btn">
                            <span class="num-length">
                                <input type="text" class="form-control required" tabindex="1" maxlength="20" id="" value="13:00 〜 13:30" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row justify-content-md-center">
                <div class="col-md-3 mt-3">
                {!! Helper::buttonRender1on1(['saveButton']) !!}
                </div>
                <div class="col-md-3 mt-3">
                {!! Helper::buttonRender1on1(['saveButton']) !!}
                </div>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5">
                    <h5 class="card-title">Form</h5>
                </div>
                <div class="col-md-7 col-7">
                    <button type="button" class="btn  button-card"><span><i class="fa fa-chevron-down"></i></span>元に戻す</button>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-5 col-lg-4">
                    <div class="form-group">
                        <h6>Required item - 1 line * icon </h6>
                        <label class="control-label lb-required">⽇時</label>
                        <div class="multi-select-full">
                            <div class="gflex">
                                <div class="input-group-btn input-group" style="width: 100%">
                                    <input type="text" class="form-control input-sm right-radius date required" id="start_date" placeholder="yyyy/mm/dd" value="2020年 11⽉ 30⽇（⽉）" tabindex="3">
                                    <div class="input-group-append-btn">
                                        <button class="btn btn-transparent button-date" type="button" data-dtp="dtp_JGtLk" tabindex="-1"></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <h6>Required item - 1 line * icon </h6>
                        <label class="control-label lb-required ">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂ 章は
                            ダミーで</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control required input-sm" tabindex="1" maxlength="20" id="" value="" />200⽂字以内で⼊⼒してください。
                            </textarea>
                        </span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <h6>Optional input ・ Multiple lines </h6>
                        <label class="control-label  ">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章は ダミ
                            ーで</label>
                        <span class="num-length">

                            <textarea type="text" class="form-control input-sm" tabindex="1" maxlength="20" id="" value="" />この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れ</textarea>
                        </span>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <h6>Impossible input ・ Multiple lines</h6>
                        <label class="control-label  ">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章は ダミ
                            ーで</label>
                        <span class="num-length">

                            <textarea type="text" class="form-control required input-sm" disabled tabindex="1" maxlength="20" id="" value="" />この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れ</textarea>
                        </span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <h6>Important item</h6>
                        <label class="control-label  label-itemimportant">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章は ダミ
                            ーで</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control  textarea-itemimportant"  tabindex="1" maxlength="20" id="" value="" />この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れ</textarea>
                        </span>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <h6 class="label-itemimportant"><span><i class="fa fa-twitch"></i> </span> 質問</h6>
                        <label class="control-label lb-required">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control required input-sm" tabindex="1" maxlength="20" id="" value="" />200⽂字以内で⼊⼒してください。</textarea>
                        </span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <h6>Important item</h6>
                        <label class="control-label  label-itemimportant">この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章は ダミ
                            ーで</label>
                        <span class="num-length">
                            <textarea type="text" class="form-control  textarea-itemimportant"  tabindex="1" maxlength="20" id="" value="" />この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れ</textarea>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5">
                    <h5 class="card-title">1on1実施前に記⼊</h5>
                </div>
                <div class="col-md-7 col-7">
                    <button type="button" class="btn  button-card"><span><i class="fa fa-chevron-down"></i></span>元に戻す</button>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-6 col-12">
                    <div class="form-group">
                        <label class="control-label label-itemimportant">WILL</label>
                        <span class="num-length">
                            <p>この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。
                                ⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。
                                この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。
                                テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキ
                                ストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキス
                                トが⼊ります。テキストが⼊ります。テキストが⼊ります。</p>
                        </span>
                    </div>
                </div>
                <div class="col-md-6 col-12">
                    <div class="form-group">
                        <label class="control-label label-itemimportant">CAN</label>
                        <span class="num-length">
                            <p>この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。
                                ⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。
                                この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。
                                テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキ
                                ストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキス
                                トが⼊ります。テキストが⼊ります。テキストが⼊ります。</p>
                        </span>
                    </div>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-6 col-12">
                    <div class="form-group">
                        <label class="control-label label-itemimportant">MUST</label>
                        <span class="num-length">
                            <p>この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。
                                ⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。
                                この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。
                                テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキ
                                ストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキス
                                トが⼊ります。テキストが⼊ります。テキストが⼊ります。</p>
                        </span>
                    </div>
                </div>
                <div class="col-md-6 col-12">
                    <div class="form-group">
                        <label class="control-label label-itemimportant">コーチからメンバーへの期待</label>
                        <span class="num-length">
                            <p>この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーで す。
                                ⽂字の⼤きさ、量、字間、⾏間等を確認するために⼊れています。この⽂章はダミーです。⽂字の⼤きさ、 量、字間、⾏間等を確認するために⼊れています。
                                この⽂章はダミーです。⽂字の⼤きさ、量、字間、⾏間等を確 テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。
                                テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキ
                                ストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキストが⼊ります。テキス
                                トが⼊ります。テキストが⼊ります。テキストが⼊ります。</p>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div> {{-- end card --}}
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-5 col-5">
                    <h5 class="card-title"><b>実施⼀覧</b></h5>
                </div>
                <div class="col-md-7 col-7">
                    <button type="button" class="btn  button-card"><span><i class="fa fa-chevron-down"></i></span>元に戻す</button>
                </div>
            </div>
            <br>
            <div class="row">
                <div class="col-md-12 col-sm-12 col-lg-6 col-12">
                    <div class="row">
                        <div class="col-md-2 col-lg-4 col-xl-3 col-12">
                            <div class="form-group">
                                <select class="form-control select-commont-1on1">
                                    <option>2020年度 </option>
                                    <option>2020年度 </option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4 col-lg-4 col-xl-3 col-12">
                            <div class="form-group">
                                <select class="form-control select-commont-1on1">
                                    <option>1-5回⽬</option>
                                    <option>1-5回⽬</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-5 col-lg-8 col-xl-3 col-12">
                            <div class="form-group">
                                <select class="form-control select-commont-1on1">
                                    <option>社員絞り込み</option>
                                    <option>社員絞り込み</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="card-body" style="width:100%">
                            <div class="row">
                                @php
                                    $data = array(
                                        [
                                            '1'=>'1on1日程が決ま。',
                                            '2'=>'社員C',
                                            '3'=>'6/17(水)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま。',
                                            '2'=>'社員B',
                                            '3'=>'6/8(月)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],
                                        [
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],[
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],[
                                            '1'=>'1on1日程が決ま',
                                            '2'=>'社員A',
                                            '3'=>'6/1(月)',
                                        ],
                                    )
                                @endphp
                                <div id="topTable" class="wmd-view table-responsive-right table-responsive" style="background-attachment: fixed;max-height: 400px;">
                                    <table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder" id="table-data-common">
                                        <thead>
                                            <tr class="">
                                                <th style="text-align: center;" ></th>
                                                <th style="text-align: center;" >1回⽬</th>
                                                <th style="text-align: center;" >2回⽬</th>
                                                <th style="text-align: center;" >3回⽬</th>
                                                <th style="text-align: center;" >4回⽬</th>
                                                <th style="text-align: center;" >5回⽬</th>
                                                <th style="text-align: center;" >6回⽬</th>
                                            </tr>
                                        </thead>
                                        <tbody >
                                            <tr class="">
                                                <th style="color:#fc933c">
                                                    <b>アンケート</b>
                                                </th>
                                                <td class="text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                                <td  class="borderRight text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                                <td  class="borderRight text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                                <td  class="borderRight text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                                <td  class="borderRight text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                                <td  class="borderRight text-center">
                                                    <button class="btn btn-transparent edit-content"></button>
                                                </td>
                                            </tr>
                                            @foreach($data as $value2)
                                            <tr class="">
                                                <th >
                                                    {{$value2['1']}}
                                                </th>
                                                <td >
                                                </td>
                                                <td  class="borderRight">
                                                </td>
                                                <td  class="borderRight">
                                                </td>
                                                <td  class="borderRight">
                                                </td>
                                                <td  class="borderRight">
                                                </td>
                                                <td  class="borderRight">
                                                </td>
                                            </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-12">
                    <div class="row">
                        <div class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-button-mobile">
                            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                            <p class="text-center">マイページ</p>
                        </div>
                        <div class="col-md-4 col-lg-3 col-xl-2 col-5 btn-odashboard margin-left-btn">
                            <img src={!!public_url('uploads/ver1.7/icon/mirai_UI-xd-(1)_10.png')!!}>
                            <p class="text-center">マイページ</p>
                        </div>
                    </div>
                    <br>
                    <br>
                    <h5 class="card-title"><b>1on1⽇程</b></h5>
                    <div class="row">
                        <div class="col-md-12 col-12 right-div-odashboard" >
                            <p><b>鈴⽊ ⼀郎さん</b></p>
                            <p class="margin-bottom-text">2020/11/30 13:00 〜 13:30</p>
                            <p>会議室 １</p>
                        </div>
                        <div class="col-md-12 col-12 right-div-odashboard margin-left-content">
                            <p><b>鈴⽊ ⼀郎さん</b></p>
                            <p class="margin-bottom-text">2020/11/30 13:00 〜 13:30</p>
                            <p>会議室 １</p>
                        </div>
                        <div class="col-md-12 col-12 right-div-odashboard margintop-content" >
                            <p><b>鈴⽊ ⼀郎さん</b></p>
                            <p class="margin-bottom-text">2020/11/30 13:00 〜 13:30</p>
                            <p>会議室 １</p>
                        </div>
                        <div class="col-md-12 col-12 right-div-odashboard margin-left-content margintop-content" >
                            <p><b>鈴⽊ ⼀郎さん</b></p>
                            <p class="margin-bottom-text">2020/11/30 13:00 〜 13:30</p>
                            <p>会議室 １</p>
                        </div>
                    </div>
                    <br>
                    <h5><b>リマインド</b></h5>
                    <div class="row">
                        <div class="col-md-12 col-12" style="padding-left:unset">
                            @php
                                $data = array(
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],
                                    [
                                        '1'=>'2020/11/30 13:00 〜 13:30 <span style="margin-left:15px;"><b>⽥中 ⼆郎 さん との 1on1⽇程が決まりました。</b></span>',
                                        '2'=>'社員C',
                                        '3'=>'6/17(水)',
                                    ],

                                )
                            @endphp
                            <div class="table-responsive-right  table-responsive">
                                <table class="table table-bordered table-cursor table-hover table-oneheader ofixed-boder">
                                    <tbody >
                                        @foreach($data as $value2)
                                        <tr class="">
                                            <td width="100%">
                                                {!! $value2['1'] !!}
                                            </td>
                                        </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div><!-- end .table-responsive -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> {{-- end card --}}
</div>
@stop