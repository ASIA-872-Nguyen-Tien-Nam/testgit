$(document).ready(function () {
    try {
        initializeReject();
        initEventsReject();
    }
    catch (e) {
        alert('ready' + e.message);
    }
});

/**
 * initialize
 *
 * @author		:	viettd - 2023/06/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initializeReject() {
    try {

    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * initEventsReject
 * @author		:	viettd -2023/06/14- create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEventsReject() {
    try {
        $(document).on("click", "#btn_reject_save", function () {
            try {
                jMessage(41, function (r) {
                    if (r && _validate()) {
                        reject();
                    }
                });
            } catch (e) {
                alert('#btn_reject_save: ' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
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
        data.fiscal_year = parent.$('#fiscal_year').val() != '' ? parseInt(parent.$('#fiscal_year').val()) : 0;
        data.employee_cd = parent.$('#employee_cd').val();
        data.report_kind = parent.$('#report_kind').val() != '' ? parseInt(parent.$('#report_kind').val()) : 0;
        data.report_no = parent.$('#report_no').val() != '' ? parseInt(parent.$('#report_no').val()) : 0;
        data.reject_comment = $('#reject_comment').val();
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
                                $('#btn-close-popup').click();
                                parent.location.reload();
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