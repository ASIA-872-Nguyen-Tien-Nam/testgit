<tbody>
<tr class="tr_generic_comment">
    <td class="text-center td-0">
        <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
            <i class="fa fa-remove"></i>
        </button>
    </td>
    <td class="text-center td-1 {{isset($data_single["company_cd"]) && $data_single['item_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['item_display_typ_1'] =='0'?'none':''}}">
        <input type="hidden" class="form-control mode_row" maxlength="3" value="A" tabindex="13">
        <input type="hidden" class="form-control item_no" maxlength="15" value="" tabindex="13">
        <span class="num-length ">
            <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="400" tabindex="13"></textarea>
        </span>
    </td>
    <td class="text-center td-2 {{isset($data_single["company_cd"]) && $data_single['item_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['item_display_typ_2'] =='0'?'none':''}}">
        <span class="num-length ">
            <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="400" tabindex="13"></textarea>
        </span>
    </td>
    <td class="text-center td-3 {{isset($data_single["company_cd"]) && $data_single['item_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['item_display_typ_3'] =='0'?'none':''}}">
        <span class="num-length ">
            <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="400" tabindex="13"></textarea>
        </span>
    </td>
    <td class="text-right td-4 {{isset($data_single["company_cd"]) && $data_single['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['weight_display_typ'] =='0'?'none':''}}">
        <span class="num-length">
            <div class="input-group-btn">
            <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" tabindex="13">
            <div class="input-group-append-btn icon-percent {{isset($data_single["company_cd"]) && $data_single['point_calculation_typ1'] == 2?'hidden':''}}">
                <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
            </div>
        </div>
        </span>
    </td>
    <td
        class="text-center td-62 {{isset($data_single["company_cd"]) && $data_single['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
        style="display: {{isset($data_single["company_cd"]) && $data_single['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
    >
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    {{-- 進捗コメント(項目別)非表示ボタン --}}
    <td
        class="text-center td-64 {{isset($data_single["company_cd"]) && $data_single['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"
        style="display: {{isset($data_single["company_cd"]) && $data_single['detail_progress_comment_display_typ'] =='0'?'none':''}}"
    >
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-6">
        <span class="num-length ">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-7 {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_0'] =='0'?'none':''}}"">
        <span class="num-length ">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-8 {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_1'] =='0'?'none':''}}"">
        <span class="num-length">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-9 {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_2'] =='0'?'none':''}}"">
        <span class="num-length ">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-10 {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_3'] =='0'?'none':''}}"">
        <span class="num-length ">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
    <td class="text-center td-11 {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{isset($data_single["company_cd"]) && $data_single['detail_comment_display_typ_4'] =='0'?'none':''}}"">
        <span class="num-length ">
            <input type="text" class="form-control" maxlength="15" disabled="disabled">
        </span>
    </td>
</tr>
</tbody>