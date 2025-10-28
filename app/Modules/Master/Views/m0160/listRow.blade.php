<table id="list-item" class="table table-bordered table-striped tbme table-ics tabl2" data-resizable-columns-id="demo-table-v2">
    <thead>
        <tr>
            {{-- 目標タイトル --}}
            <th id="item_title_display_typ" class="{{$list[0]['item_title_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['item_title_display_typ'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input class="display_typ" type="hidden" value="{{$list[0]['item_title_display_typ']}}"/>
                        <span class="num-length">
                            <input type="text" style="min-width:115px"
                                    class="form-control form-control-sm" value="{{$list[0]['item_title_title']}}"
                                    readonly="" id="item_title_title" maxlength="20" tabindex="-1"/>
                        </span>
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 目標タイトル1 ~ 目標タイトル5 --}}
            @for($i=1;$i<=5;$i++)
                <th id="item_display_typ_{{$i}}" class="{{$list[0]['item_display_typ_'.$i] =='0'?'ics-hide':''}}" style="display: {{$list[0]['item_display_typ_'.$i] =='0'?'none':''}}">
                    <div class="d-flex justify-content-between">
                        <span class="ics-textbox">
                            <input class="display_typ" type="hidden" value="{{$list[0]['item_display_typ_'.$i]}}"/>
                            <span class="num-length">
                                <input type="text" style="min-width:115px"
                                        class="form-control form-control-sm" value="{{$list[0]['item_title_'.$i]}}"
                                        readonly="" id="item_title_{{$i}}" maxlength="20" tabindex="-1"/>
                            </span>
                        </span>
                        <div class="ics-group">
                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                            </a>
                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                            </a>
                        </div><!-- end .ics-group -->
                    </div>
                </th>
            @endfor
            {{-- ウェイト --}}
            <th class="{{$list[0]['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['weight_display_typ'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input class="display_typ" type="hidden" id="weight_display_typ" value="{{$list[0]['weight_display_typ']}}"/>
                        <input type="text" style="min-width:115px"
                                class="form-control form-control-sm" id="weight_display_typ_value" value="{{$list[0]['point_calculation_typ1']==1?__('messages.weight'):__('messages.coefficient')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 難易度 --}}
            <th class="{{$list[0]['challenge_level_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['challenge_level_display_typ'] =='0'?'none':''}}">
                <input type="hidden" id="check_challenge_level" value="{{$list[0]['check_challenge_level'] ??0}}"/>
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input class="display_typ" type="hidden" id="challenge_level_display_typ"
                                value="{{$list[0]['challenge_level_display_typ']}}"/>
                        <input type="text" style="min-width:115px"
                                class="form-control form-control-sm" value="{{__('messages.level')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            <th
                class="{{$list[0]['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}} td-64"
                style="display: {{$list[0]['detail_self_progress_comment_display_typ'] =='0'?'none':''}}"
                id="detail_self_progress_comment_display_typ"
            >
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox num-length">
                        <input
                            id="detail_self_progress_comment_title"
                            type="text"
                            style="min-width:205px"
                            class="form-control form-control-sm"
                            value="{{$list[0]['detail_self_progress_comment_title']}}"
                            readonly=""
                            tabindex="-1"
                            maxlength="50"
                        />
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 進捗コメント --}}
            <th
                id="detail_progress_comment_display_typ"
                class="{{$list[0]['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}} td-66"
                style="display: {{$list[0]['detail_progress_comment_display_typ'] =='0'?'none':''}}"
            >
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox num-length">
                        <input
                            id="detail_progress_comment_title"
                            type="text"
                            style="min-width:205px"
                            class="form-control form-control-sm"
                            value="{{$list[0]['detail_progress_comment_title']}}"
                            readonly=""
                            tabindex="-1"
                            maxlength="50"
                        />
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                        </a>
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 評価 --}}
            <th class="evaluate_col">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                        <input class="display_typ" type="hidden" id="evaluation_display_typ"
                                value="{{$list[0]['evaluation_display_typ']}}"/>
                        <input type="text" style="min-width:115px"
                                class="form-control form-control-sm" value="{{__('messages.evaluation')}}"
                                readonly="">
                    </span>
                </div>
            </th>
            {{-- 自己評価コメント --}}
            <th class="{{$list[0]['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_0'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_0" value="{{$list[0]['detail_comment_display_typ_0']}}"/>
                        <input type="text" style="min-width:135px"
                                class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 一次評価者コメント --}}
            <th class="{{$list[0]['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_1'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_1" value="{{$list[0]['detail_comment_display_typ_1']}}"/>
                        <input type="text" style="min-width:145px"
                                class="form-control form-control-sm" value="{{__('messages.1st_rater_s_comment')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 二次評価者コメント --}}
            <th class="{{$list[0]['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_2'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_2" value="{{$list[0]['detail_comment_display_typ_2']}}"/>
                        <input type="text" style="min-width:145px"
                                class="form-control form-control-sm" value="{{__('messages.2st_rater_s_comment')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 三次評価者コメント --}}
            <th class="{{$list[0]['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_3'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_3" value="{{$list[0]['detail_comment_display_typ_3']}}"/>
                        <input type="text" style="min-width:145px"
                                class="form-control form-control-sm" value="{{__('messages.3st_rater_s_comment')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- 四次評価者コメント --}}
            <th class="{{$list[0]['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_4'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox">
                    <input class="display_typ" type="hidden" id="detail_comment_display_typ_4" value="{{$list[0]['detail_comment_display_typ_4']}}"/>
                        <input type="text" style="min-width:145px"
                                class="form-control form-control-sm" value="{{__('messages.4st_rater_s_comment')}}"
                                readonly="" tabindex="-1">
                    </span>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
        </tr>
    </thead>
    <tbody >
        @foreach($list as $row)
        <tr class="tr_generic_comment">
            <td class="text-center  {{$row['item_title_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$row['item_title_display_typ'] =='0'?'none':''}}">
                <span class="num-length ">
                <input type="text" class="form-control item_title" maxlength="400" value="{{$row['item_title']??''}}">
                </span>
            </td>
            @for($i=1;$i<=5;$i++)
                <td class="text-center td-{{$i}} {{$row['item_display_typ_'.$i] =='0'?'ics-hide':''}}" style="display: {{$row['item_display_typ_'.$i] =='0'?'none':''}}">
                    <span class="num-length ">
                        <input type="text" class="form-control" maxlength="15" value=""
                                disabled="disabled">
                    </span>
                </td>
            @endfor
            <td class="text-center td-6 {{$row['weight_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$row['weight_display_typ'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-7 {{$row['challenge_level_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$row['challenge_level_display_typ'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15"
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-64 {{$row['detail_self_progress_comment_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_self_progress_comment_display_typ'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input
                        type="text"
                        class="form-control"
                        maxlength="15"
                        disabled="disabled"
                    />
                </span>
            </td>
            <td class="text-center td-8 {{$row['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}} td-66" style="display: {{$row['detail_progress_comment_display_typ'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-9">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-10 {{$row['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_comment_display_typ_0'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="{{$row['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_comment_display_typ_1'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-11 {{$row['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_comment_display_typ_2'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-12 {{$row['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_comment_display_typ_3'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
            <td class="text-center td-13 {{$row['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$row['detail_comment_display_typ_4'] =='0'?'none':''}}">
                <span class="num-length ">
                    <input type="text" class="form-control" maxlength="15" value=""
                            disabled="disabled">
                </span>
            </td>
        </tr>
        @endforeach
        <tr id="tr-total">
            <td colspan="{{$list[0]['col_span']}}" class="baffbo" id="td-colspan"></td>
            <th class="ba55 text-left togcol {{$list[0]['total_score_display_typ'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['total_score_display_typ'] =='0'?'none':''}}">
                <div class="d-flex justify-content-between">
                    <span class="ics-textbox" style="white-space: nowrap" id="text_total_score_display_typ">
                    @if(isset($value['point_calculation_typ2']))
                        @if($value['point_calculation_typ2'] == 1 ) {{__('messages.total_points')}}  @else {{__('messages.average_score')}}  @endif 
                    @else   
                        @if($point_calculation_typ2 == 1 ) {{__('messages.total_points')}}  @else {{__('messages.average_score')}}  @endif
                    @endif
                </span>
                    <input class="display_typ" type="hidden" id="total_score_display_typ" value="1"/>
                    <div class="ics-group">
                        <a href="javascript:;" class="ics ics-eye-total" data-target=".td-1" tabindex="-1">
                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                        </a>
                    </div><!-- end .ics-group -->
                </div>
            </th>
            {{-- <td class="baffbo baffbo9 {{$list[0]['detail_progress_comment_display_typ'] =='0'?'ics-hide':''}}"style="display: {{$list[0]['detail_progress_comment_display_typ'] =='0'?'none':''}}"></td> --}}
            <td class="baffbo baffbo11 {{$list[0]['detail_comment_display_typ_0'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_0'] =='0'?'none':''}}"></td>
            <td class="baffbo baffbo12 {{$list[0]['detail_comment_display_typ_1'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_1'] =='0'?'none':''}}"></td>
            <td class="baffbo baffbo13 {{$list[0]['detail_comment_display_typ_2'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_2'] =='0'?'none':''}}"></td>
            <td class="baffbo baffbo14 {{$list[0]['detail_comment_display_typ_3'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_3'] =='0'?'none':''}}"></td>
            <td class="baffbo baffbo15 {{$list[0]['detail_comment_display_typ_4'] =='0'?'ics-hide':''}}" style="display: {{$list[0]['detail_comment_display_typ_4'] =='0'?'none':''}}"></td>
        </tr>
    </tbody>
</table>