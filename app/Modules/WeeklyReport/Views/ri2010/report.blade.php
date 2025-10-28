{{-- 報告書 --}}
@if (isset($report_current) && !empty($report_current))
<div class="tab-pane fade active show col-12" id="tab1">
    <div class="row">
    <div class="col-md-7 col-sm-12 col-12 col-lg-7 col-xl-7 pr-1">
        <div class="row mb-1">
            {{-- 報告日 --}}
            <div class="col-12 col-md-6 col-lg-6 col-xl-6 tab-table">
                <div class="row">
                    <label class="col-md-12 col-lg-12 col-xl-12 title">{{ $report_current['title'] ?? '' }}</label>
                </div>
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.target_period') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['target_period'] ?? ''}} </label>
                </div>
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.reporter') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['employee_nm'] ?? ''}} </label>
                </div>
                {{-- 一次承認者 --}}
                @if ($report_current['approver_employee_nm_1'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.primary_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['approver_employee_nm_1'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 二次承認者 --}}
                @if ($report_current['approver_employee_nm_2'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.secondary_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['approver_employee_nm_2'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 三次承認者 --}}
                @if ($report_current['approver_employee_nm_3'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.third_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['approver_employee_nm_3'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 四次承認者 --}}
                @if ($report_current['approver_employee_nm_4'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.fourth_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_current['approver_employee_nm_4'] ?? ''}} </label>
                </div>    
                @endif
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.report_date') }}</label>
                    <div class="col-5 col-md-5 col-lg-5 col-xl-5" style="max-width: 140px;min-width: 140px;width: 140px">
                        @php
                            $report_date = date("Y/m/d");
                            if (isset($report_current['report_date']) && $report_current['report_date'] != '') {
                                $report_date = $report_current['report_date'];
                            }
                        @endphp
                        <label style="font-weight: 700">{{ $report_date }}</label>
                        <input type="hidden" id="report_date" value="{{ $report_date }}">
                        {{-- <input type="text" disabled id="report_date" class="form-control input-sm" placeholder="yyyy/mm/dd" tabindex="-1" value="{{ $report_date }}"> --}}
                    </div>
                    <div class="col-3 col-md-3 col-lg-3 col-xl-3">
                        {{-- ステータス状態 --}}
                        <div>
                            @if (isset($report_current['status_cd']) && $report_current['status_cd'] == 1)
                            <span class="badge badge-secondary">{{ $report_current['status_nm'] ?? '' }}</span>  
                            @endif
                            @if (isset($report_current['status_cd']) && $report_current['status_cd'] > 1 && $report_current['status_cd'] < 6)                    
                            <span class="badge badge-primary">{{ $report_current['status_nm'] ?? '' }}</span>
                            @endif
                            @if (isset($report_current['status_cd']) && $report_current['status_cd'] == 6)
                            <span class="badge badge-success">{{ $report_current['status_nm'] ?? '' }}</span>  
                            @endif
                        </div>  
                    </div>
                </div>  
            </div>
            {{-- 充実度 --}}
            @if (isset($report_current['adequacy_use_typ']) && $report_current['adequacy_use_typ'] == 1)
            @if (isset($permissions['answer']) && $permissions['answer'] > 0)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                @if ($permissions['answer'] == 2)
                <div class="form-group">
                    <label>{{ $adequacy_master['name'] ?? __('ri2010.adequacy') }}</label>
                    {{-- Item dropdown --}}
                    <div class="adequacy_dropdown">
                        <div class="dropdown">
                            <table class="table one-table table-dropdown" style="width:90px ;table-layout: fixed">
                                <tbody class="table-select">
                                    <tr>
                                        <td style="padding: 0px;border-top: none;">
                                            <dt>
                                                <a class="a1 adequacy_select">
                                                    <span>
                                                        <input type="hidden" class="adequacy_value adequacy_kbn" value="{{ $report_current['adequacy_kbn'] ?? 1 }}">
                                                        @if (isset($adequacy) && !empty($adequacy))
                                                        @foreach ($adequacy as $item)
                                                            @if ($item['mark_cd'] == $report_current['adequacy_kbn'])
                                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                                                            @endif                                                        
                                                        @endforeach
                                                        @endif
                                                    </span>
                                                </a>
                                            </dt>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    {{-- Item dropdown detail --}}
                    <div class="adequacy_option" style="top: 105px;">
                        <table class="table one-table table-select" style="border: 1px solid #dee2e6;table-layout: fixed">
                            <tbody>
                                @if (isset($adequacy) && !empty($adequacy))
                                @foreach ($adequacy as $item)
                                <tr class="adequacy_option_row">
                                    <td style="padding: 10px;width: 87px;border-right: 1px solid #dee2e6;">
                                        <a title="Select this card" class="select-item image_select">
                                            <input type="hidden" class="adequacy_value adequacy_kbn" value="{{ $item['mark_cd'] ?? 0 }}">
                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />
                                        </a>
                                    </td>
                                    <td>
                                        {{ $item['explanation'] ?? '' }}
                                    </td>
                                </tr>
                                @endforeach
                                @endif
                            </tbody>
                        </table>
                    </div>
                </div>    
                @else
                <div class="form-group">
                    <label>{{ $adequacy_master['name'] ?? __('ri2010.adequacy') }}</label>
                    <br>
                    @if (isset($adequacy) && !empty($adequacy))
                    @foreach ($adequacy as $item)
                        @if ($item['mark_cd'] == $report_current['adequacy_kbn'])
                        <input type="hidden" class="adequacy_value adequacy_kbn" value="{{ $report_current['adequacy_kbn'] ?? 1 }}">
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
                @endif
            </div>
            @endif    
            @endif
            {{-- 繁忙度 --}}
            @if (isset($report_current['busyness_use_typ']) && $report_current['busyness_use_typ'] == 1)
            @if (isset($permissions['answer']) && $permissions['answer'] > 0)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                @if ($permissions['answer'] == 2)
                <div class="form-group">
                    <label>{{ $busyness_master['name'] ?? __('ri2010.busyness') }}</label>
                    {{-- Item dropdown --}}
                    <div class="adequacy_dropdown">
                        <div class="dropdown">
                            <table class="table one-table table-dropdown"
                                style="width:90px ;table-layout: fixed">
                                <tbody class="table-select">
                                    <tr>
                                        <td style="padding: 0px;border-top: none;">
                                            <dt>
                                                <a class="a1 adequacy_select">
                                                    <span>
                                                        <input type="hidden" class="adequacy_value busyness_kbn" value="{{ $report_current['busyness_kbn'] ?? 1 }}">
                                                        @if (isset($busyness) && !empty($busyness))
                                                        @foreach ($busyness as $item)
                                                            @if ($item['mark_cd'] == $report_current['busyness_kbn'])
                                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                                                            @endif                                                        
                                                        @endforeach
                                                        @endif
                                                    </span>
                                                </a>
                                            </dt>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    {{-- Item dropdown detail --}}
                    <div class="adequacy_option" style="top: 105px;">
                        <table class="table one-table table-select" style="border: 1px solid #dee2e6;table-layout: fixed">
                            <tbody>
                                @if (isset($busyness) && !empty($busyness))
                                @foreach ($busyness as $item)
                                <tr class="adequacy_option_row">
                                    <td style="padding: 10px;width: 87px;border-right: 1px solid #dee2e6;">
                                        <a title="Select this card" class="select-item image_select">
                                            <input type="hidden" class="adequacy_value busyness_kbn" value="{{ $item['mark_cd'] ?? 0 }}">
                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />
                                        </a>
                                    </td>
                                    <td>
                                        {{ $item['explanation'] ?? '' }}
                                    </td>
                                </tr>
                                @endforeach
                                @endif
                            </tbody>
                        </table>
                    </div>
                </div>
                @else
                <div class="form-group">
                    <label>{{ $busyness_master['name'] ?? __('ri2010.busyness') }}</label>
                    <br>
                    @if (isset($busyness) && !empty($busyness))
                    @foreach ($busyness as $item)
                        @if ($item['mark_cd'] == $report_current['busyness_kbn'])
                        <input type="hidden" class="adequacy_value busyness_kbn" value="{{ $report_current['busyness_kbn'] ?? 1 }}">
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
                @endif
            </div>
            @endif
            @endif
            {{-- その他 --}}
            @if (isset($report_current['other_use_typ']) && $report_current['other_use_typ'] == 1)
            @if (isset($permissions['answer']) && $permissions['answer'] > 0)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                @if ($permissions['answer'] == 2)
                <div class="form-group">
                    <label>{{ $other_master['name'] ?? __('ri2010.other') }}</label>
                    {{-- Item dropdown --}}
                    <div class="adequacy_dropdown">
                        <div class="dropdown">
                            <table class="table one-table table-dropdown"
                                style="width:90px ;table-layout: fixed">
                                <tbody class="table-select">
                                    <tr>
                                        <td style="padding: 0px;border-top: none;">
                                            <dt>
                                                <a class="a1 adequacy_select">
                                                    <span>
                                                        <input type="hidden" class="adequacy_value other_kbn" value="{{ $report_current['other_kbn'] ?? 1 }}">
                                                        @if (isset($other) && !empty($other))
                                                        @foreach ($other as $item)
                                                            @if ($item['mark_cd'] == $report_current['other_kbn'])
                                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                                                            @endif                                                        
                                                        @endforeach
                                                        @endif
                                                    </span>
                                                </a>
                                            </dt>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    {{-- Item dropdown detail --}}
                    <div class="adequacy_option" style="top: 105px;">
                        <table class="table one-table table-select" style="border: 1px solid #dee2e6;table-layout: fixed">
                            <tbody>
                                @if (isset($other) && !empty($other))
                                    @foreach ($other as $item)
                                    <tr class="adequacy_option_row">
                                        <td style="padding: 10px;width: 87px;border-right: 1px solid #dee2e6;">
                                            <a title="Select this card" class="select-item image_select">
                                                <input type="hidden" class="adequacy_value other_kbn" value="{{ $item['mark_cd'] ?? 0 }}">
                                                <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}"
                                                    width="65" />
                                            </a>
                                        </td>
                                        <td>
                                            {{ $item['explanation'] ?? '' }}
                                        </td>
                                    </tr>
                                    @endforeach
                                @endif
                            </tbody>
                        </table>
                    </div>
                </div>
                @else
                <div class="form-group">
                    <label>{{ $other_master['name'] ?? __('ri2010.other') }}</label>
                    <br />
                    @if (isset($other) && !empty($other))
                    @foreach ($other as $item)
                        @if ($item['mark_cd'] == $report_current['other_kbn'])
                        <input type="hidden" class="adequacy_value other_kbn" value="{{ $report_current['other_kbn'] ?? 1 }}">
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="65" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
                @endif
            </div>
            @endif
            @endif
            @if (!empty($supported_languages) && $supported_languages == '1')
            <div class="col-12 full-width" >
                <a id="btn_tr" class="btn btn-outline-primary bar__button" tabindex="-1">
                    {{ __('ri2010.language_conversion') }}
                </a>
            </div>           
            @endif
        </div>
        {{-- 質問一覧 --}}
        @if (isset($report_current_question) && !empty($report_current_question))
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                {{-- test --}}
                <table class="table table-bordered table-hover fixed-header table-striped table-questions table-mobile">
                    <thead>
                        <tr>
                            <th scope="col" class="question-w">{{ __('ri2010.question') }}</th>
                            <th scope="col" class="answer-w">{{ __('ri2010.answer') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($report_current_question as $question)
                        <tr class="list_question">
                            <td data-label="{{ __('ri2010.question') }}">
                                <span class="num-length pl-2">{{ $question['question'] ?? '' }}</span>
                                <input type="hidden" class="question_no" value="{{ $question['question_no'] ?? '' }}">
                            </td>
                            <td data-label="{{ __('ri2010.answer') }}">
                                @if (isset($permissions['answer']) && $permissions['answer'] > 0)
                                    {{-- 自由入力(Input text) --}}
                                    @if ($question['answer_kind'] == 1)
                                        @if ($permissions['answer'] == 1)
                                            <span class="txt-break">
                                                {!! nl2br($question['answer_sentence'] ?? '') !!}
                                                <input type="hidden" class="answer answer_sentence" value="{{ $question['answer_sentence'] ?? '' }}">                                     
                                            </span>
                                        @else
                                        <span class="num-length">
                                            <textarea class="form-control answer answer_sentence {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" autofocus maxlength="{{ $question['answer_digits'] ?? 1200 }}" tabindex="1" value="{{ $question['answer_sentence'] ?? '' }}">{{ $question['answer_sentence'] ?? '' }}</textarea>
                                        </span> 
                                        @endif
                                    </br>
                                    <span style="font-weight: bold;">{!! nl2br($question['answer_sentence_tr'] ?? '') !!}</span>
                                    @endif
                                    {{-- 数字(小数点第１位まで)(Input number) --}}
                                    @if ($question['answer_kind'] == 2)
                                    <span class="num-length">                                
                                        <input type="tel" {{ $permissions['answer'] == 1 ? 'disabled' : '' }} class="form-control answer_number text-right answer numericX1 autoNumeric-positive {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" negative="true" value="{{ $question['answer_number'] ?? '' }}" tabindex="1" decimal="1" constant_maxlength="4">
                                    </span>   
                                    @endif
                                    {{-- プルダウン（複数選択不可）(selectbox) --}}
                                    @if ($question['answer_kind'] == 3)
                                    <select {{ $permissions['answer'] == 1 ? 'disabled' : '' }} class="form-control answer_select answer {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" tabindex="1">
                                        @php
                                            $answer_combo = json_decode((htmlspecialchars_decode($question['answer_json'])),true)??[];
                                        @endphp
                                        <option value="-1"></option>
                                        @if (isset($answer_combo) && !empty($answer_combo))
                                            @foreach ($answer_combo as $option)
                                                @if ($option['detail_no'] == $question['answer_select'])
                                                <option value="{{ $option['detail_no'] }}" selected>{{ $option['detail_name'] }}</option>    
                                                @else
                                                <option value="{{ $option['detail_no'] }}">{{ $option['detail_name'] }}</option>
                                                @endif
                                            @endforeach
                                        @endif
                                    </select>
                                    @endif
                                @endif
                                {{-- 承認者のコメント --}}
                                @if (isset($report_current['comment_use_typ']) && $report_current['comment_use_typ'] == 1)
                                    @if (isset($permissions['approver_comment']) && $permissions['approver_comment'] > 0)
                                    <div class="comment_action line-top mt-1">
                                        <span class="comment_field">{{ __('ri2010.comment_field_approver') }}</span>
                                        @if (isset($permissions['btn_temporary_detail']) && $permissions['btn_temporary_detail'] == 1)
                                        <button class="btn button-1on1 comment_btn">{{ __('messages.temp_save') }}</button>
                                        @endif
                                    </div>
                                    @if ($permissions['approver_comment'] == 1)
                                        <span class="txt-break">
                                            {{-- {!! nl2br($question['approver_comment'] ?? '') !!} --}}
                                            <input type="hidden" class="approver_comment" value="{{ $question['approver_comment'] ?? '' }}">
                                            <span style="display: block;">{!! nl2br($question['approver_comment_1_show'] ?? '') !!}</span>
                                            <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_1_show_tr'] ?? '') !!}</span>
                                            <span style="display: block;">{!! nl2br($question['approver_comment_2_show'] ?? '') !!}</span>
                                            <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_2_show_tr'] ?? '') !!}</span>
                                            <span style="display: block;">{!! nl2br($question['approver_comment_3_show'] ?? '') !!}</span>
                                            <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_3_show_tr'] ?? '') !!}</span>
                                            <span style="display: block;">{!! nl2br($question['approver_comment_4_show'] ?? '') !!}</span>
                                            <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_4_show_tr'] ?? '') !!}</span>

                                        </span>
                                    @else
                                        <span class="num-length">
                                            <textarea class="form-control approver_comment" style="height: 50px;" maxlength="1200" tabindex="1" value="{{ $question['approver_comment'] ?? '' }}">{{ $question['approver_comment'] ?? '' }}</textarea>
                                        </span>  
                                        <span style="font-weight: bold;">{!! nl2br($question['approver_comment_tr'] ?? '') !!}</span>  
                                    @endif
                                    <input type="hidden" class="approver_comment_1" value="{{ $question['approver_comment_1_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_2" value="{{ $question['approver_comment_2_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_3" value="{{ $question['approver_comment_3_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_4" value="{{ $question['approver_comment_4_show'] ?? '' }}">
                                    <input type="hidden" class="approver_user_1" value="{{ $question['approver_user_1'] ?? '' }}">
                                    <input type="hidden" class="approver_user_2" value="{{ $question['approver_user_2'] ?? '' }}">
                                    <input type="hidden" class="approver_user_3" value="{{ $question['approver_user_3'] ?? '' }}">
                                    <input type="hidden" class="approver_user_4" value="{{ $question['approver_user_4'] ?? '' }}">
                                    <input type="hidden" class="approver_user_1_language" value="{{ $question['approver_user_1_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_2_language" value="{{ $question['approver_user_2_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_3_language" value="{{ $question['approver_user_3_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_4_language" value="{{ $question['approver_user_4_language'] ?? '' }}">
                                {{-- </br>
                                    <span style="font-weight: bold;">{!! nl2br($question['approver_comment_tr'] ?? '') !!}</span> --}}
                                    @endif   
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
        @endif
        {{-- 自由記入欄 --}}
        @if (isset($permissions['free_comment']) && $permissions['free_comment'] > 0)
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                <table
                    class="table table-bordered table-hover fixed-header table-striped one-table">
                    <thead>
                        <tr class="tr-table">
                            <th class="" style="text-align: left;width:100%">
                                {{ __('ri2010.comment') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100%">
                                @if ($permissions['free_comment'] == 1)
                                    <span class="txt-break">
                                        {!! nl2br($report_current['free_comment'] ?? '') !!}
                                        <input id="free_comment" type="hidden" value="{{ $report_current['free_comment'] ?? '' }}">
                                    </span>
                                @else
                                    <span class="num-length">
                                        <textarea id="free_comment" class="form-control" maxlength="1200" tabindex="3" value="{{ $report_current['free_comment'] ?? '' }}">{{ $report_current['free_comment'] ?? '' }}</textarea>
                                    </span>    
                                @endif
                            </br>
                                <span style="font-weight: bold;">{!! nl2br($report_current['free_comment_tr'] ?? '') !!}</span>
                                <input type="hidden" class="free_comment_user" value="{{ $report_current['free_comment_user'] ?? '' }}">
                                <input type="hidden" class="free_comment_user_language" value="{{ $report_current['free_comment_user_language'] ?? '' }}">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        @endif
        {{-- コメント --}}
        @if (isset($permissions['comment']) && $permissions['comment'] > 0)
        <div class="row">
            <div class="col-12 col-sm-9 col-md-9 col-lg-9 col-xl-9">
                <table
                    class="table table-bordered table-hover fixed-header table-striped one-table">
                    <thead>
                        <tr class="tr-table">
                            <th class="" style="text-align: left;width:100%">
                                <span>
                                    {{ __('ri2010.comment_field') }}
                                </span> 
                                {{-- コメントオプション --}}
                                @if (isset($permissions['btn_comment_option']) && $permissions['btn_comment_option'] == 1)
                                <button type="button" class="btn btn-outline-primary" id="btn_comment_options" tabindex="1">
                                    <i class="fa fa-plus" aria-hidden="true"></i>
                                </button>
                                @endif                                   
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100%">
                                @if ($permissions['comment'] == 1)
                                    {!! nl2br($report_current['comment'] ?? '') !!}
                                    <input id="comment" type="hidden" value="{{ $report_current['comment'] ?? '' }}">
                                    <input id="comment_check" type="hidden" value="{{ $report_current['comment'] ?? '' }}">
                                @else
                                    <span class="num-length">
                                        <textarea id="comment" class="form-control" maxlength="1200" tabindex="3" value="{{ $report_current['comment'] ?? '' }}">{{ $report_current['comment'] ?? '' }}</textarea>
                                    </span>   
                                    <input id="comment_check" type="hidden" value="{{ $report_current['comment'] ?? '' }}"> 
                                @endif
                            </br>
                                <span style="font-weight: bold;">{!! nl2br($report_current['comment_tr'] ?? '') !!}</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {{-- 充実度 --}}
            <div class="col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3 adequacy">
                @if (isset($permissions['reaction']) && $permissions['reaction'] == 2)
                {{-- Item dropdown --}}
                <div class="form-group adequacy_dropdown">
                    <div class="dropdown">
                        <table class="table one-table table-dropdown" style="width:120px ;table-layout: fixed">
                            <tbody class="table-select">
                                <tr>
                                    <td style="padding: 0px;border-top: none;">
                                        <dt>
                                            <a class="a1 adequacy_select">
                                                <span>
                                                    <input type="hidden" class="adequacy_value reaction_cd" value="{{ $report_current['reaction_cd'] ?? 1 }}">
                                                    @if (isset($reactions) && !empty($reactions))
                                                    @foreach ($reactions as $item)
                                                        @if ($item['mark_cd'] == $report_current['reaction_cd'])
                                                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80"/>        
                                                        @endif                                                        
                                                    @endforeach
                                                    @endif
                                                </span>
                                            </a>
                                        </dt>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                {{-- Item dropdown detail --}}
                <div class="adequacy_option" style="top: 77px;">
                    <table class="table one-table table-select"
                        style="border: 1px solid #dee2e6;table-layout: fixed">
                        <tbody>
                            @if (isset($reactions) && !empty($reactions))
                                @foreach ($reactions as $item)
                                <tr class="adequacy_option_row">
                                    <td style="padding: 10px;width: 110px;border-right: 1px solid #dee2e6;">
                                        <a title="Select this card" class="select-item image_select">
                                            <input type="hidden" class="adequacy_value reaction_cd" value="{{ $item['mark_cd'] ?? 0 }}">
                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />   
                                        </a>
                                    </td>
                                    <td>
                                        {{ $item['explanation'] ?? '' }}
                                    </td>
                                </tr>
                                @endforeach
                            @endif
                        </tbody>
                    </table>
                </div>
                {{-- リアクションデフォルト設定 --}}
                @isset($permissions['login_use_typ'])
                    @if (($permissions['login_use_typ'] >= 21 && $permissions['login_use_typ'] <= 24) 
                    || $permissions['login_use_typ'] == 3 
                    || ($permissions['login_use_typ'] == 4 && ($permissions['admin_and_is_approver'] == 1 || $permissions['admin_and_is_viewer'] == 1)))
                    <div class="form-group">
                        <div class="checkbox">
                            <div class="md-checkbox-v2 check-width">
                                <input name="ck_set_default" id="ck_set_default" type="checkbox" tabindex="3" value="1" {{ isset($report_current['checked_default'])&&($report_current['checked_default']==1)?'checked':''}}>
                                <label for="ck_set_default">{{ __('ri2010.reaction_default') }}</label>
                            </div>
                        </div>
                    </div>        
                    @endif
                @endisset
                @else
                <div class="form-group">
                    @if (isset($reactions) && !empty($reactions))
                    @foreach ($reactions as $item)
                        @if ($item['mark_cd'] == $report_current['reaction_cd'])
                        <input type="hidden" class="adequacy_value reaction_cd" value="{{ $report_current['reaction_cd'] ?? 1 }}">
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="90" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
                @endif
            
                {{-- Button コメント--}}
                @if (isset($permissions['btn_comment']) && $permissions['btn_comment'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_comment"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.comment_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                {{-- Button 一時保存--}}
                @if (isset($permissions['btn_temporary']) && $permissions['btn_temporary'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_save"
                            class="btn button-1on1" tabindex="4">
                            {{ __('messages.temp_save') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                
            </div>
        </div>
        @endif
        {{-- アクションボタン --}}
        <div class="row">
            <div class="button__action--left col-sm-6 col-md-9 col-lg-9">
                @if (isset($permissions['btn_temporary_header']) && $permissions['btn_temporary_header'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn-memory-footer"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('messages.temp_save') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_submit_header']) && $permissions['btn_submit_header'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn-submit-footer"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('messages.submit') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_approve_action']) && $permissions['btn_approve_action'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_approved"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.approve_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_reject_action']) && $permissions['btn_reject_action'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_reject"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.reject_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_view_action']) && $permissions['btn_view_action'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_confim"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.view_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_share_action']) && $permissions['btn_share_action'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_share"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.share_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_stick_action']) && $permissions['btn_stick_action'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" 
                            id="btn_sticky" 
                            fiscal_year="{{ $fiscal_year ?? 0 }}"
                            employee_cd="{{ $employee_cd ?? '' }}"
                            report_kind="{{ $report_kind ?? 0 }}"
                            report_no="{{ $report_no_current ?? 0 }}"
                            class="btn btn-outline-primary" 
                            tabindex="4">
                            {{ __('ri2010.stick_action') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
                @if (isset($permissions['btn_viewer_confirm']) && $permissions['btn_viewer_confirm'] == 1)
                <div class="form-group">
                    <div class="full-width">
                        <a href="javascript:;" id="btn_viewer_confirm"
                            class="btn btn-outline-primary" tabindex="4">
                            {{ __('ri2010.viewer_confirm') }}
                        </a>
                    </div><!-- end .full-width -->
                </div>
                @endif
            </div>
            <div class="button__action--right col-sm-6 col-md-3 col-lg-3">
                @if (isset($report_current['note_no']))
                <div class="sticky__label sticky__bg--{{ $report_current['note_color'] }}" style="background-color: {{ $report_current['note_color_code'] ?? '' }}" data-container="body"
                    data-toggle="tooltip" data-placement="top" data-html="true"
                    data-original-title="{!! nl2br($report_current['note_explanation']) !!}">
                    <span>{{ $report_current['note_name'] }}</span>
                </div>    
                @endif
            </div>
        </div>
    </div>
    {{-- リアクション --}}
    <div class="col-md-5 col-sm-12 col-12 col-lg-5 col-xl-5 pr-0 right_content" >
        @include('WeeklyReport::ri2010.rightContent')
    </div>
</div>
</div>    
@endif

{{-- 前回の報告書 --}}
@if (isset($report_prev_1) && !empty($report_prev_1))
<div class="tab-pane fade col-12" id="tab2">
    <div class="row">
        <div class="col-md-7 col-sm-12 col-12 col-lg-7 col-xl-7 pr-1">
        <div class="row mb-1">
            {{-- 報告日 --}}
            <div class="col-12 col-md-6 col-lg-6 col-xl-6 tab-table">
                <div class="row">
                    <label class="col-md-12 col-lg-12 col-xl-12 title">{{ $report_prev_1['title'] ?? '' }}</label>
                </div>
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.target_period') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['target_period'] ?? ''}} </label>
                </div>
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.reporter') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['employee_nm'] ?? ''}} </label>
                </div>
                {{-- 一次承認者 --}}
                @if ($report_prev_1['approver_employee_nm_1'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.primary_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['approver_employee_nm_1'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 二次承認者 --}}
                @if ($report_prev_1['approver_employee_nm_2'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.secondary_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['approver_employee_nm_2'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 三次承認者 --}}
                @if ($report_prev_1['approver_employee_nm_3'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.third_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['approver_employee_nm_3'] ?? ''}} </label>
                </div>    
                @endif
                {{-- 四次承認者 --}}
                @if ($report_prev_1['approver_employee_nm_4'] != '')
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.fourth_approver') }}</label>
                    <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_1['approver_employee_nm_4'] ?? ''}} </label>
                </div>    
                @endif
                <div class="row">
                    <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.report_date') }}</label>
                    <div class="col-5 input-group col-md-5 col-lg-5 col-xl-5" style="max-width: 140px;min-width: 140px;width: 140px">
                        <label style="font-weight: 700">{{ $report_prev_1['report_date'] ?? '' }}</label>
                        {{-- <input type="text" disabled class="form-control input-sm" placeholder="yyyy/mm/dd" tabindex="-1" value="{{ $report_prev_1['report_date'] ?? '' }}"> --}}
                    </div>
                    <div class="col-3 col-md-3 col-lg-3 col-xl-3">
                        {{-- ステータス状態 --}}
                        <div>
                            @if (isset($report_prev_1['status_cd']) && $report_prev_1['status_cd'] == 1)
                            <span class="badge badge-secondary">{{ $report_prev_1['status_nm'] ?? '' }}</span>  
                            @endif
                            @if (isset($report_prev_1['status_cd']) && $report_prev_1['status_cd'] > 1 && $report_prev_1['status_cd'] < 6)                    
                            <span class="badge badge-primary">{{ $report_prev_1['status_nm'] ?? '' }}</span>
                            @endif
                            @if (isset($report_prev_1['status_cd']) && $report_prev_1['status_cd'] == 6)
                            <span class="badge badge-success">{{ $report_prev_1['status_nm'] ?? '' }}</span>  
                            @endif
                        </div>  
                    </div>
                </div>
            </div>
            {{-- 充実度 --}}
            @if (isset($report_prev_1['adequacy_use_typ']) && $report_prev_1['adequacy_use_typ'] == 1)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                <div class="form-group">
                    <label>{{ $adequacy_master['name'] ?? __('ri2010.adequacy') }}</label>
                    <br>
                    @if (isset($adequacy) && !empty($adequacy))
                    @foreach ($adequacy as $item)
                        @if ($item['mark_cd'] == $report_prev_1['adequacy_kbn'])
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
            </div>
            @endif
            {{-- 繁忙度 --}}
            @if (isset($report_prev_1['busyness_use_typ']) && $report_prev_1['busyness_use_typ'] == 1)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                <div class="form-group">
                    <label>{{ $busyness_master['name'] ?? __('ri2010.busyness') }}</label>
                    <br>
                    @if (isset($busyness) && !empty($busyness))
                    @foreach ($busyness as $item)
                        @if ($item['mark_cd'] == $report_prev_1['busyness_kbn'])
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
            </div>
            @endif
            {{-- その他 --}}
            @if (isset($report_prev_1['other_use_typ']) && $report_prev_1['other_use_typ'] == 1)
            <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
                <div class="form-group">
                    <label>{{ $other_master['name'] ?? __('ri2010.other') }}</label>
                    <br>
                    @if (isset($other) && !empty($other))
                    @foreach ($other as $item)
                        @if ($item['mark_cd'] == $report_prev_1['other_kbn'])
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                        @endif                                                        
                    @endforeach
                    @endif
                </div>
            </div>
            @endif
        </div>
        {{-- 質問一覧 --}}
        @if (isset($report_prev_1_question) && !empty($report_prev_1_question))
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                <table class="table table-bordered table-hover fixed-header table-striped one-table table-questions table-mobile">
                    <thead>
                        <tr class="tr-table">
                            <th scope="col" class="question-w">{{ __('ri2010.question') }}</th>
                            <th scope="col" class="answer-w">{{ __('ri2010.answer') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($report_prev_1_question as $question)
                        <tr>
                            <td data-label="{{ __('ri2010.question') }}">
                                <span class="num-length pl-2">{{ $question['question'] ?? '' }}</span>
                            </td>
                            <td data-label="{{ __('ri2010.answer') }}">
                                {{-- 自由入力(Input text) --}}
                                @if ($question['answer_kind'] == 1)
                                <span class="txt-break">
                                    {!! nl2br($question['answer_sentence'] ?? '') !!}
                                </span>
                                </br>
                                <span style="font-weight: bold;">{!! nl2br($question['answer_sentence_tr'] ?? '') !!}</span>
                                @endif
                                {{-- 数字(小数点第１位まで)(Input number) --}}
                                @if ($question['answer_kind'] == 2)
                                <span class="num-length">                                
                                    <input type="tel" disabled class="form-control text-right answer numericX1 autoNumeric-positive {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" negative="true" value="{{ $question['answer_number'] ?? '' }}" tabindex="1" decimal="1" constant_maxlength="{{ $question['answer_digits'] ?? 4 }}">
                                </span>   
                                @endif
                                {{-- プルダウン（複数選択不可）(selectbox) --}}
                                @if ($question['answer_kind'] == 3)
                                <select disabled class="form-control answer {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" tabindex="1">
                                    @php
                                        $answer_combo = json_decode((htmlspecialchars_decode($question['answer_json'])),true)??[];
                                    @endphp
                                    <option value="-1"></option>
                                    @if (isset($answer_combo) && !empty($answer_combo))
                                        @foreach ($answer_combo as $option)
                                            @if ($option['detail_no'] == $question['answer_select'])
                                            <option value="{{ $option['detail_no'] }}" selected>{{ $option['detail_name'] }}</option>    
                                            @else
                                            <option value="{{ $option['detail_no'] }}">{{ $option['detail_name'] }}</option>
                                            @endif
                                        @endforeach
                                    @endif
                                </select>
                                @endif
                                {{-- 承認者のコメント --}}
                                @if (isset($report_prev_1['comment_use_typ']) && $report_prev_1['comment_use_typ'] == 1)
                                    <div class="comment_action line-top mt-1">
                                        <span class="comment_field">{{ __('ri2010.comment_field_approver') }}</span>
                                    </div>
                                    <span class="txt-break">
                                        {{-- {!! nl2br($question['approver_comment'] ?? '') !!} --}}
                                        <input type="hidden" class="approver_comment" value="{{ $question['approver_comment'] ?? '' }}">
                                        <span style="display: block;">{!! nl2br($question['approver_comment_1_show'] ?? '') !!}</span>
                                        <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_1_show_tr'] ?? '') !!}</span>
                                        <span style="display: block;">{!! nl2br($question['approver_comment_2_show'] ?? '') !!}</span>
                                        <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_2_show_tr'] ?? '') !!}</span>
                                        <span style="display: block;">{!! nl2br($question['approver_comment_3_show'] ?? '') !!}</span>
                                        <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_3_show_tr'] ?? '') !!}</span>
                                        <span style="display: block;">{!! nl2br($question['approver_comment_4_show'] ?? '') !!}</span>
                                        <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_4_show_tr'] ?? '') !!}</span>
                                    </span>
                                    <input type="hidden" class="approver_comment_1" value="{{ $question['approver_comment_1_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_2" value="{{ $question['approver_comment_2_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_3" value="{{ $question['approver_comment_3_show'] ?? '' }}">
                                    <input type="hidden" class="approver_comment_4" value="{{ $question['approver_comment_4_show'] ?? '' }}">
                                    <input type="hidden" class="approver_user_1" value="{{ $question['approver_user_1'] ?? '' }}">
                                    <input type="hidden" class="approver_user_2" value="{{ $question['approver_user_2'] ?? '' }}">
                                    <input type="hidden" class="approver_user_3" value="{{ $question['approver_user_3'] ?? '' }}">
                                    <input type="hidden" class="approver_user_4" value="{{ $question['approver_user_4'] ?? '' }}">
                                    <input type="hidden" class="approver_user_1_language" value="{{ $question['approver_user_1_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_2_language" value="{{ $question['approver_user_2_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_3_language" value="{{ $question['approver_user_3_language'] ?? '' }}">
                                    <input type="hidden" class="approver_user_4_language" value="{{ $question['approver_user_4_language'] ?? '' }}">
                                {{-- </br>
                                    <span style="font-weight: bold;">{!! nl2br($question['approver_comment_tr'] ?? '') !!}</span> --}}
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
        @endif
        {{-- 自由記入欄 --}}
        <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                <table class="table table-bordered table-hover fixed-header table-striped one-table">
                    <thead>
                        <tr class="tr-table">
                            <th style="text-align:left;">
                                {{ __('ri2010.comment') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <span class="txt-break">
                                    {!! nl2br($report_prev_1['free_comment'] ?? '') !!}
                                </span>
                            </br>
                                <span style="font-weight: bold;">{!! nl2br($report_prev_1['free_comment_tr'] ?? '') !!}</span>
                                {{-- <input type="hidden" class="free_comment_user" value="{{ $report_prev_1['free_comment_user'] ?? '' }}"> --}}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        {{-- コメント --}}
        <div class="row">
            <div class="col-12 col-sm-9 col-md-9 col-lg-9 col-xl-9">
                <table
                    class="table table-bordered table-hover fixed-header table-striped one-table">
                    <thead>
                        <tr class="tr-table">
                            <th class="" style="text-align: left;width:100%">
                                {{ __('ri2010.comment_field') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100%">
                                <span class="txt-break">
                                    {!! nl2br($report_prev_1['comment'] ?? '') !!}
                                </span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($report_prev_1['comment_tr'] ?? '') !!}</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {{-- 充実度 --}}
            <div class="col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3 adequacy">
                @if (isset($reactions) && !empty($reactions))
                    @foreach ($reactions as $item)
                        @if ($item['mark_cd'] == $report_prev_1['reaction_cd'])
                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="90" />        
                        @endif                                                        
                    @endforeach
                @endif
            </div>
        </div>
        {{-- アクションボタン --}}
        <div class="row">
            <div class="button__action--right col-12">
                @if (isset($report_prev_1['note_no']))
                <div class="sticky__label sticky__bg--{{ $report_prev_1['note_color'] }}" style="background-color: {{ $report_prev_1['note_color_code'] ?? '' }}" data-container="body"
                    data-toggle="tooltip" data-placement="top" data-html="true"
                    data-original-title="{!! nl2br($report_prev_1['note_explanation']) !!}">
                    <span>{{ $report_prev_1['note_name'] }}</span>
                </div>    
                @endif
            </div>
        </div>
        </div>
        {{-- リアクション --}}
        <div class="col-md-5 col-sm-12 col-12 col-lg-5 col-xl-5 pr-0 right_content" >
            @include('WeeklyReport::ri2010.rightContent')
        </div>
    </div>
</div>
@endif

{{-- 前々回の報告書 --}}
@if (isset($report_prev_2) && !empty($report_prev_2))
<div class="tab-pane fade col-12" id="tab3">
    <div class="row">
        <div class="col-md-7 col-sm-12 col-12 col-lg-7 col-xl-7 pr-1">
    <div class="row mb-1">
        {{-- 報告日 --}}
        <div class="col-12 col-md-6 col-lg-6 col-xl-6 tab-table">
            <div class="row">
                <label class="col-md-12 col-lg-12 col-xl-12 title">{{ $report_prev_2['title'] ?? '' }}</label>
            </div>
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.target_period') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['target_period'] ?? ''}} </label>
            </div>
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.reporter') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['employee_nm'] ?? ''}} </label>
            </div>
            {{-- 一次承認者 --}}
            @if ($report_prev_2['approver_employee_nm_1'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.primary_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['approver_employee_nm_1'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 二次承認者 --}}
            @if ($report_prev_2['approver_employee_nm_2'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.secondary_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['approver_employee_nm_2'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 三次承認者 --}}
            @if ($report_prev_2['approver_employee_nm_3'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.third_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['approver_employee_nm_3'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 四次承認者 --}}
            @if ($report_prev_2['approver_employee_nm_4'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.fourth_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_2['approver_employee_nm_4'] ?? ''}} </label>
            </div>    
            @endif
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.report_date') }}</label>
                <div class="col-5 input-group col-md-5 col-lg-5 col-xl-5" style="max-width: 140px;min-width: 140px;width: 140px">
                    <label style="font-weight: 700">{{ $report_prev_2['report_date'] ?? '' }}</label>
                    {{-- <input type="text" disabled class="form-control input-sm" placeholder="yyyy/mm/dd" tabindex="-1" value="{{ $report_prev_2['report_date'] ?? '' }}"> --}}
                </div>
                <div class="col-3 col-md-3 col-lg-3 col-xl-3">
                    {{-- ステータス状態 --}}
                    <div>
                        @if (isset($report_prev_2['status_cd']) && $report_prev_2['status_cd'] == 1)
                        <span class="badge badge-secondary">{{ $report_prev_2['status_nm'] ?? '' }}</span>  
                        @endif
                        @if (isset($report_prev_2['status_cd']) && $report_prev_2['status_cd'] > 1 && $report_prev_2['status_cd'] < 6)                    
                        <span class="badge badge-primary">{{ $report_prev_2['status_nm'] ?? '' }}</span>
                        @endif
                        @if (isset($report_prev_2['status_cd']) && $report_prev_2['status_cd'] == 6)
                        <span class="badge badge-success">{{ $report_prev_2['status_nm'] ?? '' }}</span>  
                        @endif
                    </div>  
                </div>
            </div>
        </div>
        {{-- 充実度 --}}
        @if (isset($report_prev_2['adequacy_use_typ']) && $report_prev_2['adequacy_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $adequacy_master['name'] ?? __('ri2010.adequacy') }}</label>
                <br>
                @if (isset($adequacy) && !empty($adequacy))
                @foreach ($adequacy as $item)
                    @if ($item['mark_cd'] == $report_prev_2['adequacy_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
        {{-- 繁忙度 --}}
        @if (isset($report_prev_2['busyness_use_typ']) && $report_prev_2['busyness_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $busyness_master['name'] ?? __('ri2010.busyness') }}</label>
                <br>
                @if (isset($busyness) && !empty($busyness))
                @foreach ($busyness as $item)
                    @if ($item['mark_cd'] == $report_prev_2['busyness_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
        {{-- その他 --}}
        @if (isset($report_prev_2['other_use_typ']) && $report_prev_2['other_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $other_master['name'] ?? __('ri2010.other') }}</label>
                <br>
                @if (isset($other) && !empty($other))
                @foreach ($other as $item)
                    @if ($item['mark_cd'] == $report_prev_2['other_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
    </div>
    {{-- 質問一覧 --}}
    @if (isset($report_prev_2_question) && !empty($report_prev_2_question))
    <div class="row">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <table class="table table-bordered table-hover fixed-header table-striped one-table table-questions table-mobile">
                <thead>
                    <tr class="tr-table">
                        <th scope="col" class="question-w">{{ __('ri2010.question') }}</th>
                        <th scope="col" class="answer-w">{{ __('ri2010.answer') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($report_prev_2_question as $question)
                    <tr>
                        <td data-label="{{ __('ri2010.question') }}">
                            <span class="num-length pl-2">{{ $question['question'] ?? '' }}</span>
                        </td>
                        <td data-label="{{ __('ri2010.answer') }}">
                            {{-- 自由入力(Input text) --}}
                            @if ($question['answer_kind'] == 1)
                            <span class="txt-break">
                                {!! nl2br($question['answer_sentence'] ?? '') !!}
                            </span>
                            </br>
                            <span style="font-weight: bold;">{!! nl2br($question['answer_sentence_tr'] ?? '') !!}</span>
                            @endif
                            {{-- 数字(小数点第１位まで)(Input number) --}}
                            @if ($question['answer_kind'] == 2)
                            <span class="num-length">                                
                                <input type="tel" disabled class="form-control text-right answer numericX1 autoNumeric-positive {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" negative="true" value="{{ $question['answer_number'] ?? '' }}" tabindex="1" decimal="1" constant_maxlength="{{ $question['answer_digits'] ?? 4 }}">
                            </span>   
                            @endif
                            {{-- プルダウン（複数選択不可）(selectbox) --}}
                            @if ($question['answer_kind'] == 3)
                            <select disabled class="form-control answer {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" tabindex="1">
                                @php
                                    $answer_combo = json_decode((htmlspecialchars_decode($question['answer_json'])),true)??[];
                                @endphp
                                <option value="-1"></option>
                                @if (isset($answer_combo) && !empty($answer_combo))
                                    @foreach ($answer_combo as $option)
                                        @if ($option['detail_no'] == $question['answer_select'])
                                        <option value="{{ $option['detail_no'] }}" selected>{{ $option['detail_name'] }}</option>    
                                        @else
                                        <option value="{{ $option['detail_no'] }}">{{ $option['detail_name'] }}</option>
                                        @endif
                                    @endforeach
                                @endif
                            </select>
                            @endif
                            {{-- 承認者のコメント --}}
                            @if (isset($report_prev_2['comment_use_typ']) && $report_prev_2['comment_use_typ'] == 1)
                            <div class="comment_action line-top mt-1">
                                <span class="comment_field">{{ __('ri2010.comment_field_approver') }}</span>
                            </div>
                            <span class="txt-break">
                                {{-- {!! nl2br($question['approver_comment'] ?? '') !!} --}}
                                <input type="hidden" class="approver_comment" value="{{ $question['approver_comment'] ?? '' }}">
                                <span style="display: block;">{!! nl2br($question['approver_comment_1_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_1_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_2_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_2_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_3_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_3_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_4_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_4_show_tr'] ?? '') !!}</span>
                            </span>
                            <input type="hidden" class="approver_comment_1" value="{{ $question['approver_comment_1_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_2" value="{{ $question['approver_comment_2_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_3" value="{{ $question['approver_comment_3_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_4" value="{{ $question['approver_comment_4_show'] ?? '' }}">
                            <input type="hidden" class="approver_user_1" value="{{ $question['approver_user_1'] ?? '' }}">
                            <input type="hidden" class="approver_user_2" value="{{ $question['approver_user_2'] ?? '' }}">
                            <input type="hidden" class="approver_user_3" value="{{ $question['approver_user_3'] ?? '' }}">
                            <input type="hidden" class="approver_user_4" value="{{ $question['approver_user_4'] ?? '' }}">
                            <input type="hidden" class="approver_user_1_language" value="{{ $question['approver_user_1_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_2_language" value="{{ $question['approver_user_2_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_3_language" value="{{ $question['approver_user_3_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_4_language" value="{{ $question['approver_user_4_language'] ?? '' }}">
                        {{-- </br>
                            <span style="font-weight: bold;">{!! nl2br($question['approver_comment_tr'] ?? '') !!}</span> --}}
                            @endif
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
    @endif
    {{-- 自由記入欄 --}}
    <div class="row">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <table
                class="table table-bordered table-hover fixed-header table-striped one-table">
                <thead>
                    <tr class="tr-table">
                        <th class="" style="text-align: left;width:100%">
                            {{ __('ri2010.comment') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100%">
                            <span class="txt-break">
                                {!! nl2br($report_prev_2['free_comment'] ?? '') !!}
                            </span>
                            </br>
                            <span style="font-weight: bold;">{!! nl2br($report_prev_2['free_comment_tr'] ?? '') !!}</span>
                            {{-- <input type="hidden" class="free_comment_user" value="{{ $report_prev_2['free_comment_user'] ?? '' }}"> --}}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    {{-- コメント --}}
    <div class="row">
        <div class="col-12 col-sm-9 col-md-9 col-lg-9 col-xl-9">
            <table
                class="table table-bordered table-hover fixed-header table-striped one-table">
                <thead>
                    <tr class="tr-table">
                        <th class="" style="text-align: left;width:100%">
                            {{ __('ri2010.comment_field') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100%">
                            <span class="txt-break">
                                {!! nl2br($report_prev_2['comment'] ?? '') !!}
                            </span>
                            <span style="font-weight: bold;display: block;">{!! nl2br($report_prev_2['comment_tr'] ?? '') !!}</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        {{-- 充実度 --}}
        <div class="col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3 adequacy">
            @if (isset($reactions) && !empty($reactions))
                @foreach ($reactions as $item)
                    @if ($item['mark_cd'] == $report_prev_2['reaction_cd'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="90" />        
                    @endif                                                        
                @endforeach
            @endif
        </div>
    </div>
    {{-- アクションボタン --}}
    <div class="row">
        <div class="button__action--right col-12">
            @if (isset($report_prev_2['note_no']))
            <div class="sticky__label sticky__bg--{{ $report_prev_2['note_color'] }}" style="background-color: {{ $report_prev_2['note_color_code'] ?? '' }}" data-container="body"
                data-toggle="tooltip" data-placement="top" data-html="true"
                data-original-title="{!! nl2br($report_prev_2['note_explanation']) !!}">
                <span>{{ $report_prev_2['note_name'] }}</span>
            </div>    
            @endif
        </div>
    </div>
    </div>  
     {{-- リアクション --}}
     <div class="col-md-5 col-sm-12 col-12 col-lg-5 col-xl-5 pr-0 right_content" >
        @include('WeeklyReport::ri2010.rightContent')
    </div>
</div>
</div>
@endif

{{-- ３回前の報告書 --}}
@if (isset($report_prev_3) && !empty($report_prev_3))
<div class="tab-pane fade col-12" id="tab4">
    <div class="row">
        <div class="col-md-7 col-sm-12 col-12 col-lg-7 col-xl-7 pr-1">
    <div class="row mb-1">
        {{-- 報告日 --}}
        <div class="col-12 col-md-6 col-lg-6 col-xl-6 tab-table">
            <div class="row">
                <label class="col-md-12 col-lg-12 col-xl-12 title">{{ $report_prev_3['title'] ?? '' }}</label>
            </div>
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.target_period') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['target_period'] ?? ''}} </label>
            </div>
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.reporter') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['employee_nm'] ?? ''}} </label>
            </div>
            {{-- 一次承認者 --}}
            @if ($report_prev_3['approver_employee_nm_1'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.primary_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['approver_employee_nm_1'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 二次承認者 --}}
            @if ($report_prev_3['approver_employee_nm_2'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.secondary_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['approver_employee_nm_2'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 三次承認者 --}}
            @if ($report_prev_3['approver_employee_nm_3'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.third_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['approver_employee_nm_3'] ?? ''}} </label>
            </div>    
            @endif
            {{-- 四次承認者 --}}
            @if ($report_prev_3['approver_employee_nm_4'] != '')
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.fourth_approver') }}</label>
                <label class="col-8 col-md-8 col-lg-8 col-xl-8">{{ $report_prev_3['approver_employee_nm_4'] ?? ''}} </label>
            </div>    
            @endif
            <div class="row">
                <label class="col-4 col-md-4 col-lg-4 col-xl-4">{{ __('ri2010.report_date') }}</label>
                <div class="col-5 input-group col-md-5 col-lg-5 col-xl-5" style="max-width: 140px;min-width: 140px;width: 140px">
                    <label style="font-weight: 700">{{ $report_prev_3['report_date'] ?? '' }}</label>
                    {{-- <input type="text" disabled class="form-control input-sm" placeholder="yyyy/mm/dd" tabindex="-1" value="{{ $report_prev_3['report_date'] ?? '' }}"> --}}
                </div>
                <div class="col-3 col-md-3 col-lg-3 col-xl-3">
                    {{-- ステータス状態 --}}
                    <div>
                        @if (isset($report_prev_3['status_cd']) && $report_prev_3['status_cd'] == 1)
                        <span class="badge badge-secondary">{{ $report_prev_3['status_nm'] ?? '' }}</span>  
                        @endif
                        @if (isset($report_prev_3['status_cd']) && $report_prev_3['status_cd'] > 1 && $report_prev_3['status_cd'] < 6)                    
                        <span class="badge badge-primary">{{ $report_prev_3['status_nm'] ?? '' }}</span>
                        @endif
                        @if (isset($report_prev_3['status_cd']) && $report_prev_3['status_cd'] == 6)
                        <span class="badge badge-success">{{ $report_prev_3['status_nm'] ?? '' }}</span>  
                        @endif
                    </div>  
                </div>
            </div>
        </div>
        {{-- 充実度 --}}
        @if (isset($report_prev_3['adequacy_use_typ']) && $report_prev_3['adequacy_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $adequacy_master['name'] ?? __('ri2010.adequacy') }}</label>
                <br>
                @if (isset($adequacy) && !empty($adequacy))
                @foreach ($adequacy as $item)
                    @if ($item['mark_cd'] == $report_prev_3['adequacy_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
        {{-- 繁忙度 --}}
        @if (isset($report_prev_3['busyness_use_typ']) && $report_prev_3['busyness_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $busyness_master['name'] ?? __('ri2010.busyness') }}</label>
                <br>
                @if (isset($busyness) && !empty($busyness))
                @foreach ($busyness as $item)
                    @if ($item['mark_cd'] == $report_prev_3['busyness_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
        {{-- その他 --}}
        @if (isset($report_prev_3['other_use_typ']) && $report_prev_3['other_use_typ'] == 1)
        <div class="col-4 col-md-2 col-lg-2 col-xl-2 adequacy">
            <div class="form-group">
                <label>{{ $other_master['name'] ?? __('ri2010.other') }}</label>
                <br>
                @if (isset($other) && !empty($other))
                @foreach ($other as $item)
                    @if ($item['mark_cd'] == $report_prev_3['other_kbn'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="77" />        
                    @endif                                                        
                @endforeach
                @endif
            </div>
        </div>
        @endif
    </div>
    {{-- 質問一覧 --}}
    @if (isset($report_prev_3_question) && !empty($report_prev_3_question))
    <div class="row">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <table
                class="table table-bordered table-hover fixed-header table-striped one-table table-questions table-mobile">
                <thead>
                    <tr class="tr-table">
                        <th scope="col" class="question-w">{{ __('ri2010.question') }}</th>
                        <th scope="col" class="answer-w">{{ __('ri2010.answer') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach ($report_prev_3_question as $question)
                    <tr>
                        <td data-label="{{ __('ri2010.question') }}">
                            <span class="num-length pl-2">{{ $question['question'] ?? '' }}</span>
                        </td>
                        <td data-label="{{ __('ri2010.answer') }}">
                            {{-- 自由入力(Input text) --}}
                            @if ($question['answer_kind'] == 1)
                            <span class="txt-break">
                                {!! nl2br($question['answer_sentence'] ?? '') !!}
                            </span>  
                            </br>
                            <span style="font-weight: bold;">{!! nl2br($question['answer_sentence_tr'] ?? '') !!}</span>
                            @endif
                            {{-- 数字(小数点第１位まで)(Input number) --}}
                            @if ($question['answer_kind'] == 2)
                            <span class="num-length">                                
                                <input type="tel" disabled class="form-control text-right answer numericX1 autoNumeric-positive {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" negative="true" value="{{ $question['answer_number'] ?? '' }}" tabindex="1" decimal="1" constant_maxlength="{{ $question['answer_digits'] ?? 4 }}">
                            </span>   
                            @endif
                            {{-- プルダウン（複数選択不可）(selectbox) --}}
                            @if ($question['answer_kind'] == 3)
                            <select disabled class="form-control answer {{ $question['answer_kbn'] == 1 ? 'required' : '' }}" tabindex="1">
                                @php
                                    $answer_combo = json_decode((htmlspecialchars_decode($question['answer_json'])),true)??[];
                                @endphp
                                <option value="-1"></option>
                                @if (isset($answer_combo) && !empty($answer_combo))
                                    @foreach ($answer_combo as $option)
                                        @if ($option['detail_no'] == $question['answer_select'])
                                        <option value="{{ $option['detail_no'] }}" selected>{{ $option['detail_name'] }}</option>    
                                        @else
                                        <option value="{{ $option['detail_no'] }}">{{ $option['detail_name'] }}</option>
                                        @endif
                                    @endforeach
                                @endif
                            </select>
                            @endif
                            {{-- 承認者のコメント --}}
                            @if (isset($report_prev_3['comment_use_typ']) && $report_prev_3['comment_use_typ'] == 1)
                            <div class="comment_action line-top mt-1">
                                <span class="comment_field">{{ __('ri2010.comment_field_approver') }}</span>
                            </div>
                            <span class="txt-break">
                                {{-- {!! nl2br($question['approver_comment'] ?? '') !!} --}}
                                <input type="hidden" class="approver_comment" value="{{ $question['approver_comment'] ?? '' }}">
                                <span style="display: block;">{!! nl2br($question['approver_comment_1_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_1_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_2_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_2_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_3_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_3_show_tr'] ?? '') !!}</span>
                                <span style="display: block;">{!! nl2br($question['approver_comment_4_show'] ?? '') !!}</span>
                                <span style="font-weight: bold;display: block;">{!! nl2br($question['approver_comment_4_show_tr'] ?? '') !!}</span>
                            </span>
                            <input type="hidden" class="approver_comment_1" value="{{ $question['approver_comment_1_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_2" value="{{ $question['approver_comment_2_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_3" value="{{ $question['approver_comment_3_show'] ?? '' }}">
                            <input type="hidden" class="approver_comment_4" value="{{ $question['approver_comment_4_show'] ?? '' }}">
                            <input type="hidden" class="approver_user_1" value="{{ $question['approver_user_1'] ?? '' }}">
                            <input type="hidden" class="approver_user_2" value="{{ $question['approver_user_2'] ?? '' }}">
                            <input type="hidden" class="approver_user_3" value="{{ $question['approver_user_3'] ?? '' }}">
                            <input type="hidden" class="approver_user_4" value="{{ $question['approver_user_4'] ?? '' }}">
                            <input type="hidden" class="approver_user_1_language" value="{{ $question['approver_user_1_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_2_language" value="{{ $question['approver_user_2_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_3_language" value="{{ $question['approver_user_3_language'] ?? '' }}">
                            <input type="hidden" class="approver_user_4_language" value="{{ $question['approver_user_4_language'] ?? '' }}">
                        {{-- </br>
                            <span style="font-weight: bold;">{!! nl2br($question['approver_comment_tr'] ?? '') !!}</span> --}}
                            @endif
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
    @endif
    {{-- 自由記入欄 --}}
    <div class="row">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <table
                class="table table-bordered table-hover fixed-header table-striped one-table">
                <thead>
                    <tr class="tr-table">
                        <th class="" style="text-align: left;width:100%">
                            {{ __('ri2010.comment') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100%">
                            <span class="txt-break">
                                {!! nl2br($report_prev_3['free_comment'] ?? '') !!}
                            </span>
                            </br>
                            <span style="font-weight: bold;">{!! nl2br($report_prev_3['free_comment_tr'] ?? '') !!}</span>
                            {{-- <input type="hidden" class="free_comment_user" value="{{ $report_prev_3['free_comment_user'] ?? '' }}"> --}}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    {{-- コメント --}}
    <div class="row">
        <div class="col-12 col-sm-9 col-md-9 col-lg-9 col-xl-9">
            <table
                class="table table-bordered table-hover fixed-header table-striped one-table">
                <thead>
                    <tr class="tr-table">
                        <th class="" style="text-align: left;width:100%">
                            {{ __('ri2010.comment_field') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100%">
                            <span class="txt-break">
                                {!! nl2br($report_prev_3['comment'] ?? '') !!}
                            </span>
                            <span style="font-weight: bold;display: block;">{!! nl2br($report_prev_3['comment_tr'] ?? '') !!}</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        {{-- 充実度 --}}
        <div class="col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3 adequacy">
            @if (isset($reactions) && !empty($reactions))
                @foreach ($reactions as $item)
                    @if ($item['mark_cd'] == $report_prev_3['reaction_cd'])
                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="90" />        
                    @endif                                                        
                @endforeach
            @endif
        </div>
    </div>
    {{-- アクションボタン --}}
    <div class="row">
        <div class="button__action--right col-12">
            @if (isset($report_prev_3['note_no']))
            <div class="sticky__label sticky__bg--{{ $report_prev_3['note_color'] }}" style="background-color: {{ $report_prev_3['note_color_code'] ?? '' }}" data-container="body"
                data-toggle="tooltip" data-placement="top" data-html="true"
                data-original-title="{!! nl2br($report_prev_3['note_explanation']) !!}">
                <span>{{ $report_prev_3['note_name'] }}</span>
            </div>    
            @endif
        </div>
    </div>
    </div>
     {{-- リアクション --}}
     <div class="col-md-5 col-sm-12 col-12 col-lg-5 col-xl-5 pr-0 right_content" >
        @include('WeeklyReport::ri2010.rightContent')
    </div>
</div>
</div>
@endif