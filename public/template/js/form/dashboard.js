/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	tannq – tannq@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {};
$(document).ready(function () {
	try {
		initEvents();
		_formatTooltip();
	} catch (e) {
		alert('ready' + e.message);
	}
});

/*
 * INIT EVENTS
 * @author		:	tannq - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	document.addEventListener('keydown', function (e) {
		if (e.keyCode === 9) {
			if (e.shiftKey) {
				if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
					e.preventDefault();
					if ($('.p-title-btn a:not([readonly],[disabled],:hidden)').last().length != 0) {
						$('.p-title-btn a:not([readonly],[disabled],:hidden)').last()[0].focus();
					}
					return;
				}
			} else {
				if ($(':focus')[0] === $('.p-title-btn a:not([readonly],[disabled],:hidden)').last()[0]) {
					e.preventDefault();
					$(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
				}
			}
		}
	});
	$(document).on('click', '.refer_screen', function (e) {
		e.preventDefault();
		var obj = {};
		obj.employee_cd_refer = $(this).attr('employee_cd');
		obj.status_cd = $('#action_value').attr('status_cd');
		obj.sheet_cd = $('#select_sheet_cd').val();
		obj.screen_id = 'dashboard';
		obj.select_period = $('#select_period').val();
		obj.fiscal_year = $('#fiscal_year').val();
		obj.select_category_typ = $('#select_category_typ').val();
		setCache(obj, $(this).find('a').attr('href'));
	});
	$(document).on('click', '.refer_status', function (e) {
		e.preventDefault();
		var obj = {};
		obj.fiscal_year = $('#fiscal_year').val();
		obj.employee_cd = $(this).attr('employee_cd');
		obj.sheet_cd = $(this).attr('sheet_cd');
		//
		obj.status_cd = $('#action_value').attr('status_cd');
		obj.select_period = $('#select_period').val();
		obj.select_category_typ = $('#select_category_typ').val();
		obj.from = 'dashboard';
		obj.save_cache = 'true';
		//
		var sheet_kbn = $(this).attr('sheet_kbn');
		if (sheet_kbn == '1') {
			obj.screen_id = 'dashboard_i2010';
			_redirectScreen('/master/i2010', obj,true);
		} else {
			obj.screen_id = 'dashboard_i2020';
			_redirectScreen('/master/i2020', obj,true);
		}
	});
	// list_infomation
	$(document).on('click', '.list_infomation', function () {
		try {
			var data = {
				'company_cd': $(this).attr('company_cd')
				, 'category': $(this).attr('category')
				, 'status_cd': $(this).attr('status_cd')
				, 'infomationn_typ': $(this).attr('infomationn_typ')
				, 'infomation_date': $(this).attr('infomation_date')
				, 'target_employee_cd': $(this).attr('target_employee_cd')
				, 'sheet_cd': $(this).attr('sheet_cd')
				, 'employee_cd': $(this).attr('employee_cd')
				, 'fiscal_year': $(this).attr('fiscal_year')
			};
			showPopup("/common/popup/getinformation?" + setGetPrams(data), {}, function () {
			});
		} catch (e) {
			alert('.list_infomation' + e.message);
		}
	});
	//
	$(document).on('change', '#select_period,#fiscal_year,#select_category_typ,#organization_cd', function () {
		try {
			var select_period = $('#select_period').val();
			var fiscal_year = $('#fiscal_year').val();
			var select_category_typ = $('#select_category_typ').val();
			var organization_cd ={};
			var list_organization_step1 = [];
			list_organization_step1.push({
					organization_cd_1: $('#organization_cd').val(),
					organization_cd_2: '',
					organization_cd_3: '',
					organization_cd_4: '',
					organization_cd_5: '',
				});
			organization_cd.list_organization_step1 = list_organization_step1;
			referstatus(select_period, select_category_typ, fiscal_year,JSON.stringify(organization_cd));
		} catch (e) {
			alert('#select_sheet_cd' + e.message);
		}
	});
	$(document).on('click', '.list-group-item', function (event) {
		$(this).find('.dropdown-menu').addClass('show');
		var menuHeight = $(this).find('.dropdown-menu').outerHeight(true);
		var winHeight = $(this).find('.dropdown-menu').outerHeight(true);
		var obTop = $(this).offset().top;
		var obLeft = $(this).offset().left;
		var y = event.pageY - obTop;
		var x = event.pageX - obLeft;

		if (event.pageY - obTop + menuHeight > $(window).outerHeight(true)) {
			y = $(window).outerHeight(true) - menuHeight;
		}
		$(this).find('.dropdown-menu').css({
			top: y - 10,
			left: x + 30,
		})
	});
	$(document).on('mouseout', '.list-group-item', function (event) {
		$(this).find('.dropdown-menu').removeClass('show');
	});
	$(document).on('click', '.step-bar', function () {
		try {
			var organization_cd ={};
			var list_organization_step1 = [];
			list_organization_step1.push({
					organization_cd_1: $('#organization_cd').val(),
					organization_cd_2: '',
					organization_cd_3: '',
					organization_cd_4: '',
					organization_cd_5: '',
				});
			organization_cd.list_organization_step1 = list_organization_step1;
			var data = {
				'status_cd': $(this).attr('status_cd'),
				'select_period': $('#select_period').val(),
				'select_category_typ': $('#select_category_typ').val(),
				'fiscal_year': $('#fiscal_year').val(),
				'organization_cd':JSON.stringify(organization_cd)
			};
			referemployee(data);
		} catch (e) {
			alert('#select_sheet_cd' + e.message);
		}
	});
	//vietdt -2022/08/16
	$(document).on('change', '#authority_typ', function () {
		try {
			updateauthority($(this).val());
		} catch (e) {
			alert('#authority_typ' + e.message);
		}
	});
}
function chart() {
	// Create the chart
	Highcharts.chart('chart', {
		chart: {
			type: 'pie'
		},
		title: {
			text: ''
		},
		subtitle: {
			text: ''
		},
		plotOptions: {
			series: {
				dataLabels: {
					enabled: false,
					format: '{point.name}: {point.y:.1f}%'
				}
			}
		},
		plotShadow: true,
		tooltip: {
			headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
			pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
		},

		"series": [
			{
				"name": "Browsers",
				"colorByPoint": true,
				"data": [
					{
						"name": "Chrome",
						"y": 11.111,
						"drilldown": "Chrome",
						color: "#42A5F6",
					},
					{
						"name": "Firefox",
						"y": 11.111,
						"drilldown": "Firefox",
						color: "#25C6DA"
					},
					{
						"name": "Internet Explorer",
						"y": 11.111,
						"drilldown": "Internet Explorer",
						color: "#25A79B",
					},
					{
						"name": "Safari",
						"y": 11.111,
						"drilldown": "Safari",
						color: "#D4E259",
					},
					{
						"name": "Edge",
						"y": 11.111,
						"drilldown": "Edge",
						color: "#FECA26",
					},
					{
						"name": "Opera",
						"y": 11.111,
						"drilldown": "Opera",
						color: "#FFA827",
					},
					{
						"name": "Other",
						"y": 11.111,
						"drilldown": null,
						color: "#FE6F45",
					},
					{
						"name": "Other2",
						"y": 11.111,
						"drilldown": 'Other2',
						color: "#ED3F7A",
					}
				]
			}
		],
	});
}
/**
 * refer
 *
 * @author      :   longvv
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referstatus(select_period, select_category_typ, fiscal_year,organization_cd) {
	try {
		$.ajax({
			type: 'post',
			url: '/dashboard/liststatus',
			dataType: 'html',
			data: {
				'select_period': select_period
				, 'select_category_typ': select_category_typ
				, 'fiscal_year': fiscal_year
				, 'organization_cd': organization_cd
			},
			loading: true,
			success: function (res) {
				$('#result_liststatus').empty();
				$('#result_liststatus').html(res);
				$('#result_listemployee').empty();
				$('.tooltip').remove();
				_formatTooltip();
			}
		});
	} catch (e) {
		alert('referstatus: ' + e.message);
	}
}
/**
 * refer
 *
 * @author      :   longvv
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referemployee(data) {
	try {
		$.ajax({
			type: 'post',
			url: '/dashboard/listemployee',
			dataType: 'html',
			data: data,
			loading: true,
			success: function (res) {
				$('#result_listemployee').empty();
				$('#result_listemployee').html(res);
				// $('.tooltip').remove();
				  _formatTooltip();
			}
		});
	} catch (e) {
		alert('referemployee:' + e.message);
	}
}
/**
 * updateauthority
 *
 * @author      :   vietdt -2022/08/16
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function updateauthority(authority_typ) {
	try {
		$.ajax({
			type: 'post',
			data: {
				authority_typ :authority_typ
			},
			url: '/dashboard/updateauthority',
			loading: true,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						location.reload()
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
	} catch (e) {
		alert('updateauthority:' + e.message);
	}
}

