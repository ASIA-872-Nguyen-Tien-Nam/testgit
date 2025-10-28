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
    'target_management_typ'             : {'type':'', 'attr':'id'},
    'target_self_assessment_typ'        : {'type':'', 'attr':'id'},
    'target_evaluation_typ_1'           : {'type':'', 'attr':'id'},
    'target_evaluation_typ_2'           : {'type':'', 'attr':'id'},
    'target_evaluation_typ_3'           : {'type':'', 'attr':'id'},
    'target_evaluation_typ_4'           : {'type':'', 'attr':'id'},
    'evaluation_use_typ'                : {'type':'', 'attr':'id'},
    'evaluation_self_assessment_typ'    : {'type':'', 'attr':'id'},
    'evaluation_typ_1'                  : {'type':'', 'attr':'id'},
    'evaluation_typ_2'                  : {'type':'', 'attr':'id'},
    'evaluation_typ_3'                  : {'type':'', 'attr':'id'},
    'evaluation_typ_4'                  : {'type':'', 'attr':'id'},
    'interview_use_typ'                 : {'type':'', 'attr':'id'},
    'feedback_use_typ'                  : {'type':'', 'attr':'id'},
    'rank_change_1'                     : {'type':'', 'attr':'id'},
    'rater_interview_use_typ'            : {'type':'', 'attr':'id'},
    'adjustpoint_input_1'               : {'type':'', 'attr':'id'},
    'adjustpoint_from_1'                : {'type':'text', 'attr':'id'},
    'adjustpoint_to_1'                  : {'type':'text', 'attr':'id'},
    'rank_change_2'                     : {'type':'', 'attr':'id'},
    'adjustpoint_input_2'               : {'type':'', 'attr':'id'},
    'adjustpoint_from_2'                : {'type':'text', 'attr':'id'},
    'adjustpoint_to_2'                  : {'type':'text', 'attr':'id'},
    'rank_change_3'                     : {'type':'', 'attr':'id'},
    'adjustpoint_input_3'               : {'type':'', 'attr':'id'},
    'adjustpoint_from_3'                : {'type':'text', 'attr':'id'},
    'adjustpoint_to_3'                  : {'type':'text', 'attr':'id'},
    'rank_change_4'                     : {'type':'', 'attr':'id'},
    'adjustpoint_input_4'               : {'type':'', 'attr':'id'},
    'adjustpoint_from_4'                : {'type':'text', 'attr':'id'},
    'adjustpoint_to_4'                  : {'type':'text', 'attr':'id'},
    'table_m0101'                       : {'attr' : 'list', 'item' : {
                                            'detail_no'         : {'type' : 'text', 'attr' : 'id'},
                                            'period_nm'         : {'type' : 'text', 'attr' : 'id'},
                                            'period_from_full'  : {'type' : 'text', 'attr' : 'id'},
                                            'period_to_full'    : {'type' : 'text', 'attr' : 'id'},
                                        }},
    'table_m0102'                       : {'attr' : 'list', 'item' : {
                                            'detail_no'         : {'type' : 'text', 'attr' : 'id'},
                                            'input_treatment_applications_nm'         : {'type' : 'text', 'attr' : 'id'},
                                        }},
}
$(function(){
  try{
    initialize();
    initEvents();
  }catch(e){
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
    try{
        new AutoNumeric.multiple(
            ['.numericX1', '.numericX2', '.numericX3', '.numericX4', '.numericX5', '.numericX6', '.numericX7', '.numericX8'],
            {
                styleRules: AutoNumeric.options.styleRules.positiveNegative,
                minimumValue: -100,
                maximumValue: 100
            }
        );
        $.formatInput('div.content');
    } catch(e){
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
    $(document).on('blur','.adjustpoint_to,.adjustpoint_from',function () {
        try{
            var adjustpoint = $(this).val()*1;
            if(adjustpoint > 100 ||adjustpoint < -100){
                $(this).val('');
                $(this).focus();
            }
        }catch(e){
            alert('adjustpoint: ' + e.message);
        }
    });
    $(document).on('click','#adjustpoint_input_1',function () {
        if(!$(this).hasClass('active')){
            $(this).addClass('active');
            $(this).attr('value',1);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeAttr('readonly');
            $('#adjustpoint_from_1,#adjustpoint_to_1').addClass('required');
            $('#adjustpoint_from_1').attr('tabindex','1');
            $('#adjustpoint_to_1').attr('tabindex','1');
            $('#adjustpoint_from_1').focus();
        }else{
            $(this).removeClass('active');
            $(this).attr('value',0);
            $('#adjustpoint_from_1,#adjustpoint_to_1').attr('readonly',true);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('required');
            $('#adjustpoint_from_1').attr('tabindex','-1');
            $('#adjustpoint_to_1').attr('tabindex','-1');
        }
         $('#adjustpoint_from_1,#adjustpoint_to_1').next('.textbox-error').remove();
         $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_1');
        $.formatInput('#adjustpoint_to_1');
    });
    $(document).on('click','#adjustpoint_input_2',function () {
        if(!$(this).hasClass('active')){
            $(this).addClass('active');
            $(this).attr('value',1);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeAttr('readonly');
            $('#adjustpoint_from_2,#adjustpoint_to_2').addClass('required');
            $('#adjustpoint_from_2').attr('tabindex','1');
            $('#adjustpoint_to_2').attr('tabindex','1');
            $('#adjustpoint_from_2').focus();
        }else{
            $(this).removeClass('active');
            $(this).attr('value',0);
            $('#adjustpoint_from_2,#adjustpoint_to_2').attr('readonly',true);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('required');
            $('#adjustpoint_from_2').attr('tabindex','-1');
            $('#adjustpoint_to_2').attr('tabindex','-1');
        }
        $('#adjustpoint_from_2,#adjustpoint_to_2').next('.textbox-error').remove();
        $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_2');
        $.formatInput('#adjustpoint_to_2');

    });
    $(document).on('click','#adjustpoint_input_3',function () {
        if(!$(this).hasClass('active')){
            $(this).addClass('active');
            $(this).attr('value',1);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeAttr('readonly');
            $('#adjustpoint_from_3,#adjustpoint_to_3').addClass('required');
            $('#adjustpoint_from_3').attr('tabindex','1');
            $('#adjustpoint_to_3').attr('tabindex','1');
            $('#adjustpoint_from_3').focus();
        }else{
            $(this).removeClass('active');
            $(this).attr('value',0);
            $('#adjustpoint_from_3,#adjustpoint_to_3').attr('readonly',true);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('required');
            $('#adjustpoint_from_3').attr('tabindex','-1');
            $('#adjustpoint_to_3').attr('tabindex','-1');
        }
        $('#adjustpoint_from_3,#adjustpoint_to_3').next('.textbox-error').remove();
        $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_3');
        $.formatInput('#adjustpoint_to_3');

    });
    $(document).on('click','#adjustpoint_input_4',function () {
        if(!$(this).hasClass('active')){
            $(this).addClass('active');
            $(this).attr('value',1);
            $('#adjustpoint_from_4,#adjustpoint_to_4').removeAttr('readonly');
            $('#adjustpoint_from_4,#adjustpoint_to_4').addClass('required');
            $('#adjustpoint_from_4').attr('tabindex','1');
            $('#adjustpoint_to_4').attr('tabindex','1');
            $('#adjustpoint_from_4').focus();
        }else{
            $(this).removeClass('active');
            $(this).attr('value',0);
            $('#adjustpoint_from_4,#adjustpoint_to_4').attr('readonly',true);
            $('#adjustpoint_from_4,#adjustpoint_to_4').removeClass('required');
            $('#adjustpoint_from_4').attr('tabindex','-1');
            $('#adjustpoint_to_4').attr('tabindex','-1');
        }
        $('#adjustpoint_from_4,#adjustpoint_to_4').next('.textbox-error').remove();
        $('#adjustpoint_from_4,#adjustpoint_to_4').removeClass('boder-error');
        $.formatInput('#adjustpoint_from_4');
        $.formatInput('#adjustpoint_to_4');

    });
     //btn-add-row
    $(document).on('change','.period_nm',function () {
        try{
            var period_nm   =   $(this).val();
            var _mmdd       =   $(this).closest('tr').find('.mmdd');
            if(period_nm !=''){
                _mmdd.addClass('required');
                jQuery.formatInput();
            }else{
                _mmdd.removeClass('required');
            }
            _clearErrors(1);
        } catch(e){
            alert('period_nm: ' + e.message);
        }
    });
    //btn-add-row
    $(document).on('click','#btn-add-new-1',function () {
        try{
            var html = $('#table-target-1').find('tbody').html();
            // var row = $("#table-target-1 tbody tr:first").clone();
            $('#table-data-1 tbody').append(html);
            $('#table-data-1 tbody tr:last').addClass('table_m0101');
            jQuery.formatInput();
            $('#table-data-1 tbody tr:last td:first-child span .period_nm').focus();
        } catch(e){
            alert('btn-add-new-1: ' + e.message);
        }
    });
    //btn-add-row
    $(document).on('click','.btn-remove-row',function () {
        try{
            $(this).parents('tr').remove();
        } catch(e){
            alert('btn-remove-row: ' + e.message);
        }
    });
    $(document).on('click','#btn-add-but-text',function () {
        var hidden = $('#group-but-text').is(':hidden');
        if (hidden) $('#group-but-text').toggle();
        $('input[name=textAdd]').focus();
        $('#group-but-text').attr('detail_no', 0);
        $('input[name=textAdd]').val('');
    });
    $('input[name=textAdd]').keypress(function(event){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        //
        var detail_no = $('#group-but-text').attr('detail_no');
        if (detail_no !== '0' && keycode == '13') {
            var parent = $('a.table_m0102.'+detail_no);
            var textAdd=$('#textAdd').val();
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

        if(keycode == '13'){
            var textn=$('input[name=textAdd]').val();
            if (textn.trim()!='') {
                $('input[name=textAdd]').val('');
                $('.group-add-but').append(' <span class="bl102"><a href="javascript:;" class="btn btn-primary circle mt-10 table_m0102 0 zero">'+
                    '<input type="hidden" class="detail_no" value=0>'
                    +'<input type="hidden" class="input_treatment_applications_nm" value='+textn+'><span>'+textn+'</span> <i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> ');
                //
                $('#group-but-text').attr('detail_no', 0);
            }

        }
    });
    $(document).on('blur','input[name=textAdd]',function () {
        var detail_no = $('#group-but-text').attr('detail_no');
        if (detail_no !== '0') {
            var parent = $('a.table_m0102.'+detail_no);
            var textAdd=$('#textAdd').val();
            if (textAdd.trim() != '') {
                parent.find('.input_treatment_applications_nm').val(textAdd);
                parent.find('.nm').empty().html(textAdd);
            }
            return false;
        }
        //

        var textn=$('input[name=textAdd]').val();
        if (textn.trim()!='') {
            $('input[name=textAdd]').val('');
            $('.group-add-but').append(' <span class="bl102"><a href="javascript:;" class="btn btn-primary circle mt-10 table_m0102 0 zero">'+
                '<input type="hidden" class="detail_no" value=0>'
                +'<input type="hidden" class="input_treatment_applications_nm" value='+textn+'><span>'+textn+'</span> <i class="fa fa-times mr0" aria-hidden="true" tabindex="4" style="opacity: 0;"></i></a><i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span>');
            //
            $('#group-but-text').attr('detail_no', 0);
        }
    });
    $(document).on('click','.btn-remove-but',function () {
        $(this).parent().remove();
        //
        var detail_no = $(this).siblings('a').find('.detail_no')
        $('input[name=textAdd]').val('');
        $('#group-but-text').attr('detail_no', 0).removeClass(detail_no);
        $('#group-but-text').toggle();
    });
    $(document).on('click','.table_m0102',function () {
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
    $(document).on('click','.target_typ',function () {
        var _this       = $(this);
        var target_typ  = _this.attr('target_typ');
        switch(target_typ) {
            case '1':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#target_self_assessment_typ').removeClass('disabled');
                    // $('#target_evaluation_typ_1').removeClass('disabled');
                    $('#target_evaluation_typ_1').addClass('active');
                    $('#target_evaluation_typ_1').attr('value',1);
                    $('#target_evaluation_typ_2,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.target_typ').each(function(){
                        if($(this).attr('target_typ') !='1'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
            break;
            case '2':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    // $('#target_evaluation_typ_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    // $('.target_typ').each(function(){
                    //     if($(this).attr('target_typ') !='1' && $(this).attr('target_typ') !='2'){
                    //         $(this).attr('value',0);
                    //         $(this).addClass('disabled');
                    //         $(this).removeClass('active');
                    //     }
                    // });
                }
            break;
            case '3':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#target_evaluation_typ_2,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.target_typ').each(function(){
                        if($(this).attr('target_typ') !='1' && $(this).attr('target_typ') !='2' && $(this).attr('target_typ') !='3'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
            break;
            case '4':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#target_evaluation_typ_3,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.target_typ').each(function(){
                        if($(this).attr('target_typ') =='5' || $(this).attr('target_typ') =='6'){
                             $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if(!$('#evaluation_typ_2').hasClass('active')){
                        $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
                    }
                }
            break;
            case '5':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#target_evaluation_typ_4,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.target_typ').each(function(){
                        if($(this).attr('target_typ') =='6'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if(!$('#evaluation_typ_3').hasClass('active')){
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
            break;
            case '6':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    if(!$('#evaluation_typ_4').hasClass('active')){
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
    $(document).on('click','.evaluation_typ',function () {
        var _this           = $(this);
        var evaluation_typ  = _this.attr('evaluation_typ');
        switch(evaluation_typ) {
            case '1':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#evaluation_self_assessment_typ').removeClass('disabled');
                    // $('#evaluation_typ_1').removeClass('disabled');
                    $('#evaluation_typ_1').addClass('active');
                    $('#evaluation_typ_1').attr('value',1);
                    $('#evaluation_typ_2,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.evaluation_typ').each(function(){
                        if($(this).attr('evaluation_typ') !='1'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                }
            break;
            case '2':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    // $('#evaluation_typ_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    // $('.evaluation_typ').each(function(){
                    //     if($(this).attr('evaluation_typ') !='1' && $(this).attr('evaluation_typ') !='2'){
                    //         $(this).attr('value',0);
                    //         $(this).addClass('disabled');
                    //         $(this).removeClass('active');
                    //     }
                    // });
                }
            break;
            case '3':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#evaluation_typ_2,#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.evaluation_typ').each(function(){
                        if($(this).attr('evaluation_typ') !='1' && $(this).attr('evaluation_typ') !='2' && $(this).attr('evaluation_typ') !='3'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if(!$('#target_evaluation_typ_1').hasClass('active')){
                        $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
                    }
                }
            break;
            case '4':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#evaluation_typ_3,#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.evaluation_typ').each(function(){
                        if($(this).attr('evaluation_typ') =='5' || $(this).attr('evaluation_typ') =='6'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if(!$('#target_evaluation_typ_2').hasClass('active')){
                        $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
                    }
                }
            break;
            case '5':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#evaluation_typ_4,#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    $('.evaluation_typ').each(function(){
                        if($(this).attr('evaluation_typ') =='6'){
                            $(this).attr('value',0);
                            $(this).addClass('disabled');
                            $(this).removeClass('active');
                        }
                    });
                    if(!$('#target_evaluation_typ_3').hasClass('active')){
                        $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
                    }
                }
            break;
            case '6':
                if(!_this.hasClass('active')){
                    _this.addClass('active');
                    _this.attr('value',1);
                    $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
                }else{
                    _this.removeClass('active');
                    _this.attr('value',0);
                    if(!$('#target_evaluation_typ_4').hasClass('active')){
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
    $(document).on('click','#feedback_use_typ',function () {
        var _this = $(this);
        _this.toggleClass('active');
        if(_this.hasClass('active')){
            _this.attr('value',1);
        }else{
            _this.attr('value',0);
        }
    });
    //add by vietdt cr 2022/03/10
    $(document).on('click','#interview_use_typ',function () {
        var _this = $(this);
        _this.toggleClass('active');
        if(_this.hasClass('active')){
            _this.attr('value',1);
            $("#rater_interview_use_typ").removeClass('disabled');
        }else{
            _this.attr('value',0);
            $("#rater_interview_use_typ").attr('value',0).removeClass('active').addClass('disabled');
        }
    });
    $(document).on('click','.rank_change',function () {
        var _this = $(this);
        _this.toggleClass('active');
        if(_this.hasClass('active')){
            _this.attr('value',1);
        }else{
            _this.attr('value',0);
        }
    });
    $(document).on('click', '#btn-back', function(e) {
        try{
            jMessage(71, function(r) {
                if(r){
                    if(_validateDomain(window.location)){
                        window.location.href = '/dashboard';
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
        jMessage(86, function(r) {
            if ( r && _validateM0100($('body')) ) {
                saveData();
            }
        });
    });
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
 function  _validateM0100(element) {
    if (!element) {
        element = $('body');
    }
    var error = 0;
    try {
        _clearErrors(1);
        // validate required
        element.find('.required:enabled').each(function() {
            //biennv 2016/01/14 fix required in tab
            if ($(this).is(':visible') || typeof $(this).parents('.w-result-tabs').html() != 'undefined') {
                if ($(this).is(".mmdd") && $.trim($(this).val()) == '') {
                    $(this).errorStyle(_text[15].message,1);
                    error++;
                }
                if (($(this).is(".adjustpoint_from") || $(this).is(".adjustpoint_to")) && $.trim($(this).val()) == '') {
                    $(this).errorStyle(_text[8].message,1);
                    error++;
                }
                if (($(this).is(".adjustpoint_from")) && $.trim($(this).val()) != '' && $(this).closest('tr').find('.adjustpoint_to').val()!='') {
                    var tr                  =   $(this).closest('tr');
                    var adjustpoint_from    =   tr.find('.adjustpoint_from');
                    var adjustpoint_to      =   tr.find('.adjustpoint_to');
                    if( adjustpoint_from.val()*1 >= adjustpoint_to.val()*1){
                        adjustpoint_from.errorStyle(_text[9].message,1);
                        adjustpoint_to.errorStyle(_text[9].message,1);
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
        if($('#target_evaluation_typ_1').hasClass('active') || $('#evaluation_typ_1').hasClass('active')){
            $('#rank_change_1,#adjustpoint_input_1').removeClass('disabled');
            // $('#adjustpoint_from_1,#adjustpoint_to_1').removeAttr('readonly');
            // $('#adjustpoint_from_1,#adjustpoint_to_1').addClass('required');
        }else{
            $('#rank_change_1,#adjustpoint_input_1').addClass('disabled');
            $('#rank_change_1,#adjustpoint_input_1').removeClass('active');
            $('#rank_change_1,#adjustpoint_input_1').attr('value',0);
            $('#adjustpoint_from_1,#adjustpoint_to_1').attr('readonly',true);
            $('#adjustpoint_from_1,#adjustpoint_to_1').removeClass('required');
            $('#adjustpoint_from_1,#adjustpoint_to_1').val('');
        }
        if($('#target_evaluation_typ_2').hasClass('active') || $('#evaluation_typ_2').hasClass('active')){
            $('#rank_change_2,#adjustpoint_input_2').removeClass('disabled');
            // $('#adjustpoint_from_2,#adjustpoint_to_2').removeAttr('readonly');
            // $('#adjustpoint_from_2,#adjustpoint_to_2').addClass('required');
        }else{
            $('#rank_change_2,#adjustpoint_input_2').addClass('disabled');
            $('#rank_change_2,#adjustpoint_input_2').removeClass('active');
            $('#rank_change_2,#adjustpoint_input_2').attr('value',0);
            $('#adjustpoint_from_2,#adjustpoint_to_2').attr('readonly',true);
            $('#adjustpoint_from_2,#adjustpoint_to_2').removeClass('required');
            $('#adjustpoint_from_2,#adjustpoint_to_2').val('');
        }
        if($('#target_evaluation_typ_3').hasClass('active') || $('#evaluation_typ_3').hasClass('active')){
            $('#rank_change_3,#adjustpoint_input_3').removeClass('disabled');
            // $('#adjustpoint_from_3,#adjustpoint_to_3').removeAttr('readonly');
            // $('#adjustpoint_from_3,#adjustpoint_to_3').addClass('required');
        }else{
            $('#rank_change_3,#adjustpoint_input_3').addClass('disabled');
            $('#rank_change_3,#adjustpoint_input_3').removeClass('active');
            $('#rank_change_3,#adjustpoint_input_3').attr('value',0);
            $('#adjustpoint_from_3,#adjustpoint_to_3').attr('readonly',true);
            $('#adjustpoint_from_3,#adjustpoint_to_3').removeClass('required');
            $('#adjustpoint_from_3,#adjustpoint_to_3').val('');
        }
        if($('#target_evaluation_typ_4').hasClass('active') || $('#evaluation_typ_4').hasClass('active')){
            $('#rank_change_4,#adjustpoint_input_4').removeClass('disabled');
            // $('#adjustpoint_from_4,#adjustpoint_to_4').removeAttr('readonly');
            // $('#adjustpoint_from_4,#adjustpoint_to_4').addClass('required');
        }else{
            $('#rank_change_4,#adjustpoint_input_4').addClass('disabled');
            $('#rank_change_4,#adjustpoint_input_4').removeClass('active');
            $('#rank_change_4,#adjustpoint_input_4').attr('value',0);
            $('#adjustpoint_from_4,#adjustpoint_to_4').attr('readonly',true);
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
        var data    = getData(_obj);
        // send data to post
        $.ajax({
            type        :   'POST',
            url         :   '/master/m0100/save',
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