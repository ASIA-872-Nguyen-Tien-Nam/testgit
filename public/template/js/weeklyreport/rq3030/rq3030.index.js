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
	'fiscal_year': { 'type': 'select', 'attr': 'id' }
	, 'month_from': { 'type': 'text', 'attr': 'id' }
	, 'times_from': { 'type': 'text', 'attr': 'id' }
	, 'month_to': { 'type': 'text', 'attr': 'id' }
	, 'times_to': { 'type': 'text', 'attr': 'id' }
	, 'report_kind': { 'type': 'select', 'attr': 'id' }
	, 'employee_role': { 'type': 'select', 'attr': 'id' }
	, 'approver_cd': { 'type': 'text', 'attr': 'id' }
	, 'reporter_cd': { 'type': 'text', 'attr': 'id' }
	, 'viewer_cd': { 'type': 'text', 'attr': 'id' }
	, 'position_cd': { 'type': 'select', 'attr': 'id' }
	, 'job_cd': { 'type': 'select', 'attr': 'id' }
	, 'employee_typ': { 'type': 'select', 'attr': 'id' }
};
//
$(document).ready(function () {
	try {
		_formatTooltip();
		initialize();
		initEvents();
	}
	catch (e) {
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
	try {
		$('#fiscal_year').focus();
		$(".multiselect").multiselect({
			onChange: function () {
				$.uniform.update();
			},
		});
	} catch (e) {
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
	try {
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
		// 
		$(document).on('change', '#fiscal_year', function (e) {
			try {
				var value = $(this).val();
				$('.employee_nm_weeklyreport').attr('fiscal_year_weeklyreport', value);
			} catch (e) {
				alert('.fiscal_year: ' + e.message);
			}
		});
		// search
		$(document).on('click', '#btn_search', function (e) {
			try {
				e.preventDefault();
				if (_validate()) {
					search();
				}
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		// Excel出力
		$(document).on("click", "#btn-excel", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
				excel();
			}
		});
		// 
		$(document).on('change', '#approver_employee_nm', function (e) {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($(this).val()!= old_reporter) {
					$(this).val('')
					$('#approver_cd').val('')
				}
			} catch (e) {
				alert('.fiscal_year: ' + e.message);
			}
		});
		// 
		$(document).on('change', '#reporter_employee_nm', function (e) {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($(this).val()!= old_reporter) {
					$(this).val('')
					$('#reporter_cd').val('')
				}
			} catch (e) {
				alert('.fiscal_year: ' + e.message);
			}
		});
		// 
		$(document).on('change', '#viewer_employee_nm', function (e) {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($(this).val()!= old_reporter) {
					$(this).val('')
					$('#viewer_cd').val('')
				}
			} catch (e) {
				alert('.fiscal_year: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}
/*
 * search
 * @author    : quangnd – quangnd@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function search() {
	try {
		var data = getData(_obj);
		//
		var list_org = getOrganization();
		data.data_sql.list_organization_step1 = list_org.list_organization_step1;
		data.data_sql.list_organization_step2 = list_org.list_organization_step2;
		data.data_sql.list_organization_step3 = list_org.list_organization_step3;
		data.data_sql.list_organization_step4 = list_org.list_organization_step4;
		data.data_sql.list_organization_step5 = list_org.list_organization_step5;
		//
		list = [];
		$('#group_cd').closest('.multi-select-full').find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'group_cd': $(this).val()
				});
			}
		});
		data.data_sql.list_group_cd = list;
		list = [];
		$('#grade').closest('.multi-select-full').find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'grade': $(this).val()
				});
			}
		});
		data.data_sql.list_grade = list;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rq3030/search',
			dataType: 'html',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				$('#result').empty().append(res);
				jQuery.formatInput();
				app.jTableFixedHeader();
				app.jSticky();
				// if (!$('#header_content').hasClass('hide-card-common')) {
                //     $(' .button-card').click();
                // }
			}
		});
	} catch (e) {
		alert('search: ' + e.message);
	}
}
/*
 * search
 * @author    : quangnd – quangnd@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function excel() {
	try {
		var data = getData(_obj);
		//
		var list_org = getOrganization();
		data.data_sql.list_organization_step1 = list_org.list_organization_step1;
		data.data_sql.list_organization_step2 = list_org.list_organization_step2;
		data.data_sql.list_organization_step3 = list_org.list_organization_step3;
		data.data_sql.list_organization_step4 = list_org.list_organization_step4;
		data.data_sql.list_organization_step5 = list_org.list_organization_step5;
		//
		list = [];
		$('#group_cd').closest('.multi-select-full').find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'group_cd': $(this).val()
				});
			}
		});
		data.data_sql.list_group_cd = list;
		list = [];
		$('#grade').closest('.multi-select-full').find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'grade': $(this).val()
				});
			}
		});
		data.data_sql.list_grade = list;
		$.downloadFileAjax('/weeklyreport/rq3030/export-excel', JSON.stringify(data));
	} catch (e) {
		alert('excel: ' + e.message);
	}
}
/*
 * getOrganization
 * @author    : duongntt – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
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
	return param;
}
