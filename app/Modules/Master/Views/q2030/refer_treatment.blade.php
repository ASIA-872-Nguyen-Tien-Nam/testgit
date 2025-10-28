@if(isset($result[0]['treatment_applications_no']))
    @foreach($result as $item)
        <option value='{{$item['treatment_applications_no']}}'>
            {{$item['treatment_applications_nm']}}
        </option>
    @endforeach
@endif
