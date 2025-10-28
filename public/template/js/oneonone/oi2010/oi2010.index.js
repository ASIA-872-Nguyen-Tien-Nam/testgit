/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	fiscal_year: { type: "text", attr: "id" },
	times: { type: "text", attr: "id" },
	interview_cd: { type: "text", attr: "id" },
	member_cd: { type: "text", attr: "id" },
	oneonone_schedule_date: { type: "text", attr: "id" },
	free_question: { type: "text", attr: "id" },
	// target1: { type: "text", attr: "id" },
	// target2: { type: "text", attr: "id" },
	// target3: { type: "text", attr: "id" },
	// comment: { type: "text", attr: "id" },
	member_comment: { type: "text", attr: "id" },
	coach_comment1: { type: "text", attr: "id" },
	next_action: { type: "text", attr: "id" },
	coach_comment2: { type: "text", attr: "id" },
	list_question: {
		attr: "list",
		item: {
			interview_gyocd: { type: "text", attr: "class" },
			answer: { type: "text", attr: "class" },
		},
	},
};
$(function () {
	initEvents();
	initialize();
	_setTabIndex();
	//calcTable();
});

/**
 * initialize
 *
 * @author		:	sondh - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		_formatTooltip();
	} catch (e) {
		alert("initialize: " + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/09/06 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		//back
		$(document).on('click', '#btn-back', function (e) {
			try {
				//
				var from = $('#from').val();
				if (from == '' || from == 'oq2020') {
					_backButtonFunction('', true);
				} else {
					_backButtonFunction(from);
				}
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
		// click 評価シート
		$(document).on("change", ".answer", function () {
			try {
				input_has_data = 0;
				$('.answer').each(function () {
					if ($(this).val() != '') {
						input_has_data++
					}
				})
				if (input_has_data > 0) {
					$('.answer').removeClass('required')
				} else {
					$('.answer').addClass('required')
				}
			} catch (e) {
				alert('.answer' + e.message);
			}
		});
		$(document).on("click", ".dropdown dt a", function () {
			try {
				if ($(this).hasClass('disabled')) {
					return
				} else {
					$("#data-select").toggle();
				}
			} catch (e) {
				alert('.dropdown dt a' + e.message);
			}
		});
		$(document).on('click', '#btn-excel', function () {
			try {
				let params = {
					'fiscal_year': $('#fiscal_year').val(),
					'member_cd': $('#member_cd').val(),
					'times': $('#times').val(),
				}
				$.downloadFileAjax('/oneonone/oi2010/listexcel', JSON.stringify(params));
			} catch (e) {
				alert('#btn-excel' + e.message);
			}
		})
		$(document).mouseup(function (e) {
			try {
				var container = $(".table-select");
				// if the target of the click isn't the container nor a descendant of the container
				if (!container.is(e.target) && container.has(e.target).length === 0) {
					$("#data-select").hide();
				}
			} catch (e) {
				alert('mouseup' + e.message);
			}
		});
		$(document).on("click", ".tr-select", function () {
			try {
				var text = $(this).find(".image_select").html();
				$(".remark_dropdown").find("span").html(text);
				$("#data-select").hide();
			} catch (e) {
				alert('tr-select' + e.message);
			}
		});
		//
		$(document).bind("click", function (e) {
			try {
				var $clicked = $(e.target);
				if (!$clicked.parents().hasClass("dropdown")) $(".dropdown dd ul").hide();
			} catch (e) {
				alert('click' + e.message);
			}
		});
		//add by vietdt 2021/12/03
		$(document).on("click", ".btn-temporary", function (e) {
			try {
				e.preventDefault();
				jMessage(1, function (r) {
					$('.answer').trigger('change');
					if (r && validateOi2010($('body'))) {
						saveTemporary();
					}
				});
			} catch (e) {
				alert('.btn-temporary:' + e.message);
			}
		});
		//
		$(document).on("click", ".btn-startasign", function (e) {
			try {
				e.preventDefault();
				jMessage(1, function (r) {
					$('.answer').trigger('change');
					if (r && validateOi2010($('body'))) {
						save("START");
					}
				});
			} catch (e) {
				alert('.btn-startasign:' + e.message);
			}
		});
		$(document).on("click", ".btn-beginasign", function (e) {
			try {
				e.preventDefault();
				$('.title-date').find('lb-required').removeClass('lb-required');
				$('#oneonone_schedule_date').removeClass('required');
				jMessage(1, function (r) {
					$('.answer').trigger('change');
					if (r && _validate($("body"))) {
						$('.title-date').find('lb-required').addClass('lb-required');
						$('#oneonone_schedule_date').addClass('required');
						save("FINISH");
					}
				});
			} catch (e) {
				alert('.btn-beginasign:' + e.message);
			}
		});
		$(document).on("click", ".btn-finishasign", function (e) {
			try {
				e.preventDefault();
				jMessage(43, function (r) {
					if (r) {
						save("UNDO");
					}
				});
			} catch (e) {
				alert('.btn-finishasign:' + e.message);
			}
		});
		//1on1前登録解除 add by vietdt 2021/12/06
		$(document).on("click", ".btn-previous-deregistration", function (e) {
			try {
				e.preventDefault();
				jMessage(43, function (r) {
					if (r) {
						save("UNDOSTART");
					}
				});
			} catch (e) {
				alert('.btn-previous-deregistration:' + e.message);
			}
		});
		//combo_coach_comment2 --add by vietdt 2021/04/23
		$(document).on("change", "#combo_coach_comment2", function (e) {
			try {
				var optionVal = new Array();
				var coach_comment2 = $("#coach_comment2").val();
				var combo_coach_comment2 = $(this).val();
				var k = 0; //1: The selected string exists ;0 not The selected string exists
				$('#combo_coach_comment2 option').each(function () {
					if ($(this).val() != '') {
						optionVal.push($(this).val());
					}
				});
				// replaces the selected string
				$.each(optionVal, function (i) {
					if (coach_comment2.includes(optionVal[i])) {
						coach_comment2 = coach_comment2.replace(optionVal[i], combo_coach_comment2);
						k++;
					}
				});
				$("#coach_comment2").val(coach_comment2.trim());
				$("#combo_coach_comment2").attr('save_value', k);
			} catch (e) {
				alert('#combo_coach_comment2' + e.message);
			}
		});
		// btn_popup_search_employee Employee Comprehensive Manager
		$(document).on('click', '#btn_popup_search_employee', function () {
			try {
				showPopup("/common/popup/getEmployeeComprehensiveManager", {}, function () {
				});
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});
	} catch (e) {
		alert("initEvents: " + e.message);
	}
}

//***********************************************ALLL FUNCTION DOWN THERE***************************************************** */
/**
 * save
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */

function save(save_mode) {
	try {
		if ($("#combo_coach_comment2").attr('save_value') == 0) {
			var coach_comment2 = $("#coach_comment2").val();
			var combo_coach_comment2 = $('#combo_coach_comment2').val();
			if (combo_coach_comment2 == '') {
				$("#coach_comment2").val(coach_comment2);
			} else {
				$("#coach_comment2").val(combo_coach_comment2 + ' ' + coach_comment2);
			}
		}
		var data = getData(_obj);
		data.data_sql.fullfillment_type = $("#fullfillment_type")
			.find(".value_fullfillment_type")
			.val();
		data.data_sql.save_mode = save_mode;
		var screen_mode = $('#screen_mode').val();
		var login_employee_cd = $('#login_employee_cd').val();
		var member_cd = $('#member_cd').val();
		// send ajax
		$.ajax({
			type: "POST",
			url: "/oneonone/oi2010/save",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//
						group_cd_1on1 = res['data_oi3010']['oneonone_group_cd'];
						questionnaire_cd = res['data_oi3010']['questionnaire_cd'];
						is_redirect_i3010 = res['data_oi3010']['is_redirect_i3010'];
						var from = $('#from').val();
						if (save_mode == 'FINISH'
							&& screen_mode == 12
							&& (login_employee_cd == member_cd)
							&& (member_cd != '')
							&& (questionnaire_cd > 0)
						) {
							var data = {
								'fiscal_year_1on1': $('#fiscal_year').val()
								, 'employee_cd': $('#member_cd').val()
								, 'group_cd_1on1': group_cd_1on1
								, 'times': $('#times').val()
								, 'questionnaire_cd': questionnaire_cd
								, 'from': 'oi2010'
								, 'source_from': from
								, 'screen_id': 'oi2010_oi3010'
							};
							//
							if (is_redirect_i3010 == '1' && is_redirect_i3010 != undefined && group_cd_1on1 != undefined) {
								_redirectScreen('/oneonone/oi3010', data);
							} else {
								// 
								if (from == 'odashboardmember') {
									_backButtonFunction(from);
								} else {
									_backButtonFunction('', true);
								}
							}
						} else {
							var msg_no = 2;
							if (save_mode == 'UNDO' || save_mode == 'UNDOSTART') {
								msg_no = 44;
							}
							jMessage(msg_no, function (r) {
								location.reload();
							});
						}

						break;
					// error
					case NG:
						if (typeof res["errors"] != "undefined") {
							processError(res["errors"]);
						}

						break;
					// Exception
					case EX:
						jError(res["Exception"]);
						break;
					default:
						break;
				}
			},
		});
	} catch (e) {
		alert("save" + e.message);
	}
}
/**
 * _setTabIndex
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */

function _setTabIndex() {
	var tabindex = 1;
	$('#i2010_body').find(':input:not([disabled]):not([readonly]):not([type="hidden"]):not(.notAuto_tabindex)').each(function (i) {
		var _this = $(this);
		_this.attr('tabindex', tabindex);
		tabindex++;
	});
	$('.nav-menubar-pc a').each(function (i) {
		var _this = $(this);
		_this.attr('tabindex', tabindex);
		tabindex++;
	})
	$('.notAuto_tabindex').each(function (i) {
		var _this = $(this);
		_this.attr('tabindex', '-1');
	});
}

/**
 * validateOi2010
 *
 * @author      :   viettd - 2021/06/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function validateOi2010(element) {
	try {
		var error = 0;
		_clearErrors(1);
		// input + textarea required
		element.find('.required:enabled').each(function () {
			if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
				if (($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '') {
					$(this).errorStyle(_text[8].message, 1);
					error++;
				} else if ($(this).is("select") && ($(this).val() == '-1' || $(this).val() == undefined)) {
					$(this).errorStyle(_text[8].message, 1);
					error++;
				}
			}
		});
		//  item マック (required)
		if ($('#span-selected').find('.value_fullfillment_type').val() == 0) {
			$('#span-selected').parents('dt').errorStyle(_text[8].message, 1);
			error++;
			window.scrollTo(0, 0);
		}
		// check error
		if (error > 0) {
			_focusErrorItem();
			return false;
		} else {
			return true;
		}
	} catch (e) {
		alert('validateOi2010 : ' + e.message);
	}
}


/**
 * save
 *
 * @author      :   vietdt - 2021/12/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */

function saveTemporary() {
	try {
		if ($("#combo_coach_comment2").attr('save_value') == 0) {
			var coach_comment2 = $("#coach_comment2").val();
			var combo_coach_comment2 = $('#combo_coach_comment2').val();
			if (combo_coach_comment2 == '') {
				$("#coach_comment2").val(coach_comment2);
			} else {
				$("#coach_comment2").val(combo_coach_comment2 + ' ' + coach_comment2);
			}
		}
		var data = getData(_obj);
		data.data_sql.fullfillment_type = $("#fullfillment_type")
			.find(".value_fullfillment_type")
			.val();
		// send ajax
		$.ajax({
			type: "POST",
			url: "/oneonone/oi2010/saveTemporary",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//
						jMessage(2, function (r) {
							location.reload();
						});
						break;
					// error
					case NG:
						if (typeof res["errors"] != "undefined") {
							processError(res["errors"]);
						}

						break;
					// Exception
					case EX:
						jError(res["Exception"]);
						break;
					default:
						break;
				}
			},
		});
	} catch (e) {
		alert("save" + e.message);
	}
}