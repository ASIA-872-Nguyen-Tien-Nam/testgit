<div class="row">
    <div class="col-xs-12 col-md-12 col-lg-12 calHe2">
        <div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
                    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key ?? ''}}"  maxlength="50">
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
            <div class="list-search-head">
            {{__('messages.registration_list')}}
            </div>

            <div class="list-search-content">
                @if (isset($list[0]) )
                    @foreach($list as $row)
                        <div class="text-overfollow list-search-child" id="{{ $row['sheet_cd'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['sheet_nm']}}">
                            {{$row['sheet_nm']}}
                        </div>
                    @endforeach
                @else
                    <div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
                @endif
            </div>
        </div>
    </div>
</div>
