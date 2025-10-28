/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _objTemp = {
    'fiscal_year': { 'type': 'text', 'attr': 'id' },
    'employee_cd_refer': { 'type': 'text', 'attr': 'id' },
    'sheet_cd': { 'type': 'text', 'attr': 'id' },
    'status_cd': { 'type': 'text', 'attr': 'id' },
    //  汎用
    'generic_comment_1': { 'type': 'text', 'attr': 'id' },
    'generic_comment_2': { 'type': 'text', 'attr': 'id' },
    'generic_comment_3': { 'type': 'text', 'attr': 'id' },
    'generic_comment_4': { 'type': 'text', 'attr': 'id' },
    'generic_comment_5': { 'type': 'text', 'attr': 'id' },
    'generic_comment_6': { 'type': 'text', 'attr': 'id' },
    'generic_comment_7': { 'type': 'text', 'attr': 'id' },
    'generic_comment_8': { 'type': 'text', 'attr': 'id' },
    'evaluation_step': { 'type': 'text', 'attr': 'id' },
    'tr_list': {
        'attr': 'list', 'item': {
            'item_no': { 'type': 'text', 'attr': 'class' },
            'weight': { 'type': 'text', 'attr': 'class' },
            'point_cd_0': { 'type': 'select', 'attr': 'class' },
            'evaluation_comment': { 'type': 'text', 'attr': 'class' },    //  自己評価コメント
            // 'evaluation_comment_detail'     :   {'type':'text', 'attr':'class'},
            'evaluation_comment_detail_1': { 'type': 'text', 'attr': 'class' },
            'evaluation_comment_detail_2': { 'type': 'text', 'attr': 'class' },
            'evaluation_comment_detail_3': { 'type': 'text', 'attr': 'class' },
            'evaluation_comment_detail_4': { 'type': 'text', 'attr': 'class' },
            'point_cd_1': { 'type': 'select', 'attr': 'class' },
            'point_cd_2': { 'type': 'select', 'attr': 'class' },
            'point_cd_3': { 'type': 'select', 'attr': 'class' },
            'point_cd_4': { 'type': 'select', 'attr': 'class' },
        }
    },
    'evaluation_comment_0': { 'type': 'text', 'attr': 'id' },
    'evaluation_comment_1': { 'type': 'text', 'attr': 'id' },
    'evaluation_comment_2': { 'type': 'text', 'attr': 'id' },
    'evaluation_comment_3': { 'type': 'text', 'attr': 'id' },
    'evaluation_comment_4': { 'type': 'text', 'attr': 'id' },
    'TOTAL_0': { 'type': 'text', 'attr': 'id' },
    'TOTAL_1': { 'type': 'text', 'attr': 'id' },
    'TOTAL_2': { 'type': 'text', 'attr': 'id' },
    'TOTAL_3': { 'type': 'text', 'attr': 'id' },
    'TOTAL_4': { 'type': 'text', 'attr': 'id' },
};

$(function () {
    initEvents();
    initialize();
});

/**
 * initialize
 *
 * @author		:	longvv - 2018/10/08 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        $('body .form-control:not([readonly]):not([disabled]):not(".hidden"):first').focus();
        _formatTooltip();
        var table_option = {
            'col_fix': 110
            , 'col_fix_view': 90
            , 'col_fix_option': 72
            , 'col_fix_option_view': 45
            , 'col_fix_comment': 250
            , 'col_fix_comment_view': 200
            , 'col_min': 200
        };
        createTable(table_option);
        //
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 *
 * @author      :   longvv - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function initEvents() {
    try {
        //vietdt 2022/08/31
        $('#table-data label').hover(function(){
            $('.tooltip').addClass('left-tooltip');
        });
        $(window).resize(function () {
            var table_option = {
                'col_fix': 110
                , 'col_fix_view': 90
                , 'col_fix_option': 72
                , 'col_fix_option_view': 45
                , 'col_fix_comment': 250
                , 'col_fix_comment_view': 200
                , 'col_min': 200
            };
            createTable(table_option);
        });
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 9) {
                if (e.shiftKey) {
                    if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
                        e.preventDefault();
                        if ($('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last().length != 0) {
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last()[0].focus();
                        }
                        return;
                    }
                    if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0]) {
                        e.preventDefault();
                        if ($(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length != 0) {
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0].focus();
                        } else {
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last()[0].focus();
                        }
                        return;
                    }
                } else {
                    if ($(':focus')[0] === $(':input:not([readonly],[disabled],:hidden)').last()[0]) {
                        e.preventDefault();
                        $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0].focus();
                    }
                    if ($(':focus')[0] === $('#ans-collapse a:not([readonly],.disabled,[disabled],:hidden)').last()[0]) {
                        e.preventDefault();
                        if ($(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().length > 0) {
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
                        } else {
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0].focus();
                        }
                    }
                }
            }
        });
        //面談記録
        $(document).on('click', '#btn-interview', function () {
            try {
                jMessage(71, function (r) {
                    if (r) {
                        var data = {
                            'fiscal_year': $('#fiscal_year').val()
                            , 'employee_cd': $('#employee_cd_refer').val()
                            , 'sheet_cd': $('#sheet_cd').val()
                            , 'from': 'i2020'
                            , 'from_source': $('#from').val()
                        };
                        _redirectScreen('/master/i2030', data);
                    }
                });
            } catch (e) {
                alert('.btn_employee_cd_popup' + e.message);
            }
        });
        //ダウンロード
        $(document).on('click', '#btn-download', function () {
            try {
                var file_name = $(this).attr('file-name');
                var file_adress = $(this).attr('file-adress');
                if (file_name != '') {
                    downloadfileHTML(file_adress, file_name, function () {
                        // deleteFile(file_adress);
                    });
                } else {
                    jMessage(21); return;
                }
            } catch (e) {
                alert('.btn_employee_cd_popup' + e.message);
            }
        });
        //一時保存
        $(document).on('click', '#btn-memory', function () {
            try {
                $('.point_cd_0,.point_cd_1,.point_cd_2,.point_cd_3,.point_cd_4').trigger('change');
                jMessage(1, function (r) {
                    if (r) {
                        saveData(0);
                    }
                });
            } catch (e) {
                alert('#btn_memory' + e.message);
            }
        });
        //登録
        $(document).on('click', '#btn-confirm', function () {
            try {
                $('.point_cd_0,.point_cd_1,.point_cd_2,.point_cd_3,.point_cd_4').trigger('change');
                jMessage(1, function (r) {
                    if (r) {
                        saveData(1);
                    }
                });
            } catch (e) {
                alert('#btn-confirm' + e.message);
            }
        });
        //戻る
        $(document).on('click', '#btn-back', function () {
            try {
                jMessage(71, function (r) {
                    if (r) {
                        backScreen();
                    }
                });
            } catch (e) {
                alert('#btn-back: ' + e.message);
            }
        });
        //
        $(document).on('change', '.point_cd_0,.point_cd_1,.point_cd_2,.point_cd_3,.point_cd_4', function () {
            try {
                var step = $(this).attr('step') * 1;
                var point_calculation_typ1 = $('#point_calculation_typ1').val() * 1;
                var point_calculation_typ2 = $('#point_calculation_typ2').val() * 1;
                caculatePointSum(step, point_calculation_typ1, point_calculation_typ2);
            } catch (e) {
                alert('.point_cd_0,.point_cd_1,.point_cd_2,.point_cd_3,.point_cd_4 : ' + e.message);
            }
        });
        // 自己進捗コメント
        // button btn_progress_comment_self_edit
        $(document).on('click', '#btn_progress_comment_self_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_self_hide').removeClass('hide');
                    $('.progress_comment_self').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.progress_comment_self').removeClass('hide');
                    $('.progress_comment_self_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_self_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_self_approve', function () {
            try {
                if ($('#btn_progress_comment_self_edit').hasClass('choice')) {
                    postComment(20); // 自己進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_self_approve:' + e.message);
            }
        });
        // 一次評価者進捗コメント
        // button btn_progress_comment_rater_edit
        $(document).on('click', '#btn_progress_comment_rater_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_rater_hide').removeClass('hide');
                    $('.progress_comment_rater').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.progress_comment_rater').removeClass('hide');
                    $('.progress_comment_rater_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_rater_approve', function () {
            try {
                if ($('#btn_progress_comment_rater_edit').hasClass('choice')) {
                    postComment(21); // 一次評価者進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_approve:' + e.message);
            }
        });
        // 二次評価者進捗コメント
        // button btn_progress_comment_rater_2_edit
        $(document).on('click', '#btn_progress_comment_rater_2_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_rater_2_hide').removeClass('hide');
                    $('.progress_comment_rater_2').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.progress_comment_rater_2').removeClass('hide');
                    $('.progress_comment_rater_2_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_2_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_rater_2_approve', function () {
            try {
                if ($('#btn_progress_comment_rater_2_edit').hasClass('choice')) {
                    postComment(22); // 二次評価者進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_2_approve:' + e.message);
            }
        });
        // 三次評価者進捗コメント
        // button btn_progress_comment_rater_3_edit
        $(document).on('click', '#btn_progress_comment_rater_3_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_rater_3_hide').removeClass('hide');
                    $('.progress_comment_rater_3').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.progress_comment_rater_3').removeClass('hide');
                    $('.progress_comment_rater_3_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_3_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_rater_3_approve', function () {
            try {
                if ($('#btn_progress_comment_rater_3_edit').hasClass('choice')) {
                    postComment(23); // 三次評価者進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_3_approve:' + e.message);
            }
        });
        // 四次評価者進捗コメント
        // button btn_progress_comment_rater_4_edit
        $(document).on('click', '#btn_progress_comment_rater_4_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_rater_4_hide').removeClass('hide');
                    $('.progress_comment_rater_4').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.progress_comment_rater_4').removeClass('hide');
                    $('.progress_comment_rater_4_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_4_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_rater_4_approve', function () {
            try {
                if ($('#btn_progress_comment_rater_4_edit').hasClass('choice')) {
                    postComment(24); // 四次評価者進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_rater_4_approve:' + e.message);
            }
        });

        // 自己進捗コメント(項目別)
        // button btn_self_progress_comment_edit
        $(document).on('click', '#btn_self_progress_comment_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.self_progress_comment_hide').removeClass('hide');
                    $('.div_self_progress_comment').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.div_self_progress_comment').removeClass('hide');
                    $('.self_progress_comment_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_self_progress_comment_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_self_progress_comment_approve', function () {
            try {
                if ($('#btn_self_progress_comment_edit').hasClass('choice')) {
                    postComment(10); // 自己進捗コメント
                }
            } catch (e) {
                alert('#btn_self_progress_comment_approve:' + e.message);
            }
        });
        // 進捗コメント(項目別)
        // button btn_progress_comment_edit
        $(document).on('click', '#btn_progress_comment_edit', function () {
            try {
                if ($(this).hasClass('choice')) {
                    $(this).removeClass('choice');
                    //
                    $('.progress_comment_hide').removeClass('hide');
                    $('.div_progress_comment').addClass('hide');
                } else {
                    $(this).addClass('choice');
                    //
                    $('.div_progress_comment').removeClass('hide');
                    $('.progress_comment_hide').addClass('hide');
                }
            } catch (e) {
                alert('#btn_progress_comment_edit event:' + e.message);
            }
        });
        // button btn-ics-edit
        $(document).on('click', '#btn_progress_comment_approve', function () {
            try {
                if ($('#btn_progress_comment_edit').hasClass('choice')) {
                    postComment(11); // 進捗コメント
                }
            } catch (e) {
                alert('#btn_progress_comment_approve:' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   longvv - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData(mode) {
    try {
        // mode = 0:一時保存 1:登録 2:承認 3:差戻し
        if (mode == 1 && !_validate($('body'))) {
            return false;
        } else {
            var data = getData(_objTemp);
            data.data_sql['mode'] = mode
            // send data to post
            $.ajax({
                type: 'POST',
                url: '/master/i2020/saveData',
                dataType: 'json',
                loading: true,
                data: JSON.stringify(data),
                success: function (res) {
                    switch (res['status']) {
                        // success
                        case OK:
                            // if mode = 1.登録 and status_cd = 1 then show send mail dialog;
                            if (mode == 1 && res['status_cd'] == 1) {
                                jMail(_text[2].message_nm, _text[2].message, res['employee_cd'], 0,data.data_sql['employee_cd_refer'], function (r) {
                                    if (r) {
                                        location.reload();
                                    }
                                });
                                // else 
                            } else {
                                jMessage(2, function (r) {
                                    if (r) {
                                        var alert_message = res['alert_message'];
                                        if (alert_message != 0) {
                                            jMessage(alert_message, function () {
                                                location.reload();
                                            });
                                        } else {
                                            location.reload();
                                        }
                                    }
                                });
                            }
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
        }
    } catch (e) {
        alert('save' + e.message);
    }
}
/**
 * backScreen
 *
 * @author      :   longvv - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function backScreen() {
    try {
        // var home_url = $('#home_url').attr('href');
        // var urlObject = new URL(home_url);
        // var from = $('#from').val();
        // var from_source = $('#from_source').val();
        // if(from_source != ''){
        //     var data = {
        //         'from'  :   from_source
        //     };
        // }else{
        //     var data = {
        //         'from'  :   'i2010'
        //     };
        // }
        // // 
        // if (from == 'q0071') {
        //     data.employee_cd = $('#employee_cd_refer').val();
        //     _redirectScreen('/master/q0071', data);
        // } else if (from == 'q2010') {
        //     _redirectScreen('/master/q2010', data);
        // } else if (from == 'i2040') {
        //     _redirectScreen('/master/i2040', data);
        // } else if (from == 'i2050') {
        //     _redirectScreen('/master/i2050', data);
        // } else if (from == 'portal') {
        //     data.fiscal_year = $('#fiscal_year').val();
        //     _redirectScreen('/master/portal', data);
        // } else if (from == 'evaluator') {
        //     data.fiscal_year = $('#fiscal_year').val();
        //     _redirectScreen('/master/portal/evaluator', data);
        // } else if (from == 'dashboard') {
        //     data.fiscal_year = $('#fiscal_year').val();
        //     _redirectScreen('/dashboard', data);
        // }else if(from == 'information'){
        //     if(!_validateDomain(window.location,urlObject.pathname))
        //     {
        //         jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        //     }else{
        //         window.location.href = home_url;
        //     }
        // } else {
        //     jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
        // }
        window.close();
    } catch (e) {
        alert('backScreen' + e.message);
    }
}
/**
 * createTable
 *
 * @author      :   viettd - 2019/06/14 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function createTable(table_option) {
    //
    var col_fix = 100;    // default
    var col_fix_view = 100;    // default
    var col_fix_option = 100;    // default
    var col_fix_option_view = 100;    // default
    var col_fix_comment = 100;	  // default
    var col_fix_comment_view = 100;	  // default
    var col_min = 200;    // default
    // 
    var div_table = $('.wmd-view table');
    if (typeof table_option != 'undefined') {
        col_fix = table_option.col_fix;
        col_fix_view = table_option.col_fix_view;
        col_fix_option = table_option.col_fix_option;
        col_fix_option_view = table_option.col_fix_option_view;
        col_fix_comment = table_option.col_fix_comment;
        col_fix_comment_view = table_option.col_fix_comment_view;
        col_min = table_option.col_min;
    }
    var wmd_size = $('.wmd-view').width();
    var cols_num = div_table.find('thead tr:first th').length;
    var cols_fix_num = div_table.find('thead tr:first .col-fix').length;
    var col_fix_option_num = div_table.find('thead tr:first .col-fix-option').length;
    var col_fix_comment_num = div_table.find('thead tr:first .col-fix-comment').length;
    var table_width = 0;
    // Set width for cols_fix
    if (cols_fix_num > 0) {
        div_table.find('thead tr:first .col-fix').each(function () {
            if ($(this).hasClass('view')) {
                $(this).width(col_fix_view);
                table_width += col_fix_view;
            } else {
                $(this).width(col_fix);
                table_width += col_fix;
            }
        });
    }
    // Set width for col_fix_option
    if (col_fix_option_num > 0) {
        div_table.find('thead tr:first .col-fix-option').each(function () {
            if ($(this).hasClass('view')) {
                $(this).width(col_fix_option_view);
                table_width += col_fix_option_view;
            } else {
                $(this).width(col_fix_option);
                table_width += col_fix_option;
            }
        });
    }
    // Set width for col_fix_comment
    if (col_fix_comment_num > 0) {
        div_table.find('thead tr:first .col-fix-comment').each(function () {
            if ($(this).hasClass('view')) {
                $(this).width(col_fix_comment_view);
                table_width += col_fix_comment_view;
            } else {
                $(this).width(col_fix_comment);
                table_width += col_fix_comment;
            }
        });
    }
    // Set width for table not fixed
    var w = 0;
    var w_fixed = 0
    // Get fixed width of col_fix
    div_table.find('thead tr:first .col-fix').each(function () {
        w_fixed += $(this).width();
    });
    // Get fixed width of col_fix_option
    div_table.find('thead tr:first .col-fix-option').each(function () {
        w_fixed += $(this).width();
    });
    // Get fixed width of col_fix_comment
    div_table.find('thead tr:first .col-fix-comment').each(function () {
        w_fixed += $(this).width();
    });
    w = wmd_size - w_fixed;
    // Set with for not fixed cols
    if ((w / (cols_num - cols_fix_num - col_fix_option_num - col_fix_comment_num)) < col_min) {
        div_table.find('thead tr:first th:not(".col-fix,.col-fix-option,.col-fix-comment")').each(function () {
            $(this).width(col_min);
            table_width += col_min;
        });
    } else {
        div_table.find('thead tr:first th:not(".col-fix,.col-fix-option,.col-fix-comment")').each(function () {
            $(this).width((w / (cols_num - cols_fix_num - col_fix_option_num - col_fix_comment_num)));
            table_width += w / (cols_num - cols_fix_num - col_fix_option_num - col_fix_comment_num);
        });
    }
    //
    if (table_width > 0) {
        div_table.width(table_width);
    }
    //
    div_table.find('tbody td textarea').each(function(){
        var textarea = $(this);
        var td = $(this).parents('td');
        textarea.height(td.height() - 24);
    });
    // Set scroll of table
    // //
    $(".wmd-view-topscroll").scroll(function () {
        $(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
    });
    $(".wmd-view").scroll(function () {
        $(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
    });
    fixWidth();
    $(window).resize(function () {
        fixWidth();
    });
    function fixWidth() {
        var w = $('.wmd-view .table').width();
        $(".wmd-view-topscroll .scroll-div1").width(w);
    }
    //
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        return false;
    } else {
        scrollFix();
        function scrollFix() {
            $(window).scroll(function () {
                var offset = $('.button-midd-div').offset().top;
                var scrollTop = $(window).scrollTop();
                //
                if (scrollTop > offset) {
                    //
                    $('.ofixed-boder thead tr th').css({
                        'position': 'relative',
                        'z-index': 1,
                        'top': (scrollTop - offset) + 'px'
                    });
                    //
                    $('.wmd-view-topscroll').css({
                        'top': (scrollTop - offset + 2) + 'px',
                        'position': 'relative',
                        'background': '#fff',
                        'border-style': 'none',
                        'z-index': 27
                    });
                } else {
                    $('.ofixed-boder thead tr th').css({
                        'position': 'relative',
                        'top': (0) + 'px'
                    });
                    $('.wmd-view-topscroll').css({
                        'top': (0) + 'px',
                        'position': 'relative',
                        'z-index': 27
                    });
                }
            });
        }
    }
}
/**
 * caculatePointSum
 *
 * @author      :   viettd - 2019/12/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function caculatePointSum(step, point_calculation_typ1, point_calculation_typ2) {
    try {
        // point_calculation_typ1 : 1.ウェイト 2.係数
        // point_calculation_typ2 : 1.合計 2.平均
        var betting_rate = 0;
        var weight = 0;
        var point = 0;
        var count = 0;
        var total = 0;
        var weight_total = 0;
        if (step == 1) {
            $('.tr_list').each(function () {
                betting_rate = $(this).find('.point_cd_1').attr('betting_rate') == '' ? 0 : $(this).find('.point_cd_1').attr('betting_rate') * 1;
                weight = $(this).find('.point_cd_1').attr('weight') == '' ? 0 : $(this).find('.point_cd_1').attr('weight') * 1;
                //
                if (point_calculation_typ1 == 1 && weight == 0) {
                    weight = 100;
                } else if (point_calculation_typ1 == 2 && weight == 0) {
                    weight = 1;
                }
                //
                if (typeof $(this).find('.point_cd_1 option:selected').attr('point') != 'undefined' && $(this).find('.point_cd_1 option:selected').attr('point') != '') {
                    point = $(this).find('.point_cd_1 option:selected').attr('point') * 1;
                } else {
                    point = 0;
                }
                //
                if (point_calculation_typ2 == 1 && point_calculation_typ1 == 1) {
                    total += (point * weight * betting_rate) / 100;
                } else if (point_calculation_typ2 == 1 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                } else if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                }
                //
                weight_total += weight;
                count++;
            });
            //
            if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                total = total / weight_total;
            }
            //
            // $('#point_sum1_total').text(total.toFixed(2));
            // $('#point_sum1').val(total.toFixed(2));
            //
            $('#TOTAL_1').val(total.toFixed(2));
            $('#TOTAL_1_Show').text(total.toFixed(2));
        } else if (step == 2) {
            $('.tr_list').each(function () {
                betting_rate = $(this).find('.point_cd_2').attr('betting_rate') == '' ? 0 : $(this).find('.point_cd_2').attr('betting_rate') * 1;
                weight = $(this).find('.point_cd_2').attr('weight') == '' ? 0 : $(this).find('.point_cd_2').attr('weight') * 1;
                //
                if (point_calculation_typ1 == 1 && weight == 0) {
                    weight = 100;
                } else if (point_calculation_typ1 == 2 && weight == 0) {
                    weight = 1;
                }
                //
                if (typeof $(this).find('.point_cd_2 option:selected').attr('point') != 'undefined' && $(this).find('.point_cd_2 option:selected').attr('point') != '') {
                    point = $(this).find('.point_cd_2 option:selected').attr('point') * 1;
                } else {
                    point = 0;
                }
                //
                if (point_calculation_typ2 == 1 && point_calculation_typ1 == 1) {
                    total += (point * weight * betting_rate) / 100;
                } else if (point_calculation_typ2 == 1 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                } else if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                }
                //
                weight_total += weight;
                //
                count++;
            });
            //
            if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                total = total / weight_total;
            }
            //
            // $('#point_sum2_total').text(total.toFixed(2));
            // $('#point_sum2').val(total.toFixed(2));
            $('#TOTAL_2').val(total.toFixed(2));
            $('#TOTAL_2_Show').text(total.toFixed(2));
        } else if (step == 3) {
            $('.tr_list').each(function () {
                betting_rate = $(this).find('.point_cd_3').attr('betting_rate') == '' ? 0 : $(this).find('.point_cd_3').attr('betting_rate') * 1;
                weight = $(this).find('.point_cd_3').attr('weight') == '' ? 0 : $(this).find('.point_cd_3').attr('weight') * 1;
                //
                if (point_calculation_typ1 == 1 && weight == 0) {
                    weight = 100;
                } else if (point_calculation_typ1 == 2 && weight == 0) {
                    weight = 1;
                }
                //
                if (typeof $(this).find('.point_cd_3 option:selected').attr('point') != 'undefined' && $(this).find('.point_cd_3 option:selected').attr('point') != '') {
                    point = $(this).find('.point_cd_3 option:selected').attr('point') * 1;
                } else {
                    point = 0;
                }
                //
                if (point_calculation_typ2 == 1 && point_calculation_typ1 == 1) {
                    total += (point * weight * betting_rate) / 100;
                } else if (point_calculation_typ2 == 1 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                } else if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                }
                //
                weight_total += weight;
                count++;
            });
            //
            if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                total = total / weight_total;
            }
            //
            // $('#point_sum3_total').text(total.toFixed(2));
            // $('#point_sum3').val(total.toFixed(2));
            $('#TOTAL_3').val(total.toFixed(2));
            $('#TOTAL_3_Show').text(total.toFixed(2));
        } else if (step == 4) {
            $('.tr_list').each(function () {
                betting_rate = $(this).find('.point_cd_4').attr('betting_rate') == '' ? 0 : $(this).find('.point_cd_4').attr('betting_rate') * 1;
                weight = $(this).find('.point_cd_4').attr('weight') == '' ? 0 : $(this).find('.point_cd_4').attr('weight') * 1;
                //
                if (point_calculation_typ1 == 1 && weight == 0) {
                    weight = 100;
                } else if (point_calculation_typ1 == 2 && weight == 0) {
                    weight = 1;
                }
                //
                if (typeof $(this).find('.point_cd_4 option:selected').attr('point') != 'undefined' && $(this).find('.point_cd_4 option:selected').attr('point') != '') {
                    point = $(this).find('.point_cd_4 option:selected').attr('point') * 1;
                } else {
                    point = 0;
                }
                //
                if (point_calculation_typ2 == 1 && point_calculation_typ1 == 1) {
                    total += (point * weight * betting_rate) / 100;
                } else if (point_calculation_typ2 == 1 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                } else if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                }
                //
                weight_total += weight;
                count++;
            });
            //
            if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                total = total / weight_total;
            }
            //
            // $('#point_sum4_total').text(total.toFixed(2));
            // $('#point_sum4').val(total.toFixed(2));
            $('#TOTAL_4').val(total.toFixed(2));
            $('#TOTAL_4_Show').text(total.toFixed(2));
        } else if (step == 0) {
            $('.tr_list').each(function () {
                betting_rate = $(this).find('.point_cd_0').attr('betting_rate') == '' ? 0 : $(this).find('.point_cd_0').attr('betting_rate') * 1;
                weight = $(this).find('.point_cd_0').attr('weight') == '' ? 0 : $(this).find('.point_cd_0').attr('weight') * 1;
                //
                if (point_calculation_typ1 == 1 && weight == 0) {
                    weight = 100;
                } else if (point_calculation_typ1 == 2 && weight == 0) {
                    weight = 1;
                }
                //
                if (typeof $(this).find('.point_cd_0 option:selected').attr('point') != 'undefined' && $(this).find('.point_cd_0 option:selected').attr('point') != '') {
                    point = $(this).find('.point_cd_0 option:selected').attr('point') * 1;
                } else {
                    point = 0;
                }
                //
                if (point_calculation_typ2 == 1 && point_calculation_typ1 == 1) {
                    total += (point * weight * betting_rate) / 100;
                } else if (point_calculation_typ2 == 1 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                } else if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                    total += (point * weight * betting_rate);
                }
                //
                weight_total += weight;
                count++;
            });
            //
            if (point_calculation_typ2 == 2 && point_calculation_typ1 == 2) {
                total = total / weight_total;
            }
            //
            // $('#point_sum0').val(total.toFixed(2));
            $('#TOTAL_0').val(total.toFixed(2));
        }
    } catch (e) {
        alert('caculatePointSum : ' + e.message);
    }
}
/**
 * postComment
 *
 * @author		:	viettd - 2020/10/09 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function postComment(mode = 0) {
    try {
        var data = {};
        var list = [];
        var self_progress_comment = '';
        var progress_comment = '';
        //
        $('.tr_list').each(function () {
            if ($(this).find('.self_progress_comment').val() == undefined) {
                self_progress_comment = '';
            } else {
                self_progress_comment = $(this).find('.self_progress_comment').val();
            }
            if ($(this).find('.progress_comment').val() == undefined) {
                progress_comment = '';
            } else {
                progress_comment = $(this).find('.progress_comment').val();
            }
            //
            list.push({ 'item_no': $(this).find('.item_no').val(), 'self_progress_comment': self_progress_comment, 'progress_comment': progress_comment });
        });
        data.fiscal_year = $('#fiscal_year').val();
        data.employee_cd = $('#employee_cd_refer').val();
        data.sheet_cd = $('#sheet_cd').val();
        data.progress_comment_self = $('#progress_comment_self').val();
        data.progress_comment_rater = $('#progress_comment_rater').val();
        data.progress_comment_rater_2 = $('#progress_comment_rater_2').val();
        data.progress_comment_rater_3 = $('#progress_comment_rater_3').val();
        data.progress_comment_rater_4 = $('#progress_comment_rater_4').val();
        data.list = list;
        data.mode = mode;
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/master/i2020/comment',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // seccess
                    case OK:
                        jMessage(2, function () {
                            location.reload();
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
        alert('approveComment' + e.message);
    }
}