@extends('popup')

@push('header')
    {!! public_url('template/css/popup/comment_options.css') !!}
@endpush

@section('asset_footer')
    {!! public_url('template/js/popup/comment_options.js') !!}
@stop

@section('content')
    <div class="row">
        <div class="col-12">
            <span>{{ __('ri2010.comment_label_row_max') }}</span>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="table-responsive wmd-view table-fixed-header sticky-table sticky-headers sticky-ltr-cells ">
                <table class="table table-bordered table-cursor table-hover table-oneheader member-list"
                    id="comment_options_table">
                    <thead>
                        <tr>
                            <th width="10%">
                                <div class="text-center">
                                    <span>
                                        <button class="btn btn-rm blue btn-sm" id="btn_add_comment_options" tabindex="1">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </span>
                                </div>
                            </th>
                            <th>
                                {{ __('messages.comment') }}
                            </th>
                            <th width="20%">

                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        @if (isset($comment_options) && !empty($comment_options))
                            @foreach ($comment_options as $comment_option)
                                <tr class="comment_option_row">
                                    <td class="text-center">{{ $comment_option['row_index'] }}</td>
                                    <td class="comment_options_txt_link">
                                        <div class="comment_options_input_area {{ $comment_option['view_typ'] == 1 ? 'hide': '' }}">
                                            <span class="num-length">
                                                <textarea class="form-control comment_options_input" maxlength="30" value="{{ $comment_option['comment'] }}" tabindex="1">{{ $comment_option['comment'] }}</textarea>
                                            </span>
                                        </div>
                                        <span class="comment_options_text">
                                            {!! nl2br($comment_option['comment'] ?? '') !!}
                                        </span>
                                        <input type="hidden" class="form-control detail_no" maxlength="30" value="{{ $comment_option['detail_no'] }}" tabindex="1">
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-rm blue btn-sm btn-comment-options-save" tabindex="1">
                                            <i class="fa fa-check" aria-hidden="true"></i>
                                        </button>
                                        &nbsp;
                                        <button class="btn btn-rm blue btn-sm btn-comment-options-edit {{ $comment_option['view_typ'] == 0 ? 'active': '' }}" tabindex="1">
                                            <i class="fa fa-pencil"></i>
                                        </button>
                                        &nbsp;
                                        <button class="btn btn-rm red btn-sm btn-comment-options-delete" tabindex="1">
                                            <i class="fa fa-trash" aria-hidden="true"></i>
                                        </button>
                                    </td>
                                </tr>
                            @endforeach
                        @endif

                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <input type="hidden" class="anti_tab">
    <table class="hide" id="comment_options_table_hide">
        <tbody>
            <tr class="comment_option_row">
                <td class="text-center"></td>
                <td class="comment_options_txt_link">
                    <div class="comment_options_input_area">
                        <span class="num-length">
                            <textarea class="form-control comment_options_input" maxlength="30" value="" tabindex="1"></textarea>
                        </span>
                    </div>
                    <span class="comment_options_text hide"></span>
                    <input type="hidden" class="form-control detail_no" maxlength="30" value="" tabindex="1">
                </td>
                <td class="text-center">
                    <button class="btn btn-rm blue btn-sm btn-comment-options-save" tabindex="1">
                        <i class="fa fa-check" aria-hidden="true"></i>
                    </button>
                    &nbsp;
                    <button class="btn btn-rm blue btn-sm btn-comment-options-edit active" tabindex="1">
                        <i class="fa fa-pencil"></i>
                    </button>
                    &nbsp;
                    <button class="btn btn-rm red btn-sm btn-comment-options-delete" tabindex="1">
                        <i class="fa fa-trash" aria-hidden="true"></i>
                    </button>
                </td>
            </tr>
        </tbody>
    </table>
@stop
