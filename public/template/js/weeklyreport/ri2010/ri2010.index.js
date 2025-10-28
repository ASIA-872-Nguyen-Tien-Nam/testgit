/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/10/08
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package			:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version			:	1.0.0
 * ****************************************************************************
 */
//
$(document).ready(function () {
    try {
        initialize();
        initEvents();
    }
    catch (e) {
        alert('ready' + e.message);
    }
});
/**
 * initialize
 *
 * @author		:	viettd - 2023/02/10 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        $('#report_date').focus();
        $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
        if ($('.numericX1').length > 0) {
            new AutoNumeric.multiple('.numericX1',
                {
                    styleRules: AutoNumeric.options.styleRules.positiveNegative,
                    minimumValue: 0,
                    maximumValue: 99.9,
                    decimalPlaces: 1,

                }
            );
        }
        $.formatInput('div.content');
        // Autoresize for textarea
        autoResizeTextArea();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * initEvents
 * @author		:	viettd -2023/02/10- create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
        // btn_back
        $(document).on("click", "#btn-back", function (e) {
            try {
                e.preventDefault();
                let from = $('#from').val();
                if (from == 'ri2010') {
                    let url = $('#home_url').attr('href');
                    _backButtonFunction(url);
                } else {
                    _backButtonFunction(from, true);
                }
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        // btn_dashboard
        $(document).on("click", "#btn_dashboard", function (e) {
            try {
                e.preventDefault();
                let url = $('#home_url').attr('href');
                let from = $('#from').val();
                if (from == 'rdashboardapprover' || from == 'rdashboardreporter' || from == 'rdashboard') {
                    _backButtonFunction(url, true);
                } else {
                    _backButtonFunction(url);
                }
            } catch (e) {
                alert('#btn_dashboard' + e.message);
            }
        });
        // 
        $(document).on("click", ".adequacy_select", function () {
            try {
                if ($(this).hasClass('disabled')) {
                    return;
                } else {
                    let adequacy = $(this).closest('.adequacy');
                    adequacy.find('.adequacy_option').toggle();
                }
            } catch (e) {
                alert('.adequacy_select' + e.message);
            }
        });
        $(document).mouseup(function (e) {
            try {
                var div = $(this).closest('.adequacy');
                div.find('.adequacy_option').addClass('active');
                $('.adequacy_option').each(function () {
                    if (!$(this).hasClass('active')) {
                        $(this).hide();
                    }
                });
            } catch (e) {
                alert('mouseup' + e.message);
            }
        });
        $(document).on("click", ".adequacy_option_row", function () {
            try {
                var text = $(this).find(".image_select").html();
                var adequacy = $(this).closest('.adequacy');
                adequacy.find('.adequacy_dropdown span').html(text);
                adequacy.find('.adequacy_option').hide();
                // append value
                let adequacy_value = adequacy.find('.adequacy_value').val();
                adequacy.find('.adequacy_select .adequacy_value').val(adequacy_value);
            } catch (e) {
                alert('.adequacy_option_row' + e.message);
            }
        });
        // 付箋
        $(document).on("click", "#btn_sticky", function () {
            try {
                var option = {};
                var width = $(window).width();
                if ((width <= 1368) && (width >= 1300)) {
                    option.width = '80%';
                    option.height = '70%';
                } else {
                    if (width <= 1300) {
                        option.width = '80%';
                        option.height = '70%';
                    } else {
                        option.width = '1000px';
                        option.height = '500px';
                    }
                }
                let fiscal_year = $(this).attr('fiscal_year');
                let employee_cd = $(this).attr('employee_cd');
                let report_kind = $(this).attr('report_kind');
                let report_no = $(this).attr('report_no');
                let url = '/common/popup/sticky?fiscal_year=' + fiscal_year + '&employee_cd=' + employee_cd + '&report_kind=' + report_kind + '&report_no=' + report_no;
                showPopup(url, option, function () {
                    parent.location.reload();
                });
            } catch (e) {
                alert('#btn_sticky' + e.message);
            }
        });
        // 編集する
        $(document).on("click", ".btn-edit", function () {
            try {
                $(this).hide();
                // 
                var reply = $(this).closest('.reaction-reply');
                reply.find('.reaction-label').hide();
                reply.find('.reaction_icon').hide();
                reply.find('.reaction_icon_edit').show();
                reply.find('.reaction-comment').show();
                reply.find('.reaction-comment-action').show();
                // 
                autoResizeTextArea();
            } catch (e) {
                alert('.btn-edit' + e.message);
            }
        });
        // 編集のキャンセル
        $(document).on("click", ".btn-reply-delete", function () {
            try {
                $(this).closest('.reaction-comment-action').hide();
                var reply = $(this).closest('.reply');
                var reaction_reply = $(this).closest('.reaction-reply');
                reaction_reply.find('.reaction-comment').hide();
                reaction_reply.find('.reaction_icon_edit').hide();
                reaction_reply.find('.reaction-label').show();
                reaction_reply.find('.reaction_icon').show();
                reply.find('.btn-edit').show();
            } catch (e) {
                alert('.btn-reply-delete' + e.message);
            }
        });
        // comment save
        $(document).on("keydown", ".reaction_answer", function (e) {
            try {
                let html = '<span>→' + $(this).val(); +'</span>'
                var element = $(this).closest('.reaction__row__content');
                if (e.key == 13 || e.key == 'Enter') {
                    element.find('.reaction__row__content--answer').addClass('hide');
                    // append
                    element.find('.reaction__row__content__comment').append(html);
                }
            } catch (e) {
                alert('.btn_reply' + e.message);
            }
        });
        // 週報共有
        $(document).on("click", "#btn_share", function () {
            try {
                let fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
                let employee_cd = $('#employee_cd').val();
                let report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
                let report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
                let url = '/common/popup/reportEmployee?fiscal_year=' + fiscal_year + '&employee_cd=' + employee_cd + '&report_kind=' + report_kind + '&report_no=' + report_no + '&page=1&page_size=20';
                showPopup(url, {}, function () {
                    return false;
                });
            } catch (e) {
                alert('#btn_share' + e.message);
            }
        });
        //
        $(document).on('click', '.chk-item', function () {
            try {
                var count_check = $('#list').find('input:checkbox:checked').length;
                var check_box = $('#list').find('input:checkbox').length;
                if (count_check == check_box) {
                    $('#check-all').prop('checked', true);
                } else {
                    $('#check-all').prop('checked', false);
                }
            } catch (e) {
                alert('#ckball:' + e.message);
            }
        });
        // 閲覧者確認ポップアップ
        $(document).on("click", "#btn_viewer_confirm", function () {
            try {
                let fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
                let employee_cd = $('#employee_cd').val();
                let report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
                let report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
                let url = '/common/popup/viewer?fiscal_year=' + fiscal_year + '&employee_cd=' + employee_cd + '&report_kind=' + report_kind + '&report_no=' + report_no + '&page=1&page_size=20';
                showPopup(url, {}, function () {
                    return false;
                });
            } catch (e) {
                alert('#btn_viewer_confirm' + e.message);
            }
        });
        // btn_target_show
        $(document).on("click", "#btn_target_show", function () {
            try {
                var language = $('#language_jmessages').val();
                var show_text = '表示';
                var hide_text = '非表示';
                if (language == 'en') {
                    show_text = 'Display';
                    hide_text = 'Hidden';
                }
                // 
                if ($(this).hasClass('target_show')) {
                    $(this).removeClass('target_show');
                    $(this).text(show_text);
                    // 
                    $('#target').addClass('hide');
                } else {
                    $(this).addClass('target_show');
                    $(this).text(hide_text);
                    $('#target').removeClass('hide');
                }
            } catch (e) {
                alert('#btn_target_show' + e.message);
            }
        });

        // btn_header_show
        $(document).on("click", "#btn_header_show", function () {
            try {
                var language = $('#language_jmessages').val();
                var show_text = '表示';
                var hide_text = '非表示';
                if (language == 'en') {
                    show_text = 'Display';
                    hide_text = 'Hidden';
                }
                // 
                if ($(this).hasClass('header_show')) {
                    $(this).removeClass('header_show');
                    $(this).text(show_text);
                    // 
                    $('#header').addClass('hide');
                } else {
                    $(this).addClass('header_show');
                    $(this).text(hide_text);
                    $('#header').removeClass('hide');
                }
            } catch (e) {
                alert('#btn_header_show' + e.message);
            }
        });

        // Header一時保存
        $(document).on("click", "#btn-memory, #btn-memory-footer", function () {
            try {
                jMessage(1, function (r) {
                    if (r) {
                        saveData(1);
                    }
                });
            } catch (e) {
                alert('#btn-memory: ' + e.message);
            }
        });
        // Header 提出
        $(document).on("click", "#btn-submit, #btn-submit-footer", function () {
            try {
                jMessage(1, function (r) {
                    if (r && validaterI2010()) {
                        saveData(2);
                    }
                });
            } catch (e) {
                alert('btn-submit: ' + e.message);
            }
        });
        // Footer一時保存 
        $(document).on("click", "#btn_save", function () {
            try {
                jMessage(1, function (r) {
                    if (r) {
                        saveData(3);
                    }
                });
            } catch (e) {
                alert('#btn_save: ' + e.message);
            }
        });
        // Footer コメント 
        $(document).on("click", "#btn_comment", function () {
            try {
                jMessage(1, function (r) {
                    if (r) {
                        saveData(4);
                    }
                });
            } catch (e) {
                alert('#btn_comment: ' + e.message);
            }
        });
        // Footer 承認する
        $(document).on("click", "#btn_approved", function () {
            try {
                jMessage(39, function (r) {
                    if (r) {
                        saveData(5);
                    }
                });
            } catch (e) {
                alert('#btn_approved: ' + e.message);
            }
        });
        // 確認しました
        $(document).on("click", "#btn_confim", function () {
            try {
                jMessage(1, function (r) {
                    if (r) {
                        saveData(6);
                    }
                });
            } catch (e) {
                alert('#btn_confim: ' + e.message);
            }
        });
        // Footer 差戻しする
        $(document).on("click", "#btn_reject", function () {
            try {
                let login_use_typ = $('#login_use_typ').val();
                // when admin not show popup
                    var option = {};
                    option.width = '500px';
                    option.height = '500px';
                    let url = '/common/popup/reject';
                    showPopup(url, option, function () {
                    });
            } catch (e) {
                alert('#btn_reject: ' + e.message);
            }
        });
        // btn-reply
        $(document).on("click", ".btn-reply", function () {
            try {
                $(this).hide();
                // 
                var reply = $(this).closest('.reaction-reply');
                reply.find('.reply_reaction_action').show();
                reply.find('.reply_reaction_div').show();
                reply.find('.reply_comment_div').show();
                // 
                autoResizeTextArea();
            } catch (e) {
                alert('.btn-reply: ' + e.message);
            }
        });

        // 返事のキャンセル
        $(document).on("click", ".btn-reaction-reply-delete", function () {
            try {
                $(this).closest('.reply_reaction_action').hide();
                var reaction_reply = $(this).closest('.reaction-reply');
                reaction_reply.find('.reply_reaction_div').hide();
                reaction_reply.find('.reply_comment_div').hide();
                reaction_reply.find('.btn-reply').show();
            } catch (e) {
                alert('.btn-reaction-reply-delete' + e.message);
            }
        });

        // 返事の保存
        $(document).on("click", ".btn-reaction-reply-edit", function () {
            try {
                let object = $(this);
                jMessage(1, function (r) {
                    if (r) {
                        reply(object);
                    }
                });
            } catch (e) {
                alert('.btn-reaction-reply-edit: ' + e.message);
            }
        });
        // btn-reply-edit
        $(document).on("click", ".btn-reply-edit, .btn-comment", function () {
            try {
                let object = $(this);
                jMessage(1, function (r) {
                    if (r) {
                        reply(object);
                    }
                });
            } catch (e) {
                alert('.btn-reply-edit: ' + e.message);
            }
        });
        // comment_btn
        $(document).on("click", ".comment_btn", function () {
            try {
                let object = $(this);
                jMessage(1, function (r) {
                    if (r) {
                        commentDetail(object);
                    }
                });
            } catch (e) {
                alert('.comment_btn: ' + e.message);
            }
        });
        // btn-prev
        $(document).on("click", "#btn-prev", function (e) {
            try {
                e.preventDefault();
                let fiscal_year_prev = $(this).attr('fiscal_year_prev');
                let employee_cd_prev = $(this).attr('employee_cd_prev');
                let report_kind_prev = $(this).attr('report_kind_prev');
                let report_no_prev = $(this).attr('report_no_prev');
                nextPrevPage(fiscal_year_prev, employee_cd_prev, report_kind_prev, report_no_prev);
            } catch (e) {
                alert('#btn-prev: ' + e.message);
            }
        });
        // btn-next
        $(document).on("click", "#btn-next", function (e) {
            try {
                e.preventDefault();
                let fiscal_year_next = $(this).attr('fiscal_year_next');
                let employee_cd_next = $(this).attr('employee_cd_next');
                let report_kind_next = $(this).attr('report_kind_next');
                let report_no_next = $(this).attr('report_no_next');
                nextPrevPage(fiscal_year_next, employee_cd_next, report_kind_next, report_no_next);
            } catch (e) {
                alert('#btn-next: ' + e.message);
            }
        });
        // btn_comment_options
        $(document).on("click", "#btn_comment_options", function (e) {
            try {
                e.preventDefault();
                var option = {};
                let admin_and_is_approver = $('#admin_and_is_approver').val();
                let admin_and_is_viewer = $('#admin_and_is_viewer').val();
                let login_use_typ = $('#login_use_typ').val();
                let comment_typ = _getCommentType(login_use_typ, admin_and_is_approver, admin_and_is_viewer);
                option.width = '700px';
                option.height = '550px';
                let url = '/common/popup/comment_options?comment_typ=' + comment_typ;
                showPopup(url, option, function () {
                });
            } catch (e) {
                alert('#btn_comment_options: ' + e.message);
            }
        });
        // btn_comment_options
        $(document).on("click", "#btn_tr", function (e) {
            try {
                e.preventDefault();
                let data = {};
                data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
                data.employee_cd = $('#employee_cd').val();
                data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
                data.report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
                free_comment = $('#free_comment').val();
                data.language_name = $('#language_name').val();
                data.multilingual_use_typ = $('#multilingual_use_typ').val();  
                if (data.language_name == '' || data.multilingual_use_typ == 0)
                {
                    return;
                }
                // if($('#comment').val()!== $('#comment_check').val()){
                //     return
                // }
                comment =  $('#comment').val() || "";
                let list = [];
                list.push({
                    'type':'F4201_tr',
                    'employee_cd':data.employee_cd,
                    'user_id':$('.free_comment_user').val()||'',
                    'no_1': '',
                    'no_2': '',
                    'comment': free_comment,
                    'comment_1': '',
                    'comment_2': '',
                    'comment_3': '',
                    'comment_4': '',
                    'approver_user_1': '',
                    'approver_user_2': '',
                    'approver_user_3': '',
                    'approver_user_4': '',
                    'approver_comment':'',
                    'source_lang':$('.free_comment_user_language').val()||'',
                    'source_lang_1':'',
                    'source_lang_2':'',
                    'source_lang_3':'',
                    'source_lang_4':'',
                });
    
                $('.list_question').each(function () {
                    let question_no = $(this).find('.question_no').val() != '' ? $(this).find('.question_no').val() : 0;
                    // let answer = $(this).find('.answer').val();
                    let approver_comment_1= $(this).find('.approver_comment_1').val()||'';
                    let approver_comment_2= $(this).find('.approver_comment_2').val()||'';
                    let approver_comment_3= $(this).find('.approver_comment_3').val()||'';
                    let approver_comment_4= $(this).find('.approver_comment_4').val()||'';
                    let approver_user_1= $(this).find('.approver_user_1').val()||'';
                    let approver_user_2= $(this).find('.approver_user_2').val()||'';
                    let approver_user_3= $(this).find('.approver_user_3').val()||'';
                    let approver_user_4= $(this).find('.approver_user_4').val()||'';
                    let approver_user_1_language= $(this).find('.approver_user_1_language').val()||'';
                    let approver_user_2_language= $(this).find('.approver_user_2_language').val()||'';
                    let approver_user_3_language= $(this).find('.approver_user_3_language').val()||'';
                    let approver_user_4_language= $(this).find('.approver_user_4_language').val()||'';
                    let answer_sentence = '';
                    if ($(this).find('.answer_sentence').length > 0) {
                        answer_sentence = $(this).find('.answer_sentence').val();
                    }
                    list.push({
                        'type':'F4202_tr',
                        'employee_cd':data.employee_cd,
                        'user_id':$('.free_comment_user').val()||'',
                        'no_1': question_no,
                        'no_2': '',
                        'comment': answer_sentence,
                        'comment_1': approver_comment_1 ||'',
                        'comment_2': approver_comment_2 ||'',
                        'comment_3': approver_comment_3 ||'',
                        'comment_4': approver_comment_4 ||'',
                        'approver_user_1': approver_user_1 ||'',
                        'approver_user_2': approver_user_2 ||'',
                        'approver_user_3': approver_user_3 ||'',
                        'approver_user_4': approver_user_4 ||'',
                        'approver_comment':'',
                        'source_lang':$('.free_comment_user_language').val()||'',
                        'source_lang_1':approver_user_1_language,
                        'source_lang_2':approver_user_2_language,
                        'source_lang_3':approver_user_3_language,
                        'source_lang_4':approver_user_4_language,
                    });
                });
                //data.questions = list;
                $('#tab1 #tab_comment1 .reaction-reply .comment_tr').each(function () {
                    let reaction_no = '';
                    let comment = '';
                    reaction_no = $(this).find('.reaction_no_comment').val();
                    comment =  $(this).find('.reaction_comment_tr').val();
                    comment_user = $(this).find('.comment_user').val();
                    comment_user_language = $(this).find('.comment_user_language').val();
                    list.push({
                        'type':'F4204_tr',
                        'employee_cd':reaction_no,
                        'user_id':comment_user,
                        'no_1': reaction_no,
                        'no_2': '',
                        'comment': comment,
                        'comment_1': '',
                        'comment_2': '',
                        'comment_3': '',
                        'comment_4': '',
                        'approver_user_1': '',
                        'approver_user_2': '',
                        'approver_user_3': '',
                        'approver_user_4': '',
                        'approver_comment':'',
                        'source_lang':comment_user_language,
                        'source_lang_1':'',
                        'source_lang_2':'',
                        'source_lang_3':'',
                        'source_lang_4':'',
                    });
                });
                
                $('#tab1 #tab_comment1 .reaction-reply .reply_comment_tr').each(function () {
                    let reaction_no = '';
                    let reply_no = 0;
                    let comment = '';
                    reaction_no = $(this).find('.reaction_no_reply_tr').val();
                    reply_user_tr = $(this).find('.reply_user').val();
                    reply_user_language = $(this).find('.reply_user_language').val();
                    comment =  $(this).find('.reply_tr').val();
                    reply_no = $(this).find('.reply_no_reply_tr').val();               
                    list.push({
                        'type':'F4205_tr',
                        'employee_cd':reaction_no,
                        'user_id':reply_user_tr,
                        'no_1': reaction_no,
                        'no_2': reply_no,
                        'comment': comment,
                        'comment_1': '',
                        'comment_2': '',
                        'comment_3': '',
                        'comment_4': '',
                        'approver_user_1': '',
                        'approver_user_2': '',
                        'approver_user_3': '',
                        'approver_user_4': '',
                        'approver_comment':'',
                        'source_lang':reply_user_language,
                        'source_lang_1':'',
                        'source_lang_2':'',
                        'source_lang_3':'',
                        'source_lang_4':'',
                    });
                    
                });

                if (list.every(item => item.comment === "") 
                    && list.every(item => item.comment_1 === "")
                    && list.every(item => item.comment_2 === "")
                    && list.every(item => item.comment_3 === "")
                    && list.every(item => item.comment_4 === ""))
                {
                    return
                }     
                
                data.list = list;
                
                $.ajax({
                    type: 'POST',
                    url: '/weeklyreport/ri2010/translate',
                    dataType: 'json',
                    loading: true,
                    data: data,
                    success: function (res) {
                        switch (res['status']) {
                            // success
                            case OK:
                                jMessage(2, function (r) {
                                    if (r) {
                                        window.location.reload();
                                    }
                                });
                                break;
                            // error
                            case NG:
                                if (typeof res['errors'] != 'undefined') {
                                    processError(res['errors']);
                                }
                                break;
                            // Exception
                            case EX:
                                jError(res['Exception']);
                                $(".btn-ok").click(function() {
                                    window.location.reload();
                                });
                                break;
                            default:
                                break;
                        }
                    }
                });
                
            } catch (e) {
                alert('#btn_tr: ' + e.message);
            }
        });
        // nav-link-tab
        $(document).on('shown.bs.tab', ".nav-link-tab", function (e) {
            try {
                e.preventDefault();
                var report_no = $(this).attr('report_no');
                var id =  $(this).attr('href');
                loadRight(report_no,id)
            } catch (e) {
                alert('.nav-link-tab: ' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * Comment in detail table
 *
 * @author		:	viettd - 2023/05/08 - create
 * @param		:	object
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function commentDetail(object) {
    try {
        var data = {};
        let div = object.closest('.list_question');
        data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
        data.employee_cd = $('#employee_cd').val();
        data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
        data.report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
        data.question_no = parseInt(div.find('.question_no').val());
        data.approver_comment = div.find('.approver_comment').val();
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri2010/comment',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            if (r) {
                                window.location.reload();
                            }
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('reply' + e.message);
    }
}

/**
 * Reply
 *
 * @author		:	viettd - 2023/05/08 - create
 * @param		:	object
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function reply(object) {
    try {
        var data = {};
        let div = object.closest('.reaction-reply');
        data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
        data.employee_cd = $('#employee_cd').val();
        data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
        data.report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
        data.reaction_no = div.find('.reaction_no').val();
        data.reply_no = div.find('.reply_no').val() != '' ? parseInt(div.find('.reply_no').val()) : 0;
        data.reaction_type = div.find('.reaction_type').val() != '' ? parseInt(div.find('.reaction_type').val()) : 0;
        data.reply_comment = div.find('.reply_comment').val();
        reply_user          = div.find('.reply_user').val()||'';
        comment_user         = div.find('.comment_user').val()||'';
        // 
        data.reaction_cd = 0;
        if (div.find('.adequacy_select .reaction_cd_right').length > 0) {
            data.reaction_cd = div.find('.adequacy_select .reaction_cd_right').val() != '' ? parseInt(div.find('.adequacy_select .reaction_cd_right').val()) : 0;
        }
        data.reply_cd = 0;
        if (div.find('.adequacy_select .reply_cd').length > 0) {
            data.reply_cd = div.find('.adequacy_select .reply_cd').val() != '' ? parseInt(div.find('.adequacy_select .reply_cd').val()) : 0;
        }
        //
        let lists = [];
        lists.push({
            'type': data.reaction_type == 0 ? 'f4204_tr':'f4205_tr',
            'employee_cd':data.employee_cd,
            'user_id':data.reaction_type == 0 ? comment_user :reply_user,
            'no_1': data.reaction_no,
            'no_2': data.reply_no,
            'comment': data.reply_comment,
            'comment_1': '',
            'comment_2': '',
            'comment_3': '',
            'comment_4': '',
            'approver_comment':''
        });
        data.lists = lists;
        data.language_name = $('#language_name').val();
        data.multilingual_use_typ = $('#multilingual_use_typ').val();  
        
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri2010/reply',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            if (r) {
                                window.location.reload();
                            }
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        $(".btn-ok").click(function() {
                            window.location.reload();
                        });
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('reply' + e.message);
    }
}

/**
 * save Data
 *
 * @author		:	viettd - 2023/05/08 - create
 * @param		:	mode = 1.一時保存 2.提出
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function saveData(mode) {
    try {
        var data = getDataRI2010(mode);
        data.language_name = $('#language_name').val();
        data.multilingual_use_typ = (mode == 1 || mode == 3?0:$('#multilingual_use_typ').val());    
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri2010/save',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        let messsage_no = 2;
                        if (mode == 5) {
                            messsage_no = 40;
                        }
                        jMessage(messsage_no, function (r) {
                            if (r) {
                                window.location.reload();
                            }
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        $(".btn-ok").click(function() {
                            window.location.reload();
                        });
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('saveData' + e.message);
    }
}

/**
 * get Data from screen
 * 
 * @return Object
 */
function getDataRI2010(mode) {
    try {
        let data = {};
        data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
        data.employee_cd = $('#employee_cd').val();
        data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
        data.report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
        data.report_date = $('#report_date').val();
        let lists = [];
        data.adequacy_kbn = 0;
        data.busyness_kbn = 0;
        data.other_kbn = 0;
        data.reaction_cd = 0;
        if ($('.adequacy_select .adequacy_kbn').length > 0) {
            data.adequacy_kbn = $('.adequacy_select .adequacy_kbn').val() != '' ? parseInt($('.adequacy_select .adequacy_kbn').val()) : 0;
        }
        if ($('.adequacy_select .busyness_kbn').length > 0) {
            data.busyness_kbn = $('.adequacy_select .busyness_kbn').val() != '' ? parseInt($('.adequacy_select .busyness_kbn').val()) : 0;
        }
        if ($('.adequacy_select .other_kbn').length > 0) {
            data.other_kbn = $('.adequacy_select .other_kbn').val() != '' ? parseInt($('.adequacy_select .other_kbn').val()) : 0;
        }
        if ($('.adequacy_select .reaction_cd').length > 0) {
            data.reaction_cd = $('.adequacy_select .reaction_cd').val() != '' ? parseInt($('.adequacy_select .reaction_cd').val()) : 0;
        }
        data.free_comment = $('#free_comment').val();
        if(mode == 2){
            lists.push({
                'type':'F4201_tr',
                'employee_cd':data.employee_cd,
                'user_id':'',
                'no_1': '',
                'no_2': '',
                'comment': data.free_comment,
                'comment_1': '',
                'comment_2': '',
                'comment_3': '',
                'comment_4': '',
                'approver_comment':''
            });
        }
        data.comment = $('#comment').val();
        if(mode == 4||mode ==5){
            lists.push({
                'type':'F4204_tr',
                'employee_cd':data.employee_cd,
                'user_id':'',
                'no_1': '',
                'no_2': '',
                'comment': data.comment,
                'comment_1': '',
                'comment_2': '',
                'comment_3': '',
                'comment_4': '',
                'approver_comment':''
            });
        }
        // デフォルトに設定する
        data.set_default = 0;
        if ($('#ck_set_default').length > 0) {
            if ($('#ck_set_default').prop('checked')) {
                data.set_default = 1;
            }
        }
        data.admin_and_is_approver = $('#admin_and_is_approver').val();
        data.admin_and_is_viewer = $('#admin_and_is_viewer').val();
        // 質問一覧
        let list = [];
        $('.list_question').each(function () {
            let question_no = $(this).find('.question_no').val() != '' ? $(this).find('.question_no').val() : 0;
            // let answer = $(this).find('.answer').val();
            let approver_comment = $(this).find('.approver_comment').val();
            let answer_sentence = '';
            let answer_number = 0;
            let answer_select = 0;
            if ($(this).find('.answer_sentence').length > 0) {
                answer_sentence = $(this).find('.answer_sentence').val();
            }
            if ($(this).find('.answer_number').length > 0) {
                answer_number = $(this).find('.answer_number').val() != '' ? parseFloat($(this).find('.answer_number').val()) : 0;
            }
            if ($(this).find('.answer_select').length > 0) {
                answer_select = parseInt($(this).find('.answer_select').val()) > 0 ? parseInt($(this).find('.answer_select').val()) : 0;
            }
            list.push({
                'question_no': question_no,
                'answer_sentence': answer_sentence,
                'answer_number': answer_number,
                'answer_select': answer_select,
                'approver_comment': approver_comment
            });
            if((mode == 2) && answer_sentence !=''){
                lists.push({
                    'type':'F4202_tr',
                    'employee_cd':data.employee_cd,
                    'user_id':'',
                    'no_1': question_no,
                    'no_2': '',
                    'comment': answer_sentence,
                    'comment_1': '',
                    'comment_2': '',
                    'comment_3': '',
                    'comment_4': '',
                    'approver_comment': '',
                });
            }
            if((mode == 4||mode ==5)&& approver_comment != ''){
                lists.push({
                    'type':'F4202_tr',
                    'employee_cd':data.employee_cd,
                    'user_id':'',
                    'no_1': question_no,
                    'no_2': '',
                    'comment': '',
                    'comment_1': '',
                    'comment_2': '',
                    'comment_3': '',
                    'comment_4': '',
                    'approver_comment':approver_comment || '',
                });
            }
        });
        if (lists.length === 0) {
            lists.push({
                'type':'F4202_tr',
                'employee_cd':'',
                'user_id':'',
                'no_1': 0,
                'no_2': '',
                'comment': '',
                'comment_1': '',
                'comment_2': '',
                'comment_3': '',
                'comment_4': '',
                'approver_comment': '',
            });
        }
        data.lists = lists;
        data.questions = list;
        data.mode = mode;
        return data;
    } catch (e) {
        console.log('getDataRI2010 : ' + e.message);
    }
}

/**
 * validate screen 
 * 
 */
function validaterI2010() {
    try {
        _clearErrors(1);
        let error = 0;
        if (!_validate()) {
            error++;
        }
        let message = _text[8].message;
        // validate adequacy_kbn
        if ($('.adequacy_select .adequacy_kbn').length > 0) {
            if ($('.adequacy_select .adequacy_kbn').val() == 0) {
                $('.adequacy_select .adequacy_kbn').closest('.adequacy_dropdown').errorStyle(message, 1);
                $('.adequacy_select .adequacy_kbn').closest('.adequacy_dropdown').removeClass('boder-error');
                error++;
            }
        }
        // validate busyness_kbn
        if ($('.adequacy_select .busyness_kbn').length > 0) {
            if ($('.adequacy_select .busyness_kbn').val() == 0) {
                $('.adequacy_select .busyness_kbn').closest('.adequacy_dropdown').errorStyle(message, 1);
                $('.adequacy_select .busyness_kbn').closest('.adequacy_dropdown').removeClass('boder-error');
                error++;
            }
        }
        // validate other_kbn
        if ($('.adequacy_select .other_kbn').length > 0) {
            if ($('.adequacy_select .other_kbn').val() == 0) {
                $('.adequacy_select .other_kbn').closest('.adequacy_dropdown').errorStyle(message, 1);
                $('.adequacy_select .other_kbn').closest('.adequacy_dropdown').removeClass('boder-error');
                error++;
            }
        }
        // 
        if (error > 0) {
            checkTabError();
            _focusErrorItem();
            return false;
        } else {
            return true;
        }
    } catch (e) {
        console.log('validaterI2010: ' + e.message);
    }
}

/**
 * Next or Prev Page
 * 
 * @param {Int} report_no 
 */
function nextPrevPage(fiscal_year = 0, employee_cd = '', report_kind = 0, report_no = 0) {
    try {
        var list_report_no = $('#list_report_no').val();
        var data = {
            'fiscal_year_weeklyreport': fiscal_year
            , 'employee_cd': employee_cd
            , 'report_kind': report_kind
            , 'report_no': report_no
            , 'list_report_no': list_report_no
            , 'from': 'ri2010'
        };
        data['screen_id'] = 'ri2010_ri2010';	// save key -> to cache
        _redirectScreen('/weeklyreport/ri2010', data, false);
    } catch (e) {
        console.log('nextPrevPage:' + e.message);
    }
}

/**
 * Reject a report
 *
 * @author		:	viettd - 2023/05/08 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function reject() {
    try {
        var data = {};
        data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
        data.employee_cd = $('#employee_cd').val();
        data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
        data.report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
        data.reject_comment = '';
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/common/popup/reject',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            if (r) {
                                window.location.reload();
                            }
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('reject' + e.message);
    }
}

/**
 * Auto resize textarea
 */
function autoResizeTextArea() {
    try {
        $('textarea').not('.target').each(function () {
            let h = this.scrollHeight > 60 ? this.scrollHeight : 60;
            this.setAttribute('style', 'height:' + h + 'px;overflow-y:hidden;');
        }).on('input', function () {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    } catch (e) {
        console.log('autoResizeTextArea:' + e.message);
    }
}
/**
 * loadRight
 *
 * @author      :   tuantv - 2018/10/20 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function loadRight(report_no = 1,tab = null) {
	try {
		//
        data={};
        data.fiscal_year = $('#fiscal_year').val() != '' ? parseInt($('#fiscal_year').val()) : 0;
        data.employee_cd = $('#employee_cd').val();
        data.report_kind = $('#report_kind').val() != '' ? parseInt($('#report_kind').val()) : 0;
        data.report_no   = report_no
        report_no = $('#report_no').val() != '' ? parseInt($('#report_no').val()) : 0;
		// send ajax
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/ri2010/right',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
                $('.right_content').empty();
                $(tab).find('.right_content').append(res);
                if (report_no != data.report_no){
                    $('.btn-reply').closest('.line-solid').empty();
                    $('.btn-edit').closest('div').empty();
                    $('.btn-comment').closest('div').empty();
                }		
			}
		});
	} catch (e) {
		alert('loadRight: ' + e.message);
	}
}