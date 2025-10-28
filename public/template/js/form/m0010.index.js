/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/08/16
 * 作成者		    :	tuantv
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'office_nm'        : {'type':'text', 'attr':'id'},
    'office_ab_nm'     : {'type':'text', 'attr':'id'},
    'zip_cd'            : {'type':'text', 'attr':'id'},
    'address1'          : {'type':'text', 'attr':'id'},
    'address2'          : {'type':'text', 'attr':'id'},
    'address3'          : {'type':'text', 'attr':'id'},
    'tel'               : {'type':'text', 'attr':'id'},
    'fax'               : {'type':'text', 'attr':'id'},
    'employee_nm'     : {'type':'text', 'attr':'id'},
    'arrange_order'   : {'type':'text', 'attr':'id'},
    'employee_cd'       : {'type':'text', 'attr':'id'},

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
 * @author		:	tuantv - 2018/08/16 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
        $("#office_nm").focus();
        _formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	tuantv - 2018/08/16 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
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

        $(document).on('click', '#btn-save', function(e) {
            try{
                jMessage(1, function(r) {
                    _flgLeft = 1;
                    if ( r && _validate($('body')) ) {
                        saveData();
                    }
                });
            }catch(e){
                alert('#btn-save'+e.message);
            }
        });

        $(document).on('click', '#btn-delete', function(e) {
            try{
                var office_cd   =  $('#office_cd').val();
                var office_nm   =  $('#office_nm').val();
                if ( office_cd == '0' || office_cd == ''){
                    jMessage(21, function(r) {
                        if ( r && _validate($('body')) ) {
                            $('#office_nm').focus();
                        }
                    });
                }else{
                    jMessage(3, function(r) {
                        if (r){
                            deleteData();
                        }
                    });
                } 
            }catch(e){
                alert('#btn-delete'+e.message);
            }
        });

        $(document).on('click', '#btn-back', function(e) {
            try{
                if(_validateDomain(window.location)){
                    window.location.href = '/dashboard';
                }else{
                    jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                }
            }catch(e){
                alert('#btn-back'+e.message);
            }
        });

       /* $(document).on('click', '.input-group-append-btn', function(e) {
            search(1);
        });*/

        $(document).on('click', '.list-search-child', function(e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var office_cd = $(this).data('office_cd');
            refer_office_cd(office_cd);
        });

        $(document).on('click', '#btn-add-new', function(e) {
            try{
                jMessage(5,function(){
                    clearData(_obj);
                    $('#office_cd').val('');
                    $("#office_nm").focus();
                    $("#mode").val("A");
                    $('.list-search-child').removeClass('active');
                });
            }catch(e){
                alert('#btn-add-new'+e.message);
            }
        });

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

        $(document).on('blur', '#zip_cd', function(e) {
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
            if(zip_cd =='') {
                $(this).val("");
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
 * @author      :   tuantv - 2018/08/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var office_cd =  $("#office_cd").val();
        var data    = getData(_obj);
        data.data_sql.mode = $("#mode").val();
        data.data_sql.office_cd = office_cd;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0010/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){

                    // success
                    case OK:
                        jMessage(2, function(r) {
                            clearData(_obj);
                            $('#office_nm').focus();
                            if(res['office_cd'] != 0){
                                $('#office_cd').val(res['office_cd']);
                            }
                            var page = $('.page-item.active').attr('page');
                            var search  =   $('#search_key').val();
                            getLeftContent(page, search);
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
 * delete data
 *
 * @author      :   tuantv - 2018/08/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data    = getData(_obj);
        data.data_sql.office_cd = $("#office_cd").val();
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0010/delete',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
                            clearData(_obj);
                            $("#search_key").val("");
                            _flgLeft = 2;
                            getLeftContent(1,'');
                            $("#mode").val('A');
                            $("#office_cd").val("");
                            setTimeout(function(){
                                $("#office_nm").focus();
                            }, 1000);
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
 * search
 *
 * @author  :   tuantv - 2018/08/20 - create
 * @author  :
 *
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0010/leftcontent',
            dataType    :   'html',
            loading     :   true,
            data        :   {
                current_page: page * 1, 
                search_key: search
            },
            success: function(res) {
                $('#leftcontent .inner').empty();
                $('#leftcontent .inner').html(res);
                var heneed=$('.calHe').innerHeight();
                var hetru=$('.calHe2').innerHeight();
                var heit=heneed-hetru-55;
                var heme=$('.list-search-content').innerHeight();
                $('.list-search-content').attr('style','height: '+ heit +'px');
                if(heme>heit){
                    $('.list-search-content').addClass('scroll');
                }
                var office_cd = $('#office_cd').val();
                //console.log(office_cd);
                $('.list-search-content div[id="'+office_cd+'"]').addClass('active');
                $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                if(_flgLeft != 1){
                    $('#search_key').focus();
                }else{
                    _flgLeft = 0;
                }
                _formatTooltip();
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}




/**
 * refer office_cd
 *
 * @author      :   tuantv - 2018/08/20 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer_office_cd(office_cd) {
    try {
        var data ={};
        data['office_cd'] = office_cd;
        // send data to post

       $.ajax({
            type: 'POST',
            url: '/master/m0010/refer_office_cd',
            dataType: 'html',
            loading: false,
            data: data,
            success: function (res) {
                res = JSON.parse(res);
               if(res.data.office_cd !=''){
                    //fillData(res.data,_obj);
                   $("#office_cd").val(res.data.office_cd);
                   $("#office_nm").val(htmlEntities(res.data.office_nm));
                   $("#office_ab_nm").val(htmlEntities(res.data.office_ab_nm));
                   $("#zip_cd").val(htmlEntities(res.data.zip_cd));
                   $("#address1").val(htmlEntities(res.data.address1));
                   $("#address2").val(htmlEntities(res.data.address2));
                   $("#address3").val(htmlEntities(res.data.address3));
                   $("#tel").val(htmlEntities(res.data.tel));
                   $("#fax").val(htmlEntities(res.data.fax));
                   $("#arrange_order").val(htmlEntities(res.data.arrange_order));
                   $("#employee_nm").val(htmlEntities(res.data.employee_nm));
                   $("#employee_nm").attr('old_employee_nm',res.data.employee_nm);
                   $("#employee_cd").val(htmlEntities(res.data.employee_cd));
                   $("#mode").val("U");
                   $("#office_nm").focus();
                   $('#office_nm').removeClass('boder-error');
                   $('#office_nm').next('.textbox-error').remove();
                }else {

                }
            },
        });
    } catch (e) {
        alert('save' + e.message);
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
 * tooltip format
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:	error array ex ['e1','e2']
 */
function _formatTooltip(){
    try{
        $('.text-overfollow').each(function(i) {
            var i = 1;
            var colorText = '';
            var element = $(this)
                .clone()
                .css({display: 'inline', width: 'auto', visibility: 'hidden'})
                .appendTo('body');

            if( element.width() <= $(this).width() ) {
                $(this).removeAttr('data-original-title');
            }
            element.remove();
        });
    }catch(e){
        alert('format tooltip '+e.message);
    }
}