/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/10/26
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : url customer
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _mode = 0;
var _obj = {
 	'refer_kbn'                 :   {'type':'hidden'    , 'attr':'id'}
,   'refer_questionnaire_cd'    :   {'type':'hidden'    , 'attr':'id'}
,   'questionnaire_cd'          :   {'type':'hidden'    , 'attr':'id'}
,	'questionnaire_nm'          :   {'type':'text'      , 'attr':'id'}
,   'submit'					:   {'type':'radiobox'  , 'attr':'id','name':'submit'}
,   'comment_use_typ'           :   {'type':'hidden'    , 'attr':'id'}
,   'purpose'                   :   {'type':'text'      , 'attr':'id'}
,   'purpose_use_typ'           :   {'type':'text'      , 'attr':'id'}
,   'complement'                :   {'type':'text'      , 'attr':'id'}
,   'complement_use_typ'        :   {'type':'text'      , 'attr':'id'}
,   'company_cd_refer'          :   {'type':'text'      , 'attr':'id'}
,	'browsing_setting'          :   {'attr' : 'list', 'item' : {
            'questionnaire_gyono'       : {'type' : 'text'      , 'attr' : 'class'}
        ,   'question'                  : {'type' : 'text'      , 'attr' : 'class'}
        ,   'question_typ'              : {'type' : 'text'      , 'attr' : 'class'}
        ,   'sentence_use_typ'          : {'type' : 'select'    , 'attr' : 'class'}
        ,   'points_use_typ'            : {'type' : 'select'    , 'attr' : 'class'}
        ,   'guideline_10point'         : {'type' : 'select'    , 'attr' : 'class'}
        ,   'guideline_5point'          : {'type' : 'select'    , 'attr' : 'class'}
        ,   'guideline_0point'          : {'type' : 'select'    , 'attr' : 'class'}
        },
    },
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
 * @author      :   nghianm - 2020-09-08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function initialize() {
	try{
        $('#btn-save').attr('tabindex', 9);
		$('#questionnaire_nm').focus();
        $('#radio-1').attr('checked','true');
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   nghianm - 2020-10-26 - create
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
                alert('change-search_key: ' + e.message);
            }
        });
        $(document).on('enterKey', '#search_key', function(e) {
            try{
                var page = 1;
                var search = $('#search_key').val();
                getLeftContent(page, search);
            } catch(e){
                alert('enterKey-search_key: ' + e.message);
            }
        });
		// click 評価シート
       	$(document).on('click', '.ics-eye', function (e) {
            try{
                $(this).closest('.row').hide();
                $(this).closest('.row').find('input').val('0');
            } catch(e){
                alert('ics-eye: ' + e.message);
            }
	   	});
       	$(document).on('click','.btn-remove-row',function () {
            try{
                var count = $('#table-data tbody tr').length;
                if (count <= 1) { 
                    jMessage(29);
                    return false;
                }
                else {
                    $(this).parents('tr').remove();
                }
                var length_table = $("#table-data tbody tr").length;
                for(var i=1;i<=length_table;i++){
                    $("#table-data tbody tr:eq("+(i-1)+")").find('.questionnaire_gyono').val(i);
                }
            } catch(e){
                alert('btn-remove-row: ' + e.message);
            }
	   	});
	   	$(document).on('click','.show-all',function () {
            try{
                $(".show-all-table").removeClass('hidden');
                $(".show-all-table").show();
                $(".show-all-table").find('input').val('1');
            } catch(e){
                alert('btn-show-all: ' + e.message);
            }
	   	});
        //btn-add-row
        $(document).on('click','#btn-add-row',function () {
            try{
                var row = $("#table-target-1 tbody tr:nth-child(1)").clone();
                $("#table-data tbody").find('tr:last').after(row);
                $('#table-data tbody tr:last').addClass('browsing_setting');
                $('#table-data tbody tr:last').find('.questionnaire_gyono').val($("#table-data tbody tr").length);
                $('#table-data').find('tbody tr:last td:first-child input').focus();
            } catch(e){
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-add-new
        $(document).on('click', '#btn-add-new', function (e) {
            try {
                jMessage(5, function (r) {
                    if (r) {
                        _mode = 0;
                        var page = $('#leftcontent').find('.active a').attr('page');
                        var search = $('#search_key').val();
                        getLeftContent(page, search);
                        clearData();
                    }
                });
            } catch (e) {
                alert('#btn-add-new: ' + e.message);
            }
        });
        //score_no
		$(document).on('click','.score_no',function () {
            try{
                var score_no = $(this).val();
                if(score_no ==2){
                    $(this).closest('tr').find('.score-block').addClass('hidden');
                } else if(score_no ==1){
                    $(this).closest('tr').find('.score-block').removeClass('hidden');
                }
            } catch(e){
                alert('btn-ascore_no: ' + e.message);
            }
		});
		 /* left content click item */
	    $(document).on('click', '.list-search-child', function(e) {
            try{
                _mode = 1;
                $('.list-search-child').removeClass('active');
                $('#rightcontent .calHe').removeClass('has-copy');
                $(this).addClass('active');
                getRightContent($(this).attr('id'), $(this).attr('company_cd'), $(this).attr('contract_company_attribute'));
            } catch(e){
                alert('btn-list-search: ' + e.message);
            }
	    });
	    $(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                    else {
                        $('.num-length').removeClass('td-error');
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
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
                alert('btn-delete: ' + e.message);
            }
        });
        //btn-copy
        $(document).on('click','#btn-copy',function(e) {
           try{
                e.preventDefault();
                $('#questionnaire_nm').val('');
                $('#rightcontent .calHe').addClass('has-copy');
                _mode = 0;
            } catch(e){
                alert('btn-copy: ' + e.message);
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
        var url = _customerUrl('/oneonone/om0400/leftcontent');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url, 
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
 * @author      :   nghianm - 2020/10/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(questionnaire_cd, company_cd, contract_company_attribute) {
    try {
        // send data to post
        var url = _customerUrl('/oneonone/om0400/rightcontent');
        $.ajax({
            type        :   'POST',
            url         :   url, 
            dataType    :   'html',
            // loading     :   true,
            data        :   {questionnaire_cd: questionnaire_cd,
                            company_cd: company_cd},
            success: function(res) {
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                _formatTooltip();
                $('#item_nm').focus();
                if (company_cd == '0' && contract_company_attribute !=='1') {
                    $('.dropdown-item-delete').parent('li').hide(); //pc
                    $('.dropdown-item-delete').hide();              //mobile
                } else {
                    $('.dropdown-item-delete').parent('li').show(); //pc
                    $('.dropdown-item-delete').show();              //mobile
                }
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
 * @author      :   nghianm - 2020/10/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        var array_check = data.data_sql.browsing_setting
        var check = 0;
        for(var i=0;i<array_check.length;i++) {{
            if(array_check[i].question==''){
                check = check + 1;
            }
        }}
        if(check == array_check.length){
            jMessage(116, function(r) {
                // do something
            });
            return;
        }
        if($('.show-all-table #purpose_use_typ').val()==0) {
            $('.show-all-table #purpose').val('')
        }
        if($('.show-all-table #complement_use_typ').val()==0) {
            $('.show-all-table #complement').val('')
        }
        var company_cd_refer = $('#company_cd_refer').val();
        var contract_company_attribute = $('#contract_company_attribute').val();
        // var mode_check_mc = $('#mode').val();
        if(company_cd_refer==0 && contract_company_attribute != 1) {
            _mode = 0;
        } 
        data.data_sql['mode'] = _mode;
        var url = _customerUrl('/oneonone/om0400/save');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // do something
                            // location.reload();
                            _mode = 0;
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            clearData();
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
 * @author      :   nghianm - 2020/10/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var questionnaire_cd        = $('#questionnaire_cd').val();
        var company_cd_refer        = $('#company_cd_refer').val();
        var company_cd_login        = $('#company_cd_login').val();
        var contract_company_attribute = $('#contract_company_attribute').val();
        if(contract_company_attribute != 1 && company_cd_refer=='0'){
            jMessage(122, function(r) {
                // do something
            });
            return;
        }
        if(_mode == 0){
           jMessage(21, function(r) {
                // do something
            });
            return; 
        }
        var url = _customerUrl('/oneonone/om0400/del');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'json',
            loading     :   true,
            data        :   {questionnaire_cd: questionnaire_cd},
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            // do something
                            _mode = 0;
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            clearData();
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
        alert('delete' + e.message);
    }
}

/**
 * clearData
 *
 * @author      :   vietdt - 2021/03/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function clearData() {
    $('#questionnaire_nm, #purpose, #complement,#questionnaire_cd,#refer_questionnaire_cd,#refer_kbn,#mode').val('');
    $('.show-all').trigger('click');
    $('#radio-1').prop("checked", true);
    var row = $("#table-target-1 tbody tr:nth-child(1)").clone();
    $("#table-data tbody").empty();
    $("#table-data tbody").append(row);
    $('#table-data tbody tr:last').addClass('browsing_setting');
    $('#table-data tbody tr:last').find('.questionnaire_gyono').val($("#table-data tbody tr").length);
    $('#questionnaire_nm').focus();
}