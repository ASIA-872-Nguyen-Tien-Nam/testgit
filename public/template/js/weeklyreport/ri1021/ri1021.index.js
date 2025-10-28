/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	
 * 作成者		    :	
 *
 * @package			:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version			:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'report_kinds': { 'type': 'select', 'attr': 'id' }
    , 'fiscal_year': { 'type': 'select', 'attr': 'id' }
    , 'report_group': { 'type': 'select', 'attr': 'id' }
    , 'employee_typ': { 'type': 'select', 'attr': 'id' }
    , 'employee_cdX': { 'type': 'text', 'attr': 'id' }

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
 * @author		:	sondh - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        //$('#report_kinds').focus();
        $(".multiselect").multiselect({
            onChange: function () {
                $.uniform.update();
            },
        });
        $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * initEvents
 * @author		:	viettd - 2018/10/08 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
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
        // 付箋
        $(document).on("click", "#btn_popup", function () {
            try {
                var count_check = $('#list').find('input:checkbox:checked').length;
                if (count_check == 1 && _validate($('body'))) {
                    var option = {};
                    var width = $(window).width();
                    if ((width <= 1368) && (width >= 1300)) {
                        option.width = '80%';
                        option.height = '70%';
                    } else {
                        if (width <= 1300) {
                            option.width = '80%';
                            option.height = '90%';
                        } else {
                            option.width = '80%';
                            option.height = '90%';
                        }
                    }
                    var employee_cd = $('#list').find('input:checkbox:checked').closest("tr").find('.tb_employee_cd').val();
                    var report_kind = $('#report_kinds').val();
                    var fiscal_year = $('#fiscal_year').val();
                    var group_cd = $('#report_group').val();
                    var url = 'employee_cd='+employee_cd +'&report_kind=' + report_kind+'&fiscal_year=' + fiscal_year+'&group_cd=' + group_cd ;
                    showPopup('/weeklyreport/ri1021/viewerSetting?' + url, option, function () {
                    });
                }
            } catch (e) {
                alert('#btn_sticky' + e.message);
            }
        });
        //
        $(document).on('click', '.btn-save', function () {
            try {
                var count_check = $('#list').find('input:checkbox:checked').length;
                if (count_check == 0) {
                    jMessage(18, function (r) {
                    });
                } else {
                    // if ($('#header_content').hasClass('hide-card-common')) {
                    //     $(' .button-card').click();
                    // }
                    jMessage(1, function (r) {
                        if (r && _validate($('body'))) {
                            saveData();
                        }
                    });
                }
            } catch (e) {
                alert('#ckball:' + e.message);
            }
        });
        // remove
		$(document).on('click', '#btn_delete', function (e) {
			try {
                jMessage(3, function (r) {
				deleteData();
                })
			} catch (e) {
				console.log('#btn_delete:' + e.message);
			}
		});
        // btn_search
        $(document).on('click', '#btn_search', function (e) {
            try {
                if (_validate($('body'))) {
                    var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
                    search(page, cb_page);
                }
            } catch (e) {
                console.log('#btn_search:' + e.message);
            }
        });
        // 
        $(document).on('click', ' #result li.page-prev a.page-link:not(.pagging-disable)', function (e) {
            try {
                //
                var page_size = $('#cb_page').val();
                var page = $(this).attr('page');
                search(page, page_size);
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        // 
        $(document).on('click', ' #result li.page-next a.page-link:not(.pagging-disable)', function (e) {
            try {
                //
                var page_size = $('#cb_page').val();
                var page = $(this).attr('page');
                search(page, page_size);
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        // 
        $(document).on('change', '#result #cb_page', function (e) {
            try {
                e.preventDefault();
                var page_size = $(this).val();
                var page = 1;
                $('.page-item').each(function () {
                    if ($(this).hasClass('active')) {
                        page = $(this).attr('page');
                    }
                });
                search(page, page_size);
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        // 
        $(document).on('change', '#fiscal_year, #report_kinds', function (e) {
            try {
                e.preventDefault();
                var fiscal_year = $('#fiscal_year').val();
                var report_kind = $('#report_kinds').val();
                getGroup(fiscal_year, report_kind);
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        // btn_csv_output
        $(document).on('click', '#btn_csv_output', function (e) {
            try {
                exportCSV();
            } catch (e) {
                alert('#btn_csv_output' + e.message);
            }
        });
        // import csv
        $(document).on('click', '#btn_evaluation_import', function (e) {
            try {
                if (_validate($('body'))) {
                    $('#import_file').trigger('click');
                }
            } catch (e) {
                alert('#btn-item-evaluation-input :' + e.message);
            }
        });
        // csv
        $(document).on('change', '#import_file', function (e) {
            jMessage(6, function (r) {
                if (r && _validate($('body'))) {
                    importCSV();
                }
            });
        });
        // btn_apply_latest
        $(document).on('click', '#btn_apply_latest', function (e) {
            var count_check = $('#list').find('input:checkbox:checked').length;
            if (count_check == 0) {
                jMessage(18, function (r) {
                    return false
                });
            } else {
                // $('#report_group').addClass('required');
                if (_validate($('body'))) {
                    approval_lastest();
                }
            }
        });
    } catch (e) {
        alert('#ckball:' + e.message);
    }
}
function search(page = 1, page_size = 20) {
    try {
        if ($('#employee_nm').val() == '') {
            $('#employee_cdX').val('');
        }
        var data = getData(_obj);
        var list = [];

        data.data_sql.page = page;
        data.data_sql.page_size = page_size;
        //
        var list_org = getOrganization();
        data.data_sql.list_organization_step1 = list_org.list_organization_step1;
        data.data_sql.list_organization_step2 = list_org.list_organization_step2;
        data.data_sql.list_organization_step3 = list_org.list_organization_step3;
        data.data_sql.list_organization_step4 = list_org.list_organization_step4;
        data.data_sql.list_organization_step5 = list_org.list_organization_step5;
        var div3 = $('#position_cd').closest('.multi-select-full');
        div3.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({
                    'position_cd': $(this).val()
                });
            }
        });
        data.data_sql.list_position_cd = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/search',
            dataType: 'html',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                $('#result').empty().append(res);
                jQuery.formatInput();
                getAutocomplete();
                css_hover_row();
                app.jTableFixedHeader();
                app.jSticky();
                // if (!$('#header_content').hasClass('hide-card-common')) {
                //     $(' .button-card').click();
                // }
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
/*
 * getOrganization
 * @author    : quangnd@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function getOrganization() {
    let param = [];
    let list = [];
    var div_organization_step1 = $("#organization_step1").closest("div");
    if (div_organization_step1.hasClass("multi-select-full")) {
        var div1 = $("#organization_step1").closest(".multi-select-full");
        div1.find("input[type=checkbox]").each(function () {
            if ($(this).prop("checked")) {
                var str = $(this).val().split("|");
                //
                list.push({
                    organization_cd_1: str[0] == "undefined" ? "" : str[0],
                    organization_cd_2: str[1] == "undefined" ? "" : str[1],
                    organization_cd_3: str[2] == "undefined" ? "" : str[2],
                    organization_cd_4: str[3] == "undefined" ? "" : str[3],
                    organization_cd_5: str[4] == "undefined" ? "" : str[4],
                });
                // list.push({'organization_cd':$(this).val()});
            }
        });
    }
    param.list_organization_step1 = list;
    list = [];
    var div_organization_step2 = $("#organization_step2").closest("div");
    if (div_organization_step2.hasClass("multi-select-full")) {
        var div2 = $("#organization_step2").closest(".multi-select-full");
        div2.find("input[type=checkbox]").each(function () {
            if ($(this).prop("checked")) {
                var str = $(this).val().split("|");
                //
                list.push({
                    organization_cd_1: str[0] == "undefined" ? "" : str[0],
                    organization_cd_2: str[1] == "undefined" ? "" : str[1],
                    organization_cd_3: str[2] == "undefined" ? "" : str[2],
                    organization_cd_4: str[3] == "undefined" ? "" : str[3],
                    organization_cd_5: str[4] == "undefined" ? "" : str[4],
                });
                // list.push({'organization_cd':$(this).val()});
            }
        });
    }
    param.list_organization_step2 = list;
    list = [];
    var div_organization_step3 = $("#organization_step3").closest("div");
    if (div_organization_step3.hasClass("multi-select-full")) {
        var div3 = $("#organization_step3").closest(".multi-select-full");
        div3.find("input[type=checkbox]").each(function () {
            if ($(this).prop("checked")) {
                var str = $(this).val().split("|");
                //
                list.push({
                    organization_cd_1: str[0] == "undefined" ? "" : str[0],
                    organization_cd_2: str[1] == "undefined" ? "" : str[1],
                    organization_cd_3: str[2] == "undefined" ? "" : str[2],
                    organization_cd_4: str[3] == "undefined" ? "" : str[3],
                    organization_cd_5: str[4] == "undefined" ? "" : str[4],
                });
                // list.push({'organization_cd':$(this).val()});
            }
        });
    }
    param.list_organization_step3 = list;
    list = [];
    var div_organization_step4 = $("#organization_step4").closest("div");
    if (div_organization_step4.hasClass("multi-select-full")) {
        var div4 = $("#organization_step4").closest(".multi-select-full");
        div4.find("input[type=checkbox]").each(function () {
            if ($(this).prop("checked")) {
                var str = $(this).val().split("|");
                //
                list.push({
                    organization_cd_1: str[0] == "undefined" ? "" : str[0],
                    organization_cd_2: str[1] == "undefined" ? "" : str[1],
                    organization_cd_3: str[2] == "undefined" ? "" : str[2],
                    organization_cd_4: str[3] == "undefined" ? "" : str[3],
                    organization_cd_5: str[4] == "undefined" ? "" : str[4],
                });
                // list.push({'organization_cd':$(this).val()});
            }
        });
    }
    param.list_organization_step4 = list;
    list = [];
    var div_organization_step5 = $("#organization_step5").closest("div");
    if (div_organization_step5.hasClass("multi-select-full")) {
        var div5 = $("#organization_step5").closest(".multi-select-full");
        div5.find("input[type=checkbox]").each(function () {
            if ($(this).prop("checked")) {
                var str = $(this).val().split("|");
                //
                list.push({
                    organization_cd_1: str[0] == "undefined" ? "" : str[0],
                    organization_cd_2: str[1] == "undefined" ? "" : str[1],
                    organization_cd_3: str[2] == "undefined" ? "" : str[2],
                    organization_cd_4: str[3] == "undefined" ? "" : str[3],
                    organization_cd_5: str[4] == "undefined" ? "" : str[4],
                });
                // list.push({'organization_cd':$(this).val()});
            }
        });
    }
    param.list_organization_step5 = list;
    list = [];
    return param;
}
function css_hover_row() {
    $("#table_result tbody tr").each(function () {
        var _this = $(this);
        var emp = $(this).attr("row_emp");
        $("#table_result tbody tr[row_emp ='" + emp + "']").hover(function () {
            _this.removeClass("noneHover");
            _this.addClass("colorRow");
        }, function () {
            _this.removeClass("colorRow");
            _this.addClass("noneHover");
        });
    });
}
function getAutocomplete() {
    $(document).on('click', '#check-all', function () {
        try {
            try {
                var checked = $(this).prop('checked');
                $('#list').find('.chk-item').prop('checked', checked);
            } catch (e) {
                alert('#checkall: ' + e.message);
            }
        } catch (e) {
            alert('#ckball:' + e.message);
        }
    });
    //
    $(document).on('click', '.chk-item', function () {
        try {
            var count_check = $('#list').find('input:checkbox:checked').length;
            var check_box = $('#list').find('input:checkbox').length;
            if (count_check == check_box) {
                $('#check-all').prop('checked', true);
            } else {
                $('#check-all').prop('checked', false);
            }
        } catch (e) {
            alert('#ckball:' + e.message);
        }
    });
}
/**
 * save
 *
 * @author      :   quangnd - 2023/04/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = {};
        var list = [];
        var list_tr = [];
        var list_viewer = [];
        data.report_kind = $('#report_kinds').val();
        data.fiscal_year = $('#fiscal_year').val();
        $("#myTable tbody tr").each(function () {
            var tr = $(this);
            if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                tr.find('.viewer_employee_cd').each(function () {
                    list_viewer.push({
                        'viewer_employee_cd': $(this).val()
                    });
                    if (tr.find('.tb_employee_cd').val() == $(this).val()) {
                        list_tr.push(tr)
                    }
                }),
                    list.push({
                        'employee_cd': tr.find('.tb_employee_cd').val(),
                        'list_viewer_employee_cd': list_viewer,
                    });
                if (list_viewer.length == 0 || list_viewer.includes(tr.find('.tb_employee_cd').val())) {
                    list_tr.push(tr)
                }
            }
            list_viewer = [];
        });
        data.list_employee = list;
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            var page = $('.page-item.active').attr('page');
                			var page_size = $('#cb_page').val();
							search(page, page_size);
                            // $('#btn_search').trigger('click');
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                            $("#myTable tbody tr td").css("background-color", "white")
                            $('.m-danger .btn-ok').click(function () {
                                list_tr.forEach(el => el.find('.color-error').css("background-color", "#d9b9be"));
                            });
                            var err = [];
                            res['errors'].forEach(el => err.push(el.remark));
                            $("#myTable tbody tr").each(function () {
                                var tr = $(this);
                                if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                                    if (err.includes(tr.find('.tb_employee_cd').val())) {
                                        tr.find('.employee_cd_er').css("background-color", "#d9b9be");
                                    }
                                }
                            });
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
        alert('save' + e.message);
    }
}
function getGroup(fiscal_year = 0, report_kind = 1) {
    try {
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/get_group',
            dataType: 'json',
            loading: true,
            data: { fiscal_year: fiscal_year, report_kind: report_kind },
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var option = '<option value="-1"></option>'
                        res.data.forEach(value => {
                            option += '<option value=' + value.group_cd + '>' + value.group_nm + '</option>'
                        });
                        //console.log(option)
                        $('#report_group').empty().append(option)
                        $('#employee_nm').attr('fiscal_year_weeklyreport', fiscal_year)
                        break;
                    // error
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
/**
 * exportCSV
 *
 * @author      :  tuantv - 2018/09/30 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
    try {
        var data = getData(_obj);
        var list = [];
        data.data_sql.page = 1;
        data.data_sql.page_size = 20;
        var list_org = getOrganization();
        data.data_sql.list_organization_step1 = list_org.list_organization_step1;
        data.data_sql.list_organization_step2 = list_org.list_organization_step2;
        data.data_sql.list_organization_step3 = list_org.list_organization_step3;
        data.data_sql.list_organization_step4 = list_org.list_organization_step4;
        data.data_sql.list_organization_step5 = list_org.list_organization_step5;
        var div3 = $('#position_cd').closest('.multi-select-full');
        div3.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({
                    'position_cd': $(this).val()
                });
            }
        });
        data.data_sql.list_position_cd = list;
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/export',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        var filedownload = res['FileName'];
                        var filename = '閲覧者設定.csv';
                        if ($('#language_jmessages').val() == 'en') {
                            filename = 'ViewerSetting.csv';
                        }
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, filename, function () {
                                //
                            });
                        } else {
                            jError(2);
                        }
                        break;
                    case NG:
                        jMessage(21);
                        break;
                    case EX:
                        jMessage(22);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('exportCSV' + e.message);
    }
}
/**
 * importCSV
 *
 * @author      :  tuantv - 2018/10/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
    try {
        var formData = new FormData();
        formData.append('file', $('#import_file')[0].files[0]);
        formData.append('report_kinds', $('#report_kinds').val());
        formData.append('fiscal_year', $('#fiscal_year').val());
        //処遇用途
        //send ajax
        $.ajax({
            type: 'POST',
            data: formData,
            url: '/weeklyreport/ri1021/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function (res) {
                switch (res['status']) {
                    // success
                    case 200:
                        jMessage(7, function (r) {
                            var page = $('.page-item.active').attr('page');
                			var page_size = $('#cb_page').val();
							search(page, page_size);
                            // search(1, 20);
                        });
                        break;
                    // error
                    case 201:
                        jMessage(22, function () {
                            $('#import_file').val('');
                        });
                        break;
                    // csv content is empty
                    case 202:
                        // 対象データがありません。
                        jMessage(23, function () {
                            $('#import_file').val('');
                        });
                        break;
                    // not csv format
                    case 206:
                        jMessage(27, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    // csv content error
                    case 207:
                        var filedownload = res['FileName'];
                        var filename = '閲覧者設定【エラー】.csv';
                        if ($('#language_jmessages').val() == 'en') {
                            filename = 'ViewerSettingError.csv';
                        }
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, filename, function () {
                                //
                            });
                        }
                        break;
                    // csv colum not correct 
                    case 208:
                        jMessage(31, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
                $("#import_file").val("");
            }
        });
    } catch (e) {
        alert('importCSV: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   quangnd - 2023/04/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function approval_lastest() {
    try {
        var page = 1;
        $('.page-item').each(function () {
            if ($(this).hasClass('active')) {
                page = $(this).attr('page');
            }
        });
        var page_size = $('#cb_page').val();

        var data = getData(_obj);
        var list = [];
        var list_emp = [];
        data.data_sql.page = page;
        data.data_sql.page_size = page_size;
        //
        var list_org = getOrganization();
        data.data_sql.list_organization_step1 = list_org.list_organization_step1;
        data.data_sql.list_organization_step2 = list_org.list_organization_step2;
        data.data_sql.list_organization_step3 = list_org.list_organization_step3;
        data.data_sql.list_organization_step4 = list_org.list_organization_step4;
        data.data_sql.list_organization_step5 = list_org.list_organization_step5;
        var div3 = $('#position_cd').closest('.multi-select-full');
        div3.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({
                    'position_cd': $(this).val()
                });
            }
        });
        data.data_sql.list_position_cd = list;
        $("#myTable tbody tr").each(function () {
            var tr = $(this);
            if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                list_emp.push({
                    'employee_cd': tr.find('.tb_employee_cd').val(),
                });
            }
            list_viewer = [];
        });
        data.data_sql.list_employee_cd = list_emp;
        console.log(data);
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/approval_lastest',
            dataType: 'html',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                $('#result').empty().append(res);
                jQuery.formatInput();
                getAutocomplete();
                css_hover_row();
                app.jTableFixedHeader();
                app.jSticky();
                if ($('#list').find('input:checkbox:checked').length == $('#list').find('input:checkbox').length && $('#list').find('input:checkbox').length > 0) {
                    $('#check-all').prop('checked', true);
                }
                // $('#report_group').removeClass('required');
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   namnt
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var page = 1;
        $('.page-item').each(function () {
            if ($(this).hasClass('active')) {
                page = $(this).attr('page');
            }
        });
        var page_size = $('#cb_page').val();

        var data = getData(_obj);
        var list = [];
        data.data_sql.page = page;
        data.data_sql.page_size = page_size;
        $("#myTable tbody tr").each(function () {
            var tr = $(this);
            if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                    list.push({
                        'employee_cd': tr.find('.tb_employee_cd').val(),
                    });
            }
        });
        var count_check = list.length;
            if (count_check == 0) {
                jMessage(18, function (r) {
                    return false
                });
            } else {
        data.data_sql.list_employee = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/ri1021/delete',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                    switch (res['status']) {
                        // success
                       
                        case OK:
                            jMessage(4, function (r) {
                                $('#btn_search').trigger('click')
                            });
                            break;
                        // error
                        case NG:
                        if (typeof res['errors'] != 'undefined') {
                            jMessage(21, function(r) {
                            $('.m-danger .btn-ok').click(function () {
                                list_tr.forEach(el => el.find('.color-error').css("background-color", "#d9b9be"));
                            });
                            $("#myTable tbody tr td").css("background-color", "white")
                            var err = [];
                            res['errors'].forEach(el => err.push(el.remark));
                            $("#myTable tbody tr").each(function () {
                                var tr = $(this);
                                if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                                    if (err.includes(tr.find('.tb_employee_cd').val())) {
                                        tr.find('.lblCheck').css("background-color", "#d9b9be");
                                    }
                                }
                            });
                        })
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
    }
    } catch (e) {
        alert('search: ' + e.message);
    }
}