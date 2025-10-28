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
    'tr'                 : {'attr' : 'list', 'item' : {
                                'challenge_level'          : {'type' : 'text', 'attr' : 'class'},
                                'challenge_level_nm'       : {'type' : 'text', 'attr' : 'class'},
                                'betting_rate'             : {'type' : 'text', 'attr' : 'class'},
                                'explanation'             : {'type' : 'text', 'attr' : 'class'},
    }}
};
$(function(){
    initEvents();
    initialize();
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
    try{
        $('#table-data').find('tbody tr:first td:first-child input').focus();
        $('.betting_rate').trigger('blur');
    } catch(e){
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
     document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
            if ($(':focus')[0] === $(":input:not([readonly],[disabled],[tabindex='-1'],:hidden)").last()[0]) {
                e.preventDefault();
                $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first().focus();
            }
        }
    });
    //btn-add-row
    $(document).on('click','#btn-add-new',function () {
        try{
            var row = $("#table-target tbody tr:first").clone();
            $('#table-data tbody').append(row);
            $('#table-data tbody tr:last').addClass('tr');
            $('#table-data').find('tbody tr:last td:first-child input').focus();
            $.formatInput('#table-data tbody tr:last');
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
    $(document).on('click', '#btn-back', function(){
        try{
            // window.location.href = '/dashboard';
            if(_validateDomain(window.location)){
                window.location.href = '/dashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        }catch(e){
            alert('#btn-back: ' + e.message);
        }
    });
    //btn-remove-row
    $(document).on('click','.btn-remove-row',function () {
        try{
            $(this).parents('tr').remove();
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
     $(document).on('click' , '#btn-save' , function(e){
        jMessage(1, function(r) {
            if ( r && m0110Validate() ) {
                saveData();
            }
        });
    });
}
/**
 * validate
 *
 * @author      :   longvv - 2018/09/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function m0110Validate() {
    var required = _validate($('body'));
    var count = $('#table-data tbody tr').length;

    if (count == 0) jMessage(29);

    return required && count > 0;
}
/**
 * save
 *
 * @author      :   longvv - 2018/09/06 - create
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
            url         :   '/master/m0110/save',
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
function del(){
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0110/del',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            // do something
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