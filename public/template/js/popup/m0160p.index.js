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
// $(function(){
//     initEvents();
//     initialize();
// });
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
        $(document).on('click','#btn-add-row',function(e){
          try{
            e.preventDefault();
            var row = $("#new-row tr:first").clone();
            $('#testtable tbody').append(row);
            $('#testtable').find('tbody tr:last td:first-child input').focus();
          }catch(e){
            alert('#btn-add-row' + e.message);
          }
        });
        //delete
        $(document).on('click','.btn-remove-row',function(e){
          try{
            e.preventDefault();
            var tr = $(this).closest('tr');
            tr.remove();
          } catch (e) {
                alert('.btn-remove-row' + e.message);
            }
          });
   } catch(e){

   }
}