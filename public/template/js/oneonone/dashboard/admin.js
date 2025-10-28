/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2021/11/26
 * 作成者		    :	vietdt – vietdt@ans-asia.com
 *
 * @package			:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version			:	1.0.0
 * ****************************************************************************
 */
$(document).ready(function () {
	try {
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
 * @author		:	vietdt - 2021/11/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {

	} catch (e) {
		alert('initialize: ' + e.message);
	}
}

/**
 * initEvents
 *
 * @author		:	vietdt - 2021/11/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		// change year + group
		$(document).on('change', '#fiscal_year_1on1 , #group_cd_1on1', function () {
			try {
				var fiscal_year_1on1 = $('#fiscal_year_1on1 option:selected').val();
				var group_cd_1on1 = $('#group_cd_1on1 option:selected').val();
				referLeftAdminDashboard(fiscal_year_1on1, group_cd_1on1, 1);
			} catch (e) {
				alert('change year + group : ' + e.message);
			}
		});
		$(document).on('change', '#times_select', function () {
			var times_from = $(this).val();
			var fiscal_year_1on1 = $('#fiscal_year_1on1').val();
			var group_cd_1on1 = $('#group_cd_1on1').val();
			referLeftAdminDashboard(fiscal_year_1on1, group_cd_1on1, times_from);
		})
		$(document).on('click', '.times_link', function () {
			try {
				var fiscal_year_1on1 = $(this).attr('fiscal_year_1on1');
				var group_cd_1on1 = $(this).attr('group_cd_1on1');
				var times = $(this).attr('times');
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1,
					'group_cd_1on1': group_cd_1on1,
					'times': times,
					'from': 'odashboard',
				};
				_redirectScreen('/oneonone/oq2010', data, true);
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.link_odashboardmember', function () {
			try {
				location.href = 'odashboardmember';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.link_odashboard', function () {
			try {
				location.href = 'odashboard';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		$(document).on('click', '.link_oq0010', function () {
			try {
				location.href = 'oq0010';
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		//
		$(document).on('click', '.oq2020_link', function () {
			try {
				var fiscal_year_1on1 = $('#fiscal_year_1on1 option:selected').val();
				var employee_cd = $(this).attr('employee_cd');
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1,
					'employee_cd': employee_cd,
					'from': 'odashboard'
				};
				console.log(data);
				_redirectScreen('/oneonone/oq2020', data, true);
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		// link fullfillment_click
		$(document).on('click', '.fullfillment_click', function (e) {
			try {
				e.preventDefault();
				var group_cd_1on1 = $(this).attr('group_cd_1on1');
				var member_cd = $(this).attr('employee_cd');
				var fiscal_year_1on1 = $(this).attr('fiscal_year');
				var times = $(this).attr('times');
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1
				, 	'member_cd': member_cd
				, 	'group_cd_1on1': group_cd_1on1
				, 	'times': times
				, 	'from': 'odashboardadmin'
				};
				//
				data['screen_id'] = 'odashboard_oi2010';	// save key -> to cache (link from odashboard member to oq2010)
				_redirectScreen('/oneonone/oi2010', data, false);
			} catch (e) {
				alert('.fullfillment_click: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}
/**
 * referLeftAdminDashboard
 *
 * @author		:	vietdt - 2021/11/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function referLeftAdminDashboard(fiscal_year_1on1 = 0, group_cd_1on1 = 0, times_from = 0) {
	try {
		data = {};
		data.fiscal_year_1on1 = fiscal_year_1on1;
		data.group_cd_1on1 = group_cd_1on1;
		data.times_from = times_from;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboard/getleftadmin',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#div_coach_left_content').empty();
				$('#div_coach_left_content').append(res);
			}
		});
	} catch (e) {
		alert('referLeftAdminDashboard: ' + e.message);
	}
}

