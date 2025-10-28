/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/06/19
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package         :
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year'               :   {'type':'hidden'    , 'attr':'id'}
,   'group_cd'                  :   {'type':'hidden'    , 'attr':'id'}
,   'answer_no'                 :   {'type':'hidden'    , 'attr':'id'}
,   'times'                     :   {'type':'hidden'    , 'attr':'id'}
,   'questionnaire_cd'          :   {'type':'text'      , 'attr':'id'}
,   'employee_cd'               :   { 'type': 'text', 'attr': 'id' }
,   'comment'                   :   { 'type': 'text', 'attr': 'id' }
,   'ck_search'                 :   { 'type': 'checkbox', 'attr': 'id' }
,   'question_list'             :   {'attr' : 'list', 'item' : {
            'question'                  : {'type' : 'text'      , 'attr' : 'class'}
        ,   'sentence_answer'           : {'type' : 'text'      , 'attr' : 'class'}
        ,   'questionnaire_gyono'       : {'type' : 'text'      , 'attr' : 'class'}
        },
    },
};
$(function(){
    try{
        initEvents();
        initialize();
    }catch(e){
        alert('initialize: ' + e.message);
    }
});

/*
 * initEvents
 * @author    : nghianm – nghianm@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initEvents() {
    try{
    } catch(e){
        alert('initEvents: ' + e.message);
    }
}
/**
 * initialize
 *
 * @author    : nghianm – nghianm@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initialize() {
    try{
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var from = $('#from').val();
                var source_from = $('#source_from').val();
                // 
                if(from == 'odashboardmember' || from == 'odashboard')
                {
                    _backButtonFunction(from);
                }else if (source_from == 'odashboardmember' || source_from == 'odashboard'){
                    _backButtonFunction(source_from);
                }else{
                    _backButtonFunction('', true);
                }
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        //
        $('#ck_search').first().focus();
        $(document).on('click','#ck_search',function(e) {
            if($(this).prop('checked')){
                $('#employee_nm').val('');
            }
            else {
                $('#employee_nm').val($('#employee_nm_2').val());
            }
        });
        $(document).on('click' , '.btn-save' , function(e){
            try{
                jMessage(1, function(r) {
                    if ( r && _validate($('body'))) {
                        saveData();
                    }
                    else {
                        $('.num-length').removeClass('td-error');
                    }
                });
            } catch(e){
                alert('.btn-save:' + e.message);
            }
        });
    } catch(e){
        alert('initialize: ' + e.message);
    }
}

/**
 * save
 *
 * @author      :   nghianm - 2020/10/27 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        var list    = [];
        var param   = data['data_sql'];
        var div1 = $('#myTable tbody tr');
        div1.find('input[type=radio]').each(function(){
            if($(this).prop('checked')){
                list.push({
                    'questionnaire_gyono':$(this).closest('tr').find('.questionnaire_gyono').val(),
                    'points_answer':$(this).val(),
                });
            }
        })
        param.list_points_answer    =   list;
        // }
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/oneonone/oi3010/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            // do something
                            var from = $('#from').val();
                            var source_from = $('#source_from').val();
                            // 
                            if (from == 'odashboardmember' || from == 'odashboard') {
                                _backButtonFunction(from);
                            } else if (source_from == 'odashboardmember' || source_from == 'odashboard') {
                                _backButtonFunction(source_from);
                            } else {
                                _backButtonFunction('', true);
                            }
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