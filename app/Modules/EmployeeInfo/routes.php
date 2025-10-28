<?php
Route::group(['prefix' => 'employeeinfo'], function () {
        // eDashboard
        Route::get('edashboard', 'EDashboardController@index');
        // eS0020
        Route::get('es0020', 'ES0020Controller@index');
        Route::post('es0020/leftcontent', 'ES0020Controller@getLeftContent');
        Route::post('es0020/rightcontent', 'ES0020Controller@getRightContent');
        Route::post('es0020/save', 'ES0020Controller@postSave');
        Route::post('es0020/delete', 'ES0020Controller@postDelete');
        // eS0030
        Route::get('es0030', 'ES0030Controller@getIndex');
        Route::post('es0030/search', 'ES0030Controller@postSearch');
        Route::post('es0030/delete', 'ES0030Controller@postDelete');
        Route::post('es0030/save', 'ES0030Controller@postSave');
        Route::post('es0030/refer_employee', 'ES0030Controller@referEmployee');

        // em0100
        Route::get('em0100', 'EM0100Controller@index');
        Route::post('em0100/save', 'EM0100Controller@postSave');

        // em0030
        Route::get('em0030', 'EM0030Controller@getIndex');
        Route::get('em0030/refer','EM0030Controller@getRefer');
        Route::post('em0030/save','EM0030Controller@postSave');
        Route::post('em0030/delete','EM0030Controller@postDelete');
        Route::post('em0030/leftcontent','EM0030Controller@getLeftContent');
        Route::post('em0030/rightcontent','EM0030Controller@getRightContent');
        //em0030 popup
	Route::get('em0030/popup/training', 'EM0030Controller@training');
	Route::post('em0030/popup/save', 'EM0030Controller@training');
	Route::post('em0030/popup/delete','EM0030Controller@deleteTraining');
        Route::post('em0030/popup/refer','EM0030Controller@referTraining');
        
        // em0020
        Route::get('em0020', 'EM0020Controller@getIndex');
        Route::post('em0020/leftcontent', 'EM0020Controller@getLeftContent');
        Route::post('em0020/rightcontent', 'EM0020Controller@getRightContent');
        Route::post('em0020/save', 'EM0020Controller@postSave');
        Route::post('em0020/delete', 'EM0020Controller@postDelete');
        //em0020 popup
	Route::get('em0020/popup/selection', 'EM0020Controller@selection');
        Route::post('em0020/popup/save', 'EM0020Controller@selection');
        Route::post('em0020/popup/delete', 'EM0020Controller@deleteSelection');

        // eo0100
        Route::get('eo0100', 'EO0100Controller@getIndex');
        Route::post('eo0100/export','EO0100Controller@export');
        Route::post('eo0100/import','EO0100Controller@import');

        // em0010
        Route::get('em0010', 'EM0010Controller@getIndex');
        Route::post('em0010/save','EM0010Controller@postSave');
        Route::post('em0010/leftcontent', 'EM0010Controller@getLeftContent');
        Route::post('em0010/rightcontent', 'EM0010Controller@getRightContent');
        Route::post('em0010/delete', 'EM0010Controller@postDelete');


        // eq0101
        Route::get('eq0101', 'EQ0101Controller@getIndex');
        Route::post('eq0101/refer', 'EQ0101Controller@refer');
        Route::post('eq0101/export-excel', 'EQ0101Controller@postExportExcel');
        // eq0200
        Route::get('eq0200', 'EQ0200Controller@getIndex');
        Route::post('eq0200/get_organization', 'EQ0200Controller@getOrganization');
        Route::post('eq0200/refer_seat', 'EQ0200Controller@referSeat');
        Route::post('eq0200/add_seat', 'EQ0200Controller@addSeat');
        Route::post('eq0200/search', 'EQ0200Controller@search');
        Route::post('eq0200/rightcontent','EQ0200Controller@getEmployees');
        Route::post('eq0200/del_seat','EQ0200Controller@delSeat');
        Route::post('eq0200/export','EQ0200Controller@exportExcel');

        // em0201
        Route::get('em0201', 'EM0201Controller@index');
        Route::post('em0201/save','EM0201Controller@postSave');
        Route::post('em0201/leftcontent', 'EM0201Controller@getLeftContent');
        Route::post('em0201/rightcontent', 'EM0201Controller@getRightContent');
        Route::post('em0201/delete', 'EM0201Controller@postDelete');

        // em0200
        Route::get('em0200', 'EM0200Controller@index');
        Route::post('em0200/save','EM0200Controller@postSave');


        // eq0100
        Route::get('eq0100', 'EQ0100Controller@getIndex');
        Route::post('eq0100/search', 'EQ0100Controller@search');
        Route::post('eq0100/export', 'EQ0100Controller@export');
});
