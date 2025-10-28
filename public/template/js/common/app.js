/**
 * ****************************************************************************
 * ANS ASIA
 * COMMON.JS
 * 
 * 処理概要		:	unite_mdecial app.js
 * 作成日		:	2017/07/27
 * 作成者		:	tannq – tannq@ans-asia.com
 *  
 * @package		:	MODULE NAME
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */

var app = function() {
	return {
		initFormMaxLength:function() {
			$(document).on('keyup','.form-control',function(e) {
				intNumLength($(this),e);
			});
			
			$(document).on('blur','.form-control',function(e) { 
				var gr = $(this).closest('.num-length');
				var lg = $(this).attr('maxlength');
				gr.find('span.lg').remove();
			});

			$(document).on('focus','.form-control',function(e) { 
				intNumLength($(this),e);
			});
			function intNumLength(el,events) {
				if(!el.is(':input') || el.is('select')) return;
				var gr = el.closest('.num-length');
				
				var lg 					= el.attr('maxlength');
				var message_len 		= el.attr('message_length');
				var inputWithoutDots = 0;
				var constant_maxlength 	= el.attr('constant_maxlength');
				var cnt 				= el.val().length;
				if(el.next('.textbox-error') && typeof events.keyCode !='undefined' && events.keyCode != '9' && events.keyCode != '13'){// keycode Tab, Enter
					el.next('.textbox-error').remove();
				}
				if(cnt==0 && lg > constant_maxlength){
					 el.attr('maxlength',constant_maxlength);
				}
				if(gr.length > 0 && lg) {
					if(gr.find('span.lg').length == 0) {
						if(el.is('.numeric')) {
							cnt 				= el.val().replace(/,/g, "")
							inputWithoutDots = el.val().replace(/\./g, '').length;
							cnt 				= cnt.length
							if(el[0].classList.contains('number_item_blade') == true) {
								lg = lg-1
								cnt = inputWithoutDots
								gr.append('<span class="lg"  style="width:100%">'+message_len+'</span>');
							}  else {
								gr.append('<span class="lg">'+cnt+'/'+lg+'</span>');
							}
						} else{
							if(el[0].classList.contains('number_item_blade') == true) {
								inputWithoutDots = el.val().replace(/\./g, '').length;
								lg = lg-1
								cnt = inputWithoutDots
								gr.append('<span class="lg"  style="width:100%">'+message_len+'</span>');
							} else {
								gr.append('<span class="lg" >'+cnt+'/'+lg+'</span>');}
							}
						
					} else {
						if(el[0].classList.contains('number_item_blade') == true) {
							inputWithoutDots = el.val().replace(/\./g, '').length;
							lg = lg-1
							cnt = inputWithoutDots
							gr.append('<span class="lg" style="width:100%">'+message_len+'</span>');
						} else {
							gr.find('span.lg').html(cnt+'/'+lg);
						}
					}
					if(cnt >= lg) {
						gr.find('span.lg').addClass('max');
					} else {
						gr.find('span.lg').removeClass('max');
					}
					// var grh  = gr.outerHeight(true);
					// var h    = el.outerHeight(true);
					// gr.find('span.lg').removeAttr('style');
					// gr.find('span.lg').css({bottom:(grh - h - 16)+'px'});
				}
			}
		},
		navbarAct:function() {
			var nav = $('.navbar-act');
			if(nav.length > 0) {
				var sticky  = nav.offset().top;
				window.onscroll = function() {navbarSet()};
				navbarSet();
				function navbarSet() {
					if (window.pageYOffset >= sticky) {
					    nav.addClass("sticky");
				  	} else {
				  		if(nav.find('.sticky').length > 0) {
				  			nav.removeClass("sticky");
				  		}
				  	}
				}
			}
		},

		paginateMockup:function() {
			var pagerContainer = '.page-item';
			$(document).on('click',pagerContainer,function(e) {
				e.preventDefault();
				var wrap 			  = $(this).closest('.pager-wrap'),
					currentTarget     = wrap.find('.page-item.active'),
					currentTargetPrev = currentTarget.prev(),
					currentTargetNext = currentTarget.next(),
					firstTarget    	  = wrap.find('.page-item.page-prev').next(),
					lastTarget  	  = wrap.find('.page-item.page-next').prev();
					wrap.find('.page-item').removeClass('active').removeAttr('disabled');

				if($(this).hasClass('page-prev') || $(this).hasClass('page-first')) {
					if(currentTargetPrev.hasClass('page-prev') || currentTargetPrev.hasClass('page-first') || $(this).hasClass('page-first')) {
						firstTarget.addClass('active');
						wrap.find('.page-item.page-prev').attr('disabled','disabled');
						wrap.find('.page-item.page-first').attr('disabled','disabled');
					} else {
						currentTargetPrev.addClass('active');	
					}
				} else if( $(this).hasClass('page-next') || $(this).hasClass('page-last') ) {
					if(currentTargetNext.hasClass('page-next') || currentTargetNext.hasClass('page-last') || $(this).hasClass('page-last')) {
						lastTarget.addClass('active');
						wrap.find('.page-item.page-next').attr('disabled','disabled');
						wrap.find('.page-item.page-last').attr('disabled','disabled');
					} else {
						currentTargetNext.addClass('active');
					}
				} else {
 					$(this).addClass('active');
				}
				
			});
		},
		/**
		 * @return 
		 */
		initEvents:function() {
			// File browser
			$(document).on('click','#file-browser',function(e){
				e.preventDefault();
				$(this).closest('.input-group-file').find('input[type=file]').trigger('click');
			});
			$(document).on('change','[type="file"]',function(){
			    $(this).closest('.input-group-file').find('.preview').val($(this).val());
		  	});
		  	$(document).on('click','.remove-file',function(e){
		  		e.preventDefault();
		  		$(this).closest('.input-group-file').find('input').val('');
		  	});
		  	//
		},
		mockup:function() {	
			$(document).on('change','.date',function(){
				var val = $(this).val();
				if(val !='') {
					$('.date').parent().find('.btn').bootstrapMaterialDatePicker({
						currentDate:val
					});
				}
			});				
			//
			/*$('#item1').errorStyle('必須','textbox-error');*/
			// get all item from json
			var _obj = {
			// header
				'customer_no' 		: {'param':'header','type':'only-number','attr':{'validate':'required|numeric'}}
			,	'customer_nm' 		: {'param':'header','type':'text'		,'attr':{'validate':'required|numeric'}}
			,	'order_date' 		: {'param':'header','type':'text'		,'attr':{'validate':'required|numeric'}}
			,	'order_month' 		: {'param':'header','type':'date_month'	,'attr':{'validate':'required|numeric'}}
			,	'order_time' 		: {'param':'header','type':'time'		,'attr':{'validate':'required|numeric'}}
			,	'sex' 				: {'param':'header','type':'radio'		,'attr':{'name':'sex','validate':'required|numeric'}}
			,	'depart' 			: {'param':'header','type':'checkbox'	,'attr':{'validate':'required|numeric'}}
			,	'label' 			: {'param':'header','type':'label'		,'attr':{'validate':'required|numeric'}}
			,	'selectbox' 		: {'param':'header','type':'select'		,'attr':{'validate':'required|numeric'}}
			,	'textbox' 			: {'param':'header','type':'text'		,'attr':{'validate':'required|numeric'}}
			,	'numeric_item' 		: {'param':'header','type':'numeric'	,'attr':{'validate':'required|numeric'}}
			//	detail1
			,	'product_list'		: {'param':'detail','item':{
						'product_no'		: {'type': 'only-number'	,'attr':{'validate':'required|numeric'}}
					,	'product_nm'		: {'type': 'text'			,'attr':{'validate':'required|numeric'}}
					,	'product_quanity'	: {'type': 'only-number'	,'attr':{'validate':'required|numeric'}}
					,	'product_price'		: {'type': 'numeric'		,'attr':{'validate':'required|numeric'}}
					,	'product_month'		: {'type': 'date_month'		,'attr':{'validate':'required|numeric'}}
					,	'product_radio'		: {'type': 'radio'			,'attr':{'name':'product_radio','validate':'required|numeric'}}
					,	'product_checkbox'	: {'type': 'checkbox'		,'attr':{'validate':'required|numeric'}}
					,	'product_label'		: {'type': 'label'			,'attr':{'validate':'required|numeric'}}
					,	'product_select'	: {'type': 'select'			,'attr':{'validate':'required|numeric'}}
					,	'product_numeric'	: {'type': 'numeric'		,'attr':{'validate':'required|numeric'}}
				}
			}
			//	detail1
			,	'order_list'		: {'param':'detail','item':{
						'order_no'			: {'type': 'only-number'	,'attr':{'validate':'required|numeric'}}
					,	'order_nm'			: {'type': 'text'			,'attr':{'validate':'required|numeric'}}
					,	'order_quanity'		: {'type': 'only-number'	,'attr':{'validate':'required|numeric'}}
					,	'order_price'		: {'type': 'numeric'		,'attr':{'validate':'required|numeric'}}
					,	'order_month'		: {'type': 'date_month'		,'attr':{'validate':'required|numeric'}}
					,	'order_radio'		: {'type': 'radio'			,'attr':{'name':'product_radio','validate':'required|numeric'}}
					,	'order_checkbox'	: {'type': 'checkbox'		,'attr':{'validate':'required|numeric'}}
					,	'order_label'		: {'type': 'label'			,'attr':{'validate':'required|numeric'}}
					,	'order_select'		: {'type': 'select'			,'attr':{'validate':'required|numeric'}}
					,	'order_numeric'		: {'type': 'numeric'		,'attr':{'validate':'required|numeric'}}
				}
			}				
			};
			// show popup
			$(document).on('click', '.btn-popup', function() {
				try {
					if($(this).data('url') !='')
					{
						showPopup($(this).data('url'),function(){});
					}
				} catch (e) {
					alert('btn-show:' + e.message);
				}
			});		
			$(document).mouseup(function(e) {
			    var colorbox = $("#colorbox");
			    if (!colorbox.has(e.target).length && !colorbox.is(e.target)) {
			    	$.colorbox.close();
		    	} 
			});	
		},
		jSticky:function() {
			function getChromeVersion() {     
			    var raw = navigator.userAgent.match(/Chrom(e|ium)\/([0-9]+)\./);

			    return raw ? parseInt(raw[2], 10) : false;
			}
			jQuery(document).on('stickyTable', function() {
				var outline = (getChromeVersion()) ? 'unset' :'0.5px solid #ddd';

			    $(".sticky-headers").scroll(function() {
			        $(this).find("table tr.sticky-row th").css('top', $(this).scrollTop());
			        $(this).find("table tr.sticky-row td").css('top', $(this).scrollTop());
			    });
			    $(".sticky-ltr-cells").scroll(function() {
			        $(this).find("table th.sticky-cell").css('left', $(this).scrollLeft());
			        $(this).find("table td.sticky-cell").css('left', $(this).scrollLeft());

			    });
			    $(".sticky-rtl-cells").scroll(function() {
			        var maxScroll = $(this).find("table").prop("clientWidth") - $(this).prop("clientWidth");
			        $(this).find("table th.sticky-cell").css('right', maxScroll - $(this).scrollLeft());
			        $(this).find("table td.sticky-cell").css('right', maxScroll - $(this).scrollLeft());
			    });
			});
			$( document ).ready(function(){
			    $( document ).trigger( "stickyTable" );
			});
		},

		// Fixed header
		jTableFixedHeader:function() {
			scrollFix();	
			if($('.navbar-act').length > 0 && $('.fixed-top.header').length > 0 && $('.fixed-header').length > 0) {
				var hNav = $('.navbar-act').length > 0 ? $('.navbar-act').outerHeight(true) : 0;
				var hHeader = $('.fixed-top.header').length > 0 ? $('.fixed-top.header').outerHeight(true) : 0;
				var offsetTable = $('.fixed-header').offset().top;
				if((hNav+hHeader) > offsetTable) 
				{
					$('.fixed-header thead tr th').css({
						'position':'relative',
						// 'background':'rgb(39, 87, 179)',
						'outline':'.5px solid #ddd',
						'z-index':'22',
						'top':((hNav+hHeader - offsetTable))+'px',
					});
				}
			}
			function scrollFix() {
				$('.table-fixed-header, .table-fixed-header2').scroll(function(){
					if($('.fixed-header').length > 0 ) {
						var scrollTop = $(this).scrollTop();;
						if(scrollTop > 0){
							$(this).find('.fixed-header thead tr th').css({
								'position':'relative',
								// 'background':'rgb(39, 87, 179)',
								'outline':'.5px solid #ddd',
								'z-index':'22',
								'top':((scrollTop-1))+'px',
							});
						} else {
							$(this).find('.fixed-header thead tr th').css({
								'position':'relative',
								'top':(0)+'px'
							});
						}
					}
				})
			}
			// function scrollFix() {
			// 	$('.table-fixed-header, .table-fixed-header2').scroll(function(){
			// 		if($('.fixed-header').length > 0 ) {
			// 			var hNav = $('.navbar-act').length > 0 ? $('.navbar-act').outerHeight(true) : 0;
			// 			var hHeader = $('.fixed-top.header').length > 0 ? $('.fixed-top.header').outerHeight(true) : 0;
			// 			var offsetTable = $('.table-fixed-header').offset().top;
			// 			var scrollTop = $('.table-fixed-header').scrollTop();
			// 			var scrollTop2 = $('.table-fixed-header2').scrollTop();
			// 			console.log(scrollTop + ' - ' + offsetTable);
			// 			// alert(scrollTop2);//29
			// 			// alert(offsetTable);//369
			// 			// alert(hHeader + hNav);//125.7813 - 126
			// 			// alert($('body').width());//1903

			// 			// alert((offsetTable - offset) + ' '+ scrollTop);
			// 			// alert((scrollTop-(offsetTable - offset)));
			// 			if(scrollTop > (offsetTable - (hHeader + hNav) -243)) {
			// 				// if($('body').width() < 1253) {
			// 				// 	alert(1);
			// 				$('.table-fixed-header .fixed-header thead tr th').css({
			// 					'position':'relative',
			// 					// 'background':'rgb(39, 87, 179)',
			// 					'outline':'.5px solid #ddd',
			// 					'z-index':'22',
			// 					'top':((scrollTop-1))+'px',
			// 				});

			// 				// } else {
			// 				// 	alert(2);
			// 				// 	$('.fixed-header thead tr th').css({
			// 				// 		'position':'relative',
			// 				// 		// 'background':'rgb(39, 87, 179)',
			// 				// 		'outline':'.5px solid #ddd',
			// 				// 		'z-index':'22',
			// 				// 		'top':((0-offsetTable + (hHeader + hNav)) + 243)+'px',
			// 				// 	});
			// 				// }
			// 			} else {
			// 				$('.table-fixed-header .fixed-header thead tr th').css({
			// 					'position':'relative',
			// 					'top':(0)+'px'
			// 				});
			// 			}
			// 			if(scrollTop2 > 0){
			// 				$('.table-fixed-header2 .fixed-header thead tr th').css({
			// 					'position':'relative',
			// 					// 'background':'rgb(39, 87, 179)',
			// 					'outline':'.5px solid #ddd',
			// 					'z-index':'22',
			// 					'top':((scrollTop2-1))+'px',
			// 				});
			// 			} else {
			// 				$('.table-fixed-header2 .fixed-header thead tr th').css({
			// 					'position':'relative',
			// 					'top':(0)+'px'
			// 				});
			// 			}
			// 		}
			// 	})
			// }
			
		},

		//
		initPopup:function() {
			fix();
			function fix()
			{
				var container = $('body.popup-wrapper');
				if(container.length > 0)
				{
					if(container.find('nav.navbar-fixed-top ul.navbar-right li').length > 0)
					{
						container.find('> #page-container').css({'padding-top':'25px'});
					} else {
						container.find('> #page-container').css({'padding-top':'0'});
						container.find('nav.navbar-fixed-top').remove();
					}
				}
			}
			$(window).resize(function(){
				fix();
			});
		},
		jTooltip:function() {
			if($('.jtooltip').length > 0)
			{
				var jTooltip = $('.jtooltip');
				
				var height = (jTooltip.clientHeight + 1) + "px";
				var width = (jTooltip.clientWidth + 1) + "px";
				$('.jtooltip').tooltip();
			}
		}
	}
}($);
 
$(document).ready(function() {
	"use strict";
	app.initEvents();
	app.jTooltip();
	if($('table.fixed-header').length > 0) {
		app.jTableFixedHeader();
	}
	app.initFormMaxLength();
	app.navbarAct();
	//app.paginateMockup();
	app.jSticky();
	$('.today_ja').removeClass('today_ja');
		$('.today_en').removeClass('today_en');
		if($('.language').attr('value') == 'jp') {
			$('.xdsoft_today_button').addClass('today_ja');
		} else {
			$('.xdsoft_today_button').addClass('today_en');
		}

	$(document).on('click','[data-toggle="popup"]',function(e) {
		e.preventDefault();
		showPopup("/popup");
	});
	
	$(document).on('click','[data-target="helper"]',function(){
	  	$('#modal-helper').removeAttr('class').addClass('one');
	  	$('body').addClass('modal-active');
	})

	$(document).mouseup(function(e) {
	    var helper = $("#modal-helper");
	    if (!helper.has(e.target).length && !helper.is(e.target)) {
	    	helper.addClass('out');
	    	$('body').removeClass('modal-active');
    	} 
	});
	//
	$(document).on('click','#btn-mockup-new',function(e){
		e.preventDefault();
		jWarning('警告','画面を初期化します。※保存していない情報は失われます。',function(e){
		 	if(e){
		 		jSuccess('完了','新規になりました。',function(){
		 		});
		 	}
		 });
	});
	$(document).on('click','#btn-mockup-save',function(e){
		e.preventDefault();
		jConfirm('確認','登録よろしでしょうか？',function(e){
			if(e){
				jSuccess('完了','登録が完了しました。',function(){});
			}
		});
	});
	$(document).on('click','#btn-mockup-delete',function(e){
		e.preventDefault();
		jConfirm('確認','削除よろしでしょうか？',function(e){
			if(e){
				jError('エラー','エラーを発生しまいました。',function(){});
			}
		});
	});
	$(document).on('click','#btn-mockup-show',function(e){
		e.preventDefault();
		jTooltip('会議','みらいコンサルティング様',function(){});
	});
	$(document).on('click','#btn-mockup-search',function(e){
		e.preventDefault();
		$('.div_loading').show();
		setTimeout(function() {
          //your code to be executed after 1 second
          $('.div_loading').hide();
        }, 1000);
	});
	$(document).on('click','#btn-mockup-print',function(e){
		e.preventDefault();
		$('.div_loading').show();
		setTimeout(function() {
          //your code to be executed after 1 second
          $('.div_loading').hide();
        }, 1000);
	});
	//
	$('body').keyup(function(e){
		// new
		if(e.keyCode == 119){
			$('#btn-mockup-new').trigger('click');
		}else if(e.keyCode == 120){
			$('#btn-mockup-save').trigger('click');
		}else if(e.keyCode == 113){
			$('#btn-mockup-search').trigger('click');
		}else if(e.keyCode == 118){
			$('#btn-mockup-print').trigger('click');
		}else if(e.keyCode == 115){
			$('#btn-mockup-delete').trigger('click');
		}
		// save
	});
	$(document).on('click', '.date', function (event) {
		try {
			$('.today_ja').removeClass('today_ja');
	$('.today_en').removeClass('today_en');
	if($('.language').attr('value') == 'jp') {
		$('.xdsoft_today_button').addClass('today_ja');
	} else {
		$('.xdsoft_today_button').addClass('today_en');
	}
		} catch (e) {
			alert('#btn-search:' + e.message);
		}
	})
	$(document).on('click', '.input-group-append-btn', function (event) {
		try {
			$('.today_ja').removeClass('today_ja');
	$('.today_en').removeClass('today_en');
	if($('.language').attr('value') == 'jp') {
		$('.xdsoft_today_button').addClass('today_ja');
	} else {
		$('.xdsoft_today_button').addClass('today_en');
	}
		} catch (e) {
			alert('#btn-search:' + e.message);
		}
	})
	
});

