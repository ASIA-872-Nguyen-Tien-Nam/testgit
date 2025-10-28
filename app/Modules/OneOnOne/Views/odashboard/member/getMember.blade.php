@extends('oneonone/layout')

@push('header')
{!!public_url('template/css/oneonone/dashboard/member.css')!!}
@endpush

@section('asset_footer')
{!!public_url('template/js/oneonone/dashboard/member.js')!!}
@stop

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="card pe-w">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-7" id="member_div">
                            <div class="row">
                                <div class="col-md-12">
                                    <select id="fiscal_year_1on1_member" autocomplete="off" class="form-control" tabindex="1">
                                        <option value="-1"></option>
                                        @if(!empty($F2001))
                                            @foreach($F2001 as $row)
                                                <option value="{{$row['fiscal_year']}}" {{$row['fiscal_year'] == $fiscal_year_1on1_member?'selected':''}}>{{$login_employee_nm}} {{ __('messages.list_of_1on1_in', ['year' => $row['fiscal_year']]) }}</option>
                                            @endforeach
                                        @endif
                                    </select>
                                </div>
                            </div>
                            <!-- Target -->
                            <div class="row">
                                <div class="col-md-12 mt-3" id="left_target_member_div">
                                @include('OneOnOne::odashboard.member.referTargetMember')
                                </div>
                            </div>
                            <!-- 1on1履歴 -->
                            <div class="row">
                                <div class="col-md-12 mt-3 mb-3" id="left_times_member_div">
                                    @include('OneOnOne::odashboard.member.referLeftTimesForMember')
                                </div>
                            </div>
                        </div><!-- end .col-md-7 -->
                        <!-- Right member content -->
                        <div class="col-md-5 " id="right_member_div">
                        @include('OneOnOne::odashboard.member.referRightForMember')
                        </div>
                    </div><!-- end .row -->
                </div><!-- end .card-body -->
            </div><!-- end .card -->
        </div><!-- end .col-md-6 -->
    </div><!-- end .row -->
</div>
@stop