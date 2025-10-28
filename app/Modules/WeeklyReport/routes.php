<?php

Route::group(
	['prefix' => 'weeklyreport', 'middleware' => ['logined']],
	function () {
		Route::get('rdashboardreporter', 'RDashboardController@reporter');
		Route::post('rdashboardreporter', 'RDashboardController@reporter');
		Route::get('rdashboardapprover', 'RDashboardController@approver');
		Route::post('rdashboardapprover', 'RDashboardController@approver');
		Route::get('rdashboard', 'RDashboardController@admin');
		Route::post('rdashboard', 'RDashboardController@admin');
		Route::post('rdashboard/read', 'RDashboardController@postRead');
		Route::post('rdashboard/cache', 'RDashboardController@postCache');
		//rs0020
		Route::get('rs0020', 'RS0020Controller@index');
		Route::post('rs0020/leftcontent', 'RS0020Controller@getLeftContent');
		Route::post('rs0020/rightcontent', 'RS0020Controller@getRightContent');
		Route::post('rs0020/save', 'RS0020Controller@postSave');
		Route::post('rs0020/delete', 'RS0020Controller@postDelete');
		//rs0030
		Route::get('rs0030', 'RS0030Controller@getIndex');
		Route::post('rs0030/search', 'RS0030Controller@postSearch');
		Route::post('rs0030/delete', 'RS0030Controller@postDelete');
		Route::post('rs0030/save', 'RS0030Controller@postSave');
		Route::post('rs0030/refer_employee', 'RS0030Controller@referEmployee');
		//rM0020
		Route::get('rm0020', 'RM0020Controller@index');
		Route::post('rm0020/save', 'RM0020Controller@postSave');
		Route::post('rm0020/del', 'RM0020Controller@postDelete');
		Route::post('rm0020/refer', 'RM0020Controller@referData');
		//rm0010
		Route::get('rm0010', 'RM0010Controller@getIndex');
		Route::post('rm0010/save', 'RM0010Controller@postSave');
		//rM0100
		Route::get('rm0100', 'RM0100Controller@getIndex');
		Route::post('rm0100/leftcontent', 'RM0100Controller@getLeftContent');
		Route::post('rm0100/rightcontent', 'RM0100Controller@getRightContent');
		Route::post('rm0100/save', 'RM0100Controller@postSave');
		Route::post('rm0100/delete', 'RM0100Controller@postDelete');
		//rm0010
		Route::get('rm0010', 'RM0010Controller@getIndex');
		Route::post('rm0010/save', 'RM0010Controller@postSave');
		//rm0110
		Route::get('rm0110', 'RM0110Controller@index');
		Route::post('rm0110/refer', 'RM0110Controller@refer');
		Route::post('rm0110/save', 'RM0110Controller@postSave');
		Route::post('rm0110/delete', 'RM0110Controller@postDelete');
		//rm0120
		Route::get('rm0120', 'RM0120Controller@index');
		Route::post('rm0120/save', 'RM0120Controller@postSave');
		Route::post('rm0120/leftcontent', 'RM0120Controller@getLeftContent');
		Route::post('rm0120/rightcontent', 'RM0120Controller@getRightContent');
		Route::post('rm0120/delete', 'RM0120Controller@postDelete');
		//rm0200
		Route::get('rm0200', 'RM0200Controller@index');
		//rm0310
		Route::get('rm0310', 'RM0310Controller@index');
		//ri1010
		Route::get('ri1010', 'RI1010Controller@index');
		Route::post('ri1010/refer', 'RI1010Controller@postRefer');
		Route::post('ri1010/save', 'RI1010Controller@postSave');
		Route::post('ri1010/delete', 'RI1010Controller@postDelete');
		Route::post('ri1010/referGroup', 'RI1010Controller@postReferGroup');
		// マイパーパス一覧
		Route::get('rq9001', '\App\Modules\Master\Controllers\Q9001Controller@getIndex');
		Route::post('rq9001/search', '\App\Modules\Master\Controllers\Q9001Controller@postSearch');
		Route::post('rq9001/download', '\App\Modules\Master\Controllers\Q9001Controller@postDownload');
		//rq2010
		Route::get('rq2010', 'RQ2010Controller@getIndex');
		Route::post('rq2010/search', 'RQ2010Controller@postSearch');
		Route::post('rq2010/delete', 'RQ2010Controller@postDelete');
		Route::post('rq2010/exportCSV', 'RQ2010Controller@exportCSV');
		Route::post('rq2010/getFiscalYear', 'RQ2010Controller@getFiscalYear');
		//rq2020
		Route::get('rq2020', 'RQ2020Controller@getIndex');
		Route::post('rq2020/search', 'RQ2020Controller@postSearch');
		Route::post('rq2020/export', 'RQ2020Controller@export');
		Route::post('rq2020/fiscal', 'RQ2020Controller@fiscal');
		//rq3020
		Route::get('rq3020', 'RQ3020Controller@index');
		Route::post('rq3020/search', 'RQ3020Controller@postSearch');
		Route::post('rq3020/export-excel', 'RQ3020Controller@postExportExcel');
		//ri1011
		Route::get('ri1011', 'RI1011Controller@index');
		Route::post('ri1011/save', 'RI1011Controller@postSave');
		Route::post('ri1011/del', 'RI1011Controller@postDelete');
		Route::post('ri1011/refer', 'RI1011Controller@postRefer');
		//rM0300
		Route::get('rm0300', 'RM0300Controller@index');
		//ri1020
		Route::get('ri1020', 'RI1020Controller@getIndex');
		Route::post('ri1020/search', 'RI1020Controller@postSearch');
		//rq3010
		Route::get('rq3010', 'RQ3010Controller@index');
		Route::post('rq3010/search', 'RQ3010Controller@postSearch');
		Route::post('rq3010/export-excel', 'RQ3010Controller@postExportExcel');
		//rq3030
		Route::get('rq3030', 'RQ3030Controller@index');
		Route::post('rq3030/search', 'RQ3030Controller@postSearch');
		Route::post('rq3030/export-excel', 'RQ3030Controller@postExportExcel');
		//rq2011
		Route::get('rq2011', 'RQ2011Controller@index');
		Route::post('rq2011/leftcontent', 'RQ2011Controller@getLeftContent');
		Route::post('rq2011/rightcontent', 'RQ2011Controller@getRightContent');
		Route::post('rq2011/search', 'RQ2011Controller@postSearch');
		Route::post('rq2011/refer_emp', 'RQ2011Controller@referEmployee');
		Route::post('rq2011/delete', 'RQ2011Controller@postDelete');
		Route::post('rq2011/save', 'RQ2011Controller@postSave');
		//rq3040
		Route::get('rq3040', 'RQ3040Controller@index');
		Route::post('rq3040/search', 'RQ3040Controller@postSearch');
		Route::post('rq3040/export-excel', 'RQ3040Controller@postExportExcel');
		//ri2010
		Route::get('ri2010', 'RI2010Controller@index');
		Route::post('ri2010/save', 'RI2010Controller@postSave');
		Route::post('ri2010/reply', 'RI2010Controller@postReply');
		Route::post('ri2010/comment', 'RI2010Controller@postComment');
		Route::post('ri2010/translate', 'RI2010Controller@postTranslate');
		Route::post('ri2010/right', 'RI2010Controller@loadRight');
		// Route::post('ri2010/confirm', 'RI2010Controller@postConfirm');

		Route::get('ri1021', 'RI1021Controller@index');
		Route::post('ri1021/search', 'RI1021Controller@postSearch');
		Route::post('ri1021/save', 'RI1021Controller@postSave');
		Route::post('ri1021/get_group', 'RI1021Controller@getGroup');
		Route::post('ri1021/export', 'RI1021Controller@export');
		Route::post('/ri1021/import', 'RI1021Controller@import');
		Route::post('/ri1021/delete', 'RI1021Controller@deleteData');
		Route::post('/ri1021/approval_lastest', 'RI1021Controller@approvalLastest');
		Route::post('ri1021/refer_emp', 'RI1021Controller@referEmployee');			
		Route::get('/ri1021/viewerSetting', 'RI1021Controller@viewerSetting');
		Route::post('/ri1021/viewerSetting/search', 'RI1021Controller@viewerSetting');

		Route::post('ri1020/add_row', 'RI1020Controller@addRow');
		// rm0200
		Route::post('rm0200/save', 'RM0200Controller@postSave');
		Route::post('rm0200/leftcontent', 'RM0200Controller@postLeft');
		Route::post('/rm0200/rightcontent', 'RM0200Controller@postRefer');
		Route::post('/rm0200/delete', 'RM0200Controller@postDelete');
		Route::post('rm0300/save', 'RM0300Controller@postSave');
		Route::post('rm0300/rightcontent', 'RM0300Controller@getRightContent');
		Route::post('rm0300/leftcontent', 'RM0300Controller@getLeftContent');
		Route::post('rm0300/delete', 'RM0300Controller@postDelete');
		Route::post('ri1020/search', 'RI1020Controller@postSearch');
		Route::post('ri1020/export', 'RI1020Controller@export');
		Route::post('ri1020/save', 'RI1020Controller@postSave');
		Route::post('ri1020/delete', 'RI1020Controller@postDel');
		Route::post('ri1020/apply_lastest', 'RI1020Controller@applyLastest');
		Route::post('ri1020/refer_group', 'RI1020Controller@referGroup');
		Route::post('/ri1020/get_params', 'RI1020Controller@getParams');
		Route::post('/ri1020/import', 'RI1020Controller@import');
		Route::post('/ri1020/organization', 'RI1020Controller@referOrganization');
		Route::post('/ri1020/approval_lastest', 'RI1020Controller@approvalLastest');
		Route::post('rm0310/save', 'RM0310Controller@postSave');
		Route::post('rm0310/search', 'RM0310Controller@postSearch');
		Route::post('rm0310/delete', 'RM0310Controller@postDelete');
	}
);
// Customer use
Route::group(
	['prefix' => 'customer/weeklyreport', 'middleware' => ['logined']],
	function () {
		//rM0100
		Route::get('rm0100', 'RM0100Controller@getIndex');
		Route::post('rm0100/leftcontent', 'RM0100Controller@getLeftContent');
		Route::post('rm0100/rightcontent', 'RM0100Controller@getRightContent');
		Route::post('rm0100/save', 'RM0100Controller@postSave');
		Route::post('rm0100/delete', 'RM0100Controller@postDelete');
	}
);
