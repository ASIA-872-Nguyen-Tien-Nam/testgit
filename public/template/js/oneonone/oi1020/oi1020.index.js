/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/02/05
 * 作成者          :   phuhv – phuhv@ans-asia.com
 *
 * @package         :
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
var _mode = 0;
var _obj = {
	fiscal_year: { type: "text", attr: "id" },
	group_cd: { type: "text", attr: "id" },
	coach_cd: { type: "text", attr: "id" },
	date_from: { type: "text", attr: "id" },
	date_to: { type: "text", attr: "id" },
	member_cd: { type: "text", attr: "id" },
	position_cd: { type: "text", attr: "id" },
	list_pair: {
		attr: "list",
		item: {
			ck_item: { type: "checkbox", attr: "class" },
			employee_cd: { type: "text", attr: "class" },
			times: { type: "text", attr: "class" },
		},
	},
};
$(function () {
	try {
		_formatTooltip();
		initEvents();
		initialize();
	} catch (e) {
		alert("initialize: " + e.message);
	}
});
/**
 * initialize
 *
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
	try {
		let fiscal_year = $('#fiscal_year option:selected').val();
		$('.employee_nm_1on1').attr('fiscal_year_1on1', fiscal_year)
		$(".multiselect").multiselect({
			onChange: function () {
				$.uniform.update();
			},
		});
	} catch (e) {
		alert("initialize: " + e.message);
	}
}
/**
 * delete
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function initEvents() {
	try {
		// event page-item
		$(document).on('click', '.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
			try {
				e.preventDefault();
				$('.page-item').removeClass('active');
				$(this).addClass('active')
				var page = $(this).attr('page');
				var cb_page = $('#cb_page').find('option:selected').val();
				var cb_page = cb_page == '' ? 1 : cb_page;
				search(1, page, cb_page,1);
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
				search(1, page, cb_page,1);
			} catch (e) {
				alert('#cb_page '+ e.message);
			}
		});
		$(document).on('click', '#btn-back', function (e) {
			try {
				//
				var home_url = $('#home_url').attr('href');
				_backButtonFunction(home_url);
			} catch (e) {
				alert('#btn-back:' + e.message);
			}
		});
		//
		$(document).on('change', '#fiscal_year', function () {
			let fiscal_year = $('#fiscal_year option:selected').val();
			$('.employee_nm_1on1').attr('fiscal_year_1on1', fiscal_year)
		})
		$(document).on("change", ".select_apply_bar", function (e) {
			enableApplyButton($(this));
		});
		$(document).on("blur", ".search_apply_bar", function (e) {
			enableApplyButton($(this));
		});
		$(document).on("change", ".interview_cd", function (e) {
			let time = $(this).attr("times");
			$(this)
				.parents("tr")
				.find(".coach_cd_" + time)
				.attr("interview_cd", $(this).val());
		});
		$(document).on("change", "#fiscal_year,#group_cd", function (e) {

			$("#oneonone_times").val($("#group_cd option:selected").attr("times"));
			if ($('#fiscal_year').val() != '-1' && $('#group_cd').val() != '-1') {
				referGroupInfo();
			} else {
				$('.div_loading').show();
				setTimeout(() => {
					blankData();
					$('#group_cd').val(-1);
					$('.div_loading').hide();
				}, 200);
			}
		});
		$(document).on("click", "#btn_search", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
				var page = $('.page-item.active').attr('page');
				var cb_page = $('#cb_page').val();
				search(1,page, cb_page,1);
			}
		});
		$(document).on("click", "#btn-export", function (e) {
			e.preventDefault();
			export_csv();
		});
		$(document).on("click", "#apply_value", function (e) {
			e.preventDefault();
			if (_validate($("body"))) {
				let chk_cnt = 0;
				$(".list_pair").each(function () {
					if ($(this).find(".ck_item").is(":checked")) {
						chk_cnt++;
					}
				});
				if (chk_cnt == 0) {
					jMessage(126);
				}else{
					var page = $(this).attr('page');
					var cb_page = $('#cb_page').find('option:selected').val();
					var cb_page = cb_page == '' ? 1 : cb_page;
					search(2, page, cb_page,1);
				}
			}
		});
		$(document).on("click", ".btn-save", function (e) {
			try {
				e.preventDefault();
				jMessage(1, function (r) {
					if (r && _validate($("body"))) {
						save();
					}
				});
			} catch (e) {
				alert(".btn-save:" + e.message);
			}
		});
		$(document).on("click", "#bulk_change", function (e) {
			try {
				let times = $(this).attr("times");
				if ($("#table-data2 tbody tr td .ck_item:checked").length == 0) {
					jMessage(126);
				}else{
					bulkUpdate(times);
				}
			} catch (e) {
				alert("bulk_change: " + e.message);
			}
		});
		//
		$(document).on("click", "#btn-show", function (e) {
			hide_show_table("invi", 1);
			// e.preventDefault();
			if ($(this).parent(".btn-group").find(".clicked").length == 0) {
				_mode = 1;
				$(".hid-col").addClass("hidden");
				$(this).addClass("clicked");
				$(this).find("#btn_text").text(display_attribute_info);
				$(this).find(".fa").removeClass("fa-eye-slash");
				$(this).find(".fa").addClass("fa-eye");
				$('#table-data').css('min-width', '2000px');
				$('#table-data2').css('min-width', '2000px');
				var check = 0;
				$(".buttonhide").each(function (e) {
					if ($(this).val() == "") {
						check = check + 1;
					}
				});
				hide_show_table("invi", 0);
			} else {
				_mode = 0;
				$(".hid-col").removeClass("hidden");
				$(this).removeClass("clicked");
				$(this).find("#btn_text").text(hide_attribute_info);
				$(this).find(".fa").addClass("fa-eye-slash");
				$(this).find(".fa").removeClass("fa-eye");
				$('#table-data').css('min-width', '2600px');
				$('#table-data2').css('min-width', '2600px');
				var check = 0;
				$(".buttonhide").each(function (e) {
					if ($(this).val() == "") {
						check = check + 1;
					}
				});
				hide_show_table("invi", 1);
			}
			caculateWidth();
		});
		//chekbox all
		$(document).on("change", "#ck_all", function () {
			try {
				var checked = $(this).is(":checked");
				if (checked) {
					$("input.ck_item").prop("checked", true);
				} else {
					$("input.ck_item").prop("checked", false);
				}
			} catch (e) {
				alert("#ck_all: " + e.message);
			}
		});
		//checkbox
		$(document).on("change", ".ck_item", function () {
			try {
				var check_length = $("input.ck_item").length;
				var checked_length = $("input.ck_item:checked").length;
				//
				if (check_length == checked_length) {
					$("#ck_all").prop("checked", true);
				} else {
					$("#ck_all").prop("checked", false);
				}
				//
				//$(this).closest('tr').find('.adjust_point').trigger('change');
			} catch (e) {
				alert("#ck_item: " + e.message);
			}
		});
		$(document).on("click", "#btn-import", function (e) {
			try {
				$("#import_file").replaceWith($("#import_file").val("").clone(true));
				$("#import_file").trigger("click");
			} catch (e) {
				alert("#btn-item-evaluation-input :" + e.message);
			}
		});
		$(document).on("change", "#import_file", function (e) {
			try {
				jMessage(6, function (r) {
					importCSV();
				});
			} catch (e) {
				alert("#btn-save" + e.message);
			}
		});
		//btn-delete
		$(document).on("click", "#btn-delete", function (e) {
			try {
				jMessage(3, function (r) {
					if (r) {
						deleteData();
					}
				});
			} catch (e) {
				alert("#btn-delete :" + e.message);
			}
		});
	} catch (e) {
		alert("initEvents: " + e.message);
	}
}
/**
 * hide_show_table
 *
 * @author      :   viettd - 2020/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function hide_show_table(col_name, check) {
	if (check == 0) {
		var all_col = document.getElementsByClassName(col_name);
		var all_th = document.getElementsByClassName(col_name + "_head");
		for (var i = 0; i < all_col.length; i++) {
			all_col[i].style.display = "none";
		}
		for (var i = 0; i < all_th.length; i++) {
			all_th[i].style.display = "none";
		}
		document.getElementsByClassName(col_name).value = "show";
		$(".table-col").attr("colspan", "2");
		$(".hide-table").css("display", "none");
	} else {
		let original_col_span = $(".table-col").attr("original_col_span");
		var all_col = document.getElementsByClassName(col_name);
		var all_th = document.getElementsByClassName(col_name + "_head");
		for (var i = 0; i < all_col.length; i++) {
			all_col[i].style.display = "table-cell";
		}
		for (var i = 0; i < all_th.length; i++) {
			all_th[i].style.display = "table-cell";
		}
		$(".table-col").attr("colspan", original_col_span);
		$(".hide-table").css("display", "");
		document.getElementsByClassName(col_name).value = "hide";
	}

}
/**
 * refer
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referGroupInfo() {
	try {
		var list = [];
		data = {};
		list.push({ oneonone_group: $("#group_cd").val() });
		data.fiscal_year = $("#fiscal_year").val();
		data.oneonone_group_list = list;
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oi1020/refer",
			dataType: "json",
			data: JSON.stringify(data),
			loading: true,
			success: function (res) {
				if (res['error_141'] == 1) {
					jMessage(141, function () {
						$('.div_loading').show();
						setTimeout(() => {
							blankData();
							$('#group_cd').val(-1);
							$('.div_loading').hide();
						}, 200);
					});
				} else {
					$('#table1 tbody').empty();
					$('#table1 tbody').append(res['view']);
					let fiscal_year = $('#fiscal_year option:selected').val();
					$('.employee_nm_1on1').attr('fiscal_year_1on1', fiscal_year);
					blankData();
				}
			},
		});
	} catch (e) {
		alert("referGroupInfo" + e.message);
	}
}
/**
 * refer
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function search(mode,page = 1, cb_page = 20,paging = 0) {
	try {
		var list_org = getOrganization();
		var data = getData(_obj);
		data.data_sql.list_organization_step1 = list_org.list_organization_step1;
		data.data_sql.list_organization_step2 = list_org.list_organization_step2;
		data.data_sql.list_organization_step3 = list_org.list_organization_step3;
		data.data_sql.list_organization_step4 = list_org.list_organization_step4;
		data.data_sql.list_organization_step5 = list_org.list_organization_step5;
		data.data_sql.page_size = cb_page;
		data.data_sql.page = page;
		data.data_sql.mode = mode;
		console.log(data);
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oi1020/search",
			dataType: "json",
			data: JSON.stringify(data),
			loading: true,
			success: function (res) {
				if (res["error"] == 21 && mode == 2) {
					jMessage(21);
				} else if (res["error"] == 142) {
					jMessage(142, function () {
						$('.div_loading').show();
						setTimeout(() => {
							blankData();
							$('#group_cd').val(-1);
							$('.div_loading').hide();
						}, 200);
					});
				} else {
					$('#table__result').show();
					// $("#table__result").empty();
					// $("#table__result").append(res["view"]);
					$('#table__result').html(res['view']);
					_formatTooltip();
					app.jTableFixedHeader();
					app.jSticky();
					if(paging == 0){
						$('.button-card').trigger('click');
					}
					jQuery.formatInput();
					unFixedWhenSmallScreen();
				}
			},
		});
	} catch (e) {
		alert("search" + e.message);
	}
}

/**
 * refer
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function export_csv() {
	try {
		var list_org = getOrganization();
		var data = getData(_obj);
		data.data_sql.list_organization_step1 = list_org.list_organization_step1;
		data.data_sql.list_organization_step2 = list_org.list_organization_step2;
		data.data_sql.list_organization_step3 = list_org.list_organization_step3;
		data.data_sql.list_organization_step4 = list_org.list_organization_step4;
		data.data_sql.list_organization_step5 = list_org.list_organization_step5;
		data.data_sql.mode = 3;
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oi1020/export",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//location.reload();
						// var returnRes       =   JSON.parse(res);
						var filedownload = res["FileName"];
						if (filedownload != "") {
							var filename = '1on1ペア設定.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = '1on1_Pair_Setting.csv';
							}
							downloadfileHTML(filedownload, filename, function () {
								//
							});
						} else {
							jError(2);
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
		alert("export_csv" + e.message);
	}
}
/**
 * Save
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function save() {
	try {
		var data = {};
		var list = [];
		list = getDataPairs();
		data.list_pair = list;
		data.fiscal_year = $("#fiscal_year").val();
		data.group_cd = $("#group_cd").val();
		$.ajax({
			type: "POST",
			url: "/oneonone/oi1020/save",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//
						jMessage(2, function (r) {
							// do something
							// location.reload();
							// $('#table-data tbody tr:first td:first-child input').focus();
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
/**
 * importCSV
 *
 * @author      :  viettd - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
	try {
		var formData = new FormData();
		formData.append("file", $("#import_file")[0].files[0]);
		var fiscal_year = $("#fiscal_year").val();
		var group_cd = $("#group_cd").val();
		var times = $("#oneonone_times").val();
		var count_organization = $("#count_organization").val();
		formData.append("group_cd", group_cd);
		formData.append("fiscal_year", fiscal_year);
		formData.append("times", times);
		formData.append("count_organization", count_organization);
		$.ajax({
			type: "POST",
			data: formData,
			url: "/oneonone/oi1020/import",
			loading: true,
			processData: false,
			contentType: false,
			enctype: "multipart/form-data",
			success: function (res) {
				switch (res["status"]) {
					// success
					case 200:
						jMessage(7,function(r){
							if(r){
								$("#import_file").val("");
							}
						});
						break;
					// error
					case 201:
						jMessage(22);
						break;
					case 206:
						jMessage(27, function (r) {
							$("#import_file").val("");
						});
						break;
					case 207:
						jMessage(31, function (r) {
							$("#import_file").val("");
						});
						break;
					case 9999:
						var filedownload = res["FileName"];
						if (filedownload != "") {
							var filename = '1on1ペア設定_エラー.csv';
							if ($('#language_jmessages').val() == 'en') {
								filename = '1on1_Pair_Setting_Error.csv';
							}
							downloadfileHTML(filedownload, filename, function () {
								//
							});
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
		alert("importCSV: " + e.message);
	}
}
/**
 * delete
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
	try {
		var data = {};
		var list = [];
		list = getDataPairs();
		data.list_pair = list;
		data.fiscal_year = $("#fiscal_year").val();
		data.group_cd = $("#group_cd").val();
		// send data to post
		$.ajax({
			type: "POST",
			url: "/oneonone/oi1020/delete",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//location.reload();
						jMessage(4, function () {
							var page = $('.page-item.active').attr('page');
                			var cb_page = $('#cb_page').val();
							search(1, page, cb_page,1);
							// $("#btn_search").trigger("click");
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
		alert("deleteData" + e.message);
	}
}
/**
 * Get data selected value in organization select box
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   object
 * @access      :   public
 * @see         :
 */
function getOrganization() {
	let param = [];
	let list = [];
	var div_organization_step1 = $("#organization_step1").closest("div");
	if (div_organization_step1.hasClass("multi-select-full")) {
		var div1 = $("#organization_step1").closest(".multi-select-full");
		div1.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step1 = list;
	list = [];
	var div_organization_step2 = $("#organization_step2").closest("div");
	if (div_organization_step2.hasClass("multi-select-full")) {
		var div2 = $("#organization_step2").closest(".multi-select-full");
		div2.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step2 = list;
	list = [];
	var div_organization_step3 = $("#organization_step3").closest("div");
	if (div_organization_step3.hasClass("multi-select-full")) {
		var div3 = $("#organization_step3").closest(".multi-select-full");
		div3.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step3 = list;
	list = [];
	var div_organization_step4 = $("#organization_step4").closest("div");
	if (div_organization_step4.hasClass("multi-select-full")) {
		var div4 = $("#organization_step4").closest(".multi-select-full");
		div4.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step4 = list;
	list = [];
	var div_organization_step5 = $("#organization_step5").closest("div");
	if (div_organization_step5.hasClass("multi-select-full")) {
		var div5 = $("#organization_step5").closest(".multi-select-full");
		div5.find("input[type=checkbox]").each(function () {
			if ($(this).prop("checked")) {
				var str = $(this).val().split("|");
				//
				list.push({
					organization_cd_1: str[0] == "undefined" ? "" : str[0],
					organization_cd_2: str[1] == "undefined" ? "" : str[1],
					organization_cd_3: str[2] == "undefined" ? "" : str[2],
					organization_cd_4: str[3] == "undefined" ? "" : str[3],
					organization_cd_5: str[4] == "undefined" ? "" : str[4],
				});
				// list.push({'organization_cd':$(this).val()});
			}
		});
	}
	param.list_organization_step5 = list;
	list = [];
	return param;
}
/**
 *  change fixed header to scollable
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   N/A
 * @access      :   public
 * @see         :
 */
function unFixedWhenSmallScreen() {
	var window_width = window.outerWidth;

	if (window_width < 600) {
		$('.th-1').addClass('old-th-1');
		$('.th-2').addClass('old-th-2');
		$('.th-3').addClass('old-th-3');
		//
		$('td').removeClass('th-1');
		$('th').removeClass('th-1');
		//
		$('td').removeClass('th-2');
		$('th').removeClass('th-2');
		//
		$('td').removeClass('th-3');
		$('th').removeClass('th-3');

	} else {
		$('.old-th-1').addClass('old-th-1');
		$('.old-th-2').addClass('old-th-2');
		$('.old-th-3').addClass('old-th-3');
		$('.old-th-1').removeClass('old-th-1');
		$('.old-th-2').removeClass('old-th-2');
		$('.old-th-3').removeClass('old-th-3');
	}
	caculateWidth();
}
/**
 * enable apply button
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   N/A
 * @access      :   public
 * @see         :
 */
function enableApplyButton(element) {
	let has_value = 0;
	$('.select_apply_bar').each(function () {
		if (element.val() != '') {
			has_value = 1
		}
	})
	$('.search_apply_bar').each(function () {
		if (element.parents('.div_employee_cd').find('.employee_cd_hidden').val() != '') {
			has_value = 1
		}
	})
	if (has_value == 1) {
		$('#bulk_change').removeClass('disabled');
		$('#bulk_change').attr('tabindex', '11');
	} else {
		$('#bulk_change').addClass('disabled');
		$('#bulk_change').attr('tabindex', '-1');
	}
}
/**
 * Get all setting pairs in table detail
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @return      :   object
 * @access      :   public
 * @see         :
 */
function getDataPairs() {
	var list = [];
	let row_index = 1;
	$(".list_pair").each(function () {
		_this = $(this);
		if (_this.find(".ck_item").is(":checked")) {
			_this.find(".pair_each").each(function () {
				var td = $(this).closest('td');
				var next_td = td.next();
				list.push({
					employee_cd: $(this).attr("employee_cd"),
					coach_cd: $(this).val(),
					interview_cd: next_td.find('.interview_cd').val(),
					times: $(this).attr("time"),
					start_date: $(this).attr("start_date"),
					row_index: row_index
				});
			});

		}
		row_index++;
	});
	return list;
}
/**
 * append message no data to table
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   object
 * @access      :   public
 * @see         :
 */
function blankData() {
	$('#table__result').hide();
}
/**
 * recaculate width for 2 button (属性情報非表示,最新を適用)
 *
 * @author      :   DatNT - 2020/09/18 - create
 * @author      :
 * @return      :   object
 * @access      :   public
 * @see         :
 */
function caculateWidth() {
	let th1_width = $('.th-1-width').outerWidth();
	let th2_width = $('.th-2-width').outerWidth();
	let th3_width = $('.th-3-width').outerWidth();
	let header_width = th2_width + th3_width + th1_width - 50
	$('.header-button').attr('style', 'width: ' + header_width + 'px !important;min-width: ' + header_width + 'px !important;max-width: ' + header_width + 'px !important');
	$('.btn-bulk-change').attr('style', 'width: 100px !important;min-width: 100px !important;max-width: 100px !important');
}
/**
 * bulk all data 
 *
 * @author      :   viettd - 2021/04/23 - create
 * @param      	:	null
 * @return      :   void
 */
function bulkUpdate(times = 0)
{
	try{
		$("#table-data2 tbody tr").each(function () {
			if ($(this).find(".ck_item").is(":checked")) {
				for (let index = 1; index <= times; index++) {
					// apply coach
					if ($(".hidden_search_" + index).val() != '') {
						$(this).find('.coach_cd_' + index).val($(".hidden_search_" + index).val())
						$(this).find(".hidden_val_search_" + index).val($(".hidden_search_" + index).val());
						$(this).find(".val_search_" + index).val($(".search_" + index).val());
						$(this).find(".val_search_" + index).attr('old_employee_nm', $(".search_" + index).val());
					}
					// apply sheet
					if ($(".select_" + index).val() != '-1') {
						$(this).find(".val_select_" + index).val($(".select_" + index).val());
						$(this).find('.coach_cd_' + index).attr('interview_cd', $(".select_" + index).val())
					}
				}
			}
		});
	}catch(e){
		alert('bulkUpdate : '+e.message);
	}
}