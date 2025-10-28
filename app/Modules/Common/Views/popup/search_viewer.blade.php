<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
    <nav class="pager-wrap row">
        {!! Paging::show($paging) !!}
    </nav>
    <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped ">
            <thead>
            <tr>
                <th style="max-width: 50px">{{__('messages.employee_no')}}</th>
                <th>{{__('messages.employee_name')}}</th>
                @foreach($organization_group as $dt)
                <th class="text-overfollow"
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$dt['organization_group_nm']}}" style="max-width: 100px">
                    {{$dt['organization_group_nm']}}
                </th>
                @endforeach
                <th>{{__('messages.position')}}</th>
                <th>{{__('ri2010.confirm')}}</th>
                <th>{{__('messages.comment')}}</th>
            </tr>
            </thead>
            <tbody>
                @if (isset($viewers) && !empty($viewers))
                    @foreach($viewers as $key => $row)
                        <tr employee_cd="{{$row['employee_cd']}}" employee_nm="{{$row['employee_nm']}}">
                            <td class="text-right">
                                <div class="text-overfollow" style="width: 90px;"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['employee_cd']}}">
                                    {{$row['employee_cd']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['employee_nm']}}">
                                    {{$row['employee_nm']}}
                                </div>
                            </td>
                            @foreach($organization_group as $dt)
                                <td class="td-width">
                                    <div class="text-overfollow"
                                         data-container="body" data-toggle="tooltip"
                                         data-original-title="{{$row['organization_nm'.$dt['organization_step']]}}">
                                        {{$row['organization_nm'.$dt['organization_step']]}}
                                    </div>
                                </td>
                            @endforeach
                            <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['position_nm']}}">
                                    {{$row['position_nm']}}
                                </div>
                            </td>
                            <td class="text-center td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{ $row['viewed_status'] }}">
                                     {{ $row['viewed_status'] }}
                                </div>
                            </td>
                            <td class="text-center td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{ $row['comment_status'] }}">
                                     {{ $row['comment_status'] }}
                                </div>
                            </td>
                        </tr>
                    @endforeach
                @else
                    <tr class="tr-nodata">
                        <td colspan="{{8+count($organization_group)}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </tbody>
        </table>
    </div>
</div>