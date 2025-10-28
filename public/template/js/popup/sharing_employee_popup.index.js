/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2021/01/25
 * 作成者		    :	datnt – datnt@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
let is_first = false;
$(document).ready(function () {
	try {
		initialize();
		initEvents();
	} catch (e) {
		alert('ready' + e.message);
	}
});

/**
 * initialize
 *
 * @author		:	datnt - 2021/01/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		_formatTooltip();
		
		$(document).ready(function(){
	
			if($('#is_viewer_popup').attr('value') == 1) {
				is_first = true;
				$("#btn-search").trigger('click')
			}
		})
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	datnt - 2021/01/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		$(document).on('click', '#btn-choice', function () {
			try {
				apply();
			} catch (e) {
				alert('#btn-choice: ' + e.message);
			}
		});

		$(document).on('click', 'li a.page-link:not(.pagging-disable)', function (e) {
			var li = $(this).closest('li'),
				page = li.find('a').attr('page');
			$('.pagination li').removeClass('active');
			li.addClass('active');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
			search(page, cb_page,1);
			$('.div_loading').hide();
		});

		$(document).on('click', '#btn-search', function (e) {
			var page = 1;
			var page_size = 20;
			search(page, page_size);
		});
		$(document).on('change', '#cb_page', function (e) {
			var li = $('.pagination li.active'),
				page = li.find('a').attr('page');
			var cb_page = $(this).val();
			var cb_page = cb_page == '' ? 20 : cb_page;
			search(page, cb_page,1);
			$('.div_loading').hide();
		});
		$(document).on('change', '#ck_all', function () {
			try {
				var checked = $(this).is(':checked');
				if (checked) {
					$('input.ck_item').prop('checked', true);
				}
				else {
					$('input.ck_item').prop('checked', false);
				}
			} catch (e) {
				alert('#ck_all: ' + e.message);
			}
		});
		//checkbox
		$(document).on('change', '.ck_item', function () {
			try {
				var check_length = $('input.ck_item').length;
				var checked_length = $('input.ck_item:checked').length;
				//
				if (check_length == checked_length) {
					$('#ck_all').prop('checked', true);
				}
				else {
					$('#ck_all').prop('checked', false);
				}
				//
				//$(this).closest('tr').find('.adjust_point').trigger('change');
			} catch (e) {
				alert('#ck_item: ' + e.message);
			}
		});
		// btn_share_employee
		$(document).on("click", "#btn_share_employee", function () {
            try {
				var list = [];
				$('.employee_cd_apply').each(function () {
					if ($(this).prop('checked')) {
						let employee_cd = $(this).val();
						list.push({
							'employee_cd': employee_cd
						});
					}
				});
				// check list is exists 
				if (list.length > 0) {
					jMessage(1, function (r) {
						if (r) {
							shareEmployee(list);
						}
					});
				}else{
					jMessage(18);
				}
            } catch (e) {
                alert('#btn_share_employee: ' + e.message);
            }
        });
		$(document).on('click', '#btn_apply', function (e) {
            try {
				
                var html = '';
                var viewer = '';
                var list = [];
                $(".employee_cd_apply").each(function () {
                    if ($(this).prop('checked')) {
                        viewer += $('label[for=' + $(this).attr('id') + ']').text() + '、';
                        html += '<input type="hidden" class="viewer_employee_cd" value="' + $(this).val() + '">'
                        list.push($(this).val())
                    }
                });
                if (list.length == 0) {
                    jMessage(18, function (r) {
                        return false;
                    });
                }
                else if (list.length == (uniqueArray(list)).length) {
					
                    $('#btn-close-popup').trigger('click');
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_nm').attr("data-original-title", viewer.slice(0, -1));
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_nm').text(viewer.slice(0, -1));
                    parent.$("#myTable tbody tr").find('input:checkbox:checked').closest("tr").find('.list_viewer_employee_cd').empty().append(html);
                } else {
                    jMessage(32, function (r) {
                        return false;
                    });
                }
            } catch (e) {
                console.log('#btn_apply_latest:' + e.message);
            }
        });
	} catch (e) {

	}
}
/**
 * apply value
 *
 * @author  :   datnt - 2021/01/21 - create
 * @author  :
 *
 */
function apply() {
	try {
		var choices = [];
		var current_choices = [];
		$('#employee_share_tbl tbody tr').each(function () {
			if ($(this).find('td:eq(0) input[type="checkbox"]').prop('checked')) {
				let employee_cd = $(this).closest('tr').attr('employee_cd');
				let employee_nm = $(this).closest('tr').attr('employee_nm');
				choices.push({ employee_cd: employee_cd, employee_nm: employee_nm });
			}
		});
		// get current choices
		$('.employee_choice .employee_cd_apply').each(function () {
			current_choices.push($(this).val());
		});
		// if has choice employee
		if (choices.length > 0) {
			let html = '';
			$.each(choices, function (key, value) {
				if (current_choices.length > 0 && current_choices.includes(value.employee_cd)) {
					html += ''
				}else{
					html += '<div class="md-checkbox-v2 inline-block" style="margin-right:1rem">';
					html += '<input class="employee_cd_apply" name="check_' + (current_choices.length + key) + '" id="check_' + (current_choices.length + key) + '" type="checkbox" value="' + value.employee_cd + '" tabindex="13" checked>';
					html += '<label for="check_' + (current_choices.length + key) + '">' + value.employee_nm + '</label>';
					html += '</div>';	
				}
			});
			// apply to employee_choice
			$('.employee_choice').append(html);
		}
	} catch (e) {
		alert('apply' + e.message);
	}
}

/**
 * search
 *
 * @author  :   datnt - 2021/01/21 - create
 * @author  :
 *
 */
function search(page = 1, page_size = 20, mode = 0) { //mode 1 page, mode 0 click search
	try {
		var obj = {};
		obj.fiscal_year = $('#popup_fiscal_year').val();
		obj.employee_cd = $('#popup_employee_cd').val();
		obj.report_kind = $('#popup_report_kind').val();
		obj.report_no = $('#popup_report_no').val();
		obj.page = page;
		obj.page_size = page_size;
		obj.employee_cd_key = $('#employee_cd_key').val();
		obj.employee_nm_key = $('#employee_nm_key').val();
		obj.employee_typ = $('#employee_typ').val();
		obj.belong_cd1 = -1;
		obj.belong_cd2 = -1;
		obj.belong_cd3 = -1;
		obj.belong_cd4 = -1;
		obj.belong_cd5 = -1;
		if ($('#organization_step1').length > 0) {
			obj.belong_cd1 = $('#organization_step1').val();	
		}
		if ($('#organization_step2').length > 0) {
			let str = $('#organization_step2').val().split('|');
			obj.belong_cd2 = str[1] == 'undefined' ? '-1' : str[1];	
		}
		if ($('#organization_step3').length > 0) {
			let str = $('#organization_step3').val().split('|');
			obj.belong_cd3 = str[2] == 'undefined' ? '' : str[2];	
		}
		if ($('#organization_step4').length > 0) {
			let str = $('#organization_step4').val().split('|');
			obj.belong_cd4 = str[3] == 'undefined' ? '' : str[3];
		}
		if ($('#organization_step5').length > 0) {
			let str = $('#organization_step5').val().split('|');
			obj.belong_cd5 = str[4] == 'undefined' ? '' : str[4];
		}
		obj.job_cd = $('#job_cd').val();
		obj.position_cd = $('#position_cd').val();
		obj.group_cd = $('#group_cd').val();
		if($('#is_viewer_popup').attr('value') == 1) {
			obj.mygroup_cd = $('#group_cd_screen').val();
		} else {
			obj.mygroup_cd = $('#mygroup_cd').val();
		}
		var link = '/common/popup/reportEmployee'
		if($('#is_viewer_popup').attr('value') == 1) {
			var link = '/weeklyreport/ri1021/viewerSetting/search'
		}
		$.ajax({
			type: 'POST',
			url: link,
			dataType: 'html',
			loading: true,
			data: obj,
			success: function (res) {
				$('#result').empty();
				$('#result').html(res);
				$('#ck_all').focus();
				$('[data-toggle="tooltip"]').tooltip();
				if(mode ==0) {
					if(!$('.hid a').hasClass('collapsed')) {
						if(is_first == false) {
						$('.hid a').trigger('click');
						}
					}
				} 
				is_first = false
				_formatTooltip();
			}
		});
		$('.div_loading').hide();
	} catch (e) {
		console.log('search: ' + e.message);
	}
}

/**
 * Share for Employee
 */
function shareEmployee(list = []) {
    try {
        var data = {};
		data.fiscal_year = $('#popup_fiscal_year').val();
		data.employee_cd = $('#popup_employee_cd').val();
		data.report_kind = $('#popup_report_kind').val();
		data.report_no = $('#popup_report_no').val();
		data.share_explanation = $('#share_explanation').val();
		data.share_kbn = 0;
		if($('#share_kbn').length > 0){
			if ($('#share_kbn').prop('checked')) {
				data.share_kbn = 1;
			}
		}
		data.employees = list;
		// send data to post
        $.ajax({
            type: 'POST',
            url: '/common/popup/reportEmployee/share',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
						let login_employee_cd = $('#login_employee_cd').val();
						let obj = {};
						obj.fiscal_year = data.fiscal_year
						obj.employee_cd = data.employee_cd
						obj.report_kind = data.report_kind
						obj.report_no = data.report_no
						obj.employees = list;
						jMail(_text[2].message_nm, _text[2].message, JSON.stringify(obj), 4, login_employee_cd, function (r) {
							if (r) {
								$('#btn-close-popup').trigger('click');
								parent.location.reload();    
							}
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
    } catch (e) {
        alert('shareEmployee' + e.message);
    }
}
function uniqueArray(orinalArray) {
    return orinalArray.filter((elem, position, arr) => {
        return arr.indexOf(elem) == position;
    });
}