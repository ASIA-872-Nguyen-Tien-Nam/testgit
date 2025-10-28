<nav class="pager-wrap">
    {!! Paging::show($paging ?? []) !!}
</nav>
<div class="row">
    <div class="col-md-12">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
<!-- </div>
<div class="row"> -->
    <div class="col-md-12">
    <input type="hidden" id="screen_from" value="{{$screen_from??''}}">
    <input type="hidden" id="screen" value="{{$screen??''}}">
        <div id="topTable" class="wmd-view table-responsive table-fixed-header sticky-table sticky-headers sticky-ltr-cells _width" style="max-height: 45vh;background-attachment: fixed;">
            <table class="table table-bordered table-hover table-striped fixed-header" id="table-data" style="min-width: 1600px !important">
                <thead>
                    <tr>
                        <th>
                            <div  class="head head1 w-detail-col1"style="line-height: unset">
                                <div class="checkbox ck_tb" style="padding: 0.5rem 0 !important;">
                                    <div class="md-checkbox-v2">
                                        <input type="checkbox" class='check_all' id="item-check" tabindex="">
                                        <label for="item-check"></label>
                                    </div>
                                </div>
                            </div>
                        </th>
                        @if (isset($disable['screen_m0070']) && $disable['screen_m0070'] != 0)
                            <th class="head head2 w-detail-col2">{{ __('messages.edit') }}</th>
                        @endif
                        @if (isset($disable['screen_q0071']) && $disable['screen_q0071'] != 0)
                            <th class="head head3 w-detail-col3">{{ __('messages.history') }}</th>
                        @endif
                        <th class="head head4 w-detail-col5">{{ __('messages.retirement_category') }}</th>
                        <th class="head head5 w-detail-col5">{{ __('messages.employee_no') }}</th>
                        <th class="head head6 w-detail-col5">{{ __('messages.employee_name') }}</th>
                        <th class="head head7 w-detail-col6">{{ __('messages.employee_classification') }}</th>
                        @if (isset($organization_group[0]) && !empty($organization_group[0]))
                        @foreach($organization_group as $dt)
                            <th class="head head8 w-detail-col7 text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}">
                                {{$dt['organization_group_nm']}}
                            </th>
                        @endforeach
                        @endif
                        <th class="head head9 w-detail-col9 ">{{ __('messages.job') }}</th>
                        <th class="head head10 w-detail-col10 ">{{ __('messages.position') }}</th>
                        @php
                            $item_width =  800 + 150 * count($organization_group);
                        @endphp
                        <th class="head head11  " style="width: calc(100% - {{$item_width}}px)">{{ __('messages.grade') }}</th>
                        @if (isset($list_item[0]) && !empty($list_item[0]))
                            @foreach ($list_item as $item)
                                <th class="head headitem w-detail-col-item text-overfollow"  data-container="body" data-toggle="tooltip" data-original-title="{{$item['item_nm']}}" style="max-width:100px">
                                    {{$item['item_nm']}}</th>
                            @endforeach
                        @endif
                    </tr>
                </thead>
                <tbody>
                    @forelse($views as $row)
                    <tr>
                        <td class="text-center choose w-detail-col1" >
                            <div class="checkbox ck_tb" >
                                <div class="md-checkbox-v2">
                                    <input name="check_demo" id="checkbox{{$row['id']}}" class="item-check cheker" type="checkbox"  value="1">
                                    <label for="checkbox{{$row['id']}}"></label>
                                </div>
                                <input type="hidden" class="tb_employee_cd" value="{{$row['employee_cd']}}"/>
                            </div>
                        </td>
                        @if (isset($disable['screen_m0070']) && $disable['screen_m0070'] != 0)
                            <td class="text-center w-detail-col2" style="">
                                <a  class="screen_m0070 ics ics-edit" tabindex="-1">
                                    <span class="ics-inner"  ><i class="fa fa-pencil" ></i></span>
                                </a>
                            </td>
                        @endif
                        @if (isset($disable['screen_q0071'])&& $disable['screen_q0071'] != 0 )
                            <td class="text-center w-detail-col3">
                                @if ($row['is_login_typ4'] != 1)
                                    <a   class="ics ics-edit screen_q0071 " tabindex="-1">
                                        <span class="ics-inner"  ><i class="fa fa-address-book"></i></span>
                                    </a>
                                @endif

                            </td>
                        @endif
                        <td class="text-center w-detail-col15">
                            {{$row['company_out_dt']}}
                        </td>
                        <td class="text-right w-detail-col5">
                            {{$row['employee_cd']}}
                        </td>
                        <td class="w-detail-col5">
                            <div class="text-overfollow list-search-child" id="{{ $row['employee_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">{{$row['employee_nm']}}</div>
                        </td>
                        <td class="w-detail-col6">
                            <div class="text-overfollow list-search-child" id="{{ $row['employee_typ_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_typ_nm']}}">{{$row['employee_typ_nm']}}</div>
                        </td>
                        @if (isset($organization_group[0]) && !empty($organization_group[0]))
                        @foreach($organization_group as $dt)
                            <td class="w-detail-col7">
                                <div class="text-overfollow list-search-child" id="{{ $row['belong_cd'.$dt['organization_typ'].'_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{ $row['belong_cd'.$dt['organization_typ'].'_nm'] }}">
                                {{ $row['belong_cd'.$dt['organization_typ'].'_nm'] }}</div>
                            </td>
                        @endforeach
                        @endif
                        <td class="w-detail-col9">
                            <div class="text-overfollow list-search-child" id="{{ $row['job_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['job_nm']}}">{{$row['job_nm']}}</div>
                        </td>
                        <td class="w-detail-col10">
                            <div class="text-overfollow list-search-child" id="{{ $row['position_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['position_nm']}}">{{$row['position_nm']}}</div>
                        </td>
                        <td class="" style="min-width: 70px">
                            <div class="text-overfollow list-search-child" id="{{ $row['grade_nm'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['grade_nm']}}">{{$row['grade_nm']}}</div>
                        </td>
                        @if (isset($list_item[0]) && !empty($list_item[0]))
                            @foreach ($list_item as $item)
                            @php
                                $arr_item = json_decode(html_entity_decode ( $row[$item['item_cd']]),true);
                            @endphp
                                <td>
                                @if(isset($arr_item['item_kind']))
                                    @if ($arr_item['item_kind'] == 2 || $arr_item['item_kind'] == 4 || $arr_item['item_kind'] == 5)
                                        <div class="{{$arr_item['class_item_align']}}" style="width: 150px">{{$arr_item['item_value']}}</div>
                                    @else
                                        <div class="{{$arr_item['class_item_align']}} text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$arr_item['item_value']}}" style="width: 150px">{{$arr_item['item_value']}}</div>
                                    @endif
                                @endif
                                </td>
                            @endforeach
                        @endif
                    </tr>
                    @empty
                    <tr>
                        <td colspan={{100}}  class="text-center">
                            {{app('messages')->getText(21)->message}}
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div><!-- end .row -->
    </div>
</div><!-- end .card-body -->