/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package			:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version			:	1.0.0
 * ****************************************************************************
 */

var _obj = {
	'authority_cd': { 'type': 'text', 'attr': 'id' },
	'tr_employee': {
		'attr': 'list', 'item': {
			'tb_employee_cd': { 'type': 'text', 'attr': 'class' },
		}
	}
};

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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
	try {
		initCss();
		tableContent();
		$('.employee_cd').focus();
		_formatTooltip();
		jQuery.initTabindex();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		// 
		$(document).on('click', '.pagination li a.page-link:not(.pagging-disable)', function (e) {
			//alert(1);
			e.preventDefault();
			var li = $(this).closest('li'),
				page = li.find('a').attr('page');
			$('.pagination li').removeClass('active');
			li.addClass('active');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
			search(page, cb_page);

		});
		// 
		$(document).on('click', '#btn-save', function (e) {
			try {
				var countChecked = 0;
				countChecked = $(".chk-item:checked").length;
				//debugger;
				jMessage(1, function (r) {
					if (r && _validate($('body'))) {
						if (countChecked >= 1) {
							saveData();
						} else {
							jMessage(18, function (r) {
							});
						}
					}
				});
			} catch (e) {
				alert('#btn-save' + e.message);
			}
		});
		// 
		$(document).on('click', '#btn-search', function (e) {
			var page = 1;
			var page_size = 20;
			search(page, page_size);
		});
		// 
		$(document).on('click', '#btn-delete', function (e) {
			try {
				countChecked = $(".chk-item:checked").length;
				jMessage(3, function (r) {
					if (r) {
						if (countChecked >= 1) {
							deleteData();
						} else {
							jMessage(18, function (r) {
							});
						}
					}
				});
			} catch (e) {
				alert('#btn-delete' + e.message);
			}
		});
		// 
		$(document).on('click', '#btn-back', function (e) {
			try {
				// window.location.href = '/dashboard'
				if (_validateDomain(window.location)) {
					window.location.href = '/basicsetting/sdashboard';
				} else {
					jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
				}
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
		// 
		$(document).on('change', '#cb_page', function (e) {
			var li = $('.pagination li.active'),
				page = li.find('a').attr('page');
			var cb_page = $(this).val();
			var cb_page = cb_page == '' ? 20 : cb_page;
			search(page, cb_page);
		});
		// 
		$(document).on('change', '#check-all', function () {
			try {
				var checked = $(this).is(':checked');
				if (checked) {
					$('.chk-item:enabled').prop('checked', true);
				}
				else {
					$('.chk-item:enabled').prop('checked', false);
				}
			} catch (e) {
				alert('.ck-all : ' + e.message);
			}
		});
		// check item
		$(document).on('change', '.chk-item', function () {
			try {
				var checked = $('.chk-item:checked').length;
				var all = $('.chk-item').length;
				if (checked == all) {
					$('#check-all').prop('checked', true);
				}
				else {
					$('#check-all').prop('checked', false);
				}
			} catch (e) {
				alert('.ck-all : ' + e.message);
			}
		});
		// 
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
	$(document).on('click', '#btn-show', function (e) {
		var text_display = $('.display_attr').val();
		var text_hide    = $('.hide_attr').val();

		if (!$(this).hasClass('clicked')) {
			$('.hid-col').addClass('hidden');
			$(this).addClass('clicked');
			// $(this).find('#btn_text').text('属性情報表示');
			$(this).find('#btn_text').text(text_display);
			$(this).find('.fa').removeClass('fa-eye-slash');
			$(this).find('.fa').addClass('fa-eye');
			hide_show_table('invi', 0);
			$("table thead th:eq(0)").addClass('vnHide');

			$("table thead th:last").removeClass('w-120px');
			$("table thead th:eq(7)").removeClass('w-120px');
			$("table thead th:eq(8)").removeClass('w-120px');
			$("table thead th:eq(9)").removeClass('w-120px');
			$("table thead th:eq(7)").addClass('w-260px');
			$("table thead th:eq(8)").addClass('w-260px');
			$("table thead th:eq(9)").addClass('w-260px');

			$("table tbody tr td:eq(7)").removeClass('w-120px');
			$("table tbody tr td:eq(8)").removeClass('w-120px');
			$("table tbody tr td:eq(9)").removeClass('w-120px');
			$("table tbody tr td:eq(10)").removeClass('w-120px');
			$("table tbody tr td:eq(7)").addClass('w-260px');
			$("table tbody tr td:eq(8)").addClass('w-260px');
			$("table tbody tr td:eq(9)").addClass('w-260px');
			$("table tbody tr td:eq(10)").addClass('w-260px');

			$("table tbody tr").each(function () {
				$(this).find('td:eq(7) div:first').removeClass('w-120px');
				$(this).find('td:eq(7) div:first').addClass('w-240px');
				$(this).find('td:eq(8) div:first').removeClass('w-120px');
				$(this).find('td:eq(8) div:first').addClass('w-240px');
				$(this).find('td:eq(9) div:first').removeClass('w-120px');
				$(this).find('td:eq(9) div:first').addClass('w-240px');
				$(this).find('td:eq(10) div:first').removeClass('w-120px');
				$(this).find('td:eq(10) div:first').addClass('w-240px');
			});

		} else {
			$(this).removeClass('clicked');
			$("table thead th:eq(7)").removeClass('w-260px');
			$("table thead th:eq(8)").removeClass('w-260px');
			$("table thead th:eq(9)").removeClass('w-260px');
			$("table thead th:last").addClass('w-120px');
			$("table thead th:eq(7)").addClass('w-120px');
			$("table thead th:eq(8)").addClass('w-120px');
			$("table thead th:eq(9)").addClass('w-120px');

			$("table tbody tr td:eq(7)").removeClass('w-260px');
			$("table tbody tr td:eq(8)").removeClass('w-260px');
			$("table tbody tr td:eq(9)").removeClass('w-260px');
			$("table tbody tr td:eq(10)").removeClass('w-260px');
			$("table tbody tr td:eq(7)").addClass('w-120px');
			$("table tbody tr td:eq(8)").addClass('w-120px');
			$("table tbody tr td:eq(9)").addClass('w-120px');
			$("table tbody tr td:eq(10)").addClass('w-120px');

			$("table tbody tr").each(function () {
				$(this).find('td:eq(7) div:first').addClass('w-120px');
				$(this).find('td:eq(7) div:first').removeClass('w-240px');
				$(this).find('td:eq(8) div:first').addClass('w-120px');
				$(this).find('td:eq(8) div:first').removeClass('w-240px');
				$(this).find('td:eq(9) div:first').addClass('w-120px');
				$(this).find('td:eq(9) div:first').removeClass('w-240px');
				$(this).find('td:eq(10) div:first').removeClass('w-120px');
				$(this).find('td:eq(10) div:first').addClass('w-240px');
			});
			$('.hid-col').removeClass('hidden');
			// $(this).find('#btn_text').text('属性情報非表示');
			$(this).find('#btn_text').text(text_hide);
			$(this).find('.fa').addClass('fa-eye-slash');
			$(this).find('.fa').removeClass('fa-eye');
			hide_show_table('invi', 1);
			$("table thead th:eq(0)").removeClass('vnHide');
			$("table thead th:eq(7)").addClass('w-160px');
			$("table tbody tr td div").not('.ellipsis').css("display", "block");
		}
		_formatTooltip();
		$(".w-140px").removeClass('.w-140px');
		//search(1,20);
		fixWidth();
	});
}

/**
 * search
 *
 * @author  :   tuantv - 2018/08/24 - create
 * @author  :
 *
 */
function search(page, page_size) {
	// send data to post
	//debugger;
	var count_th = $("#myTable thead tr .vnHide").length;
	if (typeof page == 'undefined') {
		var page = 1;
	}
	if (typeof page_size == 'undefined') {
		var page_size = 20;
	}
	var authority_cd = $('#authority_cd').val();
	var organization_cd1 = $('#organization_step1').val();
	var organization_cd2 = $('#organization_step2').val();
	var organization_cd3 = $('#organization_step3').val();
	var organization_cd4 = $('#organization_step4').val();
	var organization_cd5 = $('#organization_step5').val();
	var obj = {};
	obj.page = page;
	obj.page_size = page_size;
	obj.employee_cd = $('#employee_cd').val();
	obj.employee_nm = $('#employee_name').val();
	obj.organization_cd1 = organization_cd1;
	obj.organization_cd2 = organization_cd2;
	obj.organization_cd3 = organization_cd3;
	obj.organization_cd4 = organization_cd4;
	obj.organization_cd5 = organization_cd5;
	obj.position_cd = $('#position_cd').val();
	obj.check_authority = ($("#check_authority").is(':checked')) ? 1 : 0;
	obj.authority_cd = (authority_cd == '-1') ? 0 : authority_cd;
	obj.employee_typ = $('#employee_typ').val();
	/*	console.log(obj);
		debugger;*/
	$.ajax({
		type: 'POST',
		url: '/master/s0030/search',
		dataType: 'html',
		loading: true,
		data: { 'data': obj },
		success: function (res) {
			var btnText = $("#btn-show i").hasClass('fa-eye-slash');
			var text_display = $('.display_attr').val();
		    var text_hide    = $('.hide_attr').val();
			$('#result').empty();
			$('#result').html(res);
			$("#employee_cd").focus();
			initCss();
			$(".setTooltip").tooltip();
			if (btnText) {
				$('.hid-col').removeClass('hidden');
				$("#btn-show").removeClass('clicked');
				//
				//hide_show_table('invi',1);
				$("table thead th:eq(7)").addClass('w-160px');
				$("table tbody tr td div").not('.ellipsis').css("display", "block");

				$("#btn-show").find('#btn_text').text(text_hide);
				$("#btn-show").find('.fa').addClass('fa-eye-slash');
				$("#btn-show").find('.fa').removeClass('fa-eye');
			} else { //hiện các cột

				$('.hid-col').addClass('hidden');
				$("#btn-show").addClass('clicked');

				$("#btn-show").find('#btn_text').text(text_display);
				$("#btn-show").find('.fa').removeClass('fa-eye-slash');
				$("#btn-show").find('.fa').addClass('fa-eye');
			}
			$(".w-140px").removeClass('.w-140px');

			//alert(count_th);
			if (count_th == 0) {
				$("#btn-show i").removeClass("fa fa-eye-slash fa-eye");
				$("#btn-show i").addClass("fa fa-eye-slash");
				hide_show_table('invi', 1); //show
				$("#btn-show").removeClass("clicked");
				$("table thead th:eq(0)").removeClass("vnHide");
				$("#btn_text").text(text_hide);
			} else {
				$("#btn-show i").removeClass("fa fa-eye-slash fa-eye");
				$("#btn-show i").addClass("fa fa-eye");
				hide_show_table('invi', 0); //hide
				$("#btn-show").removeClass("clicked");
				$("#btn-show").addClass("clicked");
				$("table thead th:eq(0)").removeClass("vnHide");
				$("table thead th:eq(0)").addClass('vnHide');
				$("#btn_text").text(text_display);
			}
			app.jTableFixedHeader();
			tableContent();
			_formatTooltip();
			jQuery.initTabindex();
		},
		error: function (xhr) {
			console.log(xhr)
		}
	});
}

function hide_show_table(col_name, check) {
	if (check == 0) {
		var all_col = document.getElementsByClassName(col_name);
		var all_th = document.getElementsByClassName(col_name + "_head");
		//$("."+col_name+"_head").hasClass("hide");
		//var all_th=document.getElementsByClassName("hide");
		for (var i = 0; i < all_col.length; i++) {
			all_col[i].style.display = "none";
		}
		for (var i = 0; i < all_th.length; i++) {
			all_th[i].style.display = "none";
		}
		document.getElementsByClassName(col_name).value = "show";
	}
	else {
		var all_col = document.getElementsByClassName(col_name);
		var all_th = document.getElementsByClassName(col_name + "_head");
		//$("."+col_name+"_head").hasClass("show");
		for (var i = 0; i < all_col.length; i++) {
			all_col[i].style.display = "table-cell";
		}
		for (var i = 0; i < all_th.length; i++) {
			all_th[i].style.display = "table-cell";
		}
		document.getElementsByClassName(col_name).value = "hide";
	}
}

/**
 * save
 *
 * @author      :   tuantv - 2018/08/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var data = {};
		var list = [];
		data.authority_cd = $('#authority_cd').val();
		$("#myTable tbody tr").each(function () {
			var tr = $(this);
			if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
				list.push({
					'row_index':tr.find('td:eq(0) input[type=checkbox]').attr('id')
				,	'tb_employee_cd' : tr.find('.tb_employee_cd').val()
				});
			}
		});
		data.tr_employee = list;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/s0030/save',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function (r) {
							var page = $('.page-item.active').attr('page');
                			var page_size = $('#cb_page').val();
							search(page, page_size);
							// search(1, 20);
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
							processError(res['errors']);
						}
						break;
					// Exceptionm
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}
			}
		});
	} catch (e) {
		alert('saveData' + e.message);
	}
}

/**
 * delete data
 *
 * @author      :   tuantv - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */

function deleteData() {
	try {
		var num = $("#result li.active a:first").text();
		var data = {};
		var list = [];
		data.authority_cd = $('#authority_cd').val();
		$("#myTable tbody tr").each(function () {
			var tr = $(this);
			if (tr.find('td:eq(0) input[type=checkbox]').prop('checked')) {
				list.push({
					'row_index':tr.find('td:eq(0) input[type=checkbox]').attr('id')
				,	'tb_employee_cd' : tr.find('.tb_employee_cd').val()
				});
			}
		});
		data.tr_employee = list;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/master/s0030/delete',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						//
						jMessage(4, function (r) {
                			var page_size = $('#cb_page').val();
							search(num, page_size);
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
							processError(res['errors']);
						}
						break;
					// Exceptionm
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}
			}
		});
	} catch (e) {
		alert('deleteData' + e.message);
	}
}

function initCss() {
	var text_hide    = $('.hide_attr').val();
	var strHtml = '<div class="row" style="margin-left:0px;width:100%>' + '<div class="btn-group">' +
		'<button id="btn-show" class="mb-1 btn btn-outline-primary btn-sm" tabindex=8>' +
		'<i class="fa fa-eye-slash"></i>' +
		'<span id="btn_text">'+text_hide+'</span>' +
		'</button>' +
		'</div>' +
		'</div>';
	$("#result nav:first").before(strHtml);
}

/**
 * table Content
 *
 * @author      :  tuantv - 2018/11/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
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

}
function fixWidth() {
	var w = $('.wmd-view .table').outerWidth();
	var f = $('.table-group li:last').outerWidth();
	$(".wmd-view-topscroll .scroll-div1").width(w);
	// $(".table-group li:last .fixed").width(f);
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