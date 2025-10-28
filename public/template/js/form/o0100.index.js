/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/09/17
 * 作成者          :   sondh – sondh@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
};
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
 * @author      :   sondh - 2018/10/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   sondh - 2018/10/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    try{

        //btn-data-input
        $(document).on('click', '#btn-data-input', function(e) {
            try{
                var import_file = $('#import_file')[0].files[0];
                if(import_file != undefined){
                    jMessage(6,function(){
                        importCSV();
                    });
                }else{
                    jMessage(21, function (r) {
                    });
                }
            }catch (e) {
                alert('btn-data-input: '+ e.message);
            }
        });
        //btn-data-input
        $(document).on('click', '#btn-data-output', function(e) {
            try{
                exportCSV();
            }catch (e) {
                alert('btn-data-output: '+ e.message);
            }
        });
        //btn-back
        $(document).on('click', '#btn-back', function(e) {
            // window.location.href = '/dashboard'
            if(_validateDomain(window.location)){
                window.location.href = '/dashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        });
    } catch(e){
        alert('initEvents:'+e.message);
    }
}
/**
 * exportCSV
 *
 * @author      :  sondh - 2018/10/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
    try{
        var data    = {};
        var table_key = $('#table_key').val();
        data.table_key = table_key;
        //
        $.ajax({
            type        :   'POST',
            url         :   '/master/o0100/export',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                // success
                switch (res['status']) {
                    case OK:
                        var csv_name = '';
                        if(table_key == 1){
                            csv_name = '事業所マスタ.csv';
                        }else if(table_key == 2){
                            csv_name = '組織マスタ.csv';
                        }else if(table_key == 3){
                            csv_name = '職種マスタ.csv';
                        }else if(table_key == 4){
                            csv_name = '役職マスタ.csv';
                        }else if(table_key == 5){
                            csv_name = '等級マスタ.csv';
                        }else if(table_key == 6){
                            csv_name = '社員区分マスタ.csv';
                        }else if(table_key == 7){
                            csv_name = '社員マスタ.csv';
                        }else if(table_key == 8){
                            csv_name = '社員異動履歴マスタ.csv';
                        }else if(table_key == 9){
                            csv_name = 'ユーザーマスタ.csv';
                        }else{
                            csv_name = '';
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
 * @author      :  sondh - 2018/10/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function importCSV() {
    try{
        // var data = {};
        // data.import_file = $('');
        var table_key = $('#table_key').val();
        var formData = new FormData();
        formData.append('file', $('#import_file')[0].files[0]);
        formData.append('table_key',table_key)
        var name_file = $('#import_file')[0].files[0].name;
        //
        $.ajax({
            type        :   'POST',
            data        :   formData,
            url         :   '/master/o0100/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function(res) {
                //
                switch (res['status']){
                    // success
                    case 200:
                        jMessage(7, function(r) {
                            location.reload();
                        });
                        break;
                    // error
                    case 201:
                        jMessage(22);
                        break;
                    case 205:
                        jMessage(27);
                        break;
                    case 206:
                        jMessage(31, function(r) {
                            $("#import_file").val("");
                        });
                        break;
                    case 207:
                        var filedownload    =   res['FileName'];
                        if(filedownload != ''){
                            downloadfileHTML(filedownload ,name_file.split('.').slice(0, -1)+'_エラー.csv' , function () {
                                //
                            });
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
        alert('importCSV: ' + e.message);
    }
}
/**
 * readURL
 *
 * @author      :   sondh - 2018/09/18 - create
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
}