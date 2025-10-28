/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/02/05
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package         :
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'mail_kbn'          :   {'type':'select'    , 'attr':'id'}
,   'information'       :   {'type':'checkbox'  , 'attr':'id'}
,   'mail'              :   {'type':'checkbox'  , 'attr':'id'}
,   'title'             :   {'type':'text'      , 'attr':'id'}
,   'message'           :   {'type':'text'      , 'attr':'id'}
,   'sending_target'    :   {'type':'select'    , 'attr':'id'}
,   'send_date'         :   {'type':'text'      , 'attr':'id'}
,   'send_kbn'          :   {'type':'select'    , 'attr':'id'}
};
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
 * @author    : nghianm – nghianm@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
 function initialize() {
    try{
        referMailkbn(1);
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * initEvents
 * @author    : nghianm – nghianm@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
 function initEvents() {
    try{
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                //
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back:' + e.message);
            }
        });
        //
        $(document).on('change', '#mail_kbn', function(e) {
            try{
                var check = $('#mail_kbn').val()
                if(check==1) {
                    $('#send_kbn').val(1);
                    $('#send_kbn').prop('disabled',true);
                    var mail_kbn = $(this).val();
                    referMailkbn(mail_kbn);
                }else{
                    $('#send_kbn').prop('disabled',false);
                    var mail_kbn = $(this).val();
                    referMailkbn(mail_kbn);
                }
            }catch(e){
                alert('open video: '+e.message);
            }
        });
        $(document).on('click', '#information', function(e) {
            try{
                if($(this).is(":checked")) {
                    $(this).val(1)
                }else{
                    $(this).val(0)
                }
            }catch(e){
                alert('open video: '+e.message);
            }
        });
        $(document).on('click', '#mail', function(e) {
            try{
                if($(this).is(":checked")) {
                    $(this).val(1)
                }else{
                    $(this).val(0)
                }
            }catch(e){
                alert('open video: '+e.message);
            }
        });
        //save
        $(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch(e){
                alert('.btn-save:' + e.message);
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
                alert('#btn-delete:' + e.message);
            }
        });
    } catch(e){
        alert('initEvents: ' + e.message);
    }
}
/**
 * refer
 *
 * @author      :   nghianm - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referMailkbn(mail_kbn) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oi1011/refer',
            dataType    :   'json',
            loading     :   true,
            data        :   {mail_kbn: mail_kbn},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        if(res.data[0].length > 0){
                            if (mail_kbn == 1) {
                                $('#information').prop('checked', false);
                                $('#information').attr('disabled', true);
                                $('#information').next('.checkmark').addClass('check-box-disabled');
                                $('#information').val(0);
                            } else {
                                if (res.data[0][0].infomation == 1) {
                                    $('#information').prop('checked', true);
                                } else {
                                    $('#information').prop('checked', false);
                                }
                                $('#information').attr('disabled', false);
                                $('#information').next('.checkmark').removeClass('check-box-disabled');
                                $('#information').val(res.data[0][0].infomation);
                            }
                            if(res.data[0][0].mail == 1){
                                $('#mail').prop('checked',true);
                            }else{
                                $('#mail').prop('checked',false);
                            }
                            $('#mail').val(res.data[0][0].mail);
                            $('#message').val(decodeHtml(res.data[0][0].message));
                            $('#send_date').val(res.data[0][0].send_date);
                            $('#send_kbn').val(res.data[0][0].send_kbn);
                            $('#sending_target').val(res.data[0][0].sending_target);
                            $('#title').val(decodeHtml(res.data[0][0].title));
                        }
                        else {
                            if (mail_kbn == 1) {
                                $('#information').prop('checked', false);
                                $('#information').attr('disabled', true);
                                $('#information').next('.checkmark').addClass('check-box-disabled');
                                $('#information').val(0);
                            }else {
                                $('#information').prop('checked', true);
                                $('#information').attr('disabled', false);
                                $('#information').next('.checkmark').removeClass('check-box-disabled');
                                $('#information').val(1);
                            }
                            $('#mail').prop('checked','true');
                            // default message
                            $('#message').val(escapeHtml(res.message));
                            $('#title').val(decodeHtml(res.title));
                            $('#send_date').val('');
                            $('#send_kbn').val(1);
                            $('#sending_target').val(-1);
                        }
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
 * save
 *
 * @author      :   nghianm - 2020/11/10 - create
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
            url         :   '/oneonone/oi1011/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            $('#mail_kbn').trigger('change');
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
 * @author      :   nghianm - 2020/10/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var mail_kbn    = $('#mail_kbn').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oi1011/del',
            dataType    :   'json',
            loading     :   true,
            data        :   {mail_kbn: mail_kbn},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            location.reload();
                            //
                            // if (mail_kbn == 1) {
                            //     $('#information').prop('checked', false);
                            //     $('#information').attr('disabled', true);
                            //     $('#information').next('.checkmark').addClass('check-box-disabled');
                            //     $('#information').val(0);
                            // } else {
                            //     $('#information').prop('checked', true);
                            //     $('#information').attr('disabled', false);
                            //     $('#information').next('.checkmark').removeClass('check-box-disabled');
                            //     $('#information').val(1);
                            // }
                            // $('#mail').prop('checked','true');
                            // $('#message').val('');
                            // $('#send_date').val('');
                            // $('#send_kbn').val(1);
                            // $('#sending_target').val(-1);
                            // $('#title').val('');
                            // // $('#table-data tbody tr:first td:first-child input').focus();
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
 * decodeHtml
 *
 * @author      :   nghianm - 2020/10/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function decodeHtml(str)
{
    var map =
    {
        '&amp;': '&',
        '&lt;': '<',
        '&gt;': '>',
        '&quot;': '"',
        '&#039;': "'"
    };
    // return
    return str.replace(/&amp;|&lt;|&gt;|&quot;|&#039;/g, function(m) {return map[m];});
}

function escapeHtml(unsafe)
{
    return unsafe
        
         .replace(/everyone&amp;#039;s/gm, "everyone's");
 }