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
var _obj = {
	'list': {
		'attr': 'list', 'item': {
			'refer_kbn': { 'type': 'text', 'attr': 'class' },
			'file_cd': { 'type': 'text', 'attr': 'class' },
			'user_use_typ': { 'type': 'text', 'attr': 'class' },
			'file_nm': { 'type': 'text', 'attr': 'class' },
			'title': { 'type': 'text', 'attr': 'class' },
			'admin_use_typ': { 'type': 'text', 'attr': 'class' },
			'coach_use_typ': { 'type': 'text', 'attr': 'class' },
			'member_use_typ': { 'type': 'text', 'attr': 'class' },
		}
	}
};
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
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
	try {
		$(".lh-input-custom").attr("tabindex",-1).focus();
	} catch (e) {
		alert('initialize: ' + e.message);
	}
}
/*
 * initEvents
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initEvents() {
	try {
		//back
		$(document).on('click', '#btn-back', function (e) {
			try {
				//
				var home_url = $('#home_url').attr('href');
				_backButtonFunction(home_url);
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
	
	
		$(document).on('change', '.user_use_typ', function () {
			try {
				var value = $(this).val();
				var list = $(this).closest('.list')
				if (value == 0) {
					list.find('.admin_use_typ').attr('disabled', true);
					list.find('.coach_use_typ').attr('disabled', true);
					list.find('.member_use_typ').attr('disabled', true);
					list.find('.title').attr('disabled', true);
					list.find('.title').val('');
					list.find('.admin_use_typ').val(0);
					list.find('.coach_use_typ').val(0);
					list.find('.member_use_typ').val(0);
					list.find('.admin_use_typ').attr('checked', false);
					list.find('.coach_use_typ').attr('checked', false);
					list.find('.member_use_typ').attr('checked', false);
				} else {
					list.find('.admin_use_typ').attr('disabled', false);
					list.find('.title').attr('disabled', false);
					list.find('.coach_use_typ').attr('disabled', false);
					list.find('.member_use_typ').attr('disabled', false);
				}
			} catch (e) {
				alert('.user_use_typ' + e.message);
			}
		});
		// add by tuyendn 2022/09/18
		$(document).on('click', '.lh-input-custom', function () {
		    $("#upload_file").trigger("click");
		});
		// add by tuyendn 2022/09/18
		$(document).on('change','#upload_file',function(e){
			var files = e.target.files;
			var text_no_file = $('#text_no_file').val();
			if(files.length > 0){
				var filename = files[0].name;
				$('.ln-text-file').text(filename);
			}else{
				$('.ln-text-file').text(text_no_file);
			}
			 
		})
		$(document).on('click', '#btn-upload', function () {
			try {
			
				$('#upload_file').addClass('required');
				$('.lh-input-custom').addClass('required');
				
				if (_validate($('body')) && !$('#btn-upload').prop('disabled')) {
					uploadFile();
				}
				if($('#upload_file').next().hasClass('textbox-error')){
					var text_error = $('#upload_file').next().text();
					$(".lh-input-custom").attr("tabindex",0).focus();
					$('.lh-input-custom').addClass('boder-error');
					$('.lh-input-custom').after(`<div class="textbox-error">${text_error}</div>`);
				}
			} catch (e) {
				alert('btn-upload: ' + e.message);
			}
		});
		$(document).on('click', '.btn-save', function (e) {
			try {
				$('#upload_file').removeClass('required');
				jMessage(1, function (r) {
					_flgLeft = 1;
					if (r && _validate($('body'))) {
						saveData();
					}
				});
			} catch (e) {
				alert('.btn-save: ' + e.message);
			}
		});
		//btn-delete
		$(document).on('click', '.btn_delete_file', function (e) {
			try {
				var refer_kbn = $(this).parents('td').find('.refer_kbn').val();
				var file_cd = $(this).parents('td').find('.file_cd').val();
				jMessage(118, function (r) {
					_flgLeft = 1;
					if (r) {

						//
					}
				})
			} catch (e) {
				alert('#btn-delete :' + e.message);
			}
		});
		$(document).on('click', 'input[type="checkbox"]', function (e) {
			try {
				if ($(this).val() == 0) {
					$(this).val(1);
				} else {
					$(this).val(0);
				}
			} catch (e) {
				alert('input[type="checkbox"]: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}
/**
 * saveData
 *
 * @author      :   datnt - 2020/11/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveData() {
	try {
		var url = _customerUrl('/oneonone/om0010/save');
		var data = getData(_obj);
		var formData = new FormData();
		formData.append('head', JSON.stringify(data));
		formData.append('file', $('#upload_file')[0].files[0]);
		// send data to post
		$.ajax({
			type: 'post',
			data: formData,
			url: url,
			loading: true,
			processData: false,
			contentType: false,
			enctype: "multipart/form-data",
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function (r) {
							refer();
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
							processError(res['errors']);
						}
						break;
					// Exception
					case 405:
						jMessage(27, function () {
						});
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
		alert('save' + e.message);
	}

}
/**
 * delete
 *
 * @author      :   datnt - 2020/11/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteFile(refer_kbn, file_cd) {
	try {
		var data = {};
		data.refer_kbn = refer_kbn;
		data.file_cd = file_cd;
		// send data to post
		$.ajax({
			type: 'POST',
			url: '/oneonone/om0010/delete',
			dataType: 'json',
			loading: true,
			data: data,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						//location.reload();
						jMessage(4, function () {
							refer();
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
		alert('save' + e.message);
	}
}
/**
 * delete
 *
 * @author      :   datnt - 2020/11/02 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer() {
	try {
		var url = _customerUrl('/oneonone/om0010/refer');
		// send data to post
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'html',
			loading: true,
			success: function (res) {
				$('#inner').empty();
				$('#inner').append(res);
			}
		});
	} catch (e) {
		alert('save' + e.message);
	}
}
function getExtension(filename) {
	var parts = filename.split('.');
	return parts[parts.length - 1];
}
/**
* uploadFile
*
* @author      :   datnt - 2020/11/02 - create
* @author      :
* @return      :   null
* @access      :   public
* @see         :   init
*/
function uploadFile() {
	try {
		var file = $('#upload_file')[0].files[0];
		var LENGTH = 1024 * 1024 * 2; // Size of each upload
		var start = 0; // The start byte of each upload
		var end = start + LENGTH; // End bytes per upload
		var filename = file.name;
		var file_ext = getExtension(filename).toLowerCase()
		var totalSize = file.size; // total file size
		var extention = ["mp4", "avi", "wmv", "pdf", "ppt", "pptx", "xls", "xlsx", "doc", "docx", "mov"];
		var url = _customerUrl('/oneonone/om0010/upload');
		// check when file size > 500Mb = 524288000B
		if (file.size > 524288000) {
			jMessage(120);
			return;
		}
		// add by viettd 2021/06/10
		// when Mirac customer don't check number of file
		var contract_company_attribute = $('#contract_company_attribute').val();
		if(contract_company_attribute != 1){
			var file_size = 0;
			$('#inner table tbody tr').each(function(){
				if($(this).find('.refer_kbn').val() == 2){
					file_size++;
				}
			});
			// if file_size > 5 then show error 121
			if(file_size >= 5){
				jMessage(121);
				return;
			}
		}
		if (!extention.includes(file_ext)) {
			jMessage(119);
			return;
		}
		$('#progressBar').removeClass('hidden');
		$('#btn-upload').prop('disabled', true);
		processBigRequest(url, file, start, end, LENGTH, totalSize);
	} catch (e) {
		alert('uploadFile: ' + e.message);
	}
}
function processBigRequest(url, file, start, end, LENGTH, totalSize) {
	try {
		var formData = new FormData();
		var last_step = 0;
		var filename = file.name;
		var blob = null; //binary object
		var file_name_length = filename.length;
		var new_file_name = filename;
		var file_ext = getExtension(filename).toLowerCase()
		var text_no_file = $('#text_no_file').val();
		if (file_name_length > 50) {
			new_file_name = filename.substring(0, 45) + '.' + file_ext
		}
		blob = file.slice(start, end); // Intercept data that needs to be uploaded each time according to length
		formData.append('file', blob);
		formData.append('file_name', new_file_name);
		formData.append('extention', getExtension(filename));
		start = end;
		end = end + LENGTH;
		if (start >= totalSize) {
			start = totalSize;
			var data = getData(_obj);
			formData.append('head', JSON.stringify(data));
			last_step = 1;
			// send data to post
		}
		formData.append('last_step', last_step);
		$.ajax({
			url: url,
			type: "POST",
			crossDomain: true,
			processData: false,
			contentType: false,
			enctype: "multipart/form-data",
			data: formData,
			success: function (res) {
				let percentage = Math.floor((start / totalSize) * 100);
				$('#progressBarFull').css('width', `${percentage}%`);
				$('#progressBarFull').text(`${percentage}%`);
				if (percentage > 6) {
					$('#progressBarFull').css('justify-content', 'center');
				}
				if (start < totalSize) {
					processBigRequest(url, file, start, end, LENGTH, totalSize);
				}
				if (last_step == 1) {
					switch (res['status']) {
						// success
						case OK:
							jMessage(2, function (r) {
								$('#progressBar').addClass('hidden');
								$('#progressBarFull').css('justify-content', 'unset');
								$('#progressBarFull').css('width', `0%`);
								$('#progressBarFull').text(`0%`);
								$('#btn-upload').prop('disabled', false);
								$('#upload_file').val('');
								$('.ln-text-file').text(text_no_file);
								refer();
							});
							break;
						// error
						case NG:
							if (typeof res['errors'] != 'undefined') {
								processError(res['errors']);
							}
							break;
						// Exception
						case '501':
							jMessage(22, function () {
							});
							break;
						// Exception
						case EX:
							jError(res['Exception']);
							break;
						default:
							break;
					}
				}
			}
		});
	} catch (e) {
		alert('processBigRequest: ' + e.message);
	}
}

