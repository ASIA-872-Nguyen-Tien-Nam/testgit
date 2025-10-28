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
		$(".multiselect").multiselect({
			onChange: function () {
				$.uniform.update();
			},
		});
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

function initEvents() {
	try {
		//checkbox_all
		$(document).on('change', '#check-all', function () {
			try {
				if ($(this).is(':checked') == true && $(this).prop('checked')) {
					$('.chk-item').not(":disabled").prop('checked', true);
				}
				else {
					$('.chk-item').not($(this)).prop('checked', false);
				}
			} catch (e) {
				alert('.btn-check-all' + e.message)
			}
		})
		//checkbox_input
		$(document).on('change', '.chk-item', function (e) {
			try {
				var checked = $('.chk-item' + ':checked').length;
				var total_chk = $('.chk-item').not(":disabled").length;
				$('#check-all').prop('checked', false);
				if (total_chk == checked) {
					$('#check-all').prop('checked', true);
				} else {
					$('#check-all').prop('checked', false);
				}
			} catch (e) {
				alert('checkbox_input: ' + e.message);
			}
		});
		$(document).on('click', '#add_data_row_02', function () {
			try {
				var number_row = Number($('.table_data_02').find('.no:last').text()) + 1
				$('.table_data_02 .and-or-gr').removeAttr('style');
				var clone = $('.condition-row:first').clone();
				clone.find(".multiselect").multiselect();
				clone.find('.group_item').removeClass('group_item');
				clone.find(".and-or-gr").attr('style', 'display: none;');
				clone.find(".multi-select-full").find('.my_container:nth-child(3)').remove();
				clone.find('.group_item_4').find('.multi-select-full[check="check"]').removeAttr('check');
				$('.table_data_02').append(clone)
				// $('.condition-row:first').eq(-1).removeClass('data_row_02')
				$('.button_add_02_div').eq(-1).css('display','none')
				$('.table_data_02').find('.mode_item:last').focus();
				$('.table_data_02').find('.no:last').empty().html(number_row);
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#btn-add-search', function () {
			try {
				length_row = parent.$('.group-search .row').length;
				if(length_row == 0) {
					var row = '<div class="row"></div>'; 
				} else {
					var row = '<div class="row border-row"></div>'; 
				}
				parent.$('.group-search').append(row)
				var data = $('.group_item').clone();
				var and_or = $('.and-or-val').clone();
				var remove = $('.remove').clone();
				and_or.css('display', 'block');
				data.find('.select_input .multi-select-full[check!="check"]').remove();
				data.removeAttr('style');
				data.each(function (i, t) {
					parent.$('.group-search .row:last').append($(this));
					if (i == data.length - 1) {
						//
					} else {
						parent.$('.group-search .row:last').append(and_or[i]);
					}
				});
				parent.$('.group-search .row:last').find('.group_cd').attr('value',length_row + 1);
				parent.$('.group-search .row:last').append(remove[0]);
				parent.$('.group-search .row:last .group_item:first').find('.field_and_or').attr('value','');
				//
				parent.$('.group-search .row:last .multiselect').multiselect();
				parent.$('.group-search .row:last .multi-select-full').find('.my_container:nth-child(3)').remove();
				parent.$.formatInput()
				parent.$.colorbox.close();
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('change', '.mode_item', function () {
			try {
				$(this).closest('.data_row_02').find('.group_item_4').find('.multi-select-full').removeAttr('check');
				$(this).closest('.data_row_02').find('.group_item_3').find('.date_from').removeClass('date_from_4');
				$(this).closest('.data_row_02').find('.group_item_3').find('.date_to').removeClass('date_to_4');
				$(this).closest('.data_row_02').find('.group_item_3').find('.date_from').removeClass('date_from_32');
				$(this).closest('.data_row_02').find('.group_item_3').find('.date_to').removeClass('date_from_32');
				$(this).closest('.data_row_02').find('.group_item_2').find('.numeric_from').removeClass('numeric_from_5');
				$(this).closest('.data_row_02').find('.group_item_2').find('.numeric_to').removeClass('numeric_to_5');
				$(this).closest('.data_row_02').find('.group_item_2').find('.numeric_from').removeClass('numeric_from_31');
				$(this).closest('.data_row_02').find('.group_item_2').find('.numeric_to').removeClass('numeric_to_31');
				var option = $('option:selected', this).attr('tag');
				var label = $('option:selected', this).text();
				var val = $('option:selected', this).val();
				if (option == '1') {
					$(this).closest('.row').find('.group_item_1').addClass('group_item');
					$(this).closest('.row').find('.group_item_2').removeClass('group_item');
					$(this).closest('.row').find('.group_item_3').removeClass('group_item');
					$(this).closest('.row').find('.group_item_4').removeClass('group_item');
					$(this).closest('.row').find('.group_item_5').removeClass('group_item');
					$(this).closest('.row').find('.title').empty().html(label);
				} else if(option == '2') {
					$(this).closest('.row').find('.group_item_2').addClass('group_item');
					$(this).closest('.row').find('.group_item_2 .numeric_from').addClass('numeric_from_' + val);
					$(this).closest('.row').find('.group_item_2 .numeric_to').addClass('numeric_to_' + val);
					$(this).closest('.row').find('.group_item_1').removeClass('group_item');
					$(this).closest('.row').find('.group_item_3').removeClass('group_item');
					$(this).closest('.row').find('.group_item_4').removeClass('group_item');
					$(this).closest('.row').find('.group_item_5').removeClass('group_item');
					$(this).closest('.row').find('.title').empty().html(label);
				} else if(option == '3') {
					$(this).closest('.row').find('.group_item_3').addClass('group_item');
					$(this).closest('.row').find('.group_item_3 .date_from').addClass('date_from_' + val);
					$(this).closest('.row').find('.group_item_3 .date_to').addClass('date_to_' + val);
					$(this).closest('.row').find('.group_item_2').removeClass('group_item');
					$(this).closest('.row').find('.group_item_1').removeClass('group_item');
					$(this).closest('.row').find('.group_item_4').removeClass('group_item');
					$(this).closest('.row').find('.group_item_5').removeClass('group_item');
					$(this).closest('.row').find('.title').empty().html(label);
				} else if(option == '4') {
					$(this).closest('.row').find('.group_item_4').addClass('group_item');
					$(this).closest('.row').find('.group_item_2').removeClass('group_item');
					$(this).closest('.row').find('.group_item_1').removeClass('group_item');
					$(this).closest('.row').find('.group_item_3').removeClass('group_item');
					$(this).closest('.row').find('.group_item_5').removeClass('group_item');
					$(this).closest('.row').find('.title').empty().html(label);
					$(this).closest('.row').find('.group_item_4').find('.multi-select-full[id_cd=' + val + ']').attr('check','check');
				} else if(option == '5') {
					$(this).closest('.row').find('.org_input').css('display', 'flex');
					$(this).closest('.row').find('.group_item_5').addClass('group_item');
					$(this).closest('.row').find('.group_item_2').removeClass('group_item');
					$(this).closest('.row').find('.group_item_1').removeClass('group_item');
					$(this).closest('.row').find('.group_item_4').removeClass('group_item');
					$(this).closest('.row').find('.group_item_3').removeClass('group_item');
				}
				$(this).closest('.row').find('.field_cd').attr('value', val);
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('change', '.and-or', function () {
			try {
				var label = $('option:selected', this).text();
				$(this).closest('.row').find('.and-or-val span').empty().html(label ?? 'AND');
				$(this).closest('.condition-row').next().find('.field_and_or').attr('value', label ?? 'AND');
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		//btn-remove-row
		$(document).on('click', '.btn-remove-row-popup', function () {
			try {
				length_row = $(this).closest('.table_data_02').find('.condition-row').length
				no_text = $(this).closest('.condition-row').find(".no").text();
				if( length_row == 1) {
					$(this).closest('.table_data_02').find('.condition-row').find('input').val('');
					$(this).closest('.condition-row').find(".and-or-gr").attr('style', 'display: none;');
				} else {
					$(this).closest('.condition-row').addClass('hidden-tr');
					$(this).closest('.table_data_02').find('.condition-row').not('.hidden-tr').each(function (i, t) {
							$(this).find('.no').empty().html(i + 1);
					});
					if (length_row == no_text) {
						$(this).closest('.condition-row').prev().find('.and-or-gr').attr('style', 'display: none;');
					}
					$(this).closest('.condition-row').remove();
				}
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
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
	} catch (e) {
		alert('initEvents: ' + e.message);
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
function exportCSV(data2) {
    try {
     
		var data 	= parent.data_screen;
		data2.table_key = 23;
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
		data2.data_screen = data_1
        //
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0100/export',
            dataType: 'json',
            loading: true,
            data: data2,
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