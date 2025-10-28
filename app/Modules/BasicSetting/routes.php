<?php
//route callback kingoftime api
Route::post('api/basicsetting/a0003/get-kot-access-token','A0003Controller@handleProviderCallback'); 
//      
Route::group(['prefix'=>'basicsetting','middleware'=>['logined']],function() {
        Route::get('sdashboard','SDashboardController@index');
        // sS0020
        Route::get('ss0020','SS0020Controller@index');
        Route::post('ss0020/leftcontent','SS0020Controller@getLeftContent');
        Route::post('ss0020/rightcontent','SS0020Controller@getRightContent');
        Route::post('ss0020/save','SS0020Controller@postSave');
        Route::post('ss0020/delete','SS0020Controller@postDelete');
        // sS0030
        Route::get('ss0030','SS0030Controller@getIndex');
        Route::post('ss0030/search','SS0030Controller@postSearch');
        Route::post('ss0030/delete','SS0030Controller@postDelete');
        Route::post('ss0030/save','SS0030Controller@postSave');
        Route::post('ss0030/refer_employee','SS0030Controller@referEmployee');
        // sm0100
        Route::get('sm0100','SM0100Controller@getIndex');
        Route::post('sm0100/save','SM0100Controller@postSave');

        // M0050
        Route::get('m0050','M0050Controller@getIndex');
        Route::post('m0050/save','M0050Controller@postSave');
        // M0010
        Route::get('m0010','M0010Controller@getIndex');
        Route::post('m0010/save','M0010Controller@postSave');
        Route::post('m0010/delete','M0010Controller@postDelete');
        Route::post('m0010/leftcontent','M0010Controller@getLeftContent');
        Route::post('m0010/refer_office_cd','M0010Controller@referOffice');
        // M0020
        Route::get('m0020','M0020Controller@getIndex');
        Route::post('m0020/save','M0020Controller@postSave');
        Route::post('m0020/leftcontent','M0020Controller@getLeftContent');
        Route::post('m0020/rightcontent','M0020Controller@getRightContent');
        Route::post('m0020/ajaxleft','M0020Controller@getAjaxLeft');
        Route::get('m0020/org','M0020Controller@getOrg');
        Route::post('m0020/saveorg','M0020Controller@saveOrg');
        Route::post('m0020/delete','M0020Controller@postDelete');
        Route::post('m0020/checkemployee','M0020Controller@postCheckEmployee');
        // M0030
        Route::get('m0030','M0030Controller@getIndex');
        Route::get('m0030/refer','M0030Controller@getRefer');
        Route::post('m0030/save','M0030Controller@postSave');
        Route::post('m0030/delete','M0030Controller@postDelete');
        Route::post('m0030/leftcontent','M0030Controller@getLeftContent');
        Route::post('m0030/rightcontent','M0030Controller@getRightContent');
        // M0040
        Route::get('m0040','M0040Controller@getIndex');
        Route::get('m0040/refer','M0040Controller@getRefer');
        Route::post('m0040/save','M0040Controller@postSave');
        Route::post('m0040/delete','M0040Controller@postDelete');
        Route::post('m0040/leftcontent','M0040Controller@getLeftContent');
        Route::post('m0040/rightcontent','M0040Controller@getRightContent');
        // M0060
        Route::get('m0060','M0060Controller@getIndex');
        Route::post('m0060/save','M0060Controller@postSave');
        Route::post('m0060/delete','M0060Controller@postDelete');
        Route::post('m0060/leftcontent','M0060Controller@getLeftContent');
        Route::post('m0060/rightcontent','M0060Controller@getRightContent');
        // M0070
        Route::get('m0070','M0070Controller@getIndex');
        Route::post('m0070','M0070Controller@getIndex');
        Route::post('m0070/refer','M0070Controller@refer');
        Route::post('m0070/postSave','M0070Controller@postSave');
        Route::post('m0070/postSaveLoginInfo','M0070Controller@postSave');
        Route::post('m0070/postSaveEmpInfo','M0070Controller@postSaveEmpInfo');
        Route::post('m0070/leftcontent','M0070Controller@getLeftContent');
        Route::post('m0070/postSaveHeaderInfo','M0070Controller@postSaveEmployeeHeader');
        Route::post('m0070/randompass','M0070Controller@randomPass');
        Route::post('m0070/del','M0070Controller@postDelete');
        Route::post('m0070/del_row','M0070Controller@postDeleteRow');
        Route::post('m0070/getyear','M0070Controller@getYear');
        Route::get('m0070/popup_retired','M0070Controller@getPopupRetired');
        Route::post('m0070/popup/save','M0070Controller@postPopupSave');
        Route::post('m0070/popup/cancel','M0070Controller@postPopupCancel');
        Route::post('m0070/popup/refer','M0070Controller@referPopup');
        Route::post('m0070/pass_notification','M0070Controller@postPassNotification');
        Route::post('m0070/save_01','M0070Controller@postSave01');
        Route::post('m0070/refer_01','M0070Controller@refer01');
        Route::post('m0070/postSaveTab02','M0070Controller@postSaveTab02');
        Route::post('m0070/referTab02','M0070Controller@referTab02');

        Route::post('m0070/postSaveTab03','M0070Controller@postSaveTab03');
        Route::post('m0070/referTab03','M0070Controller@referTab03');

        Route::post('m0070/postSaveTab05','M0070Controller@postSaveTab05');
        Route::post('m0070/referTab05','M0070Controller@referTab05');
        Route::post('m0070/postSaveTab08','M0070Controller@postSaveTab08');
        Route::post('m0070/referTab08','M0070Controller@referTab08');
        Route::post('m0070/postSaveTab09','M0070Controller@postSaveTab09');
        Route::post('m0070/refer_09','M0070Controller@referTab09');
        Route::post('m0070/referTab02','M0070Controller@referTab02');
        Route::post('m0070/referHeader','M0070Controller@referHeader');
        Route::post('m0070/referLoginInfo','M0070Controller@referLoginInfo');
        Route::post('m0070/referEmpInfo','M0070Controller@referEmpInfo');
        Route::post('m0070/referDepartment','M0070Controller@referDepartment');
        Route::post('m0070/postSaveTab13','M0070Controller@postSaveTab13');
        Route::post('m0070/refer_13','M0070Controller@referTab13');
        Route::post('m0070/postSaveTab06','M0070Controller@postSaveTab06');
        Route::post('m0070/refer_06','M0070Controller@referTab06');
        Route::post('m0070/postSaveTab12','M0070Controller@postSaveTab12');
        Route::post('m0070/refer_12','M0070Controller@referTab12');
        Route::post('m0070/postSaveTab07','M0070Controller@postSaveTab07');
        Route::post('m0070/refer_07','M0070Controller@referTab07');
        Route::post('m0070/save_04','M0070Controller@postSaveTab04');
        Route::post('m0070/refer_04','M0070Controller@referTab04');
        Route::post('m0070/postSaveTab11','M0070Controller@postSaveTab11');
        Route::post('m0070/refer_11','M0070Controller@referTab11');
        Route::post('m0070/postSaveTab10','M0070Controller@postSaveTab10');
        Route::post('m0070/refer_10','M0070Controller@referTab10');
        // O0100
        Route::get('o0100','O0100Controller@getIndex');
        Route::post('o0100/export','O0100Controller@export');
        Route::post('o0100/import','O0100Controller@import');
        //api
        Route::get('a0003/requesttokens','APIController@getAuthorizationCode');
        Route::get('a0003/get-access-token','APIController@getAccessToken');
        Route::post('a0003/api','APIController@processApi');
        //A0003
        Route::get('a0003','A0003Controller@getIndex')->name('a0003');
        Route::post('a0003/save','A0003Controller@postSave');
        Route::get('a0003/popup','A0003Controller@popup');
        Route::post('a0003/writeconfig','A0003Controller@writeConfig');
        
        Route::get('a0003/kot-api','A0003Controller@callRedirectKOT');
        Route::post('a0003/api-kot','APIController@processApiKot');
        Route::post('a0003/api-kot-upload','APIController@execApiKotEmployeeUpload');

        //M0080
        Route::get('m0080','M0080Controller@getIndex');
        Route::post('m0080/save','M0080Controller@postSave');
        Route::post('m0080/rightcontent','M0080Controller@getRightContent');
        Route::post('m0080/leftcontent','M0080Controller@getLeftContent');
        Route::post('m0080/del','M0080Controller@postDelete');
        //Q0070
        Route::get('sq0070','\App\Modules\Master\Controllers\Q0070Controller@getIndex');
        Route::post('sq0070/search','\App\Modules\Master\Controllers\Q0070Controller@getSearch');
        // 社員一蘭出力
        Route::post('sq0070/outputemployeecsv','\App\Modules\Master\Controllers\Q0070Controller@outputEmployeeCsv');
        // パスワード一括発行
        Route::post('sq0070/releasedpass','\App\Modules\Master\Controllers\Q0070Controller@releasedpass');
        // パスワード通知      
        Route::post('sq0070/sendMail','\App\Modules\Master\Controllers\Q0070Controller@sendMail');
        // マイパーパス一覧
        Route::get('sq9001','\App\Modules\Master\Controllers\Q9001Controller@getIndex');
        Route::post('sq9001/search','\App\Modules\Master\Controllers\Q9001Controller@postSearch');
        Route::post('sq9001/download','\App\Modules\Master\Controllers\Q9001Controller@postDownload');
});