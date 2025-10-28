<div class="row bar__title align-items-center">
    <div class="form-group mb-0">
        <div class="full-width">
            <a id="btn_header_show" class="btn btn-outline-primary bar__button" tabindex="-1">
                {{ __('ri2010.target_show') }}
            </a>
        </div>
    </div>
    <div class="form-group mb-0">
        <span>{{ __('ri2010.employee_label') }}</span>
    </div>
</div>
<div class="row hide" id="header">
    <div class="col-md-3 col-sm-12 col-12 col-lg-3 col-xl-2">
        <div class="">
            <table class="table table_avatar">
                <tbody>
                    <tr>
                        <td>
                            @if (isset($picture) && $picture != '')
                                <div class="avatar">
                                    <div class="img">
                                        <div
                                            class="d-flex flex-box {{ !isset($picture) || $picture == '' ? 'flex-box-image' : '' }}">
                                            @if (!isset($picture) || $picture == '')
                                                <p class="w100">{{ __('messages.photo') }}</p>
                                                <img id="img-upload" class="thumb" />
                                            @else
                                                <img id="img-upload" class="thumb imgs"
                                                    src="{{ $picture }}?v={{ time() }}" />
                                            @endif
                                        </div>
                                    </div>
                                </div>
                            @else
                                <div class="avatar">
                                    <div class="img">
                                        <div class="d-flex flex-box portrait">
                                            <p class="w100">{{ __('messages.photo') }}</p>
                                            <img id="img-upload" class="thumb" />
                                        </div>
                                    </div>
                                </div>
                            @endif
                            <div class="text-center" style="word-break: break-all;" id="employee_nm">
                                {{ $employee_nm ?? '' }}</div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-md-9 col-sm-12 col-12 col-lg-9 col-xl-10">
        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive">
                    <table class="tbl-header" id="table-data">
                        <tbody>
                            <tr>
                                <td>
                                    <div class="form-inline finline">
                                        <div class="form-group">
                                            <label class="form-control-plaintext lbl text-overfollow ln-text"
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ __('messages.employee_classification') }}">{{ __('messages.employee_classification') }}</label>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-control-plaintext txt text-overfollow" style=""
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $employee_typ_nm ?? '' }}">{{ $employee_typ_nm ?? '' }}</label>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline finline">
                                        <div class="form-group">
                                            <label class="form-control-plaintext lbl text-overfollow ln-text"
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ __('messages.job') }}">{{ __('messages.job') }}</label>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-control-plaintext txt text-overfollow" style=""
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $job_nm ?? '' }}">{{ $job_nm ?? '' }}</label>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline finline">
                                        <div class="form-group">
                                            <label class="form-control-plaintext lbl text-overfollow ln-text"
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ __('messages.position') }}">{{ __('messages.position') }}</label>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-control-plaintext txt text-overfollow" style=""
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $position_nm ?? '' }}">{{ $position_nm ?? '' }}</label>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-inline finline">
                                        <div class="form-group">
                                            <label class="form-control-plaintext lbl text-overfollow ln-text"
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ __('messages.grade') }}">{{ __('messages.grade') }}</label>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-control-plaintext txt text-overfollow" style=""
                                                data-container="body" data-toggle="tooltip"
                                                data-original-title="{{ $grade_nm ?? '' }}">{{ $grade_nm ?? '' }}</label>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            @if (isset($organizations) && !empty($organizations))
                                <tr>
                                    @foreach ($organizations as $organization)
                                        <td>
                                            <div class="form-inline finline">
                                                <div class="form-group">
                                                    <label class="form-control-plaintext lbl text-overfollow ln-org"
                                                        data-container="body" data-toggle="tooltip"
                                                        data-original-title="{{ $organization['organization_group_nm'] ?? '' }}">{{ $organization['organization_group_nm'] ?? '' }}</label>
                                                </div>
                                                <div class="form-group">
                                                    @if ($organization['organization_typ'] == 1)
                                                        <label class="form-control-plaintext txt text-overfollow"
                                                            data-container="body" data-toggle="tooltip"
                                                            data-original-title="{{ $belong_nm1 ?? '' }}">{{ $belong_nm1 ?? '' }}</label>
                                                    @elseif ($organization['organization_typ'] == 2)
                                                        <label class="form-control-plaintext txt text-overfollow"
                                                            data-container="body" data-toggle="tooltip"
                                                            data-original-title="{{ $belong_nm2 ?? '' }}">{{ $belong_nm2 ?? '' }}</label>
                                                    @elseif ($organization['organization_typ'] == 3)
                                                        <label class="form-control-plaintext txt text-overfollow"
                                                            data-container="body" data-toggle="tooltip"
                                                            data-original-title="{{ $belong_nm3 ?? '' }}">{{ $belong_nm3 ?? '' }}</label>
                                                    @elseif ($organization['organization_typ'] == 4)
                                                        <label class="form-control-plaintext txt text-overfollow"
                                                            data-container="body" data-toggle="tooltip"
                                                            data-original-title="{{ $belong_nm4 ?? '' }}">{{ $belong_nm4 ?? '' }}</label>
                                                    @elseif ($organization['organization_typ'] == 5)
                                                        <label class="form-control-plaintext txt text-overfollow"
                                                            data-container="body" data-toggle="tooltip"
                                                            data-original-title="{{ $belong_nm5 ?? '' }}">{{ $belong_nm5 ?? '' }}</label>
                                                    @endif
                                                </div>
                                            </div>
                                        </td>
                                    @endforeach
                                </tr>
                            @endif
                            <!-- <tr>--namnt comment 20230818
                                @if (isset($approver_employee_nm_1) && $approver_employee_nm_1 != '')
                                    <td>
                                        <div class="form-inline finline">
                                            <div class="form-group">
                                                <label class="form-control-plaintext lbl text-overfollow ln-org"
                                                    data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ __('ri2010.primary_approver') }}">{{ __('ri2010.primary_approver') }}</label>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-control-plaintext txt text-overfollow"
                                                    style="" data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ $approver_employee_nm_1 ?? '' }}">{{ $approver_employee_nm_1 ?? '' }}</label>
                                            </div>
                                        </div>
                                    </td>
                                @endif
                                @if (isset($approver_employee_nm_2) && $approver_employee_nm_2 != '')
                                    <td>
                                        <div class="form-inline finline">
                                            <div class="form-group">
                                                <label class="form-control-plaintext lbl text-overfollow ln-org"
                                                    data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ __('ri2010.secondary_approver') }}">{{ __('ri2010.secondary_approver') }}</label>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-control-plaintext txt text-overfollow"
                                                    style="" data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ $approver_employee_nm_2 ?? '' }}">{{ $approver_employee_nm_2 ?? '' }}</label>
                                            </div>
                                        </div>
                                    </td>
                                @endif
                                @if (isset($approver_employee_nm_3) && $approver_employee_nm_3 != '')
                                    <td>
                                        <div class="form-inline finline">
                                            <div class="form-group">
                                                <label class="form-control-plaintext lbl text-overfollow ln-org"
                                                    data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ __('ri2010.third_approver') }}">{{ __('ri2010.third_approver') }}</label>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-control-plaintext txt text-overfollow"
                                                    style="" data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ $approver_employee_nm_3 ?? '' }}">{{ $approver_employee_nm_3 ?? '' }}</label>
                                            </div>
                                        </div>
                                    </td>
                                @endif
                                @if (isset($approver_employee_nm_4) && $approver_employee_nm_4 != '')
                                    <td>
                                        <div class="form-inline finline">
                                            <div class="form-group">
                                                <label class="form-control-plaintext lbl text-overfollow ln-org"
                                                    data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ __('ri2010.fourth_approver') }}">{{ __('ri2010.fourth_approver') }}</label>
                                            </div>
                                            <div class="form-group">
                                                <label class="form-control-plaintext txt text-overfollow"
                                                    style="" data-container="body" data-toggle="tooltip"
                                                    data-original-title="{{ $approver_employee_nm_4 ?? '' }}">{{ $approver_employee_nm_4 ?? '' }}</label>
                                            </div>
                                        </div>
                                    </td>
                                @endif
                            </tr> -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
