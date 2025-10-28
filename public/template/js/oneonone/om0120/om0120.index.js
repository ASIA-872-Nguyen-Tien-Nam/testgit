/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	'name': { 'type': 'text', 'attr': 'id' },
	'tr': {
		'attr': 'list', 'item': {
			'item_no': { 'type': 'text', 'attr': 'class' },
			'remark': { 'type': 'text', 'attr': 'class' },
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
 * @author		:	datnt - 2020/10/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	$(document).on('click', '#btn-back', function (e) {
		try {
			//
			var home_url = $('#home_url').attr('href');
			_backButtonFunction(home_url);
		} catch (e) {
			alert('#btn-back' + e.message);
		}
	});
	$('input').first().focus();
	$(document).mouseup(function (e) {
		try {
			var container = $(".table-select");
			// if the target of the click isn't the container nor a descendant of the container
			if (!container.is(e.target) && container.has(e.target).length === 0) {
				$('.dropdown ul').hide();
			}
		} catch (e) {
			alert('mouseup: ' + e.message);
		}
	});
	// $(".dropdown img.flag").addClass("flagvisibility");
	$(document).on('click', '.dropdown dt a', function () {
		try {
			var dropDown = $(this).parents('.dropdown')
			$('.table-select').removeClass('table-select');
			dropDown.addClass('table-select');
			dropDown.find('ul').toggle();
			var bottomSpace = dropDown.offset().top + dropDown.outerHeight();

			var dropDownWrapper = dropDown.find('.dropdown-wrapper');
			if ((bottomSpace + $(dropDownWrapper).outerHeight()) > $("body").height()) {
				$(dropDownWrapper).css('top', ($(dropDownWrapper).outerHeight() + dropDown.outerHeight()) * (-1));
			}
		} catch (e) {
			alert('dropdown dt a: ' + e.message);
		}
		// $(".dropdown dd ul").toggle();
	});
	$(document).on('click', '.dropdown dd ul li a', function () {
		try {
			var text = $(this).html();
			var selected_value = $(this).attr('remark_cd')
			$(this).parents('.dropdown').find('.remark').attr('value', selected_value);
			$(this).parents('.dropdown').find('span').html(text);
			$(this).parents('.dropdown').find('ul').hide();
		} catch (e) {
			alert('.dropdown dd ul li a: ' + e.message);
		}

	});
	$(document).bind('click', function (e) {
		try {
			var $clicked = $(e.target);
			if (!$clicked.parents().hasClass("dropdown"))
				$(".dropdown dd ul").hide();
		} catch (e) {
			alert('click: ' + e.message);
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
	//mark_typ
	$(document).on('change', '#mark_typ', function () {
		try {
			var params = getData(_obj);

			params.data_sql.remark_typ = $('#mark_typ input:checked').val();
			$.ajax({
				type: 'post',
				url: '/oneonone/om0120/refer',
				dataType: 'html',
				loading: true,
				data: params,
				success: function (res) {
					$('#body-inner').empty();
					$('#body-inner').append(res);
					initDropdownRemark();
				}
			});
		} catch (e) {
			alert('mark_typ: ' + e.message);
		}
	});
	$(document).on('click', '#btn-delete', function (e) {
		try {
			jMessage(3, function (r) {
				if (r) {
					deleteData();
				}
			});
		} catch (e) {
			alert('#btn-delete' + e.message);
		}
	});
}
/**
 * saveData
 *
 * @author      :   datnt - 2020/12/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var params = getData(_obj);
		params.data_sql.remark_typ = $('#mark_typ input:checked').val();
		$.ajax({
			type: 'post',
			url: '/oneonone/om0120/save',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(params),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						//
						jMessage(2, function (r) {
							location.reload();
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
 * @author      :   datnt - 2020/12/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
	try {

		$.ajax({
			type: 'POST',
			url: '/oneonone/om0120/delete',
			dataType: 'json',
			data: { 'mark_typ': $('#mark_typ input:checked').val() },
			loading: true,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(4, function (r) {
							clearData(_obj);
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
