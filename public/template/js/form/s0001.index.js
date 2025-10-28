/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/25
 * 作成者          :   viettd – viettd@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
	client_id: { type: "text", attr: "id" },
	client_secret: { type: "text", attr: "id" },
	access_token: { type: "text", attr: "id" },
	refresh_token: { type: "text", attr: "id" },
	expiry_date: { type: "text", attr: "id" },
	kot_client_secret: { type: "text", attr: "id" },
	kot_client_id: { type: "text", attr: "id" },
};
$(function () {
  try {
    initEvents();
    initialize();
  } catch (e) {
    alert("initialize: " + e.message);
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
    jQuery.initTabindex();
  } catch (e) {
    alert("initialize: " + e.message);
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
		$(document).on("click", "#search_company", function () {});
	} catch (e) {
		alert("initialize: " + e.message);
	}
	$(document).on("click", "#btn-save", function () {
		_validate($('body'))
		try {
			jMessage(1, function(r) {
				_flgLeft = 1;
				if ( r && _validate($('body')) ) {
				 	saveData();
				}
		});
		} catch (e) {
		alert(".btn-save: " + e.message);
		}
	});
	$(document).on('click', '#btn-back', function(){
        // window.location.href = '/dashboard';
        if(_validateDomain(window.location)){
            window.location.href = '/customer/master/q0001';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });
	$(document).on("click", "#generate_token", function () {
		try {
		jMessage(1, function (r) {
			generateToken();
		});
		} catch (e) {
		alert("generate_token: " + e.message);
		}
	});
}
/**
 * save
 *
 * @author      :   namnt - 
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {	
		var data = getData(_obj);
		$.ajax({
		type: "POST",
		url: "/customer/master/s0001/save",
		dataType: "json",
		loading: true,
		data: JSON.stringify(data),
		success: function (res) {
			switch (res["status"]) {
			// success
			case OK:
				jMessage(2, function (r) {
					location.reload();
				  });
				break;
			// error
			case EX:
				jError(res["Exception"]);
				break;
			default:
				break;
			}
		},
		});
	} catch (e) {
		alert("saveData" + e.message);
	}
	}
function generateToken() {
	try {
		var data = getData(_obj);
		console.log(data);
		$.ajax({
		  type: "POST",
		  url: "/customer/master/s0001/get-token",
		  dataType: "html",
		  loading: true,
		  data: { 'client_id': $('#client_id').val(), 'client_secret': $('#client_secret').val()},
		  success: function (res) {
			window.location.href = res;
			switch (res["status"]) {
			  // success
			  case OK:
				//
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
		alert("saveData" + e.message);
	  }
	}