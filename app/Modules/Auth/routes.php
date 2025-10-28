<?php 
/**
 * @author : mail@gmail.com  
 * @Website : http://ans-asia.com 
 * @version : 1.0
 * @Build by tannq@ans-asia.com
 * @description: Framework building use Laravel 
 * @Created at: 2017-10-12 06:45:42
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : add router redirect_login 
 */

Route::group(
	['prefix'=>''],
	function() {
		Route::get('','LoginController@getLogin');
		Route::get('login','LoginController@getLogin');
		Route::post('login','LoginController@postLogin');
		Route::get('redirect_login', 'LoginController@redirectLogin');
	}
);

Route::get('logout','LoginController@getLogout')->middleware('logined');
 Route::get('logoutcustomer','LoginCustomerController@getLogoutCustomer')->middleware('customer');

 Route::group(
 	['prefix'=>''],
 	function() {
 		Route::get('logincustomer','LoginCustomerController@getLoginCustomer');
 		Route::post('logincustomer','LoginCustomerController@postLoginCustomer');
 	}
 );
