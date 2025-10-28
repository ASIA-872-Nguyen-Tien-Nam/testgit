/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		:	2018/06/22
 * 作成者		:	quyentb – quyentb@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _rank_cd = 0;
var _unit_display = 0;
var _export = 0;
$(function(){
    initEvents();
    initialize();
});
/**
 * initialize
 *
 * @author    : sondh - 2018/10/11 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
    try {
        $('#fiscal_year').trigger('change');
        $('#evaluation_step').trigger('change');
        jQuery.initTabindex();
				_formatTooltip();

    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/**
 * initialize
 *
 * @author      :   quyentb - 2018/06/22 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents(){
    try {
        //
        $(document).on('change', '#evaluation_step', function () {
            try{
                if($(this).val()==5){
                    $('#select_target_1  option[value="5"]').hide();
                    if($('#select_target_1').children("option:selected").val()==5){
                        $('#select_target_1  option[value="1"]').prop("selected", true);
                    }
                }else{
                    $('#select_target_1  option[value="5"]').show();
                }
            }catch(e){
                alert('#evaluation_step' + e.message);
            }
        });
        //
        $(document).on('click', '[data-toggle]', function(){
            var target = $(this).data('target');
            $(target).toggleClass('fl')
        });
        //change fiscal_year
        $(document).on('change','#fiscal_year', function (e) {
            try {
                referData();
            } catch (e) {
                alert('#fiscal_year :' + e.message);
            }
        });
        //change btn-search
        $(document).on('click','#btn-search', function (e) {
            try {
                search();
            } catch (e) {
                alert('#btn-search :' + e.message);
            }
        });
        $(document).on('click','.page-item:not(.active):not(.disaled):not([disabled])', function (e) {
            try {
                e.preventDefault();
                $('.page-item').removeClass('active');
                $(this).addClass('active')
                var page = $(this).attr('page');
                var cb_page = $('#cb_page').find('option:selected').val();
                var cb_page = cb_page == '' ? 1 : cb_page;
                search(page,cb_page);
            } catch (e) {
                alert('#btn-search :' + e.message);
            }
        });
        $(document).on('change', '#cb_page', function (e) {
            e.preventDefault();
            var li  = $('.pagination li.active'),
                page =li.find('a').attr('page');
            var cb_page = $(this).val();
            var cb_page = cb_page == '' ? 20 : cb_page;
            search(page,cb_page);
        });
        //
        $(document).on('click','.page-father .page-item:not(.active):not(.disaled):not([disabled])',function(e) {
            e.preventDefault();
            $('.page-item').removeClass('active');
            $(this).addClass('active')
            var page = $(this).attr('page');
            var cb_page = $('#cb_page').find('option:selected').val();
            var cb_page = cb_page == '' ? 1 : cb_page;
            search(page,cb_page);
        });
        //
        $(document).on('change', '.page-father #cb_page', function(e) {
            var li  = $('.pagination li.active'),
                page =li.find('a').attr('page');
            var cb_page = $(this).val();
            var cb_page = cb_page == '' ? 20 : cb_page;
            search(page,cb_page);
        });
        //data_td
        $(document).on('click','.data_td', function (e) {
            try {
                var tr = $(this).closest('tr.tr_data');
                var unit_display = tr.find('.unit_display').val();
                var rank_cd = $(this).find('.rank_cd').val();
                _rank_cd = rank_cd;
                _unit_display = unit_display;
                referDetail(_unit_display,_rank_cd);
            } catch (e) {
                alert('.data_td :' + e.message);
            }
        });
        //
        $(document).on('click','.page-detail .page-item:not(.active):not(.disaled):not([disabled])',function(e) {
            e.preventDefault();
            $('.page-item').removeClass('active');
            $(this).addClass('active')
            var page = $(this).attr('page');
            var cb_page = $('#cb_page').find('option:selected').val();
            var cb_page = cb_page == '' ? 1 : cb_page;
            referDetail(_unit_display,_rank_cd,page,cb_page);
        });
        //
        $(document).on('change', '.page-detail #cb_page', function(e) {
            var li  = $('.pagination li.active'),
                page =li.find('a').attr('page');
            var cb_page = $(this).val();
            var cb_page = cb_page == '' ? 20 : cb_page;
            referDetail(_unit_display,_rank_cd,page,cb_page);
        });
        //btn-print
        $(document).on('click','#btn-print', function (e) {
            try {
                if(_export == 1){
                    exportData();
                }else{
                    jMessage(21);
                }
            } catch (e) {
                alert('#btn-print :' + e.message);
            }
        });
        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            // window.location.href = '/dashboard'
            if(_validateDomain(window.location)){
                window.location.href = '/dashboard';
            }else{
                if ($('#language_jmessages').val() == 'en') {
                    jError('Error','This protocol or host domain has been rejected.');
                }else{
                    jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                }
            }
        });
        //
        $(document).on('click','.link_i2040',function(){
            let employee_cd = $(this).text();
            let employee_nm = $(this).closest('tr').find('.employee_nm').text();
            let fiscal_year = $('#fiscal_year').val();
            let treatment_applications_no = $('#treatment_applications_no').val();
            var data = {
                    'employee_cd_refer'       	:  employee_cd
                ,   'employee_nm_refer'       	:  employee_nm
                ,	'from'						:	'q2030'
                ,   'fiscal_year'               :   fiscal_year
                ,   'treatment_applications_no' :   treatment_applications_no
            };
            _redirectScreen('/master/i2040',data,true);
        });
    } catch (e) {
        alert('initEvents' + e.message);
    }
}
/**
 * refer
 *
 * @author      :   sondh - 2018/10/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referData(){
    try{
        var fiscal_year = $('#fiscal_year').val();
        //
        $.ajax({
            type: 'POST',
            url: '/master/q2030/refer',
            dataType: 'html',
            loading: false,
            data: {fiscal_year: fiscal_year},
            success: function (res) {
                $('#treatment_applications_no').empty();
                $('#treatment_applications_no').append(res);
                $.formatInput();
            }
        });
    }catch(e){
        alert('referData' + e.message);
    }
}
/**
 * search
 *
 * @author      :   sondh - 2018/10/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function search(page,page_size){
    try{
        if(typeof page == 'undefined') {
            var page = 1;
        }
        if(typeof page_size =='undefined') {
            var page_size = 20;
        }
        var data = {};
        var fiscal_year = $('#fiscal_year').val();
        var treatment_applications_no = $('#treatment_applications_no').val();
        var evaluation_step = $('#evaluation_step').val();
        var select_target_1 = $('#select_target_1').val();
        var organization_cd = $('#organization_cd').val();
        data.fiscal_year = fiscal_year;
        data.treatment_applications_no = treatment_applications_no;
        data.evaluation_step = evaluation_step;
        data.select_target_1 = select_target_1;
        data.organization_cd = organization_cd;
        data.page_size = page_size;
        data.page = page;
        //
        $.ajax({
            type: 'POST',
            url: '/master/q2030/search',
            dataType: 'html',
            loading: true,
            data: data,
            success: function (res) {
                $('#result1').empty();
                $('#result1').append(res);
                $('#result2').empty();
                $.formatInput();
                _formatTooltip();
                jQuery.initTabindex();
                _export = 0;
            }
        });
    }catch(e){
        alert('search' + e.message);
    }
}
/**
 * referDetail
 *
 * @author      :   sondh - 2018/10/12 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referDetail(unit_display,rank_cd,page,page_size){
    try{
        if(typeof page == 'undefined') {
            var page = 1;
        }
        if(typeof page_size =='undefined') {
            var page_size = 20;
        }
        var data = {};
        var fiscal_year = $('#fiscal_year').val();
        var treatment_applications_no = $('#treatment_applications_no').val();
        var evaluation_step = $('#evaluation_step').val();
        var select_target_1 = $('#select_target_1').val();
        var organization_cd = $('#organization_cd').val();
        data.fiscal_year = fiscal_year;
        data.treatment_applications_no = treatment_applications_no;
        data.evaluation_step = evaluation_step;
        data.select_target_1 = select_target_1;
        data.organization_cd = organization_cd;
        data.unit_display = unit_display;
        data.rank_cd = rank_cd;
        data.page_size = page_size;
        data.page = page;
        //
        $.ajax({
            type: 'POST',
            url: '/master/q2030/referdetail',
            dataType: 'html',
            loading: true,
            data: data,
            success: function (res) {
                if(res != ''){
                    $('#result2').empty();
                    $('#result2').append(res);
                    $.formatInput();
                    _formatTooltip();
                    _export = 1;
                }else{
                    $('#result2').empty();
                }
            }
        });
    }catch(e){
        alert('referDetail' + e.message);
    }
}
/**
 * exportCsv
 *
 * @author      :   sondh - 2018/10/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function exportData() {
    try{
        var data = {};
        var fiscal_year = $('#fiscal_year').val();
        var treatment_applications_no = $('#treatment_applications_no').val();
        var evaluation_step = $('#evaluation_step').val();
        var select_target_1 = $('#select_target_1').val();
        var organization_cd = $('#organization_cd').val();
        data.fiscal_year = fiscal_year;
        data.treatment_applications_no = treatment_applications_no;
        data.evaluation_step = evaluation_step;
        data.select_target_1 = select_target_1;
        data.organization_cd = organization_cd;
        data.unit_display = _unit_display;
        data.rank_cd = _rank_cd;
        //
        $.ajax({
            type: 'POST',
            url: '/master/q2030/export',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        var csv_name = '';
                        csv_name = '評価分析.csv';
                        if ($('#language_jmessages').val() == 'en') {
                            csv_name = 'EvaluationAnalysis.csv';
                        }
                        //
                        var filedownload    =   res['FileName'];
                        if(filedownload != ''){
                            downloadfileHTML(filedownload ,csv_name , function () {
                                //
                            });
                        } else{
                            jError(2);
                        }
                        break;
                    // error
                    case NG:
                        jError(res['message']);
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
    }catch(e){
        alert('exportData:' + e.message);
    }
}