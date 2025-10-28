<?php

/**
 * @author : namnb@ans-asia.com
 * @Website : http://ans-asia.com
 * @version : 1.0
 * @Build by tannq@ans-asia.com
 * @description: Framework building use Laravel
 * @Created at: 2017-08-07 03:13:46
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : add router customer 
 */

Route::group(
	['prefix' => 'common'],
	function () {
		Route::get('', 'CommonController@getIndex');
		// change password
		Route::get('/download', 'CommonController@download')->middleware('logined');
		Route::post('/validateLogin', 'CommonController@validateLogin');
		Route::post('/deletetemp', 'CommonController@deletetemp');
		Route::post('/setCache', 'CommonController@setCache')->middleware('logined');
		Route::get('/pdf/example', 'PDFController@getIndex')->middleware('logined');
		Route::post('/pdf/process', 'PDFController@postProcess')->middleware('logined');
		Route::get('/pdf/preview', 'PDFController@getPreview')->middleware('logined');
		Route::get('/pdf/download', 'PDFController@getDownload')->middleware('logined');
		Route::get('/excel', 'ExcelController@getIndex')->middleware('logined');
		Route::get('/excel/download', 'ExcelController@getDownload')->middleware('logined');
		Route::post('/excel/import', 'ExcelController@importData')->middleware('logined');
		Route::post('/excel/process', 'ExcelController@postProcess')->middleware('logined');
		Route::post('/excel/export_q2010', 'ExcelController@exportQ2010')->middleware('logined');
		Route::post('/excel/export2_q2010', 'ExcelController@export2Q2010')->middleware('logined');
		Route::get('/email/index', ['as' => 'email.index', 'uses' => 'EmailController@index'])->middleware('logined');
		Route::post('/email/sendhtml', ['as' => 'email.send.html', 'uses' => 'EmailController@sendhtml'])->middleware('logined');
		Route::post('/email/sendraw', ['as' => 'email.send.raw', 'uses' => 'EmailController@sendraw'])->middleware('logined');
		//
		Route::get('/phpexcel', 'PHPExcelController@getIndex')->middleware('logined');
		Route::post('/phpexcel/importCSV', 'PHPExcelController@importCSV')->middleware('logined');
		Route::post('/phpexcel/importExcel', 'PHPExcelController@importExcel')->middleware('logined');
		Route::post('/phpexcel/exportCSV', 'PHPExcelController@exportCSV')->middleware('logined');
		Route::post('/phpexcel/exportExcel', 'PHPExcelController@exportExcel')->middleware('logined');
		// show popup
		Route::get('/popup/employee', 'PopupController@getEmployee')->middleware('logined');
		Route::get('/popup/employee_1on1', 'PopupController@getEmployee1on1')->middleware('logined');
		Route::get('/popup/employee_mulitireview', 'PopupController@getEmployeeMulitireview')->middleware('logined');
		Route::get('/popup/employee_weeklyreport', 'PopupController@getEmployeeWeeklyReport')->middleware('logined');
		Route::get('/popup/employee_employee_information', 'PopupController@getEmployeeInformation')->middleware('logined');
		Route::get('/popup/multiselect_employee', 'PopupController@getMultiSelectEmployee')->middleware('logined');

		Route::post('/popup/multiselect_employee/search', 'PopupController@postSearchMulitiselect')->middleware('logined');
		Route::post('/popup/employee/search', 'PopupController@postSearch')->middleware('logined');
		Route::get('/popup/change_pass', 'PopupController@change_pass')->middleware('logined');
		Route::post('/popup/change_pass/save', 'PopupController@change_pass_save')->middleware('logined');
		Route::get('/popup/change_language', 'PopupController@change_language')->middleware('logined');
		Route::post('/popup/change_language/save', 'PopupController@change_language_save')->middleware('logined');
		Route::get('popup/ri0020', 'PopupController@rI0020')->middleware('logined');
		Route::post('popup/ri0020/save', 'PopupController@rI0020')->middleware('logined');
		Route::post('popup/ri0020/refer', 'PopupController@referDatarI0020')->middleware('logined');
		Route::get('/popup/eq0100_list', 'PopupController@getFilterList')->middleware('logined');
		Route::get('/popup/eq0100', 'PopupController@getFilter')->middleware('logined');
		// refer data
		Route::get('/employeeautocomplete', 'ReferController@employeeautocomplete')->middleware('logined');
		Route::get('/employeeautocomplete1on1', 'ReferController@employeeautocomplete1on1')->middleware('logined');
		Route::get('/employeeautocompleteweeklyreport', 'ReferController@employeeautocompleteWeeklyReport')->middleware('logined');
		Route::get('/employeeautocompletemulitireview', 'ReferController@employeeautocompletemulitireview')->middleware('logined');
		Route::get('/employeeautocompletemulitiselect', 'ReferController@employeeautocompletemulitiselect')->middleware('logined');
		Route::post('/loadOrganization', 'ReferController@loadOrganization')->middleware('logined');
		Route::post('/loadStatus', 'ReferController@loadStatus')->middleware('logined');
		Route::post('/loadSheetcd', 'ReferController@loadSheetcd')->middleware('logined');
		Route::post('/load_treatment_applications_no', 'ReferController@loadTreatmentApplicationsNo')->middleware('logined');
		Route::post('/load_times_from_groupcd', 'ReferController@loadTimesFromGroup1on1')->middleware('logined');
		Route::post('/referemployee', 'ReferController@referEmployee')->middleware('logined');
		Route::post('/load_group_from_fiscal_year_1on1', 'ReferController@loadGroupFromFiscalYear1on1')->middleware('logined');
		Route::post('/load_time', 'ReferController@getTimes')->middleware('logined');
		Route::post('/load_month', 'ReferController@getMonths')->middleware('logined');

		//customer
		Route::get('/popup/employeecustomer', 'PopupController@getEmployeeCustomer')->middleware('customer');
		Route::post('/popup/employeecustomer/search', 'PopupController@postSearchCustomer')->middleware('customer');
		Route::get('/employeecustomerautocomplete', 'ReferController@employeeCustomerautocomplete')->middleware('customer');
		Route::post('/loadOrganizationcustomer', 'ReferController@CustomerloadOrganization')->middleware('customer');
		Route::post('/setCachecustomer', 'CommonController@setCachecustomer')->middleware('customer');

		// show popup information
		Route::get('/popup/getinformation', 'PopupController@getInformation')->middleware('logined');
		Route::get('/popup/information', 'PopupController@Information')->middleware('logined');
		Route::post('/popup/information/search', 'PopupController@postSearchInformation')->middleware('logined');

		// show popup question
		Route::get('/popup/question', 'PopupController@Question')->middleware('logined');
		Route::post('/popup/question/search', 'PopupController@postSearchQuestion')->middleware('logined');

		// show popup reportquestion
		Route::get('/popup/rquestion/{report_kind}', 'PopupController@reportQuestion')->middleware('logined');
		Route::post('/popup/rquestion/search', 'PopupController@reportQuestion')->middleware('logined');
		Route::get('/popup/document', 'PopupController@getDocument');
		// Route::post('/popup/downloaddocument', 'PopupController@downloadDocument')->middleware('logined');
		Route::get('/popup/get_organization', 'PopupController@getOrganization')->middleware('logined');
		// settting meeting
		Route::get('/popup/settingmetting', 'PopupController@settingMeeting')->middleware('logined');
		Route::post('/popup/save-setting-metting', 'PopupController@saveSettingMeeting')->middleware('logined');
		Route::post('/popup/delete-setting-metting', 'PopupController@deleteSettingMeeting')->middleware('logined');
		Route::post('/popup/send-meeting-mail', 'PopupController@sendMeetingMail')->middleware('logined');

		// show popup purpose (マイパーパス登録)
		Route::get('/popup/purpose/{mode}', 'PopupController@myPurpose')->middleware('logined');
		Route::post('/popup/purpose', 'PopupController@myPurpose')->middleware('logined');

		//2021/05/17
		Route::get('/popup/getEmployeeComprehensiveManager', 'PopupController@getEmployeeComprehensiveManager')->middleware('logined');
		Route::post('/popup/postSearchEmployeeComprehensiveManager', 'PopupController@postSearchEmployeeComprehensiveManager')->middleware('logined');
		// check redirect url
		Route::post('/redirect', 'CommonController@postRedirectScreen')->middleware('logined');
		// send mail popup
		Route::post('/sendmailpopup', 'ReferController@sendMailPopup')->middleware('logined');
		// show popup sticky (付箋)
		Route::get('/popup/sticky', 'PopupController@sticky')->middleware('logined');
		Route::post('/popup/sticky', 'PopupController@sticky')->middleware('logined');
		// show popup comment (コメント)
		Route::get('/popup/comment', 'PopupController@comment')->middleware('logined');
		// show popup report_share (週報共有)
		Route::get('/popup/reportEmployee', 'PopupController@shareEmployeeReport')->middleware('logined');
		Route::post('/popup/reportEmployee', 'PopupController@shareEmployeeReport')->middleware('logined');
		Route::post('/popup/reportEmployee/share', 'PopupController@shareEmployeeReportShare')->middleware('logined');
		// show popup viewer (閲覧者)
		Route::get('/popup/viewer', 'PopupController@viewerConfirm')->middleware('logined');
		Route::post('/popup/viewer', 'PopupController@viewerConfirm')->middleware('logined');
		// マイパーパス
		Route::get('/popup/my_purpose', 'PopupController@mypurpose')->middleware('logined');
		Route::post('/popup/my_purpose', 'PopupController@mypurpose')->middleware('logined');
		// 差戻しするポップアップ
		Route::get('/popup/reject', 'PopupController@reject')->middleware('logined');
		Route::post('/popup/reject', 'PopupController@reject')->middleware('logined');
		// コメントオプションポップアップ
		Route::get('/popup/comment_options', 'PopupController@commentOptions')->middleware('logined');
		Route::post('/popup/comment_options', 'PopupController@commentOptions')->middleware('logined');
		// 個人データ登録
		Route::get('/popup/ei0200', 'PopupController@ei0200')->middleware('logined');
		Route::post('/popup/ei0200', 'PopupController@ei0200')->middleware('logined');
		// コミュニケ―ションボード
		Route::get('/popup/eq0200_board', 'PopupController@eq0200Board')->middleware('logined');
		Route::post('/popup/eq0200_board', 'PopupController@eq0200Board')->middleware('logined');
	}
);
Route::group(['prefix' => 'customer/common'], function () {
	Route::post('/setCachecustomer', 'CommonController@setCachecustomer')->middleware('customer');
});
