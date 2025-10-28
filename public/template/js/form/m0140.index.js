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
	'organization_cd': { 'type': 'text', 'attr': 'id' },
	'arrange_order': { 'type': 'text', 'attr': 'id' },
	'list': {
		'attr': 'list', 'item': {
			'organization_cd': { 'type': 'select', 'attr': 'class' },
			'position_cd': { 'type': 'select', 'attr': 'class' },
			'rater_position_cd_1': { 'type': 'select', 'attr': 'class' },
			'rater_position_cd_2': { 'type': 'select', 'attr': 'class' },
			'rater_position_cd_3': { 'type': 'select', 'attr': 'class' },
			'rater_position_cd_4': { 'type': 'select', 'attr': 'class' },
		}
	},
};
// 
$( document ).ready(function() {
	try{
		initialize();
        initEvents();
	}
	catch(e){
		alert('ready' + e.message);
	}
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
		$('#organization_cd').focus();
		_formatTooltip();
		$(".list select").each(function () {
			var item = $(this).hasClass("disabled");
			if (item) {
				$(this).removeClass("required");
			}
		});
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
	try{
		$(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			getLeftContent(page, search);
		});
		$(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			getLeftContent(page, search);
		});
		$(document).on('click', '#btn-search-key', function (e) {
			var page = 1;
			var search = $('#search_key').val();
			getLeftContent(page, search);
		});
	
		$(document).on('change', '#search_key', function (e) {
			var page = 1;
			var search = $('#search_key').val();
			getLeftContent(page, search);
		});
		$(document).on('enterKey', '#search_key', function (e) {
			var page = 1;
			var search = $('#search_key').val();
			getLeftContent(page, search);
		});
		$(document).on('click', '#btn-save', function (e) {
			var organization_cd = $("#organization_cd").val();
			if (organization_cd == "") {
				jMessage(79, function (r) {
					if (r && _validate($('body'))) {
						save();
					}
				});
			} else {
				jMessage(1, function (r) {
					if (r && _validate($('body'))) {
						save();
					}
				});
			}
		});
		$(document).on('click', '.list-search-child', function (e) {
			$('.list-search-child').removeClass('active');
			$(this).addClass('active');
			$('#organization_cd').val($(this).attr('id'));
			$('#organization_cd').change();
		});
		$(document).on('change', '#organization_cd', function (e) {
			var organization_cd = $('#organization_cd').val();
			getRightContent(organization_cd);
		});
		$(document).on('click', '#btn-delete', function (e) {
			e.preventDefault();
			var organization_cd = $('#organization_cd').val();
			jMessage(3, function (r) {
				if (r) {
					deleteData(organization_cd);
				}
			});
		});
		$(document).on('click', '#btn-add-new', function (e) {
			jMessage(5, function () {
				$('select').val('');
				$('#organization_cd').focus();
				$('#arrange_order').val("");
				$('.list-search-child').removeClass('active');
			})
		});
		$(document).on('click', '#btn-back', function () {
			// window.location.href = '/dashboard';
			if (_validateDomain(window.location)) {
				window.location.href = '/dashboard';
			} else {
				jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
			}
		});
	}catch(e){
		alert('initEvents:'+e.message);
	}
}

/**
* getLeftContent
* 
* @author      :   datnt - 2018/08/28 - create
* @author      :   
* @return      :   null
* @access      :   public
* @see         :   init
*/
function getLeftContent(page, search) {
	try {
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/m0140/leftcontent',
			dataType: 'html',
			loading: true,
			data: { current_page: page, search_key: search },
			success: function (res) {
				if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
					$('#leftcontent .inner').empty();
					$('#leftcontent .inner').html(res);
					var heneed = $('.calHe').innerHeight();
					var hetru = $('.calHe2').innerHeight();
					var heit = heneed - hetru - 110;
					var heme = $('.list-search-content').innerHeight();
					if (heme > heit) {
						$('.list-search-content').addClass('scroll');
					}
					$('#search_key').focus();
					$('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
					$('.list-search-father').tooltip();
					_formatTooltip();
				}
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}
/**
 * getLeftContent
 * 
 * @author      :   datnt - 2018/08/28 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRightContent(organization_cd) {
	try {
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/m0140/rightcontent',
			dataType: 'html',
			loading: true,
			data: { organization_cd: organization_cd },
			success: function (res) {
				var rightcontent = $('#rightcontent .inner');
				rightcontent.empty();
				rightcontent.append(res);
				active_left_menu();
				app.jTableFixedHeader();
				$.formatInput();
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
function save() {
	var data = getData(_obj);
	$.ajax({
		type: 'post',
		data: JSON.stringify(data),
		url: '/master/m0140/save',
		loading: true,
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					//
					jMessage(2, function (r) {
						// location.href='/master/m0140';
						if (_validateDomain(window.location)) {
							window.location.href = '/master/m0140';
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

/**
 * save
 * 
 * @author      :   namnb - 2018/08/16 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function deleteData(organization_cd) {
	try {
		var data = getData(_obj);
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/m0140/delete',
			dataType: 'json',
			loading: true,
			data: { organization_cd: organization_cd },
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(4, function (r) {
							$('.organization_cd').attr('value', '');
							$('select').val('');
							$('.list-search-child').removeClass('active');
							$('#arrange_order').val('');
							// 
							var page = $('#leftcontent').find('.active a').attr('page');
							var search = $('#search_key').val();
							getLeftContent(page, search);
							$('#organization_cd').focus();

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
		alert('save' + e.message);
	}
}
/**
 * active_left_menu
 * 
 * @author      :   namnb - 2018/08/16 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function active_left_menu() {
	var organization_cd = $('#organization_cd').val();
	$('.list-search-child').removeClass('active');
	$('.list-search-child').each(function () {
		_this = $(this);
		if (_this.attr('id') == organization_cd) {
			_this.addClass('active');
		}
	})
}