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
    'comment_name'              : {'type' : 'text', 'attr' : 'id'},
    'comment_name_typ'           : {'type' : 'text', 'attr' : 'id'},
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
        referData();
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
     //change fiscal_year
    $(document).on('change' , '#fiscal_year' , function(e){
        try{
            // $('.show-all').trigger('click');
            referData();
        } catch(e){
            alert('#fiscal_year:' + e.message);
        }
    });
    //save
    $(document).on('click' , '.btn-save' , function(e){
        try{
            jMessage(1, function(r) {
                if ( r && _validate($('body'))) {
                    saveData();
                }
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
}
/**
 * save
 *
 * @author      :   nghianm - 2020/09/25 - create
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
            url         :   '/oneonone/om0100/refer',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        if(res.data[1][0].count_data == 0) {
                            console.log(1);
                            $('#target1_name').val('WILL');
                            $('#target2_name').val('CAN');
                            $('#target3_name').val('MUST');
                            $('#comment_name').val(string);
                            $('#target1_use_typ').val('1');
                            $('#target2_use_typ').val('1');
                            $('#target3_use_typ').val('1');
                            $('#comment_name_typ').val('1');
                            $('#target1_name').parents('.wrapper').show();
                            $('#target2_name').parents('.wrapper').show();
                            $('#target3_name').parents('.wrapper').show();
                            $('#comment_name').parents('.wrapper').show();
                            $('#count_data').val('0');
                            $('#unregistered').removeClass('hidden');
                        }
                        else {
                            console.log(2);

                            $('#target1_name').val(htmlEntities(res.data[0][0].target1_nm));
                            $('#target2_name').val(htmlEntities(res.data[0][0].target2_nm));
                            $('#target3_name').val(htmlEntities(res.data[0][0].target3_nm));
                            $('#comment_name').val(htmlEntities(res.data[0][0].comment_nm));
                            $('#target1_use_typ').val(res.data[0][0].target1_use_typ);
                            $('#target2_use_typ').val(res.data[0][0].target2_use_typ);
                            $('#target3_use_typ').val(res.data[0][0].target3_use_typ);
                            $('#comment_name_typ').val(res.data[0][0].comment_use_typ);
                            $('#count_data').val('1');
                            if(res.data[0][0].target1_use_typ == 1) {
                                $('#target1_name').parents('.wrapper').show();
                            }
                            else {
                                $('#target1_name').parents('.wrapper').hide();
                            }
                            if(res.data[0][0].target2_use_typ == 1) {
                                $('#target2_name').parents('.wrapper').show();
                            }
                            else {
                                $('#target2_name').parents('.wrapper').hide();
                            }
                            if(res.data[0][0].target3_use_typ == 1) {
                                $('#target3_name').parents('.wrapper').show();
                            }
                            else {
                                $('#target3_name').parents('.wrapper').hide();
                            }
                            if(res.data[0][0].comment_use_typ == 1) {
                                $('#comment_name').parents('.wrapper').show();
                            }
                            else {
                                $('#comment_name').parents('.wrapper').hide();
                            }
                            $('#unregistered').addClass('hidden');
                        }
                        _formatTooltip();
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
        alert('referData' + e.message);
    }
}
/**
 * save
 *
 * @author      :   nghianm - 2020/09/25 - create
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
            url         :   '/oneonone/om0100/save',
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
 * @author      :   nghianm - 2020/10/23 - create
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
            url         :   '/oneonone/om0100/del',
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