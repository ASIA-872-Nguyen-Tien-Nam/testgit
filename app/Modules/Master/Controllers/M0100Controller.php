<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0100Controller
 *
 * 処理概要/process overview   : M0100Controller
 * 作成日/create date   : 2018-06-21 09:18:18
 * 作成者/creater    : datnt@ans-asia.com
 * 
 * 更新日/update date    : 
 * 更新者/updater    : 
 * 更新内容 /update content  : 
 * 
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Dao;
use File;
class M0100Controller extends Controller
{
	/**
     * Show the application index.
     * @author longvv@ans-asia.com 
     * @created at 2018-08-28 09:18:18
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.set');
        $data['category_icon'] = 'fa fa-cogs';
        $data['title'] = trans('messages.usage_settings');
        $params = [
            'company_cd' => session_data()->company_cd
        ];
        $rows = Dao::executeSql('SPC_M0100_INQ1', $params);
        if(isset($rows[0][0]['error_typ']) && $rows[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        } 
        $data['rows'] = $rows[0][0] ?? [];
        $data['row2'] = $rows[1] ?? [];
        $data['row3'] = $rows[2] ?? [];
        $data['row4'] = $rows[3] ?? [];
		return view('Master::m0100.index',$data);
	}

    /**
     * Save data
     * @author longvv 
     * @created at 2018-08-29
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
                    //
                    $result = Dao::executeSql('SPC_M0100_ACT1',$params);
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
        return 'Silent is golden.';
    }
}