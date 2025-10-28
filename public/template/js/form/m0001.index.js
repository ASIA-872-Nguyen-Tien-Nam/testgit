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
    'company_nm'                            : {'type':'text', 'attr':'id'},
    'company_ab_nm'                         : {'type':'text', 'attr':'id'},
    'zip_cd'                                : {'type':'text', 'attr':'id'},
    'address1'                              : {'type':'text', 'attr':'id'},
    'address2'                              : {'type':'text', 'attr':'id'},
    'address3'                              : {'type':'text', 'attr':'id'},
    'tel'                                   : {'type':'text', 'attr':'id'},
    'fax'                                   : {'type':'text', 'attr':'id'},
    'incharge_nm'                           : {'type':'text', 'attr':'id'},
    //
    'evaluation_use_typ'                    : {'type':'text', 'attr':'id'},
    'evaluation_contract_attribute'         : {'type':'text', 'attr':'id'},
    'evaluation_use_start_dt'               : {'type':'text', 'attr':'id'},
    'evaluation_user_end_dt'                : {'type':'text', 'attr':'id'},

    'oneonone_use_typ'                      : {'type':'text', 'attr':'id'},
    'oneonone_contract_attribute'           : {'type':'text', 'attr':'id'},
    'oneonone_use_start_dt'                 : {'type':'text', 'attr':'id'},
    'oneonone_user_end_dt'                 : {'type':'text', 'attr':'id'},

    'marcopolo_use_typ'                    : {'type':'text', 'attr':'id'},
    'multireview_use_typ'                    : {'type':'text', 'attr':'id'},
    'multireview_contract_attribute'         : {'type':'text', 'attr':'id'},
    'multireview_use_start_dt'               : {'type':'text', 'attr':'id'},
    'multireview_user_end_dt'                : {'type':'text', 'attr':'id'},
    'report_use_typ'                    : {'type':'text', 'attr':'id'},
    'report_contract_attribute'         : {'type':'text', 'attr':'id'},
    'report_use_start_dt'               : {'type':'text', 'attr':'id'},
    'report_user_end_dt'                : {'type':'text', 'attr':'id'},
    //
    'contract_cd'                           : {'type':'text', 'attr':'id'},
    'cooperation_typ'                       : {'type':'checkbox', 'attr':'id'},
    'SSO_use_typ'                           : {'type':'checkbox', 'attr':'id'},
    'SSO_typ'                               : {'type':'text', 'attr':'id'},
    'sp_NameIDFormat'                       : {'type':'text', 'attr':'id'},
    'sp_x509cert'                           : {'type':'text', 'attr':'id'},
    'sp_privateKey'                         : {'type':'text', 'attr':'id'},
    'sp_entityId'                           : {'type':'text', 'attr':'id'},
    'sp_singleLogoutService'                : {'type':'text', 'attr':'id'},
    'idp_entityId'                          : {'type':'text', 'attr':'id'},
    'idp_singleSignOnService'               : {'type':'text', 'attr':'id'},
    'idp_singleLogoutService'               : {'type':'text', 'attr':'id'},
    'idp_x509cert'                          : {'type':'text', 'attr':'id'},
    'billing_to_typ'                        : {'type':'checkbox', 'attr':'id'},
    'destination_nm'                        : {'type':'text', 'attr':'id'},
    'Billing_incharge_nm'                   : {'type':'text', 'attr':'id'},
    'Billing_zip_cd'                        : {'type':'text', 'attr':'id'},
    'Billing_address1'                      : {'type':'text', 'attr':'id'},
    'Billing_address2'                      : {'type':'text', 'attr':'id'},
    'Billing_address3'                      : {'type':'text', 'attr':'id'},
    'Billing_tel'                           : {'type':'text', 'attr':'id'},
    'use_start_dt'                          : {'type':'text', 'attr':'id'},
    // 'api_use_typ'                           : {'type':'text', 'attr':'id'},
    // 'api_client_id'                              : {'type':'text', 'attr':'id'},
    // 'api_client_secret'                       : {'type':'text', 'attr':'id'},
    // 'api_office_cd'                         : {'type':'text', 'attr':'id'},
    // 'api_office_nm'                         : {'type':'text', 'attr':'id'},
    // 'api_employee_use'                      : {'type':'text', 'attr':'id'},
    // 'api_position_use'                      : {'type':'text', 'attr':'id'},
    // 'api_organization_use'                  : {'type':'text', 'attr':'id'},

    'table_m0002'                           : {'attr' : 'list',
            'item' : {
                'detail_no'         : {'type' : 'text', 'attr' : 'id'},
                'incharge_cd'       : {'type' : 'text', 'attr' : 'id'},
            }},
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
            jError('複数の事業所に紐づいているので別のユーザーIDを利用してください。');
        }
        if($('#api_err').length > 0 && $('#api_err').val() == 0){
            $('#api_office_nm').val($('#api_company_nm').val());
            $('#api_office_cd').val($('#api_company_id').val());
        }
        // $('input[type="checkbox"]').prop('checked', true);
        // $('input[type="checkbox"]').val(1);

        // $('.set-sso').removeClass('hidden');
        // $('#SSO_URL').addClass('required');
        // $('#SSO_URL').parents('.form-group').find('.control-label').addClass('lb-required');

        if($('#SSO_use_typ').val()==1){
            $('#sso_header').removeClass('hidden');
            $('#SSO_use_typ').prop('checked',true);
            $('.sso_body').removeClass('hidden');
            $('#SSO_typ').addClass('required');
            $('#SSO_typ').parents('.form-group').find('.control-label').addClass('lb-required');
        }else{
            $('#SSO_use_typ').prop('checked',false);
            $('#sso_header').addClass('hidden');
            $('.sso_body').addClass('hidden');
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
        $('.list-search-content div[id="'+company_cd+'"]').addClass('active');
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
        // keydoun event
        $('#zip_cd').keydown(function(event){
            try {
                if (event.keyCode == 53){
                    return true;
                }
                if (!((event.keyCode > 47 && event.keyCode < 58)
                        || (event.keyCode > 95 && event.keyCode < 106)
                        || event.keyCode == 116
                        || event.keyCode == 46
                        || event.keyCode == 37
                        || event.keyCode == 39
                        || event.keyCode == 8
                        || event.keyCode == 9
                        || event.ctrlKey // 20160404 - sangtk - allow all ctrl combination //
                        || event.keyCode == 229 // ten-key processing
                        )
                        // || event.shiftKey
                        || (event.keyCode == 189 || event.keyCode == 109)) {
                    event.preventDefault();
                }
            } catch (e) {
                alert(e.message);
            }
        });
        $(document).on('focus','textarea',function(){
            if($(this).parents('.text-area').find('.textbox-error').length > 0){
                $(this).parents('.text-area').find('.lg').css('bottom','4px');
            }else{
                return
            }
        });
         $(document).on('keyup','textarea',function(){
            if($(this).parents('.text-area').find('.textbox-error').length == 0){
                $(this).parents('.text-area').find('.lg').css('bottom','-16px');
            }else{
                return
            }
        });
        $(document).on('blur', '.zip_cd', function(e) {
            // var string = $(this).val();
            var string  =   '';
            var zip_cd  =   $(this).val();
                zip_cd  =   formatConvertHalfsize(zip_cd);
            if(zip_cd !=''){
               string   =   zip_cd.replace('-','');
            }
            if (!_validateZipCd(string)) {
                $(this).val('');
            }else{
                $(this).val(string.substr(0, 3)+'-'+string.substr(3, 7));
            }
        });
        $(document).on('click', '#SSO_use_typ', function(e) {
            if($('#SSO_use_typ').val() == 0){
                $('#SSO_typ').addClass('required');
                $('#SSO_typ').parents('.form-group').find('.control-label').addClass('lb-required');
                $('.set-sso').removeClass('hidden');
                $('.set-sso .control-label').addClass('lb-required');
                $('.set-sso .form-control').addClass('required');
                $('#sp_privateKey').parents('.form-group').find('.control-label').removeClass('lb-required');
                $('#sp_privateKey').removeClass('required');
                $('#sso_header').removeClass('hidden');
                $('.sso_body').removeClass('hidden');
                $('.tr-nodata td').attr('colspan','3');
            }else{
                _clearErrors(1);
                $('#SSO_typ').removeClass('required');
                $('#SSO_typ').parents('.form-group').find('.control-label').removeClass('lb-required');
                $('.set-sso').addClass('hidden');
                $('.set-sso .lb-required').removeClass('lb-required');
                $('.set-sso .required').removeClass('required');
                $('#sso_header').addClass('hidden');
                $('.sso_body').addClass('hidden');
                $('.tr-nodata td').attr('colspan','2');
            }
        });
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
            logoutApi();
            getRightContent( $(this).attr('id') );
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
        $(document).on('click', '#btn-add-new', function(e) {
            jMessage(5,function(r){
                if(r){
                    logoutApi();
                    clear_data_m0001();
                }
            })
        });
        $(document).on('click', '#btn-save', function(e) {
            // demo-message.js
            jMessage(1, function(r) {
                _flgLeft = 1;
                if ( r && m0001Validate($('body')) ) {
                    saveData();
                }
            });
        });
        $(document).on('click', '#btn-delete', function(e) {
            var company_cd   =  $('#company_cd').val();
                jMessage(3, function(r) {
                    if (r){
                        deleteData(company_cd);
                    }
                });
        });
        $(document).on('click', '#btn-back', function(e) {
            try{
                jMessage(71, function(r) {
                    if(r){
                        if(_validateDomain(window.location)){
                            window.location.href = _customerUrl('master/q0001');
                        }else{
                            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                        }
                    }
                });
            }catch(e){
                alert('#btn-back'+e.message);
            }
        });
        //btn-add-row
        $(document).on('click','#btn-add-row',function () {
            try{
                var row = $("#table-data tbody tr:first").clone();
                $('#table-target tbody').append(row);
                $('#table-target tbody tr:last').addClass('table_m0002');
                $('#table-target').find('tbody tr:last td:first-child input').focus();
                // initMap();
                jQuery.formatInput();
            } catch(e){
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-remove-row
        $(document).on('click','.btn-remove-row',function () {
            try{
                $(this).parents('tr').remove();
            } catch(e){
                alert('btn-remove-row: ' + e.message);
            }
        });

        //btn-issue
        $(document).on('click' , '.btn-issue' , function(e){
            try{
                $('.input-code').val(randomContractCode(8));
            }catch(e){
                alert('btn-issue : ' + e.message);
            }
        });


        $(document).on('click','.btn-get-accesstoken', function(e){
             try{
                    var obj = {};
                    let company_cd_refer = $('#company_cd').val();
                    obj.html_m0001                     =  getHtmlCondition($('#m0001-body'));
                    obj.company_cd_refer         =  company_cd_refer;
                    obj.screen_id                = 'm0001_api';
                    setCacheCustomer(obj, '/customer/master/m0001/requesttokens?company_cd_refer='+company_cd_refer);
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
                   let company_cd_refer     = $('#company_cd').val();
                   let api_office_cd        = $('#api_office_cd').val();
                    if( api_office_cd == '')
                    {
                        jMessage(103);
                    }else if($('#api_employee_use').val() != 0 || $('#api_position_use').val() != 0 || $('#api_organization_use').val() != 0){
                            data.api_employee_use        = $('#api_employee_use').val();
                            data.api_position_use        = $('#api_position_use').val();
                            data.api_organization_use    = $('#api_organization_use').val();
                            data.api_office_cd           = $('#api_office_cd').val();
                            data.company_cd_refer        = company_cd_refer;
                            $.ajax({
                                 type        :   'POST',
                                 url         :   '/customer/master/m0001/api',
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
                                            obj.html_m0001                     =  getHtmlCondition($('#m0001-body'));
                                            obj.company_cd_refer         =  company_cd_refer;
                                            obj.screen_id                = 'm0001_api';
                                            setCacheCustomer(obj, '/customer/master/m0001/requesttokens?company_cd_refer='+company_cd_refer);
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
        // btn_employee_cd_popup
        $(document).on('click','#btn-id-output', function() {
            try {
                var company_cd = $('#company_cd').val();
                var company_nm = $('#company_nm').val();
                var sso_use_typ = $('#SSO_use_typ').val();
                if(company_cd !=''){
                    var option = {};
                    option.width    = '600px';
                    option.height   = '550px';
                    showm0001Popup('/customer/master/m0001/popup/'+company_cd+'/'+sso_use_typ,option,function(){
                    });
                }
            } catch (e) {
                alert('#btn-id-output' + e.message);
            }
        });
        // billing_to_typ
        $(document).on('click','#billing_to_typ', function() {
            try {
                if($(this).is(':checked')){
                    // $('#destination_nm,#Billing_incharge_nm,#Billing_zip_cd,#Billing_address1,#Billing_address2,#Billing_address3,#Billing_tel').attr('disabled','disabled');
                    // $('#destination_nm,#Billing_incharge_nm,#Billing_zip_cd,#Billing_address1,#Billing_address2,#Billing_address3,#Billing_tel').val('');
                    $('#div_billing_to_typ').addClass('hidden');
                    $('#div_billing_to_typ').find('input').val('');
                }else{
                    $('#div_billing_to_typ').removeClass('hidden');
                    // $('#destination_nm,#Billing_incharge_nm,#Billing_zip_cd,#Billing_address1,#Billing_address2,#Billing_address3,#Billing_tel').removeAttr('disabled');
                }
            } catch (e) {
                alert('#btn-id-output' + e.message);
            }
        });
    }catch(e){
        alert('initEvents' + e.message);
    }
}
/**
 * validate zip code
 *
 * @param string
 * @returns {boolean}
 */
function _validateZipCd(zip_cd) {
    try {
        var reg1 = /^[0-9]{3}-[0-9]{4}$/;
        var reg2 = /^[0-9]{3}[0-9]{4}$/;
        //
        if (zip_cd.match(reg1) || zip_cd.match(reg2) || zip_cd == '') {
            return true;
        } else {
            return false;
        }
    } catch (e) {
        alert('_validateZipCd: ' + e);
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
 function  m0001Validate(element) {
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
        $('.date-m0001').each(function(){
            var use_start_dt   =   $(this).find('.date-start-1').val();
            var user_end_dt    =    $(this).find('.date-end-1').val();
            // var use_start_dt   =   moment($('#use_start_dt').val()).format('YYYY/MM/DD');
            // var user_end_dt    =   moment($('#user_end_dt').val()).format('YYYY/MM/DD');
            if(moment(use_start_dt).format('YYYY/MM/DD') > moment(user_end_dt).format('YYYY/MM/DD') && user_end_dt != '' && use_start_dt !=''){
                $(this).find('.date-start-1').errorStyle(_text[24].message,1);
                $(this).find('.date-end-1').errorStyle(_text[24].message,1);
                error++;
            }
        });

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
 * randomContractCode
 *
 * @author      :  longvv - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function randomContractCode(length) {
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
    var pass = "";
    for (var x = 0; x < length; x++) {
        var i = Math.floor(Math.random() * chars.length);
        pass += chars.charAt(i);
    }
    return pass;
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
        var data = getData(_obj);
        var url = _customerUrl('master/m0001/save');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            // dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            clear_data_m0001();
                            jQuery.formatInput();
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

/**
 * deleteData
 *
 * @author      :   longvv - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData(company_cd) {
    try {
        var url = _customerUrl('master/m0001/delete');
        // var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'json',
            loading     :   true,
            data        :   {company_cd: company_cd},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
                            // clearData(_obj);
                            // $('#table-target tbody tr').remove();
                            clear_data_m0001();
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
 * getLeftContent
 *
 * @author      :   longvv - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        var url = _customerUrl('master/m0001/leftcontent');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'html',
            loading     :   true,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    var company_cd = $('#company_cd').val();
                    $('.list-search-content div[id="'+company_cd+'"]').addClass('active');
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});

                    if(_flgLeft != 1){
                        $('#search_key').focus();
                    }else{
                        $('#company_nm').focus();
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
 * getRightContent
 *
 * @author      :   longvv - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(company_cd) {
    try {
        var url = _customerUrl('master/m0001/rightcontent');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'html',
            // loading     :   true,
            data        :   {company_cd: company_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').html(res);
                jQuery.formatInput();
                app.jTableFixedHeader();
                $('#company_nm').focus();
                $('#company_nm').removeClass('boder-error');
                $('#company_nm').next('.textbox-error').remove();
                $('.nav-tabs a:first').tab('show');
                // initMap();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
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

function clear_data_m0001(){
    clearData(_obj);
                    $('#evaluation_contract_attribute').val('1');
                    $('#oneonone_contract_attribute').val('1');
                    $('#multireview_contract_attribute').val('1');
                    $('#report_contract_attribute').val('1');
                    _clearErrors(1);
                    $('.nav-tabs a:first').tab('show');
                    $('input[type="checkbox"]:not(.cb-api)').prop('checked', true);
                    $('input[type="checkbox"]:not(.cb-api)').val(1);
                    $('input[type="checkbox"].cb-api').prop('checked', false);
                    $('input[type="checkbox"].cb-api').val(0);
                    $('#SSO_typ').addClass('required');
                    $('#SSO_typ').parents('.form-group').find('.control-label').addClass('lb-required');
                    $('.set-sso').removeClass('hidden');
                    $('#div_billing_to_typ').addClass('hidden');
                    $('.set-sso .control-label').addClass('lb-required');
                    $('.set-sso .form-control').addClass('required');
                    $('#sp_privateKey').parents('.form-group').find('.control-label').removeClass('lb-required');
                    $('#sp_privateKey').removeClass('required');
                    // $('#div_billing_to_typ').find('input').val('');
                    $('#table-target tbody tr').remove();
                    $('.list-search-child').removeClass('active');
                    var row = $("#table-data tbody tr:first").clone();
                    $('#table-target tbody').append(row);
                    $('#table-target tbody tr:last').addClass('table_m0002');
                    $('#table-target2 tbody tr').remove();
                    var row2 = $("#table-data tbody tr:last").clone();
                    $('#table-target2 tbody').append(row2);
                    $('#company_nm').focus();
                    $('#sso_header').removeClass('hidden');
                    $('.sso_body').removeClass('hidden');
                    $('.tr-nodata td').attr('colspan','3');
                    //API
                    // $('#api_user').removeClass('required');
                    // $('#api_user').parents('.form-group').find('.control-label').removeClass('lb-required');
                    // $('#api_user_secret').removeClass('required');
                    // $('#api_user_secret').parents('.form-group').find('.control-label').removeClass('lb-required');
                    $('#api_office_nm').val('');
                    $('#api_office_cd').val('');
                    $('.btn-issue-api').attr('disabled',true);
                    $('.btn-get-accesstoken').attr('disabled',true);
                    checkTabError();
                    // initMap();
                    jQuery.formatInput();
}