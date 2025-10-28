<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
    <nav class="pager-wrap row">
        {!! Paging::show($paging) !!}
    </nav>

    <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped ">
            <thead>
            <tr>
                <th style="width: 85px;min-width: 85px;max-width: 85px;">{{ __('messages.employee_no') }}</th>
                <th>{{ __('messages.employee_name') }}</th>
                <th>{{ __('messages.employee_classification') }}</th>
                @foreach($organization_group as $dt)
                <th class="text-overfollow" 
                     data-container="body" data-toggle="tooltip"
                     data-original-title="{{$dt['organization_group_nm']}}" style="max-width: 100px">
                    {{$dt['organization_group_nm']}}
                    {{-- {{$dt['organization_group_nm']}} --}}
                </th>
                @endforeach
                <th>{{ __('messages.job') }}</th>
                <th>{{ __('messages.position') }}</th>
                {{-- cr 2022/05/16 edit by vietdt  --}}
                {{-- <th>等級</th>
                <th>事業所</th> --}}
            </tr>
            </thead>
            <tbody>
                @if ($paging['totalRecord']!='0' || !isset($list))
                    @foreach($list as $row)
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
                            <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['employee_typ_nm']}}">
                                    {{$row['employee_typ_nm']}}
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
                                     data-original-title="{{$row['job_nm']}}">
                                    {{$row['job_nm']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['position_nm']}}">
                                    {{$row['position_nm']}}
                                </div>
                            </td>
                            {{-- cr 2022/05/16 edit by vietdt  --}}
                            {{-- <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['grade_nm']}}">
                                    {{$row['grade_nm']}}
                                </div>
                            </td>
                            <td class="td-width">
                                <div class="text-overfollow"
                                     data-container="body" data-toggle="tooltip"
                                     data-original-title="{{$row['office_nm']}}">
                                    {{$row['office_nm']}}
                                </div>
                            </td> --}}
                        </tr>
                    @endforeach
                @else
                    <tr class="tr-nodata">
                        <td colspan="{{10+count($organization_group)}}" class="w-popup-nodata no-hover text-center">{{ $_text[21]['message'] }}</td>
                    </tr>
                @endif
            </tbody>
        </table>
    </div>
</div> <!-- end .card-body -->