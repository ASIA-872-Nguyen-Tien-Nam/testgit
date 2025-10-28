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
$(document).ready(function () {
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
    try {
    } catch (e) {
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
    try {

        //btn-data-input
        $(document).on('click', '#btn-data-input', function (e) {
            try {
                var import_file = $('#import_file')[0].files[0];
                if (import_file != undefined) {
                    jMessage(6, function () {
                        importCSV();
                    });
                } else {
                    jMessage(21, function (r) {
                    });
                }
            } catch (e) {
                alert('btn-data-input: ' + e.message);
            }
        });
        // add by tuyendn 2022/09/18
		$(document).on('click', '.lh-input-custom', function () {
		    $("#import_file").trigger("click");
		});
		// add by tuyendn 2022/09/18
		$(document).on('change','#import_file',function(e){
			var files = e.target.files;
			var text_no_file = $('#text_no_file').val();
			if(files.length > 0){
				var filename = files[0].name;
				$('.ln-text-file').text(filename);
			}else{
				$('.ln-text-file').text(text_no_file);
			}
			 
		})

        //btn-data-input
        $(document).on('click', '#btn-data-output', function (e) {
            try {
                exportCSV();
            } catch (e) {
                alert('btn-data-output: ' + e.message);
            }
        });
        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            // window.location.href = '/dashboard'
            if (_validateDomain(window.location)) {
                window.location.href = 'sdashboard';
            } else {
                jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
            }
        });
        // hidden import button
        $('#table_key').on('change', function() {
            const selectedItem = $('#table_key').find(":selected");
            const authM0070 = selectedItem.data('auth');
            if(authM0070 == 2) {
                $(".nav-item #btn-data-input").addClass('d-none');
            } else {
                $(".nav-item #btn-data-input").removeClass('d-none');
            }
            var key_option = parseInt($('#table_key').val());
            if(key_option==1||key_option==2||key_option==3||key_option==4||key_option==5||key_option==6||key_option==7||key_option==10) {
                $('.label_common').attr('hidden',false)
            } else {
                $('.label_common').attr('hidden',true)
            }
        });
    } catch (e) {
        alert('initEvents:' + e.message);
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
    try {
        var data = {};
        var table_key = $('#table_key').val();
        data.table_key = table_key;
        //
        $.ajax({
            type: 'POST',
            url: '/basicsetting/o0100/export',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        var csv_name = '';
                        if (table_key == 1) {
                            csv_name = office_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 2) {
                            csv_name = organization_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 3) {
                            csv_name = job_mater.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 4) {
                            csv_name = position_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 5) {
                            csv_name = grade_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 6) {
                            csv_name = employee_classification_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 7) {
                            csv_name = employee_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 8) {
                            csv_name = employee_transfer_history_master.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 9) {
                            csv_name = optional_info.replace(/\s/g, '')+'.csv';
                        } else if (table_key == 10) {
                            csv_name = mail_password.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 11){
                            csv_name = employee_setting_info.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 12){
                            csv_name = employee_setting_qualification.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 13){
                            csv_name = employee_setting_academic.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 14){
                            csv_name = employee_setting_contact.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 15){
                            csv_name = employee_setting_work.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 16){
                            csv_name = employee_setting_family.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 17){
                            csv_name = employee_setting_leave.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 18){
                            csv_name = employee_setting_contract.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 19){
                            csv_name = employee_setting_social_insurance.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 20){
                            csv_name = employee_setting_salary.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 21){
                            csv_name = employee_setting_training_history.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 22){
                            csv_name = employee_setting_work_history.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 23){
                            csv_name = export_all.replace(/\s/g, '')+'.csv';
                        } else if(table_key == 24){
                            csv_name = employee_setting_rewards.replace(/\s/g, '')+'.csv';
                        } else {
                            csv_name = '';
                        }
                        //
                        var filedownload = res['FileName'];
                        var real_file_name = res['real_file_name'];
                        if (filedownload != '' && filedownload != '[]') {
                            if (table_key == 9) {
                                array_filedownload = jQuery.parseJSON(filedownload);
                                array_real_file_name = jQuery.parseJSON(real_file_name);
                                $.each(array_filedownload, function (index, value) {
                                    setTimeout(function () {
                                        downloadfileHTML('/download/' + value, employee_add.replace(/\s/g, '') + '(' + array_real_file_name[index] + ')' + '.csv', function () {
                                        //
                                        });
                                    }, index * 1000);
                                });
                            } else {
                                downloadfileHTML('/download/' + filedownload, csv_name, function () {
                                    //
                                });
                            }
                        } else {
                            jMessage(21);
                        }
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
    try {
        // var data = {};
        // data.import_file = $('');
        var table_key = $('#table_key').val();
        var formData = new FormData();
        var text_no_file = $('#text_no_file').val();
        formData.append('file', $('#import_file')[0].files[0]);
        formData.append('table_key', table_key)
        var name_file = $('#import_file')[0].files[0].name;
        //
        $.ajax({
            type: 'POST',
            data: formData,
            url: '/basicsetting/o0100/import',
            loading: true,
            processData: false,
            contentType: false,
            enctype: "multipart/form-data",
            success: function (res) {
                //
                switch (res['status']) {
                    // success
                    case 200:
                        jMessage(7, function (r) {
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
                        jMessage(31, function (r) {
                            $("#import_file").val("");
                            $('.ln-text-file').text(text_no_file);
                        });
                        break;
                    case 207:
                        var filedownload = res['FileName'];
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, name_file.split('.').slice(0, -1) + '_'+error+'.csv', function () {
                                //
                            });
                        }
                        break;
                    // not eligible
                    case 163:
                        jMessage(163);
                        break;
                    // Exception
                    case EX:
                        //jError(res['Exception']);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
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