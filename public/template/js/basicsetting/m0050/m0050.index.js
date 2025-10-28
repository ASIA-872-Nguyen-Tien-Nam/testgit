/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   datnt – datnt@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'tr'                 : {'attr' : 'list', 'item' : {
        'grade'          : {'type' : 'text', 'attr' : 'class'},
        'grade_nm'       : {'type' : 'text', 'attr' : 'class'},
    }}
};
var _value = '';
$(function(){
    initialize();
    initEvents();
    //calcTable();
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
    try{
        $("#table_data tbody tr:eq(0) input").focus();
        $('.indexTab').focus();
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
    document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
            if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").last()[0]) {
                e.preventDefault();
                $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first().focus();
            }
        }
    });
        $(document).on('click' , '#btn-save' , function(e){
            //$(this).blur(); // do not allow pressing enter key
            jMessage(1, function(r) {
                if ( r && m0050Validate() ) {
                    saveData();
                }
            });
        });
    }catch(e){
        alert('initEvents : ' + e.message);
    }
    
    //add new row
    $(document).on('click', '#add_new_row', function(){
        var html = $('#table_row_add').find('tbody').html();
        // var id = $('#main tr').last().find('.grade').val();
        var max = 0;
        $('#main tr').each(function(){
            var val = $(this).find('.grade').val();

            if( val != undefined && val*1 > max*1){
                max = val;
            }else if(val == undefined){
                max = 1;
            }
        })
        $('#table_data').find('tbody').append(html.replace('<tr>', '<tr class="tr">'));
        $('#main tr').last().find('.grade').val(max*1 + 1);
        $('#table_data').find('tbody tr:last-child input[type="text"]').focus();
    });
    // Remove row
    $(document).on('click', '.btn_remove', function(){
        //if($('#table_data tbody tr').length > 1) {
            $(this).closest('tr').remove();
        //}
    });
    $(document).on('click', '#btn-back', function(){
        // window.location.href = '/dashboard';
        if(_validateDomain(window.location)){
            window.location.href = 'sdashboard';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });

    $(document).on('mouseup', '#table_data tbody tr', function(){
        _value = $(this).find('input').val();
    });
    $("#table_data tbody").sortable({
        items: "> tr",
        appendTo: "parent",
        helper: "clone",
        // forceHelperSize: true,

    }).disableSelection();

    $("#table_data tbody tr").droppable({
        tolerance: "pointer",
        drop: function(e, ui) {
            var index = e.target.rowIndex;
            var value = $(this).find('input').val();
            $("#table_data tbody tr:eq("+index+")").after("<tr>" + ui.draggable.html() + "</tr>");
            $("#table_data tbody tr:eq("+(index+1)+")").remove();
        }
    });
}

/**
 * validate
 * 
 * @author      :   namnb - 2018/08/22 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function m0050Validate() {
    var required = _validate($('body'));
    var count = $('#table_data tbody tr').length;

    if (count == 0) jMessage(29);

    return required && count > 0;
}

/**
 * save
 * 
 * @author      :   namnb - 2018/08/16 - create
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
            url         :   '/basicsetting/m0050/save', 
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
                            location.reload();
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