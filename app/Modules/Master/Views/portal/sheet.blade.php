@if($list_employee)
@foreach($list_employee as $item)
<li class="refer_hyouka {{$item['rater_background']??''}}" screen_refer="{{$item['screen_refer']}}" fiscal_year="{{$item['fiscal_year']}}" sheet_cd="{{$item['sheet_cd']}}" employee_cd="{{$item['employee_cd']}}" >
    <a href="#">
        <span style="width : 35%">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['status_nm']}}">{{$item['status_nm']}}</div>
        </span>
        <span style="width : 30%">
            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['sheet_nm']}}">{{$item['sheet_nm']}}</div>
        </span>
        <div style="height: 20px" class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['employee_nm']}}">{{$item['employee_nm']}}</div>
    </a>
</li>
@endforeach
@else
<li class="text-center">
        {{app('messages')->getText(21)->message}}
</li>
@endif