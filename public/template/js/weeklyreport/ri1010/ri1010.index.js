
/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2023/02/13
 * 作成者          :   quangnd – quangnd@ans-asia.com
 *
 * @package         :
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year': { 'type': 'text', 'attr': 'id' },
    //'month': { 'type': 'text', 'attr': 'id' },
    'report_kind': { 'type': 'text', 'attr': 'id' },
    'list_schedule': {
        'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'class' },
            'year_n': { 'type': 'text', 'attr': 'class' },
            'month_n': { 'type': 'text', 'attr': 'class' },
            'title_df': { 'type': 'text', 'attr': 'class' },
            'title': { 'type': 'text', 'attr': 'class' },
            'start_date': { 'type': 'text', 'attr': 'class' },
            'deadline_date': { 'type': 'text', 'attr': 'class' },
            'report_notice': { 'type': 'text', 'attr': 'class' },
            'report_alert': { 'type': 'text', 'attr': 'class' },
            'report_user_typ': { 'type': 'text', 'attr': 'class' },
        }
    }
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
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
    try {
        $(".multiselect").multiselect({
            onChange: function () {
                $.uniform.update();
            },
        });
        $('.multiselect').css('background', '#fff7f1 !important');

        $('#fiscal_year').focus();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * initEvents
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initEvents() {
    try {
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                //
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back:' + e.message);
            }
        });
        $(document).on('click', '.btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    if (r && _validate($('body'))) {
                        saveData();
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
                    if (r && _validate($('body'))) {
                        deleteData();
                    }
                })
            } catch (e) {
                alert('#btn-delete :' + e.message);
            }
        });
        //
        $(document).on('change', '#month', function (e) {
            try {
                if ($('#report_kind').val() > 3 & $('input[type=checkbox]:checked').length > 0) {
                    $('.list_schedule').empty();
                    refer();
                }
            } catch (e) {
                alert('#month : ' + e.message);
            }
        })
        //
        $(document).on('change', '#report_group', function (e) {
            try {
                if ($('input[type=checkbox]:checked').length > 0) {
                    refer();
                }
            } catch (e) {
                alert('#report_group: ' + e.message);
            }
        })
        // $(document).on('change', '#fiscal_year ', function (e) {
        //     try {
        //         e.preventDefault();
        //         var check = $('#report_kind').val();
        //         if (check == 5) {
        //             $('.full-month').remove();
        //         }	
        //     } catch (e) {
        //         alert('#fiscal_year: ' + e.message);
        //     }
        // })
        //
        $(document).on('change', '#report_kind', function (e) {
            try {
                changeReportKind();
            } catch (e) {
                console.log('#btn_add:' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}
/**
 * refer
 *
 * @author      :   quangnd - 2023/04/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer() {
    try {
        var list = [];
        data = {};
        var div1 = $('#report_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({ 'report_group': $(this).val() });
            }
        });
        data.fiscal_year = $('#fiscal_year').val();
        data.month = $('#month').val();
        data.report_kind = $('#report_kind').val();
        data.group_cd = list[0]['report_group'];
        data.report_group_list = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1010/refer',
            dataType: 'html',
            data: data,
            loading: true,
            success: function (res) {
                $('#refer_data').empty();
                $('#refer_data').append(res);
                app.jTableFixedHeader();
                jQuery.formatInput('#refer_data');
            }
        });
    } catch (e) {
        alert('refer' + e.message);
    }
}
/**
 * save
 *
 * @author      :   quangnd - 2023/04/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);
        var list = [];
        var div1 = $('#report_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({ 'report_group': $(this).val() });
            }
        });
        data.data_sql.report_group_list = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1010/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            $('#report_group').trigger('change');
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
 * @author      :    quangnd - 2023/04/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var list = [];
        var data_no = getData(_obj);
        var detail_no = [];
        data = {};
        var div1 = $('#report_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({ 'report_group': $(this).val() });
            }
        });
        data.fiscal_year = $('#fiscal_year').val();
        data.report_kind = $('#report_kind').val();
        data.month = $('#month').val();
        data.report_group_list = list;
        data_no.data_sql.list_schedule.forEach(element => {
            detail_no.push({ 'detail_no': element.detail_no })
        });
        data.detail_no = detail_no;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1010/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            $('#report_group').trigger('change');
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
        alert('deleteData' + e.message);
    }
}
/**
 * changeReportKind
 *
 * @author      :    quangnd - 2023/04/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function changeReportKind() {
    try {
        var check = $('#report_kind').val();
        var data ={}
         data.report_kind = check
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1010/referGroup',
            dataType: 'json',
            data: data,
            loading: false,
            success: function (res) {
                let html = res.report_group.map(item => {
                    return `<option value="${item.group_cd}">${item.group_nm}</option>`;
                }).join('');
                $('#report_group').empty().append(html).multiselect('rebuild');
                            
            }
        });

        $('#block_month').css('display', 'none')
        //$('.full-month').remove();
        if (check == 4) {
            $('#block_month').css('display', 'unset');
            //$('#block_month #month').prepend('<option value="-1" class="full-month" selected></option>');
            //$('#block_month #month').prepend('<option value="-1" class="full-month" selected></option>').trigger('change');
        }
        if (check == 5) {
            $('#block_month').css('display', 'unset');
            //$('#block_month #month').trigger('change');
        }
    } catch (e) {
        alert('deleteData' + e.message);
    }
}
/**
 * referDataAffterChangeMonth()
 *
 * @author      :    quangnd - 2023/04/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function __referDataAffterChangeMonth() {
    try {
        if ($('#report_kind').val() <= 3) {
            $("#report_group").trigger('change');
        }
    } catch (e) {
        alert('deleteData' + e.message);
    }
}