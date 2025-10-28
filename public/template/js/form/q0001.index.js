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
    'company_cd'            : {'type':'text', 'attr':'id'},
    'company_nm'            : {'type':'text', 'attr':'id'},
    'detail_no'             : {'type':'text', 'attr':'id'},
    'incharge_cd'           : {'type':'text', 'attr':'id'},
    'evaluation_contract'    : {'type':'select', 'attr':'id'},
    'oneonone_contract'    : {'type':'select', 'attr':'id'},
    'multiview_contract'    : {'type':'select', 'attr':'id'},
    'check_account'	        : {'type':'checkbox', 'attr':'id'},
    'year_month'            : {'type':'text', 'attr':'id'},
 };
 $(function(){
     try {
        initEvents();
        initialize();
    }catch(e){
        alert('initialize: ' + e.message);
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
        $('#search_company').trigger('click');
        tableContent();
        jQuery.initTabindex();
    } catch(e){
        alert('initialize: ' + e.message);
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
    try{
        $(document).on('click','#search_company',function(){
            var page        = $('#history_page').val();
            var page_size   = $('#history_page_size').val();
            refer(page,page_size)
        })
    }catch(e){
        alert('initialize: ' + e.message);
    }
    $(document).on('blur','#employee_nm',function(){
       if($(this).val() == ''){
           $('#incharge_cd').val('');
       }
    })

     $(document).on('click', '.pagination li a.page-link:not(.pagging-disable)', function(e) {
     //alert(1);
     e.preventDefault();
     var li  = $(this).closest('li'),
             page =li.find('a').attr('page');
     $('.pagination li').removeClass('active');
     li.addClass('active');
     var cb_page = $('#cb_page').find('option:selected').val();
     var cb_page = cb_page == '' ? 1 : cb_page;
     refer(page,cb_page);
     });
     $(document).on('change', '#cb_page', function(e) {
        var li  = $('.pagination li.active'),
            page =li.find('a').attr('page');
        var cb_page = $(this).val();
        var cb_page = cb_page == '' ? 20 : cb_page;
        refer(page,cb_page);
     });
     $(document).on('click','#btn-add-new',function(e) {
        try {
            e.preventDefault();
            var data = {};
            var li  = $('.pagination li.active');
            var page =li.find('a').attr('page');
            var cb_page = $('#cb_page').find('option:selected').val();
            var cb_page = cb_page == '' ? 1 : cb_page;
            data.company_cd              = $('#company_cd').val();
            data.company_nm              = $('#company_nm').val();
            data.incharge_cd             = $('#incharge_cd').val();
            data.contract_attribute      = $('#contract_attribute').val();
            data.year_month              = $('#year_month').val();
            data.employee_nm             = $('#employee_nm').val();
            data.page                    = page;
            data.page_size               = cb_page;
            data.screen_id = 'q0001';
           // localStorage['myKey'] = JSON.stringify(data);
            // setCache(data);
            // location.href='/master/m0001';
            var url = _customerUrl('master/m0001');
            setCacheCustomer(data, url);
        } catch (e) {
            alert('#btn-add-new' + e.message);
        }
    });
    $(document).on('click','#btn-print',function() {
    try {
        outputCsv();
    } catch (e) {
        alert('click checked ' + e.message);
    }
    });
    // $(document).on('click','.link a',function(e) {
    //  e.preventDefault();
    //  var obj = '';
   //      var company_cd = $(this).parents('td').find('.company_cd').val();
    //  var company_cd1 = $('#company_cd').val();
    //  var company_nm = $('#company_nm').val();
    //  var incharge_cd = $('#incharge_cd').val();
    //  var contract_attribute = $('#contract_attribute').val();
   //      var year_month          = $('#year_month').val();
   //      var employee_nm          = $('#employee_nm').val();
    //  obj = '/master/m0001?company_cd='+company_cd+'&company_cd1='+company_cd1+'&company_nm='+company_nm+'&incharge_cd='+incharge_cd+
   //              '&contract_attribute='+contract_attribute+'&year_month='+year_month+'&employee_nm='+employee_nm
    //  location.href = obj;

    // });
        $(document).on('click','.link a',function(e) {
        e.preventDefault();
        var data = {};
        var li  = $('.pagination li.active');
        var page =li.find('a').attr('page');
        var cb_page = $('#cb_page').find('option:selected').val();
        var cb_page = cb_page == '' ? 1 : cb_page;
        data.company_cd_refer        = $(this).parents('td').find('.company_cd').val();
        data.company_cd              = $('#company_cd').val();
        data.company_nm              = $('#company_nm').val();
        data.incharge_cd             = $('#incharge_cd').val();
        data.contract_attribute      = $('#contract_attribute').val();
        data.year_month              = $('#year_month').val();
        data.employee_nm             = $('#employee_nm').val();
        data.page                    = page;
        data.page_size               = cb_page;
        data.screen_id = 'q0001';
       // localStorage['myKey'] = JSON.stringify(data);
        // setCache(data);
        // location.href='/master/m0001';
        var url = _customerUrl('master/m0001');
        setCacheCustomer(data, url);
        });

     //change #check_account
     $(document).on('change','#check_account',function () {
         try{
             if($(this).is(":checked")){
                 $(this).val(1);
             }else{
                 $(this).val(0);
             }
         }catch(e){
             alert('change check_account' + e.message);
         }
     })
 }

 function refer(page,page_size){
    var data    = {};
        if(typeof page =='undefined' || page == '') {
                var page = 1;
        }
        if(typeof page_size =='undefined' || page_size == '') {
                var page_size = 20;
        }
        data.company_cd          =   $('#company_cd').val();
        data.company_nm          =   $('#company_nm').val();
        data.detail_no           =   $('#detail_no').val();
        data.incharge_cd         =   $('#incharge_cd').val();
        data.incharge_nm         =   $('#employee_nm').val();
        data.evaluation_contract =   $('#evaluation_contract').val();
        data.oneonone_contract   =   $('#oneonone_contract').val();
        data.multiview_contract  =   $('#multiview_contract').val();
        data.report_contract     =   $('#report_contract').val();
        data.check_account       =   $('#check_account').val();
        data.year_month          =   $('#year_month').val();
        data.page                =   page;
        data.page_size           =   page_size;
        var url = _customerUrl('master/q0001/refer');
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'html',
            loading     :   true,
            data        :   data,
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                $('#result').empty();
                $('#result').append(res);
                if(!$('#search-box').hasClass('hide')){
                    $('#company_cd').focus();
                }
                $('[data-toggle="tooltip"]').tooltip();
                app.jTableFixedHeader();
                tableContent();
                $('.wmd-view').css('height','500px')
                _formatTooltip();
                jQuery.initTabindex();
            }
            }
        });
    }

    function outputCsv() {
    try {
        var data = getData(_obj);
        var url = _customerUrl('master/q0001/outputcsv');
        $.ajax({
            type        :   'POST',
            url         :   url,
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                    //location.reload();
                        // var returnRes       =   JSON.parse(res);
                        var filedownload    =   res['FileName'];
                        if (filedownload != '') {
                            if ($('#language_jmessages').attr('value')) {
                                downloadfileHTML(filedownload ,'CustomerList.csv' , function () {
                                    //
                                });
                                } else {
                                    downloadfileHTML(filedownload ,'顧客一覧.csv' , function () {
                                        //
                                    });
                                }
                        } else{
                            jError(2);
                        }

                        break;
                    // error
                    case NG:
                        jMessage(21);
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
        alert('outputcsv:' + e.message);
    }
}
/**
 * save
 *
 * @author      :   longvv - 2018/09/06 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteFile(fileName) {
    try {
        // var data = getData(_obj);
        var url = _customerUrl('master/q0001/deletetemp');
        $.ajax({
            type        :   'POST',
            url         :   url,
            dataType    :   'json',
            loading     :   false,
            data        :   {fileName:fileName},
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                    //location.reload();
                        // var returnRes       =   JSON.parse(res);
                        jMessage(7, function(r) {
                            // do something
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
        alert('deleteFile:' + e.message);
    }
}
function tableContent() {
	$(".wmd-view-topscroll").scroll(function () {
		$(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
	});

	$(".wmd-view").scroll(function () {
		$(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
	});

	fixWidth();

	$(window).resize(function () {
		fixWidth();
	});

}
function fixWidth() {
	var w = $('.wmd-view .table').outerWidth();
	var f = $('.table-group li:last').outerWidth();
	$(".wmd-view-topscroll .scroll-div1").width(w);
	// $(".table-group li:last .fixed").width(f);
}