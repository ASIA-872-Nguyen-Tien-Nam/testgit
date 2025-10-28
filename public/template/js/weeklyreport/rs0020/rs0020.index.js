/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日            :    2020/10/07
 * 作成者            :    nghianm – nghianm@ans-asia.com
 *
 * @package        :    MODULE MASTER
 * @copyright        :    Copyright (c) ANS-ASIA
 * @version        :    1.0.0
 * ****************************************************************************
 */
var _obj = {
    'authority_cd': {'type': 'text', 'attr': 'id'},
    'authority_nm': {'type': 'text', 'attr': 'id'},
    'use_typ': {'type': 'checkbox', 'attr': 'id'},
    'organization_belong_person_typ': {'type': 'checkbox', 'attr': 'id'},
    'list_function': {
        'attr': 'list', 'item': {
            'function_id': {'type': 'text', 'attr': 'class'},
            'function_nm': {'type': 'text', 'attr': 'class'},
            'authority': {'type': 'text', 'attr': 'class'}
        }
    },
    'arrange_order': {'type': 'text', 'attr': 'id'},
    'list_organization': {
        'attr': 'list', 'item': {
            'authority': {'type': 'checkbox', 'attr': 'class'},
            'organization_cd_1': {'type': 'text', 'attr': 'class'},
            'organization_cd_2': {'type': 'text', 'attr': 'class'},
            'organization_cd_3': {'type': 'text', 'attr': 'class'},
            'organization_cd_4': {'type': 'text', 'attr': 'class'},
            'organization_cd_5': {'type': 'text', 'attr': 'class'},
        }
    }
};
var _flgLeft = 0;
$(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
});
/**
 * initialize
 *
 * @author    : nghianm - 2020/10/07 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function initialize() {
    try {
        $('#authority_nm').focus();
        //
        _formatTooltip();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author    : nghianm - 2020/10/07 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
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
        /* end paging */

        $(document).on('mouseover', '.lbl-text', function () {
            try {
                $(this).addClass('no');
            } catch (e) {
                alert('.lbl-text : ' + e.message);
            }
        });

        //
        $(document).on('focus', '.lbl-text', function () {
            try {
                $(this).removeClass('no');
            } catch (e) {
                alert('.lbl-text : ' + e.message);
            }
        });

        //
        $(document).on('change', '.check-all', function () {
            try {
                var checked = $(this).is(':checked');
                var parent = $(this).closest('table');
                if (checked) {
                    parent.find('.chk-item:enabled').val('1');
                    $(this).val('1');
                }
                else {
                    $(this).val('0');
                }
            } catch (e) {
                alert('.ck-all : ' + e.message);
            }
        });

        // check item
        $(document).on('change', '.chk-item', function () {
            try {
                var parent = $(this).closest('table');
                var check_item = $(this).val();
                var check_all = parent.find('.check-all').val();

                if(check_item == 1 && check_all == 0){
                    parent.find('.check-all').prop('checked', false);
                    parent.find('.check-all').val('0');
                }else{
                    parent.find('.check-all').prop('checked', true);
                    parent.find('.check-all').val('1');
                }
                //
                if($(this).prop("checked")){
                    $(this).val('1')
                }else{
                    $(this).val('0')
                }
            } catch (e) {
                alert('.ck-item : ' + e.message);
            }
        });

        /* left content click item */
        $(document).on('click', '.list-search-child', function (e) {
            $('.list-search-child').removeClass('active');
            $(this).addClass('active');
            var authority_cd = $(this).attr('id');
            getRightContent(authority_cd);
        });
        /* end click item */

        //use_typ
        $(document).on('change', '#use_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                } else {
                    $(this).val(0);
                }
            } catch (e) {
                alert('#use_typ : ' + e.message);
            }
        });
        //organization_belong_person_typ
        $(document).on('change', '#organization_belong_person_typ', function () {
            try {
                if ($(this).is(":checked")) {
                    $(this).val(1);
                    //set disabel checkbox
                    $('#table-organization').find('input[type=checkbox]').prop('checked', false);
                    $('#table-organization').find('input[type="checkbox"]').attr('disabled',true);
                    $('#table-organization').find('.checkmark').css('background','#c7cdd4');
                } else {
                    $(this).val(0);
                    $('#table-organization').find('.checkmark').css('background','white');
                    $('#table-organization').find('input[type="checkbox"]').removeAttr('disabled');
                }
            } catch (e) {
                alert('#organization_belong_person_typ : ' + e.message);
            }
        });

        //btn-new-signup
        $(document).on('click', '#btn-new-signup', function (e) {
            try {
                jMessage(5, function (r) {
                    if (r) {
                        $('#authority_cd, #authority_nm, #arrange_order').val('');
                        $('select').val('0');
                        $('input[type=checkbox]').prop('checked', false);
                        $('#table-organization').find('input[type="checkbox"]').removeAttr('disabled');
                        $('#authority_nm').focus();
                        $('.list-search-child').removeClass('active');
                        $('#table-organization').find('.checkmark').css('background','white');
                    }
                });
            } catch (e) {
                alert('#btn-new-signup: ' + e.message);
            }
        });

        // btn-save
        $(document).on('click', '.btn-save', function (e) {
            try {
                jMessage(1, function (r) {
                    _flgLeft = 1;
                    if (r && _validate($('body'))) {
                        saveData();
                    }
                });
            } catch (e) {
                alert('.btn-save :' + e.message);
            }
        });

        //btn-delete
        $(document).on('click', '#btn-delete', function (e) {
            try{
                jMessage(3, function (r) {
                    _flgLeft = 1;
                    if (r) {
                        deleteData();
                    }
                })
            }catch(e){
                alert('#btn-delete :' + e.message);
            }
        });

        //btn-reflect
        $(document).on('click', '#btn-reflect', function (e) {
            try{
                var reflect = $('#reflect').val();
                $('select').val(reflect);
            }catch(e){
                alert('#btn-reflect :' + e.message);
            }
        });

        //btn-back
        $(document).on('click', '#btn-back', function (e) {
            // window.location.href = '/dashboard'
            if(_validateDomain(window.location)){
                window.location.href = 'rdashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        });

        // check button
        $(document).on('click', '.check-level-1', function (e) {
            //
            if (!$(this).is(':checked')) {
                $(this).closest('li').find('ul').find('input[type="checkbox"]').prop('checked', false);
            }
        });
        $(document).on('click', '.check-level-2', function (e) {
            if ($(this).is(':checked')) {
                var parent = genClassParent(this, 2);
                $(parent).prop('checked', true);
            }
            else {
                $(this).closest('li').find('ul').find('input[type="checkbox"]').prop('checked', false);
            }

        });
        $(document).on('click', '.check-level-3', function (e) {
            if ($(this).is(':checked')) {
                var parent = genClassParent(this, 2);
                $(parent).prop('checked', true);
                var parent1 = genClassParent(this, 3);
                $(parent1).prop('checked', true);
            }
            else {
                $(this).closest('li').find('ul').find('input[type="checkbox"]').prop('checked', false);
            }
        });
        $(document).on('click', '.check-level-4', function (e) {
            if ($(this).is(':checked')) {
                var parent = genClassParent(this, 2);
                $(parent).prop('checked', true);
                var parent1 = genClassParent(this, 3);
                $(parent1).prop('checked', true);
                var parent2 = genClassParent(this, 4);
                $(parent2).prop('checked', true);
            }
            else {
                $(this).closest('li').find('ul').find('input[type="checkbox"]').prop('checked', false);
            }
        });
        $(document).on('click', '.check-level-5', function (e) {
            if ($(this).is(':checked')) {
                var parent = genClassParent(this, 2);
                $(parent).prop('checked', true);
                var parent1 = genClassParent(this, 3);
                $(parent1).prop('checked', true);
                var parent2 = genClassParent(this, 4);
                $(parent2).prop('checked', true);
                var parent3 = genClassParent(this, 5);
                $(parent3).prop('checked', true);
            }
        });

    } catch (e) {
        alert('initEvents' + e.message);
    }
}

/**
 * [genClassParent description]
 * @param  {object} this [description]
 * @param  {integer} type [description]
 * @return {string}      [description]
 */
function genClassParent(that, type) {
    var cd1 = $(that).siblings('.organization_cd_1').val();
    var cd2 = $(that).siblings('.organization_cd_2').val();
    var cd3 = $(that).siblings('.organization_cd_3').val();
    var cd4 = $(that).siblings('.organization_cd_4').val();
    var cd5 = $(that).siblings('.organization_cd_5').val();
    var cd = [];
    switch (type) {
        case 1:
            break;
        case 2:
            cd2 = '';
            cd3 = '';
            cd4 = '';
            cd5 = '';
            break;
        case 3:
            cd3 = '';
            cd4 = '';
            cd5 = '';
            break;
        case 4:
            cd4 = '';
            cd5 = '';
            break;
        case 5:
            cd5 = '';
            break;
    }
    cd.push(cd1);
    cd.push(cd2);
    cd.push(cd3);
    cd.push(cd4);
    cd.push(cd5);
    return '.' + cd.join('-');
}

/**
 * getLeftContent
 *
 * @author      :   nghianm - 2020/10/07 - create
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
            url: '/weeklyreport/rs0020/leftcontent',
            dataType: 'html',
            loading: true,
            data: {current_page: page, search_key: search},
            success: function (res) {
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    var authority_cd = $('#authority_cd').val();
                    $('.list-search-content div[id="' + authority_cd + '"]').addClass('active');
                    if (_flgLeft != 1) {
                        $('#search_key').focus();
                    } else {
                        _flgLeft = 0;
                    }
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                    $('#table-organization').find('.checkmark').css('background','white');

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
 * make unique id
 * @return {String}
 */
function generateGuid() {
    var result, i, j;
    result = '';
    for(j=0; j<32; j++) {
    if( j == 8 || j == 12 || j == 16 || j == 20) 
    {
        result = result + '-';
    }
    i = Math.floor(Math.random()*16).toString(16).toUpperCase();
    result = result + i;
    }
    return result;
}

/**
 * [makeLi description]
 * @param  {[type]} item  [description]
 * @param  {[type]} index [description]
 * @param  {[type]} level [description]
 * @return {[type]}       [description]
 */
function makeLi(item, index, level, time) {
    var li = $('<li>', {class: "parent-"+item.id, 'data-id': item.id});
    var parent = '';
    var i='',j='',k='',l='',m='';
    i = item.organization_cd_1;
    j = item.organization_cd_2;
    k = item.organization_cd_3;
    l = item.organization_cd_4;
    m = item.organization_cd_5;
    var a_props = {
        "class":"lv"+level,
        "data-toggle":"collapse",
        "href":"#" + generateGuid(),
        "typ":"",
        "cd":"",
        "aria-expanded":"true"
    };
    var div_props = {
        "class":"text-overfollow",
        "data-container":"body",
        "data-toggle":"tooltip",
        "data-original-title":item.organization_nm
    };
    var table = $('<table>', {class: 'ck-inline'}).empty().append('<tr><td></td><td></td></tr>');
    table.find('td:first-child').append('<div class="md-checkbox-v2"></div>');
    table.find('td:first-child > div')
        .append('<input name="XXX1" id="XXX1" value="0" type="checkbox" tabindex="2">')
        .append('<label for="use_typ" class="lbl-text no"></label>');
    table.find('td:last-child').html(item.organization_nm);
    
    var a = $('<a>', a_props);
    li.append(a.append(table));
    return li;
}


/**
 * save
 *
 * @author      :   nghianm - 2020/10/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data = getData(_obj);

        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rs0020/save',
            dataType: 'json',
            loading: true,
            data: JSON.stringify(data),
            success: function (res) {
                switch (res['status']) {
                    // success
                    case OK:
                        jMessage(2, function () {
                            //
                            clearData(_obj);
                            $('select').val('0');
                            $('input[type=checkbox]').prop('checked', false);
                            $('#table-organization').find('input[type="checkbox"]').removeAttr('disabled');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#authority_nm').focus();
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
 * delete
 *
 * @author      :   nghianm - 2020/10/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data.authority_cd = $('#authority_cd').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rs0020/delete',
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
                            $('#authority_nm').focus();
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
 *    getRightContent
 *
 * @author      :   nghianm - 2020/10/07 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(authority_cd) {
    try {
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rs0020/rightcontent',
            dataType: 'json',
            loading: false,
            data: {authority_cd: authority_cd},
            success: function (res) {
                // fill 権限名称
                var data2 = res.data2[0];
                $('#authority_cd').val(data2.authority_cd);
                $('#authority_nm').val(htmlEntities(data2.authority_nm));
                $('#use_typ').prop('checked', data2.use_typ == '1' ? true:false);
                $('#organization_belong_person_typ').prop('checked', data2.organization_belong_person_typ == '1' ? true:false);
                if($('#organization_belong_person_typ').is(":checked")){
                    $('#table-organization').find('input[type=checkbox]').prop('checked', false);
                    $('#table-organization').find('input[type="checkbox"]').attr('disabled',true);
                    $('#table-organization').find('.checkmark').css('background','rgb(199, 205, 212)');
                }
                else {
                    $('#table-organization').find('input[type="checkbox"]').removeAttr('disabled');
                    $('#table-organization').find('.checkmark').css('background','white');
                }
                $('#arrange_order').val(data2.arrange_order);

                // fill 機能毎の権限設定
                var data0 = res.data0;
                if (data0.length > 0) {
                    data0.map(function(item) {
                        $('select.'+item.function_id).val(item.authority);
                    });
                }
                else {
                    $('select.authority').val('-1');
                }
                $('#table-organization input[type=checkbox]').prop('checked', false);
                // fill organization
                if (res.lvl.length > 0) {
                    res.lvl.map(function(item) {
                        if (item.authority === '1') {
                            $('.'+item.selector).prop('checked', true);
                        }
                        else {
                            $('.'+item.selector).prop('checked', false);
                        }
                    });
                }
                else {
                    $('input.authority').prop('checked', false);
                }

                $('#authority_nm').focus();
                $('#authority_nm').removeClass('boder-error');
                $('#authority_nm').next('.textbox-error').remove();
                app.jTableFixedHeader();
                $('#authority_nm').focus();
                $.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
