$(document).ready(function () {
	try {
		_formatTooltip();
		initEvents();
		// initialize();
	} catch (e) {
		alert('ready' + e.message);
	}
});
/**
 * initEvents
 *
 * @author		:	viettd - 2020/12/10 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		$(document).on('click', 'li a.page-link:not(.pagging-disable)', function (e) {
			var li = $(this).closest('li'),
				page = li.find('a').attr('page');
			$('.pagination li').removeClass('active');
			li.addClass('active');
			var cb_page = $('#cb_page').find('option:selected').val();
			var cb_page = cb_page == '' ? 1 : cb_page;
			search(page, cb_page);
		});
		$(document).on('change', '#cb_page', function (e) {
			var li = $('.pagination li.active'),
				page = li.find('a').attr('page');
			var cb_page = $(this).val();
			var cb_page = cb_page == '' ? 20 : cb_page;
			search(page, cb_page);
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}

/**
 *  Search data
 * 
 * @param {Int} page 
 * @param {Int} page_size 
 */
function search(page = 1, page_size = 20) {
	var obj = {};
	obj.fiscal_year = $('#popup_fiscal_year').val();
	obj.employee_cd = $('#popup_employee_cd').val();
	obj.report_kind = $('#popup_report_kind').val();
	obj.report_no = $('#popup_report_no').val();
	obj.page = page;
	obj.page_size = page_size;
	$.ajax({
		type: 'POST',
		url: '/common/popup/viewer',
		dataType: 'html',
		loading: true,
		data: obj,
		success: function (res) {
			$('#result').empty();
			$('#result').html(res);
			$('[data-toggle="tooltip"]').tooltip();
			_formatTooltip();
		}
	});
}
