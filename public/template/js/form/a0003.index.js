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
    'company_cd'                            : {'type':'text', 'attr':'id'},
    'api_use_typ'                           : {'type':'text', 'attr':'id'},
    'api_client_id'                         : {'type':'text', 'attr':'id'},
    'api_client_secret'                     : {'type':'text', 'attr':'id'},
    'api_office_cd'                         : {'type':'text', 'attr':'id'},
    'api_office_nm'                         : {'type':'text', 'attr':'id'},
    'api_employee_use'                      : {'type':'text', 'attr':'id'},
    'api_position_use'                      : {'type':'text', 'attr':'id'},
    'api_organization_use'                  : {'type':'text', 'attr':'id'},

};
var _flgLeft = 0;
$(function(){
  try{
    initEvents();
    initialize();
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
        // _formatTooltip();
        // jQuery.formatInput();
        $('#company_nm').focus();
        var company_cd = $('#company_cd').val();
        if($('#api_err').length > 0 && $('#api_err').val() == 1){
            var option = {};
            option.width 	= '350px';
            option.height 	= '500px';
            showPopup('/master/a0003/popup',option,function(){});
        }
        if($('#api_err').length > 0 && $('#api_err').val() == 2){
            jMessage(103);
        }
        if($('#api_err').length > 0 && $('#api_err').val() == 0 && $('#api_office_nm').val() == '' ){
            $('#api_office_nm').val($('#api_company_nm').val());
            $('#api_office_cd').val($('#api_company_id').val());
        }

        if($('#api_use_typ').val()==1){
            if($('#company_cd').val() != ''){
                $('.btn-issue-api').prop('disabled',false);
            }
            $('#api_use_typ').prop('checked',true);
            $('.btn-get-accesstoken').prop('disabled',false);
        }else{
            $('#api_use_typ').prop('checked',false);
            $('.btn-issue-api').prop('disabled');
            $('.btn-get-accesstoken').prop('disabled');
        }
        //
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

        $(document).on('click', '#api_use_typ', function(e) {
            let company_cd = $('#company_cd').val();
            if($('#api_use_typ').val() == 0){
                // $('#api_user').addClass('required');
                // $('#api_user').parents('.form-group').find('.control-label').addClass('lb-required');
                // $('#api_user_secret').addClass('required');
                // $('#api_user_secret').parents('.form-group').find('.control-label').addClass('lb-required');
                // $('#api_user').removeAttr('disabled');
                // $('#api_user_secret').removeAttr('disabled');
                if($('#company_cd').val() != ''){
                    $('.btn-issue-api').removeAttr('disabled');
                }
                $('.btn-get-accesstoken').removeAttr('disabled');
                // $('#api_client_secret').removeAttr('disabled');
                // $('#api_client_id').removeAttr('disabled');
            }else{
                _clearErrors(1);
                // $('#api_user').removeClass('required');
                // $('#api_user').parents('.form-group').find('.control-label').removeClass('lb-required');
                // $('#api_user_secret').removeClass('required');
                // $('#api_user_secret').parents('.form-group').find('.control-label').removeClass('lb-required');
                // $('#api_user').attr('disabled',true);
                // $('#api_user_secret').attr('disabled',true);
                $('.btn-issue-api').attr('disabled',true);
                $('.btn-get-accesstoken').attr('disabled',true);
                // $('#api_client_secret').attr('disabled',true);
                // $('#api_client_id').attr('disabled',true);
            }
        });

        /* end click item */
           //use_typ
        $(document).on('change', 'input[type="checkbox"]', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#cooperation_typ : ' + e.message);
            }
        });

        $(document).on('click', '#btn-save', function(e) {
            // demo-message.js
            jMessage(1, function(r) {
                _flgLeft = 1;
                if ( r  ) {
                    saveData();
                }
            });
        });

        $(document).on('click', '#btn-back', function(e) {
            var home_url            =   $('#home_url').attr('href');
            var urlObject = new URL(home_url);
            if(!_validateDomain(window.location,urlObject.pathname))
            {
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }else{
                window.location.href    =   home_url;
            }
        });

        $(document).on('click','.btn-get-accesstoken', function(e){
             try{
                    var obj = {};
                    obj.html_a0003               =  getHtmlCondition($('#a0003-body'));
                    obj.screen_id                = 'a0003_api';
                    setCache(obj, '/master/a0003/requesttokens');
            }catch(e){
                alert('btn-issue-api : ' + e.message);
            }

        });
        //btn-issue-api
        $(document).on('click' , '.btn-issue-api' , function(e){
            try{
               if($('.cb-api:checked').length == 0){
                   alert(1);
               }else{
                   let data = {};
                   let api_office_cd        = $('#api_office_cd').val();
                    if( api_office_cd == '')
                    {
                        jMessage(103);
                    }else if($('#api_employee_use').val() != 0 || $('#api_position_use').val() != 0 || $('#api_organization_use').val() != 0){
                            data.api_employee_use        = $('#api_employee_use').val();
                            data.api_position_use        = $('#api_position_use').val();
                            data.api_organization_use    = $('#api_organization_use').val();
                            data.api_office_cd           = $('#api_office_cd').val();
                            $.ajax({
                                 type        :   'POST',
                                 url         :   '/master/a0003/api',
                                 // dataType    :   'json',
                                 loading     :   true,
                                 data        :   data,
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
                                           jMessage(104);
                                            break;
                                        // Exception
                                        case EX:
                                            jError(res['Exception']);
                                            break;
                                        case 401:
                                            var obj = {};
                                            let company_cd_refer = $('#company_cd').val();
                                            obj.html_a0003                     =  getHtmlCondition($('#a0003-body'));
                                            obj.company_cd_refer         =  company_cd_refer;
                                            obj.screen_id                = 'a0003_api';
                                            setCache(obj, '/master/a0003/requesttokens');
                                            break;
                                        case 400:
                                            jError('エラー','400 '+res['message']);
                                            break;
                                        case 403:
                                            jError('エラー','403 '+res['message']);
                                        break;
                                        case 404:
                                            jError('エラー','404 '+res['message']);
                                        break;
                                        case 429:
                                            jError('エラー','429 '+res['message']);
                                        break;
                                        case 503:
                                            jError('エラー','503 '+res['message']);
                                        break;
                                        default:
                                            break;
                                    }
                                 },
                                 error:function(xhr){
                                     console.log(xhr);
                                 }
                            });
                    }
               }
            }catch(e){
                alert('btn-issue-api : ' + e.message);
            }
        });
    }catch(e){
        alert('initEvents' + e.message);
    }
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
 function  a0003Validate(element) {
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

                    if (($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '') {
                        $(this).errorStyle(message,1);
                        error++;
                    } else if ($(this).is("select") && ($(this).val() == '0' ||((!$(this).is("select")) && $(this).val() == '0') || $(this).val() == undefined)) {
                        $(this).errorStyle(message,1);
                        error++;
                    }
            });
            var rowData         =   0;
            var count           =   $('#table-target tbody tr').length;
            var rowcount        =  0;
            if (count == 0 && error == 0) {
                jMessage(29);
                error++;
            }else{
             $('#table-target tbody tr').each(function(){
                var incharge_cd =  $(this).find('.incharge_cd').val();
                if($('.incharge_cd[value="'+incharge_cd+'"]').length > 1 && incharge_cd !=''){
                    $(this).find('.employee_customer_nm').errorStyle(_text[32].message,1);
                    error++;
                }
                $('#table-target tbody tr td .boder-error:first').focus();
                if($(this).find('.incharge_cd').val() !=''){
                    rowData++;
                }
            });
         }
         if (count !=0 && rowData == 0) {
            $('#table-target tbody tr:first td:first-child .employee_customer_nm').errorStyle(_text[8].message,1);
            $('#table-target tbody tr:first td:first-child .employee_customer_nm').focus();
            error++;
        }
        var use_start_dt   =   $('#use_start_dt').val();
        var user_end_dt    =   $('#user_end_dt').val();
        // var use_start_dt   =   moment($('#use_start_dt').val()).format('YYYY/MM/DD');
        // var user_end_dt    =   moment($('#user_end_dt').val()).format('YYYY/MM/DD');
        if(moment(use_start_dt).format('YYYY/MM/DD') > moment(user_end_dt).format('YYYY/MM/DD') && user_end_dt != '' && use_start_dt !=''){
            $('#use_start_dt').errorStyle(_text[24].message,1);
            $('#user_end_dt').errorStyle(_text[24].message,1);
            error++;
        }
         if (error > 0) {
            _focusErrorItem();
            checkTabError();
            return false;
        } else {
            return true;
        }
    } catch (e) {
        alert('_validate: ' + e.toString());
    }
}

/**
 * showPopup
 *
 * @author : longvv - 2018/09/05 - create
 * @param : href,option,callback
 * @return : null
 * @access : public
 * @see :
 */
function showm0001Popup(href,option,callback) {
    var properties = {
        href : href,
        open : true,
        iframe : true,
        fastIframe : false,
        opacity : 0.2,
        escKey : true,
        overlayClose : false,
        innerWidth : option.width,
        innerHeight : option.height,
        reposition : true,
        speed : 0,
        cbox_load : function() {
            $('#cboxClose, #cboxTitle').remove();
        },
        onClosed : function() {

            if (callback) {
                callback();
            }
        }
    };
    // $.extend(properties,option);
    $.colorbox(properties);
}

/**
 * save
 *
 * @author      :   longvv - 2018/09/05 - create
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
            url         :   '/master/a0003/save',
            // dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
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
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            },
            error:function(xhr){
                console.log(xhr);
            }
        });
    } catch (e) {
        alert('save' + e.message);
    }
}

function setData(options)
{
    var objs = {};
    $.extend(objs,options)
    var str = '';
    $.each(objs,function(key,value) {
        var param = key+'='+value+'&';
        str+=param;
    });
    return str;
}
function logoutApi(){
    var iframe = $('<iframe style="visibility: collapse;"></iframe>');
                    $('body').append(iframe);
                    var content = iframe[0].contentDocument;
                    var form = '<form action="https://app.secure.freee.co.jp/developers/sign_out" method="GET"></form>';
                    content.write(form);
                    $('form', content).submit();
                    setTimeout((function(iframe) {
                    return function() {
                        iframe.remove();
                    }
                    })(iframe), 2000);
}