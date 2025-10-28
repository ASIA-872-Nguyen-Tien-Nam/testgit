/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/25
 * 作成者          :   longvv – longvv@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'job_cd'            : {'type':'text', 'attr':'id'},
    'job_nm'            : {'type':'text', 'attr':'id'},
    'job_ab_nm'         : {'type':'text', 'attr':'id'},
    'arrange_order'     : {'type':'text', 'attr':'id'},
};
var _flgLeft = 0;
$(document).ready(function() {
    try {
        initialize();
        initEvents();
    } catch (e) {
        alert('ready' + e.message);
    }
});

/**
 * initialize
 *
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('#job_nm').focus();
        //
        _formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
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
            $('#job_nm').focus();
            $('#job_cd').val('');
            $('#job_nm, #job_ab_nm,#arrange_order').val('');
            $('#job_nm').removeClass('boder-error');
            $('#job_nm').next('.textbox-error').remove();
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
        var job_cd   =  $('#job_cd').val();
        var job_nm   =  $('#job_nm').val();  
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
  }
  catch(e) {
    console.log(e.stack);
  }
}

/**
 * save
 * 
 * @author      :   namnb - 2018/08/16 - create
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
            url         :   '/basicsetting/m0030/save', 
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
                            location.reload();
                            // clearData(_obj);
                            // $('#job_nm').focus();
                            // if(res['job_cd'] != 0){
                            //     $('#job_cd').val(res['job_cd']);
                            // }
                            // var page    =   $('#leftcontent').find('.active a').attr('page');
                            // var search  =   $('#search_key').val();
                            // getLeftContent(page, search);
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
 * saviiiie
 * 
 * @author      :   namnb - 2018/08/16 - create
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
            url         :   '/basicsetting/m0030/delete', 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
                            // $('#rightcontent').find('input,select,checkbox').val('');
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
        alert('save' + e.message);
    }
}

function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0030/leftcontent', 
            dataType    :   'html',
            loading     :   true,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                }  else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    // var job_cd = $('#job_cd').val();
                    // $('.list-search-content div[id="'+job_cd+'"]').addClass('active');
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                    if(_flgLeft != 1){
                        $('#search_key').focus();
                    }else{
                        _flgLeft = 0;
                    }
                    //
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}

function getRightContent(job_cd) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/m0030/rightcontent', 
            dataType    :   'json',
            // loading     :   true,
            data        :   {job_cd: job_cd},
            success: function(res) {
                $('#job_cd').val(htmlEntities(res.job_cd));
                $('#job_nm').val(htmlEntities(res.job_nm));
                $('#job_ab_nm').val(htmlEntities(res['job_ab_nm']));
                $('#arrange_order').val(res['arrange_order']);
                $('#job_nm').focus();
                $('#job_nm').removeClass('boder-error');
                $('#job_nm').next('.textbox-error').remove();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}