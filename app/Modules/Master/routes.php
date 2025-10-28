<?php
Route::group(
    ['prefix'=>'master','middleware'=>'logined'],
    function() {
        Route::get('portal','PortalController@getIndex');
        Route::post('portal/indexrefer','PortalController@indexRefer');
        Route::get('portal/evaluator','PortalController@getEvaluator');
        Route::post('portal/evaluatorrefer','PortalController@evaluatorRefer');
        //i1020
        Route::get('i1020','I1020Controller@getIndex');
        Route::post('i1020/save','I1020Controller@postSave');
        Route::post('i1020/refer','I1020Controller@postRefer');
        Route::post('i1020/refertreatment','I1020Controller@postRefertreatment');
        //i1040
        Route::get('i1040','I1040Controller@getIndex');
        Route::post('i1040/refer','I1040Controller@postRefer');
        Route::post('i1040/refercopy','I1040Controller@postReferCopy');
        Route::post('i1040/save','I1040Controller@postSave');
        //i1041
        Route::get('i1041','I1041Controller@getIndex');
        Route::post('i1041/refer','I1041Controller@postRefer');
        Route::post('i1041/save','I1041Controller@postSave');
        Route::post('i1041/del','I1041Controller@postDelete');
        Route::post('i1041/loadStatus','I1041Controller@getStatus');
        //i2010
        Route::get('i2010','I2010Controller@getIndex')->middleware('evaluationpermission');
        Route::get('i2010rate','I2010Controller@getRate');
        Route::get('i2010interview','I2010Controller@getInterview');
        Route::post('i2010/save','I2010Controller@postSave');
        Route::post('i2010/approve','I2010Controller@postApprove');
        Route::post('i2010/approvecomment','I2010Controller@postApproveComment');
        //i2020
        Route::get('i2020','I2020Controller@getIndex')->middleware('evaluationpermission');
        Route::post('i2020/saveData','I2020Controller@postSave');
        Route::post('i2020/comment','I2020Controller@postComment');
        // q2010
        Route::get('q2010','Q2010Controller@getIndex');
        Route::post('q2010/search','Q2010Controller@postSearch');
        Route::post('q2010/copy','Q2010Controller@postCopy');
        Route::post('q2010/listexcel','Q2010Controller@postListExcel');
        Route::post('q2010/excel','Q2010Controller@postExcel');
        Route::post('q2010/excel3','Q2010Controller@postExcel3');
        // i2030
        Route::get('i2030','I2030Controller@getIndex')->middleware('evaluationpermission');
        Route::post('i2030/save','I2030Controller@postSave');
        //i2040
        Route::get('i2040','I2040Controller@getIndex');
        Route::post('i2040/search','I2040Controller@postSearch');
        Route::post('i2040/save','I2040Controller@postSave');
        Route::post('i2040/confirm','I2040Controller@postConfirm');
        Route::post('i2040/savepopup','I2040Controller@postSavePopup');
        Route::post('i2040/export','I2040Controller@postExport');
        Route::post('i2040/import','I2040Controller@postImport');
        Route::post('i2040/canceldecision','I2040Controller@postCancelDecision');
        Route::post('i2040/feedback','I2040Controller@postFeedBack');
        Route::post('i2040/getrank','I2040Controller@postGetRank');
        Route::get('/i2040/label', 'I2040Controller@i2040Label');
		Route::get('/i2040/comment', 'I2040Controller@i2040Comment');
        //m0100
        Route::get('m0100','M0100Controller@getIndex');
        Route::post('m0100/save','M0100Controller@postSave');
        //m0110
        Route::get('m0110','M0110Controller@getIndex');
        Route::post('m0110/save','M0110Controller@postSave');
        Route::post('m0110/del','M0110Controller@postDelete');
        //m0120
        Route::get('m0120','M0120Controller@getIndex');
        //m0130
        Route::get('m0130','M0130Controller@getIndex');
        Route::post('m0130/save','M0130Controller@postSave');
        Route::post('m0130/delete','M0130Controller@postDelete');
        Route::post('m0130/refer','M0130Controller@getTreatment');
        //q0071
        Route::get('q0071','Q0071Controller@getIndex')->middleware('evaluationpermission');
        //q2020
        Route::get('q2020','Q2020Controller@getIndex');
        Route::get('q2020/popup1','Q2020Controller@popup1');
        Route::get('q2020/popup2','Q2020Controller@popup2');
        //Q0070

        Route::get('q0070','Q0070Controller@getIndex');
        Route::post('q0070/referemployee','Q0070Controller@referEmployee');
        Route::post('q0070/outputhistorycsv','Q0070Controller@outputHistoryCsv');
        Route::post('q0070/outputemployeecsv','Q0070Controller@outputEmployeeCsv');
        Route::post('q0070/deletetemp','Q0070Controller@deletetemp');
        Route::post('q0070/search','Q0070Controller@getSearch');
        Route::post('q0070/releasedpass','Q0070Controller@releasedpass');
        Route::post('q0070/sendMail','Q0070Controller@sendMail');
        // M0150
        Route::get('m0150','M0150Controller@getIndex');
        Route::get('m0150/leftcontent','M0150Controller@getLeftcontent');
        Route::get('m0150/rightcontent','M0150Controller@getRightcontent');
        Route::post('m0150/save','M0150Controller@postSave');
        Route::post('m0150/delete','M0150Controller@postDelete');
        //m0170
        Route::get('m0170','M0170Controller@getIndex');
        Route::post('m0170/leftcontent','M0170Controller@getLeftContent');
        Route::post('m0170/refer_sheet_cd','M0170Controller@referSheet');
        Route::post('m0170/save','M0170Controller@postSave');
        Route::post('m0170/delete','M0170Controller@postDelete');
        Route::get('m0170/popup','M0170Controller@popup');
        Route::post('m0170/export','M0170Controller@export');
        Route::get('m0170/download','M0170Controller@download');
        Route::post('m0170/import','M0170Controller@import');
        //m0190
        Route::get('m0190','M0190Controller@getIndex');
        Route::post('m0190/save','M0190Controller@postSave');
        //m0140
        Route::get('m0140','M0140Controller@getIndex');
        Route::post('m0140/leftcontent','M0140Controller@postLeftContent');
        Route::post('m0140/rightcontent','M0140Controller@postRightContent');
        Route::post('m0140/save','M0140Controller@postSave');
        Route::post('m0140/delete','M0140Controller@postDelete');
        //q2030
        Route::get('q2030','Q2030Controller@getIndex');
        Route::post('q2030/refer','Q2030Controller@postRefer');
        Route::post('q2030/search','Q2030Controller@postSearch');
        Route::post('q2030/referdetail','Q2030Controller@postReferDetail');
        Route::post('q2030/export','Q2030Controller@postExport');
        // i1010
        Route::get('i1010','I1010Controller@getIndex');
        Route::post('i1010/refer','I1010Controller@postRefer');
        Route::post('i1010/save','I1010Controller@postSave');
        Route::post('i1010/check','I1010Controller@postCheck');
        //i1030
        Route::get('i1030','I1030Controller@getIndex');
        Route::post('i1030/refer_group','I1030Controller@referGroup');
        Route::post('i1030/refer_emp','I1030Controller@referEmployee');
        Route::post('i1030/save','I1030Controller@postSave');
        Route::post('i1030/search','I1030Controller@postSearch');
        Route::post('i1030/export','I1030Controller@export');
        Route::post('i1030/import','I1030Controller@import');
        Route::post('i1030/apply_latest','I1030Controller@apply_latest');
        Route::post('i1030/empautocomplete', 'I1030Controller@empAutocomplete');
        Route::post('i1030/rate_emp_autocomplete', 'I1030Controller@rateEmpAutocomplete');
        Route::get('i1030/getemployee', 'I1030Controller@getEmployee');
        Route::post('i1030/ogdata', 'I1030Controller@postOgdata');
        Route::post('i1030/ratersearch', 'I1030Controller@raterSearch');
        Route::post('i1030/refergroupwithusetypeone', 'I1030Controller@referGroupWithUseTypOne');
        // M0160
        Route::get('m0160','M0160Controller@getIndex');
        Route::post('m0160/leftcontent','M0160Controller@getLeftContent');
        Route::post('m0160/rightcontent','M0160Controller@getRightContent');
        Route::post('m0160/save','M0160Controller@postSave');
        Route::post('m0160/delete','M0160Controller@postDelete');
        Route::post('/m0160/listrow','M0160Controller@listRow');
        //i2050
        Route::get('i2050','I2050Controller@getIndex');
        Route::post('i2050/search','I2050Controller@postSearch');
        Route::post('i2050/changestatus','I2050Controller@postSave');
        Route::get('s0020','S0020Controller@getIndex');
        Route::post('s0020/leftcontent','S0020Controller@getLeftContent');
        Route::post('s0020/rightcontent','S0020Controller@getRightContent');
        Route::post('s0020/save','S0020Controller@postSave');
        Route::post('s0020/delete','S0020Controller@postDelete');
        Route::get('s0030','S0030Controller@getIndex');
        Route::post('s0030/search','S0030Controller@postSearch');
        Route::post('s0030/delete','S0030Controller@postDelete');
        Route::post('s0030/save','S0030Controller@postSave');
        Route::post('s0030/refer_employee','S0030Controller@referEmployee');
        //
        //BinhNN M0120
        Route::get('m0120','M0120Controller@getIndex');
        Route::get('m0120/refer','M0120Controller@getRefer');
        Route::post('m0120/leftcontent','M0120Controller@getLeftContent');
        Route::post('m0120/rightcontent','M0120Controller@getRightContent');
        Route::post('m0120/save','M0120Controller@postSave');
        Route::post('m0120/delete','M0120Controller@postDelete');
        // マイパーパス一覧
        Route::get('q9001','Q9001Controller@getIndex'); 
        Route::post('q9001/search','Q9001Controller@postSearch');
        Route::post('q9001/download','Q9001Controller@postDownload');
    }
);
Route::group(['prefix'=>'customer/master','middleware'=>['customer']], function(){ // contains check login
    Route::get('q0001','Q0001Controller@getIndex');
    Route::post('q0001/refer','Q0001Controller@postRefer');
    Route::post('q0001/outputcsv','Q0001Controller@outputcsv');
    Route::post('q0001/deletetemp','Q0001Controller@deletetemp');
    Route::get('s0001','S0001Controller@getIndex');
    Route::post('s0001/get-token', 'S0001Controller@directAuth');
    Route::get('s0001/get-token', 'S0001Controller@googleCallback');
    Route::post('s0001/save', 'S0001Controller@postSave');
});
Route::group(['prefix'=>'master','middleware'=>['customer']], function(){ // contains check login
    Route::get('q0001','Q0001Controller@getIndex');
    Route::post('q0001/refer','Q0001Controller@postRefer');
    Route::post('q0001/outputcsv','Q0001Controller@outputcsv');
    Route::post('q0001/deletetemp','Q0001Controller@deletetemp');
    Route::get('m0001','M0001Controller@getIndex')->name('m0001');
    Route::post('m0001/save','M0001Controller@postSave');
    Route::post('m0001/delete','M0001Controller@postDelete');
    Route::post('m0001/leftcontent','M0001Controller@getLeftContent');
    Route::post('m0001/rightcontent','M0001Controller@getRightContent');
    Route::get('m0001/popup/{company_cd?}/{sso_use_typ?}','M0001Controller@popup');
    Route::post('m0001/savepopup','M0001Controller@postSavepopup');
    Route::get('s0001','S0001Controller@getIndex');
    Route::post('s0001/save', 'S0001Controller@postSave');
});
Route::group(['prefix'=>'customer/master','middleware'=>['customer']], function(){
    Route::get('q0001','Q0001Controller@getIndex');
    Route::post('q0001/refer','Q0001Controller@postRefer');
    Route::post('q0001/outputcsv','Q0001Controller@outputcsv');
    Route::post('q0001/deletetemp','Q0001Controller@deletetemp');
    Route::get('m0001','M0001Controller@getIndex')->name('m0001');
    Route::post('m0001/save','M0001Controller@postSave');
    Route::post('m0001/delete','M0001Controller@postDelete');
    Route::post('m0001/leftcontent','M0001Controller@getLeftContent');
    Route::post('m0001/rightcontent','M0001Controller@getRightContent');
    Route::get('m0001/popup/{company_cd?}/{sso_use_typ?}','M0001Controller@popup');
    Route::post('m0001/savepopup','M0001Controller@postSavepopup');
    Route::get('s0001','S0001Controller@getIndex');
});