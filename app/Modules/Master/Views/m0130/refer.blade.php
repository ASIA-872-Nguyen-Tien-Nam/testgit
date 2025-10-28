@if(!empty($result))
    @foreach($result as $item)
        <tr class="list_data">
            <td class="th-rank">
				<span class="num-length">
					<input type="hidden" class="form-control input-sm rank_cd" maxlength="3" value="{{isset($item['rank_cd'])?$item['rank_cd']:''}}" />
					<input type="text" class="form-control input-sm rank_nm required" maxlength="10" value="{{isset($item['rank_nm'])?$item['rank_nm']:''}}" />
				</span>
            </td>
            <td class="td-none" style="border-right: none">
                <span class="num-length">
                    <input type="tel" class="form-control numeric points_from td-from" decimal="2" maxlength="6" negative="true" value="{{isset($item['points_from'])?$item['points_from']:''}}"/>
                </span>
            </td>
            <td class="text-center" style="width: 120px; border-right: none; border-left: none">
            {{ __('messages.more_than') }}
            </td>
            <td class="td-none" style="border-left: none; border-right: none;">
                <span class="num-length">
                    <input type="tel" class="form-control numeric points_to td-to" decimal="2" maxlength="6" negative="true" value="{{isset($item['points_to'])?$item['points_to']:''}}"/>
                </span>
            </td>
            <td class="text-center" style="width: 140px; border-right: none; border-left: none">
            {{ __('messages.less_than') }}
            </td>
            <td class="text-center">
                <button class="btn btn-rm btn-sm btn-remove-row">
                    <i class="fa fa-remove"></i>
                </button>
            </td>
        </tr>
    @endforeach
@else
    <tr class="list_data">
        <td>
            <span class="num-length">
                <input type="hidden" class="form-control input-sm rank_cd" maxlength="3" value=""/>
                <input type="text" class="form-control input-sm rank_nm required" maxlength="10" value=""/>
            </span>
        </td>
        <td class="td-none" style="border-right: none ;width: 170px;">
            <span class="num-length">
                <input type="tel" class="form-control numeric points_from td-from" decimal="2" maxlength="6" negative="true" value=""/>
            </span>
        </td>
        <td class="text-center" style="width: 120px; border-right: none; border-left: none">
        {{ __('messages.more_than') }}
        </td>
        <td class="td-none" style="border-left: none; border-right: none;width: 170px;">
            <span class="num-length">
                <input type="tel" s class="form-control numeric points_to td-to" decimal="2" maxlength="6" negative="true" value=""/>
            </span>
        </td>
        <td class="text-center" style="width: 140px; border-right: none; border-left: none">
        {{ __('messages.less_than') }}
        </td>
        <td class="text-center">
            <button class="btn btn-rm btn-sm btn-remove-row">
                <i class="fa fa-remove"></i>
            </button>
        </td>
    </tr>
@endif