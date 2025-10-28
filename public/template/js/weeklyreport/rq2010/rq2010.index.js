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
	'year_month_from': { 'type': 'select', 'attr': 'id' }
	, 'year_month_to': { 'type': 'select', 'attr': 'id' }
	, 'report_kind': { 'type': 'select', 'attr': 'id' }
	, 'group': { 'type': 'select', 'attr': 'id' }
	, 'my_group': { 'type': 'select', 'attr': 'id' }
	, 'status': { 'type': 'select', 'attr': 'id' }
	, 'note_kind': { 'type': 'text', 'attr': 'id' }
	, 'free_word': { 'type': 'select', 'attr': 'id' }
	, 'adequacy': { 'type': 'select', 'attr': 'id' }
	, 'busyness': { 'type': 'select', 'attr': 'id' }
	, 'position': { 'type': 'select', 'attr': 'id' }
	, 'job': { 'type': 'select', 'attr': 'id' }
	, 'grade': { 'type': 'select', 'attr': 'id' }
	, 'employee_typ': { 'type': 'select', 'attr': 'id' }
	, 'approver_cd': { 'type': 'text', 'attr': 'id' }
	, 'reporter_cd': { 'type': 'text', 'attr': 'id' }
};
var _obj_del = {
	'tr_del_value': {
		'attr': 'list', 'item': {
			'company_cd': { 'type': 'text', 'attr': 'class' },
			'fiscal_year': { 'type': 'text', 'attr': 'class' },
			'report_kind': { 'type': 'text', 'attr': 'class' },
			'report_no': { 'type': 'text', 'attr': 'class' },
			'employee_cd': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _mode = 0;
//
$(document).ready(function () {
	try {
		if ($(".fa-eye")[0]) {
			_mode = 1
		} else {
			_mode = 0
		}
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
		$(".dropdown dd ul").hide();
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
		//change fiscal_year
		$(document).on('click', '#btn-item-evaluation-input', function (e) {
			try {
				if (_validate()) {
					e.preventDefault();
					var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
					var param = getRq2010Param(page, cb_page);
					// send data to post
					$.ajax({
						type: 'POST',
						url: '/weeklyreport/rq2010/exportCSV',
						dataType: 'json',
						loading: true,
						// data        :    {'data':obj},
						data: JSON.stringify(param),
						success: function (res) {
							// success
							switch (res['status']) {
								case OK:
									var filedownload = res['FileName'];
									var filename = '週報一覧.csv';
									if ($('#language_jmessages').val() == 'en') {
										filename = 'ListOfReports.csv';
									}
									if (filedownload != '') {
										downloadfileHTML(filedownload, filename, function () {
											//
										});
									} else {
										jError(2);
									}
									break;
								case NG:
									jMessage(21);
									break;
								case EX:
									jMessage(22);
									break;
								default:
									break;
							}
						}
					});
				}
			} catch (e) {
				alert('fiscal_year: ' + e.message);
			}
		});
		//
		$(document).on('blur', '#employee_nm', function () {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($('#employee_nm').val()!= old_reporter) {
					$('#approver_cd').val('');
					$(this).val('')
				}
			} catch (e) {
				alert('.employee_nm' + e.message);
			}
		});
		$(document).on('click', '.dropdown dt a', function () {
			$(this).parents('.dropdown').find('ul').toggle();
		});

		//
		$(document).on('click', '.dropdown dd ul li a', function () {
			var text = $(this).html();
			
			$(this).parents('.dropdown').find('span').html(text);
			$(this).parents('.dropdown').find('ul').hide();
			$(this).parents('.dropdown').find('.img-selected img').css('height', '28px')
			$(this).parents('.dropdown').find('.img-selected img').css('width', '40px')
			$(this).parents('.dropdown').find('.img-selected img').css('margin-left', '25px')
			if ($('.img_selected_adequacy').attr('src') == '') {
				$('.img_selected_adequacy').removeAttr('src')
			}
		});

		//
		$(document).bind('click', function (e) {
			var $clicked = $(e.target);
			if (!$clicked.parents().hasClass("dropdown"))
				$(".dropdown dd ul").hide();
		});
		$(document).on('click', '.link_ri2010', function (e) {
			try {
				e.preventDefault();
				var fiscal_year = $(this).attr('fiscal_year');
				var employee_cd = $(this).attr('employee_cd');
				var report_kind = $(this).attr('report_kind');
				var report_no = $(this).attr('report_no');
				var data = {
					'fiscal_year_weeklyreport': fiscal_year
					, 'employee_cd': employee_cd
					, 'report_kind': report_kind
					, 'report_no': report_no
					, 'from': 'rq2010'
				};
				data['screen_id'] = 'rq2010_ri2010';	// save key -> to cache
				_redirectScreen('/weeklyreport/ri2010', data, true);
			} catch (e) {
				alert('.link_ri2010: ' + e.message);
			}
		});
		$(document).on('click', '.link_rq2020', function (e) {
			try {
				e.preventDefault();
				var fiscal_year = $(this).attr('fiscal_year');
				var report_kind = $(this).attr('report_kind');
				var time_from = $('#year_month_from').val();
				var time_to = $('#year_month_to').val();
				var employee_cd = $(this).attr('employee_cd');
				var employee_nm = $(this).attr('employee_nm');
				var data = {
					'fiscal_year_weeklyreport': fiscal_year
					, 'report_kind': report_kind
					, 'year_month_from': time_from
					, 'year_month_to': time_to
					, 'employee_cd': employee_cd
					, 'employee_nm': employee_nm
					, 'from': 'rq2010'
				};
				data['screen_id'] = 'rq2010_rq2020';	// save key -> to cache
				_redirectScreen('/weeklyreport/rq2020', data, true);
			} catch (e) {
				alert('.link_rq2020: ' + e.message);
			}
		});

		//
		$(document).on("click", "#search_company", function (e) {
			if (_validate()) {
				e.preventDefault();
				var page = $('.page-item.active').attr('page');
				var cb_page = $('#cb_page').val();
				var param = getRq2010Param(page, cb_page);
				// send data to post'
				$.ajax({
					type: 'POST',
					url: '/weeklyreport/rq2010/search',
					dataType: 'html',
					loading: true,
					data: JSON.stringify(param),
					success: function (res) {
						$('#result').empty();
						$('#result').append(res);
						// tableContent();
						app.jSticky();
						app.jTableFixedHeader();
						jQuery.initTabindex();
						unFixedWhenSmallScreen();
						// 
						// $('.button-card').trigger('click');
					}
				});
			}

		});
		$(document).on('click', '.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
			try {
				if (_validate()) {
					e.preventDefault();
					$('.page-item').removeClass('active');
					$(this).addClass('active')
					var page = $(this).attr('page');
					var cb_page = $('#cb_page').find('option:selected').val();
					var param = getRq2010Param(page, cb_page);
					// send data to post'
					$.ajax({
						type: 'POST',
						url: '/weeklyreport/rq2010/search',
						dataType: 'html',
						loading: true,
						data: JSON.stringify(param),
						success: function (res) {
							$('#result').empty();
							$('#result').append(res);
							// tableContent();
							app.jSticky();
							app.jTableFixedHeader();
							jQuery.initTabindex();
							unFixedWhenSmallScreen();
							// 
							// $('.fa-chevron-down').trigger('click');
							if (_mode == 1) {
								$('#btn-show').trigger('click');
							}
							if (!$(".fa-chevron-down")[0]) {
								$('#table_employee').css('height','600px')
							}
						}
					});
				}
			} catch (e) {
				alert('page_item ' + e.message);
			}
		});
		$(document).on('change', '#cb_page', function (e) {
			try {
				if (_validate()) {
					e.preventDefault();
					var li = $('.pagination li.active'),
						page = li.find('a').attr('page');
					var cb_page = $(this).val();
					var cb_page = cb_page == '' ? 20 : cb_page;
					var param = getRq2010Param(page, cb_page);
					// send data to post'
					$.ajax({
						type: 'POST',
						url: '/weeklyreport/rq2010/search',
						dataType: 'html',
						loading: true,
						data: JSON.stringify(param),
						success: function (res) {
							$('#result').empty();
							$('#result').append(res);
							// tableContent();
							app.jSticky();
							app.jTableFixedHeader();
							jQuery.initTabindex();
							unFixedWhenSmallScreen();
							// 
							// $('.fa-chevron-down').trigger('click');
							if (_mode == 1) {
								$('#btn-show').trigger('click');
							}
							if (!$(".fa-chevron-down")[0]) {
								$('#table_employee').css('height','600px')
							}
						}
					});
				}
			} catch (e) {
				alert('page_item ' + e.message);
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
		// $(document).on('click', '.employee_detail', function (e) {
		//     try {
		// 		alert('áhsdhs');
		//         var data = '';
		// 		// _redirectScreen('/weeklyreport/rI2010',data, true);
		//        // window.location.href = '/weeklyreport/rI2010';
		//         window.open("/weeklyreport/ri2010", '_blank');
		// 	} catch (e) {
		// 		alert('.employee_cd_link: ' + e.message);
		// 	}
		// });
		$(document).on('click', '.title_td', function (e) {
			try {
				var data = '';
				// _redirectScreen('/weeklyreport/rI2010',data, true);
				// window.location.href = '/weeklyreport/rI2010';
				window.open("/weeklyreport/ri2010", '_blank');
			} catch (e) {
				alert('.employee_cd_link: ' + e.message);
			}
		});
		$(document).on('click', '#btn-new-group', function (e) {
			try {
				var data = '';
				// _redirectScreen('/weeklyreport/rI2010',data, true);
				// window.location.href = '/weeklyreport/rI2010';
				window.location.replace("/weeklyreport/rq2011");
			} catch (e) {
				alert('.employee_cd_link: ' + e.message);
			}
		});
		$(document).on('click', '.button-card', function () {
			if ($(this).find('i').hasClass('fa-chevron-right')) {
				$('#table_employee').css('height', '600px')
			}
			else {
				$('#table_employee').css('height', '300px')
			}

		});
		$(document).on('blur', '#year_month_to', function () {
			if ($('#year_month_to').val() != '' && $('#year_month_from').val() != '') {
				var from = parseInt($('#year_month_from').val().replace("/", ""));
				var to = parseInt($('#year_month_to').val().replace("/", ""));
				if (from > to) {
					$('#year_month_to').val('')
				} 

			}
			if ($('#year_month_to').val() != '') {
				var yearmonth = $('#year_month_to').val().replace("/", "")
				var year        = yearmonth.substring(0,4);
				var month = yearmonth.substring(4, 6);
				yearmonth = new Date(year, month, 0).toLocaleDateString('fr-CA');
				$.ajax({
					type: 'POST',
					url: '/weeklyreport/rq2010/getFiscalYear',
					dataType: 'html',
					// data        :    {'data':obj},
					data: { 'date_from': yearmonth, },
					loading: true,
					success: function (res) {
						// success
						$('#employee_nm').attr('fiscal_year_weeklyreport',res.replace('"', '').replace('"', ''))
						$('#reporter_nm').attr('fiscal_year_weeklyreport',res.replace('"', '').replace('"', ''))
					}
				});
			}

		});
		$(document).on('blur', '#year_month_from', function () {
			if ($('#year_month_to').val() != '' && $('#year_month_from').val() != '') {
				var from = parseInt($('#year_month_from').val().replace("/", ""));
				var to = parseInt($('#year_month_to').val().replace("/", ""));
				if (from > to) {
					$('#year_month_from').val('')
				}
			}

		});
		$(document).on("click", "#btn-delete", function (e) {
			try {
				$(".chk-item:checked").closest('tr').addClass('tr_del_value')
				data = getData(_obj_del);
				countChecked = $(".chk-item:checked").length;

				if (countChecked >= 1) {
					jMessage(3, function (r) {
						if (r) {
							$('.div_loading').show();
							$.post('/weeklyreport/rq2010/delete', JSON.stringify(data))
								.then(res => {
									$('.div_loading').css('display', 'none');
									switch (res['status']) {
										// success
										case OK:
											jMessage(4, function (r) {
												$(".chk-item:checked").closest('tr').remove()
											});
										case NG:
											

											break;
										// Exception
										case EX:
											jError(res['Exception']);
											break;
										default:
											break;
									}
								})
						}
					});
				} else {
					jMessage(18, function (r) {
					});
				}
			}
			catch (e) {
				alert("#btn-delete :" + e.message);
			}
		});
		
		$(document).on("click", "#btn-show", function (e) {

			// e.preventDefault();
			if ($(this).parent(".btn-group").find(".clicked").length == 0) {
				_mode = 1;
				// $(".hid-col").addClass("hidden");
				$(this).addClass("clicked");

				$(this).find(".fa").removeClass("fa-eye-slash");
				$(this).find(".fa").addClass("fa-eye");
				$(this).find("#btn_text").text($('.display_attr').attr('value'));
				$('.el_show').css('display', 'none');
				$('#tbl-data').css('min-width', '100%');


			} else {
				_mode = 0;
				// $(".hid-col").removeClass("hidden");
				$(this).removeClass("clicked");

				$(this).find(".fa").addClass("fa-eye-slash");
				$(this).find(".fa").removeClass("fa-eye");
				$('.el_show').css('display', '');

				$(this).find("#btn_text").text($('.hide_attr').attr('value'));
				$('#tbl-data').css('min-width', '180%');
			}
		});
		$(window).click(function (e) {
			$('[data-toggle=popover]').each(function () {
				if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
					$(this).popover('hide');
				}
			});
		})
		$(function () {
			$('[data-toggle="popover"]').popover()
		})
	} catch (e) {
		alert('initEvents: ' + e.message);
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


function getParam() {
	try {
		// send data to post
		var param = {};
		var list = [];
		param.year_month_from = $('#year_month_from').val()
		param.year_month_to = $('#year_month_to').val()
		param.report_kinds = $('#report_kinds').val()
		param.group_cd = $('#group_cd').val()
		param.mygroup_cd = $('#mygroup_cd').val()
		param.status_cd = $('#status_cd').val()
		param.note_kind = $('#note_kind').val()
		param.key_search = $('#key_search').val()
		param.adequacy_kbn = $('#adequacy_kbn').val()
		param.busyness_kbn = $('#busyness_kbn').val()
		param.other_kbn = $('#other_kbn').val()
		if ($('#is_shared').is(":checked")) {
			param.is_shared = 1
		} else {
			param.is_shared = 0
		}
		param.position_cd = $('#position_cd').val()
		param.job_cd = $('#job_cd').val()
		param.grade = $('#grade').val()
		param.employee_typ = $('#employee_typ').val()
		param.approver_cd = $('#approver_cd').val()

		//
		if ($('#organization_step1 option').length > 0) {
			if ($('#organization_step1').val() != '') {
				var str = $('#organization_step1').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step1 = list;
		list = [];
		if ($('#organization_step2 option').length > 0) {
			if ($('#organization_step2').val() != '') {
				var str = $('#organization_step2').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step2 = list;
		list = [];
		if ($('#organization_step3 option').length > 0) {
			if ($('#organization_step3').val() != '') {
				var str = $('#organization_step3').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step3 = list;
		list = [];
		if ($('#organization_step4 option').length > 0) {
			if ($('#organization_step4').val() != '') {
				var str = $('#organization_step4').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step4 = list;
		list = [];
		if ($('#organization_step5 option').length > 0) {
			if ($('#organization_step5').val() != '') {
				var str = $('#organization_step5').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step5 = list;
		//
		return param;
	} catch (e) {
		alert('getParam error : ' + e.message);
	}
}
function getRq2010Param(page = 1, page_size = 20) {
	try {
		var data = getData(_obj);
		data.data_sql.adequacy = $("dt a span").find(".adequacy").val();
		data.data_sql.busyness = $("dt a span").find(".busyness").val();
		data.data_sql.other = $("dt a span").find(".other").val();
		data.data_sql.fiscal_year = $("#employee_nm").attr('fiscal_year_weeklyreport');
		if ($('#is_shared').is(":checked")) {
			data.data_sql.is_shared = 1
		} else {
			data.data_sql.is_shared = 0
		}
		var param = data['data_sql'];
		var organization = _getOrganizationData();
		param.page_size = page_size;
		param.page = page;
		param = {
			...param,
			...organization
		};
		return param;
	} catch (e) {
		console.log('getQ9001Param: ' + e.message);
	}
}
