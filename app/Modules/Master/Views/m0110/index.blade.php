@extends('layout')

@push('asset_header')
        <!-- START LIBRARY CSS -->
@endpush

@section('asset_footer')
        <!-- START LIBRARY JS -->
    {!!public_url('template/js/form/m0110.index.js')!!}
@stop

@push('asset_button')
{!!
    Helper::buttonRender(['saveButton' ,'deleteButton', 'backButton'])
!!}
@endpush

@section('content')
<style>
    @media (max-width: 575px) {
        #table-data {
            min-width: 800px;
        }
    }
    @media (max-width: 1199px) and (min-width: 992px) {
        #table-data {
            min-width: unset !important;
        }
    }
    @media (max-width: 991px) and (min-width: 768px) {
        #table-data {
            min-width: unset !important;
        }
    }
    @media (max-width: 767px) and (min-width: 576px) {
        #table-data {
            min-width: 800px !important;
        }
    }
</style>
    <!-- START CONTENT -->
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div class="col-sm-12 col-md-12 col-xl-12 col-lg-12 col-12">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover table-striped " id="table-data">
                        <thead>
                        <tr>
                            <th class="text-center" style="width: 40%;">{{ __('messages.level_name') }}</th>
                            <th class="text-center" style="width: 120px;">{{ __('messages.coefficient') }}</th>
                            <th class="text-center" >{{ __('messages.description') }}</th>
                            <th style="width: 10px;">
                                <button class="btn btn-rm blue btn-sm" id="btn-add-new" tabindex="-1">
                                    <i class="fa fa-plus"></i>
                                </button>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                            @if ( !empty($rows) )
                            @foreach ($rows as $row)
                            <tr class="tr">
                                <td>
                                    <span class="num-length">
                                        <input type="hidden" class="form-control challenge_level" value="{{isset($row['challenge_level'])?$row['challenge_level']:''}}">
                                        <input type="text" class="form-control input-sm challenge_level_nm required" maxlength="50" value="{{isset($row['challenge_level_nm'])?$row['challenge_level_nm']:''}}">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input type="text" class="form-control input-sm text-right numeric betting_rate required" maxlength="6" value="{{isset($row['betting_rate'])?(float)$row['betting_rate']:''}}" decimal="2">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input type="text" class="form-control input-sm text-left  explanation required" maxlength="50" value="{{isset($row['explanation'])?$row['explanation']:''}}" >
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-rm btn-sm btn-remove-row">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            </tr>
                            @endforeach
                            @else
                            <tr class="tr">
                                <td>
                                    <span class="num-length">
                                        <input type="hidden" class="form-control challenge_level">
                                        <input type="text" class="form-control input-sm challenge_level_nm required" maxlength="50">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input type="text" class="form-control input-sm text-right numeric betting_rate required" maxlength="6" decimal="2">
                                    </span>
                                </td>
                                <td>
                                    <span class="num-length">
                                        <input type="text" class="form-control input-sm text-left  explanation required" maxlength="50"  >
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-rm btn-sm btn-remove-row">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </td>
                            </tr>
                            @endif
                        </tbody>
                    </table>
                </div><!-- end .table-responsive -->
            </div>
        </div>
    </div><!--/.card -->
</div><!--/.container-fluid -->
@stop

@section('asset_common')
    <table class="hidden" id="table-target">
        <tbody>
            <tr>
                <td>
                    <span class="num-length">
                        <input type="hidden" class="form-control challenge_level">
                        <input type="text" class="form-control input-sm challenge_level_nm required" maxlength="50" value="">
                    </span>
                </td>
                <td>
                    <span class="num-length">
                        <input type="text" class="form-control input-sm text-right numeric betting_rate required" maxlength="6" decimal="2">
                    </span>
                </td>
                <td>
                    <span class="num-length">
                        <input type="text" class="form-control input-sm text-left  explanation required" maxlength="50"  >
                    </span>
                </td>
                <td class="text-center">
                    <button class="btn btn-rm btn-sm btn-remove-row">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        </tbody>
    </table><!-- /.hidden -->
@stop