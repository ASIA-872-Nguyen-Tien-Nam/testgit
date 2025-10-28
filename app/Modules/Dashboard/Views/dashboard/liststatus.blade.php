<div class="row">
	<div class="col-md-12" style="padding-right: 0px;padding-left:0px">
		@if(!empty($list_status))
		<ul class="breadcrumb-arrow">
			<div class="div-bar" style="width:100%;overflow: hidden;">
				@foreach($list_status as $row)
				<li class="step-bar step {{$row['step']}}"  status-bar="{{$row['status_nm']}}" status_cd="{{$row['status_cd']}}" data-toggle="tooltip"  data-original-title="{{$row['count_status_cd_nm']}}" style="width: {{$row['status_percent']}};"><a href="#"></a></li>
				@endforeach
			</div>
		</ul>
		@else
		<ul class="breadcrumb-arrow-noData">
			<div class="div-bar" style="width:100%;background-color: rgba(0,0,0,.05);">
				<li class="text-center">
					{{ $_text[21]['message'] }}
				</li>
			</div>
		</ul>
		@endif
	</div>
</div>