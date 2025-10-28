@extends('slayout')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/employeeinfo/em0200.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/employeeinfo/em0200.index.js') !!}
    <script>
        var employee_cd  = '{{ $employee_cd }}';
    </script>
@stop

@push('asset_button')
    {!! Helper::dropdownRenderEmployeeInformation(['saveButton', 'backButton']) !!}
@endpush

@section('content')
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.organization_chart') }}</label>
                            <select id="organization_chart_use_typ" name="" class="form-control" tabindex="1">
                                @if (!empty($L0010_9))
                                    @foreach ($L0010_9 as $item)
                                        <option value="{{ $item['number_cd'] }}"
                                            @if (!isset($head['organization_chart_use_typ']) && $item['number_cd'] == 1) selected
                                            @elseif (isset($head['organization_chart_use_typ']) && $item['number_cd'] == $head['organization_chart_use_typ'])
                                            selected @endif>
                                            {{ $item['name'] }}
                                        </option>
                                    @endforeach
                                @endif
                            </select>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <div class="form-group mb-0 mt-46px">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="checkbox-1" class="organization" id="checkbox-1" value="1" type="checkbox"
                                    @if (isset($head['initial_display']) && $head['initial_display'] == 1) checked 
                                    @elseif (!isset($head['initial_display']))
                                        checked @endif
                                    @if (isset($head['organization_chart_use_typ']) && $head['organization_chart_use_typ'] == 0) disabled @endif tabindex="1">
                                <label for="checkbox-1">{{ __('messages.set_as_initial_display') }}</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.seat_chart') }}</label>
                            <select id="seating_chart_use_typ" name="" class="form-control" tabindex="1">
                                @if (!empty($L0010_9))
                                    @foreach ($L0010_9 as $item)
                                        <option value="{{ $item['number_cd'] }}"
                                            @if (!isset($head['seating_chart_use_typ']) && $item['number_cd'] == 1) selected
                                            @elseif (isset($head['seating_chart_use_typ']) && $item['number_cd'] == $head['seating_chart_use_typ'])
                                            selected @endif>
                                            {{ $item['name'] }}
                                        </option>
                                    @endforeach
                                @endif
                            </select>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <div class="form-group mb-0 mt-46px">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="checkbox-2" class="organization" id="checkbox-2" value="2" type="checkbox"
                                    @if (isset($head['initial_display']) && $head['initial_display'] == 2) checked @endif
                                    @if (isset($head['seating_chart_use_typ']) && $head['seating_chart_use_typ'] == 0) disabled @endif tabindex="1">
                                <label for="checkbox-2">{{ __('messages.set_as_initial_display') }}</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.search') }}</label>
                            <select id="search_function_use_typ" name="" class="form-control" tabindex="1">
                                @if (!empty($L0010_9))
                                    @foreach ($L0010_9 as $item)
                                        <option value="{{ $item['number_cd'] }}"
                                            @if (!isset($head['search_function_use_typ']) && $item['number_cd'] == 1) selected
                                            @elseif (isset($head['search_function_use_typ']) && $item['number_cd'] == $head['search_function_use_typ'])
                                            selected @endif>
                                            {{ $item['name'] }}
                                        </option>
                                    @endforeach
                                @endif
                            </select>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <div class="form-group mb-0 mt-46px">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="checkbox-3" class="organization" id="checkbox-3" value="3" type="checkbox"
                                    @if (isset($head['initial_display']) && $head['initial_display'] == 3) checked @endif
                                    @if (isset($head['search_function_use_typ']) && $head['search_function_use_typ'] == 0) disabled @endif tabindex="1">
                                <label for="checkbox-3">{{ __('messages.set_as_initial_display') }}</label>
                            </div>
                        </div>
                    </div>
                </div>
                {{-- initial_display --}}
                <input type="text" class="d-none" id="initial_display"
                    @if (isset($head['initial_display'])) value="{{ $head['initial_display'] ?? 1 }}"
                    @else 
                        value="1" @endif>
                <div class="row">
                    <div class="col-md-12">
                        <div class="line-border-bottom">
                            <label class="control-label">{{ __('messages.seating_chart_function') }}</label>
                        </div>
                    </div>
                </div>

                {{-- table --}}
                <div id="em0200_table" class="row">
                    <div class="col-md-12">
                        <div class="table-responsive sticky-table">
                            <table class="table table-bordered table-hover table-striped m-0">
                                <thead>
                                    <tr>
                                        <th class="text-center first-column">
                                            <button id="btn-add-row" class="btn" tabindex="1">
                                                <i class="fa fa-plus"></i>
                                            </button>
                                        </th>
                                        <th>
                                            {{ __('messages.floor_nm') }}
                                        </th>
                                        <th>
                                            {{ __('messages.floor_map') }}
                                        </th>
                                        <th>
                                            {{ __('messages.seat_chart_type') }}
                                        </th>
                                        <th class="last-column"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @if (!empty($details))
                                        @foreach ($details as $index => $row)
                                            <tr class="tr">
                                                <td class="text-center first-column">
                                                    {{ $index + 1 }}
                                                </td>
                                                <td>
                                                    <span class="num-length">
                                                        <input type="text" class="d-none floor_id"
                                                            value="{{ $row['floor_id'] ?? '' }}">
                                                        <input type="text" class="form-control floor_name"
                                                            value="{{ $row['floor_name'] ?? '' }}" maxlength="20"
                                                            tabindex="1">
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="form-group mb-0">
                                                        <label class="face-file-btn" tabindex="1">
                                                            <i class="fa fa-folder-open"></i>
                                                        </label>
                                                        <div class="div_upload_file">
                                                            <input type="text" class="d-none floor_map" value="{{ $row['floor_map'] ?? '' }}">
                                                            <input type="text"
                                                                class="form-control fake-input-upload-file floor_map_name"
                                                                value="{{ $row['floor_map_name'] ?? '' }}" readonly="readonly"
                                                                tabindex="-1">
                                                            <input type="file"
                                                                class="input-upload-file d-none floor_map_hidden"
                                                                accept="application/pdf" tabindex="-1">
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="radio">
                                                        @if (!empty($L0010_77))
                                                            @foreach ($L0010_77 as $item)
                                                                @php
                                                                    if ($item['number_cd'] == 1) {
                                                                        $id = 'radio_fixed_seats_' . $index;
                                                                        $class = 'radio_fixed_seats';
                                                                    }
                                                                    if ($item['number_cd'] == 2) {
                                                                        $id = 'radio_free_address_' . $index;
                                                                        $class = 'radio_free_address';
                                                                    }
                                                                @endphp
                                                                <div class="md-radio-v2 inline-block">
                                                                    <input type="radio"
                                                                        name="list[{{ $index }}][seat_type]"
                                                                        class="{{ $class }}"
                                                                        id="{{ $id }}"
                                                                        value="{{ $item['number_cd'] }}"
                                                                        @if ($item['number_cd'] == $row['seating_chart_typ']) checked @endif>
                                                                    <label class="label_{{ $class }}"
                                                                        for="{{ $id }}"
                                                                        tabindex="1">{{ $item['name'] }}</label>
                                                                </div>
                                                            @endforeach
                                                        @endif
                                                    </div>
                                                </td>
                                                <td class="text-center last-column">
                                                    <button class="btn btn-remove-row" tabindex="1">
                                                        <i class="fa fa-remove"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        @endforeach
                                    @else
                                        @php
                                            $index = 0;
                                        @endphp
                                        <tr class="tr">
                                            <td class="text-center first-column">
                                                {{ $index + 1 }}
                                            </td>
                                            <td>
                                                <span class="num-length">
                                                    <input type="text" class="d-none floor_id" value="">
                                                    <input type="text" class="form-control floor_name" value=""
                                                        maxlength="20" tabindex="1">
                                                </span>
                                            </td>
                                            <td>
                                                <div class="form-group mb-0">
                                                    <label class="face-file-btn" tabindex="1">
                                                        <i class="fa fa-folder-open"></i>
                                                    </label>
                                                    <div class="div_upload_file">
                                                        <input type="text" class="d-none floor_map" value="">
                                                        <input type="text"
                                                            class="form-control fake-input-upload-file floor_map_name"
                                                            value="" readonly="readonly" tabindex="-1">
                                                        <input type="file" class="input-upload-file d-none floor_map_hidden"
                                                            accept="application/pdf" tabindex="-1">
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="radio">
                                                    @if (!empty($L0010_77))
                                                        @foreach ($L0010_77 as $item)
                                                            @php
                                                                if ($item['number_cd'] == 1) {
                                                                    $id = 'radio_fixed_seats_' . $index;
                                                                    $class = 'radio_fixed_seats';
                                                                }
                                                                if ($item['number_cd'] == 2) {
                                                                    $id = 'radio_free_address_' . $index;
                                                                    $class = 'radio_free_address';
                                                                }
                                                            @endphp
                                                            <div class="md-radio-v2 inline-block">
                                                                <input type="radio"
                                                                    name="list[{{ $index }}][seat_type]"
                                                                    class="{{ $class }}" id="{{ $id }}"
                                                                    value="{{ $item['number_cd'] }}"
                                                                    @if ($item['number_cd'] == 1) checked @endif>
                                                                <label class="label_{{ $class }}"
                                                                    for="{{ $id }}"
                                                                    tabindex="1">{{ $item['name'] }}</label>
                                                            </div>
                                                        @endforeach
                                                    @endif
                                                </div>
                                                <input type="text" class="d-none seating_chart_typ" value="1">
                                            </td>
                                            <td class="text-center last-column">
                                                <button class="btn btn-remove-row" tabindex="1">
                                                    <i class="fa fa-remove"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    @endif
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                {{-- clone --}}
                <div id="em0200_clone_table" class="row d-none">
                    <table class="table table-bordered table-hover table-striped">
                        <thead>
                            <tr>
                                <th class="text-center first-column">
                                    <button id="btn-add-row" class="btn" tabindex="1">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </th>
                                <th>
                                    {{ __('messages.floor_nm') }}
                                </th>
                                <th>
                                    {{ __('messages.floor_map') }}
                                </th>
                                <th>
                                    {{ __('messages.seat_chart_type') }}
                                </th>
                                <th class="last-column"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center first-column">
                                    1
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input type="text" class="d-none floor_id">
                                        <input type="text" class="form-control floor_name" maxlength="20"
                                            tabindex="1">
                                    </span>
                                </td>
                                <td>
                                    <div class="form-group mb-0">
                                        <label class="face-file-btn" tabindex="1">
                                            <i class="fa fa-folder-open"></i>
                                        </label>
                                        <div class="div_upload_file">
                                            <input type="text" class="d-none floor_map" value="">
                                            <input type="text"
                                                class="form-control fake-input-upload-file floor_map_name"
                                                readonly="readonly" tabindex="-1">
                                            <input type="file" class="input-upload-file d-none floor_map_hidden"
                                                accept="application/pdf" tabindex="-1">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="radio">
                                        @if (!empty($L0010_77))
                                            @foreach ($L0010_77 as $item)
                                                @php
                                                    if ($item['number_cd'] == 1) {
                                                        $id = 'radio_fixed_seats_' . $index;
                                                        $class = 'radio_fixed_seats';
                                                    }
                                                    if ($item['number_cd'] == 2) {
                                                        $id = 'radio_free_address_' . $index;
                                                        $class = 'radio_free_address';
                                                    }
                                                @endphp
                                                <div class="md-radio-v2 inline-block">
                                                    <input type="radio" name="" class="{{ $class }}"
                                                        id="" value="{{ $item['number_cd'] }}"
                                                        @if ($item['number_cd'] == 1) checked @endif>
                                                    <label for="" class="label_{{ $class }}"
                                                        tabindex="1">{{ $item['name'] }}</label>
                                                </div>
                                            @endforeach
                                        @endif
                                    </div>
                                    <input type="text" class="d-none seating_chart_typ" value="1">
                                </td>
                                <td class="text-center last-column">
                                    <button class="btn btn-remove-row" tabindex="1">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12">
                        <div class="line-border-bottom">
                            <label class="control-label">{{ __('messages.personal_registration_data') }}</label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-auto">
                        <div class="form-group mb-0">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="emailaddress_display_kbn" id="emailaddress_display_kbn" type="checkbox"
                                    @if (isset($head['emailaddress_display_kbn']) && $head['emailaddress_display_kbn'] == 1) checked @endif
                                    value="{{ $head['emailaddress_display_kbn'] ?? '0' }}" tabindex="1">
                                <label for="emailaddress_display_kbn">{{ __('messages.show_email_address') }}</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <div class="form-group mb-0">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="company_mobile_display_kbn" id="company_mobile_display_kbn" type="checkbox"
                                    @if (isset($head['company_mobile_display_kbn']) && $head['company_mobile_display_kbn'] == 1) checked @endif
                                    value="{{ $head['company_mobile_display_kbn'] ?? '0' }}" tabindex="1">
                                <label
                                    for="company_mobile_display_kbn">{{ __('messages.display_company_mobile_number') }}</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-auto">
                        <div class="form-group mb-0">
                            <div id="checkbox" class="md-checkbox-v2 inline-block">
                                <input name="extension_number_display_kbn" id="extension_number_display_kbn"
                                    @if (isset($head['extension_number_display_kbn']) && $head['extension_number_display_kbn'] == 1) checked @endif
                                    value="{{ $head['extension_number_display_kbn'] ?? '0' }}" type="checkbox"
                                    tabindex="1">
                                <label
                                    for="extension_number_display_kbn">{{ __('messages.display_extension_number') }}</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
