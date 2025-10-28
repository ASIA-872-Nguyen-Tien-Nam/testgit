/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2023/02/10
 * 作成者          :   mirai – mirai@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'data_group': {
        'attr': 'list', 'item': {
                'group': { 'type': 'text', 'attr': 'class' }
            , 'report': { 'type': 'text', 'attr': 'class' }
            , 'position_1': { 'type': 'select', 'attr': 'class' }
            , 'position_2': { 'type': 'select', 'attr': 'class' }
            , 'position_3': { 'type': 'select', 'attr': 'class' }
            , 'position_4': { 'type': 'select', 'attr': 'class' }
            , 'sheet_cd': { 'type': 'select', 'attr': 'class' }
        }
    }
};
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
 * @author      :   mirai - 2020-09-08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try {
       //
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2023/02/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    try {
        //save
        $(document).on('click', '#btn-save-data,.btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    if (r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch (e) {
                alert('btn-send: ' + e.message);
            }
        });
        //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try {
                jMessage(3, function (r) {
                });
            } catch (e) {
                alert('#btn-delete :' + e.message);
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
        $(document).on('click', '#btn-delete', function(){
            try{
                jMessage(3, function(r) {
                    if (r) {
                        del();
                    }
                });
            } catch(e){
                alert('#btn-delete: ' + e.message);
            }
        });
        $(document).on('change', '#report_kinds', function(){
            try {
                    search()
            } catch(e){
                alert('#btn-delete: ' + e.message);
            }
        });
        $(document).on('change', '#group_cd', function(){
            try {
                    search()
            } catch(e){
                alert('#btn-delete: ' + e.message);
            }
        });
        $(document).on('change', '.select-class_active', function(e) {
            if ($(this).val() != -1) {
                let index = $(this).closest('td').index();
                console.log(index)
                $(this).closest('tr').find('.position_1').css('background-color', 'red');
                $(this).closest('tr td:nth-child(2)')
                for (i = 0; i < index - 2; i++) {
                    $(this).closest('tr').find('.position_' + i).addClass('required');
                }
            } else {
                let index = $(this).closest('td').index();
                console.log(index)
                $(this).closest('tr').find('.position_1').css('background-color', 'red');
                $(this).closest('tr td:nth-child(2)')
                for (i = 0; i < index - 2; i++) {
                    $(this).closest('tr').find('.position_' + i).removeClass('required');
                }
            }
          
          })
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}
function saveData() {
        try {
            var data = getData(_obj);
            console.log(data);
            $.ajax({
                type: 'POST',
                url: '/weeklyreport/rm0310/save',
                dataType: 'json',
                loading: true,
                data: JSON.stringify(data),
                success: function (res) {
                    switch (res['status']) {
                        // success
                        case OK:
                            //
                            jMessage(2, function (r) {
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
function search() {
    try {
        var report_kinds = $('#report_kinds').val()
        var group_cd = $('#group_cd').val()
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rm0310/search',
            loading: true,
            dataType: 'html',
            data: { 'report_kinds': report_kinds, 'group_cd': group_cd },
            success: function (res) {
                $('#result').empty()
                $('#result').append(res)
            }
        });
    } catch (e) {
        alert('save' + e.message);
    }
}
function del(){
    try {
        var report_kinds = $('#report_kinds').val()
        var group_cd = $('#group_cd').val()
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0310/delete',
            dataType    :   'json',
            loading     :   true,
            data        :   {'report_kinds': report_kinds, 'group_cd': group_cd},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            location.reload();
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
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
        alert('del' + e.message);
    }
}