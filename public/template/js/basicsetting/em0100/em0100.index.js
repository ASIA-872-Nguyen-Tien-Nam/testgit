/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日            :    2018/08/28
 * 作成者            :    SonDH – sondh@ans-asia.com
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
 * @author    : SonDH - 2018/08/27 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try {
        $('.check-all-title-0').focus();
        setCheckBox('#table-em', '.check_all-0', '.chk-item-0');
        setCheckBox('#table-em', '.check_all-1', '.chk-item-1');
        setCheckBox('#table-em', '.check_all-2', '.chk-item-2');
        setCheckBox('#table-em', '.check_all-3', '.chk-item-3');
        setCheckBox('#table-em', '.check_all-4', '.chk-item-4');
        setCheckBox('#table-em', '.check_all-5', '.chk-item-5');
        setCheckBox('#table-em', '.check_all-6', '.chk-item-6');
        setCheckBox('#table-em', '.check_all-7', '.chk-item-7');
        setCheckBox('#table-em', '.check_all-8', '.chk-item-8');
        setCheckBox('#table-em', '.check_all-9', '.chk-item-9');
        setCheckBox('#table-em', '.check_all-10', '.chk-item-10');
        setCheckBox('#table-em', '.check_all-11', '.chk-item-11');
        setCheckBox('#table-em', '.check_all-12', '.chk-item-12');
        setCheckBox('#table-em', '.check_all-13', '.chk-item-13');
        setCheckBox('#table-em', '.check_all-14', '.chk-item-14');
        setCheckBox('#table-em', '.check_all-15', '.chk-item-15');
        setCheckBox('#table-em', '.check_all-16', '.chk-item-16');
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author    : SonDH - 2018/08/27 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
    try {            
        $(document).on('click', '#btn-back', function (e) {
			try {
				// window.location.href = '/dashboard'
				if (_validateDomain(window.location)) {
					window.location.href = 'edashboard';
				} else {
					jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
				}
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
        //   //checkbox_all
        $(document).on('change', '.check_all', function () {
            try {
                id = $(this).attr('id').split('-')['3'];
                if ($(this).is(':checked') == true && $(this).prop('checked')) {
                    $('.check_all-' + id).prop('disabled', false);
                    $('.chk-item-' + id).prop('disabled', false);
                }
                else {
                    $('.check_all-' + id).prop('disabled', true);
                    $('.chk-item-' + id).prop('disabled', true);
                }
            } catch (e) {
                alert('.btn-check-all' + e.message)
            }
        })

    } catch (e) {
        alert('initEvents' + e.message);
    }
}


function setCheckBox(table, check_all, check_box) {
    // var checked = $(check_box + ':checked').length;
    // var total_chk = $(check_box).not(":disabled").length;
    // $(check_all).prop('checked', false);
    // if (total_chk == checked) {
    //     $(check_all).prop('checked', true);
    // } else {
    //     $(check_all).prop('checked', false);
    // }

    //checkbox_all
    $(document).on('change', check_all, function () {
        try {
            if ($(check_all).is(':checked') == true && $(check_all).prop('checked')) {
                $(check_box).not(":disabled").prop('checked', true);
            }
            else {
                $(check_box).not($(check_all)).prop('checked', false);
            }
        } catch (e) {
            alert('.btn-check-all' + e.message)
        }
    })
    //checkbox_input
    $(document).on('change', check_box, function (e) {
        try {
            var checked = $(check_box + ':checked').length;
            var total_chk = $(check_box).not(":disabled").length;
            $(check_all).prop('checked', false);
            if (total_chk == checked) {
                $(check_all).prop('checked', true);
            } else {
                $(check_all).prop('checked', false);
            }
        } catch (e) {
            alert('checkbox_input: ' + e.message);
        }
    });
}