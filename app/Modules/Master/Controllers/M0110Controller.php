<?php
/**
 ****************************************************************************
 * MIRAI
 * M0110Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 07:46:26
 * 作成者/creater              : sondh
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
use Dao;
class M0110Controller extends Controller
{
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-06-21 07:46:26
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
        $data['title'] = trans('messages.level_master');
        $sql = Dao::executeSql('SPC_M0110_INQ1', [session_data('company_cd') ?? 0]);
        if(isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
        $data['rows'] = $sql[0] ?? [];
        return view('Master::m0110.index',$data);
    }

    /**
     * save
     * @author longvv
     * @created at 2018-09-05
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
                    $result = Dao::executeSql('SPC_M0110_ACT1',$params);
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
    /**
     * save
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ( $request->ajax() )
        {
            try {
                $this->valid($request);
                if($this->respon['status'] == OK)
                {
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // //
                    $result = Dao::executeSql('SPC_M0110_ACT2',$params);
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