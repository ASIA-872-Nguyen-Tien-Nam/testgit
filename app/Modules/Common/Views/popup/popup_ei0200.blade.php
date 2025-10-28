@extends('popup')

@push('header')
    {!! public_url('template/css/popup/ei0200.index.css') !!}
@endpush

@section('asset_footer')
    {!! public_url('template/js/popup/ei0200.index.js') !!}
@stop

@section('content')
    <div class="container-fluid" id="ei0200_popup">
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
                            <img src="{{ $url }}"
                                alt="">
                        </div>
                    </div>
                    <div class="text-center mt-2">
                        <button class="btn-upload" tabindex="2">
                            <i class="fa fa-folder-open"></i>
                        </button>
                        <button class="btn-clearfile" tabindex="2">
                            <i class="fa fa-trash"></i>
                        </button>
                        <div class="input-group hidden">
                            <span class="input-group-btn">
                                <span class="btn btn-default btn-file">
                                    Browse… <input type="file" id="image-input" accept="image/*">
                                </span>
                            </span>
                            <input type="text" class="form-control" readonly>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col mw-auto-1st">
                <div class="d-flex h-100 w-100 flex-column">
                    <div class="h-50">
                        <div class="row m-0 justify-content-end">
                            <div class="col mw-3st @if (empty($combobox)) d-none @endif">
                                <label class="control-label nowrap">{{ __('messages.floor_init_displayed_seating_chart') }}
                                </label>
                                <select class="form-control" id="initial_floor_id" tabindex="1">
                                    <option value="0"></option>
                                    @if (!empty($combobox))
                                        @foreach ($combobox as $item)
                                            <option value="{{ $item['floor_id'] }}"
                                                @if (isset($header['initial_floor_id']) && $header['initial_floor_id'] == $item['floor_id']) selected @endif>{{ $item['floor_name'] }}
                                            </option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="h-50">
                        <div class="row m-0">
                            <div class="col mw-2st">
                                <div class="form-group">
                                    <label class="control-label">{{ __('messages.employee_no') }}
                                    </label>
                                    <span class="num-length">
                                        <input type="text" class="form-control" id="employee_cd"
                                            value="{{ $header['employee_cd'] ?? '' }}" disabled>
                                    </span>
                                </div>
                            </div>
                            <div class="col mw-auto-2st">
                                <div class="form-group">
                                    <label class="control-label ">{{ __('messages.full_nm') }}</label>
                                    <span class="num-length">
                                        <input type="text" class="form-control" value="{{ $header['employee_nm'] ?? '' }}"
                                            disabled>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        @if (!empty($organization_group))
            <div class="row">
                @foreach ($organization_group as $item)
                    <div class="col mw-1st">
                        <div class="form-group">
                            <label class="control-label text-overfollow" data-container="body"
                            data-toggle="tooltip" data-original-title="{{ $item['organization_group_nm'] }}"
                            style="max-width: 150px; display: block"
                            >{{ $item['organization_group_nm'] }}</label>
                            <span class="num-length text-overfollow fake-input-disabled" data-container="body" data-toggle="tooltip" data-original-title="{{ $header['organization_nm_'.$item['organization_typ']] ?? '' }}"
                            style="max-width: 270px; display: block">
                                {{ $header['organization_nm_'.$item['organization_typ']] ?? '' }}
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
                    <span class="num-length text-overfollow fake-input-disabled" data-container="body" data-toggle="tooltip" data-original-title="{{ $header['position_nm'] ?? '' }}"
                        style="max-width: 270px; display: block">
                        {{ $header['position_nm'] ?? '' }}
                    </span>
                </div>
            </div>
        </div>
        @if (!empty($fields))
            @foreach ($fields as $item)
                <div class="row tr">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label class="control-label ">{{ $item['field_nm'] ?? '' }}</label>
                            <span class="num-length">
                                <input type="text" class="d-none field_cd" value="{{ $item['field_cd'] ?? '' }}">
                                <input type="text" class="form-control registered_value" tabindex="2"
                                    value="{{ $item['registered_value'] ?? '' }}" maxlength="50">
                            </span>
                        </div>
                    </div>
                </div>
            @endforeach
        @endif
        <div class="row">
            <div class="full-width text-center">
            {!! Helper::buttonRenderEmployeeInformation(['saveButton_ei0200']) !!}
                
            </div>
        </div>
        
    </div>
    <style>
        .input-group-btn {
            justify-content: center;
        }
    </style>
@stop
