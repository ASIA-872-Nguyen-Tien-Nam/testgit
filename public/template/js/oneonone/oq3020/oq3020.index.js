/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   mirai – mirai@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {};
//
$( document ).ready(function() {
   try{
		_formatTooltip();
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
       	// search
		$(document).on('click','#btn_search',function(e) {
			try{
				e.preventDefault();
				if(_validate()){
					var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
					search(page,cb_page);
				}
			}catch(e){
				alert('btn_search: ' + e.message);
			}
		});
		// change evaluation_typ
		$(document).on('click','.page-item',function(e) {
			try{
				e.preventDefault();
				if(_validate()){
					//
					var page_size = $('#cb_page').val();
					var page = $(this).attr('page');
					search(page,page_size);
				}
			}catch(e){
				alert('btn_search: ' + e.message);
			}
		});
		// change evaluation_typ
		$(document).on('change','#cb_page',function(e) {
			try{
				e.preventDefault();
				if(_validate()){
					//
					var page_size 	= $(this).val();
					var page 		= 1;
					$('.page-item').each(function(){
						if($(this).hasClass('active')){
							page = $(this).attr('page');
						}
					});
					search(page,page_size);
				}
			}catch(e){
				alert('btn_search: ' + e.message);
			}
		});
		$(document).on('click','#btn-item-evaluation-input',function(e) {
			try{
				e.preventDefault();
				//
				if(_validate()){
					var data 	= getData(_obj);
					var list 	= [];
					var param   = data['data_sql'];
					// get treatment_applications_no(処遇用途)
					var div1 = $('#times').closest('.multi-select-full');
					div1.find('input[type=checkbox]').each(function(){
						if($(this).prop('checked')){
							list.push({'times':$(this).val()});
						}
					});
					param.list_times	=	list;
					list = [];
					var div_organization_step1 = $('#organization_step1').closest('div');
					if(div_organization_step1.hasClass('multi-select-full')){
						var div1 = $('#organization_step1').closest('.multi-select-full');
						div1.find('input[type=checkbox]').each(function(){
							if($(this).prop('checked')){
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
								});
							}
						});
					}
					param.list_organization_step1	=	list;
					list = [];
					var div_organization_step2 = $('#organization_step2').closest('div');
					if(div_organization_step2.hasClass('multi-select-full')){
						var div2 = $('#organization_step2').closest('.multi-select-full');
						div2.find('input[type=checkbox]').each(function(){
							if($(this).prop('checked')){
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
								});
								// list.push({'organization_cd':$(this).val()});
							}
						});
					}
					param.list_organization_step2	=	list;
					list = [];
					var div_organization_step3 = $('#organization_step3').closest('div');
					if(div_organization_step3.hasClass('multi-select-full')){
						var div3 = $('#organization_step3').closest('.multi-select-full');
						div3.find('input[type=checkbox]').each(function(){
							if($(this).prop('checked')){
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
								});
								// list.push({'organization_cd':$(this).val()});
							}
						});
					}
					param.list_organization_step3	=	list;
					list = [];
					var div_organization_step4 = $('#organization_step4').closest('div');
					if(div_organization_step4.hasClass('multi-select-full')){
						var div4 = $('#organization_step4').closest('.multi-select-full');
						div4.find('input[type=checkbox]').each(function(){
							if($(this).prop('checked')){
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
								});
								// list.push({'organization_cd':$(this).val()});
							}
						});
					}
					param.list_organization_step4	=	list;
					list = [];
					var div_organization_step5 = $('#organization_step5').closest('div');
					if(div_organization_step5.hasClass('multi-select-full')){
						var div5 = $('#organization_step5').closest('.multi-select-full');
						div5.find('input[type=checkbox]').each(function(){
							if($(this).prop('checked')){
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
								});
								// list.push({'organization_cd':$(this).val()});
							}
						});
					}
					param.list_organization_step5	=	list;
					list = [];
					param.page_size			=	20;
					param.page				=	1;
					param.fiscal_year		=	$('#fiscal_year').val();
					param.employee_role		=	$('#employee_role').val();
					param.group_cd			=	$('#group_cd').val();
					param.position_cd		=	$('#position_cd').val();
					param.grade				=	$('#grade').val();
					param.job_cd			=	$('#job_cd').val();
					param.employee_typ		=	$('#employee_typ').val();
					param.rater_employee_nm	=	$('#coach_cd').val();
					param.employee_cd		=	$('#employee_cd').val();
					param.coach_cd			=	$('#coach_cd').val();
					$.downloadFileAjax('/oneonone/oq3020/listexcel',JSON.stringify(param));
				}
			}catch(e){
				alert('#btn-List-Output: ' + e.message);
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
/**
 * search
 *
 * @author		:	nghianm - 2020/11/30 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function search(page = 1,page_size = 20){
	try{
		var data 	= getData(_obj);
		var list 	= [];
		var param   = data['data_sql'];
		// get treatment_applications_no(処遇用途)
		var div1 = $('#times').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'times':$(this).val()});
			}
		});
		param.list_times	=	list;
		list = [];
		var div_organization_step1 = $('#organization_step1').closest('div');
		if(div_organization_step1.hasClass('multi-select-full')){
			var div1 = $('#organization_step1').closest('.multi-select-full');
			div1.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		param.list_organization_step1	=	list;
		list = [];
		var div_organization_step2 = $('#organization_step2').closest('div');
		if(div_organization_step2.hasClass('multi-select-full')){
			var div2 = $('#organization_step2').closest('.multi-select-full');
			div2.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
					});
					// list.push({'organization_cd':$(this).val()});
				}
			});
		}
		param.list_organization_step2	=	list;
		list = [];
		var div_organization_step3 = $('#organization_step3').closest('div');
		if(div_organization_step3.hasClass('multi-select-full')){
			var div3 = $('#organization_step3').closest('.multi-select-full');
			div3.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
					});
					// list.push({'organization_cd':$(this).val()});
				}
			});
		}
		param.list_organization_step3	=	list;
		list = [];
		var div_organization_step4 = $('#organization_step4').closest('div');
		if(div_organization_step4.hasClass('multi-select-full')){
			var div4 = $('#organization_step4').closest('.multi-select-full');
			div4.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
					});
					// list.push({'organization_cd':$(this).val()});
				}
			});
		}
		param.list_organization_step4	=	list;
		list = [];
		var div_organization_step5 = $('#organization_step5').closest('div');
		if(div_organization_step5.hasClass('multi-select-full')){
			var div5 = $('#organization_step5').closest('.multi-select-full');
			div5.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1':str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2':str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3':str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4':str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5':str[4] == 'undefined' ? '' : str[4],
					});
					// list.push({'organization_cd':$(this).val()});
				}
			});
		}
		param.list_organization_step5	=	list;
		list = [];
		param.page_size			=	page_size;
		param.page				=	page;
		param.fiscal_year		=	$('#fiscal_year').val();
		param.employee_role		=	$('#employee_role').val();
		param.group_cd			=	$('#group_cd').val();
		param.position_cd		=	$('#position_cd').val();
		param.grade				=	$('#grade').val();
		param.job_cd			=	$('#job_cd').val();
		param.employee_typ		=	$('#employee_typ').val();
		param.rater_employee_nm	=	$('#coach_cd').val();
		param.employee_cd		=	$('#employee_cd').val();
		param.coach_cd			=	$('#coach_cd').val();
		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/oneonone/oq3020/search',
    		dataType	:	'html',
    		loading     :   true,
    		data		:	JSON.stringify(param),
		 success: function(res) {
		 	console.log('123',res)
		 	$('#result').empty();
			$('#result').append(res);
			_formatTooltip();
			$('.button-card').click();
		 	tableContent();
		 	app.jSticky();
		 	app.jTableFixedHeader();
		 	jQuery.initTabindex();
		 }
		});
	}catch(e){
		alert('search: ' + e.message);
	}
}
