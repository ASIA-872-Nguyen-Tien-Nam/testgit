/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/10/08
 * 作成者		    :	viettd – viettd@ans-asia.com
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
 * @author		:	viettd - 2020/12/02 - create
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
 * @author		:	viettd - 2020/12/02 - create
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
				referLeftCoachDashboard(fiscal_year_1on1, group_cd_1on1, 1);
				referRightCoachDashboard(fiscal_year_1on1, group_cd_1on1);
			} catch (e) {
				alert('change year + group : ' + e.message);
			}
		});
		$(document).on('click', '.daint', function () {
			alert(1);
		});
		$(document).on('change', '#times_select', function () {
			var times_from = $(this).val();
			var fiscal_year_1on1 = $('#fiscal_year_1on1').val();
			var group_cd_1on1 = $('#group_cd_1on1').val();
			referLeftCoachDashboard(fiscal_year_1on1, group_cd_1on1, times_from);
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
		$(document).on('click', '.link_odashboardadmin', function () {
			try {
				location.href = 'odashboardadmin';
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
		//
		$(document).on('click', '.oi3010_link', function () {
			try {
				var fiscal_year_1on1 = $('#fiscal_year_1on1 option:selected').val();
				var group_cd_1on1 = $('#group_cd_1on1 option:selected').val();
				var times = $(this).attr('times');
				var questionnaire_cd = $(this).attr('questionnaire_cd');
				var coach_cd = $('#employee_cd_login').val();
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1,
					'group_cd_1on1': group_cd_1on1,
					'times': times,
					'questionnaire_cd': questionnaire_cd,
					'coach_cd': coach_cd,
					'from': 'odashboard',
				};
				_redirectScreen('/oneonone/oi3010', data, false);
			} catch (e) {
				alert('#btn-interview event' + e.message);
			}
		});
		// link schedule to oi2010
		$(document).on('click', '.schedule_link', function (e) {
			try {
				e.preventDefault();
				div = $(this).closest('td');
				var fiscal_year_1on1 = div.find('.schedule_fiscal_year').val();
				var member_cd = div.find('.schedule_employee_cd').val();
				var times = div.find('.schedule_times').val();
				var group_cd_1on1 = div.find('.schedule_group_cd_1on1').val();
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1
				, 	'member_cd': member_cd
				, 	'group_cd_1on1': group_cd_1on1
				, 	'times': times
				, 	'from': 'odashboard'
				};
				//
				data['screen_id'] = 'odashboard_oi2010';	// save key -> to cache (link from odashboard member to oq2010)
				_redirectScreen('/oneonone/oi2010', data, false);
			} catch (e) {
				alert('.schedule_link: ' + e.message);
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
				, 	'from': 'odashboard'
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
 * referLeftCoachDashboard
 *
 * @author		:	viettd - 2020/12/02 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function referLeftCoachDashboard(fiscal_year_1on1 = 0, group_cd_1on1 = 0, times_from = 0) {
	try {
		data = {};
		data.fiscal_year_1on1 = fiscal_year_1on1;
		data.group_cd_1on1 = group_cd_1on1;
		data.times_from = times_from;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboard/getleftcoach',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#div_coach_left_content').empty();
				$('#div_coach_left_content').append(res);
			}
		});
	} catch (e) {
		alert('referLeftCoachDashboard: ' + e.message);
	}
}

/**
 * referRightCoachDashboard
 *
 * @author		:	viettd - 2020/12/02 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function referRightCoachDashboard(fiscal_year_1on1 = 0, group_cd_1on1 = 0) {
	try {
		data = {};
		data.fiscal_year_1on1 = fiscal_year_1on1;
		data.group_cd_1on1 = group_cd_1on1;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboard/getrightcoach',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#div_coach_right_content').empty();
				$('#div_coach_right_content').append(res);
			}
		});
	} catch (e) {
		alert('referRightCoachDashboard: ' + e.message);
	}
}
