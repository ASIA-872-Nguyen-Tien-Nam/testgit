/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2023/02/16
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package		    :	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		    :	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'mygroup_cd': { 'type': 'text', 'attr': 'id' }
    , 'employee_cd': { 'type': 'text', 'attr': 'id' }
    , 'employee_name': { 'type': 'text', 'attr': 'id' }
    , 'employee_typ': { 'type': 'select', 'attr': 'id' }
    , 'position_cd': { 'type': 'select', 'attr': 'id' }
    , 'grade': { 'type': 'select', 'attr': 'id' }
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
        $('#mygroup_nm').focus();
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
 * INIT EVENTS
 * @author		:	longvv - 2018/09/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
        $(document).on('click', '#btn-back', function (e) {
            try {
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                console.log('#btn-back:' + e.message);
            }
        });
        // add
        $(document).on('click', '#btn_add', function (e) {
            try {
                try {
                    if ($('#data-search .pagination').length > 0) {
                        if ($('#data-search .pagination li').last().hasClass('pagging-disable')) {
                            addRow();
                        } else {
                            // get page last
                            var li = $('#data-search .pagination li').last(),
                                page = li.find('a').attr('page');
                            var cb_page = $('#cb_page').val();
                            var cb_page = cb_page == '' ? 20 : cb_page;
                            search(page, cb_page, true);
                        }
                    }
                } catch (e) {
                    alert('#btn_add:' + e.message);
                }
            } catch (e) {
                console.log('#btn_add:' + e.message);
            }
        });
        /* paging */
        $(document).on('click', '#leftcontent li.page-prev a.page-link:not(.pagging-disable)', function (e) {
            try {
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch (e) {
                alert('page-link: ' + e.message);
            }
        });
        $(document).on('click', '#leftcontent li.page-next a.page-link:not(.pagging-disable)', function (e) {
            try {
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch (e) {
                alert('page-link: ' + e.message);
            }
        });
        //search key
        $(document).on('click', '#leftcontent #btn-search-key', function (e) {
            try {
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch (e) {
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('change', '#leftcontent #search_key', function (e) {
            try {
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch (e) {
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('enterKey', '#leftcontent #search_key', function (e) {
            try {
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch (e) {
                alert('btn-search-key: ' + e.message);
            }
        });
        //
        $(document).on('click', '#check-all', function () {
            try {
                try {
                    var checked = $(this).prop('checked');
                    $('#table-check').find('.chk-item').prop('checked', checked);
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
                var count_check = $('#table-check').find('input:checkbox:checked').length;
                var check_box = $('#table-check').find('input:checkbox').length;
                if (count_check == check_box) {
                    $('#check-all').prop('checked', true);
                } else {
                    $('#check-all').prop('checked', false);
                }
            } catch (e) {
                alert('#ckball:' + e.message);
            }
        });
        /* left content click item */
        $(document).on('click', '.list-search-content .list-search-child', function (e) {
            try {
                var mygroup_nm = $(this).find('.mygroup_nm').val();
                var mygroup_cd = $(this).find('.mygroup_cd').val();
                getRightContent(mygroup_cd, mygroup_nm, 1, 20)
            } catch (e) {
                alert('list-search-child-refer: ' + e.message);
            }
        });
        // btn_search
        $(document).on('click', '#btn_search', function (e) {
            try {
                $('#mode_find').val(0);
                setTimeout(() => {
                    search(1, 20);
                }, 50);
            } catch (e) {
                console.log('#btn_search:' + e.message);
            }
        });
        //
        $(document).on('click', '#btn-new-signup', function (e) {
            try {
                jMessage(5, function (r) {
                    getRightContent(-1, '', 1, 20);
                });
            } catch (e) {
                console.log('#btn-new-signup:' + e.message);
            }
        });
        // 
        $(document).on('click', ' #data-search li.page-prev a.page-link:not(.pagging-disable)', function (e) {
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
        $(document).on('click', ' #data-search li.page-next a.page-link:not(.pagging-disable)', function (e) {
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
        $(document).on('change', '#data-search #cb_page', function (e) {
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
        $(document).on('change', '#data-search .employee_nm_weeklyreport, .employee_cd_add', function (e) {
            try {
                e.preventDefault();
                var employee_cd = $(this).closest(".tr_employee").find('.employee_cd_add').val();
                var tr = $(this).closest(".tr_employee");
                if (employee_cd == '') {
                    $(this).val('');
                    return false;
                }
                refer_emp(tr, employee_cd)
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        //
        $(document).on('click', '.btn-save', function () {
            try {
                jMessage(1, function (r) {
                    var count_check = $('#table-check').find('input:checkbox:checked').length;
                    if (count_check == 0) {
                        jMessage(18, function (r) {
                            return false;
                        });
                    } else {
                        if ($('#rightcontent').find('.hide-card-common').length > 0) {
                            $(' .button-card').click();
                        }
                        if (r && _validate($('body'))) {
                            saveData();
                        }
                    }
                });
            } catch (e) {
                alert('.btn-save: ' + e.message);
            }
        });
        //
        $(document).on('click', '#btn-delete', function (e) {
            try {
                if ($('#rightcontent').find('.hide-card-common').length > 0) {
                    $(' .button-card').click();
                }
                jMessage(3, function (r) {
                    deleteData()
                });
            } catch (e) {
                alert('#btn-delete' + e.message);
            }
        });
    } catch (e) {
        console.log('initEvents:' + e.message);
    }
}
/**
 * getLeftContent
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2011/leftcontent',
            dataType: 'html',
            loading: true,
            data: { current_page: page, search_key: search },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty().html(res);
                    //
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}
/**
 * getRightContent
 *
 * @author      :    quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(mygroup_cd, mygroup_nm, page, page_size) {
    try {
        var data = getData(_obj);
        data.data_sql.page = page;
        data.data_sql.page_size = page_size;
        data.data_sql.employee_cd = '';
        data.data_sql.employee_name = '';
        data.data_sql.employee_typ = -1;
        data.data_sql.grade = -1;
        data.data_sql.position_cd = -1;
        data.data_sql.mygroup_cd = mygroup_cd;
        data.data_sql.mygroup_nm = mygroup_nm;
        data.data_sql.mode = 1;
        //
        data.data_sql.list_organization_step1 = [];
        data.data_sql.list_organization_step2 = [];
        data.data_sql.list_organization_step3 = [];
        data.data_sql.list_organization_step4 = [];
        data.data_sql.list_organization_step5 = [];
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2011/rightcontent',
            dataType: "html",
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                $('#rightcontent .inner').empty().append(res);
                $('#mygroup_nm').focus();
                $(".multiselect").multiselect({
                    onChange: function () {
                        $.uniform.update();
                    },
                });
                if ($('#rightcontent').find('.hide-card-common').length < 1 && $('.tr_employee').length > 1) {
                    $(' .button-card').click();
                }
                if ($('#table-check').find('input:checkbox:checked').length == $('#table-check').find('input:checkbox').length && $('#table-check').find('input:checkbox').length > 0) {
                    $('#check-all').prop('checked', true);
                }
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * SEARCH
 *
 * @author      :   quangnd - 2023/04/24 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function search(page, page_size, is_add_row = false) {
    try {
        var data = getData(_obj);
        data.data_sql.page = page;
        data.data_sql.page_size = page_size;
        data.data_sql.mode = $('#mode_find').val();
        //
        var list_org = getOrganization();
        data.data_sql.list_organization_step1 = list_org.list_organization_step1;
        data.data_sql.list_organization_step2 = list_org.list_organization_step2;
        data.data_sql.list_organization_step3 = list_org.list_organization_step3;
        data.data_sql.list_organization_step4 = list_org.list_organization_step4;
        data.data_sql.list_organization_step5 = list_org.list_organization_step5;
        // send data to post 
        $.ajax({
            type: "POST",
            url: "/weeklyreport/rq2011/search",
            dataType: "html",
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                $("#data-search").empty().append(res);
                // if ($('#rightcontent').find('.hide-card-common').length < 1) {
                //     $(' .button-card').click();
                // }
                if (is_add_row) {
                    addRow();
                }
                _formatTooltip();
                if ($('#table-check').find('input:checkbox:checked').length == $('#table-check').find('input:checkbox').length) {
                    $('#check-all').prop('checked', true);
                }
            },
        });
    } catch (e) {
        alert("save" + e.message);
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
/**
 * refer Employee_cd
 *
 * @author  :   quangnd - 25/04/2023 - create
 * @author  :
 *
 */
function refer_emp(tr, employee_cd) {
    try {
        //
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2011/refer_emp',
            dataType: 'json',
            data: { employee_cd: employee_cd },
            loading: true,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        var time = (Date.now())
                        if (res.data.status == 1) {
                            tr.find('.lab_chk').attr('for', time)
                            tr.find('.inp_chk').attr('id', time)
                            tr.find('.tb_employee_cd').val(res.data.employee_cd)
                            tr.find('.employee_cd').empty()
                            tr.find('.employee_cd').text(res.data.employee_cd)
                            tr.find('.employee_nm').attr('data-original-title', res.data.employee_nm)
                            tr.find('.employee_nm').text(res.data.employee_nm)
                            tr.find('.employee_typ_nm').attr('data-original-title', res.data.employee_typ_nm)
                            tr.find('.employee_typ_nm').text(res.data.employee_typ_nm)
                            tr.find('.organization_nm_1').attr('data-original-title', res.data.belong_nm_1)
                            tr.find('.organization_nm_1').text(res.data.belong_nm_1)
                            tr.find('.organization_nm_2').attr('data-original-title', res.data.belong_nm_2)
                            tr.find('.organization_nm_2').text(res.data.belong_nm_2)
                            tr.find('.organization_nm_3').attr('data-original-title', res.data.belong_nm_3)
                            tr.find('.organization_nm_3').text(res.data.belong_nm_3)
                            tr.find('.organization_nm_4').attr('data-original-title', res.data.belong_nm_4)
                            tr.find('.organization_nm_4').text(res.data.belong_nm_4)
                            tr.find('.organization_nm_5').attr('data-original-title', res.data.belong_nm_5)
                            tr.find('.organization_nm_5').text(res.data.belong_nm_5)
                            tr.find('.job_nm').attr('data-original-title', res.data.job_nm)
                            tr.find('.job_nm').text(res.data.job_nm)
                            tr.find('.position_nm').attr('data-original-title', res.data.position_nm)
                            tr.find('.position_nm').text(res.data.position_nm)
                            tr.find('.grade_nm').attr('data-original-title', res.data.grade_nm)
                            tr.find('.grade_nm').text(res.data.grade_nm)
                        }
                        else {
                            tr.find('.employee_cd_add').val('')
                            tr.find('.employee_cd_add').focus()
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
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
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
function saveData() {
    try {
        var data = {};
        var list_cre = [];
        var list_del = [];
        var check = [];
        data.mygroup_cd = $('#mygroup_cd').val();
        data.mygroup_nm = $('#mygroup_nm').val();
        $("#myTable tbody tr").each(function () {
            var tr = $(this);
            if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                list_cre.push({
                    'employee_cd': tr.find('.tb_employee_cd').val()
                });
                check.push(tr.find('.tb_employee_cd').val());
            }
        });
        $("#myTable tbody tr").each(function () {
            var tr = $(this);
            list_del.push({
                'employee_cd': tr.find('.tb_employee_cd').val()
            });
        });
        data.cre_employee = list_cre;
        data.del_employee = list_del;
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2011/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            getLeftContent(1, '');
                            getRightContent(-1, '', 1, 20);
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                            var duplicates = check.filter((element, index, arr) => arr.indexOf(element) !== index)
                            $("#myTable tbody tr").each(function () {
                                var tr = $(this);
                                if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                                    var emp = tr.find('.tb_employee_cd').val()
                                    if (duplicates.includes(emp)) {
                                        tr.find('.check-color').css("background-color", "#d9b9be");
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

/**
 * delete data
 *
 * @author      :   quangnd - 2023/04/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */

function deleteData() {
    try {
        var mygroup_cd = $('#mygroup_cd').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2011/delete',
            dataType: 'json',
            loading: true,
            data: { mygroup_cd: mygroup_cd },
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(4, function (r) {
                            location.reload();
                        });
                        break;
                    // error
                    case NG:
                        console.log(res['errors']);
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
        alert('save' + e.message);
    }
}
/*
 * Add new row
 * @author		:	viettd - 2023/02/16 - create
 * @return		:	null
 */
function addRow() {
    try {
        var html = $('#table_row_add').find('tbody').html();
        // append table
        $('#myTable tbody').append(html);
        $('#myTable tbody tr:last input').focus();
        $.formatInput();
    } catch (e) {
        console.log('addRow' + e.message);
    }
}
