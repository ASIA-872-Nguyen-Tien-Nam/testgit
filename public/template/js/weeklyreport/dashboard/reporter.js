/**
 * ****************************************************************************
 * MIRAI
 *
 * 作成日    : 2020/12/10
 * 作成者    : viettd - viettd@ans-asia.com
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
		// initialize();
	} catch (e) {
		alert('ready' + e.message);
	}
});
/**
 * initEvents
 *
 * @author		:	viettd - 2020/12/10 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		//
		$(document).on('click', '#btn-target-member', function (e) {
			try {
				var option = {};
				$('body').css('overflow-y', 'hidden');
				option.width = '60%';
				option.height = '85%';
				$('body').css('overflow', 'unset');
				showPopup('/common/popup/ri0020', option, function () { });
			} catch (e) {
				alert('#btn-target-member event:' + e.message);
			}
		});
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
		// link report to ri2010
		$(document).on('click', '.link_ri2010', function (e) {
			try {
				e.preventDefault();
				getListReportNo($(this));
			} catch (e) {
				alert('.link_ri2010: ' + e.message);
			}
		});
		// link report to ri2010 when click notification
		$(document).on('click', '.infomation_message', function (e) {
			try {
				e.preventDefault();
				let tr = $(this).closest('tr');
				var fiscal_year = tr.attr('fiscal_year');
				var employee_cd = tr.attr('employee_cd');
				var report_kind = tr.attr('report_kind');
				var report_no = tr.attr('report_no');
				var data = {
					'fiscal_year_weeklyreport': fiscal_year
					, 'employee_cd': employee_cd
					, 'report_kind': report_kind
					, 'report_no': report_no
					, 'from': 'rdashboardreporter'
				};
				data['screen_id'] = 'rdashboardreporter_ri2010';	// save key -> to cache
				_redirectScreen('/weeklyreport/ri2010', data, true);
			} catch (e) {
				alert('.infomation_message: ' + e.message);
			}
		});
		// #year, #month
		$(document).on('change', '#year, #month', function (e) {
			try {
				e.preventDefault();
				var year = $('#year').val();
				var month = $('#month').val();
				referReportsForReporter(year, month);
			} catch (e) {
				alert('.link_ri2010: ' + e.message);
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
 * @param {Int} year 
 * @param {Int} month 
 */
function referReportsForReporter(year = -1, month = -1) {
	try {
		var data = {};
		data.year = year;
		data.month = month;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rdashboardreporter',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#left_times_member_div').empty();
				$('#left_times_member_div').append(res);
				_formatTooltip();
			}
		});
	} catch (e) {
		console.log('referReportsForReporter:' + e.message);
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
						// window.location.reload();
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
function getListReportNo(object) {
	try {
		var fiscal_year = object.attr('fiscal_year');
		var employee_cd = object.attr('employee_cd');
		var report_kind = object.attr('report_kind');
		var report_no = object.attr('report_no');
		let list = [];
		$('.tr_employee').each(function () {
			let fiscal_year = $(this).find('.employee_data').attr('fiscal_year') != 'undefined' ? parseInt($(this).find('.employee_data').attr('fiscal_year')) : 0;
			let employee_cd = $(this).find('.employee_data').attr('employee_cd') != 'undefined' ? $(this).find('.employee_data').attr('employee_cd') : '';
			let report_kind = $(this).find('.employee_data').attr('report_kind') != 'undefined' ? parseInt($(this).find('.employee_data').attr('report_kind')) : 0;
			let report_no = $(this).find('.employee_data').attr('report_no') != 'undefined' ? parseInt($(this).find('.employee_data').attr('report_no')) : 0;
			list.push({ 'fiscal_year': fiscal_year, 'employee_cd': employee_cd, 'report_kind': report_kind, 'report_no': report_no });
		});
		var data = {};
		data.reports = list;
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rdashboard/cache',
			dataType: 'json',
			loading: true,
			data: data,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						var data = {
							'fiscal_year_weeklyreport': fiscal_year
							, 'employee_cd': employee_cd
							, 'report_kind': report_kind
							, 'report_no': report_no
							, 'from': 'rdashboardreporter'
						};
						data['screen_id'] = 'rdashboardreporter_ri2010';	// save key -> to cache (link from odashboard member to oq2010)
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