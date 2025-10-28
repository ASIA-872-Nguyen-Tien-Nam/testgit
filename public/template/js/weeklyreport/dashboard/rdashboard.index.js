/**
 * ****************************************************************************
 * MIRAI
 *
 * 作成日    : 
 * 作成者    :
 *
 * @package   : MODULE 1ON1
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
$(document).ready(function () {
	try {
		_formatTooltip();
		initEvents();
		initialize();
	} catch (e) {
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
	try {
		// $('.multiselect').multiselect({
		// 	onChange: function () {
		// 		$.uniform.update();
		// 	}
		// });
		// $(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}

/**
 * initEvents
 *
 * @author		:	namnt-2023/02/13
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		//
		$(document).on('click', '.link_rdashboard', function () {
			try {
				location.href = 'rdashboard';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.link_rdashboardapprover', function () {
			try {
				location.href = 'rdashboardapprover';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.link_rdashboardreporter', function () {
			try {
				location.href = 'rdashboardreporter';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});

		$(document).on('click', '.btn_noti_show', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_noti_hide').css('display', '');
				$('.table_noti').css('display', '');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.btn_noti_hide', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_noti_show').css('display', '');
				$('.table_noti').css('display', 'none');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.btn_react_show', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_react_hide').css('display', '');
				$('.table_react').css('display', '');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.btn_react_hide', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_react_show').css('display', '');
				$('.table_react').css('display', 'none');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.btn_share_show', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_share_hide').css('display', '');
				$('.table_share').css('display', '');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.btn_share_hide', function () {
			try {
				$(this).css('display', 'none');
				$('.btn_share_show').css('display', '');
				$('.table_share').css('display', 'none');
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		//
		$(document).on('mouseover', '.label_comment', function () {
			try {
				if ($('.arrow').length == 1) {
					$('.arrow').css('left', '28px')
					console.log($('.arrow'))
				}

			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		// Click employee_detail
		// link report to ri2010
		$(document).on('click', '.link_ri2010', function (e) {
			try {
				e.preventDefault();
				var obj = {};
				obj.fiscal_year = $(this).attr('fiscal_year');
				obj.employee_cd = $(this).attr('employee_cd');
				obj.report_kind = $(this).attr('report_kind');
				obj.report_no = $(this).attr('report_no');
				let list = [];
				$('.tr_employee').each(function () {
					let fiscal_year = $(this).find('.link_ri2010').attr('fiscal_year') != 'undefined' ? parseInt($(this).find('.link_ri2010').attr('fiscal_year')) : 0;
					let employee_cd = $(this).find('.link_ri2010').attr('employee_cd') != 'undefined' ? $(this).find('.link_ri2010').attr('employee_cd') : '';
					let report_kind = $(this).find('.link_ri2010').attr('report_kind') != 'undefined' ? parseInt($(this).find('.link_ri2010').attr('report_kind')) : 0;
					let report_no = $(this).find('.link_ri2010').attr('report_no') != 'undefined' ? parseInt($(this).find('.link_ri2010').attr('report_no')) : 0;
					list.push({ 'fiscal_year': fiscal_year, 'employee_cd': employee_cd, 'report_kind': report_kind, 'report_no': report_no });
				});
				obj.reports = list;
				getListReportNo(obj);
			} catch (e) {
				alert('.link_ri2010: ' + e.message);
			}
		});

		// link report to ri2010 when click notification
		$(document).on('click', '.infomation_message', function (e) {
			try {
				e.preventDefault();
				var obj = {};
				let tr = $(this).closest('tr');
				obj.fiscal_year = tr.attr('fiscal_year');
				obj.employee_cd = tr.attr('employee_cd');
				obj.report_kind = tr.attr('report_kind');
				obj.report_no = tr.attr('report_no');
				// 
				let list = [];
				let table = tr.closest('table');
				table.find('tbody tr').each(function () {
					let fiscal_year = $(this).attr('fiscal_year') != 'undefined' ? parseInt($(this).attr('fiscal_year')) : 0;
					let employee_cd = $(this).attr('employee_cd') != 'undefined' ? $(this).attr('employee_cd') : '';
					let report_kind = $(this).attr('report_kind') != 'undefined' ? parseInt($(this).attr('report_kind')) : 0;
					let report_no = $(this).attr('report_no') != 'undefined' ? parseInt($(this).attr('report_no')) : 0;
					list.push({ 'fiscal_year': fiscal_year, 'employee_cd': employee_cd, 'report_kind': report_kind, 'report_no': report_no });
				});
				obj.reports = list;
				getListReportNo(obj);
			} catch (e) {
				alert('.link_ri2010: ' + e.message);
			}
		});
		// change #fiscal_year, #month
		$(document).on('change', '#fiscal_year, #month, #times, #mygroup_cd, #report_kind', function (e) {
			try {
				__referDataAffterChangeMonth();
			} catch (e) {
				alert('change conditions: ' + e.message);
			}
		});
		// change #organization_step1 ~ #organization_step5
		$(document).on('change', '#organization_step1, #organization_step2, #organization_step3, #organization_step4, #organization_step5', function (e) {
			try {
				__referDataAffterChangeMonth();
			} catch (e) {
				alert('change conditions: ' + e.message);
			}
		});
		// click checkbox #unapproved_only, #approved_show
		$(document).on('click', '#shared_report, #approved_show', function () {
			try {
				__referDataAffterChangeMonth();
			} catch (e) {
				alert('change conditions ' + e.message);
			}
		});
		// click btn_delete
		$(document).on('click', '.btn_delete', function () {
			try {
				readNoti($(this));
			} catch (e) {
				alert('.btn_delete ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
 * Refer reports for reporter 
 * 
 */
function __referDataAffterChangeMonth() {
	try {
		if (_validate()) {
			var fiscal_year = $('#fiscal_year').val();
			var year_month = '';
			$('#month option').each(function () {
				if ($(this).prop('selected')) {
					year_month = $(this).text().trim();
				}
			});
			var year = -1;
			var month = -1;
			if (year_month != '') {
				year = parseInt(year_month.substring(0, 4));
				month = parseInt(year_month.substring(5, 7));
			}
			var times = $('#times').val();
			var report_kind = $('#report_kind').val();
			var mygroup_cd = $('#mygroup_cd').val();
			var belong_cd1 = '-1';
			var belong_cd2 = '-1';
			var belong_cd3 = '-1';
			var belong_cd4 = '-1';
			var belong_cd5 = '-1';
			if ($('#organization_step1').length > 0) {
				let organization_step1 = $('#organization_step1').val();
				let arr = organization_step1.split('|');
				if (typeof arr[0] != undefined) {
					belong_cd1 = arr[0];
				}
			}
			if ($('#organization_step2').length > 0) {
				let organization_step2 = $('#organization_step2').val();
				let arr = organization_step2.split('|');
				if (typeof arr[1] != undefined) {
					belong_cd2 = arr[1];
				}
			}
			if ($('#organization_step3').length > 0) {
				let organization_step3 = $('#organization_step3').val();
				let arr = organization_step3.split('|');
				if (typeof arr[2] != undefined) {
					belong_cd3 = arr[2];
				}
			}
			if ($('#organization_step4').length > 0) {
				let organization_step4 = $('#organization_step4').val();
				let arr = organization_step4.split('|');
				if (typeof arr[3] != undefined) {
					belong_cd4 = arr[3];
				}
			}
			if ($('#organization_step5').length > 0) {
				let organization_step5 = $('#organization_step5').val();
				let arr = organization_step5.split('|');
				if (typeof arr[4] != undefined) {
					belong_cd5 = arr[4];
				}
			}
			var shared_report = 0;
			var approved_show = 0;
			if ($('#shared_report').prop('checked')) {
				shared_report = 1;
			}
			if ($('#approved_show').prop('checked')) {
				approved_show = 1;
			}

			var data = {};
			data.fiscal_year = fiscal_year;
			data.year = year;
			data.month = month;
			data.times = times;
			data.report_kind = report_kind;
			data.mygroup_cd = mygroup_cd;
			data.belong_cd1 = belong_cd1;
			data.belong_cd2 = belong_cd2;
			data.belong_cd3 = belong_cd3;
			data.belong_cd4 = belong_cd4;
			data.belong_cd5 = belong_cd5;
			data.shared_report = shared_report;
			data.approved_show = approved_show;
			// send data to post
			$.ajax({
				type: 'POST',
				url: '/weeklyreport/rdashboard',
				dataType: 'html',
				loading: true,
				data: data,
				success: function (res) {
					$('#left_times_viewer_div').empty();
					$('#left_times_viewer_div').append(res);
					_formatTooltip();
				}
			});
		}
	} catch (e) {
		console.log('referReportsForApprover:' + e.message);
	}
}

/**
 * Read noti
 *
 * @author		:	viettd - 2023/05/08 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function readNoti(object) {
	try {
		var data = {};
		var tr = object.closest('tr');
		var noti_div = object.closest('.noti_div');
		var total = parseInt(noti_div.find('.noti_total').val());
		if (typeof total != undefined && total > 0) {
			total -= 1;
		}
		noti_div.find('.noti_total').val(total);
		noti_div.find('.noti_total_label').text(total);
		// 
		data.fiscal_year = tr.attr('fiscal_year');
		data.infomation_typ = tr.attr('infomation_typ');
		data.employee_cd = tr.attr('employee_cd');
		data.report_kind = tr.attr('report_kind');
		data.report_no = tr.attr('report_no');
		data.from_employee_cd = tr.attr('from_employee_cd');
		data.to_employee_cd = tr.attr('to_employee_cd');
		// remove tr
		tr.remove();
		//send data to post
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rdashboard/read',
			dataType: 'json',
			loading: true,
			data: data,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:

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
		alert('readNoti' + e.message);
	}
}
/**
 * Get all list of report_no in screen
 */
function getListReportNo(obj) {
	try {
		// return list;
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rdashboard/cache',
			dataType: 'json',
			loading: true,
			data: obj,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						var data = {
							'fiscal_year_weeklyreport': obj.fiscal_year
							, 'employee_cd': obj.employee_cd
							, 'report_kind': obj.report_kind
							, 'report_no': obj.report_no
							, 'from': 'rdashboard'
						};
						data['screen_id'] = 'rdashboard_ri2010';	// save key -> to cache
						_redirectScreen('/weeklyreport/ri2010', data, true);
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
		console.log('getListReportNo:' + e.message);
	}
}