
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
	'fiscal_year': { 'type': 'select', 'attr': 'id' },
	'group_cd': { 'type': 'select', 'attr': 'id' },
	'tr_first_value': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_1': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_2': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_3': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_4': { 'type': 'text', 'attr': 'class' },
			'treatment_applications_no_a': { 'type': 'text', 'attr': 'class' },
			'r_sheet_cd1': { 'type': 'text', 'attr': 'class' },
			'sheet_cd_a': { 'type': 'select', 'attr': 'class' },
			'r_employee_cd': { 'type': 'text', 'attr': 'class' },
			'r_employee_typ': { 'type': 'text', 'attr': 'class' },
			'r_job_cd': { 'type': 'text', 'attr': 'class' },
			'r_position_cd': { 'type': 'text', 'attr': 'class' },
			'r_grade': { 'type': 'text', 'attr': 'class' },
			'number': { 'type': 'text', 'attr': 'class' },
			'pos_emp': { 'type': 'text', 'attr': 'class' },
			'row_number': { 'type': 'text', 'attr': 'class' },
			'is_new': { 'type': 'text', 'attr': 'class' },
		}
	},
	'tr_second_value': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'treatment_applications_no_b': { 'type': 'text', 'attr': 'class' },
			'r_sheet_cd2': { 'type': 'text', 'attr': 'class' },
			'sheet_cd_b': { 'type': 'select', 'attr': 'class' },
			'number': { 'type': 'text', 'attr': 'class' },
			'row_number': { 'type': 'text', 'attr': 'class' },
		}
	},
	'tr_first_delete': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_1': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_2': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_3': { 'type': 'text', 'attr': 'class' },
			'rater_employee_cd_4': { 'type': 'text', 'attr': 'class' },
			'treatment_applications_no_a': { 'type': 'text', 'attr': 'class' },
			'r_sheet_cd1': { 'type': 'text', 'attr': 'class' },
			'sheet_cd_a': { 'type': 'select', 'attr': 'class' },
			'r_employee_cd': { 'type': 'text', 'attr': 'class' },
			'r_employee_typ': { 'type': 'text', 'attr': 'class' },
			'r_job_cd': { 'type': 'text', 'attr': 'class' },
			'r_position_cd': { 'type': 'text', 'attr': 'class' },
			'r_grade': { 'type': 'text', 'attr': 'class' },
			'number': { 'type': 'text', 'attr': 'class' },
		}
	},
	'tr_second_delete': {
		'attr': 'list', 'item': {
			'key_emp': { 'type': 'text', 'attr': 'class' },
			'key_group_cd': { 'type': 'text', 'attr': 'class' },
			'treatment_applications_no_b': { 'type': 'text', 'attr': 'class' },
			'r_sheet_cd2': { 'type': 'text', 'attr': 'class' },
			'sheet_cd_b': { 'type': 'select', 'attr': 'class' },
			'number': { 'type': 'text', 'attr': 'class' },
		}
	}
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
		$(document).on('change', '#treatment_applications_no', function() {
			var val = $(this).val();
			if ( val.length === 0 ) {
				$('#group_cd').empty().append('<option value="-1"></option>');
				return false;
			}
			val = val.map(function(item) {
				return {treatment_applications_no: item};
			});

			$.post({
				url: '/master/i1030/refergroupwithusetypeone',
				data: {
					fiscal_year: $('#fiscal_year').val(),
					treatment_json: JSON.stringify(val)
				},
				loading: true
			})
			.then(res => {
				$('#group_cd').empty().append('<option value="-1"></option>');
				for (var i=0; i<res.length; i++) {
					$('#group_cd').append('<option value="'+res[i].group_cd+'">'+res[i].group_nm+'</option>');
				}
			});
		});
		//
		$(document).on('click', '#table_result tbody tr', function () {
			try {
				$('.row_active').removeClass('row_active');
				$(this).addClass('row_active');
			} catch (e) {
				alert('#btn_add:' + e.message);
			}	
		})
		$(document).on('click', '#ckball', function () {
			try {
				if ($(this).prop('checked')) {
					checkall(1);
				} else {
					checkall(0);
				}
			} catch (e) {
				alert('#ckball:' + e.message);
			}
		});
		//
		$(document).on('click', '.checkbox_row', function () {
			try {
				var length = $("#table_result tbody tr .checkbox_row").length;
				var number = 0;
				var number = $("#table_result tbody tr .checkbox_row:checked").length;
				if (length == number) {
					$("#ckball").prop("checked", true);
				} else {
					$("#ckball").prop("checked", false);
				}
				if ($(this).prop('checked') == false) {
					$(this).removeClass("has-error");
				}
			} catch (e) {
				alert('.checkbox_row:' + e.message);
			}
		});
		//社員削除
		$(document).on('click', '#btn_delete', function () {
			try {
				var group_cd = $('#group_cd').val();
				if(checkGroup(group_cd) == false){
					$('#table_result tbody .tr_first').each(function (i) {
						$(this).attr("row_delete", i);
					});
					var count = 0;
					$("#table_result tbody input[type=checkbox]:checked").each(function () {
						var _this = $(this).closest('tr');
						var value = _this.attr("row_delete");
						if (typeof value !== typeof undefined && value !== false) {
							_this.addClass('tr_first_delete');
							_this.removeClass('tr_first');
							var row_span = _this.find('td:eq(0)').attr('rowspan');
							var index = _this.index();
							if (typeof row_span !== 'undefined') {
								var i = row_span - 1;
								while (i < row_span && i >= 1) {
									$("#table_result tbody tr").eq(index + i).addClass('tr_second_delete');
									$("#table_result tbody tr").eq(index + i).removeClass('tr_second');
									i--;
								}
							}
						} else {
							_this.parents("tr").remove();
						}
						count++;
						if (count <= 1) {
							$("#ckball").prop("checked", false);
						}
					});
				}
			} catch (e) {
				alert('#btn_delete:' + e.message);
			}
		});
		//refer group
		$(document).on('change', '#group_cd', function (e) {
			try {
				e.preventDefault();
				var group_cd = $("#group_cd").val();
				if (group_cd != '-1') {
					$('#ck_search').attr('disabled', 'disabled');
					$('#ck_search').prop('checked', false);
				} else {
					$('#ck_search').removeAttr('disabled')
				}
				refer_group(group_cd);
			} catch (e) {
				alert('#group_cd refer: :' + e.message);
			}
		});

		// search
		$(document).on('click', '#btn_search', function (e) {
			try {
				e.preventDefault();
				// clear error
				$('.box-input-search').find('.boder-error').removeClass('boder-error');
				$('.box-input-search').find('.textbox-error').remove();
				$('.box-input-search').find('#group_cd').removeClass('required');
				//
					var fiscal_year = $("#fiscal_year").val();
					var group_cd = $("#group_cd").val();
					var page = $('.page-item.active').attr('page');
					var cb_page = $('#cb_page').val();
					getList(fiscal_year, group_cd, page, cb_page);
			} catch (e) {
				alert('#btn_search : ' + e.message);
			}
		});
		// event page-item
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
		// event cb_page
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
		// btn 最新を適用
		$(document).on('click', '#btn_apply_latest', function (e) {
			try {
				if (_validate()) {
					// check choice employee in screens
					var check_cnt = 0;
					$('#table_result tbody tr .checkbox_row').each(function(){
						if($(this).prop('checked')){
							check_cnt++;
						}
					})
					// if not checked in checkbox
					if(check_cnt == 0){
						jMessage(18);
					}else{
						var li = $('.pagination li.active'),
						page = li.find('a').attr('page');
						var cb_page = $('#cb_page').val();
						applyLatest(page,cb_page);
					}
				}
			} catch (e) {
				alert('btn_apply_latest error : ' + e.message);
			}
		});
		$(document).on('click', '#btn-save', function (e) {
			try {
				jMessage(1, function (r) {
					$("#table_result tbody tr input[type=checkbox]:not(:checked)").each(function () {
						$(this).closest("tr").find("#employee_cd ").removeClass("required");
					});
					$("#table_result tbody tr input[type=checkbox]:checked").each(function () {
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
						var group_cd = $("#group_cd").val();
						var import_status = $('#group_cd').attr('import_status');
						if(import_status == 'true'){
							saveData();
						}else{
							if (checkGroup(group_cd) == false) {
								saveData();
							}
						}
					}
				});
			} catch (e) {
				alert('#btn-save' + e.message);
			}
		});
		// btn_csv_output
		$(document).on('click', '#btn_csv_output', function (e) {
			try {
				exportCSV();
			} catch (e) {
				alert('#btn_csv_output' + e.message);
			}
		});
		// btn_evaluation_import
		$(document).on('click', '#btn_evaluation_import', function (e) {
			try {
				if(_validate()){
					$('#import_file').trigger('click');
				}
			} catch (e) {
				alert('#btn-item-evaluation-input :' + e.message);
			}
		});

		$(document).on('change', '#import_file', function (e) {
			try {
				jMessage(6, function (r) {
					importCSV();
				});
			} catch (e) {
				alert('#import_file' + e.message);
			}
		});

		$(document).on('click', '.btn_employee_cd_popup2', function () {
			try {
				var _this = $(this).parent().parent().find('input:first');
				var position_cd = _this.data('rater_position_cd');
				var div = $(this).parents('.div_employee_cd');
				div.addClass('employee_cd_choice');
				showPopup("/master/popup/employee/".position_cd, {}, function () {
					div.find('.employee_cd_hidden').trigger('change');
					div.find('.employee_nm_single').focus();
				});
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});

		$(document).on('change', '.row_active .add_employee_cd', function () {
			try {
				var i = 0;
				var pos = $(this).closest('tr');
				var _this = $(this);
				var employee_cd = $(this).val();
				refer_emp(employee_cd, pos, function () {
					$(".employee_nm_single").removeAttr("disabled");
					if ($("#table_result tbody tr td").hasClass("textbox-error")) {
						$("#table_result tbody tr td:eq(1) .textbox-error:first").parents(".div_employee_cd_single").find("#employee_nm_single").focus();
					}
				});
			} catch (e) {
				alert('employee_nm_single:' + e.message);
			}
		});

		$(document).on('click', '#btn-back', function (e) {
			if (_validateDomain(window.location)) {
				window.location.href = '/dashboard';
			} else {
				if ($('#language_jmessages').val() == 'en') {
					jError('Error', 'This Protocol Or Host Domain Has Been Rejected.');
				}else{
					jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
				}
				
			}
		});

		$(document).on('click', '.btn_employee_cd_popup_single', function () {
			try {
				var _this = $(this).closest('tr');
				var employee_cd = _this.find('.key_emp').val();
				var group_cd = $("#group_cd").val();
				var div = $(this).parents('.div_employee_cd_single');
				div.addClass('employee_cd_choice');
				showPopup("/master/i1030/getemployee?employee_cd=" + employee_cd + '&group_cd=' + group_cd, {}, function () {
					div.find('.employee_nm_single').focus();
					div.find('.employee_nm_single').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});
		// [社員追加] button
		$(document).on('click', '#btn_add', function () {
			try {
					// check group is required
					var group_cd = $('#group_cd').val();
					if(checkGroup(group_cd) == false){
						// check latest li is disabled
						if($('.pagination li').last().hasClass('pagging-disable')||($($('#table_result tbody data_db').length == 0))){
							addNewEmployeeRow();
						}else{
							// get page last
							var li = $('.pagination li').last(),
							page = li.find('a').attr('page');
							var cb_page = $('#cb_page').val();
							var cb_page = cb_page == '' ? 20 : cb_page;
							var fiscal_year = $("#fiscal_year").val();
							var group_cd = $("#group_cd").val();
							getList(fiscal_year, group_cd,page,cb_page,true);
						}
					}	
			} catch (e) {
				alert('#btn_add:' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents' + e.message);
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
		$('.tr_first_value').removeClass('tr_first_value');
		$('.tr_second_value').removeClass('tr_second_value');
		$("#table_result tbody .tr_first").each(function (row) {
			var _this = $(this);
			//set position employee
			_this.find(".pos_emp").val(row);
			if (_this.find("td input[type=checkbox]").prop('checked')) {
				var row_span = _this.find('td:eq(0)').attr('rowspan');
				var index = _this.index();
				_this.addClass('tr_first_value');
				var i = row_span - 1;
				while (i <= row_span && i >= 1) {
					$("#table_result tbody tr").eq(index + i).addClass('tr_second_value');
					i--;
				}
			}
		});
		var data = [];
		var fiscal_year = $("#fiscal_year").val();
		var group_cd = $("#group_cd").val();
		data = getData(_obj);
		// get treatment_applications_no(処遇用途)
		var list = [];
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		data.data_sql.list_treatment_applications_no = list;
		list = [];
		//
		$('.div_loading').css('display', 'block');
		$.post('/master/i1030/save', JSON.stringify(data))
			.then(res => {
				$('.div_loading').css('display', 'none');
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function (r) {
							if (res['group_cd'] != '') {
								var page = $('.page-item.active').attr('page');
								var cb_page = $('#cb_page').val();
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
									$("#table_result tbody .tr_first_value").each(function (row) {
										if (res['errors'][i]['item'] != '.err_sheet_cd') {
											var tr_row = row + 1;
											if (value1 == tr_row) {
												errorStyleI1030($(this).find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
											}
											$(".boder-error").next().next().remove();
										}
										if (res['errors'][i]['item'] == '.err_sheet_cd') {
											var value2 = res['errors'][i]['value2'];
											errorStyleI1030($("#table_result tbody tr:eq(" + value2 + ")").find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
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
			})
			.catch(res => {
				$('.div_loading').css('display', 'none');
			});
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
		var param = getParam(fiscal_year, group_cd);
		param.employees_checked = getEmployeesChecked();
		param.page = page;
		param.page_size = page_size;
		// send ajax
		$.ajax({
			type: 'POST',
			url: '/master/i1030/apply_latest',
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
		var data = {};
		data['group_cd'] = group_cd;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/i1030/refer_group',
			dataType: 'html',
			// loading: true,
			data: data,
			success: function (res) {
				res = JSON.parse(res);
				switch (res['status']) {
					// success
					case 200:
						if (res.data.length > 0) {
							$('#group1').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[0] + '">' + res.data[0] + '</div>'
							);
							$('#group2').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[1] + '">' + res.data[1] + '</div>'
							);
							$('#group3').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[2] + '">' + res.data[2] + '</div>'
							);
							$('#group4').empty().html(
								'<div class="text-overfollow setTooltip" data-container="body" data-toggle="tooltip" data-original-title="' + res.data[3] + '">' + res.data[3] + '</div>'
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
function getList(fiscal_year = 0, group_cd = 0, page = 1, page_size = 20,is_add_row = false) {
	try {
		var param = getParam(fiscal_year, group_cd);
		param.page = page;
		param.page_size = page_size;
		//
		$.ajax({
			type: 'POST',
			url: '/master/i1030/search',
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
				if(is_add_row){
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
				$('#group_cd').attr('import_status','false');	// add by viettd 2021/01/26
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
				type: 'POST',
				url: '/master/i1030/rate_emp_autocomplete',
				dataType: 'json',
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
			$(this).attr('old_rater_employee_nm', ui.item.value);
			$(this).closest('span').find('.rater_employee_cd').val(ui.item.id);
			$(this).closest('span').find('input:first').val(ui.item.id);
			$(this).val(ui.item.value);
		}
	});

	// rate_emp lostfocus
	$(document).on('blur', '.rate_emp', function () {
		try {
			var rater_employee_cd = $(this).closest('span').find('.rater_employee_cd').val();
			var old_rater_employee_nm = $(this).attr('old_rater_employee_nm');
			var rater_employee_nm = $(this).val();
			if ((rater_employee_cd == '') || (rater_employee_cd != '' && old_rater_employee_nm != rater_employee_nm)) {
				$(this).val('');
				$(this).closest('span').find('.rater_employee_cd').val('');
			}
		} catch (e) {
			alert('.employee_nm' + e.message);
		}
	});
	$(".emp_nm").autocomplete({
		source: function (request, response) {
			$.ajax({
				type: 'POST',
				url: '/master/i1030/empautocomplete',
				dataType: 'json',
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
	//
	$(document).on('change', '#treatment_applications_no', function () {
		console.log('val', $(this).val());
	});
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
		obj.employee_cd = employee_cd;
		// get 処遇用途
		var list = [];
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		obj.list_treatment_applications_no = list;
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
						if($("#table_result tbody tr").length <= 0) {
							$("#table_result tbody").append('<tr></tr>');
						} 
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
							if(index == 0) {
								$("#table_result tbody").prepend($(res.data).addClass('TTT'));
							} else {
							$("#table_result tbody tr:last").after($(res.data).addClass('TTT'));
							}
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
					$('.textbox-error').remove()
					$(".row_active").find('.add_employee_cd').removeClass("required boder-error");
					$(".row_active").find('.textbox-error').remove();
					//
					$(".row_active").find('.add_employee_cd').addClass("required boder-error");;
					$(".row_active").find('.add_employee_cd').closest('span').after('<div class="textbox-error" style="margin-top: 20px">' + message + '</span>');
					$(".row_active").find('.add_employee_cd').val("");
					$(".ui-menu").css("display", "none");
					$(".row_active").find('.add_employee_cd').focus();
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
		var fiscal_year = $("#fiscal_year").val();
		var param = getParam(fiscal_year, group_cd);
		$.ajax({
			type: 'POST',
			url: '/master/i1030/export',
			dataType: 'json',
			loading: true,
			// data        :    {'data':obj},
			data: JSON.stringify(param),
			success: function (res) {
				// success
				switch (res['status']) {
					case OK:
						var filedownload = res['FileName'];
						var filename = '評価者設定.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = 'EvaluatorSettings.csv';
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
		data.import_file = $('');
		var formData = new FormData();
		formData.append('file', $('#import_file')[0].files[0]);
		formData.append('fiscal_year',$('#fiscal_year').val());
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
			url: '/master/i1030/import',
			loading: true,
			processData: false,
			contentType: false,
			enctype: "multipart/form-data",
			success: function (res) {
				switch (res['status']) {
					// success
					case 200:
						jMessage(7, function (r) {
							// if (res.data_import.length > 0) {
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
						var filename = '評価者設定【エラー】.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = 'RaterSettingError.csv';
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
	if (group_cd == -1) {
		$("#group_cd").removeClass("form-control required boder-error");
		$("#group_cd").addClass("form-control required boder-error");
		var html = "<div class='textbox-error'>" + _text[8].message + "</div>";
		$("#group_cd").after(html);
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
		//該当グループなし
		param.ck_search = $('#ck_search:checked').length == 0 ? 0 : 1;
		//処遇用途
		var div1 = $('#treatment_applications_no').closest('.multi-select-full');
		div1.find('input[type=checkbox]').each(function () {
			if ($(this).prop('checked')) {
				list.push({ 'treatment_applications_no': $(this).val() });
			}
		});
		param.list_treatment_applications_no = list;
		//
		param.employee_cd = $('#employee_cdX').val();
		param.employee_nm = $('#employee_nm').val();
		list = [];
		//
		if ($('#organization_step1 option').length > 0) {
			if ($('#organization_step1').val() != '') {
				var str = $('#organization_step1').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
					'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
					'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
					'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
					'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
				});
			}
		}
		param.list_organization_step1 = list;
		list = [];
		if ($('#organization_step2 option').length > 0) {
			if ($('#organization_step2').val() != '') {
				var str = $('#organization_step2').val().split('|');
				list.push({
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
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
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
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
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
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
					'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
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
/**
 * addNewEmployeeRow
 *
 * @author      :   viettd - 2021/09/08 - create
 * @param      	:	null
 * @return      :   void
 */
function addNewEmployeeRow() {
	try {
		if ($("#table_result tbody tr td").hasClass("w-popup-nodata")) {
			$("#table_result tbody .w-popup-nodata").closest("tr").remove();
		}
		if ($("#status").val() == "OK") {
			var index = $('#table_result tbody .tr_first').length + 1;
			var tr_first = $('#table_data tbody .tr_first').clone();
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
					$(this).find("input[type=checkbox]").attr("id", "id" + i);
					$(this).find("label:first").attr("for", "id" + i);
					i++;
				}
			});
			if ($("#table_result tbody tr:first td").attr("colspan") == "15") {
				$("#table_result tbody tr:first").remove();
			}
			$('.active_row').removeClass('row_active');
			$('#table_result tbody .tr_first:last').addClass('row_active');
			$('#table_result tbody .tr_first:last .add_employee_cd:first').focus();
			jQuery.formatInput();
			getAutocomplete();
			css_hover_row();
		}
	} catch (e) {
		alert('addNewEmployeeRow:'+ e.message);
	}
}