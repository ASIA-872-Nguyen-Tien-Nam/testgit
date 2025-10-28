/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/25
 * 作成者          :   longvv – longvv@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'report_kind'               : {'type' : 'select', 'attr' : 'id'},
    'question_no'               : {'type' : 'text', 'attr' : 'id'},
    'question_title'            : {'type' : 'text', 'attr' : 'id'},
    'arrange_order'             : {'type' : 'text', 'attr' : 'id'},
    'question'                  : {'type' : 'text', 'attr' : 'id'},
    'answer_kind'               : {'type' : 'select', 'attr' : 'id'},
    'item_digits'               : {'type' : 'text', 'attr' : 'id'},
    'answer_kbn'                : {'type' : 'select', 'attr' : 'id'},
    'company_cd_refer'                : {'type' : 'select', 'attr' : 'id'},
	'm4126': {
		'attr': 'list', 'item': {
			'detail_no': { 'type': 'text', 'attr': 'class' },
			'detail_name': { 'type': 'text', 'attr': 'class' },
		}
	}
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
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('#report_kind').focus();
        _formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   longvv - 2018/06/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
    $(document).on('click', '#btn-new-signup', function(e) {
        jMessage(5,function(){
            loadRight();
        })
    });
    $(document).on('change', '#report_kind', function(e) {
        loadRight();
    });
    $(document).on('click', '.btn-save', function(e) {
        jMessage(1, function (r) {
            if (r && _validate($('body'))) {
                saveData();
            }
        });
    });
    $(document).on('click', '#btn-delete', function(e) {
        jMessage(3, function(r) {
            deleteData();
        });
    });
    $(document).on('click', '#btn-back', function(e) {
            // window.location.href = 'rdashboard';
            var home_url = $('#home_url').attr('href');
            _backButtonFunction(home_url);
            
    });
     //add new row
     $(document).on('click', '#add_new_row', function(){
        tableAddRow();
    });
    // Remove row
    $(document).on('click', '.btn_remove', function(){
        $(this).closest('tr').remove();
    });
    //
    $(document).on('click', '.level1', function(){ 
        var value = $(this).attr('data-type')
        $( '.level2' ).each(function(){
            if($(this).attr('data-type') == value){
                $(this).css('display') == 'block' ? $(this).hide() : $(this).show()  
            }    
        })  
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
    $(document).on('click', '.list-search-content .level2', function (e) {
        try {
            var company_cd = $(this).attr('data-company');
            var report_kind = $(this).attr('data-report');
            var question_no = $(this).attr('data-question');
            var contract_company_attribute = $(this).attr('contract_company_attribute');
            getRightContent(company_cd, report_kind, question_no, contract_company_attribute);
        } catch (e) {
            alert('list-search-child-refer: ' + e.message);
        }
    });
    //
    $(document).on('change', '#answer_kind', function (e) {
        try {
            tableInput();
        } catch (e) {
            alert('answer_kind: ' + e.message);
        }
    });
    $(document).on('blur', '#item_digits', function (e) {
        try {
            if(parseInt($('#item_digits').val())>1200) {
                $('#item_digits').val('');
            }
        } catch (e) {
            alert('item_digits: ' + e.message);
        }
    });

  }catch(e) {
    console.log( 'initEvents' + e.stack);
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
        var url = customerUrl('/weeklyreport/rm0100/leftcontent');
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
function getRightContent( company_cd, report_kind, question_no, contract_company_attribute) {
    try {
        var company_cd_mc = $('#company_cd_mc').val();
        var url = customerUrl('/weeklyreport/rm0100/rightcontent');
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'html',
            loading: true,
            data: {company_cd: company_cd, report_kind: report_kind, question_no: question_no },
            success: function (res) {
                $('#rightcontent .inner').empty().append(res);
                if (company_cd == company_cd_mc && contract_company_attribute !== '1') {
                    $('.dropdown-item-delete').parent('li').hide(); //pc
                    $('.dropdown-item-delete').hide();              //mobile
                }else{
                    $('.dropdown-item-delete').parent('li').show(); //pc
                    $('.dropdown-item-delete').show();              //mobile
                }
                //
                $('#report_kind').focus();
                tableInput();

                $.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * saveData
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);
        // send data to post
        $.ajax({
            type: 'POST',
            url: customerUrl('/weeklyreport/rm0100/save'),
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function () {
                            getLeftContent(1, '');
                            loadRight();
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
                    case 999:
                        processError(res['errors']);
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
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.report_kind        = $('#report_kind').val();
        data.question_no        = $('#question_no').val();
        data.company_cd_refer   = $('#company_cd_refer').val();
        var url = customerUrl('/weeklyreport/rm0100/delete');
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(4, function () {
                            getLeftContent(1, '');
                            loadRight();
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
        alert('delete' + e.message);
    }
}
/**
 * tableInput
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function tableInput() {
    try {
        if($('#answer_kind').val()==3)
        {   
            $('#table-input').removeClass('d-none');
            $('#item_digits').val('');
            $('#item_digits').removeClass('required');
            $('#item_digits').attr("readonly","readonly");
        }else{
            $('#table-input').addClass('d-none');
            $('#item_digits').removeAttr('readonly');
            $('#item_digits').addClass('required');
        }
    } catch (e) {
        alert('delete' + e.message);
    }
}
/**
 * tableAddRow
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function tableAddRow() {
    try {
        var html = $('#table_row_add').find('tbody').html();
        var max = 0;
        var max_detail_no = 0;
        $('#main tr').each(function(){
            var val = $(this).find('.grade_id').val();
            var detail_no_row =  $(this).find('.detail_no').val();
            if( val != undefined && val*1 > max*1){
                max = val;
            }else if(val == undefined){
                max = 1;
            }
            if( detail_no_row != undefined && detail_no_row*1 > max_detail_no*1){
                max_detail_no = detail_no_row;
            }else if(detail_no_row == undefined){
                max_detail_no = 1;
            }
        })
        $('#table_data').find('tbody').append(html.replace('<tr>', '<tr class="tr m4126">'));
        $('#main tr').last().find('.grade_id').val(max * 1 + 1);
        $('#main tr').last().find('.detail_no').val(max_detail_no*1 + 1);
        $('#main tr').last().find('.grade').attr('tabindex', (max*1 + 1)*3-3+9);    //quangnd đánh tabindex
        $('#main tr').last().find('.grade_nm').attr('tabindex', (max*1 + 1)*3-2+9);
        $('#main tr').last().find('.btn_remove').attr('tabindex', (max*1 + 1)*3-1+9);
        $('#main tr').last().find('.grade').focus();
        $.formatInput();
    } catch (e) {
        alert('delete' + e.message);
    }
}
/**
 * _customerUrl()
 *
 * @author  :   namnt - 2022/04/22 - create
 * @param 	:	String
 * @result 	:	string
*/
function customerUrl(url) {
	var segments = window.location.href.split('/');
	if (segments[3] == 'customer') {
		var url = '/customer' + url;
	};
	return url;
}
/**
 * loadRight
 *
 * @author      :   quangnd - 2023/04/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function loadRight() {
    try {
        $('#company_cd_refer').val('-1');
        $('#question_no').val('-1');
        $('#question_title').val('');
        $('#arrange_order').val('');
        $('#question').val('');
        $('#answer_kind').val(1);
        $('#item_digits').val('');
        $('#answer_kbn').val(1); 
        $('.div_loading').show();
        tableInput();
        $('#table_data').find('tbody').empty();
        tableAddRow();
        $('#report_kind').focus();
        setTimeout(() => {
            $('.div_loading').hide();
        }, 500);
    } catch (e) {
        alert('delete' + e.message);
    }
}
