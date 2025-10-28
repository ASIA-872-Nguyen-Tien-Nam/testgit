/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2023/03/29
 * 作成者          :   viettd@ans-asia.com
 *
 * @package     	:   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     	:   1.0.0
 * ****************************************************************************
 */
var _obj = {
	'employee_cd': { 'type': 'text', 'attr': 'id' }
	, 'position_cd': { 'type': 'select', 'attr': 'id' }
	, 'job_cd': { 'type': 'select', 'attr': 'id' }
	, 'grade': { 'type': 'select', 'attr': 'id' }
	, 'employee_typ': { 'type': 'select', 'attr': 'id' }
};
//
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
* @author      :   mirai - 2018/06/21 - create
* @author      :
* @return      :   null
* @access      :   public
* @see         :   init
*/
function initialize() {
	try {
		$('.multiselect').multiselect({
			onChange: function () {
				$.uniform.update();
			}
		});
		jQuery.initTabindex();
		$(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();
		//
		$('#myTable th').css({ left: 0, top: 0 });
		//    tableContent();
		_formatTooltip();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
* INIT EVENTS
* @author      :   mirai - 2018/06/21 - create
* @author      :
* @return      :   null
* @access      :   public
* @see         :   init
*/
function initEvents() {
	try {
		// click 社員番号
		// $(document).on('click', '.employee_cd_link', function (e) {
		// 	try {
		// 		e.preventDefault();
		// 		var tr = $(this).parents('tr');
		// 		var employee_cd = tr.find('td:eq(0) .employee_cd').val();
		// 		var html = getHtmlCondition($('.container-fluid'));
		// 		var data = {
		// 			'employee_cd': employee_cd
		// 			, 'html': html
		// 			, 'from': 'q2010'
		// 			, 'save_cache': 'true'		// save cache status
		// 			, 'screen_id': 'q2010_q0071'		// save cache status
		// 		};
		// 		//
		// 		_redirectScreen('/master/q0071', data, true);
		// 	} catch (e) {
		// 		alert('.employee_cd_link: ' + e.message);
		// 	}
		// });

		// change btn_search
		$(document).on('click', '#btn_search', function (e) {
			try {
				e.preventDefault();
				if (_validate()) {
					search(1, 20);
				}
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		// change evaluation_typ
		$(document).on('click', '.page-item:not(.pagging-disable)', function (e) {
			try {
				e.preventDefault();
				if (_validate()) {
					var page_size = $('#cb_page').val();
					var page = $(this).attr('page');
					search(page, page_size);
				}
			} catch (e) {
				alert('page-item: ' + e.message);
			}
		});
		// change evaluation_typ
		$(document).on('change', '#cb_page', function (e) {
			try {
				e.preventDefault();
				if (_validate()) {
					var page_size = $(this).val();
					var page = 1;
					$('.page-item').each(function () {
						if ($(this).hasClass('active')) {
							page = $(this).attr('page');
						}
					});
					search(page, page_size);
				}
			} catch (e) {
				alert('#cb_page: ' + e.message);
			}
		});
		// button ダウンロード
		$(document).on('click', '#btn-item-evaluation-input', function (e) {
			try {
				e.preventDefault();
				if (_validate()) {
					var param = getQ9001Param();
					var url = getModuleScreenName() + '/download';
					$.downloadFileAjax(url, JSON.stringify(param));
				}
			} catch (e) {
				alert('#btn-item-evaluation-input:  ' + e.message);
			}
		});
		// btn-back button click
		$(document).on('click', '#btn-back', function (e) {
			try {
				e.preventDefault();
				var home_url = $('#home_url').attr('href');
				var redirect_flg = $('#redirect_flg').val();
				if (redirect_flg == 1) {
					_backButtonFunction(home_url, true);
				} else {
					_backButtonFunction(home_url);
				}
			} catch (e) {
				alert('#btn-back event:' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
* search
*
* @author		:	viettd - 2018/09/17 - create
* @author		:
* @return		:	null
* @access		:	public
* @see			:	init
*/
function search(page = 1, page_size = 20) {
	try {
		var param = getQ9001Param(page, page_size);
		var url = getModuleScreenName() + '/search';
		// send data to post
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'html',
			loading: true,
			data: JSON.stringify(param),
			success: function (res) {
				$('#result').empty();
				$('#result').append(res);
				// tableContent();
				app.jSticky();
				app.jTableFixedHeader();
				jQuery.initTabindex();
				unFixedWhenSmallScreen();
			}
		});
	} catch (e) {
		alert('search: ' + e.message);
	}
}

/**
 * 
 * @param {Integer} page 
 * @param {Integer} page_size 
 * @returns 
 */
function getQ9001Param(page = 1, page_size = 20) {
	try {
		var data = getData(_obj);
		var param = data['data_sql'];
		var organization = _getOrganizationData();
		param.page_size = page_size;
		param.page = page;
		param = {
			...param,
			...organization
		};
		return param;
	} catch (e) {
		console.log('getQ9001Param: ' + e.message);
	}
}

/**
 * get url from screen
 */
function getModuleScreenName() {
	try {
		let system = $('#system').val();
		let module = '';
		switch (system) {
			case '1':
				module = '/master/q9001';
				break;
			case '2':
				module = '/oneonone/oq9001';
				break;
			case '3':
				module = '/multiview/mq9001';
				break;
			case '4':
				module = '/basicsetting/sq9001';
				break;
			case '5':
				module = '/weeklyreport/rq9001';
				break;
			default:
				module = '/master/q9001';
				break;
		}
		return module;
	} catch (e) {
		console.log('getModuleScreenName: ' + e.message);
	}
}