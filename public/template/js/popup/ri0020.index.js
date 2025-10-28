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
		// button [登録]
		$(document).on('click', '#btn-save', function () {
			try {
				jMessage(1, function (r) {
					if (r) {
						save();
					}
				});
			} catch (e) {
				alert('#btn-save' + e.message);
			}
		});
		// change key fiscal_year_weeklyreport_target
		$(document).on('change', '#fiscal_year_weeklyreport_target', function () {
			try {
				referData($(this).val());
			} catch (e) {
				alert('#fiscal_year_weeklyreport_target' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
 * save
 *
 * @author		:	viettd - 2023/05/08 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function save() {
	try {
		var data = {};
		data.fiscal_year = $('#fiscal_year_weeklyreport_target').val();
		data.target1 = $('#target1').length > 0 ? $('#target1').val() : '';
		data.target2 = $('#target2').length > 0 ? $('#target2').val() : '';
		data.target3 = $('#target3').length > 0 ? $('#target3').val() : '';
		data.target4 = $('#target4').length > 0 ? $('#target4').val() : '';
		data.target5 = $('#target5').length > 0 ? $('#target5').val() : '';
		//send data to post
		$.ajax({
			type: 'POST',
			url: '/common/popup/ri0020/save',
			dataType: 'json',
			loading: true,
			data: data,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						// parent.$('#fiscal_year_1on1_member').trigger('change');
						parent.$.colorbox.close();
						parent.location.reload();
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

/**
 * Refer data for popup ri0020
 * 
 * @param {Int} fiscal_year 
 */
function referData(fiscal_year) {
	try {
		var data = {};
		data.fiscal_year = fiscal_year;
		//send data to post
		$.ajax({
			type: 'POST',
			url: '/common/popup/ri0020/refer',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#target_popup').empty();
				$('#target_popup').append(res);
				$('#fiscal_year_weeklyreport_target').focus();
			}
		});
	} catch (e) {
		console.log('referData: ' + e.message);
	}
}