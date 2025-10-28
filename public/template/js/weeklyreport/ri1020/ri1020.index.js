
/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	'report_kinds': { 'type': 'select', 'attr': 'id' },
	'year': { 'type': 'select', 'attr': 'id' },
	'fiscal_year': { 'type': 'select', 'attr': 'id' },
	'month': { 'type': 'select', 'attr': 'id' },
	'times': { 'type': 'select', 'attr': 'id' },
	'detail_no': { 'type': 'select', 'attr': 'id' },
	'group_cd': { 'type': 'select', 'attr': 'id' },
	'ck_search': { 'type': 'checkbox', 'attr': 'id' },
	'employee_cdX': { 'type': 'text', 'attr': 'id' },
	'tr_first_value': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'approver_employee_cd_1': { 'type': 'text', 'attr': 'class' },
			'approver_employee_cd_2': { 'type': 'text', 'attr': 'class' },
			'approver_employee_cd_3': { 'type': 'text', 'attr': 'class' },
			'approver_employee_cd_4': { 'type': 'text', 'attr': 'class' },
			'approver_employee_nm_1': { 'type': 'text', 'attr': 'class' },
			'approver_employee_nm_2': { 'type': 'text', 'attr': 'class' },
			'approver_employee_nm_3': { 'type': 'text', 'attr': 'class' },
			'approver_employee_nm_4': { 'type': 'text', 'attr': 'class' },
			'approver_employee_nm_4': { 'type': 'text', 'attr': 'class' },
			// sheet
			'sheet': { 'type': 'select', 'attr': 'class' },
			'adaption_date': { 'type': 'text', 'attr': 'class' },
			// schedule sheet
			'schedule_sheet_cd': { 'type': 'select', 'attr': 'class' },
			'schedule_adaption_date': { 'type': 'text', 'attr': 'class' },
			'pos_emp': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _obj_approver = {
	'approval_row': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _obj_del = {
	'report_kinds': { 'type': 'select', 'attr': 'id' },
	'year': { 'type': 'select', 'attr': 'id' },
	'fiscal_year': { 'type': 'select', 'attr': 'id' },
	'month': { 'type': 'select', 'attr': 'id' },
	'times': { 'type': 'select', 'attr': 'id' },
	'detail_no': { 'type': 'select', 'attr': 'id' },
	'group_cd': { 'type': 'select', 'attr': 'id' },
	'employee_cdX': { 'type': 'text', 'attr': 'id' },
	'tr_del_value': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'report_no': { 'type': 'text', 'attr': 'class' },
			'pos_emp': { 'type': 'text', 'attr': 'class' },
		}
	},
};
var _flgLeft = 0;
$(function () {
	try {
		initEvents();
		initialize();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
});
/**
 * initialize
 *
 * @author    : datnt - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
	try {
		$('.multiselect').multiselect({
			onChange: function () {
				$.uniform.update();
			}
		});
		$(".multi-select-full").find(".my_container").not(":nth-of-type(1)").remove();
		//
		$('#fiscal_year').trigger('change');
		//
		jQuery.formatInput();
		tableContent();
		app.jTableFixedHeader();
		_formatTooltip();
		$('#tab').focus();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author    : datnt - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
	try {
		// search
		$(document).on('click', '#btn_search', function (e) {
			try {
				$('.rate_emp').removeClass('required')
				$('#group_cd').removeClass('required')
				e.preventDefault();
				if (_validate()&&checkGroup($("#group_cd").val()) == false && checkMonth($("#month").val()) == false) {
					var fiscal_year = $("#fiscal_year").val();
					var group_cd = $("#group_cd").val();
					var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
					getList(fiscal_year, group_cd,page,cb_page);
				}
				$('#group_cd').addClass('required')
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		$(document).on('blur', '#employee_nm', function () {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($('#employee_nm').val()!= old_reporter) {
					$('#reporter_cd').val('');
					$(this).val('')
				}
			} catch (e) {
				alert('.employee_nm' + e.message);
			}
		});
		$(document).on('change', '#fiscal_year', function (e) {
			try {
				$('.employee_nm_weeklyreport').attr('fiscal_year_weeklyreport',$('#fiscal_year option:selected').val())
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		$(document).on('click', '#ck_search', function (e) {
			try {
				if ($('#ck_search').is(':checked')) {
					$('#group_cd').removeClass('required')
				} else {
					$('#group_cd').addClass('required')
				}
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		$(document).on('click', '#btn_csv_output', function (e) {
			try {
				e.preventDefault();
				$('#group_cd').removeClass('required')
				if (_validate()&&checkGroup($("#group_cd").val()) == false && checkMonth($("#month").val()) == false) {
					var fiscal_year = $("#fiscal_year").val();
					var group_cd = $("#group_cd").val();
					exportCSV(fiscal_year, group_cd);
				}
				$('#group_cd').addClass('required')
			} catch (e) {
				alert('btn_search: ' + e.message);
			}
		});
		$(document).on('click', '#btn-back', function (e) {
			window.location.href = '/weeklyreport/rdashboard';
		});
		//
		$(document).on('click', '#check-all', function () {
			try {
				try {
					var checked = $(this).prop('checked');
					$('#list').find('.chk-item').prop('checked', checked);
				} catch (e) {
					alert('#checkall: ' + e.message);
				}
			} catch (e) {
				alert('#ckball:' + e.message);
			}
		});
		$(document).on('change', '#group_cd', function () {
			try {
				var data = {};
				data['group_cd'] = $(this).val()
					$.ajax({
						type: 'POST',
						url: '/weeklyreport/ri1020/organization',
						dataType: 'html',
						loading: true,
						// data        :    {'data':obj},
						data: data,
						success: function (res) {
							$('.init_organization').remove()
							$('.report_block').after(res)
							$('#btn_search').trigger('click')
						}
					});
			} catch (e) {
				alert('#ckball:' + e.message);
			}
		});
		//
		$(document).on('change', '#times', function () {
			$('.div_loading').show();
				setTimeout(() => {
					getParamsContent(4, $('#fiscal_year').find('option:selected').text(), $('#report_kinds').val(), $('#month').val(),$('#group_cd').val(),$(this).val())
				$('.div_loading').hide();
				}, 500);
		});
		//
		$(document).on('click', '.chk-item', function () {
			try {
				var count_check = $('#list').find('input:checkbox:checked').length;
				var check_box = $('#list').find('input:checkbox').length;
				if (count_check == check_box) {
					$('#check-all').prop('checked', true);
				} else {
					$('#check-all').prop('checked', false);
				}
			} catch (e) {
				alert('#ckball:' + e.message);
			}
		});
		// remove
		$(document).on('click', '#btn_delete', function (e) {
			try {
				
				removeRow();
			} catch (e) {
				console.log('#btn_delete:' + e.message);
			}
		});
		// add
		$(document).on('click', '#btn_add', function (e) {
			// $("#table_result").animate({scrollLeft: "-="+'1000px'}, "slow");
			//$(".table-responsive").animate({scrollLeft: "-="+'100px'}, "slow");
			$('.row_active').removeClass('row_active')
			if ($('#list .tr_first_value').length > 0) {
			try {
					addNewEmployeeRow();
				} catch (e) {
					console.log('#btn_add:' + e.message);
				}
			}
		});
		$(document).on('click', '#btn_apply_latest', function (e) {
			try {
				if (_validate()) {
						e.preventDefault();
					if (_validate() && checkGroup($("#group_cd").val()) == false && checkMonth($("#month").val()) == false) {
						$("#table_result tbody tr").each(function (row) {
							var _this = $(this);
							//set position employee
							_this.find(".pos_emp").val(row);
							if (_this.find("td input[type=checkbox]").prop('checked')) {
								_this.addClass('approval_row');
							}
						});
						if (!$(".approval_row")[0]) {
							jMessage(18);
						} else {
							var fiscal_year = $("#fiscal_year").val();
							var group_cd = $("#group_cd").val();
							var param = getParam(fiscal_year, group_cd);
							var li = $('.pagination li.active');
							param.page = li.find('a').attr('page');
							var cb_page = $('#cb_page').find('option:selected').val();
							param.page_size = cb_page == '' ? 20 : cb_page;
							param.approval_json = getData(_obj_approver)
							//
							$.ajax({
								type: 'POST',
								url: '/weeklyreport/ri1020/approval_lastest',
								dataType: 'html',
								loading: true,
								data: JSON.stringify(param),
								success: function (res) {
									// $("#card_import").empty();
									// $("#card_import").append(res);
									$('#card_import').html(res);
									$('.div_loading').hide();
									$('.btn-outline-primary').addClass("removeActive");
									// check if is_add_row = true
									
									jQuery.formatInput();
									tableContent();
									css_hover_row();
									getAutocomplete();
									app.jTableFixedHeader();
									app.jSticky();
									_formatTooltip();
									$("#ckball").prop("checked", false);
									$('#group_cd').attr('import_status', 'false');	// add by viettd 2021/01/26
								}
							});
						}
					}
					}
			} catch (e) {
				alert('#btn_apply_latest:' + e.message);
			}
		});
		// $(document).on('blur', '.approver_employee_nm_1', function (e) {
		// 	try {
		// 		$(this).closest('.tr_first_value').find('.textbox-error').remove()
		// 		$(this).closest('.tr_first_value').find('.boder-error').removeClass('boder-error')
		// 		reporter = $(this).closest('.tr_first_value').find('.employee_cd').val();
		// 		current_val = $(this).closest('.tr_first_value').find('.approver_employee_cd_1').val();
		// 		if (current_val > 0) {
		// 			prev_val_2 = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
		// 			prev_val_3 = $(this).closest('.tr_first_value').find('.approver_employee_cd_3').val();
		// 			prev_val_4 = $(this).closest('.tr_first_value').find('.approver_employee_cd_4').val();
		// 			if (prev_val_3 == current_val || prev_val_4 == current_val || prev_val_2 == current_val || reporter== current_val) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_1').val('')
		// 				$(this).text('')
		// 				$(this).val('')
		// 				$(this).removeClass("form-control required boder-error");
		// 				$(this).addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[32].message + "</div>";
		// 				$(this).after(html);
		// 			}
		// 		}
		// 	} catch (e) {
		// 		alert('btn_apply_latest error : ' + e.message);
		// 	}
		// });
		// $(document).on('blur', '.approver_employee_nm_2', function (e) {
		// 	try {
		// 		$(this).closest('.tr_first_value').find('.textbox-error').remove()
		// 		$(this).closest('.tr_first_value').find('.boder-error').removeClass('boder-error')
		// 		current_val = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
		// 		reporter = $(this).closest('.tr_first_value').find('.employee_cd').val();
		// 		if (current_val > 0) {
		// 			prev_val_1 = $(this).closest('.tr_first_value').find('.approver_employee_cd_1').val();
		// 			prev_val_2 = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
		// 			prev_val_3 = $(this).closest('.tr_first_value').find('.approver_employee_cd_3').val();
		// 			prev_val_4 = $(this).closest('.tr_first_value').find('.approver_employee_cd_4').val();
		// 			if (prev_val_1 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_2').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').after(html);
		// 			}
		// 			if (prev_val_3 == current_val || prev_val_4 == current_val || prev_val_1 == current_val|| reporter== current_val) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_2').val('')
		// 				$(this).val('')
		// 				$(this).removeClass("form-control required boder-error");
		// 				$(this).addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[32].message + "</div>";
		// 				$(this).after(html);
		// 			}
		// 		}
		// 	} catch (e) {
		// 		alert('btn_apply_latest error : ' + e.message);
		// 	}
		// });
		// $(document).on('blur', '.approver_employee_nm_3', function (e) {
		// 	try {
		// 		$(this).closest('.tr_first_value').find('.textbox-error').remove()
		// 		$(this).closest('.tr_first_value').find('.boder-error').removeClass('boder-error')
		// 		current_val = $(this).closest('.tr_first_value').find('.approver_employee_cd_3').val();
		// 		reporter = $(this).closest('.tr_first_value').find('.employee_cd').val();
		// 		if (current_val > 0) {
					
		// 			prev_val_1 = $(this).closest('.tr_first_value').find('.approver_employee_cd_1').val();
		// 			prev_val_2 = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
		// 			prev_val_4 = $(this).closest('.tr_first_value').find('.approver_employee_cd_4').val();
		// 			if (prev_val_1 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_3').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').after(html);
		// 			}
		// 			if (prev_val_2 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_3').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').after(html);
		// 			}
		// 			if (prev_val_4 == current_val || prev_val_2 == current_val || prev_val_1 == current_val|| reporter== current_val) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_3').val('')
		// 				$(this).val('')
		// 				$(this).removeClass("form-control required boder-error");
		// 				$(this).addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[32].message + "</div>";
		// 				$(this).after(html);
		// 			}
		// 		}
		// 	} catch (e) {
		// 		alert('btn_apply_latest error : ' + e.message);
		// 	}
		// });
		// $(document).on('blur', '.approver_employee_nm_4', function (e) {
		// 	try {
		// 		$(this).closest('.tr_first_value').find('.textbox-error').remove()
		// 		$(this).closest('.tr_first_value').find('.boder-error').removeClass('boder-error')
		// 		current_val = $(this).closest('.tr_first_value').find('.approver_employee_cd_4').val();
		// 		reporter = $(this).closest('.tr_first_value').find('.employee_cd').val();
		// 		if (current_val > 0) {
		// 			prev_val_1 = $(this).closest('.tr_first_value').find('.approver_employee_cd_1').val();
		// 			prev_val_2 = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
		// 			prev_val_3 = $(this).closest('.tr_first_value').find('.approver_employee_cd_3').val();
		// 			if (prev_val_1 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_4').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_1').after(html);
		// 			}
		// 			if (prev_val_2 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_4').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_2').after(html);
		// 			}
		// 			if (prev_val_3 == 0) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_4').val('')
		// 				$(this).val('')
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_3').removeClass("form-control required boder-error");
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_3').addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		// 				$(this).closest('.tr_first_value').find('.approver_employee_nm_3').after(html);
		// 			}
		// 			if (prev_val_3 == current_val || prev_val_2 == current_val || prev_val_1 == current_val|| reporter== current_val) {
		// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_4').val('')
		// 				$(this).val('')
		// 				$(this).removeClass("form-control required boder-error");
		// 				$(this).addClass("form-control required boder-error");
		// 				var html = "<div class='textbox-error'>" + _text[32].message + "</div>";
		// 				$(this).after(html);
		// 			}
		// 		}
		// 	} catch (e) {
		// 		alert('btn_apply_latest error : ' + e.message);
		// 	}
		// });
		$(document).on('click', '.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
			try {
				e.preventDefault();
				$('.page-item').removeClass('active');
				$(this).addClass('active')
				var page = $(this).attr('page');
				var cb_page = $('#cb_page').find('option:selected').val();
				var cb_page = cb_page == '' ? 1 : cb_page;
				var fiscal_year = $("#fiscal_year").val();
				var group_cd = $("#group_cd").val();
				getList(fiscal_year, group_cd,page,cb_page);	
			} catch (e) {
				alert('page_item ' + e.message);
			}
		});
		$(document).on('change', '#cb_page', function (e) {
			try {
				var li = $('.pagination li.active'),
					page = li.find('a').attr('page');
				var cb_page = $(this).val();
				var cb_page = cb_page == '' ? 20 : cb_page;
				var fiscal_year = $("#fiscal_year").val();
				var group_cd = $("#group_cd").val();
				// search(1, page, cb_page,1);
				getList(fiscal_year, group_cd,page,cb_page);
			} catch (e) {
				alert('#cb_page '+ e.message);
			}
		});
		$(document).on('click', '#btn-send', function (e) {
			try {
				$('.approver_employee_nm_1').removeClass('required')
				$('.approver_employee_nm_2').removeClass('required')
				$('.approver_employee_nm_3').removeClass('required')
				$('.approver_employee_nm_4').removeClass('required')
				if (!$(".tr_first_value")[0] && !$(".tr_del_value")[0]) {
					jMessage(29);
				}
				else {
					if ($(".tr_first_active")[0]) {
						$(".tr_first_active").remove()
					} 
					var cnt = 0;
					jMessage(1, function (r) {
						$("#table_result tbody tr input[type=checkbox]:not(:checked)").each(function () {
							$(this).closest("tr").find("#employee_cd ").removeClass("required");
						});
						$("#table_result tbody tr input[type=checkbox]:checked").each(function () {
							cnt++;
							var _this = $(this);
							if (_this.closest("tr").find('.add_employee_cd').val() == "") {
								_this.closest("tr").find('.add_employee_cd').addClass("required");
							}
						});
						var check = _validate($('body'));
						if (r && check == false) {
							$("#table_result tbody tr .employee_nm_single").addClass("required");
							$(".textbox-error:first").closest("span").find("#employee_nm_single").focus();
							var posTr = $("#table_result tbody tr td:eq(0)").hasClass("has-error");
							if (posTr) {
								$("#table_result tbody tr td:eq(0) .has-error").focus();
							}
						} else {
							var report_kinds = $("#report_kinds").val();
							var group_cd = $("#group_cd").val();
							if (checkReport(report_kinds) == false && checkGroup(group_cd) == false) {
								if (cnt == 0) {
									jMessage(18);
								} else {
									saveData();
								}
						
							}
						}
					});
				}
			} catch (e) {
				console.log('#btn_add:' + e.message);
			}
		});
		$(document).on('click', '#btn-save', function (e) {
			try {
				$('.approver_employee_nm_1').removeClass('required')
				$('.approver_employee_nm_2').removeClass('required')
				$('.approver_employee_nm_3').removeClass('required')
				$('.approver_employee_nm_4').removeClass('required')
				if (!$(".tr_first_value")[0] && !$(".tr_del_value")[0]) {
					jMessage(29);
				}
				else {
					if ($(".tr_first_active")[0]) {
						$(".tr_first_active").remove()
					} 
					var cnt = 0;
					jMessage(1, function (r) {
						$("#table_result tbody tr input[type=checkbox]:not(:checked)").each(function () {
							$(this).closest("tr").find("#employee_cd ").removeClass("required");
						});
						$("#table_result tbody tr input[type=checkbox]:checked").each(function () {
							cnt++;
							var _this = $(this);
							if (_this.closest("tr").find('.add_employee_cd').val() == "") {
								_this.closest("tr").find('.add_employee_cd').addClass("required");
							}
						});
						var check = _validate($('body'));
						if (r && check == false) {
							$("#table_result tbody tr .employee_nm_single").addClass("required");
							$(".textbox-error:first").closest("span").find("#employee_nm_single").focus();
							var posTr = $("#table_result tbody tr td:eq(0)").hasClass("has-error");
							if (posTr) {
								$("#table_result tbody tr td:eq(0) .has-error").focus();
							}
						} else {
							var report_kinds = $("#report_kinds").val();
							var group_cd = $("#group_cd").val();
							if (checkReport(report_kinds) == false && checkGroup(group_cd) == false) {
								if (cnt == 0) {
									jMessage(18);
								} else {
									saveData();
								}
						
							}
						}
					});
				}
			} catch (e) {
				console.log('#btn_add:' + e.message);
			}
		});
		$(document).on('change', '#report_kinds', function (e) {
			try {
				fiscal_year = $('#fical_year').val();
				if ($(this).val() == 4 || $(this).val() == 5) {
					$('#block_month').css('display', 'unset')
				} else {
					$('#block_month').css('display', 'none')
				}
				if ($(this).val() == 5) {
					$('#block_detail').css('display', 'unset')
				} else {
					$('#block_detail').css('display', 'none')
				}
				getParamsContent(2, $('#fiscal_year').find('option:selected').text(), $(this).val(), 0, 0)
				getParamsContent(4, $('#fiscal_year').find('option:selected').text(), $(this).val(), 0, 0)
			} catch (e) {
				console.log('#btn_add:' + e.message);
			}
		});
		$(document).on('click', '#btn_evaluation_import', function (e) {
			try {
				if(_validate()){
					$('#import_file').trigger('click');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});
		
		$(document).on('change', '.add_approver_employee_nm', function (e) {
			try {
					if (_validate()) {
						var fiscal_year = $("#fiscal_year").val();
						var group_cd = $("#group_cd").val();
						if($(this).attr('emp_cd') == undefined) {
							var reporter_cd = $(this).val();
						} else {
						var reporter_cd = $(this).attr('emp_cd');
						}
						var page = $('.page-item.active').attr('page');
						var cb_page = $('#cb_page').val();
						getList(fiscal_year, group_cd,page,cb_page,true,reporter_cd);
					}
				
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});
		
		$(document).on('change', '#import_file', function (e) {
			importCSV();
		});
		$(document).on('change', '#month', function (e) {
			try {
				getParamsContent(3, $('#fiscal_year').find('option:selected').text(), $('#report_kinds').val(), $(this).val())
				getParamsContent(3, $('#fiscal_year').find('option:selected').text(), $('#report_kinds').val(), $(this).val(), $('#group_cd').val())
				getParamsContent(4, $('#fiscal_year').find('option:selected').text(), $('#report_kinds').val(), $(this).val(),$('#group_cd').val(),$('#times').val())
			} catch (e) {
				console.log('#btn_add:' + e.message);
			}
		});
		$(document).on('change', '#fiscal_year', function (e) {
			fiscal_year = $(this).val();
			report_kind = $('#report_kinds').val();
			getParamsContent(2, $('#fiscal_year').find('option:selected').text(), report_kind, 0, 0)
			getParamsContent(4, $('#fiscal_year').find('option:selected').text(),report_kind, 0, 0)
		});

		$(document).on('change', '#group_cd', function (e) {
			try {
				e.preventDefault();
				var group_cd = $("#group_cd").val();
				if (group_cd > 0) {
					$('#ck_search').attr('disabled', 'disabled');
					$('#ck_search').closest('.md-checkbox-v2').css('cursor', 'default');
					$('#ck_search').css('cursor', 'default');
					$('#ck_search').closest('.md-checkbox-v2').find('label').css('cursor', 'default');
					$('#ck_search').prop('checked', false);
				} else {
					$('#ck_search').removeAttr('disabled')
					$('#ck_search').closest('.md-checkbox-v2').css('cursor', 'pointer');
					$('#ck_search').css('cursor', 'pointer');
					$('#ck_search').closest('.md-checkbox-v2').find('label').css('cursor', 'pointer');
				}
				refer_group(group_cd);
				getParamsContent(3, $('#fiscal_year').find('option:selected').text(), $('#report_kinds').val(), $('#month').val(),$(this).val())
			} catch (e) {
				alert('#group_cd refer: :' + e.message);
			}
		});
		$(document).on('change', '.sheet', function (e) {
			try {
				e.preventDefault();
				var element = $(this).find('option:selected'); 
				let adaption_date  = element.attr('adaption_date')
				$('.adaption_date').val(adaption_date)
				$(this).closest('.adaption_date').val(adaption_date)
			} catch (e) {
				alert('.sheet :' + e.message);
			}
		});
		$(document).on('click', '.tr_first', function (e) {
			try {
				$('.row_active').removeClass('row_active')
				$(this).addClass('row_active')
			} catch (e) {
				alert('.sheet :' + e.message);
			}
		});

	} catch (e) {
		alert('initEvents' + e.message);
	}
}
/*
 * Delete row
 * @author		:	viettd - 2023/02/16 - create
 * @return		:	null
 */
function removeRow() {
    try {
        let del_row = 0;
        $('#table_result tbody tr').each(function () {
			if ($(this).find('input[type="checkbox"]').prop('checked')) {
				$(this).addClass('tr_del_value');
				$('.tr_del_value').removeClass('tr_first_value')
                $(this).css('display','none');
				del_row++;
				$('.tr_first_active').remove()
            }
        });
        // 
        if (del_row == 0) {
            jMessage(18);
        }
    } catch (e) {
        console.log('removeRow' + e.message);
    }
}
function addNewEmployeeRow() {
	try {
		if ($("#table_result tbody tr td").hasClass("w-popup-nodata")) {
			$("#table_result tbody .w-popup-nodata").closest("tr").remove();
		}
		if ($("#status").val() == "OK") {
			var index = $('#table_result tbody .tr_first').length + 1;
			var tr_first = $('#table_data tbody .tr_first').clone();
			tr_first.addClass('tr_first_active')
			tr_first.addClass('row_active')
			if (index > 1) {
				var tr_class = '';
				if (!$('#table_result tbody tr:last').hasClass('tr-odd')) {
					tr_class = 'tr-odd';
				}
				$('#table_result tbody tr:last').after(tr_first);
				$('#table_result tbody tr:last').addClass(tr_class);
			} else {
				$('#table_result tbody').append(tr_first);
				$('#table_result tbody tr .employee_nm_single:first').focus();
			}
			$("#table_result tbody tr .employee_nm_single ").removeAttr("disabled");
			var i = 0;
			$("#table_result tbody tr").each(function () {
				var atr = $(this).parents("tr").attr("row_emp");
				if (typeof atr == typeof undefined || atr == false) {
					$(this).find(".pos_emp").val(i);
					$(this).find("input[type=checkbox]").attr("id", "id" + i);
					$(this).find("label:first").attr("for", "id" + i);
					i++;
				}
			});
			if ($("#table_result tbody tr:first td").attr("colspan") == "15") {
				$("#table_result tbody tr:first").remove();
			}
			$('#table_result tbody .tr_first:last .add_approver_employee_nm').focus();
			getAutocomplete();
			$('.table-responsive').scrollTop($(window).height());
			$('.table-responsive').scrollLeft(0);
			$('#table_result tbody tr:last').focus();
		}
	} catch (e) {
		alert('addNewEmployeeRow:'+ e.message);
	}
}
/**
 * tooltip format
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:	error array ex ['e1','e2']
 */
function _formatTooltip() {
	try {
		$('.text-overfollow').each(function (i) {
			var i = 1;
			var colorText = '';
			var element = $(this)
				.clone()
				.css({ display: 'inline', width: 'auto', visibility: 'hidden' })
				.appendTo('body');

			if (element.width() <= $(this).width()) {
				$(this).removeAttr('data-original-title');
			}
			element.remove();
		});
	} catch (e) {
		alert('format tooltip ' + e.message);
	}
}
function search(){
	try{
		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/weeklyreport/ri1020/search',
    		dataType	:	'html',
    		loading     :   true,
    		data		:	{},
		 success: function(res) {
		 	$('#result').empty();
			$('#result').append(res);
			jQuery.formatInput();
				css_hover_row();
				getAutocomplete();
				app.jTableFixedHeader();
				app.jSticky();
			if(!$("div").hasClass("hide-card-common")){
				$('.button-card').trigger("click");
			}
		 }
		});
	}catch(e){
		alert('search: ' + e.message);
	}
}
/*
 * @Author: tuantv@ans-asia.com
 *
 */
function tableContent() {

	$(".wmd-view-topscroll").scroll(function () {
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function () {
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function () {
		fixWidth();
	});
	function fixWidth() {
		var w = $('.wmd-view .table').outerWidth();
		var f = $('.table-group li:last').outerWidth();
		$(".wmd-view-topscroll .scroll-div1").width(w);
	}
}
/*
 * checkall
 * @author    : viettd - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function checkall(param) {
	try {
		if (param == 1) {
			$('.checkbox_row').prop('checked', true);
			$('#table_result tbody tr').addClass('active');
		} else {
			$('.checkbox_row').prop('checked', false);
			$('#table_result tbody tr').removeClass('active');
		}
	} catch (e) {
		alert('checkall' + e.message);
	}
}
/*
 * checkboxRow
 * @author    : viettd - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function checkboxRow(obj, param) {
	try {
		var checked = 1;
		if (param == 1) {
			$('.checkbox_row').each(function () {
				if ($(this).prop('checked') == false) {
					checked = 0;
					return false;
				}
			});
			//
			if (checked == 1) {
				$('#ckball').prop('checked', true);
			} else {
				$('#ckball').prop('checked', false);
			}
			//
			obj.closest('.tr_first').addClass('active');
			obj.closest('.tr_first').next().addClass('active');
		} else {
			$('#ckball').prop('checked', false);
			//
			obj.closest('.tr_first').removeClass('active');
			obj.closest('.tr_first').next().removeClass('active');
		}
	} catch (e) {
		alert('checkboxRow' + e.message);
	}
}
/**
 * save Data
 *
 * @author      :   tuantv - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var page = $('.page-item.active').attr('page');
		var cb_page = $('#cb_page').val();
		let success_delete = 1;
		$('.tr_first_value').removeClass('tr_first_value');
		$("#table_result tbody tr").each(function (row) {
			var _this = $(this);
			//set position employee
			_this.find(".pos_emp").val(row);
			if (_this.find("td input[type=checkbox]").prop('checked')) {
				var row_span = _this.find('td:eq(0)').attr('rowspan');
				var index = _this.index();
				if (!_this.hasClass('tr_del_value')) {
					_this.addClass('tr_first_value');
				}
				var i = row_span - 1;
				while (i <= row_span && i >= 1) {
					$("#table_result tbody tr").eq(index + i).addClass('tr_second_value');
					i--;
				}
			}
		});
		var data = [];
		var data_del = [];
		var fiscal_year = $("#fiscal_year").val();
		var group_cd = $("#group_cd").val();
		data_del = getData(_obj_del);
		if ($('.tr_del_value').length > 0) {
			$.post('/weeklyreport/ri1020/delete', JSON.stringify(data_del))
				.then(res => {
					$('.div_loading').css('display', 'none');
					switch (res['status']) {
						// success
						case OK:
							jMessage(2, function (r) {
								if (res['group_cd'] != '') {
									getList(fiscal_year, group_cd, page, cb_page);
								}
							});
							data = getData(_obj);
					$('.div_loading').css('display', 'block');
					$.post('/weeklyreport/ri1020/save', JSON.stringify(data))
						.then(res => {
							$('.div_loading').css('display', 'none');
							switch (res['status']) {
								// success
								case OK:
									jMessage(2, function (r) {
										if (res['group_cd'] != '') {
											getList(fiscal_year, group_cd, page, cb_page);
										}
									});
									break;
								case NG:
									//
									if (typeof res['errors'] != 'undefined' && res['errors'][0]['error_typ'] == 1) {
										processError(res['errors']);
									}
									if (res['errors'][0]['error_typ'] == 4) {
										for (var i = 0; i < res['errors'].length; i++) {
											var value2 = res['errors'][i]['value2'];
											$("#table_result tbody .tr_first_value").each(function (row) {
												if ($(this).find(".pos_emp").val() == value2) {
													$(this).find(".lblCheck").addClass("error-type4");
												}
											});
										}
										jMessage(res['errors'][0]['message_no'], function () {
										});
									} else {
										if (typeof res['errors'] != 'undefined') {
											for (var i = 0; i < res['errors'].length; i++) {
												var value1 = res['errors'][i]['value1'];
												//var value2 = res['errors'][i]['value2'];
												$("#list .tr_first_value").each(function (row) {
													if (res['errors'][i]['item'] == '.tr_first_value') {
														var value2 = res['errors'][i]['value2'];
														$("#table_result tbody tr:eq(" + value2 + ")").find('td:eq(1)').css("background-color", "#d9b9be");
													}
													if (res['errors'][i]['item'] != '.err_sheet_cd' && res['errors'][i]['item'] != '.tr_first_value') {
														var tr_row = row + 1;
														if (value1 == tr_row) {
															errorStyleRI1020($(this).find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
														}
														$(".boder-error").next().next().remove();
													}
													if (res['errors'][i]['item'] == '.err_sheet_cd') {
														var value2 = res['errors'][i]['value2'];
														errorStyleRI1020($("#table_result tbody tr:eq(" + value2 + ")").find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
													}
												});
												checkTabError();
											}
										}
									}

									break;
								// Exception
								case EX:
									jError(res['Exception']);
									break;
								default:
									break;
							}
						});

						case NG:
							//
							if (typeof res['errors'] != 'undefined' && res['errors'][0]['error_typ'] == 1) {
								processError(res['errors']);
							}
							if (res['errors'][0]['error_typ'] == 4) {
								for (var i = 0; i < res['errors'].length; i++) {
									var value2 = res['errors'][i]['value2'];
									$("#table_result tbody .tr_first_value").each(function (row) {
										if ($(this).find(".pos_emp").val() == value2) {
											$(this).find(".lblCheck").addClass("error-type4");
										}
									});
								}
								jMessage(res['errors'][0]['message_no'], function () {
								});
							} else {
								$('.tr_del_value').css('display','')
								if (typeof res['errors'] != 'undefined') {
									for (var i = 0; i < res['errors'].length; i++) {
										var value1 = res['errors'][i]['value1'];
										//var value2 = res['errors'][i]['value2'];
										$("#list .tr_del_value").each(function (row) {
											if (res['errors'][i]['item'] == '.tr_first_value') {
												var value2 = res['errors'][i]['value2'];
												$("#table_result tbody tr:eq(" + value2 + ")").find('td:eq(1)').css("background-color", "#d9b9be");
											}
											if (res['errors'][i]['item'] != '.err_sheet_cd' && res['errors'][i]['item'] != '.tr_first_value') {
												var tr_row = row + 1;
												if (value1 == tr_row) {
													errorStyleRI1020($(this).find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
												}
												$(".boder-error").next().next().remove();
											}
											if (res['errors'][i]['item'] == '.err_sheet_cd') {
												var value2 = res['errors'][i]['value2'];
												errorStyleRI1020($("#table_result tbody tr:eq(" + value2 + ")").find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
											}
										});
										checkTabError();
									}
								}
								$('.tr_del_value').removeClass('tr_del_value')
								$('.emcd').addClass('tr_first_value')
							}

							break;
						// Exception
						case EX:
							success_delete = 0
							jError(res['Exception']);
							break;
						default:
							break;
					}
				})
		}
		else {
			//
			data = getData(_obj);
			$('.div_loading').css('display', 'block');
			$.post('/weeklyreport/ri1020/save', JSON.stringify(data))
				.then(res => {
					$('.div_loading').css('display', 'none');
					switch (res['status']) {
						// success
						case OK:
							jMessage(2, function (r) {
								if (res['group_cd'] != '') {
									getList(fiscal_year, group_cd, page, cb_page);
								}
							});
							break;
						case NG:
							//
							if (typeof res['errors'] != 'undefined' && res['errors'][0]['error_typ'] == 1) {
								processError(res['errors']);
							}
							if (res['errors'][0]['error_typ'] == 4) {
								for (var i = 0; i < res['errors'].length; i++) {
									var value2 = res['errors'][i]['value2'];
									$("#table_result tbody .tr_first_value").each(function (row) {
										if ($(this).find(".pos_emp").val() == value2) {
											$(this).find(".lblCheck").addClass("error-type4");
										}
									});
								}
								jMessage(res['errors'][0]['message_no'], function () {
								});
							} else {
								if (typeof res['errors'] != 'undefined') {
									for (var i = 0; i < res['errors'].length; i++) {
										var value1 = res['errors'][i]['value1'];
										//var value2 = res['errors'][i]['value2'];
										$("#list .tr_first_value").each(function (row) {
											if (res['errors'][i]['item'] == '.tr_first_value') {
												var value2 = res['errors'][i]['value2'];
												$("#table_result tbody tr:eq(" + value2 + ")").find('td:eq(1)').css("background-color", "#d9b9be");
											}
											if (res['errors'][i]['item'] != '.err_sheet_cd' && res['errors'][i]['item'] != '.tr_first_value') {
												var tr_row = row + 1;
												if (value1 == tr_row) {
													errorStyleRI1020($(this).find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
												}
												$(".boder-error").next().next().remove();
											}
											if (res['errors'][i]['item'] == '.err_sheet_cd') {
												var value2 = res['errors'][i]['value2'];
												errorStyleRI1020($("#table_result tbody tr:eq(" + value2 + ")").find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
											}
										});
										checkTabError();
									}
								}
							}

							break;
						// Exception
						case EX:
							jError(res['Exception']);
							break;
						default:
							break;
					}
				});
		}
	} catch (e) {
		alert('save' + e.message);
	}
}

/**
 * applyLatest
 *
 * @author      :   tuantv - 2018/10/20 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function applyLatest(page = 1, page_size = 20) {
	try {
		//
		var fiscal_year = $("#fiscal_year").val();
		var group_cd = $("#group_cd").val();
		if (group_cd == -1) {
			group_cd = 0;
		}
		var param = getParam(fiscal_year, group_cd);
		param.employees_checked = getEmployeesChecked();
		param.page = page;
		param.page_size = page_size;
		// send ajax
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/ri1020/apply_latest',
			dataType: 'html',
			loading: true,
			data: JSON.stringify(param),
			success: function (res) {
				$("#card_import").html(res);
				$('.div_loading').hide();
				$('.btn-outline-primary').addClass("removeActive");
				jQuery.formatInput();
				tableContent();
				css_hover_row();
				getAutocomplete();
				app.jTableFixedHeader();
				app.jSticky();
				_formatTooltip();
				$("#ckball").prop("checked", false);
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}
/**
 * refer sheet_cd
 *
 * @author      :   tuantv - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer_group(group_cd) {
	try {
		var list = [];
		var data = {};
		data['group_cd'] = group_cd;
		list.push({ 'report_group': group_cd });
		data.group_cd = list;
		console.log(data);
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/ri1020/refer_group',
			dataType: 'html',
			// loading: true,
			data: data,
			success: function (res) {
				res = JSON.parse(res);
				console.log(res)
				switch (res['status']) {
					// success
					case 200:
						if (res.data.length > 0) {
							$('#group1').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[0][0]['position_nm'] + '">' +  res.data[0][0]['position_nm'] + '</div>'
							);
							$('#group2').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' +  res.data[0][0]['job_nm'] + '">' +  res.data[0][0]['job_nm'] + '</div>'
							);
							$('#group3').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' +  res.data[0][0]['grade_nm'] + '">' +  res.data[0][0]['grade_nm'] + '</div>'
							);
							$('#group4').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[0][0]['employee_typ_nm'] + '">' +  res.data[0][0]['employee_typ_nm'] + '</div>'
							);
							//
							$('[data-toggle="tooltip"]').tooltip();
							//
							if ($('#list .tr_first .key_emp').length > 0) {
								$('#btn_search').trigger('click');
							}
						}
						break;
					// error
					case 202:
						$('#group1,#group2,#group3,#group4').empty();
						$('#list').empty().append('<tr class="tr_first"><td colspan="17" class="w-popup-nodata no-hover text-center">' + res['nodata'] + '</td></tr>');
						break;
					// Exception
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}

			},
		});
	} catch (e) {
		alert('save' + e.message);
	}
}
/**
 * search
 *
 * @author  :   tuantv - 2018/09/26 - create
 * @author  :
 *
 */
function getList(fiscal_year = 0, group_cd = 0, page = 1, page_size = 20,is_add_row = false, reporter_cd = 0) {
	try {
		if (is_add_row == false) {
			var param = getParam(fiscal_year, group_cd);
			param.page = page;
			param.page_size = page_size;
			//
			$.ajax({
				type: 'POST',
				url: '/weeklyreport/ri1020/search',
				dataType: 'html',
				loading: true,
				data: JSON.stringify(param),
				success: function (res) {
					// $("#card_import").empty();
					// $("#card_import").append(res);
					$('#card_import').html(res);
					$('.div_loading').hide();
					$('.btn-outline-primary').addClass("removeActive");
					// check if is_add_row = true
					if (is_add_row) {
						addNewEmployeeRow();
					}
					jQuery.formatInput();
					tableContent();
					css_hover_row();
					getAutocomplete();
					app.jTableFixedHeader();
					app.jSticky();
					_formatTooltip();
					$("#ckball").prop("checked", false);
					$('#group_cd').attr('import_status', 'false');	// add by viettd 2021/01/26
					// if(!$("div").hasClass("hide-card-common")){
					// 	$('.button-card').trigger("click");
					// }
				}
			});
		} else {
			var param = getParam(fiscal_year, group_cd);
			param.page = page;
			param.page_size = page_size;
			param.employee_cdX	= reporter_cd
			param.employee_cd 	= reporter_cd
			//
			$.ajax({
				type: 'POST',
				url: '/weeklyreport/ri1020/add_row',
				dataType: 'html',
				loading: true,
				data: JSON.stringify(param),
				success: function (res) {

					if (res == '') {
						$('.row_active .add_approver_employee_nm').removeClass("form-control required boder-error");
						$('.row_active .add_approver_employee_nm').addClass("form-control required boder-error");
						var html = "<div class='textbox-error' style='position: relative;'>" + _text[87].message + "</div>";
						$('.row_active .add_approver_employee_nm').after(html);
					} else {
						$('.row_active').replaceWith(res)
					}
					$(".table-responsive").animate({scrollLeft: "-="+'100px'}, "slow");
					getAutocomplete();
				}
			});

		}
	} catch (e) {
		alert('SEARCH : ' + e.message);
	}
}
/**
 * export_csv
 *
 * @author  :   tuantv - 2018/09/26 - create
 * @author  :
 *
 */
function exportCSV(fiscal_year = 0, group_cd = 0, page = 1, page_size = 20,is_add_row = false) {
	try {
		var param = getParam(fiscal_year, group_cd);
		param.page = page;
		param.page_size = page_size;
		//
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/ri1020/export_csv',
			dataType: 'html',
			loading: true,
			data: JSON.stringify(param),
			success: function (res) {
				jMessage(7);
			}
		});
	} catch (e) {
		alert('SEARCH : ' + e.message);
	}
}
/**
 * getAutocomplete
 *
 * @author  :   tuantv - 2018/09/27 - create
 * @author  :
 *
 */
function getAutocomplete() {
	$(".rate_emp").autocomplete({
		source: function (request, response) {
			var input = this.element;
			var employee_cd = $(input).parents("tr").find(".rate_emp").val();
			var posRate = $(input).parents(".div_employee_cd").find("input:first").data("rater");
			var valueRate = $(input).parents(".div_employee_cd").find("input:first").data("rater_position_cd");
			$.ajax({
				type: 'GET',
				url: '/common/employeeautocomplete',
				dataType: 'json',
			// loading:true,
			global: false,
			// loading:true,
			global: false,
			data: {
					key: request.term,
					fiscal_year: $("#fiscal_year").val(),
					group_cd: $("#group_cd").val(),
					employee_cd: employee_cd,
					pos_rate: posRate,
					value_rate: valueRate
				},
				success: function (res) {
					//debugger;
					response(res);
				},
			});
		},
		minLength: 1,
		select: function (event, ui) {
			$(this).attr('old_approver_employee_nm', ui.item.value);
			$(this).attr('emp_cd', ui.item.id);
			$(this).closest('span').find('.approver_employee_cd').val(ui.item.id);
			$(this).closest('span').find('input:first').val(ui.item.id);
			$(this).val(ui.item.value);
		}
	});

	$(document).on('blur', '.rate_emp', function () {
		try {
			var approver_employee_cd = $(this).closest('span').find('.approver_employee_cd').val();
			var old_approver_employee_nm = $(this).attr('old_approver_employee_nm');
			var approver_employee_nm = $(this).val();
			if ((approver_employee_cd == '') || (approver_employee_cd != '' && old_approver_employee_nm != approver_employee_nm)) {
				$(this).val('');
				$(this).closest('span').find('.approver_employee_cd').val('');

			}
		} catch (e) {
			alert('.employee_nm' + e.message);
		}
	});
	
	// $(document).on('focusout', '.approver_employee_nm_1', function () {
	// 	try {
	// 		$(this).closest('.tr_first_value').find('.textbox-error').remove()
	// 		$(this).closest('.tr_first_value').find('.boder-error').removeClass('boder-error')
	// 		reporter = $(this).closest('.tr_first_value').find('.employee_cd').val();
	// 		current_val = $(this).closest('.tr_first_value').find('.approver_employee_cd_1').val();
	// 		if (current_val > 0) {
	// 			prev_val_2 = $(this).closest('.tr_first_value').find('.approver_employee_cd_2').val();
	// 			prev_val_3 = $(this).closest('.tr_first_value').find('.approver_employee_cd_3').val();
	// 			prev_val_4 = $(this).closest('.tr_first_value').find('.approver_employee_cd_4').val();
	// 			if (prev_val_3 == current_val || prev_val_4 == current_val || prev_val_2 == current_val || reporter== current_val) {
	// 				$(this).closest('.tr_first_value').find('.approver_employee_cd_1').val('')
	// 				$(this).text('')
	// 				$(this).val('')
	// 				$(this).removeClass("form-control required boder-error");
	// 				$(this).addClass("form-control required boder-error");
	// 				var html = "<div class='textbox-error'>" + _text[32].message + "</div>";
	// 				$(this).after(html);
	// 			}
	// 		}
	// 	} catch (e) {
	// 		alert('btn_apply_latest error : ' + e.message);
	// 	}
	// });
	$(".emp_nm").autocomplete({
		source: function (request, response) {
			$.ajax({
					type: 'GET',
					url: '/common/employeeautocomplete',
					dataType: 'json',
				// loading:true,
				global: false,
				// loading:true,
				global: false,
				data: {
					key: request.term,
					fiscal_year: $("#fiscal_year").val(),
					group_cd: $("#group_cd").val(),
				},
				success: function (res) {
					response(res);
				},
			});
		},
		minLength: 1,
		select: function (event, ui) {
			var check = $(this).closest('span').find('.rater_employee_cd').hasClass("add_rate");
			$(this).parents(".div_employee_cd_single").find(".employee_cd_hidden:first").val(ui.item.id);
			$(this).parents(".div_employee_cd_single").find(".employee_nm_single:first").val(ui.item.id);
			var pos = $(this).closest('tr');
			var employee_cd = ui.item.id;
			$(this).closest('span').find('.rater_employee_cd').val(ui.item.id);
			$(this).val(ui.item.value);
		}
	});
	$(".add_emp").autocomplete({
		source: function (request, response) {
			$.ajax({
					type: 'GET',
					url: '/common/employeeautocompleteweeklyreport?',
					dataType: 'json',
				// loading:true,
				global: false,
				// loading:true,
				global: false,
				data: {
					key: request.term,
					fiscal_year: $("#fiscal_year").val(),
				},
				success: function (res) {
					response(res);
				},
			});
		},
		minLength: 1,
		select: function (event, ui) {
			$(this).attr('old_approver_employee_nm', ui.item.value);
			$(this).attr('emp_cd', ui.item.id);
			$(this).closest('span').find('.approver_employee_cd').val(ui.item.id);
			$(this).closest('span').find('input:first').val(ui.item.id);
			$(this).val(ui.item.value);
		}
	});
	//

}
/**
 * refer Employee_cd
 *
 * @author  :   tuantv - 2018/09/27 - create
 * @author  :
 *
 */
function refer_emp(employee_cd, pos, callback) {
	try {
		// send data to post
		var pos = pos;
		var obj = {};
		obj.fiscal_year = $("#fiscal_year").val();
		obj.group_cd = $("#group_cd").val(); 
		if (obj.group_cd == -1) {
			obj.group_cd = 0
		}
		obj.employee_cd = employee_cd;
		// get 処遇用途
		var list = [];
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		//
		$.ajax({
			type: 'POST',
			url: '/master/i1030/refer_emp',
			dataType: 'json',
			data: obj,
			loading: true,
			success: function (res) {
				//debugger;
				var prev = pos.prev('tr');
				var tr_class = ''
				if (!prev.hasClass('tr-odd')) {
					tr_class = 'tr-odd';
				}
				var row_span = pos.find('td:eq(1)').attr('rowspan');
				var index = pos.index();
				// if not error
				if (res.check_msg87 == 1) {
					if (typeof row_span !== 'undefined') {
						var i = row_span;
						while (i <= row_span && i >= 0) {
							$("#table_result tbody tr").eq(index + i).remove();
							i--;
						}
					} else {
						pos.remove();
					}
					if (index > 0 && prev.length > 0) {
						if (res.data != '') {
							prev.after($(res.data).addClass('ZZZ'));
						} else {
							var tr_first = $('#table_data tbody .tr_first').clone();
							tr_first.addClass('XXX');
							prev.after(tr_first);
						}
						prev.next().find("#employee_nm_single").focus();
						prev.next().addClass(tr_class);
					} else {
						if (res != '') {
							$("#table_result tbody tr:last").after($(res.data).addClass('TTT'));
						} else {
							var tr_first = $('#table_data tbody .tr_first').clone();
							tr_first.addClass('YYY');
							$("#table_result tbody tr:last").after(tr_first);
						}
						pos.find("#employee_nm_single").focus();
					}
					// if error
				} else {
					var message = _text[87].message;
					//
					$("#table_result tbody tr").eq(index).find('.add_employee_cd').removeClass("required boder-error");
					$("#table_result tbody tr").eq(index).find('.textbox-error').remove();
					//
					$("#table_result tbody tr").eq(index).find('.add_employee_cd').addClass("required boder-error");;
					$("#table_result tbody tr").eq(index).find('.add_employee_cd').closest('span').after('<div class="textbox-error" style="margin-top: 20px">' + message + '</span>');
					$("#table_result tbody tr").eq(index).find('.add_employee_cd').val("");
					$(".ui-menu").css("display", "none");
					$("#table_result tbody tr").eq(index).find('.add_employee_cd').focus();
				}
				jQuery.formatInput();
				css_hover_row();
				getAutocomplete();
				app.jTableFixedHeader();
				app.jSticky();
				if (callback) {
					callback();
				}
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}
/**
 * exportCSV
 *
 * @author      :  tuantv - 2018/09/30 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
	try {
		var group_cd = $("#group_cd").val();
		if (group_cd == -1) {
			group_cd = 0
		}
		var fiscal_year = $("#fiscal_year").val();
		var param = getParam(fiscal_year, group_cd);
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/ri1020/export',
			dataType: 'json',
			loading: true,
			// data        :    {'data':obj},
			data: JSON.stringify(param),
			success: function (res) {
				// success
				switch (res['status']) {
					case OK:
						var filedownload = res['FileName'];
						var filename = '承認者設定.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = 'ApproverSettings.csv';
							}
						if (filedownload != '') {
							downloadfileHTML(filedownload, filename, function () {
								//
							});
						} else {
							jError(2);
						}
						break;
					case NG:
						jMessage(21);
						break;
					case EX:
						jMessage(22);
						break;
					default:
						break;
				}
			}
		});
	} catch (e) {
		alert('exportCSV' + e.message);
	}
}
/**
 * importCSV
 *
 * @author      :  tuantv - 2018/10/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
	try {
		var data = {};
		console.log(data);
		data.import_file = $('');
		var formData = new FormData();
		formData.append('file', $('#import_file')[0].files[0]);
		formData.append('fiscal_year', $('#fiscal_year').val());
		formData.append('times', $('#times').val());
		formData.append('month', $('#month').val());
		formData.append('group_cd',$('#group_cd').val());
		formData.append('report_kinds',$('#report_kinds').val());
		// formData.append('fiscal_year',$('#fiscal_year').val());
		//処遇用途
		var list = [];
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		formData.append('treatment_applications_no',JSON.stringify(list));
		// send ajax
		$.ajax({
			type: 'POST',
			data: formData,
			url: '/weeklyreport/ri1020/import',
			loading: true,
			processData: false,
			contentType: false,
			enctype: "multipart/form-data",
			success: function (res) {
				switch (res['status']) {
					// success
					case 200:
						jMessage(7, function (r) {
							$('#btn_search').trigger('click');
							// if (res.data_import.length > 0) {ri1
							// 	$('#group_cd').attr('import_status','true');	// add by viettd 2021/01/26
							// 	// 
							// 	let data = res.data_import;
							// 	for (var i = 0; i < data.length; i++) {
							// 		var emcd = $('.emcd.' + data[i].employee_cd);
							// 		if (emcd.length > 0 && emcd.attr('hasconfirm') == '') {
							// 			var group_cd = data[i].group_cd;			// add by viettd 2021/01/26
							// 			var cd1 = data[i].rater_employee_cd_1;
							// 			var nm1 = data[i].rater_employee_nm_1;
							// 			var cd2 = data[i].rater_employee_cd_2;
							// 			var nm2 = data[i].rater_employee_nm_2;
							// 			var cd3 = data[i].rater_employee_cd_3;
							// 			var nm3 = data[i].rater_employee_nm_3;
							// 			var cd4 = data[i].rater_employee_cd_4;
							// 			var nm4 = data[i].rater_employee_nm_4;
							// 			// apply group_cd
							// 			if(group_cd > 0){
							// 				emcd.find('.key_group_cd').val(group_cd);
							// 			}
							// 			// cd 1
							// 			if (cd1 != '0' && cd1 != '') {
							// 				$.post('/master/i1030/ratersearch', {
							// 					key: cd1,
							// 					ord: 'cd1',
							// 					employee_cd: data[i].employee_cd,
							// 					cd: cd1,
							// 					nm: nm1
							// 				}).then(res => {
							// 					var ele = $('.emcd.' + res.employee_cd);
							// 					if (res.response.length > 0) {
							// 						if(typeof res.response[0].value != 'undefined' || res.response[0].value != ''){
							// 							res.nm = res.response[0].value;
							// 						}
							// 						clearRaterEmp(ele, '12', '1', res.cd, res.nm);
							// 					}
							// 					else {
							// 						clearRaterEmp(ele, '12', '1', '', '');
							// 					}
							// 				});
							// 			}
							// 			else {
							// 				clearRaterEmp(emcd, '12', '1', '', '');
							// 			}

							// 			// cd 2
							// 			if (cd2 != '0' && cd2 != '') {
							// 				$.post('/master/i1030/ratersearch', {
							// 					key: cd2,
							// 					ord: 'cd2',
							// 					employee_cd: data[i].employee_cd,
							// 					cd: cd2,
							// 					nm: nm2
							// 				})
							// 					.then(res => {
							// 						var ele = $('.emcd.' + res.employee_cd);
							// 						if (res.response.length > 0) {
							// 							if(typeof res.response[0].value != 'undefined' || res.response[0].value != ''){
							// 								res.nm = res.response[0].value;
							// 							}
							// 							clearRaterEmp(ele, '13', '2', res.cd, res.nm);
							// 						}
							// 						else {
							// 							clearRaterEmp(ele, '13', '2', '', '');
							// 						}
							// 					});
							// 			}
							// 			else {
							// 				clearRaterEmp(emcd, '13', '2', '', '');
							// 			}

							// 			// cd 3
							// 			if (cd3 != '0' && cd3 != '') {
							// 				$.post('/master/i1030/ratersearch', {
							// 					key: cd3,
							// 					ord: 'cd3',
							// 					employee_cd: data[i].employee_cd,
							// 					cd: cd3,
							// 					nm: nm3
							// 				})
							// 					.then(res => {
							// 						var ele = $('.emcd.' + res.employee_cd);
							// 						if (res.response.length > 0) {
							// 							if(typeof res.response[0].value != 'undefined' || res.response[0].value != ''){
							// 								res.nm = res.response[0].value;
							// 							}
							// 							clearRaterEmp(ele, '14', '3', res.cd, res.nm);
							// 						}
							// 						else {
							// 							clearRaterEmp(ele, '14', '3', '', '');
							// 						}
							// 					});
							// 			}
							// 			else {
							// 				clearRaterEmp(emcd, '14', '3', '', '');
							// 			}

							// 			// cd 4
							// 			if (cd4 != '0' && cd4 != '') {
							// 				$.post('/master/i1030/ratersearch', {
							// 					key: cd4,
							// 					ord: 'cd4',
							// 					employee_cd: data[i].employee_cd,
							// 					cd: cd4,
							// 					nm: nm4
							// 				})
							// 					.then(res => {
							// 						var ele = $('.emcd.' + res.employee_cd);
							// 						if (res.response.length > 0) {
							// 							if(typeof res.response[0].value != 'undefined' || res.response[0].value != ''){
							// 								res.nm = res.response[0].value;
							// 							}
							// 							clearRaterEmp(ele, '15', '4', res.cd, res.nm);
							// 						}
							// 						else {
							// 							clearRaterEmp(ele, '15', '4', '', '');
							// 						}
							// 					});
							// 			}
							// 			else {
							// 				clearRaterEmp(emcd, '15', '4', '', '');
							// 			}
							// 		}
							// 	}
							// }
						});
						break;
					// error
					case 201:
						jMessage(22, function () {
							$('#import_file').val('');
						});
						break;
					// csv content is empty
					case 202:
						// 対象データがありません。
						jMessage(23, function () {
							$('#import_file').val('');
						});
						break;
					// not csv format
					case 206:
						jMessage(27, function (r) {
							$("#import_file").val("");
						});
						break;
					// csv content error
					case 207:
						var filedownload = res['FileName'];
						var filename = '承認者設定【エラー】.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = 'ApproverError.csv';
							}
						if (filedownload != '') {
							downloadfileHTML(filedownload, filename, function () {
								//
							});
						}
						break;
					// csv colum not correct 
					case 208:
						jMessage(31, function (r) {
							$("#import_file").val("");
						});
						break;
					// Exception
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}
				$("#import_file").val("");
			}
		});
	} catch (e) {
		alert('importCSV: ' + e.message);
	}
}
function clearRaterEmp(emcd, colNum, ord, cd, nm) {
	emcd.find('.col' + colNum).find('.rater_employee_cd_' + ord).val(cd);
	emcd.find('.col' + colNum).find('.rater_employee_nm_' + ord).val(nm).attr('old_rater_employee_nm', nm);
}
/**
 * css_hover_row
 *
 * @author      :  tuantv - 2018/10/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function css_hover_row() {
	$("#table_result tbody tr").each(function () {
		var _this = $(this);
		var emp = $(this).attr("row_emp");
		$("#table_result tbody tr[row_emp ='" + emp + "']").hover(function () {
			_this.removeClass("noneHover");
			_this.addClass("colorRow");
		}, function () {
			_this.removeClass("colorRow");
			_this.addClass("noneHover");
		});
	});
}
/**
 * error
 *
 * @author      :   tuantv - 2018/10/16 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function errorStyleI1030(selector, message) {
	try {
		message = jQuery.castString(message);
		if (message !== '') {
			selector.addClass('boder-error');
			if (selector.next('.textbox-error').length > 0) {
			} else {
				selector.after('<div class="textbox-error">' + message + '</span>');
			}
			selector.closest('tr').find('td').css('vertical-align', 'center');
			selector.closest('tr').find(".textbox-error").parents("td").find('.rate_emp:first').css('margin-top', '20px');
			selector.closest('tr').find(".textbox-error").parents("td").find('.btn_employee_cd_popup:first').css('margin-top', '20px');
			selector.closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align', 'middle');
			_focusErrorItem();
		}

	} catch (e) {
		alert('errorStyleI1030' + e.message);
	}
}
/**
 * error
 *
 * @author      :   tuantv - 2018/12/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function errorStyleI1030_2(selector, message) {
	try {
		message = jQuery.castString(message);
		if (message !== '') {
			selector.addClass('boder-error');
			if (selector.next('.textbox-error').length > 0) {
			} else {
				selector.after('');
			}
			selector.closest('tr').find('td').css('vertical-align', 'center');
			selector.closest('tr').find(".textbox-error").parents("td").find('.rate_emp:first').css('margin-top', '20px');
			selector.closest('tr').find(".textbox-error").parents("td").find('.btn_employee_cd_popup:first').css('margin-top', '20px');
			selector.closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align', 'middle');
			_focusErrorItem();
		}

	} catch (e) {
		alert('errorStyleI1030' + e.message);
	}
}
/**
 * checkTabError
 *
 * @author : tuantv - 2017/10/16 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function checkTabError() {
	// mark error for tab
	$('a[data-toggle="tab"]').removeClass('tab-error');
	//
	if ($('.tab-pane:hidden').length > 0) {
		$('.tab-pane:hidden').each(function () {
			var id = $(this).attr('id');
			if ($('#' + id + ' .textbox-error').length > 0) {
				$('a[href="#' + id + '"]').addClass('tab-error');
			}
		});
	}
}
/*
 * @Author: tuantv@ans-asia.com
 *
 */
function tableContent() {
	$(".wmd-view-topscroll").scroll(function () {
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function () {
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function () {
		fixWidth();
	});
	function fixWidth() {
		var w = $('.wmd-view .table').outerWidth();
		var f = $('.table-group li:last').outerWidth();
		$(".wmd-view-topscroll .scroll-div1").width(w);
	}
}
/**
 * check value group_cd
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:
 */
function checkGroup(group_cd) {
	var _bool = false;
	if (group_cd == 0 && !$('#ck_search').is(':checked')) {
		$("#group_cd").removeClass("form-control required boder-error");
		$("#group_cd").addClass("form-control required boder-error");
		var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		$("#group_cd").after(html);
		_bool = true;
	}
	return _bool;
}
/**
 * check value group_cd
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:
 */
function checkMonth(month) {
	var _bool = false;
	if (month == 0 && $('#report_kinds').val() == 5) {
		$("#month").removeClass("form-control required boder-error");
		$("#month").addClass("form-control required boder-error");
		var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		$("#month").after(html);
		_bool = true;
	}
	return _bool;
}
/**
 * checkReport
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:
 */
function checkReport(report_kinds) {
	var _bool = false;
	if (report_kinds == -1) {
		$("#report_kinds").removeClass("form-control required boder-error");
		$("#report_kinds").addClass("form-control required boder-error");
		var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		$("#report_kinds").after(html);
		_bool = true;
	}
	return _bool;
}

/**
 * getParam
 *
 * @author  :   viettd - 2020/01/09 - create
 * @author  :
 * @param 	:
*/
function getParam(fiscal_year = 0, group_cd = 0) {
	try {
		// send data to post
		var param = {};
		var list = [];
		param.fiscal_year = fiscal_year;
		param.group_cd = group_cd;
		param.report_kinds = $('#report_kinds').val()
		param.report_typ = $('#report_typ').val()
		param.month = $('#month').val();
		param.time = $('#times').val();
		param.employee_typ = -1;
		param.employee_cdX = $('#reporter_cd').val();
		//該当グループなし
		param.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
		//処遇用途
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		//
		param.employee_cd = $('#reporter_cd').val();
		param.employee_nm = $('#reporter_cd').text();
		list = [];
		//
		if ($('#organization_step1 option').length > 0) {
				var str = $('#organization_step1').val().split('|');
				list.push({
					'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
		}
		param.list_organization_step1 = list;
		list = [];
		if ($('#organization_step2 option').length > 0) {
			if ($('#organization_step2').val() != '') {
				var str = $('#organization_step2').val().split('|');
				list.push({
					'organization_cd_1':  str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step2 = list;
		list = [];
		if ($('#organization_step3 option').length > 0) {
			if ($('#organization_step3').val() != '') {
				var str = $('#organization_step3').val().split('|');
				list.push({
					'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step3 = list;
		list = [];
		if ($('#organization_step4 option').length > 0) {
			if ($('#organization_step4').val() != '') {
				var str = $('#organization_step4').val().split('|');
				list.push({
					'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step4 = list;
		list = [];
		if ($('#organization_step5 option').length > 0) {
			if ($('#organization_step5').val() != '') {
				var str = $('#organization_step5').val().split('|');
				list.push({
					'organization_cd_1':  str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step5 = list;
		//
		return param;
	} catch (e) {
		alert('getParam error : ' + e.message);
	}
}
/**
 * get all checked employees
 *
 * @author      :   viettd - 2021/09/08 - create
 * @param      	:	null
 * @return      :   void
 */
 function getEmployeesChecked() {
	try {
		var employees = [];
		if($('#table_result').length > 0){
			$('#table_result tbody .tr_first').each(function () {
				var tr = $(this);
				if(tr.find('.checkbox_row').prop('checked')){
					employees.push(
						{
							employee_cd : tr.find('.key_emp').val()
						}
					);
				}
			});
		}
		// return 
		return employees;
	} catch (e) {
		alert('getEmployeesChecked:'+ e.message);
	}
}
function getParamsContent(mode,fiscal_year = 0,report_kind = 0,month = 0,group = 0,detail_no=0) {
	try {
		var data = {};
		data.mode = mode
		data.fiscal_year = fiscal_year.replace(/[^0-9]/g, '');
		data.report_kind = report_kind
		data.month = month
		data.group = group
		data.detail_no = detail_no
		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/weeklyreport/ri1020/get_params',
    		dataType	:	'html',
    		loading     :   true,
    		data		:	data,
		 success: function(res) {
			if (mode == 2) {
				 var month = []
				 var option = '<option value="-1"></option>'
				 month = JSON.parse(res)
				for (i = 0; i < month.length; i++) {
					var month_name = '';
						month_name = month[i]['month_nm']
					option += '<option value=' + month[i]['month'] + '>'+month_name+'</option>'
				 }
				 $('#month').html(option)
			} else if (mode == 4) {
				var group = []
				 var option = '<option value="-1"></option>'
				group = JSON.parse(res)
				 for (i = 0; i < group.length; i++) {
					 option += '<option value='+group[i]['group_cd']+'>'+group[i]['group_nm']+'</option>'
				}
				$('#ck_search').removeAttr('disabled')
				$('#ck_search').closest('.md-checkbox-v2').css('cursor', 'pointer');
					$('#ck_search').css('cursor', 'pointer');
					$('#ck_search').closest('.md-checkbox-v2').find('label').css('cursor', 'pointer');

				 $('#group_cd').html(option)
			} else if (mode == 3) {
				var detail_no = []
				 var option = '<option value="-1"></option>'
				 detail_no = JSON.parse(res)
				for (i = 0; i < detail_no.length; i++) {
					if ($('#times').val() == detail_no[i]['detail_no']) {
						option += '<option selected value=' + detail_no[i]['detail_no'] + '>' + detail_no[i]['title'] + '</option>'
					} else {
						option += '<option value=' + detail_no[i]['detail_no'] + '>' + detail_no[i]['title'] + '</option>'
					}
				 }
				 $('#times').html(option)
			}
		}
		});
	}catch(e){
		alert('search: ' + e.message);
	}
}
function errorStyleRI1020(selector, message) {
	try {
		console.log(selector)
		message = jQuery.castString(message);
		if (message !== '') {
			selector.addClass('boder-error');
			if (selector.next('.textbox-error').length > 0) {
			} else {
				selector.after('<div class="textbox-error">' + message + '</span>');
			}
			
			_focusErrorItem();
		}

	} catch (e) {
		alert('errorStyleI1030' + e.message);
	}
}
