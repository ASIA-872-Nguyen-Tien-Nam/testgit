<div class="row" style="justify-content: space-around;">
	<div class="calHe2" style="width: 120px">
		<div class="form-group">
            <span class="num-length">
                <div class="input-group-btn">
				    <input type="text" id="search_key" class="form-control" placeholder="" value="{{$employees['search_key'] ?? ''}}" maxlength="50">
					<div class="input-group-append-btn">
						<button id="btn-search-key" class="btn btn-transparent" type="button"><i class="fa fa-search"></i></button>
					</div>
			    </div>
            </span>
		</div>
	</div>
</div>
<div class="row" style="justify-content: space-around;">
	<div style="width: 120px">
		<nav class="pager-wrap pagin-fix">
			{{Paging::show($employees['paging'])}}
		</nav>
	</div>
</div>
<div class="row" style="justify-content: space-around;">
	<div style="width: 120px">
		<div class="list-search-v">
			<div class="list-search-head">
			{{ __('messages.registration_list') }}
			</div>

			<div class="list-search-content">
				@if ( isset($employees['list'][0]) )
					@foreach($employees['list'] as $row)
					<div class="text-overfollow list-search-child" id="{{ $row['employee_cd'] }}"  data-container="body" data-toggle="tooltip" data-original-title="{{$row['employee_nm']}}">{{$row['employee_nm']}}</div>
					@endforeach
				@else
					<div class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</div>
				@endif
			</div>
		</div>
	</div>
</div>
