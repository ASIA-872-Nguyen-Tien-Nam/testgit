<?php 
/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-15 13:15:26
 * 作成者/creater              : TOINV
 * 
 * 更新日/update date          : 
 * 更新者/updater              : 
 * 更新内容 /update content    : 
 * 
 * 
 * @package         :  BasicSetting
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\BasicSetting\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
use Dao;
class M0050Controller extends Controller
{
	/**
     * Show the application index.
     * @author TOINV
     * @created at 2018-06-15 13:15:26
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.grade_master');
		$sql = Dao::executeSql('SPC_M0050_INQ1', [session_data('company_cd') ?? 0]);
		$data['rows'] = $sql[0] ?? [];
        if(isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
		return view('BasicSetting::m0050.index',$data);
	}

	/**
     * save
     * @author namnb
     * @created at 2018-08-22
     * @return \Illuminate\Http\Response
     */
	public function postSave(Request $request)
	{
		if ( $request->ajax() )
		{
			try {
                $this->valid($request);
                if($this->respon['status'] == OK)
                {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // //
                    $result = Dao::executeSql('SPC_M0050_ACT1',$params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
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