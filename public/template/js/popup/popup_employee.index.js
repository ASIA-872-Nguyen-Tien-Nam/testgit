/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/25
 * 作成者		    :	longvv – longvv@ans-asia.com
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
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try{
		var screen_emp_info = ''
		if(parent.$('#employee_cd').attr('screen') != undefined) {
		screen_emp_info = parent.$('#employee_cd').attr('screen')
		$('body').addClass(screen_emp_info)
		}
		_formatTooltip();
    } catch(e){
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * @author		:	longvv - 2018/06/25 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initEvents() {
   try{
        $(document).on('click', '.table-bordered tbody tr:not(.tr-nodata)', function() {
			try {
				transfer($(this));
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
   } catch(e){

   }
}

function transfer(element) {
	try {
		var emp_typ = element.find('td:eq(3)').text()
		var belong_nm_1 = element.find('td:eq(4)').text()
		var belong_nm_2 = element.find('td:eq(5)').text()
		var belong_nm_3 =  element.find('td:eq(6)').text()
		var belong_nm_4 = element.find('td:eq(7)').text()
		var belong_nm_5 = element.find('td:eq(8)').text()
		var job_title = element.find('td:eq(9)').text()
		var position = element.find('td:eq(10)').text()
		var rank =  element.find('td:eq(11)').text()
		var employee_cd 	= $.trim(element.attr('employee_cd'));
		var employee_nm 	= $.trim(element.attr('employee_nm'));
		parent.$('.employee_cd_choice').find('.employee_cd_hidden').val(employee_cd);
		parent.$('.employee_cd_choice').find('.add_employee_cd').val(employee_cd);
		parent.$('.employee_cd_choice').find('.employee_cd').val(employee_cd);
		parent.$('.employee_cd_choice').find('.employee_nm').val(employee_nm);
		parent.$('.add_approver_employee_nm').attr('emp_cd', employee_cd);
		parent.$('.employee_cd_choice').find('.approver_employee_cd_1').val(employee_cd);
		parent.$('.employee_cd_choice').find('.approver_employee_nm_1').val(employee_nm);
		parent.$('.employee_cd_choice').find('.approver_employee_cd_2').val(employee_cd);
		parent.$('.employee_cd_choice').find('.approver_employee_nm_2').val(employee_nm);
		parent.$('.employee_cd_choice').find('.approver_employee_cd_3').val(employee_cd);
		parent.$('.employee_cd_choice').find('.approver_employee_nm_3').val(employee_nm);
		parent.$('.employee_cd_choice').find('.approver_employee_cd_4').val(employee_cd);
		parent.$('.employee_cd_choice').find('.approver_employee_nm_4').val(employee_nm);
		parent.$('.employee_cd_choice').find('.add_approver_employee_cd').val(employee_cd);
		parent.$('.employee_cd_choice').find('.add_approver_employee_nm').val(employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_1on1').val(employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_mulitireview').val(employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_weeklyreport').val(employee_nm);
		parent.$('.employee_cd_choice').find('.employee_name').val(employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_1on1').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_mulitireview').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').find('.employee_nm_weeklyreport').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').closest('.div_parent_employee_cd').next('.div_parent_employee_nm').find('.employee_nm').val(employee_nm);
		parent.$('.employee_cd_choice').closest('.div_parent_employee_cd').next('.div_parent_employee_nm').find('.employee_name').val(employee_nm);
		parent.$('.employee_cd_choice').closest('.div_parent_employee_cd').next('.div_parent_employee_nm').find('.employee_nm').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').next('.div_parent_employee_nm').find('.employee_nm').attr('old_employee_nm',employee_nm);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').next('.div_parent_employee_nm').find('.employee_nm').remove();
		parent.$('.employee_cd_choice').closest('.div_parent_employee_cd').next('.div_parent_employee_nm').find('.employee_cd_hidden').val(employee_cd);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').find('.rate_emp').attr('old_rater_employee_nm', employee_nm);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').find('.rate_emp').attr('old_approver_employee_nm', employee_nm);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').find('.rate_emp').trigger('blur');

		var index = parent.$('.employee_cd_choice').closest('.div_employee_cd').find("input:first").data('rater');
		parent.$('.employee_cd_choice').closest('.div_employee_cd').find(".rater_employee_cd_"+index).val(employee_cd);
		parent.$('.employee_cd_choice').closest('.div_employee_cd').find(".rater_employee_nm_"+index).val(employee_nm);

		

		parent.$('.employee_nm_1on1').closest('.row_active').find('.check_exist').val(employee_cd);
		parent.$('.employee_nm_1on1').closest('.row_active').find('.add_approver_employee_nm').val('click');
		parent.$('.employee_nm_1on1').closest('.row_active').find('.add_approver_employee_nm').val(employee_nm);
		parent.$('.employee_nm_1on1').closest('.row_active').find('.add_approver_employee_nm').attr('emp_cd',employee_cd);
		parent.$('.employee_nm_1on1').closest('.row_active').find('.add_approver_employee_nm').trigger('change');
		parent.$('.employee_cd_choice').removeClass('employee_cd_choice');
		parent.$('.add_approver_employee_nm').trigger('change');
		parent.$('.add_employee_cd ').trigger('change');
		parent.$.colorbox.close();
		parent.$('body').css('overflow','auto');

	} catch (e) {
		alert('transfer' + e.message);
	}
}
/**
 * search
 *
 * @author  :   tuantv - 2018/08/21 - create
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
		obj.page = page;
		obj.page_size = page_size;
		obj.employee_cd = $('#employee_cd').val();
		obj.employee_ab_nm = $('#employee_ab_nm').val();
		obj.office_cd = $('#office_cd').val();
		obj.system = $('#system').val();
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
			url         :   '/common/popup/employee/search',
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