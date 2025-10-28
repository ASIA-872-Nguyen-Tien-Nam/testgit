<?php
function genLi($level, $tmp) {
    $unique = md5(uniqid(rand(), true));
    ?>
    <a href="javascript:void(0)" class="lv{{$level}} list_organization">
        <table class="ck-inline">
            <tr>
                <td class="td1-level{{$level}}">
                    <div class="md-checkbox-v2">
                        <label for="{{$unique}}" class="lbl-text no checkbox-set container">
                            <input class="check-level-{{$level}} authority {{preg_replace('/\s+/', '', $tmp['selector'])}}" id="{{$unique}}" value="1" type="checkbox" tabindex="36">
                            <input type="hidden" class="organization_cd_1" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_1'])}}">
                            <input type="hidden" class="organization_cd_2" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_2'])}}">
                            <input type="hidden" class="organization_cd_3" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_3'])}}">
                            <input type="hidden" class="organization_cd_4" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_4'])}}">
                            <input type="hidden" class="organization_cd_5" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_5'])}}">
                            <span class="checkmark"></span>
                        </label>
                    </div>
                </td>
                <td data-toggle="tooltip" data-original-title="{{$tmp['organization_nm']}}"><label class="text-overfollow {{'resize_'.$level}}" for="{{$unique}}">{{$tmp['organization_nm']}}</label></td>
            </tr>
        </table>
    </a>
<?php }
?>
@php
    $count = count($result);
@endphp
<div class="row">
    <div class="col-md-7 col-lg-5 col-xl-5">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.authority_name')}}</label>
                <span class="num-length">
                    <input type="hidden" id="authority_cd" class="form-control required" maxlength="20" value="" tabindex="1">
                    <input tabindex="1" type="text" id="authority_nm" class="form-control required" maxlength="50" value="">
                </span>
        </div>
    </div>
    <div class="col-md-7 col-lg-4 col-xl-4">
        <label class="control-label">{{__('messages.usage_category')}}</label>
        <label for="use_typ" style="margin: 0;" class="container lbl-text">&nbsp;{{__('messages.label_002')}}
            <input name="use_typ" id="use_typ" value="0" type="checkbox" tabindex="2" tab>
            <span class="checkmark"></span>
        </label>
                   
    </div>
    <div class="col-md-3 col-lg-2 col-xl-2">
        <div class="form-group">
            <label class="control-label">{{__('messages.sort_order')}}</label>
            <span class="num-length">
                <div class="input-group">
                    <input type="text" id="arrange_order" class="form-control only-number" maxlength="4" value="" tabindex="3">
                </div>
            </span>
        </div>
    </div>
</div> <!-- end .row -->

<div class="row">
    <div class="col-md-12 col-lg-6 col-lg-6 ln-12">
        <div class="row">
            <div class="col-md-12 col-lg-12 col-xl-4 col-sm-6 ">
                <p id="text__function__authority">{{__('messages.set_functions_authority ')}}</p>
            </div>

            <div class="col-md-12 col-lg-12 col-sm-6 col-xl-8 div-reflect">
                <p><button id="btn-reflect" class="btn btn-multiview-menu focusin" tabindex="4">{{__('messages.batch_reflect')}}</button></p>
                <div class="form-group">
                    <select class="form-control required " id="reflect" tabindex="4">
                        @foreach($combobox as $cb)
                            <option value="{{$cb['number_cd']}}">{{$cb['name']}}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        </div>

        <div class="table-responsive wmd-view table-fixed-header table-data">
            <table class="table table-bordered table-hover fixed-header ofixed-boder">
                <thead>
                <tr>
                    <th>{{__('messages.function_name')}}</th>
                    <th width="200">{{__('messages.use_authority')}}</th>
                </tr>
                </thead>
                <tbody>
                @foreach($result as $key=>$value)
                    <tr class="function list_function">
                        <input type="hidden" class="function_id" value="{{$value['function_id']}}">
                        <input type="hidden" class="function_nm" value="{{$value['function_nm']}}">
                        <td>{{$value['function_nm']}}</td>
                        <td>
                            <select class="form-control required authority {{$value['function_id']}}" tabindex="{{5+$key}}">
                                @foreach($combobox as $cb)
                                    <option value="{{$cb['number_cd']}}">{{$cb['name']}}</option>
                                @endforeach
                            </select>
                        </td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
    </div>

    <div class="col-md-12 col-lg-6 col-lg-6 ln-12">
        <p>{{__('messages.authority_range')}}</p>
        <label for="organization_belong_person_typ" style="margin: 0;" class="lbl-text container">&nbsp;{{__('messages.label_001')}}
            <input name="organization_belong_person_typ" id="organization_belong_person_typ" value="0" type="checkbox" tabindex="4">
            <span class="checkmark"></span>
        </label>
        <div class="table-responsive table-data table-hover ofixed-boder" id="table-organization">
            <ul>
                @if (!empty($lvl1))
                @foreach ($lvl1 as $k1 => $v1)
                    <li class="li-lv1">
                        <?php genLi(1, $v1); ?>
                        <ul>
                            <?php
                            for ($j=0; $j<count($lvl2); $j++) {
                                if ($lvl2[$j]['parent_id'] != $v1['id'] || count($M0022)<=1) continue;
                                ?>
                                <li class="li-lv2">
                                    <?php genLi(2, $lvl2[$j]); ?>
                                    <ul>
                                        <?php
                                        for ($k=0; $k<count($lvl3); $k++) {
                                            if ($lvl3[$k]['parent_id'] != $lvl2[$j]['id'] || count($M0022)<=2) continue;
                                            ?>
                                            <li>
                                                <?php genLi(3, $lvl3[$k]); ?>
                                                <ul>
                                                    <?php
                                                    for ($l=0; $l<count($lvl4); $l++) {
                                                        if ($lvl4[$l]['parent_id'] != $lvl3[$k]['id'] || count($M0022)<=3) continue;
                                                        ?>
                                                        <li>
                                                            <?php genLi(4, $lvl4[$l]); ?>
                                                            <ul>
                                                                <?php
                                                                for ($m=0; $m<count($lvl5); $m++) {
                                                                    if ($lvl5[$m]['parent_id'] != $lvl4[$l]['id'] || count($M0022)<=4) continue;
                                                                    ?>
                                                                    <li>
                                                                        <?php genLi(5, $lvl5[$m]); ?>
                                                                    </li>
                                                                    <?php
                                                                }
                                                                ?>
                                                            </ul>
                                                        </li>
                                                        <?php
                                                    }
                                                    ?>
                                                </ul>
                                            </li>
                                            <?php
                                        }
                                        ?>
                                    </ul>
                                </li>
                                <?php
                            }
                            ?>
                        </ul>
                    </li>
                @endforeach
                @endif
            </ul>
        </div>
    </div>
</div> <!-- end .row -->
<div class="row justify-content-md-center">
    {!! Helper::buttonRenderMulitireview(['saveButton']) !!}
</div>