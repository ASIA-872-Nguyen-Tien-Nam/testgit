/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/09/17
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'sheet_cd': { 'type': 'text', 'attr': 'id' },
    'sheet_nm': { 'type': 'text', 'attr': 'id' },
    'sheet_ab_nm': { 'type': 'text', 'attr': 'id' },
    'point_kinds': { 'type': 'select', 'attr': 'id' },
    'point_calculation_typ1': { 'type': 'radiobox', 'attr': 'id', 'name': 'point_calculation_typ1' },
    'point_calculation_typ2': { 'type': 'radiobox', 'attr': 'id', 'name': 'point_calculation_typ2' },
    'evaluation_period': { 'type': 'radiobox', 'attr': 'id' },
    'details_feedback_typ': { 'type': 'checkbox', 'attr': 'id' },
    'comments_feedback_typ': { 'type': 'checkbox', 'attr': 'id' },
    'upload_file_nm': { 'type': 'text', 'attr': 'id' },
    'goal_number': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_1': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_1': { 'type': 'text', 'attr': 'id' },
    'generic_comment_1': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_2': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_2': { 'type': 'text', 'attr': 'id' },
    'generic_comment_2': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_3': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_3': { 'type': 'text', 'attr': 'id' },
    'generic_comment_3': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_4': { 'type': 'select', 'attr': 'id' },
    'generic_comment_title_4': { 'type': 'text', 'attr': 'id' },
    'generic_comment_4': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_5': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_5': { 'type': 'text', 'attr': 'id' },
    'generic_comment_5': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_6': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_6': { 'type': 'text', 'attr': 'id' },
    'generic_comment_6': { 'type': 'text', 'attr': 'id' },
    'generic_comment_display_typ_7': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_7': { 'type': 'text', 'attr': 'id' },
    'generic_comment_7': { 'type': 'text', 'attr': 'id' },

    'generic_comment_display_typ_8': { 'type': 'text', 'attr': 'id' },
    'generic_comment_title_8': { 'type': 'text', 'attr': 'id' },
    'generic_comment_8': { 'type': 'text', 'attr': 'id' },
    // 'item_title_display_typ': { 'type': 'text', 'attr': 'id' },
    'item_title_title': { 'type': 'text', 'attr': 'id' },

    // 'item_display_typ_1': { 'type': 'text', 'attr': 'id' },
    'item_title_1': { 'type': 'text', 'attr': 'id' },
    // 'item_display_typ_2': { 'text': 'text', 'attr': 'id' },
    'item_title_2': { 'type': 'text', 'attr': 'id' },
    // 'item_display_typ_3': { 'type': 'text', 'attr': 'id' },
    'item_title_3': { 'type': 'text', 'attr': 'id' },
    // 'item_display_typ_4': { 'type': 'text', 'attr': 'id' },
    'item_title_4': { 'type': 'text', 'attr': 'id' },
    // 'item_display_typ_5': { 'type': 'text', 'attr': 'id' },
    'item_title_5': { 'type': 'text', 'attr': 'id' },
    'weight_display_typ': { 'type': 'text', 'attr': 'id' },
    'challenge_level_display_typ': { 'type': 'text', 'attr': 'id' },
    // 'detail_progress_comment_display_typ': { 'type': 'text', 'attr': 'id' },
    'progress_comment_display_typ': { 'type': 'text', 'attr': 'id' },
    'evaluation_display_typ': { 'type': 'text', 'attr': 'id' },

    'self_assessment_comment_display_typ1': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ_0': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ_1': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ_2': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ_3': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ_4': { 'type': 'text', 'attr': 'id' },
    'detail_comment_display_typ': { 'type': 'text', 'attr': 'id' },
    'total_score_display_typ': { 'type': 'text', 'attr': 'id' },
    // 'challengelevel_criteria_display_typ': { 'type': 'text', 'attr': 'id' },
    // 'point_criteria_display_typ': { 'type': 'text', 'attr': 'id' },
    // 'self_assessment_comment_display_typ': { 'type': 'text', 'attr': 'id' },
    // 'evaluation_comment_display_typ': { 'type': 'text', 'attr': 'id' },
    'arrange_order': { 'type': 'text', 'attr': 'id' },
    'tr_generic_comment': {
        'attr': 'list', 'item': {
            'item_title': { 'type': 'text', 'attr': 'class' },
        }
    },
    'detail_self_progress_comment_title': { 'type': 'text', 'attr': 'id' },
    'detail_progress_comment_title': { 'type': 'text', 'attr': 'id' },
    'self_progress_comment_title': { 'type': 'text', 'attr': 'id' },
    'progress_comment_title': { 'type': 'text', 'attr': 'id' },
    'evaluation_self_typ': { 'type': 'checkbox', 'attr': 'id' },
};
var _flgLeft = 0;
//
$(document).ready(function () {
    try {
        initialize();
        initEvents();
    } catch (e) {
        alert('ready' + e.message);
    }
});

/**
 * initialize
 *
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        $('#sheet_nm').focus();
        $("input:radio[name=point_calculation_typ1]:first").prop('checked', true);
        $("input:radio[name=point_calculation_typ2]:first").prop('checked', true);
        $("input:radio[name=evaluation_period]:first").prop('checked', true);
        if ($('#upload_file_nm').val() != '') {
            $('#btn-download').removeClass('hidden');
            $('#btn-delete-file').removeClass('hidden');
        }
        //
        _formatTooltip();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {

        $(document).on('change', '#calculation_typ_change2 input', function (e) {
            if($('input[name=point_calculation_typ2]:checked').val() == 1){
                $('#text_total_score_display_typ').text(text_total_points);
            }else{
                $('#text_total_score_display_typ').text(text_average_score);
            }
        });

        $(document).on('change', '#calculation_typ_change1', function (e) {
            if ($('#calculation_typ_change1 input:checked').val() == 1) {
                $('#weight_display_typ_value').val(text_weight);
                $('#text_total_score_display_typ').text(text_total_points);
                $('input:radio[name="point_calculation_typ2"]:first').prop('checked', true);
                $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', true);
            } else {
                $('#weight_display_typ_value').val(text_coefficient);
                $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', false);
                $('input:radio[name="point_calculation_typ2"]').removeAttr('disabled');
            }
        });
        /* paging */
        $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', '#btn-search-key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('change', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('enterKey', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        /* end paging */
        $(document).on('click', '#btn-item-setting', function (e) {
            e.preventDefault();
            showPopup("/master/m0160/popup");
        });
        //
        $(document).on('click', '.ics-edit', function (e) {
            e.preventDefault();
            if ($(this).closest('.ics-wrap-disabled').length < 1) {
                var container = $(this).closest('.d-flex');
                container.find('input').removeAttr('readonly').select();;
            }
        });
        //
        $(document).on('blur', '.ics-textbox input', function () {
            $(this).attr('readonly', 'readonly');
        });
        $(document).on('blur', '#goal_number', function () {
            if ($(this).val() == 0) {
                jMessage(67);
                return;
            }
            if ($(this).val() != '') {
                try {
                    var number_of_row = $(this).val();
                    var sheet_cd = $('#sheet_cd').val();
                    var point_calculation_typ2 = $('input[name=point_calculation_typ2]:checked').val();
                    // send data to post
                    $.ajax({
                        type: 'POST',
                        url: '/master/m0160/listrow',
                        dataType: 'html',
                        loading: true,
                        data: { number_of_row: number_of_row, sheet_cd: sheet_cd, point_calculation_typ2: point_calculation_typ2 },
                        success: function (res) {
                            $('#list_item_table').empty();
                            $('#list_item_table').html(res);
                        }
                    });
                } catch (e) {
                }
            }
        });
        //
        $(document).on('keyup', '.ics-textbox input', function (e) {
            if (e.keyCode == 13) {
                $(this).blur();
            }
        });
        //
        $(document).on('mouseup', function (e) {
            var input = $('.ics-textbox input');
            if (!$(e.target).is(':input')) {
                $('.ics-textbox input').attr('readonly', 'readonly');
            }
        });
        //
        $(document).on('click', '.ics-eye-total', function (e) {
            var th = $(this).closest('th');
            th.find('.display_typ').val(0);
            e.preventDefault();
            $(this).closest('tr').hide();
        });
        //details_feedback_typ
        $(document).on('change', '#details_feedback_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#details_feedback_typ : ' + e.message);
            }
        });
        //comments_feedback_typ
        $(document).on('change', '#comments_feedback_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#comments_feedback_typ : ' + e.message);
            }
        });
        //btn-add-new
        $(document).on('click', '#btn-add-new', function (e) {
            try {
                jMessage(5, function () {
                    //    clearRightContent();
                    location.reload();
                })
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-save
        $(document).on('click', '#btn-save', function (e) {
            _flgLeft = 1;
            var challenge_level_display_typ = $('#challenge_level_display_typ').val();
            var check_challenge_level = $('#check_challenge_level').val();
            if (check_challenge_level == 1 && challenge_level_display_typ == 0) {
                if (_validate($('body'))) {
                    jMessage(72, function (r) {
                        if (r) {
                            saveData();
                        }
                    })
                }

            } else {
                jMessage(1, function (r) {
                    _flgLeft = 1;
                    if (r && _validate($('body'))) {
                        saveData();
                    }
                });
            }
        });
        //
        $(document).on('click', '.ics-eye', function (e) {
            var _this = $(this);
            e.preventDefault();
            var table = $(this).closest('table');
            var th = $(this).closest('th');
            var index = th.index();
            var evaluate_col_index  = $('.evaluate_col').index();
            th.addClass('ics-hide');
            th.hide();
            th.find('.display_typ').val(0);
            table.find('tbody tr td:eq(' + index + ')').hide();
            table.find('tbody tr td:eq(' + index + ')').addClass('ics-hide');
            // 
            var length = $('.w-table1 table thead tr .ics-hide').length;
            if (table.hasClass('tbl1')) {
                // $('.w-table1').css('width', (100 - length * 10) + '%');
            }
            var screen = $(window).width();
            var width_table3 = 50;
            var width_table4 = 75;
            if (screen < 1100) {
                width_table3 = 100
                width_table4 = 100
            }
            // 
            var length3 = $('.w-table3 table thead tr .ics-hide').length;
            $('.w-table3').css('width', (width_table3 - length3 * (width_table3 / 2)) + '%');
            var length4 = $('.w-table4 table thead tr .ics-hide').length;
            $('.w-table4').css('width', (width_table4 - length4 * (width_table4 / 3)) + '%');
            // when has 目標 list
            if (table.hasClass('tabl2')) {
                table.find('tbody tr td').each(function () {
                    if ($(this).index() == index) {
                        $(this).addClass('ics-hide');
                        if (!$(this).hasClass('baffbo')) {
                            $(this).hide();
                        }
                    }
                });
                // total row
                let col_span = 0;
                table.find('thead tr th').each(function(){
                    if(!$(this).hasClass('ics-hide') && $(this).index() < evaluate_col_index){
                        col_span ++;
                    }
                });
                // if col_span = 0 then hide item #td-colspan
                if(col_span == 0){
                    $('#td-colspan').hide();
                }else{
                    $('#td-colspan').attr('colspan', col_span);
                }
                // if index > evaluate_col_index then hide
                if(index > evaluate_col_index){
                    $('.baffbo' + index).hide();
                    $('.baffbo' + index).addClass('ics-hide');
                }
            }
        });
        //btn-show
        $(document).on('click', '#btn-show', function (e) {
            var screen = $(window).width();
            var width_table3 = 50;
            var width_table4 = 75;
            if (screen < 1100) {
                width_table3 = 100
                width_table4 = 100
            }
            $('table thead tr,table tbody tr').each(function () {
                $(this).find('.ics-hide').show();
                $(this).find('.display_typ').val(1);

                $(this).find('.ics-hide').removeClass('d-none').removeClass('ics-hide');
            });
            $('.w-table1').css('width', '100%');
            $('.w-table3').css('width', '' + width_table3 + '%');
            $('.w-table4').css('width', '' + width_table4 + '%');
            $('#td-colspan').attr('colspan', 10);
            $('#td-colspan').show();
            $('#tr-total').show();
            var mql = $(window).width();
            $('.ln-css').removeClass('ln-css');
            $('#table-comment1').css('width', mql<768?'100%':'75%');
        });
        //
        $(document).on('change', '.btn-file :file', function () {
            var input = $(this),
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [label]);
        });
        //
        $(document).on('change', '#upload_file', function () {
            readURL(this);
        });
        //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try {
                jMessage(3, function (r) {
                    _flgLeft = 1;
                    if (r) {
                        deleteData();
                    }
                })
            } catch (e) {
                alert('#btn-delete :' + e.message);
            }
        });
        /* left content click item */
        $(document).on('click', '.list-search-child', function (e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var sheet_cd = $(this).attr('id');
            getRightContent(sheet_cd);
        });
        /* end click item */
        //btn-copy
        $(document).on('click', '#btn-copy', function (e) {
            e.preventDefault();
            $('#sheet_cd').val(0);
            $('#sheet_nm').val('');
            $('#rightcontent .calHe').addClass('has-copy');
            $('#sheet_nm').focus();
            $('.upload_file_nm').text('');
            $('#upload_file_nm').val('');
            $('#file_name').val('');
            $('#file_adress').val('');
            $('#upload_file_old').val('');
        });
        //btn-download
        $(document).on('click', '#btn-download', function () {
            try {
                var file_name = $('#upload_file_nm').val();
                var file_adress = $('#file_adress').val();
                if (file_name != '') {
                    downloadfileHTML(file_adress, file_name, function () {
                        // deleteFile(file_adress);
                    });
                } else {
                    jMessage(21); return;
                }
            } catch (e) {
                alert('#btn-download' + e.message);
            }
        });
        //btn-delete-file
        $(document).on('click', '#btn-delete-file', function () {
            try {
                $('#upload_file_nm').val('');
                $('.upload_file_nm').text('');
                $('#file_name').val('');
                $("#upload_file_old").val('');
            } catch (e) {
                alert('#btn-delete-file' + e.message);
            }
        });
        $(document).on('change', '#upload_file', function () {
            var file = readURL(this);
            $("#file_name").val(file['name']);
        });

        $(document).on('click', '.face-file-btn', function () {
            $("#upload_file").trigger("click");
        });

        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            // window.location.href = '/dashboard'
            if (_validateDomain(window.location)) {
                window.location.href = '/dashboard';
            } else {
                jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
            }
        });

        $(document).on('click','.ics-eye2',function(e) {
            var index = $(this).closest('th').index() + 1;
           
            $(this).closest('table').find('td:nth-child('+index+')').addClass('ics-hide d-none');
            $(this).closest('th').addClass('ics-hide d-none');
            if ( $(this).closest('table').hasClass('calc') ) {
                var mql = $(window).width();
                if ( mql<768 ) {
                    $(this).closest('table')
                        .css('width', $(this).closest('table').find('th:not(.ics-hide)').length*33.33+'%');
                }
                else {
                    $(this).closest('table')
                        .css('width', $(this).closest('table').find('th:not(.ics-hide)').length*25+'%');
                }
            }
            $('.ln-css').removeClass('ln-css');
            $(this).closest('table').find('th').not('.d-none').first().addClass('ln-css');
        });

    } catch (e) {
        alert('initEvents:' + e.message);
    }
}
/**
 * getLeftContent
 *
 * @author      :   SonDH - 2018/08/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/m0160/leftcontent',
            dataType: 'html',
            loading: true,
            data: { current_page: page, search_key: search },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    var sheet_cd = $('#sheet_cd').val();
                    $('.list-search-content div[id="' + sheet_cd + '"]').addClass('active');
                    if (_flgLeft != 1) {
                        $('#search_key').focus();
                    } else {
                        _flgLeft = 0;
                    }
                    $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
                    //
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}
/**
 *    getRightContent
 *
 * @author      :   SonDH - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(sheet_cd) {
    try {
        // send data to post
        var screen = $(window).width();
        var width_table3 = 50;
        var width_table4 = 75;
        if (screen < 1100) {
            width_table3 = 100
            width_table4 = 100
        }
        $.ajax({
            type: 'POST',
            url: '/master/m0160/rightcontent',
            dataType: 'html',
            loading: true,
            data: {
                'sheet_cd': sheet_cd,
                'width_table3': width_table3,
                'width_table4': width_table4
            },
            success: function (res) {
                $('#right-respon').empty();
                $('#right-respon').append(res);
                $('#sheet_nm').focus();
                $('#sheet_nm').removeClass('boder-error');
                $('#sheet_nm').next('.textbox-error').remove();
                $('#sheet_nm').focus();
                $('#rightcontent .calHe').removeClass('has-copy');
                $.formatInput();
                if ($('#upload_file_nm').val() != '') {
                    $('#btn-download').removeClass('hidden');
                    $('#btn-delete-file').removeClass('hidden');
                } else {
                    $('#btn-download').addClass('hidden');
                    $('#btn-delete-file').addClass('hidden');
                }
                // set width table-comment1
                var mql = $(window).width();
                if ( mql < 768 ) {
                    $('#table-comment1').css(
                        'width',
                        $('#table-comment1').find('th:not(.ics-hide)').length*33.33+'%'
                    );
                }
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * saveData
 *
 * @author      :   sondh - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveData() {
    var data = getData(_obj);
    if ($('#file_adress').val() != undefined) {
        data.data_sql.file_adress = $('#file_adress').val();
    } else {
        data.data_sql.file_adress = '';
    }
    data.data_sql.upload_file_old = $('#upload_file_old').val();
    data.data_sql.evaluation_self_typ = $('#evaluation_self_typ').is(':checked') ? 1 : 0;
    data.data_sql.detail_self_progress_comment_display_typ = $('#detail_self_progress_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.detail_progress_comment_display_typ = $('#detail_progress_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.self_progress_comment_display_typ = $('#self_progress_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.progress_comment_display_typ = $('#progress_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.progress_comment_title = $('#progress_comment_title').val();
    data.data_sql.challengelevel_criteria_display_typ = $('#challengelevel_criteria_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.point_criteria_display_typ = $('#point_criteria_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.self_assessment_comment_display_typ = $('#self_assessment_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.evaluation_comment_display_typ = $('#evaluation_comment_display_typ').hasClass('ics-hide') ? 0 : 1;
    //
    data.data_sql.item_title_display_typ = $('#item_title_display_typ').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.item_display_typ_1 = $('#item_display_typ_1').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.item_display_typ_2 = $('#item_display_typ_2').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.item_display_typ_3 = $('#item_display_typ_3').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.item_display_typ_4 = $('#item_display_typ_4').hasClass('ics-hide') ? 0 : 1;
    data.data_sql.item_display_typ_5 = $('#item_display_typ_5').hasClass('ics-hide') ? 0 : 1;

    var formData = new FormData();
    formData.append('head', JSON.stringify(data));
    formData.append('file', $('#upload_file')[0].files[0]);
    // send data to post
    $.ajax({
        type: 'post',
        data: formData,
        url: '/master/m0160/save',
        loading: true,
        processData: false,
        contentType: false,
        enctype: "multipart/form-data",
        success: function (res) {
            $('#rightcontent .calHe').removeClass('has-copy');
            switch (res['status']) {
                // success
                case OK:
                    jMessage(2, function (r) {
                        clearRightContent();
                        // 
                        location.reload();
                        // var page = $('#leftcontent').find('.active a').attr('page');
                        // var search = $('#search_key').val();
                        // getLeftContent(page, search);
                    });
                    break;
                // error
                case NG:
                    if (typeof res['errors'] != 'undefined') {
                        processError(res['errors']);
                    }
                    break;
                // Exception
                case 405:
                    jMessage(27, function () {
                    });
                    break;
                // Exception
                case EX:
                    jError(res['Exception']);
                    break;
                default:
                    break;
            }
        }
    })
}
/**
 * delete
 *
 * @author      :   SonDH - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.sheet_cd = $('#sheet_cd').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/m0160/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            location.reload();
                            //
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#sheet_nm').focus();
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
        alert('save' + e.message);
    }
}
/**
 * readURL
 *
 * @author      :   sondh - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.readAsDataURL(input.files[0]);
    }
    return input.files[0];
}
//
if (matchMedia) {
    const mq = window.matchMedia("(max-width: 1366px)");
    mq.addListener(WidthChange);
    WidthChange(mq);
}
// media query change
function WidthChange(mq) {
    if (mq.matches) {
        $('.w-table4 .par').removeClass("d-flex");
        $('.w-table4 .par').css({ "position": "relative", "top": "0px", "left": "0px" });
        $('.w-table4 .chil').css({ "position": "absolute", "top": "0px", "left": "107px" });
    } else {
        // window width is less than 500px
    }
}
//clear data right_content
function clearRightContent() {
    try {
        $('#rightcontent .calHe').removeClass('has-copy');
        $('#sheet_nm').focus();
        $('#sheet_cd').val(0);
        $('#sheet_nm, #sheet_ab_nm, #goal_number, #arrange_order').val('');
        $('#sheet_nm').removeClass('boder-error');
        $('#sheet_nm').next('.textbox-error').remove();
        $('#point_kinds').removeClass('boder-error');
        $('#point_kinds').next('.textbox-error').remove();
        $('input:radio[name="point_calculation_typ1"]:first').prop('checked', true);
        $('input:radio[name="point_calculation_typ2"]:first').prop('checked', true);
        $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', true);
        $('input:radio[name="evaluation_period"]:first').prop('checked', true);
        $('#upload_file').val('');
        $('.upload_file_nm').text('');
        $('#file_name').val('');
        $('input[type=checkbox]').prop('checked', false);
        $('#btn-show').trigger('click');
        $('select').val('-1');
        $('.list-search-child').removeClass('active');
        $('#btn-download').addClass('hidden');
        $('#btn-delete-file').addClass('hidden');
        //
        $('#generic_comment_title_1').val('会社用汎用コメント①');
        $('#generic_comment_title_2').val('会社用汎用コメント②');
        $('#generic_comment_title_3').val('評価者用汎用コメント①');
        $('#generic_comment_title_4').val('評価者用汎用コメント②');
        $('#generic_comment_title_5').val('本人用汎用コメント①');
        $('#generic_comment_title_6').val('本人用汎用コメント②');
        $('#generic_comment_title_7').val('本人用汎用コメント③');
        $('#generic_comment_title_8').val('会社用汎用コメント③');
        //
        $('#generic_comment_1').val('');
        $('#generic_comment_2').val('');
        $('#generic_comment_8').val('');
        $('.item_title').val('');
        //
        $('#item_title_title').val('目標タイトル');
        $('#item_title_1').val('目標タイトル１');
        $('#item_title_2').val('目標タイトル２');
        $('#item_title_3').val('目標タイトル３');
        $('#item_title_4').val('目標タイトル４');
        $('#item_title_5').val('目標タイトル５');
    } catch (e) {
        alert('clearRightContent: ' + e.message);
    }

}