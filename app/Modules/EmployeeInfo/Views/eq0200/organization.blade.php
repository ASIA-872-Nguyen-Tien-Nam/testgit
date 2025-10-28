<div class="col-md-2" style="padding-bottom: 15px;position: absolute;right: 0px;z-index:1">
    <div class="full-width">
        <button id="btn_organization_charts_output" class="btn-menu-show btn btn-outline-primary" tabindex="1">
            {{ __('messages.output') }}
        </button>
    </div>
</div>
<div class="organization_charts">
    {{-- organization_firsts --}}
    @if (isset($organization_firsts) && !empty($organization_firsts))
        <div class="organization_group">
            <div class="row">
                <div class="col-md-12">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "0">
                            <span><i class="fa fa-minus"></i></span>
                        </a>
                    </div>
                    <div class="organization_member">
                        @foreach ($organization_firsts as $organization_first)
                            <div class="organization-card" employee_cd="{{ $organization_first['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $organization_first['position_nm'] }}">
                                    {{ $organization_first['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $organization_first['employee_cd'] }}:{{ $organization_first['employee_nm'] }}">
                                        {{ $organization_first['employee_cd'] }}:{{ $organization_first['employee_nm'] }}
                                        </div>
                                    </h6>
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    @endif
    {{-- organization_seconds --}}
    @if (isset($organization_seconds) && !empty($organization_seconds))
        @foreach ($organization_seconds as $organization_second)
        <div class="organization_group">
            {{-- organization_typ = 1 --}}
            @if ($organization_second['organization_typ'] == 1)
            <div class="row">
                <div class="col-md-11 offset-md-1">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "1" lv="{{$organization_second['organization_cd_1']}}">
                            <span><i class="fa fa-minus"></i></span>
                            {{ $organization_second['organization_nm'] }}
                        </a>
                    </div>
                    <div class="organization_member">
                        @php
                            $employee_info = json_decode(htmlspecialchars_decode($organization_second['employee_info']), true) ?? [];
                        @endphp
                        @foreach ($employee_info as $employee)
                            <div class="organization-card" employee_cd="{{ $employee['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['position_nm'] }}">
                                        {{ $employee['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        @if($employee['sub'] == 1 )
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @else
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @endif
                                    </h6>
                                </div>
                            </div>    
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
            {{-- organization_typ = 2 --}}
            @if ($organization_second['organization_typ'] == 2)
            <div class="row">
                <div class="col-md-8 offset-md-3">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "2" lv="{{$organization_second['organization_cd_2']}}-{{$organization_second['organization_cd_1']}}">
                            <span><i class="fa fa-minus"></i></span>
                            {{ $organization_second['organization_nm'] }}
                        </a>
                    </div>
                    <div class="organization_member">
                        @php
                            $employee_info = json_decode(htmlspecialchars_decode($organization_second['employee_info']), true) ?? [];
                        @endphp
                        @foreach ($employee_info as $employee)
                            <div class="organization-card" employee_cd="{{ $employee['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['position_nm'] }}">
                                    {{ $employee['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        @if($employee['sub'] == 1 )
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @else
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @endif
                                    </h6>
                                </div>
                            </div>    
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
            {{-- organization_typ = 3 --}}
            @if ($organization_second['organization_typ'] == 3)
            <div class="row">
                <div class="col-md-7 offset-md-5">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "3" lv="{{$organization_second['organization_cd_3']}}-{{$organization_second['organization_cd_2']}}-{{$organization_second['organization_cd_1']}}">
                            <span><i class="fa fa-minus"></i></span>
                            {{ $organization_second['organization_nm'] }}
                        </a>
                    </div>
                    <div class="organization_member">
                        @php
                            $employee_info = json_decode(htmlspecialchars_decode($organization_second['employee_info']), true) ?? [];
                        @endphp
                        @foreach ($employee_info as $employee)
                            <div class="organization-card" employee_cd="{{ $employee['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['position_nm'] }}">
                                    {{ $employee['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        @if($employee['sub'] == 1 )
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @else
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @endif
                                    </h6>
                                </div>
                            </div>    
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
            {{-- organization_typ = 4 --}}
            @if ($organization_second['organization_typ'] == 4)
            <div class="row">
                <div class="col-md-5 offset-md-7">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "4" lv="{{$organization_second['organization_cd_4']}}-{{$organization_second['organization_cd_3']}}-{{$organization_second['organization_cd_2']}}-{{$organization_second['organization_cd_1']}}">
                            <span><i class="fa fa-minus"></i></span>
                            {{ $organization_second['organization_nm'] }}
                        </a>
                    </div>
                    <div class="organization_member">
                        @php
                            $employee_info = json_decode(htmlspecialchars_decode($organization_second['employee_info']), true) ?? [];
                        @endphp
                        @foreach ($employee_info as $employee)
                            <div class="organization-card" employee_cd="{{ $employee['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['position_nm'] }}">
                                    {{ $employee['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        @if($employee['sub'] == 1 )
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @else
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @endif
                                    </h6>
                                </div>
                            </div>    
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
            {{-- organization_typ = 5 --}}
            @if ($organization_second['organization_typ'] == 5)
            <div class="row">
                <div class="col-md-3 offset-md-9">
                    <div class="organization-button">
                        <a class="btn btn-organization active" organization_typ = "5" lv="{{$organization_second['organization_cd_5']}}-{{$organization_second['organization_cd_4']}}-{{$organization_second['organization_cd_3']}}-{{$organization_second['organization_cd_2']}}-{{$organization_second['organization_cd_1']}}">
                            <span><i class="fa fa-minus"></i></span>
                            {{ $organization_second['organization_nm'] }}
                        </a>
                    </div>
                    <div class="organization_member">
                        @php
                            $employee_info = json_decode(htmlspecialchars_decode($organization_second['employee_info']), true) ?? [];
                        @endphp
                        @foreach ($employee_info as $employee)
                            <div class="organization-card" employee_cd="{{ $employee['employee_cd'] }}">
                                <h6 class="organization-card-header">
                                    <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['position_nm'] }}">
                                    {{ $employee['position_nm'] }}
                                    </div>
                                </h6>
                                <div class="organization-card-body">
                                    <h6 class="organization-card-title">
                                        @if($employee['sub'] == 1 )
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ __('messages.sub_detail') }} {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @else
                                        <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="{{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}">
                                        {{ $employee['employee_cd'] }}:{{ $employee['employee_nm'] }}
                                        </div>
                                        @endif
                                    </h6>
                                </div>
                            </div>    
                        @endforeach
                    </div>
                </div>
            </div>
            @endif
        </div>
        @endforeach
    @endif
</div>