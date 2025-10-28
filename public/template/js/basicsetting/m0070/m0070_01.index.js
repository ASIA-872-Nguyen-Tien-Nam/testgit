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
var _obj_01 = {
    'blood_type': { 'type': 'radiobox', 'attr': 'id', 'name': 'blood_type' },
    'headquarters_prefectures': { 'type': 'select', 'attr': 'id' },
    'headquarters_other': { 'type': 'text', 'attr': 'id' },
    'possibility_transfer': { 'type': 'select', 'attr': 'id' },
    'nationality': { 'type': 'text', 'attr': 'id' },
    'residence_card_no': { 'type': 'text', 'attr': 'id' },
    'status_residence': { 'type': 'select', 'attr': 'id' },
	'expiry_date': { 'type': 'text', 'attr': 'id' },
    'permission_activities': { 'type': 'select', 'attr': 'id' },
    'disability_classification': { 'type': 'select', 'attr': 'id' },
    'disability_recognition_date': { 'type': 'text', 'attr': 'id' },
    'disability_content': { 'type': 'text', 'attr': 'id' },
    'common_name': { 'type': 'text', 'attr': 'id' },
    'common_name_furigana': { 'type': 'text', 'attr': 'id' },
    'maiden_name': { 'type': 'text', 'attr': 'id' },
    'maiden_name_furigana': { 'type': 'text', 'attr': 'id' },
    'business_name': { 'type': 'text', 'attr': 'id' },
    'business_name_furigana': { 'type': 'text', 'attr': 'id' },

    'attached_file1': { 'type': 'text', 'attr': 'id' },
    'attached_file1_name': { 'type': 'text', 'attr': 'id' },
    'attached_file1_uploaddatetime': { 'type': 'text', 'attr': 'id' },
	'attached_file2': { 'type': 'text', 'attr': 'id' },
    'attached_file2_name': { 'type': 'text', 'attr': 'id' },
    'attached_file2_uploaddatetime': { 'type': 'text', 'attr': 'id' },
	'attached_file3': { 'type': 'text', 'attr': 'id' },
    'attached_file3_name': { 'type': 'text', 'attr': 'id' },
    'attached_file3_uploaddatetime': { 'type': 'text', 'attr': 'id' },
	'attached_file4': { 'type': 'text', 'attr': 'id' },
    'attached_file4_name': { 'type': 'text', 'attr': 'id' },
    'attached_file4_uploaddatetime': { 'type': 'text', 'attr': 'id' },
	'attached_file5': { 'type': 'text', 'attr': 'id' },
    'attached_file5_name': { 'type': 'text', 'attr': 'id' },
    'attached_file5_uploaddatetime': { 'type': 'text', 'attr': 'id' },

    'base_style': { 'type': 'select', 'attr': 'id' },
    'sub_style': { 'type': 'select', 'attr': 'id' },
    'driver_point': { 'type': 'numeric', 'attr': 'id' },
    'analytical_point': { 'type': 'numeric', 'attr': 'id' },
    'expressive_point': { 'type': 'numeric', 'attr': 'id' },
    'amiable_point': { 'type': 'numeric', 'attr': 'id' },

	'employee_cd': { 'type': 'text', 'attr': 'id' },
};
$(document).ready(function () {
	try {
		initEvents1();
	} catch (e) {
		alert('ready' + e.message);
	}
});

function initEvents1() {
	try {
		//autocomplate
		$(document).on('focus', '.autocomplete-down-01', function (e) {
			try {
				var data = JSON.parse($(this).attr('availableData'));
				$(this).autocomplete({
					source: data,
					minLength: 0,
					select: function (event, ui) {
                        $(this).val(ui.item.label);
                        $('#nationality').val(ui.item.number_cd);
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
		$(document).on('blur', '.autocomplete-down-01', function (e) {
			try {
				var input = $(this).val();
                var data = JSON.parse($(this).attr('availableData'));
				if (!data.filter(element => element.label === input).length) {
					$(this).val('');
                    $('#nationality').val('');
				} else {
                    nationality = data.filter(element => element.label === input)
                    $('#nationality').val(nationality[0].number_cd);
                }
				if (!input || input.length === 0) {
					$(this).val('');
					$('#nationality').val('');
				}
                
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		$(document).on('change', '.import_file', function () {
            var file = readURL_01(this);
            $(this).closest('.num-length').find('.file-name').empty().text(file['name']);
            $(this).closest('.num-length').find('.attached_file_name').val(file['name']);
        });

		//btn-delete-file
		$(document).on('click', '.btn-remove', function () {
			try {
				$(this).closest('.num-length').find('.file-name').empty().text('');
				$(this).closest('.num-length').find('.uploadtime-01').empty().text('');
                $(this).closest('.num-length').find('.attached_file_name').val('');
                $(this).closest('.num-length').find('.attached_file').val('');
                $(this).closest('.num-length').find('.attached_file_uploaddatetime').val('');
                $(this).closest('.num-length').find('.import_file').val('');
			} catch (e) {
				alert('#btn-delete-file' + e.message);
			}
		});
		//btn-download
        $(document).on('click', '.btn-down-01', function () {
            try {
                var file_name = $(this).closest('.num-length').find('.attached_file_name').val();
                var file_down = $(this).closest('.num-length').find('.attached_file').val();
                var company_cd = $('.company_cd').val();
                file_address = '/uploads/m0070/'+company_cd+'/employee_information/'+file_down
                if (file_name != '') {
                    downloadfileHTML(file_address, file_name, function () {
                    });
                } else {
                    jMessage(21); return;
                }
            } catch (e) {
                alert('#btn-download' + e.message);
            }
        });
        // blur katakana halfsize
		$(document).on('blur', 'input.kana:enabled', function () {
			var string = $(this).val();
			if (!_validateHalfSizeAndFullSizeKana(string)) {
				$(this).val('');
			}
		});
		$(document).on('blur', '#business_name', function () {
			var string = $(this).val();
			if (!_validateStringName(string)) {
				$(this).val('');
			}
		});
	} catch (e) {
		alert('initEvents1: ' + e.message);
	}
}


function readURL_01(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.readAsDataURL(input.files[0]);
    }
    return input.files[0];
}

/**
 * saveData
 *
 * @author      :   sondh - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab01() {
    var data = getData(_obj_01);
    var formData = new FormData();
    formData.append('head', JSON.stringify(data));
    formData.append('file1', $('#upload_file_1')[0].files[0]);
    formData.append('file2', $('#upload_file_2')[0].files[0]);
    formData.append('file3', $('#upload_file_3')[0].files[0]);
    formData.append('file4', $('#upload_file_4')[0].files[0]);
    formData.append('file5', $('#upload_file_5')[0].files[0]);
    return new Promise((resolve, reject) => {
        // send data to post
        $.ajax({
            type: 'post',
            data: formData,
            url: '/basicsetting/m0070/save_01',
            
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        var employee_cd = $('#employee_cd').val();
                        getRefer01(employee_cd);
                        resolve(true)
                        break;
                    // error
                    case NG:
                        resolve(true)
                        break;
                    // Exception
                    case 405:
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
 * getLeftContent
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer01(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/refer_01',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
				$('.tab-content').find('#tab4').remove();
				// $('.nav-tabs').find('.active').removeClass('active');
				// $('.nav-tabs').find('.show').removeClass('show');
				// $('.tab-content').find('#tab1').addClass('active');
				// $('.tab-content').find('#tab1').addClass('show');
                $('.tab-content').append(res);
                $.formatInput();
                setInputFilter(document.querySelectorAll('.numeric_range'), function (value) {
					return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
				});
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}

/**
 * Check halfsize kana
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

/**
 * Check  katakana, kanji, hiragana, chữ latin
 *
 * @param string
 * @returns {Boolean}
 */
function _validateStringName(string) {
	var regexp = /([`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]|[0-9])+/;
	if (regexp.test(string) || string == '') {
		return false;
	} else {
		return true;
	}
}