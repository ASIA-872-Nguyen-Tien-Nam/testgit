<div id="topTable" class="wmd-view table-responsive " style="margin-bottom:10px">
    <table class="table table-bordered table-hover table-striped fixed-header outline-none table_sort"
        style="min-width: 840px;margin-top: 0!important;" id="myTable">
        <thead>
            <tr>
                <th class="sticky-cell text-center nosort" style="width: 20px">
                    <div class="md-checkbox-v2 inline-block lb">
                        <input name="ck_all" class="check_all" id="ck_all" type="checkbox">
                        <label for="ck_all"></label>
                    </div>
                </th>
                <th class="" class="text-center" num="1">{{ __('messages.fiscal_year') }} <span><i class="fa fa-sort sort"></i></span></th>
                <th class="" class="text-center" num="2">{{ __('messages.employee_no') }} <span><i class="fa fa-sort sort"></i></span></th>
                <th class="" class="text-center" num="3">{{ __('messages.employee_name') }}  <span><i class="fa fa-sort sort"></i></span></th>
                <th class="" class="text-center" num="4">{{ __('messages.eval_sheet_category') }}  <span><i class="fa fa-sort sort"></i></span></th>
                <th class="" class="text-center" num="5">{{ __('messages.evaluation_sheet') }}  <span><i class="fa fa-sort sort"></i></span></th>
                <th class="" class="text-center" num="6">{{ __('messages.status') }} <span><i class="fa fa-sort sort"></i></span></th>
            </tr>

        </thead>
        <tbody id="mock-data1" class="list_table">
            @foreach ($table as $key => $item)
                <tr class="list">
                    <td class="sticky-cell text-center">
                        <div class="md-checkbox-v2 inline-block lb">
                            <input class="ck_item" name="ck{{$key}}" id="ck{{$key}}" type="checkbox" value="1">
                            <label for="ck{{$key}}"></label>
                        </div>
                    </td>
                    <td num="1" style="min-width:70px"  >
                        {{$item['fiscal_year']}}
                    </td>
                    <td num="2" style="min-width:100px">
                        <div class="text-right"><a href="#" class="link_q0071 text-right">{{$item['employee_cd']}}</a></div>
                        <input type="text " class="employee_cd hidden" value="{{$item['employee_cd']}}">
                        <input type="hidden" class="order_by" value="{{$item['employee_cd']}}" />
                    </td>
                    <td style=" word-break: break-all;" num="3">{{$item['employee_nm']}}
                        <input type="text " class="employee_nm hidden" value="{{$item['employee_nm']}}">
                        <input type="hidden" class="order_by" value="{{$item['employee_nm']}}" />
                    </td>
                    <td style=" word-break: break-all;" num="4" style="min-width:200px">{{$item['sheet_kbn_nm']}}
                        <input type="hidden" class="order_by" value="{{$item['sheet_kbn']}}" />
                    </td>

                    <td  num="5">
                        <a style=" word-break: break-all;" href="#" class="link_sheet">{{$item['sheet_nm']}}</a>
                        <input type="text " class="sheet_nm hidden" value="{{$item['sheet_nm']}}">
                        <input type="text " class="sheet_kbn hidden" value="{{$item['sheet_kbn']}}">
                        <input type="hidden" class="order_by" value="{{$item['sheet_nm']}}" />
                    </td>
                    <td style=" word-break: break-all;" num="6">{{$item['status_nm']}}
                        <input type="text " class="status_nm hidden" value="{{$item['status_nm']}}">
                        <input type="hidden" class="order_by" value="{{$item['status_nm']}}" />
                    </td>
                    <td style=" word-break: break-all;" class="hidden">
                        <input type="text " class="sheet_cd hidden" value="{{$item['sheet_cd']}}">
                        <input type="text " class="status_cd hidden" value="{{$item['status_cd']}}">
                        <input type="text " class="fiscal_year hidden" value="{{$item['fiscal_year']}}">
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
</div><!-- end .row -->