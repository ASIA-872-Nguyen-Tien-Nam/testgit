/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */

var _focus_index = null;
var _confirm = false;
$(function(){
    initEvents();
    initialize();
});
_check_copy = 0;
/**
 * initialize
 *
 * @author		:	sondh - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
        $('#fiscal_year').focus();
        $('.nav-tabs a:first').tab('show');
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	sondh - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
     document.addEventListener('keydown', function (e) {
            if (e.keyCode  === 9) {
                if (e.shiftKey) {
                   if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
                        e.preventDefault();
                         if($('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last().length!=0){
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last()[0].focus();
                        }
                        return;
                    }
                     if ($(':focus')[0] === $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0]) {
                        e.preventDefault();
                         if($(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length!=0){
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0].focus();
                        }else{
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').last()[0].focus();
                        }
                        return;
                    }
                }else{
                        if ($(':focus')[0] === $(':input:not([readonly],[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0].focus();
                        }
                        if ($(':focus')[0] === $('#ans-collapse a:not([readonly],.disabled,[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            if($(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().length > 0){
                                $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
                            }else{
                                $('#ans-collapse a:not([readonly],[disabled],.disabled,:hidden)').first()[0].focus();
                            }
                        }
                }
            }
        });
    //add-new
    // lưu value hiện tại khi element nhận focus (keyboard hoặc click trước đó)
        $(document).on('focus', '#treatment_applications_no', function() {
        $('#prev_treatment').attr('value',$(this).val());
        $('#prev_treatment').val($(this).val());
        });
    $(document).on('change','#treatment_applications_no',function () {
        try {
        if(_check_copy == 0){
        var next = $('#treatment_applications_no').val()
        $('#treatment_applications_no').val($('#prev_treatment').attr('value'))
        jMessage(175, function (r) {
            if (r) {
                 $('#treatment_applications_no').val(next)
            
                referData(1);
            
        } else {
             $('#treatment_applications_no').val($('#prev_treatment').attr('value'))
        }
        })
    }

        }catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
    $(document).on('click','#btn-add-new',function () {
        try{
              var tr          = $(this).parents('tr');
            var table       = $(this).parents('.table');
            var group_body  = $(this).parents('tbody');
            table.each(function(){
                var tr_table = $(this).find('tbody tr');
                if(tr_table.hasClass('class-selected')){
                    tr_table.removeClass('class-selected');
                    tr_table.find('.td-group').removeClass('td-selected-white');
                    tr_table.find('td:not(.td-group)').removeClass('td-selected-gray');
                    tr_table.next().find('td').removeClass('td-selected-gray');
                }
            });
            tr.addClass('class-selected');
            $(this).addClass('td-selected-white');
            // tr.find('td:not(.td-group)').addClass('td-selected-gray');
            // tr.find('tr td:not(.td-group)').addClass('td-selected-gray');
            // group_body.find('tr:not(.class-selected) td').addClass('td-selected-gray');
            var count_selected  = 0;
            var table           = $(this).parents('table');
            table.find('tbody tr').each(function (){
                if ( $(this).hasClass('class-selected') ) {
                    count_selected++;
                }
            });
            if(count_selected > 0){
                var row = $("#table-target-1 tbody tr:first").clone();
                row.find('.td-group').addClass('td-selected-gray');
                var parent_body = table.find('tbody .class-selected');
                var count_tr = $('.class-selected').parents('tbody').find('tr').length;
                if(count_tr > 1){
                    parent_body.parents('tbody').find('tr:last').after(row);
                 }else{
                    parent_body.after(row);
                 }
                parent_body.parents('tbody').find('tr:last td:first-child select').focus();
                var old_rowspan = 1*parent_body.find('.td-group').attr('rowspan');
                parent_body.find('.td-group').attr('rowspan',old_rowspan+1);
            }else{
                var row = $("#table-target-1 tbody tr:first").clone();
                var parent_body = table.find('tbody:last');
                parent_body.append(row);
                table.find('tbody:last tr:last td:first-child select').focus();
                var old_rowspan = 1*parent_body.find('.td-group').attr('rowspan');
                parent_body.find('.td-group').attr('rowspan',old_rowspan+1);
            }
            //
            $('#table-data tbody.group-body:not(.hidden)').each(function () {
                var _tbody = $(this);
                //
                _tbody.find('tr.tr-main').each(function (j) {
                    var detail_no = j+1;
                    $(this).find('.detail_no').val(detail_no);
                });
            });
            $.formatInput();
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
    //btn-remove-row
    $(document).on('click','.btn-remove-row',function () {
        try{
            var tbody = $(this).parents('tbody');
            var tr    = $(this).parents('tr');
            var leng  = tbody.find('tr').length;
            if(leng > 1){
    // check nếu row này có nút plus
        if(tr.find('#btn-add-new').length > 0){
            var $btnAdd = tr.find('#btn-add-new').closest('td').clone(true); 
            // move nút plus sang row tiếp theo
            tr.next().append($btnAdd);
        }

        // xử lý rowspan cho td-group (nếu cần)
        if(tr.find('td:first-child').hasClass('td-group')){
            var td_first = tr.find('.td-group').clone();
            var old_rowspan = parseInt(td_first.attr('rowspan'));
            tr.next().find('td:first-child').before(td_first);
            tr.next().find('.td-group').attr('rowspan', old_rowspan - 1);
        } else {
            var prevGroupCell = tr.prevAll('tr').find('.td-group').first();
            if(prevGroupCell.length > 0){
                var old_rowspan = parseInt(prevGroupCell.attr('rowspan'));
                prevGroupCell.attr('rowspan', old_rowspan - 1);
            }
        }

        tr.closest('.group-body').find('.td-group').removeClass('td-selected-white');
        tr.closest('.group-body').find('tr').removeClass('class-selected');

        // remove row
        tr.remove();
    }
            //
            $('#table-data tbody.group-body:not(.hidden)').each(function () {
                var _tbody = $(this);
                //
                _tbody.find('tr.tr-main').each(function (j) {
                    var detail_no = j+1;
                    $(this).find('.detail_no').val(detail_no);
                });
            });
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
    $(document).on('focusin','#table-data .input-sm',function(){
        // alert(1);
        _focus_index = $(this).closest('.group-body').attr('id');
    });
    //select-group
    $(document).on('click','.td-group',function () {
        try{
            var tr          = $(this).parents('tr');
            var table       = $(this).parents('.table');
            var group_body  = $(this).parents('tbody');
            table.each(function(){
                var tr_table = $(this).find('tbody tr');
                if(tr_table.hasClass('class-selected')){
                    tr_table.removeClass('class-selected');
                    tr_table.find('.td-group').removeClass('td-selected-white');
                    tr_table.find('td:not(.td-group)').removeClass('td-selected-gray');
                    tr_table.next().find('td').removeClass('td-selected-gray');
                }
            });
            tr.addClass('class-selected');
            $(this).addClass('td-selected-white');
            // tr.find('td:not(.td-group)').addClass('td-selected-gray');
            // tr.find('tr td:not(.td-group)').addClass('td-selected-gray');
            // group_body.find('tr:not(.class-selected) td').addClass('td-selected-gray');
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });
    $(window).on("click", function (event){
        if (
            $("#table-data").has(event.target).length == 0 //checks if descendants of $box was clicked
            && !$("#table-data").is(event.target) //checks if the $box itself was clicked
        ) {
            var tr_selected = $("#table-data").find('tr.class-selected');
            tr_selected.find('.td-group').removeClass('td-selected-white');
            tr_selected.find('td:not(.td-group)').removeClass('td-selected-gray');
            var group_body = $('#table-data tbody tr.class-selected').parents('tbody');
            group_body.find('tr:not(.class-selected) td').removeClass('td-selected-gray');
            $("#table-data").find('tr.class-selected').removeClass('class-selected');
        }
        if (
            $("#table-data-1").has(event.target).length == 0 //checks if descendants of $box was clicked
            && !$("#table-data-1").is(event.target) //checks if the $box itself was clicked
        ) {
            var tr_selected = $("#table-data-1").find('tr.class-selected');
            tr_selected.find('.td-group').removeClass('td-selected-white');
            tr_selected.find('td:not(.td-group)').removeClass('td-selected-gray');
            var group_body = $('#table-data-1 tbody tr.class-selected').parents('tbody');
            group_body.find('tr:not(.class-selected) td').removeClass('td-selected-gray');
            $("#table-data-1").find('tr.class-selected').removeClass('class-selected');
        }
        if (
            $("#table-data-2").has(event.target).length == 0 //checks if descendants of $box was clicked
            && !$("#table-data-2").is(event.target) //checks if the $box itself was clicked
        ) {
            var tr_selected = $("#table-data-2").find('tr.class-selected');
            tr_selected.find('.td-group').removeClass('td-selected-white');
            tr_selected.find('td:not(.td-group)').removeClass('td-selected-gray');
            var group_body = $('#table-data-2 tbody tr.class-selected').parents('tbody');
            group_body.find('tr:not(.class-selected) td').removeClass('td-selected-gray');
            $("#table-data-2").find('tr.class-selected').removeClass('class-selected');
        }
    });
    //change fiscal_year
    $(document).on('change','#fiscal_year', function (e) {
        try {
            if(_check_copy == 0){
                referData(0);
            }else{
                referTreatment();
            }
            //referData(0)
        } catch (e) {
            alert('#fiscal_year :' + e.message);
        }
    });

    // btn-save
    $(document).on('click', '#btn-save', function (e) {
        try {
            var upd = 0;
            jMessage(1, function (r) {
                if (r && _validate($('body'))) {
                    // tao unique id cho moi row
                    $('#table-data tr.tr-main').each(function() {
                        // remove old uid
                        if (typeof $(this).data('uid') != 'undefined') {
                            $(this).removeClass($(this).data('uid'));
                        }
                        //
                        var uid = generateGuid();
                        $(this).data('uid', uid).addClass(uid);
                    });
                    saveData(0, $('#evaluation-master-set').attr('value'),1,1);

                   
                     
                }else{
                    $('.num-length').removeClass('td-error');
                    $('.div_loading').hide();
                }
            });
        } catch (e) {
            alert('#btn-save :' + e.message);
        }
    });
    // btn-save
    $(document).on('click', '#btn-evaluation-master-confirmation', function (e) {
        try {
            jMessage(1, function (r) {
                if (r && _validate($('#row-header'))) {
                    //    
                        saveData(1,0);
                }else{
                    $('.div_loading').hide();
                }
            });
        } catch (e) {
            alert('#btn-save :' + e.message);
        }
    });
    //btn-copy
    $(document).on('click','#btn-copy',function(e) {
        e.preventDefault();
        if ($('#treatment_applications_no option').length > 0) {
            $('#treatment_applications_no option').remove()
            $('.calHe').addClass('has-copy');
            $('#fiscal_year').val('-1');
            $('#treatment_applications_no').val('-1');
            $('#fiscal_year').focus();
            _check_copy = 1; 
        }
    });
    //btn-back
    $(document).on('click', '#btn-back', function (e) {
        if(_validateDomain(window.location)){
            window.location.href = '/dashboard';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });
    // sheet_cd
    $(document).on('change', 'select.sheet_cd', function (e) {
        var use_typ = 0;
        if ( $(this).val() != '0' ){
            use_typ = 1;
            $(this).parents('.tr-main').find('.weight').attr('disabled',false);
        }else{
            $(this).parents('.tr-main').find('.weight').val('0').attr('disabled',true);
        }
        $(this).attr('use_typ', use_typ);
        $(this).attr('value_sheet_cd', $(this).val());
    });
    $(document).on('focus', 'select.sheet_cd', function (e){
        var select = $(this);
        var selectedValue = select.attr("value_sheet_cd");
        select.empty().append($("#m0200_option option").clone()).val(selectedValue);
    });
    // Xử lý sự kiện 'blur' của select
    $(document).on('blur', 'select.sheet_cd', function () {
        var select = $(this);
        var selectedValue = select.val();
        select.find('option').not(`[value="${selectedValue}"]`).remove();
    });
}
/**
 * refer
 *
 * @author      :   sondh - 2018/09/26 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referData(check_treatment = 0){
    try{
        var fiscal_year = $('#fiscal_year').val();
        var treatment_applications_no = $('#treatment_applications_no').val() || 0;
        var check_treatment = check_treatment
        //
        $.ajax({
            type: 'POST',
            url: '/master/i1020/refer',
            dataType: 'json',
            loading: false,
            data: {fiscal_year: fiscal_year,treatment_applications_no: treatment_applications_no,check_treatment:check_treatment},
            success: function (res) {
                var check = res.data_check[0];
                const $btn = $('#btn-evaluation-master-confirmation');
                if (check.btn === 'disabled') {
                    $btn.prop('disabled', true);
                } else {
                    $btn.prop('disabled', false);
                }
                const $div = $('#evaluation-master-set');
                if (check.text === 'hidden') {
                    $div.attr('hidden', true);
                } else {
                    $div.removeAttr('hidden');
                } 
                const $div2 = $('#cannot-be-changed'); 
                if (check.btn === 'disabled') {
                    $div2.prop('hidden', false);
                } else {
                    $div2.prop('hidden', true);
                }
                $('#tabs').empty();
                $('#tabs').append(res.html);
                $.formatInput();   
            }
        });
    }catch(e){
        alert('referData' + e.message);
    }
}

function randomString(length, chars) {
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

/**
 * make unique id
 * @return {String}
 */
function generateGuid() {
    return randomString(10, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
}
/**
 * save
 *
 * @author      :   sondh - 2018/09/24 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData(mode = 0, update=0, show_174 =0,w_m_999=0,change_treatment = 0) {
    try {
        var data = {};
        data.list_row = mode == 0?getDataInsert():[];
        data.fiscal_year = $('#fiscal_year').val();
        data.treatment_applications_no = $('#treatment_applications_no').val()||0;
         if(change_treatment == 1) {
            data.treatment_applications_no = $('#prev_treatment').attr('value')||0;
        }
        data.mode = mode;
        data.update = update;
        data.show_174 = show_174;
        data.w_m_999 = w_m_999;
        data.list_use_typ = mode == 0?getDataUseTyp():[];

        // send data to post
        $.ajax({
            type: 'POST',
            url: '/master/i1020/save',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                         _check_copy = 0; 
                         $('.calHe').removeClass('has-copy');
                                   
                                 jMessage(2, function () {
                            if (mode == 0) {
                                if(_validateDomain(window.location)){
                                     $('.calHe').removeClass('has-copy');
                                }else{
                                    jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                                }
                            }else{
                                $('#evaluation-master-set').prop('hidden', true);
                                $('#cannot-be-changed').prop('hidden', true);
                                $('#fiscal_year').focus();
                            }})
                        break;
                    // error
                    case NG:
                        $('#treatment_applications_no').val($('#prev_treatment').attr('value'))
                        if (typeof res['errors'] != 'undefined') {
                            // for (var i = 0; i< res['errors'].length; i++){
                            //     var sheet_cd_chk = res['errors'][i]['value2'];
                            //     $(".tr-main").each(function (row){
                            //         var sheet_cd = row+1;
                            //         //
                            //         if (sheet_cd_chk == sheet_cd) {
                            //             errorStyleI1020($(this).find(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message);
                            //         }
                            //     });
                            //     checkTabError();
                            // }
                            $('a.treatment_applications_no').removeClass('tab-error2');
                            $('.td-error').append('<div></div>');
                            var hasError149 = res['errors'].filter(err => err.message_no == 149);
                            if (hasError149.length) {
                                jMessage(149, function () {
                                    $('#fiscal_year').focus();
                                });
                            }
                            var hasError172 = res['errors'].filter(err => err.message_no == 172);
                            if (hasError172.length) {
                                jMessage(172, function () {
                                    $('#fiscal_year').focus();
                                });
                            }
                            for (var i = 0; i< res['errors'].length; i++){
                                $(res['errors'][i]['item']).addClass('XXX');
                                errorStyleI1020($(res['errors'][i]['item']), _text[res['errors'][i]['message_no']].message, res['errors'][i]['message_no']);
                                checkTabError();
                            }
                        }
                        break;
                    // Exception
                    case EX:
                         $('#treatment_applications_no').val($('#prev_treatment').attr('value'))
                        jError(res['Exception'],'',function () {
                            $('#fiscal_year').focus();
                        });
                        break;
                    case 999:
                         $('#treatment_applications_no').val($('#prev_treatment').attr('value'))
                        $('a.treatment_applications_no').removeClass('tab-error2');
                        for (var i = 0; i< res['errors'].length; i++){
                            if ( !res['errors'][i]['message_no'] == 98 ) continue;
                            var tabs = res['errors'][i]['remark'].split(',').map(function(item) {
                                $('a[href="'+item+'"]').addClass('xxx tab-error2');
                            }).join(',');
                        }
                        jMessage(98, function () {
                            $('#fiscal_year').focus();
                        });
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
 * error
 *
 * @author      :   SonDH - 2018/09/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function errorStyleI1020(selector, message, message_no='') {
    try {
        message = jQuery.castString(message);
        if (message !== '') {
            selector.addClass('boder-error');
            if(selector.next('.textbox-error').length > 0){
            }else{
                if (message_no == 149) {
                    selector.addClass('textbox-error');
                }
                else {
                    selector.after('<div class="textbox-error">' + message + '</span>');
                }
            }
            selector.closest('tr').find('td').css('vertical-align','top');
            selector.closest('tr').find('td .btn-remove-row').closest('td').css('vertical-align','middle');
            _focusErrorItem();
        }

    } catch (e) {
        alert('errorStyleI1020' + e.message);
    }
}
/**
 * get data
 *
 * @author      :   SonDH - 2018/09/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getDataInsert() {
    var data = {};
    var row_id =0;
    $('#table-data tbody.group-body:not(.hidden)').each(function () {
        //
        var _tbody = $(this);
        var group_cd = $(this).attr('group_cd');
       // var treatment_applications_no  = $(this).attr('treatment_applications_no');
        //
        _tbody.find('tr.tr-main').each(function (j, row_tr) {

            var $row = $(row_tr),
                $detail_no  = $row.find('.detail_no'),
                $sheet_cd  = $row.find('.sheet_cd'),
                $weight  = $row.find('.weight');

            var rowdata = {};
            rowdata['group_cd'] = group_cd;
            //rowdata['treatment_applications_no'] = treatment_applications_no;
            rowdata['detail_no'] = $detail_no.val()==0?1:$detail_no.val();
            rowdata['sheet_cd'] = $sheet_cd.val();
            rowdata['weight'] = $weight.val();
            rowdata['uid'] = $(this).data('uid');
            rowdata['use_typ'] = $sheet_cd.attr('use_typ');

            data[row_id] = rowdata;
            //
            row_id = row_id + 1;
        });

    });
    return data;
}
/**
 * get only group with use_typ = 0
 * @return {Object}
 */
function getDataUseTyp() {
    var data = [];
    var row_id =0;
    $('#table-data tbody.group-body:not(.hidden)').each(function () {
        //
        var _tbody = $(this);
        var group_cd = $(this).attr('group_cd');
        //var treatment_applications_no  = $(this).attr('treatment_applications_no');
        var scd = $(this).find('.sheet_cd');

        if ( scd.length === 1 && scd.val() == '0' ) {
            var rowdata = {};
            rowdata['group_cd'] = group_cd;
            //rowdata['treatment_applications_no'] = treatment_applications_no;
            rowdata['use_typ'] = 0;
            data.push(rowdata);
        }

    });
    return data;
}
/**
 * refer treatment_applications_no
 *
 * @author      :   SonDH - 2018/11/29 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referTreatment() {
    try{
        var fiscal_year = $('#fiscal_year').val();
        //
        $.ajax({
            type: 'POST',
            url: '/master/i1020/refertreatment',
            dataType: 'json',
            loading: false,
            data: {fiscal_year: fiscal_year},
            success: function (res) {
                if(res.data_check[0].text == 'confirm') {
                    $('#evaluation-master-set').attr('value',1)
                } else {
                    $('#evaluation-master-set').attr('value',0)
                }
                var $select = $('#treatment_applications_no');
                $select.empty();             
                $.each(res.data, function(index,item) {                  
                    $select.append(
                        $('<option>', {
                            value: item.treatment_applications_no,
                            text: item.treatment_applications_nm
                        })
                    );
                });
                var check = res.data_check[0];
                const $btn = $('#btn-evaluation-master-confirmation');
                if (check.btn === 'disabled') {
                    $btn.prop('disabled', true);
                } else {
                    $btn.prop('disabled', false);
                }
                const $div = $('#evaluation-master-set');
                if (check.text === 'hidden') {
                    $div.attr('hidden', true);
                } else {
                    $div.removeAttr('hidden');
                } 
                const $div2 = $('#cannot-be-changed'); 
                if (check.btn === 'disabled') {
                    $div2.prop('hidden', false);
                } else {
                    $div2.prop('hidden', true);
                }
            }
        });
    }catch(e){
        alert('referTreatment:' + e.message);
    }
}