<div class="row">
    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
        <div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{ $search_key ?? '' }}"
                        maxlength="50">
                    <div class="input-group-append-btn">
                        <button id="btn-search-key" class="btn btn-transparent" type="button" tabindex="-1"><i
                                class="fa fa-search"></i></button>
                    </div>
                </div>
            </span>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12 col-xs-12 col-lg-12">
        <nav class="pager-wrap pagin-fix">
            {{ Paging::show($paging) }}
        </nav>
    </div>
    <div class="col-md-12 col-xs-12 col-lg-12">
        <div class="list-search-v">
            <div class="list-search-head-oneonone">
                {{ __('messages.sheet_list') }}
            </div>
            <div class="list-search-content">
                <ul>
                @if(isset($menu[0]) && $menu[0] != '' && isset($menu[0][0]['option_cd']))
                @foreach($menu[0] as $menu_lv_1)
                    <li>
                        <a class="lv1 collapsed" txt="シート１" data-toggle="collapse" href="#{{$menu_lv_1['option_cd']}}" typ="1"
                            cd="1-" aria-expanded="false">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$menu_lv_1['option_nm']}}" aria-describedby="tooltip381538">
                                <i class="fa fa-chevron-right"></i><span> </span><span>{{$menu_lv_1['option_nm']}}</span>
                            </div>
                        </a>
                        <ul class="collapse" id="{{$menu_lv_1['option_cd']}}" style="">
                        @if(isset($menu[1]) && $menu[1] != '')
                        @foreach($menu[1] as $menu_lv_2)
                        @if($menu_lv_2['parent_option_cd_1'] == $menu_lv_1['option_cd'])
                            <li class="">
                                <a class="lv2" href="#{{$menu_lv_2['option_cd']}}{{$menu_lv_2['parent_option_cd_1']}}"  txt="シート１" data-toggle="collapse" typ="1"
                            cd="1-" aria-expanded="false">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                        data-original-title="{{$menu_lv_2['option_nm']}}" aria-describedby="tooltip381538">
                                        <input type="hidden" class="interview_cd" value="1">
                                        <i class="fa fa-chevron-right"></i><span> </span><span class="adaption_date">{{$menu_lv_2['option_nm']}}</span>
                                    </div>
                                </a>
                                <ul class="collapse" id="{{$menu_lv_2['option_cd']}}{{$menu_lv_2['parent_option_cd_1']}}" style="">
                                @if(isset($menu[2]) && $menu[2] != '')
                                @foreach($menu[2] as $menu_lv_3)
                                @if($menu_lv_3['parent_option_cd_2'] == $menu_lv_2['option_cd'] && $menu_lv_3['parent_option_cd_1'] == $menu_lv_2['parent_option_cd_1'])
                                    <li class="">
                                        <a report_kind="{{$menu_lv_3['parent_option_cd_1']}}" adaption_date="{{$menu_lv_3['option_nm']}}" sheet_cd="{{$menu_lv_3['parent_option_cd_2']}}" class="lv3" href="#">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip"
                                                data-original-title="{{$menu_lv_3['option_nm']}}" aria-describedby="tooltip381538">
                                                <input type="hidden" class="interview_cd" value="1">
                                                <span> </span><span class="adaption_date">{{$menu_lv_3['option_nm']}}</span>
                                            </div>
                                        </a>
                                    </li>
                                    
                                @endif
                                @endforeach
                                @endif
                                </ul>
                            </li>
                        @endif
                        @endforeach
                        @endif
                        </ul>
                    </li>
                @endforeach
                @else
					<div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
                @endif
                </ul>
            </div>
        </div>
    </div>
</div>
