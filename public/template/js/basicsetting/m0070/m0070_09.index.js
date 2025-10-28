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
var _obj_tab_09 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'list_tab_09': {
		'attr': 'list', 'item': {
			'detail_no'           : { 'type': 'text', 'attr': 'class' },
			'leave_absence_startdate'   : { 'type': 'text', 'attr': 'class' },
			'leave_absence_enddate'     : { 'type': 'text', 'attr': 'class' },
			'remarks'             : { 'type': 'text', 'attr': 'class' },
		}
	}
}
$(document).ready(function () {
	try {
		initEvents9();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents9() {
	try {
		 //add-row
		 $(document).on('click', '#add-new-row-tab09', function () {
            try {
                var row = $(this).closest('.table-responsive-right').find('.table-target tr:first').clone();
                var number_row = $(this).closest('.table').find('tbody tr').length + 1
                $(this).closest('.table').append(row);
                $.formatInput();
                $(this).closest('.table').find('tbody tr:last td:first-child span').text(number_row);
				// $(this).closest('.table').find('tbody tr:last td:first-child').next('td').find('.date').focus();
                $(this).closest('.table').find('tbody tr:last').addClass('list_point_kinds');
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-remove-row
        $(document).on('click', '#remove-row-tab09', function () {
            try {
                var index = $(this).parents('tr').find('.no span').text() * 1;
                $(this).parents('tr').remove();

                if ($("#tab10 #table-data tbody tr").length == 0) {
                    $('#add-new-row-tab09').trigger('click')
                }
                
                resetIndexTab9(index);

                if ($('#tbl-data').height() < ($('#div_data').height() - 15)) {
                    $('.scroll > table').css('width', '100%');
                    $('.scroll > table').css('min-width', '1017px');
                }
                var row_count = $('.scroll tbody tr').length;
                if (row_count <= 6) {
                    $('.scroll').addClass('more4');
                }
                else {
                    $('.scroll').removeClass('more4');
                }
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });
        
        //check no row
        $(document).on('click','.leave_absence_infor', function(){
            var row = $('#add-new-row-tab09').closest('table').find('tbody > tr').length;
            if (row <= 0) {
                $('#add-new-row-tab09').trigger('click');
            }
        });
	} catch (e) {
		alert('initEvents9: ' + e.message);
	}
}

/**
 * resetIndex
 *
 * @author      :   Quanlh - 2024/03/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function resetIndexTab9(index) {
    $("#tab10 #table-data tbody tr").each(function (i,e) {
        if ($(this).find('.no span').text() * 1 > index) {
            $(this).find('.no span').text(i + 1)
        }
    })
}

/**
 * saveDataTab09
 *
 * @author      :   Quanlh - 2024/03/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab09() {
    var data = getData(_obj_tab_09);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.list_tab_09?.splice(data.data_sql?.list_tab_09.length - 1, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab09',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer09(employee_cd);
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
 * get
 *
 * @author      :   Quanlh - 2024/03/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer09(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_09',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {            
                $('.tab-content').find('#tab10').html(res);
                $('.tab-content').find('#tab10').removeClass('show active');
				$.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getReferTab09: ' + e.message);
	}
}