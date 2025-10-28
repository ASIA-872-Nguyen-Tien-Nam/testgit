<div class="row " id="hide-show-table">
    <div class="col-md-12 col-lg-12 col-xl-12 col-sm-12 col-12 table-1">
        <label class="control-label mt-10">{{__('messages.purpose')}}</label>
        <div class="table-responsive wmd-view  table-data">
            <table class="table table-bordered table-bordered-hover  ofixed-boder">
                <thead>
                    <tr class="tr-table">
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! __('messages.position') !!}">
                            {{__('messages.position')}}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! __('messages.job') !!}">
                            {{__('messages.job')}}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! __('messages.grade') !!}">
                            {{__('messages.grade')}}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! __('messages.employee_classification') !!}">
                            {{__('messages.employee_classification')}}
                            </div>
                        </th>
                        <th class="col-tb1" style="max-width:230px">
                            <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{!! __('messages.implement_times') !!}">
                                {{__('messages.implement_times')}}
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody >
                    @if(isset($table_info))
                        <tr class="list">
                            <td class="text-center" style="max-width:230px">
                                <span class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$table_info['position_nm']??''}}">
                                    {{$table_info['position_nm']??''}}
                                    </div>    
                                </span>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <span class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$table_info['job_nm']??''}}">
                                    {{$table_info['job_nm']??''}}
                                </div>    
                                </span>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <span class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$table_info['grade_nm']??''}}">
                                {{$table_info['grade_nm']??''}}
                                </div>    
                                </span>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <span class="{{($table_info['detail_status']??0) > 1 ? 'hidden' : ''}}">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title="{{$table_info['employee_typ_nm']??''}}">
                                {{$table_info['employee_typ_nm']??''}}
                                </div>  
                                </span>
                            </td>
                            <td class="text-center text-fix" style="max-width:230px">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="left" data-html="true" data-original-title=" {{$table_info['times']??''}}">
                                {{$table_info['times']??''}}
                                </div>  
                            </td>
                        </tr>
                    @else
                        <tr>
                            <td colspan="5"  class="w-popup-nodata no-hover text-center"> {{ $_text[21]['message'] }}</td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div>
<div class="row mt-10">
    <div class="col-md-12 mt-10 col-lg-12 col-xl-12 col-sm-12 col-12 table-2">
        <div class="table-responsive wmd-view  table-data sticky-table sticky-headers sticky-ltr-cells">
            <table class="table table-bordered table-hover  ofixed-boder">
                <thead>
                    <tr>
                        <th style="width: 80px !important">1on1 </th>
                        <th class="col-tb2">{{__('messages.title')}}</th>
                        <th class="col-tb2 " style="max-width: 170px;width: 170px">{{__('messages.start_dates')}}</th>
                        <th  style="width: 40px !important"></th>
                        <th class="col-tb2 "style="max-width: 170px;width: 170px">{{__('messages.time_limit')}}</th>
                        <th class="col-tb2 ">{{__('messages.alert')}}</th>
                    </tr>
                </thead>
                <tbody >
                    @if(isset($table_schedule[0]))
                        @foreach($table_schedule as $row)
                        <tr class="list_schedule">
                            <td class="text-center">
                                {{ __('messages.label_026', ['number' => $row['times']])}}
                                <input type="hidden" class="times" value="{{$row['times']}}">
                            </td>
                            <td class="text-center">
                                <span class="num-length">

                                    <input type="text" class="form-control oneonone_title" maxlength="20" value="{{$row['oneonone_title']}}" tabindex="3">
                                </span>
                            </td>
                            <td class="text-center" >

                                <div class="gflex">
                                    <div class="input-group-btn input-group" style="width: 160px">
                                        <input type="text" class="form-control input-sm date right-radius start_date required" placeholder="yyyy/mm/dd" value="{{$row['start_date']}}" tabindex="3">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
                                        </div>
                                    </div>
                                </div><!-- end .gflex -->
                            </td>
                            <td class="text-center">
                                <span style="font-size: 25px">~</span>
                            </td>
                            <td class="text-center">
                                <div class="gflex">
                                    <div class="input-group-btn input-group" style="width: 160px">
                                        <input type="text" class="form-control input-sm date right-radius deadline_date required" placeholder="yyyy/mm/dd" value="{{$row['deadline_date']}}" tabindex="3">
                                        <div class="input-group-append-btn">
                                            <button class="btn btn-transparent" type="button" data-dtp="dtp_JGtLk" tabindex="-1" style="background: none !important;"><i class="fa fa-calendar"></i></button>
                                        </div>
                                    </div>
                                </div><!-- end .gflex -->
                            </td>
                            <td class="text-center">
                                <select name="" id="" class="form-control required oneonone_alert" tabindex="3">
                                    <option {{$row['alert'] == 1?'selected':''}} value="1">{{__('messages.dont_notify')}}</option>
                                    <option {{$row['alert'] == 2?'selected':''}} value="2">{{__('messages.notify')}}</option>
                                </select>
                            </td>
                        </tr>
                        @endforeach
                    @else
                        <tr>
                            <td colspan="6"  class="w-popup-nodata no-hover text-center"> {{ $_text[21]['message'] }}</td>
                        </tr>
                    @endif
                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>

</div>
<div class="row justify-content-md-center">
    {!!
        Helper::buttonRender1on1(['saveButton'])
    !!}
</div>