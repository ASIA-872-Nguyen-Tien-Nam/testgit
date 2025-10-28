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
var _obj = {
    'fiscal_year': { 'type': 'text', 'attr': 'id' },
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'status_cd': { 'type': 'text', 'attr': 'id' },
    'evaluation_step': { 'type': 'text', 'attr': 'id' },
    'tr_status': {
        'attr': 'list', 'item': {
            'fiscal_year': { 'type': 'text', 'attr': 'class' },
            'employee_cd': { 'type': 'text', 'attr': 'class' },
            'status_nm': { 'type': 'text', 'attr': 'class' },
            'interview_no': { 'type': 'text', 'attr': 'class' },
            'period_detail_no': { 'type': 'text', 'attr': 'class' },
            'interview_date': { 'type': 'text', 'attr': 'class' },
            'interview_comment_self': { 'type': 'text', 'attr': 'class' },
            'interview_comment_rater': { 'type': 'text', 'attr': 'class' },
            'interview_comment_rater2': { 'type': 'text', 'attr': 'class' },
            'interview_comment_rater3': { 'type': 'text', 'attr': 'class' },
            'interview_comment_rater4': { 'type': 'text', 'attr': 'class' },
            'sheet_cd': { 'type': 'text', 'attr': 'class' },
        }
    }
};
$(function () {
    initEvents();
    initialize();
    //calcTable();
});

/**
 * initialize
 *
 * @author		:	sondh - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        jQuery.initTabindex();
        $('#table-data').find('tbody tr td .form-control[value=""]:not([type="hidden"]):not([readonly]):not([disabled]):first').focus();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/09/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {

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

            } else {
                if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last()[0]) {
                    e.preventDefault();
                    $(":input:not([readonly],[disabled],:hidden)").first()[0].focus();
                }
            }
        }
    });
    //btn-back
    $(document).on('click', '#btn-back', function () {
        try {
            var from = $('#from').val();
            var data = {
                'fiscal_year': $('#fiscal_year').val(),
                'employee_cd': $('#employee_cd').val(),
                'sheet_cd': $('#sheet_cd').val(),
                'from': $('#from_source').val(),
            }
            if (from == 'i2010') {
                _redirectScreen('/master/i2010', data);
            } else if (from == 'i2020') {
                _redirectScreen('/master/i2020', data);
            } else {
                jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
            }
        } catch (e) {
            alert('#btn-back: ' + e.message);
        }
    });
    //btn-save
    $(document).on('click', '#btn-save', function (e) {
        jMessage(1, function (r) {
            if (r && _validateI2030()) {
                saveData();
            }
        });
    });
    // change comment 本人コメント + 一次評価者コメント
    $(document).on('change', '.interview_comment_self,.interview_comment_rater', function () {
        try {
            var tr = $(this).closest('tr');
            // if not 1.期首面談 and 　12.フィードバック面談
            if (!tr.find('.interview_date').hasClass('begin_fb_interview')) {
                if ($(this).val() != '') {
                    tr.find('.interview_date').addClass('required');
                } else {
                    tr.find('.interview_date').removeClass('required');
                }
            }
        } catch (e) {
            alert('interview_comment_self,interview_comment_rater change event : ' + e.message);
        }
    });
}
/**
 * save
 * 
 * @author      :   longvv - 2018/09/06 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function saveData() {
    try {
        var data = getData(_obj);
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/i2030/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            // do something
                            // location.reload();
                            // $('#table-data tbody tr:first td:first-child input').focus();
                            $('#btn-back').trigger('click');
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
 * _validateI2030
 * 
 * @return : true/false
 */
function _validateI2030() {
    var error = 0;
    try {
        _clearErrors(1);
        // validate required
        var msg = _text[8].message;
        $('.interview_date:enabled').each(function () {
            if ($(this).is(':visible') && $(this).hasClass('required') && $(this).val() == '') {
                $(this).closest('.gflex').errorStyle(msg, 1);
                error++;
            }
        });
        // return
        if (error > 0) {
            return false;
        } else {
            return true;
        }
    } catch (e) {
        alert('_validateI2030: ' + e.toString());
    }
}