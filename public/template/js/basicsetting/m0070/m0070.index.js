(function ($) {
	$.fn.hasScrollBar = function () {
		return this.get(0).scrollHeight > this.height();
	}
})(jQuery);
var temp = 0;
var _obj = {
	'employee_cd': { 'type': 'text', 'attr': 'id' },
	'employee_last_nm': { 'type': 'text', 'attr': 'id' },
	'employee_first_nm': { 'type': 'text', 'attr': 'id' },
	'employee_nm': { 'type': 'text', 'attr': 'id' },
	'employee_ab_nm': { 'type': 'text', 'attr': 'id' },
	'furigana': { 'type': 'text', 'attr': 'id' },
	'gender': { 'type': 'radiobox', 'attr': 'id' },
	'mail': { 'type': 'text', 'attr': 'id' },
	'birth_date': { 'type': 'text', 'attr': 'id' },
	'company_in_dt': { 'type': 'text', 'attr': 'id' },
	'company_out_dt': { 'type': 'text', 'attr': 'id' },
	'director_typ': { 'type': 'text', 'attr': 'id' },
	'retirement_reason_typ': { 'type': 'text', 'attr': 'id' },
	'retirement_reason': { 'type': 'text', 'attr': 'id' },
	'oneonone_typ': { 'type': 'text', 'attr': 'id' },
	'multireview_typ': { 'type': 'text', 'attr': 'id' },
	'report_typ': { 'type': 'text', 'attr': 'id' },
	'base_style': { 'type': 'text', 'attr': 'id' },
	'sub_style': { 'type': 'text', 'attr': 'id' },
	'driver_point': { 'type': 'text', 'attr': 'id' },
	'analytical_point': { 'type': 'text', 'attr': 'id' },
	'expressive_point': { 'type': 'text', 'attr': 'id' },
	'amiable_point': { 'type': 'text', 'attr': 'id' },
	'application_date': { 'type': 'text', 'attr': 'id' },
	'user_id': { 'type': 'text', 'attr': 'id' },
	'password': { 'type': 'text', 'attr': 'id' },
	'sso_user': { 'type': 'text', 'attr': 'id' },
	'office_cd': { 'type': 'select', 'attr': 'id' },
	'organization_step1': { 'type': 'select', 'attr': 'id' },
	'organization_step2': { 'type': 'select', 'attr': 'id' },
	'organization_step3': { 'type': 'select', 'attr': 'id' },
	'organization_step4': { 'type': 'select', 'attr': 'id' },
	'organization_step5': { 'type': 'select', 'attr': 'id' },
	'authority_cd': { 'type': 'select', 'attr': 'id' },
	'oneonone_authority_cd': { 'type': 'select', 'attr': 'id' },
	'multireview_authority_cd': { 'type': 'select', 'attr': 'id' },
	'setting_authority_cd': { 'type': 'select', 'attr': 'id' },
	'report_authority_cd': { 'type': 'select', 'attr': 'id' },
	'job_cd': { 'type': 'select', 'attr': 'id' },
	'position_cd': { 'type': 'select', 'attr': 'id' },
	'employee_typ': { 'type': 'select', 'attr': 'id' },
	'grade': { 'type': 'select', 'attr': 'id' },
	'base_salary': { 'type': 'text', 'attr': 'id' },
	'picture': { 'type': 'text', 'attr': 'id' },
	'imgInp': { 'type': 'file', 'attr': 'id' },
	// 'evaluated_typ'				: {'type':'checkbox', 'attr':'id'},
	'ck1': { 'type': 'checkbox', 'attr': 'id' },
	'list': {
		'attr': 'list', 'item': {
			'application_date': { 'type': 'text', 'attr': 'class' },
			'office_cd': { 'type': 'text', 'attr': 'class' },
			'belong_cd1': { 'type': 'text', 'attr': 'class' },
			'belong_cd2': { 'type': 'text', 'attr': 'class' },
			'belong_cd3': { 'type': 'text', 'attr': 'class' },
			'belong_cd4': { 'type': 'text', 'attr': 'class' },
			'belong_cd5': { 'type': 'text', 'attr': 'class' },
			'position_cd': { 'type': 'text', 'attr': 'id' },
			'job_cd': { 'type': 'text', 'attr': 'id' },
			'employee_typ': { 'type': 'text', 'attr': 'id' },
			'grade': { 'type': 'text', 'attr': 'id' },
		}
	},
};
var _obj1 = {
	'employee_cd': { 'type': 'text', 'attr': 'id' },
	'employee_last_nm': { 'type': 'text', 'attr': 'id' },
	'employee_first_nm': { 'type': 'text', 'attr': 'id' },
	'employee_nm': { 'type': 'text', 'attr': 'id' },
	'employee_ab_nm': { 'type': 'text', 'attr': 'id' },
	'furigana': { 'type': 'text', 'attr': 'id' },
	'gender': { 'type': 'radiobox', 'attr': 'id' },
	//'mail': { 'type': 'text', 'attr': 'id' },
	'birth_date': { 'type': 'text', 'attr': 'id' },
	'company_in_dt': { 'type': 'text', 'attr': 'id' },
	'company_out_dt': { 'type': 'text', 'attr': 'id' },
	//'director_typ': { 'type': 'text', 'attr': 'id' },
	//'retirement_reason_typ': { 'type': 'text', 'attr': 'id' },
	//'retirement_reason': { 'type': 'text', 'attr': 'id' },
	'oneonone_typ': { 'type': 'text', 'attr': 'id' },
	'multireview_typ': { 'type': 'text', 'attr': 'id' },
	'report_typ': { 'type': 'text', 'attr': 'id' },
	'base_style': { 'type': 'text', 'attr': 'id' },
	'sub_style': { 'type': 'text', 'attr': 'id' },
	'driver_point': { 'type': 'text', 'attr': 'id' },
	'analytical_point': { 'type': 'text', 'attr': 'id' },
	'expressive_point': { 'type': 'text', 'attr': 'id' },
	'amiable_point': { 'type': 'text', 'attr': 'id' },
	'application_date': { 'type': 'text', 'attr': 'id' },
	'user_id': { 'type': 'text', 'attr': 'id' },
	'password': { 'type': 'text', 'attr': 'id' },
	'sso_user': { 'type': 'text', 'attr': 'id' },
	'office_cd': { 'type': 'select', 'attr': 'id' },
	// 'organization_step1': { 'type': 'select', 'attr': 'id' },
	// 'organization_step2': { 'type': 'select', 'attr': 'id' },
	// 'organization_step3': { 'type': 'select', 'attr': 'id' },
	// 'organization_step4': { 'type': 'select', 'attr': 'id' },
	// 'organization_step5': { 'type': 'select', 'attr': 'id' },
	'authority_cd': { 'type': 'select', 'attr': 'id' },
	'oneonone_authority_cd': { 'type': 'select', 'attr': 'id' },
	'multireview_authority_cd': { 'type': 'select', 'attr': 'id' },
	'supported_languages': { 'type': 'select', 'attr': 'id' },
	'setting_authority_cd': { 'type': 'select', 'attr': 'id' },
	'report_authority_cd': { 'type': 'select', 'attr': 'id' },
	'empinfo_authority_cd': { 'type': 'select', 'attr': 'id' },
	'job_cd': { 'type': 'select', 'attr': 'id' },
	'position_cd': { 'type': 'select', 'attr': 'id' },
	'employee_typ': { 'type': 'select', 'attr': 'id' },
	'grade': { 'type': 'select', 'attr': 'id' },
	'base_salary': { 'type': 'text', 'attr': 'id' },
	'picture': { 'type': 'text', 'attr': 'id' },
	'imgInp': { 'type': 'file', 'attr': 'id' },
	'ck1': { 'type': 'checkbox', 'attr': 'id' },
	'list': {
		'attr': 'list', 'item': {
			'application_date': { 'type': 'text', 'attr': 'class' },
			'office_cd': { 'type': 'text', 'attr': 'class' },
			'belong_cd1': { 'type': 'text', 'attr': 'class' },
			'belong_cd2': { 'type': 'text', 'attr': 'class' },
			'belong_cd3': { 'type': 'text', 'attr': 'class' },
			'belong_cd4': { 'type': 'text', 'attr': 'class' },
			'belong_cd5': { 'type': 'text', 'attr': 'class' },
			'position_cd': { 'type': 'text', 'attr': 'class' },
			'job_cd': { 'type': 'text', 'attr': 'class' },
			'employee_typ': { 'type': 'text', 'attr': 'class' },
			'grade': { 'type': 'text', 'attr': 'id' },
		}
	},
};

var _obj_header = {
	'employee_cd': { 'type': 'text', 'attr': 'id' },
	'employee_last_nm': { 'type': 'text', 'attr': 'id' },
	'employee_first_nm': { 'type': 'text', 'attr': 'id' },
	'employee_nm': { 'type': 'text', 'attr': 'id' },
	'employee_ab_nm': { 'type': 'text', 'attr': 'id' },
	'furigana': { 'type': 'text', 'attr': 'id' },
	'gender': { 'type': 'radiobox', 'attr': 'id' },
	'birth_date': { 'type': 'text', 'attr': 'id' },
	'company_in_dt': { 'type': 'text', 'attr': 'id' },
	'company_out_dt': { 'type': 'text', 'attr': 'id' },
	'application_date': { 'type': 'text', 'attr': 'id' },
	'user_id': { 'type': 'text', 'attr': 'id' },
	'authority_cd': { 'type': 'select', 'attr': 'id' },
	'list': {
		'attr': 'list', 'item': {
			'application_date': { 'type': 'text', 'attr': 'class' },
			'office_cd': { 'type': 'text', 'attr': 'class' },
			'belong_cd1': { 'type': 'text', 'attr': 'class' },
			'belong_cd2': { 'type': 'text', 'attr': 'class' },
			'belong_cd3': { 'type': 'text', 'attr': 'class' },
			'belong_cd4': { 'type': 'text', 'attr': 'class' },
			'belong_cd5': { 'type': 'text', 'attr': 'class' },
			'position_cd': { 'type': 'text', 'attr': 'class' },
			'job_cd': { 'type': 'text', 'attr': 'class' },
			'employee_typ': { 'type': 'text', 'attr': 'class' },
			'grade': { 'type': 'text', 'attr': 'id' },
		}
	},
};
var _obj2 = {
	'employee_cd': { 'type': 'text', 'attr': 'id' },
	'mail': { 'type': 'text', 'attr': 'id' },
	'tel': { 'type': 'text', 'attr': 'id' },
	'tel_extends': { 'type': 'text', 'attr': 'id' },
	'application_date': { 'type': 'text', 'attr': 'id' },
	'user_id': { 'type': 'text', 'attr': 'id' },
	'grade': { 'type': 'text', 'attr': 'id' },
	'salary_grade': { 'type': 'text', 'attr': 'id' },
	'company_out_dt': { 'type': 'text', 'attr': 'id' },
	'retirement_reason': { 'type': 'text', 'attr': 'id' },
	'position_cd': { 'type': 'text', 'attr': 'id' },
	'job_cd': { 'type': 'text', 'attr': 'id' },
	'employee_typ': { 'type': 'text', 'attr': 'id' },
	'change_data_emp': { 'type': 'text', 'attr': 'id' },
	'office_cd': { 'type': 'select', 'attr': 'id' },
	'row_data_02': {
		'attr': 'list', 'item': {
			'arrange_order': { 'type': 'text', 'attr': 'class' },
			'organization_cd1': { 'type': 'select', 'attr': 'class' },
			'organization_cd2': { 'type': 'select', 'attr': 'class' },
			'organization_cd3': { 'type': 'select', 'attr': 'class' },
			'organization_cd4': { 'type': 'select', 'attr': 'class' },
			'organization_cd5': { 'type': 'select', 'attr': 'class' },
			'position_cd': { 'type': 'select', 'attr': 'class' },
			'detail_no_data_row': { 'type': 'text', 'attr': 'class' },
		}
	},
	'list': {
		'attr': 'list', 'item': {
			'application_date': { 'type': 'text', 'attr': 'class' },
			'detail_no': { 'type': 'text', 'attr': 'class' },
			'office_cd': { 'type': 'text', 'attr': 'class' },
			'belong_cd1': { 'type': 'text', 'attr': 'class' },
			'belong_cd2': { 'type': 'text', 'attr': 'class' },
			'belong_cd3': { 'type': 'text', 'attr': 'class' },
			'belong_cd4': { 'type': 'text', 'attr': 'class' },
			'belong_cd5': { 'type': 'text', 'attr': 'class' },
			'position_cd': { 'type': 'text', 'attr': 'class' },
			'job_cd': { 'type': 'text', 'attr': 'class' },
			'employee_typ': { 'type': 'text', 'attr': 'class' },
			'grade': { 'type': 'text', 'attr': 'id' },
		}
	},
};
var _mode = 0;
var _flgLeft = 0;

$(document).ready(function () {
	try {
		if (navigator.userAgent.indexOf("Firefox") != -1) //prevent show popup save password browser firefox
		{
			$('#password').attr('autocomplete', 'off');
			$('#password').attr('type', 'password');
			$('#password').removeClass('show_typePassWord');
			if ($('#employee_nm').val() == '') {
				$('#employee_cd').val('');
			}

		} else if (navigator.userAgent.indexOf("Edge") > -1) //IF IE > 10
		{
			$('#password').attr('type', 'password');
		}

		initialize();
		initEvents();
	} catch (e) {
		alert('ready' + e.message);
	}
});

/**
 * initialize
 */
function initialize() {
	try {
		
		checkInputUser(0);
		setInputFilter(document.querySelectorAll('.numeric_range'), function (value) {
			return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
		});
		$('#employee_cd').focus();
		$('#rd1').trigger('click')
		var employee_cd = $('#employee_cd').val();
		$('.list-search-content div[id="' + employee_cd + '"]').addClass('active');
		_formatTooltip_m0070();
		removeTooltip();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}

/**
 * initEvents
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
	try {
		$(document).on('click', '#director_typ', function (e) {
			if ($('#director_typ').is(':checked')) {
				$('#authority_cd').prop("disabled", true);
				$('#oneonone_authority_cd').prop("disabled", true);
				$('#empinfo_authority_cd').prop("disabled", true);
				$('#setting_authority_cd').prop("disabled", true);
				$('#multireview_authority_cd').prop("disabled", true);
				$('#empinfo_authority_cd').prop("disabled", true);
				$('#report_authority_cd').prop("disabled", true);
				$('#authority_cd').val(0);
				$('#oneonone_authority_cd').val(0);
				$('#multireview_authority_cd').val(0);
				$('#setting_authority_cd').val(0);
				$('#report_authority_cd').val(0);
				$('#empinfo_authority_cd').val(0);
				$('#multireview_authority_cd').val(0);
			} else {
				$('#authority_cd').prop("disabled", false);
				$('#oneonone_authority_cd').prop("disabled", false);
				$('#multireview_authority_cd').prop("disabled", false);
				$('#setting_authority_cd').prop("disabled", false);
				$('#report_authority_cd').prop("disabled", false);
				$('#empinfo_authority_cd').prop("disabled", false);
				$('#setting_authority_cd').prop("disabled", false);
			}
		});
		$(document).on('click', '#btn-retired', function (e) {
			try {
				var employee_cd = $('#employee_cd').val();
				var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if ((width <= 1368) && (width >= 1300)) {
					option.width = '90%';
					option.height = '85%';
				} else {
					if (width <= 1300) {
						option.width = '90%';
						option.height = '70%';
					} else {
						option.width = '980px';
						option.height = '620px';
					}
				}
				// e.preventDefault();
				showPopup('/basicsetting/m0070/popup_retired?employee_cd=' + employee_cd, option, function () { });
			} catch (e) {
				alert('#btn-set-bith event: ' + e.message);
			}
		});
		$(document).on('keyup', '#user_id,#password', function (e) {
			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val())) {
				$(this).val('');
			}
		})
		$(document).on('blur', '.number_item1', function (e) {
			var text =convertFullSizeToHalfSize($(this).val())??'';
			$(this).val(convertFullSizeToHalfSize(($(this).val()??'')))
			var number = parseFloat(formatConvertHalfsize(($(this).val()??'')));
			if(number == parseInt(number)){
			var roundedDownNumber = Math.floor(number * 10) / 10;
			var formattedNumber = roundedDownNumber.toFixed(1);
			var zero = 0;
			$(this).val(formattedNumber);
			}
			var maxlength = $(this).attr('maxlength')
			var len = ($(this).val()??'').length
			var dotCount = (text.match(/\./g) || []).length;
			if(parseInt(len) > parseInt(maxlength) || isValidNumberAndPeriod(number) == false||isValidDecimal(number) == false || dotCount > 1 ) {
				$(this).val('');
			}
          
			var decimalPart = (number.toString().split('.')[1]??'').length;
			if(decimalPart>1) {
				$(this).val('');
			}
		})
		var selection = {};

		$(document).on('keyup', '.number_item1', function (e) {
			try {
				e.preventDefault();
				var fullSizeRegex = /^[\uFF00-\uFFEF]+$/;
				if(fullSizeRegex.test($(this).val())==true) {
				this.setSelectionRange(selection.end+1, selection.end+1);
				}
			} catch (e) {
				alert('.d-numeric:keyup ' + e.toString());
			}
		});
		$(document).on('keydown', '.number_item1', function (e) {
			try {
				var keyCode = e.keyCode;
				var max_length = parseInt($(this).attr('maxlength')??0)-3
				if (keyCode !== 8 && keyCode !== 46) {
				if(($(this).val()??'').length>max_length) {
					if(e.originalEvent.key !='.'&&!($(this).val()??'').includes('.')) {
					e.preventDefault();
					}
				}
			}
			} catch (e) {
				alert('.d-numeric:keyup ' + e.toString());
			}
			});
			var start_run = false;
		$('.number_item1').on('keyup', function(event) {
			if(start_run == false) {
            var input = $(this).val();
            var maxLength = parseInt($(this).attr('maxlength')??0)-2;

            // Tách chuỗi thành phần nguyên và phần thập phân
            var parts = input.split('.');
            var integerPart = parts[0] || ''; // Phần nguyên
            var decimalPart = parts[1] || ''; // Phần thập phân

            // Kiểm tra và ngăn nhập khi độ dài phần nguyên đạt tới giới hạn
            if (integerPart.length >= maxLength && event.data !== '.' && decimalPart.length > 0) {
                event.preventDefault();
                $('.number_item1').text("Bạn chỉ được phép nhập tối đa 8 chữ số.");
            } else {
                $('.number_item1').text("");
            }
		}
        });
		

		// check ime
		$(document).on('compositionupdate', '.number_item1', function (e) {
			try {
				start_run = true;
				e.preventDefault();
				selection_start = this.selectionStart ?? 0;
				selection_ed = this.selectionEnd ?? 0;
				selection = {
					'start': selection_start,
					'end': selection_ed
				}
				if(isNumeric(formatConvertHalfsize(e.originalEvent.data))==false) {
					window.getSelection().removeAllRanges();
				}
				
	

			} catch (e) {
				alert('.d-numeric:compositionstart ' + e.toString());
			}
		});
		$(document).on('compositionend', '.number_item1', function (e) {
			try {
				start_run = false;
				window.getSelection().removeAllRanges();
				
			} catch (e) {
				alert('.d-numeric:compositionstart ' + e.toString());
			}
		});
		$(document).on('click', '.btn-remove_11', function (e) {
			var i = ($(this).closest('.table_data_11').children('.row_data_11_count')).length - 1;
			var thi = $(this).closest('.table_data_11')
			$(this).closest('.row').remove()
			for (let j = 0; j < i; j++) {
				thi.find('.row_data_11_count:eq(' + j + ') .label_number_id_11').text(j + 1)
			}
		});

		$(document).on('keyup', function (e) {
			if (e.keyCode === 13) {
				event.preventDefault();
				if ($(':focus')[0] == $('#imageMain').find('label')[0]) {
					$('#imgInp').trigger('click');
				}
				if ($(':focus')[0] == $('#imageMain').find('button')[0]) {
					$('#btn-delete-file').trigger('click');
				}
			}
		});
		$(document).on('blur', '#password', function (e) {
			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val())) {
				$(this).val('');
			}
			checkInputUser(0);
		});
		$(document).on('blur', '#user_id', function (e) {
			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val())) {
				$(this).val('');
			}
			checkInputUser(1);
		});
		$(document).on('blur', '#company_in_dt', function () {
			if ($(this).val() != '' && $(this).val() != undefined) {
				$('a[data-toggle="tab"]').removeClass('tab-error');
			}
		});
		$(document).on('blur', '#application_date', function () {
			if ($(this).val() != '' && $(this).val() != undefined) {
				$(this).parents('.input-group').find('.error-type4').removeClass('error-type4');
				$(this).parents('.input-group').find('.boder-error').removeClass('boder-error');
				$(this).parents('.input-group').find('.textbox-error').remove();
			}
		});
		$(document).on('change', '#application_date', function () {
			$('.detail_no_data_row').val(0)
			$('.change_data_emp').val(1)
		});
		$(document).on('change', '#employee_last_nm,#employee_first_nm', function (e) {
			try {
				var employee_last_nm = $('#employee_last_nm').val();
				var employee_first_nm = $('#employee_first_nm').val();
				if (employee_last_nm != '' || employee_first_nm != '') {
					$('#employee_nm').val(employee_last_nm + ' ' + employee_first_nm);
				}
			} catch (e) {
				alert('#employee_last_nm or employee_first_nm: ' + e.message);
			}
		});
		$(document).on('click', '#btn-add-new', function (e) {
			try {
				e.preventDefault();
				jMessage(5, function (r) {
					location.reload();
				});
			} catch (e) {
				alert('#birth_date event: ' + e.message);
			}
		});
		/* left content click item */
		$(document).on('click', '#btn-delete', function (e) {
			try {
				e.preventDefault();
				jMessage(3, function (r) {
					del();
				});
			} catch (e) {
				alert('#btn-delete event: ' + e.message);
			}
		});
		// [戻る button
		$(document).on('click', '#btn-back', function () {
			try {
				var screen_from = $('#screen_from').val();
				if (screen_from == '') {
					if (_validateDomain(window.location)) {
						window.location.href = '/basicsetting/sdashboard';
					} else {
						jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
					}
				} else {
					window.close();
				}
			} catch (e) {
				alert('#btn-back: ' + e.message);
			}
		});
		//Button [パスワード通知] event
		$(document).on('click', '#btn-mail', function (e) {
			try {
				e.preventDefault();
				var employee_nm = $('#employee_nm').val();
				var password = $('#password').val();
				var mail = $('#mail').val();
				var language = $('#language_pass').val();
				//quangnd
				if (mail == '') {
					jMessage(58);
				} else {
					sendMail(employee_nm, password, mail, language);
				}
			} catch (e) {
				alert('#btn-mail event : ' + e.message);
			}
		});
		//Button [発行] event
		$(document).on('click', '#btn-random-pass', function (e) {
			try {
				e.preventDefault();
				randomPass();
			} catch (e) {
				alert('#btn-random-pass event : ' + e.message);
			}
		});
		//
		$(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			var organization_cd = $('#organization_cd:selected').val();
			getLeftContent(page, search, organization_cd);
		});
		$(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			var organization_cd = $('#organization_cd:selected').val();
			getLeftContent(page, search, organization_cd);
		});
		$(document).on('click', '#btn-search-key', function (e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#organization_nm', function (e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#company_out_dt_flg', function (e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#search_key', function (e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('enterKey', '#search_key', function (e) {
			var page = 1;
			getLeftContent(page);
		});
		/* left content click item */
		$(document).on('click', '.list-search-child', function (e) {
			$('.list-search-child').removeClass('active');
			$(this).addClass('active');
			$('#employee_cd').val($(this).attr('id'));
			$('#employee_cd').change();
		});
		// refer data employee
		$(document).on('change', '#employee_cd', function () {
			refer();
		});
		$(document).on('click', '#btn-save', function () {
			var errors = 0;
			errors = $('#company_out_dt').parents('.input-group-btn').find('.boder-error').length;
			date_callback('#company_in_dt')
			$('#company_in_dt,#company_out_dt').errorStyle(_text[24].message, 1);
			if (errors == 0) {
				jMessage(1, function (r) {
					_flgLeft = 1;
					if (r && _validate($('body'))) {
						saveData();
					}
				});
			}
		});
		$(document).on('click', '#btn-upload', function () {
			$('#imgInp').trigger('click');
		});
		$(document).on('change', '.btn-file :file', function () {
			var input = $(this),
				label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
			input.trigger('fileselect', [label]);
		});
		//btn-delete-file
		$(document).on('click', '#btn-delete-file', function () {
			try {
				var html = '<p class="w100">' + photo + '</p><img id="img-upload" class="thumb" />';
				$(".avatar .flex-box").empty();
				$(".avatar .flex-box").append(html);
				$("#imgInp").val("");
				$(this).val('Y');
				// $("#modePic").val("Y");
			} catch (e) {
				alert('#btn-delete-file' + e.message);
			}
		});
		$(document).on('change', '#imgInp', function () {
			readURLImg(this);
		});
		$(document).on('click', '#btn_show_password', function (e) {
			try {
				e.preventDefault();
				if (navigator.userAgent.indexOf("Firefox") != -1) //prevent show popup save password browser firefox
				{
					if ($(this).hasClass('notview')) {
						$(this).addClass('clicked');
						$(this).find('.fa').removeClass('fa-eye-slash');
						$(this).find('.fa').addClass('fa-eye');
						$(this).removeClass('notview');
						$('#password').attr('type', 'text');
						// $('#password').removeClass('show_typePassWord');

					} else {
						$(this).removeClass('clicked');
						$(this).find('.fa').addClass('fa-eye-slash');
						$(this).find('.fa').removeClass('fa-eye');
						$(this).addClass('notview');
						$("#password").attr('type', 'password');
						// $("#password").addClass('show_typePassWord');
					}
				} else {
					if ($(this).hasClass('notview')) {
						$(this).addClass('clicked');
						$(this).find('.fa').removeClass('fa-eye-slash');
						$(this).find('.fa').addClass('fa-eye');
						$(this).removeClass('notview');
						//$('#password').attr('type','text');
						$('#password').removeClass('show_typePassWord');
						$("#password").removeAttr('type');

					} else {
						$(this).removeClass('clicked');
						$(this).find('.fa').addClass('fa-eye-slash');
						$(this).find('.fa').removeClass('fa-eye');
						$(this).addClass('notview');
						$("#password").attr('type', 'password');
						$("#password").addClass('show_typePassWord');
					}
				}
			} catch (e) {
				alert('#btn_show_password event:' + e.message);
			}
		})
		$(document).on('keyup', '.autocomplete-down, .job', function (e) {
			try {
				var input = $(this).val();
				if (input == ' ' || input == '　') {
					$(this).val('');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		$(document).on('click', '#add_data_row_02', function () {
			try {
				if ($('.row_data_tab_2_inside').length <= 1) {
					$('.block_data_tab_02').eq(-1).append($('.row_data_tab_2_inside').eq(0).clone())
					$('.block_sort').eq(-1).attr('hidden', false)

				} else {
					$('#tab2').append($('.row_data_02_hidden').clone())
					$('.row_data_02').eq(-1).removeClass('row_data_02_hidden')
					$('.row_data_02').eq(-1).attr('hidden', false)
					// $('.row_data_tab_2_inside').eq(-1).removeClass('row_data_tab_2_inside')
				}
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '.btn-remove-row', function () {
			try {
				_mode = 1
				$(this).parents('tr').remove();
				// if ( $('#tbl-data tr').length <= 6 ) {
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
		$(document).on('click', '.btn-remove_02', function () {
			try {
				
				if ($('.row_data_02').length == 3) {
					$('.block_data_tab_02').eq(-1).find('select').val(-1)
					$('.block_sort').eq(-1).val('')
					$('.detail_no_data_row').eq(-1).val(0)
					$('.detail_no_data_row').attr('value',0)
					$('.arrange_order').eq(-1).val('')
					$('.button_add_02_div').eq(1).attr('hidden', false)
				} else {
					$(this).closest('.row_data_02').remove()
					$('.button_add_02_div').eq(1).attr('hidden', false)
				}
				
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});

		$(document).on('click', '.btn_import', function (e) {
			try {
				$(this).parents('span').find('.import_file').trigger('click');
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});
		//autocomplate commom
		$(document).on('focus', '.autocomplete-down', function (e) {
			try {
				var data = $(this).attr('availableData').split(',');
				$(this).autocomplete({
					source: data,
					minLength: 0,
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
				}).on('focus', function () { $(this).keydown(); });
			} catch (e) {
				alert('#btn-item-evaluation-input1 :' + e.message);
			}
		});

		// $(document).on('click', '#edit_checkbox', function (e) {
		// 	try {
		// 		if ($('#edit_checkbox').is(':checked') == true) {
		// 			$('#total_contract_period').attr('disabled', false)
		// 			$('#total_contract_period').focus()
		// 		} else {
		// 			$('#total_contract_period').attr('disabled', true)
		// 		}
		// 	} catch (e) {
		// 		alert('#btn-item-evaluation-input :' + e.message);
		// 	}
		// });
		$(document).on('click', '.menu_m0070_mobile li', function (e) {
			try {
				$('.menu_m0070_mobile button').trigger('click')
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});

		$(document).on('blur', '.zip_cd', function (e) {
			// var string = $(this).val();
			var string = '';
			var zip_cd = $(this).val();
			zip_cd = formatConvertHalfsize(zip_cd);
			if (zip_cd != '') {
				string = zip_cd.replace('-', '');
			}
			if (!_validateZipCd(string)) {
				$(this).val('');
			} else {
				$(this).val(string.substr(0, 3) + '-' + string.substr(3, 7));
			}
			if (zip_cd == '') {
				$(this).val("");
			}
		});
		//
		$(document).on('change', '#multilingual_typ', function (e) {
			try {
				if ($('#multilingual_typ').is(':checked')) {
					$('#supported_languages').prop('disabled', false); // Bỏ disabled nếu checkbox được chọn
				} else {
					$('#supported_languages').prop('disabled', true).val(''); // Bật disabled nếu checkbox không được chọn
				}
			} catch (e) {
				alert('#multilingual_typ:' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents:' + e.message);
	}
}

/**
 * heightCSS
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function heightCSS() {
	var heneed = $('.calHe').innerHeight();
	var hetru = $('.calHe2').innerHeight();
	var heit = heneed - hetru - 65;
	var heme = $('.list-search-content').innerHeight();
	$('.list-search-content').attr('style', 'height: ' + heit + 'px');
	if (heme > heit) {
		$('.list-search-content').addClass('scroll');
	}
	$('.calHe2').parent().parent().parent().addClass('marb50');
}

/**
 * gcd
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function gcd(u, v) {
	if (u === v) return u;
	if (u === 0) return v;
	if (v === 0) return u;
	if (~u & 1)
		if (v & 1)
			return gcd(u >> 1, v);
		else
			return gcd(u >> 1, v >> 1) << 1;

	if (~v & 1) return gcd(u, v >> 1);

	if (u > v) return gcd((u - v) >> 1, v);

	return gcd((v - u) >> 1, u);
}

/* returns an array with the ratio */
function getRatio(w, h) {
	var d = gcd(w, h);
	return [w / d, h / d];
}

/**
 * refer
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function refer() {
	var employee_cd = $('#employee_cd').val();
	if (employee_cd == '0') {
		employee_cd = '';
		$('#employee_cd').val('');
	}
	$.ajax({
		type: 'post',
		url: '/basicsetting/m0070/refer',
		dataType: 'html',
		loading: true,
		data: { employee_cd: employee_cd },
		success: function (res) {
			if (res) {
				$('#rightcontent').html(res);
				if($('#employee_nm').val() != '') {
				$('#is_refer').val(1);
				}
				$('#employee_cd').focus();
				active_left_menu();
				jQuery.formatInput();
				_autoNumeric();
				$('[data-toggle="tooltip"]').tooltip();
				$('.list-search-father').tooltip();
				addImgs();
				_formatTooltip_m0070();
				checkInputUser(0)
				setInputFilter(document.querySelectorAll('.numeric_range'), function (value) {
					return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
				});
				widthRetirement();
				removeTooltip();
			}
			//prevent show popup save password browser firefox
			if (navigator.userAgent.indexOf("Firefox") != -1) {
				$('#password').attr('autocomplete', 'off');
				$('#password').attr('type', 'password');
				$('#password').removeClass('show_typePassWord');
			}
		}
	});
}

/**
 * saveData
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
async function saveData() {
	$('.tab-error').removeClass('tab-error')
	$('.div_loading').show();
	await m0070HeaderSave()
	await Promise.all([m0070Tab1Save(),m0070Tab2Save(),saveDataTab01(),saveDataTab02(),saveDataTab03()
		,saveDataTab05(),saveDataTab06(),saveDataTab09(),saveDataTab12(),saveDataTab13(),saveDataTab08()
        ,saveDataTab04(),saveDataTab11(),saveDataTab07(),saveDataTab10(),
	])
	.then(function(error) {
		if(temp > 0) {
			jMessage(22);
			
		} else {
			jMessage(2, function (r) {
				$('.div_loading').hide();
				$('#employee_cd').trigger('focus');
			});
		}
	})
    .catch(function(error) {
		temp = 1
		if(temp > 0) {
			jMessage(22);
		}
    });
	
}
function activeHref() {
	var ele = $('.menu_m0070_pc .treatment_applications_no.active.show').attr('href')
	$(ele).addClass('active')
	$(ele).addClass('show')
	$('.menu_m0070_pc .treatment_applications_no.active.show').trigger('click')
}
function m0070HeaderSave() {
	var data = getData(_obj_header);

	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
	data.rules['#employee_cd'] = data.rules['#employee_cd'].replace(/\s+/g, '');
	data.data_sql.user_id = data.data_sql.user_id.replace(/\s+/g, '');
	data.rules['#user_id'] = data.rules['#user_id'].replace(/\s+/g, '');

	//
	data.data_sql.list_character = _getItems(0);
	data.data_sql.list_date = _getItems(1);
	data.data_sql.list_number_item = _getItems(2);
	//
	var mode_pic = "";
	var mode_flg = $('#btn-delete-file').val();
	if (typeof $('#imgInp')[0].files[0] != "undefined") {
		var mode_exists = "Y";
		$("#modePic").val("Y");
	} else {
		var mode_exists = "N";
		$("#modePic").val("N");
	}
	if (mode_flg == 'Y') {
		var mode_exists = mode_flg;
		$("#modePic").val(mode_flg);
	}
	mode_pic = $("#modePic").val();
	data.data_sql.mode_pic = mode_pic;
	data.data_sql.mode = _mode;
	data.data_sql.mode_exists = mode_exists;
	var formData = new FormData();
	formData.append('head', JSON.stringify(data));
	formData.append('file', $('#imgInp')[0].files[0]);
	return new Promise((resolve, reject) => {
	$.ajax({
		type: 'post',
		data: formData,
		url: '/basicsetting/m0070/postSaveHeaderInfo',
		
		processData: false,
		contentType: false,
		enctype: "multipart/form-data",
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					$('#employee_cd').val(res['employee_cd'])
					getReferHeader(res['employee_cd'])
					referDepartment(res['employee_cd'])
					resolve(true)
					break;
				// error
				case NG:
					resolve(true)
					break;
				case 404:
					resolve(true)
					break;
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
function m0070Tab1Save() {
	var data = getData(_obj1);
	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
	data.rules['#employee_cd'] = data.rules['#employee_cd'].replace(/\s+/g, '');
	data.data_sql.user_id = data.data_sql.user_id.replace(/\s+/g, '');
	data.rules['#user_id'] = data.rules['#user_id'].replace(/\s+/g, '');
	var evaluated_typ = 0;
	if ($('#evaluated_typ').is(':checked')) {
		evaluated_typ = 0;
	} else {
		evaluated_typ = 1;
	}
	data.data_sql.evaluated_typ = evaluated_typ;

	var oneonone_typ = 0;
	if ($('#oneonone_typ').is(':checked')) {
		oneonone_typ = 0;
	} else {
		oneonone_typ = 1;
	}
	data.data_sql.oneonone_typ = oneonone_typ;

	var multireview_typ = 0;
	if ($('#multireview_typ').is(':checked')) {
		multireview_typ = 0;
	} else {
		multireview_typ = 1;
	}
	data.data_sql.multireview_typ = multireview_typ;
	var report_typ = 0;
	if ($('#report_typ').is(':checked')) {
		report_typ = 0;
	} else {
		report_typ = 1;
	}
	data.data_sql.report_typ = report_typ;
	var director_typ = 0;
	if ($('#director_typ').is(':checked')) {
		director_typ = 0;
	} else {
		director_typ = 1;
	}
	data.data_sql.director_typ = director_typ;
	var multilingual_typ = 0;
	if ($('#multilingual_typ').is(':checked')) {
		multilingual_typ = 1;
	} 
	data.data_sql.multilingual_typ = multilingual_typ;
	//
	data.data_sql.list_character = _getItems(0);
	data.data_sql.list_date = _getItems(1);
	data.data_sql.list_number_item = _getItems(2);
	//
	var mode_pic = "";
	var mode_flg = $('#btn-delete-file').val();
	if (typeof $('#imgInp')[0].files[0] != "undefined") {
		var mode_exists = "Y";
		$("#modePic").val("Y");
	} else {
		var mode_exists = "N";
		$("#modePic").val("N");
	}
	if (mode_flg == 'Y') {
		var mode_exists = mode_flg;
		$("#modePic").val(mode_flg);
	}
	mode_pic = $("#modePic").val();
	data.data_sql.mode_pic = mode_pic;
	data.data_sql.mode = _mode;
	data.data_sql.mode_exists = mode_exists;
	var formData = new FormData();
	formData.append('head', JSON.stringify(data));
	formData.append('file', $('#imgInp')[0].files[0]);
	return new Promise((resolve, reject) => {
	$.ajax({
		type: 'post',
		data: formData,
		url: '/basicsetting/m0070/postSaveLoginInfo',

		processData: false,
		contentType: false,
		enctype: "multipart/form-data",
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					$('#employee_cd').val(res['employee_cd'])
					referLoginInfo(res['employee_cd'])
					resolve(true)
					break;
				// error
				case NG:
					if (typeof res['errors'] != 'undefined') {
						processError(res['errors']);
					}
					break;
				case 404:
					resolve(true)
					break;
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

function m0070Tab2Save() {

	var data = getData(_obj2);

	data.data_sql.employee_cd = data.data_sql.employee_cd.replace(/\s+/g, '');
	data.rules['#employee_cd'] = data.rules['#employee_cd'].replace(/\s+/g, '');
	data.data_sql.user_id = data.data_sql.user_id.replace(/\s+/g, '');
	data.rules['#user_id'] = data.rules['#user_id'].replace(/\s+/g, '');

	//
	var formData = new FormData();
	formData.append('head', JSON.stringify(data));

	return new Promise((resolve, reject) => {

	$.ajax({
		type: 'post',
		data: formData,
		url: '/basicsetting/m0070/postSaveEmpInfo',
		processData: false,
		contentType: false,
		enctype: "multipart/form-data",
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					$('#employee_cd').val(res['employee_cd'])
					referEmpInfo(res['employee_cd'])
					resolve(true)
					break;
				// error
				case NG:
					if (typeof res['errors'] != 'undefined') {
						processError(res['errors']);
					}
					break;
				case 404:
					resolve(true)
					break;
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
 * del
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function del() {
	var data = getData(_obj);
	var evaluated_typ = 0;
	if ($('#evaluated_typ').is(':checked')) {
		evaluated_typ = 0;
	} else {
		evaluated_typ = 1;
	}
	data.data_sql.evaluated_typ = evaluated_typ;
	$.ajax({
		type: 'post',
		data: JSON.stringify(data),
		url: '/basicsetting/m0070/del',
		loading: true,
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					jMessage(4, function (r) {
						$('#rightcontent').find('input,select,checkbox').val('');
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
}

/**
 * delRow
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function delRow(application_date) {
	var employee_cd = $('#employee_cd').val();
	$.ajax({
		type: 'post',
		data: { application_date: application_date, employee_cd: employee_cd },
		url: '/basicsetting/m0070/del_row',
		loading: true,
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					$('#employee_cd').focus();
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
function getLeftContent(page) {
	try {
		var list = [];
		list.push({
			'organization_cd_1': $('#organization_nm').val() == 0 ? '' : $('#organization_nm').val(),
			'organization_cd_2': '',
			'organization_cd_3': '',
			'organization_cd_4': '',
			'organization_cd_5': '',
		});
		// send data to post
		var search = $('#search_key').val();
		var company_out_dt_flg = 0;
		if ($('#company_out_dt_flg').is(':checked')) {
			company_out_dt_flg = 1;
		}
		var data = {
			current_page: page
			, search_key: search
			, organization_step1: JSON.stringify(list)
			, company_out_dt_flg: company_out_dt_flg
		}
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/leftcontent',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
					$('#leftcontent .inner').empty();
					$('#leftcontent .inner').html(res);
					var heneed = $('.calHe').innerHeight();
					var hetru = $('.calHe2').innerHeight();
					var heit = heneed - hetru - 110;
					var heme = $('.list-search-content').innerHeight();
					_formatTooltip_m0070();
					if (heme > heit) {
						$('.list-search-content').addClass('scroll');
					}
					if (_flgLeft != 1) {
						$('#search_key').focus();
					} else {
						$('#employee_cd').focus();
						_flgLeft = 0;
					}
					$('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
					$('.list-search-father').tooltip();
					if (active_left_menu) {
						active_left_menu();
					}
				}
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}

/**
 * readURL
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function readURLImg(input) {
	console.log(input.files[0])
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function (e) {
			
			//
			$('#img-upload').attr('src', e.target.result);
			$('#img-upload').closest('div').addClass('loaded');
			$('#img-upload').closest('div').find('p').remove();
			// var img = document.getElementById('img-upload');
			var ratio = getRatio($('#img-upload').prop('naturalWidth'), $('#img-upload').prop('naturalHeight'));
			var frame_with = '120px';
			var height = '120px';
			$("img").addClass("imgs");
		}
		reader.readAsDataURL(input.files[0]);
	}
}

$('#btn-send-html').on('click', function () {
	var data = {
		'_token': '{{ csrf_token() }}',
		'data': { customer_name: $('#customer_name').val() },
		'to': $('#to').val(),
		'subject': $('#subject').val(),
		'body': $('#body').val(),
		'cc': $('#cc').val(),
		'bcc': $('#bcc').val(),
		'mail_type': 'html',
		'attachs': $('#attachs').val(),
	};
	$.sendEmail(data, function (res) {
		alert(res['status']);
	});
});

/**
 * sendMail
 *
 * @author      :   viettd - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function sendMail(employee_nm, password, mail, language) {
	try {
		$.ajax({
			type: 'post',
			data: {
				employee_nm: employee_nm,
				password: password,
				mail: mail,
				language: language
			},
			url: '/basicsetting/m0070/pass_notification',
			loading: true,
			success: function (res) {
				console.log(res);
				switch (res['status']) {
					// success
					case OK:
						jMessage(35);
						break;
					// error
					case NG:
						jMessage(81,function(r){
						//
						});	
					// Exception
					case EX:
						jMessage(81,function(r){
						//
						});	
						break;
					default:
						break;
				}
			},
			error: function (jqXHR, exception) {
				jMessage(81,function(r){
					//
					});	
			},
		});
	} catch (e) {
		alert('sendMail' + e.message);
	}
}

/**
 * randomPass
 *
 * @author      :   viettd - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function randomPass() {
	try {
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/randompass',
			dataType: 'json',
			//loading     :   true,
			data: {},
			success: function (res) {
				if (res['status'] == OK) {
					if (typeof res['password'] != undefined) {
						// $('#password').val(res['password']);
						$('#password').val(htmlEntities(res['password']));
					}
				} else {
					$('#password').val('');
				}
			}
		});
	} catch (e) {
		alert('randomPass' + e.message);
	}
}

/**
 * calculateAge
 *
 * @author      :   viettd - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function calculateAge(date_from = '', date_to = '', mode = 0) {
	try {
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/getyear',
			dataType: 'json',
			loading: false,
			data: {
				date_from: date_from
				, date_to: date_to
				, mode: mode
			},
			success: function (res) {
				if (res['status'] == OK) {
					_clearErrors(1);
					if (mode == 0) {
						$('#year_old').val(res['year_num']);
					} else if (mode == 1) {
						if (res['year_check'] == 1) {
							$('#company_in_dt,#company_out_dt').errorStyle(_text[24].message, 1);
							$('#period_date').val('');
						} else {
							$('#period_date').val(res['year_num']);
						}
					}
				} else {
					if (mode == 0) {
						$('#year_old').val('');
					} else if (mode == 1) {
						$('#period_date').val('');
					}
				}
			}
		});
	} catch (e) {
		alert('calculateAge' + e.message);
	}
}
function active_left_menu() {
	var employee_cd = $('#employee_cd').val();
	$('.list-search-child').removeClass('active');
	$('.list-search-child').each(function () {
		_this = $(this);
		if (_this.attr('id') == employee_cd) {
			_this.addClass('active');
		}
	})
}
function employee_cd_change() {
	$('#employee_cd').change();
}

function addImgs() {
	var imgs = $("img").attr("src");
	if (imgs != '') {
		$("#img-upload").css("width", "120px");
		//$("#img-upload").css("height","120px");
	}
}

/**
 * date_callback
 *
 * @author      :   datnt - 2018/12/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function date_callback(el) {
	try {
		var cur_year = new Date();
		var item = $(el).attr('id');
		if (item == 'birth_date') {
			var birth_date = $(el).val();
			if (birth_date != '') {
				calculateAge(birth_date, '', 0);
			} else {
				$('#year_old').val('');
			}
		}
		else if (item == 'company_in_dt') {
			var company_out_dt = $('#company_out_dt').val();
			var company_in_dt = $(el).val();
			var company_in_date = new Date(company_in_dt);
			if (company_in_dt != '' && company_in_date < cur_year) {
				calculateAge(company_in_dt, company_out_dt, 1);
			} else if ((company_in_dt > company_out_dt) || company_in_dt == '') {
				$('#period_date').val('');
			}
			var application_date = $('#application_date').val();
			var is_refer = $('#is_refer').val();
			if (application_date == '' && is_refer == '0') {
				$('#application_date').val(company_in_dt);
			}
		} else if (item == 'company_out_dt') {
			var company_out_dt = $(el).val();
			var company_in_dt = $('#company_in_dt').val();
			calculateAge(company_in_dt, company_out_dt, 1);
		}
	} catch (e) {
		alert('#birth_date event: ' + e.message);
	}
}

function clear_info() {
	var html = '<p class="w100">' + photo + '</p><img id="img-upload" class="thumb" />';
	$(".avatar .flex-box").empty();
	$(".avatar .flex-box").append(html);
	$("#imgInp").val("");
	$('#rightcontent input').val('');
	$('#rightcontent select').val('-1');
	$('#rightcontent select option').removeAttr('selected');
	$('#rightcontent select option:eq(0)').attr('selected');
	$("#belong_cd1").val(0);
	$("#belong_cd2").val(0);
	$('#employee_cd').focus();
	$('#result').empty();
	$('#evaluated_typ').prop('checked', false);
	$('#director_typ').prop('checked', false);
	$('#oneonone_typ').prop('checked', false);
	$('#multireview_typ').prop('checked', false);
	$('#report_typ').prop('checked', false);
	$('.number_item').prop('checked', false);
	$('.number_item').val('');
	$('#rd1').val(1);
	$('.btn-remove-row_tab10').trigger('click')
	document.getElementById("rd1").checked = true;
	document.getElementById("rd2").checked = false;
	document.getElementById("ins_rd1").checked = true;
	document.getElementById("ins_rd2").checked = false;
	document.getElementById("ins_rd21").checked = true;
	document.getElementById("ins_rd22").checked = false;
	document.getElementById("ins_rd31").checked = true;
	document.getElementById("ins_rd32").checked = false;
	document.getElementById("ins_rd41").checked = true;
	document.getElementById("ins_rd42").checked = false;
	clearInfoTab05();
	active_left_menu();
	checkInputUser(0);
	_autoNumeric();
	// clear each tabs
	$('#table-tab03 .list_tab_03').remove();
    $('#btn-add-new-row-tab3').trigger('click');
}

function setInputFilter(textbox, inputFilter) {
	textbox.forEach(item => {
		["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop"].forEach(function (event) {
			item.addEventListener(event, function () {
				if (inputFilter(this.value)) {
					this.oldValue = this.value;
					this.oldSelectionStart = this.selectionStart;
					this.oldSelectionEnd = this.selectionEnd;
				} else if (this.hasOwnProperty("oldValue")) {
					this.value = this.oldValue;
					this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
				} else {
					this.value = "";
				}
			});
		});
	});
}

/**
* tooltip format
*
* @author  :   longvv - 2018/12/05 - create
* @author  :
* @param 	:	error array ex ['e1','e2']
*/
function _formatTooltip_m0070() {
	try {
		$('.text-overfollow').each(function (i) {
			var element = $(this)
				.clone()
				.css({ display: 'inline', width: 'auto', visibility: 'hidden' })
				.appendTo('body');
			var $table = $("#tab2");
			$table.css({ position: "absolute", visibility: "hidden", display: "block" });
			if (element.width() <= Math.round($(this).width())) {
				$(this).removeAttr('data-original-title');
			}
			$table.css({ position: "", visibility: "", display: "" });
			element.remove();
		});
	} catch (e) {
		alert('format tooltip ' + e.message);
	}
}

function checkInputUser(mode) {
	user = $('#user_id').val();
	if (user == '' || user == undefined) {
		$('.s0010_info :input:not(#evaluated_typ):not(#oneonone_typ):not(#multireview_typ):not(#report_typ):not(#director_typ):not(#multilingual_typ)').prop('disabled', true);
		$('.s0010_info :input:not(#evaluated_typ):not(#oneonone_typ):not(#multireview_typ):not(#report_typ):not(#director_typ)').val('');
		$('#director_typ').prop('checked', false);
		$('#multilingual_typ').prop('checked', false);
		$('#password').prop('disabled', true);
		$('#password').val('');
		$('.s0010_info :input').val('');
		$('#password').removeClass('required');
	} else {
		if (!$('#director_typ').prop('checked')) {
			$('.s0010_info :input:not(#supported_languages)').prop('disabled', false);
		}
		$('#password').prop('disabled', false);
		$('#password').addClass('required');
		if (mode == 1) {
			$('#password').focus();
		}
	}
}

/**
* widthRetirement
*
* @author  :   quangnd- create
* @author  :
* @param 	:	error array ex ['e1','e2']
*/
function widthRetirement() {
	try {
		var width = $('#retirement_reason_typ_nm').width();
		$('#retirement_reason').css("padding-left", width + 10)
	} catch (e) {
		alert('widthRetirement: ' + e.message);
	}
}

/**
* removeTooltip
*
* @author  :   quangnd- create
* @author  :
* @param 	:	error array ex ['e1','e2']
*/
function removeTooltip() {
	try {
		var retirement_reason_typ_nm = $('#retirement_reason_typ_nm').val();
		var retirement_reason = $('#retirement_reason').val();
		if (retirement_reason_typ_nm == '' && retirement_reason == '') {
			$('#tontip').removeAttr('data-original-title');
		}
	} catch (e) {
		alert('removeTooltip: ' + e.message);
	}
}

/**
 * validate zip code
 *
 * @param string
 * @returns {boolean}
 */
function _validateZipCd(zip_cd) {
    try {
        var reg1 = /^[0-9]{3}-[0-9]{4}$/;
        var reg2 = /^[0-9]{3}[0-9]{4}$/;
        //
        if (zip_cd.match(reg1) || zip_cd.match(reg2) || zip_cd == '') {
            return true;
        } else {
            return false;
        }
    } catch (e) {
        alert('_validateZipCd: ' + e);
    }
}
function getReferHeader(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referHeader',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.header_employee').html(res);
			}
		});
	} catch (e) {
		alert('getReferTab09: ' + e.message);
	}
}
function referLoginInfo(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referLoginInfo',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('#tab1').html(res);
				checkInputUser(0)
			}
		});
	} catch (e) {
		alert('getReferTab09: ' + e.message);
	}
}
function referEmpInfo(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referEmpInfo',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab2').remove();
                $('.tab-content').append(res);
			}
		});
	} catch (e) {
		alert('getReferTab09: ' + e.message);
	}
}
function referDepartment(employee_cd) {
	try {
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/referDepartment',
			dataType: 'html',
			
			data: {'employee_cd': employee_cd, 'mode': '1'},
			success: function (res) {
                $('.tab-content').find('#tab3').remove();
                $('.tab-content').append(res);
			}
		});
	} catch (e) {
		alert('getReferTab09: ' + e.message);
	}
}
function isNumeric(str) {
    return !isNaN(str) && !isNaN(parseFloat(str));
}
function convertFullSizeToHalfSize(str) {
	return str.replace(/[\uFF10-\uFF19\uFF0E]/g, function(ch) {
		return String.fromCharCode(ch.charCodeAt(0) - 0xFEE0);
	});
}
function isValidNumberAndPeriod(str) {
	// Kiểm tra chuỗi chỉ chứa số full-size, số half-size và dấu chấm full-size, half-size
	var regex = /^[0-9\uFF10-\uFF19.\uFF0E]+$/;
	return regex.test(str);
}
function isValidDecimal(str) {
	// Biểu thức chính quy để kiểm tra định dạng số thập phân với phần nguyên và phần thập phân tùy chọn
	var regex = /^\d+(\.\d{1})?$/;
	return regex.test(str);
}