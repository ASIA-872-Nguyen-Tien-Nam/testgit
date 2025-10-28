/**
 * ****************************************************************************
 * ANS ASIA
 * MIRAI COMMON.JS
 *
 * 処理概要		:	mirai common.js
 * 作成日		:	2018/07/10
 * 作成者		:	viettd – viettd@ans-asia.com
 *
 * @package		:	MODULE NAME
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
document.addEventListener('keydown', function (e) {
	if($('.anti_tab').length > 0){
		if (e.keyCode  === 9) {
			if (e.shiftKey) {
	               if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
	                    e.preventDefault();
	                     if($('.nav-menubar-pc a:not([readonly],[disabled],:hidden)').last().length!=0){
	                    	$('.nav-menubar-pc a:not([readonly],[disabled],:hidden)').last()[0].focus();
	                    }
	                    return;
	                }
	                var max = -1;
	                $(":input:not([readonly],[disabled],:hidden)[tabindex]").attr('tabindex', function (a, b) {
	                    max = Math.max(max, +b);
	                });
	                if ($(':focus')[0] === $('.nav-menubar-pc a:not(.disabled,.no-focus,.disable,:hidden)').first()[0]) {
	                    e.preventDefault();
	                    $(":input:not([readonly],[disabled],:hidden)[tabindex="+max+"]").focus();
	                }
	            }else{
                    var list_button   = $('.nav-menubar-pc a:not(.disabled,.no-focus,.disable,:hidden)');
                    console.log($(':focus')[0]);
					if (list_button.length == 0 && $(':focus')[0] === $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled,[tabindex="-1"])').last()[0]) {
						e.preventDefault();
						$(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled,[tabindex="-1"])').first().focus();
                    }
                    if(list_button.length > 0 && $(':focus')[0] === $('.nav-menubar-pc a:not(.disabled,.no-focus,.disable,:hidden)').last()[0]){
                        e.preventDefault();
						$(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled,[tabindex="-1"])').first().focus();
                    }
	            }
	        }
	}
});