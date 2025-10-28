$(function () {
	initZIP();
});

/*
 * INIT EVENTS
 * @author		:	viettd - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initZIP() {
	//btn-add-new
	$(document).on('change', '.zip_cd', function () {
		try {
			if ($(this).val() != '') {
				changeZipCode($(this), false);
			}
		} catch (e) {
			alert('.zip_cd: ' + e.message);
		}
	});
	// keydown event
	$('input.zip_cd:enabled').keydown(function (event) {
		try {
			if (event.keyCode == 53) {
				return true;
			}
			if (!((event.keyCode > 47 && event.keyCode < 58)
				|| (event.keyCode > 95 && event.keyCode < 106)
				|| event.keyCode == 116
				|| event.keyCode == 46
				|| event.keyCode == 37
				|| event.keyCode == 39
				|| event.keyCode == 8
				|| event.keyCode == 9
				|| event.ctrlKey // 20160404 - sangtk - allow all ctrl combination // 
				|| event.keyCode == 229 // ten-key processing
			)
				// || event.shiftKey
				|| (event.keyCode == 189 || event.keyCode == 109)) {
				event.preventDefault();
			}
		} catch (e) {
			alert(e.message);
		}
	});
}

/**
 * changeZipCode
 * 
 * @author		:	viettd - 2018/06/25 - create
 * @author		:	
 * @params		:	null
 * @return		:	null
 * @access		:	public
 * @see			:	
 */
function changeZipCode(obj, callback) {
	var div = obj.closest('.div-zip-cd');
	var zip_cd = obj.val();
	let GOOGLE_KEY = $('#google_key').val();
	let url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + zip_cd + '&sensor=false&language=ja&key=' + GOOGLE_KEY;
	delete $.ajaxSettings.headers["X-CSRF-TOKEN"];
	$.ajax({
		type: 'GET',
		url: url,
		dataType: 'json',
		success: function (res) {
			$.ajaxSettings.headers["X-CSRF-TOKEN"] = $('meta[name="csrf-token"]').attr('content');
			if (res.status == "OK") {
				results = res.results;
				let address_components = results[0]['address_components'];
				let postal_code = '';
				let city = '';
				let address = '';
				let len = address_components.length;
				for (let i = len - 2; i >= 0; i--) {
					const element = address_components[i];
					if (i == 0) {
						postal_code = element.long_name;
					} else if (element.types.includes('administrative_area_level_1')) {
						city = element.long_name;
					} else {
						address += element.long_name;
					}
				}
				// apply google api response
				div.find('.zip_cd').val(postal_code);
				div.find('.prefectures').val(city);
				div.find('.city_ward_town').val(address);
			} else {
				resetPostCode(div);
			}
		},
		error: function (xhr) {
			jMessage(22, function (r) {
				if (r) {
					resetPostCode(div);
				}
			});
		}
	});
}

/**
 * Reset zip area
 * 
 * @param {Object} div_zip_cd 
 */
function resetPostCode(div_zip_cd) {
	try {
		div_zip_cd.find('.prefectures').val('');
		div_zip_cd.find('.city_ward_town').val('');
	} catch (e) {
		console.log('resetPostCode: ' + e.message);
	}
}