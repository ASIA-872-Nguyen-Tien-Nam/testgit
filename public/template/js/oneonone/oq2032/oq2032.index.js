/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 2020/10/07
 * 作成者    : namnb - namnb@ans-asia.com
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
var _obj = {
    'fiscal_year': { 'type': 'select', 'attr': 'id' }
    , 'position_cd': { 'type': 'select', 'attr': 'id' }
    , 'job_cd': { 'type': 'select', 'attr': 'id' }
    , 'coach_nm': { 'type': 'text', 'attr': 'id' }
};
//
$(document).ready(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
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
    try {
        $(".multiselect").multiselect({
            onChange: function () {
                $.uniform.update();
            },
        });
    } catch (e) {
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
    try {
        //change fiscal_year
        $(document).on('change', '#fiscal_year', function (e) {
            try {
                var fiscal_year = $(this).val();
                $('.employee_nm_1on1').attr("fiscal_year_1on1", fiscal_year);
            } catch (e) {
                alert('fiscal_year: ' + e.message);
            }
        });
        //
        $(document).on("click", "#btn-search", function (e) {
            e.preventDefault();
            if (_validate($("body"))) {
                search();
            }
        });
        // 
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        //
        $(document).on("click", "#btn-excel", function (e) {
            e.preventDefault();
            if (_validate($("body"))) {
                var data = getData(_obj);
                // 
                list = [];
                var div2 = $('#group_cd_1on1').closest('.multi-select-full');
                div2.find('input[type=checkbox]').each(function () {
                    if ($(this).prop('checked')) {
                        list.push({
                            'group_cd_1on1': $(this).val()
                        });
                    }
                });
                data.data_sql.list_group_1on1 = list;
                //
                list = [];
                var div2 = $('#grade').closest('.multi-select-full');
                div2.find('input[type=checkbox]').each(function () {
                    if ($(this).prop('checked')) {
                        list.push({
                            'grade': $(this).val()
                        });
                    }
                });
                data.data_sql.list_grade = list;
                //
                var submit = 0;
                $('.submit').each(function () {
                    if ($(this).is(":checked")) {
                        submit = $(this).val()
                    }
                });
                data.data_sql.submit = submit;
                //
                var target = 0;
                $('.target').each(function () {
                    if ($(this).is(":checked")) {
                        target = $(this).val()
                    }
                });
                data.data_sql.target = target;
                //
                var view_unit = 0;
                $('.view_unit').each(function () {
                    if ($(this).is(":checked")) {
                        view_unit = $(this).val()
                    }
                });
                data.data_sql.view_unit = view_unit;
                $.downloadFileAjax('/oneonone/oq2032/export-excel', JSON.stringify(data));
            }
        });
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}

/**
 * SEARCH
 *
 * @author      :   DUONGNTT - 2020/12/15 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function search() {
    try {
        var data = getData(_obj);
        //
        list = [];
        var div2 = $('#group_cd_1on1').closest('.multi-select-full');
        div2.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({
                    'group_cd_1on1': $(this).val()
                });
            }
        });
        data.data_sql.list_group_1on1 = list;
        list = [];
        var div2 = $('#grade').closest('.multi-select-full');
        div2.find('input[type=checkbox]').each(function () {
            if ($(this).prop('checked')) {
                list.push({
                    'grade': $(this).val()
                });
            }
        });
        data.data_sql.list_grade = list;
        //
        var submit = 0;
        $('.submit').each(function () {
            if ($(this).is(":checked")) {
                submit = $(this).val()
            }
        });
        data.data_sql.submit = submit;
        //
        var target = 0;
        $('.target').each(function () {
            if ($(this).is(":checked")) {
                target = $(this).val()
            }
        });
        data.data_sql.target = target;
        //
        var view_unit = 0;
        $('.view_unit').each(function () {
            if ($(this).is(":checked")) {
                view_unit = $(this).val()
            }
        });
        data.data_sql.view_unit = view_unit;
        // send data to post
        $.ajax({
            type: "POST",
            url: "/oneonone/oq2032/search",
            dataType: "html",
            data: JSON.stringify(data),
            loading: true,
            success: function (res) {
                $("#result").empty();
                $("#result").append(res);
                $('.view_unit').each(function () {
                    if ($(this).is(":checked")) {
                        view_unit = $(this).parents('.md-radio-v2').find('label').text();
                        $('.th_view_unit').text(view_unit);
                    }
                });
                jQuery.formatInput();
                tableContent();
                app.jTableFixedHeader();
                app.jSticky();
                // $(".button-card").trigger("click");
            },
        });
    } catch (e) {
        alert("save" + e.message);
    }
}

/*
 * tableContent
 * @author    : phuhv – phuhv@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function tableContent() {
    //$('.fixed-header').tableHeadFixer();\
    $(".wmd-view-topscroll").scroll(function () {
        $(".wmd-view").scrollLeft($(".wmd-view-topscroll").scrollLeft());
    });

    $(".wmd-view").scroll(function () {
        $(".wmd-view-topscroll").scrollLeft($(".wmd-view").scrollLeft());
    });

    fixWidth();

    $(window).resize(function () {
        fixWidth();
    });
    function fixWidth() {
        var w = $('.wmd-view .table').outerWidth();
        $(".wmd-view-topscroll .scroll-div1").width(w);
    }
}
