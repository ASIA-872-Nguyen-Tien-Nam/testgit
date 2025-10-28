<nav class="pager-wrap">
</nav>
<div class="row">
    <div class="col-md-12">
        <label class="control-label ">&nbsp;</label>
        @if($supporter_permission_typ >= 2)
        <span style="color: #2B71B9;float:right">
            <b>※{{__('messages.the_blue_part_of_the_title')}}</b>
        </span>
        @endif
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="wmd-view-topscroll">
            <div class="scroll-div1"></div>
        </div>
    </div>
    <div class="col-md-12">
        <div id="topTable" class="wmd-view table-responsive _width" style="background-attachment: fixed;max-height: 450px;">
            <table class="table table-bordered table-hover table_sort one-table table-special ofixed-boder" id="table-data">
                <thead>
                    <tr>
                        <th num="9" group="X" class="text-sort" style="width:90px">
                            <span class="text-nowrap">{{ __('messages.employee_name')}}
                                <span><i class="fa fa-sort sort"></i></span>
                            </span>
                        </th>
                        <th num="10" group="X" class="text-sort" style="width: 90px;">
                            <span class="text-nowrap">{{ __('messages.review_date') }}
                                <span><i class="fa fa-sort sort"></i></span>
                            </span>
                        </th>
                        <th num="11" group="X" class="text-sort" style="width: 90px">
                            <span class="text-nowrap">{{ __('messages.supporter') }}
                                <span><i class="fa fa-sort sort"></i></span>
                            </span>
                        </th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width:180px; min-width:180px" >{{ __('messages.title_table_mq2000') }}<br> {{ __('messages.project_issue') }}</th>
                        <th rowspan="2" group="X" class="hide-group-x large_column" style="width: 390px">{{ __('messages.content') }}</th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 50px">{{ __('messages.evaluation')}}①<br>（{{ __('messages.point')}}）</th>
                        <!-- only admin -->
                        @if($supporter_permission_typ >= 2)
                        <th rowspan="2" group="X" class="hide-group-x" style="width:90px;min-width: 90px;background:#2B71B9;color:white">{{__('messages.1st_rater')}}</th>
                        @endif
                        @if($supporter_permission_typ >= 2)
                        <th rowspan="2" group="X" class="hide-group-x large_column" style="width: 390px;background:#2B71B9;color:white">{{__('messages.1st_rater_s_comment')}}</th>
                        @endif                        
                        @if($supporter_permission_typ >= 2)
                        <th rowspan="2" group="X" class="hide-group-x" style="width:105px;min-width: 105px; max-width:84px;background:#2B71B9;color:white">{{__('messages.degree_of_importance_2_mq2000_up')}} <br> {{__('messages.degree_of_importance_2_mq2000_down')}}</th>
                        @endif
                        @if($supporter_permission_typ >= 2)
                        <th rowspan="2" group="X" class="hide-group-x" style="width:105px;min-width: 105px; max-width:84px;background:#2B71B9;color:white">{{__('messages.final_evaluation_points_mq2000_up')}}<br>{{__('messages.final_evaluation_points_mq2000_down')}}</th>
                        @endif
                    </tr>
                </thead>
                <tbody>
                    @if(!empty($views))
                    @foreach ($views as $row)
                    
                    <tr style="cursor: pointer;" class="list_importance_point">
                        <td group="X" class="" num="9" style="max-width:90px">
                        @if($enable_link == true)
                            <a href="#" class="btn-to-review-input">
                            {{$row['employee_nm']}}
                            <input type="hidden" class="employee_cd order_by" value="{{$row['employee_cd']??''}}" />
                            <input type="hidden" class="detail_no" value="{{$row['detail_no']??''}}" />
                            <input type="hidden" class="supporter_cd" value="{{$row['supporter_cd']??''}}" />
                            </a>
                        @elseif($current_user == $row['supporter_cd'] && $enable_link == false)
                            <a href="#" class="btn-to-review-input">
                            {{$row['employee_nm']}}
                            <input type="hidden" class="employee_cd order_by" value="{{$row['employee_cd']??''}}" />
                            <input type="hidden" class="detail_no" value="{{$row['detail_no']??''}}" />
                            <input type="hidden" class="supporter_cd" value="{{$row['supporter_cd']??''}}" />
                            </a>
                        @else
                        {{$row['employee_nm']}}
                        <input type="hidden" class="employee_cd order_by" value="{{$row['employee_cd']??''}}" />
                            <input type="hidden" class="detail_no" value="{{$row['detail_no']??''}}" />
                            <input type="hidden" class="supporter_cd" value="{{$row['supporter_cd']??''}}" />
                        @endif
                        </td>
                        <td group="X" class="text-center" num="10">
                            {{$row['review_date']}}
                            <input type="hidden" class="order_by" value="{{$row['review_date']??''}}" />
                        </td>
                        <td group="X" class="" num="11" style="max-width: 60px">
                            {{$row['supporter_nm']}}
                            <input type="hidden" class="order_by" value="{{$row['supporter_cd']??''}}" />
                        </td>
                        <td group="X" class="hide-group-x"  style="max-width: 60px">
                            {!! nl2br($row['project_title']) !!}    
                        </td>
                        <td group="X" class="hide-group-x" style="max-width: 60px">
                            {!! nl2br($row['comment']) !!}    
                        </td>
                        <td group="X" class="hide-group-x text-right">
                            {{ $row['evaluation_point'] }}
                        </td>
                        <!-- only admin -->
                        @if($supporter_permission_typ >= 2)
                        <td group="X" class="hide-group-x" style="max-width: 60px">
                            {{$row['rater_employee_nm_1']}}
                        </td>
                        @endif
                        @if($supporter_permission_typ >= 2)
                        <td group="X" class="hide-group-x">
                            @if($row['authority_row_typ'] == 2)
                            <span class="num-length">
                                <div class="input-group-btn">
                            <!-- <input type="text" class="form-control rater_employee_comment_1"  tabindex="11" maxlength="50" value="{{$row['rater_employee_comment_1']??''}}"> -->
                            <span class="num-length">
                                <textarea class="form-control rater_employee_comment_1" maxlength="50" rows="3" cols="20" style="height:60px">{{$row['rater_employee_comment_1']??''}}</textarea>
                            </span>
                            <input type="hidden" class="form-control rater_employee_cd_1" value="{{$row['rater_employee_cd_1']??''}}">
                                </div>
                            </span>
                            @elseif($row['authority_row_typ'] == 1)
                                {{$row['rater_employee_comment_1']??''}}
                            @endif
                        </td>
                        @endif
                        @if($supporter_permission_typ >= 2)
                        <td group="X" class="hide-group-x text-right select-right">
                            @if($row['authority_row_typ'] == 2)
                            <select evaluation_point={{$row['evaluation_point']}}  tabindex="11" class="form-control text-right importance_point" {{$row['evaluation_point']==0?'disabled':''}}>
                                <option value="0" {!!$row['importance_point'] == '0'?'selected':''!!} class="text-right">0.0</option>
                                <option value="0.5" {!!$row['importance_point'] == '0.5'?'selected':''!!} class="text-right">0.5</option>
                                <option value="1" {!!$row['importance_point'] == '1' ?'selected':''!!} class="text-right">1.0</option>
                                <option value="1.5" {!!$row['importance_point'] == '1.5'?'selected':''!!} class="text-right">1.5</option>
                                <option value="2" {!!$row['importance_point'] == '2.0'?'selected':''!!} class="text-right">2.0</option>
                            </select>
                            @elseif($row['authority_row_typ'] == 1)
                                {!!$row['importance_point']??''!!}
                                <input type="hidden" value="{!!$row['importance_point']??''!!}" class="importance_point">
                            @else
                                <input type="hidden" value="0" class="importance_point">
                            @endif
                        </td>
                        @endif
                        @if($supporter_permission_typ >= 2)
                        <td group="X" class="hide-group-x text-right sum_point">
                            @if($row['authority_row_typ'] == 1 || $row['authority_row_typ'] == 2)
                                {{$row['point'] == 0?'0.0点': number_format($row['point'],1).''. __('messages.point')}}
                            @endif
                        </td>
                        @endif
                        <!-- hidden -->
                        <input type="hidden" class="point" value="{{ $row['point'] ?? 1 }}">
                        <input type="hidden" class="detail_no" value="{{ $row['detail_no'] ?? 0 }}">
                        <input type="hidden" class="employee_cd" value="{{ $row['employee_cd'] ??'' }}">
                        <input type="hidden" class="supporter_cd" value="{{ $row['supporter_cd'] ??'' }}">
                        <input type="hidden" class="rater_employee_cd_1" value="{{ $row['rater_employee_cd_1'] ??'' }}">
                        <input type="hidden" class="authority_row_typ" value="{{ $row['authority_row_typ'] ?? 0 }}">
                    </tr>
                    @endforeach
                    @else
                    <tr>
                        <td colspan="10"><div class="no-hover text-center">{{ $_text[21]['message'] }}</div></td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .row -->
    </div>
    @if($supporter_permission_typ >= 2)
    <div class="col-md-12">
        <div id="topTable" class="wmd-view table-responsive _width" style="background-attachment: fixed;">
            <table class="table table-bordered table-hover table_sort one-table table-special">
                <thead>
                    <tr>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 20%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;background: white;border: 0px"></th>
                        <th rowspan="2" group="X" class="hide-group-x" style="width: 10%;text-align: left;background: #2B71B9;color:white">{{__('messages.average_score')}}</th>
                        <th rowspan="2" group="X" class="hide-group-x text-right" style="width: 10%;" id="sum-total">{{ isset($sum_total) ? $sum_total : '' }}{{__('messages.point')}}</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div><!-- end .row -->
    </div>
    @endif
</div><!-- end .card-body -->
@if($supporter_permission_typ >= 2)
<div class="row justify-content-md-center" style="margin-top: 30px;">
    {!!
    Helper::buttonRenderMulitireview(['saveButton'])
    !!}
</div>
@endif