<div class="card-body" id="result" >
    @php
        $count = count($list_group);
	    function ordinal($number) {
        $ends = array('th','st','nd','rd','th','th','th','th','th','th');
	    if( \Session::get('website_language', config('app.locale')) != 'en')
	    	return  '';
        elseif ((($number % 100) >= 11) && (($number%100) <= 13))
            return  'th';
        else
            return  $ends[$number % 10];
	    }
    @endphp
    @if(!empty($list_group))
        <div class=" wmd-view  table-responsive" style="max-height: 600px">
            <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="myTable"
            style="min-width: {{($count*180+500).'px'}}">
                <thead>
                <tr>    
                    <th rowSpan="2"></th>
                    @if(!empty($list_group))
                    @foreach($list_group as $title_group)
                        <th style="min-width: 180px" colSpan="2" value="{{$title_group['group_cd']??''}}">{{$title_group['group_nm']??''}}</th>

                    @endforeach
                    @endif
                </tr>
                <tr class="tr2"> 

                    @for($i=0;$i<$count;$i++) 
                        <th class="w-120px">{{ __('messages.coach') }}</th>
                        <th class="w-120px">{{ __('messages.member') }}</th>
                    @endfor
                </tr>
                </thead>
                <tbody>
                    @if(!empty($list_group))
                    <tr class="tr_employee table0" >
                        <td class="w-120px text-center" style="width:4%"> 
                        {{ __('messages.all') }}
                        </td>
                        @for($i=0;$i<$count;$i++) 
                                <td class="w-120px text-center"> 
                                    <select width="20px" tabindex="1" count_select="{{$i}}" class="form-control text-overflow   search-1">
                                        <option value="-1"></option>
                                        @if (isset($list_coach))
                                            @foreach($list_coach as $coach)
                                                <option value="{{$coach['questionnaire_cd']}}">{{$coach['questionnaire_nm']}}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </td>
                                <td class="w-120px text-center select-width">
                                    <select width="20px" tabindex="1" count_select="{{$i}}" class="form-control text-overflow  search-2">
                                        <option value="-1"></option>
                                        @if (isset($list_member))
                                            @foreach($list_member as $members)
                                                <option value="{{$members['questionnaire_cd']}}">{{$members['questionnaire_nm']}}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </td>
                            @endfor
                    </tr>
                    @if(isset($list))
                    @foreach($list as $row)
                        <tr class="times_group table0">
                            <td class="w-120px text-center"> 
                                {{ __('messages.th_time', ['number' => $row['times']??'']).ordinal($row['times']??'5') }}
                            </td>
                            <input type="hidden" value="{{$row['times']}}" class="times">
                            @foreach($list_group as $i => $data)
                            @php
                                $group = $data['group_cd'];
                            @endphp
                            @if($row[$group] != '')
                                @php
                                    $data_result = json_decode(str_replace('&quot;', '"', $row[$group]));
                                    $questionnaire_cd_coach = $data_result[0]->questionnaire_cd_coach??'';
                                    $questionnaire_cd_member = $data_result[1]->questionnaire_cd_member??'';
                                @endphp
                                <input type="hidden" value="{{$group??''}}" class="group_cd">
                                <input type="hidden" value="{{$row['times']??''}}" class="times_each">
                                <td class="w-120px text-center select-width"> 
                                    <select width="20px"  tabindex="1" group_cd="{{$group??''}}" class="form-control text-overflow search-val-coach coach-{{$group??''}} coach-val-{{$i}} td-data">
                                        <option value="-1"></option>
                                        @if (isset($list_coach))
                                            @foreach($list_coach as $coach)
                                                <option value="{{$coach['questionnaire_cd']??''}}"
                                                {{$questionnaire_cd_coach == $coach['questionnaire_cd']?'selected':''}}
                                                >{{$coach['questionnaire_nm']??''}}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </td>
                                <td class="w-120px text-center select-width">
                                    <select width="20px" tabindex="1" group_cd="{{$group}}" class="form-control text-overflow search-val-member member-{{$group}} member-val-{{$i}} td-data">
                                        <option value="-1"></option>
                                        @if (isset($list_member))
                                            @foreach($list_member as $members)
                                                <option value="{{$members['questionnaire_cd']}}"
                                                {{$questionnaire_cd_member == $members['questionnaire_cd']?'selected':''}}
                                                >{{$members['questionnaire_nm']}}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </td>
                            @else 
                                <td class="w-120px text-center"> 
                                   
                                </td>
                                <td class="w-120px text-center select-width">
                                    
                                </td>
                            @endif
                            @endforeach
                        </tr>
                    @endforeach
                    @endif
                    @endif
                </tbody>
            </table>
        </div><!-- end .row -->
    @endif
    <div class="row justify-content-md-center">
        {!! Helper::buttonRender1on1(['saveButton']) !!}
    </div>
        </div>
    </div>
</div> <!-- end .card-body -->