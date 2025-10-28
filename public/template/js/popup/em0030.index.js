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
var _obj = {
    'training_cd'               : {'type':'text', 'attr':'id'},
    'training_nm'               : {'type':'text', 'attr':'id'},
    'arrange_order'             : {'type':'text', 'attr':'id'},
    'mode'             			: {'type':'text', 'attr':'id'},
};
var _obj1 = {
    'mode'             			: {'type':'text', 'attr':'id'},
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
		$(document).on('click', '.table-add tbody tr .arrange_order,.table-add tbody tr .training_nm', function () {
			try {
				training_cd = $(this).closest('tr').find('.training_cd').val();
				arrange_order = $(this).closest('tr').find('.arrange_order').text().trim();
				training_nm = $(this).closest('tr').find('.training_nm').text().trim();
				$('#training_cd').val(training_cd);
				$('#arrange_order').val(arrange_order);
				$('#training_nm').val(training_nm);
			} catch (e) {
				alert('btn-show_update: ' + e.message);
			}
		});
		//btn-remove-row
		$(document).on('click', '.btn-remove-row-popup', function () {
			try {
				training_cd = $(this).closest('tr').find('.training_cd').val();
				arrange_order = $(this).closest('tr').find('.arrange_order').text().trim();
				training_nm = $(this).closest('tr').find('.training_nm').text().trim();
				jMessage(3, function(r) {
					if ( r ) {
						deleteData(training_cd, arrange_order, training_nm);
					}
				});
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		//X
        $(document).on('click', '#btn-close-popup', function () {
            parent.$.colorbox.close();
            parent.location.reload();
            parent.$('body').css('overflow','auto');
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
			url: '/employeeinfo/em0030/popup/save',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function(r) {
                            $('#training_cd, #training_nm, #arrange_order').val('');
                            refer();
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
function deleteData(training_cd, arrange_order, training_nm) {
    try {
        data =getData(_obj1);
        data.data_sql['arrange_order']    =  arrange_order;
        data.data_sql['training_cd']    =  training_cd;
        data.data_sql['training_nm']    =  training_nm;
		data.rules['#arrange_order']    =  arrange_order;
		data.rules['#training_cd']    =  training_cd;
		data.rules['#training_nm']    =  training_nm;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/employeeinfo/em0030/popup/delete', 
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
							$('#training_cd, #training_nm, #arrange_order').val('');
                            refer();
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

/**
 * refer list
 * 
 * @author      :   trinhdt - 2024/03
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function refer() {
    try {
        var mode = $('#mode').val()
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/em0030/popup/refer',
            loading: true,
            dataType: 'html',
            data: { 'mode': mode},
            success: function (res) {
                $('#result').empty()
                $('#result').append(res)
            },
			error: function (xhr) {
				console.log(xhr)
			}
        });
    } catch (e) {
        alert('refer' + e.message);
    }
}