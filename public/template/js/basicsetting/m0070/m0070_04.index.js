
/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2024/03
 * 作成者          :   trinhdt
 *
 * @package     :   MODULE EMPLOYEE
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   2.1
 * ****************************************************************************
 */
var _obj_tab_4 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'detail':  {
        'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'class' },
            'work_history_kbn': { 'type': 'text', 'attr': 'class' },
            'check_new_row': { 'type': 'text', 'attr': 'class' },
        }
    },
    'list1_tab_04': {
        'attr': 'list', 'item': {
            'numeric_value1': { 'type': 'text', 'attr': 'class' },
            'item_id': { 'type': 'text', 'attr': 'class' },
            'date_from': { 'type': 'text', 'attr': 'class' },
            'date_to': { 'type': 'text', 'attr': 'class' },
            'text_item': { 'type': 'text', 'attr': 'class' },
            'select_item': { 'type': 'select', 'attr': 'class' },
            'number_item': { 'type': 'text', 'attr': 'class' },
            'work_history_kbn': { 'type': 'text', 'attr': 'class' },
            'check_new_row': { 'type': 'text', 'attr': 'class' },
        }
    }   
}
$(document).ready(function () {
	try {
        // new AutoNumeric.multiple(
        //     ['.number_item'],
        //     {
        //         styleRules: AutoNumeric.options.styleRules.positiveNegative,
        //         minimumValue: -99999999.99,
        //         maximumValue: 99999999.99,
        //         decimalPlaces: 2,
        //     }
        // );
		initEvents4();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents4() {
	try {
		//btn-add-row
        $(document).on('click', '.btn-add-new-row-15', function () {
            try {
                var row = $(this).closest('.table-responsive-right').find('.detail-sub:first').clone();
                row.find('.p-item input').val('');
                row.find('.detail_no').val('');
                row.find('.p-item select option').removeAttr('selected');
                row.find('.p-item select option:eq(0)').attr('selected');
                row.find('.date').removeClass('boder-error');
                row.find('.textbox-error').remove();
                row.addClass('tr-bottom');
                $(this).closest('.table-responsive-right').find('.detail-content').prepend(row);
                $.formatInput();
                $(this).closest('.table-responsive-right').find('.no').each(function (i, t) {
                    $(this).empty().html(i + 1);
                    $(this).closest('.detail-sub').find('.check_new_row').attr('value',i+1);
                });
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-remove-row
		$(document).on('click', '.btn-remove-row-15', function () {
			try {
                if ($(this).closest('.detail-content').find('.detail-sub').length == 1) {
					$(this).closest('.detail-sub').find('.p-item input').val('');
					$(this).closest('.detail-sub').find('.detail_no').val('');

                    $(this).closest('.detail-sub').find('.select_item').val('').trigger('change');
                } else {
                    if (!$(this).closest('.detail-sub').prev().length) {
                        $(this).closest('.detail-sub').next().removeClass('tr-head');
                    }
                    $(this).closest('.detail-sub').addClass('remote-row');
                    $(this).closest('.table-responsive-right').find('.detail-sub').not('.remote-row').each(function (i, t) {
                        $(this).find('.no').empty().html(i + 1);
                        $(this).closest('.detail-sub').find('.check_new_row').attr('value',i+1);
                    });
                    $(this).closest('.detail-sub').remove();
                }
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
        $(document).on('blur', '.numeric', function () {
            try {
                //check case -0,000,-0
                if (Number($(this).val().replaceAll(',', '')) === 0 && $(this).val() != '') {
                    $(this).val(0)
                }

                if (!($.isNumeric($(this).val()))) {
                    $(this).val('')
                }
            } catch (e) {
                alert('.d-numeric: ' + e.toString());
            }
        });
	} catch (e) {
		alert('btn-remove-row: ' + e.message);
	}
}

/**
 * saveData
 *
 * @author      :   trinhdt - 2024 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab04() {
    var data = getData(_obj_tab_4);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'POST',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            url: '/basicsetting/m0070/save_04',
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer04(employee_cd);
                        resolve(true)
                        break;
                    // error
                    case NG:
                        if (typeof res['errors'] != 'undefined') {
                            processError(res['errors']);
                        }
                        // resolve(true)
                        break;
                    case 404:
                        resolve(true)
                        break;
                    // Exception
                    case EX:
                        resolve(true)
                        break;
                    default:
                        break;
                }
            },
            error: function(xhr, status, error) {
                temp = temp+1
                reject(error);
            }
        });
    })
}

/**
 * getLeftContent
 *
 * @author      :   trinhdt - 2024 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer04(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_04',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
				$('.tab-content').find('#tab15').remove();
                $('.tab-content').append(res);
                $.formatInput();
                // _autoNumeric();
                activeHref()
			}
		});
	} catch (e) {
		alert('get refer content: ' + e.message);
	}
}