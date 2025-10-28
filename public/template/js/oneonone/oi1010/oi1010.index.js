
/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/02/05
 * 作成者          :   phuhv – phuhv@ans-asia.com
 *
 * @package         :
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'list_schedule'    : {'attr' : 'list', 'item' : {
        'times'                 : {'type' : 'text', 'attr' : 'class'},
        'oneonone_title'        : {'type' : 'text', 'attr' : 'class'},
        'start_date'            : {'type' : 'text', 'attr' : 'class'},
        'deadline_date'         : {'type' : 'text', 'attr' : 'class'},
        'oneonone_alert'        : {'type' : 'text', 'attr' : 'class'},
    }}
};
 $(function(){
    try{
        initEvents();
        initialize();
    }catch(e){
        alert('initialize: ' + e.message);
    }
});
/**
 * initialize
 *
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
 function initialize() {
    try{
        $('.oneonone_group').multiselect('rebuild');
        $('.oneonone_group').trigger('change');

    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * initEvents
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
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
                alert('#btn-back:' + e.message);
            }
        });
        $(document).on('change', '#oneonone_group', function(e) {
            if($('input[type=checkbox]:checked').length > 0){
                refer();
            }
        })
        $(document).on('change', '#fiscal_year', function(e) {
            if($('input[type=checkbox]:checked').length > 0){
                refer();
            }
        })
        $(document).on('click', '.btn-save', function(e) {
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))){
                        saveData();
                    }
                });
            } catch(e){
                alert('.btn-save: ' + e.message);
            }
        });
         //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try{
                jMessage(3, function (r) {
                    if (r) {
                        deleteData();
                    }
                })
            }catch(e){
                alert('#btn-delete :' + e.message);
            }
        });
        //
    } catch(e){
        alert('initEvents: ' + e.message);
    }
}
/**
 * refer
 *
 * @author      :   datnt - 2020/11/10 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function refer() {
    try {
        var list = [];
        data= {};
        var div1 = $('#oneonone_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function(){
            if($(this).prop('checked')){
                list.push({'oneonone_group':$(this).val()});
            }
        });
        data.fiscal_year = $('#fiscal_year').val();
        data.oneonone_group_list = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/oi1010/refer',
            dataType: 'html',
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                $('#refer_data').empty();
                $('#refer_data').append(res);
                app.jTableFixedHeader();
                jQuery.formatInput('#refer_data');
            }
        });
    } catch (e) {
        alert('refer' + e.message);
    }
}
/**
 * save
 *
 * @author      :   binhnn - 2018/09/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        var list = [];
        var div1 = $('#oneonone_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function(){
            if($(this).prop('checked')){
                list.push({'oneonone_group':$(this).val()});
            }
        });
        data.data_sql.oneonone_group_list = list;
        data.data_sql.fiscal_year = $('#fiscal_year').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oi1010/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            $('#oneonone_group').trigger('change');
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
 * delete
 *
 * @author      :   SonDH - 2018/09/18 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var list = [];
        data= {};
        var div1 = $('#oneonone_group').closest('.multi-select-full');
        div1.find('input[type=checkbox]').each(function(){
            if($(this).prop('checked')){
                list.push({'oneonone_group':$(this).val()});
            }
        });
        data.fiscal_year = $('#fiscal_year').val();
        data.oneonone_group_list = list;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/oneonone/oi1010/delete',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //location.reload();
                        jMessage(4, function () {
                            location.reload();
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
        alert('deleteData' + e.message);
    }
}