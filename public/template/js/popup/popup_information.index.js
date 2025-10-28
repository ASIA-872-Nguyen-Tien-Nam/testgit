/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
};
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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
    	$('#infomation_date_from').focus();
    	jQuery.initTabindex();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
   try{
 	document.addEventListener('keydown', function (e) {
		if (e.keyCode  === 9) {
			if (e.shiftKey) {
	               if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
	                    e.preventDefault();
	                    if($('#cb_page')[0].length!=0){
	                    	$('#cb_page')[0].focus();
	                    }	
	                    return;
	                }
	            }else{
	            		if ($(':focus')[0] === $('#cb_page')[0]) {
			                e.preventDefault();
			                $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
		                }
	            }
	        }
	    })
	   $(document).on('click', 'li a.page-link:not(.pagging-disable)', function(e) {
            var li  = $(this).closest('li'),
			page =li.find('a').attr('page');
		   	$('.pagination li').removeClass('active');
		   	li.addClass('active');
		   	var cb_page = $('#cb_page').find('option:selected').val();
		   	var cb_page = cb_page == '' ? 1 : cb_page;
		   	search(page,cb_page);
        });

	   $(document).on('click', '#btn-search', function(e) {
		   var page = 1;
		   var page_size = 20;
		   search(page,page_size);
	   });
	   $(document).on('change', '#cb_page', function(e) {
		   var li  = $('.pagination li.active'),
			   page =li.find('a').attr('page');
		   var cb_page = $(this).val();
		   var cb_page = cb_page == '' ? 20 : cb_page;
		   search(page,cb_page);
	   });
	   // btn_employee_cd_popup
        $(document).on('click','.list_infomation', function() {
            try {
                var data = {
                        'company_cd'            :   $(this).attr('company_cd')
                    ,   'category'              :   $(this).attr('category')
                    ,   'status_cd'             :   $(this).attr('status_cd')
                    ,   'infomationn_typ'       :   $(this).attr('infomationn_typ')  
                    ,   'infomation_date'       :   $(this).attr('infomation_date')  
                    ,   'target_employee_cd'    :   $(this).attr('target_employee_cd')  
                    ,   'sheet_cd'              :   $(this).attr('sheet_cd')  
                    ,   'employee_cd'           :   $(this).attr('employee_cd')    
                    ,   'fiscal_year'           :   $(this).attr('fiscal_year')    
                };
                var obj = {};
                var confirmation_datetime_flg 	= 0;
                if($('#confirmation_datetime_flg').is(':checked')){
					confirmation_datetime_flg 	= 	1;
				}
            	obj.infomation_date_from       	= $('#infomation_date_from').val();
            	obj.infomation_date_to        	= $('#infomation_date_to').val();
            	obj.infomation_title            = $('#infomation_title').val();
            	obj.confirmation_datetime_flg   = confirmation_datetime_flg;
            	obj.screen_id                	= 'searchinfomation';
            	setCache(obj, '');
                var option = {};
                option.width 	= '100%';
				option.height 	= '100%';
                showPopup("/common/popup/getinformation?"+ setGetPrams(data),option,function() {
                });
            } catch (e) {
                alert('.list_infomation' + e.message);
            }
        });
        //X
       $(document).on('click', '#btn-close-popup', function() {
            parent.$.colorbox.close();
			parent.location.reload();
			parent.$('body').css('overflow','auto');
        });
   } catch(e){

   }
}
/**
 * search
 *
 * @author  :   longvv - 2018/10/26 - create
 * @author  :
 *
 */
function search(page,page_size) {
		// send data to post
	if(validate()){
		if(typeof page =='undefined') {
			var page = 1;
		}
		if(typeof page_size =='undefined') {
			var page_size = 20;
		}
		var obj = {};
		var confirmation_datetime_flg 	=	0;
		obj.infomation_date_from 		=	$('#infomation_date_from').val();
		obj.infomation_date_to	 		=	$('#infomation_date_to').val();
		obj.infomation_title 			=	$('#infomation_title').val();
		if($('#confirmation_datetime_flg').is(':checked')){
			confirmation_datetime_flg 	= 	1;
		}
		obj.confirmation_datetime_flg 	= 	confirmation_datetime_flg;
		obj.page = page;
		obj.page_size = page_size;
		$.ajax({
			type        :   'POST',
			url         :   '/common/popup/information/search',
			dataType    :   'html',
			loading     :   true,
			data        :   {'data':obj},
			success: function(res) {
				$('#result').empty();
				$('#result').html(res);
				$('[data-toggle="tooltip"]').tooltip();
				jQuery.initTabindex();
			}
		});
	}
}
function validate() {
	try{
		_clearErrors(1);
		var	infomation_date_from 	= $('#infomation_date_from').val();
		var	infomation_date_to	 	= $('#infomation_date_to').val();
		if(infomation_date_from !='' && infomation_date_to !=''){
			date_from  	= new Date(infomation_date_from);
			date_to  	= new Date(infomation_date_to);
			if(date_from > date_to){
				var message = _text[24].message;
				$('#infomation_date_from').errorStyle(message,2);
				$('#infomation_date_to').errorStyle(message,2);
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
	}catch(e){
		alert('validate' + e.message);
	}
}