<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * DashboardController
 *
 * 処理概要/process overview   : DashboardcustomerController
 * 作成日/create date   : 2018-06-26 03:53:04
 * 作成者/creater    : mail@gmail.com
 * 
 * 更新日/update date    : 
 * 更新者/updater    : 
 * 更新内容 /update content  : 
 * 
 * 
 * @package         :  Dashboardcustomer
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Dashboard\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
class DashboardcustomerController extends Controller
{
	/**
     * Show the application index.
     * @author mail@gmail.com 
     * @created at 2018-06-26 03:53:04
     * @return \Illuminate\Http\Response
     */
	public function index(Request $request)
	{
		$data['title'] = 'みらいコンサルティング様';
		$data['home_flg'] = '1';
		return view('Dashboard::dashboard.index',$data);
	}

}