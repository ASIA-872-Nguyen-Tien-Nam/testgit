@if (isset($reaction_comments) && !empty($reaction_comments))
    @foreach ($reaction_comments as $reaction_comment)
    @php
    if ($reaction_comment['reply_use_typ'] == 1) {
        $reaction_reply = $reactions_reporter_reply ?? []; 
    }else{
        $reaction_reply = $reactions_approver_viewer_reply ?? [];   
    }
    @endphp
    {{-- reaction reaction_type = 0 --}}
    @if ($reaction_comment['reaction_type'] == 0)    
        {{-- Has comment --}}
        @if ($reaction_comment['reaction_datetime'])
            <div class="row mb-2 reaction__row">
                <div class="col-sm-12 col-md-12">
                    <span>{{ $reaction_comment['reaction_user'] }}</span>
                </div>
            </div>    
            <div class="row mb-2 reaction-reply line">
                <div class="col-sm-12 col-md-12 col-xl-12 adequacy">
                    @if (isset($reaction_reply) && !empty($reaction_reply))
                    <div class="reaction_icon reaction_icon_2 mr-3 mb-3">
                        @foreach ($reaction_reply as $item)
                            @if ($item['mark_cd'] == $reaction_comment['reaction_cd'])
                            <img data-container="body" data-toggle="tooltip" data-original-title="{{ $item['explanation'] ?? '' }}" src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />        
                            @endif                                                        
                        @endforeach
                    </div>
                    {{-- Item dropdown --}}
                    <div class="reaction_icon_edit form-group adequacy_dropdown">
                        <div class="dropdown">
                            <table class="table one-table table-dropdown" style="width:120px ;table-layout: fixed">
                                <tbody class="table-select">
                                    <tr>
                                        <td style="padding: 0px;border-top: none;">
                                            <dt>
                                                <a class="a1 adequacy_select">
                                                    <span>
                                                        <input type="hidden" class="adequacy_value reaction_cd_right" value="{{ $reaction_comment['reaction_cd'] ?? 0 }}">
                                                        @foreach ($reaction_reply as $item)
                                                            @if ($item['mark_cd'] == $reaction_comment['reaction_cd'])
                                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />        
                                                            @endif                                                        
                                                        @endforeach
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
                                @foreach ($reaction_reply as $item)
                                <tr class="adequacy_option_row">
                                    <td style="padding: 10px;width: 110px;border-right: 1px solid #dee2e6;">
                                        <a title="Select this card" class="select-item image_select">
                                            <input type="hidden" class="adequacy_value reaction_cd_right" value="{{ $item['mark_cd'] ?? 0 }}">
                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />   
                                        </a>
                                    </td>
                                    <td>
                                        {{ $item['explanation'] ?? '' }}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                    @endif
                    {{-- comment --}}
                    <div class="form-group comment_tr">
                        <div class="reaction-label">
                            {!! nl2br($reaction_comment['comment']) !!}
                        </div>        
                        <span class="num-length reaction-comment">
                            <textarea class="form-control reply_comment" maxlength="1200" tabindex="5" value="{{ $reaction_comment['comment'] }}">{{ $reaction_comment['comment'] }}</textarea>
                        </span>
                        <input type="hidden" class="reaction_comment_tr" value="{{$reaction_comment['comment']}}">
                        <input type="hidden" class="reaction_no_comment" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                        <input type="hidden" class="comment_user" value="{{ $reaction_comment['comment_user'] ?? '' }}">
                        <input type="hidden" class="comment_user_language" value="{{ $reaction_comment['comment_user_language'] ?? '' }}">
                    {{-- </br> --}}
                        <span style="font-weight: bold;">{!! nl2br($reaction_comment['comment_tr']) !!}</span>
                    </div>
                    {{-- edit button --}}
                    @if ($reaction_comment['btn_edit_status'] == 1)
                    <div class="form-group reply" style="width: 100px;float: right;">
                        <input type="hidden" class="reaction_no" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                        <input type="hidden" class="reply_no" value="{{ $reaction_comment['reply_no'] ?? 0 }}">
                        <input type="hidden" class="reaction_type" value="{{ $reaction_comment['reaction_type'] ?? 0 }}">
                        <button tabindex="5" type="button" class="btn btn-outline-primary btn-block btn-edit">
                            <i class="fa fa-pencil" aria-hidden="true"></i>
                        </button>
                        <div class="reaction-comment-action">
                            <button type="button" class="btn btn-reply-edit btn-success">
                                <i class="fa fa-check" aria-hidden="true"></i>
                            </button>
                            <button type="button" class="btn-reply-delete btn-danger">
                                <i class="fa fa-times" aria-hidden="true"></i>
                            </button>
                        </div>
                    </div>
                    @endif
                </div>
            </div>
        {{-- Has not comment --}}
        @elseif ($reaction_comment['btn_edit_status'] == 1)
            <div class="row mb-2 reaction__row">
                <div class="col-sm-12 col-md-12">
                    <span>{{ $reaction_comment['reaction_user'] }}</span>
                </div>
            </div>
            <div class="row mb-2 reaction-reply line">
                <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 adequacy mb-3">
                    @if (isset($reaction_reply) && !empty($reaction_reply))
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
                                                        <input type="hidden" class="adequacy_value reaction_cd_right" value="{{ $reaction_comment['reaction_cd'] ?? 0 }}">
                                                        @foreach ($reaction_reply as $item)
                                                            @if ($item['mark_cd'] == $reaction_comment['reaction_cd'])
                                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80"/>        
                                                            @endif                                                        
                                                        @endforeach
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
                                @foreach ($reaction_reply as $item)
                                <tr class="adequacy_option_row">
                                    <td style="padding: 10px;width: 110px;border-right: 1px solid #dee2e6;">
                                        <a title="Select this card" class="select-item image_select">
                                            <input type="hidden" class="adequacy_value reaction_cd_right" value="{{ $item['mark_cd'] ?? 0 }}">
                                            <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80"/>   
                                        </a>
                                    </td>
                                    <td>
                                        {{ $item['explanation'] ?? '' }}
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                    @endif
                    {{-- Comment --}}
                    <div class="form-group comment_tr">
                        <span class="num-length">
                            <textarea class="form-control reply_comment" maxlength="1200" tabindex="5" value="{{ $reaction_comment['comment'] }}">{{ $reaction_comment['comment'] }}</textarea>
                        </span>
                        <input type="hidden" class="reaction_comment_tr" value="{{$reaction_comment['comment']}}">
                        <input type="hidden" class="reaction_no_comment" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                        <input type="hidden" class="comment_user" value="{{ $reaction_comment['comment_user'] ?? '' }}">
                        <input type="hidden" class="comment_user_language" value="{{ $reaction_comment['comment_user_language'] ?? '' }}">
                    {{-- </br> --}}
                        <span style="font-weight: bold;">{!! nl2br($reaction_comment['comment_tr']) !!}</span>
                    </div>
                    {{-- edit --}}
                    @if ($reaction_comment['btn_edit_status'] == 1)
                    <div class="form-group reply" style="float: right;">
                        <input type="hidden" class="reaction_no" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                        <input type="hidden" class="reply_no" value="{{ $reaction_comment['reply_no'] ?? 0 }}">
                        <input type="hidden" class="reaction_type" value="{{ $reaction_comment['reaction_type'] ?? 0 }}">
                        <button tabindex="5" type="button" class="btn btn-outline-primary btn-comment">{{ __('ri2010.comment_action') }}</button>
                    </div>
                    @endif
                </div>
            </div>
        @endif
    @endif
    {{-- reaction reply input reaction_type = 2 --}}
    @if ($reaction_comment['reaction_type'] == 2)
    @php
    if ($reaction_comment['login_use_typ'] == 1) {
        $reaction_reply = $reactions_reporter_reply ?? []; 
    }else{
        $reaction_reply = $reactions_approver_viewer_reply ?? [];   
    }
    @endphp
    <div class="row mb-2 reaction-reply line-solid">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12">
            @if (isset($reaction_reply) && !empty($reaction_reply))
            <div class="adequacy reply_reaction_div mb-3">
                {{-- Item dropdown --}}
                <div class="form-group adequacy_dropdown">
                    <div class="dropdown">
                        <table class="table one-table table-dropdown"
                            style="width:120px ;table-layout: fixed">
                            <tbody class="table-select">
                                <tr>
                                    <td style="padding: 0px;border-top: none;">
                                        <dt>
                                            <a class="a1 adequacy_select">
                                                <span>
                                                    <input type="hidden" class="adequacy_value reply_cd" value="{{ $reaction_comment['reply_cd'] ?? 0 }}">
                                                    @foreach ($reaction_reply as $item)
                                                        @if ($item['mark_cd'] == $reaction_comment['reply_cd'])
                                                        <img data-container="body" data-toggle="tooltip" data-original-title="{{ $item['explanation'] ?? '' }}" src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />        
                                                        @endif                                                        
                                                    @endforeach
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
                    <table class="table one-table table-select" style="border: 1px solid #dee2e6;table-layout: fixed">
                        <tbody>
                            @foreach ($reaction_reply as $item)
                            <tr class="adequacy_option_row">
                                <td style="padding: 10px;width: 110px;border-right: 1px solid #dee2e6;">
                                    <a title="Select this card" class="select-item image_select">
                                        <input type="hidden" class="adequacy_value reply_cd" value="{{ $item['mark_cd'] ?? 0 }}">
                                        <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] }}" width="80" />
                                    </a>
                                </td>
                                <td>
                                    {{ $item['explanation'] ?? '' }}
                                </td>
                            </tr>  
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
            @endif
            {{-- answer reply --}}
            <div class="form-group reply_comment_div">
                <span class="num-length">
                    <textarea class="form-control reply_comment" maxlength="600" tabindex="5" value=""></textarea>
                </span>
            </div>
            {{-- button 返事 --}}
            <div class="form-group" style="width: 100px;float: right;">
                <input type="hidden" class="reaction_no" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                <input type="hidden" class="reply_no" value="{{ $reaction_comment['reply_no'] ?? 0 }}">
                <input type="hidden" class="reaction_type" value="{{ $reaction_comment['reaction_type'] ?? 0 }}">
                <button tabindex="5" type="button" class="btn button-1on1 btn-block btn-reply mb-2">{{ __('ri2010.reply_action') }}</button>
                <div class="reply_reaction_action">
                    <button type="button" class="btn btn-reaction-reply-edit btn-success">
                        <i class="fa fa-check" aria-hidden="true"></i>
                    </button>
                    <button type="button" class="btn-reaction-reply-delete btn-danger">
                        <i class="fa fa-times" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
    @endif
    {{-- reaction reply viewer reaction_type = 1 --}}
    @if ($reaction_comment['reaction_type'] == 1)
    <div class="row mb-2 reaction__row">
        <div class="col-sm-12 col-md-12">
            <span>{{ $reaction_comment['reply_user_nm'] }}</span>
        </div>
    </div>
    <div class="row mb-2 reaction-reply line">
        <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 adequacy">
            @if (isset($reaction_reply) && !empty($reaction_reply))
            <div class="reaction_icon reaction_icon_2 mr-3 mb-3">
                @foreach ($reaction_reply as $item)
                    @if ($item['mark_cd'] == $reaction_comment['reply_cd'])
                    <img data-container="body" data-toggle="tooltip" data-original-title="{{ $item['explanation'] ?? '' }}" src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />        
                    @endif                                                        
                @endforeach
            </div>
            {{-- add by viettd 2023/08/15 --}}
            {{-- Item dropdown --}}
            <div class="reaction_icon_edit form-group adequacy_dropdown">
                <div class="dropdown">
                    <table class="table one-table table-dropdown" style="width:120px ;table-layout: fixed">
                        <tbody class="table-select">
                            <tr>
                                <td style="padding: 0px;border-top: none;">
                                    <dt>
                                        <a class="a1 adequacy_select">
                                            <span>
                                                <input type="hidden" class="adequacy_value reply_cd" value="{{ $reaction_comment['reply_cd'] ?? 0 }}">
                                                @foreach ($reaction_reply as $item)
                                                    @if ($item['mark_cd'] == $reaction_comment['reply_cd'])
                                                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />        
                                                    @endif                                                        
                                                @endforeach
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
                        @foreach ($reaction_reply as $item)
                        <tr class="adequacy_option_row">
                            <td style="padding: 10px;width: 110px;border-right: 1px solid #dee2e6;">
                                <a title="Select this card" class="select-item image_select">
                                    <input type="hidden" class="adequacy_value reply_cd" value="{{ $item['mark_cd'] ?? 0 }}">
                                    <img src="/template/image/icon/weeklyreport/{{ $item['remark1'] ?? '' }}" width="80" />   
                                </a>
                            </td>
                            <td>
                                {{ $item['explanation'] ?? '' }}
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            @endif
            {{-- comment --}}
            <div class="form-group reply_comment_tr">
                <div class="reaction-label">
                    {!! nl2br($reaction_comment['reply_comment']) !!}
                </div>        
                <span class="num-length reaction-comment">
                    <textarea class="form-control reply_comment" maxlength="600" tabindex="5" value="{{ $reaction_comment['reply_comment'] }}">{{ $reaction_comment['reply_comment'] }}</textarea>
                </span>
                <input type="hidden" class="reply_tr" value="{{ $reaction_comment['reply_comment'] }}">
                <input type="hidden" class="reaction_no_reply_tr" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                <input type="hidden" class="reply_no_reply_tr" value="{{ $reaction_comment['reply_no'] ?? 0 }}">
                <input type="hidden" class="reply_user" value="{{ $reaction_comment['reply_user'] ?? '' }}">
                <input type="hidden" class="reply_user_language" value="{{ $reaction_comment['reply_user_language'] ?? '' }}">
            {{-- </br> --}}
                <span style="font-weight: bold;">{!! nl2br($reaction_comment['reply_comment_tr']) !!}</span>
            </div>
            {{-- edit --}}
            @if ($reaction_comment['btn_edit_status'] == 1)
            <div class="form-group reply" style="width: 100px;float: right;">
                <input type="hidden" class="reaction_no" value="{{ $reaction_comment['reaction_no'] ?? 0 }}">
                <input type="hidden" class="reply_no" value="{{ $reaction_comment['reply_no'] ?? 0 }}">
                <input type="hidden" class="reaction_type" value="{{ $reaction_comment['reaction_type'] ?? 0 }}">
                <button tabindex="5" type="button" class="btn btn-outline-primary btn-block btn-edit">
                    <i class="fa fa-pencil" aria-hidden="true"></i>
                </button>
                <div class="reaction-comment-action">
                    <button type="button" class="btn btn-reply-edit btn-success">
                        <i class="fa fa-check" aria-hidden="true"></i>
                    </button>
                    <button type="button" class="btn-reply-delete btn-danger">
                        <i class="fa fa-times" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
            @endif
        </div>
    </div>
    @endif
    {{-- share by & share with reaction_type = 3 --}}
    @if ($reaction_comment['reaction_type'] == 3)
    <div class="row mb-2 reaction__row">
        <div class="col-sm-12 col-md-12">
            <span>{{ $reaction_comment['reaction_user'] }}</span>
        </div>
    </div>
    <div class="row mb-2 reaction__row line-solid">
        <div class="col-sm-12 col-md-12">
            <div class="text-overfollow infomation_message" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($reaction_comment['share_text'] ?? '')!!}">
                {!! nl2br($reaction_comment['share_text']) !!}
            </div>
        </div>
    </div>
    @endif
    @endforeach
@else
    <div class="text-center mb-3">
        {{ $_text[21]['message'] }}
    </div>
@endif