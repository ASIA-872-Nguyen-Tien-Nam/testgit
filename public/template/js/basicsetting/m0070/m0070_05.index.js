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

var _obj_tab_5 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    // 'final_education_kbn_nm': { 'type': 'text', 'attr': 'id' },
    'final_education_kbn': { 'type': 'text', 'attr': 'id' },
    'final_education_other': { 'type': 'text', 'attr': 'id' },
    'graduation_year': { 'type': 'text', 'attr': 'id' },
	'graduation_school_nm': { 'type': 'text', 'attr': 'id' },
    'graduation_school_cd': { 'type': 'text', 'attr': 'id' },
    'graduation_school_other': { 'type': 'text', 'attr': 'id' },
    'faculty': { 'type': 'text', 'attr': 'id' },
    'major': { 'type': 'text', 'attr': 'id' },
    'list_tab_05': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'id' },
            'graduation_year': { 'type': 'text', 'attr': 'id' },
            'graduation_school_nm': { 'type': 'text', 'attr': 'id' },
            'graduation_school_cd': { 'type': 'text', 'attr': 'id' },
            'graduation_school_other': { 'type': 'text', 'attr': 'id' },
            'faculty': { 'type': 'text', 'attr': 'id' },
            'major': { 'type': 'text', 'attr': 'id' },
		}
	}
}

$(document).ready(function () {
	try {
		initEvents5();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents5() {
	try {
        //autocomplate
		$(document).on('focus', '.autocomplete-down-tab_05', function (e) {
			try {
					var data = JSON.parse($(this).attr('availableData'));
					$(this).autocomplete({
						source: function(request, response) {
							if (request.term.length > 0) {
								response($.ui.autocomplete.filter(data, request.term));
							} else {
								response([]);
							}
						},
						minLength: 0,
						select: function (event, ui) {
							$(this).val(ui.item.label);
							if (ui.item.code) {
								$(this).closest('div').find('.graduation_school_cd').val(ui.item.code);
							}
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
		$(document).on('blur', '.autocomplete-down-tab_05', function (e) {
			try {
				var input = $(this).val();
				var data = JSON.parse($(this).attr('availableData'));
				if (!data.filter(element => element.label === input).length) {
					$(this).val('');
					$(this).closest('div').find('.graduation_school_cd').val('');
				}
				if (!input || input.length === 0) {
					$(this).val('');
					$(this).closest('div').find('.graduation_school_cd').val('');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		$(document).on('click', '#add_row_data_06', function () {
            try {
				var row = $('#tab6').find('.row_data_06_hidden').clone();
				$('.block_data_06').append(row);
				$('.block_data_06').find('.row_data_06:last').attr('hidden', false)
				$('.block_data_06').find('.row_data_06:last').removeClass('row_data_06_hidden')
				$.formatInput();
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });
        $(document).on('click', '.btn-remove_06', function () {
            try {
                $(this).closest('.list_tab_05').remove();
            } catch (e) {
                alert('btn-remove-row: ' + e.message);
            }
        });
        
        $(document).on('change', '.final_education_kbn', function () {
            if ($(this).val() == 9 && $(this).attr('dis') == '') {
                $('.final_education_other').attr('disabled', false)
				$('.final_education_other').attr('tabindex', 9)
            } else {
                $('.final_education_other').attr('disabled', true)
				$('.final_education_other').val('');
            }
			if ( $(this).val() == 9 || $(this).val() == 8) {
				$('.cd_1').val('');
				$('.cd_1').closest('.form-group').find('.graduation_school_cd').val('');
				$('.cd_1').attr('disabled', true)
			}else {
				$('.cd_1').attr('disabled', false)
			}

            $.formatInput()
        });

		$(document).on('click', '.employee-academic', function () {
            if($('.final_education_kbn').val() == 9 && $('.final_education_kbn').attr('dis') == ''){
				$('.final_education_other').attr('disabled', false)
			}else {
                $('.final_education_other').attr('disabled', true)
            } 

			if ( $('.final_education_kbn').val() == 9 || $('.final_education_kbn').val() == 8) {
				$('.cd_1').val('');
				$('.cd_1').closest('.form-group').find('.graduation_school_cd').val('');
				$('.cd_1').attr('disabled', true)

			}else {
				$('.cd_1').attr('disabled', false)
			}
        });
		
	} catch (e) {
		alert('initEvents5: ' + e.message);
	}
}

/**
 * saveDataTab05
 *
 * @author      :   Hainn - 2024/03/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab05() {
    var data = getData(_obj_tab_5);
	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
	data.data_sql?.list_tab_05?.splice(data.data_sql?.list_tab_05.length - 1, 1);
	return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab05',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer05(employee_cd);
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
 * getRefer05
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer05(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referTab05',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab6').remove();
                $('.tab-content').append(res);
				$.formatInput();
				activeHref()
			}
		});
	} catch (e) {
		alert('getRefer02: ' + e.message);
	}
}

/**
 * clearInfoTab05
 *
 * @author      :   Hainn - 2024/05/08
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function clearInfoTab05() {
	$('.final_education_other').attr('disabled', true)
	$('.block_data_06').find('.list_tab_05 .btn-remove_06').trigger('click')
}