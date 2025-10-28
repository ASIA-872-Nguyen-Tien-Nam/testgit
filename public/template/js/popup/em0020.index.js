/**
 * ****************************************************************************
 * MIRAI
 *
 * 作成日    : 2024/04
 * 作成者    : trinhdt
 *
 * @package   : MODULE EMPLOYEE
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 2.1
 * ****************************************************************************
 */
//obj insert
var _obj = {
    'selected_items_no'         : {'type':'text', 'attr':'id'},
    'selected_items_nm'         : {'type':'text', 'attr':'id'},
    'arrange_order'             : {'type':'text', 'attr':'id'},
    'work_history_kbn'          : {'type':'text', 'attr':'id'},
	'id'          				: {'type':'text', 'attr':'id'},
};
// obj del
var _obj1 = {
    'arrange_order'             : {'type':'text', 'attr':'id'},
    'work_history_kbn'          : {'type':'text', 'attr':'id'},
	'id'          				: {'type':'text', 'attr':'id'},
};
$(document).ready(function () {
	try {
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
function initEvents() {
	try {
		//btn-add-row
		$(document).on('click', '#btn-add-row', function () {
			try {
				try{
					jMessage(1, function(r) {
						if ( r && _validate($('body')) ) {
							saveData();
						}
					});
					$(this).closest('.container-fluid').find('.table-input input').val('');
				} catch(e){
					alert('btn-add-row: ' + e.message);
				}
			} catch (e) {
				alert('btn-add-row: ' + e.message);
			}
		});
		//btn-show-update
		$(document).on('click', '.table-add tbody tr .arrange_order,.table-add tbody tr .selected_items_nm', function () {
			try {
				selected_items_no = $(this).closest('tr').find('.selected_items_no').val();
				arrange_order = $(this).closest('tr').find('.arrange_order').text().trim();
				selected_items_nm = $(this).closest('tr').find('.selected_items_nm').text().trim();
				$('#selected_items_no').val(selected_items_no);
				$('#arrange_order').val(arrange_order);
				$('#selected_items_nm').val(selected_items_nm);
			} catch (e) {
				alert('btn-show_update: ' + e.message);
			}
		});
		//btn-remove-row
		$(document).on('click', '.btn-remove-row-popup', function () {
			try {
				selected_items_no = $(this).closest('tr').find('.selected_items_no').val();
				jMessage(3, function(r) {
					if ( r ) {
						deleteData(selected_items_no);
					}
				});
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}


/*
**
* save
*
* @author      :   trinhdt
* @return      :   null
* @access      :   public
* @see         :
    */
function saveData() {
    try {
        var data = getData(_obj);
		$.ajax({
			type: 'post',
			url: '/employeeinfo/em0020/popup/save',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function(r) {
                            $('#selected_items_no, #selected_items_nm, #arrange_order').val('');
							location.reload();
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
        alert('save');
    }
}

/**
 * delete
 * 
 * @author      :   trinhdt - 2024/03
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function deleteData(selected_items_no) {
    try {
        data =getData(_obj1);
        data.data_sql['selected_items_no']  =  selected_items_no;
		data.rules['#selected_items_no']    =  selected_items_no;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/employeeinfo/em0020/popup/delete', 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
							$('#selected_items_no, #selected_items_nm, #arrange_order').val('');
							location.reload();
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
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
        alert('delete' + e.message);
    }
}
