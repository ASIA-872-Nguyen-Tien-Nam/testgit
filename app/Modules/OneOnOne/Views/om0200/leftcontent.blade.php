<div class="row">
    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
        <div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key ?? ''}}"  maxlength="50">
                    <div class="input-group-append-btn">
                        <button id="btn-search-key" class="btn btn-transparent" type="button" tabindex="-1"><i class="fa fa-search"></i></button>
                    </div>
                </div>
            </span>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12 col-xs-12 col-lg-12">
        <nav class="pager-wrap pagin-fix">
            {{Paging::show($paging)}}
        </nav>
    </div>
    <div class="col-md-12 col-xs-12 col-lg-12">
        <div class="list-search-v">
            <div class="list-search-head-oneonone">
            {{ __('messages.sheet_list') }}
            </div>
            <div class="list-search-content">
                @if(isset($list_sheet) && !empty($list_sheet))
                <ul>
                    @foreach ($list_sheet as $key => $item)
                        <li>
                            <a class="lv1 collapsed" txt="{{$item[0]['interview_nm']}}" data-toggle="collapse" href="#{{'sheet'.$key}}" typ="1" cd="1-" aria-expanded="true">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item[0]['interview_nm']}}" aria-describedby="tooltip523082">
                                <i class="fa fa-chevron-right"></i><span> </span><span>{{$item[0]['interview_nm']}}</span>
                                </div>
                              </a>
                            <ul class="collapse" id="{{'sheet'.$key}}">
                                @foreach ($item as $dt)
                                    <li class="">
                                        <a class="lv2" href="#">
                                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['adaption_date']}}">
                                                <input type="hidden" class="interview_cd" value="{{$dt['interview_cd']}}">
                                                <span> </span><span class="adaption_date">{{$dt['adaption_date']}}</span>
                                            </div>
                                        </a>
                                    </li>
                                @endforeach
                            </ul>
                        </li>
                    @endforeach
                </ul>
                @else
                    <ul>
                        <li style="text-align: center;">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ $_text[21]['message'] }}">
                                {{ $_text[21]['message'] }}
                            </div>
                        </li>
                    </ul>
                @endif

            </div>
        </div>
    </div>
</div>
