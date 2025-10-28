/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'contract_cd'                       :   {'type':'text',     'attr':'id'},
    'contract_company_attribute'       :   {'type':'numeric',     'attr':'id'},
    'user_id'                          :   {'type':'text',     'attr':'id'},
    'password'                         :   {'type':'text',     'attr':'id'},
 };
$(function(){
  try{
    initEvents();
    initialize(); 
    $('input:not([readonly]):not([disabled]):first').focus();
  }catch(e){
    alert('initialize: ' + e.message);
  }
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
        $(document).on('click','#btn_login',function(e) {
            e.preventDefault();
                if(_validate()){
                    var data                    =   {};
                    data.contract_cd            =   $("#contract_cd").val();
                    data.user_id                =   $("#user_id").val();
                    data.password               =   $("#password").val();
                    data.remember_id            =   0;
                    data.remember_contract_cd   =   0;
                    if($('#remember_id:checked').length > 0) {
                        data.remember_id = 1;
                    }
                    if($('#remember_contract_cd:checked').length > 0) {
                        data.remember_contract_cd = 1;
                    }
                    $.ajax({
                        url:'/logincustomer',
                        type:'post',
                        dataType    :   'json',
                        data        :   data,
                        loading:true,
                        success:function(response) {
                            if(response.redirectTo) {
                                location.href=response.redirectTo
                                return;
                            }
                        },
                        error:function(xhr) {
                            var json = xhr.responseJSON;
                           
                            if (xhr.status == 401) {
                                if ($('#language_jmessages').attr('value') == 'en') {
                                    jError('Error', json.message, function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                    return;
                                } else {
                                    jError('エラー', json.message, function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                    return;
                                }
                            } else {
                                if ($('#language_jmessages').attr('value') == 'en') {
                                    jError('Error', 'Session timeout. Please reload the screen.', function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                } else {
                                    jError('エラー', 'セッションタイムアウトが発生しました。画面を再描画してください。', function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                }
                            }
                            
                            
                        }
                    });
                }
        });
    }catch(e){
        alert('initEvents' + e.message);
    }
}