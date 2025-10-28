/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2021/01/25
 * 作成者		    :	datnt – datnt@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {
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
 * @author		:	datnt - 2021/01/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
    	_formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	datnt - 2021/01/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
   try{
	   $(document).on('click', '#btn-apply', function() {
		   try {
			   apply();
		   } catch (e) {
			   alert('.table-bordered tbody tr' + e.message);
		   }
	   });

	   $(document).on('click', 'li a.page-link:not(.pagging-disable)', function(e) {
            var li  = $(this).closest('li'),
			page =li.find('a').attr('page');
		   	$('.pagination li').removeClass('active');
		   	li.addClass('active');
		   	var cb_page = $('#cb_page').find('option:selected').val();
		   	var cb_page = cb_page == '' ? 1 : cb_page;
		   	search(page,cb_page);
        });

	   $(document).on('click', '#btn-search', function(e) {
		   var page = 1;
		   var page_size = 20;
		   search(page,page_size);
	   });
	   $(document).on('change', '#cb_page', function(e) {
		   var li  = $('.pagination li.active'),
			   page =li.find('a').attr('page');
		   var cb_page = $(this).val();
		   var cb_page = cb_page == '' ? 20 : cb_page;
		   search(page,cb_page);
	   });
	   $(document).on('change', '#ck_all', function(){
		try {
			var checked = $(this).is(':checked');
			if ( checked ) {
				$('input.ck_item').prop('checked', true);
			}
			else {
				$('input.ck_item').prop('checked', false);
			}
		} catch(e){
			alert('#ck_all: ' + e.message);
		}
	});
	//checkbox
	$(document).on('change', '.ck_item', function(){
		try {
			var check_length = $('input.ck_item').length;
			var checked_length = $('input.ck_item:checked').length;
			//
			if ( check_length == checked_length ) {
				$('#ck_all').prop('checked', true);
			}
			else {
				$('#ck_all').prop('checked', false);
			}
			//
			//$(this).closest('tr').find('.adjust_point').trigger('change');
		} catch(e){
			alert('#ck_item: ' + e.message);
		}
	});
   } catch(e){

   }
}
/**
 * apply value
 *
 * @author  :   datnt - 2021/01/21 - create
 * @author  :
 *
 */
function apply() {
	try {
		var html = '';
		var class_select = $('#class_select').val();
		let mulitiselect_mode = $('#mulitiselect_mode').val();
		let class_list = '';
		if(mulitiselect_mode == 1){
			class_list = 'list_employee_cd';
		}
		if(mulitiselect_mode == 2){
			class_list = 'list_supporter_cd';
		}
		if(mulitiselect_mode == 3){
			class_list = 'list_rater_employee_cd';
		}
		var count = parent.$('#'+class_select).closest('.row').find('.div-m0102 .bl102').length;
		var array = [];
		if(count == 0){
			$('.ck_item:checked').each(function(element){
				let employee_cd 	= $.trim($(this).parents('tr').attr('employee_cd'));
				let employee_nm 	= $.trim($(this).parents('tr').attr('employee_nm'));
				html +=' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px">'
				+'<a href="javascript:;" class="btn btn-primary circle '+class_list+' table_m0102 0 zero">'
				+'<input type="hidden" class="detail_no" value='+employee_cd+'>'
				+'<span>'+employee_nm+'</span>'
				+'<i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a>'
				+'<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> '
			})
			parent.$('.employee_cd_choice').find('.group-add-but').append(html);
		}
		else {
			parent.$('#'+class_select).closest('.row').find('.div-m0102 .bl102').each(function () {
				array.push($(this).find('.detail_no').val());
			});
			$('.ck_item:checked').each(function(element){
				let employee_cd 	= $.trim($(this).parents('tr').attr('employee_cd'));
				console.log(employee_cd);
				let employee_nm 	= $.trim($(this).parents('tr').attr('employee_nm'));
				if(array.indexOf(employee_cd) == -1) {
					html +=' <span class="bl102" style="margin-left: 10px;margin-bottom: 10px">'
					+'<a href="javascript:;" class="btn btn-primary circle '+class_list+' table_m0102 0 zero">'
					+'<input type="hidden" class="detail_no" value='+employee_cd+'>'
					+'<span>'+employee_nm+'</span>'
					+'<i class="fa fa-times mr0" aria-hidden="true" style="opacity: 0;"></i> </a>'
					+'<i class="fa fa-times mr0 btn-remove-but" aria-hidden="true"></i></span> '
				}
			})
			parent.$('.employee_cd_choice').find('.group-add-but').append(html);
		}
		parent.$('.employee_cd_choice').removeClass('employee_cd_choice');
		parent.$.colorbox.close();
		parent.$('body').css('overflow','auto');
	} catch (e) {
		alert('transfer' + e.message);
	}
}
/**
 * search
 *
 * @author  :   datnt - 2021/01/21 - create
 * @author  :
 *
 */
function search(page,page_size) {
		// send data to post
		if(typeof page =='undefined') {
			var page = 1;
		}
		if(typeof page_size =='undefined') {
			var page_size = 20;
		}
		var rater_position_cd	=	$('#rater_position_cd').val();
		var position_cd 		=	$('#position_cd').val();
		var obj = {};
		var list_org = getOrganization();
		obj.mode = 1;
		obj.page = page;
		obj.page_size = page_size;
		obj.employee_cd = $('#employee_cd').val();
		obj.employee_ab_nm = $('#employee_ab_nm').val();
		obj.office_cd = $('#office_cd').val();
		obj.mulitiselect_mode = $('#mulitiselect_mode').val();
		obj.fiscal_year = $('#fiscal_year').val();
		obj.organization_step1       = JSON.stringify(list_org.list_organization_step1)
        obj.organization_step2       = JSON.stringify(list_org.list_organization_step2)
        obj.organization_step3       = JSON.stringify(list_org.list_organization_step3)
        obj.organization_step4       = JSON.stringify(list_org.list_organization_step4)
        obj.organization_step5       = JSON.stringify(list_org.list_organization_step5)
		obj.job_cd = $('#job_cd').val();
		if(rater_position_cd !=''){
			obj.position_cd = 	rater_position_cd;
		}else{
			obj.position_cd = 	position_cd;
		}
		var company_out_dt_flg	=	0;
		if($('#company_out_dt_flg').is(':checked')){
			company_out_dt_flg	=	1;
		}
		obj.company_out_dt_flg = 	company_out_dt_flg;
		$.ajax({
			type        :   'POST',
			url         :   '/common/popup/multiselect_employee/search',
			dataType    :   'html',
			loading     :   true,
			data        :   {'data':obj},
			success: function(res) {
				$('#result').empty();
				$('#result').html(res);
				$('#employee_cd').focus();
				$('[data-toggle="tooltip"]').tooltip();
				_formatTooltip();
			}
		});

}
function getOrganization(){
    let param = [];
    let list = [];
    if($('#organization_step1').val()!=undefined){
        var str  =  $('#organization_step1 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step1   =   list;
    list = [];
    if($('#organization_step2').val()!=undefined){
        var str  =  $('#organization_step2 option:selected').val().split('|');
        if(str[0] !=0){
            list.push({
                'organization_cd_1':str[0] == undefined ? '' : str[0],
                'organization_cd_2':str[1] == undefined ? '' : str[1],
                'organization_cd_3':str[2] == undefined ? '' : str[2],
                'organization_cd_4':str[3] == undefined ? '' : str[3],
                'organization_cd_5':str[4] == undefined ? '' : str[4],
            });
        }

    }
    param.list_organization_step2   =   list;
    list = [];
    if($('#organization_step3').val()!=undefined){
        var str  =  $('#organization_step3 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step3   =   list;
    list = [];
    if($('#organization_step4').val()!=undefined){
        var str  =  $('#organization_step4 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0 ? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step4   =   list;
    list = [];
    if($('#organization_step5').val()!=undefined){
        var str  =  $('#organization_step5 option:selected').val().split('|');
        list.push({
            'organization_cd_1':str[0] == undefined ||str[0] ==0? '' : str[0],
            'organization_cd_2':str[1] == undefined ? '' : str[1],
            'organization_cd_3':str[2] == undefined ? '' : str[2],
            'organization_cd_4':str[3] == undefined ? '' : str[3],
            'organization_cd_5':str[4] == undefined ? '' : str[4],
        });
    }
    param.list_organization_step5  =   list;
    list = [];
    return param;
}