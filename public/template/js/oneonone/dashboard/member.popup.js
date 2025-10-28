/**
 * ****************************************************************************
 * ANS ASIA
 *
 * Created Date    	: 2020/12/08
 * Created By   	: viettd - viettd@ans-asia.com
 *
 * Updated Content  :
 * Updated Date    	:
 * Updated By   	:
 *
 * @package   : MODULE 1on1
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
	'fiscal_year_1on1_target'       :   {'type':'numeric', 'attr':'id'}
,	'target1'						:   {'type':'text', 'attr':'id'}
,	'target2'						:   {'type':'text', 'attr':'id'}
, 	'target3'						: 	{ 'type': 'text', 'attr': 'id' }
,	'comment'						:   {'type':'text', 'attr':'id'}
};
//
$(document).ready(function() {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});

function initialize() {
	$('html').addClass('pdtop31');
}
/*
 * initEvents
 * @author		:	viettd - 2020/12/08 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try{
		document.addEventListener('keydown', function (e) {
			if (e.keyCode  === 9) {
				if (e.shiftKey) {
					if ($(':focus')[0] === $('.popup-wrapper :input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0]) {
						e.preventDefault();
						$('.popup-wrapper :input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().focus();
					}
				}else{
					if ($(':focus')[0] === $('.popup-wrapper :input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0]) {
						e.preventDefault();
						$('.popup-wrapper :input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
					}
				}
			}
		});
		// button [登録]
		$(document).on('click','#btn-save', function() {
			try {
				jMessage(1,function(r){
					if ( r && _validate($('body'))){
                        savePopup();
                    }
				});
			} catch (e) {
				alert('#btn-save-popup event' + e.message);
			}
		});
		// button [削除]
		$(document).on('click','#btn-delete', function() {
			try {
				jMessage(3,function(r){
					if(r){
						deletePopup($('#fiscal_year_1on1_target').val());
					}
				});
			} catch (e) {
				alert('#btn-delete-popup event' + e.message);
			}
		});
		// change fiscal_year
		$(document).on('change','#fiscal_year_1on1_target', function() {
			try {
				referContent($(this).val());
			} catch (e) {
				alert('#fiscal_year_1on1_target event' + e.message);
			}
		});
	}catch(e){
		alert('initEvents : ' + e.message);
	}
}
/**
 * savePopup
 *
 * @author		:	viettd - 2020/12/09 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function savePopup() {
	try {
		var data    = getData(_obj);
		//send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/oneonone/odashboardmember/popup/save',
			dataType    :   'json',
			loading     :   true,
			data        :   JSON.stringify(data),
			success: function(res) {
			switch (res['status']){
				// seccess
				case OK:
					jMessage(2,function(){
						// location.reload();
						parent.$('#fiscal_year_1on1_member').trigger('change');
						parent.$.colorbox.close();
						parent.$('body').css('overflow','scroll');
					});
				break;
				// error
				case NG:
					if(typeof res['errors'] != 'undefined'){
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
		alert('savePopup' + e.message);
	}
}
/**
 * deletePopup
 *
 * @author		:	viettd - 2020/12/09 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function deletePopup(fiscal_year_1on1_target) {
	try {
		var data    = {};
		data.fiscal_year_1on1_target = fiscal_year_1on1_target;
		//send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/oneonone/odashboardmember/popup/delete',
			dataType    :   'json',
			loading     :   true,
			data        :   data,
			success: function(res) {
			switch (res['status']){
				// seccess
				case OK:
					jMessage(4,function(){
						// location.reload();
						parent.$('#fiscal_year_1on1_member').trigger('change');
						parent.$.colorbox.close();
						parent.$('body').css('overflow','scroll');
					});
				break;
				// error
				case NG:
					if(typeof res['errors'] != 'undefined'){
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
		alert('deletePopup' + e.message);
	}
}

/**
 * referContent
 *
 * @author		:	viettd - 2020/12/09 - create
 * @return		:	null
 * @access		:	public
 * @see			:
 */
function referContent(fiscal_year_1on1_target) {
	try {
		var data    = {};
		data.fiscal_year_1on1_target = fiscal_year_1on1_target;
		//send data to post
		$.ajax({
			type        :   'POST',
			url         :   '/oneonone/odashboardmember/popup/detail',
			dataType    :   'html',
			loading     :   true,
			data        :   data,
			success: function(res) {
				$('#popup_detail_div').empty();
				$('#popup_detail_div').append(res);
			}
		});
	} catch (e) {
		alert('referContent' + e.message);
	}
}