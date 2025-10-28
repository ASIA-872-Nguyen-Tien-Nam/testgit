/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/11/06
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _mode = 0;
var _obj = {
 	'group_cd'               :   {'type':'text'  ,   'attr':'id'}
,	'group_nm'            	 :   {'type':'text'  ,   'attr':'id'}
};
//
$( document ).ready(function() {
	try{
		initialize();
		initEvents();
	}
	catch(e){ 
		alert('ready' + e.message);
	}
});
/**
 * initialize
 *
 * @author      :   nghianm - 2020-11-06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function initialize() {
	try{
		$('#group_nm').focus();
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2020-11-06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
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
                alert('#btn-back' + e.message);
            }
        });
		/* paging */
	    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
            try{
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('li.page-prev: ' + e.message);
            }
	    });
	    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
            try{
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('li.page-next: ' + e.message);
            }
	    });
        $(document).on('click', '#btn-search-key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('change', '#search_key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('enterKey', '#search_key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
         /* left content click item */
	    $(document).on('click', '.list-search-child', function(e) {
            try{
                _mode = 1;
                $('.list-search-child').removeClass('active');
                $(this).addClass('active');
                getRightContent($(this).attr('id'));
            } catch(e){
                alert('list-search-child: ' + e.message);
            }
	    });
        $(document).on('click', '#btn-add-new', function(e) {
        	try{
	        	jMessage(5,function(){
	            //
	            $('#group_cd').val('');
	            $('#group_nm').val('');
                $('#table-data tbody tr').find('.list_m0040').prop('checked', false);
                $('#table-data tbody tr').find('.list_m0030').prop('checked', false);
                $('#table-data tbody tr').find('.list_m0050').prop('checked', false);
                $('#table-data tbody tr').find('.list_m0060').prop('checked', false);
	            $('.list-search-child').removeClass('active');
	            $('#group_nm').focus();
	            _mode = 0;
        	})
			} catch(e){
		        alert('btn-add-new: ' + e.message);
		        }
		    });
        $(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
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
                alert('#btn-delete: ' + e.message);
            }
        });
	} catch(e){
		alert('initEvents: ' + e.message);	
	}
}
/**
 * get left content
 *
 * @author      :   nghianm - 2020/10/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/om0300/leftcontent', 
            dataType    :   'html',
            loading     :   true,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}
/**
 * get right content
 *
 * @author      :   nghianm - 2020/10/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(group_cd) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/om0300/rightcontent', 
            dataType    :   'html',
            // loading     :   true,
            data        :   {group_cd: group_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                _formatTooltip();
                $('#group_nm').focus();
                app.jTableFixedHeader();
                jQuery.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   nghianm - 2020/10/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
		var list 	= [];
		var param   = data['data_sql'];
		// get treatment_applications_no(処遇用途)
		var div1 = $('#table-data tbody tr').find('.listm0040');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'code':$(this).val()});
			}
		});
		param.list_m0040	=	list;
        //
		list 	= [];
		var div2 = $('#table-data tbody tr').find('.listm0030');
		div2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({
					'code':$(this).val()
				});
			}
		});
		param.list_m0030	=	list;
		//
		list 	= [];
		var div3 = $('#table-data tbody tr').find('.listm0050');
		div3.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({
					'code':$(this).val()
				});
			}
		});
		param.list_m0050	=	list;
		//
		list 	= [];
		var div4 = $('#table-data tbody tr').find('.listm0060');
		div4.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({
					'code':$(this).val()
				});
			}
		});
		param.list_m0060	=	list;
		list = [];
        data.data_sql['mode'] = _mode;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/om0300/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            getRightContent('');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#group_nm').focus();
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
 * @author      :   nghianm - 2020/11/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var group_cd    = $('#group_cd').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/om0300/del',
            dataType    :   'json',
            loading     :   true,
            data        :   {group_cd: group_cd},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            getRightContent('');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#group_nm').focus();
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





