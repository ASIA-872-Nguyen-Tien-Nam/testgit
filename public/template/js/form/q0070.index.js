/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   datnt – datnt@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'employee_name': { 'type': 'text', 'attr': 'id' },
    'employee_typ': { 'type': 'text', 'attr': 'id' },
    'position_cd': { 'type': 'text', 'attr': 'id' },
    'grade': { 'type': 'text', 'attr': 'id' },
    'company_out_dt_flg': { 'type': 'checkbox', 'attr': 'id' },
    'fiscal_year': { 'type': 'text', 'attr': 'id' },
    'group_cd': { 'type': 'text', 'attr': 'id' },
    'ck_search': { 'type': 'text', 'attr': 'id' },
    'tr_employee': {
        'attr': 'list', 'item': {
            'checker': { 'type': 'checkbox', 'attr': 'class' },
            'tb_employee_cd': { 'type': 'text', 'attr': 'class' },
        },
    },

};
var _obj1 = {
    'list_character': {
        'attr': 'list', 'item': {
            'character_item': { 'type': 'text', 'attr': 'class' },
            'item_cd': { 'type': 'text', 'attr': 'class' },
        }
    }, 'list_date': {
        'attr': 'list', 'item': {
            'from_date_item': { 'type': 'text', 'attr': 'class' },
            'to_date_item': { 'type': 'text', 'attr': 'class' },
            'item_cd': { 'type': 'text', 'attr': 'class' },
        }
    },
};
$(function () {
    initEvents();
    initialize();
    tableContent();
    //calcTable();
});

/**
 * initialize
 *
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        $('#employee_cd').focus();
        _formatTooltip();
        jQuery.initTabindex();
        valid()
        if (window.innerWidth <= 1400 && window.innerWidth >= 1200) {
            $('.header-left-function').removeClass('col-xl-6');
            $('.header-right-function').removeClass('col-xl-6');
            $('.header-left-function').addClass('col-xl-4');
            $('.header-right-function').addClass('col-xl-8');
        }
        if (window.innerWidth <= 1100) {
            $('.header-left-function').removeClass('col-lg-4');
            $('.header-right-function').removeClass('col-xl-8');
            $('.header-left-function').addClass('col-xl-3');
            $('.header-right-function').addClass('col-xl-9');
        }
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    //btn-add-row
    $(window).resize(function () {
        // location.reload();
    });
    //編集
    $(document).on('click', '.radio_box', function () {
        try {
            $(this).attr('checked', 'checked');                                        
        } catch (e) {
            alert('.btn-edit: ' + e.message);
        }
    });
    $(document).on('click', '#btn-add-new', function () {
        try {
            if (_validateDomain(window.location)) {
                window.location.href = '/basicsetting/m0070';
            } else {
                jError(error, label_026);
            }
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });

    //btn-remove-row
    $(document).on('click', '.btn-remove-row', function () {
        try {
            $(this).parents('tr').remove();
        } catch (e) {
            alert('btn-remove-row: ' + e.message);
        }
    });
    //履歴
    // $(document).on('click','.btn-history',function () {
    //     try{
    //         var data = {};
    //         data.from                = 'q0070';
    //         _redirectScreen('/master/q0071',data);
    //     } catch(e){
    //         alert('.btn-history: ' + e.message);
    //     }
    // });
    $(document).on('click', '#item-check', function () {
        //
        try {
            var count = $('#table-data tbody tr').length;
            var value = $(this).is(':checked');
            var item = $(this).attr('id');
            fnc_checked(value, count, item);
        } catch (e) {
            alert('click checked ' + e.message);
        }
    });
    $(document).on('click', '.item-check', function () {
        try {
            var $this = $(this),
                $type = 'item-check',
                $checkbox = $('#table-data tbody tr').find('.' + $type).length,
                $checkboxChecked = $('#table-data tbody tr').find('.' + $type + ':checked').length;
            //
            if ($checkbox == $checkboxChecked) {
                $('#' + $type).prop('checked', true);
            } else {
                $('#' + $type).prop('checked', false);
            }

        } catch (e) {
            alert('click checked ' + e.message);
        }
    });
    $(document).on('click', '#btn-print-history', function () {
        try {
            if (_validate()) {
                outputHistorycsv();
            }
        } catch (e) {
            alert('click checked ' + e.message);
        }
    });

    $(document).on('click', '#btn-print-employee', function () {
        try {
            if (_validate()) {
                outputEmployeecsv();
            }
        } catch (e) {
            alert('click checked ' + e.message);
        }
    });

    $(document).on('click', '.btn-search', function (e) {
        e.preventDefault();
        _clearErrors(1);
        if (_validate()) {
            search();
        }
    });

    $(document).on('click', '.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
        e.preventDefault();
        $('.page-item').removeClass('active');
        $(this).addClass('active')
        var page = $(this).attr('page');
        var cb_page = $('#cb_page').find('option:selected').val();
        var cb_page = cb_page == '' ? 1 : cb_page;
        search(page, cb_page);
    });

    $(document).on('change', '#cb_page', function (e) {
        var li = $('.pagination li.active'),
            page = li.find('a').attr('page');
        var cb_page = $(this).val();
        var cb_page = cb_page == '' ? 20 : cb_page;

        search(page, cb_page);
    });

    $(document).on('change', '#ck_search', function () {
        valid()
    })

    $(document).on('change', '#fiscal_year,#group_cd', function () {
        valid()
    })
    $(document).on('click', '#btn-released-pass ', function (e) {
        try {
            var countChecked = 0;
            countChecked = $(".item-check:checked").length;
            jMessage(91, function (r) {
                if (r) {
                    if (countChecked >= 1) {
                        releasedPass();
                    } else {
                        jMessage(66, function (r) {
                            if (r && _validate($('body'))) {
                                releasedPass();
                            }
                        });
                    }
                }
            });
        } catch (e) {
            alert('#btn-released-pass ' + e.message);
        }
    });
    //Button [パスワード通知] event
    $(document).on('click', '#btn-mail', function (e) {
        try {
            e.preventDefault();
            var countChecked = 0;
            countChecked = $(".item-check:checked").length;
            jMessage(34, function (r) {
                if (r) {
                    if (countChecked >= 1) {
                        sendMail();
                    } else {
                        jMessage(18, function (r) {
                            return;
                        });
                    }
                }
            });
        } catch (e) {
            alert('#btn-mail event : ' + e.message);
        }
    });
    //編集
    $(document).on('click', '.screen_m0070', function (e) {
        e.preventDefault();
        if (!$(this).hasClass('disabled')) {
            var tr = $(this).parents('tr');
            var employee_cd = tr.find('.tb_employee_cd').val();
            var html = getHtmlCondition($('.container-fluid'));
            var data = {
                'employee_cd': employee_cd
                , 'html': html
                , 'from': 'sq0070'
                , 'save_cache': 'true'		    // save cache status
                , 'screen_id': 'sq0070_m0070'
            };
            //
            _redirectScreen('/basicsetting/m0070', data, true);
        }
    });
    //履歴
    $(document).on('click', '.screen_q0071', function (e) {
        e.preventDefault();
        if (!$(this).hasClass('disabled')) {
            var tr = $(this).parents('tr');
            var employee_cd = tr.find('.tb_employee_cd').val();
            var html = getHtmlCondition($('.container-fluid'));
            var data = {
                'employee_cd': employee_cd
                , 'html': html
                , 'from': 'q0070'
                , 'save_cache': 'true'		    // save cache status
                , 'screen_id': 'q0070_q0071'
            };
            _redirectScreen('/master/q0071', data, true);
        }
    });
    $(document).on('click', '.hide-box-input-search', function (e) {
        var card = $('#result').closest('.card');
        var table_fixed_header = $('#result').find('.table-fixed-header');
        if ($(this).find('.fa-caret-down').length > 0) {
            card.css('min-height', '79vh');
            table_fixed_header.css('min-height', '72vh');
        } else {
            card.css('min-height', '50vh');
            table_fixed_header.css('min-height', '45vh');
        }
    });
    $(document).on('click', '#btn-back', function (e) {
        var home_url = $('#home_url').attr('href');
        window.location.href = home_url;
    });
}

function setData(options) {
    var objs = {};
    $.extend(objs, options)
    var str = '';
    $.each(objs, function (key, value) {
        var param = key + '=' + value + '&';
        str += param;
    });
    return str;
}

/**
 * save
 *
 * @author      :   longvv - 2018/09/11 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function sendMail() {
    try {
        var list_org = getOrganization();
        $("table tbody tr").removeClass("tr_employee");
        $("table tbody tr").find('input[type=checkbox]:checked').closest('tr').addClass("tr_employee");
        var data = getData(_obj);
        data.data_sql.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
        data.data_sql.list_organization_step1 = list_org.list_organization_step1
        data.data_sql.list_organization_step2 = list_org.list_organization_step2
        data.data_sql.list_organization_step3 = list_org.list_organization_step3
        data.data_sql.list_organization_step4 = list_org.list_organization_step4
        data.data_sql.list_organization_step5 = list_org.list_organization_step5
        data.data_sql.list_character = _getItems(0);
        data.data_sql.list_date = _getItems(1);
        data.data_sql.list_number_item = _getItems(2);
        // add by viettd 2021/09/22
        var url = ''
        var screen = $('#screen').val();
        if (screen != undefined && screen == 'sq0070') {
            url = '/basicsetting/sq0070/sendMail';
        } else {
            url = '/master/q0070/sendMail';
        }
        // end add by viettd 2021/09/22
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(35);
                        break;
                    // error
                    case NG:
                        jMessage(81,function(r){
							//
						});	
                        break;
                    // Exception
                    case EX:
                        jMessage(81,function(r){
							//
						});	
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('sendMail' + e.message);
    }
}
/**
 * releasedPass パスワード一括発行
 *
 * @author      :   longvv - 2018/09/11 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function releasedPass() {
    try {
        var list_org = getOrganization();
        $("table tbody tr").removeClass("tr_employee");
        $("table tbody tr").find('input[type=checkbox]:checked').closest('tr').addClass("tr_employee");
        var data = getData(_obj);
        data.data_sql.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
        data.data_sql.company_out_dt_flg = $('#company_out_dt_flg:checked').length == 0 ? 0 : 1;
        data.data_sql.list_organization_step1 = list_org.list_organization_step1
        data.data_sql.list_organization_step2 = list_org.list_organization_step2
        data.data_sql.list_organization_step3 = list_org.list_organization_step3
        data.data_sql.list_organization_step4 = list_org.list_organization_step4
        data.data_sql.list_organization_step5 = list_org.list_organization_step5
        data.data_sql.list_character = _getItems(0);
        data.data_sql.list_date = _getItems(1);
        data.data_sql.list_number_item = _getItems(2);
        // add by viettd 2021/09/22
        var url = ''
        var screen = $('#screen').val();
        if (screen != undefined && screen == 'sq0070') {
            url = '/basicsetting/sq0070/releasedpass';
        } else {
            url = '/master/q0070/releasedpass';
        }
        // end add by viettd 2021/09/22
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(92, function (r) {
                            if (r) {
                                $('#table-data').find('.item-check').prop('checked', false);
                                $('#item-check').prop('checked', false);
                            }
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exceptionm
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('releasedPass  ' + e.message);
    }
}
/**
 * outputcsv
 *
 * @author      :   longvv - 2018/09/06 - create
 * @author      :
 * @return      :   null
             obj.organization_step1       = $('#organization_step1').val();
            obj.organization_step2       = $('#organization_step2').val();
            obj.organization_step3       = $('#organization_step3').val();
            obj.organization_step4       = $('#organization_step4').val();
            obj.organization_step5       = $('#organization_step5').val();
 * @access      :   public
 * @see         :
 */
function outputHistorycsv() {
    var list_org = getOrganization();
    var obj = {};
    obj.employee_cd = $('#employee_cd').val();
    obj.employee_name = $('#employee_name').val();
    obj.employee_typ = $('#employee_typ option:selected').val();
    obj.organization_step1 = list_org.list_organization_step1
    obj.organization_step2 = list_org.list_organization_step2
    obj.organization_step3 = list_org.list_organization_step3
    obj.organization_step4 = list_org.list_organization_step4
    obj.organization_step5 = list_org.list_organization_step5
    obj.position_cd = $('#position_cd option:selected').val();
    obj.grade = $('#grade option:selected').val();
    obj.company_out_dt_flg = $('#company_out_dt_flg:checked').length == 0 ? 0 : 1;
    obj.fiscal_year = $('#fiscal_year').val();
    obj.group_cd = $('#group_cd option:selected').val();
    obj.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
    obj.list_character = _getItems(0);
    obj.list_date = _getItems(1);
    obj.list_number_item = _getItems(2);
    $.ajax({
        type: 'POST',
        url: '/master/q0070/outputhistorycsv',
        loading: true,
        data: JSON.stringify(obj),
        success: function (res) {
            switch (res['status']) {
                // success
                case OK:
                    //location.reload();
                    // var returnRes       =   JSON.parse(res);
                    var filedownload = res['FileName'];
                    var name = '評価履歴.csv';
                    if ($("#language_jmessages").val() == 'en') {
                        name = 'EvaluationHistory.csv';
                    }
                    if (filedownload != '') {
                        downloadfileHTML(filedownload, name, function () {
                            //
                        });
                    } else {
                        jError(2);
                    }

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
        },
        error: function (xhr) {
            var json = xhr.responseJSON;

            if (xhr.status == 401) {
                jError(error, json.message, function () {
                    $('input:not([readonly]):not([disabled]):first').focus();
                });
                $('input:not([readonly]):not([disabled]):first').focus();
                return;
            } else {
                jError(error, label_010, function () {
                    $('input:not([readonly]):not([disabled]):first').focus();
                });
            }
        }
    });

}

/**
 * outputEmployeecsv 社員一蘭出力
 *
 * @author      :   longvv - 2018/09/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function outputEmployeecsv() {
    var list_org = getOrganization();
    var obj = {};
    obj.employee_cd = $('#employee_cd').val();
    obj.employee_name = $('#employee_name').val();
    obj.employee_typ = $('#employee_typ option:selected').val();
    obj.organization_step1 = list_org.list_organization_step1
    obj.organization_step2 = list_org.list_organization_step2
    obj.organization_step3 = list_org.list_organization_step3
    obj.organization_step4 = list_org.list_organization_step4
    obj.organization_step5 = list_org.list_organization_step5
    obj.position_cd = $('#position_cd option:selected').val();
    obj.grade = $('#grade option:selected').val();
    obj.company_out_dt_flg = $('#company_out_dt_flg:checked').length == 0 ? 0 : 1;
    obj.fiscal_year = $('#fiscal_year').val();
    obj.group_cd = $('#group_cd option:selected').val();
    obj.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
    obj.list_character = _getItems(0);
    obj.list_date = _getItems(1);
    obj.list_number_item = _getItems(2);
    // add by viettd 2021/09/22
    var url = ''
    var screen = $('#screen').val();
    if (screen != undefined && screen == 'sq0070') {
        url = '/basicsetting/sq0070/outputemployeecsv';
    } else {
        url = '/master/q0070/outputemployeecsv';
    }
    // end add by viettd 2021/09/22
    $.ajax({
        type: 'POST',
        url: url,
        loading: true,
        data: JSON.stringify(obj),
        success: function (res) {
            switch (res['status']) {
                // success
                case OK:
                    //location.reload();
                    // var returnRes       =   JSON.parse(res);
                    var filedownload = res['FileName'];
                    if (filedownload != '') {
                        downloadfileHTML(filedownload, list_of_employees.replace(/\s/g, '')+'.csv', function () {
                            //
                        });
                    } else {
                        jError(2);
                    }

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
        },
        error: function (xhr) {
            var json = xhr.responseJSON;

            if (xhr.status == 401) {
                jError(error, json.message, function () {
                    $('input:not([readonly]):not([disabled]):first').focus();
                });
                $('input:not([readonly]):not([disabled]):first').focus();
                return;
            } else {
                jError(error, label_010, function () {
                    $('input:not([readonly]):not([disabled]):first').focus();
                });
            }
        }
    });

}
/**
 * checked all
 *
 * @author      :   tuantv - 2018/05/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function fnc_checked(value, count, item) {
    if (count > 0) {
        if (value == false) {
            $('#table-data').find('.' + item).prop('checked', false);
        } else {
            $('#table-data').find('.' + item).prop('checked', true);
        }
    }
}
/**
 * search
 *
 * @author      :   tuantv - 2018/05/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function search(page, page_size) {
    _clearErrors(1);
    if (typeof page == 'undefined') {
        var page = 1;
    }
    if (typeof page_size == 'undefined') {
        var page_size = 20;
    }
    var url = ''
    var screen = $('#screen').val();
    if (screen != undefined && screen == 'sq0070') {
        url = '/basicsetting/sq0070/search'
    } else {
        url = '/master/q0070/search'
    }
    var list_org = getOrganization();
    var obj = {};
    obj.employee_cd = $('#employee_cd').val();
    obj.employee_name = $('#employee_name').val();
    obj.employee_typ = $('#employee_typ option:selected').val();
    obj.organization_step1 = list_org.list_organization_step1
    obj.organization_step2 = list_org.list_organization_step2
    obj.organization_step3 = list_org.list_organization_step3
    obj.organization_step4 = list_org.list_organization_step4
    obj.organization_step5 = list_org.list_organization_step5
    obj.position_cd = $('#position_cd option:selected').val();
    obj.grade = $('#grade option:selected').val();
    obj.company_out_dt_flg = $('#company_out_dt_flg:checked').length == 0 ? 0 : 1;
    obj.fiscal_year = $('#fiscal_year').val();
    obj.group_cd = $('#group_cd option:selected').val();
    obj.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
    obj.page_size = page_size;
    obj.page = page;
    obj.list_character = _getItems(0);
    obj.list_date = _getItems(1);
    obj.list_number_item = _getItems(2);
    obj.screen_from = $('#screen_from').val();
    $.ajax({
        url: url,
        type: 'post',
        data: JSON.stringify(obj),
        loading: true,
        success: function (res) {
            if(res['status'] != undefined && res['status'] == 164) {
                jMessage(164);
            } else {
            $('#result').empty();
            $('#result').html(res);
            $('body').removeErrorStyle();
            $('input,select').removeClass('required');
            jQuery.formatInput();
            app.jTableFixedHeader();
            if (!$('.box-input-search').hasClass('hide')) {
                $('input:first').focus();
            } else {
                var card = $('#result').closest('.card');
                var table_fixed_header = $('#result').find('.table-fixed-header');
                card.css('min-height', '79vh');
                table_fixed_header.css('min-height', '72vh');
            }
            tableContent();
            _formatTooltip();
            jQuery.initTabindex();
        }
        },
        error: function (res) {

        }
    });
}
/**
 * valid
 *
 * @author      :   tuantv - 2018/05/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function valid() {
    var ck_search = $('#ck_search'),
        checked = $('#ck_search:checked'),
        group_cd = $('#group_cd'),
        fiscal_year = $('#fiscal_year'),
        authority_typ = $('#authority_typ').val();
    _clearErrors(1);
    // group_cd.find('option').removeAttr('selected');
    group_cd.removeClass('required');
    fiscal_year.removeClass('required');
    if (checked.length > 0) {
        group_cd.val('-1');
        group_cd.attr('disabled', 'disabled');
        // if(authority_typ!=2){
        fiscal_year.addClass('required');
        // }
    } else {
        group_cd.removeAttr('disabled');
        fiscal_year.removeClass('required')
    }

    if (fiscal_year.val() != -1) {
        if (checked.length == 0) {
            group_cd.removeAttr('disabled');
            group_cd.addClass('required');
        }
    } else if (group_cd.find('option:selected').val() != -1) {
        fiscal_year.addClass('required');
    }
}
/**
 * table Content
 *
 * @author      :  tuantv - 2018/11/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function tableContent() {
    $(".wmd-view-topscroll").scroll(function () {
        $(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
    });

    $(".wmd-view").scroll(function () {
        $(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
    });

    fixWidth();

    $(window).resize(function () {
        fixWidth();
    });
    function fixWidth() {
        var w = $('.wmd-view .table').outerWidth();
        var f = $('.table-group li:last').outerWidth();
        $(".wmd-view-topscroll .scroll-div1").width(w);
        $('#header').width(w);
        // $(".table-group li:last .fixed").width(f);
    }
}
/**
 * getOrganization
 *
 * @author      :  tuantv - 2018/11/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getOrganization() {
    let param = [];
    let list = [];
    if ($('#organization_step1').val() != undefined) {
        var str = $('#organization_step1 option:selected').val().split('|');
        list.push({
            'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
            'organization_cd_2': str[1] == undefined ? '' : str[1],
            'organization_cd_3': str[2] == undefined ? '' : str[2],
            'organization_cd_4': str[3] == undefined ? '' : str[3],
            'organization_cd_5': str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step1 = list;
    list = [];
    if ($('#organization_step2').val() != undefined) {
        var str = $('#organization_step2 option:selected').val().split('|');
        if (str[0] != 0) {
            list.push({
                'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                'organization_cd_2': str[1] == undefined ? '' : str[1],
                'organization_cd_3': str[2] == undefined ? '' : str[2],
                'organization_cd_4': str[3] == undefined ? '' : str[3],
                'organization_cd_5': str[4] == undefined ? '' : str[4],
            });
        }

    }
    param.list_organization_step2 = list;
    list = [];
    if ($('#organization_step3').val() != undefined) {
        var str = $('#organization_step3 option:selected').val().split('|');
        list.push({
            'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
            'organization_cd_2': str[1] == undefined ? '' : str[1],
            'organization_cd_3': str[2] == undefined ? '' : str[2],
            'organization_cd_4': str[3] == undefined ? '' : str[3],
            'organization_cd_5': str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step3 = list;
    list = [];
    if ($('#organization_step4').val() != undefined) {
        var str = $('#organization_step4 option:selected').val().split('|');
        list.push({
            'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
            'organization_cd_2': str[1] == undefined ? '' : str[1],
            'organization_cd_3': str[2] == undefined ? '' : str[2],
            'organization_cd_4': str[3] == undefined ? '' : str[3],
            'organization_cd_5': str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step4 = list;
    list = [];
    if ($('#organization_step5').val() != undefined) {
        var str = $('#organization_step5 option:selected').val().split('|');
        list.push({
            'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
            'organization_cd_2': str[1] == undefined ? '' : str[1],
            'organization_cd_3': str[2] == undefined ? '' : str[2],
            'organization_cd_4': str[3] == undefined ? '' : str[3],
            'organization_cd_5': str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step5 = list;
    list = [];
    return param;
}