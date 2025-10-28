/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2023/02/09
 * 作成者		    :	quangnd – quangnd@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
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
 * @author		:	quangnd - 2023/02/09 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
		jQuery.initTabindex();
        app.jTableFixedHeader();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	quangnd - 2023/02/09 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
        $(document).on('click','.popup-detail',function(){
            try{
                var value = $(this).text();
                var value_no = $(this).attr('question_no');
                parent.$('.search-cate-active .question').val(value.trim());
                parent.$('.search-cate-active .question').removeAttr('readonly');
                parent.$('.search-cate-active .question_no').val(value_no);
                parent.$.colorbox.close();
                parent.$('body').css('overflow','auto');
            } catch(e){
                alert('popup-detai: ' + e.message);
            }
        });
        $(document).on('click','.popup-detail_previous',function(){
            try{
                $(this).closest('tr').find('.popup-detail').trigger('click')
            } catch(e){
                alert('popup-detai: ' + e.message);
            }
        });
        $(document).on('click','.popup-detail_after',function(){
            try{
                $(this).closest('tr').find('.popup-detail').trigger('click')
            } catch(e){
                alert('popup-detai: ' + e.message);
            }
        });
		//
		$(document).on('click', '#btn-close-popup', function() {
			parent.$.colorbox.close();
			parent.$('body').css('overflow','auto');
			//parent.location.reload();; iss /redmine/attachments/download/41936/10.png
		});
        //
		$(document).on('click', '#popup-paging-rquestion .pagination li a.page-link:not(.pagging-disable)', function (e) {
            try{
                //alert(1);
                e.preventDefault();
                var li = $(this).closest('li'),
                    page = li.find('a').attr('page');
                $('.pagination li').removeClass('active');
                li.addClass('active');
                var cb_page = $('#cb_page').find('option:selected').val();
                var cb_page = cb_page == '' ? 1 : cb_page;
                searchReportQuestion(page, cb_page);
            } catch(e){
                alert('#popup-paging-rquestion: ' + e.message);
            }
		});
        //
        $(document).on('change', '#popup-paging-rquestion #cb_page', function (e) {
            try{
                var li = $('.pagination li.active'),
                    page = li.find('a').attr('page');
                var cb_page = $(this).val();
                var cb_page = cb_page == '' ? 20 : cb_page;
                searchReportQuestion(page, cb_page);
            } catch(e){
                alert('#popup-paging-rquestion: ' + e.message);
            }
		});
   	} catch(e){
        alert('initEvents: ' + e.message);
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
function searchReportQuestion( page, page_size) {
    try {
        var report_kind = $('#report_kind_popup').val();
        $.ajax({
            type: 'POST',
            url: '/common/popup/rquestion/search',
            dataType: 'html',
            loading: true,
            data: {report_kind: report_kind, page: page, page_size: page_size},
            success: function (res) {
                $('#popup-rquestion').empty().append(res);
            }
        });
    } catch (e) {
        alert('searchReportQuestion: ' + e.message);
    }
}