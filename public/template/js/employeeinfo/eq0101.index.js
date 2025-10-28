(function ($) {
	$.fn.hasScrollBar = function () {
		return this.get(0).scrollHeight > this.height();
	}
})(jQuery);

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
			'position_cd': { 'type': 'text', 'attr': 'class' },
			'job_cd': { 'type': 'text', 'attr': 'class' },
			'employee_typ': { 'type': 'text', 'attr': 'class' },
			'grade': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _mode = 0;
var _flgLeft = 0;
var index_11 = 1
var index_8 = 1
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


function initialize() {
	try {
		checkInputUser();
		setInputFilter(document.querySelectorAll('.numeric_range'), function (value) {
			return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
		});
		$('#employee_cd').focus();

		var employee_cd = $('#employee_cd').val();
		$('.list-search-content div[id="' + employee_cd + '"]').addClass('active');
		_formatTooltip_m0070();
		removeToltip();
		// heightCSS();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/**
 * initialize
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
				$('#multireview_authority_cd').prop("disabled", true);
				$('#setting_authority_cd').prop("disabled", true);
				$('#report_authority_cd').prop("disabled", true);
				$('#authority_cd').val(0);
				$('#oneonone_authority_cd').val(0);
				$('#multireview_authority_cd').val(0);
				$('#setting_authority_cd').val(0);
				$('#report_authority_cd').val(0);
			} else {
				$('#authority_cd').prop("disabled", false);
				$('#oneonone_authority_cd').prop("disabled", false);
				$('#multireview_authority_cd').prop("disabled", false);
				$('#setting_authority_cd').prop("disabled", false);
				$('#report_authority_cd').prop("disabled", false);
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
		})
		$(document).on('blur', '#password', function (e) {
			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val())) {
				$(this).val('');
			}
			checkInputUser(0);
		})
		$(document).on('blur', '#user_id', function (e) {
			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val())) {
				$(this).val('');
			}
			checkInputUser(1);
		})

		$(document).on('blur', '#company_in_dt', function () {
			if ($(this).val() != '' && $(this).val() != undefined) {
				$('a[data-toggle="tab"]').removeClass('tab-error');
			}
		})
		$(document).on('blur', '#application_date', function () {
			if ($(this).val() != '' && $(this).val() != undefined) {
				$(this).parents('.input-group').find('.error-type4').removeClass('error-type4');
				$(this).parents('.input-group').find('.boder-error').removeClass('boder-error');
				$(this).parents('.input-group').find('.textbox-error').remove();
			}
		})
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
					//location.reload();
					clear_info();
					// $('#rightcontent').empty();
					// $('#rightcontent').append()
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
						window.location.href = '/employeeinfo/edashboard';
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
		//
		// $(document).on('click', '#del_row', function(e) {
		// 	try{
		// 		var application_date = $(this).parents('tr').find('.application_date').val();
		// 		delRow(application_date);
		// 	}catch(e){
		// 		alert('#btn-delete event: '+e.message);
		// 	}
		// });
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
			var employee_cd = $(this).val();
			// var result = parseFloat(employee_cd.replace(/,/g, ""));
			/*	if(!checkHalfSize(employee_cd) || !result || result === 0){
				 $(this).val('');
				 clear_info();
			 }else if(employee_cd == 0){
				 clear_info();
				 $(this).errorStyle(_text[8].message,1);
			 }else{
				 */
			refer();
			// }
			// if(employee_cd!= ''){

			// }
		});

		$(document).on('click', '#btn-save', function () {
			var errors = 0;
			errors = $('#company_out_dt').parents('.input-group-btn').find('.boder-error').length;
			// if( $('#company_out_dt').val() != '' && $('#company_out_dt').val() <= $('#company_in_dt').val() )
			// {
			// 	jMessage(24,function (r) {
			// 		clear_info();
			// 	});	
			// 	errors = 1;			
			// }
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
		//
		$(document).on('change', '.btn-file :file', function () {
			var input = $(this),
				label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
			input.trigger('fileselect', [label]);
		});

		//btn-delete-file
		$(document).on('click', '#btn-delete-file', function () {
			try {
				var html = '<p class="w100">'+photo+'</p><img id="img-upload" class="thumb" />';
				$(".avatar .flex-box").empty();
				$(".avatar .flex-box").append(html);
				$("#imgInp").val("");
				$(this).val('Y');
				// $("#modePic").val("Y");
			} catch (e) {
				alert('#btn-delete-file' + e.message);
			}
		});

		//
		// $("#imgInp").change(function () {
		// 	readURL(this);
		// });
		$(document).on('change', '#imgInp', function () {

			readURL(this);
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

		//btn-remove-row
		$(document).on('click', '.btn-remove-row', function () {
			try {
				_mode = 1
				$(this).parents('tr').addClass('hidden-tr');
				$(this).closest('.table').find('tbody tr').not('.hidden-tr').each(function (i, t) {
					$(this).find('.no').empty().html(i + 1);
				});
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
		//btn-add-row
		$(document).on('click','.btn-add-new-row',function () {
			try{
				var row = $(this).closest('.table-responsive-right').find('.table-target tr:first').clone();
				var number_row = $(this).closest('.table').find('tbody tr').length + 1
				$(this).closest('.table').append(row);
				$(this).closest('.table').find('tbody tr:last td:first-child').text(number_row);
				$(this).closest('.table').find('tbody tr:last td:first-child input').focus();
				$(this).closest('.table').find('tbody tr:last').addClass('list_point_kinds');
			} catch(e){
				alert('btn-add-new: ' + e.message);
			}
		});

		//btn-add-row
		$(document).on('click','.btn-add-new-row-1',function () {
			try{
				var row = $(this).closest('.table-responsive-right').find('.table-target-1 tr').clone();
				var number_row = $(this).closest('.table').find('tbody tr .no').length + 1
				row.attr('cate_no-head', number_row);
				$(this).closest('.table').append(row);
				$(this).closest('.table').find('.no:last').empty().html(number_row);
				$(this).closest('.table').find('tbody tr:last td:first-child input').focus();
				$(this).closest('.table').find('tbody tr:last').addClass('list_point_kinds');
			} catch(e){
				alert('btn-add-new: ' + e.message);
			}
		});
		$(document).on('click', '.btn-remove-row-1', function () {
			try {
				stt = $(this).parents('tr').attr('cate_no-head');
				$(this).closest('.table').find('tbody tr[cate_no-head!= '+ stt + ']').find('.no').each(function (i, t) {
					$(this).empty().html(i+1);
				});
				$(this).closest('.table').find('tbody tr[cate_no-head='+ stt + ']').remove();
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#add_data_row_02', function () {
			try {
				$('.table_data_02').append($('.data_row_02').clone())
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#button_11_add', function () {
			try {
				
				$('.table_data_11').append($('.row_data_11').clone())
				$('.row_data_11').eq(-1).find('.label_number_id_11').text(index_11+1)
				$('.row_data_11').eq(-1).removeClass('row_data_11')
				index_11 = index_11+1
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#add_row_data_08', function () {
			try {
				$('.table_data_08').append($('.row_data_08').clone())
				$('.row_data_08').eq(-1).find('.label_number_id_8').text(index_8+1)
				$('.row_data_08').eq(-1).removeClass('row_data_08')
				index_8 = index_8+1
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#button_12_add_1', function () {
			try {
				$('.table_12_add_1').append($('.row_12_add_1').clone())
				$('.row_12_add_1').eq(-1).find('.button_12_add_1').empty()
				$('.row_12_add_1').eq(-1).removeClass('row_12_add_1')
				
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#button_12_add_2', function () {
			try {
				$('.table_12_add_2').append($('.row_12_add_2').clone())
				$('.row_12_add_2').eq(-1).find('.button_12_add_2').empty()
				$('.row_12_add_2').eq(-1).removeClass('row_12_add_2')
				
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#button_12_add_3', function () {
			try {
				$('.table_12_add_3').append($('.row_12_add_3').clone())
				$('.row_12_add_3').eq(-1).find('.button_12_add_3').empty()
				$('.row_12_add_3').eq(-1).removeClass('row_12_add_3')
				
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('click', '#button_12_add_4', function () {
			try {
				$('.table_12_add_4').append($('.row_12_add_4').clone())
				$('.row_12_add_4').eq(-1).find('.button_12_add_4').empty()
				$('.row_12_add_4').eq(-1).removeClass('row_12_add_4')
				
			} catch (e) {
				alert('btn-remove-row: ' + e.message);
			}
		});
		$(document).on('change', '.vehicle_select', function () {
			var optionSelected = $("option:selected", this);
			$(this).closest('.row').find('.block_append_8').remove()
			if(optionSelected.val() == 1||optionSelected.val() == 0) {
				$(this).closest('.row').append($('.vehicle_hidden_1').children().clone())
			} else if(optionSelected.val() == 2) {
				$(this).closest('.row').append($('.vehicle_hidden_4').children().clone())
			} else if(optionSelected.val() == 3) {
				$(this).closest('.row').append($('.vehicle_hidden_2').children().clone())
			} else {
				$(this).closest('.row').append($('.vehicle_hidden_3').children().clone())
			}
			$(this).closest('.row').find('.vehicle_hidden_1').attr('hidden',false)
		});
		$(document).on('click', '.menu_m0070_mobile li', function (e) {
			try {
				$('.menu_m0070_mobile button').trigger('click')
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});
		// Excel出力
		$(document).on("click", "#btn-employee-info-output", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
				excel();
			}
		});
	} catch (e) {
		alert('initEvents:' + e.message);
	}
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
		url: '/employeeinfo/eq0101/refer',
		dataType: 'html',
		loading: true,
		data: { employee_cd: employee_cd },
		success: function (res) {
			if (res) {
				$('#rightcontent').html(res);
				$('#employee_cd').focus();
				active_left_menu();
				jQuery.formatInput();
				_autoNumeric();
				// app.jTableFixedHeader();
				// var heneed=$('.calHe').innerHeight();
				// var hetru=$('.calHe2').innerHeight();
				// var heit=heneed-hetru-55;
				// var heme=$('.list-search-content').innerHeight();
				// $('.list-search-content').attr('style','height: '+ heit +'px');
				// if(heme>heit){
				// 	$('.list-search-content').addClass('scroll');
				// }
				// $('.calHe2').parent().parent().parent().addClass('marb50');
				$('[data-toggle="tooltip"]').tooltip();
				$('.list-search-father').tooltip();
				addImgs();
				_formatTooltip_m0070();
				checkInputUser(0)
				// heightCSS();
				setInputFilter(document.querySelectorAll('.numeric_range'), function (value) {
					return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
					
				});
				widthRetirement();
				removeToltip();
				_formatTooltip();
			}
			if (navigator.userAgent.indexOf("Firefox") != -1) //prevent show popup save password browser firefox
			{
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
function saveData() {
	var data = getData(_obj);
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
		//modePic= "N";
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
	$.ajax({
		type: 'post',
		data: formData,
		url: '/basicsetting/m0070/postSave',
		loading: true,
		processData: false,
		contentType: false,
		enctype: "multipart/form-data",
		success: function (res) {
			switch (res['status']) {
				// success
				case OK:
					//
					jMessage(2, function (r) {
						clear_info();

						var page = $('#leftcontent').find('.active a').attr('page');
						getLeftContent(page);

					});
					_mode = 0;
					break;
				// error
				case NG:
					if (typeof res['errors'] != 'undefined') {
						processError(res['errors']);
					}
					break;
				case 404:
					jMessage(27);
					break;
				// Exception
				case EX:
					jError(res['Exception']);
					break;
				default:
					break;
			}
		}
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
	})
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
					// $('.list-search-content').attr('style','height: '+ heit +'px');
					_formatTooltip_m0070();
					if (heme > heit) {
						$('.list-search-content').addClass('scroll');
					}
					// var job_cd = $('#job_cd').val();
					// $('.list-search-content div[id="'+job_cd+'"]').addClass('active');
					// $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
					// if(_flgLeft != 1){
					//     $('#search_key').focus();
					// }
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
function readURL(input) {
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
				mail:mail, 
				language:language
			},
			url: '/basicsetting/m0070/pass_notification',
			loading: true,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(35);
						break;
					// error
					case NG:
						// if (typeof res['errors'] != 'undefined') {
						// 	processError(res['errors']);
						// }
						jMessage(81,function(r){
							//
						});	
						break;
					// Exception
					case EX:
						jMessage(81,function(r){
							//
						});	
						break;
					default:
						break;
				}
			}
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
 * caculateAge
 *
 * @author      :   viettd - 2018/08/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function caculateAge(date_from = '', date_to = '', mode = 0) {
	try {
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/basicsetting/m0070/getyear',
			dataType: 'json',
			loading: true,
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
		alert('caculateAge' + e.message);
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

/* Check halfsize alphanumeric
* @param string
* @returns {Boolean}
*/
function _validateHalfSizeAlphanumeric(string) {
	//	string = _formatString(string);
	var regexp = /^[a-zA-Z0-9]+$/;
	if (regexp.test(string) || string == '') {
		return true;
	} else {
		return false;
	}
}

function addImgs() {
	var imgs = $("img").attr("src");
	if (imgs != '') {
		$("#img-upload").css("width", "120px");
		//$("#img-upload").css("height","120px");
	}
}
/**
 * caculateAge
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
			var birth_date_convert = new Date(birth_date);
			if (birth_date != '') {
				caculateAge(birth_date, '', 0);
			} else {
				$('#year_old').val('');
			}
		}
		else if (item == 'company_in_dt') {
			var company_out_dt = $('#company_out_dt').val();
			var company_in_dt = $(el).val();
			var company_in_date = new Date(company_in_dt);
			if (company_in_dt != '' && company_in_date < cur_year) {
				caculateAge(company_in_dt, company_out_dt, 1);
			} else if ((company_in_dt > company_out_dt) || company_in_dt == '') {
				//$(el).val('');
				$('#period_date').val('');
			}
			var application_date = $('#application_date').val();
			if (application_date == '') {
				$('#application_date').val(company_in_dt);
			}
		} else if (item == 'company_out_dt') {
			var company_out_dt = $(el).val();
			var company_in_dt = $('#company_in_dt').val();
			// if(company_out_dt != ''){
			caculateAge(company_in_dt, company_out_dt, 1);
			// }
		}
	} catch (e) {
		alert('#birth_date event: ' + e.message);
	}
}
function checkHalfSize(str) {
	str = (str == null) ? "" : str;
	if (str.match(/^[A-Za-z0-9]*$/)) {
		return true;
	} else {
		return false;
	}

}
function _validateFullSize(string) {
	try {
		// string = $.rtrim(string);
		string = $.mbRTrim(string);
		if ($.byteLength(string) != string.length) {
			return true;
		} else {
			return false;
		}
	} catch (e) {
		alert('_validateFullSize: ' + e);
	}
}
function clear_info() {
	var html = '<p class="w100">'+photo+'</p><img id="img-upload" class="thumb" />';
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
	document.getElementById("rd1").checked = true;
	document.getElementById("rd2").checked = false;
	active_left_menu();
	checkInputUser(0);
	_autoNumeric();
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
	})


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
			var i = 1;
			var colorText = '';
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
		$('#s0010_info :input:not(#evaluated_typ):not(#oneonone_typ):not(#multireview_typ):not(#report_typ)').prop('disabled', true);
		$('#s0010_info :input:not(#evaluated_typ):not(#oneonone_typ):not(#multireview_typ):not(#report_typ)').val('');
		$('#director_typ').prop('checked', false);
		$('#password').prop('disabled', true);
		$('#password').val('');
		$('#s0010_info :input').val('');
		$('#password').removeClass('required');
	} else {
		if (!$('#director_typ').prop('checked')) {
			$('#s0010_info :input').prop('disabled', false);
		}
		$('#password').prop('disabled', false);
		$('#password').addClass('required');
		if(mode == 1){
			$('#password').focus();
		}
	}
}
/**
* tooltip format
*
* @author  :   quangnd- create
* @author  :
* @param 	:	error array ex ['e1','e2']
*/
function widthRetirement() {
	try {
		var width = $('#retirement_reason_typ_nm').width();
		$('#retirement_reason').css("padding-left", width+10)
	} catch (e) {
		alert('widthRetirement: ' + e.message);
	}
}
/**
* tooltip format
*
* @author  :   quangnd- create
* @author  :
* @param 	:	error array ex ['e1','e2']
*/
function removeToltip() {
	try {
		var retirement_reason_typ_nm = $('#retirement_reason_typ_nm').val();
		var retirement_reason = $('#retirement_reason').val();
		if (retirement_reason_typ_nm =='' && retirement_reason==''){
			$('#tontip').removeAttr('data-original-title');
		}
	} catch (e) {
		alert('widthRetirement: ' + e.message);
	}
}

/*
 * search
 * @author    : quanlh - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function excel() {
	try {
		var data = getData(_obj);
		//
		$.downloadFileAjax('/employeeinfo/eq0101/export-excel', JSON.stringify(data));
	} catch (e) {
		alert('excel: ' + e.message);
	}
}