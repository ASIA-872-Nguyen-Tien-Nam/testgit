@php
    function ordinal1($number) {
    $ends = array('th','st','nd','rd','th','th','th','th','th','th');
	if( \Session::get('website_language', config('app.locale')) != 'en')
		return  '';
    elseif ((($number % 100) >= 11) && (($number%100) <= 13))
        return  'th';
    else
        return  $ends[$number % 10];
	}
	@endphp	
<div class="row {{!empty($target)?"":"hidden"}}">
    <div class="col-md-3 col-lg-6 col-md-6 col-sm-12 col-12 wrapper {{ !empty($target) && $target[0]['target1_use_typ'] == 0 ?"hidden":''  }}">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{ !empty($target) ? $target[0]['target1_nm']:'' }}</label>
            <span class="num-length">
                @if ($target_can_edited == 0)
                <textarea disabled style="height: 120px" class="form-control" 
                cols="30" rows="4" maxlength="1000" id="generic_comment_1" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['target1']:'') }}</textarea>
                @else
                <textarea style="height: 120px" class="form-control" 
                cols="30" rows="4" maxlength="1000" id="generic_comment_1" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['target1']:'') }}</textarea>
                @endif
            </span>
        </div>
    </div>
    <div class="col-md-3 col-lg-6 col-md-6 col-sm-12 col-12 wrapper {{ !empty($target) && $target[0]['target2_use_typ'] == 0 ?"hidden":''  }}">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{ !empty($target) ? $target[0]['target2_nm']:'' }}</label>
            <span class="num-length">
                @if ($target_can_edited == 0)
                <textarea disabled style="height: 120px" class="form-control"   cols="30" rows="4" maxlength="1000" id="generic_comment_2" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['target2']:'') }}</textarea>
                @else
                <textarea style="height: 120px" class="form-control"   cols="30" rows="4" maxlength="1000" id="generic_comment_2" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['target2']:'') }}</textarea> 
                @endif
            </span>
        </div>
    </div>
    <div class="col-md-3 col-lg-6 col-md-6 col-sm-12 col-12 wrapper {{ !empty($target) && $target[0]['target3_use_typ'] == 0 ?"hidden":''  }}">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{ !empty($target) ? $target[0]['target3_nm']:'' }}</label>
            <span class="num-length">
                @if ($target_can_edited == 0)
                <textarea disabled style="height: 120px" class="form-control"  cols="30" rows="4" maxlength="1000" id="generic_comment_3" tabindex="8">{{$check==1?'':(!empty($target) ? $target[0]['target3']:'') }}</textarea>
                @else
                <textarea style="height: 120px" class="form-control"  cols="30" rows="4" maxlength="1000" id="generic_comment_3" tabindex="8">{{$check==1?'':(!empty($target) ? $target[0]['target3']:'') }}</textarea>
                @endif
            </span>
        </div>
    </div>
    <div class="col-md-3 col-lg-6 col-md-6 col-sm-12 col-12 wrapper {{ !empty($target) && $target[0]['comment_use_typ'] == 0 ?"hidden":''  }}">
        <div class="form-group">
            <label class="control-label label-itemimportant">{{ !empty($target) ? $target[0]['comment_nm']:'' }}</label>
            <span class="num-length">
            @if ($coach_comment_can_edited == 0 && $target_can_edited == 0)
                <textarea disabled style="height: 120px" class="form-control"  cols="30" rows="4" maxlength="400" id="generic_comment_4" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['comment']:'') }}</textarea>
                @else
                <textarea style="height: 120px" class="form-control"  cols="30" rows="4" maxlength="400" id="generic_comment_4" tabindex="8">{{ $check==1?'':(!empty($target) ? $target[0]['comment']:'') }}</textarea>
                @endif
            </span>
        </div>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <nav class="pager-wrap">
        </nav>
        <div class="row">
            <div class="col-md-12">
                <div class="wmd-view-topscroll">
                    <div class="scroll-div1"></div>
                </div>
            </div>
        <!-- </div>
        <div class="row"> -->
            <div class="col-md-12">
                <div id="topTable" class=" wmd-view table-responsive sticky-headers sticky-ltr-cells _width" style="background-attachment: fixed;{{ !empty($list_result)?'max-height:660px':'' }}">
                    <table class="table table-bordered table-hover ofixed-boder" id="table-data">
                        <thead>
                        <tr>
                            <th class="w-detail-col2" colspan="7" style="padding-left:30%;text-align: unset ">{{ __('messages.1on1_history') }}</th>
                        </tr>
                        <tr class="tr2">
                            <th class="w-detail-col2" style="width: 70px;padding: 0;">{{ __('messages.number_times') }}</th>
                            <th style="width: 150px;min-width:150px;">{{ __('messages.title') }}</th>
                            <th class="w-detail-col3" style="width: 145px">{{ __('messages.implementation_date') }}</th>
                            <th class="w-detail-col12" style="width: 100px;">{{ __('messages.coach') }}</th>
                            <th class="w-detail-col4" style="width: 140px;">{{ __('messages.adequacy') }}</th>
                            <th class="w-detail-col5" >{{ __('messages.member_comment') }}</th>
                            <th class="w-detail-col6" >{{ __('messages.coach_comment') }}</th>
                        </tr>
                        </thead>
                        <tbody>
                        @if(!empty($list_result))
                            @foreach($list_result as $result)
                            <tr class="show-popupX" style="cursor: pointer;">
                                <td class="text-center w-detail-col12 list-img " style="padding: 0;min-width: 45px">
                                    <!-- 2.edited -->
                                    @if($result['authority'] == 2)
                                        <a class="times" href="#" tabindex="-1">{{$result['times']}}</a>
                                    @elseif($result['authority'] == 1 && $result['f2200_data_is_view'] == 1)
                                        <a class="times" href="#" tabindex="-1">{{$result['times']}}</a>
                                    @elseif($result['authority'] == 1 && $result['f2200_data_is_view'] == 0)
                                        {{$result['times']}}
                                    @else
                                        {{$result['times']}}
                                    @endif
                                </td>
                                <td>
                                    {{ $result['title']=='' ?  __('messages.th_time',['number'=>$result['times']??'']).ordinal1($result['times']) : $result['title'] }}    
                                </td>
                                <td class=" w-detail-col4 list-img text-center" style="min-width: 160px">
                                    @if($result['authority'] == 1)
                                        {{$result['interview_date']}}
                                    @elseif($result['authority'] == 2)
                                        <div class="input-group-btn input-group div_popup_meeting" style="width: 100%" 
                                            employee_cd="{{ $result['employee_cd'] }}" fiscal_year="{{ $result['fiscal_year'] }} " times="{{  $result['times'] }}" from="oQ2020">
                                            <input type="text"  
                                            class="form-control input-sm date right-radius oneonone_schedule_date" placeholder="yyyy/mm/dd" value="{{$result['interview_date']}}" tabindex="8">
                                            <div class="input-group-append-btn">
                                                <button class="btn-transparent popup  btn_popup_meeting"  
                                                employee_cd="{{$result['employee_cd']}}" times="{{$result['times']}}" type="button" tabindex="-1"><i class="fa fa-calendar"></i></button>
                                            </div>
                                        </div>
                                    @endif
                                </td>
                                <td class="w-detail-col5 list-img" style="min-width: 70px; max-width:300px">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-placement="top" data-html="true" data-original-title="{!! nl2br($result['coach_mn']) !!}">
                                        {{$result['coach_mn']}}
                                    </div>
                                </td>
                                <td class="w-detail-col6 text-center list-img" style="min-width: 70px"> 
                                    <!-- 2.edited or 1.only view when f2200 coach inserted -->
                                    @if($result['f2200_data_is_view'] == 1)
                                        @if($result['picture'] != '' || $result['picture'] != null)
                                            <img src="/uploads/ver1.7/odashboard/{{$result['picture']}}"/>
                                        @else
                                            <span></span>
                                        @endif
                                    @endif
                                </td>
                                <td class="w-detail-col7 list-img" style="max-width: 340px;min-width: 120px;">
                                    @if($result['f2200_data_is_view'] == 1)
                                        <h6>{!! !empty($result['member_comment'])?nl2br($result['member_comment']):''!!}</h6>
                                    @endif
                                </td>
                                <td class="w-detail-col9 list-img" style="max-width: 340px;min-width: 120px;">
                                    @if($result['f2200_data_is_view'] == 1)
                                        <h6>{!! !empty($result['coach_comment1'])?nl2br($result['coach_comment1']):''!!}</h6>
                                    @endif
                                </td>
                            </tr>
                            @endforeach
                        @else 
                            <tr>
                                <td colspan="7" class="w-div-nodata  no-hover text-center">{{ $_text[21]['message'] }}</td>
                            </tr>
                        @endif
                        </tbody>
                    </table>
                </div><!-- end .row -->
                <div class="row justify-content-md-center">
                    @if(isset($permission) && $permission == 2)
						{!! Helper::buttonRender1on1(['saveButton']) !!}
				    @endif
                </div>
            </div>
        </div><!-- end .card-body -->
    </div><!-- end .card-body -->
</div>