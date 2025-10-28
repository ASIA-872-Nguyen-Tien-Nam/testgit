
    <div class="col-md-12" >
        <div class="table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells" style="" id="table_detail">
            <table class="table table-bordered table-hover fixed-header" id="table-data">
                <thead>
                <tr>
                    <th class="text-center" style="width:8%" >{{ __('messages.mark') }}</th>
                    <th class="text-center" style="width:85%">{{ __('messages.content') }} </th>
                    <th class="text-center" style="width:7%">{{ __('messages.points') }}</th>
                </tr>
                </thead>
                <tbody>
                    @foreach ($data_table as $item_no => $row)
                    @php
                        $placeholder = '';
                        switch ($item_no) {
                            case 0:
                                $placeholder = trans('messages.very_fulfilling');
                                break;
                            case 1:
                                $placeholder = trans('messages.quite_fulfilling');
                                break;
                            case 2:
                                $placeholder = trans('messages.well_fulfilling');
                                break;
                            case 3:
                                $placeholder = trans('messages.not_very_fulfilling');
                                break;
                            case 4:
                                $placeholder = trans('messages.not_fulfilling_at_all');
                                break;
                            default:
                                $placeholder = '';
                                break;
                        }
                    @endphp
                    <tr class="tr">
                        <td  class="mid-cate text-center" >
                            <input type="text" class="hidden item_no" value="{{$item_no*1 + 1}}">
                            <input type="text" class="hidden remark" value="{{$item_no*1 + 1}}">
                            <span><img src="/uploads/ver1.7/odashboard/{{$row['remark1']}}" width=50px/></span>
                        </td>
                        <td >
                            <span class="num-length">
                                <textarea tabindex="3" class="form-control explanation" placeholder="{{ $placeholder }}" cols="30" rows="3" maxlength="50">{{($row['explanation']??'')==''?$placeholder:($row['explanation']??'')}}</textarea>
                            </span>
                        </td>
                        <td class="text-right">
                            <input type="text" class="hidden point" value="{{(float)$row['point']}}">
                            {{(float)$row['point']}}
                        </td>
                    </tr>
                    @endforeach

                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
