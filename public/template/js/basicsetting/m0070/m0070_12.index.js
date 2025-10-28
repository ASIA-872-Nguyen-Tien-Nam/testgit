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
var _obj_tab_12 = {
	'employee_cd'					: { 'type': 'text', 'attr': 'id' },
	'base_salary'					: { 'type': 'text', 'attr': 'id' },
	'basic_annual_income'			: { 'type': 'text', 'attr': 'id' },
}
$(document).ready(function () {
	try {
		initEvents12();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents12() {
	try {
		
	} catch (e) {
		alert('initEvents12: ' + e.message);
	}
}


/**
 * saveData
 *
 * @author      :   quanlh - 2024/04/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab12() {
    var data = getData(_obj_tab_12);
	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    return new Promise((resolve, reject) => {
        // send data to post
        $.ajax({
            type: 'post',
            data: JSON.stringify(data),
            url: '/basicsetting/m0070/postSaveTab12',
			dataType    :   'json',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer12(employee_cd);
                        resolve(true)
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            processError(res['errors']);
                        }
                        break;
                    // Exception
                    case 405:
                        resolve(true)
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
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
 * Refer12
 *
 * @author      :   Quanlh - 2024/04/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer12(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_12',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab17').remove();
                $('.tab-content').append(res);
                $.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer12: ' + e.message);
	}
}