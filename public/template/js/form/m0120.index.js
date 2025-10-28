/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/06/22
 * 作成者          :   datnt – datnt@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'point_kinds'        : {'type':'text', 'attr':'id'},
    'point_kinds_nm'    : {'type':'text', 'attr':'id'},
    'arrange_order'     : {'type':'text', 'attr':'id'},
    'list_point_kinds':{
        'attr': 'list', 'item': {
            'mode'               : {'type': 'text', 'attr': 'class'},
            'point_cd'          : {'type': 'text', 'attr': 'class'},
            'point_nm'          : {'type': 'text', 'attr': 'class'},
            'point'             : {'type': 'text', 'attr': 'class'},
            'point_criteria'   : {'type': 'text', 'attr': 'class'}
        }
    },
};
var _flgLeft = 0;
//
$(function(){
    initEvents();
    initialize();
});

/**
 * initialize
 *
 * @author      :   datnt - 2018/06/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('#point_kinds_nm').focus();
        //
        _formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   datnt - 2018/06/21 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {

    /* paging */
    $(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
        var page = $(this).attr('page');
        var search = $('#search_key').val();
        getLeftContent(page, search);
    });

    //
    $(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
        var page = $(this).attr('page');
        var search = $('#search_key').val();
        getLeftContent(page, search);
    });

    //
    $(document).on('click', '#btn-search-key', function(e) {
        var page = 1;
        var search = $('#search_key').val();
        getLeftContent(page, search);
    });

    //
    $(document).on('change', '#search_key', function(e) {
        var page = 1;
        var search = $('#search_key').val();
        getLeftContent(page, search);
    });

    //
    $(document).on('enterKey', '#search_key', function(e) {
        var page = 1;
        var search = $('#search_key').val();
        getLeftContent(page, search);
    });

    //
    $(document).on('click', '.list-search-child', function(e) {
        $('.list-search-child').removeClass('active');
        $(this).addClass('active');
        getRightContent( $(this).attr('id') );
    });
     $(document).on('blur','.point',function(){
        var _this 	= 	$(this)
        var val 	=	_this.val();
            val 	= 	formatConvertHalfsize(val);
        if (_this.attr('negative')) {
            if (!_validateNumber(val)) {
                _this.val('');
            }
        }else{
            if (!_isNormalInteger(val)) {
                _this.val('');
            }
        }
    });
    $(document).on('keydown','.point',function (event) {
        try {
            var negativeEnabled = false;
            if ($(this).attr('negative')) {
                negativeEnabled = $(this).attr('negative');
            }
            if (event.keyCode == 53){
                return true;
            }
            if (!((event.keyCode > 47 && event.keyCode < 58)
                    || (event.keyCode > 95 && event.keyCode < 106)
                    || event.keyCode == 116
                    || event.keyCode == 46
                    || event.keyCode == 37
                    || event.keyCode == 39
                    || event.keyCode == 8
                    || event.keyCode == 9
                    || event.ctrlKey // 20160404 - sangtk - allow all ctrl combination //
                    || event.keyCode == 229 // ten-key processing
                    )
                    // || event.shiftKey
                    || (negativeEnabled == false
                            && event.keyCode == 189 || event.keyCode == 109)) {
                event.preventDefault();
            }
            if (negativeEnabled && (event.keyCode == 189 || event.keyCode == 109)) {
                var _this 			=	$(this);
                var val 			= 	_this.val();
                var character 		=	val.substring(0,1);
                var negative 		=	'';
                var maxlength 		=	_this.attr('maxlength')*1;
                if(character=='-'){
                    _this.attr('maxlength',maxlength-1);
                    negative 	= val.replace(/-/g, '');
                }else{
                    _this.attr('maxlength',maxlength+1);
                    negative 	= '-' + val.replace(/-/g, '');
                }
                // var negative 	= '-' + val.replace(/-/g, '');

                $(this).val(negative);
            }
        } catch (e) {
            alert(e.message);
        }
    })
    //btn-add-row
    $(document).on('click','#btn-add-new-row',function () {
        try{
            var row = $("#table-target tbody tr:first").clone();
            $('#table-data tbody').append(row);
            $('#table-data').find('tbody tr:last td:first-child input').focus();
            $('#table-data').find('tbody tr:last').addClass('list_point_kinds');
        } catch(e){
            alert('btn-add-new: ' + e.message);
        }
    });

    //btn-remove-row
    $(document).on('click','.btn-remove-row',function () {
        try{
            $(this).parents('tr').remove();
        } catch(e){
            alert('btn-remove-row: ' + e.message);
        }
    });

    //
    $(document).on('click', '#btn-add-new', function(e) {
        jMessage(5,function(){
            //
            $('#point_kinds').val(0);
            $('#point_kinds_nm').val('');
            $('#arrange_order').val('');
            //
            $('.list-search-child').removeClass('active');
            //
            $('#table-data tbody').empty();
            $('#btn-add-new-row').trigger('click');
            //
            $('#point_kinds_nm').focus();
        })
    });

    //
    $(document).on('click', '#btn-save', function(e) {
        jMessage(1, function(r) {
            checkRequired();
            _flgLeft = 1;
            if ( r && _validate($('body'))){
                if(checkData() == 1) {
                    jMessage(29);
                }else{
                    saveData();
                }
            }
        });
    });

    //
    $(document).on('click', '#btn-delete', function(e) {
        jMessage(3, function(r) {
            if (r){
                deleteData();
            }
        });
    });

    //change point_nm
    $(document).on('change', '.point_nm', function(e) {
        if($(this).val() != ''){
            $(this).closest('tr').find('.point').removeClass('required');
            $(this).closest('tr').find('.point').removeClass('boder-error');
            $(this).closest('tr').find('.point').next('.textbox-error').remove();
        }
    });

    //change point
    $(document).on('change', '.point', function(e) {
        if($(this).val() != ''){
            $(this).closest('tr').find('.point_nm').removeClass('required');
            $(this).closest('tr').find('.point_nm').removeClass('boder-error');
            $(this).closest('tr').find('.point_nm').next('.textbox-error').remove();
        }
    });

    //
    $(document).on('click', '#btn-back', function(e) {
        // window.location.href = '/dashboard'
        if(_validateDomain(window.location)){
            window.location.href = '/dashboard';
        }else{
            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
        }
    });
}

/**
 * save
 *
 * @author      :   binhnn - 2018/09/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    try {
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0120/save',
            dataType    :   'json',
            loading     :   true,
            data        :   JSON.stringify(data),
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        //
                        jMessage(2, function(r) {
                            $('#point_kinds').val(0);
                            $('#point_kinds_nm').val('');
                            $('#arrange_order').val('');
                            $('#table-data tbody').empty();
                            $('#btn-add-new-row').trigger('click');
                            var page = $('#leftcontent').find('.active a').attr('page');
                            var search = $('#search_key').val();
                            getLeftContent(page, search);
                            $('#point_kinds_nm').focus();
                        });
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
    } catch (e) {
        alert('save' + e.message);
    }
}

/**
 * save
 *
 * @author      :   binhnn - 2018/09/05 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
    try {
        var data = {};
        data['point_kinds'] = $('#point_kinds').val();
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0120/delete',
            dataType    :   'json',
            loading     :   true,
            data        :   data,
            success: function(res) {
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
                            //clearData(_obj);
                            location.reload();
                        });
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
    } catch (e) {
        alert('save' + e.message);
    }
}

function getLeftContent(page, search) {
    try {
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0120/leftcontent',
            dataType   :   'html',
            loading    :   true,
            data       :   {current_page: page, search_key: search},
            success: function(res){
                if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
                    jMessage(164);
                } else {
                    $('#leftcontent .inner').empty();
                    $('#leftcontent .inner').html(res);
                    var point_kinds = $('#point_kinds').val();
                    $('.list-search-content div[id="'+point_kinds+'"]').addClass('active');
                    $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                    //
                    if(_flgLeft != 1){
                        $('#search_key').focus();
                    }else{
                        _flgLeft = 0;
                    }
                    _formatTooltip();
                }
            }
        });
    } catch (e) {
        alert('get left content: ' + e.message);
    }
}

function getRightContent(point_kinds) {
    try {
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0120/rightcontent',
            dataType    :   'html',
            // loading     :   true,
            data        :   {point_kinds: point_kinds},
            success: function(res){
                $('#rightcontent .inner').empty();
                $('#rightcontent .inner').append(res);
                //
                $('#point_kinds_nm').focus();
                $.formatInput();
            }
        });
    } catch (e) {
        alert('get right content: ' + e.message);
    }
}
/**
 * function checkData
 *
 * @author  :   ANS-ASIA BINHNN - 2018/01/31 - create
 * @author  :
 *
 */
function checkData() {
    try {
        _clearErrors();
        var error = 0;
        var count = $('#table-data tbody tr').length;
        //
        if(count == 0) {
            error = 1;
        }
        return error;
    } catch (e) {
        alert('checkData: ' + e.message);
    }
}
/**
 * function checkRequired
 *
 * @author  :   sondh-2018/12/27
 * @author  :
 *
 */
function checkRequired(){
    try{
        $('#table-data tbody tr').each(function () {
            var point_nm  = $(this).find('.point_nm ').val();
            var point = $(this).find('.point ').val();

            if(point_nm == '' && point ==''){
                $(this).find('.point_nm').addClass('required');
                $(this).find('.point').addClass('required');
            }else{
                $(this).find('.point_nm').removeClass('required');
                $(this).find('.point').removeClass('required');
            }
        });
    }catch(e){
        alert('checkRequired: ' + e.message);
    }
}
/**
	 * _validateNumber
	 *
	 * @author : biennv - 2015/04/17 - create
	 * @param :
	 *            string
	 * @returns : {Boolean}
	 */
	function _validateNumber(string) {
		try {
			var regexp = /^-*[0-9]+$/;
			if (regexp.test(string) || string == '') {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert(e.message);
		}
	}