/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {

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
        // $('body .form-control:not([readonly]):not([disabled]):not(".hidden"):first').focus();
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
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 9) {
                if (e.shiftKey) {
                    if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
                        e.preventDefault();
                        if ($('.lth a:not([readonly],[disabled],:hidden)').last().length != 0) {
                            $('.lth a:not([readonly],[disabled],:hidden)').last()[0].focus();
                        }
                        if ($('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length > 0) {
                            e.preventDefault();
                            $('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0].focus();
                        }
                        return;
                    }
                } else {
                    if ($('.lth a:not([readonly],[disabled],:hidden)').last().length > 0) {
                        if ($(':focus')[0] === $('.lth a:not([readonly],[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
                        }
                    } else if ($('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length > 0) {
                        if ($(':focus')[0] === $('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0].focus();
                        }
                    } else {
                        if ($(':focus')[0] === $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0].focus();
                        }
                    }

                }
            }
        });
        //evaluator
        $(document).on('click', '.list_status', function () {
            try {
                // var data = {
                //     'fiscal_year': $(this).attr('fiscal_year')
                //     , 'employee_cd': $(this).attr('employee_cd')
                //     , 'sheet_cd': $(this).attr('sheet_cd')
                //     , 'screen_id': 'evaluator'
                //     , 'screen_from2': $('#screen_from2').val()
                // };
                // var screen_refer = $(this).attr('screen_refer');
                // setCache(data, screen_refer + '?from=evaluator');
                var data = {
                    'fiscal_year': $(this).attr('fiscal_year'),
                    'employee_cd': $(this).attr('employee_cd'),
                    'sheet_cd': $(this).attr('sheet_cd'),
                    'from': 'evaluator',   // screen from
                };
                var screen_refer = $(this).attr('screen_refer');
                _redirectScreen(screen_refer,data,true);
            } catch (e) {
                alert('.btn_employee_cd_popup' + e.message);
            }
        });

        //evaluator
        $(document).on('change', '#list_fiscal_year', function () {
            try {
                var fiscal_year = $('#list_fiscal_year').val();
                // alert(fiscal_year);
                if (fiscal_year != '') {
                    refer(fiscal_year);
                }

            } catch (e) {
                alert('.btn_employee_cd_popup' + e.message);
            }
        });
        // btn_employee_cd_popup
        $(document).on('click', '.list_infomation', function () {
            try {
                var data = {
                    'company_cd': $(this).attr('company_cd')
                    , 'category': $(this).attr('category')
                    , 'status_cd': $(this).attr('status_cd')
                    , 'infomationn_typ': $(this).attr('infomationn_typ')
                    , 'infomation_date': $(this).attr('infomation_date')
                    , 'target_employee_cd': $(this).attr('target_employee_cd')
                    , 'sheet_cd': $(this).attr('sheet_cd')
                    , 'employee_cd': $(this).attr('employee_cd')
                    , 'fiscal_year': $(this).attr('fiscal_year')
                };
                showPopup("/common/popup/getinformation?" + setGetPrams(data), {}, function () {
                });
            } catch (e) {
                alert('.list_infomation' + e.message);
            }
        });
        $(document).on('click', '#btn-back', function (e) {
            try {
                var home_url = $('#home_url').attr('href');
                var urlObject = new URL(home_url);
                if (!_validateDomain(window.location, urlObject.pathname)) {
                    jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
                } else {
                    window.location.href = home_url;
                }
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
    } catch (e) {

    }
}
/**
 * refer
 * 
 * @author      :   longvv
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function refer(fiscal_year) {
    $.ajax({
        type: 'post',
        url: '/master/portal/evaluatorrefer',
        dataType: 'html',
        data: { 'fiscal_year': fiscal_year },
        loading: true,
        success: function (res) {
            $('#div_result').empty();
            $('#div_result').html(res);
            $('#list_fiscal_year').focus();
        },
        error: function (xhr) {
            jError('エラー', xhr.statusText);
        }
    });
}