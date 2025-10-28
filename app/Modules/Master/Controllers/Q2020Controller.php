<?php 
/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 07:46:26
 * 作成者/creater              : TOINV
 * 
 * 更新日/update date          : 
 * 更新者/updater              : 
 * 更新内容 /update content    : 
 * 
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
class Q2020Controller extends Controller
{
	/**
     * Show the application index.
     * @author TOINV
     * @created at 2018-06-21 07:46:26
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category'] 		= '評価';
		$data['category_icon'] 	= 'fa fa-line-chart';
		$data['title'] 			= '評価一覧';
		return view('Master::q2020.index',$data);
	}

	/**
     * Show the application index.
     * @author TOINV
     * @created at 2018-06-21 07:46:26
     * @return void
     */
	public function popup1(Request $request)
	{
		$data['title'] = '目標管理シート';
		return view('Master::q2020.popup1',$data);
	}
	public function popup2(Request $request)
	{
		$data['title'] = '評価シート';
		return view('Master::q2020.popup2',$data);
	}
}