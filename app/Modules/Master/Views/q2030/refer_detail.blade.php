@if(isset($result) && !empty($result))
    <div class="row">
        <div class="col-md-8">
            <div class="line-border-bottom">
                <label class="control-label text-primary bold">{{__('messages.detail')}}</label>
            </div>
        </div><!-- end .col-md-6 -->
    </div><!-- end .row -->
    <div class="row">
            <div class="col-12 col-sm-12 col-md-12 col-xs-12 col-lg-12">
            <nav class="pager-wrap row">
                @if(isset($paging))
                    {{Paging::show($paging)}}
                @endif
            </nav>
            </div>
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-striped"  id="table-3" style="table-layout: fixed;">
                    <thead>
                        <th class="text-center">{{__('messages.employee_no')}}</th>
                        <th class="text-center w10">{{__('messages.employee_name')}}</th>
                        <th class="text-center w15">{{__('messages.employee_classification')}}</th>
                        @foreach($M0022 as $dt)
                            <th class="text-center "  >
                                <div class="text-overfollow  employee-overfollow header-overfollow "  data-container="body" data-toggle="tooltip" data-original-title="{{$dt['organization_group_nm']}}">
                                {{$dt['organization_group_nm']}}
                            </div>
                            </th>
                        @endforeach
                        <th class="text-center w10">{{__('messages.job')}}</th>
                        <th class="text-center w10">{{__('messages.grade')}}</th>
                        <th class="text-center w10">{{__('messages.settled_rank')}}</th>
                    </thead>
                    <tbody>
                        @foreach($result as $value)
                            <tr class="tr-detail">
                                <td class="text-right employee_cd text-overflow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['employee_cd']}}"><a href="#" class="link_i2040" value="{{$value['employee_cd']}}">{{$value['employee_cd']}}</a></td>
                                <td class="text-left employee_nm text-overflow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['employee_nm']}}">{{$value['employee_nm']}}</td>
                                <td class="text-left employee_typ_nm text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['employee_typ_nm']}}">{{$value['employee_typ_nm']}}</td>
                                @foreach($M0022 as $dt)
                                    <td class="text-left {{'organization_nm_'.$dt['organization_typ']}}">{{$value['organization_nm_'.$dt['organization_typ']]}}</td>
                                @endforeach
                                <td class="text-left job_nm text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['job_nm']}}">{{$value['job_nm']}}</td>
                                <td class="text-left grade_nm text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['grade_nm']}}">{{$value['grade_nm']}}</td>
                                <td class="text-center rank_nm text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{$value['rank_nm']}}">{{$value['rank_nm']}}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div><!-- end .p-2 -->
    </div><!-- end .row -->
@endif