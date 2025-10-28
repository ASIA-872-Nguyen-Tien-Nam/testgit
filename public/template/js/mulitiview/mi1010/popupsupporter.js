/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2018/07/03
 * 作成者    : longvv - longvv@ans-asia.com 
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
    'list_browsing': {
        'attr': 'list', 'item': {
            'browsing_kbn': { 'type': 'checkbox', 'attr': 'class' },
            'position_cd': { 'type': 'text', 'attr': 'class' },
        }
    }
}

$(document).ready(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});
function initialize() {
    try {
        $('.check-level-1.browsing_kbn_1').focus();
        if ($('input[type="checkbox"].check-level-1.browsing_kbn_3').is(':checked')) {
            $('.li-lv3').parents('.browsing_position_list').removeClass('hidden');
        } else {
            $('.li-lv3').parents('.browsing_position_list').addClass('hidden');
        }
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * INIT EVENTS
 */
function initEvents() {
    try {
        //checkmark
        $(document).on('click', '.checkmark', function () {
            var _this = $(this);
            if (_this.hasClass('ck_1')) {
                if (!_this.parents('.md-checkbox-v2').find('.check-level-1').is(':checked')) {
                    $('.cb_checked').removeClass('cb_checked');
                    _this.addClass('cb_checked');
                    _this.parents('.md-checkbox-v2').find('.check-level-1').val(1);
                    $('.checkmark').each(function () {
                        if (!$(this).hasClass('cb_checked')) {
                            var cb_input = $(this).parents('.md-checkbox-v2').find('.check-level-1');
                            cb_input.val(0);
                            cb_input.prop('checked', false);
                        }
                    });
                } else {
                    _this.removeClass('cb_checked');
                    _this.parents('.md-checkbox-v2').find('.check-level-1').val(0);
                }
                var browsing_kbn_3 = $('input[type="checkbox"].check-level-1.browsing_kbn_3').val();
                if (browsing_kbn_3 == 1) {
                    $('.li-lv3').parents('.browsing_position_list').removeClass('hidden');
                } else {
                    $('.li-lv3').parents('.browsing_position_list').addClass('hidden');
                }
            } else if (_this.hasClass('ck_3')) {
                if (!_this.parents('.md-checkbox-v2').find('.check-level-3').is(':checked')) {
                    _this.parents('.md-checkbox-v2').find('.check-level-3').val(1);
                } else {
                    _this.parents('.md-checkbox-v2').find('.check-level-3').val(0);
                }
                var cnt_checked = 0;
                $('.browsing_position_list').find('.check-level-3').each(function (j, row_tr) {
                    var $row = $(row_tr);
                    if ($row.val() == 1) {
                        cnt_checked = cnt_checked + 1;
                    }
                });
                if (cnt_checked == 0) {
                    $('input[type="checkbox"].check-level-1.browsing_kbn_3').prop('checked', false);
                    $('input[type="checkbox"].check-level-1.browsing_kbn_3').val(0);
                } else {
                    $('input[type="checkbox"].check-level-1.browsing_kbn_3').prop('checked', true);
                    $('input[type="checkbox"].check-level-1.browsing_kbn_3').val(1);
                }
            }
        });
        $(document).on('click', '.check-for-lbl', function () {
            try {
                $(this).parents('tr').find('.checkmark').trigger("click");
            } catch (e) {
                alert('check: ' + e.message);
            }
        });
        //btn-save-popup
        $(document).on('click', '#btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    saveData();
                });
            } catch (e) {
                alert('btn-save: ' + e.message);
            }
        });

    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * SAVE
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);
        $.ajax({
            type: 'POST',
            url: '/multiview/mi1010/save-popup',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            parent.$('.main-mlayout').find("#btn_reload").trigger("click");
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
