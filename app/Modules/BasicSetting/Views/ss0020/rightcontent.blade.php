<?php
function genLi($level, $tmp) {
    $unique = md5(uniqid(rand(), true));
    ?>
    <a href="javascript:void(0)" class="lv{{$level}} list_organization">
        <table class="ck-inline">
            <tr>
                <td class="td1-level{{$level}}">
                    <div class="md-checkbox-v2">
                        <input class="check-level-{{$level}} authority {{preg_replace('/\s+/', '', $tmp['selector'])}}" id="{{$unique}}" value="1" type="checkbox" tabindex="36">
                        <label for="{{$unique}}" class="lbl-text no"></label>
                        <input type="hidden" class="organization_cd_1" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_1'])}}">
                        <input type="hidden" class="organization_cd_2" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_2'])}}">
                        <input type="hidden" class="organization_cd_3" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_3'])}}">
                        <input type="hidden" class="organization_cd_4" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_4'])}}">
                        <input type="hidden" class="organization_cd_5" value="{{preg_replace('/\s+/', '',$tmp['organization_cd_5'])}}">
                    </div>
                </td>
                <td data-toggle="tooltip" data-original-title="{{$tmp['organization_nm']}}"><label class="text-overfollow {{'resize_'.$level}}" for="{{$unique}}">{{$tmp['organization_nm']}}</label></td>
            </tr>
        </table>
    </a>
<?php }
?>
<div class="row">
    <div class="col-md-5">
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.authority_name') }}</label>
                <span class="num-length">
                    <input type="hidden" id="authority_cd" class="form-control required" maxlength="20" value="" tabindex="1">
                    <input tabindex="1" type="text" id="authority_nm" class="form-control required" maxlength="50" value="">
                </span>
        </div>
    </div>
    <div class="col-md-4 checkbox-div" style="max-width: 280px;">
        <label class="control-label">{{ __('messages.usage_category') }}</label>
        <table>
            <tr>
                <td style="height: 38px;">
                    <div class="md-checkbox-v2">
                        <input name="use_typ" id="use_typ" value="0" type="checkbox" tabindex="2" tab>
                        <label for="use_typ" style="margin: 0;" class="lbl-text">&nbsp;{{ __('messages.label_002') }}</label>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-md-2">
        <div class="form-group">
            <label class="control-label">{{ __('messages.sort_order') }}</label>
            <span class="num-length">
                <div class="input-group">
                    <input type="text" id="arrange_order" class="form-control only-number" maxlength="4" value="" tabindex="3">
                </div>
            </span>
        </div>
    </div>
</div> <!-- end .row -->

<div class="row">
    <div class="col-md-12 col-lg-6 col-lg-6">
        <div class="row">
            <div class="col-md-12 col-lg-12 col-xl-4 col-sm-6 ">
                <p id="size-text">{{ __('messages.set_functions_authority ') }}</p>
            </div>

            <div class="col-md-12 col-lg-12 col-sm-6 col-xl-8 div-reflect" style="left:10px">
                <p><button id="btn-reflect" class="btn btn-basic-setting-menu focusin" tabindex="4">{{ __('messages.batch_reflect') }}</button></p>
                <div class="form-group">
                    <select class="form-control required " id="reflect" tabindex="5" style ="width: 150px;">
                        @foreach($combobox as $cb)
                            <option value="{{$cb['number_cd']}}">{{$cb['name']}}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        </div>

        <div class="table-responsive wmd-view table-fixed-header table-data">
            <table class="table table-bordered table-hover fixed-header table-striped">
                <thead>
                <tr>
                    <th>{{ __('messages.function_name') }}</th>
                    <th width="200">{{ __('messages.use_authority') }}</th>
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

    <div class="col-md-6">
        <p>{{ __('messages.authority_range') }}</p>
        <table>
            <tr>
                <td style="height: 38px">
                    <div class="md-checkbox-v2 checkbox-div">
                        <input name="organization_belong_person_typ" id="organization_belong_person_typ" value="0" type="checkbox" tabindex="4">
                        <label for="organization_belong_person_typ" style="margin: 0;" class="lbl-text">&nbsp;{{ __('messages.label_001') }}</label>
                    </div>
                </td>
            </tr>
        </table>
        <div class="table-responsive table-data table-hover " id="table-organization" style="overflow-x: hidden;">
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
