/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		:	2018/09/17
 * 作成者		:	viettd – viettd@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	:	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
'function_list'					: {'attr' : 'list', 'item' : {
		'category'					: {'type' : 'text' 		, 'attr' : 'class'}
	,	'status_cd'					: {'type' : 'text' 		, 'attr' : 'class'}
	,	'status_nm'					: {'type' : 'text' 		, 'attr' : 'class'}
	,	'status_use_typ'			: {'type' : 'select' 	, 'attr' : 'class'}	
		}
	}
};
//
$( document ).ready(function() {
	try{
		initialize();
		initEvents();
	}
	catch(e){ 
		alert('ready' + e.message);
	}
});
/**
 * initialize
 * 
 * @author		:	viettd - 2018/09/17 - create
 * @author		:	
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */ 
function initialize(){
	
}
/**
 * initEvents
 * 
 * @author		:	viettd - 2018/09/17 - create
 * @author		:	
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */ 
function initEvents(){
	try{
		// btn-save button click
		$(document).on('click','#btn-save',function(e){
			try {
				e.preventDefault();
				jMessage(1,function(r){
					if(r){
						save();
					}
				});
			} catch (e) {
				alert('#btn-save event:' + e.message);
			}
		});
		// btn-back button click
		$(document).on('click','#btn-back',function(e){
			try {
				e.preventDefault();
				// window.location.href = '/dashboard';
				if(_validateDomain(window.location)){
	                window.location.href = '/dashboard';
	            }else{
	                jError('エラー','このプロトコル又はホストドメインは拒否されました。');
	            }
			} catch (e) {
				alert('#btn-back event:' + e.message);
			}
		});
	}catch(e){
		alert('initEvents:'+ e.message);
	}
}
/**
 * save
 * 
 * @author		:	viettd - 2018/09/17 - create
 * @author		:	
 * @return		:	null
 * @access		:	public
 * @see			:	
 */
function save() {
	try {
		var data 	= getData(_obj);
		var function_list = data.data_sql.function_list.map(item => {
			item.status_nm = item.status_nm.replace(/\t/g, '');
			return item;
		});
		data.data_sql.function_list = function_list;
		// send data to post
		$.ajax({
			type		:	'POST',
    		url			:	'/master/m0190/save', 
    		dataType	:	'json',
    		data		:	JSON.stringify(data),
		 success: function(res) {
			switch (res['status']){
				// seccess
				case OK:
					jMessage(2,function(){
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