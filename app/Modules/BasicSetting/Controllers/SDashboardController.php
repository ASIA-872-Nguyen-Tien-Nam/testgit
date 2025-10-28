<?php
namespace App\Modules\BasicSetting\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class SDashboardController extends Controller
{
	/**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-08 06:35:42
     * @return \Illuminate\Http\Response
     */
	public function index(Request $request)
	{
          $data['home_flg']  =   '1';
		$data['title'] = trans('messages.basic_setting_menu');
		return view('BasicSetting::sdashboard.index',$data);
	}

	/**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-08 06:35:42
     * @return void
     */
    public function postSave(Request $request)
    {
    	if($request->ajax())
    	{
    		//return request ajax
    	}
    	// return http request
    }
}