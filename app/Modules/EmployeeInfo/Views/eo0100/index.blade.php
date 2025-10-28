@extends('slayout')

@section('asset_header')
    {!! public_url('template/css/employeeinfo/eo0100.index.css') !!}
@stop

@section('asset_footer')
    {!! public_url('template/js/employeeinfo/eo0100.index.js') !!}
    <script>
        var qualification_master = '{{ __('messages.function_nm1') }}';
        var training_master = '{{ __('messages.function_nm3_1') }}';
        var error = '{{ __('messages.error') }}';
    </script>
@stop
@push('asset_button')
    {!! Helper::dropdownRenderEmployeeInformation(['dataInputButton', 'dataOutoutButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.target_data') }}</label>
                            <select id="target_employee_field" class="form-control" tabindex="1">
                                <option value="1">{{ __('messages.function_nm1') }}</option>
                                <option value="2">{{ __('messages.function_nm3_1') }}</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <input type="hidden" id="text_no_file" value="{{ __('messages.no_file_chosen') }}" />
                        <div class="form-group" style="position:absolute;z-index:-1">
                            <input type="file" class="form-control" id="real-input" placeholder="" maxlength="100"
                                accept=".csv" tabindex="2">
                        </div>
                        <div class="form-group form-control fake-input-upload" tabindex="0">
                            <div class="fake_input"><button
                                    class="ln-btn-input">{{ __('messages.choose_file') }}</button><span
                                    class="ln-text-file">{{ __('messages.no_file_chosen') }}</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
