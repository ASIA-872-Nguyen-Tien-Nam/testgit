@if(isset($result[0][0]['group_cd']))
    <div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
    <nav class="pager-wrap row">
        @if(isset($paging))
            {{Paging::show($paging)}}
        @endif
    </nav>
    </div>
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-striped"  id="table-2">
                    <thead>
                        <th class="text-center" style="width: 250px;">{{__('messages.rank')}}</th>
                        @if(isset($m0130))
                            @foreach($m0130 as $item)
                                <th class="text-center" style="width: 150px;">{{$item['rank_nm']}}</th>
                            @endforeach
                        @endif
                        <th class="text-center" style="width: 150px;">{{__('messages.number_of_persons')}}</th>
                    </thead>
                    <tbody>
                        @foreach($result[0] as $value)
                            <tr class="tr_data">
                                <input type="hidden" class="unit_display" value="{{$value['group_cd']}}"/>
                                @if($value['type_chk'] == 1)
                                    <td style="text-align: left;width: 250px;max-width:250px;" class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['group_nm']}}">{{$value['group_nm']}}</td>
                                @else
                                    <th style="text-align: left;background-color: #EAEBEE;max-width:250px;" class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['group_nm']}}">{{$value['group_nm']}}</th>
                                @endif
                                @if($value['type_chk']==1)
                                    @foreach($rank[$value['group_cd']] as $td)
                                        <td style="text-align: center;" class="data_td">
                                            <input type="hidden" class="rank_cd" value="{{$td['rank_cd']}}"/>
                                            <a  data-toggle="true" data-target=".fl" href="#" class="detail_show text-wrap" tabindex="-1">{{$td['result']}}</a>
                                        </td>
                                    @endforeach
                                @else
                                    @foreach($result[2] as $tl)
                                        <th style="text-align: center;background-color: #EAEBEE" class="text-wrap">{{$tl['result']}}</th>
                                    @endforeach
                                @endif
                                    <th style="text-align: center;background-color: #EAEBEE" class="text-wrap">{{$value['group_emp']}}</th>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
@else
    <div class="d-flex flex-lg-row flex-md-column">
        <div class="flex-start  md-overflow ">
            <table class="table table-bordered table-hover ">
                <thead>
                    <th class="text-center" style="width: 250px;">{{__('messages.rank')}}</th>
                    @foreach($m0130 as $item)
                        <th class="text-center" style="width: 150px;">{{$item['rank_nm']}}</th>
                    @endforeach
                    <th class="text-center" style="width: 150px;">{{__('messages.number_of_persons')}}</th>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="17"  class="text-center">
                            {{app('messages')->getText(21)->message}}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
@endif
