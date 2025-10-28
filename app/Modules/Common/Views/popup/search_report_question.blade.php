<div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12" id="popup-paging-rquestion">
    <nav class="pager-wrap row">
        {{ Paging::show($paging) }}
    </nav>
</div>
<div class="card-body col-md-12" style="padding: 0px">
    <div class="table-responsive  sticky-table sticky-headers sticky-ltr-cells" style="max-height: calc(100vh - 180px);">
        <table class="table one-table  table-bordered  ofixed-boder" id="table-popup">
            <thead>
                <tr>
                    <th class="text-center" style="width:35%">
                        {{ __('rm0200.title') }}</th>
                    <th class="text-center" style="width:40%">
                        {{ __('rm0200.question') }}</th>
                    <th class="text-center" style="width:25%">
                        {{ __('rm0200.answer_type') }}</th>
                </tr>
            </thead>
            <tbody>
                @if (isset($list[0]))
                    @foreach ($list as $value)
                        <tr class="tr popup-detail_row">
                            <td class="mid-cate popup-detail_previous">
                                <span class="num-length">
                                    {{ $value['question_title'] }}
                                </span>
                            </td>
                            <td class="popup-detail" question_no="{{$value['question_no']}}">
                                <span class="num-length">
                                    {{ $value['question'] }}
                                </span>
                            </td>
                            <td rowspan="1" class="low-cate  popup-detail_after " low_cate_cd="1">
                                <span class="num-length">
                                    {{ $value['answer_type'] }}
                                </span>
                            </td>
                        </tr>
                    @endforeach
                @else
                    <tr>
                        <td colspan="100%" class="w-div-nodata  no-hover text-center">
                            {{ $_text[21]['message'] }}
                        </td>
                    </tr>
                @endif
            </tbody>
        </table>
    </div><!-- end .table-responsive -->
</div>
