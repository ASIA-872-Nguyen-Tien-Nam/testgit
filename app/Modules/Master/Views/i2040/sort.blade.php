<?php
$Reputation = array(
	    'S'
	,   'A'
	,   'B'
	,   'C'
	,   'D'
);
$Reputation2 = array(
        '優'
    ,   '良'
    ,   '可'
    ,   '不可'
);
?>
@foreach($sort AS $key=>$row)
    <tr class="row_data" data-order="{{$key}}">
        <td class="sticky-cell text-center">
            <div class="md-checkbox-v2 inline-block lb">
                <input class="ck-item" name="ck{{$key}}" id="ck{{$key}}" type="checkbox">
                <label for="ck{{$key}}"></label>
            </div>
        </td>
        <td class="sticky-cell" num="1">{{$row['id']}}</td>
        <td class="sticky-cell text-left" width="120" num="2"><a href="/master/q0071">{{$row['a']}}</a> </td>
        <td class="sticky-cell text-left " width="100" num="3">{{$row['b']}}</td>
        <td class="sticky-cell text-left invi" width="100" num="4">{{$row['c']}}</td>
        <td class="sticky-cell text-left invi" width="100" num="5">{{$row['d']}}</td>
        <td class="sticky-cell invi" num="6">{{$row['e']}}</td>
        <td class="sticky-cell invi" num="7">{{$row['f']}}</td>
        <td class="sticky-cell text-left" width="100" num="8">{{$row['g']}}</td>
        <td class="" width="100">{{$row[1]}}</td>
        <td class="" width="100">
            <span class="num-length">
                <input type="text" class="form-control numeric reduce_point1" maxlength="4" negative="true" decimal="1" value="">
            </span>
        </td>
        <td class="text-left" width="100">
            <select name="" id="" class="form-control input-sm">
                <option value=""></option>
                @foreach($Reputation as $list)
                <option value="" {{$list == $row[2] ? 'selected' : ''}}>{{$list}}</option>
                @endforeach
            </select>
        </td>
        <td class="" width="100">{{$row[3]}}</td>
        <td class="" width="100">
            <span class="num-length">
                <input type="text" class="form-control numeric reduce_point2" maxlength="4" negative="true" decimal="1" value=>
            </span>
        </td>
        <td class="text-left" width="100">
            <select name="" id="" class="form-control input-sm">
                <option value=""></option>
                @foreach($Reputation as $list)
                <option value="" {{$list == $row[4] ? 'selected' : ''}}>{{$list}}</option>
                @endforeach
            </select>
        </td>
        <td class="" width="100">{{$row[5]}}</td>
        <td class="" width="100">
            <span class="num-length">
                <input type="text" class="form-control numeric reduce_point3" maxlength="4" negative="true" decimal="1">
            </span>
        </td>
        <td class="text-left" width="100">
            <select name="" id="" class="form-control input-sm">
                <option value=""></option>
                @foreach($Reputation as $list)
                <option value="" {{$list == $row[6] ? 'selected' : ''}}>{{$list}}</option>
                @endforeach
            </select>
        </td>
        <td class="" width="100">{{$row[7]}}</td>
        <td class="" width="100">
            <span class="num-length">
                <input type="text" class="form-control numeric reduce_point4" maxlength="4" negative="true" decimal="1">
            </span>
        </td>
        <td class="text-left" width="100">
            <select name="" id="" class="form-control input-sm">
                <option value=""></option>
                @foreach($Reputation as $list)
                <option value="" {{$list == $row[8] ? 'selected' : ''}}>{{$list}}</option>
                @endforeach
            </select>
        </td>
        <td class="text-center" width="100">{{$row[9]}}</td>
        <td class="" width="100">
            <span class="num-length">
                <input type="text" class="form-control numeric reduce_point_final" maxlength="4" negative="true" decimal="1" value="{{$row[10]}}">
            </span>
        </td>
        <td class="text-left" width="100">
            <select name="" id="" class="form-control input-sm">
                <option value=""></option>
                @foreach($Reputation as $list)
                <option value="" {{$list == $row[11] ? 'selected' : ''}}>{{$list}}</option>
                @endforeach
            </select>
        </td>
        <td class="text-left td_comment" width="500">
            <span class="num-length">
                <input type="text" class="form-control input-sm comment " maxlength="100">
            </span>
        </td>
        <td></td>
        <td class="text-left" width="220"><a href="/master/i2020">{{$row[12]}}</a></td>
        <td class="text-right" width="100">{{$row[13]}}</td>
        <td class="text-right" width="100">{{$row[14]}}</td>
        <td class="text-right" width="100">{{$row[15]}}</td>
        <td class="text-right" width="100">{{$row[16]}}</td>
        <td class="text-right" width="100">{{$row[17]}}<span>%</span></td>
        <td class="text-left" width="220"><a href="/master/i2010">{{$row[18]}}</a></td>
        <td class="text-right" width="100">{{$row[19]}}</td>
        <td class="text-right" width="100">{{$row[20]}}</td>
        <td class="text-right" width="100">{{$row[21]}}</td>
        <td class="text-right" width="100">{{$row[22]}}</td>
        <td class="text-right" width="100">{{$row[23]}}<span>%</span></td>
    </tr>
    @endforeach