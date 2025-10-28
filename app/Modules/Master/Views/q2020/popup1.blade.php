@extends('popup')
@push('action') rm-act @endpush
@push('asset_button')

@endpush

@section('asset_header')
        <!-- START LIBRARY CSS -->
<style type="text/css">
    .p0{
        padding: 0;
    }
    .min-w100{
        min-width: 100px;
    }
    .min-w150{
        min-width: 150px;
    }
    .w-50{
        width: 50px;
        min-width: 50px;
        max-width: 50px;
    }
    .w250{
        width: 250px;
    }
    .border-none{
        border: none !important;
    }
    .table-fix{
        table-layout: fixed;
    }
    .marb1{
        margin-bottom: 1rem;
    }
    .box-no{
        height: 66px;
        border: 1px solid #dee2e6;
    }
    .backfff{
        background-color: #fff !important;
    }
    .backe5{
        background: #E5E5E5;
    }
</style>


@stop
@section('content')

    <div class="card-body">




        <div class="row">
            <div class="col-md-10">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th>年度</th>
                            <th>社員番号</th>
                            <th>氏名</th>
                            <th>等級</th>
                            <th>役職</th>
                            <th>職種</th>
                            <th>一次評価者氏名</th>
                            <th>二次評価者氏名</th>
                            <th>三次評価者氏名</th>
                            <th>四次評価者氏名</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div><!-- end .col-md-6 -->
            <div class="col-md-2">

                <div class="box-no col-md-12 float-right ">
                    評価シートタイプ
                </div>



            </div><!-- end .col-md-6 -->


            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th>汎用コメント ①</th>
                            <th>汎用コメント ②</th>
                            <th>汎用コメント ③</th>
                            <th>汎用コメント ④</th>
                            <th>汎用コメント ⑤</th>

                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>


            <div class="col-md-12 marb1">
                <label>目標管理</label>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th class="w-50">No</th>
                            <th class="min-w100">タイトル 1</th>
                            <th class="min-w100">タイトル 2</th>
                            <th class="min-w100">タイトル 3</th>
                            <th class="min-w100">タイトル 4</th>
                            <th class="min-w100">タイトル 5</th>
                            <th class="min-w100">ウェイト</th>
                            <th class="min-w100">難易度</th>
                            <th class="min-w100">本人進移コメント</th>
                            <th class="min-w100">一次進移コメント</th>
                            <th class="min-w100">本人評価コメント</th>
                            <th class="min-w100">一次評価者コメント</th>
                            <th class="w-50">自己評価</th>
                            <th class="w-50">一次評価</th>
                            <th class="w-50">二次評価</th>
                            <th class="w-50">三次評価</th>
                            <th class="w-50">四次評価</th>

                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td class="border-none text-right backfff" colspan="11"></td>
                            <td class="border-none text-right backe5">素点</td>

                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td class="border-none text-right backfff" colspan="11"></td>
                            <td class="border-none text-right backe5">調整点</td>

                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td class="border-none text-right backfff" colspan="11"></td>
                            <td class="border-none text-right backe5">評価点</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        <tr>
                            <td class="border-none text-right backfff" colspan="11"></td>
                            <td class="border-none text-right backe5" >評語</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        </tbody>
                    </table>


                </div>
            </div>



            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th>本人評価コメント欄</th>
                            <th>一次評価コメント欄</th>
                            <th>二次評価コメント欄</th>
                            <th>三次評価コメント欄</th>
                            <th>四次評価コメント欄</th>

                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>&nbsp;</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>

                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>



            <div class="col-md-4">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-fix table-striped">
                        <thead>
                        <tr>
                            <th colspan="5">評価基準</th>


                        </tr>
                        </thead>
                        <thead>
                        <tr>
                            <th colspan="1">評価点</th>
                            <th colspan="4">評価基準</th>


                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td colspan="1" class="text-right">1</td>
                            <td colspan="4">ができる</td>
                        </tr>
                        <tr>
                            <td colspan="1"  class="text-right">2</td>
                            <td colspan="4">ができる</td>
                        </tr>
                        <tr>
                            <td colspan="1"  class="text-right">3</td>
                            <td colspan="4">ができる</td>
                        </tr>
                        <tr>
                            <td colspan="1"  class="text-right">4</td>
                            <td colspan="4">ができる</td>
                        </tr>
                        <tr>
                            <td colspan="1"  class="text-right">5</td>
                            <td colspan="4">ができる</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>



        </div><!-- end .row -->



    </div>

@stop