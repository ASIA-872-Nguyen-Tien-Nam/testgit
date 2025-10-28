<!--table1 -->
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-12 col-lg-6 col-xl-3 block_left">
                <div class="row">
                    <div class="" style="padding-left: 10px;padding-right: 10px">
                        <div class="form-group">
                            <label class="control-label">{{ __('messages.sheet_cd') }}</label>
                            <input type="hidden" class="arrange_order" value="{{ $data_refer['arrange_order'] ?? '' }}">
                            <input type="hidden" name="" id="mode" value="A">
                            <input type="text" class="form-control text-left" id="sheet_cd" value="{{ $refer[0]['sheet_cd'] ?? '' }}" tabindex="-1" readonly style="max-width: 100px" />
                        </div>
                    </div>
                    <div style="padding-left: 10px;padding-right: 10px;width: calc(100% - 120px);">
                        
                        <div class="report-question">
                    <label for="" class="lb-required" lb-required="{{ __('messages.required') }}" style="white-space: nowrap">{{ __('rm0200.report_type') }}</label>
                        <select id="report_kind" class="form-control required" tabindex="1" autofocus>
                        <option value="-1"></option>
                            @if(isset($option_report_kind) && $option_report_kind != '')
                            @foreach($option_report_kind as $menu_lv_1)
                            @if(isset($refer[0]['report_kind']) && $refer[0]['report_kind']==$menu_lv_1['option_cd'])
                            <option selected value="{{$menu_lv_1['option_cd']}}">{{$menu_lv_1['option_nm'] }}</option>
                            @else
                            <option value="{{$menu_lv_1['option_cd']}}">{{$menu_lv_1['option_nm'] }}</option>
                            @endif
                            @endforeach
                            @endif
                        </select>
                </div><!-- end .p-title -->
                    </div>
                </div>

            </div>
            <div class="col-md-12 col-lg-9 col-xl-8 row block_right">
            <div class=" name_sheet">
                <div class="form-group  ">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{ __('rm0200.name') }}</label>
                    <span class="num-length" id=''>
                        <input type="text" class="form-control text-left required" maxlength="50" value="{{ $refer[0]['sheet_nm'] ?? '' }}" tabindex="1" id="sheet_nm" />
                    </span>
                </div>
            </div>
            <div class="date_time">
                <div class="">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}" style="white-space: nowrap;">{{ __('rm0200.start_date') }}</label>
                    <div class="form-group adaption_date">
                        <div class="input-group-btn input-group ">
                            <input type="text" id="adaption_date" class="form-control input-sm date right-radius required" placeholder="yyyy/mm/dd" tabindex="2" value="{{ $refer[0]['adaption_date'] ?? '' }}">
                            <div class="input-group-append-btn">
                                <button class="btn btn-transparent no-required" type="button" data-dtp="dtp_Cen0e" tabindex="-1" style="background: none !important"><i class="fa fa-calendar"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        <div class="row">
            @if(isset($refer[0]['adequacy_use_typ']) && $refer[0]['adequacy_use_typ'] == 1)
            <div value="1" class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.adequacy') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="adequacy_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @elseif(isset($refer[0]['adequacy_use_typ']) && $refer[0]['adequacy_use_typ'] == 0)
            <div value="0" hidden class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.adequacy') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="adequacy_use_typ" typ="0" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @else
            <div value="1" class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.adequacy') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="adequacy_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @endif
            @if(isset($refer[0]['business_use_typ']) && $refer[0]['business_use_typ'] == 1)
            <div class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.busyness') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="busyness_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @elseif(isset($refer[0]['business_use_typ']) && $refer[0]['business_use_typ'] == 0)
            <div hidden class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.busyness') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="busyness_use_typ" typ="0" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @else
            <div class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.busyness') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="busyness_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @endif
            @if(isset($refer[0]['other_use_typ']) && $refer[0]['other_use_typ'] == 1)
            <div class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.others') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="other_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @elseif(isset($refer[0]['other_use_typ']) && $refer[0]['other_use_typ'] == 0)
            <div hidden class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.others') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="other_use_typ" typ="0" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @else
            <div class="col-md-2 picture-img" style="max-width: 122px">
                <label class="control-label">&nbsp;</label>
                <div class="table-responsive ">
                    <dl class="dropdown" style="margin-bottom:0rem">
                        <table class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" id="tbl1" style="margin-bottom:0.4rem !important">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="d-flex justify-content-between">
                                            <span class="ics-textbox" style="width:100%">
                                                <span class="num-length">
                                                    <input type="text" style="min-width:20px" class="form-control form-control-sm" value="{{ __('rm0200.others') }}" id="comment_title" maxlength="50" readonly="readonly" tabindex="-1">
                                                </span>
                                            </span>
                                            <div class="ics-group">
                                                <a id="other_use_typ" typ="1" href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="padding: 0px">
                                        <dt>
                                            <a href="#" tabindex="-1">
                                                <span class="weather-select">
                                                    <img src="/uploads/ver1.7/odashboard/weather_1.png" width="100%" />
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
            @endif
            <div class="col-md-4 col-xl-2 col-lg-3 checkbox-text">
                <div class="form-group " style="max-width: 132px">
                    <label class="control-label">&nbsp;</label>
                    <span class="num-length" style="display: block;">
                        <button class="btn btn-primary button-1on1  show-all" type="button" data-dtp="dtp_JGtLk" tabindex="-1"><i class="fa fa-eye"></i>{{ __('messages.redisplay') }}</button>
                    </span>
                </div>
                <!--/.form-group -->
            </div>
        </div>
    </div>
</div>
<!--table2 -->
<div class="card">
    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-12">
                <div class="table-responsive posire">
                    <table id="table_question" class="table one-table table-bordered table-hover table-ics marginbottom15 tbl1" data-resizable-columns-id="demo-table-v2">
                        <thead>
                            <tr>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox w-50" style="min-width: 80%;">
                                            <span class="num-length">
                                                <input type="text" class="form-control form-control-sm input-header" value="{{ __('rm0200.question') }}" readonly="" id="question_nm" tabindex="-1" />
                                            </span>
                                        </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox w-50" style="min-width: 80%">
                                            <span class="num-length">
                                                <input type="text" class="form-control form-control-sm input-header" value="{{ __('messages.answer') }}" readonly="" id="answer_nm" tabindex="-1" />
                                            </span>
                                        </span>
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
                            @if(isset($question[0]))
                            @foreach($question as $question)
                            <tr class="list_questions">
                                <td class="text-center td-1">
                                    <input type="hidden" class="interview_gyocd" value="1">
                                    <input type="hidden" class="arrange_order" value="">
                                    <span class="num-length ">
                                        <div class="input-group-btn input-group">
                                            <span class="num-length text-left">
                                            <input type="text" hidden class="question_id" value="{{$question['question_id']}}">
                                                <input type="text" class="required form-control question err_question_cd" maxlength="200" tabindex="8" value="{{$question['question']}}">
                                                <input type="hidden" class="question_no" value="{{$question['question_no']}}" maxlength="200">
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
                                                <input type="text" hidden class="question_id" value="1">
                                                <input type="text" class="required form-control question" readonly maxlength="200" tabindex="8" value="">
                                                <input type="text" hidden class="question_no" maxlength="200">
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
                <div class="table-responsive posire approver__table">
                    @if(isset($refer[0]['comment_use_typ']) && $refer[0]['comment_use_typ'] == 1)
                    <table id="" class="table one-table table-bordered table-striped tbme table-ics tabl2">
                        <tbody>
                            <tr>
                                <td class="togcol text-center">
                                    <div class="d-flex">
                                        <span class="" style="width:100%;font-weight: bold;color: #181818">
                                            <div style="max-width: unset" class="text-overflow first_approver">
                                                {{ __('rm0200.1st_aprrover_comment') }}
                                            </div>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="comment_use_typ" typ="1" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </td>
                                <td class="right_col">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    @elseif(isset($refer[0]['comment_use_typ']) && $refer[0]['comment_use_typ'] == 0)
                    <table hidden id="" class="table_show_hide table one-table table-bordered table-striped tbme table-ics tabl2">
                        <tbody>
                            <tr>
                                <td class="togcol text-center">
                                    <div class="d-flex">
                                        <span class="" style="width:100%;font-weight: bold;color: #181818">
                                            <div style="max-width: unset" class="text-overflow first_approver">
                                                {{ __('rm0200.1st_aprrover_comment') }}
                                            </div>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="comment_use_typ" typ="0" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </td>
                                <td class="right_col">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    @else
                    <table id="" class="table one-table table-bordered table-striped tbme table-ics tabl2">
                        <tbody>
                            <tr>
                                <td class="togcol text-center">
                                    <div class="d-flex">
                                        <span class="" style="width:100%;font-weight: bold;color: #181818">
                                            <div style="max-width: unset" class="text-overflow first_approver">
                                                {{ __('rm0200.1st_aprrover_comment') }}
                                            </div>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="comment_use_typ" typ="1" class="ics ics-eye-table" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </td>
                                <td class="right_col">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    @endif
                </div>
            </div>
        </div><!-- end .row -->
        <div class="row mb-3">
            <div class="col-md-12">
            
            </div>
        </div>
    </div>
   
</div>
<div class="row block_save_button_bottom justify-content-md-center">
    {!! Helper::buttonRenderWeeklyReport(['saveButton']) !!}
</div>