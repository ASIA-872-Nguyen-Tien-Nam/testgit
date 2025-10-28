/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2021/01/05
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'employee_cd'                       : {'type':'text', 'attr':'id'},
    'detail_no'                         : {'type':'text', 'attr':'id'},
    'supporter_cd'                      : {'type':'text', 'attr':'id'},
    'review_date'                       : {'type':'text', 'attr':'id'},
    'project_title'                     : {'type':'text', 'attr':'id'},
    'evaluation_typ'                    : {'type':'select','attr':'id'},
    'comment_date'                      : {'type':'text', 'attr':'id'},
    'comment'                           : {'type':'text', 'attr':'id'},
    'use_typ'                           : { 'type': 'text', 'attr': 'id' },
    'fiscal_year'                       : { 'type': 'text', 'attr': 'id' },
}
$(function(){
    try{
        initialize();
        initEvents();
    }catch(e){
        alert('initialize: ' + e.message);
    }
});
/**
 * initialize
 *
 * @author    : nghianm - 2021/01/05 - create
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
 * @author    : nghianm - 2021/01/05 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
    //back
    $(document).on('click', '#btn-back', function (e) {
        try {
            var from = $('#from').val();
            // check from  
            if(from == 'mq2000'){
                _backButtonFunction('',true);
            }else{
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            }
        } catch (e) {
            alert('#btn-back' + e.message);
        }
    });
    //save
    $(document).on('click' , '.btn-save' , function(e){
        try{
            jMessage(1, function(r) {
                if ( r && _validate($('body'))) {
                    if ($('#employee_cd').val()!= '') {
                        saveData();
                    }else{
                        jMessage(21);
                    }
                }
                else {
                    $('.num-length').removeClass('td-error');
                }
            });
        } catch(e){
            alert('.btn-save: ' + e.message);
        }
    });
    //delete
    $(document).on('click', '#btn-delete', function(){
        try{
            jMessage(3, function(r) {
                if (r) {
                    del();
                }
            });
        } catch(e){
            alert('btn-delete: ' + e.message);
        }
    });
    //checked use_typ
    $(document).on('click' , '#use_typ' , function(e){
        try{
            if($(this).is(":checked")){
                $(this).val(1);
            }
            else {
                $(this).val(0);
            }
        } catch(e){
            alert('use_typ: ' + e.message);
        }
    });
}
/**
 * save
 *
 * @author      :   nghianm - 2021/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        $.ajax({
            type        :   'POST',
            url         :   '/multiview/mi2000/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(2, function(r) {
                            // check send mail
                            if(typeof res['mail_info'] != 'undefined' && res['mail_info'].length > 0){
                                sendMail(res['mail_info']);
                            }else{
                                afterProcess($('#from').val());
                            }
                        });
                        break;
                    // error
                    case NG:
                        // check exists error mail
                        if(typeof res['error_no'] != 'undefined'){
                            jMessage(2,function(r){
                                if(r){
                                    jMessage(res['error_no'],function(e){
                                        if(e){
                                            afterProcess($('#from').val());
                                        }
                                    });
                                }
                            });
                        }else{
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
        alert('saveData' + e.message);
    }
}
/**
 * del
 *
 * @author      :   nghianm - 2021/01/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var employee_cd         = $('#employee_cd').val();
        var detail_no           = $('#detail_no').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/multiview/mi2000/delete',
            dataType    :   'json',
            loading     :   true,
            data        :   {employee_cd: employee_cd,detail_no:detail_no},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //cons
                        jMessage(4, function(r) {
                            // do something
                            afterProcess($('#from').val());
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

/**
 * Process after save for close browser or back home
 *
 * @author      :   viettd - 2021/03/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function afterProcess(from = ''){
    try{
        if(from == 'mq2000'){
            window.close();
        }else if (from == 'mdashboardsupporter'){
            // var home_url = $('#home_url').attr('href');
            home_url = '/multiview/mdashboardsupporter';
            _backButtonFunction(home_url);
        }else{
            location.reload();
        }
    }catch(e){
        alert('afterProcess:'+e.message);
    }
}
/**
 * Send mail information to rater1
 *
 * @author      :   viettd - 2021/05/13 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
 function sendMail(mail_info){
    try{
        var data = {};
        data.mail_info = mail_info;
        // send data to post
		$.ajax({
			type: "POST",
			url: "/multiview/mi2000/send-mail",
			dataType: "json",
			loading: true,
			data: data,
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						// jMessage(80,function(r){
                        //     afterProcess($('#from').val());
						// });
                        setTimeout(
                            function() 
                            {
                                afterProcess($('#from').val());
                            }, 3000);
                        
						break;
					// error
					case NG:
						jMessage(81,function(r){
							afterProcess($('#from').val());
						});	
					// Exception
					case EX:
						// jError(res["Exception"]);
						// send mail error
						jMessage(81,function(r){
							afterProcess($('#from').val());
						});	
						break;
					default:
						break;
				}
			},
		});
    }catch(e){
        alert('sendMail:'+e.message);
    }
}