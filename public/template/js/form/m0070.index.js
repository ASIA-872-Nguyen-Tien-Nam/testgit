(function($) {
	$.fn.hasScrollBar = function() {
		return this.get(0).scrollHeight > this.height();
	}
})(jQuery);

var _obj = {
	'employee_cd'				: {'type':'text', 'attr':'id'},
	'employee_last_nm'			: {'type':'text', 'attr':'id'},
	'employee_first_nm'			: {'type':'text', 'attr':'id'},
	'employee_nm'				: {'type':'text', 'attr':'id'},
	'employee_ab_nm'			: {'type':'text', 'attr':'id'},
	'furigana'					: {'type':'text', 'attr':'id'},
	'gender'					: {'type':'radiobox', 'attr':'id'},
	'mail'						: {'type':'text', 'attr':'id'},
	'birth_date'				: {'type':'text', 'attr':'id'},
	'company_in_dt'				: {'type':'text', 'attr':'id'},
	'company_out_dt'			: {'type':'text', 'attr':'id'},
	'application_date'			: {'type':'text', 'attr':'id'},
	'user_id'					: {'type':'text', 'attr':'id'},
	'password'					: {'type':'text', 'attr':'id'},
	'sso_user'					: {'type':'text', 'attr':'id'},
	'office_cd'					: {'type':'select', 'attr':'id'},
	'organization_step1'				: {'type':'select', 'attr':'id'},
	'organization_step2'				: {'type':'select', 'attr':'id'},
	'organization_step3'				: {'type':'select', 'attr':'id'},
	'organization_step4'				: {'type':'select', 'attr':'id'},
	'organization_step5'				: {'type':'select', 'attr':'id'},
	'authority_cd'				: {'type':'select', 'attr':'id'},
	'job_cd'					: {'type':'select', 'attr':'id'},
	'position_cd'				: {'type':'select', 'attr':'id'},
	'employee_typ'				: {'type':'select', 'attr':'id'},
	'grade'						: {'type':'select', 'attr':'id'},
	'base_salary'				: {'type':'text', 'attr':'id'},
	'picture'					: {'type':'text', 'attr':'id'},
	'imgInp'					: {'type':'file', 'attr':'id'},
	// 'evaluated_typ'				: {'type':'checkbox', 'attr':'id'},
	'ck1'						: {'type':'checkbox', 'attr':'id'},
	'list'                 : {'attr' : 'list', 'item' : {
	    'application_date'  : {'type' : 'text', 'attr' : 'class'},
	    'office_cd'       	: {'type' : 'text', 'attr' : 'class'},
	    'belong_cd1'       	: {'type' : 'text', 'attr' : 'class'},
	    'belong_cd2'       	: {'type' : 'text', 'attr' : 'class'},
	    'belong_cd3'       	: {'type' : 'text', 'attr' : 'class'},
	    'belong_cd4'       	: {'type' : 'text', 'attr' : 'class'},
	    'belong_cd5'       	: {'type' : 'text', 'attr' : 'class'},
	    'position_cd'       : {'type' : 'text', 'attr' : 'class'},
	    'job_cd'       		: {'type' : 'text', 'attr' : 'class'},
	    'employee_typ'      : {'type' : 'text', 'attr' : 'class'},
	    'grade'       		: {'type' : 'text', 'attr' : 'class'},    }
    }
};
var _mode = 0;
var _flgLeft = 0;
	$(document).ready(function() {
	try {
	
    if(navigator.userAgent.indexOf("Firefox") != -1 ) //prevent show popup save password browser firefox
    {
        	$('#password').attr('autocomplete','off');
        	$('#password').attr('type','password');
        	$('#password').removeClass('show_typePassWord');
        	if($('#employee_nm').val() == ''){
        		$('#employee_cd').val('');
        	}

    }else if(navigator.userAgent.indexOf("Edge") > -1) //IF IE > 10
    {
    	$('#password').attr('type','password');
    }
		initialize();
		initEvents();
	} catch (e) {
		alert('ready' + e.message);
	}
});


function initialize() {
	try{
		$('#employee_cd').focus();

		 var employee_cd = $('#employee_cd').val();
        $('.list-search-content div[id="'+employee_cd+'"]').addClass('active');
        _formatTooltip();
		// heightCSS();
	} catch(e){
		alert('initialize: ' + e.message);
	}
}
/**
 * initialize
 * 
 * @author      :   datnt - 2018/08/28 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function initEvents() {
 	try{
 		$(document).on('keyup','#user_id,#password',function(){
 			var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val()) ) {
				$(this).val('');
			}
	    })
	    $(document).on('keyup',function(e){
 			if (e.keyCode === 13) {
			    event.preventDefault();
			    if($(':focus')[0] ==$('#imageMain').find('label')[0]){
			    	$('#imgInp').trigger('click');
			    }
			    if($(':focus')[0] ==$('#imageMain').find('button')[0]){
			    	$('#btn-delete-file').trigger('click');
			    }
		  	}
	    })
	    $(document).on('blur','#user_id,#password',function(){
	    	var regex = /[\u3000-\u303F]|[\u3040-\u309F]|[\u30A0-\u30FF]|[\uFF00-\uFFEF]|[\u4E00-\u9FAF]|[\u2605-\u2606]|[\u2190-\u2195]|\u203B/g;
			if (regex.test($(this).val()) ) {
				$(this).val('');
			}
	    })
		$(document).on('change', '#employee_last_nm,#employee_first_nm', function(e) {
			try{
				var employee_last_nm = $('#employee_last_nm').val();
				var employee_first_nm = $('#employee_first_nm').val();
				if(employee_last_nm != ''||employee_first_nm != ''){
					$('#employee_nm').val(employee_last_nm +' '+employee_first_nm);
				}
			}catch(e){
				alert('#employee_last_nm or employee_first_nm: '+e.message);
			}
		});
		$(document).on('click', '#btn-add-new', function(e) {
			try{
				e.preventDefault();
				jMessage(5, function(r) {
					//location.reload();
					clear_info();
					// $('#rightcontent').empty();
					// $('#rightcontent').append()
				});
			}catch(e){
				alert('#birth_date event: '+e.message);
			}
		});
		/* left content click item */
		$(document).on('click', '#btn-delete', function(e) {
			try{
				e.preventDefault();
				jMessage(3, function(r) {
					del();
				});
			}catch(e){
				alert('#btn-delete event: '+e.message);
			}
		});
		// $(document).on('click', '#btn-back', function(e) {
		// 	var str = '';
		// 	if(location.search) {
		// 		var array = location.search.split('&');
		// 		var newArray = array.splice(0, 1);
		// 		// array = array.join('&');
		// 		var str = '?'+array.join('&');
		// 		// console.log(array.join('&'));
		// 	}
		// 	window.location.href = '/master/q0070'+str
		// });
		$(document).on('click', '#btn-back', function(){
    	    try{
    	        var screen_from = $('#screen_from').val();
    	        // if(screen_from == 'q0070'){
    	        //     window.location.href = '/master/'+screen_from;
    	        // }else{
    	        //     //var home_url = $('#home_url').attr('href');
    	        //     window.location.href = '/master/q0070'; 
    	        // }
    	        //
    	        if(_validateDomain(window.location)){
		            // window.location.href = '/dashboard';
		            window.location.href = '/master/q0070';
		        }else{
		            jError('エラー','このプロトコル又はホストドメインは拒否されました。');
		        }
    	    }catch(e){
    	        alert('#btn-back: ' + e.message); 
    	    }
    	});
		//
		// $(document).on('click', '#del_row', function(e) {
		// 	try{
		// 		var application_date = $(this).parents('tr').find('.application_date').val();
		// 		delRow(application_date);
		// 	}catch(e){
		// 		alert('#btn-delete event: '+e.message);
		// 	}
		// });
		//Button [パスワード通知] event
		$(document).on('click', '#btn-mail', function(e) {
			try {
				e.preventDefault();
				var employee_nm = $('#employee_nm').val();
				var password 	= $('#password').val();
				var mail 		= $('#mail').val();
				if(mail == ''){
					jMessage(58);
				}else{					
					sendMail(employee_nm,password,mail);
				}
			} catch (e) {
				alert('#btn-mail event : ' + e.message);
			}
		});
	    //Button [発行] event
	    $(document).on('click', '#btn-random-pass', function(e) {
	    	try {
	    		e.preventDefault();
	    		randomPass();
	    	} catch (e) {
	    		alert('#btn-random-pass event : ' + e.message);
	    	}
	    });
		//
		$(document).on('click', 'li.page-prev a.page-link:not(.pagging-disable)', function(e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			var organization_cd = $('#organization_cd:selected').val();
			getLeftContent(page, search,organization_cd);
		});
		$(document).on('click', 'li.page-next a.page-link:not(.pagging-disable)', function(e) {
			var page = $(this).attr('page');
			var search = $('#search_key').val();
			var organization_cd = $('#organization_cd:selected').val();
			getLeftContent(page, search,organization_cd);
		});
		$(document).on('click', '#btn-search-key', function(e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#organization_nm', function(e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#company_out_dt_flg', function(e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('change', '#search_key', function(e) {
			var page = 1;
			getLeftContent(page);
		});
		$(document).on('enterKey', '#search_key', function(e) {
			var page = 1;
			getLeftContent(page);
		});
		/* left content click item */
		$(document).on('click', '.list-search-child', function(e) {
			$('.list-search-child').removeClass('active');
			$(this).addClass('active');
			$('#employee_cd').val($(this).attr('id'));
			$('#employee_cd').change();
		});
	 	 // refer data employee
	 	 $(document).on('change','#employee_cd', function (){
	 	 	var employee_cd = $(this).val();
	 	 	// var result = parseFloat(employee_cd.replace(/,/g, ""));
	 	 /*	if(!checkHalfSize(employee_cd) || !result || result === 0){
				$(this).val('');
				clear_info();
			}else if(employee_cd == 0){
				clear_info();
				$(this).errorStyle(_text[8].message,1);
			}else{
				*/
				refer();
			// }
	 	 	// if(employee_cd!= ''){
	 	 		
	 	 	// }
	 	 });
	 	 function clear_info(){
	 	 	var html = '<p class="w100">'+photo+'</p><img id="img-upload" class="thumb" />';
			$(".avatar .flex-box").empty();
			$(".avatar .flex-box").append(html);
			$("#imgInp").val("");
			$('#rightcontent input').val('');
			$('#rightcontent select option').removeAttr('selected');
			$('#rightcontent select option:eq(0)').attr('selected');
			$("#belong_cd1").val(0);
			$("#belong_cd2").val(0);
			$('#employee_cd').focus();
			$('#result').empty();	
			$('#evaluated_typ').prop('checked',false);	
			$('#rd1').val(1);
			document.getElementById("rd1").checked = true;
			document.getElementById("rd2").checked = false;
			active_left_menu();
	 	 }
	 	 $(document).on('click', '#btn-save', function (){
	 	 	var errors = 0;
	 	 	errors = $('#company_out_dt').parents('.input-group-btn').find('.boder-error').length;
	 	 	if(errors == 0){
	 	 		jMessage(1, function(r) {
	 	 			_flgLeft = 1; 
		 	 		if ( r && _validate($('body'))) {
		 	 			saveData();
		 	 		}
	 	 		});
	 	 	}
	 	 	
	 	 });
	 	 $(document).on('click' , '#btn-upload' , function(){
	 	 	$('#imgInp').trigger('click');
	 	 });
		//
		$(document).on('change', '.btn-file :file', function () {
			var input = $(this),
			label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
			input.trigger('fileselect', [label]);
		});

		//btn-delete-file
		$(document).on('click','#btn-delete-file', function() {
			try {
				var html = '<p class="w100">'+photo+'</p><img id="img-upload" class="thumb" />';
				$(".avatar .flex-box").empty();
				$(".avatar .flex-box").append(html);
				$("#imgInp").val("");
				$(this).val('Y');
				// $("#modePic").val("Y");
			} catch (e) {
				alert('#btn-delete-file' + e.message);
			}
		});

		//
		// $("#imgInp").change(function () {
		// 	readURL(this);
		// });
		$(document).on('change', '#imgInp', function () {

			readURL(this);
		});

		$(document).on('click','#btn_show_password',function(e){
			try{
				e.preventDefault();
				if(navigator.userAgent.indexOf("Firefox") != -1 ) //prevent show popup save password browser firefox
    			{
					if($(this).hasClass('notview')){
						$(this).addClass('clicked');
						$(this).find('.fa').removeClass('fa-eye-slash');
						$(this).find('.fa').addClass('fa-eye');
						$(this).removeClass('notview');
						$('#password').attr('type','text');
						// $('#password').removeClass('show_typePassWord');

					}else{
						$(this).removeClass('clicked');
						$(this).find('.fa').addClass('fa-eye-slash');
						$(this).find('.fa').removeClass('fa-eye');
						$(this).addClass('notview');
						$("#password").attr('type','password');
						// $("#password").addClass('show_typePassWord');
					}
				}else{
					if($(this).hasClass('notview')){
						$(this).addClass('clicked');
						$(this).find('.fa').removeClass('fa-eye-slash');
						$(this).find('.fa').addClass('fa-eye');
						$(this).removeClass('notview');
						//$('#password').attr('type','text');
						$('#password').removeClass('show_typePassWord');
						$("#password").removeAttr('type');

					}else{
						$(this).removeClass('clicked');
						$(this).find('.fa').addClass('fa-eye-slash');
						$(this).find('.fa').removeClass('fa-eye');
						$(this).addClass('notview');
						$("#password").attr('type','password');
						$("#password").addClass('show_typePassWord');
					}
				}
			}catch(e){
				alert('#btn_show_password event:'+e.message);
			}
		})

		//btn-remove-row
		$(document).on('click','.btn-remove-row',function () {
			try{
				_mode=1
				$(this).parents('tr').remove();
			  // if ( $('#tbl-data tr').length <= 6 ) {
			  	if ( $('#tbl-data').height() < ($('#div_data').height()-15) ) {
			  		$('.scroll > table').css('width', '100%');
			  		$('.scroll > table').css('min-width', '1017px');
			  	}

			  	var row_count = $('.scroll tbody tr').length;
			  	if ( row_count <= 6 ) {
			  		$('.scroll').addClass('more4');
			  	}
			  	else {
			  		$('.scroll').removeClass('more4');
			  	}
			  } catch(e){
			  	alert('btn-remove-row: ' + e.message);
			  }
			});
	}catch(e){
		alert('initEvents:'+e.message);
	}
}
/**
 * gcd
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function heightCSS(){
	var heneed=$('.calHe').innerHeight();
 	var hetru=$('.calHe2').innerHeight();
 	var heit=heneed-hetru-65;
 	var heme=$('.list-search-content').innerHeight();
 	$('.list-search-content').attr('style','height: '+ heit +'px');
 	if(heme>heit){
 		$('.list-search-content').addClass('scroll');
 	}
 	$('.calHe2').parent().parent().parent().addClass('marb50');
}
/**
 * gcd
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function gcd (u, v) {
 	if (u === v) return u;
 	if (u === 0) return v;
 	if (v === 0) return u;

 	if (~u & 1)
 		if (v & 1)
 			return gcd(u >> 1, v);
 		else
 			return gcd(u >> 1, v >> 1) << 1;

 		if (~v & 1) return gcd(u, v >> 1);

 		if (u > v) return gcd((u - v) >> 1, v);

 		return gcd((v - u) >> 1, u);
 	}
 	/* returns an array with the ratio */
 	function getRatio(w, h) {
 		var d = gcd(w,h);
 		return [w/d, h/d];
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
 function refer(){
 	var employee_cd = $('#employee_cd').val();
	if(employee_cd == '0'){
		employee_cd = '';
		$('#employee_cd').val('');
	}
 	$.ajax({
 		type        :   'post',
 		url         :   '/master/m0070/refer',
 		dataType    :   'html',
 		loading     :   true,
 		data:{employee_cd : employee_cd},
 		success: function(res){
 			if(res) {
 				$('#rightcontent').html(res);
 				$('#employee_cd').focus();
 				active_left_menu();
 				jQuery.formatInput();
 				app.jTableFixedHeader();
 				// var heneed=$('.calHe').innerHeight();
 				// var hetru=$('.calHe2').innerHeight();
 				// var heit=heneed-hetru-55;
 				// var heme=$('.list-search-content').innerHeight();
 				// $('.list-search-content').attr('style','height: '+ heit +'px');
 				// if(heme>heit){
 				// 	$('.list-search-content').addClass('scroll');
 				// }
 				// $('.calHe2').parent().parent().parent().addClass('marb50');
 				$('[data-toggle="tooltip"]').tooltip();
				$('.list-search-father').tooltip();
				addImgs();
				_formatTooltip();
 				// heightCSS();
 			}
 			if(navigator.userAgent.indexOf("Firefox") != -1 ) //prevent show popup save password browser firefox
		    {
		        	$('#password').attr('autocomplete','off');
		        	$('#password').attr('type','password');
		        	$('#password').removeClass('show_typePassWord');
		    }
 		}
 	});
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
 function saveData(){
 	var data = getData(_obj);
 	var evaluated_typ	=	0;
 	if($('#evaluated_typ').is(':checked')){
		evaluated_typ	=	0;
	}else{
		evaluated_typ	=	1;
	}
 	data.data_sql.evaluated_typ 	= evaluated_typ;
	var mode_pic 		= "";
	var mode_flg		=	$('#btn-delete-file').val();
	if( typeof $('#imgInp')[0].files[0] != "undefined") {
		var mode_exists= "Y";
		$("#modePic").val("Y");
	}else {
		//modePic= "N";
		var mode_exists= "N";
		$("#modePic").val("N");
	}
	if(mode_flg	==	'Y'){
		var mode_exists= mode_flg;
		$("#modePic").val(mode_flg);
	}
	mode_pic = $("#modePic").val();
	data.data_sql.mode_pic = mode_pic;
	data.data_sql.mode = _mode;
	data.data_sql.mode_exists = mode_exists;
	var formData = new FormData();
	formData.append('head', JSON.stringify(data));
	formData.append('file', $('#imgInp')[0].files[0]);
 	$.ajax({
 		type : 'post',
 		data: formData,
 		url: '/master/m0070/postSave',
 		loading: true,
 		processData: false,
 		contentType: false,
 		enctype: "multipart/form-data",
 		success: function(res) {
 			switch (res['status']){
                // success
                case OK:
                    //
                    jMessage(2, function(r) {
                    	// location.href='/master/m0070';
                    	var html = '<p class="w100">'+photo+'</p><img id="img-upload" class="thumb" />';
						$(".avatar .flex-box").empty();
						$(".avatar .flex-box").append(html);
						$("#imgInp").val("");
						$('#rightcontent input').val('');
						$('#rightcontent select option').removeAttr('selected');
						$('#rightcontent select').val('');
						//$('#rightcontent select option:eq(0)').prop('selected',true);
						$("#belong_cd1").val(0);
						$("#belong_cd2").val(0);
						$('#result').empty();	
						$('#evaluated_typ').prop('checked',false);	
						$('#rd1').val(1);
						document.getElementById("rd1").checked = true;
						document.getElementById("rd2").checked = false;
						var page    =   $('#leftcontent').find('.active a').attr('page');
						getLeftContent(page);
                    });
                    	_mode = 0;
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
/**
 * del
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function del(){
 	var data = getData(_obj);
 	var evaluated_typ	=	0;
 	if($('#evaluated_typ').is(':checked')){
		evaluated_typ	=	0;
	}else{
		evaluated_typ	=	1;
	}
 	data.data_sql.evaluated_typ 	= evaluated_typ;
 	$.ajax({
 		type : 'post',
 		data: JSON.stringify(data),
 		url: '/master/m0070/del',
 		loading: true,
 		success: function(res){
 			switch (res['status']){
                    // success
                    case OK:
                    jMessage(4, function(r) {
                    	$('#rightcontent').find('input,select,checkbox').val('');
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
    })
 }
/**
 * delRow
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function delRow(application_date){
 	var employee_cd = $('#employee_cd').val();
 	$.ajax({
 		type : 'post',
 		data: {application_date: application_date, employee_cd :employee_cd},
 		url: '/master/m0070/del_row',
 		loading: true,
 		success: function(res){
 			switch (res['status']){
                    // success
                    case OK:
                    	$('#employee_cd').focus();
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
    })
 }
/**
 * getLeftContent
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function getLeftContent(page) {
 	try {
 		var list = [];
 		list.push({
                'organization_cd_1':$('#organization_nm').val()==0?'':$('#organization_nm').val(),
                'organization_cd_2':'',
                'organization_cd_3':'',
                'organization_cd_4':'',
                'organization_cd_5':'',
            }); 
        // send data to post
        var search 				= 	$('#search_key').val();
		var company_out_dt_flg	=	0;
		if($('#company_out_dt_flg').is(':checked')){
			company_out_dt_flg	=	1;
		}
       	var data =	{
       					current_page		: page
       				, 	search_key			: search
       				,	organization_step1		: JSON.stringify(list)
       				, 	company_out_dt_flg	: company_out_dt_flg
       			}
        $.ajax({
        	type        :   'POST',
        	url         :   '/master/m0070/leftcontent',
        	dataType    :   'html',
        	loading     :   true,
        	data        :   data,
        	success: function(res) {
        		$('#leftcontent .inner').empty();
        		$('#leftcontent .inner').html(res);
        		var heneed=$('.calHe').innerHeight();
        		var hetru=$('.calHe2').innerHeight();
        		var heit=heneed-hetru-110;
        		var heme=$('.list-search-content').innerHeight();
        		// $('.list-search-content').attr('style','height: '+ heit +'px');
        		_formatTooltip();
        		if(heme>heit){
        			$('.list-search-content').addClass('scroll');
        		}
                // var job_cd = $('#job_cd').val();
                // $('.list-search-content div[id="'+job_cd+'"]').addClass('active');
                // $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
                // if(_flgLeft != 1){
                //     $('#search_key').focus();
                // }
                if(_flgLeft != 1){
                    $('#search_key').focus();
                }else{
                	$('#employee_cd').focus();
                    _flgLeft = 0;
                }
                $('[data-toggle="tooltip"]').tooltip({trigger: "hover"});
				$('.list-search-father').tooltip();
                if(active_left_menu){
                	active_left_menu();
                }
            }
        });
    } catch (e) {
    	alert('get left content: ' + e.message);
    }
}
/**
 * readURL
 *
 * @author      :   datnt - 2018/08/28 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
 function readURL(input) {
 	if (input.files && input.files[0]) {
 		var reader = new FileReader();
		
 		reader.onload = function (e) {
			//
			$('#img-upload').attr('src', e.target.result);
			$('#img-upload').closest('div').addClass('loaded');
			$('#img-upload').closest('div').find('p').remove();
			// var img = document.getElementById('img-upload');
			var ratio = getRatio($('#img-upload').prop('naturalWidth'), $('#img-upload').prop('naturalHeight'));
			var frame_with = '120px';
			var height = '120px';
			$("img").addClass("imgs");
		}
		reader.readAsDataURL(input.files[0]);
	}
}

$('#btn-send-html').on('click', function() {
	var data = {
		'_token': '{{ csrf_token() }}',
		'data' : {customer_name: $('#customer_name').val()},
		'to': $('#to').val(),
		'subject': $('#subject').val(),
		'body': $('#body').val(),
		'cc': $('#cc').val(),
		'bcc': $('#bcc').val(),
		'mail_type': 'html',
		'attachs': $('#attachs').val(),
	};
	$.sendEmail(data, function(res) {
		alert(res['status']);
	});
});
/**
 * sendMail
 * 
 * @author      :   viettd - 2018/08/29 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
 function sendMail(employee_nm,password,mail) {
 	try {
 		var subject	='人事評価システムMIRAICのログインパスワードの通知';
 		var body 	= 'pass_mail';
    	//
    	var data = {
    		'_token'	: $('meta[name="csrf-token"]').attr('content'),
    		'data' 		: {employee_nm: employee_nm,password:password},
    		'to'		: mail,
    		'subject'	: subject,
    		'body'		: body,
    		'cc'		: '',
    		'bcc'		: '',
    		'mail_type'	: 'html',
    		'attachs'	: '',
    	};
    	$.sendEmail(data, function(res) {
    		if(res['status'] == OK){
    			jMessage(35); // sucess
    		}else{
    			jMessage(22); // fail
    		}
    	});
    } catch (e) {
    	alert('sendMail' + e.message);
    }
}
/**
 * randomPass
 * 
 * @author      :   viettd - 2018/08/29 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
 function randomPass() {
 	try {
    	// send data to post
    	$.ajax({
    		type        :   'POST',
    		url         :   '/master/m0070/randompass', 
    		dataType    :   'json',
    		//loading     :   true,
    		data        :   {},
    		success: function(res) {
    			if(res['status'] == OK){
    				if(typeof res['password'] != undefined){
    					// $('#password').val(res['password']);
    					$('#password').val(htmlEntities(res['password']));
    				}
    			}else{
    				$('#password').val('');
    			}
    		}
    	}); 
    } catch (e) {
    	alert('randomPass' + e.message);
    }
}
/**
 * caculateAge
 * 
 * @author      :   viettd - 2018/08/29 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
 function caculateAge(date_from = '',date_to = '',mode = 0) {
 	try {
    	// send data to post
    	$.ajax({
    		type        :   'POST',
    		url         :   '/master/m0070/getyear', 
    		dataType    :   'json',
    		loading     :   true,
    		data        :   {
    			date_from	: date_from
    			,	date_to		: date_to
    			,	mode		: mode
    		},
    		success: function(res) {
    			if(res['status'] == OK){
    				_clearErrors(1);
    				if(mode == 0){
    					$('#year_old').val(res['year_num']);
    				}else if (mode == 1){
    					if(res['year_check'] == 1){
    						$('#company_in_dt,#company_out_dt').errorStyle(_text[24].message,1);
    						$('#period_date').val('');
    					}else{
    						$('#period_date').val(res['year_num']);
    					}
    				}
    			}else{
    				if(mode == 0){
    					$('#year_old').val('');
    				}else if(mode == 1){
    					$('#period_date').val('');
    				}
    			}
    		}
    	}); 
    } catch (e) {
    	alert('caculateAge' + e.message);
    }
}
function active_left_menu(){
	var employee_cd  =   $('#employee_cd').val();
	$('.list-search-child').removeClass('active');
	$('.list-search-child').each(function(){
		_this = $(this);
		if(_this.attr('id') == employee_cd){
			_this.addClass('active');
		}
	})
}
function employee_cd_change(){
	$('#employee_cd').change();
}

 /* Check halfsize alphanumeric
 * @param string
 * @returns {Boolean}
 */
function _validateHalfSizeAlphanumeric(string){
//	string = _formatString(string);
	var regexp = /^[a-zA-Z0-9]+$/;
	if(regexp.test(string)||string == ''){
		return true;
	}else{
		return false;
	}
}

function addImgs() {
	var imgs = $("img").attr("src");
	if(imgs !='') {
		$("#img-upload").css("width","120px");
		//$("#img-upload").css("height","120px");
	}
}
/**
 * caculateAge
 * 
 * @author      :   datnt - 2018/12/10 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function date_callback(el){
	try{
		var cur_year=new Date();
		var item = $(el).attr('id');
		if(item == 'birth_date'){
			var birth_date =  $(el).val();
			var birth_date_convert	=  new Date(birth_date);
			if(birth_date !=''){
				caculateAge(birth_date,'',0);
			}else{
				$('#year_old').val('');
			}
		}
		else if(item == 'company_in_dt'){
			var company_out_dt 	=  $('#company_out_dt').val();
			var company_in_dt	=  $(el).val();
			var company_in_date	=  new Date(company_in_dt);
			if(company_in_dt !=''&&company_in_date<cur_year){
				caculateAge(company_in_dt,company_out_dt,1);
			}else if((company_in_dt > company_out_dt)||company_in_dt == ''){
				//$(el).val('');
				$('#period_date').val('');
			}
			var application_date  	= 	$('#application_date').val();
			if(application_date == ''){
				$('#application_date').val(company_in_dt);
			}
		}else if(item == 'company_out_dt'){
			var company_out_dt  =  $(el).val();
			var company_in_dt 	= $('#company_in_dt').val();
			// if(company_out_dt != ''){
				caculateAge(company_in_dt,company_out_dt,1);
			// }
		}
	}catch(e){
		alert('#birth_date event: '+e.message);
	}
}
function checkHalfSize(str){
	str = (str==null)?"":str;
	if(str.match(/^[A-Za-z0-9]*$/)){
		return true;
	}else{
		return false;
	}

}
function _validateFullSize(string) {
		try {
			// string = $.rtrim(string);
			string = $.mbRTrim(string);
			if ($.byteLength(string) != string.length) {
				return true;
			} else {
				return false;
			}
		} catch (e) {
			alert('_validateFullSize: ' + e);
		}
	}