/**
 * ****************************************************************************
 * ANS ASIA
 * MIRAI COMMON.JS
 *
 * 処理概要		:	mirai common.js
 * 作成日		:	2018/07/10
 * 作成者		:	viettd – viettd@ans-asia.com
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : add function _customerUrl 
 *
 * @package		:	MODULE NAME
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var OK = 200;		// OK
var NG = 201;		// Not good
var EX = 202;		// Exception
var EPT = 203;		// Empty
var PE = 999;		// Not permission
var DELIMITER = '|#|@';	// delimiter
var _isIE = false;
jQuery.ajaxSetup({
	headers: {
		'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
	},

	beforeSend: function () {
		// window.addEventListener("keydown", preventKeydown, false);
		var loading = getParameterByName('loading', this.url);
		// console.log(this.loading);
		if (this.loading) {
			$('.div_loading').show();
		}
	},
	complete: function (res) {
		// _setTabIndex()
		// window.removeEventListener("keydown", preventKeydown, false);
		if ($('.navbar-act .nav-item.active').length > 0) {
			$('.navbar-act .nav-item.active').removeClass('active');
		}
		$('[data-toggle="tooltip"]').tooltip();
		if (this.loading) {
			$('.div_loading').hide();
		}
		// add by viettd 2016/06/24
		if (res['responseText'] == 'セッションタイムアウトが発生しました。再度ログインしてください') {
			// add by viettd 2016/11/10
			if (_validateDomain(window.location)) {
				window.location.href = '/login';
			} else {
				jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
			}
		}
		// end add by viettd 2016/06/24
		if (typeof res.status !== undefined && res.status == 403) {
			jError('エラー', "アクセスが拒否されました。アクセスする権限がありません。");
			return;
		}
	},
	statusCode: {
		500: function () {
			jMessage(22);
		},
		501: function () {
			jMessage(22);
		},
		406: function () {
			jMessage(164);
		},
		400: function () {
			jMessage(9);
		}
	}
});

$(document).ready(function () {
	try {
		init();
		$.formatInput();
		_formatTooltip();
		_autoNumeric();
		var window_width = window.outerWidth;
		if (window_width < 600) {
			$('th').removeClass('sticky-cell');
		}
	} catch (e) {
		alert('ready' + e.message);
	}
});
/**
 * initialize
 *
 * @author : viettd - 2015/09/15 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function init() {
	try {
		$(window).resize(function () {
			unFixedWhenSmallScreen();
		});
		initDropdownRemark();
		$(document).on('focus', '.cb_focus', function () {
			$(this).parents('.md-checkbox-v2').find('.checkmark').addClass('cb_onfocus');
		})
		$(document).on('blur', '.cb_focus', function () {
			$(this).parents('.md-checkbox-v2').find('.checkmark').removeClass('cb_onfocus');
		})
		$(document).on('keydown', '.cb_focus', function (e) {
			if (e.key == 13 || e.key == 'Enter') {
				$('.cb_onfocus').trigger('click');
			}
		})
		//////////////////////////////////////////////////////////////////////////////////////////
		$(document).on('click', '.logout', function () {
			var iframe = $('<iframe style="visibility: collapse;display: none;"></iframe>');
			$('body').append(iframe);
			var content = iframe[0].contentDocument;
			var form = '<form action="https://app.secure.freee.co.jp/developers/sign_out" method="GET"></form>';
			content.write(form);
			$('form', content).submit();
			setTimeout((function (iframe) {
				return function () {
					iframe.remove();
				}
			})(iframe), 2000);
		});
		// _setTabIndex();
		//////////////////// left + right content ////////////////////
		var heneed = $('.calHe').innerHeight();
		var hetru = $('.calHe2').innerHeight();
		var heit = heneed - hetru - 70;
		var heme = $('.list-search-content').innerHeight();
		// $('.list-search-content').attr('style','height: '+ heit +'px');
		// if(heme>heit){
		// 	$('.list-search-content').addClass('scroll');
		// }
		// $('.calHe2').parent().parent().parent().addClass('marb50');
		//////////////////// SHOW LOADING ////////////////////

		$('.tooltip').remove();
		// Tool-tip
		$('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
		//
		$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
			checkTabError();
		});
		//マイナス
		$('input[negative="true"]').each(function (i) {
			var maxlength = $(this).attr('maxlength');
			$(this).attr('constant_maxlength', maxlength);
		});
		//
		if ($('.box-input-search .hide-box-input-search').length < 1) {
			$('.box-input-search').append('<a href="javascript:;" onmouseover="boxSearchAdd()" onmouseout="boxSearchRemove()" class="hide-box-input-search" tabindex="-1"><i class="fa fa-caret-up" aria-hidden="true"></i></a>');
		}
		$(document).on('click', '.hide-box-input-search', function () {
			$('.box-input-search').toggleClass('hide');
			$(this).children('i').toggleClass('fa-caret-down');
		});
		$(document).on('click', '.list-search-child', function () {
			$('.list-search-child').removeClass('active');
			$(this).addClass('active');
		});
		$(document).on('click', '.nav-item-common', function () {
			$(this).find('i').toggleClass('fa-chevron-right')
			$(this).find('i').toggleClass('fa-chevron-down')
		});
		$(document).on('click', '.button-menu-common', function () {
			try {
				if ($('.button-menu-common').hasClass('backgimage')) {
					var imageUrl = "url('/uploads/ver1.7/icon/Capture.png')";
					$('.button-menu-common').removeClass('backgimage');
					$('.button-menu-common .navbar-toggler-icon').css('background-size', '27px');
					$('.button-menu-common .navbar-toggler-icon').css('background-image', imageUrl);
				}
				else {
					var imageUrl = "url('/uploads/ver1.7/icon/close.png')";
					$('.button-menu-common').addClass('backgimage');
					$('.backgimage .navbar-toggler-icon').css('background-image', imageUrl);
				}
			} catch (e) {
				alert('btn-add-new: ' + e.message);
			}
		});

		//nghia add
		$(document).on('click', '.button-card', function () {
			//add vietdt 2022/08/18 v1.9
			var language = $('#language_jmessages').val();
			var chevron_right = '表示する';
			var chevron_down = '非表示にする';
			if (language == 'en') {
				chevron_right = 'Show';
				chevron_down = 'Set to Private';
			}
			$(this).closest('.card').toggleClass('hide-card-common');
			$(this).find('i').toggleClass('fa-chevron-right');
			$(this).find('i').toggleClass('fa-chevron-down');
			if ($(this).find('i').hasClass('fa-chevron-right')) {
				$('.group-search-condition').addClass('hidden');
				$(this).parents('.card').find(':input').not(':input[type=button]').addClass('hidden')
				$(this).parents('.card').find('.multiselect').addClass('hidden')
				$(this).parents('.card').find('#btn_search').addClass('hidden')
				$(this).html('<span><i class="fa fa-chevron-right"></i></span> ' + chevron_right);
			}
			else {
				$('.group-search-condition').removeClass('hidden');
				$(this).parents('.card').find(':input').removeClass('hidden')
				$(this).parents('.card').find('.multiselect').removeClass('hidden')
				$(this).parents('.card').find('#btn_search').removeClass('hidden')
				$(this).html('<span><i class="fa fa-chevron-down"></i></span>  ' + chevron_down);
			}
			$(this).css('border', '1px solid #80808054');
			$(this).css('box-shadow', '0 5px 10px 2px rgba(88, 103, 221, 0.19)');
		});
		$(document).on('click', '.hide-card', function () {
			$(this).closest('.card-body').toggleClass('hide-card-common');
			$(this).find('i').toggleClass('fa-chevron-right');
			$(this).find('i').toggleClass('fa-chevron-down');
		});
		// change upload-file
		$(document).on('change', '.upload-file', function () {
			$(this).parents('.upload').find('.input-path').val($(this).val().replace(/^.*[\\\/]/, ''));
		});
		// closed popup
		$(document).on('click', '#btn-close-popup', function () {
			parent.$('body').css('overflow', 'auto');
			// console.log(parent.$('#1on1_title').val());
			parent.$.colorbox.close();
		});
		//
		if ($('.hide-box-input-search .fa-caret-down').length < 1) {
			$('body').find('.form-control:not([readonly]):not([desabled]):first').focus();
		}
		// button change password
		$(document).on('click', '#btn-change-password', function () {
			try {
				var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if ((width <= 1368) && (width >= 1300)) {
					option.width = '35%';
					option.height = '85%';
				} else {
					if (width <= 1300) {
						option.width = '40%';
						option.height = '80%';
					} else {
						option.width = '480px';
						option.height = '620px';
					}
				}
				// option.changePass = 1;
				showPopup('/common/popup/change_pass', option, function () { });
			} catch (e) {
				alert('#btn-change-password: ' + e.message);
			}
		});
		// button change language
		$(document).on('click', '#btn-change-language', function () {
			try {
				var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if ((width <= 1368) && (width >= 1300)) {
					option.width = '35%';
					option.height = '80%';
				} else if ((width < 1300)) {
					option.width = '35%';
					option.height = '75%';
				} else {
					if (width <= 1000) {
						option.width = '40%';
						option.height = '50%';
					} else {
						option.width = '480px';
						option.height = '500px';
					}
				}
				// option.changePass = 1;
				showPopup('/common/popup/change_language', option, function () { });
			} catch (e) {
				alert('#btn-change-password: ' + e.message);
			}
		});
		$(document).on('click', '.btn-information', function () {
			try {
				showPopup("/common/popup/information/", {}, function () {
				});
			} catch (e) {
				alert('.btn-information: ' + e.message);
			}
		});
		//
		$(document).on('change', '.organization_cd1,.organization_cd2,.organization_cd3,.organization_cd4', function () {
			try {
				var data = {};
				var list = [];
				var param = '';
				if ($(this).hasClass('multiselect')) {
					param = 'multiselect';
					list = [];
					var multi_select_full = $(this).closest('.multi-select-full');
					multi_select_full.find('input[type=checkbox]').each(function () {
						if ($(this).prop('checked')) {
							// list.push({'organization_cd':$(this).val()});
							if ($(this).val() != '') {
								var str = $(this).val().split('|');
								//
								list.push({
									'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
									'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
									'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
									'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
									'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
								});
							}
						}
					});
				} else {
					// list.push({'organization_cd':$(this).val()});
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
				data.list = list;
				data.organization_typ = $(this).attr('organization_typ');
				// add by viettd 2021/01/21
				data.system = 1;
				if (typeof $(this).attr('system') != 'undefined') {
					data.system = $(this).attr('system');
				}
				loadOrganization(data, param, this);
			} catch (e) {
				alert('.organization_cd1 ' + e.message);
			}
		});
		//
		$(document).on('change', '.organization_customer_cd1', function () {
			try {
				var data = {};
				var list = [];
				var param = '';
				if ($(this).hasClass('multiselect')) {
					param = 'multiselect';
					list = [];
					var multi_select_full = $(this).closest('.multi-select-full');
					multi_select_full.find('input[type=checkbox]').each(function () {
						if ($(this).prop('checked')) {
							list.push({ 'organization_cd': $(this).val() });
						}
					});
				} else {
					list.push({ 'organization_cd': $(this).val() });
				}
				data.list = list;
				loadcustomerOrganization(data, param);
			} catch (e) {
				alert('.organization_customer_cd1 ' + e.message);
			}
		});
		// evaluation_typ 評価種類
		$(document).on('change', '.evaluation_typ', function () {
			try {
				var evaluation_typ = $(this).val();
				//if(evaluation_typ > 0){
				loadStatus(evaluation_typ);
				//}
			} catch (e) {
				alert('.evaluation_typ ' + e.message);
			}
		});
		// category_typ カテゴリ
		$(document).on('change', '.category_typ', function () {
			try {
				var category_typ = $(this).val();
				var evaluation_typ = $('.evaluation_typ').val();
				var fiscal_year = $('#fiscal_year').val() != '' ? $('#fiscal_year').val() : 0;
				if (category_typ > 0) {
					loadSheetcd(fiscal_year, category_typ, evaluation_typ);
				}
			} catch (e) {
				alert('.category_typ ' + e.message);
			}
		});
		// fiscal_year
		$(document).on('change', '.fiscal_year', function () {
			try {
				var fiscal_year = $(this).val();
				var from_screen_id = $(this).attr('from_screen_id');
				if (fiscal_year > 0) {
					load_treatment_applications_no(fiscal_year, from_screen_id);
				}
			} catch (e) {
				alert('.fiscal_year change ' + e.message);
			}
		});
		// group_cd_1on1 change
		$(document).on('change', '.group_cd_1on1', function () {
			try {
				var fiscal_year = $('#fiscal_year').val();
				var group_cd = $(this).val();
				if (fiscal_year > 0) {
					load_times_1on1(fiscal_year, group_cd);
				}
			} catch (e) {
				alert('.group_cd_1on1 change ' + e.message);
			}
		});
		// fiscal_year_1on1 change
		$(document).on('change', '.fiscal_year_1on1', function () {
			try {
				var fiscal_year = $(this).val();
				if (fiscal_year > 0) {
					load_group_from_fiscal_year_1on1(fiscal_year);
				}
			} catch (e) {
				alert('.fiscal_year_1on1 change ' + e.message);
			}
		});
		// employee_customer_nm lostfocus
		$(document).on('blur', '.employee_customer_nm', function () {
			try {
				var employee_cd = $(this).closest('span').find('.incharge_cd').val();
				var old_employee_nm = $(this).attr('old_employee_nm');
				var employee_nm = $(this).val();
				if ((employee_cd == '' && old_employee_nm != undefined) || (employee_cd != '' && old_employee_nm != employee_nm && old_employee_nm != undefined)) {
					$(this).val('');
					$(this).closest('.div_employee_customer_cd').find('.incharge_cd').val('');
				}
			} catch (e) {
				alert('.employee_customer_nm' + e.message);
			}
		});
		// employee_nm lostfocus
		$(document).on('blur', '.employee_nm , .employee_nm_1on1 , .employee_nm_mulitireview, .employee_nm_mulitiselect, .employee_nm_weeklyreport', function () {
			try {
				var employee_cd = $(this).closest('span').find('.employee_cd_hidden').val();
				var old_employee_nm = $(this).attr('old_employee_nm');
				var employee_nm = $(this).val();
				var is_callback = $(this).attr('is_callback');
				//
				if (
					(employee_cd == '' && old_employee_nm != undefined)
					|| (employee_cd != '' && old_employee_nm != employee_nm && old_employee_nm != undefined)
				) {
					$(this).val('');
					$(this).closest('.div_parent_employee_nm').prev('.div_parent_employee_cd').find('.employee_cd').val('');
					$(this).closest('span').find('.employee_cd_hidden').val('');
				}
				if (is_callback != undefined && typeof afterBlurEmployeeCd === 'function') {
					afterBlurEmployeeCd($(this));
				}
			} catch (e) {
				alert('.employee_nm , .employee_nm_1on1 , .employee_nm_mulitireview , .employee_nm_mulitiselect, .employee_nm_weeklyreport' + e.message);
			}
		});

		$("body").keydown(function (e) {
			if (e.keyCode == 27) {
				e.preventDefault();
				// $('#btn-back').trigger('click');
				$('#btn-close-popup').trigger('click');
			}
		});
		// input.numeric:enabled,input.only-number:enabled lostfocus
		$(document).on('focusout', 'input.numeric:enabled,input.only-number:enabled', function () {
			try {
				var string = $(this).val();
				string = formatConvertHalfsize(string);
				$(this).val(string);
			} catch (e) {
				alert('input.numeric:enabled,input.only-number:enabled' + e.message);
			}
		});
		//Sort reverse table
		$(document).on('click', '.table_sort th', function () {
			$('.table_sort th span .sort').removeClass('fa-sort-down');
			$('.table_sort th span .sort').removeClass('fa-sort-up');
			$('.table_sort th span .sort').addClass('fa-sort');
			if ($(this).find('.sorted').length == 0) {
				$('.table_sort th span .sort').removeClass('sorted');
				$(this).find('.sort').removeClass('fa-sort');
				$(this).find('.sort').addClass('fa-sort-down');
				$(this).find('.sort').addClass('sorted');
				sort(this);
			} else {
				$(this).find('.sort').removeClass('fa-sort-down');
				$(this).find('.sort').addClass('fa-sort-up');
				$(this).find('.sort').removeClass('sorted');
				reverse(this);
			}

		});
		//change refer_employee_cd
		$(document).on('change', '.refer_employee_cd', function () {
			try {
				refer_employee($(this));
			} catch (e) {
				alert('change employee_cd' + e.message);
			}
		});
		//download-manual (evaluation)
		$(document).on('click', '#download-manual', function () {
			try {
				var option = {};
				option.width = '50%';
				option.height = '50%';
				showPopup('/common/popup/document?module_typ=1', option, function () { });
			} catch (e) {
				alert('click #download-manual' + e.message);
			}
		});
		//download-manual (1on1)
		$(document).on('click', '#download__manual__1on1', function () {
			try {
				var option = {};
				option.width = '50%';
				option.height = '50%';
				showPopup('/common/popup/document?module_typ=2', option, function () { });
			} catch (e) {
				alert('click #download__manual__1on1' + e.message);
			}
		});
		//download-manual (マルチレビュー)
		$(document).on('click', '#download__manual__mulitireview', function () {
			try {
				var option = {};
				option.width = '50%';
				option.height = '50%';
				showPopup('/common/popup/document?module_typ=3', option, function () { });
			} catch (e) {
				alert('click #download__manual__mulitireview' + e.message);
			}
		});
		//longvv fix tooltip 2018/12/24
		$(document).on('mouseover', '.text-overfollow', function () {
			try {
				var x = $(this).offset().left;
				var y = $(this).offset().top + $(this).height();
				$('.bs-tooltip-bottom').css('transform', 'translate3d(' + x + 'px, ' + y + 'px, 0px)');
				$('.bs-tooltip-bottom').css('opacity', '1');
			} catch (e) {
				alert('mouseover .text-overfollow' + e.message);
			}
		});
		//longvv fix tooltip 2018/12/25
		$(document).on('mouseleave ', '.text-overfollow', function () {
			try {
				$('.tooltip').remove();
			} catch (e) {
				alert('mouseover .text-overfollow' + e.message);
			}
		});
		// btn_popup_meeting
		$(document).on('click', '.btn_popup_meeting', function () {
			try {
				var option = {};
				var width = $(window).width();
				var height = $(window).height();
				// if ((width <= 1366 ) && (height <=768)) {
				if (width <= 1368 && width >= 1300) {
					option.width = "35%";
					option.height = "650px";
				} else {
					if (width <= 1300) {
						option.width = "40%";
						option.height = "650px";
					} else {
						option.width = "480px";
						option.height = "650px";
					}
				}
				var div_popup_meeting = $(this).parents('.div_popup_meeting')
				div_popup_meeting.addClass('popup_meeting_choice');
				let fiscal_year = div_popup_meeting.attr('fiscal_year');
				let employee_cd = div_popup_meeting.attr('employee_cd');
				let times = div_popup_meeting.attr('times');
				let from = div_popup_meeting.attr('from');
				$('body').css('overflow', 'hidden');
				showPopup("/common/popup/settingmetting?fiscal_year=" + fiscal_year + '&employee_cd=' + employee_cd + '&times=' + times + '&from=' + from, option, function () { });
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});
		// btn_employee_cd_popup get member from coach
		$(document).on('click', '.btn_employee_cd_popup_1on1', function () {
			try {
				var div = $(this).parents('.div_employee_cd');
				var fiscal_year_1on1 = div.find('.employee_nm_1on1').attr('fiscal_year_1on1');
				if (typeof fiscal_year_1on1 == 'undefined') {
					fiscal_year_1on1 = 0;
				}
				$('body').css('overflow', 'hidden');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/employee_1on1?fiscal_year=" + fiscal_year_1on1, {}, function () {
					div.find('.employee_nm_1on1').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});
		// btn_employee_cd_popup for mulitireview
		$(document).on('click', '.btn_employee_cd_popup_mulitireview', function () {
			try {
				var div = $(this).parents('.div_employee_cd');
				var fiscal_year_mulitireview = div.find('.employee_nm_mulitireview').attr('fiscal_year_mulitireview');
				if (typeof fiscal_year_mulitireview == 'undefined') {
					fiscal_year_mulitireview = 0;
				}
				$('body').css('overflow', 'hidden');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/employee_mulitireview?fiscal_year=" + fiscal_year_mulitireview, {}, function () {
					div.find('.employee_nm_mulitireview').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup_mulitireview' + e.message);
			}
		});
		// btn_employee_cd_popup for weeklyreport
		$(document).on('click', '.btn_employee_cd_popup_weeklyreport', function () {
			try {
				$(this).closest('td').addClass('employee_cd_choice')
				var div = $(this).parents('.div_employee_cd');
				var fiscal_year_weeklyreport = div.find('.employee_nm_weeklyreport').attr('fiscal_year_weeklyreport');
				if (typeof fiscal_year_weeklyreport == 'undefined') {
					fiscal_year_weeklyreport = 0;
				}
				$('body').css('overflow', 'hidden');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/employee_weeklyreport?fiscal_year=" + fiscal_year_weeklyreport, {}, function () {
					div.find('.employee_nm_weeklyreport').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup_weeklyreport' + e.message);
			}
		});
		// btn_employee_cd_popup for employee information
		$(document).on('click', '.btn_employee_cd_popup_employee_information', function () {
			try {
				$(this).closest('td').addClass('employee_cd_choice')
				var div = $(this).parents('.div_employee_cd');
				var fiscal_year_employee_information = div.find('.employee_nm_employee_information').attr('fiscal_year_employee_information');
				if (typeof fiscal_year_employee_information == 'undefined') {
					fiscal_year_employee_information = 0;
				}
				var system = 6;
				if (div.find('.system').length > 0) {
					system = div.find('.system').val();
				}
				$('body').css('overflow', 'hidden');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/employee_employee_information?fiscal_year=" + fiscal_year_employee_information + "&system=" + system, {}, function () {
					div.find('.employee_nm_employee_information').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup_employee_information' + e.message);
			}
		});
		// btn_employee_cd_popup
		$(document).on('click', '.btn_employee_cd_popup', function () {
			try {
				//add vietdt 2022/04/01
				var fiscal_year = $('#fiscal_year').val();
				if (typeof fiscal_year == 'undefined') {
					fiscal_year = 0;
				}
				var _this = $(this).closest('tr');
				var employee_cd = _this.find('.key_emp').val();
				var rater = $(this).attr('rater');
				var rater_position_cd = $(this).closest(".div_employee_cd").find("input:first").data('rater_position_cd');
				var div = $(this).parents('.div_employee_cd');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/employee?employee_cd=" + employee_cd + '&rater=' + rater + '&rater_position_cd=' + rater_position_cd + '&fiscal_year=' + fiscal_year, {}, function () {
					div.find('.employee_nm').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_employee_cd_popup' + e.message);
			}
		});
		// btn_multi_select_employee_popup
		$(document).on('click', '.btn_multi_select_employee_popup', function () {
			try {
				$('.employee_cd_choice').removeClass('employee_cd_choice');
				var div = $(this).parents('.input-group');
				var fiscal_year_mulitiselect = div.find('.employee_nm_mulitiselect').attr('fiscal_year_mulitiselect');
				var mulitiselect_mode = div.find('.employee_nm_mulitiselect').attr('mulitiselect_mode');
				var class_select = $(this).attr('class_select');
				$('body').css('overflow', 'hidden');
				div.addClass('employee_cd_choice');
				showPopup("/common/popup/multiselect_employee?fiscal_year=" + fiscal_year_mulitiselect + "&mulitiselect_mode=" + mulitiselect_mode + "&class_select=" + class_select, {}, function () {
					div.find('.employee_nm_mulitiselect').focus();
					div.find('.employee_cd').trigger('change');
				});
			} catch (e) {
				alert('.btn_multi_select_employee_popup' + e.message);
			}
		});
		// btn_employee_customer_cd_popup
		$(document).on('click', '.btn_employee_customer_cd_popup', function () {
			try {
				var div = $(this).parents('.div_employee_customer_cd');
				div.addClass('employee_customer_cd_choice');
				showPopup("/common/popup/employeecustomer", function () {
					div.find('.employee_customer_nm').focus();
					div.find('.employee_customer_cd').change();
				});
			} catch (e) {
				alert('.btn_employee_customer_cd_popup' + e.message);
			}
		});
		//
		$(document).on('click', '#btn-copy', function (e) {
			var content = "コピー中";
			if ($('#language_jmessages').val() == 'en') {
				var content = "Copying";
			}
			$('.inner').attr('copy-content', content);
			$('.has-copy').attr('copy-content', content);
			$('.copy__area').attr('copy-content', content);
			$('.calHe').attr('copy-content', content);
		});
		// add by viettd 2023/02/06
		$(document).on('click', '.my_purpose_btn', function () {
			try {
				var option = {};
				option.width = '500px';
				option.height = '500px';
				let url = '/common/popup/my_purpose';
				showPopup(url, option, function () {
				});
			} catch (e) {
				alert('.my_purpose_btn' + e.message);
			}
		});
		// change month to get times
		$(document).on('change', '.month_times', function () {
			try {
				let div_month_times = $(this).closest('.div_month_times')
				let div_month_time_s = $(this).closest('.div_month_time_s');
				let report_kind = 0;
				if (div_month_times.find('.r_report_kind').length > 0) {
					report_kind = div_month_times.find('.r_report_kind').val();
				}
				var fiscal_year = 0;
				var month = 1;
				if (div_month_times.find('.r_fiscal_year').length > 0) {
					fiscal_year = div_month_times.find('.r_fiscal_year').val();
				}
				if (div_month_time_s.find('.month_times').length > 0) {
					month = div_month_time_s.find('.month_times').val();
				}
				getTimesContent(fiscal_year, report_kind, month, div_month_time_s);
			} catch (e) {
				alert('.month_times: ' + e.message);
			}
		});
		// change report_kind
		$(document).on('change', '.r_report_kind ', function () {
			try {
				// disbaled all
				$('.month_times').val('-1');
				$('.times').attr('-1');
				$('.month_times').attr('disabled', 'disabled');
				$('.times').attr('disabled', 'disabled');
				let report_kind = $(this).val();
				// when report_kind = 4.month
				if (report_kind == 4) {
					$('.month_times').removeAttr("disabled");
				}
				// when report_kind = 5.times
				if (report_kind == 5) {
					$('.month_times').removeAttr("disabled");
					$('.times').removeAttr("disabled");
				}
				var div_month_times = $(this).closest('.div_month_times');
				var fiscal_year = 0;
				var month = -1;
				if (div_month_times.find('.r_fiscal_year').length > 0) {
					fiscal_year = div_month_times.find('.r_fiscal_year').val();
				}
				if (div_month_times.find('.month_times').length > 0) {
					month = div_month_times.find('.month_times').val();
				}
				var screen = ''
				if (typeof ($(this).attr('screen')) != 'undefined') {
					screen = $(this).attr('screen');
				}
				getMonthsContent(fiscal_year, report_kind, month, screen, div_month_times);
			} catch (e) {
				alert('.r_report_kind: ' + e.message);
			}
		});
		// change month
		$(document).on('change', '.r_fiscal_year', function () {
			try {
				var div_month_times = $(this).closest('.div_month_times');
				var fiscal_year = 0;
				var report_kind = 0;
				var month = -1;
				if (div_month_times.find('.r_report_kind').length > 0) {
					report_kind = div_month_times.find('.r_report_kind').val();
				}
				if (div_month_times.find('.r_fiscal_year').length > 0) {
					fiscal_year = div_month_times.find('.r_fiscal_year').val();
				}
				if (div_month_times.find('.month_times').length > 0) {
					month = div_month_times.find('.month_times').val();
				}
				var screen = ''
				if (typeof ($(this).attr('screen')) != 'undefined') {
					screen = $(this).attr('screen');
				}
				getMonthsContent(fiscal_year, report_kind, month, screen, div_month_times);
			} catch (e) {
				alert('.r_fiscal_year: ' + e.message);
			}
		});
	} catch (e) {
		alert('initialize' + e.message);
	}
}
/////////////////////////////////////////////////////////////////////////////////////
// REFER DATA
/////////////////////////////////////////////////////////////////////////////////////
/**
 * sort
 *
 * @author		:	longvv - 2018/09/17 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function sort(el) {
	var table, rows, switching, i, x, y, shouldSwitch, col_num, myTable, count_th, element_table;
	col_num = $(el).attr('num');
	element_table = $(el).closest('table');
	count_th = element_table.find('thead tr').length;
	myTable = element_table.attr('id');
	table = document.getElementById(myTable);
	switching = true;
	/*Make a loop that will continue until
	no switching has been done:*/
	while (switching) {
		//start by saying: no switching is done:
		switching = false;
		rows = table.getElementsByTagName("TR");
		/*Loop through all table rows (except the
		first, which contains table headers):*/
		for (i = count_th; i < (rows.length - 1); i++) {
			//start by saying there should be no switching:
			shouldSwitch = false;
			/*Get the two elements you want to compare,
			one from current row and one from the next:*/
			var x = $('#' + myTable + ' tr:eq(' + (i + 1) + ') td[num=' + col_num + ']').find('.order_by').val();
			var y = $('#' + myTable + ' tr:eq(' + i + ') td[num=' + col_num + ']').find('.order_by').val();
			if (parseInt(x) == 0 || x == '') {
				x = 99999999;
			}
			if (parseInt(y) == 0 || y == '') {
				y = 99999999;
			}
			//check if the two rows should switch place:
			if (x < y) {
				//if so, mark as a switch and break the loop:
				shouldSwitch = true;
				break;
			}
		}
		if (shouldSwitch) {
			/*If a switch has been marked, make the switch
			and mark that a switch has been done:*/
			rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
			switching = true;
		}
	}
}
/**
 * reverse
 *
 * @author		:	longvv - 2018/09/17 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function reverse(el) {
	var table, rows, switching, i, x, y, shouldSwitch, col_num, myTable, count_th, element_table;
	col_num = $(el).attr('num');
	element_table = $(el).closest('table');
	count_th = element_table.find('thead tr').length;
	myTable = element_table.attr('id');
	table = document.getElementById(myTable);
	switching = true;
	/*Make a loop that will continue until
	no switching has been done:*/
	while (switching) {
		//start by saying: no switching is done:
		switching = false;
		rows = table.getElementsByTagName("TR");
		/*Loop through all table rows (except the
		first, which contains table headers):*/
		for (i = count_th; i < (rows.length - 1); i++) {
			//start by saying there should be no switching:
			shouldSwitch = false;
			var x = $('#' + myTable + ' tr:eq(' + (i + 1) + ') td[num=' + col_num + ']').find('.order_by').val();
			var y = $('#' + myTable + ' tr:eq(' + i + ') td[num=' + col_num + ']').find('.order_by').val();
			//check if the two rows should switch place:
			if (x > y) {
				//if so, mark as a switch and break the loop:
				shouldSwitch = true;
				break;
			}
		}
		if (shouldSwitch) {
			rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
			switching = true;
		}
	}
}
/**
 * refer_employee
 *
 * @author		:	longvv - 2018/20/11 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function refer_employee(element) {
	var employee_cd = element.val();
	$.ajax({
		type: 'post',
		url: '/common/referemployee',
		dataType: 'json',
		loading: true,
		data: { employee_cd: employee_cd },
		async: false,
		success: function (res) {
			var data = res['data'];
			if (data) {
				element.val(data['employee_cd']);
				$('#employee_name').val(data['employee_nm']);
				$('#employee_nm').val(data['employee_nm']);
			} else {
				element.val('')
				$('#employee_name').val("");
				$('#employee_nm').val("");
				element.focus();
			}

		}
	});
}
/**
 * load_treatment_applications_no(ステータス状況)
 *
 * @author		:	viettd - 2018/09/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function load_treatment_applications_no(fiscal_year = 0, from_screen_id = '') {
	try {
		//
		$.ajax({
			type: 'POST',
			url: '/common/load_treatment_applications_no',
			dataType: 'json',
			loading: true,
			data: {
				fiscal_year: fiscal_year
				, from_screen_id: from_screen_id
			},
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if ($('.treatment_applications_no').hasClass('multiselect')) {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['treatment_applications_no'] + '">' + htmlEntities(res['rows'][i]['treatment_applications_nm']) + '</option>';
						}
						$('.treatment_applications_no').html(html);
						$('.treatment_applications_no').multiselect('rebuild');
						$('.treatment_applications_no').trigger('change');
					} else {
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['treatment_applications_no'] + '">' + htmlEntities(res['rows'][i]['treatment_applications_nm']) + '</option>';
						}
						$('.treatment_applications_no').html(html);
					}
				}
			}
		});
	} catch (e) {
		alert('load_treatment_applications_no' + e.message);
	}
}
/**
 * load_group_from_fiscal_year_1on1
 *
 * @author		:	viettd - 2020/11/30 - create
 * @param	int fiscal_year
 *
 * @return void
 */
function load_group_from_fiscal_year_1on1(fiscal_year = 0) {
	try {
		$.ajax({
			type: 'POST',
			url: '/common/load_group_from_fiscal_year_1on1',
			dataType: 'json',
			loading: true,
			data: {
				fiscal_year: fiscal_year
			},
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if ($('.group_cd_1on1').hasClass('multiselect')) {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['group_cd_1on1'] + '">' + htmlEntities(res['rows'][i]['group_nm_1on1']) + '</option>';
						}
						$('.group_cd_1on1').html(html);
						$('.group_cd_1on1').multiselect('rebuild');
						$('.group_cd_1on1').trigger('change');
					} else {
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['group_cd_1on1'] + '">' + htmlEntities(res['rows'][i]['group_nm_1on1']) + '</option>';
						}
						$('.group_cd_1on1').html(html);
					}
				}
			}
		});
	} catch (e) {
		alert('load_group_from_fiscal_year_1on1' + e.message);
	}
}
/**
 * load_times_from_groupcd
 *
 * @author		:	nghianm - 2020/11/30 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function load_times_1on1(fiscal_year = 0, group_cd = 0) {
	try {
		//
		$.ajax({
			type: 'POST',
			url: '/common/load_times_from_groupcd',
			dataType: 'json',
			loading: true,
			data: {
				fiscal_year: fiscal_year
				, group_cd: group_cd
			},
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if ($('.times').hasClass('multiselect')) {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['times'] + '">' + htmlEntities(res['rows'][i]['times']) + '</option>';
						}
						$('.times').html(html);
						$('.times').multiselect('rebuild');
						$('.times').trigger('change');
					} else {
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['times'] + '">' + htmlEntities(res['rows'][i]['times']) + '</option>';
						}
						$('.times').html(html);
					}
				}
			}
		});
	} catch (e) {
		alert('load_times' + e.message);
	}
}

/**
 * loadSheetcd(ステータス状況)
 *
 * @author		:	viettd - 2018/09/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadSheetcd(fiscal_year = 0, category_typ = 0, evaluation_typ = 0) {
	try {
		//
		$.ajax({
			type: 'POST',
			url: '/common/loadSheetcd',
			dataType: 'json',
			loading: true,
			data: {
				fiscal_year: fiscal_year
				, category_typ: category_typ
				, evaluation_typ: evaluation_typ
			},
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					console.log(res['rows']);
					var html = '<option value="-1"></option>';
					for (var i = 0; i < res['rows'].length; i++) {
						html += '<option value="' + res['rows'][i]['sheet_cd'] + '">' + htmlEntities(res['rows'][i]['sheet_nm']) + '</option>';
					}
					//
					$('.sheet_cd').html(html);
				}
			}
		});
	} catch (e) {
		alert('loadSheetcd' + e.message);
	}
}
/**
 * loadStatus(ステータス状況)
 *
 * @author		:	viettd - 2018/09/26 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadStatus(evaluation_typ = 0) {
	try {
		//
		$.ajax({
			type: 'POST',
			url: '/common/loadStatus',
			dataType: 'json',
			loading: true,
			data: {
				evaluation_typ: evaluation_typ
			},
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					var html = '<option value="-1"></option>';
					for (var i = 0; i < res['rows'].length; i++) {
						html += '<option value="' + res['rows'][i]['status_cd'] + '">' + htmlEntities(res['rows'][i]['status_nm']) + '</option>';
					}
					//
					$('.status_cd').html(html);
				}
			}
		});
	} catch (e) {
		alert('loadcustomerOrganization' + e.message);
	}
}

/**
 * loadcustomerOrganization
 *
 * @author		:	longvv - 2018/08/23 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadcustomerOrganization(data = {}, param) {
	try {
		//
		$.ajax({
			type: 'POST',
			url: '/common/loadOrganizationcustomer',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if (param == 'multiselect') {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['organization_cd'] + '">' + htmlEntities(res['rows'][i]['organization_nm']) + '</option>';
						}
						$('.organization_customer_cd2').html(html);
						$('.organization_customer_cd2').multiselect('rebuild');
						$('.organization_customer_cd2').trigger('change');
					} else {
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							html += '<option value="' + res['rows'][i]['organization_cd'] + '">' + htmlEntities(res['rows'][i]['organization_nm']) + '</option>';
						}
						$('.organization_customer_cd2').html(html);
					}
				}
			}
		});
	} catch (e) {
		alert('loadcustomerOrganization' + e.message);
	}
}
/**
 * loadOrganization
 *
 * @author		:	longvv - 2018/08/23 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function loadOrganization(data = {}, param, this1) {
	try {
		var organization_typ = 2;
		if (typeof data.organization_typ !== 'undefined') {
			organization_typ = parseInt(data.organization_typ) + 1;
		}
		//
		$.ajax({
			type: 'POST',
			url: '/common/loadOrganization',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				if (typeof res['rows'] != undefined) {
					if (param == 'multiselect') {
						var html = '';
						for (var i = 0; i < res['rows'].length; i++) {
							var val = res['rows'][i]['organization_cd_1'] + '|' + res['rows'][i]['organization_cd_2'] + '|' + res['rows'][i]['organization_cd_3'] + '|' + res['rows'][i]['organization_cd_4'] + '|' + res['rows'][i]['organization_cd_5'];
							html += '<option value="' + val + '">' + res['rows'][i]['organization_nm'] + '</option>';
						}
						//
						$(this1).closest('.row').find('.organization_cd' + organization_typ).empty();
						$(this1).closest('.row').find('.organization_cd' + organization_typ).append(html);
						$(this1).closest('.row').find('.organization_cd' + organization_typ).multiselect('rebuild');
						$(this1).closest('.row').find('.organization_cd' + organization_typ).trigger('change');
					} else {
						('.row').find
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							var val = res['rows'][i]['organization_cd_1'] + '|' + res['rows'][i]['organization_cd_2'] + '|' + res['rows'][i]['organization_cd_3'] + '|' + res['rows'][i]['organization_cd_4'] + '|' + res['rows'][i]['organization_cd_5'];
							html += '<option value="' + val + '">' + res['rows'][i]['organization_nm'] + '</option>';
						}
						$(this1).closest('.row').find('.organization_cd' + organization_typ).empty();
						$(this1).closest('.row').find('.organization_cd' + organization_typ).append(html);
						$(this1).closest('.row').find('.organization_cd' + organization_typ).trigger('change');
					}
				}
			}
		});
	} catch (e) {
		alert('loadOrganization' + e.message);
	}
}
/////////////////////////////////////////////////////////////////////////////////////
// END REFER DATA
/////////////////////////////////////////////////////////////////////////////////////
/**
 * Common item validation process. Call when click save button.
 *
 * @author : viettd - 2015/10/02 - create
 * @author :
 * @param :
 *            element
 * @return : true/false
 * @access : public
 * @see :
 */
function _validate(element) {
	if (!element) {
		element = $('body');
	}
	var error = 0;
	try {
		_clearErrors(1);
		// validate required
		var message = _text[8].message;
		element.find('.required:enabled').each(function () {
			//biennv 2016/01/14 fix required in tab
			if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
				if (($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '') {
					$(this).errorStyle(message, 1);
					error++;
				} else if ($(this).is("select") && ($(this).val() == '-1' || $(this).val() == undefined)) {
					$(this).errorStyle(message, 1);
					error++;
				}
			}
		});
		// item multiselect
		element.find('.multiselect').each(function () {
			if ($(this).hasClass('required')) {
				var div = $(this).closest('.multi-select-full');
				var check = 0;
				div.find('input[type=checkbox]').each(function () {
					if ($(this).prop('checked')) {
						check++;
					}
				});
				//
				if (check == 0) {
					div.errorStyle(message, 2);
					error++;
				}
			}
		});
		//
		element.find('.requiredValue0:enabled').each(function () {
			//biennv 2016/01/14 fix required in tab
			if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
				if (($(this).is("input") || $(this).is("textarea")) && $.trim($(this).val()) == '' || $.trim($(this).val()) == '0') {
					$(this).errorStyle(message, 1);
					error++;
				}
			}
		});

		if (error > 0) {
			checkTabError();
			_focusErrorItem();
			return false;
		} else {
			return true;
		}
	} catch (e) {
		alert('_validate: ' + e.toString());
	}
}
/**
 * _findErrMsgPosition
 *
 * @author : viettd - 2015/09/23 - create
 * @author :
 * @return : item- description
 * @access : public
 * @see :
 */
function _findErrMsgPosition(item) {
	try {
		var top = item.position().top;
		var left = item.position().left
			+ 1
			* item.css('margin-left').substring(0,
				item.css('margin-left').length - 2);
		while (!item.parent().is('body')) {
			if (item.parent().css('position') == 'relative') {
				top += item.parent().position().top;
				left += item.parent().position().left;
			} else if (item.parent().is('#cboxLoadedContent')) {
				top += $('#colorbox').position().top;
				left += $('#colorbox').position().left;
				break;
			}
			item = item.parent();
		}
		return {
			top: top,
			left: left
		};
	} catch (e) {
		alert('_findErrMsgPosition: ' + e.message);
	}
}



/**
 * checkTabError
 *
 * @author : namnb - 2017/08/21 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function checkTabError() {
	// mark error for tab
	$('a[data-toggle="tab"]').removeClass('tab-error');
	//
	if ($('.tab-pane').length > 0) {
		$('.tab-pane').each(function () {
			var id = $(this).attr('id');
			if ($('#' + $.trim(id) + ' .textbox-error').length > 0) {
				$('a[href="#' + id + '"]').addClass('tab-error');
			}
		});
	}
}
/**
 * Find first error item and focus it
 */
function _focusErrorItem() {
	try {
		$('.textbox-error:first').focus();
		$('.boder-error:first').focus();
	} catch (e) {
		alert('_focusErrorItem: ' + e.message);
	}
}
/**
 * Clear all red items. Call when no error detected.
 */
// function _clearErrors() {
// 	try {
// 		$('.textbox-error').remove();
// 		$('input,select,textarea').removeClass('boder-error');
// 	} catch (e) {
// 		alert('_clearErrors' + e.message);
// 	}
// }
function _clearErrors(style) {
	try {
		if (window.location.pathname.split("/").pop().includes('m0070') && window.location.pathname.split("/").pop().includes('m0070') !== -1) {
			$('.error-type4').removeClass('error-type4');
			$(this).closest('.tab-pane').find('.textbox-error').removeErrorStyle(style);
		} else {
			$('.error-type4').removeClass('error-type4');
			$('.textbox-error').removeErrorStyle(style);
		}
	} catch (e) {
		alert('_clearErrors' + e.message);
	}
}

/**
 * processError
 *
 * @author : viettd - 2015/10/14 - create
 * @author :
 * @param :
 *            null
 * @return : null
 * @access : public
 * @see :
 */
function processError(error) {
	try {
		_clearErrors();
		// check the first row of table error has error_typ = 1 (dialog)
		if (error[0].error_typ == 1) {
			jMessage(error[0].message_no);
			// check the first row of table error has error_typ = 2(dialog can
			// eidt message)
		} else if (error[0].error_typ == 2) {
			jMessage(error[0].message_no, function () { });
		} else if (error[0].error_typ == 999) {
			jError(error[0].remark, '例外');
			//edited by viettd - 2016/08/29
		} else if (error[0].error_typ == 3) {
			for (var i in error) {
				// if tooltip
				if (error[i].error_typ == 3) {
					// check id
					if (error[i].item.indexOf('#') != -1) {
						var msg = error[i].remark;
						// check item is muliti attribute
						if (error[i].item.indexOf(',') != '') {
							var itemAarray = error[i].item.split(',');
							for (var j = 0; j < itemAarray.length; j++) {
								$(itemAarray[j]).errorStyle(msg, 1);
							}
						} else {
							$(error[i].item).errorStyle(msg, 1);
						}
					}
					// check class
					if (error[i].item.indexOf('.') != -1) {
						// when index is not exists.
						if (error[i].value1 == 0) {
							//							var msg = _text[error[i].message_no];
							var msg = error[i].remark;
							// check item is muliti attribute
							if (error[i].item.indexOf(',') != '') {
								var itemAarray = error[i].item.split(',');
								for (var j = 0; j < itemAarray.length; j++) {
									$(itemAarray[j]).errorStyle(msg,
										1);
								}
							} else {
								$(error[i].item).errorStyle(msg,
									1);
							}
							// when index is exists
						} else {
							var index = error[i].value1;
							var msg = error[i].remark;
							//							var msg = _text[error[i].message_no];
							$(error[i].item).eq(index - 1).errorStyle(msg, 1);
						}
					}
				} else {
					jMessage(error[i].message_no);
				}
			}
			//end edited by viettd - 2016/08/29
		} else if (error[0].error_typ == 4) {
			jMessage(error[0].message_no, function () {
				for (var i in error) {
					if (error[i].error_typ == 4) {
						// check id
						if (error[i].item.indexOf('#') != -1) {
							var msg = _text[error[i].message_no].message;
							// check item is muliti attribute
							if (error[i].item.indexOf(',') != -1) {
								var itemAarray = error[i].item.split(',');
								for (var j = 0; j < itemAarray.length; j++) {
									// $(itemAarray[j]).errorStyle(msg,1);
									$(itemAarray[j]).closest('td').addClass('error-type4');
								}
							} else {
								// $(error[i].item).errorStyle(msg, 1);
								$(error[i].item).closest('td').addClass('error-type4');
							}
						}
						// check class
						if (error[i].item.indexOf('.') != -1) {
							// when index is not exists.
							if (error[i].value1 == 0) {
								var msg = _text[error[i].message_no].message;
								// check item is muliti attribute
								if (error[i].item.indexOf(',') != -1) {
									var itemAarray = error[i].item.split(',');
									for (var j = 0; j < itemAarray.length; j++) {
										// $(itemAarray[j]).errorStyle(msg,1);
										$(itemAarray[j]).closest('td').addClass('error-type4');
									}
								} else {
									// $(error[i].item).errorStyle(msg,1);
									$(error[i].item).closest('td').addClass('error-type4');
								}
								// when index is exists
							} else {
								var index = error[i].value1;
								var msg = _text[error[i].message_no].message;
								// $(error[i].item).eq(index - 1).errorStyle(msg,1);
								// $(error[i].item).eq(index - 1).addClass('error-type4');
								$(error[i].item).eq(index - 1).closest('td').addClass('error-type4');
							}
						}
					}
				}
			});
		} else if (error[0].error_typ == 5) {
			jError('エラー', error[0].remark); // alert message text from sql
		} else {
			for (var i in error) {
				// if tooltip
				if (error[i].error_typ == 0) {
					// check id
					if (error[i].item.indexOf('#') != -1) {
						var msg = _text[error[i].message_no].message;
						// check item is muliti attribute
						if (error[i].item.indexOf(',') != '') {
							var itemAarray = error[i].item.split(',');
							for (var j = 0; j < itemAarray.length; j++) {
								$(itemAarray[j]).errorStyle(msg, 1);
							}
						} else {
							$(error[i].item).errorStyle(msg, 1);
						}
					}
					// check class
					if (error[i].item.indexOf('.') != -1) {
						// when index is not exists.
						if (error[i].value1 == 0) {
							var msg = _text[error[i].message_no].message;
							// check item is muliti attribute
							if (error[i].item.indexOf(',') != '') {
								var itemAarray = error[i].item.split(',');
								for (var j = 0; j < itemAarray.length; j++) {
									$(itemAarray[j]).errorStyle(msg,
										1);
								}
							} else {
								$(error[i].item).errorStyle(msg,
									1);
							}
							// when index is exists
						} else {
							var index = error[i].value1;
							var msg = _text[error[i].message_no].message;
							$(error[i].item).eq(index - 1).errorStyle(msg, 1);
						}
					}
				}
			}
			//
		}
		//
		_focusErrorItem();
		checkTabError();
	} catch (e) {
		alert('processError' + e.message);
	}
}
/**
 * getData
 *
 * @author : viettd - 2015/10/12 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function getData(obj) {
	try {
		var result = {};
		var data = {};
		var data_sql = {};
		$.each(obj, function (key, element) {
			if (element.attr == 'id') {
				var val = getDataRules(key, element);
				data['#' + key] = val['val'];
				data_sql[key] = val['val'];
			} if (element.attr == 'name') {
				var val = getDataRules(key, element);
				data[key] = val['val'];
				data_sql[key] = val['val'];
			} else if (element.attr == 'list') {
				var array_result = [];
				// get data of sql
				$('.' + key).each(function () {
					var object = $(this);
					var data_item = {};
					$.each(element.item, function (key1, element1) {
						data_item[key1] = getDataItem(object.find('.' + key1), element1);
					});
					array_result.push(data_item);
				});
				data_sql[key] = array_result;
				//
				$.each(element.item, function (key1, element1) {
					var val = getDataRules(key1, element1);
					data['.' + key1] = val['val'];
				});
			}
		});
		//
		result['rules'] = data;
		result['data_sql'] = data_sql;
		return result;
	} catch (e) {
		alert('getData : ' + e.message);
	}
}
/**
 * getDataRules
 *
 * @author : viettd - 2015/10/12 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function getDataRules(key, element) {
	try {
		var result = [];
		switch (element.type) {
			case 'text':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						val.push($.trim($(this).val()));
					});
					result['val'] = val;
				} else {
					result['val'] = $.trim($('#' + key).val());
				}
				break;
			case 'time':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						if ($(this).val() == '') {
							val.push(0);
						} else {
							val.push($.trim($(this).val()).replace(':', ''));
						}
					});
					result['val'] = val;
				} else {
					if ($('#' + key).val() == '') {
						result['val'] = 0;
					} else {
						result['val'] = $.trim($('#' + key).val()).replace(':', '');
					}
				}
				break;
			case 'select':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						val.push($(this).val());
					});
					result['val'] = val;
				} else {
					result['val'] = $('#' + key).val();
				}
				break;
			case 'radiobox':
				if ($("input[name='" + key + "']").is(':checked')) {
					result['val'] = $("input[name='" + key + "']:checked").val();
				} else {
					result['val'] = '0';
				}
				break;
			case 'checkbox':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						if ($(this).is(':checked')) {
							val.push($(this).val());
						} else {
							val.push('0')
						}
					});
					result['val'] = val;
				} else {
					if ($('#' + key).is(':checked')) {
						result['val'] = $('#' + key).val();
					} else {
						result['val'] = '0';
					}
				}
				break;
			case 'numeric':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						if ($(this).val() == '') {
							val.push(0);
						} else {
							val.push($.trim($(this).val()).replace(/,/g, ''));
						}
					});
					result['val'] = val;
				} else {
					if ($('#' + key).val() == '') {
						result['val'] = 0;
					} else {
						result['val'] = $.trim($('#' + key).val()).replace(/,/g, '');
					}
				}
				break;
			case 'only-number':
				if (element.attr == 'class') {
					var val = [];
					$('.' + key).each(function () {
						if ($(this).val() == '') {
							val.push(0);
						} else {
							val.push($.trim($(this).val()));
						}
					});
					result['val'] = val;
				} else {
					if ($('#' + key).val() == '') {
						result['val'] = 0;
					} else {
						result['val'] = $.trim($('#' + key).val());
					}
				}
				break;
			default:
				if ($('#' + key).attr('value') == '') {
					result['val'] = 0;
				} else {
					result['val'] = $.trim($('#' + key).attr('value')).replace(/,/g, '');
				}
				break;
		}
		return result;
	} catch (e) {
		alert('getDataRules : ' + e.message);
	}
}
/**
 * getDataItem
 *
 * @author : viettd - 2015/10/12 - create
 * @author :
 * @return : null
 * @access : public
 * @see :
 */
function getDataItem(object, element) {
	try {
		var result = '';
		switch (element.type) {
			case 'text':
				result = $.trim(object.val());
				break;
			case 'time':
				result = $.trim(object.val()).replace(':', '');
				break;
			case 'select':
				result = object.val();
				if (!result) {
					result = -1;
				}
				break;
			case 'checkbox':
				result = '0';
				if (object.is(":checked")) {
					result = object.val();
				}
				break;
			case 'numeric':
				if ($.trim(object.val()) == '') {
					result = $.trim(object.val()).replace('', 0);
				} else {
					result = $.trim(object.val()).replace(/,/g, '');
				}
				break;
			case 'only-number':
				if ($.trim(object.val()) == '') {
					result = $.trim(object.val()).replace('', 0);
				} else {
					result = $.trim(object.val());
				}
				break;
			case 'html':
				if ($.trim(object.text()) == '') {
					result = $.trim(object.text());
				} else {
					result = $.trim(object.text());
				}
				break;
		}
		return result;
	} catch (e) {
		alert('getDataItem : ' + e.message);
	}
}

/**
 * function fillData
 *
 * @author    : Tuantv - 2018/08/20 - create
 * @params    : data - object
 * @return    : null
 */
function fillData(data, _obj) {
	_clearErrors();
	$.each(_obj, function (key, element) {
		switch (element.type) {
			case 'tel':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'text':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'textarea':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'numeric':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'time':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'refer':
				$('#' + key).val((typeof (data[key]) == 'undefined') ? '' : data[key]);
				break;
			case 'select':
				// $('#' + key).val((typeof (data[key])=='undefined')?'0':data[key]);
				$('#' + key).find('option[value="' + data[key] + '"]').prop('selected', true);
				break;
			case 'multiselect':
				break;
			case 'radiobox':
				var name = element['attr']['name'];
				$("input[name='" + name + "'][value='" + data[key] + "']").prop('checked', true);
				break;
			case 'checkbox':
				$('#' + key).prop('checked', data[key] == '1');
				break;
			case 'display':
				$('#' + key).text(data[key]);
				$('#' + key).val(data[key]);
				break;
			default:
				break;
		}
		;
	});
	//$(":input:not([readonly],[disabled],:hidden)").first().focus();
}

/**
 * function clearData
 *
 * @author    : TuanTV - 2018/08/20 - create
 * @params    : data - object
 * @return    : null
 */
function clearData(_obj, except_key) {
	_clearErrors();
	if (Array.isArray(except_key)) {
		$.each(_obj, function (key, element) {
			if (except_key.indexOf(key) < 0) {
				switch (element.type) {
					case 'text':
						$('#' + key).val('');
						break;
					case 'textarea':
						$('#' + key).val('');
						break;
					case 'numeric':
						$('#' + key).val('');
						break;
					case 'time':
						$('#' + key).val('');
						break;
					case 'refer':
						$('#' + key).val('');
						break;
					case 'select':
						$('#' + key).val('0');
						break;
					case 'multiselect':
						break;
					case 'radiobox':
						break;
					case 'checkbox':
						$('#' + key).prop('checked', false);
						break;
					case 'display':
						{
							$('#' + key).text('');
							$('#' + key).val('');
						}
						break;
					default:
						break;
				}
				;
			}
		});
	} else {
		$.each(_obj, function (key, element) {
			if (typeof except_key == 'undefined') {
				except_key = 'khong xac dinh';
			}
			if (key != except_key) {
				switch (element.type) {
					case 'text':
						$('#' + key).val('');
						break;
					case 'textarea':
						$('#' + key).val('');
						break;
					case 'numeric':
						$('#' + key).val('');
						break;
					case 'time':
						$('#' + key).val('');
						break;
					case 'refer':
						$('#' + key).val('');
						break;
					case 'select':
						$('#' + key).val('0');
						break;
					case 'multiselect':
						break;
					case 'radiobox':
						break;
					case 'checkbox':
						$('#' + key).prop('checked', false);
						break;
					case 'display':
						{
							$('#' + key).text('');
							$('#' + key).val('');
						}
						break;
					default:
						break;
				}
				;
			}
		});
	}
}
/**
 * Convert Full-width to Half-width Characters
 *
 * @param string
 * @returns string
 */
function formatConvertHalfsize(string) {
	try {
		string = $.textFormat(string, '9');
		string = $.textFormat(string, '@');
		string = $.textFormat(string, 'a');
		string = $.textFormat(string, 'A');
		return string;
	} catch (e) {
		alert('_formatString: ' + e);
	}
}
/**
 * getParameterByName
 *
 * @author : viettd - 2015/11/13 - create
 * @author :
 * @params : null
 * @return : null
 * @access : public
 * @see :
 */
function getParameterByName(name, url) {
	try {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex
			.exec(url);
		return results === null ? "" : decodeURIComponent(results[1].replace(
			/\+/g, " "));
	} catch (e) {
		alert('getParameterByName' + e.message);
	}
}
/**
 * showPopup
 *
 * @author : viettd - 2015/09/15 - create
 * @param : href,callback
 * @return : null
 * @access : public
 * @see :
 */
function showPopup(href, option, callback) {
	var width = '';
	var height = '';
	if (typeof (option.width) != 'undefined') {
		width = option.width;
		height = option.height;
	} else {
		width = '80%';
		height = '87%';
	}
	var properties = {
		href: href,
		open: true,
		iframe: true,
		fastIframe: false,
		opacity: 0.2,
		escKey: true,
		overlayClose: false,
		innerWidth: width,
		innerHeight: height,
		reposition: true,
		speed: 0,
		cbox_load: function () {
			$('#cboxClose, #cboxTitle').remove();
		},
		onClosed: function () {

			if (callback) {
				callback();
			}
		}
	};
	// $.extend(properties,option);
	// $.colorbox(properties);
	validateLogin(properties);
}
//validateLogin
function validateLogin(properties) {
	try {
		$.ajax({
			type: 'POST',
			url: '/common/validateLogin',
			dataType: 'json',
			loading: false,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						$.colorbox(properties);
						break;
					// error
					case NG:
						if (_validateDomain(window.location)) {
							location.href = '/login';
						} else {
							jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
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
		alert('validateLogin:' + e.message);
	}
}
function idleLogout() {
	if (location.pathname == '/login') return;
	if ($.idleLogout) {
		$.idleLogout({
			logoutSeconds: 3600, // logout 1h
			countdownSeconds: 10,
			logoutUrl: '/logout',
			countdownMessage: "長い時間何も動作していません。{countdown}秒に自動的にログアウトします。よろしいですか。",
		});
		$(document).bind('UserActivity.idleLogout UserIdle.idleLogout IdleLogout.idleLogout CancelLogut.idleLogout IdleDialogUpdate.idleLogout', function (e) {
			// console.log(e.type, e.namespace, e);
		});
	}
}

function boxSearchAdd() {
	$('.box-input-search').addClass('border-box-input-search');
}
function boxSearchRemove() {
	$('.box-input-search').removeClass('border-box-input-search');
}
function htmlEntities(str) {
	try {
		if (str == undefined) {
			str = '';
		}
		return str.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(
			/&gt;/g, '>').replace(/&quot;/g, '"');
	} catch (e) {
		alert('htmlEntities' + e.message);
	}
}

/**
 * if parent element is input return input value OR return html to element
 *
 * @author      :   tannq - 2017/10/26
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function setRefer($el, $value) {

	if (typeof $value === 'undefined') {
		var $value = '';
	}

	if ($value != '') {
		$value = htmlEntities(String($value));
	}

	if ($el.length == 1) {

		if ($el.is('select')) {
			$el.find('option').removeAttr('selected');
			$el.find('option[value="' + $value + '"]').attr('selected', 'selected');
		} else if ($el.is(':checkbox')) {
			$value > 0 ? $el.attr('checked', 'checked') : $el.removeAttr('checked');
		} else if ($el.is(':input')) {
			$el.val($value).blur();
			if ($el.hasClass('product_nm')) {
				$el.attr('data-original-title', $value);
			}
			if ($el.hasClass('standard')) {
				$el.attr('data-original-title', $value);
			}
		} else {
			$el.text($value);
			if ($el.hasClass('model_number')) {
				$el.attr('data-original-title', $value);
			}


		}
	} else if ($el.length > 1) {
		$el.each(function () {
			var $this = $(this);
			if ($this.is('select')) {
				$this.find('option').removeAttr('selected');
				$this.find('option[value="' + $value + '"]').attr('selected', 'selected');
			} else if ($this.is(':checkbox')) {
				$value > 0 ? $this.attr('checked', 'checked') : $this.removeAttr('checked');
			} else if ($this.is(':input')) {
				$this.val(($value)).blur();
			} else {
				$this.text(($value));
			}
		});
	}

}


// function _setTabIndex() {
// 	//:not([disabled]):not([readonly]):not([type="hidden"])
// 	var tabindex=1;
//     $(':input:not([disabled]):not([readonly]):not([type="hidden"]):not(button):not(.notAuto_tabindex)').each(function (i) {
//         var _this = $(this);
//         _this.attr('tabindex', i + 1);
//         tabindex++;
//     });
//     $('.notAuto_tabindex').each(function (i) {
//         var _this = $(this);
//         _this.attr('tabindex', i + 1+tabindex);
//     });
// 	// $('input[disabled], input[readonly], textarea[disabled], textarea[readonly], select[disabled]').attr('tabindex', '-1');
// }
/**
 * downloadfileHTML
 * @author longvv@ans-asia.com
 * @return array
 */
function downloadfileHTML(filedownload, fileNameSave, callback) {
	try {

		// $("#DownloadFileMain").attr("href" , filedownload);
		// $("#DownloadFileMain").attr("download" , fileNameSave);
		var link = document.createElement('a');
		if (link.download !== undefined) { // feature detection
			// Browsers that support HTML5 download attribute
			link.setAttribute("href", filedownload);
			link.setAttribute("download", fileNameSave);
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		}
		// var anchor = document.createElement('a');
		// anchor.setAttribute("download", fileNameSave);
		// anchor.setAttribute("href", filedownload);
		// anchor.click();

		if (callback) {
			callback();
		}
	} catch (e) {
		alert('downloadfileHTML ' + e.message);
	}

}
/**
 * deleteFile
 *
 * @author      :   longvv - 2018/09/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteFile(fileName) {
	try {
		// var data = getData(_obj);

		$.ajax({
			type: 'POST',
			url: '/common/deletetemp',
			dataType: 'json',
			loading: false,
			data: { fileName: fileName },
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						//location.reload();
						// var returnRes       =   JSON.parse(res);
						jMessage(7, function (r) {
							// do something
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
		alert('deleteFile:' + e.message);
	}
}

function setCache(params, referUrl, callback) {
	try {
		$.ajax({
			type: 'POST',
			headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') },
			url: '/common/setCache',
			dataType: 'json',
			loading: false,
			data: { params: params },
			success: function (res) {
				if (callback) {
					callback();
				}
				// check permission of user
				if (res.status == NG) {
					// jError('エラー','閲覧権限がありません。');
					jMessage(102);
				} else {
					if (referUrl != '') {
						if (_validateDomain(window.location, referUrl)) {
							if (referUrl == '/master/i1041') {
								window.open(
									referUrl,
									'_blank' // <- This is what makes it open in a new window.
								);
							} else {
								window.location.href = referUrl;
							}
						} else {
							jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
						}
					}
				}
			}
		});
	} catch (e) {
		alert('setCache:' + e.message);
	}
}
function setCacheCustomer(params, referUrl, callback) {
	try {
		var url = _customerUrl('common/setCachecustomer');
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'json',
			loading: false,
			data: { params: params },
			success: function (res) {
				if (callback) {
					callback();
				}
				if (referUrl != '') {
					if (_validateDomain(window.location, referUrl) || referUrl.includes('/customer/master/m0001/requesttokens')) {
						window.location.href = referUrl;
					} else {
						jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
					}
				}
			}
		});
	} catch (e) {
		alert('setCachecustomer:' + e.message);
	}
}
/**
 * setGetPrams
 *
 * @author      :   longvv
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function setGetPrams(obj) {
	var param = '';
	$.each(obj, function (key, element) {
		param += '&' + key + '=' + encodeURI(element);
	});
	return param.slice(1);
}
/**
 * get html contiditon
 *
 * @author		:	thanhnv - 2016/02/02 - create
 * @author		:
 * @params		:	null
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function getHtmlCondition(id) {
	$('select option').each(function () {
		$(this).attr('selected', this.selected);
	});
	$(id).find('input').each(function () {
		if ($(this).is('[type="text"]') || $(this).is('[type="tel"]')) {
			$(this).attr('value', $(this).val());
			$('.date').removeClass('hasDatepicker');
			$('.date').next('img').remove();
		} else if ($(this).is('[type="checkbox"]')) {
			if ($(this).is(':checked')) {
				$(this).attr('checked', true);
			} else {
				$(this).removeAttr('checked');
			}
		}
	});
	// fix table
	$(id).find('.sticky-table table .sticky-cell').css('left', '0px');
	return $(id).html();
}
/**
 * tooltip format
 *
 * @author  :   longvv - 2018/12/05 - create
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
document.addEventListener('keydown', function (e) {

	if ($('.anti_tab').length > 0) {
		if (e.keyCode === 9) {
			if (e.shiftKey) {
				if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
					e.preventDefault();
					if ($('#ans-collapse a:not([readonly],[disabled],:hidden)').last().length != 0) {
						$('#ans-collapse a:not([readonly],[disabled],:hidden)').last()[0].focus();
					}
					return;
				}

				var max = -1;
				$(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
					max = Math.max(max, +b);
				});
				if ($(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]) {
					e.preventDefault();
					$(":input:not([readonly],[disabled],:hidden)[tabindex=" + max + "]").focus();
				}
			} else {
				if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],:hidden)').last()[0]) {
					e.preventDefault();
					$(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
				}
			}
		}
	} else {
		if (e.keyCode === 9 && $('.anti_comon').length != 1) {
			if (e.shiftKey) {
				if ($(':focus')[0] === $("#rightcontent :input:not(.pagging-disable,[readonly],[disabled],:hidden)").first()[0]) {
					e.preventDefault();
					if ($(".pagination a:not(.pagging-disable,[readonly],[disabled],:hidden)").last().length != 0) {
						$(".pagination a:not(.pagging-disable,[readonly],[disabled],:hidden)").last()[0].focus();
					}
					else {
						var max = -1;
						$(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
							max = Math.max(max, +b);
						});
						$(":input:not([readonly],[disabled],:hidden)[tabindex=" + max + "]").focus();
					}
					return;
				}

				var max = -1;
				$(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
					max = Math.max(max, +b);
				});

				if ($(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]) {
					e.preventDefault();
					$(":input:not([readonly],[disabled],:hidden)[tabindex=" + max + "]").focus();
				}
			} else {
				if ($(':focus')[0] === $(".pagination a:not(.pagging-disable,[readonly],[disabled],:hidden)").last()[0]) {
					e.preventDefault();
					$("#rightcontent :input:not([readonly],[disabled],:hidden)").first().focus();
				}
				// if (    $(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').last()[0]) {
				//     e.preventDefault();
				//     $(":input:not([readonly],[disabled],:hidden)").first().focus();
				// }
			}

		}
	}
});
/**
 * validate domain
 *
 * @author  :   viettd - 2018/12/05 - create
 * @param 	:	location
 * @result 	:	bool(true|false)
*/
function _validateDomain(object, referUrl = '') {
	try {
		var hostname = object.hostname;
		var protocol = object.protocol;
		// check protocol (http or https);
		if (protocol !== 'http:' && protocol !== 'https:') {
			//このプロトコルは拒否されました
			return false;
		}
		// check url
		if (referUrl != '' && _URL_WHITELIST.includes(referUrl) === false) {
			return false;
		}
		// check domain
		if (_DOMAIN_WHITELIST.length > 0) {
			if (_DOMAIN_WHITELIST.includes(hostname) === false) {
				// このドメインは拒否されました
				return false;
			}
		}
		// 成功
		return true;
	} catch (e) {
		alert('_validateDomain : ' + e.message);
	}
}
/**
 * _getItems
 *
 * @author  :   datnt - 2020/10/08 - create
 * @param 	:	null
 * @result 	:	object
*/
function _getItems(type = 0) {
	var list_character = [];
	var list_date = [];
	var list_number_item = [];
	if (type == 0) {
		$('.list_character').each(function () {
			list_character.push({
				'character_item': $(this).find('.character_item').val()
				, 'item_cd': $(this).find('.item_cd').val()
			});
		});
		return list_character; // get list character
	}
	//
	if (type == 1) {
		$('.list_date').each(function () {
			let date_value = $(this).find('.date_item').val();
			let from_date_item = $(this).find('.from_date_item').val();
			let to_date_item = $(this).find('.to_date_item').val();
			// list_date.push(obj_sub);
			list_date.push({
				'from_date_item': from_date_item
				, 'to_date_item': to_date_item
				, 'date_item': date_value
				, 'item_cd': $(this).find('.item_cd').val()
			});
		});
		return list_date;
	}
	//
	if (type == 2) {
		$('.list_number_item').each(function () {
			let item = $(this).find('.number_item');
			let item_cd = $(this).find('.item_cd');
			let from_number_item = $(this).find('.from_number_item').val();
			let to_number_item = $(this).find('.to_number_item').val();
			if (from_number_item == undefined) {
				from_number_item = '';
			}
			if (to_number_item == undefined) {
				to_number_item = '';
			}
			//
			if (item.is(':radio')) {
				// let val = $(this).find('input[name="'+item_cd.val()+'"]:checked').val();
				let val = $(this).find('input[type="radio"]:checked').val();
				if (val == undefined) {
					val = '';
				}
				list_number_item.push({ 'number_item': val, 'item_cd': item_cd.val() });
			} else if (item.is(':checkbox')) {
				// let val = $(this).find('input[name="'+item_cd.val()+'"]:checked').val();
				$(this).find('input[type="checkbox"]:checked').each(function () {
					let val = $(this).val();
					if (val == undefined) {
						val = '';
					}
					list_number_item.push({ 'number_item': val, 'item_cd': item_cd.val() });
				});
			} else if (item.is('input')) {
				let val = item.val() != '' ? item.val() : '';
				list_number_item.push({
					'from_number_item': from_number_item
					, 'to_number_item': to_number_item
					, 'number_item': val
					, 'item_cd': item_cd.val()
				});
			} else if (item.is('select')) {
				let val = $(this).find('select').val();
				list_number_item.push({ 'number_item': val, 'item_cd': item_cd.val() });
			}
		});
		return list_number_item;
	}
}

/**
 * _redirectScreen
 *
 * @author  :   viettd - 2020/12/11 - create
 * @param 	:	string url
 * @param 	:	object  payload
 * @result 	:	void
*/
function _redirectScreen(url = '', payload = {}, is_new_tab = false) {
	// check url is blank
	if (url == '') {
		return false;
	}
	// check payload is empty
	if (Object.keys(payload).length == 0) {
		return false;
	}
	//send data to post
	$.ajax({
		type: 'POST',
		url: '/common/redirect',
		dataType: 'json',
		loading: true,
		data: payload,
		success: function (res) {
			switch (res['status']) {
				// seccess
				case OK:
					//
					if (res['redirect_status'] == 'false') {
						jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
					} else {
						if (_validateDomain(window.location, url)) {
							if (is_new_tab) {
								//
								// window.open(_urlGenerated(url,res['redirect_from'],res['redirect_param']),'_blank');
								window.open().location = _urlGenerated(url, res['redirect_from'], res['redirect_param']);
							} else {
								window.location.href = _urlGenerated(url, res['redirect_from'], res['redirect_param']);
							}
						} else {
							jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
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
		}
	});
}

/**
 * _redirectScreen
 *
 * @author  :   viettd - 2020/12/11 - create
 * @param 	:	string url
 * @param 	:	object  payload
 * @result 	:	void
*/
function _urlGenerated(url, redirect_from, redirect_param) {
	if (redirect_from == '') {
		return url;
	}
	//
	url = url + '?from=' + redirect_from;
	// check if redirect_param != ''
	if (redirect_param != '') {
		url = url + '&redirect_param=' + redirect_param;
	}
	//
	return url
}
function unFixedWhenSmallScreen() {
	var window_width = window.outerWidth;
	if (window_width < 600) {
		$('.sticky-cell').addClass('old-sticky-cell');
		$('td').removeClass('sticky-cell');
		$('th').removeClass('sticky-cell');
	} else {
		$('.old-sticky-cell').addClass('sticky-cell');
		$('.old-sticky-cell').removeClass('old-sticky-cell');
	}
}
function initDropdownRemark() {
	var input = document.getElementsByClassName("remark_dropdown");
	if (input[0] != undefined) {
		$.each(input, function (id, el) {
			el.addEventListener("keyup", function (event) {
				// Number 13 is the "Enter" key on the keyboard
				if (event.keyCode === 13) {
					// Cancel the default action, if needed
					event.preventDefault();
					$(this).find('a').trigger('click');
					// Trigger the button element with a click
				}
			});
		})

	}
}
/**
 * _backButtonFunction()
 *
 * @author  :   viettd - 2021/01/17 - create
 * @param 	:	string url
 * @param 	:	bool  is_close_brower
 * @result 	:	void
*/
function _backButtonFunction(url = '', is_close_brower = false) {
	// if is_close_brower = true
	if (is_close_brower) {
		window.close();
	} else {
		if (_validateDomain(window.location)) {
			window.location.href = url;
		} else {
			jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
		}
	}
}
/**
 * getMinMaxAutoNumeric()
 *
 * @author  :   viettd - 2021/02/19 - create
 * @param 	:	integer maxlength
 * @param 	:	integer  decimal
 * @param 	:	bool  negative
 * @param 	:	bool  is_min
 *
 * @result 	:	void
*/
function _getMinMaxAutoNumeric(maxlength = 3, decimal = 2, negative = false, is_min = false) {
	var num_str = '';
	// check maxlength < 3
	if (maxlength < 3) {
		return 0;
	}
	// check decimal < 1
	if (decimal < 1) {
		return 0;
	}
	//
	let integer_len = maxlength - decimal - 1; // 1 is '.'
	// get min
	num_str = '-';
	if (is_min) {
		// get integer string
		for (let index = 0; index < integer_len; index++) {
			num_str += '9';
		}
		num_str += '.'; // add '.'
		//  get decimal string
		for (let index = 0; index < decimal; index++) {
			num_str += '9';
		}
		// check negative
		if (negative) {
			return parseFloat(num_str);
		} else {
			return 0;
		}
	}
	// get Max
	num_str = '';
	// get integer string
	for (let index = 0; index < integer_len; index++) {
		num_str += '9';
	}
	num_str += '.'; // add '.'
	//  get decimal string
	for (let index = 0; index < decimal; index++) {
		num_str += '9';
	}
	return parseFloat(num_str);
}
/**
 * _autoNumeric()
 *
 * @author  :   viettd - 2021/02/19 - create
 * @param 	:	object options
 * @result 	:	void
*/
function _autoNumeric(options) {
	try {
		if (options == undefined) {
			options = 'body';
		}
		var message = _text[28].message;
		// add item autonumeric
		$(options).find('.autonumeric').each(function () {
			_clearErrors(1);
			let error = 0;
			var id_val = '';
			if (typeof $(this).attr('id') == 'undefined') {
				alert('id of autonumeric item is required');
				return;
			}
			id_val = $(this).attr('id');
			var negative = $(this).attr('negative');
			var decimal = $(this).attr('decimal');
			var maxlength = $(this).attr('maxlength');
			var separator = $(this).attr('separator');
			var zero = $(this).attr('zero');
			var numeric_val = $(this).val();
			if (typeof numeric_val != 'undefined' && numeric_val != '') {
				numeric_val = parseFloat(numeric_val);
			} else {
				numeric_val = 0;
			}
			var min = 0;
			var max = 0;
			var option = {};
			// check negative
			if (negative) {
				option.styleRules = AutoNumeric.options.styleRules.positiveNegative;
			}
			// check decimal
			if (typeof decimal != 'undefined') {
				option.decimalPlaces = decimal;
			} else {
				decimal = 2; // decimal default
			}
			// check maxlength
			if (typeof maxlength == 'undefined') {
				maxlength = 3; // maxlength default
			}
			// get min & max
			min = _getMinMaxAutoNumeric(maxlength, decimal, negative, true);
			max = _getMinMaxAutoNumeric(maxlength, decimal, negative, false);
			// check min
			// console.log(min,max);
			if (typeof min != 'undefined') {
				option.minimumValue = min;
			}
			// check max
			if (typeof max != 'undefined') {
				option.maximumValue = max;
			}
			// display separator
			if (separator) {
				option.digitGroupSeparator = ',';
			} else {
				option.digitGroupSeparator = '';
			}
			// emptyInputBehavior
			if (typeof zero != 'undefined') {
				option.emptyInputBehavior = 'zero';
			}
			// check range
			if (numeric_val < min || numeric_val > max) {
				error++;
				$(this).errorStyle('項目の値は[' + numeric_val + ']:' + message, 1);
			}
			// apply autonumeric
			if (error > 0) {
				$(this).val('');
			} else {
				an_element = new AutoNumeric('#' + id_val, option); // With one option object
			}
		});
	} catch (e) {

		alert('_autoNumeric : ' + e.message);
	}
}
/**
 * _customerUrl()
 *
 * @author  :   namnt - 2022/04/22 - create
 * @param 	:	String
 * @result 	:	string
*/
function _customerUrl(url) {
	var segments = window.location.href.split('/');
	if (segments[3] == 'customer') {
		var url = '/customer/' + url;
	};
	return url;
}
/**
 * Get OrganizationData
 */
function _getOrganizationData() {
	try {
		var list = [];
		var obj = {};
		var div_organization_step1 = $('#organization_step1').closest('div');
		if (div_organization_step1.hasClass('multi-select-full')) {
			var div1 = $('#organization_step1').closest('.multi-select-full');
			div1.find('input[type=checkbox]').each(function () {
				if ($(this).prop('checked')) {
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		obj.list_organization_step1 = list;
		list = [];
		var div_organization_step2 = $('#organization_step2').closest('div');
		if (div_organization_step2.hasClass('multi-select-full')) {
			var div2 = $('#organization_step2').closest('.multi-select-full');
			div2.find('input[type=checkbox]').each(function () {
				if ($(this).prop('checked')) {
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		obj.list_organization_step2 = list;
		list = [];
		var div_organization_step3 = $('#organization_step3').closest('div');
		if (div_organization_step3.hasClass('multi-select-full')) {
			var div3 = $('#organization_step3').closest('.multi-select-full');
			div3.find('input[type=checkbox]').each(function () {
				if ($(this).prop('checked')) {
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		obj.list_organization_step3 = list;
		list = [];
		var div_organization_step4 = $('#organization_step4').closest('div');
		if (div_organization_step4.hasClass('multi-select-full')) {
			var div4 = $('#organization_step4').closest('.multi-select-full');
			div4.find('input[type=checkbox]').each(function () {
				if ($(this).prop('checked')) {
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		obj.list_organization_step4 = list;
		list = [];
		var div_organization_step5 = $('#organization_step5').closest('div');
		if (div_organization_step5.hasClass('multi-select-full')) {
			var div5 = $('#organization_step5').closest('.multi-select-full');
			div5.find('input[type=checkbox]').each(function () {
				if ($(this).prop('checked')) {
					var str = $(this).val().split('|');
					//
					list.push({
						'organization_cd_1': str[0] == 'undefined' ? '' : str[0],
						'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
						'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
						'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
						'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
					});
				}
			});
		}
		obj.list_organization_step5 = list;
		return obj;
	} catch (e) {
		console.log('getOrganizationData: ' + e.message);
	}
}
/**
 * getTimesContent()
 *
 * @author  :   namnt - 2022/04/22 - create
 * @param 	:	String
 * @result 	:	string
*/
function getTimesContent(fiscal_year, report_kind, month, div) {
	try {
		var data = {};
		data.fiscal_year = fiscal_year;
		data.report_kind = report_kind;
		data.month = month;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/common/load_time',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				div.find('.times').empty();
				var data = [];
				var option = '<option value="-1"></option>';
				data = JSON.parse(res)
				if (data.length > 0) {
					data.forEach(res => {
						option += '<option value=' + res.detail_no + '>' + res.title + '</option>'

					});
				}
				div.find('.times').append(option)
			}
		});
	} catch (e) {
		alert('getTimesContent: ' + e.message);
	}
}

/**
 * getMonthsContent()
 *
 * @author  :   namnt - 2022/04/22 - create
 * @param 	:	String
 * @result 	:	string
*/
function getMonthsContent(fiscal_year, report_kind, month, screen = '', div_month_times) {
	try {
		var data = {};
		data.fiscal_year = fiscal_year;
		data.screen = screen
		data.report_kind = report_kind
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/common/load_month',
			dataType: 'html',
			loading: true,
			data: data,
			success: function (res) {
				div_month_times.find('.month_times').empty();
				var data = [];
				var option = '';
				if (report_kind != 5 || fiscal_year == -1) {
					var option = '<option value="-1" class="full-month"></option>';
				}
				data = JSON.parse(res);
				if (data.length > 0) {
					data.forEach(res => {
						if (res.month == month && screen == 'schedule') {
							option += '<option value=' + res.month + ' selected>' + res.month_nm + '</option>'
						} else {
							option += '<option value=' + res.month + '>' + res.month_nm + '</option>'
						}
					});
				}
				div_month_times.find('.month_times').append(option);
				div_month_times.find('.month_times').trigger('change');
				// change month
				if (typeof __referDataAffterChangeMonth == 'function') {
					__referDataAffterChangeMonth();
				}
			}
		});
	} catch (e) {
		alert('getMonthsContent: ' + e.message);
	}
}

/**
 * _getCommentType
 * 
 * @param {Int} login_use_typ 
 * @param {Int} admin_and_is_approver 
 * @param {Int} admin_and_is_viewer 
 * @returns Int 
 * 
 */
function _getCommentType(login_use_typ = 0, admin_and_is_approver = 0, admin_and_is_viewer = 0) {
	try {
		login_use_typ = parseInt(login_use_typ);
		admin_and_is_approver = parseInt(admin_and_is_approver);
		admin_and_is_viewer = parseInt(admin_and_is_viewer);
		if (login_use_typ >= 21 && login_use_typ <= 24) {
			return 1; // 1.承認者
		}
		if (login_use_typ == 3) {
			return 2; // 2.閲覧者
		}
		// admin is approver
		if (login_use_typ == 4 && admin_and_is_approver == 1) {
			return 1; // 1.承認者
		}
		// admin is viewer
		if (login_use_typ == 4 && admin_and_is_viewer == 1) {
			return 2; // 2.閲覧者
		}
		return 0;
	} catch (e) {
		console.log('_getCommentType:' + e.message);
	}
}
function _isJson(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}