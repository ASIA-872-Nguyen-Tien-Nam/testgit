/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/09/17
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
    'work_history_kbn'			    : {'type':'select', 'attr':'id'},
    'list_item'			:	{'attr':'list',	'item':{
        'item_id'					    :   {'type':'text',	'attr':'class'},
        'item_title'					:   {'type':'text',	'attr':'class'},
        'item_display_kbn'				:   {'type':'text',	'attr':'class'},
        'item_arrangement_column'		:   {'type':'text',	'attr':'class'},
        'item_arrangement_line'		    :   {'type':'text', 'attr':'class'},
    }},
   
};
var _flgLeft = 0;
//
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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        $('.focus').focus();
        sortable();
        positionCalculation();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
    try {
        /* paging */
        $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('click', '#btn-search-key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('change', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        $(document).on('enterKey', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getLeftContent(page, search);
        });
        //
        $(document).on('click', '.ics-edit', function (e) {
            e.preventDefault();
            if ($(this).closest('.ics-wrap-disabled').length < 1) {
                var container = $(this).closest('.d-flex');
                container.find('input').removeAttr('hidden').select();
                container.find('.text-name').css('display','none');
            }
        });
        //
        $(document).on('blur', '.ics-textbox input', function () {
            $(this).attr('hidden', 'hidden');
            $(this).closest('.ics-textbox').find('.text-name').css('display', 'flex');
            $(this).closest('.ics-textbox').find('.text-name').empty().text($(this).val());
        });
        //
        $(document).on('keyup', '.ics-textbox input', function (e) {
            if (e.keyCode == 13) {
                $(this).blur();
            }
        });
        //
        // $(document).on('mouseup', function (e) {
        //     var input = $('.ics-textbox input');
        //     if (!$(e.target).is(':input')) {
        //         $('.ics-textbox input').attr('readonly', 'readonly');
        //     }
        // });

        //btn-add-new
        $(document).on('click', '#btn-add-new', function (e) {
            try {
                jMessage(5, function () {
                    //    clearRightContent();
                    location.reload();
                })
            } catch (e) {
                alert('btn-add-new: ' + e.message);
            }
        });
        //btn-save
        $(document).on('click', '#btn-save', function (e) {
            jMessage(1, function(r) {
                _flgLeft = 1; 
                if ( r && _validate($('body')) ) {
                    saveData();
                }
            });
        });
        //btn-show
        $(document).on('click', '#btn-show-all', function (e) {
            $('#sortable').each(function () {
                $(this).find('.ics-hide').show();
                $(this).find('.display_typ').val(1);

                $(this).find('.ics-hide').removeClass('d-none').removeClass('ics-hide');
            });
            $('.item_display_kbn').attr('value',1);
            positionCalculation();
        });
        //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try {
                jMessage(3, function (r) {
                    _flgLeft = 1;
                    if (r) {
                        deleteData();
                    }
                })
            } catch (e) {
                alert('#btn-delete :' + e.message);
            }
        });
        /* left content click item */
        $(document).on('click', '.list-search-child', function (e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var work_history_kbn = $(this).attr('id');
            getRightContent(work_history_kbn);
        });

        /* change option work*/
        $(document).on('change', '#work_history_kbn', function (e) {
            $('.list-search-child').removeClass('active');
            var work_history_kbn = $(this).val();
            $('#'+ work_history_kbn).addClass('active');
            getRightContent(work_history_kbn);
        });

        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            // window.location.href = '/dashboard'
            if (_validateDomain(window.location)) {
                window.location.href = 'edashboard';
            } else {
                jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
            }
        });

        $(document).on('click','.ics-eye2',function(e) {
            var index = $(this).closest('li').index() + 1;
            $(this).closest('ul').find('li:nth-child('+index+')').addClass('ics-hide d-none');
            $(this).closest('ul').find('li:nth-child('+index+')').find('.item_display_kbn').attr('value',0);
            $(this).closest('ul').find('li:nth-child('+index+')').find('.item_arrangement_column').attr('value',0);
            $(this).closest('ul').find('li:nth-child('+index+')').find('.item_arrangement_line').attr('value',0);
            var row = $(this).closest('ul').find('li:nth-child('+index+')').clone();
            $(this).closest('ul').append(row);
            $(this).closest('ul').find('li:nth-child('+index+')').remove();
            positionCalculation();
        });

        // check focus to popup
        $(document).on('click','#sortable li',function(e) {
            list_item_select = ['li-12','li-13','li-14','li-15','li-16','li-17','li-18','li-19','li-20','li-21']
            $('#sortable li').css('border','1px solid #c5c5c5');
            $('#sortable li').removeClass('selection');
            if (list_item_select.includes($(this).attr('id'))) {
                $(this).css('border','2px solid rgb(112 112 112)');
                $(this).addClass('selection');
            }
        });
        //show popup btn-create-selection
        $(document).on('click', '#btn-create-select', function (e) {
            try {
                var option = {};
                if ($('#sortable li').hasClass('selection')) {
                    let id = Number($('.selection').attr('id').split('-')[1]);
                    let work_history_kbn = $('#work_history_kbn').val();
                    var width = $(window).width();
                    if ((width <= 1368) && (width >= 1300)) {
                        option.width = '55%';
                        option.height = '76%';
                    } else {
                        if (width <= 1300) {
                            option.width = '82%';
                            option.height = '60%';
                        } else {
                            option.width = '770px';
                            option.height = '620px';
                        }
                    }
                    if ( _validate($('body')) ) {
                        showPopup('/employeeinfo/em0020/popup/selection?id='+id+'&work_history_kbn=' + work_history_kbn,option,function () { });
                    }
                } else {
                    jMessage(18);
                }
            } catch (e) {
                alert('#btn-create-category: ' + e.message);
            }
        });

    } catch (e) {
        alert('initEvents:' + e.message);
    }
}
/**
 * getLeftContent
 *
 * @author      :   TrinhDT - 2024/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/em0020/leftcontent',
            dataType: 'html',
            loading: true,
            data: { current_page: page, search_key: search },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    if (_flgLeft != 1) {
                        $('#search_key').focus();
                    } else {
                        _flgLeft = 0;
                    }
                    $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
                    //
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}
/**
 *    getRightContent
 *
 * @author      :   trindt - 2024/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(work_history_kbn) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/em0020/rightcontent',
            dataType: 'html',
            loading: true,
            data: {'work_history_kbn': work_history_kbn},
            success: function (res) {
                $('#right-respon').empty();
                $('#right-respon').append(res);
                $('#work_history_kbn').val(work_history_kbn);
                $('#work_history_kbn').focus();
                $('#work_history_kbn').removeClass('boder-error');
                $('#work_history_kbn').next('.textbox-error').remove();
                $('#rightcontent .calHe').removeClass('has-copy');
                positionCalculation();
                sortable();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * saveData
 *
 * @author      :   trinhdt - 2024 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveData(){
    var data = getData(_obj);
    $.ajax({
        type : 'POST',
        data: JSON.stringify(data),
        url: '/employeeinfo/em0020/save',
        loading: true,
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
               case 404:
                   jMessage(27);
               break;
               // Exception
               case EX:
               jError(res['Exception']);
               break;
               default:
               break;
           }
       }
   })
}
/**
 * delete
 *
 * @author      :  trinhdt - 2024 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.work_history_kbn = $('#work_history_kbn').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/em0020/delete',
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
                            //
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#work_history_kbn').focus();
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
        alert('delete' + e.message);
    }
}

/**
 *  sortable drag and drop position calculation
 *
 * @author      :   trindt - 2024/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function sortable() {
    $( "#sortable" ).sortable({
        stop: function(event, ui) {
            positionCalculation();
        }
    });
    $( "#sortable" ).disableSelection();
};

/**
 *  position calculation
 *
 * @author      :   trindt - 2024/03 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function positionCalculation() {
    var col = 6;
    var line = 1;
    $('#sortable').find('li').not('.ics-hide,.d-none').each(function (i,e) {
        col = col - Number($(this).attr('col-size'));
        if (col < 0) {
            col = 6 - Number($(this).attr('col-size'));
            line = line + 1
        }
        if ($(this).attr('col-size') == '1') {
            item_arrangement_column = 6 - col;
        }
        if ($(this).attr('col-size') == '2') {
            item_arrangement_column = 6 - (col + 1);
        }
        if ($(this).attr('col-size') == '6') {
            item_arrangement_column = 6 - (col + 5);
        }
        $(this).find('.item_arrangement_column').attr('value',item_arrangement_column);
        $(this).find('.item_arrangement_line').attr('value',line);
    })
};