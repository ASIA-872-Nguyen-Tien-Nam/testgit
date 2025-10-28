/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/10/08
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'beginning_date'                    : {'type':'text', 'attr':'id'},
    'beginning_date_1on1'               : { 'type': 'text', 'attr': 'id' },
    'beginning_date_report'             : {'type':'text', 'attr':'id'},
    'password_length'                   : {'type':'text', 'attr':'id'},
    'password_character_limit'          : {'type':'select', 'attr':'id'},
    'password_age'                      : { 'type': 'text', 'attr': 'id' },
    'mypurpose_use_typ'                 : {'type':'text', 'attr':'id'},
    // 'empinf_user_typ'                   : {'type':'select', 'attr':'id'},
    // 'cert_user_typ'                     : {'type':'checkbox', 'attr':'class'},
    // 'resume_user_typ'                   : {'type':'checkbox', 'attr':'class'},
    'empinf_user_typ'                   : {'type':'select', 'attr':'id'},
    'empsrch_user_typ'                  : {'type':'checkbox', 'attr':'id'},
    'empcom_user_typ'                   : {'type':'checkbox', 'attr':'id'},
    'cert_user_typ'                     : {'type':'checkbox', 'attr':'id'},
    'resume_user_typ'                   : {'type':'checkbox', 'attr':'id'},
    'multilingual_option_use_typ'       : {'type':'select', 'attr':'id'},
}
$(function(){
  try{
	if ($('#language_jmessages').val() == 'en') {
		$('.commuting').css('flex', '0 0 8.7%')
		$('.row-dis').addClass('checkbox-en')
	}
    initialize();
    initEvents();
  }catch(e){
    alert('initialize: ' + e.message);
  }
});
/**
 * initialize
 *
 * @author    : nghianm - 2020/10/08 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try{
        $.formatInput('div.content');
        checkDisplayRadio()
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author    : nghianm - 2020/10/08 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initEvents() {
      //password_length
    $(document).on('change','#password_length',function () {
        try{
            var password_length   =   $(this).val()*1;
            if(password_length > 20){
                $(this).val('');
            }
        } catch(e){
            alert('password_length: ' + e.message);
        }
    });
    $(document).on('click', '#btn-back', function(e) {
        try{
            jMessage(71, function(r) {
                if(r){
                    if(_validateDomain(window.location)){
                        window.location.href = 'sdashboard';
                    }else{
                        jError('エラー','このプロトコル又はホストドメインは拒否されました。');
                    }
                }
            });
        }catch(e){
            alert('#btn-back'+e.message);
        }
    });

    $(document).on('click', '#btn-save', function(e) {
        getDataCheckbox();
        jMessage(86, function(r) {
            if ( r && _validate($('body')) ) {
                saveData();
            }
        });
    });
    $(document).on('change','#empinf_user_typ',function () {
        try{
            checkDisplayRadio()
        } catch(e){
            alert('password_length: ' + e.message);
        }
    });
    $(document).on('change','#empsrch_user_typ',function () {
        try{
            checkDisplayRadio()
        } catch(e){
            alert('password_length: ' + e.message);
        }
    });
    $(document).on('change','#empcom_user_typ',function () {
        try{
            checkDisplayRadio()
        } catch(e){
            alert('password_length: ' + e.message);
        }
    });
    $(document).on('click', '#add_row_sm0100', function(e) {
        try{
            var count = $("#add_row .col-auto").length;
            if (count <20) {
            var newHtml = $("#template_add_row").html();
            $("#add_row").append(newHtml);
             // Sau khi thêm row mới, khởi tạo lại autocomplete
            $(".language_find").autocomplete({
                source: _language_name.map(function(lang) {
                    return {
                        label: lang.language_name,  // Hiển thị trong dropdown
                        value: lang.language_cd     // Giá trị khi chọn
                    };
                }),
                minLength: 0,
                focus: function(event, ui) {
                    event.preventDefault();
                },
                select: function(event, ui) {
                    $(this).val(ui.item.label);  // Hiển thị language_name khi chọn
                    $(this).closest('div').find('.language_cd').val(ui.item.value);
                    $(this).data('selected', true);
                    return false;  // Ngăn không cho giá trị bị thay đổi thành language_cd
                }
            }).on("focus click", function () {
                var inputVal = $(this).val().trim();
                if (inputVal === "") {
                    $(this).autocomplete("search", ""); // Nếu ô trống, hiển thị tất cả gợi ý
                } else {
                    $(this).autocomplete("search", inputVal); // Nếu có giá trị, chỉ hiển thị gợi ý phù hợp
                }
            });
            }
        } catch(e){
            alert('#add_row_sm0100: ' + e.message);
        }
    });
    $(document).on('blur', '.language_find', function() {
        var inputVal = $(this).val().trim();
        var languageCdInput = $(this).closest('div').find('.language_cd');
        // Kiểm tra nếu giá trị trong ô input không có trong danh sách
        var isValid = false;
        _language_name.forEach(function(lang) {
            if (inputVal === lang.language_name) {              
                languageCdInput.val(lang.language_cd)
                isValid = true;
            }
        });
    
        // Nếu không chọn từ pulldown, xóa giá trị
        if (!isValid) {
            $(this).val('');
            $(this).closest('div').find('.language_cd').val('');
        }
    });
    $(".language_find").autocomplete({
        source: _language_name.map(function (lang) {
            return {
                label: lang.language_name,  // Hiển thị trong dropdown
                value: lang.language_cd     // Giá trị khi chọn
            };
        }),
        minLength: 0,
        focus: function(event, ui) {
            event.preventDefault();
        },
        select: function (event, ui) {
            $(this).val(ui.item.label);  // Hiển thị language_name khi chọn
            $(this).closest('div').find('.language_cd').val(ui.item.value);
            $(this).data('selected', true);
            return false;  // Ngăn không cho giá trị bị thay đổi thành language_cd
        }
    }).on("focus click", function () {
        var inputVal = $(this).val().trim();
        if (inputVal === "") {
            $(this).autocomplete("search", ""); // Nếu ô trống, hiển thị tất cả gợi ý
        } else {
            $(this).autocomplete("search", inputVal); // Nếu có giá trị, chỉ hiển thị gợi ý phù hợp
        }
    });
}
/**
 * save
 *
 * @author      :   nghianm - 2020/10/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var values = [];
        $("#add_row .language_cd").each(function(index){
            values.push({ 
                "index": index,
                "language_cd": $(this).val() 
            });
        });
        //check trùng lặp
        const seen = new Set();
        const duplicates = new Set();
        for (const item of values) {
            const value = item["language_cd"];
            if (value === "") continue;
            if (seen.has(value)) {
                duplicates.add(value);
            } else {
                seen.add(value);
            }
        }
        const check =[];
        if (duplicates.size > 0) {
            const duplicateArray = Array.from(duplicates);
            $("#add_row .language_cd").each(function(index){ 
                if (duplicateArray.includes($(this).val() )){
                    check.push({
                        "message_no": "32",
                        "item": ".language_find",
                        "order_by": "0",
                        "error_typ": "0",
                        "value1": (index+1).toString(), // Chỉ số trùng lặp
                        "value2": "0",
                        "remark": ""
                    });
                }
            });
            processError(check);
        return
        }    
        var data={}
        data =getData(_obj);
        data.data_sql['obj']    =  getDataCheckbox();
        data.data_sql['empsrch_user_typ']    =  $("#empsrch_user_typ").prop("checked") ? 1 : 0;
        data.data_sql['empcom_user_typ']    =  $("#empcom_user_typ").prop("checked") ? 1 : 0;
        data.data_sql['cert_user_typ']    =  $("#cert_user_typ").prop("checked") ? 1 : 0;
        data.data_sql['resume_user_typ']    =  $("#resume_user_typ").prop("checked") ? 1 : 0;
        data.data_sql['language_cd']        = values;
        
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/basicsetting/sm0100/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            location.reload();
                        });
                        break;
                    // error
                    case NG:
                        if(typeof res['errors'] != 'undefined'){
                            processError(res['errors']);
                            $(".btn-ok").click(function () {
                                let firstErrorElement = null;
                                res['errors'].forEach((item) => {
                                    if (item.item === ".language_find") {
                                        let index = parseInt(item.value1); // Chuyển value1 thành index (giả sử value1 bắt đầu từ 1)
                                        let inputElement = $(".language_find").eq(index);
                                        inputElement.addClass("boder-error");
                        
                                        // Focus vào phần tử đầu tiên có lỗi
                                        if (!firstErrorElement) {
                                            firstErrorElement = inputElement;
                                        }
                                    }
                                });
                                if (firstErrorElement) {
                                    firstErrorElement.focus();
                                }
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
    } catch (e) {
        alert('save' + e.message);
    }
}

/**
 * checkDisplay Radio
 *
 * @author      :   trinhdt- create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function checkDisplayRadio() {
    try {
        var option = $('#empinf_user_typ').val();
            if(option == '1'){
                $('.row-group').css('display', 'block');
                if ($("#empsrch_user_typ").is(':checked')) {
                    $('.row-dis').find('input').attr('disabled', false);
                } else {
                    $('.row-dis').find('input').attr('disabled', true);
                    $('.row-dis').find('input').prop('checked', false);
                }
                if ($("#empcom_user_typ").is(':checked')) {
                    $('.row-dis-2').find('input').attr('disabled', false);
                } else {
                    $('.row-dis-2').find('input').attr('disabled', true);
                    $('.row-dis-2').find('input').prop('checked', false);
                }
            } else {
                $('.row-group').css('display', 'none');
                $('.row-dis-2').find('input').prop('checked', false);
                $('.row-dis').find('input').prop('checked', false);
                $('#empsrch_user_typ').prop('checked', false);
                $('#empcom_user_typ').prop('checked', false);
            }
    } catch (e) {
        alert('save' + e.message);
    }
}
function getDataCheckbox() {
	try {
		var checkboxes = $('.tab_checkbox');
        var jsonData = [];
        
        checkboxes.each(function() {
            var tab_id = $(this).attr('tab_id');
            var tab_nm = $(this).attr('tab_nm');
            var isChecked = $(this).is(':checked') ? 1 : 0;
            jsonData.push({ tab_id: tab_id, tab_nm: tab_nm, isChecked: isChecked });
        });
        
        var jsonString = jsonData;
        return jsonString;

	} catch (e) {
		alert('_formatString: ' + e);
	}
}