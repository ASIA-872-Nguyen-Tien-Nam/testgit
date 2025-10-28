/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2021/05/14
 * 作成者		    :	vietdt – vietdt@ans-asia.com
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
 * @author		:	vietdt - 2021/05/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
		_formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	vietdt - 2021/05/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
   try{
	   $(document).on('click', 'li a.page-link:not(.pagging-disable)', function(e) {
            var li  = $(this).closest('li'),
			page =li.find('a').attr('page');
		   	$('.pagination li').removeClass('active');
		   	li.addClass('active');
		   	var cb_page = $('#cb_page').find('option:selected').val();
		   	var cb_page = cb_page == '' ? 1 : cb_page;
		   	search(page,cb_page);
        });
	   $(document).on('change', '#cb_page', function(e) {
		   var li  = $('.pagination li.active'),
			   page =li.find('a').attr('page');
		   var cb_page = $(this).val();
		   var cb_page = cb_page == '' ? 20 : cb_page;
		   search(page,cb_page);
	   });
   } catch(e){

   }
}
/**
 * search
 *
 * @author  :   vietdt - 2021/05/14 - create
 * @author  :
 *
 */
function search(page,page_size) {
		// send data to post
	if(typeof page =='undefined') {
		var page = 1;
	}
	if(typeof page_size =='undefined') {
		var page_size = 20;
	}
	$.ajax({
		type        :   'POST',
		url			:   '/common/popup/postSearchEmployeeComprehensiveManager',
		dataType    :   'html',
		loading     :   true,
		data: { 'page_size': page_size, 'page': page},
		success: function(res) {
			$('#result').empty();
			$('#result').html(res);
			$('[data-toggle="tooltip"]').tooltip();
			_formatTooltip();
		}
	});

}