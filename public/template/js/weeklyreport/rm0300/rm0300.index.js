/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/11/06
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _mode = 0;
var _obj = {
 	    'group_cd'               :   {'type':'text'  ,   'attr':'id'}
    ,   'group_nm': { 'type': 'text', 'attr': 'id' }
    ,   'browse_position_typ' : {'type':'checkbox', 'attr':'id'}
    ,   'browse_department_typ' : {'type':'checkbox', 'attr':'id'}
    ,   'organization_step1': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step3': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step4': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step5': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2_1': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2_2': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2_3': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2_4': { 'type': 'select', 'attr': 'id' }
    ,   'organization_step2_5': { 'type': 'select', 'attr': 'id' }
};
//
$( document ).ready(function() {
	try{
		initialize();
		initEvents();
	}
	catch(e){ 
		alert('ready' + e.message);
	}
});
/**
 * initialize
 *
 * @author      :   nghianm - 2020-11-06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function initialize() {
	try{
		$('#group_nm').focus();
        $(".multiselect").multiselect({
            onChange: function () {
                $.uniform.update();
            },
        });
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2020-11-06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
	try{
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
		/* paging */
	    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
            try{
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('li.page-prev: ' + e.message);
            }
	    });
	    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
            try{
                var page = $(this).attr('page');
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('li.page-next: ' + e.message);
            }
	    });
        $(document).on('click', '#btn-search-key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('change', '#search_key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
        $(document).on('enterKey', '#search_key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('btn-search-key: ' + e.message);
            }
        });
         /* left content click item */

        $(document).on('click', '#btn-add-new', function(e) {
        	try{
	        	jMessage(5,function(){
	            //
                    $('#group_cd').val('');
                    $('#group_nm').val('');
                    $('#table-data_1 tbody tr').find('.list_m0040').prop('checked', false);
                    $('#table-data_1 tbody tr').find('.list_m0030').prop('checked', false);
                    $('#table-data_1 tbody tr').find('.list_m0050').prop('checked', false);
                    $('#table-data_1 tbody tr').find('.list_m0060').prop('checked', false);
                    $('#table-data_2 tbody tr').find('.list_m0040').prop('checked', false);
                    $('#table-data_2 tbody tr').find('.list_m0030').prop('checked', false);
                    $('#table-data_2 tbody tr').find('.list_m0050').prop('checked', false);
                    $('#table-data_2 tbody tr').find('.list_m0060').prop('checked', false);
                    $('.list-search-child').removeClass('active');
                    $("#organization_step1").val(0);
                    $("#organization_step2").val(0);
                    $("#organization_step2").html('<option value="-1"></option>');
                    $("#organization_step3").val(0);
                    $("#organization_step3").html('<option value="-1"></option>');
                    $("#organization_step4").val(0);
                    $("#organization_step4").html('<option value="-1"></option>');
                    $("#organization_step5").val(0);
                    $("#organization_step5").html('<option value="-1"></option>');
                    $("#organization_step2_1").val(0);
                    $("#organization_step2_2").val(0);
                    $("#organization_step2_2").html('<option value="-1"></option>');
                    $("#organization_step2_3").val(0);
                    $("#organization_step2_3").html('<option value="-1"></option>');
                    $("#organization_step2_4").val(0);
                    $("#organization_step2_4").html('<option value="-1"></option>');
                    $("#organization_step2_5").val(0);
                    $("#organization_step2_4").html('<option value="-1"></option>');
                    $('#browse_position_typ').removeAttr('checked');
                    $('#browse_department_typ').removeAttr('checked');
	                $('#group_nm').focus();
	            _mode = 0;
        	})
			} catch(e){
		        alert('btn-add-new: ' + e.message);
		        }
		    });
        $(document).on('click' , '#btn-save-data' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
            }
        });
        $(document).on('click' , '#btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
            }
        });
        $(document).on('click', '.list-search-child', function(e) {
            try{
                _mode = 1;
                $('.list-search-child').removeClass('active');
                $(this).addClass('active');
                getRightContent($(this).attr('id'));
            } catch(e){
                alert('list-search-child: ' + e.message);
            }
	    });
	    //delete
        $(document).on('click', '#btn-delete', function(){
            try{
                jMessage(3, function(r) {
                    if (r) {
                        del();
                    }
                });
            } catch(e){
                alert('#btn-delete: ' + e.message);
            }
        });
        $(document).on('change', '.organization_cd21,.organization_cd22,.organization_cd23,.organization_cd24', function () {
            try {
                console.log($(this)+'1')
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
				loadOrganization2(data, param);
			} catch (e) {
				alert('.organization_cd1 ' + e.message);
			}
        });
        $(document).on('click', '.label-error_browse_department_typ', function () {
            if (!$('#browse_department_typ').is(':checked')) {
                $('#organization_step2_1').val('-1')
                $('#organization_step2_2').val('-1')
                $('#organization_step2_3').val('-1')
                $('#organization_step2_4').val('-1')
                $('#organization_step2_5').val('-1')
                $('#organization_step2_1').attr('disabled','disabled')
                $('#organization_step2_2').attr('disabled','disabled')
                $('#organization_step2_3').attr('disabled','disabled')
                $('#organization_step2_4').attr('disabled','disabled')
                $('#organization_step2_5').attr('disabled','disabled')
            } else {
                $('#organization_step2_1').removeAttr('disabled')
                $('#organization_step2_2').removeAttr('disabled')
                $('#organization_step2_3').removeAttr('disabled')
                $('#organization_step2_4').removeAttr('disabled')
                $('#organization_step2_5').removeAttr('disabled')
            }
        });
        $(document).on('click', '.label-error_browse_department_typ', function () {
            if (!$('#browse_department_typ').is(':checked')) {
                $('#browse_department_typ').val(1)
            } else {
                $('#browse_department_typ').val(0)
            }
        });
        $(document).on('click', '.label-error_browse_position_typ', function () {
            if (!$('#browse_position_typ').is(':checked')) {
                $('#browse_position_typ').val(1)
            } else {
                $('#browse_position_typ').val(0)
            }
        });
	} catch(e){
		alert('initEvents: ' + e.message);	
	}
}
/**
 * get left content
 *
 * @author      :   nghianm - 2020/10/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0300/leftcontent', 
            dataType    :   'html',
            loading     :   true,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}
/**
 * get right content
 *
 * @author      :   namnt
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(group_cd) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/om0300/rightcontent', 
            dataType    :   'html',
            // loading     :   true,
            data        :   {group_cd: group_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                _formatTooltip();
                $('#group_nm').focus();
                app.jTableFixedHeader();
                jQuery.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * save
 *
 * @author      :   namnt
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
		var list 	= [];

		// var param   = data['data_sql'];    

		var div1 = $('#table-data_1 tbody tr').find('.listm0040');
		div1.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list.push({'code':$(this).val()});
			}
		});
		data['data_sql'].list_m0040	=	list;
        //
		list_m0030 	= [];
		var div2 = $('#table-data_1 tbody tr').find('.listm0030');
		div2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0030.push({
					'code':$(this).val()
				});
			}
		});
		data['data_sql'].list_m0030	=	list_m0030;
		//
		list_m0050 	= [];
		var div3 = $('#table-data_1 tbody tr').find('.listm0050');
		div3.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0050.push({
					'code':$(this).val()
				});
			}
		});
		data['data_sql'].list_m0050	=	list_m0050;
		//
		list_m0060 	= [];
        var div4 = $('#table-data_1 tbody tr').find('.listm0060');
		div4.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0060.push({
					'code':$(this).val()
				});
			}
        });
        //
        data['data_sql'].list_m0060 = list_m0060;
        list_m0040_2 	= [];
        var div5 = $('#table-data_2 tbody tr').find('.listm0040_2');
		div5.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0040_2.push({'code':$(this).val()});
			}
		});
		data['data_sql'].list_m0040_2	=	list_m0040_2;
        //
		list_m0030_2 	= [];
		var div2_2 = $('#table-data_2 tbody tr').find('.listm0030_2');
		div2_2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0030_2.push({
					'code':$(this).val()
				});
			}
		});
		data['data_sql'].list_m0030_2	=	list_m0030_2;
		//
		list_m0050_2 	= [];
		var div3_2 = $('#table-data_2 tbody tr').find('.listm0050_2');
		div3_2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0050_2.push({
					'code':$(this).val()
				});
			}
		});
		data['data_sql'].list_m0050_2	=	list_m0050_2;
		//
		list_m0060_2 	= [];
		var div4_2 = $('#table-data_2 tbody tr').find('.listm0060_2');
		div4_2.find('input[type=checkbox]').each(function(){
			if($(this).prop('checked')){
				list_m0060_2.push({
					'code':$(this).val()
				});
			}
		});
		data['data_sql'].list_m0060_2	=	list_m0060_2;
		list = [];
        data['data_sql'].mode = _mode;
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0300/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            getRightContent('');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#group_nm').focus();
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
        alert('save' + e.message);
    }
}
/**
 * del
 *
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var group_cd    = $('#group_cd').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0300/delete',
            dataType    :   'json',
            loading     :   true,
            data        :   {group_cd: group_cd},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            getRightContent('');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#group_nm').focus();
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
        alert('del' + e.message);
    }
}
/**
 * getRightContent
 *
 * @author      :   namnt
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(group_cd) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0300/rightcontent', 
            dataType    :   'html',
            loading     :   true,
            data        :   {group_cd: group_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                _formatTooltip();
                $('#group_nm').focus();
                app.jTableFixedHeader();
                jQuery.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * get loadOrganization
 *
 * @author      :   namnt
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function loadOrganization2(data = {}, param) {
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
						$('.organization_cd2' + organization_typ).empty();
						$('.organization_cd2' + organization_typ).append(html);
						$('.organization_cd2' + organization_typ).multiselect('rebuild');
						$('.organization_cd2' + organization_typ).trigger('change');
					} else {
						var html = '<option value="-1"></option>';
						for (var i = 0; i < res['rows'].length; i++) {
							var val = res['rows'][i]['organization_cd_1'] + '|' + res['rows'][i]['organization_cd_2'] + '|' + res['rows'][i]['organization_cd_3'] + '|' + res['rows'][i]['organization_cd_4'] + '|' + res['rows'][i]['organization_cd_5'];
							html += '<option value="' + val + '">' + res['rows'][i]['organization_nm'] + '</option>';
						}
                        console.log(organization_typ+html)
						$('.organization_cd2' + organization_typ).empty();
						$('.organization_cd2' + organization_typ).append(html);
						$('.organization_cd2' + organization_typ).trigger('change');
					}
				}
			}
		});
	} catch (e) {
		alert('loadOrganization' + e.message);
	}
}

