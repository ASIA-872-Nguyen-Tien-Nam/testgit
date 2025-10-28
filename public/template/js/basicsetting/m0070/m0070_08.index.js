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
var _obj_tab_8 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
	'marital_status': { 'type': 'select', 'attr': 'id' },
    'list_tab_08': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'id' },
			'full_name': { 'type': 'text', 'attr': 'id' },
			'full_name_furigana': { 'type': 'text', 'attr': 'id' },
			'relationship': { 'type': 'text', 'attr': 'id' },
			'gender': { 'type': 'select', 'attr': 'id' },
			'birthday': { 'type': 'text', 'attr': 'id' },
			'residential_classification': { 'type': 'select', 'attr': 'id' },
			'profession': { 'type': 'text', 'attr': 'id' },
		}
	}
}

$(document).ready(function () {
	try {
		initEvents8();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents8() {
	try {
		//focus autocomplete
		$(document).on('focus', '.autocomplete-down-tab_08', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label);
                        $(this).closest('div').find('#relationship').val(ui.item.number_cd)
                        // $(this).closest('div').find('#profession').val(ui.item.number_cd)
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
					return $("<li>")
						.append("<div>" + item.label + "</div>")
						.appendTo(ul);
				};
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		//check autocomplete
		$(document).on('blur', '.autocomplete-down-tab_08', function (e) {
			try {
				var input = $(this).val();
				if (!input || input.length === 0) {
					$(this).val('');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		//add-row
		$(document).on('click', '#btn-add-row-tab_08', function () {
			try {
				var row = $(this).closest('.table-responsive-right').find('.table-target tr:first').clone();
				var number_row = $(this).closest('.table').find('tbody tr').length + 1
				$(this).closest('.table').append(row);
				$.formatInput();
				$(this).closest('.table').find('tbody tr:last td:first-child').text(number_row);
				$(this).closest('.table').find('tbody tr:last td:first-child').next('td').find('.qualification_nm').focus();
			} catch (e) {
				alert('btn-add-new: ' + e.message);
			}
		});

		$(document).on('keyup', '.autocomplete-down-tab_08', function (e) {
			try {
				// $(this).closest('div').find('#profession').val($(this).val());
				$(this).closest('div').find('#relationship').val($(this).val());
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		//btn-remove-row
        $(document).on('click', '#btn-remove-row-tab_08', function () {
            try {
                var index = $(this).parents('tr').find('.no').val() * 1;
                $(this).parents('tr').remove();
                
                if ($("#tab9 #table-data tbody tr").length == 0) {
                    $('#btn-add-row-tab_08').trigger('click')
                }

                resetIndexTab8(index);
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });
		
		//check no row
        $(document).on('click','.employee-family', function(){
            var row = $('#btn-add-row-tab_08').closest('table').find('tbody > tr').length;
            if (row <= 0) {
                $('#btn-add-row-tab_08').trigger('click');
            }
        });

		// blur katakana halfsize
		$(document).on('blur', 'input.halfsize-kana:enabled', function () {
			var string = $(this).val();
			if (!_validateHalfSizeAndFullSizeKana(string)) {
				$(this).val('');
			}
		});
	} catch (e) {
		alert('initEvents8: ' + e.message);
	}
}

/**
 * resetIndex
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function resetIndexTab8(index) {
    $("#tab9 #table-data tbody tr").each(function (i,e) {
        if ($(this).find('.no').text() * 1 > index) {
            $(this).find('.no').text(i + 1)
        }
    })
}

/**
 * saveDataTab08
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab08() {
    var data = getData(_obj_tab_8);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.list_tab_08?.splice(data.data_sql?.list_tab_08.length - 1, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab08',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer08(employee_cd);
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
 * getRefer08
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer08(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referTab08',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab9').remove();
                $('.tab-content').append(res);
				$.formatInput()
				activeHref()
			}
		});
	} catch (e) {
		alert('getRefer02: ' + e.message);
	}
}

/**
 * Check halfsize and fullsize kana
 *
 * @param string
 * @returns {Boolean}
 */
function _validateHalfSizeAndFullSizeKana(string) {
	var regexp = /^([ァ-ン]|ー|[ｧ-ﾝﾞﾟ]|\s)+$/;
    if (regexp.test(string) || string == '') {
        return true;
    } else {
        return false;
    }
}