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
	, 'group_cd': { 'type': 'select', 'attr': 'id' }
	, 'employee_cd': { 'type': 'text', 'attr': 'id' }
	, 'position_cd': { 'type': 'select', 'attr': 'id' }
	, 'job_cd': { 'type': 'select', 'attr': 'id' }
	, 'grade': { 'type': 'select', 'attr': 'id' }
	, 'employee_typ': { 'type': 'select', 'attr': 'id' }
	, 'coach_cd': { 'type': 'text', 'attr': 'id' }
	, 'only_admin_comments': { 'type': 'checkbox', 'attr': 'id' }
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
		$(".multiselect").multiselect({
			onChange: function () {
				$.uniform.update();
			},
		});
		var redirect_flg = $('#redirect_flg').val();
		if (redirect_flg == 1) {
			search(1, 20);
		}
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
		//show popup item_setting
		$(document).on('click', '#hide-group-x', function (e) {
			var group_cd_1on1 = $('#group_cd').val();
			var fiscal_year	= $('#fiscal_year').val();
			$('body').css('overflow', 'hidden')
			showPopup('/oneonone/oq2010/popupsetup?group_cd_1on1=' + group_cd_1on1 + '&fiscal_year='+fiscal_year, {
				width: '480px',
				height: '620px'
			}, function () { });
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
		$(document).on('click', '.dropdown dt a', function () {
			$(this).parents('.dropdown').find('ul').toggle();
		});

		//
		$(document).on('click', '.dropdown dd ul li a', function () {
			var text = $(this).html();
			$(this).parents('.dropdown').find('span').html(text);
			$(this).parents('.dropdown').find('ul').hide();
		});

		//
		$(document).bind('click', function (e) {
			var $clicked = $(e.target);
			if (!$clicked.parents().hasClass("dropdown"))
				$(".dropdown dd ul").hide();
		});

		//
		$(document).on("click", "#btn_search", function (e) {
			e.preventDefault();
			$('#redirect_flg').val(0)
			if (_validate($("body"))) {
				var page = $('.page-item.active').attr('page');
				var cb_page = $('#cb_page').val();
				var cb_page = cb_page == '' ? 20 : cb_page;
				search(page, cb_page);
			}
		});

		//
		$(document).on('click', '#radio-0', function (e) {
			$('.group_times_detail').removeClass('hidden');
			var colspan_vl = $('#colspan_group').val();
			$('#view-all-month').attr('colspan', colspan_vl);
			tableContent();
		});

		//
		$(document).on('click', '.select_group_times', function (e) {
			var num_cl_detail = $('#num_cl_detail').val();
			var times_start = $(this).parents('.group_times_select').find('.times_start').val();
			var times_end = $(this).parents('.group_times_select').find('.times_end').val();
			$('.group_times_detail').addClass('hidden');
			var i = 0;
			var j = 0;
			for (i = times_start; i <= times_end; i++) {
				$('.group_' + i).removeClass('hidden');
				j = j + 1;
			}
			var colspan_vl = j * num_cl_detail;
			$('#view-all-month').attr('colspan', colspan_vl);
			tableContent();
		});

		//
		$(document).on('click', '.hide-box-input-search', function (e) {
			var card = $('#result').closest('.card');
			var table_fixed_header = $('#result').find('.table-fixed-header');
			if ($(this).find('.fa-caret-down').length > 0) {
				card.css('min-height', '79vh');
				table_fixed_header.css('min-height', '72vh');
			} else {
				card.css('min-height', '50vh');
				table_fixed_header.css('min-height', '45vh');
			}
		});

		///* paging */
		$(document).on('click', '.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
			e.preventDefault();
			$('.page-item').removeClass('active');
			$(this).addClass('active')
			var page = $(this).attr('page');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
			search(page, cb_page);
		});

		/* paging */
		$(document).on('change', '#cb_page', function (e) {
			var li = $('.pagination li.active'),
				page = li.find('a').attr('page');
			var cb_page = $(this).val();
			var cb_page = cb_page == '' ? 20 : cb_page;
			search(page, cb_page);
		});

		// to screen oQ2020 detail
		$(document).on('click', '.employee_detail', function (e) {
			try {
				var employee_cd = $(this).attr('employee_cd');
				var fiscal_year = $('#fiscal_year').val();
				var html = getHtmlCondition($('.container-fluid'));
				var data = {
					'employee_cd': employee_cd
					, 'fiscal_year_1on1': fiscal_year
					, 'html': html
					, 'from': 'oq2010'
					, 'save_cache': 'true'		// save cache status
					, 'screen_id': 'oq2010_oq2020'		// save cache status
				};
				//
				_redirectScreen('/oneonone/oq2020', data, true);
			} catch (e) {
				alert('.employee_cd_link: ' + e.message);
			}
		});
		//btn back
		$(document).on('click', '#btn-back', function (e) {
			try {
				// 
				var home_url = $('#home_url').attr('href');
				var redirect_flg = $('#redirect_flg').val();
				if (redirect_flg == 1) {
					_backButtonFunction(home_url, true);
				} else {
					_backButtonFunction(home_url);
				}
			} catch (e) {
				alert('#btn-back' + e.message);
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
function search(page = 1, cb_page = 20) {
	try {
		var data = getData(_obj);
		data.data_sql.fullfillment_type = $("dt a span").find(".fullfillment_type").val();
		data.data_sql.page = page;
		data.data_sql.cb_page = cb_page;
		var list_org = getOrganization();
		data.data_sql.list_organization_step1 = list_org.list_organization_step1;
		data.data_sql.list_organization_step2 = list_org.list_organization_step2;
		data.data_sql.list_organization_step3 = list_org.list_organization_step3;
		data.data_sql.list_organization_step4 = list_org.list_organization_step4;
		data.data_sql.list_organization_step5 = list_org.list_organization_step5;
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oq2010/search",
			dataType: "html",
			data: JSON.stringify(data),
			loading: true,
			success: function (res) {
				$("#result").empty();
				$("#result").append(res);
				_formatTooltip();
				jQuery.formatInput();
				tableContent();
				app.jTableFixedHeader();
				app.jSticky();
				var redirect_flg = $('#redirect_flg').val();
				if (redirect_flg == 0) {
					$(".button-card").trigger("click");
				}
				//
				var redirect_times = $('#redirect_times').val();
				if ((redirect_flg == 1) && (redirect_times > 0)) {
					if (redirect_times <= 3) {
						$('#radio-1').parents('.group_times_select').find('.select_group_times').trigger("click");
					} else if (redirect_times > 3 && (redirect_times % 3 == 0)) {
						var group_times = (redirect_times / 3);
						$('#radio-' + group_times + '').parents('.group_times_select').find('.select_group_times').trigger("click");
					} else if (redirect_times > 3 && (redirect_times % 3 != 0)) {
						var group_times = Math.floor((redirect_times / 3)) + 1;
						$('#radio-' + group_times + '').parents('.group_times_select').find('.select_group_times').trigger("click");
					}
				}
			},
		});
	} catch (e) {
		alert("save" + e.message);
	}
}
/**
 * resize width table
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
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
 * get Organization
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
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
	return param;
}



