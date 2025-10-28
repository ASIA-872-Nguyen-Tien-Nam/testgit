/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2023/02/07
 * 作成者		    :	quangnd - quangnd@ans-asia.com
 *
 * @package		:	MODULE weeklyreport
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
	'mark_kbn': { 'type': 'text', 'attr': 'id' },
	'name': { 'type': 'text', 'attr': 'id' },
};
$(document).ready(function() {
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
 * @author      :   quangnd - 2023/04/14 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('#mark_kbn').focus();
		//changeSelect();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}

/*
 * INIT EVENTS
 * @author		:	quangnd - 2023/02/07 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
	try {
		$(document).on('click', '#btn-back', function (e) {
			try {
				var home_url = $('#home_url').attr('href');
				_backButtonFunction(home_url);
			} catch (e) {
				alert('#btn-back' + e.message);
			}
		});
		$(document).on('click', '.btn-save', function () {
			try {
				jMessage(1, function (r) {
					if (r && _validate($('body'))) {
						saveData();
					}
				});
			} catch (e) {
				alert('.btn-save: ' + e.message);
			}
		});

		$(document).on('click', '#btn-delete', function (e) {
			try {
				jMessage(3, function (r) {
					deleteData()
				});
			} catch (e) {
				alert('#btn-delete' + e.message);
			}
		});
		//
		$(document).on('change', '#mark_kbn', function () {
			try {
				changeSelect();
			} catch (e) {
				alert('mark_kbn: ' + e.message);
			}
		});
		/* paging */
		$(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
			try {
				var page = $(this).attr('page');
				var search = $('#search_key').val();
				getLeftContent(page, search);
			} catch (e) {
				alert('page-link: ' + e.message);
			}
		});
		$(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
			try {
				var page = $(this).attr('page');
				var search = $('#search_key').val();
				getLeftContent(page, search);
			} catch (e) {
				alert('page-link: ' + e.message);
			}
		});
		//search key
		$(document).on('click', '#btn-search-key', function (e) {
			try {
				var page = 1;
				var search = $('#search_key').val();
				getLeftContent(page, search);
			} catch (e) {
				alert('btn-search-key: ' + e.message);
			}
		});
		$(document).on('change', '#search_key', function (e) {
			try {
				var page = 1;
				var search = $('#search_key').val();
				getLeftContent(page, search);
			} catch (e) {
				alert('btn-search-key: ' + e.message);
			}
		});
		$(document).on('enterKey', '#search_key', function (e) {
			try {
				var page = 1;
				var search = $('#search_key').val();
				getLeftContent(page, search);
			} catch (e) {
				alert('btn-search-key: ' + e.message);
			}
		});
		/* left content click item */
		$(document).on('click', '.list-search-content .list-search-child', function (e) {
			try {
				var mark_kbn = $(this).find('.mark_kbn_cd').val();
				getRightContent(mark_kbn);
			} catch (e) {
				alert('list-search-child-refer: ' + e.message);
			}
		});
		//mark_kbn
		$(document).on('change', '#mark_kbn', function () {
			try {
				var mark_kbn = $(this).val();
				getRightContent(mark_kbn);
			} catch (e) {
				alert('mark_typ: ' + e.message);
			}
		});
	} catch (e) {
		alert('initEvents: ' + e.message);
	}
}
/**
 * getLeftContent
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
	try {
		var url = _customerUrl('/weeklyreport/rm0120/leftcontent');
		// send data to post
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'html',
			loading: true,
			data: { current_page: page, search_key: search },
			success: function (res) {
				if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
					$('#leftcontent .inner').empty().html(res);
					$('#search_key').focus();
					//
					_formatTooltip();
				}
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
	}
}
/**
 * getRightContent
 *
 * @author      :    quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(mark_kbn) {
    try {
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rm0120/rightcontent',
            dataType: 'html',
            loading: true,
            data: {mark_kbn: mark_kbn},
            success: function (res) {
                $('#rightcontent .inner').empty().append(res);
				changeSelect();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * saveData
 *
 * @author      :   quangnd -2023/04/13
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
	try {
		var params = getData(_obj);
		params.data_sql.mark_typ = $('#mark_typ input:checked').val();
		$.ajax({
			type: 'post',
			url: '/weeklyreport/rm0120/save',
			dataType: 'json',
			loading: true,
			data: JSON.stringify(params),
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(2, function (r) {
							getLeftContent(1,'');
							getRightContent(params.data_sql.mark_kbn);
						});
						break;
					// error
					case NG:
						if (typeof res['errors'] != 'undefined') {
							processError(res['errors']);
						}
						break;
					case EX:
						jError(res['Exception']);
						break;
					default:
						break;
				}
			}
		});
	} catch (e) {
		alert('saveData: ' + e.message);
	}
};
/**
 * delete data
 *
 * @author      :   quangnd -2023/04/13
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
	try {
		var check_exits = $('#check_exits').val();
		var data = {};
		data.mark_kbn   =  (check_exits == 1) ? $('#mark_kbn').val() : 0 ;
		$.ajax({
			type: 'POST',
			url: '/weeklyreport/rm0120/delete',
			dataType: 'json',
			data: data,
			loading: true,
			success: function (res) {
				switch (res['status']) {
					// success
					case OK:
						jMessage(4, function (r) {
							location.reload();
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
		alert('deleteData' + e.message);
	}
}
/**
 * changeSelect
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function changeSelect() {
	try {
		$('#body-inner .tr').addClass('d-none')
		var check = $('#mark_kbn').val();
		if (check < 3) {
			// $("#table-data").attr("style", "width: 90%;")
			$(".show").removeClass("hide")
		} else {
			// $("#table-data").attr("style", "width: 90%;")
			$(".w-size").attr("style", "width: 18%;")
			$(".show").addClass("hide")
		}
		if(check == 2){
			$('#body-inner .mark_typ_2').removeClass('d-none')
		}else{
			$('#body-inner .mark_typ_3').removeClass('d-none')
		}
		if ($('#name').val() == '') {
			$('#name').val($("#mark_kbn option:selected").text().trimStart())
		}
	} catch (e) {
		alert('mark_kbn: ' + e.message);
	}
}