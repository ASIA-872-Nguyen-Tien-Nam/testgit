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

var _obj_tab_10 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'tr_tab10' : { 
        'attr': 'list', 'item': {
            'employment_contract_no': { 'type': 'text', 'attr': 'id' },
            'contract_no': { 'type': 'text', 'attr': 'id' },
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'start_date': { 'type': 'text', 'attr': 'id' },
            'expiration_date': { 'type': 'text', 'attr': 'id' },
            'contract_renewal_kbn': { 'type': 'text', 'attr': 'id' },
            'reason_resignation': { 'type': 'text', 'attr': 'id' },
            'remarks': { 'type': 'text', 'attr': 'id' },
        }
    },
}

$(document).ready(function () {
	try {
		initEvents10();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents10() {
	try {
        //btn delete
		$(document).on('click', '.btn-remove-row_tab10', function (e) {
            var countRow = $(this).closest('table').find('.tr_tab10').length - 1;
            var block = $(this).closest('tbody');

            if (countRow > 0 ) {
                $(this).closest('tr').remove();
                block.find('.tr_tab10').each(function (i,e) {
                    $(this).find('.no').html(i + 1);
                })
            }else {
                $(this).closest('.col_tab11').remove();
                
                var countBlock = $('#tab11').find('.col_tab11').length;
                var checkBtnAddBlock =  $('#tab11').find('.col_tab11').eq(0).find('#add_block_tab_10_btn').length;
                var row = $('#tab11').find('.add_block_tab_11_hidden #add_block_tab_10_btn').clone();
                
                if (checkBtnAddBlock == 0){
                    $('#tab11').find('.col_tab11').eq(0).find('.full-width').append(row);
                }

                if (countBlock <= 0 ) {
                    $('#add_block_tab_10_btn').trigger('click');
                }
            }
            countTotalContract(block);
        });

        //add row table
        $(document).on('click', '.btn-add-new-row_11', function () {
            try {
                var row = $(this).closest('.table-responsive-right').find('.table-target tr:last').clone();
                var number_row = $(this).closest('.table').find('tbody tr').length + 1
                row.find('.detail_no').val(0);
                row.find('.td-error .textbox-error').html('');
                row.find('.td-error input').removeClass('boder-error');
                row.find('.td-error input').removeClass('td-error');
                row.find('.start_date').val('');
                row.find('.expiration_date').val('');
                row.find('.contract_renewal_kbn').val(0);
                row.find('.reason_resignation').val('');
                row.find('.remarks').val('');
                $(this).closest('.table').append(row);
                $.formatInput();
                $(this).closest('.table').find('tbody tr:last td:first-child').text(number_row);
                $(this).closest('.table').find('tbody tr:last td:first-child input').focus();
                $(this).closest('.table').find('tbody tr:last .focus').focus();
                $(this).closest('.table').find('tbody tr:last .date').val('');
                $(this).closest('.table').find('tbody tr:last').addClass('list_point_kinds');
                countTotalContract($(this));
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
    
        // add block
        $(document).on('click', '#add_block_tab_10_btn', function (e) {
            try {
                $('.add_block_tab_11_table').append($('.add_block_tab_11_hidden').clone())
                var number_row = $(this).closest('#tab11').find('.col_tab11').length + 1;
                $.formatInput('.add_block_tab_11_row');
                $('.add_block_tab_11_row').eq(-1).find('.employment_contract_no').val(number_row)
                $('.add_block_tab_11_row').eq(-1).removeAttr('hidden')
                if (number_row > 1) {
                    $('.add_block_tab_11_row').eq(-1).find('#add_block_tab_10_btn').closest('div').empty();
                    $('.add_block_tab_11_row').eq(-1).find('.border_block').removeClass('hidden')
                }
                $('.add_block_tab_11_row').eq(-1).removeClass('add_block_tab_11_hidden')
                $('.add_block_tab_11_row').eq(-1).removeClass('hidden')
                $('.add_block_tab_11_row').eq(-1).addClass('col_tab11')
            } catch (e) {
                alert('#btn-item-evaluation-input :' + e.message);
            }
        });

        //check not data
        $(document).on('click', '.employment_contract_information_tab_10', function (e) {
            try {
                var length = $('#tab11').find('.col_tab11').length;
                if (length <= 0) {
                    $('#add_block_tab_10_btn').trigger('click');
                }
            } catch (e) {
                alert('#btn-item-evaluation-input :' + e.message);
            }
        });

        //count record
        $(document).on('change', '.start_date , .expiration_date, .reason_resignation, .remarks', function (e) {
            try {
                countTotalContract($(this));
            } catch (e) {
                alert('#btn-item-evaluation-input :' + e.message);
            }
        });
	} catch (e) {
		alert('initEvents10: ' + e.message);
	}
}


/**
 * count total_contract_period and number_of_contract_renewals
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function countTotalContract(index) {
    var countRecord = 0;
    var monthsDiff = 0;

    index.closest('table').find('.tr_tab10').each(function (i,e) {
        var start_date_str  = $(e).find('.start_date').val() ?? '';
        var expiration_date_str  = $(e).find('.expiration_date').val() ?? '';
        var start = start_date_str != '' ? new Date(start_date_str) : null;
        var end = expiration_date_str != '' ? new Date(expiration_date_str) : null;

        if (start && end) {
            var dayMonth = new Date(end.getFullYear(), end.getMonth() + 1, 0).getDate();
            start.setMonth(start.getMonth() + 1);

            if (end.getFullYear() < start.getFullYear()) {
                monthsDiff = 0;
            } else if (end.getFullYear() === start.getFullYear()) {
                if (end.getDate() === dayMonth && start.getDate() === 1 && start.getMonth() == end.getMonth() + 1) {
                    monthsDiff++;
                } else {
                    monthsDiff += end.getMonth() + 1 - start.getMonth();
                    
                    if (end.getDate() == dayMonth && start.getMonth() != end.getMonth() + 1) {
                        monthsDiff++
                    }
                    if (end.getDate() - start.getDate() == -1) {
                        monthsDiff++;
                    }    
                    if (end.getDate() < start.getDate()) {
                        monthsDiff--;
                    }
                }
            } else {
                var year = end.getFullYear() -  start.getFullYear();
                monthsDiff += year*12 - start.getMonth() + end.getMonth() + 1;
                if (end.getDate() < start.getDate()) {
                    monthsDiff--;
                }
                if (end.getDate() == dayMonth && start.getMonth() != end.getMonth() + 1) {
                    monthsDiff++
                }
                if (end.getDate() - start.getDate() == -1) {
                    monthsDiff++;
                }
            }    
        }
        countRecord++;
    })
    monthsDiff = Math.abs(monthsDiff);
    var soThang = monthsDiff % 12;
    var soNam = Math.floor(monthsDiff / 12);
    if ($('#tab11 .language').val() == 2) {
        index.closest('.col_tab11').find('.total_contract_period').val(soNam + ' Year ' + soThang + ' Month');
    }else {
        index.closest('.col_tab11').find('.total_contract_period').val(soNam + '年' + soThang + 'ヵ月');
    }
    index.closest('.col_tab11').find('.number_of_contract_renewals').val(countRecord);
}


/**
 * saveDataTab10
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab10() {
    var data = getData(_obj_tab_10);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.tr_tab10?.splice(0, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: JSON.stringify(data),
            url: '/basicsetting/m0070/postSaveTab10',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer10(employee_cd);
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
 * getRefer10
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer10(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_10',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab11').html(res);
                $('.tab-content').find('#tab11').removeClass('show active');
				$.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer02: ' + e.message);
	}
}