/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/12/23
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   common template
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {};
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
* @author      :   mirai - 2020-09-08 - create
* @author      :
* @return      :   null
* @access      :   public
* @see         :   init
*/
function initialize() {
   try{
   		$('.multiselect').multiselect({
			onChange: function() {
				$.uniform.update();
			}
		});
		jQuery.initTabindex();
		$(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();
		//
		$('#myTable th').css({left:0,top:0});
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
       // search
	$(document).on('click' , '#test-dialog' , function(e){
		try{
			jMessage(9, function(r) {
			})
			return
		} catch(e){
			alert('btn-add-new: ' + e.message);
		}
	});
	
   } catch(e){
       alert('initEvents: ' + e.message);	
   }
}
/*
 * @Author: nghianm@ans-asia.com
 *
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
