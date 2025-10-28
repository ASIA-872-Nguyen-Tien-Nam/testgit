@extends('oneonone/layout')

@section('asset_header')
        <!-- START LIBRARY CSS -->
    {!!public_url('template/css/oneonone/oi3010/oi3010.index.css')!!}
@stop
@section('asset_footer')
    {!!public_url('template/js/oneonone/oi3010/oi3010.index.js')!!}
        <!-- START LIBRARY JS -->
@stop
@push('asset_button')
{!!
Helper::dropdownRender1on1(['saveButton_oi3010','backButton'])
!!}
@endpush
@section('content')
    <!-- START CONTENT -->
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-8 col-lg-9 col-12 col-xl-10 col-group">
                            <div class="form-group text-overflow-line {{!empty($condition_m2400) && $condition_m2400[0]['purpose_use_typ']==1 && $condition_m2400[0]['purpose'] != ''?'':'hidden'}}">
                                <label  class="control-label " for="">{{__('messages.questionnaire_purpose')}}</label>
                                <h6>{!! !empty($condition_m2400)?nl2br($condition_m2400[0]['purpose']):''!!}</h6>
                                <input type="hidden" id="fiscal_year" value="{{$fiscal_year??''}}">
                                <input type="hidden" id="group_cd" value="{{$group_cd??''}}">
                                <input type="hidden" id="times" value="{{$times??''}}">
                                <input type="hidden" id="questionnaire_cd" value="{{!empty($condition_m2400)?$condition_m2400[0]['questionnaire_cd']:''}}">
                                <input type="hidden" id="employee_cd" value="{{$employee_cd??''}}">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8 col-lg-9 col-12 col-xl-10 col-group">
                            <div class="form-group text-overflow-line {{!empty($condition_m2400) && $condition_m2400[0]['complement_use_typ']==1 && $condition_m2400[0]['complement'] != ''?'':'hidden'}}">
                                <label  class="control-label " for="">{{__('messages.supplementary_matter')}} </label>
                                <h6>{!! !empty($condition_m2400)?nl2br($condition_m2400[0]['complement']):''!!}</h6>
                            </div>
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-md-10 col-lg-10">
                            <div class="form-group">
                                <label class="control-label">{{__('messages.questionnaire_type')}}</label>
                                <span class="num-length">
                                    <input tabindex="-1" type="text" id="authority_nm" class="form-control" readonly  maxlength="20" value="{{!empty($condition_m2400)?$condition_m2400[0]['questionnaire_nm']:''}}">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-5 col-lg-8">

                        </div>
                        <div class="col-md-7 col-lg-4 col-12 col-group-2">
                            <div class="form-group">
                                <label class="control-label ">{{__('messages.input_date_and_time')}}
                                </label>
                                <div class="group-inline">
                                    <div class="input-group-btn input-group " style="">
                                        <input type="text" id="company_in_dt" readonly class="form-control input-sm datetime right-radius text-center"  tabindex="-1" value="{{!empty($current_times)?$current_times[0]['current_times']:''}}">
        
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
            <div class="row">
                <div class="col-md-5 col-lg-5">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.employee_name')}}</label>
                        <span class="num-length">
                            <input readonly  type="text" id="employee_nm" tabindex="-1" class="form-control"  maxlength="101" value="{{isset($member_nm[0]['employee_nm'])?$member_nm[0]['employee_nm']:''}}">
                            <input  type="hidden" id="employee_nm_2" tabindex="-1" class="form-control"  maxlength="101" value="{{isset($member_nm[0]['employee_nm'])?$member_nm[0]['employee_nm']:''}}">
                        </span>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4" >
                    <label class="control-label">&nbsp;</label>
                        <div class="md-checkbox-v2 pt-1">
                            <label for="ck_search" class="container">{{__('messages.name_withheld_by_request')}}
                                <input  name="ck111" id="ck_search" type="checkbox" tabindex="1" value="1" {{ isset($cache['ck_search'])&&($cache['ck_search'] == 1) ? 'checked' : ''}}>
                                <span class="checkmark"></span>
                            </label>
                        </div>
                </div>
                <div class="col-md-5 col-lg-5 {{!empty($condition_m2400) && $condition_m2400[0]['submit'] == 1?'hidden':''}}">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.coach')}}
                        </label>
                        <div class="input-group-btn input-group div_employee_cd">
                            <span class="num-length">
                            <input type="text" class="form-control indexTab Convert-Halfsize employee_nm" readonly  id="employee_nm" tabindex="-1" maxlength="10" value="{{isset($coach_nm[0]['employee_nm'])?$coach_nm[0]['employee_nm']:''}}" style="padding-right: 40px;" />
                            </span>
                        </div>
                    </div>
                </div>
            </div> 
            <div id="result">
                <div class="row">
                    <div class="col-md-12">
                        <div class="wmd-view-topscroll">
                            <div class="scroll-div1"></div>
                        </div>
                    </div>
                </div>
                @php
                    $check_sentence_typ = 0;
                    $check_points_typ = 0;
                    $check_width = 0;
                    $table_length = 0;
                    if(!empty($list_question)){
                        $table_length = count($list_question);

                        for($i=0;$i<$table_length;$i++){
                            if($list_question[$i]['sentence_use_typ'] != 1) {
                                $check_sentence_typ = $check_sentence_typ + 1;
                            }
                            if($list_question[$i]['points_use_typ'] != 1) {
                                $check_points_typ = $check_points_typ + 1;
                            }
                        }
                        if($check_sentence_typ == $table_length && $check_points_typ == $table_length) {
                            $check_width = 1;
                        }
                        elseif($check_sentence_typ == $table_length){
                            $check_width = 2;
                        }
                        elseif($check_points_typ == $table_length){
                            $check_width = 3;
                        }
                    }
                @endphp

                <label class=" lb-required" lb-required="{{ __('messages.required') }}" for="">{{__('messages.questionnaire_olumn')}} </label>
                    <div class="table-responsive wmd-view  " style="width: {{$check_width==1?'20%':($check_width==2?'60%':($check_width==3?'60%':''))}};    max-height: 620px">
                        <table class="table one-table sortable table-bordered table-hover ofixed-boder" id="myTable" style="margin-bottom: 10px !important">
                            <thead>
                            <tr>
                                <th class="w-80px"  style="width:20%">{{__('messages.question')}}</th>
                                <th class="w-160px th-answer-box {{ $check_sentence_typ == $table_length?'hidden':''}}">{{__('messages.answer_column')}}</th>
                                <th class="w-160px th-score {{$check_points_typ == $table_length?'hidden':''}}">{{__('messages.points')}}</th>
                            </tr>
                            </thead>
                            <tbody>
                                @if(isset($list_question))
                                @foreach ($list_question as $row)
                                    <tr class="question_list">
                                        <td class="" style="">
                                            {{$row['question']}}
                                            <input tabindex="3" hidden maxlength="200" type="text" class="form-control required question" value="{{$row['question']}}">
                                        </td>
                                        <td class="{{ $check_sentence_typ == $table_length?'hidden':''}}">
                                            <span class="num-length">
                                                <input type="hidden" class="questionnaire_gyono" value="{{$row['questionnaire_gyono']}}" tabindex="3"> 
                                                <textarea class="form-control required sentence_answer" style="height: 65px" {{$row['sentence_use_typ']==1?'':'hidden'}} cols="30" rows="2" maxlength="200" tabindex="3">{{$row['sentence_answer']??''}}</textarea>
                                            </span>
                                        </td>
                                        @if($row['points_use_typ']==2)
                                        	<td class="{{$check_points_typ == $table_length?'hidden':''}}">
                                        	</td>
                                        @else
	                                        <td class="">
	                                            <div class="radio required">
	                                                <div class="radio-v2 radio-10-5-0 radio-1 inline-block" id="md-radio-v1" style="color: #fc933c !important;">
                                                        <p class="text__point">
                                                        10 {{__('messages.point')}}
                                                        </p>
                                                        <label for="rd1_{{$row['questionnaire_gyono']}}" data-container="body" class="text-overflow-oi3010 container" data-toggle="tooltip" data-original-title="10 {{__('messages.point')}} : {{$row['guideline_10point']??''}}" style="width:59px; height:40px">
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd1_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==10?'checked':''}} value="10" tabindex="3"> 
                                                            <span class="checkradio checkradio-10-5-0"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd2_{{$row['questionnaire_gyono']}}" class="container">&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd2_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==9?'checked':''}} value="9" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd3_{{$row['questionnaire_gyono']}}" class="container" >&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd3_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==8?'checked':''}} value="8" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rdquestionnaire_gyono_{{$row['questionnaire_gyono']}}" class="container" >&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rdquestionnaire_gyono_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==7?'checked':''}} value="7" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd5_{{$row['questionnaire_gyono']}}" class="container">&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd5_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==6?'checked':''}} value="6" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="radio-10-5-0 radio-1 inline-block" style="color: #fc933c !important; width:63px; height:58px;">
                                                        <p class="text__point">
                                                        5 {{__('messages.point')}}
                                                        </p>
                                                        <label for="rd6_{{$row['questionnaire_gyono']}}" data-toggle="tooltip" class="text-overflow-oi3010 container" style="width: 140%;text-align: center; width:59px; height:40px"  data-original-title="5 {{__('messages.point')}} : {{$row['guideline_5point']??''}}">
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" {{isset($check_status[0])&& $check_status[0]['check_status'] == 0?'checked':($row['points_answer']==5?'checked':'')}} type="radio" id="rd6_{{$row['questionnaire_gyono']}}" value="5" tabindex="3">
                                                            <span class="checkradio checkradio-10-5-0"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label  for="rd7_{{$row['questionnaire_gyono']}}" class="container">&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd7_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==4?'checked':''}} value="4" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd8_{{$row['questionnaire_gyono']}}" class="container">&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd8_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==3?'checked':''}} value="3" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd9_{{$row['questionnaire_gyono']}}" class="container" >&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd9_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==2?'checked':''}} value="2" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="md-radio-v2 inline-block">
                                                        <label for="rd10_{{$row['questionnaire_gyono']}}" class="container">&nbsp;&nbsp;&nbsp;
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd10_{{$row['questionnaire_gyono']}}" {{$row['points_answer']==1?'checked':''}} value="1" tabindex="3">
                                                            <span class="checkradio"></span>
                                                        </label>
	                                                </div>
	                                                <div class="radio-10-5-0 radio-1 inline-block" style="color: #fc933c !important;  width:63px; height:58px;">
                                                    <p class="text__point">
                                                    {{__('messages.0_points')}}
                                                    </p>    
                                                        <label for="rd11_{{$row['questionnaire_gyono']}}" data-toggle="tooltip" class="text-overflow-oi3010 container" style="width: 140%;text-align: right; width:59px; height:40px" data-original-title="{{__('messages.0_points')}} : {{$row['guideline_0point']??''}}">
                                                            <input class="required" name="rdz_{{$row['questionnaire_gyono']}}" type="radio" id="rd11_{{$row['questionnaire_gyono']}}" {{isset($check_status[0]) && $check_status[0]['check_status'] == 1 && $row['points_answer']==0?'checked':''}} value="0" tabindex="3">
                                                            <span class="checkradio checkradio-10-5-0"></span>
                                                        </label>
	                                                </div>
	                                            </div>
	                                        </td>
	                                    @endif
                                    </tr>
                                @endforeach
                                @endif
                            </tbody>
                        </table>
                    </div><!-- end .row -->
                    <br/>
                <div class="row" style="margin-bottom: 1em">
                    <div class="col-md-12">
                        <label for="">{{__('messages.free_entry_field')}}</label>
                        <span class="num-length">
                            <textarea maxlength="400" class="form-control comment" cols="30" rows="4" maxlength="400" id="comment" tabindex="4">{{isset($comment[0])?$comment[0]['comment']:''}}</textarea>
                        <input type="hidden" id="answer_no" value="{{isset($comment[0])?$comment[0]['answer_no']:''}}">
                        </span>
                    </div>
                </div>
                <div class="row justify-content-md-center">
                    {!! Helper::buttonRender1on1(['saveButton_oi3010']) !!}
                </div>
            </div>
        </div> <!-- end .card-body -->
    </div><!-- end .card -->
    <input type="hidden" class="anti_tab">
    <input type="hidden" id="from" value="{{ $from ??'' }}">
    <input type="hidden" id="source_from" value="{{ $source_from ??'' }}">
</div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop