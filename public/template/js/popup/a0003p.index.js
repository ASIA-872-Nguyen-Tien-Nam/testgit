/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	viettd – viettd@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */

$(function(){
  try{
    initEvents();
    initialize();
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
    try{
        $(document).on('dblclick', '.pop_tr', function(e) {
            let api_office_cd = $(this).find('#office_cd').text();
            let api_office_nm = $(this).find('#office_nm').text();
			jConfirm('確認','選択した事業所は「'+api_office_nm +'」でよろしいですか？',function(e){
				if(e){
					parent.$('.main').find('#api_office_cd').val(api_office_cd.trim());
					parent.$('.main').find('#api_office_nm').val(api_office_nm.trim());
					writeFileConfig(api_office_cd);
            		$('#btn-close-popup').click();
				}
			});

        })

  	}catch(e){
		alert('initialize: ' + e.message);
	}

}
function writeFileConfig(api_office_cd){
	let data = {
		'api_office_cd':api_office_cd
	}
	$.ajax({
		type        :   'POST',
		url         :   '/basicsetting/a0003/writeconfig',
		// dataType    :   'json',
		loading     :   false,
		data        :   data,
		success: function(res) {
		},
		error:function(xhr){
			console.log(xhr);
		}
   });
}