<div class="card-body">
    @if(isset($paging['totalRecord']) && $paging['totalRecord'] != 0)
        <nav class="pager-wrap">
            {!! Paging::show($paging) !!}
        </nav>
    @endif
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped ">
            <thead>
            <tr>
                <th width="100px">{{__('messages.noti_date')}}</th>
                <th>{{__('messages.title')}}</th>
                <th width="50px">{{__('messages.unread')}}</th>
            </tr>
            </thead>
            <tbody>
                @if ($paging['totalRecord']!='0' || !isset($list))
                    @foreach($list as $item)
                        <tr class="list_infomation" company_cd="{{$item['company_cd']}}" category="{{$item['category']}}" status_cd="{{$item['status_cd']}}" infomationn_typ="{{$item['infomationn_typ']}}" infomation_date="{{$item['infomation_date']}}" target_employee_cd="{{$item['target_employee_cd']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}" fiscal_year="{{$item['fiscal_year']??''}}">
                            <td class="text-center">{{$item['infomation_date']}}</td>
                            <td class="text-left">{{$item['infomation_title']}}</td>
                            <td class="text-center">
                                @if($item['confirmation_datetime_flg']==1)
                                <button class="btn btn-sm btn-green circle"></button>
                                @endif
                            </td>
                        </tr>
                    @endforeach
                @else
                    <tr class="tr-nodata">
                            <td colspan="3" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </tbody>
        </table>
    </div>
</div> <!-- end .card-body -->