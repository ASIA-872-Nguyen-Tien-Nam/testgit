/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
    	$('#category1_cd').focus();
		jQuery.initTabindex();
        app.jTableFixedHeader();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
   try{
    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
        try{
        var page = $(this).attr('page');
        var page_size   =    $('#cb_page').find('option:selected').val();
            searchQuestion(page,page_size);
        }catch (e) {
            alert('li.page-prev a.page-link:not(.pagging-disable): '+ e.message);
        }
    });
    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
        try{
            var page = $(this).attr('page');
            var page_size   = $('#cb_page').find('option:selected').val();
            searchQuestion(page,page_size);
        }catch (e) {
            alert('li.page-next a.page-link:not(.pagging-disable): '+ e.message);
        }
    });
    $(document).on('change', '#cb_page', function(e) {
        var li  = $('.pagination li.active'),
            page =li.find('a').attr('page');
        var page_size = $(this).val();
        var page_size = page_size == '' ? 20 : page_size;

        searchQuestion(page,page_size);
   });
    $(document).on('click','.popup-detail',function(){
        try{
            var value = $(this).text();
            parent.$('.search-cate-active .question').val(value.trim());
            parent.$.colorbox.close();
			parent.$('body').css('overflow','auto');
        } catch(e){
            alert('popup-detai: ' + e.message);
        }
    });
		// search
		$(document).on('change','#category1_cd ', function() {
			try {
                $('#category2_cd').val(0);
                $('#category3_cd').val(0);
				searchQuestion(1,20);
			} catch (e) {
				alert('.search' + e.message);
			}
        });
        	// search
		$(document).on('change',' #category2_cd', function() {
			try {
                $('#category3_cd').val(0);
				searchQuestion(1,20);
			} catch (e) {
				alert('.search' + e.message);
			}
        });
        	// search
		$(document).on('change',' #category3_cd', function() {
			try {
				searchQuestion(1,20);
			} catch (e) {
				alert('.search' + e.message);
			}
		});
		//
		$(document).on('click', '#btn-close-popup', function() {
			parent.$.colorbox.close();
			parent.$('body').css('overflow','auto');
			//parent.location.reload();; iss /redmine/attachments/download/41936/10.png
		});
   	} catch(e){

   }
}
/**
 * search
 *
 * @author  :   longvv - 2018/10/26 - create
 * @author  :
 *
 */
function searchQuestion(page,page_size) {
    try {
        category1_cd = $('#category1_cd').val();
        category2_cd = $('#category2_cd').val();
        category3_cd = $('#category3_cd').val();
        refer_kbn = $('#category1_cd').find('option:selected').attr('refer_kbn');
        var data = {
            'category1_cd' :category1_cd,
            'category2_cd' :category2_cd,
            'category3_cd' :category3_cd,
            'refer_kbn' :refer_kbn,
            'page' :page,
            'page_size' :page_size,
        };
        $.ajax({
            type        :   'POST',
            url         :   '/common/popup/question/search',
            dataType    :   'html',
            loading     :   true,
            data        :   data,
            success: function(res){
                $('#result').empty();
				$('#result').html(res);
				$('[data-toggle="tooltip"]').tooltip();
				jQuery.initTabindex();
                $('#category1_cd').focus();
                $.formatInput();
                app.jTableFixedHeader();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}