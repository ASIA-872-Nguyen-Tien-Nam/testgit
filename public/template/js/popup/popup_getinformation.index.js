/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
};
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
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 9) {
                if (e.shiftKey) {
                    if ($(':focus')[0] === $('.collapse a:not([readonly],[disabled],:hidden)').last()[0]) {
                        e.preventDefault();
                        if ($('#ans-collapse a:not([readonly],[disabled],:hidden)').last().length != 0) {
                            $('#ans-collapse a:not([readonly],[disabled],:hidden)').last()[0].focus();
                        }
                        return;
                    }
                } else {
                    if ($(':focus')[0] === $('.collapse a:not([readonly],[disabled],:hidden)').last()[0]) {
                        e.preventDefault();
                        $('.collapse a:not([readonly],[disabled],:hidden)').last().focus();
                    }
                }
            }
        })
        //click  対象シート
        $(document).on('click', '.sheet_cd', function (e) {
            try {
                var data = {
                    'fiscal_year': $(this).attr('fiscal_year'),
                    'employee_cd': $(this).attr('employee_cd'),
                    'sheet_cd': $(this).attr('sheet_cd'),
                    'from': 'information',   // screen from
                    'from_source' : $('#from').val(),
                };
                // setCache(data,'');
                var screen_refer = $(this).attr('screen_refer');
                _redirectScreen(screen_refer,data,true);
            } catch (e) {
                alert('.sheet_cd: ' + e.message);
            }
        });
        //X
        $(document).on('click', '#btn-close-popup', function () {
            parent.$.colorbox.close();
            parent.location.reload();
            parent.$('body').css('overflow','auto');
        });
        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            try {
                $('#btn-close-popup').trigger('click');
                parent.$('body').css('overflow','auto');
            } catch (e) {
                alert('btn-back: ' + e.message);
            }
        });
    } catch (e) {

    }
}