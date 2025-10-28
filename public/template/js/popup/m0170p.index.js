/**
 * ****************************************************************************
 * ANS ASIA
 * 
 * 作成日		:	2017/06/27
 * 作成者		:	datnt – datnt@ans-asia.com
 *  
 * @package		:	MODULE MASTER
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */


 $(document).ready(function() {
 	try {
 		initialize();
 		initEvents();
 	} catch (e) {
 		alert('ready' + e.message);
 	}
 });

/*
 * INIT EVENTS
 */
 function initEvents()
 {
 	$(document).on('click','#btn-add-new',function () {
 		try{
 			var row = $("#table-target tbody tr:first").clone();
 			$('#table-data tbody').append(row);
            $('#table-data').find('tbody tr:last td:first-child input').focus();
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
    $(document).on('focusin','#table-data .input-sm',function(){
        _focus_index = $(this).closest('.group-body').attr('id');
    });

 }  

/**
 * initialize
 * 
 * @author		:	datnt - 2017/06/27 - create
 * @author		:	
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */ 
 function initialize(){
 	$("tr td:first input").focus();
 }
 