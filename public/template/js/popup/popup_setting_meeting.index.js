/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2020/12/10
 * 作成者		    :	datnt
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	fiscal_year: { type: "text", attr: "id" },
	employee_cd: { type: "text", attr: "id" },
	times: { type: "text", attr: "id" },
	from: { type: "text", attr: "id" },
	oneonone_schedule_date: { type: "text", attr: "id" },
	time: { type: "text", attr: "id" },
	title: { type: "text", attr: "id" },

};
$(document).ready(function () {
	try {
		initEvents();
	} catch (e) {
		alert('ready' + e.message);
	}
});

/*
 * INIT EVENTS
 * @author		:	2020/12/10
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		document.addEventListener('keydown', function (e) {
			if (e.keyCode === 9) {
				if (e.shiftKey) {
					if ($(':focus')[0] === $('#oneonone_schedule_date')[0]) {
						e.preventDefault();
						$('#btn-delete').focus();
					}
				} else {
					if ($(':focus')[0] === $('#btn-delete')[0]) {
						e.preventDefault();
						$('#oneonone_schedule_date').focus();
					}
				}
			}
		})
		$(document).on('click', '#btn-save', function (e) {
			try {
				e.preventDefault();
				jMessage(1, function (r) {
					if (r && _validate($("body"))) {
						save();
					}
				});
			} catch (e) {
				alert('btn-save-popup: ' + e.message);
			}
		});
		$(document).on('change', '#send_message', function () {
			try {
				if ($(this).is(":checked")) {
					$(this).val(1);
				} else {
					$(this).val(0);
				}
			} catch (e) {
				alert('#send_message : ' + e.message);
			}
		});
		$(document).on('click', '#btn-delete', function (e) {
			try {
				jMessage(3, function (r) {
					if (r) {
						deleteData();
					}
				});
			} catch (e) {
				alert('#btn-delete: ' + e.message);
			}
		});
	} catch (e) {

	}
}
/**
 * save
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function save() {
	try {
		var data = getData(_obj);
		var oneonone_schedule_date = $('#oneonone_schedule_date').val();
		var time = $('#time').val();
		var place = $('#place').val();
		data.data_sql.mail_check = $('#send_message').val();
		data.data_sql.place = place;
		$.ajax({
			type: "POST",
			url: "/common/popup/save-setting-metting",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						jMessage(2, function (r) {
							if(r){
								parent.$('.popup_meeting_choice').find('.oneonone_schedule_date').val(oneonone_schedule_date);
								parent.$('.popup_meeting_choice').parents('.screen_oi2010').find('.time').html(time);
								parent.$('.popup_meeting_choice').parents('.screen_oi2010').find('.place').html(place);
								parent.$('.popup_meeting_choice').removeClass('popup_meeting_choice');
								// when check send mail
								if(res['mail_check'] == 1){
									if(res['mail_info']['member_mail'] == '' && res['mail_info']['coach_mail'] == ''){
										jMessage(134,function(r){
											// close popup
											parent.$.colorbox.close();
											parent.$('body').css('overflow', 'auto');
										});
									}else{
										sendMeetingMail(res['mail_info']);
									}
								// when do not check send mail then close popup
								}else{
									parent.$.colorbox.close();
									parent.$('body').css('overflow', 'auto');
								}
							}
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
 * delete
 *
 * @author      :   SonDH - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
	try {
		var data = getData(_obj);
		data.data_sql.place = $('#place').val();
		data.data_sql.mail_check = $('#send_message').val();
		// send data to post
		$.ajax({
			type: "POST",
			url: "/common/popup/delete-setting-metting",
			dataType: "json",
			loading: true,
			data: JSON.stringify(data),
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						//location.reload();
						jMessage(4, function () {
							parent.$('.popup_meeting_choice').find('.oneonone_schedule_date').val('');
							parent.$('.popup_meeting_choice').removeClass('popup_meeting_choice');
							parent.$.colorbox.close();
							parent.$('body').css('overflow', 'auto');
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
 * Send mail for meeting
 *
 * @author      :   viettd - 2021/05/13 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function sendMeetingMail(data)
{
	try{
		// send data to post
		$.ajax({
			type: "POST",
			url: "/common/popup/send-meeting-mail",
			dataType: "json",
			loading: true,
			data: data,
			success: function (res) {
				switch (res["status"]) {
					// success
					case OK:
						// jMessage(80,function(r){
						// 	// close popup
						// 	parent.$.colorbox.close();
						// 	parent.$('body').css('overflow', 'auto');
						// });
						// close popup
						parent.$.colorbox.close();
						parent.$('body').css('overflow', 'auto');
						break;
					// error
					case NG:
						jMessage(81,function(r){
							// close popup
							parent.$.colorbox.close();
							parent.$('body').css('overflow', 'auto');
						});	
						break;
					// Exception
					case EX:
						// jError(res["Exception"]);
						// send mail error
						jMessage(81,function(r){
							// close popup
							parent.$.colorbox.close();
							parent.$('body').css('overflow', 'auto');
						});	
						break;
					default:
						break;
				}
			},
		});
	}catch(e){
		alert('sendMeetingMail : '+e.message);
	}
}