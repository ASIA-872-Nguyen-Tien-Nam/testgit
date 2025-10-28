/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/10/06
 * 作成者          :   mirai – mirai@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
 	'fiscal_year'               :   {'type':'select'  ,   'attr':'id'}
,	'evaluation_step'           :   {'type':'select'  ,   'attr':'id'}
,	'employee_nm'            	:   {'type':'text'    ,   'attr':'id'}
,	'rater_employee_nm'         :   {'type':'text'    ,   'attr':'id'}
,	'employee_typ'            	:   {'type':'select'  ,   'attr':'id'}
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
 * @author      :   nghianm - 2020-10-06 - create
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
		//
		var from = getParameterByName('from',window.location);
		if(from == ''){
			$('#fiscal_year').trigger('change');
			$('#evaluation_typ').trigger('change');
		}
		_formatTooltip();
		// $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden,[disabled])').each(function(e){
		// 	$(this).attr('tabindex',13+e);
		// })
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   nghianm - 2020-10-06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
	try{
		// click 評価シート
		$(document).on('click','.sheet_cd_click',function(e) {
			try{
				e.preventDefault();
				var sheet_kbn	= $(this).attr('sheet_kbn');
				var tr 			= $(this).parents('tr');
				var employee_cd = tr.find('.employee_cd').val();
				var sheet_cd 	= $(this).attr('sheet_cd');
				var html 		= getHtmlCondition($('.container-fluid'));
				var data = {
                        'fiscal_year'       :   $('#fiscal_year').val()
                    ,   'employee_cd'       :   employee_cd
                    ,   'sheet_cd'          :   sheet_cd
                    ,	'html'				: 	html
					,   'from'         		:   'i2050'
					,	'save_cache'		:	'true'		// save cache status
		        };
		        //
		        if(sheet_kbn == 1){
					data['screen_id'] = 'i2050_i2010';	// save key -> to cache (link from i2050 to i2010)
					_redirectScreen('/master/i2010',data,true);
		        }else if(sheet_kbn == 2){
					data['screen_id'] = 'i2050_i2020';	// save key -> to cache (link from i2050 to i2020)
					_redirectScreen('/master/i2020',data,true);
		        }
			}catch(e){
				alert('.sheet_cd_click: ' + e.message);
			}
		});
		// change evaluation_typ
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
		//chekbox all
		$(document).on('change', '#ckball', function(){
			try {
				var checked = $(this).is(':checked');
				if ( checked ) {
					$('input.ck_item').prop('checked', true);
				}
				else {
					$('input.ck_item').prop('checked', false);
				}
			} catch(e){
				alert('#ckball: ' + e.message);
			}
		});
		//checkbox
		$(document).on('change', '.ck_item', function(){
			try {
				var check_length = $('input.ck_item').length;
				var checked_length = $('input.ck_item:checked').length;
				//
				if ( check_length == checked_length ) {
					$('#ckball').prop('checked', true);
				}
				else {
					$('#ckball').prop('checked', false);
				}
			} catch(e){
				alert('.ck_item: ' + e.message);
			}
		});
		// btn-back button click
		$(document).on('click','#btn-back',function(e){
			try {
				e.preventDefault();
				var home_url = $('#home_url').attr('href');
				var urlObject = new URL(home_url);
		        if(!_validateDomain(window.location,urlObject.pathname))
		        {
		            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
		        }else{
		        	window.location.href = home_url;
		        }
			} catch (e) {
				alert('#btn-back event:' + e.message);
			}
		});
		// btn-back button click
		$(document).on('click','#btn-back-status',function(e){
			try {
				e.preventDefault();
				var checked = 0;
				var list = [];
				var data = {};
				$('#myTable tbody tr').each(function(){
					var tr = $(this);
					if(tr.find('td:eq(0) input[type="checkbox"]').prop('checked')){
						checked++;
					}
				});
				//
				if(checked == 0){
					jMessage(18);
				}
				else {
					jMessage(1, function(r) {
	        			if(_validate()){
							changeStatus();
						}
    				});
				}
			} catch (e) {
				alert('#btn-back event:' + e.message);
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
 * @author		:	nghianm - 2020/10/06 - create
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
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'treatment_applications_no':$(this).val()});
			}
		});
		param.list_treatment_applications_no	=	list;
		//
		list = [];
		var div2 = $('#grade').closest('.multi-select-full');
		div2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({
					'grade':$(this).val()
				});
			}
		});
		param.list_grade	=	list;
		//
		list = [];
		var div3 = $('#position_cd').closest('.multi-select-full');
		div3.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({
					'position_cd':$(this).val()
				});
			}
		});
		param.list_position_cd	=	list;
		// add by viettd 2019/12/12
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
					// list.push({'organization_cd':$(this).val()});
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
		param.page_size		=	page_size;
		param.page			=	page;

		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/master/i2050/search',
    		dataType	:	'html',
    		loading     :   true,
    		data		:	JSON.stringify(param),
		 success: function(res) {
		 	$('#result').empty();
		 	$('#result').append(res);
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
/**
 * changestatus
 *
 * @author		:	nghianm - 2020/10/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function changeStatus(){
	var data 	= getData(_obj);
	var params 	= data['data_sql'];
    var param 	= [];
    var list 	= [];
    var sheet_cd_list = [];
    var checked = 0;
	// get treatment_applications_no(処遇用途)
	var div1 = $('#treatment_applications_no').closest('.multi-select-full');
	div1.find('input[type=checkbox]').each(function(){
		if($(this).prop('checked')){
			param.push({'treatment_applications_no':$(this).val()});
		}
	});
	params.list_treatment_applications_no	=	param;
	params.fiscal_year = $('#fiscal_year').val();
	//
	var div2 = $('#myTable tbody tr');
	div2.find('input[type=checkbox]').each(function(){
		checked = $(this).prop('checked');
		var sheet_cd_list = getSheet(this,checked);
		if(sheet_cd_list.length > 0) {
			list.push({
				'row_index':$(this).val(),
				'employee_cd':$(this).attr('employee_cd'),
				'sheet_cd_list':getSheet(this,checked),
			});
		}
	});
	params.list = list;
	// send data to post
	$.ajax({
		type		:	'POST',
		url			:	'/master/i2050/changestatus',
		dataType	:	'json',
		loading     :   true,
		data		:	JSON.stringify(params),
		success: function(res) {
		 	 switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // do something
							var page = $('.page-item.active').attr('page');
                			var page_size = $('#cb_page').val();
							search(page, page_size);
                            // search(1,20);
                            // $('#table-data tbody tr:first td:first-child input').focus();
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

}
function getSheet(el,checked){
	let sheet_cd_list 	= [];
	if(checked){
		$(el).closest('tr').find('.sheet_cd').each(function(){
				var sheer_cd = $(this).val();
				if (sheer_cd != '') {
					sheet_cd_list.push(sheer_cd);					
				}
		})
	}
	return sheet_cd_list
}