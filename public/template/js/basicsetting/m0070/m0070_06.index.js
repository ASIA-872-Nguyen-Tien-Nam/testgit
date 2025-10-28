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
var _obj_tab_06 = {
    'employee_cd'					: { 'type': 'text', 'attr': 'id' },
	'owning_house_kbn'				: { 'type': 'select', 'attr': 'id' },
	'head_household'				: { 'type': 'text', 'attr': 'id' },
	'post_code'						: { 'type': 'text', 'attr': 'id' },
	'address1'						: { 'type': 'text', 'attr': 'id' },
	'address2'						: { 'type': 'text', 'attr': 'id' },
	'address3'						: { 'type': 'text', 'attr': 'id' },
	'home_phone_number'				: { 'type': 'text', 'attr': 'id' },
	'personal_phone_number'			: { 'type': 'text', 'attr': 'id' },
	'personal_email_address'		: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_name'		: { 'type': 'text', 'attr': 'id' },
	'relationship'					: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_birthday'	: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_post_code'	: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_addres1'		: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_addres2'		: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_addres3'		: { 'type': 'text', 'attr': 'id' },
	'emergency_contact_phone_number': { 'type': 'text', 'attr': 'id' }
}
$(document).ready(function () {
	try {
		initEvents6();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents6() {
	try {
		//autocomplate
		$(document).on('focus', '.autocomplete-down-06', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label);
                        $('#relationship').val(ui.item.number_cd);
						// $(this).closest('tr').find('.relationship').val(ui.item.value);
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
				alert('#btn-item-evaluation-input6 :' + e.message);
			}
		});
		
		//check post-code
		$(document).on('click', '.contact_information_tab', function (e) {
			try {
				if ($('#address1').val() == '' && $('#address2').val() == '') {
					if ($('#post_code').val() != '') {
						$('#post_code').trigger('change');
					}
				}

				if ($('#emergency_contact_addres1').val() == '' && $('#emergency_contact_addres2').val() == '') {
					if ($('#emergency_contact_post_code').val() != '') {
						$('#emergency_contact_post_code').trigger('change');
					}
				}
			} catch (e) {
				alert('#post_code :' + e.message);
			}
		});	
		// check head household	
		$(document).on('change', '#head_household', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#cooperation_typ : ' + e.message);
            }
        });

		//count Birthday
		$(document).on('change', '#emergency_contact_birthday', function () {
            try {
				var date = $(this).val();
				if (date != '') {
					var number = getBirthday(date);
					$('.year_old').val(number);
				}else{
					$('.year_old').val('');
				}
            } catch (e) {
                alert('Birthday : ' + e.message);
            }
        });

		// keydoun event
        $('.zip_cd').keydown(function(event){
            try {
                if (event.keyCode == 53){
                    return true;
                }
                if (!((event.keyCode > 47 && event.keyCode < 58)
                        || (event.keyCode > 95 && event.keyCode < 106)
                        || event.keyCode == 116
                        || event.keyCode == 46
                        || event.keyCode == 37
                        || event.keyCode == 39
                        || event.keyCode == 8
                        || event.keyCode == 9
                        || event.ctrlKey // 20160404 - sangtk - allow all ctrl combination //
                        || event.keyCode == 229 // ten-key processing
                        )
                        // || event.shiftKey
                        || (event.keyCode == 189 || event.keyCode == 109)) {
                    event.preventDefault();
                }
            } catch (e) {
                alert(e.message);
            }
        });
	} catch (e) {
		alert('initEvents6: ' + e.message);
	}
}


/**
 * saveData
 *
 * @author      :   quanlh - 2024/04/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab06() {
    var data = getData(_obj_tab_06);
	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
    return new Promise((resolve, reject) => {
        // send data to post
        $.ajax({
            type: 'post',
            data: JSON.stringify(data),
            url: '/basicsetting/m0070/postSaveTab06',
			dataType    :   'json',
            
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer06(employee_cd);
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
 * Refer06
 *
 * @author      :   Quanlh - 2024/04/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer06(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_06',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab7').remove();
                $('.tab-content').append(res);
				$.formatInput();
				activeHref()
			}
		});
	} catch (e) {
		alert('getRefer06: ' + e.message);
	}
}

/**
 * getBirthday
 *
 * @author      :   Hainn - 2024/05/09
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getBirthday(date) {
	let year = moment().diff(date, 'years');
	let now = moment().format();

	if(date == null){
		return 0
	}

	if (year <= 0) {
		return 0
	}

	let date_temp = moment(date, "DD-MM-YYYY").add('years', year);
	if (now < date_temp) {
		year -= 1;
	}

	return year;
}