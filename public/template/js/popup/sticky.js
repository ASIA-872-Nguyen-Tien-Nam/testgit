$(document).ready(function () {
    try {
        initEvents();
        // initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});

// /**
//  * initialize
//  * 
//  * @author      :   viettd - 2023/02/13 - create
//  * @return      :   null
//  */
// function initialize() {
//     try {

//     } catch (e) {
//         alert('initialize: ' + e.message);
//     }
// }

/**
 * initEvents
 * 
 * @author      :   viettd - 2023/02/13 - create
 * @author      :   
 * @return      :   null
 */
function initEvents() {
    try {
        $(document).on('click', '.btn-sticky', function (e) {
            try {
                var sticky = $(this);
                $('.sticky .btn-sticky').each(function(){
                    $(this).removeClass('active');
                });
                // 
                sticky.addClass('active');
                // if ($(this).hasClass('active')) {
                //     $(this).removeClass('active');
                // } else {
                //     $(this).addClass('active');
                // }
            } catch (e) {
                alert('btn-sticky: ' + e.message);
            }
        });
        $(document).on('click', '#btn-sticky', function (e) {
            try {
                jMessage(1,function (r) {
                    if (r) {
                        saveData();
                    }
                })
            } catch (e) {
                alert('#btn-sticky: ' + e.message);
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * save
 * 
 * @author      :   longvv - 2018/09/05 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function saveData() {
    try {
        var data = {};
        data.fiscal_year = $('#sticky_data').attr('fiscal_year');
        data.employee_cd = $('#sticky_data').attr('employee_cd');
        data.report_kind = $('#sticky_data').attr('report_kind');
        data.report_no = $('#sticky_data').attr('report_no');
        data.note_explanation = $('#note_explanation').val();
        // get note_no
        data.note_no = 0;
        $('.btn-sticky').each(function(){
            if ($(this).hasClass('active')) {
                data.note_no = $(this).attr('note_no');
            }
        });
        var url = _customerUrl('/common/popup/sticky');
        // send data to post
        $.ajax({
            type: 'POST',
            url: url,
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
                            $('#btn-close-popup').trigger('click');
                            // parent.$('body').css('overflow', 'scroll');
                            parent.location.reload();    
                        
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