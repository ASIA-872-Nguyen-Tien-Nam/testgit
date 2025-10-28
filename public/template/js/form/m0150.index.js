$(document).ready(function(){

});


/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2018/08/15
 * 作成者          :   mirai – mirai@ans-asia.com
 * 作成者          :   logic – tannq@ans-asia.com
 *
 * @package     :   MODULE MASTER
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version     :   1.0.0
 * ****************************************************************************
 */
var _obj = {
    'group_cd'                    :   {'type':'numeric',     'attr':'id'},
    'group_nm'                    :   {'type':'text',     'attr':'id'},
    'arrange_order'               :   {'type':'numeric',     'attr':'id'},
    'm0060'                          : {'attr' : 'list', 'item' : {
            'chk'                       : {'type' : 'checkbox'      , 'attr' : 'class'}
        ,   'code'                      : {'type' : 'numeric'      , 'attr' : 'class'}
    },
    },
    'm0030'                          : {'attr' : 'list', 'item' : {
            'chk'                       : {'type' : 'checkbox'      , 'attr' : 'class'}
        ,   'code'                      : {'type' : 'numeric'      , 'attr' : 'class'}
    },
    },
    'm0040'                          : {'attr' : 'list', 'item' : {
            'chk'                       : {'type' : 'checkbox'      , 'attr' : 'class'}
        ,   'code'                      : {'type' : 'numeric'      , 'attr' : 'class'}
    },
    },
    'm0050'                          : {'attr' : 'list', 'item' : {
            'chk'                       : {'type' : 'checkbox'      , 'attr' : 'class'}
        ,   'code'                      : {'type' : 'numeric'      , 'attr' : 'class'}
    }
    }
};

$(function(){
    initialize();
    initEvents();
});

/**
 * initialize
 *
 * @author      :   mirai - 2018/06/21 - create
 * @author      :   tuantv
 * @author      :   tannq -logic
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
    try{
        $('.indexTab:first').focus();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author      :   mirai - 2018/08/15 - create
 * @author      :   tuantv
 * @author      :   tannq -logic
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
    try {
         document.addEventListener('keydown', function (e) {
            if (e.keyCode  === 9) {
                if (e.shiftKey) {
           if ($(':focus')[0] === $("#rightcontent :input:not([readonly],[disabled],:hidden)").first()[0]) {
                e.preventDefault();
                if($('.pager-wrap a:not(.disabled,.no-focus,.disable,:hidden)').last().length!=0){
                    $('.pager-wrap a:not(.disabled,.no-focus,.disable,:hidden)').last().focus();
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
                if ($(':focus')[0] === $('.pager-wrap a:not(.disabled,.no-focus,.disable,:hidden)').last()[0]) {
                    e.preventDefault();
                    $("#rightcontent :input:not([readonly],[disabled],:hidden)").first().focus();
                }
            }
        }
        });
        $(document).on('click','.page-item:not(.active):not(.disaled):not([disabled])',function(e) {
            e.preventDefault();
            $('.page-item').removeClass('active');
            $(this).addClass('active')
            var page = $(this).attr('page');
            leftcontent(page);
        });

        $(document).on('change','#keyword',function() {
            leftcontent();
        });

        $(document).on('click','.list-search-child:not([empty])',function(e) {
            e.preventDefault();
            rightcontent($(this));
        });

       /* $(document).on('keypress', '#arrange_order', function(e) {
            alert(1);
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        });
*/
        $(document).on('click','#btn-save',function(e) {
            e.preventDefault();
            var nextRequest = true;
            // $('.m0060 .md-checkbox-v2.has-error .label-error').removeAttr('data-original-title');
            // $('.m0060 .md-checkbox-v2').removeClass('has-error');
            jMessage(1, function (r) {
                // if($('.m0060 input.chk:checked').length ==0) {
                //     $('.m0060 .md-checkbox-v2').addClass('has-error');
                //     $('.has-error .label-error').attr('title',_text[8].message).tooltip();
                //     // $('.label-error').tooltip()
                //     $('.label-error').on('shown.bs.tooltip', function () {
                //       $('.tooltip').addClass('has-error');
                //     })
                //     nextRequest = false;
                // }
                if($('#group_nm').val()=='') {
                    $('#group_nm').errorStyle(_text[8].message,1);
                    $('#group_nm').focus()
                    nextRequest = false;
                }
                if(nextRequest) {
                    saveData();
                }
            });
        });

        // reset
        $(document).on('click','#btn-add-new',function(e){
            e.preventDefault();
            jMessage(5, function (r) {
                if(r){
                    $('.list-search-child').removeClass('active');
                    $('#rightcontent .inner').find('input:not(:checkbox):not(.code)').val('');
                    $('input.chk:checked').each(function(){
                        $(this).prop('checked',false);
                    });
                    $('.md-checkbox-v2.has-error').removeClass('has-error');
                    $('.label-error').removeAttr('data-original-title');
                    $('.indexTab:first').focus();
                    $('#rightcontent .inner').removeClass('has-copy');
                }
            });

        });

        // delete
        $(document).on('click','#btn-delete',function(e) {
            e.preventDefault();
            var group_cd = $('#group_cd').val();
            jMessage(3, function (r) {
                if(r){
                    deleteData(group_cd)
                }
            });
        });

        $(document).on('click', '#btn-back', function(){
            // window.location.href = '/dashboard';
            if(_validateDomain(window.location)){
                window.location.href = '/dashboard';
            }else{
                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
            }
        });

        $(document).on('click','#btn-copy',function(e) {
            e.preventDefault();
            $('#rightcontent .inner').find('input:not(:checkbox):not(.code)').val('');
            $('#rightcontent .inner').addClass('has-copy');
            // $(this).closest('li').addClass('active');
            $('.indexTab:first').focus();
        })

    } catch(e){
        alert('initialize: ' + e.message);
    }
}

/**
 * left
 *
 * @author      :   tannq
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function leftcontent(page,callback) {
    var obj = {};
        obj.group_nm = $('#keyword').val();
        obj.page = typeof page =='undefined' ? 1 : page;
        $.ajax({
            url:'/master/m0150/leftcontent',
            type:'get',
            data:obj,
            loading:true,
            success:function(res) {
                if(res['status'] != undefined && res['status'] == 164) {
                    jMessage(164);
                } else {
                $('#left-respon').html(res);
                    if(typeof callback =='function') {
                        $('#rightcontent .inner').removeClass('has-copy');
                        callback(res)
                        $('.indexTab:first').focus();
                    }
                }
            },
            error:function(xhr) {
                jError('エラー',xhr.statusText);
            }
        });
}

/**
 * right
 *
 * @author      :   tannq
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function rightcontent(el) {
    var obj = {};
        obj.group_cd = el.find('.group_cd').val();
        $.ajax({
            url:'/master/m0150/rightcontent',
            type:'get',
            data:obj,
            loading:true,
            success:function(res) {
                $('#right-respon').html(res);
                $('#group_nm').val(el.find('.group_nm').val());
                $('#group_cd').val(el.find('.group_cd').val());
                $('#arrange_order').val(el.find('.arrange_order').val());
                $('#rightcontent .inner').removeClass('has-copy');
                $('.indexTab:first').focus();
                _formatTooltip();
            },
            error:function(xhr) {
                jError('エラー',xhr.statusText);
            }
        });
}

/**
 * save
 *
 * @author      :   tannq
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
    var data    = getData(_obj);
    // send data to post
    $.ajax({
        type        :   'POST',
        url         :   '/master/m0150/save',
        dataType    :   'json',
        loading     :   true,
        data        :   JSON.stringify(data),
        success: function(res) {
            switch (res.status){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
                        $('#rightcontent .inner').removeClass('has-copy');
                        var page = $('.pagination .page-item.active').attr('page');
                         var group_cd = res.group_cd;
                            page = page ? page : 1;
                            leftcontent(page,function() {
                                // $('.list-search-child').find('.group_cd[value="'+group_cd+'"]').closest('.list-search-child').addClass('active');
                                // $('.indexTab:first').focus();
                            })
                            // location.reload()
                            $('#rightcontent').find('input:not(.code):not(:checkbox)').val('');
                            $(':checkbox').prop('checked',false)
                            $('.list-search-child.active').removeClass('active');
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
}

/**
 * save
 *
 * @author      :   tannq
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData(group_cd) {
    try {
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0150/delete',
            loading     :   true,
            data        :   {group_cd:group_cd},
            success: function(res) {
                $('#rightcontent .inner').removeClass('has-copy');
                switch (res['status']){
                    // success
                    case OK:
                        jMessage(4, function(r) {
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
