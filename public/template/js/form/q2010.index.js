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
var _obj = {
 	'fiscal_year'               :   {'type':'select'  ,   'attr':'id'}
,	'evaluation_typ'            :   {'type':'select'  ,   'attr':'id'}
,	'status_cd'            		:   {'type':'select'  ,   'attr':'id'}
,	'category_typ'            	:   {'type':'select'  ,   'attr':'id'}
,	'sheet_cd'            		:   {'type':'select'  ,   'attr':'id'}
,	'employee_cd'            	:   {'type':'text'  ,   'attr':'id'}
,	'employee_typ'            	:   {'type':'select'  ,   'attr':'id'}
,	'position_cd'            	:   {'type':'select'  ,   'attr':'id'}
,	'grade'            			:   {'type':'select'  ,   'attr':'id'}
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
 * @author      :   mirai - 2018/06/21 - create
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
		// $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden,[disabled])').each(function(e){
		// 	$(this).attr('tabindex',13+e);
		// })
		_formatTooltip();
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2018/06/21 - create
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
				var sheet_cd 	= tr.find('.sheet_cd').val();
				// var html 		= getHtmlCondition($('.container-fluid'));
				var data = {
                        'fiscal_year'       :   $('#fiscal_year').val()
                    ,   'employee_cd'       :   employee_cd
                    ,   'sheet_cd'          :   sheet_cd
					// ,	'html'				: 	html
					,   'from'         		:   'q2010'
					,	'save_cache'		:	'true'		// save cache status
		        };
		        //
		        if(sheet_kbn == 1){
					data['screen_id'] = 'q2010_i2010';	// save key -> to cache (link from q2010 to i2010)
					_redirectScreen('/master/i2010',data,true);
		        }else if(sheet_kbn == 2){
					data['screen_id'] = 'q2010_i2020';	// save key -> to cache (link from q2010 to i2020)
					_redirectScreen('/master/i2020',data,true);
		        }
			}catch(e){
				alert('.sheet_cd_click: ' + e.message);
			}
		});
		// click 社員番号
		$(document).on('click','.employee_cd_link',function(e) {
			try{
				e.preventDefault();
				var tr = $(this).parents('tr');
				var employee_cd = tr.find('td:eq(0) .employee_cd').val();
				var html 		= getHtmlCondition($('.container-fluid'));
				var data = {
                        'employee_cd'     	:   employee_cd
                    ,	'html'				: 	html
					,   'from'         		:   'q2010'
					,	'save_cache'		:	'true'		// save cache status
					,	'screen_id'			:	'q2010_q0071'		// save cache status
		        };
		        //
				_redirectScreen('/master/q0071',data,true);
			}catch(e){
				alert('.employee_cd_link: ' + e.message);
			}
		});
		// button [前評価者コピー]
		$(document).on('click','#btn-pre-evaluation-copy',function(e) {
			try{
				e.preventDefault();
				var checked = 0;
				var list = [];
				var data = {};
				$('#myTable tbody tr').each(function(){
					var tr = $(this);
					if(tr.find('td:eq(0) input[type="checkbox"]').prop('checked')){
						checked++;
						list.push({'row_index':tr.find('td:eq(1) .employee_cd_link').attr('id'),'sheet_cd':tr.find('td:eq(0) input[type="checkbox"]').val(),'employee_cd':tr.find('td:eq(0) .employee_cd').val()});
					}
				});
				//
				if(checked == 0){
					jMessage(18);
				}else{
					jMessage(1,function(r){
						if(r){
							data.fiscal_year 	=	$('#fiscal_year').val();
							data.list 			=	list;
							copyData(data);
						}
					})
				}
			}catch(e){
				alert('btn-pre-evaluation-copy : ' + e.message);
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

		// change evaluation_typ
		$(document).on('change','#evaluation_typ',function(e) {
			try{
				e.preventDefault();
				var evaluation_typ = $(this).val();
				if(evaluation_typ == 2){
					$('#category_typ').attr('disabled',false);
					//
					$('#sheet_cd').attr('disabled',false);
				}else if(evaluation_typ == 1){
					$('#category_typ').val(-1);
					$('#category_typ').attr('disabled',true);
					//
					$('#sheet_cd').val(-1);
					$('#sheet_cd').attr('disabled',true);
				}
			}catch(e){
				alert('#evaluation_typ: ' + e.message);
			}
		});
		$(document).on('click','#btn-evaluation-synthesis',function(e){
			e.preventDefault();
				var html 		= getHtmlCondition($('.container-fluid'));
				var data = {
                        'fiscal_year'       :   $('#fiscal_year').val()
                    ,	'html'				: 	html
                    ,   'screen_id'         :   'q2010'
		        };
		        //
		        setCache(data,'/master/i2040?from=q2010');
		});
		// $(document).on('click','.row_status',function(e) {
		// 	try{
		// 		e.preventDefault();
		// 		var screenID = $(this).attr('screenID');
		// 		var actionID = $(this).attr('actionID');
		// 		if(screenID == 'i2040'){
		// 			location.href = '/master/'+screenID+'?stt='+actionID;
		// 		}else{
		// 			location.href = '/master/'+screenID+'?screen='+actionID;
		// 		}
		// 	}catch(e){
		// 		alert('.row_status: ' + e.message);
		// 	}
		// });
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
		//
		$(document).on('click','#btn-List-Output',function(e) {
			try{
				e.preventDefault();
				//
				if(_validate()){
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
					list = [];
					// department_cd
					var div2 = $('#department_cd').closest('.multi-select-full');
					div2.find('input[type=checkbox]').each(function(){
						if($(this).prop('checked')){
							list.push({'department_cd':$(this).val()});
						}
					});
					param.list_department_cd	=	list;
					list = [];
					// department_cd
					var div3 = $('#team_cd').closest('.multi-select-full');
					div3.find('input[type=checkbox]').each(function(){
						if($(this).prop('checked')){
							list.push({'team_cd':$(this).val()});
						}
					});
					param.list_team_cd	=	list;
					list = [];
					param.page_size		=	20;
					param.page			=	1;
					$.downloadFileAjax('/master/q2010/listexcel',JSON.stringify(param));
				}
			}catch(e){
				alert('#btn-List-Output: ' + e.message);
			}
		});
		//
		$(document).on('click','#btn-Evaluation-Output',function(e) {
			try{
				e.preventDefault();
				var checked = 0;
				$('#myTable tbody tr .ck_item').each(function(){
					if($(this).prop('checked')){
						checked ++ ;
					}
				});
				//
				if(checked == 0){
					jMessage(18);
				}else{
					var param = {};
					var list 	= [];
					var list_treatment 	= [];
					$('#myTable tbody tr').each(function(){
						var tr = $(this);
						if(tr.find('td:eq(0) input[type="checkbox"]').prop('checked')){
							list.push({'employee_cd':tr.find('td:eq(0) .employee_cd').val(),'sheet_cd':tr.find('.sheet_cd').val()});
						}
					});
					param.list 			=	list;
					param.fiscal_year	=	$('#fiscal_year').val();
					var div1 = $('#treatment_applications_no').closest('.multi-select-full');
					div1.find('input[type=checkbox]').each(function(){
						if($(this).prop('checked')){
							list_treatment.push({'treatment_applications_no':$(this).val()});
						}
					});
					param.list_treatment_applications_no	=	list_treatment;
					$.downloadFileAjax('/master/q2010/excel',JSON.stringify(param));
				}
			}catch(e){
				alert('#btn-Evaluation-Output: ' + e.message);
			}
		});
		//
		$(document).on('click','#btn-q2010-excel',function(e) {
			try{
				e.preventDefault();
				var checked = $('#myTable tbody tr .ck_item:checked').length;
				var evaluation_typ = $('#evaluation_typ').val();

				if(checked == 0){
					jMessage(18);
				}
				else if (evaluation_typ == '2') {
					jMessage(21);
				}
				else {
					var param = {};
					var list 	= [];
					$('#myTable tbody tr').each(function(){
						var tr = $(this);
						if(tr.find('td:eq(0) input[type="checkbox"]').prop('checked')){
							list.push({'employee_cd':tr.find('td:eq(0) .employee_cd').val(),'sheet_cd':tr.find('.sheet_cd').val()});
						}
					});
					param.list 			=	list;
					param.fiscal_year	=	$('#fiscal_year').val();
					$.downloadFileAjax('/master/q2010/excel3',JSON.stringify(param));
				}
			}catch(e){
				alert('#btn-q2010-excel: ' + e.message);
			}
		});
		//
		// $(document).on('click','.table th',function(){
		// 	$('.table th span .sort').removeClass('fa-sort-down');
		// 	$('.table th span .sort').removeClass('fa-sort-up');
		// 	// $('.table th span .sort').removeClass('sorted');
		// 	$('.table th span .sort').addClass('fa-sort');
		// 	if($(this).find('.sorted').length == 0){
		// 		$('.table th span .sort').removeClass('sorted');
		// 		$(this).find('.sort').removeClass('fa-sort');
		// 		$(this).find('.sort').addClass('fa-sort-down');
		// 		$(this).find('.sort').addClass('sorted');
		// 		sort(this);
		// 	}else{
		// 		$(this).find('.sort').removeClass('fa-sort-down');
		// 		$(this).find('.sort').addClass('fa-sort-up');
		// 		$(this).find('.sort').removeClass('sorted');
		// 		reverse($(this));
		// 	}
		// });
		//
		$(document).on('click','#btn-show',function(e){
			// e.preventDefault();
			var text_display = $('.display_attr').val();
			var text_hide    = $('.hide_attr').val();
			if($(this).parent('.btn-group').find('.clicked').length == 0){
				$('.hid-col').addClass('hidden');
				$(this).addClass('clicked');
				// $(this).find('#btn_text').text('属性情報表示');
				$(this).find('#btn_text').text(text_display);
				$(this).find('.fa').removeClass('fa-eye-slash');
				$(this).find('.fa').addClass('fa-eye');
				hide_show_table('invi',0);
			}else{
				$('.hid-col').removeClass('hidden');
				$(this).removeClass('clicked');
				// $(this).find('#btn_text').text('属性情報非表示');
				$(this).find('#btn_text').text(text_hide);
				$(this).find('.fa').addClass('fa-eye-slash');
				$(this).find('.fa').removeClass('fa-eye');
				hide_show_table('invi',1);
			}
			tableContent();
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
	} catch(e){
		alert('initEvents: ' + e.message);
	}
}
/*
 * @Author: tannq@ans-asia.com
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
 * hide_show_table
 *
 * @author		:	viettd - 2018/09/17 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function hide_show_table(col_name,check){
	if(check==0){
		var all_col=document.getElementsByClassName(col_name);
		var all_th=document.getElementsByClassName(col_name+"_head");
		for(var i=0;i<all_col.length ;i++)
		{
			all_col[i].style.display="none";
		}
		for(var i=0;i<all_th.length ;i++)
		{
			all_th[i].style.display="none";
		}
		document.getElementsByClassName(col_name).value="show";
	}else{
		var all_col=document.getElementsByClassName(col_name);
		var all_th=document.getElementsByClassName(col_name+"_head");
		for(var i=0;i<all_col.length;i++)
		{
			all_col[i].style.display="table-cell";
		}
		for(var i=0;i<all_th.length ;i++)
		{
			all_th[i].style.display="table-cell";
		}
		document.getElementsByClassName(col_name).value="hide";
	}
}
/**
 * search
 *
 * @author		:	viettd - 2018/09/17 - create
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
    		url			:	'/master/q2010/search',
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
			 unFixedWhenSmallScreen();
		 }
		});
	}catch(e){
		alert('search: ' + e.message);
	}
}
/**
 * copyData(data)
 *
 * @author		:	viettd - 2018/10/09 - create
 * @param		:	copy
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function copyData(data){
	try {
		//send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/master/q2010/copy',
    		dataType	:	'json',
    		loading		: 	true,
    		data		:	data,
		 success: function(res) {
			switch (res['status']){
				// seccess
				case OK:
					jMessage(2,function(){
						var page = $('.page-item.active').attr('page');
                		var page_size = $('#cb_page').val();
						search(page, page_size);
						// $('#btn_search').trigger('click');
					});
				break;
				// error
				case NG:
					if(typeof res['errors'] != 'undefined'){
						//
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
		alert('copyData' + e.message);
	}
}


