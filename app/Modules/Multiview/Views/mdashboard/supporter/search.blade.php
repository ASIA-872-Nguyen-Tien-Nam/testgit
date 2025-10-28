<div class="row">  
    <div class="col-md-12 {{isset($list2[0]['cre_datetime'])?'col-lg-8': 'col-lg-9'}}">
        <div class="table-responsive wmd-view table-data">
            <table class="table table-bordered table-hover ofixed-boder">
                <thead>
                    <tr>
                        <th colspan="5">{{__('messages.supported_list')}}</th>
                    </tr>
                    <tr>
                        <th style="width: 45%">{{ __('messages.employee_name') }} </th>
                        <th style="width: 10%">{{ __('messages.average_score')}}</th>
                        <th style="width: 15%">{{ __('messages.number_of_reviews')}}</th>
                        <th style="width: 20%">{{ __('messages.last_review_datetime')}}</th>
                        <th style="width: 10%">{{ __('messages.new')}} </th>
                    </tr>
                </thead>
                <tbody>
                    @if (isset($list1[0]['employee_cd']))
                    @foreach($list1 as $key=>$row)
                    <tr class="function list_function">
                        <input type="hidden" class="employee_cd" value="{{$row['employee_cd']??''}}">
                        <input type="hidden" class="detail_no" value="0">
                        <td><a href="#" class="btn-to-review-list"> {{$row['employee_nm']??''}}</a></td>
                        <td class="text-right">{{$row['sum_evaluation_point']??''}}</td>
                        <td class="text-right">{{$row['num_detail']??''}}</td>
                        <td class="text-center">{{$row['cre_datetime']??''}}</td>
                        <td>
                            <div class="ics-group text-center">
                                <a href="#" class="ics ics-edit btn-to-review-input" tabindex="-1">
                                    <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                </a>
                            </div>
                        </td>
                    </tr>
                    @endforeach
                    @else
                    <tr>
                        <td class="text-center" colspan="5">{{ $_text[21]['message'] }}</td>
                    </tr>
                    @endif
                </tbody>
            </table>
        </div>
    </div>
    <div class="col-lg-4 col-md-12" id="result2">
        @include('Multiview::mdashboard.infomation')
    </div>
</div>