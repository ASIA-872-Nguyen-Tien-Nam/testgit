/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   SonDH – sondh@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'detail_no'               : {'type':'text', 'attr':'id'},
    'list_data': {
        'attr': 'list', 'item': {
            'rank_cd': {'type': 'text', 'attr': 'class'},
            'rank_nm': {'type': 'text', 'attr': 'class'},
            'points_from': {'type': 'text', 'attr': 'class'},
            'points_to': {'type': 'text', 'attr': 'class'}
        }
    }
};
$(function () {
    initEvents();
    initialize();
    //calcTable();
});

/**
 * initialize
 *
 * @author        :    datnt - 2018/06/21 - create
 * @author        :    SonDH - 2018/09/05 - update
 * @return        :    null
 * @access        :    public
 * @see            :    init
 */
function initialize() {
    try {
        // $('#name').focus();
        //
        // $('#table-data').find('tbody tr:first td:first-child input').focus();
        $('#detail_no').focus();

        //
        var tr = $('#table-data tbody tr');
        if (tr.length > 1) {
            $('#table-data tbody tr:last-child').addClass('last_child');
        } else {
            $('#table-data tbody tr:last-child').removeClass('last_child');
        }
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}

/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/21 - create
 * @author		:   SonDH - 2018/09/05 - update
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {

    document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
            if (e.shiftKey) {
                   if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
                        e.preventDefault();
                         if($('#ans-collapse a:not([readonly],[disabled],:hidden)').last().length!=0){
                            $('#ans-collapse a:not([readonly],[disabled],:hidden)').last()[0].focus();
                        }   
                        return;
                    }
                      
                    if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],:hidden)').first()[0]) {
                        e.preventDefault();
                         if($(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length!=0){
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().focus();
                        }   
                        return;
                    }
                }else{
                        if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
                        }
                        if ($(':focus')[0] === $(':input:not([readonly],[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            $('#ans-collapse a:not([readonly],[disabled],:hidden)').first()[0].focus();
                        }
                }
            }
    });

    $(document).on('blur', '.td-from,.td-to', function () {
        var val = $(this).val();
        if (val !== '') {
            val = val.split('.');
            if (val.length > 1) {
                if (val[1].length === 1) {
                    val[1] += '0';
                }
            }
            else {
                val.push('00');
            }
            console.log(val);
            $(this).val(val.join('.'));
        }
    });
    //
    $(document).on('change', '.td-from', function () {
        var val = $(this).val();
        var index = $(this).closest('tr').index();
        var nextTr = $('#data-refer').find('tr:nth-child('+(index+2)+')');
        if (nextTr.length > 0) {
            if (val !== '') {
                val = val.split('.');
                if (val.length > 1) {
                    if (val[1].length === 1) {
                        val[1] += '0';
                    }
                }
                else {
                    val.push('00');
                }
                nextTr.find('.td-to').val(val.join('.'));
            }
        }
    });
    //btn-add-row
    $(document).on('click', '#btn-add-new-row', function () {
        try {
            $('#table-data').find('tbody tr').removeClass('last_child');
            var row = $("#table-target tbody tr:first").clone();
            $('#table-data tbody').append(row);
            $('#table-data').find('tbody tr:last td:first-child input').focus();
            $('#table-data').find('tbody tr:last').addClass('list_data');
            $('#table-data').find('tbody tr:last').addClass('last_child');
            $.formatInput('#table-data tbody tr:last');
            // enter new To input by previous From input
            var index = $('#table-data tbody tr:last').index();
            var from_ = $('#table-data tbody tr:nth-child('+(1*index)+')').find('.points_from').val();
            $('#table-data tbody tr:last').find('.points_to').val(from_);
            console.log(from_);
        } catch (e) {
            alert('btn-add-new: ' + e.message);
        }
    });

    //btn-remove-row
    $(document).on('click', '.btn-remove-row', function () {
        try {
            $(this).parents('tr').remove();
            $('#table-data').find('tbody tr:last').addClass('last_child');
        } catch (e) {
            alert('btn-remove-row: ' + e.message);
        }
    });

    //btn-save
    $(document).on('click', '#btn-save', function () {
        try {
            var check = $('#table-data tbody tr.list_data').length;
            jMessage(1, function (r) {
                if (check > 0) {
                    if (r && _validate($('body'))) {
                        saveData();
                    }
                } else {
                    jMessage(29, function () {

                    })
                }
            })
        } catch (e) {
            alert('btn-save: ' + e.message);
        }
    });

    //btn-save
    $(document).on('click', '#btn-delete', function () {
        try {
            var check = $('#table-data tbody tr.list_data').length;
            jMessage(3, function (r) {
                if (check > 0) {
                    if (r && _validate($('body'))) {
                        deleteData();
                    }
                } else {
                    jMessage(21, function () {

                    })
                }
            })
        } catch (e) {
            alert('btn-save: ' + e.message);
        }
    });

    //back
    $(document).on('click', '#btn-back', function(e) {
        // window.location.href = '/dashboard'
        if(_validateDomain(window.location)){
            window.location.href = '/dashboard';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });

    //back
    $(document).on('change', '#detail_no', function(e) {
        $.post('/master/m0130/refer', {detail_no: $(this).val()})
            .then((res, status) => {
                $('#data-refer').empty().append(res);
                $.formatInput('#table-data tbody tr');
            })
    });
}

/**
 * save
 *
 * @author      :   SonDH - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);

        $.ajax({
            type: 'POST',
            url: '/master/m0130/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(2, function () {
                            //
                            location.reload();
                        });
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {

                            if(res['errors'][0]['remark']=='DUPLICATE'){
                                jMessage(res['errors'][0]['message_no'], function() {
                                    _focusErrorItem();
                                });
                            }
                            //
                            for (var i = 0; i< res['errors'].length; i++){
                                var rank_chk = res['errors'][i]['value1'];

                                $("#table-data tbody tr").each(function (row){
                                    // var rank_cd = $(this).find('.rank_cd').val();
                                    var rank_cd = row+1;
                                    if (rank_chk == rank_cd) {
                                        //
                                        if (res['errors'][i]['remark']=='FROM-TO' || res['errors'][i]['remark']=='FROM-TO-0'){

                                            errorStyleM0130($(this).find(res['errors'][i]['item']),_text[res['errors'][i]['message_no']].message,2);

                                        }else if(res['errors'][i]['remark']=='DUPLICATE'){

                                            $(this).find('.points_from,.points_to').addClass('boder-error');

                                        }else if(res['errors'][i]['remark']=='FROM-TO-FIRST-LAST'){
                                            errorStyleM0130($(this).find(res['errors'][i]['item']),_text[res['errors'][i]['message_no']].message,2);
                                        }else{
                                            errorStyleM0130($(this).find(res['errors'][i]['item']),_text[res['errors'][i]['message_no']].message);
                                        }
                                    }
                                });
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
        alert('saveData:' + e.message);
    }
}

/**
 * error
 *
 * @author      :   SonDH - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function errorStyleM0130(selector, message, style) {
    try {
        message = jQuery.castString(message);
        if (message !== '') {
            if (style == 2) {
                selector.addClass('boder-error');
                if(selector.next('.textbox-error').length > 0){
                }else{
                    selector.after('<div class="textbox-error">' + message + '</span>');
                }
            } else {
                selector.addClass('boder-error');
                if(selector.closest('.form-inline').next('.textbox-error').length > 0){
                }else{
                    selector.after('<div class="textbox-error">' + message + '</span>');

                }
            }
            selector.closest('tr').find('td').css('vertical-align','top');
            selector.closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align','middle');
            _focusErrorItem();
        }

    } catch (e) {

    }
}

/**
 * delete
 *
 * @author      :   SonDH - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {detail_no: $('#detail_no').val()};

        $.ajax({
            type: 'POST',
            url: '/master/m0130/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(4, function (r) {
                            // // $('#rightcontent').find('input,select,checkbox').val('');
                            // clearData(_obj);
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
        alert('deleteData: ' + e.message);
    }
}

/**
 * Get rank_cd detail for delete
 */
function getDetailData() {
    var result = {};
    $("#table-data tbody tr").each(function (row) {
        var item = {};
        item['rank_cd'] = $(this).find('.rank_cd').val();

        if (item['rank_cd'] != '') {
            result[row] = item;
        }
    });
    return result;
}