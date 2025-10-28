  /**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _company_out_dt = 0;
var _sheet_cd = 0;
var _sheet_kbn = 0
var _screen = 0;
var _obj = {
	'company_out_dt'  : {'type' : 'text', 'attr' : 'id'},
	'retirement_reason_typ'  	: {'type' : 'select', 'attr' : 'id'},
	'retirement_reason'  		: {'type' : 'select', 'attr' : 'id'},
	'selected_employee_cd'  		: {'type' : 'text', 'attr' : 'id'},
	//
	'list' : {'attr' : 'list', 'item' : {
		'ck_item'     : {'type' : 'checkbox','attr' : 'class'},
		'employee_cd' : {'type' : 'text', 'attr' : 'class'},
		'employee_nm' : {'type' : 'text', 'attr' : 'class'},
		'sheet_kbn'   : {'type' : 'text', 'attr' : 'class'},
		'sheet_cd'    : {'type' : 'text', 'attr' : 'class'},
		'sheet_nm'    : {'type' : 'text', 'attr' : 'class'},
		'status_cd'   : {'type' : 'text', 'attr' : 'class'},
		'status_nm'   : {'type' : 'text', 'attr' : 'class'},
		'fiscal_year'   : {'type' : 'text', 'attr' : 'class'},
   		}
	}
};
$(function(){
	initEvents();
	initialize();
	// calcTable();
	//tableContent();
});

/**
 * initialize
 *
 * @author		:	sondh - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try{
		_company_out_dt = $('#company_out_dt').val();
	   tableScroll();
	   jQuery.formatInput();
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	sondh - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	jQuery.formatInput();

	$(document).on('click','.link_q0071',function(){
		let employee_cd = $('#selected_employee_cd').val();
		var data = {
			   'employee_cd_refer'       	:  employee_cd
			,	'from'						:	'm0070'
		};
		_redirectScreen('/master/q0071',data,true);
	});
	$(document).on('click','.link_sheet',function(){
			let employee_cd           		= $('#selected_employee_cd').val();
			let fiscal_year           		= $(this).parents('tr').find('.fiscal_year').val();
			let sheet_cd           			= $(this).parents('tr').find('.sheet_cd').val();
		let sheet_kbn = $(this).parents('td').find('.sheet_kbn').val();

		var data = {
			'fiscal_year'       :   fiscal_year
		,   'employee_cd'       :   employee_cd
		,   'sheet_cd'          :   sheet_cd
		,	'from'				:	'm0070'
		};
		if(sheet_kbn == 1){
			_redirectScreen('/master/i2010',data,true);
		}else if(sheet_kbn == 2){
			_redirectScreen('/master/i2020',data,true);
		}
	});

	// $(document).on('blur','#company_out_dt',function(){
	// 	var data ={};
	// 	var company_out_dt 	=	$('#company_out_dt').val();
	// 	data.company_out_dt = company_out_dt
	// 	data.employee_cd	=$('#selected_employee_cd').val();
	// 	if(company_out_dt != '' && company_out_dt != _company_out_dt){
	// 		$.ajax({
	// 			type        :   'POST',
	// 			dataType		:'html',
	// 			url         :   '/basicsetting/m0070/popup/refer',
	// 			loading     :   true,
	// 			data        :   data,
	// 			 success: function(res){
	// 				if(res) {
	// 					$('#data-table').empty();
	// 					$('#data-table').html(res);
	// 				}
	// 			}
	// 		});
	// 	}

	// })
//chekbox all
$(document).on('change', '#ck_all', function(){
	try {
		var checked = $(this).is(':checked');
		if ( checked ) {
			$('input.ck_item').prop('checked', true);
		}
		else {
			$('input.ck_item').prop('checked', false);
		}
	} catch(e){
		alert('#ck_all: ' + e.message);
	}
});
//checkbox
$(document).on('change', '.ck_item', function(){
	try {
		var check_length = $('input.ck_item').length;
		var checked_length = $('input.ck_item:checked').length;
		//
		if ( check_length == checked_length ) {
			$('#ck_all').prop('checked', true);
		}
		else {
			$('#ck_all').prop('checked', false);
		}
		//
		//$(this).closest('tr').find('.adjust_point').trigger('change');
	} catch(e){
		alert('#ck_item: ' + e.message);
	}
});
$(document).on('click','#btn-save-popup',function(){
	jMessage(1, function(r) {
		if ( r && _validate($('#collapseExample'))) {
		save();
		}
	});
});
$(document).on('click','#btn-cancel',function(){
	jMessage(139, function(r) {
		if ( r && _validate($('#collapseExample'))) {
		cancel();
		}
	});
});
}
function tableScroll() {
	setScroll();
	$(window).resize(function() {
		setScroll();
	});
}
function setScroll() {
	//var tableWidth = $('.dataTable').outerWidth(false);
	var tableWidth = $('#myTable').width();
	var scrll = $('.scroll');
	$('.top-scroll').css({width:$('.table-responsive').outerWidth(true)});
	scrll.css({"min-width":tableWidth+6, width: tableWidth});
	$('.table-responsive').scroll(function() {
		$('.top-scroll').scrollLeft($('.table-responsive').scrollLeft());
	});
	$('.top-scroll').scroll(function() {
		$('.table-responsive').scrollLeft($('.top-scroll').scrollLeft());
	});
}
/**
 * search
 *
 * @author      :   datnt - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function save(){
	try{
		var data    = getData(_obj);
		var company_out_dt 			= data.data_sql.company_out_dt;
		var retirement_reason_typ 	= data.data_sql.retirement_reason_typ;
		var retirement_reason 		= data.data_sql.retirement_reason;
		var retirement_reason_typ_nm=	$('#retirement_reason_typ option:selected').text();
		var param   = data['data_sql'];
		// send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/basicsetting/m0070/popup/save',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
						parent.$('#btn-retired').parents('#tab2').find('#company_out_dt').val(company_out_dt);
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason_typ').val(retirement_reason_typ);
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason_typ_nm').text(retirement_reason_typ_nm);
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason').val(retirement_reason);
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason').css("padding-left",parent.$('#btn-retired').parents('#tab2').find('#retirement_reason_typ_nm').width()+10);
						parent.$('#btn-retired').parents('#tab2').find('#tontip').attr('data-original-title', retirement_reason_typ_nm+' '+retirement_reason);
						$('#btn-close-popup').click();
                    });
                    break;
                // error
                case NG:
                if(typeof res['errors'] != 'undefined'){
                	processError(res['errors']);
                }
                break;
                case 404:
                	jMessage(27);
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
	}catch(e){
		alert('save: ' + e.message);
	}
}
/**
 * search
 *
 * @author      :   datnt - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function cancel(){
	try{
		var selected_employee_cd = $('#selected_employee_cd').val();
		var data    = getData(_obj);
		var param   = data['data_sql'];
		// send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/basicsetting/m0070/popup/cancel',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(140, function(r) {
						parent.$('#btn-retired').parents('#tab2').find('#company_out_dt').val('');
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason_typ').val('');
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason').val('');
						parent.$('#btn-retired').parents('#tab2').find('#retirement_reason_typ_nm').text('');
						if(selected_employee_cd != undefined && selected_employee_cd != ''){
							parent.$('#btn-retired').parents('.master-content').find('#'+selected_employee_cd+'').removeClass('div_left_company_out_dt');
							parent.$('#btn-retired').parents('.master-content').find('#'+selected_employee_cd+'_span').remove();
						}
						$('#btn-close-popup').click();
                    });
                    break;
                // error
                case NG:
                if(typeof res['errors'] != 'undefined'){
                	processError(res['errors']);
                }
                break;
                case 404:
                	jMessage(27);
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
	}catch(e){
		alert('save: ' + e.message);
	}
}
// redirect parent page from popup
function setCacheM0070(params,referUrl,callback){
    try {
        $.ajax({
			type        :   'POST',
			headers 	:	{'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')},
            url         :   '/common/setCache',
            dataType    :   'json',
            loading     :   false,
            data        :   {params:params},
            success : function(res) {
                if(callback){
                    callback();
				}
				// check permission of user
				if(res.status == NG){
					// jError('エラー','閲覧権限がありません。');
					jMessage(102);
				}else{
					if(referUrl!=''){
						if(_validateDomain(window.location,referUrl)){
							window.top.location.href = referUrl;
						}else{
							jError('エラー','このプロトコル又はホストドメインは拒否されました。');
						}
					}
				}
            }
        });
    } catch (e) {
        alert('setCache:' + e.message);
    }
}