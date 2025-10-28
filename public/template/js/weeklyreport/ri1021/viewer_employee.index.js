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
        _formatTooltip();
        $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
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
        //        // add
        $(document).on('click', '#btn_add', function (e) {
            try {
                if ($('#popup_result .pagination').length > 0) {
                    if ($('#popup_result .pagination li').last().hasClass('pagging-disable')) {
                        addRow();
                    } else {
                        // get page last
                        var li = $('#popup_result .pagination li').last(),
                            page = li.find('a').attr('page');
                        var cb_page = $('#popup_result #cb_page').val();
                        var cb_page = cb_page == '' ? 20 : cb_page;
                        search(page, cb_page, true);
                    }
                }
            } catch (e) {
                alert('#btn_add:' + e.message);
            }
        });
        // 
        $(document).on('click', ' #popup_result li.page-prev a.page-link:not(.pagging-disable)', function (e) {
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
        $(document).on('click', ' #popup_result li.page-next a.page-link:not(.pagging-disable)', function (e) {
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
        $(document).on('change', '#popup_result #cb_page', function (e) {
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
        $(document).on('change', '.employee_nm_weeklyreport, .employee_cd_add', function (e) {
            try {
                e.preventDefault();
                var employee_cd = $(this).closest(".tr_employee").find('.employee_cd_add').val();
                var tr = $(this).closest(".tr_employee");
                if (employee_cd == '') {
                    $(this).val('');
                    return false;
                } else {
                    refer_emp(tr, employee_cd)
                }
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        //
        $(document).on('click', '#btn_apply', function (e) {
            try {
                var html = '';
                var viewer = '';
                var list = [];
                $("#popup_list tr").each(function () {
                    var tr = $(this);
                    if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
                        viewer += tr.find('.tb_employee_nm').val() + '、';
                        html += '<input type="hidden" class="viewer_employee_cd" value="' + tr.find('.tb_employee_cd').val() + '">'
                        list.push(tr.find('.tb_employee_cd').val())
                    }
                });
                if (list.length == 0) {
                    jMessage(18, function (r) {
                        return false;
                    });
                }
                else if (list.length == (uniqueArray(list)).length) {
                    $('#btn-close-popup').trigger('click');
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_nm').attr("data-original-title", viewer.slice(0, -1));
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_nm').text(viewer.slice(0, -1));
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_cd').empty().append(html);
                } else {
                    jMessage(32, function (r) {
                        return false;
                    });
                }
            } catch (e) {
                console.log('#btn_apply_latest:' + e.message);
            }
        });
    } catch (e) {

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
        var data = {};
        data.page = page;
        data.page_size = page_size;
        data.fiscal_year = $('#popup_fiscal_year').val();
        data.report_kind = $('#popup_report_kind').val();
        data.employee_cd = $('#popup_employee_cd').val();
        data.group_cd = $('#popup_group_cd').val();
        // send data to post 
        $.ajax({
            type: "POST",
            url: "/weeklyreport/ri1021/viewerSetting/search",
            dataType: "html",
            data: data,
            loading: true,
            success: function (res) {
                $("#popup_result").empty().append(res);
                if (is_add_row) {
                    addRow();
                }
                _formatTooltip();
            },
        });
    } catch (e) {
        alert("save" + e.message);
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
        $('#popup_list').append(html);
        $('#popup_list tr:last input').focus();
        $.formatInput();
    } catch (e) {
        console.log('addRow' + e.message);
    }
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
            url: '/weeklyreport/ri1021/refer_emp',
            dataType: 'json',
            data: { employee_cd: employee_cd, fiscal_year: $('#fiscal_year').val(), report_kind: $('#popup_report_kind').val(), group_cd: $('#popup_group_cd').val()},
            loading: true,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        var time = (Date.now())
                        if (res.data.status == 87) {
                            jMessage(87, function (r) {
                                tr.find('.employee_cd_add').val('')
                                tr.find('.employee_nm_weeklyreport').val('')
                                tr.find('.employee_nm_weeklyreport ').focus()
                            });
                        } else if (res.data.status == 1) {
                            tr.find('.lab_chk').attr('for', time)
                            tr.find('.inp_chk').attr('id', time)
                            tr.find('.tb_employee_cd').val(res.data.employee_cd)
                            tr.find('.div_employee_cd').empty()
                            tr.find('.div_employee_cd').text(res.data.employee_cd)
                            tr.find('.tb_employee_nm').val(res.data.employee_nm)
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
                            tr.find('.position_nm').attr('data-original-title', res.data.position_nm)
                            tr.find('.position_nm').text(res.data.position_nm)
                            _formatTooltip();
                            $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
                            $.formatInput();
                        }
                        else {
                            tr.find('.employee_cd_add').val('')
                            tr.find('.employee_nm_weeklyreport').val('')
                            tr.find('.employee_nm_weeklyreport ').focus()
                        }
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case EX: checkbox
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
function uniqueArray(orinalArray) {
    return orinalArray.filter((elem, position, arr) => {
        return arr.indexOf(elem) == position;
    });
}