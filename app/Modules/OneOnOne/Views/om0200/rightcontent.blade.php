
<!--table1 -->
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-12 col-lg-6 col-xl-8">
                <div class="row">
                    <div class="" style="padding-left: 10px;padding-right: 10px">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.sheet_cd') }}</label>
                            <input type="hidden" class="arrange_order" value="{{$data_refer['arrange_order']??''}}">
                            <input type="hidden" name="" id="mode" value="A">
                            <input type="text" class="form-control text-left" id="interview_cd" value="{{$data_refer['interview_cd']??''}}" tabindex="-1" readonly  style="max-width: 100px"/>
                        </div>
                    </div>
                    <div  style="padding-left: 10px;padding-right: 10px;width: calc(100% - 120px);">
                        <div class="form-group">
                            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('messages.sheet_name') }}</label>
                            <span class="num-length" id='goal_number_span'>
                                <input type="text" class="form-control text-left required" maxlength="50" value="{{$data_refer['interview_nm']??''}}" tabindex="1" id="interview_nm"/>
                            </span>
                        </div>
                    </div>
                </div>

            </div>
            <div class="col-md-5 col-lg-4 col-xl-2">
                <div class="" >
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}" style="white-space: nowrap;">{{ __('messages.adaptation_start_date') }}</label>
                    <div class="form-group adaption_date" style="min-width: 240px">
                        <div class="input-group-btn input-group ">
                        <input type="text" id="adaption_date" class="form-control input-sm date right-radius required" placeholder="yyyy/mm/dd"
                                tabindex="2" value="{{$data_refer['adaption_date']??''}}" >
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_Cen0e" tabindex="-1" style="background: none !important"><i class="fa fa-calendar"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2 mb-3 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1">
                            <thead>
                            <tr>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <span class="num-length">
                                                <input type="text"
                                                    class="form-control form-control-sm input-header text-center" value="{{$data_remark['name']??''}}" id="m2120_name"
                                                    readonly="" tabindex="-1" />
                                            </span>
                                        </span>
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px" >
                                        <dt>
                                            <a href="#"  tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/{{$combo_remark[1]['remark1']??''}}" width="100%"/>
                                                </span>
                                            </a>
                                        </dt>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </dl>
                </div>
            </div>
            <div class="col-md-4 col-xl-2 col-lg-3 checkbox-text">
                <div class="form-group " style="max-width: 132px">
                    <label class="control-label">&nbsp;</label>
                    <span class="num-length" style="display: block;">
                        <button class="btn btn-primary button-1on1  show-all" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-eye"> {{ __('messages.redisplay') }}</i></button>
                    </span>
                </div><!--/.form-group -->
            </div>
        </div>
        <div class="row" style="margin-top: 10px">
            <div class="col-md-12">
                <div class="table-responsive   w-table1">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1">
                        <thead>
                        <tr>
                            @php
                                $class_target_hide1 = '';
                                $class_target_hide2 = '';
                                $class_target_hide3 = '';
                                //
                                $class_target1_val = 'display_typ';
                                $class_target2_val = 'display_typ';
                                $class_target3_val = 'display_typ';
                                //
                                $target1_val = 1;
                                $target2_val = 1;
                                $target3_val = 1;
                                // temporary hidden  and can show when click show all
                                if(($data_refer['target1_use_typ']??'1') == '0'){
                                    $class_target_hide1 = 'ics-hide';
                                    $target1_val = 0;
                                }
                                if(($data_refer['target2_use_typ']??'1') == '0'){
                                    $class_target_hide2 = 'ics-hide';
                                    $target2_val = 0;
                                }
                                if(($data_refer['target3_use_typ']??'1') == '0'){
                                    $class_target_hide3 = 'ics-hide';
                                    $target3_val = 0;
                                }

                                // hidden
                                if(($year_target_service['target1_use_typ']??'0') == '0'){
                                    $class_target_hide1 = 'hidden-target';
                                    $target1_val = 0;
                                    $class_target1_val='';
                                }
                                if(($year_target_service['target2_use_typ']??'0') == '0'){
                                    $class_target_hide2 = 'hidden-target';
                                    $target2_val = 0;
                                    $class_target2_val='';
                                }
                                if(($year_target_service['target3_use_typ']??'0') == '0'){
                                    $class_target_hide3 = 'hidden-target';
                                    $target3_val = 0;
                                    $class_target3_val='';
                                }
                            @endphp
                            <th class="{{$class_target_hide1}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox" style="width:100%">
                                        <input class="{{$class_target1_val}}" type="hidden" id="target1_use_typ" value="{{$target1_val}}"/>
                                        <span class="num-length">
                                            <input type="text"
                                                   class="form-control form-control-sm input-header" value="{{$year_target_service['target1_nm']??''}}"
                                                   id="target1_nm" maxlength="50"
                                                   readonly="" tabindex="-1" />
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$class_target_hide2}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox" style="width:100%">
                                        <input class="{{$class_target2_val}}" type="hidden" id="target2_use_typ" value="{{$target2_val}}"/>
                                        <span class="num-length">
                                            <input type="text"
                                                   class="form-control form-control-sm input-header" value="{{$year_target_service['target2_nm']??''}}"
                                                   id="target2_nm" maxlength="50"
                                                   readonly="" tabindex="-1"/>
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th class="{{$class_target_hide3}}">
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox" style="width:100%">
                                        <input class="{{$class_target3_val}}" type="hidden" id="target3_use_typ" value="{{$target3_val}}"/>
                                        <span class="num-length">
                                            <input type="text"
                                                   class="form-control form-control-sm input-header" value="{{$year_target_service['target3_nm']??''}}"
                                                   id="target3_nm" maxlength="50"
                                                   readonly="" tabindex="-1"/>
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center {{$class_target_hide1}}">
                                <span class="num-length">
                                    <input type="text" readonly class="form-control" tabindex="-1">
                                </span>
                            </td>
                            <td class="text-center {{$class_target_hide2}}">
                                <span class="num-length">
                                    <input type="text"  readonly class="form-control" tabindex="-1">
                                </span>
                            </td>
                            <td class="text-center {{$class_target_hide3}}" >
                                <span class="num-length ">
                                    <input type="text" readonly class="form-control" tabindex="-1">
                                </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        @if (($year_target_service['comment_use_typ']??'0') =='1')
            <div class="table-responsive wmd-view table-fixed-header sticky-headers sticky-ltr-cells mt-10 wrapper mb-3">
                <table class="table table-bordered table-hover table-ics marginbottom15 " id="myTable" >
                    <thead>
                        <tr>
                            <th class="w-120px text-left {{($data_refer['comment_use_typ']??'1') =='0'?'ics-hide':''}}" >
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox" style="min-width: 150px;width:100%">
                                        <input class="display_typ" type="hidden" id="comment_use_typ" value="{{$data_refer['comment_use_typ']??'1'}}">
                                        <span class="num-length">
                                            <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{$year_target_service['comment_nm']??''}}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                            <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="tr_employee">
                            <td class="w-120px {{($data_refer['comment_use_typ']??'1') =='0'?'ics-hide':''}}">
                                <textarea class="form-control" cols="30" rows="4" maxlength="400" id="comment" tabindex="11" disabled style="height: 38px;"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        @endif
    </div>
</div>
<!--table2 -->
<div class="card">
    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-12">
                <div class="table-responsive posire">
                    <table id="table_question" class="table one-table table-bordered table-striped tbme table-ics tabl2"
                            data-resizable-columns-id="demo-table-v2">
                        <thead>
                        <tr>
                            <th>
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox w-50" style="min-width: 80%;">
                                        <span class="num-length">
                                            <input type="text"
                                                    class="form-control form-control-sm input-header" value="{{$data_refer['question_nm']??__('messages.pawn')}}"
                                                    readonly="" id="question_nm" maxlength="50" tabindex="-1"/>
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil" ></i></span>
                                        </a>
                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th>
                                <div class="d-flex justify-content-between">
                                    <span class="ics-textbox w-50" style="min-width: 80%">
                                        <span class="num-length">
                                            <input type="text"
                                                    class="form-control form-control-sm input-header" value="{{$data_refer['answer_nm']?? __('messages.answer') }}"
                                                    readonly="" id="answer_nm" maxlength="50" tabindex="-1"/>
                                        </span>
                                    </span>
                                    <div class="ics-group">
                                        <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                            <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                        </a>

                                    </div><!-- end .ics-group -->
                                </div>
                            </th>
                            <th>
                                <div class="text-center">
                                    <span>
                                        <button class="btn btn-rm blue btn-sm" id="btn-add-detail" tabindex="-1">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </span>
                                </div>
                            </th>
                        </tr>
                        </thead>

                        <tbody>
                            @if (isset($question_table[0]) && !empty($question_table[0]))
                                @foreach($question_table as $row)
                                    <tr class="list_questions">
                                        <td class="text-center td-1">
                                            <input type="hidden" class="interview_gyocd" value="{{$row['interview_gyocd']}}">
                                            <input type="hidden" class="arrange_order" value="{{$row['arrange_order']}}">
                                            <span class="num-length ">
                                                <div class="input-group-btn input-group">
                                                    <span class="num-length text-left">
                                                        <input type="text" class="required form-control question" maxlength="200" tabindex="8" value="{{$row['question']}}">
                                                    </span>
                                                    <div class="input-group-append-btn">
                                                        <button class="btn btn-transparent search_cate" type="button" tabindex="-1">
                                                            <i class="fa fa-search"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </span>
                                        </td>
                                        <td class="text-center td-2">
                                        </td>
                                        <td class="text-center td-3">
                                            <button class="btn btn-rm btn-sm btn-remove-row">
                                                <i class="fa fa-remove"></i>
                                            </button>
                                        </td>

                                    </tr>
                                @endforeach
                            @else
                                <tr class="list_questions">
                                    <td class="text-center td-1">
                                        <input type="hidden" class="interview_gyocd" value="1">
                                        <input type="hidden" class="arrange_order" value="">
                                        <span class="num-length ">
                                            <div class="input-group-btn input-group">
                                                <span class="num-length text-left">
                                                    <input type="text" class="required form-control question" maxlength="200" tabindex="8" value="">
                                                </span>
                                                <div class="input-group-append-btn">
                                                    <button class="btn btn-transparent search_cate" type="button" tabindex="-1">
                                                        <i class="fa fa-search"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </span>
                                    </td>
                                    <td class="text-center td-2">
                                    </td>
                                    <td class="text-center td-3">
                                        <button class="btn btn-rm btn-sm btn-remove-row">
                                            <i class="fa fa-remove"></i>
                                        </button>
                                    </td>

                                </tr>
                            @endif

                        </tbody>
                    </table>
                </div>
            </div>
        </div><!-- end .row -->

        <!--table6 -->
        <div class="row {{($data_refer['free_question_use_typ']??'1') == 0 ?'hidden':''}} mb-3">
            <div class="col-md-12">
                <div class="table-responsive   ">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr class="th-edited">
                            <th th_index="0" class="w-50" >
                                <span class="ics-textbox">
                                    <input class="display_typ" type="hidden" id="free_question_use_typ" value="{{$data_refer['free_question_use_typ']??'1'}}"/>
                                    <span class="num-length">
                                        <input type="text" maxlength="50" class="form-control form-control-sm input-header" id="free_question_nm" value="{{$data_refer['free_question_nm']??__('messages.free_entry_field')}}"
                                            readonly="" tabindex="-1">
                                    </span>
                                </span>
                            </th>
                            <th>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit ics-table-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center" style="width:93%">
                                <span class="num-length">
                                    <input type="text" style="" class="form-control form-control-sm input-header" value=""
                                            readonly="" tabindex="-1">
                                </span>
                            </td>
                            <td class="togcol text-center" width=50px>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- end .row -->
    </div>
</div>
<div class="card">
    <div class="card-body">
<!--table3 -->
        <div class="row {{($data_refer['member_comment_typ']??'1') == 0 ?'hidden':''}} mb-3">
            <div class="col-md-12">
                <div class="table-responsive   ">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr class="th-edited">
                            <th th_index="0" class="w-50" >
                                <span class="ics-textbox">
                                    <input class="display_typ" type="hidden" id="member_comment_typ" value="{{$data_refer['member_comment_typ']??'1'}}"/>
                                    <span class="num-length">
                                        <input type="text" maxlength="50" class="form-control form-control-sm input-header" id="member_comment_nm" value="{{$data_refer['member_comment_nm']??__('messages.member_comment')}}"
                                                readonly="" tabindex="-1">
                                    </span>
                                </span>
                            </th>
                            <th>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit ics-table-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>

                                </div><!-- end .ics-group -->
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center" style="width:93%">
                                    <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
                            </td>
                            <td class="togcol text-center" width=50px>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!-- end .row -->
        <!--table4 -->
        <div class="row {{($data_refer['coach_comment1_typ']??'1') == 0 ?'hidden':''}} mb-3">
            <div class="col-md-12">
                <div class="table-responsive   ">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr class="th-edited">
                            <th th_index="0" class="w-50" >
                                <span class="ics-textbox">
                                    <input class="display_typ" type="hidden" id="coach_comment1_typ" value="{{$data_refer['coach_comment1_typ']??'1'}}"/>
                                    <span class="num-length">
                                        <input type="text" maxlength="50" class="form-control form-control-sm input-header" id="coach_comment1_nm" value="{{$data_refer['coach_comment1_nm']??__('messages.coach_comment')}}"
                                            readonly="" tabindex="-1">
                                    </span>
                                </span>
                            </th>
                            <th>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit ics-table-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center" style="width:93%">
                                    <textarea readonly class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
                            </td>
                            <td class="togcol text-center" width=50px>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div><!-- end .row -->
        <!--table5 -->
        <div class="row {{($data_refer['next_action_typ']??'1') == 0 ?'hidden':''}} mb-3">
            <div class="col-md-12">
                <div class="table-responsive   ">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr class="th-edited">
                            <th th_index="0" class="w-50" >
                                <span class="ics-textbox">
                                    <input class="display_typ" type="hidden" id="next_action_typ" value="{{$data_refer['next_action_typ']??'1'}}"/>
                                    <span class="num-length">
                                        <input type="text" maxlength="50" class="form-control form-control-sm input-header" id="next_action_nm" value="{{$data_refer['next_action_nm']??__('messages.label_013')}}"
                                            readonly="" tabindex="-1">
                                    </span>
                                </span>
                            </th>
                            <th>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit ics-table-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>

                                </div><!-- end .ics-group -->
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center" style="width:93%">
                                    <textarea readonly class="form-control" cols="30" rows="4" maxlength="400"  tabindex="-1"></textarea>
                            </td>
                            <td class="togcol text-center" width=50px>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!-- end .row -->

        <!--table6 -->
        <div class="row {{($data_refer['coach_comment2_typ']??'1') == 0 ?'hidden':''}}">
            <div class="col-md-12">
                <div class="table-responsive   ">
                    <table class="table one-table table-bordered table-hover table-ics marginbottom15">
                        <thead>
                        <tr class="th-edited">
                            <th th_index="0" class="w-50" >
                                <span class="ics-textbox" >
                                    <input class="display_typ" type="hidden" id="coach_comment2_typ" value="{{$data_refer['coach_comment2_typ']??'1'}}"/>
                                    <span class="num-length">
                                        <input type="text" maxlength="50" class="form-control form-control-sm input-header" id="coach_comment2_nm" value="{{$data_refer['coach_comment2_nm']??__('messages.label_012')}}"
                                            readonly="" tabindex="-1">
                                    </span>
                                </span>
                            </th>
                            <th>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-edit ics-table-edit" tabindex="-1">
                                        <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                    </a>

                                </div><!-- end .ics-group -->
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="text-center" style="width:93%">
                                    <textarea readonly class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="-1"></textarea>
                            </td>
                            <td class="togcol text-center" width=50px>
                                <div class="ics-group">
                                    <a href="javascript:;" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                        <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                    </a>
                                </div><!-- end .ics-group -->
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!-- end .row -->
    </div>
    <div class="row justify-content-md-center">
        {!!
            Helper::buttonRender1on1(['saveButton'])
        !!}
    </div>
</div>


<table id="table-target" class="hidden">
    <tbody>
        <tr class="new_tr">
            <td class="text-center td-1">
                <input type="hidden" class="interview_gyocd" value="">
                <input type="hidden" class="arrange_order" value="">
                <span class="num-length ">
                    <div class="input-group-btn input-group">
                        <span class="num-length text-left">
                            <input type="text" class="form-control required question" maxlength="200" value="">
                        </span>
                        <div class="input-group-append-btn">
                            <button class="btn btn-transparent search_cate" type="button" tabindex="-1">
                                <i class="fa fa-search"></i>
                            </button>
                        </div>
                    </div>
                </span>
            </td>
            <td class="text-center td-2">
            </td>
            <td class="text-center td-3">
                <button class="btn btn-rm btn-sm btn-remove-row">
                    <i class="fa fa-remove"></i>
                </button>
            </td>

        </tr>

    </tbody>
</table>