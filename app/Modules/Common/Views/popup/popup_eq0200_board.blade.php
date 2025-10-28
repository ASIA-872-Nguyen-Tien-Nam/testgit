@extends('popup')

@push('header')
    {!! public_url('template/css/popup/eq0200_board.index.css') !!}
@endpush

@section('asset_footer')
    {!! public_url('template/js/popup/eq0200_board.index.js') !!}
@stop

@section('content')
    <div class="container-fluid" id="eq0200_board_popup">
        <div class="row mb-3">
            <div class="col mw-1st">
                <div class="avatar">
                    <div class="img" style="padding-top: 5px;">
                        <div class="d-flex flex-box" img_message="{{ __('messages.photo') }}">
                            @php
                                $url = '';
                                if (!empty($header['picture'])) {
                                    $url = asset('uploads/ei0200/' . session_data()->company_cd . '/' . $header['picture']);
                                }
                            @endphp
                            <p class="w-100">
                                @if (empty($header['picture']))
                                    {{ __('messages.photo') }}
                                @endif
                            </p>
                            <img src="{{ $url }}" alt="">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col mw-auto-1st">
                <div class="d-flex h-100 w-100 flex-column justify-content-end">
                    <div class="row m-0">
                        <div class="col mw-2st">
                            <div class="form-group">
                                <label class="control-label">{{ __('messages.employee_no') }}
                                </label>
                                <span class="num-length">
                                    <input type="text" class="form-control" value="{{ $header['employee_cd'] ?? '' }}" disabled>
                                </span>
                            </div>
                        </div>
                        <div class="col mw-auto-2st">
                            <div class="form-group">
                                <label class="control-label ">{{ __('messages.full_nm') }}</label>
                                <span class="num-length">
                                    <input type="text" class="form-control" value="{{ $header['employee_nm'] ?? '' }}" disabled>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {{-- <div class="row">
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label">{{ __('messages.organization_1') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control" value="{{ $organization_nm_1 ?? '' }}" tabindex="2"
                            disabled>
                    </span>
                </div>
            </div>
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.organization_2') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control" value="{{ $organization_nm_2 ?? '' }}" tabindex="2"
                            disabled>
                    </span>
                </div>
            </div>
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.organization_3') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control" value="{{ $organization_nm_3 ?? '' }}" tabindex="2"
                            disabled>
                    </span>
                </div>
            </div>
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.organization_4') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control" value="{{ $organization_nm_4 ?? '' }}" tabindex="2"
                            disabled>
                    </span>
                </div>
            </div>
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.organization_5') }}</label>
                    <span class="num-length">
                        <input type="text" class="form-control" value="{{ $organization_nm_5 ?? '' }}" tabindex="2"
                            disabled>
                    </span>
                </div>
            </div>
        </div> --}}

        @if (!empty($organization_group))
            <div class="row">
                @foreach ($organization_group as $item)
                    <div class="col mw-1st">
                        <div class="form-group">
                            <label class="control-label text-overfollow" data-container="body"
                            data-toggle="tooltip" data-original-title="{{ $item['organization_group_nm'] }}"
                            style="max-width: 150px; display: block"
                            >{{ $item['organization_group_nm'] }}</label>
                            {{-- <span class="num-length">
                                <input type="text" class="form-control text-overfollow" value="{{ $header['organization_nm_'.$item['organization_typ']] }}" 
                                data-container="body" data-toggle="tooltip" data-original-title="{{ $header['organization_nm_'.$item['organization_typ']] }}"
                                style="max-width: 450px; display: block"
                                tabindex="2" disabled>
                            </span> --}}
                            <span class="num-length text-overfollow fake-input-disabled" data-container="body" data-toggle="tooltip" data-original-title="{{ $header['organization_nm_'.$item['organization_typ']] }}"
                            style="max-width: 450px; display: block">
                                {{ $header['organization_nm_'.$item['organization_typ']] }}
                            </span>
                        </div>
                    </div>
                @endforeach
            </div>
        @endif

        <div class="row">
            <div class="col mw-1st">
                <div class="form-group">
                    <label class="control-label ">{{ __('messages.position') }}</label>
                    {{-- <span class="num-length">
                        <input type="text" class="form-control" value="{{ $header['position_nm'] ?? '' }}" disabled>
                    </span> --}}
                    <span class="num-length text-overfollow fake-input-disabled" data-container="body" data-toggle="tooltip" data-original-title="{{ $header['position_nm'] }}"
                        style="display: block">
                        {{ $header['position_nm'] }}
                    </span>
                </div>
            </div>
            @if (isset($header['show_mail']) && $header['show_mail'] == 1)
                <div class="col mw-1st">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.email') }}</label>
                        <span class="num-length">
                            <input type="text" class="form-control" value="{{ $header['mail'] ?? '' }}" disabled>
                        </span>
                    </div>
                </div>
            @endif
            @if (isset($header['show_company_mobile_display_kbn']) && $header['show_company_mobile_display_kbn'] == 1)
                <div class="col mw-1st">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.company_mobile_number') }}</label>
                        <span class="num-length">
                            <input type="text" class="form-control" value="{{ $header['company_mobile_number'] ?? '' }}" disabled>
                        </span>
                    </div>
                </div>
            @endif
            @if (isset($header['show_extension_number_display_kbn']) && $header['show_extension_number_display_kbn'] == 1)
                <div class="col mw-1st">
                    <div class="form-group">
                        <label class="control-label ">{{ __('messages.extension_number') }}</label>
                        <span class="num-length">
                            <input type="text" class="form-control" value="{{ $header['extension_number'] ?? '' }}" disabled>
                        </span>
                    </div>
                </div>
            @endif
        </div>

        {{-- tabs --}}
        <div class="row">
            <div class="col-md-12">
                <div class="position-relative">
                    <ul class="nav nav-tabs tab-style ml-0 border-0">
                        <li class="nav-item">
                            <a class="nav-link active show" data-toggle="tab" href="#popup_eq0200_board_01_tab"
                                role="tab" aria-selected="true" tabindex="1">
                                {{ __('messages.profile') }}
                            </a>
                        </li>
                        <li class="nav-item @if ($M9101['resume_use_typ'] != 1) d-none @endif">
                            <a class="nav-link" data-toggle="tab" href="#popup_eq0200_board_02_tab" role="tab"
                                aria-selected="true" tabindex="1">
                                {{ __('messages.work_history_infor') }}
                            </a>
                        </li>
                        <li class="nav-item @if ($M9101['cert_use_typ'] != 1) d-none @endif">
                            <a class="nav-link" data-toggle="tab" href="#popup_eq0200_board_03_tab" role="tab"
                                tabindex="1">
                                {{ __('messages.qualifications_held') }}
                            </a>
                        </li>
                    </ul>
                    <div class="tab-content m-0 w-100">
                        {{-- tab 1 --}}
                        <div class="tab-pane active m-0" id="popup_eq0200_board_01_tab">
                            @if (!empty($fields))
                                <div class="pl-4 pr-4 mt-3 pb-3" style="overflow: auto; max-height: 325px; height: fit-content;">
                                    @foreach ($fields as $item)
                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group mb-0">
                                                <label class="control-label text-overfollow" data-container="body"
                                                    data-toggle="tooltip" data-original-title="{{ $item['field_nm'] }}"
                                                    style="display: block">{{ $item['field_nm'] ?? '' }}</label>
                                                <span class="num-length text-overfollow fake-input-disabled" data-container="body" data-toggle="tooltip" data-original-title="{{$item['registered_value'] ?? '' }}"
                                                    style="display: block">
                                                    {{ $item['registered_value'] ?? '' }}
                                                </span>
                                                {{-- <span class="num-length">
                                                    <input type="text" class="form-control text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ $item['registered_value'] ?? '' }}"
                                                        value="{{ $item['registered_value'] ?? '' }}" disabled>
                                                </span> --}}
                                            </div>
                                        </div>
                                    </div>
                                    @endforeach
                                </div>
                            @else 
                                <div style="height: 1rem;"></div>
                            @endif
                        </div>
                        {{-- tab 2 --}}
                        <div class="tab-pane m-0" id="popup_eq0200_board_02_tab">
                            <div class="row">
                                <div class="col-md-12">
                                    @if (!empty($list_tab2))
                                        <div class="table-responsive pl-4 pr-4 mt-3 pb-3" style="overflow: auto; max-height: 325px; height: fit-content;">
                                            <span class="">{{__('messages.work_history_current_pos')}}</span>
                                            <div class="full-width" style="min-width: 700px;">
                                            @foreach ($list_tab2 as $index => $data)
                                                <div class="tr">
                                                        <div class="first-column text-center" style="width: 5%;">
                                                            {{ $index + 1 }}
                                                        </div>
                                                        <div class='d-flex flex-wrap' style="width: 95%">
                                                            @foreach ($data as $key => $item)
                                                                @php
                                                                    if ($key == 'detail_no') {
                                                                        continue;
                                                                    }
                                                                    $json = html_entity_decode($data[$key]);
                                                                    $array = json_decode($json, true) ?? [];
                                                                    $row = $array[0] ?? [];
                                                                @endphp
                                                                @if (isset($row['item_id']) && $row['item_id'] == 1)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.period') }}</label>
                                                                        <div class="d-flex p-1 item justify-content-center">
                                                                            <span>{{ $row['date_from'] ?? '' }}</span>
                                                                            <div class="pl-2 pr-2">
                                                                                ～
                                                                            </div>
                                                                            <span>{{ $row['date_to'] ?? '' }}</span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 2)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 3)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 4)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 5)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 6)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 7)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 8)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 9)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 10)
                                                                    <div
                                                                        class="width-6col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 11)
                                                                    <div
                                                                        class="width-6col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 12)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif 
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 13)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 14)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 15)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 16)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 17)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 18)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 19)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 20)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 21)
                                                                    @php
                                                                        if (isset($row['combobox'])) {
                                                                            $json = html_entity_decode(
                                                                                $row['combobox']
                                                                            );
                                                                            $array = json_decode($json, true) ?? [];
                                                                        }
                                                                    @endphp
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.selected_items') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            @if (count($array[0]) == 3)
                                                                                @foreach ($array ?? [] as $cb)
                                                                                    @if (($row['select_item'] ?? 0) == $cb['selected_items_no'])
                                                                                    <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $cb['selected_items_nm'] ?? '' }}">
                                                                                        {{ $cb['selected_items_nm'] ?? '' }}
                                                                                    </span>
                                                                                    @endif
                                                                                @endforeach
                                                                            @endif
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 22)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.numerical_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-right w-100">{{ $row['number_item'] ?? '' }}</span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 23)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.numerical_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-right w-100">{{ $row['number_item'] ?? '' }}</span>
                                                                        </div>
                                                                    </div>
                                                                @endif

                                                                @if (isset($row['item_id']) && $row['item_id'] == 24)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.numerical_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-right w-100">{{ $row['number_item'] ?? '' }}</span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 25)
                                                                    <div
                                                                        class="width-1col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} last-row item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.numerical_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-right w-100">{{ $row['number_item'] ?? '' }}</span>
                                                                        </div>
                                                                    </div>
                                                                @endif

                                                                @if (isset($row['item_id']) && $row['item_id'] == 26)
                                                                    <div
                                                                        class="width-6col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 27)
                                                                    <div
                                                                        class="width-6col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif

                                                                @if (isset($row['item_id']) && $row['item_id'] == 28)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 29)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                                @if (isset($row['item_id']) && $row['item_id'] == 30)
                                                                    <div
                                                                        class="width-2col group {{ $row['item_display_kbn'] == 1 ? '' : 'd-none' }} item_{{ $row['item_id'] ?? '' }}">
                                                                        <label
                                                                            class="control-label w-100 text-center m-0 pt-2 pb-2">{{ $row['item_title'] ?? __('messages.character_item') }}</label>
                                                                        <div class="d-flex p-1 item">
                                                                            <span class="text-overfollow w-100 d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $row['text_item'] ?? '' }}">
                                                                                {{ $row['text_item'] ?? '' }}
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                @endif
                                                            @endforeach
                                                        </div>
                                                    </div>
                                            @endforeach
                                            </div>
                                        </div>
                                    @else 
                                        <div style="height: 1rem;"></div>
                                    @endif
                                </div>
                            </div>
                        </div>
                        {{-- tab 3 --}}
                        <div class="tab-pane m-0" id="popup_eq0200_board_03_tab">
                            <div class="row">
                                <div class="col-md-12">
                                    @if (!empty($qualifications))
                                        <div class="div_table table-responsive pl-4 pr-4 mt-3 pb-3" style="overflow: auto; max-height: 325px; height:fit-content">
                                            <table class="table table-bordered table-head-fixed mb-0">
                                                <thead>
                                                    <th class="bg-column min-w45"></th>
                                                    <th class="bg-column min-w200">
                                                        {{ __('messages.qualification_date') }}</th>
                                                    <th class="bg-column min-w530">
                                                        {{ __('messages.qualification_name') }}
                                                    </th>
                                                </thead>
                                                <tbody>
                                                    @foreach ($qualifications as $index => $item)
                                                        <tr>
                                                            <td>{{ $index + 1 }}</td>
                                                            <td>
                                                                {{-- <span class="num-length">
                                                                    <div class="input-group-btn input-group">
                                                                        <input type="text"
                                                                            class="form-control input-sm date"
                                                                            value="{{ $item['headquarters_other'] }}"
                                                                            placeholder="yyyy/mm/dd" disabled>
                                                                        <div class="input-group-append-btn">
                                                                            <button class="btn btn-transparent"
                                                                                type="button" tabindex="-1"><i
                                                                                    class="fa fa-calendar"></i></button>
                                                                        </div>
                                                                    </div>
                                                                </span> --}}
                                                                <span class="num-length text-center">
                                                                    {{ $item['headquarters_other'] ?? '' }}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                {{-- <span class="num-length">
                                                                    <select class="form-control"disabled>
                                                                        <option value="0">
                                                                            {{ $item['qualification_nm'] }}</option>
                                                                    </select>
                                                                </span> --}}
                                                                <span class="num-length text-left text-overflow d-block" data-container="body" data-toggle="tooltip" data-original-title="{{ $item['qualification_nm'] ?? '' }}">
                                                                    {{ $item['qualification_nm'] ?? '' }}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    @endforeach
                                                </tbody>
                                            </table>
                                        </div>
                                    @else 
                                        <div style="height: 1rem;"></div>
                                    @endif
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
