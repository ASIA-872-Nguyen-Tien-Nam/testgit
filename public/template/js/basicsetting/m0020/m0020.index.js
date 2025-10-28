/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/08/22
 * 作成者          :   SonDH – sondh@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
	"organization_typ":"",
	"organization_cd_1":"",
    "organization_cd_2":"",
    "organization_cd_3":"",
    "organization_cd_4":"",
    "organization_cd_5":"",
	"organization_nm":"",
	"organization_ab_nm":"",
	"responsible_cd":"",
	"arrange_order":"",
	"employee_nm":"",
	"parent_cd":"",
	"same_level": "",
	"employee_nm": "",
	"import_cd": ""
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
 * @author      :   SonDH - 2018/08/22 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
	try{
		$('#organization_nm').focus();
		$('.list-search-father').tooltip();
        $('.list-search-content').removeAttr('style');
        // $('#btn-Create-Division').addClass('disabled');
        // new
        ajaxLeft('', 1);
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/*
 * INIT EVENTS
 * @author      :   SonDH - 2018/08/22 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    document.addEventListener('keydown', function (e) {
        if (e.keyCode  === 9) {
            if (e.shiftKey) {
               if ($(':focus')[0] === $("#rightcontent :input:not(.pagging-disable,[readonly],[disabled],:hidden)").first()[0]) {
                    e.preventDefault();
                    if($(".list-search-content a:not(.pagging-disable,[readonly],[disabled],:hidden)").last().length!=0){
                        $(".list-search-content a:not(.pagging-disable,[readonly],[disabled],:hidden)").last()[0].focus();
                    }
                    else{
                        var max = -1;
                         $(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
                            max = Math.max(max, +b);
                        });
                        $(":input:not([readonly],[disabled],:hidden)[tabindex="+max+"]").focus();
                    }
                    return;
                }

                var max = -1;
                $(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
                    max = Math.max(max, +b);
                });

                if ($(':focus')[0] === $('#ans-collapse a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]) {
                    e.preventDefault();
                    $(":input:not([readonly],[disabled],:hidden)[tabindex="+max+"]").focus();
                }
            }else{
                if ($(':focus')[0] === $('.list-search-content a:not(.disabled,.no-focus,.disable,:hidden)').last()[0]) {
                    e.preventDefault();
                    $("#rightcontent :input:not([readonly],[disabled],:hidden)").first().focus();
                }
            }
        }
    });
    $(document).on('click','#btn-change-org-name',function(){
        showPopup(
			'/common/popup/get_organization',
			{width: '550px', height: '460px'},
			function() {}
		);
    })

	$(document).on('click','#btn-create-org', function(e) {
		//
		jMessage(5, function(r) {
			var organization_cd_1 = $('#organization_cd_1').val();
            var organization_cd_2 = $('#organization_cd_2').val();
            var organization_cd_3 = $('#organization_cd_3').val();
            var organization_cd_4 = $('#organization_cd_4').val();
            var organization_cd_5 = $('#organization_cd_5').val();
			var organization_typ  = $('#organization_typ').val();
            var cr_same_org       = $('.cr_same_org').val();

            resetX();
            $('#organization_cd_1').val(organization_cd_1);
            $('#organization_cd_2').val(organization_cd_2);
            $('#organization_cd_3').val(organization_cd_3);
            $('#organization_cd_4').val(organization_cd_4);
            $('#organization_cd_5').val(organization_cd_5);
            $('#organization_typ').val(organization_typ);
            $('#same_level').val(0);
            $('#organization_nm').focus();

            // create breadcrumb
            var actived = $('.list-search-content a.actived');
            if (actived.length > 0) {
                // do not delete
                $('#editing').val('-1');
                //
                var cd = actived.attr('cd').split('-');
                var typ = actived.attr('typ');
                var cd0 = cd[0];
                var cd1 = cd[1];
                var cd2 = cd[2];
                var cd3 = cd[3];
                var cd4 = cd[4];
                var output = [];

                // if (cd0 != '') {
                //     output.push($('a[cd="'+cd0+'----"]').attr('txt'));
                //     console.log(output);
                // }
                if (cd1 != '') {
                    output.push($('a[cd="'+cd0+'----"]').attr('txt'));
                }
                if (cd2 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'---"]').attr('txt'));
                }
                if (cd3 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'-'+cd2+'--"]').attr('txt'));
                }
                if (cd4 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'-'+cd2+'-'+cd3+'-"]').attr('txt'));
                }

                if (typ !== '1') {output.push(cr_same_org);}
               
                $('#breadcrumbX').empty().html('<li class="breadcrumb-item">'
                    +output.join('</li><li class="breadcrumb-item">')+'</li>');
            }
		});
	});

	$(document).on('click','#btn-Create-Division', function(e) {
		//
		jMessage(5, function(r) {
            var organization_cd_1 = $('#organization_cd_1').val();
            var organization_cd_2 = $('#organization_cd_2').val();
            var organization_cd_3 = $('#organization_cd_3').val();
            var organization_cd_4 = $('#organization_cd_4').val();
            var organization_cd_5 = $('#organization_cd_5').val();
			var organization_typ  = $('#organization_typ').val();
            var cr_sub_org        = $('.cr_sub_org').val();

            resetX();
            $('#organization_cd_1').val(organization_cd_1);
            $('#organization_cd_2').val(organization_cd_2);
            $('#organization_cd_3').val(organization_cd_3);
            $('#organization_cd_4').val(organization_cd_4);
            $('#organization_cd_5').val(organization_cd_5);
            $('#organization_typ').val(organization_typ);
            $('#same_level').val(1);
            $('#organization_nm').focus();

            // create breadcrumb
            var actived = $('.list-search-content a.actived');
            if (actived.length > 0) {
                // do not delete
                $('#editing').val('-1');
                //
                var cd = actived.attr('cd').split('-');
                var typ = actived.attr('typ');
                var cd0 = cd[0];
                var cd1 = cd[1];
                var cd2 = cd[2];
                var cd3 = cd[3];
                var cd4 = cd[4];
                var output = [];

                if (cd0 != '') {
                    output.push($('a[cd="'+cd0+'----"]').attr('txt'));
                }
                if (cd1 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'---"]').attr('txt'));
                }
                if (cd2 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'-'+cd2+'--"]').attr('txt'));
                }
                if (cd3 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'-'+cd2+'-'+cd3+'-"]').attr('txt'));
                }
                if (cd4 != '') {
                    output.push($('a[cd="'+cd0+'-'+cd1+'-'+cd2+'-'+cd3+'-'+cd4+'"]').attr('txt'));
                }

                output.push(cr_sub_org);

                $('#breadcrumbX').empty().html('<li class="breadcrumb-item">'
                    +output.join('</li><li class="breadcrumb-item">')+'</li>');
            }
            else {
                $('#same_level').val(0);
            }
		});
	});

	$(document).on('click','#btn-delete', function(e) {
		if ($('a.actived').length === 0 || $('#editing').val() === '-1') {
            jMessage(21);
			return false;
		}
        else {
    		jMessage(3, function(r) {
    			deleteX();
    		});
        }
	});

	$(document).on('click','#btn-save', function(e) {
		if ($('a.actived').length < 0) {
			return false;
		}
		jMessage(1, function(r) {
			saveX();
		});
	});

    $(document).on('click','#btn-back',function(e) {
        e.preventDefault();
        // location.href="/dashboard";
        if(_validateDomain(window.location)){
            window.location.href = 'sdashboard';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });

	// left panel
	$(document).on('click', '#btn-search-key', function(e) {
        var page = 1;
        ajaxLeft($('#search_key').val(), page, true);
    });

    $(document).on('keypress', '#search_key', function(evt) {
        evt = evt || window.event;
        var charCode = evt.keyCode || evt.which;
        if (parseInt(charCode) === 13) {
            var page = 1;
            ajaxLeft($('#search_key').val(), page, true);
        }
    });

	$(document).on('click', '.page-link', function(e) {
        var page = $(this).attr('page');
        ajaxLeft($('#search_key').val(), page);
    });

    var lv = '.lv1,.lv2,.lv3,.lv4,.lv5';
	$(document).on('click', lv, function(e) {
        var typ = $(this).attr('typ');
        var cd = $(this).attr('cd');
        $(lv).removeClass('actived');
        $(this).addClass('actived');
        $('#same_level').val('-1');
        // do not delete
        $('#editing').val('0');
        //
        //
        getRightContent(typ, cd);
        //
        if ($(this).hasClass('lv5')) {
        	$('.btn-Create-Division').addClass('disabled');
        }
        else {
        	$('.btn-Create-Division').removeClass('disabled');
        }
        //
        return false;
    });

    $(document).on('change', '#employee_nm', function(e) {
        // var $this = $(this);
        // var data = {employee_cd: $this.val()};
        // $.post('/master/m0020/checkemployee', data).then(res => {
        //     if (!res.exists) {
        //         $this.val('').siblings('.employee_nm').val('');
        //     }
        // })
    });

    $(document).on('change','#responsible_cd', function(e) {
        var $this = $(this);
        var data = {employee_cd: $this.val()};
        $.post('/basicsetting/m0020/checkemployee', data).then(res => {
            if (!res.exists) {
                $this.val('').siblings('.employee_nm').val('');
            }
        })
    });
}

/**
 * get left data
 * @param  {String} key [key search]
 * @return {Void}
 */
function ajaxLeft(key, current_page, loading) {
    // if (typeof loading == 'undefined') {
    //     loading = false;
    // }
    $.ajax({
        type        :   'POST',
        url         :   '/basicsetting/m0020/ajaxleft',
        dataType    :   'json',
        loading     :   true,
        data        :   {key: key, current_page: current_page}
    })
    .then(res => {
        if(res['status'] != undefined && res['status'] == 164) {
            jMessage(164);
        } else {
        $('#leftul nav').empty().html(res.paging).find('ul').css('margin-top', '1rem');
        fillLeft(res);
        }
    });
}

/**
 * generate left content from data
 * @param  {JSON} data [lvl1,lvl2,lvl3,lvl4,lvl5]
 * @return {DOM}
 */
function fillLeft(data) {
    var lvl1 = data.lvl1;
    var lvl2 = data.lvl2;
    var lvl3 = data.lvl3;
    var lvl4 = data.lvl4;
    var lvl5 = data.lvl5;

    // clear
    $('.list-search-content').empty();

    if (lvl1.length === 0) {
        $('.list-search-content').append('<ul><li style="text-align: center;"><div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="'+_text[21].message+'">'+_text[21].message+'</div></li></ul>');
        $('div[data-toggle="tooltip"]').tooltip();
        return;
    }

    // fill level 1
    for (var i = 0; i < lvl1.length; i++) {
        if ($('.list-search-content > ul').length === 0) {
            $('.list-search-content').append('<ul></ul>');
        }
        var time = (new Date().getTime()) + i + 10;
        var li = makeLi(lvl1[i], i, 1, time);
        $('.list-search-content > ul').append(li);
    }

    // fill level 2
    for (var j = 0; j < lvl2.length; j++) {
        var parent = 'parent-' + lvl2[j].parent;
        if ($('li.'+parent+'>ul').length === 0) {
            $('li.'+parent).append('<ul class="collapse"></ul>');
        }
        var time = (new Date().getTime()) + i + 100;
        var li = makeLi(lvl2[j], j, 2, time);
        $('li.'+parent+'>ul').append(li);
    }

    // fill level 3
    for (var k = 0; k < lvl3.length; k++) {
        var parent = 'parent-' + lvl3[k].parent;
        if ($('li.'+parent+'>ul').length === 0) {
            $('li.'+parent).append('<ul class="collapse"></ul>');
        }
        var time = (new Date().getTime()) + i + 1000;
        var li = makeLi(lvl3[k], k, 3, time);
        $('li.'+parent+'>ul').append(li);
    }

    // fill level 4
    for (var l = 0; l < lvl4.length; l++) {
        var parent = 'parent-' + lvl4[l].parent;
        if ($('li.'+parent+'>ul').length === 0) {
            $('li.'+parent).append('<ul class="collapse"></ul>');
        }
        var time = (new Date().getTime()) + i + 10000;
        var li = makeLi(lvl4[l], l, 4, time);
        $('li.'+parent+'>ul').append(li);
    }

    // fill level 5
    for (var m = 0; m < lvl5.length; m++) {
        var parent = 'parent-' + lvl5[m].parent;
        if ($('li.'+parent+'>ul').length === 0) {
            $('li.'+parent).append('<ul class="collapse"></ul>');
        }
        var time = (new Date().getTime()) + i + 100000;
        var li = makeLi(lvl5[m], m, 5, time);
        $('li.'+parent+'>ul').append(li).find('a.lv5').attr('href', 'javascript:void(0)').removeAttr('data-toggle');
    }

    // fill id for collapse
    $('.lv1,.lv2,.lv3,.lv4,.lv5').each(function() {
        var id = generateGuid();
        $(this).attr('href', '#'+id);
        $(this).siblings('ul').attr('id', id);
    });

    $('ul.collapse').on('show.bs.collapse', function () {
        $(this).siblings('a').addClass('rotator');
    });

    $('ul.collapse').on('hide.bs.collapse', function () {
        $(this).siblings('a').removeClass('rotator');
    });

    //
    // fillLevel(data.lvl1, 1);
    $('[data-toggle="tooltip"]').tooltip();
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
        "class":"lv1",
        "txt":"",
        "data-toggle":"collapse",
        "href":"collapse-" + time,
        "typ":"",
        "cd":"",
        "aria-expanded":"true"
    };
    var div_props = {
        "class":"text-overfollow",
        "data-container":"body",
        "data-toggle":"tooltip",
        "data-original-title":""
    };
    parent = a_props.href.replace('{i}', index);

    a_props.class = "lv"+level;
    a_props.txt = item.organization_ab_nm == '' ? item.organization_nm : item.organization_ab_nm ;
    a_props.href = "#"+parent;
    a_props.typ = level;
    a_props.cd = item.organization_cd_1.replace("-", "|@|")+'-'+item.organization_cd_2.replace("-", "|@|")+'-'+item.organization_cd_3.replace("-", "|@|")+'-'+item.organization_cd_4.replace("-", "|@|")+'-'+item.organization_cd_5.replace("-", "|@|");

    var a = $('<a>', a_props);
    div_props["data-original-title"] = item.organization_nm;
    var div = $('<div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="'+item.organization_nm+'" >')//$('<div>', div_props)
        .append('<i class="fa fa-chevron-right"></i>')
        .append($('<span>').text(' '))
        .append($('<span >').text(htmlEntities(item.organization_nm)));
    li.append(a.append(div));
    return li;
}

/**
 * reset items value
 * @return {[type]} [description]
 */
function resetX() {
    $('#organization_cd').val('');
    $('#organization_nm').val('');
    $('#organization_ab_nm').val('');
    $('#employee_nm').val('');
    $('#responsible_cd').val('');
    $('#arrange_order').val('');
    $('#organization_typ').val('');
    $('#organization_cd').val('');
    $('#parent_cd').val('');
    $('#same_level').val('');
    $('#import_cd').val('');
}
function resetRight() {
    $('#organization_typ').val('1');
    $('#organization_cd_1').val('');
    $('#organization_cd_2').val('');
    $('#organization_cd_3').val('');
    $('#organization_cd_4').val('');
    $('#organization_cd_5').val('');
    $('#same_level').val('0');
    $('#organization_nm').val('');
    $('#organization_ab_nm').val('');
    $('#employee_nm').val('');
    $('#responsible_cd').val('');
    $('#arrange_order').val('');
    $('#organization_cd').val('');
    $('#parent_cd').val('');
    $('#import_cd').val('');
    $('#breadcrumbX').empty();
}

/**
 * delete function
 *
 * @return {[type]} [description]
 */
function deleteX() {
	var data = _obj;

	Object.keys(data).map(item => {
		data[item] = $('#'+item).val();
		return item;
	});

	$.ajax({
        type        :   'POST',
        url         :   '/basicsetting/m0020/delete',
        dataType    :   'json',
        loading     :   false,
        data        :   data,
        success: function(res) {
            switch (res['status']){
                // success
                case OK:
                    jMessage(4, function(r) {
                        // ajaxLeft('', 1);
                        // resetRight();
                        location.reload();
                    });
                    break;
                // error
                case NG:
                    if(typeof res['errors'] != 'undefined'){
                        processError(res['errors']);
                    }
                break;
                case 405:
                    jMessage(27, function () {
                    });
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
}

/**
 * save
 * @return {[type]} [description]
 */
function saveX() {
	var data = _obj;

	Object.keys(data).map(item => {
		data[item] = $('#'+item).val();
		return item;
	});

	$.ajax({
        type        :   'POST',
        url         :   '/basicsetting/m0020/save',
        dataType    :   'json',
        loading     :   false,
        data        :   data,
        success: function(res) {
            switch (res['status']){
                // success
                case OK:
                    jMessage(2, function(r) {
                    	// getLeftContent(1);
                        // ajaxLeft('', 1);
                        // resetX();
                        // $('#organization_typ').val('1');
                        // $('#same_level').val('0');
                        // $('#breadcrumbX').empty();
                        location.reload();
                    });
                    break;
                // error
                case NG:
                    if(typeof res['errors'] != 'undefined'){
                        processError(res['errors']);
                    }
                break;
                case 405:
                    jMessage(27, function () {
                    });
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
}

/**
 * refer left content
 *
 * @param  {integer} page [current page number]
 * @return {dom}      [list in dom]
 */
function getLeftContent(page) {
    var search = $('#search_key').val();

	$.ajax({
        type        :   'POST',
        url         :   '/basicsetting/m0020/leftcontent',
        dataType    :   'html',
        loading     :   false,
        data        :   {current_page: page, search_key: search}
    })
    .then(res => {
    	$('#leftul').empty().html(res);
        _formatTooltip();
    });
}

/**
 * refer right content
 *
 * @param  {integer} cd [organization_cd]
 * @return {json}    [info right content]
 */
function getRightContent(typ, cd) {
	$.ajax({
        type        :   'POST',
        url         :   '/basicsetting/m0020/rightcontent',
        dataType    :   'json',
        loading     :   true,
        data        :   {organization_typ: typ, cd: cd}
    })
    .then(res => {
        var txt = [];
        txt.push(res.text1);
        if (res.text2 !== '') {txt.push(res.text2);}
        if (res.text3 !== '') {txt.push(res.text3);}
        if (res.text4 !== '') {txt.push(res.text4);}
        if (res.text5 !== '') {txt.push(res.text5);}
        var crumb = '<li class="breadcrumb-item">'+txt.join('</li><li class="breadcrumb-item">')+'</li>';
        $('#breadcrumbX').empty().html(crumb);
        //
    	fillData(res, typ);
        $('#organization_nm').removeClass('boder-error');
        $('#organization_nm').siblings('.textbox-error').remove();
    });
}

/**
 * fill dom value by object given
 * @param  {object} res [_obj]
 * @return {[type]}     [description]
 */
function fillData(res, typ) {
	Object.keys(res).map(item => {
        if(item == 'employee_nm'){
            $('#employee_nm').attr('old_employee_nm',htmlEntities(res[item]+''));
        }
		$('#'+item).val(htmlEntities(res[item]+''));
		return item;
	});
}