<?php
/**
 * @author : mail@gmail.com
 * @Website : http://ans-asia.com
 * @version : 1.0
 * @Build by tannq@ans-asia.com
 * @description: Framework building use Laravel
 * @Created at: 2018-06-26 03:53:04
 */

Route::group(
	['prefix'=>''],
	function() {
		Route::get('sdashboard','SDashboardController@index');
		// Menu
		Route::get('menu','MenuController@index');
		Route::get('menu/rdashboard','MenuController@getChoice');
		// Dashboard 人事評価
		Route::get('dashboard','DashboardController@index');
		Route::post('dashboard/liststatus','DashboardController@liststatus');
		Route::post('dashboard/listemployee','DashboardController@listemployee');
		Route::post('dashboard/updateauthority', 'DashboardController@updateauthority');
		Route::get('dashboardcustomer','DashboardcustomerController@index');
	}
);