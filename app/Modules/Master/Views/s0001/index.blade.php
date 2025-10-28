@extends('customer')

@section('asset_header')
    <!-- START LIBRARY CSS -->
    {!! public_url('template/css/form/s0001.index.css') !!}
@stop

@section('asset_footer')
    <!-- START LIBRARY JS -->
    {!! public_url('template/js/form/s0001.index.js') !!}
@stop
@push('asset_button')
    {!! Helper::buttonRender(['saveButton', 'backButton']) !!}
@endpush
@section('content')
    <!-- START CONTENT -->
    <div class="container-fluid" id="rightcontent">
        <div class="inner" style="padding:8px;">
            <div class="card-body" style="flex:unset">
                <div class="line-border-bottom">
                    <label class="control-label">{{ __('messages.google_api') }}</label>
                </div>
                <div class="col-lg-10 col-md-8">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">Client
                            ID</label>
                        <span class="num-length">
                            <input type="text" id="client_id" class="form-control required" maxlength="255"
                                tabindex="1" autofocus value="{{ $S0001[0]['client_id'] ?? '' }}">
                        </span>
                    </div><!--/.form-group -->
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">Client
                            Secret</label>
                        <span class="num-length">
                            <input type="text" id="client_secret" class="form-control required" maxlength="255"
                                tabindex="1" value="{{ $S0001[0]['client_secret'] ?? '' }}">
                        </span>
                    </div><!--/.form-group -->
                </div>

            </div>
            @if (isset($S0001[0]) && $S0001[0]['client_id'] != '' && $S0001[0]['client_id'])
            <div class="card-body card-body_table_data" style="padding-bottom:8px">
                <div class="row mb-3 col-lg-9 col-md-9 mt-8">
                    @if (isset($S0001[0]) && $S0001[0]['client_id'] != '' && $S0001[0]['client_id'])
                        <div class="col-md-12">
                            <div class="full-width">
                                <a class="btn btn-primary btn-basic-setting-menu btn-issue" tabindex="1"
                                    id="generate_token">
                                    <i class="fa fa-check"></i>{{ __('messages.token_issue') }}
                                </a>
                            </div>
                        </div>
                </div>
                <div class="row mb-3 col-lg-9 col-md-9 mt-8">
                    <div class="col-md-12">
                        <div class="full-width" style="padding-left:10px">
                            <div id="s0001_table" class="row">
                                <div class="table-responsive sticky-table">
                                    <table class="table table-bordered table-hover table-striped m-0">
                                        <thead>
                                            <tr class="text-center" style="height: 55px;">
                                                <th width="120">{{ __('messages.access_token') }}</th>
                                                <th width="120">{{ __('messages.refresh_token') }}</th>
                                                <th width="50">{{ __('messages.expired') }}</th>
                                                <th width="50">{{ __('messages.token_status') }}</th>
                                            </tr>
                                        </thead>
                                        <tbody id="result">
                                            @if (isset($S0002))
                                                @foreach ($S0002 as $item)
                                                    <tr class="list">
                                                        <td class="row_token text-overfollow" data-container="body"
                                                            data-toggle="tooltip" title=""
                                                            data-original-title="{{ $item['access_token'] }}">
                                                            {{ $item['access_token'] }}</td>
                                                        <td class="row_token text-overfollow" data-container="body"
                                                            data-toggle="tooltip" title=""
                                                            data-original-title="{{ $item['refresh_token'] }}">
                                                            {{ $item['refresh_token'] }}</td>
                                                        <td class="row_token text-overfollow" data-container="body"
                                                            style="text-align: center;" data-toggle="tooltip" title=""
                                                            data-original-title="{{ $item['effective_date'] }}">
                                                            {{ $item['effective_date'] }}</td>
                                                        @if ($item['status'] == 0)
                                                            <td class="row_token" style="text-align: center;">
                                                                {{ __('messages.token_enabled') }}</td>
                                                        @else
                                                            <td class="row_token" style="text-align: center;">
                                                                {{ __('messages.token_disabled') }}</td>
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
                    @endif
                </div>
            </div>
            @endif
             <div class="card-body" style="flex:unset">
            <div class="line-border-bottom">
                <label class="control-label">{{ __('messages.KOT_API') }}</label>
            </div>
            <div>
                <div class="col-lg-10 col-md-8">
                    <div class="form-group">
                        <label class="control-label lb-required"
                            lb-required="{{ __('messages.required') }}">{{ __('messages.kot_client_id') }}</label>
                        <span class="num-length">
                            <input type="text" id="kot_client_id" class="form-control required" maxlength="255"
                                tabindex="1" value="{{ $S0001[0]['kot_client_id'] ?? '' }}" autofocus>
                        </span>
                    </div><!--/.form-group -->
                </div>

                <div class="col-lg-10 col-md-8">
                    <div class="form-group">
                        <label class="control-label lb-required"
                            lb-required="{{ __('messages.required') }}">{{ __('messages.kot_client_secret') }}</label>
                        <span class="num-length">
                            <input type="text" id="kot_client_secret" class="form-control  required" maxlength="255"
                                tabindex="1" value="{{ $S0001[0]['kot_client_secret'] ?? '' }}">
                        </span>
                    </div><!--/.form-group -->
                </div>
            </div>
            </div>
        </div>
    </div><!-- end .container-fluid -->
@stop
