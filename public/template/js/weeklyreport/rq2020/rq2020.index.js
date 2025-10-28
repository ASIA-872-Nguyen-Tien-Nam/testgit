/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日    : 
 * 作成者    : 
 *
 * @package   : MODULE MASTER
 * @copyright : Copyright (c) ANS-ASIA
 * @version   : 1.0.0
 * ****************************************************************************
 */
$(document).ready(function () {
    try {
        initEvents();
        initialize();
    } catch (e) {
        alert('ready' + e.message);
    }
});
function initialize() {
    try {
    } catch (e) {
        alert('ready' + e.message);
    }
}

/*
* INIT EVENTS
*/
function initEvents() {
    try {
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        // search
        $(document).on('click', '#btn_search', function (e) {
            try {
                if (_validate($('body'))) {
                    search();
                }
            } catch (e) {
                alert('#btn_search: ' + e.message);
            }
        });
        //export
        $(document).on('click', '#btn-item-evaluation-input', function (e) {
            try {
                if (_validate($('body'))) {
                    exportCSV();
                }
            } catch (e) {
                alert('#btn_search: ' + e.message);
            }
        });
        // 
        $(document).on('click', '.weekly_tab', function (e) {
            try {
                e.preventDefault();
				var fiscal_year = $(this).attr('fiscal_year');
				var employee_cd = $(this).attr('employee_cd');
				var report_kind = $(this).attr('report_kind');
				var report_no = $(this).attr('report_no');
				var data = {
					'fiscal_year_weeklyreport': fiscal_year
					, 'employee_cd': employee_cd
					, 'report_kind': report_kind
					, 'report_no': report_no
					, 'from': 'rq2020'
				};
				data['screen_id'] = 'rq2020_ri2010';	// save key -> to cache (link from odashboard member to oq2010)
				_redirectScreen('/weeklyreport/ri2010', data, true);
            } catch (e) {
                alert('.employee_cd_link: ' + e.message);
            }
        });
        // 
        $(document).on('change', '#fiscal_year', function (e) {
            try {
                var value = $(this).val();
                var can_view = false;
                $('#employee_nm').attr('fiscal_year_weeklyreport',value);
                    $.ajax({
                        type: 'GET',
                        url: '/common/employeeautocompleteweeklyreport',
                        dataType: 'json',
                    // loading:true,
                    global: false,
                    data: {
                        key: '',
                        fiscal_year :	$('#fiscal_year').val(), //add vietdt 2022/04/01
                    },
                    success: function (res){
                        for(var i = 0;i<res.length;i++){
                            res[i].label 	=	htmlEntities(res[i].label);
                            if($('#employee_cd').val() == res[i].id) {
                                can_view = true
                            }
                        }
                        if(can_view != true) {
                            $('#employee_cd').val('')
                            $('#employee_nm').attr('fiscal_year_weeklyreport',value);
                            $('#year_month_start').val('')
                            $('#year_month_end').val('')
                            $('#report_kinds').val("-1")
                            $('#employee_nm').val("")
                            fiscal();
                        }
                    },
                });
                
            } catch (e) {
                alert('.employee_cd_link: ' + e.message);
            }
        });
        
        $(document).on('change', '.employee_nm_weeklyreport', function (e) {
			try {
				var old_reporter = $(this).attr('old_employee_nm');
				if ($(this).val()!= old_reporter) {
					$(this).val('')
					$('#employee_cd').val('')
				}
			} catch (e) {
				alert('.fiscal_year: ' + e.message);
			}
		});
    } catch (e) {
        alert('initEvents: ' + e.message);
    }
}
/*
 * search
 * @author    : quangnd@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function search() {
    try {
        var data={}
        data.fiscal_year        = $('#fiscal_year').val();
        data.year_month_start   = $('#year_month_start').val().replace('/','');
        data.year_month_end     = $('#year_month_end').val().replace('/','');
        data.report_kinds       = $('#report_kinds').val();
        data.employee_cd        = $('#employee_cd').val();
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2020/search',
            dataType: 'html',
            loading: true,
            data: data,
            success: function (res) {
                $('#result').empty().append(res);
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
/**
 * exportCSV
 *
 * @author      :  tuantv - 2018/09/30 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function exportCSV() {
    try {
        var data={}
        data.fiscal_year        = $('#fiscal_year').val();
        data.year_month_start   = $('#year_month_start').val().replace('/','');
        data.year_month_end     = $('#year_month_end').val().replace('/','');
        data.report_kinds       = $('#report_kinds').val();
        data.employee_cd        = $('#employee_cd').val();
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2020/export',
            dataType: 'json',
            loading: true,
            data: data,
            success: function (res) {
                // success
                switch (res['status']) {
                    case OK:
                        var filedownload = res['FileName'];
                        var filename = '週報個人履歴.csv';
                        if ($('#language_jmessages').val() == 'en') {
                            filename = 'WeeklyPersonalHistory.csv';
                        }
                        if (filedownload != '') {
                            downloadfileHTML(filedownload, filename, function () {
                                //
                            });
                        } else {
                            jError(2);
                        }
                        break;
                    case NG:
                        jMessage(21);
                        break;
                    case EX:
                        jMessage(22);
                        break;
                    default:
                        break;
                }
            }
        });
    } catch (e) {
        alert('exportCSV' + e.message);
    }
}
/*
 * search
 * @author    : quangnd@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function fiscal() {
    try {
        var data={}
        // send data to post
        $.ajax({
            type: 'POST',
            url: '/weeklyreport/rq2020/fiscal',
            dataType: 'html',
            loading: true,
            data: data,
            success: function (res) {
                $('#result').empty().append(res);
            }
        });
    } catch (e) {
        alert('search: ' + e.message);
    }
}
