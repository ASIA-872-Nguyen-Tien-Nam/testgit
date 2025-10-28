<?php 
/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-25 8:40:26
 * 作成者/creater              : TOINV
 * 
 * 更新日/update date          :	
 * 更新者/updater              : 
 * 更新内容 /update content    : 
 * 
 * 
 * @package         			:  Master
 * @copyright       			:  Copyright (c) ANS-ASIA
 * @version         			:  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
use Dao;
class M0190Controller extends Controller
{
	/**
     * Show the application index.
     * @author TOINV
     * @created at 2018-06-25 8:40:26
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
		$data['title'] 			= trans('messages.status_setting');
		$data['library8']		= getCombobox(8);
		$data['library10']		= getCombobox(10);
		//
		$params['company_cd']  = session_data()->company_cd;
		$params['language']    = session_data()->language;
		$result = Dao::executeSql('SPC_M0190_INQ1',$params);
		if(isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
		$data['data0']					=	$result[0] ?? array();
		$data['data1']					=	$result[1] ?? array();
		$data['data2']					=	$result[2] ?? array();
		$data['target_management_typ']	=	$result[3][0]['target_management_typ'] ?? 0;
		//
		return view('Master::m0190.index',$data);
	}
	/**
	 * save
	 * @author viettd 
	 * @created at 2018-09-17
	 * @return void
	 */
	public function postSave(Request $request) 
	{
		if($request->ajax()) 
		{
			//return request ajax
			try {
				$this->valid($request);
				if($this->respon['status'] == OK)
				{
					$params['json']         =   $this->respon['data_sql'];
					$params['cre_user']     =   session_data()->user_id;
					$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0190_ACT1',$params);
					// check exception
					if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
						return response()->view('errors.query',[],501);
					}else if(isset($result[0]) && !empty($result[0])){
						$this->respon['status'] = NG;
						foreach ($result as $temp) {
							array_push($this->respon['errors'],$temp);   
						}
					}else {
    					$this->respon['status'] = OK;
    				}
				}
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();
			}
			return response()->json($this->respon);
		}
	}
}