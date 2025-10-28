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
 	'category'			       		: {'type':'select', 'attr':'id'},
 	'status_cd'			       		: {'type':'select', 'attr':'id'},
 	'notice_information'			: {'type':'checkbox', 'attr':'id'},
 	'notice_mail'			       	: {'type':'checkbox', 'attr':'id'},
 	'notice_title'			       	: {'type':'text', 'attr':'id'},
 	'notice_message'			    : {'type':'text', 'attr':'id'},
 	'notice_sending_target'			: {'type':'text', 'attr':'id'},
 	'notice_send_date'			    : {'type':'text', 'attr':'id'},
 	'alert_information'				: {'type':'checkbox', 'attr':'id'},
 	'alert_mail'			       	: {'type':'checkbox', 'attr':'id'},
 	'alert_title'			       	: {'type':'text', 'attr':'id'},
 	'alert_message'			    	: {'type':'text', 'attr':'id'},
 	'alert_sending_target'			: {'type':'text', 'attr':'id'},
 	'alert_send_date'			    : {'type':'text', 'attr':'id'},
 };
 getData()
 $(function(){
 	initialize();
 	initEvents();
	//calcTable();
});

/**
 * initialize
 *
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
 function initialize() {
 	try{
         $('#fiscal_year').focus();
         if($('#status_cd').val() != '-1' && $('#category').val() != '-1'){
            refer();
         }
 	} catch(e){
 		alert('initialize: ' + e.message);
 	}
 }
/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
 function initEvents() {
 	$(document).on('click', '#btn-save', function(e) {
 		jMessage(1,function(r){
 			if(r){
 				if ( r && _validatei1041($('body')) ) {
 					save();
 				}
 			}
 		});
 	});
 	$(document).on('click', '#btn-delete', function(e) {
 		jMessage(3,function(r){
 			if(r){
                del();
            }
        });
 	});
 	$(document).on('change', '#status_cd', function(e) {
        refer();
    });
    $(document).on('change', '#category', function(e) {
     // if($(this).val() == -1){
         // $('input').val('');
         // $('select').val('');
         // $('textarea').val('');
         $('[type=checkbox]').prop('checked',false) ;
         $('#body input,#body select,#body textarea').val('');
         $('#body input,#body select,#body textarea').removeClass('required');
         $('#body label').removeClass('lb-required');
         loadStatus($(this).val());
     // }
     $.formatInput();
 });
    $(document).on('click', '#btn-back', function(){
        // if(_validateDomain(window.location)){
        //     window.location.href = '/master/i1040';
        // }else{
        //     jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        // }
        window.close();
    });
    //
    $(document).on('click', '#notice_information,#notice_mail', function(){
     if($('#notice_information').prop("checked") || $('#notice_mail').prop("checked")){
        $('#notice_title').addClass('required');
        $('#notice_title').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#notice_message').addClass('required');
        $('#notice_message').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#notice_sending_target').addClass('required');
        $('#notice_sending_target').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#notice_send_date').addClass('required');
        $('#notice_send_date').parents('.form-group').find('.control-label').addClass('lb-required');

    }else{
        $('#notice_title').removeClass('required');
        $('#notice_title').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#notice_message').removeClass('required');
        $('#notice_message').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#notice_sending_target').removeClass('required');
        $('#notice_sending_target').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#notice_send_date').removeClass('required');
        $('#notice_send_date').parents('.form-group').find('.control-label').removeClass('lb-required');
    }
});
    $(document).on('click', '#alert_information,#alert_mail', function(){
     if($('#alert_information').prop("checked") || $('#alert_mail').prop("checked")){
        $('#alert_title').addClass('required');
        $('#alert_title').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#alert_message').addClass('required');
        $('#alert_message').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#alert_sending_target').addClass('required');
        $('#alert_sending_target').parents('.form-group').find('.control-label').addClass('lb-required');
        $('#alert_send_date').addClass('required');
        $('#alert_send_date').parents('.form-group').find('.control-label').addClass('lb-required');
    }else{
        $('#alert_title').removeClass('required');
        $('#alert_title').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#alert_message').removeClass('required');
        $('#alert_message').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#alert_sending_target').removeClass('required');
        $('#alert_sending_target').parents('.form-group').find('.control-label').removeClass('lb-required');
        $('#alert_send_date').removeClass('required');
        $('#alert_send_date').parents('.form-group').find('.control-label').removeClass('lb-required');
    }
});
}
/**
 * Common item validation process. Call when click save button.
 *
 * @author : viettd - 2015/10/02 - create
 * @author :
 * @param :
 *            element
 * @return : true/false
 * @access : public
 * @see :
 */
 function  _validatei1041(element) {
    if (!element) {
        element = $('body');
    }
    var error = 0;
    try {
        _clearErrors(1);
        // validate required
        var message = _text[8].message;
        element.find('.required:enabled').each(function() {
            //biennv 2016/01/14 fix required in tab
            if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
                if ((($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '')) {
                    $(this).errorStyle(message,1);
                    error++;
                } else if ($(this).is("select") && ($(this).val() == '-1'  || $(this).val() == undefined)) {
                    $(this).errorStyle(message,1);
                    error++;
                }
            }
        });

        element.find('.requiredValue0:enabled').each(function() {
            //biennv 2016/01/14 fix required in tab
            if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
                if (($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '' || $.trim($(this).val()) == '0') {
                    $(this).errorStyle(message,1);
                    error++;
                }
            }
        });

        if (error > 0) {
            checkTabError();
            _focusErrorItem();
            return false;
        } else {
            return true;
        }
    } catch (e) {
        alert('_validate: ' + e.toString());
    }
}
/**
 * refer
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function refer() {
 	try {
 		var category 	= $('#category').val();
 		var status_cd 	= $('#status_cd').val();
		// send data to post
		$.ajax({
			type        :   'post',
			url         :   '/master/i1041/refer',
			dataType    :   'html',
			loading     :   true,
			data        :   {category: category,status_cd:status_cd},
			success: function(res) {
				// active_left_menu();
				// app.jTableFixedHeader();
				$('#body').empty();
				$('#body').append(res);
				$.formatInput();
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}

/**
 * saveData
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function save(){
 	var data = getData(_obj);
 	$.ajax({
 		type : 'post',
 		data: JSON.stringify(data),
 		url: '/master/i1041/save',
 		loading: true,
 		success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
                    });
                    break;
                // error
                case NG:
                if(typeof res['errors'] != 'undefined'){
                	processError(res['errors']);
                }
                break;
                case 404:
                jMessage(27);
                break;
                // Exception
                case EX:
                jError(res['Exception']);
                break;
                default:
                break;
            }
        }
    })
 }
/**
 * del
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function del(){
 	var category 	= $('#category').val();
 	var status_cd 	= $('#status_cd').val();
 	$.ajax({
 		type : 'post',
 		data: {category:category,status_cd:status_cd},
 		url: '/master/i1041/del',
 		loading: true,
 		success: function(res){
 			switch (res['status']){
                    // success
                    case OK:
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
    })
 }
 /**
 * loadStatus(ステータス状況)
 *
 * @author		:	viettd - 2018/09/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadStatus(category = 0){
    try {
        //
        $.ajax({
            type		:	'POST',
            url			:	'/master/i1041/loadStatus',
            dataType	:	'json',
            loading 	: 	true,
            data		:	{
            	category	: category
            },
            success: function(res) {
            	if(typeof res['status_cd_cb'] != undefined){
            		var html = '<option value="-1"></option>';
            		for (var i = 0; i < res['status_cd_cb'].length; i++) {
            			html += '<option value="'+res['status_cd_cb'][i]['status_cd']+'">'+htmlEntities(res['status_cd_cb'][i]['status_nm'])+'</option>';
            		}
            		//
            		$('.status_cd').html(html);
                }
                if (typeof res['target'] != undefined) {
                    var html = '<option value="-1"></option>'
                    for (var i = 0; i < res['target'].length; i++) {
            			html += '<option value="'+res['target'][i]['number_cd']+'">'+htmlEntities(res['target'][i]['name'])+'</option>';
                    }
                    $('#notice_sending_target').empty();
                    $('#alert_sending_target').empty();
                    $('#notice_sending_target').html(html);
                    $('#alert_sending_target').html(html);
                }
            }
        });
    } catch (e) {
        alert('loadcustomerOrganization' + e.message);
    }
}
