@extends('mlayout')

@section('asset_header')
        <!-- START LIBRARY CSS -->
    {!!public_url('template/css/mulitiview/ms0030/ms0030.index.css')!!}
@stop
@section('asset_footer')
    {!!public_url('template/js/mulitiview/ms0030/ms0030.index.js')!!}
        <!-- START LIBRARY JS -->
    <script>
        var hide = '{{ __('messages.hide_attribute_info') }}';
        var display = '{{ __('messages.display_attribute_info') }}';
    </script>
@stop

@push('asset_button')
{!!
	Helper::dropdownRenderMulitireview(['saveButton','delButton', 'backButton'])
!!}
@endpush

@section('content')
    <!-- START CONTENT -->
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <div class="row">
            	<div class="col-md-12">
            		<div class="line-border-bottom">
						<label class="control-label">{{__('messages.extract_condition')}}</label>
					</div>
            	</div>
            </div> <!-- end .row -->
            <div class="row">
                <div class="col-md-4 col-lg-3 col-xl-2 div_parent_employee_cd">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.employee_no')}}
                        </label>
                        <div class="input-group-btn input-group div_employee_cd">
                            <span class="num-length">
                            <input type="text" class="form-control indexTab employee_cd refer_employee_cd Convert-Halfsize" id="employee_cd" tabindex="1" maxlength="10" value="" style="padding-right: 40px;" />
                            </span>
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent btn_employee_cd_popup_mulitireview" type="button" tabindex="-1">
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3 col-xl-2 div_parent_employee_nm">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.employee_name')}}</label>
                        <span class="num-length">
                        <input type="hidden" class="employee_cd_hidden">
                        <input type="text" class="form-control employee_name" placeholder="{{__('messages.label_006')}}"  tabindex="2" maxlength="101" id="employee_name" value="" />
                        </span>
                    </div>
                    <!--/.form-group -->
                </div>

                <div class="col-md-4 col-lg-3 col-xl-2">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.employee_classification')}}</label>
                        <select tabindex="4" name="employee_typ" id="employee_typ" class="form-control employee_typ">
                            <option value="0"></option>
                            @if(isset($data_init[4][0]))
                                @if($data_init[4][0]['employee_typ'] !='')
                                    @foreach($data_init[4] as $row)
                                        <option value="{{$row['employee_typ']}}">{{$row['employee_typ_nm']}}</option>
                                    @endforeach
                                @endif
                            @endif
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
                @if(isset($organization_group))
                @foreach($organization_group as $item)
                    @if($item['organization_step'] == 1)
                        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                            <div class="form-group">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="5" class="form-control  organization_cd1" >
                                    <option value="-1"></option>
                                    @if(!empty($combo_organization))
                                        @foreach($combo_organization as $temp)
                                        <option value="{{$temp['organization_cd_1'].'|'.$temp['organization_cd_2'].'|'.$temp['organization_cd_3'].'|'.$temp['organization_cd_4'].'|'.$temp['organization_cd_5']}}">{{$temp['organization_nm']}}</option>
                                        @endforeach
                                    @endif
                                </select>
                            </div>
                        </div>
                    @else
                        <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                            <div class="form-group">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$item['organization_group_nm']}}" style="margin-bottom: .5rem;">{{$item['organization_group_nm']}}</div>
                                <select id="organization_step{{$item['organization_step']}}" organization_typ="{{$item['organization_typ']}}" tabindex="5" class="form-control  organization_cd{{$item['organization_step']}}">
                                </select>
                            </div>
                        </div>
                    @endif
                @endforeach
                @endif
            </div>
            <div class="row" style="margin-top: 10px;">
                <div class="col-md-4 col-xl-2 col-xs-12 col-lg-3">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.authority')}}</label>
                        <select id="authority_cd" tabindex="6" class="form-control required">
                            <option value="-1" selected></option>
                            @if(isset($data_init[3][0]))
                                @if($data_init[3][0]['authority_cd'] !='')
                                    @foreach($data_init[3] as $row)
                                        <option value="{{$row['authority_cd']}}">{{$row['authority_nm']}}</option>
                                    @endforeach
                                @endif
                            @endif
                        </select>
                    </div>
                </div>
                <div class="col-md-8 col-lg-9 col-xl-10">
                    <label class="control-label">&nbsp;</label>
                    <div style="text-align: right">
                        <div id="bor_authority" class="md-checkbox-v2 inline-block bor_authority" style="margin-right: 10px;">
                            <label class="container" for="check_authority">{{__('messages.unconfigured_employees')}}
                                <input type="checkbox" name="ck1" id="check_authority" value="1" tabindex="7"/>
                                <span class="checkmark"></span>
                            </label>
                        </div>
                        <button id="btn-search" class="btn btn-multiview-menu focusin" tabindex="8">{{__('messages.extract_employee')}}</button>
                    </div>
                </div>
                <input type="hidden" class="anti_tab" name="">
            </div> <!-- end .row -->
            <div id="result">
                @include('Multiview::ms0030.search')
            </div>
        </div> <!-- end .card-body -->
    </div><!-- end .card -->
</div><!-- end .container-fluid -->
@stop

@section('asset_common')

@stop