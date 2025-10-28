/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2021/01/05
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
	'fiscal_year': { 'type': 'text', 'attr': 'id' },
	'review_date_from': { 'type': 'text', 'attr': 'id' },
	'review_date_to': { 'type': 'text', 'attr': 'id' },
	'project_title': { 'type': 'text', 'attr': 'id' },
	'list_employee_cd': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'id' },
			'input_treatment_applications_nm': { 'type': 'text', 'attr': 'id' },
		}
	},
	'list_supporter_cd': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'id' },
			'input_treatment_applications_nm': { 'type': 'text', 'attr': 'id' },
		}
	},
	'list_rater_employee_cd': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'id' },
			'input_treatment_applications_nm': { 'type': 'text', 'attr': 'id' },
		}
	},
}
var _obj_list_search = {
	'list_importance_point': {
		'attr': 'list', 'item': {
			'importance_point': { 'type': 'text', 'attr': 'id' },
			'point': { 'type': 'numeric', 'attr': 'id' },
			'detail_no': { 'type': 'numeric', 'attr': 'id' },
			'employee_cd': { 'type': 'text', 'attr': 'id' },
			'rater_employee_comment_1': { 'type': 'text', 'attr': 'id' },
			'rater_employee_cd_1': { 'type': 'text', 'attr': 'id' },
			'authority_row_typ': { 'type': 'numeric', 'attr': 'id' },
		}
	},
}
$(function () {
	try {
		initialize();
		initEvents();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
});
/**
 * initialize
 *
 * @author    : nghianm - 2021/01/05 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
	try {
		$('.multiselect').multiselect({
			onChange: function () {
				$.uniform.update();
			}
		});
		jQuery.initTabindex();
		$(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();
		//
		$('#myTable th').css({ left: 0, top: 0 });
		tableContent();
		var redirect_flg = $('#redirect_flg').val();
		if (redirect_flg == 1) {
			var textn = $('#textAdd1').val();
			var value = $('#textAdd1').closest('.num-length').find('.employee_cd_hidden').val();
			var nametag = $('#textAdd1').closest('.num-length').find('.name_tag').val();
			if (textn.trim() != '') {
				$('#textAdd1').val('');
				$('#textAdd1').closest('.row').find('.group-add-but').append(' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px"><a href="javascript:;" class="btn btn-primary circle  ' + nametag + ' 0 zero">' +
					'<input type="hidden" class="detail_no" value=' + value + '>'
					+ '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
				//
				$('#textAdd1').closest('.row').find('#group-but-text').attr('detail_no', 2);
			}
			search(1, 20);
		}
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author    : nghianm - 2021/01/05 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
	//back
	$(document).on('click', '#btn-back', function (e) {
		try {
			var home_url = $('#home_url').attr('href');
            _backButtonFunction(home_url);
		} catch (e) {
			alert('#btn-back' + e.message);
		}
	});
	//change fiscal_year_multiview
	$(document).on('change', '#fiscal_year', function (e) {
		try {
			var fiscal_year = $(this).val();
			$('.employee_nm_mulitiselect').attr("fiscal_year_mulitiselect",fiscal_year);
		} catch (e) {
			alert('fiscal_year: ' + e.message);
		}
	});
	//save
	$(document).on('click', '#btn_search', function (e) {
		try {
			if (_validate($('body'))) {
				search(1, 20);
			}
			else {
				$('.num-length').removeClass('td-error');
			}
		} catch (e) {
			alert('btn_search: ' + e.message);
		}
	});
	// change evaluation_typ
	$(document).on('click', '.page-item', function (e) {
		try {
			e.preventDefault();
			if (_validate()) {
				//
				var page_size = $('#cb_page').val();
				var page = $(this).attr('page');
				search(page, page_size);
			}
		} catch (e) {
			alert('page-item: ' + e.message);
		}
	});
	// change evaluation_typ
	$(document).on('change', '.importance_point', function (e) {
		try {
			e.preventDefault();
			var result = $(this).val() * $(this).attr('evaluation_point') * 1.0;
			if ($('#language_jmessages').val() == 'en') {
				if (result.toString().length == 2 || result.toString().length == 1) {
					$(this).closest('tr').find('.sum_point').text(result + '.0 pts');
				} else {
					$(this).closest('tr').find('.sum_point').text(result + ' pts');
				}
				$(this).closest('tr').find('.point').val(result);
				// set all total avg 
				let point_total_avg = sumPointAVG();
				$('#sum-total').html(parseFloat(point_total_avg).toFixed(2)+' pts');
			} else {
				if (result.toString().length == 2 || result.toString().length == 1) {
					$(this).closest('tr').find('.sum_point').text(result+'.0点');
				} else {
					$(this).closest('tr').find('.sum_point').text(result+'点');
				}
				$(this).closest('tr').find('.point').val(result);
				// set all total avg 
				let point_total_avg = sumPointAVG();
				$('#sum-total').html(parseFloat(point_total_avg).toFixed(2)+'点');
			}
		} catch (e) {
			alert('importance_point: ' + e.message);
		}
	});
	// change evaluation_typ
	$(document).on('change', '#cb_page', function (e) {
		try {
			e.preventDefault();
			if (_validate()) {
				//
				var page_size = $(this).val();
				var page = 1;
				$('.page-item').each(function () {
					if ($(this).hasClass('active')) {
						page = $(this).attr('page');
					}
				});
				search(page, page_size);
			}
		} catch (e) {
			alert('cb_page: ' + e.message);
		}
	});
	//save
	$(document).on('click', '.btn-save', function (e) {
		try {
			jMessage(1, function (r) {
				saveData();
			});
		} catch (e) {
			alert('.btn-save: ' + e.message);
		}
	});
	//
	$('input[name=textAdd]').keypress(function (event) {
		var keycode = (event.keyCode ? event.keyCode : event.which);
		//
		if (keycode == '13') {
			var textn = $(this).val();
			var value = $(this).closest('.num-length').find('.employee_cd_hidden').val();
			var nametag = $(this).closest('.num-length').find('.name_tag').val();
			var count = $(this).closest('.row').find('.div-m0102 .bl102').length;
			var array = [];
			if(count == 0){
				if (textn.trim() != '') {
					$(this).val('');
					$(this).closest('.row').find('.group-add-but').append(' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px"><a href="javascript:;" class="btn btn-primary circle  ' + nametag + ' 0 zero">' +
						'<input type="hidden" class="detail_no" value=' + value + '>'
						+ '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
					//
					$(this).closest('.row').find('#group-but-text').attr('detail_no', 2);
				}
			}
			else {
				$(this).closest('.row').find('.div-m0102 .bl102').each(function () {
					array.push($(this).find('.detail_no').val());
				});
				if(array.indexOf(value) == -1) {
					if (textn.trim() != '') {
						$(this).val('');
						$(this).closest('.row').find('.group-add-but').append(' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px"><a href="javascript:;" class="btn btn-primary circle  ' + nametag + ' 0 zero">' +
							'<input type="hidden" class="detail_no" value=' + value + '>'
							+ '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
						//
						$(this).closest('.row').find('#group-but-text').attr('detail_no', 1);
					}
				}
				else {
					return;
				}
			}
		}
	});
	//
	$(document).on('blur', 'input[name=textAdd]', function () {
		var textn = $(this).val();
		var value = $(this).closest('.num-length').find('.employee_cd_hidden').val();
		var nametag = $(this).closest('.num-length').find('.name_tag').val();
		var count = $(this).closest('.row').find('.div-m0102 .bl102').length;
		var array = [];
		if(count == 0){
			if (textn.trim() != '') {
				$(this).val('');
				$(this).closest('.row').find('.group-add-but').append(' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px"><a href="javascript:;" class="btn btn-primary circle  ' + nametag + ' 0 zero">' +
					'<input type="hidden" class="detail_no" value=' + value + '>'
					+ '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
				//
				$(this).closest('.row').find('#group-but-text').attr('detail_no', 2);
			}
		}
		else {
			$(this).closest('.row').find('.div-m0102 .bl102').each(function () {
				array.push($(this).find('.detail_no').val());
			});
			if(array.indexOf(value) == -1) {
				if (textn.trim() != '') {
					$(this).val('');
					$(this).closest('.row').find('.group-add-but').append(' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px"><a href="javascript:;" class="btn btn-primary circle  ' + nametag + ' 0 zero">' +
						'<input type="hidden" class="detail_no" value=' + value + '>'
						+ '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
					//
					$(this).closest('.row').find('#group-but-text').attr('detail_no', 2);
				}
			}
			else {
				return;
			}
		}
	});
	//
	$(document).on('click', '.btn-remove-but', function () {
		$(this).parent().remove();
	});
	// //EXCEL
	$(document).on('click', '#btn-item-evaluation-input', function (e) {
		try {
			if (_validate($('.card-body'))) {
				e.preventDefault();
				var data = getData(_obj);
				var param = data['data_sql'];
				if (param['review_date_from'] == '') {
					param['review_date_from'] = null;
				}
				if (param['review_date_to'] == '') {
					param['review_date_to'] = null;
				}
				// get treatment_applications_no(処遇用途)
				var list_org = getOrganization();
				param.list_organization_step1 = list_org.list_organization_step1;
				param.list_organization_step2 = list_org.list_organization_step2;
				param.list_organization_step3 = list_org.list_organization_step3;
				param.list_organization_step4 = list_org.list_organization_step4;
				param.list_organization_step5 = list_org.list_organization_step5;
				//
				param.list_position_cd 	= list_org.list_position_cd;
				param.list_grade 		= list_org.list_grade;
				param.list_job_cd 		= list_org.list_job_cd;
				param.list_employee_typ = list_org.list_employee_typ;
				$.downloadFileAjax('/multiview/mq2000/export-excel', JSON.stringify(param));
			}
		} catch (e) {
			alert('#btn-item-evaluation-input: ' + e.message);
		}
	});
	// //EXCEL
	$(document).on('click', '#btn-item-evaluation-input-3', function (e) {
		try {
			if (_validate($('.card-body'))) {
				e.preventDefault();
				var data = getData(_obj);
				var param = data['data_sql'];
				if (param['review_date_from'] == '') {
					param['review_date_from'] = null;
				}
				if (param['review_date_to'] == '') {
					param['review_date_to'] = null;
				}
				// get treatment_applications_no(処遇用途)
				var list_org = getOrganization();
				param.list_organization_step1 = list_org.list_organization_step1;
				param.list_organization_step2 = list_org.list_organization_step2;
				param.list_organization_step3 = list_org.list_organization_step3;
				param.list_organization_step4 = list_org.list_organization_step4;
				param.list_organization_step5 = list_org.list_organization_step5;
				//
				param.list_position_cd 	= list_org.list_position_cd;
				param.list_grade 		= list_org.list_grade;
				param.list_job_cd 		= list_org.list_job_cd;
				param.list_employee_typ = list_org.list_employee_typ;
				$.downloadFileAjax('/multiview/mq2000/export-excel-avg', JSON.stringify(param));
			}
		} catch (e) {
			alert('#btn-item-evaluation-input-3: ' + e.message);
		}
	});
	// to screen レビュー入力に
	$(document).on('click', '.btn-to-review-input', function (e) {
		try {
			var employee_cd = $(this).parents('td').find('.employee_cd').val();
			var detail_no = $(this).parents('td').find('.detail_no').val();
			var data = {
					'employee_cd': employee_cd
				, 	'detail_no': detail_no
				, 	'from': 'mq2000'
				, 	'screen_id': 'mq2000_mi2000'		// save cache status
			};
			_redirectScreen('/multiview/mi2000', data, true);
		} catch (e) {
			alert('.btn-to-review-input: ' + e.message);
		}
	});
}
/**
 * sumPointAVG
 *
 * @author      :   viettd - 2021/03/17 - create
 * @author      :
 * @return      :   float
 * @access      :   public
 * @see         :
 */
function sumPointAVG(){
	try{
		var row_count = 0;
		var sub_total = 0;
		$('.list_importance_point').each(function () {
			let authority_row_typ = $(this).find('.authority_row_typ').val();
			let point = $(this).find('.point').val();
			if (authority_row_typ == 1 || authority_row_typ == 2){
				if(point != '' || typeof point != 'undefined'){
					sub_total = sub_total + Number(point);
					row_count++;
				}
			}
		});
		// check rou_count = 0 then return 0
		if(row_count == 0){
			return 0;
		}
		return (sub_total / row_count);
	}catch(e){
		alert('sumPointAVG:'+e.message);
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
function search(page, page_size) {
	try {
		var data = getData(_obj);
		var param = data['data_sql'];
		if (param['review_date_from'] == '') {
			param['review_date_from'] = null;
		}
		if (param['review_date_to'] == '') {
			param['review_date_to'] = null;
		}
		// get treatment_applications_no(処遇用途)
		var list_org = getOrganization();
		param.list_organization_step1 = list_org.list_organization_step1;
		param.list_organization_step2 = list_org.list_organization_step2;
		param.list_organization_step3 = list_org.list_organization_step3;
		param.list_organization_step4 = list_org.list_organization_step4;
		param.list_organization_step5 = list_org.list_organization_step5;
		//
		param.list_position_cd 	= list_org.list_position_cd;
		param.list_grade 		= list_org.list_grade;
		param.list_job_cd 		= list_org.list_job_cd;
		param.list_employee_typ = list_org.list_employee_typ;
		param.page_size = page_size;
		param.page = page;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/multiview/mq2000/search',
			dataType: 'html',
			loading: true,
			data: JSON.stringify(param),
			success: function (res) {
				if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
				$('#result').empty();
				$('#result').append(res);
				$('.button-card').click();
				tableContent();
				app.jSticky();
				app.jTableFixedHeader();
				jQuery.initTabindex();
				$('.rater_employee_comment_1').each(function () {
					$(this).closest("textarea").css("height", $(this).closest("tr").height() - 5)
					$(this).height($(this).prop('scrollHeight'));
				});   
			}
			}
		});
	} catch (e) {
		alert('search: ' + e.message);
	}
}

/**
 * save
 *
 * @author      :   nghianm - 2021/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var data = getData(_obj_list_search);
		$.ajax({
			type: 'POST',
			url: '/multiview/mq2000/save',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						//
						jMessage(2, function (r) {
							// do something
							// location.reload();
							var page = $('.page-item.active').attr('page');
                			var page_size = $('#cb_page').val();
							search(page, page_size);
							// search(1, 20);
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
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
		alert('save' + e.message);
	}
}
/*
 * @Author: nghianm@ans-asia.com
 *
 */
function tableContent() {
	//$('.fixed-header').tableHeadFixer();\
	$(".wmd-view-topscroll").scroll(function () {
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function () {
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function () {
		fixWidth();
	});
	function fixWidth() {
		var w = $('.wmd-view .table').outerWidth();
		$(".wmd-view-topscroll .scroll-div1").width(w);
	}
}
/**
 * getOrganization
 *
 * @author      :   nghianm - 2021/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getOrganization() {
	let param = [];
	let list = [];
	var div_organization_step1 = $("#organization_step1").closest("div");
	if (div_organization_step1.hasClass("multi-select-full")) {
		var div1 = $("#organization_step1").closest(".multi-select-full");
		div1.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step1 = list;
	list = [];
	var div_organization_step2 = $("#organization_step2").closest("div");
	if (div_organization_step2.hasClass("multi-select-full")) {
		var div2 = $("#organization_step2").closest(".multi-select-full");
		div2.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step2 = list;
	list = [];
	var div_organization_step3 = $("#organization_step3").closest("div");
	if (div_organization_step3.hasClass("multi-select-full")) {
		var div3 = $("#organization_step3").closest(".multi-select-full");
		div3.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step3 = list;
	list = [];
	var div_organization_step4 = $("#organization_step4").closest("div");
	if (div_organization_step4.hasClass("multi-select-full")) {
		var div4 = $("#organization_step4").closest(".multi-select-full");
		div4.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step4 = list;
	list = [];
	var div_organization_step5 = $("#organization_step5").closest("div");
	if (div_organization_step5.hasClass("multi-select-full")) {
		var div5 = $("#organization_step5").closest(".multi-select-full");
		div5.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step5 = list;
	list = [];
	var div7 = $('#position_cd').closest('.multi-select-full');
	div7.find('input[type=checkbox]').each(function () {
		if ($(this).prop('checked')) {
			list.push({ 'position_cd': $(this).val() });
		}
	});
	param.list_position_cd = list;
	// add by nghianm 2021/01/16
	list = [];
	var div7 = $('#grade').closest('.multi-select-full');
	div7.find('input[type=checkbox]').each(function () {
		if ($(this).prop('checked')) {
			list.push({ 'grade': $(this).val() });
		}
	});
	param.list_grade = list;
	// add by nghianm 2021/01/16
	list = [];
	var div7 = $('#job_cd').closest('.multi-select-full');
	div7.find('input[type=checkbox]').each(function () {
		if ($(this).prop('checked')) {
			list.push({ 'job_cd': $(this).val() });
		}
	});
	param.list_job_cd = list;
	// add by nghianm 2021/01/16
	list = [];
	var div7 = $('#employee_typ').closest('.multi-select-full');
	div7.find('input[type=checkbox]').each(function () {
		if ($(this).prop('checked')) {
			list.push({ 'employee_typ': $(this).val() });
		}
	});
	param.list_employee_typ = list;
	list = [];
	return param;
}
