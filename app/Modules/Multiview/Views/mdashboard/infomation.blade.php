@if(isset($list2[0]['cre_datetime']))
<div class="table-responsive wmd-view table-data">
    <table class="table table-bordered table-hover ofixed-boder" id="table-detail">
        <thead>
            <tr>
                <th colspan="5">通知</th>
            </tr>
        </thead>
        <tbody>
            @foreach($list2 as $key=>$row)
            <tr class="function list_function"> 
                <td>{{$row['infomation_message']??''}}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endif