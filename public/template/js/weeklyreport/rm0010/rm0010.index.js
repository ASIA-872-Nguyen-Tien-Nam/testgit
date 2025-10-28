/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/25
 * 作成者          :   datnt – viettd@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'annual_report_typ': { 'type': '', 'attr': 'id' },
    'target_self_assessment_typ': { 'type': '', 'attr': 'id' },
    'first_annual_report_typ': { 'type': '', 'attr': 'id' },
    'second_annual_report_typ': { 'type': '', 'attr': 'id' },
    'third_annual_report_typ': { 'type': '', 'attr': 'id' },
    'fourth_annual_report_typ': { 'type': '', 'attr': 'id' },
    'semi_annual_report_typ': { 'type': '', 'attr': 'id' },
    'first_semi_annual_report_typ': { 'type': '', 'attr': 'id' },
    'second_semi_annual_report_typ': { 'type': '', 'attr': 'id' },
    'third_semi_annual_report_typ': { 'type': '', 'attr': 'id' },
    'fourth_semi_annual_report_typ': { 'type': '', 'attr': 'id' },
    'quarterly_report_typ': { 'type': '', 'attr': 'id' },
    'first_quarterly_report_typ': { 'type': '', 'attr': 'id' },
    'second_quarterly_report_typ': { 'type': '', 'attr': 'id' },
    'third_quarterly_report_typ': { 'type': '', 'attr': 'id' },
    'fourth_quarterly_report_typ': { 'type': '', 'attr': 'id' },
    'monthly_report_typ': { 'type': '', 'attr': 'id' },
    'first_monthly_report_typ': { 'type': '', 'attr': 'id' },
    'second_monthly_report_typ': { 'type': '', 'attr': 'id' },
    'third_monthly_report_typ': { 'type': '', 'attr': 'id' },
    'fourth_monthly_report_typ': { 'type': '', 'attr': 'id' },
    'weekly_report_typ': { 'type': '', 'attr': 'id' },
    'first_weekly_report_typ': { 'type': '', 'attr': 'id' },
    'second_weekly_report_typ': { 'type': '', 'attr': 'id' },
    'third_weekly_report_typ': { 'type': '', 'attr': 'id' },
    'fourth_weekly_report_typ': { 'type': '', 'attr': 'id' },
    'sticky_2': {
        'attr': 'list', 'item': {
            'note_name': { 'type': 'text', 'attr': 'id' },
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'note_color': {'type' : 'text', 'attr' : 'id'},
        }
    },
    'sticky': {
        'attr': 'list', 'item': {
            'note_name': { 'type': 'text', 'attr': 'class' },
            'detail_no': { 'type': 'text', 'attr': 'id' },
            'note_color': { 'type': 'text', 'attr': 'id' },
        }
    },
    'viewer_sharing' : {'type':'checkbox', 'attr':'id'},
    'share_notify_reporter': { 'type': 'checkbox', 'attr': 'id' },
    'viewable_deadline_kbn' : {'type':'checkbox', 'attr':'id'},
    'approver' : {'type':'checkbox', 'attr':'id'},
    'viewer' : {'type':'checkbox', 'attr':'id'},
    'weeklyreport_deadline': { 'type': 'select', 'attr': 'id' },
    'monthlyreport_deadline' : {'type':'select', 'attr':'id'},
    'comment_option_use_typ' : {'type':'select', 'attr':'id'},
    'weeklyreport_judgment_date' : {'type':'select', 'attr':'id'},
}
$(function () {
    try {
        initialize();
        initEvents();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
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
    try {
        $.formatInput('div.content');
    } catch (e) {
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
    $(document).on('blur', '.adjustpoint_to,.adjustpoint_from', function () {
        try {
            var adjustpoint = $(this).val() * 1;
            if (adjustpoint > 100 || adjustpoint < -100) {
                $(this).val('');
                $(this).focus();
            }
        } catch (e) {
            alert('adjustpoint: ' + e.message);
        }
    });
    $(document).on('click', '.dropdown-item', function () {

        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_2").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color")); //note
        $('#color_selected').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon_1', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_div_1").remove();
        if ($('#btn_add_sticky').length < 1) {
            $('#row_sticky').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        }
        else {
            $('#btn_add_sticky').attr('number', number)
        }
    });
    $(document).on('click', '#close_icon_2', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_div_2").remove();
        if ($('#btn_add_sticky').length < 1) {
            $('#row_sticky').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_1', function () {


        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_div_1").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_1').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_1_1', function () {
        $('.dropdown-menu').removeClass('show');
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $($(this)).closest(".sticky").css("background-color", $(this).attr("value"));
        $('#color_selected_1_1').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_1_2', function () {
        $('.dropdown-menu').removeClass('show');
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $($(this)).closest(".sticky").css("background-color", $(this).attr("value"));
        $('#color_selected_1_2').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_1_3', function () {
        $('.dropdown-menu').removeClass('show');
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $($(this)).closest(".sticky").css("background-color", $(this).attr("value"));
        $('#color_selected_1_3').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_1_4', function () {
        $('.dropdown-menu').removeClass('show');
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $($(this)).closest(".sticky").css("background-color", $(this).attr("value"));
        $('#color_selected_1_4').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_1_5', function () {
        $('.dropdown-menu').removeClass('show');
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $($(this)).closest(".sticky").css("background-color", $(this).attr("value"));
        $('#color_selected_1_5').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '.dropdown-item_2', function () {

        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_div_2").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_2').attr('value', $(this).attr("value"))
    });

    $(document).on('click', '.dropdown-item_3', function () {

        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_div_3").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_3').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon_3', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_div_3").remove();
        if ($('#btn_add_sticky').length < 1) {
            $('#row_sticky').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_4', function () {

        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_div_4").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_4').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon_4', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_div_4").remove();
        if ($('#btn_add_sticky').length < 1) {
            $('#row_sticky').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_5', function () {

        $('.dropdown-menu').removeClass('show');
        $($(this)).closest(".sticky_div_5").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_5').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon_5', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_div_5").remove();
        if ($('#btn_add_sticky').length < 1) {
            $('#row_sticky').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky').attr('number', number)
        }
    });
    $(document).on('click', '.sticky_div_1', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_div_text_1').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_1"  cols="30" style="border:none" rows="10" value="' + $("#label_text_1").text() + '">')
            $('#label_text_1').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon_1").css("display", '');
            $("#option_icon_1").css("display", '');
        }
    });
    $(document).on('click', '.sticky_div_2', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_div_text_2').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_2"  cols="30" style="border:none" rows="10"value="' + $("#label_text_2").text() + '">')
            $('#label_text_2').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon_2").css("display", '');
            $("#option_icon_2").css("display", '');
        }
    });
    $(document).on('click', '.sticky_div_3', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_div_text_3').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_3"  cols="30" style="border:none" rows="10"value="' + $("#label_text_3").text() + '">')
            $('#label_text_3').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon_3").css("display", '');
            $("#option_icon_3").css("display", '');
        }
    });
    $(document).on('click', '.sticky_div_4', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_div_text_4').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_4"  cols="30" style="border:none" rows="10"value="' + $("#label_text_4").text() + '">')
            $('#label_text_4').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon_4").css("display", '');
            $("#option_icon_4").css("display", '');
        }
    });
    $(document).on('click', '.sticky_div_5', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_div_text_5').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_5"  cols="30" style="border:none" rows="10"value="' + $("#label_text_5").text() + '">')
            $('#label_text_5').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon_5").css("display", '');
            $("#option_icon_5").css("display", '');
        }
    });
    $(document).on("keydown", '.sticky_div_1', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_div_text_1').append('<p style="color:black" id="label_text_1">' + $("#sticky_text_1").val() + '</p><input class="note_name" hidden value=' + $("#sticky_text_1").val()  + '>')
                $(this).addClass('unactive');
                $('#sticky_div_text_1').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_text_1").remove();
                $("#close_icon_1").css("display", 'none');
                $("#option_icon_1").css("display", 'none');
            }
        }
    });

    $(document).on("keydown", '.sticky_div_2', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_div_text_2').append('<p style="color:black" id="label_text_2">' + $("#sticky_text_2").val() + '</p><input class="note_name" hidden value=' + $("#sticky_text_2").val()  + '>')
                $(this).addClass('unactive');
                $('#sticky_div_text_2').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_text_2").remove();
                $("#close_icon_2").css("display", 'none');
                $("#option_icon_2").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_div_3', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_div_text_3').append('<p style="color:black" id="label_text_3">' + $("#sticky_text_3").val() + '</p><input class="note_name" hidden value=' + $("#sticky_text_3").val()  + '>')
                $(this).addClass('unactive');
                $('#sticky_div_text_3').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_text_3").remove();
                $("#close_icon_3").css("display", 'none');
                $("#option_icon_3").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_div_4', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_div_text_4').append('<p style="color:black" id="label_text_4">' + $("#sticky_text_4").val() + '</p><input class="note_name" hidden value=' + $("#sticky_text_4").val()  + '>')
                $(this).addClass('unactive');
                $('#sticky_div_text_4').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_text_4").remove();
                $("#close_icon_4").css("display", 'none');
                $("#option_icon_4").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_div_5', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_div_text_5').append('<p style="color:black" id="label_text_5">' + $("#sticky_text_5").val() + '</p><input class="note_name" hidden value=' + $("#sticky_text_5").val()  + '>')
                $(this).addClass('unactive');
                $('#sticky_div_text_5').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_text_5").remove();
                $("#close_icon_5").css("display", 'none');
                $("#option_icon_5").css("display", 'none');
            }
        }
    });
    $(document).on('click', '#btn_add_sticky', function (e) {
        var number = 1;
        if (!$(".sticky_div_1")[0]) {
            number = 1
        } else if (!$(".sticky_div_2")[0]) {
            number = 2
        } else if (!$(".sticky_div_3")[0]) {
            number = 3
        }
        else if (!$(".sticky_div_4")[0]) {
            number = 4
        }
        else {
            number = 5
        }
        $('#btn_add_sticky').remove();
        $('#row_sticky').append('<div class="col-lg-2 mr-2 col-md-2 col-sm-6 col-12 sticky sticky_div_' + number + ' col-md-auto active  btn-outline-brand-xl" style="display:flex;min-height: 52px;padding:7px; background:'+$('#color_value_1').attr('value')+'"' + 'note_color="1">' +
            '<input class="detail_no" value="" type="hidden" hidden />' +
            '<div class="dropdown"  style="padding-top: 6px;"><i class="fa fa-ellipsis-h mt-2 mr-2"  id="option_icon_' + number + '" style="font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i' + '>' +
            '<div class="dropdown-menu" id="color_' + number + '" aria-labelledby="dropdownMenuButton"' + '>' +
            '<a value_color="1" class="dropdown-item dropdown-item_1_' + number + '" style="height: 32px;background: '+$('#color_value_1').attr('value')+'" value="'+$('#color_value_1').attr('value')+'" ></a' + '>' +
            '<a value_color="2" class="dropdown-item dropdown-item_1_' + number + '" value="'+$('#color_value_2').attr('value')+'" style="height: 32px;background: '+$('#color_value_2').attr('value')+';" ></a' + '>' +
            '<a value_color="3" class="dropdown-item dropdown-item_1_' + number + '" value="'+$('#color_value_3').attr('value')+'" style="height: 32px;background: '+$('#color_value_3').attr('value')+';" ></a' + '>' +
            '<a value_color="4" class="dropdown-item dropdown-item_1_' + number + '" value="'+$('#color_value_4').attr('value')+'" style="height: 32px;background: '+$('#color_value_4').attr('value')+';" ></a' + '>' +
            '<a value_color="5" class="dropdown-item dropdown-item_1_' + number + '" value="'+$('#color_value_5').attr('value')+'" style="height: 32px;background: '+$('#color_value_5').attr('value')+';" ></a' + '>' +
            '<input class="note_color" value="1" type="hidden" hidden />' +
            '</div></div' + '>' +
            '<div cols="30"  id="sticky_div_text_' + number + '"' + '>' +
            '<input type="text" maxlength="10" class="form-control" name="" id="sticky_text_' + number + '" cols="30" style="border:none" rows="10"></input></div><div class="dropdown ml-2"' + '>' +
            '<input id="color_selected_' + number + '" value="'+$('#color_value_1').attr('value')+'" type="hidden"/' + '>' +
            '</div><i class="fa fa-close" number=' + number + ' id="close_icon_' + number + '" aria-hidden="true"></i></div>')
        $('.sticky_div_' + number + '').removeClass('unactive')
        $('.sticky_div_' + number + '').addClass('active')
        if ($('.sticky').length < 5) {
            $('#row_sticky').append('<button  number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        }
        $('#sticky_text_' + ($('.sticky').length) + '').focus();
    });
    $(document).on('click', '#adjustpoint_input_1', function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
            $(this).attr('value', 1);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeAttr('readonly');
            $('#adjustpoint_from_1,#adjustpoint_to_1').addClass('required');
            $('#adjustpoint_from_1').attr('tabindex', '1');
            $('#adjustpoint_to_1').attr('tabindex', '1');
            $('#adjustpoint_from_1').focus();
        } else {
            $(this).removeClass('active');
            $(this).attr('value', 0);
            $('#adjustpoint_from_1,#adjustpoint_to_1').attr('readonly', true);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('required');
            $('#adjustpoint_from_1').attr('tabindex', '-1');
            $('#adjustpoint_to_1').attr('tabindex', '-1');
        }
        $('#adjustpoint_from_1,#adjustpoint_to_1').next('.textbox-error').remove();
        $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_1');
        $.formatInput('#adjustpoint_to_1');
    });
    $(document).on('click', '#adjustpoint_input_2', function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
            $(this).attr('value', 1);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeAttr('readonly');
            $('#adjustpoint_from_2,#adjustpoint_to_2').addClass('required');
            $('#adjustpoint_from_2').attr('tabindex', '1');
            $('#adjustpoint_to_2').attr('tabindex', '1');
            $('#adjustpoint_from_2').focus();
        } else {
            $(this).removeClass('active');
            $(this).attr('value', 0);
            $('#adjustpoint_from_2,#adjustpoint_to_2').attr('readonly', true);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('required');
            $('#adjustpoint_from_2').attr('tabindex', '-1');
            $('#adjustpoint_to_2').attr('tabindex', '-1');
        }
        $('#adjustpoint_from_2,#adjustpoint_to_2').next('.textbox-error').remove();
        $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_2');
        $.formatInput('#adjustpoint_to_2');

    });
    $(document).on('click', '#adjustpoint_input_3', function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
            $(this).attr('value', 1);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeAttr('readonly');
            $('#adjustpoint_from_3,#adjustpoint_to_3').addClass('required');
            $('#adjustpoint_from_3').attr('tabindex', '1');
            $('#adjustpoint_to_3').attr('tabindex', '1');
            $('#adjustpoint_from_3').focus();
        } else {
            $(this).removeClass('active');
            $(this).attr('value', 0);
            $('#adjustpoint_from_3,#adjustpoint_to_3').attr('readonly', true);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('required');
            $('#adjustpoint_from_3').attr('tabindex', '-1');
            $('#adjustpoint_to_3').attr('tabindex', '-1');
        }
        $('#adjustpoint_from_3,#adjustpoint_to_3').next('.textbox-error').remove();
        $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_3');
        $.formatInput('#adjustpoint_to_3');

    });
    $(document).on('click', '#adjustpoint_input_4', function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
            $(this).attr('value', 1);
            $('#adjustpoint_from_4,#adjustpoint_to_4').removeAttr('readonly');
            $('#adjustpoint_from_4,#adjustpoint_to_4').addClass('required');
            $('#adjustpoint_from_4').attr('tabindex', '1');
            $('#adjustpoint_to_4').attr('tabindex', '1');
            $('#adjustpoint_from_4').focus();
        } else {
            $(this).removeClass('active');
            $(this).attr('value', 0);
            $('#adjustpoint_from_4,#adjustpoint_to_4').attr('readonly', true);
            $('#adjustpoint_from_4,#adjustpoint_to_4').removeClass('required');
            $('#adjustpoint_from_4').attr('tabindex', '-1');
            $('#adjustpoint_to_4').attr('tabindex', '-1');
        }
        $('#adjustpoint_from_4,#adjustpoint_to_4').next('.textbox-error').remove();
        $('#adjustpoint_from_4,#adjustpoint_to_4').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_4');
        $.formatInput('#adjustpoint_to_4');

    });
    //btn-add-row
    $(document).on('change', '.period_nm', function () {
        try {
            var period_nm = $(this).val();
            var _mmdd = $(this).closest('tr').find('.mmdd');
            if (period_nm != '') {
                _mmdd.addClass('required');
                jQuery.formatInput();
            } else {
                _mmdd.removeClass('required');
            }
            _clearErrors(1);
        } catch (e) {
            alert('period_nm: ' + e.message);
        }
    });
    //btn-add-row
    $(document).on('click', '#btn-add-new-1', function () {
        try {
            var html = $('#table-target-1').find('tbody').html();
            // var row = $("#table-target-1 tbody tr:first").clone();
            $('#table-data-1 tbody').append(html);
            $('#table-data-1 tbody tr:last').addClass('table_m0101');
            jQuery.formatInput();
            $('#table-data-1 tbody tr:last td:first-child span .period_nm').focus();
        } catch (e) {
            alert('btn-add-new-1: ' + e.message);
        }
    });
    //btn-add-row
    $(document).on('click', '.btn-remove-row', function () {
        try {
            $(this).parents('tr').remove();
        } catch (e) {
            alert('btn-remove-row: ' + e.message);
        }
    });
    $(document).on('click', '#btn-add-but-text', function () {
        var hidden = $('#group-but-text').is(':hidden');
        if (hidden) $('#group-but-text').toggle();
        $('input[name=textAdd]').focus();
        $('#group-but-text').attr('detail_no', 0);
        $('input[name=textAdd]').val('');
    });
    $('input[name=textAdd]').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        //
        var detail_no = $('#group-but-text').attr('detail_no');
        if (detail_no !== '0' && keycode == '13') {
            var parent = $('a.table_m0102.' + detail_no);
            var textAdd = $('#textAdd').val();
            if (textAdd.trim() != '') {
                parent.find('.input_treatment_applications_nm').val(textAdd);
                parent.find('.nm').empty().html(textAdd);
                //
                $('input[name=textAdd]').focus();
                $('#group-but-text').attr('detail_no', 0);
                $('input[name=textAdd]').val('');
            }
            return false;
        }
        //

        if (keycode == '13') {
            var textn = $('input[name=textAdd]').val();
            if (textn.trim() != '') {
                $('input[name=textAdd]').val('');
                $('.group-add-but').append(' <span class="bl102"><a href="javascript:;" class="btn btn-primary circle mt-10 table_m0102 0 zero">' +
                    '<input type="hidden" class="detail_no" value=0>'
                    + '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
                //
                $('#group-but-text').attr('detail_no', 0);
            }

        }
    });
    $(document).on('blur', 'input[name=textAdd]', function () {
        var detail_no = $('#group-but-text').attr('detail_no');
        if (detail_no !== '0') {
            var parent = $('a.table_m0102.' + detail_no);
            var textAdd = $('#textAdd').val();
            if (textAdd.trim() != '') {
                parent.find('.input_treatment_applications_nm').val(textAdd);
                parent.find('.nm').empty().html(textAdd);
            }
            return false;
        }
        //

        var textn = $('input[name=textAdd]').val();
        if (textn.trim() != '') {
            $('input[name=textAdd]').val('');
            $('.group-add-but').append(' <span class="bl102"><a href="javascript:;" class="btn btn-primary circle mt-10 table_m0102 0 zero">' +
                '<input type="hidden" class="detail_no" value=0>'
                + '<input type="hidden" class="input_treatment_applications_nm" value=' + textn + '><span>' + textn + '</span> <i class="fa fa-times mr0" aria-hidden="true" tabindex="4" style="opacity: 0;"></i></a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span>');
            //
            $('#group-but-text').attr('detail_no', 0);
        }
    });
    $(document).on('click', '.btn-remove-but', function () {
        $(this).parent().remove();
        //
        var detail_no = $(this).siblings('a').find('.detail_no')
        $('input[name=textAdd]').val('');
        $('#group-but-text').attr('detail_no', 0).removeClass(detail_no);
        $('#group-but-text').toggle();
    });
    $(document).on('click', '.table_m0102', function () {
        // can not edit for new
        if ($(this).hasClass('zero')) {
            return false;
        }
        //
        var hidden = $('#group-but-text').is(':hidden');
        if (hidden) $('#group-but-text').toggle();
        $('input[name=textAdd]')
            .val($(this).find('.input_treatment_applications_nm').val())
            .focus();
        $('#group-but-text').attr(
            'detail_no',
            $(this).find('.detail_no').val()
        )
            .addClass(
                $(this).find('.detail_no').val()
            );
    });
    $(document).on('click', '.target_typ', function () {
        var _this = $(this);
        var target_typ = _this.attr('target_typ');
        switch (target_typ) {
            case '1':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    // $('#first_annual_report_typ').removeClass('disabled');
                    $('#first_annual_report_typ').addClass('active');
                    $('#first_annual_report_typ').attr('value', 1);
                    // $('#target_evaluation_typ_1').removeClass('disabled');
                    // $('#first_annual_report_typ').addClass('active');
                    $('#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                    $('#second_annual_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('#first_annual_report_typ').attr('value', 0);
                    $('.target_typ').each(function () {
                        if ($(this).attr('target_typ') != '1') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '2':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#second_annual_report_typ').removeClass('disabled');
                    $('#first_annual_report_typ').addClass('active');
                    // $('#target_evaluation_typ_1').removeClass('disabled');
                    $('#second_annual_report_typ,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.target_typ').each(function () {
                        if ($(this).attr('target_typ') != '1' && $(this).attr('target_typ') != '2') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '3':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#third_annual_report_typ').removeClass('disabled');
                    $('#second_annual_report_typ').addClass('active');
                    $('#target_evaluation_typ_3,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.target_typ').each(function () {
                        if ($(this).attr('target_typ') != '1' && $(this).attr('target_typ') != '2' && $(this).attr('target_typ') != '3') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '4':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#fourth_annual_report_typ').removeClass('disabled');
                    $('#third_annual_report_typ').addClass('active');
                    $('#target_evaluation_typ_4,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.target_typ').each(function () {
                        if ($(this).attr('target_typ') == '5' || $(this).attr('target_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#evaluation_typ_2').hasClass('active')) {
                        $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
                    }
                }
                break;
            case '5':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#target_evaluation_typ_5,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.target_typ').each(function () {
                        if ($(this).attr('target_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#evaluation_typ_3').hasClass('active')) {
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
                break;
            default:
                return false;
                break;
        }
        _clearErrors(1);
        getActive();
    });
    $(document).on('click', '.evaluation_typ', function () {
        var _this = $(this);
        var evaluation_typ = _this.attr('evaluation_typ');
        switch (evaluation_typ) {
            case '1':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    // $('#first_semi_annual_report_typ').removeClass('disabled');
                    $('#first_semi_annual_report_typ').addClass('active');
                    $('#first_semi_annual_report_typ').attr('value', 1);
                    // $('#evaluation_typ_1').removeClass('disabled');
                    $('#evaluation_typ_2,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                    $('#second_semi_annual_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('#first_semi_annual_report_typ').attr('value', 0);
                    $('.evaluation_typ').each(function () {
                        if ($(this).attr('evaluation_typ') != '1') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '2':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#second_semi_annual_report_typ').removeClass('disabled');
                    $('#evaluation_typ_3,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.evaluation_typ').each(function () {
                        if ($(this).attr('evaluation_typ') != '1' && $(this).attr('evaluation_typ') != '2') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '3':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#third_semi_annual_report_typ').removeClass('disabled');
                    $('#evaluation_typ_4,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.evaluation_typ').each(function () {
                        if ($(this).attr('evaluation_typ') != '1' && $(this).attr('evaluation_typ') != '2' && $(this).attr('evaluation_typ') != '3') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#target_evaluation_typ_1').hasClass('active')) {
                        $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
                    }
                }
                break;
            case '4':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#fourth_semi_annual_report_typ').removeClass('disabled');
                    $('#evaluation_typ_5,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.evaluation_typ').each(function () {
                        if ($(this).attr('evaluation_typ') == '5' || $(this).attr('evaluation_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#target_evaluation_typ_2').hasClass('active')) {
                        $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
                    }
                }
                break;
            case '5':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#evaluation_typ_4,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.evaluation_typ').each(function () {
                        if ($(this).attr('evaluation_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#target_evaluation_typ_3').hasClass('active')) {
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
                break;
            // case '6':
            //     if (!_this.hasClass('active')) {
            //         _this.addClass('active');
            //         _this.attr('value', 1);
            //         $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
            //     } else {
            //         _this.removeClass('active');
            //         _this.attr('value', 0);
            //         if (!$('#target_evaluation_typ_4').hasClass('active')) {
            //             $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
            //         }
            //     }
            //     break;
            default:
                return false;
                break;
        }
        _clearErrors(1);
        getActive();
    });
    $(document).on('click', '.weekly_report_typ', function () {
        var _this = $(this);
        var target_typ = _this.attr('weekly_report_typ');
        switch (target_typ) {
            case '1':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#weekly_report_typ').removeClass('disabled');
                    // $('#weekly_report_typ_1').removeClass('disabled');
                    $('#weekly_report_typ').addClass('active');
                    $('#first_weekly_report_typ').addClass('active');
                    $('#first_weekly_report_typ').attr('value', 1);
                    $('#weekly_report_typ').attr('value', 1);
                    $('#second_weekly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('#first_weekly_report_typ').attr('value', 0);
                    $('.weekly_report_typ').each(function () {
                        if ($(this).attr('weekly_report_typ') != '1') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '2':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#second_weekly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.weekly_report_typ').each(function () {
                        if ($(this).attr('weekly_report_typ') != '1' && $(this).attr('weekly_report_typ') != '2') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '3':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#third_weekly_report_typ,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.weekly_report_typ').each(function () {
                        if ($(this).attr('weekly_report_typ') != '1' && $(this).attr('weekly_report_typ') != '2' && $(this).attr('weekly_report_typ') != '3') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#weekly_report_typ_1').hasClass('active')) {
                        $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
                    }
                }
                break;
            case '4':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#fourth_weekly_report_typ,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.weekly_report_typ').each(function () {
                        if ($(this).attr('weekly_report_typ') == '5' || $(this).attr('weekly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '5':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#weekly_report_typ_5,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.weekly_report_typ').each(function () {
                        if ($(this).attr('weekly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#weekly_report_typ_3').hasClass('active')) {
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
                break;
            case '6':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    if (!$('#weekly_report_typ_4').hasClass('active')) {
                        $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
                    }
                }
                break;
            default:
                return false;
                break;
        }
        _clearErrors(1);
        getActive();
    });
    $(document).on('click', '.quarterly_report_typ', function () {
        var _this = $(this);
        var target_typ = _this.attr('quarterly_report_typ');
        switch (target_typ) {
            case '1':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#first_quarterly_report_typ').addClass('active');
                    $('#first_quarterly_report_typ').attr('value', 1);
                    $('#second_quarterly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('#first_quarterly_report_typ').attr('value', 0);
                    $('.quarterly_report_typ').each(function () {
                        if ($(this).attr('quarterly_report_typ') != '1') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '2':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#second_quarterly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.quarterly_report_typ').each(function () {
                        if ($(this).attr('quarterly_report_typ') != '1' && $(this).attr('quarterly_report_typ') != '2') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '3':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#third_quarterly_report_typ,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.quarterly_report_typ').each(function () {
                        if ($(this).attr('quarterly_report_typ') != '1' && $(this).attr('quarterly_report_typ') != '2' && $(this).attr('quarterly_report_typ') != '3') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '4':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#fourth_quarterly_report_typ,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.quarterly_report_typ').each(function () {
                        if ($(this).attr('quarterly_report_typ') == '5' || $(this).attr('quarterly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '5':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#quarterly_report_typ_5,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.quarterly_report_typ').each(function () {
                        if ($(this).attr('quarterly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#weekly_report_typ_3').hasClass('active')) {
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
                break;
            case '6':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    if (!$('#weekly_report_typ_4').hasClass('active')) {
                        $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
                    }
                }
                break;
            default:
                return false;
                break;
        }
        _clearErrors(1);
        getActive();
    });
    $(document).on('click', '.monthly_report_typ', function () {
        var _this = $(this);
        var target_typ = _this.attr('monthly_report_typ');
        switch (target_typ) {
            case '1':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#monthly_report_typ').removeClass('disabled');
                    // $('#weekly_report_typ_1').removeClass('disabled');
                    $('#monthly_report_typ').addClass('active');
                    $('#monthly_report_typ').attr('value', 1);
                    $('#first_monthly_report_typ').addClass('active');
                    $('#first_monthly_report_typ').attr('value', 1);
                    $('#second_monthly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('#first_monthly_report_typ').attr('value', 0);
                    $('.monthly_report_typ').each(function () {
                        if ($(this).attr('monthly_report_typ') != '1') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '2':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#second_monthly_report_typ').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.monthly_report_typ').each(function () {
                        if ($(this).attr('monthly_report_typ') != '1' && $(this).attr('monthly_report_typ') != '2') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
                break;
            case '3':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#third_monthly_report_typ,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.monthly_report_typ').each(function () {
                        if ($(this).attr('monthly_report_typ') != '1' && $(this).attr('monthly_report_typ') != '2' && $(this).attr('monthly_report_typ') != '3') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#monthly_report_typ_1').hasClass('active')) {
                        $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
                    }
                }
                break;
            case '4':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#fourth_monthly_report_typ,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.monthly_report_typ').each(function () {
                        if ($(this).attr('monthly_report_typ') == '5' || $(this).attr('monthly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#monthly_report_typ_2').hasClass('active')) {
                        $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
                    }
                }
                break;
            case '5':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#monthly_report_typ_4,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    $('.monthly_report_typ').each(function () {
                        if ($(this).attr('monthly_report_typ') == '6') {
                            $(this).attr('value', 0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if (!$('#monthly_report_typ_3').hasClass('active')) {
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
                break;
            case '6':
                if (!_this.hasClass('active')) {
                    _this.addClass('active');
                    _this.attr('value', 1);
                    $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
                } else {
                    _this.removeClass('active');
                    _this.attr('value', 0);
                    if (!$('#monthly_report_typ_4').hasClass('active')) {
                        $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
                    }
                }
                break;
            default:
                return false;
                break;
        }
        _clearErrors(1);
        getActive();
    });

    $(document).on('click', '#btn-back', function (e) {
        try {
            jMessage(71, function (r) {
                if (r) {
                    if (_validateDomain(window.location)) {
                        window.location.href = '/weeklyreport/rdashboard';
                    } else {
                        jError('エラー', 'このプロトコル又はホストドメインは拒否されました。');
                    }
                }
            });
        } catch (e) {
            alert('#btn-back' + e.message);
        }
    });

    $(document).on('click', '.btn-save', function (e) {
        jMessage(86, function (r) {
            if (r && _validateM0100($('body'))) {
                saveData();
            }
        });
    });
    $(document).on('click', '#close_icon2_1', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_2_div_1").remove();
        if ($('#btn_add_sticky_2').length < 1) {
            $('#row_sticky_2').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky_2').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item2_2', function () {

        $('.dropdown-menu').removeClass('show'); e.preventDefault();
        $($(this)).closest(".sticky_2_div_2").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_2').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon2_2', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_2_div_2").remove();
        if ($('#btn_add_sticky_2').length < 1) {
            $('#row_sticky_2').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        }
        else {
            $('#btn_add_sticky_2').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_3', function () {

        $('.dropdown-menu').removeClass('show'); e.preventDefault();
        $($(this)).closest(".sticky_2_div_3").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_3').attr('value', $(this).attr("value"))
    });
    $(document).on('click', '#close_icon2_3', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_2_div_3").remove();
        if ($('#btn_add_sticky_2').length < 1) {
            $('#row_sticky_2').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        }
        else {
            $('#btn_add_sticky_2').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_4', function () {
        e.preventDefault();
        $($(this)).closest(".sticky_2_div_4").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_4').attr('value', $(this).attr("value"))

        $('.dropdown-menu').removeClass('show');
    });
    $(document).on('click', '#close_icon2_4', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_2_div_4").remove();
        if ($('#btn_add_sticky_2').length < 1) {
            $('#row_sticky_2').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky_2').attr('number', number)
        }
    });
    $(document).on('click', '.dropdown-item_5', function () {
        e.preventDefault();
        $($(this)).closest(".sticky_2_div_5").css("background-color", $(this).attr("value"));
        $($(this)).parent(".dropdown-menu").find(".note_color").attr("value",$(this).attr("value_color"));
        $('#color_selected_5').attr('value', $(this).attr("value"))

        $('.dropdown-menu').removeClass('show');
    });
    $(document).on('click', '#close_icon2_5', function () {
        var number = $(this).attr('number');
        $($(this)).closest(".sticky_2_div_5").remove();
        if ($('#btn_add_sticky_2').length < 1) {
            $('#row_sticky_2').append('<button number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        } else {
            $('#btn_add_sticky_2').attr('number', number)
        }
    });
    $(document).on('click', '.sticky_2_div_1', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_2_div_text_1').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_1"  cols="30" style="border:none" rows="10" value="' + $("#label_text2_1").text() + '">')
            $('#label_text2_1').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon2_1").css("display", '');
            $("#option_icon2_1").css("display", '');
        }
    });

    $(document).on('click', '.sticky_2_div_2', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_2_div_text_2').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_2"  cols="30" style="border:none" rows="10"value="' + $("#label_text2_2").text() + '">')
            $('#label_text2_2').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon2_2").css("display", '');
            $("#option_icon2_2").css("display", '');
        }
    });
    $(document).on('click', '.sticky_2_div_3', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_2_div_text_3').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_3"  cols="30" style="border:none" rows="10"value="' + $("#label_text2_3").text() + '">')
            $('#label_text2_3').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon2_3").css("display", '');
            $("#option_icon2_3").css("display", '');
        }
    });
    $(document).on('click', '.sticky_2_div_4', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_2_div_text_4').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_4"  cols="30" style="border:none" rows="10"value="' + $("#label_text2_4").text() + '">')
            $('#label_text2_4').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon2_4").css("display", '');
            $("#option_icon2_4").css("display", '');
        }
    });
    $(document).on('click', '.sticky_2_div_5', function (e) {
        e.stopPropagation();
        if ($(this).hasClass("unactive")) {
            $('#sticky_2_div_text_5').html('<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_5"  cols="30" style="border:none" rows="10"value="' + $("#label_text2_5").text() + '">')
            $('#label_text2_5').remove()
            $(this).addClass('active');
            $(this).removeClass('unactive');
            $("#close_icon2_5").css("display", '');
            $("#option_icon2_5").css("display", '');
        }
    });
    $(document).on('click', function (e) {
        if ((e.target.id != 'btn_add_sticky_2' && !e.target.classList.contains('fa-plus')) && (e.target.id != 'btn_add_sticky' && !e.target.classList.contains('fa-plus'))) {
            if ($('.sticky_2_div_1').hasClass("active")) {
                $('#sticky_2_div_text_1').append('<p style="color:black" id="label_text2_1">' + $("#sticky_2_text_1").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_1").val()  + '">')
                $('.sticky_2_div_1').addClass('unactive');
                $('#sticky_2_div_text_1').addClass('label_stick')
                $('.sticky_2_div_1').removeClass('active');
                $("#sticky_2_text_1").remove();
                $("#close_icon2_1").css("display", 'none');
                $("#option_icon2_1").css("display", 'none');
            }
            if ($('.sticky_2_div_2').hasClass("active")) {
                $('#sticky_2_div_text_2').append('<p style="color:black" id="label_text2_2">' + $("#sticky_2_text_2").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_2").val()  + '">')
                $('.sticky_2_div_2').addClass('unactive');
                $('#sticky_2_div_text_2').addClass('label_stick')
                $('.sticky_2_div_2').removeClass('active');
                $("#sticky_2_text_2").remove();
                $("#close_icon2_2").css("display", 'none');
                $("#option_icon2_2").css("display", 'none');
            }
            if ($('.sticky_2_div_3').hasClass("active")) {
                $('#sticky_2_div_text_3').append('<p style="color:black" id="label_text2_3">' + $("#sticky_2_text_3").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_3").val()  + '">')
                $('.sticky_2_div_3').addClass('unactive');
                $('#sticky_2_div_text_3').addClass('label_stick')
                $('.sticky_2_div_3').removeClass('active');
                $("#sticky_2_text_3").remove();
                $("#close_icon2_3").css("display", 'none');
                $("#option_icon2_3").css("display", 'none');
            }
            if ($('.sticky_2_div_4').hasClass("active")) {
                $('#sticky_2_div_text_4').append('<p style="color:black" id="label_text2_4">' + $("#sticky_2_text_4").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_4").val()  + '">')
                $('.sticky_2_div_4').addClass('unactive');
                $('#sticky_2_div_text_4').addClass('label_stick')
                $('.sticky_2_div_4').removeClass('active');
                $("#sticky_2_text_4").remove();
                $("#close_icon2_4").css("display", 'none');
                $("#option_icon2_4").css("display", 'none');
            }
            if ($('.sticky_2_div_5').hasClass("active")) {
                $('#sticky_2_div_text_5').append('<p style="color:black" id="label_text2_5">' + $("#sticky_2_text_5").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_5").val()  + '">')
                $('.sticky_2_div_5').addClass('unactive');
                $('#sticky_2_div_text_5').addClass('label_stick')
                $('.sticky_2_div_5').removeClass('active');
                $("#sticky_2_text_5").remove();
                $("#close_icon2_5").css("display", 'none');
                $("#option_icon2_5").css("display", 'none');
            }
            if ($('.sticky_div_1').hasClass("active")) {
                $('#sticky_div_text_1').append('<p style="color:black" id="label_text_1">' + $("#sticky_text_1").val() + '</p><input class="note_name" hidden value="' + $("#sticky_text_1").val() + '">')
                $('.sticky_div_1').addClass('unactive');
                $('#sticky_div_text_1').addClass('label_stick')
                $('.sticky_div_1').removeClass('active');
                $("#sticky_text_1").remove();
                $("#close_icon_1").css("display", 'none');
                $("#option_icon_1").css("display", 'none');
            }

            if ($('.sticky_div_2').hasClass("active")) {
                $('#sticky_div_text_2').append('<p style="color:black" id="label_text_2">' + $("#sticky_text_2").val() + '</p><input class="note_name" hidden value="' + $("#sticky_text_2").val() + '">')
                $('.sticky_div_2').addClass('unactive');
                $('#sticky_div_text_2').addClass('label_stick')
                $('.sticky_div_2').removeClass('active');
                $("#sticky_text_2").remove();
                $("#close_icon_2").css("display", 'none');
                $("#option_icon_2").css("display", 'none');
            }

            if ($('.sticky_div_3').hasClass("active")) {
                $('#sticky_div_text_3').append('<p style="color:black" id="label_text_3">' + $("#sticky_text_3").val() + '</p><input class="note_name" hidden value="' + $("#sticky_text_3").val() + '">')
                $('.sticky_div_3').addClass('unactive');
                $('#sticky_div_text_3').addClass('label_stick')
                $('.sticky_div_3').removeClass('active');
                $("#sticky_text_3").remove();
                $("#close_icon_3").css("display", 'none');
                $("#option_icon_3").css("display", 'none');
            }

            if ($('.sticky_div_4').hasClass("active")) {
                $('#sticky_div_text_4').append('<p style="color:black" id="label_text_4">' + $("#sticky_text_4").val() + '</p><input class="note_name" hidden value="' + $("#sticky_text_4").val() + '">')
                $('.sticky_div_4').addClass('unactive');
                $('#sticky_div_text_4').addClass('label_stick')
                $('.sticky_div_4').removeClass('active');
                $("#sticky_text_4").remove();
                $("#close_icon_4").css("display", 'none');
                $("#option_icon_4").css("display", 'none');
            }

            if ($('.sticky_div_5').hasClass("active")) {
                $('#sticky_div_text_5').append('<p style="color:black" id="label_text_5">' + $("#sticky_text_5").val() + '</p><input class="note_name" hidden value="' + $("#sticky_text_5").val() + '">')
                $('.sticky_div_5').addClass('unactive');
                $('#sticky_div_text_5').addClass('label_stick')
                $('.sticky_div_5').removeClass('active');
                $("#sticky_text_5").remove();
                $("#close_icon_5").css("display", 'none');
                $("#option_icon_5").css("display", 'none');
            }
        }
    });

    $(document).on("keydown", '.sticky_2_div_1', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_2_div_text_1').append('<p style="color:black" id="label_text2_1">' + $("#sticky_2_text_1").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_1").val() + '">')
                $(this).addClass('unactive');
                $('#sticky_2_div_text_1').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_2_text_1").remove();
                $("#close_icon2_1").css("display", 'none');
                $("#option_icon2_1").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_2_div_2', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_2_div_text_2').append('<p style="color:black" id="label_text2_2">' + $("#sticky_2_text_2").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_2").val() + '">')
                $(this).addClass('unactive');
                $('#sticky_2_div_text_2').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_2_text_2").remove();
                $("#close_icon2_2").css("display", 'none');
                $("#option_icon2_2").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_2_div_3', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_2_div_text_3').append('<p style="color:black" id="label_text2_3">' + $("#sticky_2_text_3").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_3").val() + '">')
                $(this).addClass('unactive');
                $('#sticky_2_div_text_3').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_2_text_3").remove();
                $("#close_icon2_3").css("display", 'none');
                $("#option_icon2_3").css("display", 'none');
            }
        }
    });
    $(document).on("keydown", '.sticky_2_div_4', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_2_div_text_4').append('<p style="color:black" id="label_text2_4">' + $("#sticky_2_text_4").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_4").val() + '">')
                $(this).addClass('unactive');
                $('#sticky_2_div_text_4').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_2_text_4").remove();
                $("#close_icon2_4").css("display", 'none');
                $("#option_icon2_4").css("display", 'none');
            }
        }
    });
    $(document).on("click", '#comment_option_use_typ', function (e) {
        var selectedValue = $("#comment_option_use_typ").val();

        if (selectedValue == 1) {
            $('#approver').attr('disabled', false)
            $('#viewer').attr('disabled',false)
            $('.label_ckb').removeClass('label_disabled')
            $('#approver_span').attr('tabindex',3)
            $('#viewer_span').attr('tabindex',3)
            
        } else {
            if ($('#approver').val() == 1) {
                $('#approver').trigger('click')
            }
            if ($('#viewer').val() == 1) {
                $('#viewer').trigger('click')
            }
            $('#approver').attr('checked',false)
            $('#viewer').attr('checked',false)
            $('#approver_span').attr('tabindex',-1)
            $('#viewer_span').attr('tabindex',-1)
            $('#approver').attr('disabled', true)
            $('#viewer').attr('disabled', true)

            $('.label_ckb').addClass('label_disabled')
   
           
        }
    });
    $(document).on("keydown", '.sticky_2_div_5', function (e) {
        if (e.which == 13) {
            if ($(this).hasClass("active")) {
                $('#sticky_2_div_text_5').append('<p style="color:black" id="label_text2_5">' + $("#sticky_2_text_5").val() + '</p><input class="note_name" hidden value="' + $("#sticky_2_text_5").val() + '">')
                $(this).addClass('unactive');
                $('#sticky_2_div_text_5').addClass('label_stick')
                $(this).removeClass('active');
                $("#sticky_2_text_5").remove();
                $("#close_icon2_5").css("display", 'none');
                $("#option_icon2_5").css("display", 'none');
            }
        }
    });
    $(document).on('click', '#btn_add_sticky_2', function (e) {
        var number = 1;
        if (!$(".sticky_2_div_1")[0]) {
            number = 1
        } else if (!$(".sticky_2_div_2")[0]) {
            number = 2
        } else if (!$(".sticky_2_div_3")[0]) {
            number = 3
        }
        else if (!$(".sticky_2_div_4")[0]) {
            number = 4
        }
        else {
            number = 5
        }
        $('#btn_add_sticky_2').remove();
        $('#row_sticky_2').append('<div class="col-lg-2 mr-2 col-md-2 col-sm-6 col-12 sticky_2 sticky_2_div_' + number + ' col-md-auto active  btn-outline-brand-xl" style="display:flex;min-height: 52px;padding:7px; background:'+$('#color_value_1').attr('value')+'"' + 'note_color="1">' +
            '<div class="dropdown"  style="padding-top: 6px;"><i class="fa fa-ellipsis-h mt-2 mr-2"  id="option_icon2_' + number + '" style="font-size:16px; color:gray" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"></i' + '>' +
            '<input class="detail_no" value="" type="hidden" hidden />' +
            '<div class="dropdown-menu" id="color_' + number + '" aria-labelledby="dropdownMenuButton"' + '>' +
            '<a value_color="1" class="dropdown-item dropdown-item2_' + number + '" style="height: 32px;background: '+$('#color_value_1').attr('value')+';" value="'+$('#color_value_1').attr('value')+'" ></a' + '>' +
            '<a value_color="2" class="dropdown-item dropdown-item2_' + number + '" value="'+$('#color_value_2').attr('value')+'" style="height: 32px;background: '+$('#color_value_2').attr('value')+';" ></a' + '>' +
            '<a value_color="3" class="dropdown-item dropdown-item2_' + number + '" value="'+$('#color_value_3').attr('value')+'" style="height: 32px;background: '+$('#color_value_3').attr('value')+';" ></a' + '>' +
            '<a value_color="4" class="dropdown-item dropdown-item2_' + number + '" value="'+$('#color_value_4').attr('value')+'" style="height: 32px;background: '+$('#color_value_4').attr('value')+';" ></a' + '>' +
            '<a value_color="5" class="dropdown-item dropdown-item2_' + number + '" value="'+$('#color_value_5').attr('value')+'" style="height: 32px;background: '+$('#color_value_5').attr('value')+';" ></a' + '>' +
            '<input class="note_color" value="1" type="hidden" hidden />' +
            '</div></div' + '>' +
            '<div cols="30"  id="sticky_2_div_text_' + number + '"' + '>' +
            '<input type="text" maxlength="10" class="form-control" name="" id="sticky_2_text_' + number + '" cols="30" style="border:none" rows="10"></input></div><div class="dropdown ml-2"' + '>' +
            '<input id="color_selected_' + number + '" value="'+$('#color_value_1').attr('value')+'" type="hidden"/' + '>' +
            '</div><i class="fa fa-close"  number=' + number + ' id="close_icon2_' + number + '" aria-hidden="true"></i></div>')
        if ($('.sticky_2').length < 5) {
            $('#row_sticky_2').append('<button  number=' + number + ' class=" btn btn-rm blue btn-lg col-md-auto border border-primary" id="btn_add_sticky_2"' + '>' +
                '<i class="fa fa-plus"></i></button>')
        }
        $('.sticky_2_div_' + number + '').click();
        $('#sticky_2_text_' + ($('.sticky_2').length) + '').focus();
    });
    $(document).on('click', function (e) {
        console.log(!e.target.classList.contains('sticky_2'))
    })
    $(document).on('click','#viewable_deadline_kbn',function () {
        try {
            if($(this).is(":checked")){
                $(this).val(1);
            }else{
                $(this).val(0);
            }
        }catch(e){
            alert('change check_account' + e.message);
        }
    })
    $(document).on('click','#approver',function () {
        try {
            if($(this).is(":checked")){
                $(this).val(1);
            }else{
                $(this).val(0);
            }
        }catch(e){
            alert('change check_account' + e.message);
        }
    })
    $(document).on('click','#viewer',function () {
        try {
            if($(this).is(":checked")){
                $(this).val(1);
            }else{
                $(this).val(0);
            }
        }catch(e){
            alert('change check_account' + e.message);
        }
    })
    $(document).on('click','#viewer_sharing',function () {
        try {
            if($(this).is(":checked")){
                $(this).val(1);
            }else{
                $(this).val(0);
            }
        }catch(e){
            alert('change check_account' + e.message);
        }
    })
    $(document).on('click','#share_notify_reporter',function () {
        try {
            if($(this).is(":checked")){
                $(this).val(1);
            }else{
                $(this).val(0);
            }
        }catch(e){
            alert('change check_account' + e.message);
        }
    })
}
/**
 * Common item validation process. Call when click save button.
 *
 * @author : viettd - 2015/10/02 - create
 * @author :
 * @param :
 *            element
 * @return : true/false
 * @access : public
 * @see :
 */
function _validateM0100(element) {
    if (!element) {
        element = $('body');
    }
    var error = 0;
    try {
        _clearErrors(1);
        // validate required
        element.find('.required:enabled').each(function () {
            //biennv 2016/01/14 fix required in tab
            if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
                if ($(this).is(".mmdd") && $.trim($(this).val()) == '') {
                    $(this).errorStyle(_text[15].message, 1);
                    error++;
                }
                if (($(this).is(".adjustpoint_from") || $(this).is(".adjustpoint_to")) && $.trim($(this).val()) == '') {
                    $(this).errorStyle(_text[8].message, 1);
                    error++;
                }
                if (($(this).is(".adjustpoint_from")) && $.trim($(this).val()) != '' && $(this).closest('tr').find('.adjustpoint_to').val() != '') {
                    var tr = $(this).closest('tr');
                    var adjustpoint_from = tr.find('.adjustpoint_from');
                    var adjustpoint_to = tr.find('.adjustpoint_to');
                    if (adjustpoint_from.val() * 1 >= adjustpoint_to.val() * 1) {
                        adjustpoint_from.errorStyle(_text[9].message, 1);
                        adjustpoint_to.errorStyle(_text[9].message, 1);
                        error++;
                    }
                }
            }
        });

        if (error > 0) {
            _focusErrorItem();
            return false;
        } else {
            return true;
        }
    } catch (e) {
        alert('_validate: ' + e.toString());
    }
}
/**
 * getActive
 *
 * @author      :   longvv - 2018/08/31 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getActive() {
    try {
        if ($('#target_evaluation_typ_1').hasClass('active') || $('#evaluation_typ_1').hasClass('active')) {
            $('#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
            // $('#adjustpoint_from_1,#adjustpoint_to_1').removeAttr('readonly');
            // $('#adjustpoint_from_1,#adjustpoint_to_1').addClass('required');
        } else {
            $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
            $('#rank_change_1,#adjustpoint_input_1').removeClass('active');
            $('#rank_change_1,#adjustpoint_input_1').attr('value', 0);
            $('#adjustpoint_from_1,#adjustpoint_to_1').attr('readonly', true);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('required');
            $('#adjustpoint_from_1,#adjustpoint_to_1').val('');
        }
        if ($('#target_evaluation_typ_2').hasClass('active') || $('#evaluation_typ_2').hasClass('active')) {
            $('#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
            // $('#adjustpoint_from_2,#adjustpoint_to_2').removeAttr('readonly');
            // $('#adjustpoint_from_2,#adjustpoint_to_2').addClass('required');
        } else {
            $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
            $('#rank_change_2,#adjustpoint_input_2').removeClass('active');
            $('#rank_change_2,#adjustpoint_input_2').attr('value', 0);
            $('#adjustpoint_from_2,#adjustpoint_to_2').attr('readonly', true);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('required');
            $('#adjustpoint_from_2,#adjustpoint_to_2').val('');
        }
        if ($('#target_evaluation_typ_3').hasClass('active') || $('#evaluation_typ_3').hasClass('active')) {
            $('#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
            // $('#adjustpoint_from_3,#adjustpoint_to_3').removeAttr('readonly');
            // $('#adjustpoint_from_3,#adjustpoint_to_3').addClass('required');
        } else {
            $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
            $('#rank_change_3,#adjustpoint_input_3').removeClass('active');
            $('#rank_change_3,#adjustpoint_input_3').attr('value', 0);
            $('#adjustpoint_from_3,#adjustpoint_to_3').attr('readonly', true);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('required');
            $('#adjustpoint_from_3,#adjustpoint_to_3').val('');
        }
        if ($('#target_evaluation_typ_4').hasClass('active') || $('#evaluation_typ_4').hasClass('active')) {
            $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
            // $('#adjustpoint_from_4,#adjustpoint_to_4').removeAttr('readonly');
            // $('#adjustpoint_from_4,#adjustpoint_to_4').addClass('required');
        } else {
            $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
            $('#rank_change_4,#adjustpoint_input_4').removeClass('active');
            $('#rank_change_4,#adjustpoint_input_4').attr('value', 0);
            $('#adjustpoint_from_4,#adjustpoint_to_4').attr('readonly', true);
            $('#adjustpoint_from_4,#adjustpoint_to_4').removeClass('required');
            $('#adjustpoint_from_4,#adjustpoint_to_4').val('');
        }
    } catch (e) {
        alert('getActive' + e.message);
    }
}
/**
 * save
 *
 * @author      :   longvv - 2018/08/31 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);
        console.log(data);
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rm0010/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        //
                        jMessage(2, function (r) {
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
        alert('save' + e.message);
    }
}
