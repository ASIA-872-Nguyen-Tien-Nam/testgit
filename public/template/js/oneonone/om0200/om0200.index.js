/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'interview_cd': { 'type': 'text', 'attr': 'id' },
    'interview_nm': { 'type': 'text', 'attr': 'id' },
    'adaption_date': { 'type': 'text', 'attr': 'id' },
    'target1_use_typ': { 'type': 'text', 'attr': 'id' },
    'target2_use_typ': { 'type': 'text', 'attr': 'id' },
    'target3_use_typ': { 'type': 'text', 'attr': 'id' },
    'comment_use_typ': { 'type': 'text', 'attr': 'id' },
    'question_nm': { 'type': 'text', 'attr': 'id' },
    'answer_nm': { 'type': 'text', 'attr': 'id' },
    'free_question_nm': { 'type': 'text', 'attr': 'id' },
    'free_question_use_typ': { 'type': 'text', 'attr': 'id' },
    'member_comment_nm': { 'type': 'text', 'attr': 'id' },
    'member_comment_typ': { 'type': 'text', 'attr': 'id' },
    'coach_comment1_nm': { 'type': 'text', 'attr': 'id' },
    'coach_comment1_typ': { 'type': 'text', 'attr': 'id' },
    'next_action_nm': { 'type': 'text', 'attr': 'id' },
    'next_action_typ': { 'type': 'text', 'attr': 'id' },
    'coach_comment2_nm': { 'type': 'text', 'attr': 'id' },
    'coach_comment2_typ': { 'type': 'text', 'attr': 'id' },
    'arrange_order': { 'type': 'text', 'attr': 'id' },
    'mode': { 'type': 'text', 'attr': 'id' },
    'list_questions': {
        'attr': 'list', 'item': {
            'interview_gyocd': { 'type': 'text', 'attr': 'class' },
            'question': { 'type': 'text', 'attr': 'class' },
            'arrange_order': { 'type': 'text', 'attr': 'class' },
        }
    }
};
$(function () {

    initialize();
    initEvents();
    //calcTable();
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
        $('#interview_nm').focus();
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
    //back
    $(document).on('click', '#btn-back', function (e) {
        try {
            //
            var home_url = $('#home_url').attr('href');
            _backButtonFunction(home_url);
        } catch (e) {
            alert('#btn-back' + e.message);
        }
    });
    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
        try {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('li.page-prev a.page-link:not(.pagging-disable): ' + e.message);
        }
    });
    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
        try {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('li.page-next a.page-link:not(.pagging-disable): ' + e.message);
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
            alert('search_key: ' + e.message);
        }
    });
    $(document).on('enterKey', '#search_key', function (e) {
        try {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('search_key: ' + e.message);
        }
    });
    //btn-copy
    $(document).on('click', '#btn-copy', function (e) {
        try {
            e.preventDefault();
            $('#interview_cd').val('');
            $('#interview_nm').val('');
            $('#rightcontent .calHe').addClass('has-copy');
            $('#interview_nm').focus();
            $('#mode').val('C');
        } catch (e) {
            alert('btn-copy: ' + e.message);
        }
    });
    $(document).on('click', '.lv1', function () {
        try {
            if ($(this).hasClass('rotator')) {
                $(this).removeClass('rotator');
            } else {
                $(this).addClass('rotator');
            }
        } catch (e) {
            alert('show.bs.collapse: ' + e.message);
        }
    });
    //btn-add-new
    $(document).on('click', '#btn-add-new', function (e) {
        try {
            jMessage(5, function () {
                clearRightContent();
                $('.actived').removeClass('actived');
                $('.show').removeClass('show');
                $('.rotator').removeClass('rotator');
            })
        } catch (e) {
            alert('btn-add-new: ' + e.message);
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
            })
        } catch (e) {
            alert('#btn-delete :' + e.message);
        }
    });
    $(document).on('click', '.lv2', function (e) {
        try {
            let interview_cd = $(this).find('.interview_cd').val();
            let adaption_date = $(this).find('.adaption_date').text();
            $('.actived').removeClass('actived');
            $(this).addClass('actived');
            getRightContent(interview_cd, adaption_date);
        } catch (e) {
            alert('lv2 :' + e.message);
        }
    });
    $(document).on('click', '#btn-add-detail', function () {
        try {
            var row = $("#table-target tbody tr:first").clone();
            var max = 0;
            tr = $('#table_question').find('.list_questions')
            tr.each(function () {
                if (max <= $(this).find('.interview_gyocd').val() * 1) {
                    max = $(this).find('.interview_gyocd').val() * 1
                }
            });
            row.find('.interview_gyocd').val(max * 1 + 1);
            $('#table_question tbody').append(row);
            $('#table_question tbody tr:last').addClass('list_questions');
            $('#table_question').find('tbody tr:last td:first-child input').focus();
            $.formatInput('#table_question tbody tr:last');
        } catch (e) {
            alert('btn-add-detail: ' + e.message);
        }
    });
    $(document).on('click', '.btn-remove-row', function () {
        try {
            $(this).parents('tr').remove();
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });
    $(document).on('click', '.btn-save', function (e) {
        try {
            jMessage(1, function (r) {
                _flgLeft = 1;
                if (r && _validate($('body'))) {
                    saveData();
                }
            });
        } catch (e) {
            alert('.btn-save: ' + e.message);
        }
    });
    // $(".dropdown img.flag").addClass("flagvisibility");

    $(document).on('click', '.dropdown dt a', function () {
        try {
            $(this).parents('.dropdown').find('ul').toggle();
            // $(".dropdown dd ul").toggle();
        } catch (e) {
            alert('dropdown: ' + e.message);
        }
    });
    $(document).on('click', '.search_cate', function () {
        try {
            $('.search-cate-active').removeClass('search-cate-active');
            $(this).parents('td').addClass('search-cate-active');
            $('body').css('overflow', 'hidden');
            showPopup("/common/popup/question", {}, function () {

            });
        } catch (e) {
            alert('search_cate: ' + e.message);
        }
    });

    $(document).on('click', '.dropdown dd ul li a', function () {
        try {
            var text = $(this).html();
            $(this).parents('.dropdown').find('.weather-select').html(text);
            $(this).parents('.dropdown').find('ul').hide();
            $("#result").html("Selected value is: " + getSelectedValue("sample"));
        } catch (e) {
            alert('dropdown dd ul li a: ' + e.message);
        }
    });
    $(document).bind('click', function (e) {
        try {
            var $clicked = $(e.target);
            if (!$clicked.parents().hasClass("dropdown"))
                $(".dropdown dd ul").hide();
        } catch (e) {
            alert('click ' + e.message);
        }
    });
    $(document).on('click', '.ics-edit', function (e) {
        try {
            e.preventDefault();
            if ($(this).closest('.ics-wrap-disabled').length < 1) {
                var container = $(this).closest('.d-flex');
                container.find('input').removeAttr('readonly').select();
            }
        } catch (e) {
            alert('ics-edit ' + e.message);
        }
    });
    $(document).on('click', '.ics-table-edit', function (e) {
        try {
            e.preventDefault();
            var container = $(this).closest('.th-edited');
            container.find('input').removeAttr('readonly').select();
        } catch (e) {
            alert('ics-table-edit' + e.message);
        }
    });
    $(document).on('blur', '.ics-textbox input', function () {
        try {
            $(this).attr('readonly', 'readonly');
        } catch (e) {
            alert('ics-textbox input' + e.message);
        }
    });
    $(document).on('click', '.ics-eye', function (e) {
        try {
            var _this = $(this);
            e.preventDefault();
            var table = $(this).closest('table');
            var th = $(this).closest('th');
            var index = th.index();

            th.addClass('ics-hide');
            th.hide();
            th.find('.display_typ').val(0);

            table.find('tbody tr td:eq(' + index + ')').hide();
            table.find('tbody tr td:eq(' + index + ')').addClass('ics-hide');

            var length = $('.w-table1 table thead tr .ics-hide').length;
            if (table.hasClass('tbl1')) {
                $('.w-table1').css('width', (100 - length * 10) + '%');
            }
            var length3 = $('.w-table3 table thead tr .ics-hide').length;
            $('.w-table3').css('width', (50 - length3 * (50 / 2)) + '%');
            var length4 = $('.w-table4 table thead tr .ics-hide').length;
            $('.w-table4').css('width', (50 - length4 * (50 / 2)) + '%');
            if (table.hasClass('tabl2')) {
                table.find('tbody tr td').each(function () {
                    if ($(this).index() == index) {
                        $(this).addClass('ics-hide');
                        if (!$(this).hasClass('baffbo')) {
                            $(this).hide();
                        }
                        if (index == 9) {
                            $('.ba55').next().hide();
                            $('.ba55').next().addClass('ics-hide');
                        }
                    }
                });
                if (index != 9) {
                    var Newlength = $('#td-colspan').attr('colspan') - 1;
                    if (Newlength > 0) {
                        $('#td-colspan').attr('colspan', Newlength);
                    } else {
                        $('#td-colspan').hide();
                    }
                }
            }
        } catch (e) {
            alert('ics-eye-table' + e.message);
        }
    });
    $(document).on('click', '.ics-eye-table', function (e) {
        try {
            e.preventDefault();
            $(this).parents('tr').addClass('hidden');
            $(this).parents('table').find('.display_typ').val(0);
            if ($(this).parents('tbody').find('tr:visible').length == 0) {
                $(this).closest('.row').addClass('hidden');
            }
        } catch (e) {
            alert('ics-eye-table' + e.message);
        }
    })
    $(document).on('click', '.show-all', function (e) {
        try {
            e.preventDefault();
            $('.table tr.hidden').removeClass('hidden');
            $('.row.hidden').removeClass('hidden');
            $('#myTable').removeClass('hidden');
            $('table thead tr,table tbody tr').each(function () {
                $(this).find('.ics-hide').show();
                $(this).find('.display_typ').val(1);

                $(this).find('.ics-hide').removeClass('ics-hide');
            });
            $('.w-table1').css('width', '100%');
            $('.w-table3').css('width', '50%');
            $('.w-table4').css('width', '50%');
            $('#td-colspan').attr('colspan', 8);
            $('#td-colspan').show();
            $('#tr-total').show();
        } catch (e) {
            alert('show-all' + e.message);
        }
    })

} // end function initEvents

function getSelectedValue(id) {
    return $("#" + id).find("dt a span.value").html();
}
/**
 * getLeftContent
 *
 * @author      :   SonDH - 2018/08/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0200/postleft',
            dataType: 'html',
            loading: true,
            data: { page: page, search_key: search },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
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
 * get left data
 * @param  {String} key [key search]
 * @return {Void}
 */
function getRightContent(interview_cd, adaption_date) {
    try {
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0200/refer',
            dataType: 'html',
            loading: true,
            data: { interview_cd: interview_cd, adaption_date: adaption_date }
        })
            .then(res => {
                $('#leftul nav').empty().html(res.paging).find('ul').css('margin-top', '1rem');
                $('#right-respon').empty();
                $('#right-respon').append(res);
                $('#interview_nm').focus();
                jQuery.formatInput();
            });
    } catch (e) {
        alert('getRightContent' + e.message);
    }
}

/**
 * save
 *
 * @author      :   binhnn - 2018/09/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0200/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            clearRightContent();
                            $('.actived').removeClass('actived');
                            $('.show').removeClass('show');
                            $('.rotator').removeClass('rotator');
                            $('#interview_nm').focus();
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
 * @author      :   SonDH - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.interview_cd = $('#interview_cd').val();
        data.adaption_date = $('#adaption_date').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/om0200/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            clearRightContent();
                            $('.actived').removeClass('actived');
                            $('.show').removeClass('show');
                            $('.rotator').removeClass('rotator');
                            //
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);

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
function clearRightContent() {
    try {
        $('#rightcontent .calHe').removeClass('has-copy');
        $('#interview_nm').focus();
        $('#interview_cd').val('');
        $('#interview_nm').removeClass('boder-error');
        $('#interview_nm').next('.textbox-error').remove();
        $('#interview_nm').val('');
        $('#adaption_date').val('');
        $('.show-all').trigger('click');
        $('#table_question tbody').empty();
        var row = $("#table-target tbody tr:first").clone();
        $('#table_question tbody').append(row);
        $('#table_question tbody tr:last').addClass('list_questions');
        $.formatInput('#table_question tbody tr:last');
        //
        $('#question_nm').val(pawn);
        $('#answer_nm').val(answer);
        $('#free_question_nm').val(free_entry_field);
        $('#member_comment_nm').val(member_comment);
        $('#coach_comment1_nm').val(coach_comment);
        $('#next_action_nm').val(label_013);
        $('#coach_comment2_nm').val(label_012);
    
    } catch (e) {
        alert('clearRightContent: ' + e.message);
    }
}
