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
var _obj_tab_11 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'employment_insurance_no': { 'type': 'text', 'attr': 'id' },
    'basic_pension_no': { 'type': 'text', 'attr': 'id' },
    'employment_insurance_status': { 'type': 'radiobox','name':'employment_insurance_status', 'attr': 'id' },
    'health_insurance_status': { 'type': 'radiobox','name':'health_insurance_status', 'attr': 'id' },
    'health_insurance_reference_no': { 'type': 'text', 'attr': 'id' },
    'employees_pension_insurance_status': { 'type': 'radiobox', 'name':'employees_pension_insurance_status','attr': 'id' },
    'employees_pension_reference_no': { 'type': 'text', 'attr': 'id' },
    'welfare_pension_status': { 'type': 'radiobox', 'name':'welfare_pension_status','attr': 'id' },
    'employees_pension_member_no': { 'type': 'text', 'attr': 'id' },
    'row_12_add_1': { 'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'social_insurance_kbn': { 'type': 'text', 'attr': 'id' },
            'joining_date': { 'type': 'text', 'attr': 'id' },
            'date_of_loss': { 'type': 'text', 'attr': 'id' },
            'reason_for_loss_kbn': { 'type': 'text', 'attr': 'id' },
        } 
    },
    'row_12_add_2': { 'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'social_insurance_kbn': { 'type': 'text', 'attr': 'id' },
            'joining_date': { 'type': 'text', 'attr': 'id' },
            'date_of_loss': { 'type': 'text', 'attr': 'id' },
            'reason_for_loss': { 'type': 'text', 'attr': 'id' },
        } 
    },
    'row_12_add_3': { 'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'social_insurance_kbn': { 'type': 'text', 'attr': 'id' },
            'joining_date': { 'type': 'text', 'attr': 'id' },
            'date_of_loss': { 'type': 'text', 'attr': 'id' },
            'reason_for_loss': { 'type': 'text', 'attr': 'id' },
        } 
    },
    'row_12_add_4': { 'attr': 'list', 'item': {
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'social_insurance_kbn': { 'type': 'text', 'attr': 'id' },
            'joining_date': { 'type': 'text', 'attr': 'id' },
            'date_of_loss': { 'type': 'text', 'attr': 'id' },
            'reason_for_loss': { 'type': 'text', 'attr': 'id' },
        } 
    },
}

$(document).ready(function () {
	try {
		initEvents11();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents11() {
	try {

        //focus autocomplete
		$(document).on('focus', '.autocomplete-down-tab_11', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label)
                        $(this).closest('span').find('.reason_for_loss_kbn').val(ui.item.number_cd);
                        // $(this).closest('span').find('.reason_for_loss').val(ui.item.number_cd);
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
		$(document).on('blur', '.autocomplete-down-tab_11', function (e) {
			try {
				var input = $(this).val();
				if (!input || input.length === 0) {
					$(this).val('');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

        //remove row
		$(document).on('click', '.btn-remove_12', function (e) {
            if ($(this).closest('.flex-fill').find('.row_tab_11').length <= 2) {
                $(this).closest('.row').find('.joining_date').val('');
                $(this).closest('.row').find('.date_of_loss').val('');
                // $(this).closest('.row').find('.reason_nm_1').val('');
                $(this).closest('.row').find('.reason_for_loss_kbn').val('');
                $(this).closest('.row').find('.reason_for_loss').val('');
                // $(this).closest('.row').find('.reason_nm').val('');
            }
            else {
                $(this).closest('.row').remove();
            }
        });

        //add row
        $(document).on('click', '#button_12_add_1', function () {
            try {
                $('.table_12_add_1 .flex-fill').append($('.row_12_add_1_hidden').clone())                
                $('.row_12_add_1').eq(-1).attr('hidden', false)
                $('.row_12_add_1').eq(-1).removeClass('row_12_add_1_hidden')
                $('.row_12_add_1').eq(-1).find('.form-control:eq(0)').focus()
                $.formatInput()
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });

        //add row
        $(document).on('click', '#button_12_add_2', function () {
            try {
                $('.table_12_add_2 .flex-fill').append($('.row_12_add_2_hidden').clone())
                $('.row_12_add_2').eq(-1).attr('hidden', false)
                $('.row_12_add_2').eq(-1).removeClass('row_12_add_2_hidden')
                $('.row_12_add_2').eq(-1).find('.form-control:eq(0)').focus()
                $.formatInput()
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });

        //add row
        $(document).on('click', '#button_12_add_3', function () {
            try {
                $('.table_12_add_3 .flex-fill').append($('.row_12_add_3_hidden').clone())
                $('.row_12_add_3').eq(-1).attr('hidden', false)
                $('.row_12_add_3').eq(-1).removeClass('row_12_add_3_hidden')
                $('.row_12_add_3').eq(-1).find('.form-control:eq(0)').focus()
                $.formatInput()
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });

        //add row
        $(document).on('click', '#button_12_add_4', function () {
            try {
                $('.table_12_add_4 .flex-fill').append($('.row_12_add_4_hidden').clone())
                $('.row_12_add_4').eq(-1).attr('hidden', false)
                $('.row_12_add_4').eq(-1).removeClass('row_12_add_4_hidden')
                $('.row_12_add_4').eq(-1).find('.form-control:eq(0)').focus()
                $.formatInput()
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });

        //add row when no data
        $(document).on('click', '.menu_m0070_pc .social_insurance', function () {
            try {
                var row_1 = $('.table_12_add_1').find('.row_12_add_1').not('.row_12_add_1_hidden').length;
                var row_2 = $('.table_12_add_2').find('.row_12_add_2').not('.row_12_add_2_hidden').length;
                var row_3 = $('.table_12_add_3').find('.row_12_add_3').not('.row_12_add_3_hidden').length;
                var row_4 = $('.table_12_add_4').find('.row_12_add_4').not('.row_12_add_4_hidden').length;
                if (row_1 <= 0) {
                    $('#button_12_add_1').trigger('click');
                }
                if (row_2 <= 0) {
                    $('#button_12_add_2').trigger('click');
                }
                if (row_3 <= 0) {
                    $('#button_12_add_3').trigger('click');
                }
                if (row_4 <= 0) {
                    $('#button_12_add_4').trigger('click');
                }
                $.formatInput()
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });

        $(document).on('keyup', '.autocomplete-down-tab_11', function (e) {
			try {
				$(this).closest('div').find('.reason_for_loss').val($(this).val());
				$(this).closest('div').find('.reason_for_loss_kbn').val($(this).val());
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

        $(document).on('blur', '.employment_insurance_no', function (e) {
            $(this).val(convertFullSizeToHalfSize(($(this).val()??'')))
            
            var text =convertFullSizeToHalfSize($(this).val())??'';
            var maxlength = $(this).attr('maxlength')
			var len = ($(this).val()??'').length
			var hyphenCount = (text.match(/-/g) || []).length;
			if(parseInt(len) > parseInt(maxlength)|| hyphenCount > 2 ) {
				$(this).val('');
			}

            if (!isValidNumber($(this).val())) {
                $(this).val('');
            }
		})

        $(document).on('blur', '.basic_pension_no', function (e) {
			$(this).val(convertFullSizeToHalfSize(($(this).val()??'')))
            var text =convertFullSizeToHalfSize($(this).val())??'';

            var maxlength = $(this).attr('maxlength')
			var len = ($(this).val()??'').length
			var hyphenCount = (text.match(/-/g) || []).length;
			if(parseInt(len) > parseInt(maxlength) || hyphenCount > 1 ) {
				$(this).val('');
			}

            if (!isValidNumber($(this).val())) {
                $(this).val('');
            }
		})

        $(document).on('keydown', '.employment_insurance_no', function (e) {
            try {
                var keyCode = e.keyCode;
                var maxDigits = 11;
                var value = $(this).val() ?? '';
                var numHyphens = (value.match(/-/g) || []).length;
                var numDigits = value.replace(/-/g, '').length;
        
                if (keyCode !== 8 && keyCode !== 46) {
                    if (numDigits >= maxDigits && !['-', 'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(e.key)) {
                        e.preventDefault();
                    } else if (numHyphens >= 2 && e.key === '-') {
                        e.preventDefault();
                    }
                }
            } catch (e) {
                alert('.d-numeric:keyup ' + e.toString());
            }
        });

        $(document).on('keydown', '.basic_pension_no', function (e) {
            try {
                var keyCode = e.keyCode;
                var maxDigits = 10;
                var value = $(this).val() ?? '';
                var numHyphens = (value.match(/-/g) || []).length;
                var numDigits = value.replace(/-/g, '').length;
        
                if (keyCode !== 8 && keyCode !== 46) { // Not backspace or delete
                    if (numDigits >= maxDigits && !['-', 'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(e.key)) {
                        e.preventDefault();
                    } else if (numHyphens >= 1 && e.key === '-') {
                        e.preventDefault();
                    }
                }
            } catch (e) {
                alert('.d-numeric:keyup ' + e.toString());
            }
        });

        
	} catch (e) {
		alert('initEvents11: ' + e.message);
	}
}

/**
 * saveDataTab11
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab11() {
    var data = getData(_obj_tab_11);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.row_12_add_1?.splice(0, 1);
    data.data_sql?.row_12_add_2?.splice(0, 1);
    data.data_sql?.row_12_add_3?.splice(0, 1);
    data.data_sql?.row_12_add_4?.splice(0, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: JSON.stringify(data),
            url: '/basicsetting/m0070/postSaveTab11',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer11(employee_cd);
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
 * getRefer11
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer11(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_11',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab12').html(res);
                $('.tab-content').find('#tab12').removeClass('show active');
				$.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer02: ' + e.message);
	}
}

function isValidNumber(str) {
	var regex = /^\d*(-\d*){0,2}$/;
	return regex.test(str);
}

function convertFullSizeToHalfSize(str) {
    return str.replace(/[\uFF10-\uFF19\uFF0E\uFF0D]/g, function(ch) {
        return String.fromCharCode(ch.charCodeAt(0) - 0xFEE0);
    });
}