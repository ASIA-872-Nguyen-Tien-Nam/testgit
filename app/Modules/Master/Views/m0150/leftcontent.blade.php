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
			@forelse($views as $row)
				<div class="list-search-child text-overfollow" data-toggle="tooltip" title="{{$row['group_nm']}}">
					{{$row['group_nm']}}
					<input type="hidden" class="group_cd" value="{{$row['group_cd']}}" />
					<input type="hidden" class="group_nm" value="{{$row['group_nm']}}" />
					<input type="hidden" class="arrange_order" value="{{$row['arrange_order']}}" />
				</div>
			@empty
				<div class="list-search-child text-overfollow" empty data-toggle="tooltip" title="{{app('messages')->getText(21)->message}}">
					{{app('messages')->getText(21)->message}}
				</div>
			@endforelse
			
		</div>
	</div>
</div>