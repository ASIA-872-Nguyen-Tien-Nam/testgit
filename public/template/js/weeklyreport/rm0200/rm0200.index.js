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
    'sheet_cd': { 'type': 'text', 'attr': 'id' },
    'sheet_nm': { 'type': 'text', 'attr': 'id' },
    'report_kind': { 'type': 'text', 'attr': 'id' },
    'adaption_date': { 'type': 'text', 'attr': 'id' },
    'busyness_use_typ': { 'type': 'text', 'attr': 'id' },
    'other_use_typ': { 'type': 'select', 'attr': 'id' },
    'comment_use_typ': { 'type': 'text', 'attr': 'id' },
    'adequacy_use_typ': "{ 'type': 'text', 'attr': 'id' }",
    'list_questions': {
        'attr': 'list', 'item': {
            'question_id': { 'type': 'text', 'attr': 'class' },
            'question': { 'type': 'text', 'attr': 'class' },
            'question_no': { 'type': 'text', 'attr': 'class' },
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
        $('#report_kind').focus();
        $(".dropdown dd ul").hide();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	namnt - 2023/04/06 - create
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
    //btn-add-new
    $(document).on('click', '#btn-new-signup', function (e) {
        try {
            jMessage(5, function () {
                clearRightContent()
                $('.actived').removeClass('actived');
                $('.show').removeClass('show');
                $('.rotator').removeClass('rotator');
            })
        } catch (e) {
            alert('btn-new-signup: ' + e.message);
        }
    });
    //btn-delete
    $(document).on('click', '#btn-delete', function (e) {
        try {
            jMessage(3, function (r) {
            })
        } catch (e) {
            alert('#btn-delete :' + e.message);
        }
    });

    $(document).on('click', '#btn-add-detail', function () {
        try {
            var detail_id = parseInt($('#table_question tbody tr:last .question_id').val());
            if ($(".list_questions").length == 0) {
                var row = $(".list_questions_hidden").clone();
            } else {
                var row = $("#table_question tbody tr:first").clone();
                row.find('.textbox-error').remove();
                row.find('td').css('padding-bottom','5px');
            }
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
            $('#table_question tbody tr:last .question_id').attr('value', detail_id + 1);
            $('#table_question tbody tr:last .question_id').val(detail_id+1);
            $('#table_question').find('tbody tr:last td:first-child input').val('').prop('readonly', true);;
            $.formatInput('#table_question tbody tr:last');
        } catch (e) {
            alert('btn-add-detail: ' + e.message);
        }
    });
    $(document).on('click', '.btn-remove-row', function () {
        try {
            if ($("#table_question tbody tr").length > 1) {
                $(this).parents('tr').remove();
            }
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });
    $(document).on('click', '.btn-save', function (e) {
        try {
            $("#table_question tbody tr td").css('padding-bottom','5px')
            jMessage(1, function (r) {
                _flgLeft = 1;
                if (r && _validate($('body'))) {
                    saveData();
                }
            });
        } catch (e) {
            alert('.btn-send: ' + e.message);
        }
    });
    $(document).on('click', '.dropdown dt a', function () {
        $(this).parents('.dropdown').find('ul').toggle();
    });

    //
    $(document).on('click', '.dropdown dd ul li a', function () {
        var text = $(this).html();
        $(this).parents('.dropdown').find('.weather-select').html(text);
        $(this).parents('.dropdown').find('ul').hide();
    });

    //
    $(document).bind('click', function (e) {
        var $clicked = $(e.target);
        if (!$clicked.parents().hasClass("dropdown"))
            $(".dropdown dd ul").hide();
    });


    $(document).on('click', '.ics-eye', function (e) {
        try {
            var _this = $(this);
            e.preventDefault();
            var parent = $(this).parents('.picture-img')
            $(this).attr('typ',0)
            parent.hide()
        } catch (e) {
            alert('ics-eye' + e.message);
        }
    });

    $(document).on('click', '.ics-eye-table', function (e) {
        try {
            e.preventDefault();
            $('.ics-eye-table').attr('typ','0')
            $(this).closest('.approver__table').hide();
        } catch (e) {
            alert('ics-eye-table' + e.message);
        }
    });

    $(document).on('click', '.show-all', function (e) {
        try {
            e.preventDefault();
            $('#other_use_typ').attr('typ','1');
            $('#adequacy_use_typ').attr('typ','1');
            $('#busyness_use_typ').attr('typ', '1');
            $('.ics-eye-table').attr('typ','1')
            $('.picture-img').show();
            $('.approver__table').show();
            $('.picture-img').removeAttr('hidden');
            $('.table_show_hide').removeAttr('hidden');
        } catch (e) {
            alert('show-all' + e.message);
        }
    })
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
    $(document).on('click', '.lv1', function (e) {
        try {
            if ($(this).children().children('i').hasClass('fa-chevron-right')) {
                $(this).children().children('i').removeClass('fa-chevron-right')
                $(this).children().children('i').addClass('fa-chevron-down')
           } else {
            $(this).children().children('i').removeClass('fa-chevron-down')
            $(this).children().children('i').addClass('fa-chevron-right')
       }
        } catch (e) {
            alert('#btn-delete :' + e.message);
        }
    });
    $(document).on('click', '.lv2', function (e) {
        try {
            if ($(this).children().children('i').hasClass('fa-chevron-right')) {
                $(this).children().children('i').removeClass('fa-chevron-right')
                $(this).children().children('i').addClass('fa-chevron-down')
            } else {
                $(this).children().children('i').removeClass('fa-chevron-down')
                $(this).children().children('i').addClass('fa-chevron-right')
           }
        } catch (e) {
            alert('#btn-delete :' + e.message);
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
    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
        try {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('li.page-next a.page-link:not(.pagging-disable): ' + e.message);
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
    $(document).on('blur', '#search_key', function (e) {
        try {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });
    $(document).on('click', '.search_cate', function () {
        try {
            $('.search-cate-active').removeClass('search-cate-active');
            $(this).parents('td').addClass('search-cate-active');
            $('body').css('overflow', 'hidden');
            var report_kind = $('.report-question #report_kind').val();
            report_kind = (report_kind != null) ?report_kind :0
            showPopup("/common/popup/rquestion/"+report_kind, {}, function () {
            });
        } catch (e) {
            alert('search_cate: ' + e.message);
        }
    });
    $(document).on('click', '.lv3', function (e) {
        try {
            var report_kind = $(this).attr('report_kind');
            var sheet_cd = $(this).attr('sheet_cd');
            $('.actived').removeClass('actived');
            $(this).addClass('actived');
            var adaption_date = $(this).attr('adaption_date');
            getRightContent(report_kind, sheet_cd, adaption_date);
        } catch (e) {
            alert('list-search-child-refer: ' + e.message);
        }
    });
    $(document).on('change', '#report_kind', function (e) {
        try {
            $('.div_loading').show();
            setTimeout(() => {
                changeReport();
                getLeftContent(1,'');
            $('.div_loading').hide();
            }, 500);
            
        } catch (e) {
            alert('btn-search-key: ' + e.message);
        }
    });
} // end function initEvents
/*
 * saveData
 * @author		:	namnt - 2023/04/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function saveData() {
    try {
        var data = getData(_obj);
        data['adequacy_use_typ'] = $('#adequacy_use_typ').attr('typ');
        data['busyness_use_typ'] = $('#busyness_use_typ').attr('typ');
        data['other_use_typ'] = $('#other_use_typ').attr('typ');
        data['comment_use_typ'] = $('#comment_use_typ').attr('typ');
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rm0200/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function (r) {
                            location.reload();
                        });
                        break;
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            for (var i = 0; i < res['errors'].length; i++) {
                            if (res['errors'][i]['item'] == '.err_question_cd') {
                                var value2 = res['errors'][i]['value2'];
                                $("#table_question tbody tr:eq(" + value2 + ") td").css('padding-bottom','24px')
                                errorStyleRM0200($("#table_question tbody tr:eq(" + value2 + ")").find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
                            } else {
                                processError(res['errors']);
                            }
                        }
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
/*
 * getLeftContent
 * @author		:	namnt - 2023/04/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function getLeftContent(page, search) {
    try {
        var url = _customerUrl('/weeklyreport/rm0200/leftcontent');
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'html',
            loading: true,
            data: { page: page, search_key: search },
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
/*
 *getRightContent
 * @author		:	namnt - 2023/04/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function getRightContent( report_kind, sheet_cd, adaption_date) {
    try {
        var url = _customerUrl('/weeklyreport/rm0200/rightcontent');
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'html',
            loading: true,
            data: {report_kind: report_kind, sheet_cd: sheet_cd, adaption_date: adaption_date },
            success: function (res) {
                $('#rightcontent .inner').empty().append(res);
                $.formatInput();
                $('#report_kind').focus();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/*
 * deleteData
 * @author		:	namnt - 2023/04/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function deleteData() {
    try {
        var data = {};
        data.adaption_date = $('#adaption_date').val();
        data.sheet_cd = $('#sheet_cd').val();
        data.report_kind = $('#report_kind').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rm0200/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            location.reload();

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
/*
 * clearRightContent
 * @author		:	namnt - 2023/04/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function clearRightContent() {
    try {
        $('#rightcontent .calHe').removeClass('has-copy');
        $('#report_kind').focus();
        $('#sheet_cd').val('');
        $('#sheet_nm').val('');
        $('#report_kind').val('1');
        $('#adaption_date').val('');
        $('.show-all').trigger('click');
        var row = $("#table_question tbody tr:first").clone();
        $('#table_question tbody').empty();
        $("#table_question tbody").append(row)
        $('.question').val('');
        $('.question').attr("readonly",true);

        console.log(row)
        //
    } catch (e) {
        alert('clearRightContent: ' + e.message);
    }
}
function errorStyleRM0200(selector, message) {
	try {
		message = jQuery.castString(message);
		if (message !== '') {
			selector.addClass('boder-error');
			if (selector.next('.textbox-error').length > 0) {
			} else {
				selector.after('<div class="textbox-error">' + message + '</span>');
			}
			
			_focusErrorItem();
		}

	} catch (e) {
		alert('errorStyleI1030' + e.message);
	}
}
function changeReport() {
    try {
        $('#rightcontent .calHe').removeClass('has-copy');
        $('#report_kind').focus();
        $('#sheet_cd').val('');
        $('#sheet_nm').val('');
        $('#adaption_date').val('');
        $('.show-all').trigger('click');
        var row = $("#table_question tbody tr:first").clone();
        $('#table_question tbody').empty();
        $("#table_question tbody").append(row)
        $('.question').val('');
        $('.question').attr("readonly",true);
        console.log(row)
        //
    } catch (e) {
        alert('clearRightContent: ' + e.message);
    }
}
