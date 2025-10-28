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
var _obj_tab_13 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'list_tab_13': {
		'attr': 'list', 'item': {
			'detail_no'                 : { 'type': 'text', 'attr': 'class' },
            'label'                     : { 'type': 'text', 'attr': 'class' },
			'reward_punishment_typ'     : { 'type': 'text', 'attr': 'class' },
			'decision_date'             : { 'type': 'text', 'attr': 'class' },
			'reason'                    : { 'type': 'text', 'attr': 'class' },
            'remarks'                   : { 'type': 'text', 'attr': 'class' },
		}
	}
}
$(document).ready(function () {
	try {
		initEvents13();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents13() {
	try {
		//autocomplate
		$(document).on('focus', '.autocomplete-down-tab_13', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label);
                        $(this).closest('tr').find('.reward_punishment_typ').val(ui.item.number_cd);
                        $(this).closest('tr').find('.label').val(ui.item.value);
                        return false;
                    },
					open: function (event, ui) {
						var $input = $(event.target);
						var $results = $input.autocomplete("widget");
						var scrollTop = $(window).scrollTop();
						var top = $results.position().top;
						var height = $results.outerHeight();

						if (top + height > $(window).innerHeight() + scrollTop) {
							newTop = top - height - $input.outerHeight();
							if (newTop > scrollTop)
								$results.css("top", newTop + "px");
						}
					}
				}).on('focus', function () { $(this).keydown(); })
				.autocomplete("instance")._renderItem = function (ul, item) {
                    if(item.row_index == 1 && item.numeric_value1 == 1) {
                        return $("<li>")
                        .append("<div>"+ item.group_name + item.label + "</div>")
                        .appendTo(ul);
                    }if(item.row_index == 1 && item.numeric_value1 == 2) {
                        return $("<li>")
                        .append("<div>"+ item.group_name + item.label + "</div>")
                        .appendTo(ul);
                    }if(item.row_index == 1 && item.numeric_value1 == 3) {
                        return $("<li>")
                        .append("<div>" + item.label + "</div>")
                        .appendTo(ul);
                    }else{
                        return $("<li>")
                            .append("<div>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp" + item.label + "</div>")
                            .appendTo(ul);
                    }
				};
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});
    
        //add-row
		 $(document).on('click', '#add-new-row-tab13', function () {
            try {
                var row = $(this).closest('.table-responsive-right').find('.table-target tr:first').clone();
                var number_row = $(this).closest('.table').find('tbody tr').length + 1
                $(this).closest('.table').append(row);
                $.formatInput();
                $(this).closest('.table').find('tbody tr:last td:first-child span').text(number_row);
				$(this).closest('.table').find('tbody tr:last td:first-child').next('td').find('.date').focus();
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-remove-row
        $(document).on('click', '#remove-row-tab13', function () {
            try {
                var index = $(this).parents('tr').find('.no span').text() * 1;
                $(this).parents('tr').remove();
                resetIndex(index);

                if ($("#tab13 #table-data tbody tr").length == 0) {
                    $('#add-new-row-tab13').trigger('click')
                }
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });
        //check no row
        $(document).on('click','.reward_and_punishment_information_tab', function(){
            var row = $('#add-new-row-tab13').closest('table').find('tbody > tr').length;
            if (row <= 0) {
                $('#add-new-row-tab13').trigger('click');
            }
        });
        //check
        $(document).on('blur', '.autocomplete-down-tab_13', function (e) {
            try {
				var input = $(this).val();
				var data = JSON.parse($(this).attr('availableData'));
				if (!data.filter(element => element.label === input).length) {
					$(this).val('');
					$(this).closest('div').find('.reward_punishment_typ').val(0);
				}
				if (!input || input.length === 0) {
					$(this).val('');
					$(this).closest('div').find('.reward_punishment_typ').val(0);
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
        });
	} catch (e) {
		alert('initEvents13: ' + e.message);
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
    $("#tab13 #table-data tbody tr").each(function (i,e) {
        if ($(this).find('.no span').text() * 1 > index) {
            $(this).find('.no span').text(i + 1)
        }
    })
}

/**
 * saveDataTab13
 *
 * @author      :   Quanlh - 2024/04/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab13() {
    var data = getData(_obj_tab_13);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.list_tab_13?.splice(data.data_sql?.list_tab_13.length - 1, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab13',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer13(employee_cd);
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
 * Refer13
 *
 * @author      :   Quanlh - 2024/04/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer13(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_13',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab13').remove();
                $('.tab-content').append(res);
                $.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer13: ' + e.message);
	}
}