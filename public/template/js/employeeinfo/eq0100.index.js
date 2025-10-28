/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */

var _obj = {
	'group_item': {
		'attr': 'list', 'item': {
			'group_cd': { 'type': 'text', 'attr': 'class' },
			'numeric_value2': { 'type': 'text', 'attr': 'class' },
			'field_cd': { 'type': 'text', 'attr': 'class' },
			'field_val': { 'type': 'text', 'attr': 'class' },
			'field_and_or': { 'type': 'text', 'attr': 'class' },
			'date_from': { 'type': 'text', 'attr': 'class' },
			'date_to': { 'type': 'text', 'attr': 'class' },
			'numeric_from': { 'type': 'text', 'attr': 'class' },
			'numeric_to': { 'type': 'text', 'attr': 'class' },
			'organization_cd1': { 'type': 'text', 'attr': 'class' },
			'organization_cd2': { 'type': 'text', 'attr': 'class' },
			'organization_cd3': { 'type': 'text', 'attr': 'class' },
			'organization_cd4': { 'type': 'text', 'attr': 'class' },
			'organization_cd5': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _obj_1 = {
	'items': {
		'attr': 'list', 'item': {
			'group_cd': { 'type': 'text', 'attr': 'class' },
			'field_cd': { 'type': 'text', 'attr': 'class' },
			'field_val': { 'type': 'text', 'attr': 'class' },
			'field_val_json': { 'type': 'text', 'attr': 'class' },
			'field_and_or': { 'type': 'text', 'attr': 'class' },
		}
	},
};



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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		tableContent();
		$('.employee_cd').focus();
		_formatTooltip();
		jQuery.initTabindex();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {

		$(document).on('click', '.pagination li a.page-link:not(.pagging-disable)', function (e) {
			//alert(1);
			e.preventDefault();
			var li = $(this).closest('li'),
				page = li.find('a').attr('page');
			$('.pagination li').removeClass('active');
			li.addClass('active');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
			search(page, cb_page);

		});

		$(document).on('click', '#btn-search', function (e) {
			var page = 1;
			var page_size = 20;
			search(page, page_size);
		});


		$(document).on('click', '#output_excel', function () {
			try {
				var data = {};
				screen_cd = [];
				employee = [];
				$(".chk-item:checked").each(function() {
					screen_cd.push({ 'screen_cd': $(this).val()});
				});
				parent.$("#myTable .chk-item:checked").each(function() {
					employee_cd = $(this).closest('tr').attr('employee_cd')
					employee.push({ 'emp_cd': employee_cd});
				});
				data.screen = screen_cd;
				data.employee = employee;
				data.type = 1;
				exportCSV(data)
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#btn-delete', function (e) {
			try {
				countChecked = $(".chk-item:checked").length;
				jMessage(43, function (r) {
					if (r) {
						if (countChecked >= 1) {
							deleteData();
						} else {
							jMessage(18, function (r) {
							});
						}
					}
				});
			} catch (e) {
				alert('#btn-delete' + e.message);
			}
		});

		$(document).on('click', '#btn-back', function (e) {
			try {
				window.location.href    =   '/menu';
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});

		$(document).on('change', '#cb_page', function (e) {
			var li = $('.pagination li.active'),
				page = li.find('a').attr('page');
			var cb_page = $(this).val();
			var cb_page = cb_page == '' ? 20 : cb_page;
			search(page, cb_page);
		});

		$(document).on('change', '#check-all', function () {
			try {
				var checked = $(this).is(':checked');
				if (checked) {
					$('.chk-item:enabled').prop('checked', true);
				}
				else {
					$('.chk-item:enabled').prop('checked', false);
				}
			} catch (e) {
				alert('.ck-all : ' + e.message);
			}
		});
		// check item
		$(document).on('change', '.chk-item', function () {
			try {
				var checked = $('.chk-item:checked').length;
				var all = $('.chk-item').length;
				if (checked == all) {
					$('#check-all').prop('checked', true);
				}
				else {
					$('#check-all').prop('checked', false);
				}
			} catch (e) {
				alert('.ck-all : ' + e.message);
			}
		});

		 //編集
		 $(document).on('click', '.screen_eq0101', function (event) {
			try {
				event.preventDefault();
				var employee_cd = $(this).closest('tr').attr('employee_cd');
				var data = {
                    'employee_cd'     		:   employee_cd
				,	'from'					:	'eq0100'
				,	'save_cache'			:	'true'				// save cache status
				,	'screen_id'				:	'eq0100_eq0101'		// save cache status
	        	};
				_redirectScreen('/employeeinfo/eq0101',data,true);
			} catch (e) {
				console.log('err: ' + e.message);
			}
		});
		//show popup item_setting
		$(document).on('click', '#btn-print-employee', function (e) {
			// var group_cd_1on1 = $('#group_cd').val();
			// var fiscal_year	= $('#fiscal_year').val();
			$('body').css('overflow', 'hidden')
			parent.data_screen 	= getData(_obj)
			
			showPopup('/common/popup/eq0100_list', {
				width: '480px',
				height: '620px'
			}, function () { });
		});
		//show popup item_setting
		$(document).on('click', '#btn-show', function (e) {
			try {
				var option = {};
				var width = $(window).width();
				if ((width <= 1368) && (width >= 1300)) {
					option.width = '55%';
					option.height = '76%';
				} else {
					if (width <= 1300) {
						option.width = '82%';
						option.height = '60%';
					} else {
						option.width = '770px';
						option.height = '620px';
					}
				}
				showPopup('/common/popup/eq0100',option,function () { });
			} catch (e) {
				alert('#btn-set-bith event: ' + e.message);
			}
		});
		$(document).on('keydown', '.page-link', function (event) {
            try {
                if (!event.shiftKey && event.keyCode == 9) {
                    event.preventDefault();
                    $('#cb_page').focus();
                }
            } catch (e) {
                alert('#btn-search:' + e.message);
            }
        })
		$(document).on('keydown', '#cb_page', function (event) {
            try {
                if (event.shiftKey && event.keyCode == 9) {
                    event.preventDefault();
                    $('.pagination a:not(.pagging-disable)').focus();
                }
            } catch (e) {
                alert('#btn-search:' + e.message);
            }
        })
		//btn-clear
		$(document).on('click', '#btn-clear', function (event) {
            try {
                $('.group-search').empty();
            } catch (e) {
                alert('#btn-search:' + e.message);
            }
        })
		//btn-remove-row
		$(document).on('click', '.btn-remove-row-popup', function () {
			try {
				if (!$(this).closest('.row').prev().length) {
					$(this).closest('.row').next().removeClass('border-row');
				}
				$(this).closest('.row').addClass('remove-row');
				$(this).closest('.group-search').find('.row').not('.remove-row').each(function (i, t) {
					$(this).find('.group_item').find('.group_cd').attr('value',i+1);
				});
				$(this).closest('.row').remove();
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});

		// check item
		$(document).on('keydown', '.date_to, .date_from', function () {
			try {
				if ($(this).hasClass('boder-error')) {
					// $(this).closest('.date_input').find('input').removeClass('boder-error');
					$(this).closest('.date_input').find('.textbox-error').remove();
				}
			} catch (e) {
				alert('.ck-all : ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
 * search
 *
 * @author  :   tuantv - 2018/08/24 - create
 * @author  :
 *
 */
function search(page, page_size) {
	// send data to post
	if (typeof page == 'undefined') {
		var page = 1;
	}
	if (typeof page_size == 'undefined') {
		var page_size = 20;
	}
	var data 	= getData(_obj);
	var data_1 = {};
	var list = []

	data.data_sql.group_item.forEach(function (row, index) {
		if (row.numeric_value2 == 1 && row.field_val != '') {
			list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val': row.field_val, 'field_val_json':'','field_and_or': row.field_and_or });
		}
		if (row.numeric_value2 == 2) {
			list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValue(row.numeric_from, row.numeric_to), 'field_val_json':'', 'field_and_or': row.field_and_or });
		}
		if (row.numeric_value2 == 3) {
			list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValue(row.date_from, row.date_to), 'field_val_json':'', 'field_and_or': row.field_and_or });
		}
		if (row.numeric_value2 == 4 && row.field_val != '') {
			if (row.field_cd == 24) {
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValueSelect1(row.field_val), 'field_val_json':'', 'field_and_or': row.field_and_or });
			} else	{
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValueSelect(row.field_val), 'field_val_json':'', 'field_and_or': row.field_and_or });
			}
		}
		if (row.numeric_value2 == 5 && row.organization_cd1 != '') {
			var list_org1 = getOrganization(row.organization_cd1);
			var list_org2 = getOrganization(row.organization_cd2);
			var list_org3 = getOrganization(row.organization_cd3);
			var list_org4 = getOrganization(row.organization_cd4);
			var list_org5 = getOrganization(row.organization_cd5);
			var field_val = getSubGroup(list_org1,list_org2,list_org3,list_org4,list_org5);
			list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  '', 'field_val_json':  field_val, 'field_and_or': row.field_and_or });
		}

	});
	data_1.items = list
	data_1.page_size = page_size;
	data_1.page = page;

	$.ajax({
		type: 'POST',
		url: '/employeeinfo/eq0100/search',
		// dataType: 'html',
		loading: true,
		data: JSON.stringify(data_1),
		success: function (res) {
			switch (res['status']) {
				case 201:
					_clearErrors(1);
					console.log(res['errors']);
					processError(res['errors']);
					break;
				default:
					_clearErrors(1);
					$('.group-search').find('.date').removeClass('boder-error')
					$('#result').empty();
		 			$('#result').append(res);
		 			tableContent();
			 		_formatTooltip();
		 			app.jSticky();
		 			app.jTableFixedHeader();
			 		jQuery.initTabindex();
			 		unFixedWhenSmallScreen();
					break;
			}
		},
		error: function (xhr) {
			console.log(xhr)
		}
	});
}

/**
 * table Content
 *
 * @author      :  tuantv - 2018/11/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function tableContent() {
	$(".wmd-view-topscroll").scroll(function () {
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function () {
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function () {
		fixWidth();
	});

}
function fixWidth() {
	var w = $('.wmd-view .table').outerWidth();
	var f = $('.table-group li:last').outerWidth();
	$(".wmd-view-topscroll .scroll-div1").width(w);
	// $(".table-group li:last .fixed").width(f);
}
/**
 * tooltip format
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:	error array ex ['e1','e2']
 */
function _formatTooltip() {
	try {
		$('.text-overfollow').each(function (i) {
			var i = 1;
			var colorText = '';
			var element = $(this)
				.clone()
				.css({ display: 'inline', width: 'auto', visibility: 'hidden' })
				.appendTo('body');

			if (element.width() <= $(this).width()) {
				$(this).removeAttr('data-original-title');
			}
			element.remove();
		});
	} catch (e) {
		alert('format tooltip ' + e.message);
	}
}

/**
 * value format date ang number
 *
 * @author  :   trinhdt - create
 * @author  :
 * @param 	:	
 */
function _formatValue(from, to) {
	try {
		var string = _.padStart(from.toString(), 10, '0') + _.padStart(to.toString(), 10, '0')
		return string
	} catch (e) {
		alert('format tooltip ' + e.message);
	}
}

/**
 * value format select multiselect
 *
 * @author  :   trinhdt - create
 * @author  :
 * @param 	:	
 */
function _formatValueSelect(select) {
	if (select.includes(",")) {
		var str = select.split(",");
		var str_sub = '';
		str.forEach(function (res) {
			str_sub = str_sub + _.padStart(res, 10, '0')
		});
	} else {
		var str_sub = _.padStart(select, 10, '0')
	}
	return str_sub;
}

/**
 * value format select multiselect filed_cd = 24
 *
 * @author  :   trinhdt - create
 * @author  :
 * @param 	:	
 */
function _formatValueSelect1(select) {
	if (select.includes(",")) {
		var str = select.split(",");
		var str_sub = '';
		str.forEach(function (res) {
			str_sub = str_sub + _.padStart(res, 20, '0')
		});
	} else {
		var str_sub = _.padStart(select, 20, '0')
	}
	return str_sub;
}

/**
 * get Organization
 *
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getOrganization(organization_cd) {
	let list = [];
	if (organization_cd.includes(",")) {
		var str = organization_cd.split(",");
		str.forEach(function (res) {
			var str_sub = res.split("|");
			//
			if (str_sub.length > 1) {
				list.push({
					organization_cd_1: str_sub[0] == "undefined" ? "" : str_sub[0],
					organization_cd_2: str_sub[1] == "undefined" ? "" : str_sub[1],
					organization_cd_3: str_sub[2] == "undefined" ? "" : str_sub[2],
					organization_cd_4: str_sub[3] == "undefined" ? "" : str_sub[3],
					organization_cd_5: str_sub[4] == "undefined" ? "" : str_sub[4],
				});
			}
		});
	} else {
		var str_sub = organization_cd.split("|");
		//
		if (str_sub.length > 1) {
			list.push({
				organization_cd_1: str_sub[0] == "undefined" ? "" : str_sub[0],
				organization_cd_2: str_sub[1] == "undefined" ? "" : str_sub[1],
				organization_cd_3: str_sub[2] == "undefined" ? "" : str_sub[2],
				organization_cd_4: str_sub[3] == "undefined" ? "" : str_sub[3],
				organization_cd_5: str_sub[4] == "undefined" ? "" : str_sub[4],
			});
		}
	}
	return list;
}

/**
 * get group in group sub
 *
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getSubGroup(org1,org2,org3,org4,org5) {
    try {
		if (org2.length == 0) {
			return org1;
		} else {
			list_all = []
			list2 = []
			list_no = []
			
			org1.forEach(function (res1) {
				lv1 = res1.organization_cd_1
				org2.forEach(function (res2) {
					if (lv1 == res2.organization_cd_1) {
						list2.push(res2);
					} else {
						list_no.push(res1);
					}
				});
			});
			list_all.push(list2);
	
			list3 = []
			list2.forEach(function (res) {
				lv1 = res.organization_cd_1
				lv2 = res.organization_cd_2
				org3.forEach(function (res3) {
					if (lv1 == res3.organization_cd_1 && lv2 == res3.organization_cd_2) {
						list3.push(res3);
					} else {
						list_no.push(res);
					}
				});
			});
			if (list3.length > 0) {
				list_all = []
				list_all.push(list3);
			}
	
			list4 = []
			list3.forEach(function (res) {
				lv1 = res.organization_cd_1
				lv2 = res.organization_cd_2
				lv3 = res.organization_cd_3
				org4.forEach(function (res4) {
					if (lv1 == res4.organization_cd_1 && lv2 == res4.organization_cd_2 && lv3 == res4.organization_cd_3) {
						list4.push(res4);
					} else {
						list_no.push(res);
					}
				});
			});
			if (list4.length > 0) {
				list_all = []
				list_all.push(list4);
			}
	
			list5 = []
			list4.forEach(function (res) {
				lv1 = res.organization_cd_1
				lv2 = res.organization_cd_2
				lv3 = res.organization_cd_3
				lv4 = res.organization_cd_4
				org5.forEach(function (res5) {
					if (lv1 == res5.organization_cd_1 && lv2 == res5.organization_cd_2 && lv3 == res5.organization_cd_3 && lv3 == res5.organization_cd_4) {
						list5.push(res5);
					} else {
						list_no.push(res);
					}
				});
			});
			if (list5.length > 0) {
				list_all = []
				list_all.push(list5);
			}
	
			var result = [...new Set(list_no.map(i=>JSON.stringify(Object.fromEntries(
				Object.entries(i).sort(([a],[b])=>a.localeCompare(b))))
			))].map(JSON.parse)

			org1_id = []
			list_all[0].forEach(function (res) {
				org1_id.push(res.organization_cd_1);
			});

			result_final = []
			result.forEach(function (res) {
				if (res.organization_cd_2 == '' && org1_id.includes(res.organization_cd_1)) {
					// remove item
				} else {
					result_final.push(res);
				}
			});

			org1_id = []
			result_final.forEach(function (res) {
				org1_id.push(res.organization_cd_1);
			});

			result_final_1 = []
			result_final.forEach(function (res) {
				if (res.organization_cd_2 == '' && org1_id.includes(res.organization_cd_1)) {
					// remove item
				} else {
					result_final_1.push(res);
				}
			});
			const list = [...result_final_1, ...list_all[0]];
			return list;
		}
    } catch (e) {
        console.log('getSubGroup:' + e.message);
    }
}

/**
 * exportCSV
 *
 * @author      :  trinhdt - 2024/04
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV(data) {
    try {
        data.table_key = 23;
		var data 	= getData(_obj);
		var data_1 = {};
		var list = []

		data.data_sql.group_item.forEach(function (row, index) {
			if (row.numeric_value2 == 1 && row.field_val != '') {
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val': row.field_val, 'field_val_json':'','field_and_or': row.field_and_or });
			}
			if (row.numeric_value2 == 2 && (row.numeric_from != '' || row.numeric_to != '')) {
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValue(row.numeric_from, row.numeric_to), 'field_val_json':'', 'field_and_or': row.field_and_or });
			}
			if (row.numeric_value2 == 3 && (row.date_from != '' || row.date_to != '')) {
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValue(row.date_from, row.date_to), 'field_val_json':'', 'field_and_or': row.field_and_or });
			}
			if (row.numeric_value2 == 4 && row.field_val != '') {
				if (row.field_cd == 24) {
					list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValueSelect1(row.field_val), 'field_val_json':'', 'field_and_or': row.field_and_or });
				} else	{
					list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  _formatValueSelect(row.field_val), 'field_val_json':'', 'field_and_or': row.field_and_or });
				}
			}
			if (row.numeric_value2 == 5 && row.organization_cd1 != '') {
				var list_org1 = getOrganization(row.organization_cd1);
				var list_org2 = getOrganization(row.organization_cd2);
				var list_org3 = getOrganization(row.organization_cd3);
				var list_org4 = getOrganization(row.organization_cd4);
				var list_org5 = getOrganization(row.organization_cd5);
				var field_val = getSubGroup(list_org1,list_org2,list_org3,list_org4,list_org5);
				list.push({ 'group_cd': row.group_cd, 'field_cd': row.field_cd, 'field_val':  '', 'field_val_json':  field_val, 'field_and_or': row.field_and_or });
			}

		});
		data_1.items = list
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0100/export',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        csv_name = employee_information_output.replace(/\s/g, '')+'.csv';
                        //
                        var filedownload = res['FileName'];
                        if (filedownload != '' && filedownload != '[]') {
                            downloadfileHTML('/download/' + filedownload, csv_name, function () {
                                //
                            });
                        } else {
                            jMessage(21);
                        }
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
        alert('exportCSV: ' + e.message);
    }
}

/**
 * loadOrganization with group_item not row
 *
 * @author		:	longvv - 2018/08/23 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadOrganization(data = {}, param, this1) {
	try {
		var organization_typ = 2;
		if (typeof data.organization_typ !== 'undefined') {
			organization_typ = parseInt(data.organization_typ) + 1;
		}
		//
		$.ajax({
			type: 'POST',
			url: '/common/loadOrganization',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if (param == 'multiselect') {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							var val = res['rows'][i]['organization_cd_1'] + '|' + res['rows'][i]['organization_cd_2'] + '|' + res['rows'][i]['organization_cd_3'] + '|' + res['rows'][i]['organization_cd_4'] + '|' + res['rows'][i]['organization_cd_5'];
							html += '<option value="' + val + '">' + res['rows'][i]['organization_nm'] + '</option>';
						}
						//
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).empty();
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).append(html);
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).multiselect('rebuild');
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).trigger('change');
					} else {
						('.row').find
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							var val = res['rows'][i]['organization_cd_1'] + '|' + res['rows'][i]['organization_cd_2'] + '|' + res['rows'][i]['organization_cd_3'] + '|' + res['rows'][i]['organization_cd_4'] + '|' + res['rows'][i]['organization_cd_5'];
							html += '<option value="' + val + '">' + res['rows'][i]['organization_nm'] + '</option>';
						}
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).empty();
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).append(html);
						$(this1).closest('.group_item').find('.organization_cd' + organization_typ).trigger('change');
					}
				}
			}
		});
	} catch (e) {
		alert('loadOrganization' + e.message);
	}
}