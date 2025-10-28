@php
	function year_english($message) {
	if( \Session::get('website_language', config('app.locale')) == 'en')
		return  '';
    else
        return  $message;
	}
	@endphp
<div class="row">
    <div class="col-md-3"> 
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.fiscal_year')}}</label>
            <select id="fiscal_year" tabindex="1" class="form-control required fiscal_year">
                @if(isset($years) && !empty($years))
                @foreach($years as $key=>$val) 
                    <option value="{{$val}}" {{$val==$fiscal_year?'selected':''}}>{{$val}}{{year_english(__('messages.fiscal_year'))}}</option>
                @endforeach
                @endif
            </select>
        </div>
    </div>
    <div class="{{isset($list2[0]['cre_datetime'])?'col-md-5': 'col-md-6'}}">
        <div class="row">
            <div class="col-md-4 col-lg-3 col-xl-2 col-sm-3 col-12" style="max-width: 100px;">
                @if($confirm_button_is_show == 1)
                <div class="form-group text-danger" style="float: left;">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd div-1">
                        <div style="color: red">{{__('messages.confirm')}}</div>
                    </div>
                </div>
                @endif
            </div>

            @if($confirm_button_is_show == 0)
            <div class="col-md-5 col-lg-3 col-xl-4 col-sm-6 col-12 div-2" style="max-width: 150px;">
                <div class="form-group full-width">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <div class="form-group full-width">
                            <div class="full-width">
                                <a href="javascript:;" class="btn unlock-btn" id="btn-confirm" style="width:100%;" tabindex="2">
                                    <i class="fa fa-check"></i>
                                    {{__('messages.confirm')}}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div>
            </div>
            @endif

            @if($confirm_button_is_show == 1)
            <div class="col-md-5 col-lg-3 col-xl-4 col-sm-6 col-12 lock-item" style="max-width: 230px;">
                <div class="form-group full-width">
                    <label class="control-label">&nbsp;</label>
                    <div class="input-group-btn input-group div_employee_cd">
                        <div class="form-group full-width">
                            <div class="full-width">
                                <a href="javascript:;" id="btn-unconfirm" class="btn lock-btn" style="width:100%" tabindex="3">
                                    <i class="fa fa-unlock-alt"></i>
                                    {{ __('messages.unsettle')}}
                                </a>
                            </div><!-- end .full-width -->
                        </div>
                    </div>
                </div>
            </div>
            @endif
        </div>
    </div>
    <div class="{{isset($list2[0]['cre_datetime'])?'col-md-4': 'col-md-3'}} mdashboard-supporter col-6">
        <ul class="p-title-btn">
            <li id="refer_portal_evaluator" class="refer_screen">
                <a href="#" tabindex="5" class="btn btn-outline-primary btn-horizontal lg btn-to-supporter">
                    <div class="inner">
                        <i class="fa fa-male"></i>
                        <div>{{ __('messages.conduct_review') }}</div>
                    </div>
                </a>
            </li>
        </ul><!-- end .btn-group -->
    </div>
</div>

<div class="row">
    <div class="col-md-12 {{isset($list2[0]['cre_datetime'])?'col-lg-8': 'col-lg-9'}}">
        <div class="table-responsive wmd-view table-data">
            <table class="table table-bordered table-hover ofixed-boder">
                <thead>
                    <tr>
                        <th colspan="4">{{__('messages.list_of_employees')}}</th>
                    </tr>
                    <tr>
                        <th style="width: 45%">{{ __('messages.employee_name') }} </th>
                        <th style="width: 10%">{{ __('messages.average_score')}}</th>
                        <th style="width: 15%">{{ __('messages.number_of_reviews')}}</th>
                        <th style="width: 20%">{{ __('messages.last_review_datetime')}}</th>
                    </tr>
                </thead>
                <tbody>
                    @if (isset($list1[0]['employee_cd']))
                    @foreach($list1 as $key=>$row)
                    <tr class="function list_function">
                        <input type="hidden" class="employee_cd" value="{{$row['employee_cd']??''}}">
                        <td><a href="#" class="btn-to-review-list"> {{$row['employee_nm']??''}}</a></td>
                        <td class="text-right">{{$row['sum_evaluation_point']??''}}</td>
                        <td class="text-right">{{$row['num_detail']??''}}</td>
                        <td class="text-center">{{$row['cre_datetime']??''}}</td>
                    </tr>
                    @endforeach
                    @else
                    <tr>
                        <td class="text-center" colspan="4">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-lg-4 col-md-12">
        @include('Multiview::mdashboard.infomation')
    </div>
</div>