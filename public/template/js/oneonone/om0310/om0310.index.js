/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   mirai – mirai@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'data_group': {
        'attr': 'list', 'item': {
            '1on1_group_cd': { 'type': 'text', 'attr': 'class' }
            , 'coach_position_cd': { 'type': 'select', 'attr': 'class' }
            , 'frequency': { 'type': 'select', 'attr': 'class' }
            , 'times_interview': { 'type': 'text', 'attr': 'class' }
            , 'interview_cd': { 'type': 'select', 'attr': 'class' }
        }
    }
};
//
$(document).ready(function () {
    try {
        initialize();
        initEvents();
    }
    catch (e) {
        alert('ready' + e.message);
    }
});
/**
 * initialize
 *
 * @author      :   mirai - 2020-09-08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try {
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2020-09-08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    try {
        // click 評価シート
        $(document).on('change', '.select-frequency', function (e) {
            try {
                var check_value = $(this).val();
                if (check_value == 4) {
                    $(this).closest('td').find('.times_other').removeClass('dis_none');
                    $(this).closest('td').find('.div_frequency_nm').removeClass('dis_none');
                }
                else {
                    $(this).closest('td').find('.times_other').addClass('dis_none');
                    $(this).closest('td').find('.div_frequency_nm').addClass('dis_none');
                }
            } catch (e) {
                alert('open video: ' + e.message);
            }
        });

        //save
        $(document).on('click', '.btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    if (r && _validate($('#table-data'))) {
                        saveData();
                    } else {
                        error();
                    }
                });
            } catch (e) {
                alert('.btn-save: ' + e.message);
            }
        });

        //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try {
                jMessage(3, function (r) {
                    _flgLeft = 1;
                    if (r) {
                        deleteData();
                    }
                });
            } catch (e) {
                alert('#btn-delete :' + e.message);
            }
        });

        $(document).on('change', '.times_interview', function (e) {
            try {
                var times_value = $(this).val();
                if ((times_value == 0) || (times_value > 365)) {
                    $(this).val('');
                }
            } catch (e) {
                alert('open video: ' + e.message);
            }
        });
        $(document).on('keyup', '.times_interview', function (e) {
            try {
                $(this).closest('td').find('.div_blank').remove();
                $(this).parents('td').find('.div_frequency_nm').css("margin", "10px");
            } catch (e) {
                alert('open video: ' + e.message);
            }
        });

        //btn back
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });

    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * save
 *
 * @author      :   duongntt - 2020/11/06 - create
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
            url: '/oneonone/om0310/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            getContent();
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
 * delete
 *
 * @author      :   duongntt - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0310/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(4, function () {
                            $('.coach_position_cd').val('-1');
                            $('.select-frequency').val('1');
                            $('.interview_cd').val('-1');
                            $('.times_other').addClass('dis_none');
                            $('.div_frequency_nm').addClass('dis_none');
                            $('.times_interview').val('');
                            $("#table-data tbody tr:first td").find('.coach_position_cd').focus();
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
        alert('delete' + e.message);
    }
}
/**
 * getContent
 *
 * @author      :   duongntt - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getContent() {
    try {
        var data = {};
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0310/content',
            dataType: 'html',
            data: data,
            success: function (res) {
                $('result').empty();
                $('result').append(res);
                $("#table-data tbody tr:first td").find('.coach_position_cd').focus();
                $.formatInput();
                app.jTableFixedHeader();
            }
        });
    } catch (e) {
        alert('get content: ' + e.message);
    }
}
/**
 * error function
 *
 * @author      :   duongntt - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function error() {
    $('.textbox-error').each(function () {
        if ($(this).parents('td').find('.frequency').length > 0) {
            $(this).parents('td').find('.div_frequency').append('<div class="div_blank">	&nbsp;</div>');
            $(this).parents('td').find('.div_frequency_nm').append('<div class="div_blank">	&nbsp;</div>');
            $(this).parents('td').find('.div_frequency_nm').css("margin-left", "-42px");
        }
    });
}





