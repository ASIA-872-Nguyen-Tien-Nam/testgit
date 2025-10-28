/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2023/03/28
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package			:	MODULE POPUP
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version			:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	'mypurpose': { 'type': 'text', 'attr': 'id' },
	'comment': { 'type': 'text', 'attr': 'id' },
};
// 
$(document).ready(function () {
	try {
		initialize();
		initEvents();
	} catch (e) {
		alert('ready' + e.message);
	}
});

/**
 * initialize
 *
 * @author		:	viettd - 2023/03/28 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		// _formatTooltip();
		var screen_emp_info = ''
		if(parent.$('#employee_cd').attr('screen') != undefined) {
		screen_emp_info = parent.$('#employee_cd').attr('screen')
		$('body').addClass(screen_emp_info)
		}
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	viettd - 2023/03/28 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		$(document).on('click', '#btn-save', function (r) {
			try {
				jMessage(1, function (r) {
					if (r && _validate($('body'))) {
						save();
					}
				});
			} catch (e) {
				alert('#btn-save' + e.message);
			}
		});
	} catch (e) {
		console.log('initEvents:' + e.message);
	}
}

/**
 * save
 *
 * @author      :   viettd - 2023/03/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function save() {
	try {
		var data = getData(_obj);
		$.ajax({
			type: 'post',
			url: '/common/popup/my_purpose',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function () {
							// close popup
							$('#btn-close-popup').click();
							parent.location.reload();
						});
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
		})
	} catch (e) {
		console.log('save:' + e.message);
	}
}