<div class="row">
    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
        <div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{ $search_key ?? '' }}"
                        maxlength="50">
                    <div class="input-group-append-btn">
                        <button id="btn-search-key" class="btn btn-transparent" type="button"><i
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
            <div class="list-search-head">
                {{ __('messages.registration_list') }}
            </div>

            <div class="list-search-content">
                @if (isset($list[0]))
                    @foreach ($list as $value)
                        @if ($value['child'] == 0)
                            <div class=" list-search-child level1" style="padding-left: 5px;"
                                data-type="{{ $value['report_kind'] }}">
                                <div class="text-overfollow" style="float: left;width: 100%" data-container="body"
                                    data-toggle="tooltip" data-original-title="{{ $value['name_kind'] }}">
                                    <i class="fa fa-chevron-right"></i><span> {{ $value['name_kind'] }}</span>
                                </div>
                            </div>
                        @else
                            <div class=" list-search-child level2 hide" data-type="{{ $value['report_kind'] }}"
                                contract_company_attribute="{{ $value['contract_company_attribute'] }}"
                                data-company="{{ $value['company_cd'] }}" data-report="{{ $value['report_kind'] }}"
                                data-question="{{ $value['question_no'] }}">
                                @if ($value['contract_company_attribute'] != 1 && $value['company_cd'] == $company_mc['company_mc'])
                                    <div class="text-overfollow" style="width: 130px;float: left" data-container="body"
                                        data-toggle="tooltip" data-original-title="{{ $value['question_title'] }}">
                                        <span> {{ $value['question_title'] }}</span>
                                    </div>
                                    <span
                                        style="text-align: right; float: right; color: blue">{{ __('messages.unregistered') }}</span>
                                @else
                                    <div class="text-overfollow" style="width: 100%;float: left" data-container="body"
                                        data-toggle="tooltip" data-original-title="{{ $value['question_title'] }}">
                                        <span> {{ $value['question_title'] }}</span>
                                    </div>
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
<input type="hidden" id="company_cd_mc" value="{{ $company_mc['company_mc'] ?? 0 }}">
