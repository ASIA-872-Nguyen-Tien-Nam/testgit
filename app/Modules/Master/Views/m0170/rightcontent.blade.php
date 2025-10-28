        <div class="card-body p-0">
            <div class="row">
                <div class="col-md-6 col-lg-3 col-xl-3 col-xxl-3">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.name')}}</label>
								<span class="num-length">
                                    <input type="hidden" class="form-control required" tabindex="1" maxlength="10" id="r_sheet_cd"/>
                                    <input type="hidden" class="form-control required" tabindex="1" maxlength="10" id="im_sheet_cd"/>
									<input type="text" class="form-control required" tabindex="1" maxlength="50" id="r_sheet_nm" value="" />
								</span>
                    </div><!--/.form-group -->
                </div>

                <div class="col-md-6 col-lg-4 col-xl-3 col-xxl-3">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.abbreviation')}}</label>
								<span class="num-length">
									<input type="text" id="sheet_ab_nm" class="form-control" tabindex="2" maxlength="10" value="" />
								</span>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3 col-xl-3">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.category')}}</label>
                        <select name="" id="category" tabindex="3" class="form-control required">
                            <option value="-1"></option>
                            @if (isset($combo_category[0]) )
                                @foreach($combo_category as $row)
                                    <option value="{{$row['number_cd']}}">{{$row['name']}}</option>
                                @endforeach
                            @endif
                        </select>

                    </div><!--/.form-group -->
                </div>
                <div class="col-md-3 col-lg-1 col-xl-1 col-xxl-1 ln-min">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.sort_order')}}</label>
                        <span class="num-length">
                            <input tabindex="7" type="text" id="arrange_order" class="form-control only-number" placeholder="" maxlength="6" value="">
                        </span>
                    </div><!--/.form-group -->
                </div>
                <div class="col-md-3 col-lg-1 col-xl-1 col-xxl-1">
                    <div class="copy__area">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-4">
                    <div class="form-group">
                        <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.eval_standard')}}&nbsp;
                            {{--<i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="評価点マスタで登録した評価点種類名称が表示される。"></i>--}}
                        </label>
                        <select name="" id="point_kinds" tabindex="4" class="form-control required" tabindex="4">
                            <option value="-1"></option>
                            @if (isset($combo_point_kinds[0]) )
                                @foreach($combo_point_kinds as $row)
                                    <option value="{{$row['point_kinds']}}">{{$row['point_kinds_nm']}}</option>
                                @endforeach
                            @endif
                        </select>
                    </div><!--/.form-group -->
                </div>
                <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3 ln-lg-3">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.calculate_method')}}&nbsp;
                        </label>
                        <div class="radio" id='calculation_typ_change'>
                            @foreach($lib2 as $key=>$item)
                                <div class="md-radio-v2 inline-block">
                                    <input name="point_calculation_typ1" type="radio" id="YY{{$key}}" value="{{$item['number_cd']}}" {{$item['number_cd'] =='1'?"checked":""}} maxlength="3" tabindex="5">
                                    <label for="YY{{$key}}">{{$item['name']}}</label>
                                </div>
                            @endforeach
                        </div>
                    </div><!--/.form-group -->
                </div>
                <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.compulate_method')}}&nbsp;
                            {{-- <i class="fa fa-question-circle text-primary" data-toggle="tooltip" data-original-title="マスタでの登録はせず、固定の値を表示する。"></i>--}}
                        </label>
                        <div class="radio rad1" id='calculation_typ_change2'>
                            @if (isset($rad_point_calculation_typ[0]) )
                                @foreach($rad_point_calculation_typ as $row)
                                    <div class="md-radio-v2 inline-block"  >
                                        <input name="point_calculation_typ2" type="radio" id="{{'ZZ'.$row['number_cd']}}" {{$row['id'] =='1'?"checked":""}} value="{{$row['number_cd']}}" tabindex="5" {{$row['id'] =='2'?'disabled':''}}>
                                        <label for="{{'ZZ'.$row['number_cd']}}">{{$row['name']}}</label>
                                    </div>
                                @endforeach
                            @endif

                        </div>
                    </div><!--/.form-group -->
                </div>
                <div class="col-md-6 col-lg-6 col-xl-3 col-xxl-3">
                    <div class="form-group">
                        <label class="control-label">{{__('messages.period_setting')}}&nbsp;
                        </label>
                        <div class="radio rad2">
                            @if (isset($rad_evaluation_period[0]) )
                                @foreach($rad_evaluation_period as $row)
                                    <div class="md-radio-v2 inline-block">
                                        <input name="evaluation_period" type="radio" id="{{'XX'.$row['detail_no']}}" {{$row['id'] =='1'?"checked":""}} value="{{$row['detail_no']}}"  tabindex="6">
                                        <label class="text-overfollow lh-lable" data-container="body" data-toggle="tooltip"  data-original-title="{{$row['period_nm']}}" for="{{'XX'.$row['detail_no']}}" >{{$row['period_nm']}}</label>
                                    </div>
                                @endforeach
                            @endif
                        </div>
                    </div><!--/.form-group -->
                </div>

            </div>

            <div class="line-border-bottom">
                <label class="control-label">{{__('messages.rated_s_authority_setting')}}</label>
            </div>
            <div class="row">
                <div class="col-lg-4 col-xl-4 ">
                    <div class="form-group">
                        <div class="checkbox">
                            <div class="md-checkbox-v2 inline-block">
                                <input name="evaluation_self_typ" id="evaluation_self_typ" type="checkbox" value="" tabindex="8"
                                value="{{$evaluation_self_assessment_typ}}" {{$evaluation_self_assessment_typ==1?'checked':''}}>
                                <label for="evaluation_self_typ">{{__('messages.implement_self_eval')}}</label>
                            </div>
                        </div><!-- end .checkbox -->
                    </div>
                </div>
                <div class=" col-lg-4 col-xl-4">
                    <div class="form-group">
                        <div class="checkbox">
                            <div class="md-checkbox-v2 inline-block">
                                <input name="details_feedback_typ" id="details_feedback_typ" type="checkbox" value="" tabindex="8">
                                <label for="details_feedback_typ">{{__('messages.can_view_eval_detail')}}</label>
                            </div>
                        </div><!-- end .checkbox -->
                    </div>
                </div>
                <div class="col-lg-4 col-xl-4">
                    <div class="form-group">
                        <div class="checkbox">
                            <div class="md-checkbox-v2 inline-block">
                                <input name="comments_feedback_typ" id="comments_feedback_typ" type="checkbox" value="" tabindex="9">
                                <label for="comments_feedback_typ">{{__('messages.can_view_eval_comment')}}</label>
                            </div>
                        </div><!-- end .checkbox -->
                    </div>
                </div>
            </div>
            <div class="line-border-bottom">
                <label class="control-label">{{__('messages.upload_pa_manual')}}</label>
            </div>

            {{-- begin upload file--}}
            <div class="col-md-5 w-item-search line-upload-bottom">
                <div class="form-rows upload m-div">
                   <label for="realupload" class="face-file-btn">
                       <i class="fa fa-folder-open fa1" ></i>
                    </label>
                    <div class="fakeupload">
                        <input type="text" id="file_name" name="fakeupload" class="form-control m012-textbox-80" readonly="readonly" tabindex="-1">
                        <input type="hidden" id="upload_file_nm" value="" tabindex="-1"/>
                        <input type="hidden" id="file_address" value="" tabindex="-1"/>
                        <button id="btn-download" class="btn-download" filename="" oldname="" tabindex="-1">{{--<img class="icon-attach-file" src="/template/image/icon/icon-attach-file.png">--}}
                            <i class="fa fa-download fa2"></i>
                        </button>
                        <button id="btn-delete-file" class="btn-clearfile" tabindex="-1">
                            <i class="fa fa-trash fa3"></i>
                        </button>
                        <input type="file" name="upload" class="realupload" tabindex="-1">
                        <input type="hidden" class="type-file" value="csv" tabindex="-1">
                        <input class="new-file-name" type="hidden" value="" tabindex="-1">
                    </div>
                </div>
            </div>

            <input type="file" class="inputfile" id="upload_file" maxlength="100" accept="application/pdf" tabindex="-1">
            {{-- end upload file--}}
            <div class="line-border-bottom d-flex justify-content-between">
                <label class="control-label">{{__('messages.sheet_settings')}}</label>
                <button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex="10"><i class="fa fa-eye"></i> {{__('messages.redisplay')}}</button>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="table-responsive w-table1 sticky-table sticky-headers sticky-ltr-cells">
                        <table class="table table-bordered table-hover table-ics marginbottom15" id="tbl1">
                            <thead>
                            <tr>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_1" value="1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '①'])}}"
                                                       id="generic_comment_title_1" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil" ></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_2" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '②'])}}"
                                                       id="generic_comment_title_2" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_8" value="1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.comment_company',['num' => '③'])}}"
                                                       id="generic_comment_title_8" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_3" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:120px"
                                                       class="form-control form-control-sm" value="{{__('messages.gp_evaluator_comment',['num' => '①'])}}"
                                                       id="generic_comment_title_3" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_4" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:120px"
                                                       class="form-control form-control-sm" value="{{__('messages.gp_evaluator_comment',['num' => '②'])}}"
                                                       id="generic_comment_title_4" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_5" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '①'])}}"
                                                       id="generic_comment_title_5" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_6" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '②'])}}"
                                                       id="generic_comment_title_6" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="generic_comment_display_typ_7" value="1" tabindex="-1"/>
                                            <span class="num-length">
                                                <input type="text" style="min-width:165px"
                                                       class="form-control form-control-sm" value="{{__('messages.personal_comment',['num' => '③'])}}"
                                                       id="generic_comment_title_7" maxlength="20"
                                                       readonly="" tabindex="-1"/>
                                            </span>
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
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
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_1" tabindex="11"></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_2" tabindex="12"></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_8" tabindex="12"></textarea>
                                    </span>
                                </td>
                                <td class="text-center ">
                                    <span class="num-length ">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_3" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_4" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_5" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_6" disabled=""></textarea>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="num-length">
                                        <textarea class="form-control" cols="30" rows="4" maxlength="400" id="generic_comment_7" disabled=""></textarea>
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div><!-- end .col-md-12 -->
                <div class="col-md-12">
                    <div id="item" class="table-responsive w-table2 sticky-table sticky-headers sticky-ltr-cells">
                        <table id="tbl2" class="table table-bordered table-hover table-ics tabl2 marginbottom15 table-striped table-hover table-striped" >
                            <thead>
                            <tr>
                                <th class="th-total" number="0">
                                    <button class="btn btn-rm blue btn-sm" id="btn-add-new-row" tabindex="13">
                                        <i class="fa fa-plus"></i>
                                    </button>
                                </th>
                                <th class="th-total" number="1">
                                    <div class="d-flex justify-content-between">
													<span class="num-length ics-textbox">
														<input type="text" style="min-width:205px" id="item_title_1" maxlength="20" class="form-control form-control-sm" value="{{__('messages.large_classification')}}" readonly="" tabindex="-1">
													</span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="item_display_typ_1" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-6 " tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th class="th-total" number="2">
                                    <div class="d-flex justify-content-between">
													<span class="num-length ics-textbox">
														<input type="text" style="min-width:205px" id="item_title_2" maxlength="20" class="form-control form-control-sm" value="{{__('messages.middle_classification')}}" readonly="" tabindex="-1">
													</span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="item_display_typ_2" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-7" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th class="th-total" number="3">
                                    <div class="d-flex justify-content-between">
													<span class="num-length ics-textbox">
														<input type="text" style="min-width:205px" id="item_title_3" maxlength="20" class="form-control form-control-sm" value="{{__('messages.minor_classification')}}" readonly="" tabindex="-1">
													</span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="item_display_typ_3" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-8" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                {{-- ウェイト --}}
                                <th class="th-total" number="4" class="w4" style="min-width:125px">
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input type="text"  id="weight_display_typ" class="form-control form-control-sm" value="{{__('messages.weight')}}" readonly="" tabindex="-1">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-9" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                                <th class="th-total" id="detail_self_progress_comment_display_typ" number="4" style="min-width:265px">
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox num-length">
                                            <input type="text" id="detail_self_progress_comment_title" class="form-control form-control-sm required" value="{{__('messages.self_progress_comment_m0170')}}" readonly="" tabindex="-1" style="min-width:205px;" maxlength="50">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="detail_self_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-62" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                {{-- 評価者進捗コメント(項目別)非表示ボタン --}}
                                <th class="th-total" number="5" id="detail_progress_comment_display_typ">
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox num-length">
                                            <input
                                                id="detail_progress_comment_title"
                                                type="text"
                                                style="min-width:205px"
                                                class="form-control form-control-sm"
                                                value="{{__('messages.evaluator_progress_comments_m0170')}}"
                                                readonly=""
                                                tabindex="-1"
                                                maxlength="50"
                                            />
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="detail_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-64" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                {{-- 評価 --}}
                                <th number="6">
                                    <div class="d-flex justify-content-between">
										<span class="ics-textbox">
											<input type="text" style="min-width:100px;" id="evaluation_display_typ" class="form-control form-control-sm" value="{{__('messages.evaluation')}}" readonly="" tabindex="-1">
										</span>
                                    </div>
                                </th>
                                <th number="7">
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox">
                                            <input class="display_typ" type="hidden" id="detail_comment_display_typ_0" value="1" tabindex="-1"/>
                                            <input type="text" style="min-width:115px"
                                                   class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}"
                                                   readonly="" tabindex="-1">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th number="8">
                                    <div class="d-flex justify-content-between">
											<span class="ics-textbox">
												<input type="text" style="min-width:205px" id="detail_comment_display_typ_1" class="form-control form-control-sm" value="{{__('messages.1st_rater_s_comment')}}" readonly="" tabindex="-1">
											</span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th number="9">
                                    <div class="d-flex justify-content-between">
                                            <span class="ics-textbox">
                                                <input type="text" style="min-width:205px" id="detail_comment_display_typ_2" class="form-control form-control-sm" value="{{__('messages.2st_rater_s_comment')}}" readonly="" tabindex="-1">
                                            </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th number="10">
                                    <div class="d-flex justify-content-between">
                                            <span class="ics-textbox">
                                                <input type="text" style="min-width:205px" id="detail_comment_display_typ_3" class="form-control form-control-sm" value="{{__('messages.3st_rater_s_comment')}}" readonly="" tabindex="-1">
                                            </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                                <th number="11">
                                    <div class="d-flex justify-content-between">
                                            <span class="ics-textbox">
                                                <input type="text" style="min-width:205px" id="detail_comment_display_typ_4" class="form-control form-control-sm" value="{{__('messages.4st_rater_s_comment')}}" readonly="" tabindex="-1">
                                            </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye" data-target=".td-11" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <input type="hidden" id="mode_import" value=""/>
                                <tr class="tr_generic_comment">
                                    {{-- delete --}}
                                    <td class="text-center td-0">
                                        <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                                            <i class="fa fa-remove"></i>
                                        </button>
                                    </td>
                                    {{-- 大分類 --}}
                                    <td class="text-center td-1 ln-length">
                                         <input type="hidden" class="form-control mode_row" maxlength="1" value="A">
                                         <input type="hidden" class="form-control item_no" maxlength="3" value="">
                                        <span class="num-length">
                                            <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                                        </span>
                                    </td>
                                    {{-- 中分類 --}}
                                    <td class="text-center td-2 ln-length">
                                        <span class="num-length">
                                            <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                                        </span>
                                    </td>
                                    {{-- 小分類 --}}
                                    <td class="text-center td-3 ln-length">
                                        <span class="num-length ">
                                            <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                                        </span>
                                    </td>
                                    {{-- ウェイト --}}
                                    <td class="text-right td-4 " >
                                        <span class="num-length">
                                            <div class="input-group-btn ">
                                                <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" tabindex="13">
                                                <div class="input-group-append-btn icon-percent">
                                                    <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                                                </div>
                                            </div>
                                        </span>
                                    </td>
                                    {{-- 自己進捗コメント(項目別)非表示ボタン --}}
                                    <td class="text-center td-62">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 進捗コメント(項目別)非表示ボタン --}}
                                    <td class="text-center td-64">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 評価 --}}
                                    <td class="text-center td-6">
                                        <span class="num-length ">
                                            <input type="text" class="form-control" maxlength="2" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 自己評価コメント --}}
                                    <td class="text-center td-7">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 一次評価者コメント --}}
                                    <td class="text-center td-8">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 二次評価者コメント --}}
                                    <td class="text-center td-9">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 三次評価者コメント --}}
                                    <td class="text-center td-10">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                    {{-- 四次評価者コメント --}}
                                    <td class="text-center td-11">
                                        <span class="num-length">
                                            <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                        </span>
                                    </td>
                                </tr>
                                {{--Total--}}
                                <tr id="tr-total">
                                    <td colspan="0" class="baffbo" id="td-colspan" msg="calculate colspan by js setColSpanTotalTbl2()">

                                    </td>
                                    <th  class="ba55 text-left togcol">
                                        <div class="d-flex justify-content-between" style="align-items: center">
                                            <span class="ics-textbox" style="white-space: nowrap"  id="text_total_score_display_typ" >{{__('messages.total_points')}}</span>
                                            <div class="ics-group">
                                                <a href="javascript:;" id="total_score_display_typ" class="ics ics-eye-total" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                    <!-- <td class="baffbo baffbo5"></td>
                                    <td class="baffbo baffbo6"></td> -->
                                    <td class="baffbo baffbo8"></td>
                                    <td class="baffbo baffbo9"></td>
                                    <td class="baffbo baffbo10"></td>
                                    <td class="baffbo baffbo11"></td>
                                    <td class="baffbo baffbo12"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <table class="hidden" id="table-target">
                    <tbody>
                    <tr class="tr_generic_comment">
                        <td class="text-center td-0">
                            <button class="btn btn-rm btn-sm btn-remove-row" tabindex="13">
                                <i class="fa fa-remove"></i>
                            </button>
                        </td>
                        <td class="text-center td-1 ln-length">
                            <input type="hidden" class="form-control mode_row" value="A" maxlength="1">
                            <input type="hidden" class="form-control item_no" maxlength="15" value="" >
                            <span class="num-length ">
                                <textarea class="form-control item_detail_1" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                        </td>
                        <td class="text-center td-2 ln-length">
                            <span class="num-length ">
                                <textarea class="form-control item_detail_2" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                        </td>
                        <td class="text-center td-3 ln-length">
                            <span class="num-length ">
                                <textarea class="form-control item_detail_3" cols="30" rows="3" maxlength="1000" tabindex="13"></textarea>
                            </span>
                        </td>
                        <td class="text-right td-4 ">
                             <span class="num-length">
                                    <div class="input-group-btn">
                                        <input type="text" class="form-control only-number weight requiredValue0" maxlength="3" max="100" min="0" tabindex="13">
                                        <div class="input-group-append-btn icon-percent">
                                            <button class="btn btn-transparent" type="button" disabled=""><i class="fa fa-percent"></i></button>
                                        </div>
                                    </div>
                            </span>
                        </td>
                        <td class="text-center td-62">
							<span class="num-length ">
								<input type="text" class="form-control" maxlength="15" disabled="disabled">
							</span>
                        </td>
                        <td class="text-center td-64">
							<span class="num-length ">
								<input type="text" class="form-control" maxlength="15" disabled="disabled">
							</span>
                        </td>
                        <td class="text-center td-6">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-7">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-8">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-9">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-10">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                        <td class="text-center td-11">
                            <span class="num-length ">
                                <input type="text" class="form-control" maxlength="15" disabled="disabled">
                            </span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <!--table3 -->
                <div class="col-md-12">
                    <div id="tbl3" class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-100" style="margin-top: 15px">
                        <div class="w200">
                            <table id="table-comment1" class="table table-bordered table-hover table-ics calc">
                                <thead>
                                <tr>
                                    <th id="self_progress_comment_display_typ">
                                        <div class="d-flex justify-content-between">
    										<span class="ics-textbox num-length">
    											<input type="text" id="self_progress_comment_title" style="min-width:115px" class="form-control form-control-sm" value="{{__('messages.self_progres_comment')}}" readonly="" tabindex="-1" maxlength="50">
    										</span>
                                            <div class="ics-group">
                                                <a href="javascript:;" id="self_progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                                    <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                                </a>
                                                <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                    <th>
                                        <div class="d-flex justify-content-between">
    										<span class="ics-textbox">
    											<input type="text" style="min-width:115px" id="point_criteria_display_typ" class="form-control form-control-sm" value="{{__('messages.eval_standard_m0160')}}" readonly="" tabindex="-1">
    										</span>
                                            <div class="ics-group">
                                                <a href="javascript:;" class="ics ics-eye2" data-target=".td-2" tabindex="-1">
                                                    <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                                </a>
                                            </div><!-- end .ics-group -->
                                        </div>
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="togcol w-366" >
    									<span class="num-length ">
    										<input type="text" class="form-control" maxlength="15" disabled="disabled">
    									</span>
                                    </td>
                                    <td class="togcol" style="width: 50% !important;">
    									<span class="num-length ">
    										<input type="text" class="form-control" maxlength="15" disabled="disabled">
    									</span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div><!-- end .row -->

                <div class="col-md-12" style="margin-top: -1px;">
                    <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells w-table3 w25" style="width: 25%;">
                        <table class="table table-bordered table-hover table-ics">
                            <thead>
                            <tr>
                                <th id="progress_comment_display_typ">
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox num-length">
                                            <input type="text" id="progress_comment_title" style="min-width:115px" class="form-control form-control-sm required" value="{{__('messages.eval_progress_comment')}}" readonly="" tabindex="-1" maxlength="50">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" id="progress_comment_title_x" class="ics ics-edit" tabindex="-1">
                                                <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                            </a>
                                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="togcol w-366" >
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div><!-- end .row -->

                <div class="col-md-12" style="margin-top: -1px;">
                    <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-table3 w25" style="width: 25%;">
                        <table class="table table-bordered table-hover table-ics">
                            <thead>
                            <tr>
                                <th>
                                    <div class="d-flex justify-content-between">
                                        <span class="ics-textbox" style="width:100%">
                                            <input type="text" id="self_assessment_comment_display_typ" style="min-width:115px" class="form-control form-control-sm" value="{{__('messages.self_evaluation_comment')}}" readonly="" tabindex="-1">
                                        </span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="togcol w-366" >
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div><!-- end .row -->

                <!--table4 -->
                <div class="col-md-12" style="margin-top: -1px;">
                    <div class="table-responsive sticky-table sticky-headers sticky-ltr-cells  w-table4 w25">
                        <table class="table table-bordered table-hover table-ics marginbottom15">
                            <thead>
                            <tr>
                                <th>
                                    <div class="d-flex justify-content-between">
										<span class="ics-textbox" >
											<input type="text" style="min-width:60px" id="evaluation_comment_display_typ" class="form-control form-control-sm" value="{{__('messages.evaluator_comment')}}" readonly="" tabindex="-1">
										</span>
                                        <div class="ics-group">
                                            <a href="javascript:;" class="ics ics-eye2" data-target=".td-1" tabindex="-1">
                                                <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                            </a>
                                        </div><!-- end .ics-group -->
                                    </div>
                                </th>

                            </thead>
                            <tbody>
                            <tr>
                            <tr>
                                <td class="togcol">
                                    <span class="num-length ">
                                        <input type="text" class="form-control" maxlength="15" disabled="disabled">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div><!-- end .card-body -->
<input type="file" class="inputfile" id="import_file" maxlength="100" accept="application/csv">
