{{-- note --}}
@php
	$check_lang = \Session::get('website_language', config('app.locale'));
@endphp
<div class="row">
    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
        <div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key ?? ''}}"  maxlength="20">
                    <div class="input-group-append-btn">
                        <button id="btn-search-key" class="btn btn-transparent" type="button"><i class="fa fa-search"></i></button>
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
            <div class="list-search-head list-search-head-oneonone">
            {{ __('messages.questionnaire_list') }}
            </div>

            <div class="list-search-content">
                @if (isset($list[0]) )
                    @foreach($list as $row)
                        @if($row['check_status'] == 0)
                        <div style="" class="text-overfollow list-search-child" id="{{ $row['questionnaire_cd'] }}" company_cd="{{$row['company_cd']??''}}" refer_kbn="{{$row['refer_kbn']??''}}" refer_questionnaire_cd="{{$row['refer_questionnaire_cd']??''}}" contract_company_attribute="{{ session_data()->contract_company_attribute }}" data-container="body" data-toggle="tooltip" data-original-title="{{$row['questionnaire_nm']}}">
                            @if(session_data()->contract_company_attribute ==1)
                                {{$row['questionnaire_nm']}}
                            @else
                                @if($row['check_status'] == 0 && $row['company_cd'] == 0)
                                    <div class="text-overfollow" style="float:left;{{$check_lang=='en'?'width: calc(100% - 80px);':'width: calc(100% - 45px);'}}">
                                        {{$row['questionnaire_nm']}}
                                    </div>
                                @else
                                    {{$row['questionnaire_nm']}}
                                @endif
                            @endif
                            @if(session_data()->contract_company_attribute ==1)
                                <span></span>
                            @else
                                @if($row['check_status'] == 0 && $row['company_cd'] == 0)
                                    <span style="float: right; color: blue; {{$check_lang=='en'?'width: 80px':'width: 45px'}}">{{ __('messages.unregistered') }}</span>
                                @endif
                            @endif
                        </div>
                        @endif
                    @endforeach
                @else
                    <div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
                @endif
            </div>
        </div>
    </div>
</div>
