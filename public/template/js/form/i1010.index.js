/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   datnt – datnt@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
	'fiscal_year': { 'type': 'text', 'attr': 'id' },
	'list': {
		'attr': 'list', 'item': {
			'treatment_applications_no': { 'type': 'text', 'attr': 'class' },
			'use_typ': { 'type': 'select', 'attr': 'class' },
			'sheet_use_typ': { 'type': 'select', 'attr': 'class' },
		}
	},
};

$(function () {
	initEvents();
	initialize();
});

/**
 * initialize
 *
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		$('#fiscal_year').focus();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	$(document).on('click', '#btn-save', function (e) {
		jMessage(1, function (r) {
			if (r) {
				save();
			}
		});
	});
	$(document).on('change', '#fiscal_year', function (e) {
		refer();
	});
	$(document).on('change', '.use_typ', function (e) {
		let use_typ = $(this).val();
		if (use_typ == 1) {
			$(this).parents('.list').find('.sheet_use_typ').prop('disabled', false);
		} else {
			$(this).parents('.list').find('.sheet_use_typ').prop('disabled', true);
			$(this).parents('.list').find('.sheet_use_typ').val(0);
		}
	});
	$(document).on('click', '#btn-back', function () {
		if (_validateDomain(window.location)) {
			window.location.href = '/dashboard';
		} else {
			jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
		}
	});
}
/**
 * refer
 * 
 * @author      :   datnt - 2018/08/28 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function refer() {
	try {
		var fiscal_year = $('#fiscal_year').val();
		// send data to post
		$.ajax({
			type: 'post',
			url: '/master/i1010/refer',
			dataType: 'html',
			loading: true,
			data: { fiscal_year: fiscal_year },
			success: function (res) {
				$('#inner').empty();
				$('#inner').append(res);
				check_save();
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}

/**
 * saveData
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function check_save() {
	var fiscal_year = $('#fiscal_year').val();
	$.ajax({
		type: 'post',
		data: { fiscal_year: fiscal_year },
		url: '/master/i1010/check',
		loading: false,
		success: function (res) {
			const $mobile = $('#chk_btn .nav-menubar-mobile');
			const $pc = $('#chk_btn .nav-menubar-pc');
			
			// Cập nhật nội dung ngoài #chk_btn
			$('.nav-menubar-mobile').not('#chk_btn .nav-menubar-mobile').empty().append($mobile.children().clone());
			$('.nav-menubar-pc').not('#chk_btn .nav-menubar-pc').empty().append($pc.children().clone());
			
			if (res['check_save'] == 1) {
				// Chỉ xóa/remove các phần ngoài #chk_btn
				$('.nav-menubar-mobile .navbar-nav.ml-auto').not('#chk_btn *').remove();
				$('.nav-menubar-mobile .dropleft').not('#chk_btn *').hide();		
				$('.nav-menubar-pc #btn-save').not('#chk_btn *').hide();
			
				const $navUl = $('.nav-menubar-pc .navbar-nav.ml-auto').not('#chk_btn *').addClass('check_btn');
				$('.nav-menubar-mobile').not('#chk_btn *').append($navUl.clone());
				$('.nav-menubar-mobile .check_btn').addClass('mt-2');
			} else {
				$('.nav-menubar-mobile .check_btn').not('#chk_btn *').remove();
				$('.nav-menubar-mobile .dropleft').not('#chk_btn *').css("display", "flow-root");
				$('.nav-menubar-pc #btn-save').not('#chk_btn *').css("display", "flow-root");
			}
		}
	})
}
/**
 * saveData
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function save() {
	var data = getData(_obj);
	$.ajax({
		type: 'post',
		data: JSON.stringify(data),
		url: '/master/i1010/save',
		loading: true,
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					//
					jMessage(2, function (r) {
						if (_validateDomain(window.location)) {
							location.href = '/master/i1010';
						} else {
							jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
						}
					});
					break;
				// error
				case NG:
					if (typeof res['errors'] != 'undefined') {
						processError(res['errors']);
					}
					break;
				case 404:
					jMessage(27);
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
}