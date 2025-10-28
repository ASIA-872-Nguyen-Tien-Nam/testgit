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
var _obj_tab_07 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'list_tab_07': {
		'attr': 'list', 'item': {
			'detail_no_tab07'                   : { 'type': 'text', 'attr': 'class' },
            'commuting_method'                  : { 'type': 'text', 'attr': 'id' },
			'commuting_distance'                : { 'type': 'numeric', 'attr': 'id' },
			'drivinglicense_renewal_deadline'   : { 'type': 'text', 'attr': 'id' },
			'commuting_method_detail'           : { 'type': 'text', 'attr': 'id' },
            'departure_point'                   : { 'type': 'text', 'attr': 'id' },
            'arrival_point'                     : { 'type': 'text', 'attr': 'id' },
            'commuter_ticket_classification'    : { 'type': 'text', 'attr': 'class' },
            'commuting_expenses'                : { 'type': 'text', 'attr': 'class' },           
		}
	}
}
$(document).ready(function () {
	try {
		initEvents7();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents7() {
	try {
        // //add-row
		$(document).on('click', '#add_row_data_08', function () {
            try {
                var index_8 = 1
                index_8 = parseInt($('.row_display').eq(-1).find('.label_number_id_8').text())
                if (isNaN(index_8)) {
                    index_8 = 0
                }
                $('.table_data_08').append($('.row_data_08').clone())
                $('.row_data_08').eq(-1).find('.label_number_id_8').text(index_8 + 1)
                $('.row_data_08').eq(-1).attr('hidden', false)
                $('.row_data_08').eq(-1).addClass('row_display')
                $('.row_data_08').eq(-1).removeClass('row_data_08')
                index_8 = index_8 + 1
                $.formatInput()
            } catch (e) {
                alert('btn-add-row: ' + e.message);
            }
        });
        
        //remove-row
        $(document).on('click', '.btn-remove_08', function (e) {
            var i = $(this).closest('.table_data_08').children('.row_display').length - 1
            $(this).closest('.row').closest('.row').remove()
            resetIndex(i);
            for (let j = 0; j <= i; j++) {
                $('.row_display:eq(' + j + ')').find('.label_number_id_8').text(j)
            }
            if ($("#tab8 .table_data_08 .row_display").length == 0) {
                $('#add_row_data_08').trigger('click')
            }
            calculateTotalExpenses();
        })
        //
        $(document).on('change', '.vehicle_select', function () {
            var optionSelected = $("option:selected", this);
            $(this).closest('.row').find('.block_append_8').remove()
            if (optionSelected.val() == 2 || optionSelected.val() == 7) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_1').children().clone())
            } else if (optionSelected.val() == 1 || optionSelected.val() == 5) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_2').children().clone())
            } else if (optionSelected.val() == 4) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_5').children().clone())
            } else if (optionSelected.val() == 8) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_6').children().clone())
            }
            else if (optionSelected.val() == 6) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_4').children().clone())
            }
            else if (optionSelected.val() == 3) {
                $(this).closest('.row_append_08').find('.block_remove_08').remove()
                $(this).closest('.row_append_08').append($('.vehicle_hidden_3').children().clone())
            }
            $(this).closest('.row').find('.vehicle_hidden_1').attr('hidden', false)
            $.formatInput()
        });

        $(document).on('blur', '.commuting_expenses, .commuter_ticket_classification',function() {
            calculateTotalExpenses(); 
        });

	} catch (e) {
		alert('initEvents7: ' + e.message);
	}
}

/**
 * resetIndex
 *
 * @author      :   Quanlh - 2024/04/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function resetIndex(index) {
    $("#tab8 #table-data tbody tr").each(function (i,e) {
        if ($(this).find('.no span').text() * 1 > index) {
            $(this).find('.no span').text(i + 1)
        }
    })
}

/**
 * saveDataTab07
 *
 * @author      :   Quanlh - 2024/04/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab07() {
    var data = getData(_obj_tab_07);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab07',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer07(employee_cd);
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
 * Refer07
 *
 * @author      :   Quanlh - 2024/04/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer07(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_07',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab8').html(res);
                $('.tab-content').find('#tab8').removeClass('show active');
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer07: ' + e.message);
	}
}

function fullWidthToHalfWidth(str) {
    return str.replace(/[０-９]/g, function(c) {
        return String.fromCharCode(c.charCodeAt(0) - 0xFEE0);
    });
}

/**
 * Sum total Expenses
 *
 * @author      :   Quanlh - 2024/04/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function calculateTotalExpenses() {
    var totalExpenses = 0;
    $('.list_tab_07').each(function() {
        var expenseInput = $(this).find('.commuting_expenses');
        if (expenseInput.length > 0) {
            var expenseInputValue = expenseInput.val().replace(/,/g, '');
            expenseInputValue = fullWidthToHalfWidth(expenseInputValue);
            var expense = parseFloat(expenseInputValue) || 0; // get commuting_expenses
            var classificationSelect = $(this).find('.commuter_ticket_classification');
            var ticketClassification = parseFloat(classificationSelect.find('option:selected').attr('numeric_value1')) || 1; // get numeric_value1   
            var result = expense / ticketClassification; // sum
            totalExpenses += result; // sum total
        }
    });
    
    totalExpenses = totalExpenses.toFixed();
    // update sum total
    $('#total_expenses').val(totalExpenses.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
}
