/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/12/09
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year'       		: {'type' : 'text'      , 'attr' : 'id'},
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
 * @author      :   mirai - 2020-12-09 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function initialize() {
	try{
		tableContent();
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2020-09-08 - create
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
		$(document).on('change', '#fiscal_year', function () {
	        try {
                getRightContent($('#fiscal_year').val());
	        } catch (e) {
	            alert('fiscal_year ' + e.message);
	        }
   		});
		$(document).on('change', '.search-1', function () {
	        try {
	        	var count_select = $(this).attr('count_select');
	            $('.coach-val-'+count_select).val($(this).val());
	        } catch (e) {
	            alert('search-1' + e.message);
	        }
   		});
   		$(document).on('change', '.search-2', function () {
	        try {
	            var count_select = $(this).attr('count_select');
	            $('.member-val-'+count_select).val($(this).val());
	        } catch (e) {
	            alert('search-2 ' + e.message);
	        }
   		});
    	//save
    	$(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                    else {
                        $('.num-length').removeClass('td-error');
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
            }
	    });
	} catch(e){
		alert('initEvents: ' + e.message);	
	}
}
/**
 * get right content
 *
 * @author      :   nghianm - 2020/12/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(fiscal_year) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oq3010/rightcontent', 
            dataType    :   'html',
            // loading     :   true,
            data        :   {fiscal_year: fiscal_year},
            success: function(res) {
                $('#result').empty();
                $('#result').append(res);
				_formatTooltip();
				// $('.button-card').click();
                $('#fiscal_year').focus();
                app.jTableFixedHeader();
                jQuery.formatInput();
                tableContent();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   nghianm - 2020/12/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
		var param   = data['data_sql'];
		var array_result = [];
		// get data of sql
		$('.td-data').each(function(){
			var _this 		= 	$(this);
			var tr 			= 	_this.closest('tr');
			var data_item 	= {};
			data_item['times'] =  tr.find('.times').val();
			data_item['group_cd'] =  _this.attr('group_cd');
			data_item['questionnaire_cd'] =  _this.val();
			if(_this.hasClass('search-val-coach')){
				data_item['submit'] =  1;
			}else{
				data_item['submit'] =  2;
			}
			array_result.push(data_item);
		});
		param['list_group'] = array_result;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oq3010/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(param),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // do something
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
/**
 * tableContent
 * 
 * @author		:	nghianm - 2020/12/08 - create
 * @author		:	
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */ 
function tableContent() {
	//$('.fixed-header').tableHeadFixer();\
	$(".wmd-view-topscroll").scroll(function(){
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function(){
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function(){
		fixWidth();
	});
	function fixWidth() {
		var w = $('.wmd-view .table').outerWidth();
		$(".wmd-view-topscroll .scroll-div1").width(w);
	}
}


