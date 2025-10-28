<thead>
    <tr>
        <th class="th-total">
            <button class="btn btn-rm blue btn-sm" id="btn-add-new-row" tabindex="13">
                <i class="fa fa-plus"></i>
            </button>
        </th>
        <th class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_1'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="num-length ics-textbox">
                        <input type="text" style="min-width:205px" id="item_title_1" maxlength="20" class="form-control form-control-sm" value="{{isset($arrDataHeader["company_cd"])?$arrDataHeader['item_title_1']:__('messages.large_classification') }}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" id="item_display_typ_1" class="ics ics-edit" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                    </a>
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-6" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_2'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="num-length ics-textbox">
                        <input type="text" style="min-width:205px" id="item_title_2" maxlength="20" class="form-control form-control-sm" value="{{isset($arrDataHeader["company_cd"])?$arrDataHeader['item_title_2']:__('messages.middle_classification')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" id="item_display_typ_2" class="ics ics-edit" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                    </a>
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-7" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_3'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="num-length ics-textbox">
                        <input type="text" style="min-width:205px" id="item_title_3" maxlength="20" class="form-control form-control-sm" value="{{isset($arrDataHeader["company_cd"])?$arrDataHeader['item_title_3']:__('messages.minor_classification')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" id="item_display_typ_3" class="ics ics-edit" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                    </a>
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-8" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        {{-- ウェイト --}}
        <th class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['weight_display_typ'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input type="text" style="min-width:70px" id="weight_display_typ" class="form-control form-control-sm" value="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['point_calculation_typ1'] == '2'?__('messages.coefficient'):__('messages.weight')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-9" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        {{-- 自己進捗コメント(項目別)非表示ボタン --}}
        <th
            id="detail_self_progress_comment_display_typ"
            number="4"
            class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_self_progress_comment_display_typ']==0?'ics-hide':''}}"
            style="min-width:205px;{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_self_progress_comment_display_typ']==0?'display:none':''}}
        ">
            <div class="d-flex justify-content-between">
                <span class="ics-textbox num-length">
                    <input type="text" id="detail_self_progress_comment_title" class="form-control form-control-sm" value="{{isset($arrDataHeader["company_cd"])?$arrDataHeader['detail_self_progress_comment_title']:__('messages.self_progress_comment_m0170')}}" readonly="" tabindex="-1" style="min-width:205px;" maxlength="50">
                </span>
                <div class="ics-group">
                    <a href="javascript:;" id="detail_self_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                    </a>
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-62" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        {{-- 進捗コメント(項目別)非表示ボタン --}}
        <th
            id="detail_progress_comment_display_typ"
            class="th-total {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
            style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_progress_comment_display_typ'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                <span class="ics-textbox num-length">
                    <input
                        id="detail_progress_comment_title"
                        type="text"
                        style="min-width:205px"
                        class="form-control form-control-sm"
                        value="{{isset($arrDataHeader["company_cd"])?$arrDataHeader['detail_progress_comment_title']:__('messages.evaluator_progress_comments_m0170')}}"
                        readonly=""
                        tabindex="-1"
                        maxlength="50"
                    />
                </span>
                <div class="ics-group">
                    <a href="javascript:;" id="detail_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                    </a>
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-64" tabindex="-1">
                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        {{-- 評価 --}}
        <th number="5">
     
            <div class="d-flex justify-content-between">
                <span class="ics-textbox">
                    <input type="text" style="min-width:100px;" id="evaluation_display_typ" class="form-control form-control-sm" value="{{__('messages.evaluator')}}" readonly="readonly" tabindex="-1">
                </span>
            </div>
        </th>
        <th class="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
            style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_0'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_0" value="1" tabindex="-1"/>
                    <input type="text" style="min-width:115px"
                            class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}"
                            readonly="" tabindex="-1">
                </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_1'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input type="text" style="min-width:205px" id="detail_comment_display_typ_1" class="form-control form-control-sm" value="{{__('messages.1st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_2'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input type="text" style="min-width:205px" id="detail_comment_display_typ_2" class="form-control form-control-sm" value="{{__('messages.2st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_3'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input type="text" style="min-width:205px" id="detail_comment_display_typ_3" class="form-control form-control-sm" value="{{__('messages.3st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <th class="{{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_4'] =='0'?'none':''}}">
            <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input type="text" style="min-width:205px" id="detail_comment_display_typ_4" class="form-control form-control-sm" value="{{__('messages.4st_rater_s_comment')}}" readonly="readonly" tabindex="-1">
                    </span>
                <div class="ics-group">
                    <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                        <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
    </tr>
</thead>
<tbody>
@foreach($data_import as $row)
    <input type="hidden" id="mode_import" value="csv"/>
    <tr class="tr_generic_comment">
        <td class="text-center td-0">
            <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                <i class="fa fa-remove"></i>
            </button>
        </td>
        <td class="text-center td-1 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_1'] =='0'?'none':''}}">
            <input type="hidden" class="form-control mode_row" maxlength="1" value="A">
            <input type="hidden" class="form-control item_no" maxlength="3" value="{{$row['item_no']}}">
        <span class="num-length">
            <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_1']}}</textarea>
        </span>
        </td>
        <td class="text-center td-2 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_2'] =='0'?'none':''}}">
        <span class="num-length">
            <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_2']}}</textarea>
        </span>
        </td>
        <td class="text-center td-3 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['item_display_typ_3'] =='0'?'none':''}}">
        <span class="num-length ">
            <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13">{{$row['item_detail_3']}}</textarea>
        </span>
        </td>
        {{-- ウェイト --}}
        <td class="text-right td-4 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['weight_display_typ'] =='0'?'none':''}}">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" value="{{is_numeric($row['weight'])?$row['weight']:''}}" tabindex="13">
                    <div class="input-group-append-btn icon-percent {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['point_calculation_typ1'] == '2'?'hidden':''}}">
                        <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                    </div>
                </div>
            </span>
        </td>
        {{-- 自己進捗コメント(項目別)非表示ボタン --}}
        <td
            class="text-center td-62 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
            style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
        >
            <span class="num-length">
                <input type="text" class="form-control" maxlength="15" disabled="disabled">
            </span>
        </td>
        {{-- 進捗コメント(項目別)非表示ボタン --}}
        <td
            class="text-center td-64 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
            style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_progress_comment_display_typ'] =='0'?'none':''}}"
        >
            <span class="num-length">
                <input type="text" class="form-control" maxlength="15" disabled="disabled">
            </span>
        </td>
        {{-- 評価 --}}
        <td class="text-center td-6">
            <span class="num-length ">
                <input type="text" class="form-control" maxlength="2" disabled="disabled">
            </span>
        </td>
        {{-- 自己評価コメント --}}
        <td class="text-center td-7 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}"
            style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_0'] =='0'?'none':''}}">
            <span class="num-length">
                <input type="text" class="form-control" maxlength="15" disabled="disabled">
            </span>
        </td>
        <td class="text-center td-8 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_1'] =='0'?'none':''}}">
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
        </td>
        <td class="text-center td-9 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_2'] =='0'?'none':''}}">
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
        </td>
        <td class="text-center td-10 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_3'] =='0'?'none':''}}">
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
        </td>
        <td class="text-center td-11 {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{isset($arrDataHeader["company_cd"]) && $arrDataHeader['detail_comment_display_typ_4'] =='0'?'none':''}}">
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
        </td>
    </tr>
    @endforeach
    <tr id="tr-total">
        <td colspan="4" class="baffbo" id="td-colspan">
        </td>
        <th  class="ba55 text-left togcol">
            <div class="d-flex justify-content-between">
                <span class="ics-textbox " style="white-space: nowrap"  id="text_total_score_display_typ" >{{__('messages.total_points')}}</span>
                <div class="ics-group">
                    <a href="javascript:;" id="total_score_display_typ" class="ics ics-eye-total" data-target=".td-1">
                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                    </a>
                </div><!-- end .ics-group -->
            </div>
        </th>
        <td class="baffbo"></td>
        <td class="baffbo"></td>
    </tr>
</tbody>