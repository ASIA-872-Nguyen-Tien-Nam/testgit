/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2020/09/15
 * 作成者		    :	nghianm – nghianm@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year'              : {'type' : 'select', 'attr' : 'id'},
    'target1_name'              : {'type' : 'text', 'attr' : 'id'},
    'target1_use_typ'           : {'type' : 'text', 'attr' : 'id'},
    'target2_name'              : {'type' : 'text', 'attr' : 'id'},
    'target2_use_typ'           : {'type' : 'text', 'attr' : 'id'},
    'target3_name'              : {'type' : 'text', 'attr' : 'id'},
    'target3_use_typ'           : {'type' : 'text', 'attr' : 'id'},
    'target4_name'              : {'type' : 'text', 'attr' : 'id'},
    'target4_use_typ'           : {'type' : 'text', 'attr' : 'id'},
    'target5_name'              : {'type' : 'text', 'attr' : 'id'},
    'target5_use_typ'           : {'type' : 'text', 'attr' : 'id'},
};
$(function(){
    initEvents();
    initialize();
    //calcTable();
});

/**
 * initialize
 *
 * @author		:	nghianm - 2020/09/15 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	nghianm - 2020/09/15 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    //back
    $(document).on('click', '#btn-back', function (e) {
        try {
            // 
            var home_url = $('#home_url').attr('href');
            _backButtonFunction(home_url);
        } catch (e) {
            alert('#btn-back:' + e.message);
        }
    });
    //show-all
    $(document).on('click', '.show-all', function (e) {
        try{
            $('.wrapper').show();
            $('.wrapper table thead tr .ics-group input').val('1');
        } catch(e){
            alert('.show-all:' + e.message);
        }
    });
    $(document).on('click','.btn-remove-row',function () {
        try{
            $(this).parents('tr').remove();
        } catch(e){
            alert('.btn-remove-row:' + e.message);
        }
    });

    $(document).on('click','.ics-edit',function(e) {
        try{
            e.preventDefault();
            if($(this).closest('.ics-wrap-disabled').length < 1){
              var container = $(this).closest('.d-flex');
              container.find('input').removeAttr('readonly').select();;
            }
        } catch(e){
            alert('.ics-edit:' + e.message);
        }
    });
    $(document).on('blur','.ics-textbox input',function() {
        try{
            $(this).attr('readonly','readonly');
        } catch(e){
            alert('.ics-textbox input:' + e.message);
        }
    });
    $(document).on('click', '.ics-eye', function (e) {
        try{
            e.preventDefault();
            $(this).parents('.wrapper').hide();
            $(this).parents('.ics-group').find('input').val('0');
        } catch(e){
            alert('.ics-eye:' + e.message);
        }
    });
    //save
    $(document).on('click' , '.btn-save' , function(e){
        try{
            jMessage(1, function(r) {
                saveData();
            });
        } catch(e){
            alert('.btn-save:' + e.message);
        }
    });
    //delete
    $(document).on('click', '#btn-delete', function(){
        try{
            var count_data = $('#count_data').val();
            if(count_data==0) {
                jMessage(23, function(r) {
                    return;
                });
            }
            else {
                jMessage(3, function(r) {
                    if (r) {
                        del();
                    }
                });
            }
        } catch(e){
            alert('#btn-delete:' + e.message);
        }
    });
    //change fiscal_year
    $(document).on('change' , '#fiscal_year' , function(e){
        try{
            // $('.show-all').trigger('click');
            referData();
        } catch(e){
            alert('#fiscal_year:' + e.message);
        }
    });
}
/**
 * refer
 *
 * @author      :   quangnd - 2023/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function referData(){
    try {
        var data    = {
            'fiscal_year' : $('#fiscal_year').val()
        };
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0020/refer',
            dataType    :   'html',
            loading     :   true,
            data        :   data,
            success: function(res) {
                $('#target-content').empty().html(res);
                _formatTooltip();
                $('#fiscal_year').focus();
                $('#count_data').val() == 0 ?$('#unregistered').removeClass('hidden') : $('#unregistered').addClass('hidden');
            }
        });
    } catch (e) {
        alert('referData' + e.message);
    }
}
/**
 * save
 *
 * @author      :   quangnd - 2023/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0020/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            $('#fiscal_year').trigger('change');
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
 * @author      :   quangnd - 2023/04/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function del(){
    try {
        var data    = {
            'fiscal_year' : $('#fiscal_year').val()
        };
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/weeklyreport/rm0020/del',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(4, function(r) {
                            $('#fiscal_year').trigger('change');
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