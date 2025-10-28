/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	longvv – longvv@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
var _obj = {

};

$(function () {
    initEvents();
    initialize();
});

/**
 * initialize
 *
 * @author		:	longvv - 2018/10/08 - create
 * @author		:
 * @return		:	null
 * @access		:	public
 * @see			:	init
 */
function initialize() {
    try {
        // $('body .form-control:not([readonly]):not([disabled]):not(".hidden"):first').focus();
        _formatTooltip();
    } catch (e) {
        alert('initialize: ' + e.message);
    }
}
/*
 * INIT EVENTS
 * 
 * @author      :   longvv - 2018/10/08 - create
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function initEvents() {
    try {
        document.addEventListener('keydown', function (e) {
            if (e.keyCode === 9) {
                if (e.shiftKey) {
                    if ($(':focus')[0] === $(":input:not([readonly],[disabled],:hidden)").first()[0]) {
                        e.preventDefault();
                        if ($('.lth a:not([readonly],[disabled],:hidden)').last().length != 0) {
                            $('.lth a:not([readonly],[disabled],:hidden)').last()[0].focus();
                        }
                        if ($('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length > 0) {
                            e.preventDefault();
                            $('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0].focus();
                        }
                        return;
                    }
                } else {
                    if ($('.lth a:not([readonly],[disabled],:hidden)').last().length > 0) {
                        if ($(':focus')[0] === $('.lth a:not([readonly],[disabled],:hidden)').last()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first().focus();
                        }
                    } else if ($('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last().length > 0) {
                        if ($(':focus')[0] === $('.hyouka-left_stepBox a:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').last()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0].focus();
                        }
                    } else {
                        if ($(':focus')[0] === $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0]) {
                            e.preventDefault();
                            $(':input:not(.disabled,.no-focus,.disable,:hidden,[readonly],[disabled],:disabled)').first()[0].focus();
                        }
                    }

                }
            }
        });
        //evaluator
        $(document).on('click', '.list_status', function () {
            try {
                var data = {
                    'fiscal_year': $(this).attr('fiscal_year'),
                    'employee_cd': $(this).attr('employee_cd'),
                    'sheet_cd': $(this).attr('sheet_cd'),
                    'from': 'portal',   // screen from
                };
                var screen_refer = $(this).attr('screen_refer');
                _redirectScreen(screen_refer,data,true);
            } catch (e) {
                alert('.btn_employee_cd_popup' + e.message);
            }
        });
        //i2020 i2010
        $(document).on('click', '.refer_hyouka', function () {
            try {
                var data = {
                    'fiscal_year': $(this).attr('fiscal_year'),
                    'employee_cd': $(this).attr('employee_cd'),
                    'sheet_cd': $(this).attr('sheet_cd'),
                    'from': 'portal',   // screen from
                };
                var screen_refer = $(this).attr('screen_refer');
                _redirectScreen(screen_refer,data,true);
            } catch (e) {
                alert('.refer_hyouka' + e.message);
            }
        });

        //evaluator
        $(document).on('change', '#list_fiscal_year', function () {
            try {
                var fiscal_year = $('#list_fiscal_year').val();
                if (fiscal_year != '') {
                    refer(0,fiscal_year);
                }
            } catch (e) {
                alert('#list_fiscal_year' + e.message);
            }
        });
        $(document).on('change', '#evaluation_typ', function () {
            try {
                if ($('#evaluation_typ').val() == -1) {
                    var fiscal_year = $('#list_fiscal_year').val();
                    var evaluation_typ = $(this).val();
                    var evaluation_stage = -1
                    var period = -1
                } else {
                    var fiscal_year = $('#list_fiscal_year').val();
                    var evaluation_typ = $(this).val();
                    var evaluation_stage = $('#evaluation_stage').val()
                    var period = $('#period').val()
                
                }
                if (evaluation_typ != 0) {
                    refer(1,fiscal_year,evaluation_typ,evaluation_stage,period);
                }
            } catch (e) {
                alert('#list_fiscal_year' + e.message);
            }
        });
        $(document).on('change', '#evaluation_stage', function () {
            try {
                var fiscal_year = $('#list_fiscal_year').val();
                var evaluation_typ = $('#evaluation_typ').val();
                var evaluation_stage = $(this).val()
                var period = $('#period').val()
                
                
                if (evaluation_typ != 0) {
                    refer(1,fiscal_year,evaluation_typ,evaluation_stage,period);
                }
            } catch (e) {
                alert('#list_fiscal_year' + e.message);
            }
        });
        $(document).on('change', '#period', function () {
            try {
                var fiscal_year = $('#list_fiscal_year').val();
                var evaluation_typ = $('#evaluation_typ').val();
                var evaluation_stage = $('#evaluation_stage').val()
                var period = $('#period').val()
                
                
                if (evaluation_typ != 0) {
                    refer(1,fiscal_year,evaluation_typ,evaluation_stage,period);
                }
            } catch (e) {
                alert('#list_fiscal_year' + e.message);
            }
        });
        $(document).on('change', '#organization_step1, #organization_step2, #organization_step3', function () {
            try {
                var fiscal_year = $('#list_fiscal_year').val();
                var evaluation_typ = $('#evaluation_typ').val();
                var evaluation_stage = $('#evaluation_stage').val()
                var period = $('#period').val()
                
                
                if (evaluation_typ != 0) {
                    refer(1,fiscal_year,evaluation_typ,evaluation_stage,period);
                }
            } catch (e) {
                alert('#list_fiscal_year' + e.message);
            }
        });
        // list_infomation
        $(document).on('click', '.list_infomation', function () {
            try {
                var data = {
                    'company_cd': $(this).attr('company_cd')
                    , 'category': $(this).attr('category')
                    , 'status_cd': $(this).attr('status_cd')
                    , 'infomationn_typ': $(this).attr('infomationn_typ')
                    , 'infomation_date': $(this).attr('infomation_date')
                    , 'target_employee_cd': $(this).attr('target_employee_cd')
                    , 'sheet_cd': $(this).attr('sheet_cd')
                    , 'employee_cd': $(this).attr('employee_cd')
                    , 'fiscal_year': $(this).attr('fiscal_year')
                };
                showPopup("/common/popup/getinformation/?" + setGetPrams(data), {}, function () {
                });
            } catch (e) {
                alert('.list_infomation' + e.message);
            }
        });
        
    } catch (e) {

    }
}
/**
 * refer
 * 
 * @author      :   longvv
 * @author      :   
 * @return      :   null
 * @access      :   public
 * @see         :   
 */
function refer(mode = 0, fiscal_year, evaluation_typ = '-1', evaluation_stage = '-1', period = '-1') {
    var organization_cd_1 = '';
    var organization_cd_2 = '';
    var organization_cd_3 = '';
    var pos_2 = 0;
    if ($('#organization_step1').val() != undefined && $('#organization_step1').val() != '') {
        var organization_step1 = ($('#organization_step1').val())
        if (organization_step1 != '') {
            organization_cd_1 = organization_step1.substring(0, organization_step1.indexOf('|')) ?? ''
        } else {
            organization_cd_1 = ''
        }
    } else {
        organization_cd_1 = ''
    }
    if ($('#organization_step2').val() != undefined && $('#organization_step2').val() != '') {
        var organization_step2 = ($('#organization_step2').val())
        if (organization_step2 != '') {
            organization_cd_2 = organization_step2.substring(organization_step2.indexOf('|', 0) + 1, organization_step2.indexOf('|', organization_step2.indexOf('|', 0) + 1)) ?? ''
        } else {
            organization_cd_2 = ''
        }
        pos_2 = organization_step2.indexOf('|', organization_step2.indexOf('|', 0) + 1)
    } else {
        organization_cd_2 = ''
    }
    if ($('#organization_step3').val() != undefined && $('#organization_step3').val() != '' && $('#organization_step3').val() != '-1') {
        var organization_step3 = ($('#organization_step3').val())
        if (organization_step3 != '' && pos_2 != 0) {
            organization_cd_3 = organization_step3.substring(pos_2 + 1, organization_step3.indexOf('|', pos_2 + 1)) ?? ''
        } else {
            organization_cd_3 = ''
        }
    } else {
        organization_cd_3 = ''
    }
    $.ajax({
        type: 'post',
        url: '/master/portal/indexrefer',
        dataType: 'html',
        data: { 'fiscal_year': fiscal_year, 'evaluation_typ': evaluation_typ, 'evaluation_stage': evaluation_stage, 'period': period, 'organization_cd': getOrganization(), 'mode': mode,'organization_cd_1':organization_cd_1,'organization_cd_2':organization_cd_2,'organization_cd_3': organization_cd_3},
        loading: true,
        success: function (res) {
            if (mode == 0) {
                $('#div_result').empty();
                $('#div_result').html(res);
            } else {
                $('#sheet_block').empty();
                $('#sheet_block').html(res);
            }
        },
        error: function (xhr) {
            jError('エラー', xhr.statusText);
        }
    });
}
function getOrganization() {
    var param = {};
		var list = [];
    if ($('#organization_step1 option').length > 0) {
                    var str = $('#organization_step1').val().split('|');
                    list.push({
                        'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                        'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
                        'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
                        'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
                        'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
                    });
                }
                    param.list_organization_step1 = list;
                    list = [];
                    if ($('#organization_step2 option').length > 0) {
                        if ($('#organization_step2').val() != '') {
                            var str = $('#organization_step2').val().split('|');
                            list.push({
                                'organization_cd_1':  str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                                'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
                                'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
                                'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
                                'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
                            });
                        }
                    }
                    param.list_organization_step2 = list;
                    list = [];
                    if ($('#organization_step3 option').length > 0) {
                        if ($('#organization_step3').val() != '') {
                            var str = $('#organization_step3').val().split('|');
                            list.push({
                                'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                                'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
                                'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
                                'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
                                'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
                            });
                        }
                    }
                    param.list_organization_step3 = list;
                    list = [];
                    if ($('#organization_step4 option').length > 0) {
                        if ($('#organization_step4').val() != '') {
                            var str = $('#organization_step4').val().split('|');
                            list.push({
                                'organization_cd_1': str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                                'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
                                'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
                                'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
                                'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
                            });
                        }
                    }
                    param.list_organization_step4 = list;
                    list = [];
                    if ($('#organization_step5 option').length > 0) {
                        if ($('#organization_step5').val() != '') {
                            var str = $('#organization_step5').val().split('|');
                            list.push({
                                'organization_cd_1':  str[0] == undefined || str[0] == 0 || str[0] == -1 ? '' : str[0],
                                'organization_cd_2': str[1] == 'undefined' ? '' : str[1],
                                'organization_cd_3': str[2] == 'undefined' ? '' : str[2],
                                'organization_cd_4': str[3] == 'undefined' ? '' : str[3],
                                'organization_cd_5': str[4] == 'undefined' ? '' : str[4],
                            });
                        }
    }
    console.log(param);
    param.list_organization_step5 = list;
    return param;
}
