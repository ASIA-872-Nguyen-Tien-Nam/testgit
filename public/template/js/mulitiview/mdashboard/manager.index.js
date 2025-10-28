/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日            :    2020/11/13
 * 作成者            :    datnt –
 *
 * @package        :    MODULE MASTER
 * @copyright        :    Copyright (c) ANS-ASIA
 * @version        :    1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year': { 'type': 'select', 'attr': 'id' }
};
$(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
});
/**
 * initialize
 *
 * @author    : datnt - 2020/11/17 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try {
        $('#fiscal_year').focus();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author    : datnt - 2020/11/17 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
    //change fiscal_year
    $(document).on('change', '#fiscal_year', function (e) {
        try {
            var fiscal_year = $('#fiscal_year').val();
            getLeftContent(fiscal_year);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });
    //  
    $(document).on('click', '#btn-confirm', function () {
        try {
            var confirm_flg = 1;
            jMessage(61, function (r) {
                saveData(confirm_flg);
            });
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });
    //
    $(document).on('click', '#btn-unconfirm', function () {
        try {
            var confirm_flg = 0;
            jMessage(43, function (r) {
                saveData(confirm_flg);
            });
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });
    // to screen レビュー一覧
    $(document).on('click', '.btn-to-review-list', function (e) {
        try {
            var employee_cd = $(this).parents('tr').find('.employee_cd').val();
            var fiscal_year = $('#fiscal_year').val();
            // var html = getHtmlCondition($('.container-fluid'));
            var data = {
                'employee_cd': employee_cd
                , 'fiscal_year': fiscal_year
                // , 'html': html
                , 'from': 'mdashboard'
                // , 'save_cache': 'true'		// save cache status
                , 'screen_id': 'mdashboard_mq2000'		// save cache status
            };
            //
            _redirectScreen('/multiview/mq2000', data, false);
        } catch (e) {
            alert('.employee_cd_link: ' + e.message);
        }
    });
    // to screen レビュー入力に
    $(document).on('click', '.btn-to-supporter', function () {
        try {
            location.href = 'mdashboardsupporter';
        } catch (e) {
            alert('#btn-to-supporter' + e.message);
        }
    });
}
/**
 * getLeftContent
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(fiscal_year) {
    try {
        data = {};
        data.fiscal_year = fiscal_year;
        data.screen_flg = 0;
        // send data to post
        $.ajax({
            type: "POST",
            url: "/multiview/mdashboard/search",
            dataType: "html",
            data: data,
            loading: true,
            success: function (res) {
                $("#result").empty();
                $("#result").append(res);
                jQuery.formatInput();
                app.jTableFixedHeader();
                app.jSticky();
            },
        });
    } catch (e) {
        alert("search" + e.message);
    }
}
/**
 * save
 *
 * @author      :   DUONGNTT - 2021/01/12 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData(confirm_flg) {
    try {
        var data = getData(_obj);
        data.data_sql.confirm_flg = confirm_flg;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/multiview/mdashboard/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var fiscal_year = $('#fiscal_year').val();
                        if (confirm_flg == 1) {
                            jMessage(62, function (r) {
                                getLeftContent(fiscal_year);
                            });
                        } else if (confirm_flg == 0) {
                            jMessage(44, function (r) {
                                getLeftContent(fiscal_year);
                            });
                        }
                        break;
                    // error
                    case NG:
                        if (typeof res["errors"] != "undefined") {
                            processError(res["errors"]);
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res["Exception"]);
                        break;
                    case 999:
                        processError(res['errors']);
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
