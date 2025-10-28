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

var _obj = {
	'fiscal_year'  : {'type' : 'text', 'attr' : 'id'},
	'employee_typ'  : {'type' : 'select', 'attr' : 'id'},
	'list'                 : {'attr' : 'list', 'item' : {
		'application_date'  : {'type' : 'text', 'attr' : 'class'},
		'office_cd'         : {'type' : 'text', 'attr' : 'class'},
		'belong_cd1'        : {'type' : 'text', 'attr' : 'class'},
		'belong_cd2'        : {'type' : 'text', 'attr' : 'class'},
		'position_cd'       : {'type' : 'text', 'attr' : 'class'},
		'job_cd'            : {'type' : 'text', 'attr' : 'class'},
		'employee_typ'      : {'type' : 'text', 'attr' : 'class'},
		'grade'             : {'type' : 'text', 'attr' : 'class'},    }
	},
	'row_data'         : {'attr' : 'list', 'item' : {
		'ck_item'                    	: {'type' : 'checkbox',     'attr' : 'class'},
		'employee_cd'                    : {'type' : 'text',     'attr' : 'class'},
		'valuation_step'                 : {'type' : 'text',     'attr' : 'class'},
		'treatment_applications_no_1'      : {'type' : 'text',     'attr' : 'class'},
		'point_sum1'                     : {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point1'                  : {'type' : 'text',    'attr' : 'class'},
		'rank_kinds1'                    : {'type' : 'select',  'attr' : 'class'},
		'step1_point_status'             : {'type' : 'text',  'attr' : 'class'},
		'point_sum2'                     : {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point2'                  : {'type' : 'text',    'attr' : 'class'},
		'rank_kinds2'                    : {'type' : 'select',  'attr' : 'class'},
		'step2_point_status'             : {'type' : 'text',  'attr' : 'class'},
		'point_sum3'                     : {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point3'                  : {'type' : 'text',    'attr' : 'class'},
		'rank_kinds3'                    : {'type' : 'select',  'attr' : 'class'},
		'step3_point_status'             : {'type' : 'text',  'attr' : 'class'},
		'point_sum4'                     : {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point4'                  : {'type' : 'text',    'attr' : 'class'},
		'rank_kinds4'                    : {'type' : 'select',  'attr' : 'class'},
		'step4_point_status'             : {'type' : 'text',  'attr' : 'class'},
		'point_sum5'                     : {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point5'                  : {'type' : 'text',    'attr' : 'class'},
		'rank_kinds5'                    : {'type' : 'select',  'attr' : 'class'},
		'final_point_status'             : {'type' : 'text',  'attr' : 'class'},
		'comment'                        : {'type' : 'text',    'attr' : 'class'},
		'm0050_rank'                        : {'type' : 'text',    'attr' : 'class'},
		}
	}
};
var _obj_2 = {
	'fiscal_year'  : {'type' : 'text', 'attr' : 'id'},
	'row_data'         : {'attr' : 'list', 'item' : {
		'ck_item'                    	: {'type' : 'checkbox',     'attr' : 'class'},
		'employee_cd'				: {'type' : 'text',    'attr' : 'class'},
		'employee_nm' 				: {'type' : 'text',    'attr' : 'class'},
		'employee_typ_nm'			: {'type' : 'text',    'attr' : 'class'},
		'belong1_nm'				: {'type' : 'text',    'attr' : 'class'},
		'belong2_nm'				: {'type' : 'text',    'attr' : 'class'},
		'job_nm'					: {'type' : 'text',    'attr' : 'class'},
		'position_nm'				: {'type' : 'text',    'attr' : 'class'},
		'grade_nm'					: {'type' : 'text',    'attr' : 'class'},
		'point_sum1'				: {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point1'				: {'type' : 'text',    'attr' : 'class'},
		'rank_kinds1'					: {'type' : 'select',  'attr' : 'class'},
		'point_sum2'				: {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point2'				: {'type' : 'text',    'attr' : 'class'},
		'rank_kinds2'					: {'type' : 'select',  'attr' : 'class'},
		'point_sum3'				: {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point3'				: {'type' : 'text',    'attr' : 'class'},
		'rank_kinds3'					: {'type' : 'select',  'attr' : 'class'},
		'point_sum4'				: {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point4'				: {'type' : 'text',    'attr' : 'class'},
		'rank_kinds4'					: {'type' : 'select',  'attr' : 'class'},
		'point_sum5'				: {'type' : 'numeric', 'attr' : 'class'},
		'adjust_point5'				: {'type' : 'text',    'attr' : 'class'},
		'rank_kinds5'					: {'type' : 'select',  'attr' : 'class'},
		'comment'					: {'type' : 'text',  'attr' : 'class'},
		'treatment_applications_no_1'	: {'type' : 'text',  'attr' : 'class'},
		'treatment_applications_nm'	: {'type' : 'text',  'attr' : 'class'},

		}
	}
};
var _obj3 = {
	'fiscal_year'  					: {'type' : 'text', 'attr' 	 : 'id'},
	'treat1'  						: {'type' : 'select', 'attr' : 'id'},
	'treat2'  						: {'type' : 'select', 'attr' : 'id'},
	'treat3'  						: {'type' : 'select', 'attr' : 'id'},
	'employee_typ'  				: {'type' : 'select', 'attr' : 'id'},
	'employee_cd'  					: {'type' : 'select', 'attr' : 'id'},
	'rater'  						: {'type' : 'select', 'attr' : 'id'},
	// 'evalute_step'  				: {'type' : 'select', 'attr' : 'id'}, 
	'rank'  						: {'type' : 'select', 'attr' : 'id'},
	'list': {'attr' : 'list', 'item' : {
		'application_date'  : {'type' : 'text', 'attr' : 'class'},
		'office_cd'         : {'type' : 'text', 'attr' : 'class'},
		'belong_cd1'        : {'type' : 'text', 'attr' : 'class'},
		'belong_cd2'        : {'type' : 'text', 'attr' : 'class'},
		'position_cd'       : {'type' : 'text', 'attr' : 'class'},
		'job_cd'            : {'type' : 'text', 'attr' : 'class'},
		'employee_typ'      : {'type' : 'text', 'attr' : 'class'},
		'grade'             : {'type' : 'text', 'attr' : 'class'},    }
	}
};
var _obj4 = {
    'list_character'        : {'attr' : 'list', 'item' : {
        'character_item'        : {'type' : 'text', 'attr' : 'class'},
        'item_cd'       	    : {'type' : 'text', 'attr' : 'class'},
        }
    },'list_date'           : {'attr' : 'list', 'item' : {
        'date_item'             : {'type' : 'text', 'attr' : 'class'},
        'item_cd'       	    : {'type' : 'text', 'attr' : 'class'},
        }
    },
 };
$(function(){
	initEvents();
	initialize();
	// calcTable();

	 //app.jTableFixedHeader();
	$('#myTable th').css({left:0,top:0});
	$('.multiselect').multiselect({
		onChange: function() {
			$.uniform.update();
		}
	});
	$(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();

	//cr 2022/08/05 vietdt 
	var checked = 0;
	var multi = $('#evalute_step').closest('.multi-select-full');
	multi.find('input[type=checkbox]').each(function(){
		if($(this).prop('checked')){
			checked = 1;
		}
	});
	if(checked != 0|| $('#rater').val() != ''){
	   	$('#evalute_step').addClass('required');
	   	$('#evalute_step').parents('.form-group').find('.label_evalute_step').addClass('lb-required');
	   	$('#rater_nm').addClass('required');
	   	$('#rater_nm').parents('.form-group').find('label').addClass('lb-required');
   }else{
	   	$('#evalute_step').removeClass('required');
	   	$('#evalute_step').parents('.form-group').find('.label_evalute_step').removeClass('lb-required');
	   	$('#rater_nm').removeClass('required');
	   	$('#rater_nm').parents('.form-group').find('label').removeClass('lb-required');
   }

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
		//
		// var disabledSort = Array(0);
		// for (var i=9; i<=38; i++) {
		//     disabledSort.push(i);
		// }
		// console.log(disabledSort);
		//search();
		// $('#myTable').DataTable({
		// 	paging: false,
		// 	bFilter: false,
		// 	sDom: '',
		// 	"columnDefs": [{
		// 		"targets": [0, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37],
		// 		"orderable": false
		// 	}],
		// });
	   tableScroll();
	   _formatTooltip();
	   /*$('.top-scroll .scroll').css({'min-width': '3940px'});
	   $('#myTable').css({'min-width': '3940px'});*/
	   	if($('#fiscal_year').val() != '' && $('#treatment_applications_no').val()!= undefined &&  $('#treatment_applications_no').val().length > 0 ){
			var page = $('.page-item.active').attr('page');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
		   	search(page,cb_page);
	   	}
		if($('#fiscal_year').val()>0) {
			$('#fiscal_year').trigger('change')
			$('#employee_cd').trigger('change')
		}
	   
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
	//save
	
	
	$(document).on('click' , '.btn_show_comment' , function(e){
		try{
			let tr = $(this).parents('.row_data');
			let treatment_applications_no = tr.attr('treatment_applications_no');
			let employee_cd = tr.attr('employee_cd');
			let fiscal_year = $('#fiscal_year').val();
			let valuation_step = tr.find('.valuation_step').val();
			var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if ((width >=1300)) {
					option.width 	= '70%';
					option.height 	= '45%';
				}else{

						option.width 	= '80%';
						option.height 	= '55%';

				}
			// e.preventDefault();
			showPopup('/master/i2040/comment?treatment_applications_no='+treatment_applications_no+'&employee_cd='+employee_cd+'&fiscal_year='+fiscal_year+'&valuation_step='+valuation_step,option,function(){});
		} catch(e){
			alert('btn-save: ' + e.message);
		}
	});
	$(document).on('change', '#treatment_applications_no', function(){
            try{
            	var list =[];
               var div1 = $('#treatment_applications_no').closest('.multi-select-full');
				div1.find('input[type=checkbox]').each(function(){
					if($(this).prop('checked')){
						list.push({'treatment_applications_no':$(this).val()});
					}
				});
				var fiscal_year = $('#fiscal_year').val();
				if(list.length > 0){
					getRank(fiscal_year,list);
					_clearErrors(1);
					$(this).parents('.multi-select-full').removeClass('boder-error');
				}
            }catch(e){
                alert('#treatment_applications_no: ' + e.message);
            }
        });
	//戻る
        $(document).on('click', '#btn-back', function(){
            try{
                jMessage(71, function(r) {
                    if (r) {
                        backScreen();
                    }
                });
            }catch(e){
                alert('#btn-back: ' + e.message);
            }
        });
        $(document).on('change', '#employee_nm1', function(){
            try{
               if($(this).val() == ''){
               	$('#employee_cd').val('');
               }
            }catch(e){
                alert('#btn-back: ' + e.message);
            }
        });
        $(document).on('change', '#employee_nm2', function(){
            try{
               if($(this).val() == ''){
               	$('#rater').val('');
               }
            }catch(e){
                alert('#btn-back: ' + e.message);
            }
        });
        $(document).on('change', '#evalute_step,#rater,#employee_nm2', function(){
            try{
				//cr 2022/08/05 vietdt 
				var checked = 0;
				var multi = $('#evalute_step').closest('.multi-select-full');
				multi.find('input[type=checkbox]').each(function(){
					if($(this).prop('checked')){
						checked = 1;
					}
				});
               if(checked != 0|| $('#rater').val() != ''){
               	$('#evalute_step').addClass('required');
               	$('#evalute_step').parents('.form-group').find('.label_evalute_step').addClass('lb-required');
               	$('#rater_nm').addClass('required');
               	$('#rater_nm').parents('.form-group').find('label').addClass('lb-required');
               }else{
               	$('#evalute_step').removeClass('required');
               	$('#evalute_step').parents('.form-group').find('.label_evalute_step').removeClass('lb-required');
               	$('#rater_nm').removeClass('required');
               	$('#rater_nm').parents('.form-group').find('label').removeClass('lb-required');
               }
            }catch(e){
                alert('#btn-back: ' + e.message);
            }
        });
        $(document).on('blur', '#evalute_step,#rater,#rater_nm', function(){
            try{
				//cr 2022/08/05 vietdt 
				var checked = 0;
				var multi = $('#evalute_step').closest('.multi-select-full');
				multi.find('input[type=checkbox]').each(function(){
					if($(this).prop('checked')){
						checked = 1;
					}
				});
               if(checked != 0|| $('#rater').val() != ''){
               	$('#evalute_step').addClass('required');
               	$('#evalute_step').parents('.form-group').find('.label_evalute_step').addClass('lb-required');
               	$('#rater_nm').addClass('required');
               	$('#rater_nm').parents('.form-group').find('label').addClass('lb-required');
               }else{
               	$('#evalute_step').removeClass('required');
               	$('#evalute_step').parents('.form-group').find('.label_evalute_step').removeClass('lb-required');
               	$('#rater_nm').removeClass('required');
               	$('#rater_nm').parents('.form-group').find('label').removeClass('lb-required');
               }
            }catch(e){
                alert('#btn-back: ' + e.message);
            }
        });
	// click 評価シート
	$(document).on('click','.employee_cd_link',function(e) {
		try{
			e.preventDefault();
			var employee_cd = $(this).attr('employee_cd');
			// var html 		= getHtmlCondition($('.container-fluid'));
			var data = {
                    'employee_cd'     		:   employee_cd
                // ,	'html'					: 	html
				,	'from'					:	'i2040'
				,	'save_cache'			:	'true'				// save cache status
				,	'screen_id'				:	'i2040_q0071'		// save cache status
	        };
	        //
			// setCache(data,'/master/q0071?from=i2040');
			_redirectScreen('/master/q0071',data,true);
		}catch(e){
			alert('.employee_cd_link: ' + e.message);
		}
	});
	$(document).on('click','.sheet_cd_click',function(e) {
		try{
			e.preventDefault();
			var tr = $(this).parents('tr');
			var employee_cd = tr.find('.employee_cd').val();
			var sheet_cd = $(this).find('.sheet_cd').val();
			var sheet_kbn = $(this).find('.sheet_kbn').val();
			// var html = getHtmlCondition($('.container-fluid'));
			var data = {
                    'fiscal_year'       :   $('#fiscal_year').val()
                ,   'employee_cd'       :   employee_cd
				,   'sheet_cd'          :   sheet_cd
				,	'from'				:	'i2040'
				,	'save_cache'		:	'true'		// save cache status
                // ,	'html'				: 	html
	        };
	        if(sheet_kbn == 1){
				// setCache(data,'/master/i2010?from=i2040');
				data['screen_id'] = 'i2040_i2010';	// save key -> to cache (link from q2010 to i2010)
				_redirectScreen('/master/i2010',data,true);
			}else if(sheet_kbn == 2){
				// setCache(data,'/master/i2020?from=i2040');
				data['screen_id'] = 'i2040_i2020';	// save key -> to cache (link from q2010 to i2010)
				_redirectScreen('/master/i2020',data,true);
			}

		}catch(e){
			alert('.sheet_cd_click: ' + e.message);
		}
	});
	$(document).on('change', '.adjust_point', function(e) {
		try{
			var adjust_point 		= $(this).parents('td').find('.adjust_point').val()==''?0:$(this).parents('td').find('.adjust_point').val()*1;
			var input_from 	= $(this).parents('td').find('.adjustpoint_from').val()*1;
			var input_to 	= $(this).parents('td').find('.adjustpoint_to').val()*1;
			var target_point_sum = $(this).attr('point_sum');
			var point_sum 	= $(this).parents('tr').find('.'+target_point_sum+'').val()==''?0:$(this).parents('tr').find('.'+target_point_sum+'').val()*1;
			if(adjust_point != 0 && (adjust_point < input_from || adjust_point > input_to)){
				$(this).parents('td').find('.adjust_point').val('');
			}else{
				var point_from = 0;
				var point_to = 0;
				var total = point_sum +adjust_point;
				var text = '';
				$(this).parents('tr').find('.rank_kinds option').each(function(){
					point_from = $(this).attr('point_from');
					point_to = $(this).attr('point_to');
					if((point_from == '') && point_to != ''){
						if(total < point_to){
							$(this).prop('selected',true);
						//
							text = $(this).text();
						}
					}else if(point_from != '' && (point_to == '')){
						if(total >= point_from){
							$(this).prop('selected',true);
							text = $(this).text();
						}
					}else if(point_from != '' && point_to != ''){
						if(total >= point_from && total < point_to){
							$(this).prop('selected',true);
							text = $(this).text();
						}
					}
				});
				// add by viettd 2019/10/18
				// if($(this).parents('tr').find('.rank_kinds').hasClass('hidden')){

				// 	$(this).parents('tr').find('.td_rank_nm').text(text);
				// }
				var td = $(this).closest('td').next();
				if(td.find('.rank_kinds.hidden').length > 0){
					td.find('.td_rank_nm').text(text);
				}
			}
		}catch(e){
			alert('.adjust_point'+e.message);
		}
	});
	 $(document).on('click','.page-item:not(.active):not(.disaled):not([disabled])',function(e) {
        e.preventDefault();
        $('.page-item').removeClass('active');
        $(this).addClass('active')
        var page = $(this).attr('page');
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
	$(document).on('click', '#btn-print', function(e) {
		try{
			if(_validate($('.box-input-search'))){
				exportCSV();
			}
		}catch(e){
			alert('#btn-print'+e.message);
		}
	});
	//save
	 $(document).on('click' , '#btn-save' , function(e){
		try{
		  //
 			jMessage(1, function(r) {
 				if ( r) {
 				save();
 				}
 			});
		} catch(e){
			alert('btn-save: ' + e.message);
		}
	});
	  $(document).on('change' , '#fiscal_year' , function(e){
		try{
			var fiscal_year = $(this).val();
			getRank(fiscal_year);
		} catch(e){
			alert('#fiscal_year: ' + e.message);
		}
	});
	$(document).on('click' , '#btn-confirm' , function(e){
		try{
			jMessage(150,function(r){
				if (r) {
					jMessage(61, function(e) {
						if (e){
							confirm();
						}
					});
				}
			});
		} catch(e){
			alert('btn-confirm: ' + e.message);
		}
	});
	$(document).on('click' , '#btn-decision-cancel' , function(e){
		try{
			jMessage(43, function(r) {
	 	 		if (r){
	 	 			cancel_decision();
	 	 		}
 	 		});

		} catch(e){
			alert('btn-decision-cancel: ' + e.message);
		}
	});
	$(document).on('click' , '#btn-feedback-rater' , function(e){
		try{
			jMessage(46, function(r) {
	 	 		if (r){
	 	 			feed_back('RATER');
	 	 		}
 	 		});
		} catch(e){
			alert('btn-feedback: ' + e.message);
		}
	});

	$(document).on('click' , '#btn-feedback-evaluator' , function(e){
		try{
			jMessage(48, function(r) {
	 	 		if (r){
	 	 			feed_back('EVALUATOR');
	 	 		}
 	 		});
		} catch(e){
			alert('btn-feedback: ' + e.message);
		}
	});
	 //search
	$(document).on('click' , '#btn-search' , function(e){
		try{
			e.preventDefault();
			if(_validate($('.box-input-search'))){
				var page = 1;
				var cb_page = cb_page == '' ? 20 : cb_page;
			   search(page,cb_page);
			}
		} catch(e){
			alert('btn-search: ' + e.message);
		}
	});
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
	//
	// $(document).on('change', '#select-treatment', function(){
	//     $('#action_value').html('<b>処遇用途: ' + $(this).find('option[value='+$(this).val()+']').html()+'</b>');
	// });
	//
	$(document).on('change', '.reduce_point1, .reduce_point2, .reduce_point3, .reduce_point4', function(){
		if($(this).val() == ''||$(this).val() == 0){
			$(this).closest('.row_data').find('.td_comment span .comment').removeClass('required');

		}
		if($(this).val() != '' && $(this).val() != 0){
			// console.log($(this).closest('.row_data').find('.td_comment span').html());
			$(this).closest('.row_data').find('.td_comment span .comment').addClass('required');
		}
	});

	// sort table
	// var copy_tbody = $('#mock-data1').clone();
	// var $num1 = Array();
	// copy_tbody.find('td[num="1"]').each(function() { $num1.push($(this).text()); });

	$(document).on('click', '#btn-import', function (e) {
			try{
					$('#import_file').replaceWith($('#import_file').val('').clone(true));
					$('#import_file').trigger('click');
			}catch(e){
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});

	$(document).on('change', '#import_file', function(e) {
		try{
			jMessage(6, function(r) {
				importCSV();
			});
		}catch(e){
			alert('#btn-save'+e.message);
		}
	});
	//add vietdt 2022/06/30
	$(document).on('change', '.rank_kinds', function(e) {
		try{
			var rank_kinds = $(this).val();
			$(this).parent("td").find(".order_by").val(rank_kinds);
		}catch(e){
			alert('.rank_kinds5'+e.message);
		}
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

$(document).on('click','#btn-show',function(e){
	// e.preventDefault();
	if($(this).parent('.btn-group').find('.clicked').length == 0){
		$('.hid-col').addClass('hidden');
		$(this).addClass('clicked');
		$(this).find('#btn_text').text('表示');
		$(this).find('.fa').removeClass('fa-eye-slash');
		$(this).find('.fa').addClass('fa-eye');
		$('.change-col').attr('colspan','4');
		hide_show_table('invi',0);
	}else{
		$('.hid-col').removeClass('hidden');
		$(this).removeClass('clicked');
		$(this).find('#btn_text').text('非表示');
		$(this).find('.fa').addClass('fa-eye-slash');
		$(this).find('.fa').removeClass('fa-eye');
		$('.change-col').attr('colspan','8');
		hide_show_table('invi',1);
	}
})
$(document).on('click','#btn-list-title',function(e){
	var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if ((width <= 1368 ) && (width >=1300)) {
					option.width 	= '35%';
					option.height 	= '85%';
				}else{
					if (width <= 1300) {
						option.width 	= '40%';
						option.height 	= '80%';
					}else{
						option.width 	= '480px';
						option.height 	= '620px';
					}
				}
	// e.preventDefault();
	showPopup('/master/i2040/label',option,function(){});
})
function hide_show_table(col_name,check)
{
	if(check==0)
	{
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
	}

	else
	{
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
 * @author      :   datnt - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function search(page,cb_page){
	try{
		var data    = getData(_obj3);
		data.data_sql.page = page;
		var list    = [];
		var param   = data['data_sql'];

		/*var temp = getOrganization();
		param.list_organization_step1 = temp.list_organization_step1
		param.list_organization_step2 = temp.list_organization_step2
		param.list_organization_step3 = temp.list_organization_step3
		param.list_organization_step4 = temp.list_organization_step4
		param.list_organization_step5 = temp.list_organization_step5*/
		// get treatment_applications_no(処遇用途)
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'treatment_applications_no':$(this).val()});
			}
		});
		param.list_treatment_applications_no    =   list;
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
		// position_cd
		var div7 = $('#position_cd').closest('.multi-select-full');
		div7.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'position_cd':$(this).val()});
			}
		});
		param.list_position_cd =   list;
		list = [];
		 // grade
		var div8 = $('#grade').closest('.multi-select-full');
		div8.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'grade':$(this).val()});
			}
		});
		param.list_grade =   list;
		list = [];
		var div9 = $('#evalute_step').closest('.multi-select-full');
		div9.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'evalute_step':$(this).val()});
			}
		});
		param.list_evalute_step    =   list;
		param.page     	=   page;
		param.cb_page   =   cb_page;
		param.list_character 	        = _getItems(0);
		param.list_date 		        = _getItems(1);
		param.list_number_item 	    	= _getItems(2);
		// send data to post\\
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/search',
			dataType    :   'html',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
			$('#result').empty();
			$('#result').append(res);
			// tableContent();
			_formatTooltip();
			jQuery.formatInput();
			jQuery.initTabindex();
			app.jTableFixedHeader();
			$('.top-scroll .scroll').css({'min-width': '1940px'});
			$('#myTable').css({'min-width': '1940px'});
			tableScroll();
			app.jSticky();
			unFixedWhenSmallScreen();
		 }
		});
	}catch(e){
		alert('search: ' + e.message);
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
function save(){
	try{
		var data    = getData(_obj);
		var param   = data['data_sql'];
		// send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/save',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
						var page = $('.page-item.active').attr('page');
						var cb_page = $('#cb_page').val();
						search(page, cb_page);
                    	// $('#btn-search').trigger('click');
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
function confirm(){
try{
	var data = getData(_obj);
	var page = $('.page-item.active').attr('page');
	var cb_page = $('#cb_page').val();
	var param = data['data_sql'];
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/confirm',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    // when send mail
					if (typeof res['employees'] != 'undefined' && res['employees'].length > 0) {
						var object = {};
						var employees = [];
						for (let i = 0; i < res['employees'].length; i++) {
							employees.push ({'employee_cd_rater': res['employees'][i]['employee_cd_rater'],'employee_cd': res['employees'][i]['employee_cd']});
						}
						// 
						object.rater =  employees;
						jMail(_text[62].message_nm, _text[62].message,JSON.stringify(object), 2,'', function (r) {
							if (r) {
								search(page, cb_page);
								// $('#btn-search').trigger('click');
							}
						});
					}else{
						jMessage(62, function(r) {
							search(page, cb_page);
							// $('#btn-search').trigger('click');
						});
					}
					// if (res['employee_cd'] != '') {
					// 	jMail(_text[62].message_nm, _text[62].message,res['employee_cd'], 2, function (r) {
					// 		if (r) {
					// 			$('#btn-search').trigger('click');
					// 		}
					// 	});
					// }else{
					// 	jMessage(62, function(r) {
					// 		$('#btn-search').trigger('click');
					// 	});
					// }
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
		alert('confirm: ' + e.message);
	}
}
/**
 * cancel_decision
 *
 * @author      :   datnt - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function cancel_decision(){
try{
	var data = getData(_obj);
	var param = data['data_sql'];
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/canceldecision',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(44, function(r) {
						var page = $('.page-item.active').attr('page');
						var cb_page = $('#cb_page').val();
						search(page, cb_page);
                    	// $('#btn-search').trigger('click');
                    });
                    break;
                // error
                case NG:
                if(typeof res['errors'] != 'undefined'){
                	processError(res['errors']);
                }else{
                	jMessage(45, function(r) {
                    });
                }
                break;
                case EX:
                jError(res['Exception']);
                break;
                default:
                break;
            }
        }
    	});
	}catch(e){
		alert('cancel_decision: ' + e.message);
	}
}
/**
 * cancel_decision
 *
 * @author      :   datnt - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function feed_back(mode){
try{
	var data = getData(_obj);
	data['data_sql'].mode 	=	mode;
	var param = data['data_sql'];
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/feedback',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(param),
		 success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    // RATER (一次評価者フィードバック)
                    if(mode == 'RATER'){
	                    jMessage(47, function(r) {
	                    });
	                // EVALUATOR (本人フィードバック)
					}else{
						// when send mail
						if (typeof res['employees'] != 'undefined' && res['employees'].length > 0) {
							var object = {};
							var employees = [];
							for (let i = 0; i < res['employees'].length; i++) {
								employees.push ({'employee_cd': res['employees'][i]['employee_cd']});
							}
							// 
							object.rater =  employees;
							jMail(_text[49].message_nm, _text[49].message,JSON.stringify(object), 3,'', function (r) {
								if (r) {
									// $('#btn-search').trigger('click');
								}
							});
						}else{
							// jMessage(49, function(r) {
							// 	$('#btn-search').trigger('click');
							// });
							jMessage(49);
						}
	                	// jMessage(49, function(r) {
	                    // });
	                }
                    break;
                // error
                case NG:
                 if(typeof res['errors'] != 'undefined'){
                	processError(res['errors']);
                }else{
                	jMessage(45, function(r) {
                    });
                }
                break;
                case EX:
                jError(res['Exception']);
                break;
                default:
                break;
            }
        }
    	});
	}catch(e){
		alert('feed_back: ' + e.message);
	}
}
/**
 * exportCSV
 *
 * @author      :  datnt - 2018/09/30 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */

function exportCSV() {
	try {
		var data    = getData(_obj3);
		var list    = [];
		var param   = data['data_sql'];
		/*var temp = getOrganization();
		param.list_organization_step1 = temp.list_organization_step1;
		param.list_organization_step2 = temp.list_organization_step2;
		param.list_organization_step3 = temp.list_organization_step3;
		param.list_organization_step4 = temp.list_organization_step4;
		param.list_organization_step5 = temp.list_organization_step5;*/
		// get treatment_applications_no(処遇用途)
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'treatment_applications_no':$(this).val()});
			}
		});
		param.list_treatment_applications_no    =   list;
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
		// position_cd
		var div7 = $('#position_cd').closest('.multi-select-full');
		div7.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'position_cd':$(this).val()});
			}
		});
		param.list_position_cd =   list;
		list = [];
		 // grade
		var div8 = $('#grade').closest('.multi-select-full');
		div8.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'grade':$(this).val()});
			}
		});
		param.list_grade =   list;
		list = [];
		var div9 = $('#evalute_step').closest('.multi-select-full');
		div9.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'evalute_step':$(this).val()});
			}
		});
		param.list_evalute_step    =   list;
		param.list_character 	        = _getItems(0);
		param.list_date 		        = _getItems(1);
		param.list_number_item 	    	= _getItems(2);
		var param = data['data_sql'];
		$.ajax({
			type        :   'POST',
			url         :   '/master/i2040/export',
			dataType    :   'json',
			loading     :   true,
			data        :    JSON.stringify(param),
			success: function (res) {
            switch (res['status']) {
                // success
                case OK:
                //location.reload();
                    // var returnRes       =   JSON.parse(res);
                    var filedownload    =   res['FileName'];
					var filename = '総合評価.csv';
					if ($('#language_jmessages').val() == 'en') {
						filename = 'OverallEvaluation.csv';
					}
                    if(filedownload != ''){
                        downloadfileHTML(filedownload ,filename , function () {
                            // 
                        });
                    } else{
                        jError(2);
                    }

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
		alert('exportCSV' + e.message);
	}
}

/**
 * importCSV
 *
 * @author      :  viettd - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
    try{
		var list =[];
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
			div1.find('input[type=checkbox]').each(function(){
				if($(this).prop('checked')){
					list.push({'treatment_applications_no':$(this).val()});
				}
			});
        var data = {};
        data.import_file = $('');
        //data.mode();
        var max_rate = $('#myTable').attr('maxrate');
        var final_step = $('#myTable').attr('final_step');
        var formData = new FormData();
        formData.append('file', $('#import_file')[0].files[0]);
        var fiscal_year = $('#fiscal_year').val();
        formData.append('max_rate',max_rate);
		formData.append('fiscal_year',fiscal_year);
		var param = {};
		param.list_treatment_applications_no = list;
        formData.append('list_treatment_applications_no',JSON.stringify(param));
        $.ajax({
            type        :   'POST',
            data        :   formData,
            url         :   '/master/i2040/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function(res) {
             //  var arr = JSON.parse(res);
                switch (res['status']){
                    // success
                    case 200:
                    	var arrData	=	res.data_import;
                    	// $('#myTable tbody tr').each(function(){
                    	// 	$(this).find('td:eq(25) input').attr('value','');
                    	// });
						// apply data into screen
                    	for (var i = 0; i< arrData.length; i++){
                    		employee_cd_import					= arrData[i]['employee_cd'];
                    		treatment_applications_no_import	= arrData[i]['treatment_applications_no'];
                    		$('#myTable tbody tr').each(function(){
                    			var	employee_cd 				=	$(this).attr('employee_cd');
                    			var	treatment_applications_no 	=	$(this).attr('treatment_applications_no');
								// 
                    			if((treatment_applications_no_import == treatment_applications_no) && (employee_cd_import == employee_cd)){
									$(this).find('td .point_sum1_view').text(arrData[i]['point_sum1']);
									$(this).find('td .point_sum1').attr('value',arrData[i]['point_sum1']);
									$(this).find('td .adjust_point1').attr('value',arrData[i]['adjust_point1']);
									$(this).find('td .rank_kinds1').val(arrData[i]['rank_kinds1']);
									// 
									$(this).find('td .point_sum2_view').text(arrData[i]['point_sum2']);
									$(this).find('td .point_sum2').attr('value',arrData[i]['point_sum2']);
									$(this).find('td .adjust_point2').attr('value',arrData[i]['adjust_point2']);
									$(this).find('td .rank_kinds2').val(arrData[i]['rank_kinds2']);
									// 
									$(this).find('td .point_sum3_view').text(arrData[i]['point_sum3']);
									$(this).find('td .point_sum3').attr('value',arrData[i]['point_sum3']);
									$(this).find('td .adjust_point3').attr('value',arrData[i]['adjust_point3']);
									$(this).find('td .rank_kinds3').val(arrData[i]['rank_kinds3']);
									// 
									$(this).find('td .point_sum4_view').text(arrData[i]['point_sum4']);
									$(this).find('td .point_sum4').attr('value',arrData[i]['point_sum4']);
									$(this).find('td .adjust_point4').attr('value',arrData[i]['adjust_point4']);
									$(this).find('td .rank_kinds4').val(arrData[i]['rank_kinds4']);
									// 
									$(this).find('td .m0050_rank').attr('value',arrData[i]['rank_kinds4_m0050']);
									// 
									$(this).find('td .point_sum5_view').text(arrData[i]['point_sum5']);
									$(this).find('td .point_sum5').attr('value',arrData[i]['point_sum5']);
									$(this).find('td .adjust_point5').val(arrData[i]['adjust_point5']);
									$(this).find('td .rank_kinds5').val(arrData[i]['rank_kinds5']);
                    			}
                    		});
                    	}
						// show message success
						jMessage(7,function(r){
							if(r){
								$("#import_file").val("");
							}
						});
                        break;
                    // error
                    case 201:
                        jMessage(22);
                        break;
                    case 206:
                        jMessage(27, function(r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 207:
                        jMessage(31, function(r) {
                            $("#import_file").val("");
                        });
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
        alert('importCSV: ' + e.message);
    }
}
/**
 * backScreen
 *
 * @author      :   longvv - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function backScreen(){
    try {
        var home_url = $('#home_url').attr('href');
        var screen_id = $('#screen_id').val();
        var urlObject = new URL(home_url);
        if(!_validateDomain(window.location,urlObject.pathname))
        {
			if ($('#language_jmessages').val() == 'en') {
				jError('Error','This Protocol Or Host Domain Has Been Rejected.');
			}else{
				jError('エラー','このプロトコル又はホストドメインは拒否されました。');
			}
        }else{
        	if(screen_id == 'q2010'){
	            window.location.href = '/master/q2010?from=i2040';
	        }else{
	            window.location.href = home_url;
	        }
        }
    } catch (e) {
        alert('backScreen' + e.message);
    }
}
/**
 * get rank
 *
 * @author      :   datnt - 2018/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
 function getRank(fiscal_year,list){
	 var param = {};
	param.list_treatment_applications_no    =   list;
 	$.ajax({
            type        :   'POST',
            data        :   {fiscal_year:fiscal_year,json:JSON.stringify(param)},
            url         :   '/master/i2040/getrank',
            loading: true,
            enctype: "multipart/form-data",
		  success: function (res) {
			  var redirect = 0;
             //  var arr = JSON.parse(res);
			var promise = new Promise((resolve, reject) => {
             	var html_rank = '<option value = -1></option>';
             	var html_treatment1 = '<option value = -1></option>';
             	var html_treatment2 = '<option value = -1></option>';
             	var html_treatment3 = '<option value = -1></option>';
	            res[0].forEach(function(el) {
					html_rank += '<option value = ' + el['rank_cd'] + '>' + el['rank_nm'] + '</option>'
					
				});
				res[2].forEach(function(el) {
	            	html_treatment1 += '<option value = '+el['treatment_applications_no']+'>'+el['treatment_applications_nm']+'</option>'
				});
				res[3].forEach(function(el) {
	            	html_treatment2 += '<option value = '+el['treatment_applications_no']+'>'+el['treatment_applications_nm']+'</option>'
				});
				res[4].forEach(function(el) {
	            	html_treatment3 += '<option value = '+el['treatment_applications_no']+'>'+el['treatment_applications_nm']+'</option>'
				});
				$('#rank').empty();
				$('#rank').append(html_rank);
				//
				$('#treat3').empty();
				$('#treat3').append(html_treatment1);
				//add vietdt 2022/08/19
				var text_1 = '過去評価';
				var text_2 = '年度処遇用途';

				if ($('#language_jmessages').val() == 'en') {
					text_1 = 'Past Evaluation';
					text_2 = "'"+'s Company Action';
				}
				if (fiscal_year != '-1') {
					$('#treatment_label_1').html(text_1 + '(' + (fiscal_year - 3) + text_2 + ')');
					//
					if ($('#treatment_redirect')[0]) {
					var div_treatment = $('#treatment_applications_no').closest('.multi-select-full');
						div_treatment.find('input[type=checkbox]').each(function(){
							if ($(this).val() == $('#treatment_redirect').text()) {
								redirect = 1
								$(this).trigger('click')
								$('#treatment_redirect').remove()
							}
						});
					}
					$('#treat2').empty();
					$('#treat2').append(html_treatment2);
					$('#treatment_label_2').html(text_1 + '(' + (fiscal_year - 2) + text_2 + ')');
					//
					$('#treat1').empty();
					$('#treat1').append(html_treatment3);
					$('#treatment_label_3').html(text_1 + '(' + (fiscal_year - 1) + text_2 + ')');
					
				} else {
					if ($('#language_jmessages').val() == 'en') {
						$('#treatment_label_1').html('Company Action taken 3 years earlier');
						//
						$('#treat2').empty();
						$('#treat2').append(html_treatment2);
						$('#treatment_label_2').html('Company Action taken 2 years earlier');
						//
						$('#treat1').empty();
						$('#treat1').append(html_treatment3);
						$('#treatment_label_3').html('Company Action taken last year');
					} else {
						$('#treatment_label_1').html('3年前の処遇用途');
						//
						$('#treat2').empty();
						$('#treat2').append(html_treatment2);
						$('#treatment_label_2').html('2年前の処遇用途');
						//
						$('#treat1').empty();
						$('#treat1').append(html_treatment3);
						$('#treatment_label_3').html('1年前の処遇用途');
					}
				}
				resolve(true);
			});
				promise.then(() => {
					if (redirect == 1) {
					var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
					search(page, cb_page);
					// $('#btn-search').trigger('click')
				}
			
			});
            }
        });
 }
 function getOrganization(){
    let param = [];
    let list = [];
    if($('#organization_step1').val()!=undefined){
        var str  =  $('#organization_step1 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step1   =   list;
    list = [];
    if($('#organization_step2').val()!=undefined){
        var str  =  $('#organization_step2 option:selected').val().split('|');
        if(str[0] !=0){
            list.push({
                'organization_cd_1':str[0] == undefined ? '' : str[0],
                'organization_cd_2':str[1] == undefined ? '' : str[1],
                'organization_cd_3':str[2] == undefined ? '' : str[2],
                'organization_cd_4':str[3] == undefined ? '' : str[3],
                'organization_cd_5':str[4] == undefined ? '' : str[4],
            });
        }

    }
    param.list_organization_step2   =   list;
    list = [];
    if($('#organization_step3').val()!=undefined){
        var str  =  $('#organization_step3 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step3   =   list;
    list = [];
    if($('#organization_step4').val()!=undefined){
        var str  =  $('#organization_step4 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step4   =   list;
    list = [];
    if($('#organization_step5').val()!=undefined){
        var str  =  $('#organization_step5 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step5  =   list;
    list = [];
    return param;
}
function getDataItemM0072(){
    var data = getData(_obj4);
    //
	var list_number_item = [];
	$('.list_number_item').each(function(){
		var result 		= {};
		var obj = $(this).find('.number_item');
		result.item_cd = $(this).find('.item_cd').val();
		let type = $(this).attr('item_typ');
		switch (type) {
			case 'input':
				result.number_item =	obj.val();
			break;
			case 'selectbox':
				result.number_item  = obj.val();
				if (!result.number_item ) {
					result.number_item  = -1;
				}
			break;
			case 'radiobox':
				result.number_item  = '0';
				obj.each(function(index, element){
					if($(element).is(':checked')){
						result.number_item  =$(element).val();
					}
				});
			break;
			default:
				result.number_item  = '0';
			break;
		}
		list_number_item.push(result);
	});
    data.data_sql.list_number_item 	= list_number_item;
    return JSON.stringify(data.data_sql)
}