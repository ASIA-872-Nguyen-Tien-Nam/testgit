/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2020/10/07
 * 作成者    : duongntt - duongntt@ans-asia.com
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
	'fiscal_year': { 'type': 'select', 'attr': 'id' }
	, 'combination_vertical': { 'type': 'select', 'attr': 'id' }
	, 'combination_horizontal': { 'type': 'select', 'attr': 'id' }
	, 'position_cd': { 'type': 'select', 'attr': 'id' }
	, 'job_cd': { 'type': 'select', 'attr': 'id' }
	, 'coach_nm': { 'type': 'text', 'attr': 'id' }
};

$(document).ready(function () {
	try {
		initEvents();
		initialize();
	} catch (e) {
		alert('ready' + e.message);
	}
});
function initialize() {
	try {
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
 */
function initEvents() {
	try {
		//
		$(document).on("click", "#btn-search", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
				search();
			}
		});
		//change fiscal_year 
		$(document).on('change', '#fiscal_year', function (e) {
			try {
				var fiscal_year = $(this).val();
				$('.employee_nm_1on1').attr("fiscal_year_1on1", fiscal_year);
			} catch (e) {
				alert('fiscal_year: ' + e.message);
			}
		});
		//
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
		$(document).on("click", "#btn-excel", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
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
				var div2 = $('#group_cd_1on1').closest('.multi-select-full');
				div2.find('input[type=checkbox]').each(function () {
					if ($(this).prop('checked')) {
						list.push({
							'group_cd_1on1': $(this).val()
						});
					}
				});
				data.data_sql.list_group_1on1 = list;
				//
				list = [];
				var div2 = $('#grade').closest('.multi-select-full');
				div2.find('input[type=checkbox]').each(function () {
					if ($(this).prop('checked')) {
						list.push({
							'grade': $(this).val()
						});
					}
				});
				data.data_sql.list_grade = list;
				$.downloadFileAjax('/oneonone/oq2033/export-excel', JSON.stringify(data));
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
 * SEARCH
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
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
		var div2 = $('#group_cd_1on1').closest('.multi-select-full');
		div2.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'group_cd_1on1': $(this).val()
				});
			}
		});
		data.data_sql.list_group_1on1 = list;
		//
		list = [];
		var div2 = $('#grade').closest('.multi-select-full');
		div2.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({
					'grade': $(this).val()
				});
			}
		});
		data.data_sql.list_grade = list;
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oq2033/search",
			dataType: "html",
			data: JSON.stringify(data),
			loading: true,
			success: function (res) {
				$("#result").empty();
				$("#result").append(res);
				jQuery.formatInput();
				tableContent();
				app.jTableFixedHeader();
				app.jSticky();
				// $(".button-card").trigger("click");
			},
		});
	} catch (e) {
		alert("save" + e.message);
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

/*
 * tableContent
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
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