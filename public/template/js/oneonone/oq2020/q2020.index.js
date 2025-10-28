/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2020/12/14
 * 作成者    : nghianm - nghianm@ans-asia.com
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
        'fiscal_year'               :   {'type':'text'    , 'attr':'id'}
    ,   'employee_cd'               :   {'type':'text'    , 'attr':'id'}
    ,   'start_date'                :   {'type':'text'    , 'attr':'id'}
    ,   'finish_date'               :   {'type':'text'      , 'attr':'id'}
    ,   'time_to'                   :   {'type':'text'      , 'attr':'id'}
    ,   'time_from'                 :   {'type':'text'      , 'attr':'id'}
};

$(document).ready(function() {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});
function initialize() {
    try {
        var employee_check_cd = $('.employee_check_cd').val();
        var w_1on1_authority_typ = $('.w_1on1_authority_typ').val();
        if(w_1on1_authority_typ == 1 || employee_check_cd != ''){
            $('#btn_search').trigger('click');
        }
    } catch (e) {
        alert('ready' + e.message);
    }
}

/*
 * INIT EVENTS
 */
function initEvents(){
    try{
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var from = $('#from').val();
                if(from != '') {
                    _backButtonFunction('',true);
                }
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        // search
		$(document).on('click','#btn_search',function(e) {
			try{
				e.preventDefault();
				if(_validate()){
					search();
				}
			}catch(e){
				alert('btn_search: ' + e.message);
			}
        });
        // search
		$(document).on('change','#fiscal_year',function(e) {
			try{
                var year = $('#fiscal_year').val();
                $('#employee_nm').attr('fiscal_year_1on1',year);
                var w_1on1_authority_typ = $('.w_1on1_authority_typ').val();
                if (w_1on1_authority_typ == 1) {
                    search();
                }else{
                    $('#employee_cd').val('');
                    $('#employee_nm').val('');
                    $('#employee_nm').attr('old_employee_nm', '');
                    $('#employee_nm').focus();
                }
			}catch(e){
				alert('btn_search: ' + e.message);
			}
        });
        // click 社員番号
        $(document).on('click','.times',function(e) {
			try{
				e.preventDefault();
				var fiscal_year = $('#fiscal_year').val();
				var employee_cd = $('#employee_cd').val();
                var times       = $(this).text();
				var html 		= getHtmlCondition($('.container-fluid'));
				var data = {
                        'fiscal_year_1on1'     	:   fiscal_year
                    ,   'member_cd'     	:   employee_cd
                    ,   'times'             :   times
                    ,	'html'				: 	html
					,   'from'         		:   'oq2020'
					,	'save_cache'		:	'true'		// save cache status
					,	'screen_id'			:	'oq2020_oi2010'		// save cache status
		        };
		        //
				_redirectScreen('/oneonone/oi2010',data,true);
			}catch(e){
				alert('.employee_cd_link: ' + e.message);
			}
		});
        //EXCEL
        $(document).on('click','#btn-item-evaluation-input',function(){
			let params = {
				'fiscal_year' 	: $('#fiscal_year').val(),
				'member_cd' 	: $('#employee_cd').val(),
				'times' 		: 0,
			}
            if ( _validate($('body'))) {
                $.downloadFileAjax('/oneonone/oi2010/listexcel', JSON.stringify(params));
            }
		})
		//save
		$(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function (r) {
                    if (r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
            }
	    });

    }catch(e){
        alert('initEvents: ' + e.message);
    }
}
/**
 * checkEmp
 *
 * @author		:	nghianm - 2020/12/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function checkEmp(){
	try{
        var result = $('#employee_cd').val();
        var employee_cd_1on1 = $('#employee_cd_1on1').val();
        if(employee_cd_1on1 == result ) {
            $('#generic_comment_1').removeAttr('disabled','true');
            $('#generic_comment_2').removeAttr('disabled','true');
            $('#generic_comment_3').removeAttr('disabled','true');
            $('#generic_comment_4').attr('disabled','true');
        }
        else {
            $('#generic_comment_1').attr('disabled','true')
            $('#generic_comment_2').attr('disabled','true')
            $('#generic_comment_3').attr('disabled','true')
            $('#generic_comment_4').removeAttr('disabled','true')
        }
	}catch(e){
		alert('checkEmp: ' + e.message);
	}
}
/**
 * search
 *
 * @author		:	nghianm - 2020/12/14 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function search(){
	try{
        var data    = {
             'fiscal_year' 	: $('#fiscal_year').val()
        ,    'employee_cd' 	: $('#employee_cd').val()
        ,    'start_date' 	: $('#start_date').val()
        ,    'finish_date' 	: $('#finish_date').val()
        ,    'time_to' 	    : $('#time_to').val()
        ,    'time_from' 	: $('#time_from').val()
        };
		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/oneonone/oq2020/search',
    		dataType	:	'html',
    		loading     :   true,
    		data        :   data,
            success: function(res) {
                $('#result').empty();
                $('#result').append(res);
                $('.button-card').click();
                app.jSticky();
                app.jTableFixedHeader();
                jQuery.initTabindex();
                jQuery.formatInput();
                // checkEmp();
            }
		});
	}catch(e){
		alert('search: ' + e.message);
	}
}
/**
 * save
 *
 * @author      :   nghianm - 2020/10/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        data.data_sql['target1_nm'] = $('#generic_comment_1').val();
        data.data_sql['target2_nm'] = $('#generic_comment_2').val();
        data.data_sql['target3_nm'] = $('#generic_comment_3').val();
        data.data_sql['comment'] 	= $('#generic_comment_4').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oq2020/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // location.reload();
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
 * callback search after blur employee
 *
 * @author      :  vietdt - 2021/03/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function afterBlurEmployeeCd(_this) {
    search();
}