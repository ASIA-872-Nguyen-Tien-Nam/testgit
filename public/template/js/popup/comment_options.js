$(document).ready(function () {
    try {
        initializeCommentOptions();
        initEventsCommentOptions();
    }
    catch (e) {
        alert('ready' + e.message);
    }
});

/**
 * initialize
 *
 * @author		:	viettd - 2023/06/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initializeCommentOptions() {
    try {

    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * initEventsReject
 * @author		:	viettd -2023/06/14- create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEventsCommentOptions() {
    try {
        // btn-comment-options-delete
        $(document).on("click", ".btn-comment-options-delete", function (e) {
            try {
                e.preventDefault();
                let tr = $(this).closest('tr');
                let detail_no = $(this).closest('tr').find('.detail_no').val();
                if (detail_no == '') {
                    detail_no = 0;
                }
                deleteCommentOptions(tr, detail_no);
            } catch (e) {
                alert('.btn-comment-options-delete: ' + e.message);
            }
        });
        // btn-comment-options-save
        $(document).on("click", ".btn-comment-options-save", function (e) {
            try {
                e.preventDefault();
                let tr = $(this).closest('tr');
                if (tr.find('.btn-comment-options-edit').hasClass('active')) {
                    let detail_no = $(this).closest('tr').find('.detail_no').val();
                    let comment = tr.find('.comment_options_input').val();
                    if (detail_no == '') {
                        detail_no = 0;
                    }
                    saveCommentOptions(tr, comment, detail_no);
                }
                return false;
            } catch (e) {
                alert('.btn-comment-options-save: ' + e.message);
            }
        });
        // btn_add_comment_options
        $(document).on("click", "#btn_add_comment_options", function (e) {
            try {
                e.preventDefault();
                let row_index = $('#comment_options_table tbody tr').length + 1;
                if (row_index <= 5) {
                    addRow(row_index);
                }
                return false;
            } catch (e) {
                alert('#btn_add_comment_options: ' + e.message);
            }
        });
        // btn-comment-options-edit
        $(document).on("click", ".btn-comment-options-edit", function (e) {
            try {
                e.preventDefault();
                let tr = $(this).closest('tr');
                if ($(this).hasClass('active')) {
                    $(this).removeClass('active');
                    // don't active
                    tr.find('.comment_options_input_area').hide();
                    tr.find('.comment_options_text').show();
                } else {
                    $(this).addClass('active');
                    // active
                    tr.find('.comment_options_input_area').show();
                    tr.find('.comment_options_text').hide();
                }
            } catch (e) {
                alert('.btn-comment-options-edit: ' + e.message);
            }
        });
        // click tr
        $(document).on("click", ".comment_options_txt_link", function (e) {
            try {
                e.preventDefault();
                let tr = $(this).closest('tr');
                if (tr.find('.btn-comment-options-edit').hasClass('active')) {
                    return false;
                }
                let comment = tr.find('.comment_options_input').val();
                let current_comment = parent.$('#comment').val().trim();
                let next_comment = current_comment;
                if (next_comment == '') {
                    next_comment = comment;
                } else {
                    next_comment = current_comment + '\n' + comment;
                }
                // check length >= 400
                if (next_comment.length > 1200) {
                    jMessage(28);
                } else {
                    parent.$('#comment').val(next_comment);
                    autoResizeTextAreaParent();
                    $('#btn-close-popup').trigger('click');
                }
            } catch (e) {
                alert('.comment_option_row: ' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * Add a new row
 * 
 * @param {Int} row_index 
 */
function addRow(row_index) {
    try {
        let tr = $('#comment_options_table_hide tbody tr').clone();
        tr.find('td:eq(0)').text(row_index);
        $('#comment_options_table tbody').append(tr);
        $('#comment_options_table tbody tr:last .comment_options_input').focus();
    } catch (e) {
        console.log('addRow:' + e.message);
    }
}

/**
 * saveCommentOptions
 * 
 * @param {String} comment 
 * @param {Int} detail_no 
 */
function saveCommentOptions(tr, comment, detail_no = 0) {
    try {
        var data = {};
        data.detail_no = detail_no;
        data.comment = comment;
        data.comment_typ = _getCommentType(parent.$('#login_use_typ').val(), parent.$('#admin_and_is_approver').val(), parent.$('#admin_and_is_viewer').val());
        data.mode = 0; // save
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/common/popup/comment_options',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        tr.find('.comment_options_text').html(res['comment_option']['comment'].replace(/\n/g, '<br />'));
                        tr.find('.comment_options_input').val(res['comment_option']['comment']);
                        tr.find('.detail_no').val(res['comment_option']['detail_no']);
                        tr.find('.btn-comment-options-edit').trigger('click');
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
        alert('saveCommentOptions' + e.message);
    }
}

/**
 * deleteCommentOptions
 * 
 * @param {Int} detail_no 
 */
function deleteCommentOptions(tr, detail_no = 0) {
    try {
        var data = {};
        data.detail_no = detail_no;
        data.comment = '';
        data.comment_typ = _getCommentType(parent.$('#login_use_typ').val(), parent.$('#admin_and_is_approver').val(), parent.$('#admin_and_is_viewer').val());
        data.mode = 1; // delete
        //send data to post
        $.ajax({
            type: 'POST',
            url: '/common/popup/comment_options',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        $('#comment_options_table tbody').find(tr).remove();
                        resetIndex();
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
        alert('deleteCommentOptions' + e.message);
    }
}

/**
 * reset table row number
 */
function resetIndex() {
    try {
        index = 1;
        $('#comment_options_table tbody tr').each(function () {
            $(this).find('td:eq(0)').text(index);
            index++;
        });
    } catch (e) {
        console.log('resetIndex:' + e.message);
    }
}

/**
 * Auto resize textarea
 */
function autoResizeTextAreaParent() {
    try {
        parent.$('textarea').not('.target').each(function () {
            let h = this.scrollHeight > 60 ? this.scrollHeight : 60;
            this.setAttribute('style', 'height:' + h + 'px;overflow-y:hidden;');
        }).on('input', function () {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    } catch (e) {
        console.log('autoResizeTextAreaParent:' + e.message);
    }
}