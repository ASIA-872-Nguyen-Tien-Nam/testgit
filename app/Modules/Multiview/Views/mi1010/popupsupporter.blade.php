@extends('popup')

@push('header')
{!!public_url('template/css/mulitiview/popupsupporter/popupsupporter.index.css')!!}
@endpush
 
@section('asset_footer')
{!!public_url('template/js/mulitiview/mi1010/popupsupporter.js')!!}
@stop

@section('content')

<?php
function genLi($level, $tmp)
{
    $unique = md5(uniqid(rand(), true));
?>
    <a href="javascript:void(0)" class="lv{{$level}} list_browsing">
        <table class="ck-inline">
            <tr>
                <td class="td1-level{{$level}}">
                    <div class="md-checkbox-v2">
                        <label for="{{$unique}}" class="container lbl-text">
                            <input class="check-level-{{$level}} browsing_kbn_{{$tmp['id']}} browsing_kbn cb_focus" id="{{$unique}}" {{$tmp['flg_check']==1?'checked':''}} value="{{$tmp['flg_check']??''}}" type="checkbox" tabindex="1">
                            <span class="checkmark ck_{{$level}}"></span>
                        </label>
                        <input type="hidden" class="position_cd" value="{{$tmp['position_cd']??''}}">
                    </div>
                </td>
                <td><label class="check-for-lbl" for="">{{$tmp['nm']}}</label></td>
            </tr>
        </table>
    </a>
<?php }
?>
<div class="container-fluid">
    <div class="col-md-12">
        <div class="table-responsive table-data table-hover" id="table-organization">
            <ul>
                @if (!empty($lvl1))
                @foreach ($lvl1 as $k1 => $v1)
                <li class="li-lv1">
                    <?php genLi(1, $v1); ?>
                    <ul class="browsing_position_list">
                        <?php
                        for ($j = 0; $j < count($lvl2); $j++) {
                            if ($lvl2[$j]['parent_id'] != $v1['id']) continue;
                        ?>
                            <li class="li-lv3">
                                <?php genLi(3, $lvl2[$j]); ?>
                            </li>
                        <?php
                        }
                        ?>
                    </ul>
                </li>
                @endforeach
                @else
                <div class="no-hover text-center">{{ $_text[21]['message'] }}</div>
                @endif
            </ul>
        </div>
    </div>
    <div class="row justify-content-md-center" style="margin-top: 30px;">
        {!!
        Helper::buttonRenderMulitireview(['saveButton'])
        !!}
    </div>


</div>
@stop