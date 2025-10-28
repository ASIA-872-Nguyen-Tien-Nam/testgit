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
    'fiscal_year': { 'type': 'select', 'attr': 'id' },
    'list_supporters': {
        attr: "list",
        item: {
            supporter_cd: { type: "text", attr: "class" },
            other_browsing_kbn: { type: "checkbox", attr: "class" },
        },
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
 * @author    : datnt - 2020/11/17 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try {
        $('#fiscal_year').focus();
        var fiscal_year = $('#fiscal_year').val();
        $('.supporter_nm').attr("fiscal_year_mulitireview", fiscal_year);
        //
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
        _formatTooltip();
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
    try {
        //
        $(document).on('click', '#btn-view-supporter', function () {
            try {
                var option = {};
                var width = $(window).width();
                // if ((width <= 1366 ) && (height <=768)) {
                if ((width >= 1300)) {
                    option.width = '40%';
                    option.height = '60%';
                } else {
                    option.width = '40%';
                    option.height = '60%';
                }
                // e.preventDefault();
                showPopup('/multiview/mi1010/view-supporter', option, function () { });
            } catch (e) {
                alert('#btn-view-supporter: ' + e.message);
            }
        });
        //
        $(document).on('click', '#btn-add-detail', function () {
            try {
                var num_tr = $('#table_detail tbody tr').length;
                // maximum 30 row details
                if (num_tr <= 29) {
                    random_number = Math.floor(1000000000 + Math.random() * 9000000000);
                    var row = $("#table-target tbody tr:first").clone();
                    var row_id = $('#table_detail tbody tr:last').attr('tr_id') * 1 + 1;
                    if (typeof $('#table_detail tbody tr:last').attr('tr_id') === "undefined") {
                        row_id = 1;
                    }
                    row.find('.check_box').attr('id', random_number);
                    row.find('.lbl_check_box').attr('for', random_number);
                    $('#table_detail tbody').append(row);
                    $('#table_detail tbody tr:last').addClass('list_supporters');
                    $('#table_detail tbody tr:last').attr('tr_id', row_id);
                    $('#table_detail').find('tbody tr:last td:first-child input').focus();
                    $.formatInput('#table_detail tbody tr:last');
                } else {
                    $('#btn-add-detail').attr("disabled", "disabled");
                }
            } catch (e) {
                alert('btn-add-detail: ' + e.message);
            }
        });
        //
        $(document).on('click', '.btn-remove-row', function () {
            try {
                $(this).parents('tr').remove();
                var num_tr = $('#table_detail tbody tr').length;
                if (num_tr <= 29) {
                    $('#btn-add-detail').removeAttr("disabled");
                }
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //change fiscal_year_multiview
        $(document).on('change', '#fiscal_year', function (e) {
            try {
                var fiscal_year = $(this).val();
                $('.employee_nm_mulitireview').attr("fiscal_year_mulitireview", fiscal_year);
                //
                var employee_nm = $("#employee_nm").val();
                if (employee_nm != '') {
                    search();
                }
            } catch (e) {
                alert('#fiscal_year: ' + e.message);
            }
        });
        //change supporter_cd
        $(document).on('blur', '.supporter_nm', function (e) {
            try {
                var supporter_cd = $(this).parents('tr').find('.supporter_cd').val();
                var row_id = $(this).parents('tr').attr('tr_id');
                referSupporter(supporter_cd, row_id);
            } catch (e) {
                alert('.supporter_nm: ' + e.message);
            }
        });
        // btn-save
        $(document).on('click', '.btn-save', function (e) {
            try {
                var check = $('#table_detail tbody tr.list_supporters').length;
                jMessage(1, function (r) {
                    if (check > 0) {
                        if (r && _validate($('body'))) {
                            saveData();
                        }
                    } else {
                        jMessage(29, function () {

                        });
                    }
                });
            } catch (e) {
                alert('.btn-save :' + e.message);
            }
        });

        // button export
        $(document).on('click', '#btn-print', function (e) {
            try {
                if (_validate($('.condition-search'))) {
                    e.preventDefault();
                    var fiscal_year = $('#fiscal_year').val();
                    var employee_cd = $('#employee_cd').val();
                    if (fiscal_year > 0 && employee_cd != '') {
                        var param = {};
                        param.fiscal_year = $('#fiscal_year').val();
                        param.employee_cd = $('#employee_cd').val();
                        $.downloadFileAjax('/multiview/mi1010/export-excel', JSON.stringify(param));
                    } else {
                        jMessage(21);
                    }
                }
            } catch (e) {
                alert('#btn-print: ' + e.message);
            }
        });

        // btn-export
        $(document).on('click', '#btn-export', function (e) {
            try {
                exportCSV();
            } catch (e) {
                alert('#btn-export :' + e.message);
            }
        });

        // import
        $(document).on('click', '#btn-import', function (e) {
            try {
                $('#import_file').trigger('click');
            } catch (e) {
                alert('#btn-import :' + e.message);
            }
        });

        // import
        $(document).on('change', '#import_file', function (e) {
            try {
                importCSV();
            } catch (e) {
                alert('#upload_file :' + e.message);
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

        // reload hidden
        $(document).on('click', '#btn_reload', function (e) {
            try {
                location.reload();
            } catch (e) {
                alert('#btn_reload :' + e.message);
            }
        });
    } catch (e) {

    }
}

/**
 * SEARCH
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function search() {
    try {
        var data = getData(_obj);
        var employee_cd = $('#employee_cd').val();
        data.data_sql.employee_cd = employee_cd;
        data.data_sql.check_mulitireview_typ = 1; // check mulitireview
        // check mulitireview_typ of employee_cd
        $.ajax({
            type: "POST",
            url: "/multiview/mi1010/search",
            dataType: "json",
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                // apply rater_employee_nm_1_string
                if (typeof res['rater_employee_nm_1_string'] != 'undefined') {
                    $('#rater_employee_nm_1_string').text(htmlEntities(res['rater_employee_nm_1_string']));
                    $('#rater_employee_nm_1_string').attr("data-original-title",htmlEntities(res['rater_employee_nm_1_string']));
                }
                // check status
                if(res['status'] == OK){
                    searchDetail();
                }else if (res['status'] == NG){
                    // jMessage(146,function(r){
                    //     if(r){
                    //         searchDetail();
                    //     }
                    // });
                    // comment out by viettd 2021/06/28
                    // add by viettd 2021/06/28
                    jMessage(145,function(){
                        $('#employee_cd').val('');
                        $('#employee_nm').val('');
                        $('#employee_cd').attr('old_employee_nm','');
                        $('#rater_employee_nm_1_string').text('');
                    });
                }else{
                    jError(res["Exception"]);
                }
            },
        });
    } catch (e) {
        alert("save" + e.message);
    }
}

/**
 * searchDetail
 *
 * @author      :   viettd - 2021/06/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function searchDetail(){
    try{
        var data = getData(_obj);
        var employee_cd = $('#employee_cd').val();
        data.data_sql.employee_cd = employee_cd;
        data.data_sql.check_mulitireview_typ = 0; // check mulitireview
        $.ajax({
            type: "POST",
            url: "/multiview/mi1010/search",
            dataType: "html",
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                $("#result").empty();
                $("#result").append(res);
                jQuery.formatInput();
                app.jTableFixedHeader();
                app.jSticky();
                var fiscal_year = $('#fiscal_year').val();
                $('.supporter_nm').attr("fiscal_year_mulitireview", fiscal_year);
            },
        });
    }catch(e){
        alert('searchDetail:'+e.message);
    }
}

/**
 * refer
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referSupporter(supporter_cd, row_id) {
    try {
        var data = getData(_obj);
        data.data_sql.supporter_cd = supporter_cd;
        // send data to post
        $.ajax({
            type: "POST",
            url: "/multiview/mi1010/refer",
            dataType: "json",
            // loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                if (res.flg == 1) {
                    $('tr[tr_id=' + row_id + ']').find('.position_cd').text(res.list_info.position_nm);
                    $('tr[tr_id=' + row_id + ']').find('.grade').text(res.list_info.grade_nm);
                    $('tr[tr_id=' + row_id + ']').find('.job_cd').text(res.list_info.job_nm);
                    $('tr[tr_id=' + row_id + ']').find('.employee_typ').text(res.list_info.employee_typ_nm);
                    $('#list_position_default').find('tbody tr').each(function (j, row_tr) {
                        var $row = $(row_tr),
                            $browsing_position_cd = $row.find('.browsing_position_cd').text();
                        if (res.list_info.position_cd == $browsing_position_cd) {
                            $('tr[tr_id=' + row_id + ']').find('.other_browsing_kbn').prop('checked', true);
                        }
                    });
                } else {
                    $('tr[tr_id=' + row_id + ']').find('.supporter_nm').text('');
                    $('tr[tr_id=' + row_id + ']').find('.position_cd').text('');
                    $('tr[tr_id=' + row_id + ']').find('.grade').text('');
                    $('tr[tr_id=' + row_id + ']').find('.job_cd').text('');
                    $('tr[tr_id=' + row_id + ']').find('.employee_typ').text('');
                }

            },
        });
    } catch (e) {
        alert("save" + e.message);
    }
}
/**
 * save
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
        var employee_cd = $('#employee_cd').val();
        data.data_sql.employee_cd = employee_cd;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/multiview/mi1010/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function () {
                            $('#fiscal_year').focus();
                        });
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

/**
 * exportCSV
 *
 * @author      :  duongntt - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
    try {
        var data = {};
        data.fiscal_year = $('#fiscal_year').val();
        //
        $.ajax({
            type: 'POST',
            url: '/multiview/mi1010/export-csv',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    
                    case OK:
                        var filedownload = res['FileName'];
                        if (filedownload != '') {
                            if ($('#language_jmessages').val() == 'en') { 
                                downloadfileHTML(filedownload, 'SupporterSetting.csv', function () {
                                    //
                                });
                            } else {
                                downloadfileHTML(filedownload, 'サポーター設定.csv', function () {
                                    //
                                });
                            }
                        } else {
                            jError(2);
                        }
                        break;
                    // error
                    case NG:
                        console.log(res)
                        jError('エラー',res['message']);
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            },
            error: function(xhr, status, error) {
                console.log(error)
                jError(res['Exception']);

            }
        });
    } catch (e) {
        alert('exportCSV: ' + e.message);
    }
}

/**
 * importCSV
 *
 * @author      :  viettd - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
    try {
        var data = {};
        data.import_file = $('');
        var formData = new FormData();
        formData.append('file', $('#import_file')[0].files[0]);
        formData.append('fiscal_year', $('#fiscal_year').val());
        var name_file = $('#import_file')[0].files[0].name;
        $.ajax({
            type: 'POST',
            data: formData,
            url: '/multiview/mi1010/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function (res) {
                switch (res['status']) {
                    case 200:
                        jMessage(7, function (r) {
                            location.reload();
                            $("#import_file").val("");
                        });
                        break;
                    // error
                    case 201:
                        jMessage(22, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 205:
                        jMessage(27, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 206:
                        jMessage(31, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 207:
                        var filedownload = res['FileName'];
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, name_file.split('.').slice(0, -1) + '_エラー.csv', function () {
                                //
                            });
                            $("#import_file").val("");
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
        alert('importCSV: ' + e.message);
    }
}
/**
 * callback search after blur employee
 *
 * @author      :  duongntt - 2021/01/14 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function afterBlurEmployeeCd(_this) {
    var employee_nm = $("#employee_nm").val();
    var old_employee_nm = $('#employee_nm').attr('old_employee_nm');
    $('#employee_nm').attr('old_employee_nm', employee_nm);
    if (old_employee_nm != '') {
        search();
    }
}