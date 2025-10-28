/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   datnt – datnt@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'employee_typ'      : {'type':'text', 'attr':'id'},
    'employee_typ_nm'   : {'type':'text', 'attr':'id'},
    'arrange_order'     : {'type':'text', 'attr':'id'},
    'import_cd'         : {'type':'text', 'attr':'id'},
};
var _flgLeft = 0;
$(function(){
    initEvents();
    initialize();
    //calcTable();
});

/**
 * initialize
 *
 * @author    : datnt - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try{
        $(document).ready(function(){
            $('.indexTab').focus();
             _formatTooltip();
        });
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author    : datnt - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
    try{
        /* paging */
        $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', '#btn-search-key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('change', '#search_key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('enterKey', '#search_key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        /* end paging */

        /* left content click item */
        $(document).on('click', '.list-search-child', function(e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            getRightContent( $(this).attr('id') );
        });
        /* end click item */

        $(document).on('click', '#btn-add-new', function(e) {
            jMessage(5,function(){
                $('#employee_typ_nm').focus();
                $('#employee_typ').val('');
                $('#import_cd').val('');
                $('#employee_typ_nm, #arrange_order').val('');
                $('#employee_typ_nm').removeClass('boder-error');
                $('#employee_typ_nm').next('.textbox-error').remove();
                $('.list-search-child').removeClass('active');
            })
        });
        $(document).on('click', '#btn-save', function(e) {
            // demo-message.js
            jMessage(1, function(r) {
                _flgLeft = 1;
                if ( r && _validate($('body')) ) {
                    saveData();
                }
            });
        });
        $(document).on('click', '#btn-delete', function(e) {
            var employee_typ   =  $('#employee_typ').val();
            var employee_typ_nm   =  $('#employee_typ_nm').val();  
            jMessage(3, function(r) {
                if (r){
                    deleteData();
                }
            });
        });
        $(document).on('click', '#btn-back', function(e) {
          // window.location.href = '/dashboard'
            if(_validateDomain(window.location)){
                window.location.href = 'sdashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        });
    } catch(e){
        alert('initEvents : ' + e.message);
    }  
}

/**
 * save
 * 
 * @author      :   namnb - 2018/08/23 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function saveData() {
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0060/save', 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            clearData(_obj);
                            $('#employee_typ_nm').focus();
                            var page    =   $('#leftcontent').find('.active a').attr('page');
                            var search  =   $('#search_key').val();
                            getLeftContent(page, search);
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
        alert('save: ' + e.message);
    }
}

/**
 * save
 * 
 * @author      :   namnb - 2018/08/23 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function deleteData() {
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0060/delete', 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
                            clearData(_obj);
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
        alert('delete: ' + e.message);
    }
}

function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0060/leftcontent', 
            dataType    :   'html',
            loading     :   true,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    _formatTooltip();
                    var employee_typ = $('#employee_typ').val();
                    $('.list-search-content div[id="'+employee_typ+'"]').addClass('active');
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                    if(_flgLeft != 1){
                        $('#search_key').focus();
                    }else{
                        _flgLeft = 0;
                    }
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}

function getRightContent(employee_typ) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0060/rightcontent', 
            dataType    :   'json',
            // loading     :   true,
            data        :   {employee_typ: employee_typ},
            success: function(res) {
                $('#employee_typ').val(res.employee_typ);
                $('#employee_typ_nm').val(htmlEntities(res.employee_typ_nm));
                $('#arrange_order').val(res['arrange_order']);
                $('#import_cd').val(res['import_cd']);
                $('#employee_typ_nm').focus();
                $('#employee_typ_nm').removeClass('boder-error');
                $('#employee_typ_nm').next('.textbox-error').remove();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}