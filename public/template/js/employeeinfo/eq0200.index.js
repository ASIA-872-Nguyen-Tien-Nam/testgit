/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2024/03/01
 * 作成者          :   viettd – viettd@ans-asia.com
 *
 * @package        :   MODULE EMPLOYEE INFORMATION
 * @copyright      :   Copyright (c) ANS-ASIA
 * @version        :   1.0.0
 * ****************************************************************************
 */
var _obj_del = {
    'seat_del': {
        'attr': 'list', 'item': {
            'seat_item_employee_cd': { 'type': 'text', 'attr': 'class' },
        }
    },

};
var _flgLeft = 0;
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
 * @author      :   viettd - 2024/03/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try {
        dragSeat();
        _formatTooltip();
        $('.pagination a:not(.pagging-disable)').each(function (e) {
            $(this).attr('tabindex', 2);
        })
        if($('#leftcontent').length != 1){
            $('#rightcontent').addClass('rightcontent100')
            $('#rightcontent1').addClass('rightcontent100')
            $('#rightcontent1').find('.layout-width').removeAttr('style')
            $('#rightcontent1').find('.layout-width').attr('style','width: 1700px');
        } else {
            $('#rightcontent').removeClass('rightcontent100')
            $('#rightcontent1').removeClass('rightcontent100')
            $('#rightcontent1').find('.layout-width').removeAttr('style')
            $('#rightcontent1').find('.layout-width').attr('style','width: 1464px');
        }
        jQuery.initTabindex();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   viettd - 2024/03/01 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    try {
        /* paging */
        $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getRightEmployees(page, search);
        });
        $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function (e) {
            var page = $(this).attr('page');
            var search = $('#search_key').val();
            getRightEmployees(page, search);
        });
        $(document).on('click', '#btn-search-key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getRightEmployees(page, search);
        });
        $(document).on('change', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getRightEmployees(page, search);
        });
        $(document).on('enterKey', '#search_key', function (e) {
            var page = 1;
            var search = $('#search_key').val();
            getRightEmployees(page, search);
        });

        /* left content click item */
        $(document).on('click', '.list-search-child', function (e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            // getRightContent( $(this).attr('id') );
        });
        // seat_area enter
        // $(document).on('keypress', function (e) {
        //     if (e.which == 13) {
        //         $('#seat_selected').trigger('click');
        //     }
        // });
        // key_search
        $(document).on('click', '#btn_search', function () {
            try {
                let search_key = $('#key_search').val();
                let tab_id = '';
                $('.eq0200_tab').each(function () {
                    if ($(this).hasClass('active')) {
                        tab_id = $(this).attr('tab_id');
                    }
                });
                if (tab_id == 'organization') {
                    referOrganizationChart(search_key);
                } else if (tab_id == 'seat') {
                    referSeat($('#seat_area_select').val(), search_key);
                }
            } catch (e) {
                console.log('#key_search: ' + e.message);
            }
        });
        // btn_organization_charts_output
        $(document).on('click', '#btn_organization_charts_output', function (e) {
            try {
                e.preventDefault();
                if (_validate($("body"))) {
                    exportExcel();
                }
            } catch (e) {
                console.log('#btn_organization_charts_output: ' + e.message);
            }
        });
        // personal_setting_btn
        $(document).on('click', '#personal_setting_btn', function () {
            try {
                personalSetting();
            } catch (e) {
                console.log('#personal_setting_btn: ' + e.message);
            }
        });
        // seat_selected
        $(document).on('click touchend', '#seat_selected', function () {
            try {
                var typ = $('#seating_chart_typ').attr('value');
                if (typ == 1) {
                    var employee_cd = '';
                    $('.list-search-child').each(function () {
                        if ($(this).hasClass('active')) {
                            employee_cd = $(this).attr('id');
                        }
                    });
                    if (employee_cd == '') {
                        jMessage(18);
                        return;
                    }
                } else {
                    var employee_cd = $('#employee_cd_login').val();
                }
                let x = $('#seat_selected').offset().left;
                let y = $('#seat_selected').offset().top;
                addSeat(employee_cd, x, y);
            } catch (e) {
                console.log('#seat_selected: ' + e.message);
            }
        });
        
        $('.seat_item').on('click', function(){
            $('.seat_item').removeClass('seat_del_no');
            $(this).addClass('seat_del_no');
        });

        $(document).on('click', '.seat_item', function () {
            try {
                var offset = $('#rightcontent').width();
                if ($(this).offset().left > (offset - 5)) {
                    $(this).closest('.seat-group').find('.dropdown-menu').removeClass('dropdown-menu-seat');
                } else {
                    $(this).closest('.seat-group').find('.dropdown-menu').addClass('dropdown-menu-seat');
                }
                let seat_mode = $('#seat_mode').val();
                if (seat_mode == 0) {
                    let seating_chart_typ = $('#seating_chart_typ').val();
                    let btn_seat_register = $('#btn_seat_register').val();
                    if ((seating_chart_typ == 1 && btn_seat_register == 1) || seating_chart_typ == 2) {
                        if (seating_chart_typ == 2) {
                            $(this).addClass('seat_del');
                            // $(this).closest('.seat-group').find('.btn-delete').css('display','none');
                            $(this).draggable({
                                scroll: true,
                                containment: '#seat_area',
                                start: function () {
                                    // $(this).closest('.seat-group').find('.dropdown-menu').removeClass('show');
                                },
                                stop: function () {
                                    employee_cd = $(this).find('.seat_item_employee_cd').attr('value')
                                    let x = $(this).offset().left;
                                    let y = $(this).offset().top;
                                    addSeat(employee_cd, x, y);
                                    $(this).draggable('disable');
                                    $(this).removeClass('seat_del');
                                }
                            });
                            $(this).draggable('enable');
                        } else {
                            $(this).addClass('seat_del');
                            $(this).draggable({
                                scroll: true,
                                containment: '#seat_area',
                                start: function () {
                                    // $(this).closest('.seat-group').find('.dropdown-menu').removeClass('show');
                                },
                                stop: function () {
                                    employee_cd = $(this).find('.seat_item_employee_cd').attr('value')
                                    let x = $(this).offset().left;
                                    let y = $(this).offset().top;
                                    addSeat(employee_cd, x, y);
                                    $(this).draggable('disable');
                                    $(this).removeClass('seat_del');
                                }
                            });
                            $(this).draggable('enable');
                        }
                    } else {
                        $(this).closest('.seat-group').find('.btn-delete').css('display','none');
                    }
                }
            } catch (e) {
                console.log('#seat_selected: ' + e.message);
            }
        });
        // btn-add-new
        $(document).on('click', '#btn-add-new', function () {
            try {
                // set mode screen
                let mode = $('#seat_mode').val();
                if (mode == 0) {
                    $('#seat_mode').val(1);
                    $('.suggest_text').show();
                    $('#seat_selected').show();
                    $('.seat_item').removeClass('seat_del');
                    $('.seat_item').dropdown('dispose').removeAttr('data-toggle');
                    $('#rightcontent').scrollLeft(1400);
                    $('#rightcontent1').scrollLeft(1400);
                } else {
                    $('#seat_area_select').trigger('change');
                    $('#seat_mode').val(0);
                    $('.suggest_text').hide();
                    $('#seat_selected').hide();
                    $('.seat_item').attr('data-toggle', 'dropdown');
                }
                // 
            } catch (e) {
                console.log('#btn-add-new: ' + e.message);
            }
        });
        // seat_item
        $(document).on('click', '.btn-profile', function () {
            try {
                let seat_mode = $('#seat_mode').val();
                let employee_cd = $(this).closest('.seat-group').find('.seat_item_employee_cd').val();
                if (seat_mode == 0) {
                    seatDetail(employee_cd);
                }
            } catch (e) {
                console.log('.seat_item: ' + e.message);
            }
        });
        // btn-organization
        $(document).on('click', '.btn-organization', function () {
            try {
                organization_typ = $(this).attr('organization_typ');
                lv = $(this).attr('lv');
                if ($(this).hasClass('active')) {
                    hideOrg($(this));
                    if (typeof lv == 'undefined') {
                        for (let index = Number(organization_typ) + 1; index < 6; index++) {
                            organization = $(this).closest('.organization_charts').find('.btn-organization[organization_typ=' + index + ']');
                            organization.closest('.row').css('display', 'none');
                            hideOrg(organization);
                        }
                    } else {
                        checkSubGroup($(this), organization_typ, hide = 1)
                    }
                } else {
                    showOrg($(this));
                    if (typeof lv == 'undefined') {
                        for (let index = Number(organization_typ) + 1; index < 6; index++) {
                            organization = $(this).closest('.organization_charts').find('.btn-organization[organization_typ=' + index + ']');
                            organization.closest('.row').css('display', 'block');
                            showOrg(organization);
                        }
                    } else {
                        checkSubGroup($(this), organization_typ, hide = 0)
                    }
                }
            } catch (e) {
                console.log('.btn-organization: ' + e.message);
            }
        });
        // click organization-card
        $(document).on('click', '.organization-card', function () {
            try {
                var employee_cd = $(this).attr('employee_cd');
                seatDetail(employee_cd);
            } catch (e) {
                console.log('click btn_output: ' + e.message);
            }
        });
        // seat_area_select
        $(document).on('change', '#seat_area_select', function () {
            try {
                let floor_id = $(this).val();
                referSeat(floor_id);
                $('#key_search').val('');
            } catch (e) {
                console.log('click seat_area_select: ' + e.message);
            }
        });
        // change evaluation_typ
        $(document).on('click', '.page-item', function (e) {
            try {
                e.preventDefault();
                if (_validate()) {
                    //
                    var page_size = $('#cb_page').val();
                    var page = $(this).attr('page');
                    search(page, page_size);
                }
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        // change evaluation_typ
        $(document).on('change', '#cb_page', function (e) {
            try {
                e.preventDefault();
                if (_validate()) {
                    //
                    var page_size = $(this).val();
                    var page = 1;
                    $('.page-item').each(function () {
                        if ($(this).hasClass('active')) {
                            page = $(this).attr('page');
                        }
                    });
                    search(page, page_size);
                }
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });

        // btn-search
        $(document).on('click', '#btn-search', function (e) {
            try {
                e.preventDefault();
                var page_size = $('#cb_page').val();
                var page = $(this).attr('page');
                search(page, page_size);
            } catch (e) {
                alert('#btn-search:' + e.message);
            }
        });
        // click row search
        $(document).on('click', '.employee_link', function () {
            try {
                let tr = $(this).closest('tr');
                let employee_cd = tr.attr('employee_cd') ?? '';
                seatDetail(employee_cd);
            } catch (e) {
                console.log('.seat_item: ' + e.message);
            }
        });
        //autocomplate
        $(document).on('focus', '.autocomplete-down', function (e) {
            try {
                var data = $(this).attr('availableData').split(',');
                $(this).autocomplete({
                    source: data,
                    minLength: 0,
                    open: function (event, ui) {
                        var $input = $(event.target);
                        var $results = $input.autocomplete("widget");
                        var scrollTop = $(window).scrollTop();
                        var top = $results.position().top;
                        var height = $results.outerHeight();

                        if (top + height > $(window).innerHeight() + scrollTop) {
                            newTop = top - height - $input.outerHeight();
                            if (newTop > scrollTop)
                                $results.css("top", newTop + "px");
                        }
                    }
                }).on('focus', function () { $(this).keydown(); });
            } catch (e) {
                alert('#btn-item-evaluation-input1 :' + e.message);
            }
        });
        $(document).on('keyup', '.autocomplete-down', function (e) {
            try {
                var input = $(this).val();
                if (input == ' ' || input == '　') {
                    $(this).val('');
                }
            } catch (e) {
                alert('#btn-item-evaluation-input1 :' + e.message);
            }
        });

        $(document).on('click', '#btn-back', function (e) {
            window.location.href    =   '/menu';
        });

        $(document).on('click', '.btn-delete', function () {
            try {
                let employee_cd = $(this).closest('.seat-group').find('.seat_item_employee_cd').val();
                jMessage(3, function (r) {
                    if (r) {
                        deleteData(employee_cd);
                    }
                });
            } catch (e) {
                console.log('#btn-add-new: ' + e.message);
            }
        });

         // change evaluation_typ
         $(document).on('click', '.btn-refresh', function (e) {
            try {
                e.preventDefault();
                let floor_id = $('#seat_area_select').val();
                referSeat(floor_id,'',1);
            } catch (e) {
                alert('btn_search: ' + e.message);
            }
        });
        $("#rightcontent").on( 'scroll', function(){
            $("#rightcontent1")
                .scrollLeft($("#rightcontent").scrollLeft());
        });
        $("#rightcontent1").on( 'scroll', function(){
            $("#rightcontent")
                .scrollLeft($("#rightcontent1").scrollLeft());
        });
    }
    catch (e) {
        console.log('initEvents: ' + e.message);
    }
}

/**
 * referOrganizationChart
 * 
 * @param {String} search_key 
 */
function referOrganizationChart(search_key = '') {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/get_organization',
            dataType: 'html',
            loading: true,
            data: {
                'search_key': search_key
            },
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                $('#tab1').empty();
                $('#tab1').append(res);
                }
            }
        });
    } catch (e) {
        console.log('referOrganizationChart:' + e.message);
    }
}

/**
 * referSeat
 * 
 * @param {Int} floor_id 
 * @param {String} search_key 
 */
function referSeat(floor_id = 0, search_key = '', mode = 0) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/refer_seat',
            dataType: 'html',
            loading: true,
            data: {
                'floor_id': floor_id,
                'search_key': search_key
            },
            success: function (res) {
                let date = new Date()
                let format = moment().format('YYYY/MM/DD') +' '+ moment(date).format('HH:mm')
                $('#rightcontent1').scrollLeft(-1400);
                $('#rightcontent').scrollLeft(-1400);
                $('.sys_refer').text(format);
                $('.communication_content').empty();
                $('.communication_content').append(res);
                if($('#leftcontent').length != 1){
                    $('#rightcontent').addClass('rightcontent100')
                    $('#rightcontent1').addClass('rightcontent100')
                    $('#rightcontent1').find('.layout-width').removeAttr('style')
                    $('#rightcontent1').find('.layout-width').attr('style','width: 1700px');
                } else {
                    $('#rightcontent').removeClass('rightcontent100')
                    $('#rightcontent1').removeClass('rightcontent100')
                    $('#rightcontent1').find('.layout-width').removeAttr('style')
                    $('#rightcontent1').find('.layout-width').attr('style','width: 1464px');
                }
                $('#rightcontent1').scrollLeft(-1400);
                $('#rightcontent').scrollLeft(-1400);
                $('.suggest_text').hide();
                $('#seat_mode').val(0);
                dragSeat();
                if (mode == 0) {
                    $('.btn-seat').removeAttr('style');
                    $('.btn-seat').attr('style','display: flex;justify-content: flex-end;');
                    let seating_chart_typ = $('#seating_chart_typ').val();
                    let btn_seat_register = $('#btn_seat_register').val();
                    if ((seating_chart_typ == 1 && btn_seat_register == 1) || seating_chart_typ == 2) {
                        $('#btn-add-new').css('display', 'block');
                    } else {
                        $('#btn-add-new').css('display', 'none');
                    }
                }
                if (floor_id == 0) {
                    $('.btn-seat').removeAttr('style');
                    $('.btn-seat').attr('style','display: flex;justify-content: flex-end;');
                    $('#btn-add-new').css('display', 'block');
                }
                $('.seat_item').on('click', function(){
                    $('.seat_item').removeClass('seat_del_no');
                    $(this).addClass('seat_del_no');
                });
                $("#rightcontent").on( 'scroll', function(){
                    $("#rightcontent1")
                        .scrollLeft($("#rightcontent").scrollLeft());
                });
                $("#rightcontent1").on( 'scroll', function(){
                    $("#rightcontent")
                        .scrollLeft($("#rightcontent1").scrollLeft());
                });
            }
        });
    } catch (e) {
        console.log('referSeat:' + e.message);
    }
}

/**
 * personalSetting
 * 
 */
function personalSetting() {
    try {
        var option = {};
        showPopup('/common/popup/ei0200', option, function () { });
    } catch (e) {
        console.log('personalSetting:' + e.message);
    }
}

/**
 * Add a seat
 */
function addSeat(employee_cd, x, y) {
    try {
        let x_1 = $('#seat_area').offset().left;
        let y_1 = $('#seat_area').offset().top;
        data = {};
        data.floor_id = $('#seat_area_select').val();
        data.employee_cd = employee_cd;
        data.x = x - x_1;
        data.y = y - y_1;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/add_seat',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // reset seats
                if (typeof res.seat != 'undefined') {
                    let seat = res.seat;
                    let html = '';
                    html += '<div class="seat_item" style="left: ' + seat.x + 'px; top: ' + seat.y + 'px">';
                    html += '<div class="seat_item_extend">'
                    html += '<span>' + seat.employee_nm.substring(0, 4) + '</span>';
                    html += '<input type="hidden" class="seat_item_employee_cd" value="' + seat.employee_nm.substring(0, 4) + '">';
                    html += '</div>';
                    html += '</div>';
                    $(".seat_item").draggable({
                        scroll: false,
                        containment: '#seat_area',
                        stop: function () {
                            $(this).css('background-color', 'green');
                        }
                    });
                    $(".seat_item").draggable('disable');
                    $('.seat_item').css('background-color', '#2A70B8');
                    $('#seat_area').append(html);
                }
                // 
                // let button_text = buttonText();
                // $('#btn-add-new').text(button_text.btn_seat_register_text);
                $('#seat_mode').val(0);
                $('.suggest_text').hide();
                $('#seat_selected').hide();
                // 
                dragSeat();
                $('#seat_area_select').trigger('change');
            }
        });
    } catch (e) {
        console.log('addSeat:' + e.message);
    }
}

/*
 * view a seat
 * @author      :   manhnd
 * @created at  :   2024/03/06
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function seatDetail(employee_cd) {
    try {
        var option = {};
        url = `/common/popup/eq0200_board?employee_cd=${employee_cd}`;
        showPopup(url, option, function () { });
    } catch (e) {
        console.log('seatDetail: ' + e.message);
    }
}

/**
 * dragSeat
 */
function dragSeat() {
    try {
        // reset position
        $("#seat_selected").css('top', '0px');
        if($('#leftcontent').length != 1){
            $("#seat_selected").css('left', '1644px');
        } else {
            $("#seat_selected").css('left', '1408px');
        }
        // 
        $("#seat_selected").draggable({
            scroll: true,
            containment: '#seat_area',
            start: function () {
                $(this).css('background-color', 'white');
            },
            stop: function () {
                $(this).css('background-color', 'green');
                $(this).css('color', 'white');
                $('#seat_selected').trigger('click');
            }
        });
    } catch (e) {
        console.log('dragSeat:' + e.message);
    }
}

// /**
//  * buttonText
//  * @returns object
//  */
// function buttonText() {
//     try {
//         let obj = {};
//         let btn_cancel_text = 'キャンセル';
//         let btn_seat_register_text = '座席登録';
//         let language = $('#language_jmessages').val();
//         if (language == 'en') {
//             btn_cancel_text = 'Cancel';
//             btn_seat_register_text = 'Register Seat';
//         }
//         obj.btn_cancel_text = btn_cancel_text;
//         obj.btn_seat_register_text = btn_seat_register_text;
//         return obj;
//     } catch (e) {
//         console.log('buttonText:' + e.message);
//     }
// }

/**
 * hideOrg
 * 
 */
function hideOrg(org) {
    try {
        org.removeClass('active');
        org.addClass('inactive');
        org.find('span').empty();
        org.find('span').append('<i class="fa fa-plus"></i>');
        org.closest('.row').find('.organization_member').hide();
    } catch (e) {
        console.log('hideOrg:' + e.message);
    }
}
/**
 * showOrg
 * 
 */
function showOrg(org) {
    try {
        org.removeClass('inactive');
        org.addClass('active');
        org.find('span').empty();
        org.find('span').append('<i class="fa fa-minus"></i>');
        org.closest('.row').find('.organization_member').show();
    } catch (e) {
        console.log('showOrg:' + e.message);
    }
}
/**
 * find sub group => hide or show
 * 
 */
function checkSubGroup(org, organization_typ, hide) {
    try {
        org.closest('.organization_charts').find('.btn-organization[organization_typ=' + (Number(organization_typ) + 1) + ']').each(function (i, e) {
            lv_sub_2 = $(this).attr("lv");
            id_sub_2 = $(this).attr("lv").split('-')[0] ?? '';
            if (lv_sub_2 == id_sub_2 + '-' + lv) {
                showOrHide(hide, $(this))
                if ((Number(organization_typ) + 2) < 6) {
                    org.closest('.organization_charts').find('.btn-organization[organization_typ=' + (Number(organization_typ) + 2) + ']').each(function (i, e) {
                        lv_sub_3 = $(this).attr("lv");
                        id_sub_3 = $(this).attr("lv").split('-')[0] ?? '';
                        if (lv_sub_3 == id_sub_3 + '-' + lv_sub_2) {
                            showOrHide(hide, $(this))
                            if ((Number(organization_typ) + 3) < 6) {
                                org.closest('.organization_charts').find('.btn-organization[organization_typ=' + (Number(organization_typ) + 3) + ']').each(function (i, e) {
                                    lv_sub_4 = $(this).attr("lv");
                                    id_sub_4 = $(this).attr("lv").split('-')[0] ?? '';
                                    if (lv_sub_4 == id_sub_4 + '-' + lv_sub_3) {
                                        showOrHide(hide, $(this))
                                        if ((Number(organization_typ) + 4) < 6) {
                                            org.closest('.organization_charts').find('.btn-organization[organization_typ=' + (Number(organization_typ) + 4) + ']').each(function (i, e) {
                                                lv_sub_5 = $(this).attr("lv");
                                                id_sub_5 = $(this).attr("lv").split('-')[0] ?? '';
                                                if (lv_sub_5 == id_sub_5 + '-' + lv_sub_4) {
                                                    showOrHide(hide, $(this))
                                                }
                                            })
                                        }
                                    }
                                })
                            }
                        }
                    })
                }

            }
        })
    } catch (e) {
        console.log('showOrg:' + e.message);
    }
}

/**
 * ShowOrHide org
 * 
 */
function showOrHide(hide, org) {
    try {
        if (hide == 1) {
            org.closest('.row').css('display', 'none');
            hideOrg(org);
        } else {
            org.closest('.row').css('display', 'block');
            showOrg(org);
        }
    } catch (e) {
        console.log('showOrg:' + e.message);
    }
}

/**
 * Search 
 * 
 * @param {Int} page 
 * @param {Int} page_size 
 */
function search(page = 1, page_size = 20) {
    try {
        var data = {};
        var belong_cd1 = '-1';
        var belong_cd2 = '-1';
        var belong_cd3 = '-1';
        var belong_cd4 = '-1';
        var belong_cd5 = '-1';
        data.employee_cd = $('#employee_cd').val();
        data.employee_nm = $('#employee_nm').val();
        // 
        if ($('#organization_step1').length > 0) {
            let organization_step1 = $('#organization_step1').val();
            let arr = organization_step1.split('|');
            if (typeof arr[0] != 'undefined') {
                belong_cd1 = arr[0];
            }
        }
        if ($('#organization_step2').length > 0) {
            let organization_step2 = $('#organization_step2').val();
            let arr = organization_step2.split('|');
            if (typeof arr[1] != 'undefined') {
                belong_cd2 = arr[1];
            }
        }
        if ($('#organization_step3').length > 0) {
            let organization_step3 = $('#organization_step3').val();
            let arr = organization_step3.split('|');
            if (typeof arr[2] != 'undefined') {
                belong_cd3 = arr[2];
            }
        }
        if ($('#organization_step4').length > 0) {
            let organization_step4 = $('#organization_step4').val();
            let arr = organization_step4.split('|');
            if (typeof arr[3] != 'undefined') {
                belong_cd4 = arr[3];
            }
        }
        if ($('#organization_step5').length > 0) {
            let organization_step5 = $('#organization_step5').val();
            let arr = organization_step5.split('|');
            if (typeof arr[4] != 'undefined') {
                belong_cd5 = arr[4];
            }
        }
        data.belong_cd1 = belong_cd1;
        data.belong_cd2 = belong_cd2;
        data.belong_cd3 = belong_cd3;
        data.belong_cd4 = belong_cd4;
        data.belong_cd5 = belong_cd5;
        // 資格 + 業務経歴
        let cert_use_typ = '';
        let resume_use_typ = '';
        if ($('#cert_use_typ').length > 0) {
            cert_use_typ = $('#cert_use_typ').val();
        }
        if ($('#resume_use_typ').length > 0) {
            resume_use_typ = $('#resume_use_typ').val();
        }
        data.cert_use_typ = cert_use_typ;
        data.resume_use_typ = resume_use_typ;
        // items
        var list = [];
        $('.field_nm').each(function () {
            list.push({ 'field_cd': $(this).attr('field_cd'), 'field_val': $(this).val() });
        });
        data.items = list;
        data.page_size = page_size;
        data.page = page;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/search',
            dataType: 'html',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                $('#result').empty();
                $('#result').append(res);
                _formatTooltip()
                // tableContent();
                // app.jSticky();
                // app.jTableFixedHeader();
                // jQuery.initTabindex();
                // unFixedWhenSmallScreen();
                }
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
function getRightEmployees(page, search) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/rightcontent',
            dataType: 'html',
            loading: true,
            data: { current_page: page, search: search, mode: 1 },
            success: function (res) {
                $('#leftcontent').empty();
                $('#leftcontent').html(res);
                $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
                if(_flgLeft != 1){
                    $('#search_key').focus();
                }else{
                    _flgLeft = 0;
                }
                _formatTooltip();
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}

/**
 * saviiiie
 * 
 * @author      :   namnb - 2018/08/16 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function deleteData(employee_cd) {
    try {
        var data = getData(_obj_del);
        data.data_sql['seat_del']  =  [];
        data.data_sql['seat_del']  =  {'seat_item_employee_cd': employee_cd};
        data.rules['.seat_item_employee_cd'] = [];
		data.rules['.seat_item_employee_cd'] =  employee_cd;
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/employeeinfo/eq0200/del_seat',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(4, function (r) {
                            $('#seat_area_select').trigger('change');
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

/**
 * exportExcel
 * 
 * @author      :   hainn - 2024/05/02 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function exportExcel() {
    try {
        let search_key = $('#key_search').val();
        $.downloadFileAjax('/employeeinfo/eq0200/export',JSON.stringify(search_key));
    } catch (e) {
        alert('exportExcel' + e.message);
    }
}