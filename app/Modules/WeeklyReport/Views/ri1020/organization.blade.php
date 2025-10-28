
@if(isset($organization_group[0]) && !empty($organization_group[0]))
<div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 init_organization">
    <div class="form-group">
        <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$organization_group[0]['organization_group_nm']}}" style="max-width: 150px;    display: block">
            {{$organization_group[0]['organization_group_nm']}}
        </label>
        <select name="" system="5" id="organization_step1" class="form-control organization_cd1" tabindex="3" organization_typ='1'>
            <option value="-1"></option>
            @foreach($combo_organization as $row)
            <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" {{($list_organization['belong_cd1']??'')==$row['organization_cd_1']?'selected':''}}>{{$row['organization_nm']}}</option>
            @endforeach
        </select>
    </div>
    <!--/.form-group -->
</div>
@endif

@php

if($count_organization_cd < count($organization_group)){ $count_organization_cd=count($organization_group); } @endphp 
@foreach($organization_group as $dt) @if($dt['organization_typ']>=2)

    <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3 init_organization">
        <div class="form-group">
        @if (is_array($dt)  && isset($dt['organization_group_nm']))
            <label class="text-overfollow control-label {{$check_lang=='en'?'lable-check':''}}" data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}" style="max-width: 150px;    display: block">
                {{$dt['organization_group_nm']}}
            </label>
            @endif
            <select name="" system="5" id="{{'organization_step'.$dt['organization_typ']}}" class="form-control {{'organization_cd'.$dt['organization_typ']}}" tabindex="4" organization_typ="{{$dt['organization_typ']}}">
                <option value="-1"></option>
              
                @if($organization_group_total[$dt['organization_typ']] != null && count($organization_group_total[$dt['organization_typ']]) > 0)
                @foreach($organization_group_total[$dt['organization_typ']] as $row)   
                
                    @if($dt['organization_typ'] == 2)
                        @if(($list_organization['belong_cd1']??'')==$row['organization_cd_1']&&($list_organization['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']])
                        <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" selected>
                            {{$row['organization_nm'] }}
                        </option>
                    @else
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}">
                        {{$row['organization_nm'] }}
                    </option>
                    @endif
                    @elseif($dt['organization_typ'] == 3)
                    @if(($list_organization['belong_cd1']??'')==$row['organization_cd_1']&&($list_organization['belong_cd2']??'')==$row['organization_cd_2']&&($list_organization['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']])
                       
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" selected>
                        {{$row['organization_nm'] }}
                    </option>
                    @else
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}">
                        {{$row['organization_nm'] }}
                    </option>
                    @endif
                    @elseif($dt['organization_typ'] == 4)
                    @if(($list_organization['belong_cd1']??'')==$row['organization_cd_1']&&($list_organization['belong_cd2']??'')==$row['organization_cd_2']&&($list_organization['belong_cd3']??'')==$row['organization_cd_3']&&($list_organization['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']])
                    
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" selected>
                        {{$row['organization_nm'] }}
                    </option>
                    @else
                    <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}">
                        {{$row['organization_nm'] }}
                    </option>
                    @endif
                    @else
                    @if(($list_organization['belong_cd1']??'')==$row['organization_cd_1']&&($list_organization['belong_cd2']??'')==$row['organization_cd_2']&&($list_organization['belong_cd3']??'')==$row['organization_cd_3']&&($list_organization['belong_cd4']??'')==$row['organization_cd_4']&&($list_organization['belong_cd'.$dt['organization_typ']]??'')==$row['organization_cd_'.$dt['organization_typ']])
                    
                        <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}" selected>
                            {{$row['organization_nm'] }}
                        @else
                        <option value="{{$row['organization_cd_1'].'|'.$row['organization_cd_2'].'|'.$row['organization_cd_3'].'|'.$row['organization_cd_4'].'|'.$row['organization_cd_5']}}">
                            {{$row['organization_nm'] }}
                        </option>
                    @endif
                @endif
                @endforeach
                @endif
            </select>

        </div>
        <!--/.form-group -->
    </div>

    @endif
@endforeach