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
	'fiscal_year'			       	: {'type':'text', 'attr':'id'},
	'period_cd'			       		: {'type':'text', 'attr':'id'},
	'period_from'			       	: {'type':'text', 'attr':'id'},
	'period_to'			       		: {'type':'text', 'attr':'id'},
	'list'									:	{'attr':'list',		'item':{
 		'category'					:   {'type':'text',		'attr':'class'},
 		'status_cd'					:   {'type':'text',		'attr':'class'},
 		'start_date'				:   {'type':'text',	'attr':'class'},
 		'deadline_date'				:   {'type':'text',	'attr':'class'},
 		'notice_information'		:   {'type':'select',	'attr':'class'},
 		'alert_information'			:   {'type':'select',	'attr':'class'},
 	}},
};

 $(function(){
	initEvents();
	initialize();
	//calcTable();
});

/**
 * initialize
 *
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
 function initialize() {
	try{
		$('#fiscal_year').focus();
	} catch(e){
		alert('initialize: ' + e.message);
	}
 }
/*
 * INIT EVENTS
 * @author		:	datnt - 2018/06/21 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
 function initEvents() {
	$(document).on('click', '#btn-save', function(e) {
		jMessage(1,function(r){
			if(r){
				save();
			}
		});
	});
	$(document).on('change', '#fiscal_year', function(e) {
		if($('#btn-copy').attr('copy_mode') != 1){
			refer();
		}else{
			var old_fiscal_year = $('#btn-copy').attr('fiscal_year');
			referCopy();
			changeDate($(this).val(),old_fiscal_year);
		}
	});
	$(document).on('change', '#period_cd', function(e) {
		if($('#btn-copy').attr('copy_mode') != 1){
			refer();
		}else{
			referCopy();
		}
	});
    $(document).on('click', '#btn-back', function(){
        if(_validateDomain(window.location)){
    		window.location.href = '/dashboard';
    	}else{
    		jError('エラー','このプロトコル又はホストドメインは拒否されました。');
    	}
    });
    $(document).on('click','.screen_i1041',function(e) {
    	e.preventDefault();
	    var tr = $(this).parents('tr');
	    var obj = {};
	        obj.fiscal_year	= $('#fiscal_year').val();
	        obj.period_cd	= $('#period_cd').val();
	        obj.category	= tr.find('.category').val();
	        obj.status_cd	= tr.find('.status_cd').val();
	        obj.screen_id	= 'i1040';
	        setCache(obj, '/master/i1041');
	});
    $(document).on('click','#btn-copy',function(e) {
	    e.preventDefault();
	    var fiscal_year =  $('#fiscal_year').val();
	    // $('.inner').find('input:not(:checkbox):not(.code)').val('');
	    var period_from = $('#period_from').val();
	    var period_to = $('#period_to').val();
	    $('#btn-copy').attr('copy_mode','1');
	    $('#btn-copy').attr('fiscal_year',fiscal_year);
	    $('.inner').addClass('has-copy');
	    $('#period_cd').val('');
	    $('#fiscal_year').val('');
	    $('#lb-period input').val('');
	    // $('#lb-period').attr('period_from',period_from);
	    // $('#lb-period').attr('period_to',period_to);
	    // $(this).closest('li').addClass('active');
	    $('.indexTab:first').focus();
	})
 }
/**
 * refer
 * 
 * @author      :   datnt - 2018/08/28 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function refer() {
	try {
		var fiscal_year = $('#fiscal_year').val();
		var period_cd 	= $('#period_cd').val();
		// send data to post
		$.ajax({
			type        :   'post',
			url         :   '/master/i1040/refer', 
			dataType    :   'html',
			loading     :   true,
			data        :   {fiscal_year: fiscal_year,period_cd:period_cd},
			success: function(res) {
				// active_left_menu();
				// app.jTableFixedHeader();
				 
				$('#body').empty();
				$('#body').append(res);
				$.formatInput();
			}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
 }
}

/**
 * refer
 * 
 * @author      :   datnt - 2018/08/28 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function referCopy() {
	try {
		var fiscal_year = $('#fiscal_year').val();
		var period_cd 	= $('#period_cd').val();
		// send data to post
		$.ajax({
			type        :   'post',
			url         :   '/master/i1040/refercopy', 
			loading     :   true,
			data        :   {fiscal_year: fiscal_year,period_cd:period_cd},
			success: function(res) {
				$('#lb-period .text-center').val(res['result']['period_year']);
				$('#period_from').val(res['result']['period_from']);
	    		$('#period_to').val(res['result']['period_to']);
	    	}
		});
	} catch (e) {
		alert('get left content: ' + e.message);
 }
}

/**
 * saveData
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function save(){
 	var data = getData(_obj);
 	$.ajax({
 		type : 'post',
 		data: JSON.stringify(data),
 		url: '/master/i1040/save',
 		loading: true,
 		success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
                    	// $('.inner').removeClass('has-copy');
                    	$('input,select').val('');
                    	$('#btn-copy').removeAttr('copy_mode');
                    	$('.inner').removeClass('has-copy');
                    	// location.reload();
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

function active_left_menu(){
	var organization_cd  =   $('#organization_cd').val();
	$('.list-search-child').removeClass('active');
	$('.list-search-child').each(function(){
		_this = $(this);
		if(_this.attr('id') == organization_cd){
			_this.addClass('active');
		}
	})
}

function changeDate(fiscal_year,old_fiscal_year){
	var start_plus_year = 0;
	var deadline_plus_year = 0;
	var start_year = 0;
	var deadline_year = 0;
	var new_year ='';
	$('.list').each(function(){
		start_date		=	$(this).find('.start_date').val();
		if(start_date !=''){
			start_plus_year		= 	fiscal_year - old_fiscal_year;
			start_year			=	parseInt(start_date.slice(0,4),10)+parseInt(start_plus_year,10);
			start_year 			=	start_year+start_date.slice(4,10)
			if(start_year != undefined && start_year != ''){
				start_year	=	start_year.replace(/-/g, "/");
			}
			$(this).find('.start_date').val(start_year);
			
			$(this).find('.start_date').trigger('blur');
		}
		deadline_date	=	$(this).find('.deadline_date').val();
		if(deadline_date !=''){
			if(start_plus_year !=0){
				deadline_plus_year		= 	start_plus_year;
			}else{
				deadline_plus_year		= 	fiscal_year - old_fiscal_year ;
			}
			deadline_year			=	parseInt(deadline_date.slice(0,4),10)+parseInt(deadline_plus_year,10);
			deadline_year 			=	deadline_year+deadline_date.slice(4,10);
			if(deadline_year != undefined && deadline_year != ''){
				deadline_year	=	deadline_year.replace(/-/g, "/");
			}
			$(this).find('.deadline_date').val(deadline_year);
			$(this).find('.deadline_date').trigger('blur');
		}
	});
}