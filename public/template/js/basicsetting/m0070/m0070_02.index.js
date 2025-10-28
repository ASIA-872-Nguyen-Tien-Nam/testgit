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
var _obj_tab_2 = {
    'employee_cd': { 'type': 'text', 'attr': 'id' },
    'list_tab_02': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'class' },
			'qualification_nm': { 'type': 'text', 'attr': 'class' },
			'qualification_cd': { 'type': 'text', 'attr': 'class' },
			'qualification_typ': { 'type': 'text', 'attr': 'class' },
			'headquarters_other': { 'type': 'text', 'attr': 'class' },
			'possibility_transfer': { 'type': 'text', 'attr': 'class' },
			'remarks': { 'type': 'text', 'attr': 'class' },
		}
	}
}

$(document).ready(function () {
	try {
		initEvents2();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents2() {
	try {
        //autocomplate
		$(document).on('focus', '.autocomplete-down-tab_02', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label);
                        $(this).closest('tr').find('.qualification_cd').val(ui.item.qualification_cd);
                        $(this).closest('tr').find('.qualification_typ_nm').val(ui.item.value);
                        $(this).closest('tr').find('.qualification_typ').val(ui.item.qualification_typ);
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
		$(document).on('blur', '.autocomplete-down-tab_02', function (e) {
			try {
				var input = $(this).val();
                var data = JSON.parse($(this).attr('availableData'));
				if (!data.filter(element => element.label === input).length) {
                    $(this).closest('tr').find('.qualification_cd').val('');
                    $(this).closest('tr').find('.qualification_typ').val('');
                    $(this).closest('tr').find('.qualification_typ_nm').val('');
				}
				if (!input || input.length === 0) {
					$(this).closest('tr').find('.qualification_cd').val('');
                    $(this).closest('tr').find('.qualification_typ').val('');
                    $(this).closest('tr').find('.qualification_typ_nm').val('');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

        //add-row
		$(document).on('click', '#btn-add-row-tab-02', function () {
            try {
                var row = $(this).closest('.table-responsive-right').find('.table-target tr:first').clone();
                var number_row = $(this).closest('.table').find('tbody tr').length + 1
                $(this).closest('.table').append(row);
                $.formatInput();
                $(this).closest('.table').find('tbody tr:last td:first-child span').text(number_row);
                $(this).closest('.table').find('tbody tr:last td:first-child').next('td').find('.qualification_nm').focus();
                $(this).closest('.table').find('tbody tr:last').addClass('list_point_kinds');
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-remove-row
        $(document).on('click', '#btn-remove-row-tab-02', function () {
            try {
                var index = $(this).parents('tr').find('.no span').text() * 1;
                $(this).parents('tr').remove();
                

                if ($("#tab5 #table-data tbody tr").length == 0) {
                    $('#btn-add-row-tab-02').trigger('click')
                }

                resetIndexTab5(index);

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
        $(document).on('click','.employee_qualification', function(){
            var row = $('#btn-add-row-tab-02').closest('table').find('tbody > tr').length;
            if (row <= 0) {
                $('#btn-add-row-tab-02').trigger('click');
            }
        });
	} catch (e) {
		alert('initEvents2: ' + e.message);
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
function resetIndexTab5(index) {
    $("#tab5 #table-data tbody tr").each(function (i,e) {
        if ($(this).find('.no span').text() * 1 > index) {
            $(this).find('.no span').text(i + 1)
        }
    })
}

/**
 * saveDataTab02
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab02() {
    var data = getData(_obj_tab_2);
    data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    data.data_sql?.list_tab_02?.splice(data.data_sql?.list_tab_02.length - 1, 1);
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'post',
            data: data,
            url: '/basicsetting/m0070/postSaveTab02',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer02(employee_cd);
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
 * getRefer01
 *
 * @author      :   Hainn - 2024/03/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer02(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referTab02',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab5').remove();
                $('.tab-content').append(res);
                $.formatInput();
                activeHref()
			}
		});
	} catch (e) {
		alert('getRefer02: ' + e.message);
	}
}