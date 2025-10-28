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
    'list_check_display': {
        attr: "list",
        item: {
            item_cd: { type: "text", attr: "class" },
            order_no: { type: "text", attr: "class" },
            display_kbn: { type: "checkbox", attr: "class" },
        },
    }
},
    index = 0;

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
        $('#ckb_all').focus();
        _setTabIndex();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * INIT EVENTS
 */
function initEvents() {
    try {
        //check all popup item_setting
        $(document).on('click', '#ckb_all', function () {
            if ($(this).is(':checked')) {
                $('input[type="checkbox"].checkbox_row').prop('checked', true);
                $('input[type="checkbox"].checkbox_row').val(1);
            }
            else {
                $('input[type="checkbox"].checkbox_row').prop('checked', false);
                $('input[type="checkbox"].checkbox_row').val(0);
            }
        });
        //check all popup item_setting
        $(document).on('click', 'input[type="checkbox"].checkbox_row', function () {
            var slt = 'input[type="checkbox"].checkbox_row';
            if ($(this).is(':checked')) {
                $(this).val(1);
            }
            else {
                $(this).val(0);
            }
            if ($(slt + ':checked').length === $(slt).length) {
                $('#ckb_all').prop('checked', true);
            }
            else {
                $('#ckb_all').prop('checked', false);
            }
        });

        //btn-save-popup
        $(document).on('click', '#btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    saveData();
                });
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });

        //

        $(document).on('click', '.pop_tr ', function () {
            try {
                $('.tr_selected').removeClass('tr_selected');
                index = $(this).index();
                $(this).addClass('tr_selected');
            } catch (e) {
                alert('#btn-back: ' + e.message);
            }
        });
        //
        $(document).on('click', '#move_up', function () {
            upNdown('up');
        })
        //
        $(document).on('click', '#move_down', function () {
            upNdown('down');
        })
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
            url: '/oneonone/oq2010/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            $("#btn-close-popup").trigger("click");
                            var group_cd = $('#group_cd_1on1').val();
                            if (group_cd != -1) {
                                parent.$('body').css('overflow', 'auto');
                                parent.$('.main-oneonone').find("#btn_search").trigger("click");
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
        alert('save' + e.message);
    }
}
function upNdown(direction) {
    var rows = document.getElementById("table_popup").rows,
        parent = rows[index].parentNode;
    if (direction === "up") {
        if (index > 1 && ($('.tr_checkall')[0] != rows[index])) {
            parent.insertBefore(rows[index], rows[index - 1]);
            // when the row go up the index will be equal to index - 1
            index--;
        }
    }
    if (direction === "down" && ($('.tr_checkall')[0] != rows[index])) {
        if (index < rows.length - 1) {
            parent.insertBefore(rows[index + 1], rows[index]);
            // when the row go down the index will be equal to index + 1
            index++;
        }
    }

}
function _setTabIndex() {
    try {
        $('#btn-save').attr('tabindex', 2);
    } catch (e) {
        alert('setTabIndex: ' + e.message);
    }
}