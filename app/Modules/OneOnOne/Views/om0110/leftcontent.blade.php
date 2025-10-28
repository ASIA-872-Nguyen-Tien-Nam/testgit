<div class="row">
	<div class="col-xs-12 col-md-12 col-lg-12 calHe2">
		<div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
				    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$search_key ?? ''}}" maxlength="50">
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
			<div class="list-search-head-oneonone">
			{{ __('messages.category_list') }}
			</div>
			<div class="list-search-content">
				@if (isset($list[0]) )
					@foreach($list as $row)
					<div class="text-overfollow list-search-child" id="{{ $row['category1_cd'] }}" company_cd="{{ $row['company_cd'] }}" refer_kbn="{{$row['refer_kbn']??''}}" contract_company_attribute="{{ session_data()->contract_company_attribute }}" data-container="body" data-toggle="tooltip" data-original-title="{{$row['category1_nm']}}">
						@if(session_data()->company_cd ==0)
							{{$row['category1_nm']}}
						@else
							@if($row['contract_company_attribute'] != 1 && $row['company_cd'] == 0)
								<div class="text-overfollow" style="float:left;width: 65%">
									{{$row['category1_nm']}}
								</div>
								<span style="width: 35%;float: right; color: blue">{{ __('messages.unregistered') }}</span>
							@else
								{{$row['category1_nm']}}
							@endif
						@endif
					</div>
                    @endforeach
                @else
                    <div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
                @endif
			</div>
		</div>
	</div>
</div>
