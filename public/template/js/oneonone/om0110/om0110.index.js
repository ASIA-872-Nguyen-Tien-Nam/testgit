/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : url customer
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var max_cate = 0;
var max_low_cate = 0;
var _flgLeft = 0;
var _obj = {
    'refer_kbn': { 'type': 'hidden', 'attr': 'id' }
    , 'questionnaire_cd': { 'type': 'hidden', 'attr': 'id' }
    , 'questionnaire_nm': { 'type': 'text', 'attr': 'id' }
    , 'submit': { 'type': 'radiobox', 'attr': 'id', 'name': 'submit' }
    , 'comment_use_typ': { 'type': 'hidden', 'attr': 'id' }
    , 'purpose': { 'type': 'text', 'attr': 'id' }
    , 'purpose_use_typ': { 'type': 'text', 'attr': 'id' }
    , 'complement': { 'type': 'text', 'attr': 'id' }
    , 'complement_use_typ': { 'type': 'text', 'attr': 'id' }
    , 'company_cd_refer': { 'type': 'text', 'attr': 'id' }
    , 'browsing_setting': {
        'attr': 'list', 'item': {
            'questionnaire_gyono': { 'type': 'text', 'attr': 'class' }
            , 'question': { 'type': 'text', 'attr': 'class' }
            , 'question_typ': { 'type': 'text', 'attr': 'class' }
            , 'sentence_use_typ': { 'type': 'select', 'attr': 'class' }
            , 'points_use_typ': { 'type': 'select', 'attr': 'class' }
            , 'guideline_10point': { 'type': 'select', 'attr': 'class' }
            , 'guideline_5point': { 'type': 'select', 'attr': 'class' }
            , 'guideline_0point': { 'type': 'select', 'attr': 'class' }
        },
    },
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
        _setTabIndex();
        $('#category1_nm').focus();
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
    $('.tr').each(function () {
        if ($(this).attr('cate_no') * 1 > max_cate) {
            max_cate = $(this).attr('cate_no') * 1;
        }
        if ($(this).find('.low-cate').attr('low_cate_cd') * 1 > max_low_cate) {
            max_low_cate = $(this).find('.low-cate').attr('low_cate_cd') * 1;
        }
    });
    $(document).on('click', '.mid-cate', function () {
        try {
            $('.mid-selected').removeClass('mid-selected');
            $('.low-selected').removeClass('low-selected');
            $(this).addClass('mid-selected');
        } catch (e) {
            alert('mid-cate: ' + e.message);
        }
    });
    $(document).on('click', '.low-cate', function () {
        try {
            var parent_cate_no = $(this).parents('tr').attr('cate_no');
            $('.mid-selected').removeClass('mid-selected');
            $('.low-selected').removeClass('low-selected');
            $('tr[cate_no=' + parent_cate_no + ']:eq(0)').find('.mid-cate').addClass('mid-selected');
            $(this).addClass('low-selected');
        } catch (e) {
            alert('low-cate: ' + e.message);
        }
    });
    $(document).on('click', '.small-cate', function () {
        try {
            var parent_cate_no = $(this).parents('tr').attr('cate_no');
            $('.mid-selected').removeClass('mid-selected');
            $('.low-selected').removeClass('low-selected');
            $('tr[cate_no=' + parent_cate_no + ']:eq(0)').find('.mid-cate').addClass('mid-selected');
            var low_cate_cd = $(this).parents('tr').find('.low-cate').attr('low_cate_cd');
            $('tr[cate_no=' + parent_cate_no + '] td[low_cate_cd=' + low_cate_cd + ']:not(:hidden)').addClass('low-selected');
        } catch (e) {
            alert('low-cate: ' + e.message);
        }
    });

    //btn-add-row
    $(document).on('click', '#btn-add-mid', function () {
        try {
            var row = $("#table-target tbody tr:first").clone();
            var cate_no = $('#table-data tbody tr:last').attr('cate_no') * 1 + 1;
            // max_cate         = max_cate + 1;
            // max_low_cate    = max_low_cate + 1;
            $('#table-data tbody').append(row);
            $('#table-data tbody tr:last').addClass('tr');
            $('#table-data tbody tr:last').attr('cate_no', cate_no);
            $('#table-data tbody tr:last').find('.low-cate').attr('low_cate_cd', 1);
            $('.mid-selected').removeClass('mid-selected');
            $('.low-selected').removeClass('low-selected');
            $('#table-data').find('tbody tr:last .mid-cate').addClass('mid-selected');
            $('#table-data').find('tbody tr:last .low-cate').addClass('low-selected');
            $('#table-data').find('tbody tr:last td:first-child input').focus();
            $.formatInput('#table-data tbody tr:last');
        } catch (e) {
            alert('btn-add-mid: ' + e.message);
        }
    });
    $(document).on('click', '#btn-add-low', function () {
        try {
            var cate_no = $('.mid-selected').parents('tr').attr('cate_no');
            var cur_row_span = $('.mid-selected').attr('rowspan');
            var row = $("#table-target tbody tr:eq(1)").clone();
            $('.low-selected').removeClass('low-selected');
            //  max_low_cate    = max_low_cate + 1;
            var max_low_cate2 = $("tr[cate_no='" + cate_no + "']").last().find('.low-cate').attr('low_cate_cd') * 1 + 1;
            var category2_cd = $("tr[cate_no='" + cate_no + "']").last().find('.category2_cd').val();
            $("tr[cate_no='" + cate_no + "']").last().after(row);
            $('table:not(:hidden) .new-tr').attr('cate_no', cate_no);
            $('table:not(:hidden) .new-tr .low-cate').attr('low_cate_cd', max_low_cate2);
            $('table:not(:hidden) .new-tr .low-cate').addClass('low-selected');
            $('table:not(:hidden) .new-tr .low-cate input').focus();
            $('table:not(:hidden) .new-tr .mid-cate .category2_cd').val(category2_cd);
            $('table:not(:hidden) .new-tr').removeClass('new-tr');
            $('.mid-selected').attr('rowspan', cur_row_span * 1 + 1);
        } catch (e) {
            alert('btn-add-low: ' + e.message);
        }
    });
    $(document).on('click', '#btn-add-detail', function (e) {
        try {
            e.preventDefault();
            var cate_no = $('.low-selected').parents('tr').attr('cate_no');
            var low_cur_row_span = $('.low-selected').attr('rowspan');
            var mid_cur_row_span = $("tr[cate_no='" + cate_no + "']").first().find('.mid-cate').attr('rowspan');
            var low_cate_cd = $('.low-selected').attr('low_cate_cd');
            var row = $("#table-target tbody tr:eq(2)").clone();
            var category2_cd = $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']').last().parents('tr').find('.category2_cd').val();
            var category3_cd = $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']').last().parents('tr').find('.category3_cd').val();
            $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']').last().parents('tr').after(row);
            $('table:not(:hidden) .new-tr').attr('cate_no', cate_no);
            $('table:not(:hidden) .new-tr').find('.low-cate').attr('low_cate_cd', low_cate_cd);
            $('table:not(:hidden) .new-tr .td-detail input').focus();
            $('table:not(:hidden) .new-tr .mid-cate .category2_cd').val(category2_cd);
            $('table:not(:hidden) .new-tr .low-cate .category3_cd').val(category3_cd);
            $('table:not(:hidden) .new-tr').removeClass('new-tr');
            $('.low-selected').attr('rowspan', low_cur_row_span * 1 + 1);
            $("tr[cate_no='" + cate_no + "'] .mid-cate").attr('rowspan', mid_cur_row_span * 1 + 1);
        } catch (e) {
            alert('btn-add-deatail: ' + e.message);
        }
    });
    $(document).on('click', '.btn-remove-row', function () {
        try {
            var cate_no = $(this).parents('tr').attr('cate_no');
            var mid_rowspan = $('tr[cate_no=' + cate_no + ']:eq(0) .mid-cate').attr('rowspan');
            var low_cate_cd = $(this).parents('tr').find('.low-cate').attr('low_cate_cd');
            var low_rowspan = $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']:eq(0)').attr('rowspan');
            $(this).parents('tr').remove();
            $('tr[cate_no=' + cate_no + ']:eq(0) .mid-cate').removeClass('hidden');
            $('tr[cate_no=' + cate_no + '] .mid-cate').attr('rowspan', mid_rowspan * 1 - 1);
            $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']').attr('rowspan', low_rowspan * 1 - 1);
            $('tr[cate_no=' + cate_no + '] td[low_cate_cd=' + low_cate_cd + ']:eq(0)').removeClass('hidden');
            $('tr[cate_no=' + cate_no + ']:eq(0) .low-cate').find('').removeClass('hidden');
        } catch (e) {
            alert('btn-remove-row: ' + e.message);
        }
    });

    /* paging */
    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
        try {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('page-link: ' + e.message);
        }
    });
    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
        try {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('page-link: ' + e.message);
        }
    });
    $(document).on('click', '#btn-search-key', function (e) {
        try {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });
    $(document).on('change', '#search_key', function (e) {
        try {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });
    $(document).on('enterKey', '#search_key', function (e) {
        try {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });

    /* left content click item */
    $(document).on('click', '.list-search-child', function (e) {
        try {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var category1_cd = $(this).attr('id');
            var company_cd = $(this).attr('company_cd');
            var refer_kbn = $(this).attr('refer_kbn');
            var contract_company_attribute = $(this).attr('contract_company_attribute');
            getRightContent(category1_cd, company_cd, refer_kbn, contract_company_attribute);
        } catch (e) {
            alert('list-search-child-refer: ' + e.message);
        }
    });
    /* end click item */

    // btn-save
    $(document).on('click', '.btn-save', function (e) {
        try {
            var check = $('#table-data tbody tr.tr').length;
            jMessage(1, function (r) {
                _flgLeft = 1;
                if (check > 0) {
                    if (r && _validate($('#rightcontent'))) {
                        $('#table-data tr').each(function () {
                            if (typeof $(this).data('uid') != 'undefined') {
                                $(this).removeClass($(this).data('uid'));
                            }
                            var uid = generateGuid();
                            $(this).data('uid', uid).addClass(uid);
                        });
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

    //btn-add-new
    $(document).on('click', '#btn-add-new', function (e) {
        try {
            jMessage(5, function () {
                var category1_cd = 0;
                getRightContent(category1_cd, -1, 0,-1);
                $('#category1_nm').focus();
                $('.list-search-child').removeClass('active');
            })
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });

    // button export
    $(document).on('click', '#btn-export', function (e) {
        try {
            var category1_cd = $('#category1_cd').val();
            if (category1_cd > 0) {
                exportCSV();
            } else {
                jMessage(21);
            }
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

}

/**
 * getLeftContent
 *
 * @author      :   duongntt - 2020/10/23 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        var url = _customerUrl('/oneonone/om0110/leftcontent');
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'html',
            loading: true,
            data: { current_page: page, search_key: search },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    // var category1_cd = $('#category1_cd').val();
                    // $('.list-search-content div[id="' + category1_cd + '"]').addClass('active');
                    if (_flgLeft != 1) {
                        $('#search_key').focus();
                    } else {
                        _flgLeft = 0;
                    }
                    $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
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
 * @author      :   duongntt - 2020/10/23 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(category1_cd, company_cd, refer_kbn, contract_company_attribute) {
    try {
        var url = _customerUrl('/oneonone/om0110/rightcontent');
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'html',
            loading: true,
            data: { category1_cd: category1_cd, company_cd: company_cd, refer_kbn: refer_kbn },
            success: function (res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                if (company_cd == '0' && contract_company_attribute !== '1') {
                    $('.dropdown-item-delete').parent('li').hide(); //pc
                    $('.dropdown-item-delete').hide();              //mobile
                }else{
                    $('.dropdown-item-delete').parent('li').show(); //pc
                    $('.dropdown-item-delete').show();              //mobile
                }
                //
                $('#category1_nm').focus();
                $.formatInput();
                app.jTableFixedHeader();
                _setTabIndex();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * saveData
 *
 * @author      :   duongntt - 2020/10/23 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var url = _customerUrl('/oneonone/om0110/save');
        var data = {};
        data.list_data = getDataInsert();
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function () {
                            var category1_cd = 0;
                            getRightContent(category1_cd, -1, 0,-1);
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#category1_nm').focus();
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            for (var i = 0; i < res['errors'].length; i++) {
                                $(res['errors'][i]['item']).addClass('XXX');
                                errorStyleI1020($(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
                                checkTabError();
                            }
                        }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
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
 * delete
 *
 * @author      :   SonDH - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var url = _customerUrl('/oneonone/om0110/delete');
        var data = {};
        data.category1_cd = $('#category1_cd').val();
        data.company_cd_refer = $('#company_cd_refer').val();
        data.refer_kbn = $('#refer_kbn').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(4, function () {
                            var category1_cd = 0;
                            getRightContent(category1_cd, -1, 0,-1);
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#category1_nm').focus();
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
        data.category1_cd = $('#category1_cd').val();
        data.company_cd_refer = $('#company_cd_refer').val();
        data.refer_kbn = $('#refer_kbn').val();
        var url = _customerUrl('/oneonone/om0110/export');
        //
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        var filedownload = res['FileName'];
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, question_master+'.csv', function () {
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
        var url = _customerUrl('/oneonone/om0110/import');
        $.ajax({
            type: 'POST',
            data: formData,
            url: url,
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function (res) {
                switch (res['status']) {
                    case 200:
                        var tbody = $('#table-data');
                        tbody.empty();
                        tbody.append(res.data_import);
                        $("#import_file").val("");
                        break;
                    // error
                    case 201:
                        jMessage(22);
                        break;
                    case 206:
                        jMessage(27, function (r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 207:
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
            }
        });
    } catch (e) {
        alert('importCSV: ' + e.message);
    }
}

function getDataInsert() {
    var data = {};
    var row_id = 0;
    var category1_cd = $('#category1_cd').val();
    var category1_nm = $('#category1_nm').val();
    var company_cd_refer = $('#company_cd_refer').val();
    var refer_kbn = $('#refer_kbn').val();
    $('#table-data').find('tbody tr:visible').each(function (j, row_tr) {
        var $row = $(row_tr),
            $category2_cd = $row.find('.category2_cd'),
            $category2_nm = $row.find('.category2_nm'),
            $category3_cd = $row.find('.category3_cd'),
            $category3_nm = $row.find('.category3_nm'),
            $question_cd = $row.find('.question_cd'),
            $question = $row.find('.question'),
            $cate2_no = $row.attr('cate_no'),
            $cate3_no = $row.find('.low-cate').attr('low_cate_cd');

        var rowdata = {};
        rowdata['category1_cd'] = category1_cd;
        rowdata['category1_nm'] = category1_nm;
        rowdata['category2_cd'] = $category2_cd.val();
        // rowdata['category2_no'] = $row.attr('cate_no')*1;
        rowdata['category2_nm'] = $category2_nm.val();
        rowdata['category3_cd'] = $category3_cd.val();
        rowdata['category3_nm'] = $category3_nm.val();
        rowdata['question_cd'] = $question_cd.val();
        rowdata['question'] = $question.val();
        rowdata['cate2_no'] = $cate2_no;
        rowdata['cate3_no'] = $cate3_no;
        rowdata['company_cd_refer'] = company_cd_refer;
        rowdata['refer_kbn'] = refer_kbn;
        rowdata['uid'] = $(this).data('uid');
        data[row_id] = rowdata;
        //
        row_id = row_id + 1;
    });
    return data;
}

function randomString(length, chars) {
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

/**
 * make unique id
 * @return {String}
 */
function generateGuid() {
    return randomString(10, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
}

function _setTabIndex() {
    try {
        $('#btn-save').attr('tabindex', 2);
    } catch (e) {
        alert('setTabIndex: ' + e.message);
    }
}