/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/09/25
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _flgLeft = 0;
var _check_save = 0;
var _mode = 0;
var _obj = {
    'item_cd'                  : {'type' : 'text', 'attr' : 'id'},
    'item_nm'                  : {'type' : 'text', 'attr' : 'id'},
    'arrange_order'            : {'type' : 'text', 'attr' : 'id'},
    'item_kind'                : {'type' : 'select', 'attr' : 'id'},
    'item_digits'              : {'type' : 'text', 'attr' : 'id'},
    'rater_browsing_kbn'       : {'type' : 'checkbox', 'attr' : 'id'},
    'item_display_kbn'         : {'type' : 'select', 'attr' : 'id'},
    'search_item_kbn'          : {'type' : 'checkbox', 'attr' : 'id'},
    'browsing_setting'               : {'attr' : 'list', 'item' : {
            'chk'                       : {'type' : 'checkbox'  , 'attr' : 'class'}
        ,   'authority_cd'              : {'type' : 'text'    , 'attr' : 'class'}
        },
    },
    'choice_field'               : {'attr' : 'list', 'item' : {
            'detail_no'              : {'type' : 'text'  , 'attr' : 'class'}
        ,   'detail_nm'              : {'type' : 'text'   , 'attr' : 'class'}
        },
    }
};
$(function(){
    //calcTable();
    initialize();
    initEvents();
});

/**
 * initialize
 *
 * @author      :   nghianm - 2020/09-25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('#item_nm').focus();
        $('.betting_rate').trigger('blur');
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
     document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
            if ($(':focus')[0] === $(":input:not([readonly],[disabled],[tabindex='-1'],:hidden)").last()[0]) {
                e.preventDefault();
                $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first().focus();
            }
        }
    });
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
    //btn-add-row
    $(document).on('click','#btn-add-new-row',function (e) {
        try{
            var row = $("#table_row_add tbody tr:first").clone();
            $('#table-data tbody').append(row);
            _formatTooltip();
            $('#table-data tbody tr:last').addClass('choice_field');
            $('#table-data').find('tbody tr:last td:first-child input').focus();
            jQuery.formatInput();
            e.preventDefault();
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
    $(document).on('click', '#btn-delete', function(){
       jMessage(3, function(r) {
            if (r) {
                del();
            }
        });
    });
    /* left content click item */
    $(document).on('click', '.list-search-child', function(e) {
        $('.list-search-child').removeClass('active');
        $(this).addClass('active');
        _check_save = 1;
        _mode = 1;
        getRightContent( $(this).attr('id') );
    });
    //
    $(document).on('change', '#item_digits', function(){
        var row = $('#item_kind').val();
        if(row==1) {
            var val_digits = $('#item_digits').val();
            if(val_digits>200){
                jMessage(114,function(){
                    $('#item_digits').val('');
                    $('#item_digits').focus();
                })
            }
        }
        if(row==2) {
            var val_digits = $('#item_digits').val();
            if(val_digits>8){
                jMessage(115,function(){
                    $('#item_digits').val('');
                    $('#item_digits').focus();
                })
            }
        }

    });
    //
    $(document).on('change', '#item_kind', function(){
        var row = $('#item_kind').val();
        if(row==3){
            $('#table-data thead tr th').css('top','0px');            $('#item_digits').val('');
            $('#row-table-one').hide();
            $('#item_digits').attr("readonly","readonly");
        }
        else if(row==4 || row == 5 ){
            $('#row-table-one').show();
            $('#table-data thead tr th').css('top','0px');
            $('#item_digits').val('');
            $('#item_digits').attr("readonly","readonly");
        }
        else {
            $('#row-table-one').hide();
            $('#item_digits').removeAttr('readonly');
            $('#item_digits').val('');
        }
        if(row == 1 || row == 2 ){
            $('#item_digits_label').addClass('lb-required');
            $('#item_digits').addClass('required');
        } else {
            $('#item_digits_label').removeClass('lb-required');
            $('#item_digits').removeClass('required');
        }
    });
    $(document).on('click', '#btn-back', function(){
        try{
            // window.location.href = '/dashboard';
            if(_validateDomain(window.location)){
                window.location.href = 'sdashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        }catch(e){
            alert('#btn-back: ' + e.message);
        }
    });
    $(document).on('click', '#btn-add-new', function(e) {
        jMessage(5,function(){
            //
            $('#item_cd').val('');
            $('#item_nm').val('');
            $('#item_kind').val(-1);
            $('#item_digits').val('');
            $('#item_display_kbn').val(0);
            $('#search_item_kbn').val(1);
            $('#rater_browsing_kbn').val(1);
            $('#arrange_order').val('');
            $('#row-table-one').addClass('hidden');
            $('#item_digits').removeAttr('readonly');
            $('#search_item_kbn').removeAttr('checked');
            $('#rater_browsing_kbn').removeAttr('checked');
            $('#table-data-right tbody tr td .chk').removeAttr('checked');

            //
            $('.list-search-child').removeClass('active');
            //
            $('#table-data tbody').empty();
            $('#btn-add-new-row').trigger('click');
            //
            $('#item_nm').focus();
            _check_save = 0;
        })
    });
    //btn-remove-row
    $(document).on('click','.btn-remove-row',function () {
        try{
            var count = $('#table-data tbody tr').length;
            if (count <= 1) {
                jMessage(29);
                return false;
            }
            else {
                $(this).parents('tr').remove();
            }
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
     $(document).on('click' , '#btn-save' , function(e){
        var check_total_data = $('#total_data').val();
        if(check_total_data >= 10 && _check_save == 0){
            jMessage(113);
            return false;
        }
        jMessage(1, function(r) {
            _flgLeft = 1;
            if ( r && _validate($('body'))) {
                saveData();
            }
        });
    });
}
/**
 * get left content
 *
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0080/leftcontent',
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
/**
 * save
 *
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        data.data_sql['mode'] = _mode;
        if((data.data_sql.item_kind == 1 && data.data_sql.item_digits == 0)
        	|| (data.data_sql.item_kind == 2 && data.data_sql.item_digits == 0)){
                jMessage(9, function(r) {
                    $('#item_digits').focus();
                })
                return
        }
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0080/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // do something
                            location.reload();
                            _mode = 0;
                            // $('#table-data tbody tr:first td:first-child input').focus();
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
        alert('save' + e.message);
    }
}
/**
 * del
 *
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var data    = {
            'item_cd' : $('#item_cd').val()
        };
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0080/del',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            // do something
                            clear();
                            location.reload();
                            // $('#table-data tbody tr:first td:first-child input').focus();
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
        alert('save' + e.message);
    }
}
/**
 * get right content
 *
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(item_cd) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0080/rightcontent',
            dataType    :   'html',
            // loading     :   true,
            data        :   {item_cd: item_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                jQuery.formatInput();
                _formatTooltip();
                $('#item_nm').focus();
                app.jTableFixedHeader();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * clear
 *
 * @author      :   nghianm - 2020/09/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function clear() {
    try {
        // send data to post
        $('#item_cd').val('');
            $('#item_nm').val('');
            $('#item_kind').val(-1);
            $('#item_digits').val('');
            $('#item_display_kbn').val(0);
            $('#search_item_kbn').val(1);
            $('#rater_browsing_kbn').val(1);
            $('#arrange_order').val('');
            $('#row-table-one').addClass('hidden');
            $('#item_digits').removeAttr('readonly');
            $('#search_item_kbn').removeAttr('checked');
            $('#rater_browsing_kbn').removeAttr('checked');
            $('#table-data-right tbody tr td .chk').removeAttr('checked');

            //
            $('.list-search-child').removeClass('active');
            //
            $('#table-data tbody').empty();
            $('#btn-add-new-row').trigger('click');
            //
            $('#item_nm').focus();
            _check_save = 0;
            _mode = 0;
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
