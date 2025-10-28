/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2023/02/07
 * 作成者		    :	quangnd - quangnd@ans-asia.com
 *
 * @package		:	MODULE weeklyreport
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	'mark_kbn': { 'type': 'text', 'attr': 'id' },
	'name': { 'type': 'text', 'attr': 'id' },
	'tr': {
		'attr': 'list', 'item': {
			'item_no': { 'type': 'text', 'attr': 'class' },
			'mark_cd': { 'type': 'text', 'attr': 'class' },
			'explanation': { 'type': 'text', 'attr': 'class' },
			'point': { 'type': 'text', 'attr': 'class' },
		}
	}
};
$(document).ready(function() {
	try{
		initEvents();
	}
	catch(e){
		alert('ready' + e.message);
	}
});

/*
 * INIT EVENTS
 * @author		:	quangnd - 2023/02/07 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try{
		$(document).on('click', '#btn-back', function (e) {
			try {
				//
				var home_url = $('#home_url').attr('href');
				_backButtonFunction(home_url);
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
		$(document).on('click', '.btn-save', function () {
			try {
				jMessage(1, function (r) {
					if (r && _validate($('body'))) {
						saveData();
					}
				});
			} catch (e) {
				alert('.btn-save: ' + e.message);
			}
		});

		$(document).on('click', '#btn-delete', function (e) {
			try {
				jMessage(3, function (r) {
					deleteData();
				});
			} catch (e) {
				alert('#btn-delete' + e.message);
			}
		});
		//
		//mark_typ
		$(document).on('change', '#mark_kbn', function () {
			try {
				referData(1);
			} catch (e) {
				alert('mark_typ: ' + e.message);
			}
		});
		$(document).on('change', '#mark_typ', function () {
			try {
				referData(2);
			} catch (e) {
				alert('mark_typ: ' + e.message);
			}
		});
	} catch (e) {
		alert('#btn-initEvents ' + e.message);
	}	
}
/**
 * referData
 *
 * @author      :   quangnd -2023/04/13
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referData(mode) {
	try {
		var data = {};
		data.mark_kbn   = $('#mark_kbn').val();
        data.mark_typ 	= $('#mark_typ input:checked').val();
		data.mode 		= mode;
		$.ajax({
			type: 'post',
			url: '/weeklyreport/rm0110/refer',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				$('#body-inner').empty().append(res);
				$('#mark_kbn').focus();
			}
		});
	} catch (e) {
		alert('referData: ' + e.message);
	}
};
/**
 * saveData
 *
 * @author      :   quangnd -2023/04/13
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var params = getData(_obj);
		params.data_sql.mark_typ = $('#mark_typ input:checked').val();
		$.ajax({
			type: 'post',
			url: '/weeklyreport/rm0110/save',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(params),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function (r) {
							referData(1)
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
							processError(res['errors']);
						}
						break;
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}
			}
		});
	} catch (e) {
		alert('saveData: ' + e.message);
	}
};
/**
 * delete data
 *
 * @author      :   quangnd -2023/04/13
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
	try {
		var data = {};
		data.mark_kbn   = $('#mark_kbn').val();
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rm0110/delete',
			dataType: 'json',
			data: data,
			loading: true,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(4, function (r) {
							location.reload();
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
		});
	} catch (e) {
		alert('deleteData' + e.message);
	}
}
