/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	datnt – datnt@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'r_sheet_cd'                                : {'type':'text', 'attr':'id'},
    'r_sheet_nm'                                : {'type':'text', 'attr':'id'},
    'sheet_ab_nm'                               : {'type':'text', 'attr':'id'},
    'category'                                  : {'type':'select', 'attr':'id'},
    'point_kinds'                               : {'type':'select', 'attr':'id'},
    'point_calculation_typ1'                    : {'type':'radiobox','name':'point_calculation_typ1', 'attr':'id'},
    'point_calculation_typ2'                    : {'type':'radiobox','name':'point_calculation_typ2', 'attr':'id'},
    'evaluation_period'                         : {'type':'radiobox','name':'evaluation_period', 'attr':'id'},
    'evaluation_self_typ'                      : {'type':'checkbox', ' attr':'id'},
    'details_feedback_typ'                      : {'type':'checkbox', ' attr':'id'},
    'comments_feedback_typ'                     : {'type':'checkbox', ' attr':'id'},
    'detail_self_progress_comment_title'       : {'type':'text', 'attr':'id'},
    'detail_progress_comment_title'            : {'type':'text', 'attr':'id'},
    'self_progress_comment_title'               : {'type':'text', 'attr':'id'},
    'progress_comment_title'                   : {'type':'text', 'attr':'id'},
    'upload_file'					            : {'type':'file', 'attr':'id'},
    'upload_file_nm'			                : {'type':'text', 'attr':'id'},
    'imgInp'					                : {'type':'file', 'attr':'id'},
    'arrange_order'                             : {'type':'text', 'attr':'id'},
    'mode'                                      : {'type':'text', 'attr':'id'},
    'mode_import'                               : {'type':'text', 'attr':'id'},
    'tr_generic_comment':{
        'attr': 'list', 'item': {
            'item_no'                   : {'type': 'text', 'attr': 'class'},
            'item_detail_1'             : {'type': 'text', 'attr': 'class'},
            'item_detail_2'             : {'type': 'text', 'attr': 'class'},
            'item_detail_3'             : {'type': 'text', 'attr': 'class'},
            'weight'                    : {'type': 'text', 'attr': 'class'},
            'mode_row'                  : {'type': 'text', 'attr': 'class'}
        }
    },

};
var _flgLeft = 0;
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
 * @author		:	datnt - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
*/
function initialize() {
    try{
       $('#r_sheet_nm').focus();
        removeButton();
        _formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try{


        $(document).on('change', '#calculation_typ_change2 input', function (e) {
            if($('input[name=point_calculation_typ2]:checked').val() == 1){
                $('#text_total_score_display_typ').text(text_total_points);
            }else{
                $('#text_total_score_display_typ').text(text_average_score);
            }
        });

        $(document).on('change', '.weight', function(e) {
            var weight = 0;
            weight = $(this).val();
            if(weight >100) {
                $(this).val(100);
            }else {
                $(this).val(weight);
            }
        });

        $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', '#btn-search-key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('change', '#search_key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('enterKey', '#search_key', function(e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });

        $(document).on('click', '.list-search-child', function(e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var sheet_cd = $(this).data('sheet_cd');
            refer_sheet_cd(sheet_cd);
        });
        $(document).on('change', '#calculation_typ_change', function(e) {
            if($('#calculation_typ_change input:checked').val() == 1 ){
                $('#weight_display_typ').val(text_weight);
                $('#text_total_score_display_typ').text(text_total_points);
                $('input:radio[name="point_calculation_typ2"]:first').prop('checked', true);
                $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', true);
                $('.icon-percent').removeClass('hidden');
            }else{
                $('#weight_display_typ').val(text_coefficient);
                $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', false);
                $('input:radio[name="point_calculation_typ2"]').removeAttr('disabled');
                $('.icon-percent').addClass('hidden');
            }
        });

      /*  $(document).on('change', '.btn-file :file', function () {
            var input = $(this),
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [label]);
        });*/

        $(document).on('change', '#upload_file', function () {
           var file =  readURL(this);
            $("#file_name").val(file['name']);
        });

        $(document).on('click', '.face-file-btn', function () {
           $("#upload_file").trigger("click");
        });


        $(document).on('click','#btn-copy',function(e) {
            e.preventDefault();
            //$('#rightcontent .inner').find('input:not(:checkbox):not(.code)').val('');
            $("#r_sheet_cd").val("0");
            $("#r_sheet_nm").val("");
            $("#mode").val("A");
            $('.copy__area').addClass('has-copy');
            $('#upload_file').val("");
            $('#upload_file_nm').val("");
            $("#file_name").val("");
            $("#file_address").val("");
            fileExists();
            $('#r_sheet_nm').focus();
        });

        $(document).on('click', '#btn-add-new', function(e) {
            try{
                jMessage(5,function(){
                    // clearData(_obj);
                    // resetData();
                    // // fill some inputs
                    // $('#detail_self_progress_comment_title').val('自己進捗コメント(項目別)');
                    // $('#detail_progress_comment_title').val('進捗コメント(項目別)');
                    // $('#self_progress_comment_title').val('進捗コメント（自己）');
                    // $('#progress_comment_title').val('進捗コメント（評価者）');
                    // setColSpanTotalTbl2();
                    location.reload();
                })
            }catch (e) {
                alert('btn-add-new: '+ e.message);
            }
        });
        //
        $(document).on('click', '#btn-delete', function (e) {
            try{
                jMessage(3, function (r) {
                    _flgLeft = 1;
                    if (r) {
                        deleteData();
                    }
                })
            }catch(e){
                alert('#btn-delete :' + e.message);
            }
        });
        //
        $(document).on('click', '#btn-save', function(e) {
            try{
                $("#tbl2 tbody tr .weight").removeClass("required");
                jMessage(1, function(r) {
                    _flgLeft = 1;
                    var count_tr =$("#tbl2 tbody .tr_generic_comment").length;
                   var check = _validate($('body'));
                   if(r && check == false) {
                       $("#tbl2 tbody tr .weight").addClass("required");
                       $("#tbl2 tbody .textbox-error:first").closest("div").find("input:first").focus();
                   }else {
                       if(count_tr >0) {
                           saveData();
                       } else {
                           jMessage(29, function(r) {
                           });
                       }
                   }


                });
            }catch(e){
                alert('#btn-save'+e.message);
            }
        });

        $(document).on('click','#btn-back',function(e) {
            e.preventDefault();
            // location.href="/dashboard";
            if(_validateDomain(window.location)){
                window.location.href = '/dashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        });
        $(document).on('click','.ics-edit',function(e) {
            e.preventDefault();
            if($(this).closest('th').hasClass('ics-wrap-disabled')) {
                return;
            }
            var container = $(this).closest('.d-flex');
            //container.find('input').removeAttr('readonly').focus();
            container.find('input').removeAttr('readonly').select();;
        });

        $(document).on('blur','.ics-textbox input',function() {
            $(this).attr('readonly','readonly');
        });

        $(document).on('keyup','.ics-textbox input',function(e) {
            if(e.keyCode ==13) {
                $(this).blur();
            }
        });

        $(document).on('change', '#details_feedback_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#details_feedback_typ : ' + e.message);
            }
        });

        $(document).on('change', '#comments_feedback_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#details_feedback_typ : ' + e.message);
            }
        });

        $(document).on('mouseup',function(e) {
            var input =$('.ics-textbox input');
            if (!$(e.target).is(':input')) {
                $('.ics-textbox input').attr('readonly','readonly');
            }
        });

        $(document).on('click','#btn-show',function(e) {
            e.preventDefault();
           $('table thead tr,table tbody tr').each(function(){
                $(this).find('.ics-hide').show();
                $(this).find('.ics-hide').removeClass('d-none').removeClass('ics-hide');
            });
            $('.w-table1').css('width','100%');
            $('.w-table3').css('width','50%');
            $('#td-colspan').attr('colspan',4);
            $('#td-colspan').show();
            $('#tr-total').show();
            var mql = $(window).width();
            $('.ln-css').removeClass('ln-css');
            $('#table-comment1').css('width', mql<768?'100%':'50%');
            setColSpanTotalTbl2();
        });

        $(document).on('click','.ics-eye',function(e) {
            e.preventDefault();
            var table  = $(this).closest('table');
            var th     = $(this).closest('th');
            var index  = th.index();
            console.log(index)
            th.addClass('ics-hide');
            th.hide();
            table.find('tbody tr td:eq('+index+')').hide();
            table.find('tbody tr td:eq('+index+')').addClass('ics-hide');
            var length = $('.w-table1 table thead tr .ics-hide').length;
            if(table.hasClass('tbl1')){
                $('.w-table1').css('width',(100-length*10)+'%');
            }
            if(table.hasClass('tabl2')){
               table.find('tbody tr td').each(function(){
                if($(this).index() == index){
                   $(this).addClass('ics-hide');
                   if(!$(this).hasClass('baffbo')){
                       $(this).hide();
                   }
                  }
                if(index == 5){
                    $('.ba55').next().hide();
                    $('.ba55').next().addClass('ics-hide');
                  }
                });
                if(index < 5){
                   var Newlength  = $('#td-colspan').attr('colspan') -1;
                   if(Newlength > 0){
                     $('#td-colspan').attr('colspan',Newlength);
                   }else{
                     $('#td-colspan').hide();
                   }
                }
                if(index > 5){
                   $('.baffbo'+index).hide();
                   $('.baffbo'+index).addClass('ics-hide');
                }
                $('#table-target tbody tr td').each(function(){
                    if($(this).index() == index){
                        $(this).addClass('ics-hide');
                        if(!$(this).hasClass('baffbo')){
                            $(this).hide();
                        }
                    }
                });
            }
            var screen = $(window).width();
            var width_table3 = 50;
            var width_table4 = 25;
            if(screen < 1100){
                width_table3 = 100
                width_table4 = 50
            }
            var length3 = $('.w-table3 table thead tr .ics-hide').length;
            $('.w-table3').css('width',(width_table3-length3*(width_table3/2))+'%');

           /* $("#tbl2 tbody .ics-hide span").each(function(){
                $(this).children('input').val("");
            });*/
            setColSpanTotalTbl2();
        });

        $(document).on('click','.ics-eye2',function(e) {
            var index = $(this).closest('th').index() + 1;
            $(this).closest('table').find('td:nth-child('+index+')').addClass('ics-hide d-none');
            $(this).closest('th').addClass('ics-hide d-none');
            if ( $(this).closest('table').hasClass('calc') ) {
                var mql = $(window).width();
                if ( mql<768 ) {
                    $(this).closest('table')
                        .css('width', $(this).closest('table').find('th:not(.ics-hide)').length*50+'%');
                }
                else {
                    $(this).closest('table')
                        .css('width', $(this).closest('table').find('th:not(.ics-hide)').length*25+'%');
                }
            }
            setColSpanTotalTbl2();
        });

        $(document).on('click','.ics-eye-total',function(e) {
          e.preventDefault();
          $(this).closest("th").addClass("ics-hide");
          $(this).closest('tr').hide();
        });

        $(document).on('click','#btn-item-setting',function(e) {
                try{
                  e.preventDefault();
                  showPopup("/master/m0170/popup");
            }catch (e) {
                alert('initEvents: ' + e.message);
            }
         });
        $(document).on('click','.btn-remove-row',function () {
            try{
                var tr    = $(this).parents('tr');
                tr.remove();
            } catch(e){
                alert('btn-add-new: ' + e.message);
            }
        });
         $(document).on('click','#btn-add-new-row',function () {
            try{
                var html = $('#table-target').find('tbody').html();
                //var html = $('#table-target tbody tr').clone();
                $('#tr-total').before(html);
                $(".bor_card").css("margin-bottom","45px");
                _setFocus();
                jQuery.formatInput();
                //_setTabIndex();
                //$.formatInput('#table-data tbody tr:last');
            } catch(e){
                alert('btn-add-new: ' + e.message);
            }
        });

        $(document).on('change', '.btn-file :file', function () {
            var input = $(this),
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [label]);
        });
        //


        $(document).on('click','#btn-download', function() {
            try {
               // var file_name       = $("#upload_file_nm").val();
                var file_name = $("#file_name").val();
                var file_address    = $("#file_address").val();
                if(file_name !=''){
                    downloadfileHTML(file_address ,file_name, function () {
                        // deleteFile(file_adress);
                    });
                }else{
                    jMessage(21);
                }
            } catch (e) {
                alert('#btn-download' + e.message);
            }
        });
        //btn-delete-file
        $(document).on('click','#btn-delete-file', function() {
            try {
                $("#file_name").val("");
                $("#upload_file_nm").val("");
                $("#file_address").val("");
                $('#upload_file').val("");
            } catch (e) {
                alert('#btn-delete-file' + e.message);
            }
        });

        // button export
        $(document).on('click', '#btn-item-evaluation-output', function (e) {
            try{
                var r_sheet_cd = $('#r_sheet_cd').val();
                if(r_sheet_cd > 0){
                    exportCSV();
                }else{
                    jMessage(21);
                }
            }catch(e){
                alert('#btn-item-evaluation-output :' + e.message);
            }
        });
        // import
        $(document).on('click', '#btn-item-evaluation-input', function (e) {
            try{
                $('#import_file').trigger('click');
            }catch(e){
                alert('#btn-item-evaluation-input :' + e.message);
            }
        });

      /*  $(document).on('click', '#import_file', function (e) {
            try{
                $('#import_file').trigger('change');
                //importCSV();
            }catch(e){
                alert('#import_file :' + e.message);
            }
        });*/
        // import
        $(document).on('change', '#import_file', function (e) {
            try{
                importCSV();
            }catch(e){
                alert('#upload_file :' + e.message);
            }
        });
        //
        setColSpanTotalTbl2();
   } catch (e) {
      alert('initEvents: ' + e.message);
    }
}


/**
 * save
 *
 * @author      :   tuantv - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        value0();
        var data    = getData(_obj);
        var generic_comment_display_typ_1 = 0;
        var generic_comment_display_typ_2 = 0;
        var generic_comment_display_typ_3 = 0;
        var generic_comment_display_typ_4 = 0;
        var generic_comment_display_typ_5 = 0;
        var generic_comment_display_typ_6 = 0;
        var generic_comment_display_typ_7 = 0;
        var generic_comment_display_typ_8 = 0;
        var detail_progress_comment_display_typ = 0;
        var detail_self_progress_comment_display_typ = 0;
        var self_progress_comment_display_typ = 0;
        var progress_comment_display_typ = 0;
        var generic_comment_title_1 = '';
        var generic_comment_title_2 = '';
        var generic_comment_title_3 = '';
        var generic_comment_title_4 = '';
        var generic_comment_title_5 = '';
        var generic_comment_title_6 = '';
        var generic_comment_title_7 = '';
        var generic_comment_title_8 = '';
        var self_assessment_comment_display_typ = 0;
        var evaluation_comment_display_typ = 0;
        var point_criteria_display_typ = 0;
        var item_display_typ_1 = 0;
        var item_title_1 = '';
        var item_display_typ_2 = 0;
        var item_title_2 = '';
        var item_display_typ_3 = 0;
        var item_title_3 = '';
        var item_display_typ_4 = 0;
        var weight_display_typ = 0;
        var total_score_display_typ = 0;
        generic_comment_title_1 = $("#generic_comment_title_1").val();
        generic_comment_1 = $("#generic_comment_1").val();
        generic_comment_title_2 = $("#generic_comment_title_2").val();
        generic_comment_2 = $("#generic_comment_2").val();
        generic_comment_title_3 = $("#generic_comment_title_3").val();
        generic_comment_title_4 = $("#generic_comment_title_4").val();
        generic_comment_title_5 = $("#generic_comment_title_5").val();
        generic_comment_title_6 = $("#generic_comment_title_6").val();
        generic_comment_title_7 = $("#generic_comment_title_7").val();
        generic_comment_title_8 = $("#generic_comment_title_8").val();
        generic_comment_8 = $("#generic_comment_8").val();
        item_title_1 = $("#item_title_1").val();
        item_title_2 = $("#item_title_2").val();
        item_title_3 = $("#item_title_3").val();
        if(!$("#generic_comment_title_1").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_1 =1;
        }

        if(!$("#generic_comment_title_2").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_2 =1;
        }

        if(!$("#generic_comment_title_3").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_3 =1;
        }

        if(!$("#generic_comment_title_4").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_4 =1;
        }

        if(!$("#generic_comment_title_5").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_5 =1;
        }
        if(!$("#generic_comment_title_6").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_6 =1;
        }
        if(!$("#generic_comment_title_7").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_7 =1;
        }
        if(!$("#generic_comment_title_8").parents('th').hasClass('ics-hide')) {
            generic_comment_display_typ_8 =1;
        }
        if(!$("#detail_progress_comment_display_typ").hasClass('ics-hide')) {
            detail_progress_comment_display_typ =1;
        }
        if(!$("#detail_self_progress_comment_display_typ").hasClass('ics-hide')) {
            detail_self_progress_comment_display_typ =1;
        }
        if(!$("#self_progress_comment_display_typ").hasClass('ics-hide')) {
            self_progress_comment_display_typ =1;
        }
        if(!$("#progress_comment_display_typ").hasClass('ics-hide')) {
            progress_comment_display_typ =1;
        }
        if(!$("#item_display_typ_1").parents('th').hasClass('ics-hide')) {
            item_display_typ_1 = 1;
        }
        if(!$("#item_display_typ_2").parents('th').hasClass('ics-hide')) {
            item_display_typ_2 = 1;
        }
        if(!$("#item_display_typ_3").parents('th').hasClass('ics-hide')) {
            item_display_typ_3 = 1;
        }
        if(!$("#weight_display_typ").parents('th').hasClass('ics-hide')) {
            weight_display_typ = 1;
        }
        if(!$("#total_score_display_typ").parents('th').hasClass('ics-hide')) {
            total_score_display_typ = 1;
        }
        if(!$("#self_assessment_comment_display_typ").parents('th').hasClass('ics-hide')) {
            self_assessment_comment_display_typ = 1;
        }
        if(!$("#evaluation_comment_display_typ").parents('th').hasClass('ics-hide')) {
            evaluation_comment_display_typ = 1;
        }
        if(!$("#point_criteria_display_typ").parents('th').hasClass('ics-hide')) {
            point_criteria_display_typ = 1;
        }
        var detail_comment_display_typ_0 = 0;
        if(!$("#detail_comment_display_typ_0").closest('th').hasClass('ics-hide')) {
            detail_comment_display_typ_0 = 1;
        }
         var detail_comment_display_typ_1 = 0;
        if(!$("#detail_comment_display_typ_1").closest('th').hasClass('ics-hide')) {
            detail_comment_display_typ_1 = 1;
        }
        var detail_comment_display_typ_2 = 0;
        if(!$("#detail_comment_display_typ_2").closest('th').hasClass('ics-hide')) {
            detail_comment_display_typ_2 = 1;
        }
        var detail_comment_display_typ_3 = 0;
        if(!$("#detail_comment_display_typ_3").closest('th').hasClass('ics-hide')) {
            detail_comment_display_typ_3 = 1;
        }
        var detail_comment_display_typ_4 = 0;
        if(!$("#detail_comment_display_typ_4").closest('th').hasClass('ics-hide')) {
            detail_comment_display_typ_4 = 1;
        }

        var upload_file_nm = $("#upload_file_nm").text();
        var check_filename = $('#upload_file')[0].files[0];

        if(check_filename == undefined && upload_file_nm =='') {
            data.data_sql.upload_file = '';
        }

        if(check_filename == undefined && upload_file_nm !='') {
            data.data_sql.upload_file = upload_file_nm;
        }

        if(check_filename != undefined && upload_file_nm =='') {
            data.data_sql.upload_file = $('#upload_file')[0].files[0].name;
        }
        if(check_filename != undefined && upload_file_nm !='') {
            data.data_sql.upload_file = $('#upload_file')[0].files[0].name;
        }
        var details_feedback = $("#details_feedback_typ").val();
        var comments_feedback = $("#comments_feedback_typ").val();

        data.data_sql.details_feedback_typ = (details_feedback =='' || details_feedback ==0)?0:1;
        data.data_sql.comments_feedback_typ = (comments_feedback =='' || comments_feedback ==0)?0:1;
       // alert(data.data_sql.details_feedback_typ);

        data.data_sql.generic_comment_display_typ_1 = generic_comment_display_typ_1;
        data.data_sql.generic_comment_title_1 = generic_comment_title_1;
        data.data_sql.generic_comment_1 = generic_comment_1;
        data.data_sql.generic_comment_display_typ_2 = generic_comment_display_typ_2;
        data.data_sql.generic_comment_title_2 = generic_comment_title_2;
        data.data_sql.generic_comment_2 = generic_comment_2;
        data.data_sql.generic_comment_display_typ_3 = generic_comment_display_typ_3;
        data.data_sql.generic_comment_title_3 = generic_comment_title_3;
        data.data_sql.generic_comment_display_typ_4 = generic_comment_display_typ_4;
        data.data_sql.generic_comment_title_4 = generic_comment_title_4;
        data.data_sql.generic_comment_display_typ_5 = generic_comment_display_typ_5;
        data.data_sql.generic_comment_title_5 = generic_comment_title_5;
        data.data_sql.generic_comment_display_typ_6 = generic_comment_display_typ_6;
        data.data_sql.generic_comment_title_6 = generic_comment_title_6;
        data.data_sql.generic_comment_display_typ_7 = generic_comment_display_typ_7;
        data.data_sql.generic_comment_title_7 = generic_comment_title_7;
        data.data_sql.generic_comment_display_typ_8 = generic_comment_display_typ_8;
        data.data_sql.detail_progress_comment_display_typ = detail_progress_comment_display_typ;
        data.data_sql.detail_self_progress_comment_display_typ = detail_self_progress_comment_display_typ;
        data.data_sql.self_progress_comment_display_typ = self_progress_comment_display_typ;
        data.data_sql.progress_comment_display_typ = progress_comment_display_typ;
        data.data_sql.generic_comment_title_8 = generic_comment_title_8;
        data.data_sql.generic_comment_8 = generic_comment_8;
        //

        data.data_sql.item_display_typ_1 = item_display_typ_1;
        data.data_sql.item_title_1 = item_title_1;
        data.data_sql.item_display_typ_2 = item_display_typ_2;
        data.data_sql.item_title_2 = item_title_2;
        data.data_sql.item_display_typ_3 = item_display_typ_3;
        data.data_sql.item_title_3 = item_title_3;
        data.data_sql.weight_display_typ = weight_display_typ;
        data.data_sql.evaluation_display_typ = 1;
        data.data_sql.total_score_display_typ = total_score_display_typ;
        data.data_sql.self_assessment_comment_display_typ = self_assessment_comment_display_typ;
        data.data_sql.point_criteria_display_typ = point_criteria_display_typ;
        data.data_sql.detail_comment_display_typ_0 = detail_comment_display_typ_0;
        data.data_sql.detail_comment_display_typ_1 = detail_comment_display_typ_1;
        data.data_sql.detail_comment_display_typ_2 = detail_comment_display_typ_2;
        data.data_sql.detail_comment_display_typ_3 = detail_comment_display_typ_3;
        data.data_sql.detail_comment_display_typ_4 = detail_comment_display_typ_4;
        data.data_sql.evaluation_comment_display_typ = evaluation_comment_display_typ;
        data.data_sql.evaluation_self_typ = $('#evaluation_self_typ').is(':checked')?1:0;
        data.data_sql.mode = $("#mode").val();
        var file_address = $("#file_address").val();
        var upload_file_nm = $("#upload_file_nm").val();


        data.data_sql.file_address = (typeof file_address !='undefined')?file_address:'';
        data.data_sql.upload_file_nm = (typeof upload_file_nm !='undefined')?upload_file_nm:'';
        data.data_sql.flag = $("#flag").val();
        var formData = new FormData();
        formData.append('head', JSON.stringify(data));
        formData.append('file', $('#upload_file')[0].files[0]);


        // send data to post
        $.ajax({
            type        :   'POST',
            data        :   formData,
            url         :   '/master/m0170/save',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function(res) {
                $('.copy__area').removeClass('has-copy');
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(2, function(r) {

                            location.reload();
                            // $('#r_sheet_nm').focus();
                            // if(res['r_sheet_cd'] != 0){
                            //     clearData(_obj);
                            //     setInitTitle();
                            //     fileExists();
                            //     $("#mode").val('A');
                            //     $("#file_address").val("");
                            //     resetData();
                            //     /*$("#file_name").val("");
                            //     $("#upload_file_nm").val("");
                            //     $("#file_address").val("");
                            //     $('#upload_file').val("");*/
                            // }
                            // var page    =   $('#leftcontent').find('.active a').attr('page');
                            // var search  =   $('#search_key').val();
                            // getLeftContent(page, search);

                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            processError(res['errors']);
                        }
                    break;
                    case 405:
                        jMessage(27, function () {
                        });
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
 * readURL
 *
 * @author      :   tuantv - 2018/09/17 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.readAsDataURL(input.files[0]);
    }
    return input.files[0];
}

/**
 * search
 *
 * @author  :   tuantv - 2018/09/14 - create
 * @author  :
 *
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0170/leftcontent',
            dataType    :   'html',
            loading     :   false,
            data        :   {current_page: page, search_key: search},
            success: function(res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    var heneed=$('.calHe').innerHeight();
                    var hetru=$('.calHe2').innerHeight();
                    var heit=heneed-hetru-55;
                    var heme=$('.list-search-content').innerHeight();
                    $('.list-search-content').attr('style','height: '+ heit +'px');
                    if(heme>heit){
                        $('.list-search-content').addClass('scroll');
                    }
                    var sheet_cd = $('#sheet_cd').val();
                    $('.copy__area').removeClass('has-copy');
                    $('.list-search-content div[id="'+sheet_cd+'"]').addClass('active');
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                    if(_flgLeft != 1){
                        $('#search_key').focus();
                    }else{
                        _flgLeft = 0;
                    }
                    _formatTooltip();
                }
            }

        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}


/**
 * refer sheet_cd
 *
 * @author      :   tuantv - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer_sheet_cd(sheet_cd) {
    try {
        var data ={};
        var screen = $(window).width();
        var width_table3 = 50;
        var width_table4 = 25;
        if(screen < 1100){
            width_table3 = 100
            width_table4 = 50
        }
        data['sheet_cd'] = sheet_cd;
        data['width_table3'] = width_table3;
        data['width_table4'] = width_table4;

        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/m0170/refer_sheet_cd',
            dataType: 'html',
            loading: false,
            data: data,
            success: function (res) {
                res = JSON.parse(res);
                switch (res['status']) {
                    // success
                    case 200:
                        if(res.data.sheet_cd !=''){
                            $("#rightcontent").empty();
                            $("#rightcontent").append(res.data_refer);
                            jQuery.formatInput();
                            $("#mode").val("U");
                            $("#r_sheet_nm").focus();
                            $('#r_sheet_nm').removeClass('boder-error');
                            $('#r_sheet_nm').next('.textbox-error').remove();
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            //getLeftContent(page, search);
                            fileExists();
                            // set width table-comment1
                            var mql = $(window).width();
                            if ( mql < 768 ) {
                                $('#table-comment1').css(
                                    'width',
                                    $('#table-comment1').find('th:not(.ics-hide)').length*50+'%'
                                );
                            }
                        }
                        break;
                    // error
                    case 202:
                            // location.href = '/master/m0170';
                            if(_validateDomain(window.location)){
                                window.location.href = '/master/m0170';
                            }else{
                                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                            }
                        break;
                    // Exception
                    case EX:
                        jError(res['Exception']);
                        break;
                    default:
                        break;
                }
                setColSpanTotalTbl2();
            },
        });
    } catch (e) {
        alert('save' + e.message);
    }
}

function setColSpanTotalTbl2() {
    var colspan = $('th.th-total').length - $('th.th-total.ics-hide').length;
    $('td#td-colspan').attr('colspan', colspan);
}

/**
 * delete
 *
 * @author      :   Tuantv - 2018/09/19 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.sheet_cd = $('#r_sheet_cd').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/m0170/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                $('.copy__area').removeClass('has-copy');
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            location.reload();
                            //$('#r_sheet_nm').focus();
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
        alert('save' + e.message);
    }
}
/**
 * exportCSV
 *
 * @author      :  viettd - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
    try{
        var data    = {};
        data.sheet_cd      = $('#r_sheet_cd').val();
        //
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0170/export',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                // success
            var name_csv      = $('#r_sheet_nm').val()+"_"+$('#nn_csv').val();
            //var name_csv  = name.replaceAll(' ', '')

            switch (res['status']) {
                case OK:
                    var filedownload    =   res['FileName'];
                    if(filedownload != ''){
                        downloadfileHTML(filedownload ,name_csv+'.csv' , function () {
                            //
                        });
                    } else{
                        jError(2);
                    }
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
    }catch(e){
        alert('exportCSV: ' + e.message);
    }
}
/**
 * importCSV
 *
 * @author      :  viettd - 2017/12/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
    try{
        var formData = new FormData();
        formData.append('file', $('#import_file')[0].files[0]);
        formData.append('sheet_cd', $('#im_sheet_cd').val());
        $.ajax({
            type        :   'POST',
            data        :   formData,
            url         :   '/master/m0170/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function(res) {
             //  var arr = JSON.parse(res);
                switch (res['status']){
                    // success

                    case 200:
                        var tbody = $('#tbl2');
                        tbody.empty();
                        tbody.append(res.data_import);

                        var tbody = $('#table-target');
                        tbody.empty();
                        tbody.append(res.data_table_target);
                        if($('input[name=point_calculation_typ2]:checked').val() == 1){
                            $('#text_total_score_display_typ').text(text_total_points);
                        }else{
                            $('#text_total_score_display_typ').text(text_average_score);
                        }
                        
                        $("#import_file").val("");
                        break;
                    // error
                    case 201:
                        jMessage(22);
                        break;
                    case 206:
                        jMessage(27, function(r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 207:
                        jMessage(31, function(r) {
                            $("#import_file").val("");
                        });
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
        alert('importCSV: ' + e.message);
    }
}

/**
 * setInitTitle
 *
 * @author      :  tuantv - 2018/09/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function setInitTitle(){
    $("#generic_comment_title_1").val("汎用コメント①");
    $("#generic_comment_title_2").val("汎用コメント②");
    $("#generic_comment_title_3").val("汎用コメント③");
    $("#generic_comment_title_4").val("汎用コメント④");
    $("#generic_comment_title_5").val("汎用コメント⑤");
    $("#item_title_1").val("大分類");
    $("#item_title_2").val("中分類");
    $("#item_title_3").val("小分類");
    $("#upload_file_nm").text("");
}

/**
 * _setFocus
 *
 * @author      :  tuantv - 2018/10/31 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function _setFocus(){
    var _length = $("#tbl2 tbody .tr_generic_comment").length;
    $("#tbl2 tbody .tr_generic_comment").eq(_length-1).find(".item_detail_1:first").focus();
}

/**
 * file Exists
 *
 * @author      :  tuantv - 2018/09/31 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function fileExists() {
    var file_name = $("#file_name").val();
    if(file_name !='') {
        $("#btn-download").removeClass("iconDownload");
        $("#btn-delete-file").removeClass("iconDownload");
    }else {
        removeButton();
    }
}

function removeButton() {
    var msg =_text[21].message;
    $("#btn-download").addClass("iconDownload");
    $("#btn-delete-file").addClass("iconDownload");
    $("#file_name").val(msg);
}

/**
 * disable item weigh in screen
 *
 * @author      :  tuantv - 2018/09/14 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function value0() {
    $("#tbl2 tbody .td-4").each(function(){
        var check = $(this).hasClass('ics-hide');
        if(check)
        {
            $("#tbl2 tbody .td-4 input").val(0);
            $("#flag").val('N');
        }else {
            $("#flag").val('Y');
        }
    });
}
// function resetData(){
//                     $('#r_sheet_nm').focus();
//                     $('#r_sheet_cd').val(0);
//                     $('#category').removeClass('boder-error');
//                     $('#category').next('.textbox-error').remove();
//                     $('#point_kinds').removeClass('boder-error');
//                     $('#point_kinds').next('.textbox-error').remove();
//                     $(".radio .md-radio-v2 input").removeAttr("checked");
//                     $(".rad1 .md-radio-v2:eq(0)").find('input').prop('checked', true);
//                     $('input:radio[name="point_calculation_typ2"]:eq(1)').prop('disabled', true);
//                     $(".rad2 .md-radio-v2:eq(0)").find('input').prop('checked', true);
//                     $(".radio .md-radio-v2:eq(0)").find('input').prop('checked', true);
//                     $('.icon-percent').removeClass('hidden');
//                     $('#upload_file').val('');
//                     $('input[type=checkbox]').prop('checked', false);
//                     $('#evaluation_self_typ').val(0);
//                     $('#btn-show').trigger('click');
//                     $('select').val('-1');
//                     $('.list-search-child').removeClass('active');
//                     $('#tbl2 tbody .btn-remove-row').not(':eq(0)').trigger('click');
//                     $('#tbl2 tbody .btn-remove-row:eq(0)').parents('tr').find('input[type=text]').val('');
//                     $("#upload_file_nm").val("");
//                     var msg =_text[21].message;
//                     $("#file_name").val(msg);
//                     $("#file_address").val("");
//                     setInitTitle();
//                     $("#mode").val('A');
//                     $('.copy__area').removeClass('has-copy');
//                     //
//                     $('#generic_comment_title_1').val('会社用汎用コメント①');
//                     $('#generic_comment_title_2').val('会社用汎用コメント②');
//                     $('#generic_comment_title_3').val('評価者用汎用コメント①');
//                     $('#generic_comment_title_4').val('評価者用汎用コメント②');
//                     $('#generic_comment_title_5').val('本人用汎用コメント①');
//                     $('#generic_comment_title_6').val('本人用汎用コメント②');
//                     $('#generic_comment_title_7').val('本人用汎用コメント③');
//                     $('#generic_comment_title_8').val('会社用汎用コメント③');
//                     //
//                     $('#generic_comment_1').val('');
//                     $('#generic_comment_2').val('');
//                     $('#generic_comment_8').val('');

//                     $('.item_detail_1').val('');
//                     $('.item_detail_2').val('');
//                     $('.item_detail_3').val('');

//                     $('#detail_self_progress_comment_title').val('自己進捗コメント(項目別)');
//                     $('#detail_progress_comment_title').val('進捗コメント(項目別)');
//                     $('#self_progress_comment_title').val('進捗コメント（自己）');
//                     $('#progress_comment_title').val('進捗コメント（評価者）');
// }
/**
 * tooltip format
 *
 * @author  :   tuantv - 2018/12/05 - create
 * @author  :
 * @param 	:	error array ex ['e1','e2']
 */
function _formatTooltip(){
    try{
        $('.text-overfollow').each(function(i) {
            var i = 1;
            var colorText = '';
            var element = $(this)
                .clone()
                .css({display: 'inline', width: 'auto', visibility: 'hidden'})
                .appendTo('body');

            if( element.width() <= $(this).width() ) {
                $(this).removeAttr('data-original-title');
            }
            element.remove();
        });
    }catch(e){
        alert('format tooltip '+e.message);
    }
}