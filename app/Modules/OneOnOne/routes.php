<?php

Route::group(
	['prefix' => 'oneonone', 'middleware' => ['logined']],
	function () {
		Route::get('', 'OneOnOneController@index');
		Route::get('odashboard', 'ODashboardController@index');
		Route::get('odashboardmember', 'ODashboardController@getMember');
		Route::get('odashboardadmin', 'ODashboardController@getAdmin');
		// target popup
		Route::get('odashboardmember/popup', 'ODashboardController@getPopup');
		Route::post('odashboardmember/popup/detail', 'ODashboardController@postDetailPopupTarget');
		Route::post('odashboardmember/popup/save', 'ODashboardController@postSavePopupTarget');
		Route::post('odashboardmember/popup/delete', 'ODashboardController@postDeletePopupTarget');
		// coach
		Route::post('odashboard/getleftcoach', 'ODashboardController@postLeftCoachContent');
		Route::post('odashboard/getrightcoach', 'ODashboardController@postRightCoachContent');
		// member
		Route::post('odashboardmember/getlefttimesformember', 'ODashboardController@postLeftTimesForMember');
		Route::post('odashboardmember/getrightmember', 'ODashboardController@postRightMemberContent');
		Route::post('odashboardmember/getlefttargetformember', 'ODashboardController@postLeftTargetForMember');
		// coach
		Route::post('odashboard/getleftadmin', 'ODashboardController@postLeftAdminContent');
		//oM0110
		Route::get('om0110', 'OM0110Controller@getIndex');
		Route::post('om0110/leftcontent', 'OM0110Controller@getLeftContent');
		Route::post('om0110/rightcontent', 'OM0110Controller@getRightContent');
		Route::post('om0110/save', 'OM0110Controller@postSave');
		Route::post('om0110/delete', 'OM0110Controller@postDelete');
		Route::post('om0110/export', 'OM0110Controller@export');
		Route::get('om0110/download', 'OM0110Controller@download');
		Route::post('om0110/import', 'OM0110Controller@import');
		//om0010
		Route::get('om0010', 'OM0010Controller@index');
		Route::post('om0010/upload', 'OM0010Controller@postUpload');
		Route::post('om0010/save', 'OM0010Controller@postSave');
		Route::post('om0010/refer', 'OM0010Controller@postRefer');
		Route::post('om0010/delete', 'OM0010Controller@postDelete');
		//oq0010
		Route::get('oq0010', 'OQ0010Controller@index');
		//om0120
		Route::get('om0120', 'OM0120Controller@index');
		Route::post('om0120/refer', 'OM0120Controller@refer');
		Route::post('om0120/save', 'OM0120Controller@postSave');
		Route::post('om0120/delete', 'OM0120Controller@postDelete');
		//os0020
		Route::get('os0020', 'OS0020Controller@index');
		Route::post('os0020/leftcontent', 'OS0020Controller@getLeftContent');
		Route::post('os0020/rightcontent', 'OS0020Controller@getRightContent');
		Route::post('os0020/save', 'OS0020Controller@postSave');
		Route::post('os0020/delete', 'OS0020Controller@postDelete');
		//os0030
		Route::get('os0030', 'OS0030Controller@getIndex');
		Route::post('os0030/search', 'OS0030Controller@postSearch');
		Route::post('os0030/delete', 'OS0030Controller@postDelete');
		Route::post('os0030/save', 'OS0030Controller@postSave');
		Route::post('os0030/refer_employee', 'OS0030Controller@referEmployee');
		//oi1010
		Route::get('oi1010', 'OI1010Controller@index');
		Route::post('oi1010/refer', 'OI1010Controller@postRefer');
		Route::post('oi1010/save', 'OI1010Controller@postSave');
		Route::post('oi1010/delete', 'OI1010Controller@postDelete');
		//oi2010
		Route::get('oi2010', 'OI2010Controller@index');
		Route::post('oi2010/save', 'OI2010Controller@postSave');
		Route::post('oi2010/listexcel', 'OI2010Controller@listExcel');
		Route::post('oi2010/saveTemporary', 'OI2010Controller@saveTemporary');

		//oq2010
		Route::get('oq2010', 'OQ2010Controller@index');
		Route::post('oq2010/search', 'OQ2010Controller@postSearch');
		Route::post('oq2010/save', 'OQ2010Controller@postSave');
		Route::get('oq2010/popupsetup', 'OQ2010Controller@getPopupSetup');
		//oM0100
		Route::get('om0100', 'OM0100Controller@index');
		Route::post('om0100/save', 'OM0100Controller@postSave');
		Route::post('om0100/del', 'OM0100Controller@postDelete');
		Route::post('om0100/refer', 'OM0100Controller@referData');
		//OM0200
		Route::get('om0200', 'OM0200Controller@index');
		Route::post('om0200/postleft', 'OM0200Controller@postLeft');
		Route::post('om0200/refer', 'OM0200Controller@postRefer');
		Route::post('om0200/save', 'OM0200Controller@postSave');
		Route::post('om0200/delete', 'OM0200Controller@postDelete');
		//oM0300
		Route::get('om0300', 'OM0300Controller@index');
		Route::post('om0300/leftcontent', 'OM0300Controller@getLeftContent');
		Route::post('om0300/rightcontent', 'OM0300Controller@getRightContent');
		Route::post('om0300/save', 'OM0300Controller@postSave');
		Route::post('om0300/del', 'OM0300Controller@postDelete');

		//oM0310
		Route::get('om0310', 'OM0310Controller@index');
		Route::post('om0310/content', 'OM0310Controller@getContent');
		Route::post('om0310/save', 'OM0310Controller@postSave');
		Route::post('om0310/delete', 'OM0310Controller@postDelete');
		//oI1020
		Route::get('oi1020', 'OI1020Controller@index');
		Route::post('oi1020/refer', 'OI1020Controller@postRefer');
		Route::post('oi1020/search', 'OI1020Controller@postSearch');
		Route::post('oi1020/export', 'OI1020Controller@postExport');
		Route::post('oi1020/import', 'OI1020Controller@postImport');
		Route::post('oi1020/save', 'OI1020Controller@postSave');
		Route::post('oi1020/delete', 'OI1020Controller@postDelete');
		//oI1011
		Route::get('oi1011', 'OI1011Controller@index');
		Route::post('oi1011/save', 'OI1011Controller@postSave');
		Route::post('oi1011/del', 'OI1011Controller@postDelete');
		Route::post('oi1011/refer', 'OI1011Controller@postRefer');
		//oQ2030
		Route::get('oq2030', 'OQ2030Controller@index');
		Route::post('oq2030/search', 'OQ2030Controller@postSearch');
		Route::post('oq2030/export-excel', 'OQ2030Controller@postExportExcel');
		//oQ2031
		Route::get('oq2031', 'OQ2031Controller@index');
		Route::post('oq2031/search', 'OQ2031Controller@postSearch');
		Route::post('oq2031/export-excel', 'OQ2031Controller@postExportExcel');
		//oQ2032
		Route::get('oq2032', 'OQ2032Controller@index');
		Route::post('oq2032/search', 'OQ2032Controller@postSearch');
		Route::post('oq2032/export-excel', 'OQ2032Controller@postExportExcel');
		//oq2033
		Route::get('oq2033', 'OQ2033Controller@index');
		Route::post('oq2033/search', 'OQ2033Controller@postSearch');
		Route::post('oq2033/export-excel', 'OQ2033Controller@postExportExcel');
		//oq2020
		Route::get('oq2020', 'OQ2020Controller@index');
		Route::post('oq2020/search', 'OQ2020Controller@postSearch');
		Route::post('oq2020/save', 'OQ2020Controller@postSave');
		//om0400
		Route::get('om0400', 'OM0400Controller@index');
		Route::post('om0400/leftcontent', 'OM0400Controller@getLeftContent');
		Route::post('om0400/rightcontent', 'OM0400Controller@getRightContent');
		Route::post('om0400/save', 'OM0400Controller@postSave');
		Route::post('om0400/del', 'OM0400Controller@postDelete');

		//oq3020
		Route::get('oq3020', 'OQ3020Controller@index');
		Route::post('oq3020/search', 'OQ3020Controller@postSearch');
		Route::post('oq3020/listexcel', 'OQ3020Controller@postListExcel');
		//oi3010
		Route::get('oi3010', 'OI3010Controller@index');
		Route::post('oi3010/save', 'OI3010Controller@postSave');
		//oq3010
		Route::get('oq3010', 'OQ3010Controller@index');
		Route::post('oq3010/save', 'OQ3010Controller@postSave');
		Route::post('oq3010/rightcontent', 'OQ3010Controller@getRightContent');

		// template
		Route::get('/template','TempController@index');
		// マイパーパス一覧
        Route::get('oq9001','\App\Modules\Master\Controllers\Q9001Controller@getIndex');
        Route::post('oq9001/search','\App\Modules\Master\Controllers\Q9001Controller@postSearch');
        Route::post('oq9001/download','\App\Modules\Master\Controllers\Q9001Controller@postDownload');
	}
);
Route::group(
	['prefix' => 'customer/oneonone', 'middleware' => ['logined']],
	function () {
		Route::get('om0110', 'OM0110Controller@getIndex');
		Route::post('om0110/leftcontent', 'OM0110Controller@getLeftContent');
		Route::post('om0110/rightcontent', 'OM0110Controller@getRightContent');
		Route::post('om0110/save', 'OM0110Controller@postSave');
		Route::post('om0110/delete', 'OM0110Controller@postDelete');
		Route::post('om0110/export', 'OM0110Controller@export');
		Route::get('om0110/download', 'OM0110Controller@download');
		Route::post('om0110/import', 'OM0110Controller@import');
		//om0010
		Route::get('om0010', 'OM0010Controller@index');
		Route::post('om0010/upload', 'OM0010Controller@postUpload');
		Route::post('om0010/save', 'OM0010Controller@postSave');
		Route::post('om0010/refer', 'OM0010Controller@postRefer');
		Route::post('om0010/delete', 'OM0010Controller@postDelete');
		Route::get('om0400', 'OM0400Controller@index');
		Route::post('om0400/leftcontent', 'OM0400Controller@getLeftContent');
		Route::post('om0400/rightcontent', 'OM0400Controller@getRightContent');
		Route::post('om0400/save', 'OM0400Controller@postSave');
		Route::post('om0400/del', 'OM0400Controller@postDelete');
	}
);