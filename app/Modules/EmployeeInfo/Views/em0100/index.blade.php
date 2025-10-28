@extends('slayout')

@section('asset_header')
    {!! public_url('template/css/employeeinfo/em0100.index.css') !!}
@stop

@section('asset_footer')
    <script>
        var hide = '{{ __('messages.hide_attribute_info') }}';
        var display = '{{ __('messages.display_attribute_info') }}';
    </script>
    {!! public_url('template/js/employeeinfo/em0100.index.js') !!}
@stop

@push('asset_button')
    {!! Helper::dropdownRenderEmployeeInformation(['saveButton', 'backButton']) !!}
@endpush

@section('content')
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row" style="margin-top: 20px;">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="table-em0100">
                                <thead>
                                    <tr>
                                        <th></th>
                                        @if (!empty($tabs))
                                            @foreach ($tabs as $index => $tab)
                                                <th column="column-{{ $tab['tab_id'] }}">
                                                    <div class="md-checkbox-v2 inline-block">
                                                        <input name="" class="checkbox-setting"
                                                            id="checkbox-setting-{{ $tab['tab_id'] }}" type="checkbox"
                                                            @if ($tab['count_checked'] > 0)
                                                                checked
                                                            @endif
                                                            tabindex="1">
                                                        <label for="checkbox-setting-{{ $tab['tab_id'] }}"
                                                            class="label-checkbox-setting">{{ $tab['tab_nm'] ?? '' }}</label>
                                                    </div>
                                                </th>
                                            @endforeach
                                        @endif
                                    </tr>
                                    <tr>
                                        <th class="thead text-left">
                                            <div class="md-checkbox-v2 inline-block">
                                                <label>{{ __('messages.select_all') }}</label>
                                            </div>
                                        </th>
                                        @if (!empty($tabs))
                                            @foreach ($tabs as $index => $tab)
                                                <th column="column-{{ $tab['tab_id'] }}">
                                                    <div class="md-checkbox-v2 inline-block">
                                                        <input name="" class="checkbox-all"
                                                            id="checkbox-all-{{ $tab['tab_id'] }}" type="checkbox"
                                                            @if (sizeof($authorities) == $tab['count_checked'] && sizeof($authorities) > 0)
                                                                checked
                                                            @elseif ($tab['count_checked'] == 0)
                                                                disabled
                                                            @endif
                                                            tabindex="1">
                                                        <label for="checkbox-all-{{ $tab['tab_id'] }}"
                                                            class="label-checkbox-all"></label>
                                                    </div>
                                                </th>
                                            @endforeach
                                        @endif
                                    </tr>
                                </thead>
                                <tbody>
                                    @if (!empty($authorities))
                                        @foreach ($authorities as $index => $authority)
                                            <tr authority_cd="{{ $authority['authority_cd'] }}">
                                                <td class="thead">
                                                    <div class="md-checkbox-v2 inline-block">
                                                        <label 
                                                        >{{ $authority['authority_nm'] }}</label>
                                                    </div>
                                                </td>
                                                @if (!empty($tabs))
                                                    @foreach ($tabs as $tab)
                                                        @php
                                                            $json = html_entity_decode($tab['settings']);
                                                            $array = json_decode($json, true) ?? [];
                                                        @endphp
                                                        <td class="tabs" column="column-{{ $tab['tab_id'] }}">
                                                            <div class="md-checkbox-v2 inline-block">
                                                                <input type="text" class="d-none authority_cd"
                                                                    value="{{ $authority['authority_cd'] }}">
                                                                <input type="text" class="d-none tab_id"
                                                                    value="{{ $tab['tab_id'] }}">
                                                                <input name=""
                                                                    class="checkbox tab{{ $tab['tab_id'] }} use_typ"
                                                                    id="checkbox{{ $index }}-{{ $tab['tab_id'] }}"
                                                                    @if ($tab['count_checked'] == 0)
                                                                        disabled    
                                                                    @endif
                                                                    @if (!empty($array))
                                                                        @foreach ($array as $item)
                                                                            @if ($item['authority_cd'] == $authority['authority_cd'] && $item['tab_id'] == $tab['tab_id'] && $item['use_typ'] == 1)
                                                                                checked value="1" old_value="1"
                                                                                @break
                                                                            {{-- @else 
                                                                                value="0" old_value="0" --}}
                                                                            @endif  
                                                                        @endforeach
                                                                    @else 
                                                                        value="0"    
                                                                    @endif
                                                                    type="checkbox" tabindex="1">
                                                                <label
                                                                    for="checkbox{{ $index }}-{{ $tab['tab_id'] }}"
                                                                    class="checkbox"></label>
                                                            </div>
                                                        </td>
                                                    @endforeach
                                                @endif
                                            </tr>
                                        @endforeach
                                    @endif
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
