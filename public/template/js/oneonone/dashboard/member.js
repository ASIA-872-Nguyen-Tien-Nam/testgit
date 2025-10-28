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
		document.addEventListener('keydown', function (e) {
			if (e.keyCode === 9) {
				if (e.shiftKey) {
					if ($(':focus')[0] === $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0]) {
						e.preventDefault();
						$('#btn-add-detail').focus();
					}
				} else {
					if ($(':focus')[0] === $('#btn-add-detail')[0]) {
						e.preventDefault();
						$(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
					}
				}
			}
		})
		//
		$(document).on('click', '#btn-target-member', function (e) {
			try {
				var option = {};
				$('body').css('overflow-y', 'hidden');
				option.width = '60%';
				option.height = '80%';
				var fiscal_year_1on1_target = $('#fiscal_year_1on1_member option:selected').val();
				$('body').css('overflow', 'unset');
				// e.preventDefault();
				showPopup('/oneonone/odashboardmember/popup?fiscal_year_1on1_target=' + fiscal_year_1on1_target + '', option, function () { });
			} catch (e) {
				alert('#btn-target-member event:' + e.message);
			}
		});
		$(document).on('click', '.link_odashboard', function () {
			try {
				location.href = 'odashboard';
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
		$(document).on('click', '.oi3010_link', function (e) {
			try {
				e.preventDefault();
				var tr = $(this).parents('tr');
				var fiscal_year_1on1 = $('#fiscal_year_1on1_member option:selected').val();
				var group_cd_1on1 = tr.attr('group_cd_1on1');
				var employee_cd = tr.attr('employee_cd');
				var times = tr.attr('times');
				var questionnaire_cd = $(this).attr('questionnaire_cd');

				var data = {
					'fiscal_year_1on1': fiscal_year_1on1
					, 'employee_cd': employee_cd
					, 'group_cd_1on1': group_cd_1on1
					, 'times': times
					, 'questionnaire_cd': questionnaire_cd
					, 'from': 'odashboardmember'
				};
				//
				data['screen_id'] = 'odashboard_oi3010';	// save key -> to cache (link from odashboard member to oi3010)
				_redirectScreen('/oneonone/oi3010', data, false);
			} catch (e) {
				alert('.link_oi3010: ' + e.message);
			}
		});
		$(document).on('click', '.link_oi2010', function (e) {
			try {
				e.preventDefault();
				var tr = $(this).parents('tr');
				var group_cd_1on1 = tr.attr('group_cd_1on1');
				var member_cd = tr.attr('employee_cd');
				var fiscal_year_1on1 = $('#fiscal_year_1on1_member option:selected').val();
				var times = tr.attr('times');
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1
					, 'member_cd': member_cd
					, 'group_cd_1on1': group_cd_1on1
					, 'times': times
					, 'from': 'odashboardmember'
				};
				//
				data['screen_id'] = 'odashboard_oi2010';	// save key -> to cache (link from odashboard member to oq2010)
				_redirectScreen('/oneonone/oi2010', data, false);
			} catch (e) {
				alert('.link_oi2010: ' + e.message);
			}
		});
		// change item fiscal_year_1on1_member
		$(document).on('change', '#fiscal_year_1on1_member', function () {
			try {
				referLeftTimesForMember($(this).val());
				referLeftTargetForMember($(this).val());
				referRightForMember($(this).val());
			} catch (e) {
				alert('#fiscal_year_1on1_member : ' + e.message);
			}
		});
		// link schedule to oi2010
		$(document).on('click', '.right-div-odashboard', function (e) {
			try {
				e.preventDefault();
				div = $(this);
				var fiscal_year_1on1 = div.find('.schedule_fiscal_year').val();
				var member_cd = div.find('.schedule_employee_cd').val();
				var times = div.find('.schedule_times').val();
				var group_cd_1on1 = div.find('.schedule_group_cd_1on1').val();
				var data = {
					'fiscal_year_1on1': fiscal_year_1on1
				, 	'member_cd': member_cd
				, 	'group_cd_1on1': group_cd_1on1
				, 	'times': times
				, 	'from': 'odashboardmember'
				};
				//
				data['screen_id'] = 'odashboardmember_oi2010';	// save key -> to cache (link from odashboard member to oq2010)
				_redirectScreen('/oneonone/oi2010', data, false);
			} catch (e) {
				alert('.right-div-odashboard: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}
/**
 * referLeftTimesForMember
 *
 * @author		:	viettd - 2020/12/02 - create
 * @param		int	fiscal_year_1on1_member
 * @return		void
 * @access		:	public
 * @see			:	init
 */
function referLeftTimesForMember(fiscal_year_1on1_member = 0) {
	try {
		data = {};
		data.fiscal_year_1on1_member = fiscal_year_1on1_member;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboardmember/getlefttimesformember',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#left_times_member_div').empty();
				$('#left_times_member_div').append(res);
			}
		});
	} catch (e) {
		alert('referLeftTimesForMember : ' + e.message);
	}
}
/**
 * referLeftTargetForMember
 *
 * @author		:	viettd - 2020/12/02 - create
 * @param		int	fiscal_year_1on1_member
 * @return		void
 * @access		:	public
 * @see			:	init
 */
function referLeftTargetForMember(fiscal_year_1on1_member = 0) {
	try {
		data = {};
		data.fiscal_year_1on1_member = fiscal_year_1on1_member;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboardmember/getlefttargetformember',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#left_target_member_div').empty();
				$('#left_target_member_div').append(res);
				_formatTooltip();
			}
		});
	} catch (e) {
		alert('referLeftTargetForMember : ' + e.message);
	}
}

/**
 * referLeftTargetForMember
 *
 * @author		:	viettd - 2020/12/02 - create
 * @param		int	fiscal_year_1on1_member
 * @return		void
 * @access		:	public
 * @see			:	init
 */
function referRightForMember(fiscal_year_1on1_member = 0) {
	try {
		data = {};
		data.fiscal_year_1on1_member = fiscal_year_1on1_member;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/odashboardmember/getrightmember',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#right_member_div').empty();
				$('#right_member_div').append(res);
			}
		});
	} catch (e) {
		alert('referLeftTargetForMember : ' + e.message);
	}
}
