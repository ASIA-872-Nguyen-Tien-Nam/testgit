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
    .box-no{
        height: 66px;
        border: 1px solid #dee2e6;
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
                <label>面談記録</label>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                        <tr>
                            <th >面談</th>
                            <th >実施日</th>
                            <th class="min-w150" >本人コメント</th>
                            <th class="min-w150" >一次評価者コメント</th>


                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>期首面談</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 1</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 2</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 3</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 4</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 5</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 6</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 7</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 8</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 9</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 10</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 11</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>期首面談 12</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>フィードバック面談</td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>

                        </tbody>
                    </table>


                </div>
            </div>







        </div><!-- end .row -->



    </div>

@stop