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
    //back
	$(document).on('click', '#btn-back', function (e) {
		try {
			var home_url = $('#home_url').attr('href');
            _backButtonFunction(home_url);
		} catch (e) {
			alert('#btn-back' + e.message);
		}
	});
    //change fiscal_year
    $(document).on('change', '#fiscal_year', function (e) {
        try {
            var fiscal_year = $('#fiscal_year').val();
            getLeftContent(fiscal_year);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });

    // to screen レビュー入力に
    $(document).on('click', '.btn-to-review-input', function (e) {
        try {
            var employee_cd = $(this).parents('tr').find('.employee_cd').val();
            var detail_no = $(this).parents('tr').find('.detail_no').val();
            var fiscal_year = $('#fiscal_year').val();
            // var html = getHtmlCondition($('.container-fluid'));
            var data = {
                'employee_cd': employee_cd
                , 'fiscal_year': fiscal_year
                , 'detail_no': detail_no
                // , 'html': html
                , 'from': 'mdashboardsupporter'
                // , 'save_cache': 'true'		// save cache status
                , 'screen_id': 'mdashboardsupporter_mi2000'		// save cache status
            };
            //
            _redirectScreen('/multiview/mi2000', data, false);
        } catch (e) {
            alert('.employee_cd_link: ' + e.message);
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
                , 'from': 'mdashboardsupporter'
                // , 'save_cache': 'true'		// save cache status
                , 'screen_id': 'mdashboardsupporter_mq2000'		// save cache status
            };
            //
            _redirectScreen('/multiview/mq2000', data, false);
        } catch (e) {
            alert('.employee_cd_link: ' + e.message);
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
        data.screen_flg = 1;
        // send data to post
        $.ajax({
            type: "POST",
            url: "/multiview/mdashboardsupporter/search",
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
