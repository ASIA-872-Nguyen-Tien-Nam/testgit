/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	tannq – tannq@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'contract_cd'                       :   {'type':'text',     'attr':'id'},
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
    $(document).on('click','#btn_login',function(e) {
        e.preventDefault();
        var data = getData(_obj);
        // if ($('#language_jmessages').attr('value')) {
        //     data.data_sql.language = 'en';
        // } else {
        //     data.data_sql.language = 'jp';
        // }
        data.data_sql.remember_contract_cd      =   0;
        data.data_sql.remember_id = 0;
            if($('#remember_contract_cd:checked').length > 0) {
                data.data_sql.remember_contract_cd = 1;
            }
            if($('#remember_id:checked').length > 0) {
                data.data_sql.remember_id = 1;
            }
            if(_validate()){
                $.ajax({
                    url:'/login',
                    type:'post',
                    dataType    :   'json',
                    data        :   JSON.stringify(data),
                    loading:true,
                    success: function (response) {
                        switch (response['status']){
                            case 200:
                                if(response.redirectTo) {
                                    location.href=response.redirectTo
                                    return;
                                };
                            break;
                            case 201:
                                if ($('#language_jmessages').attr('value') == 'en') {
                                    jError('Error', response['message'], function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                    return;
                                } else {
                                    jError('エラー', response['message'], function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                    return;
                                }
                            break;
                            case 202:
                                if ($('#language_jmessages').attr('value') == 'en') {
                                    jError('Error', "Access Denied. You Don't Have Permission To Access.", function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                } else {
                                    jError('エラー', 'アクセスが拒否されました。アクセスする権限がありません。', function () {
                                        $('input:not([readonly]):not([disabled]):first').focus();
                                    });
                                }
                            break;
                            default:
                            break;
                        }
                        
                    },
                    error: function (xhr) {
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
                            // location.reload();
                            if ($('#language_jmessages').attr('value') == 'en') {
                                jError('Error', "Access Denied. You Don't Have Permission To Access.", function () {
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                });
                            } else {
                                jError('エラー', 'アクセスが拒否されました。アクセスする権限がありません。', function () {
                                    $('input:not([readonly]):not([disabled]):first').focus();
                                });
                            }
                        }
                        
                        
                    }
                });
            }
    });

    $(document).on('click','.btn-cancel',function(e) {
        e.preventDefault()
        $('input:not([readonly]):not([disabled]):first').focus(); 
    });

}