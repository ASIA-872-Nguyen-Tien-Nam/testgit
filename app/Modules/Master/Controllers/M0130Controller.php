<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0130Controller
 *
 * 処理概要/process overview   : M0130Controller
 * 作成日/create date   : 2018-06-22 04:39:03
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
use Validator;
use Carbon\Carbon;
use File;
use Dao;
class M0130Controller extends Controller
{
	/**
     * Show the application index.
     * @author datnt@ans-asia.com 
     * @created at 2018-06-22 04:39:03
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
        $data['title'] = trans('messages.rank_master');
        $params['company_cd']   =   session_data()->company_cd;
        // $result = Dao::executeSql('SPC_M0130_INQ1',$params);
        $combobox = getCombobox('M0102',1);

		return view('Master::m0130.index',array_merge($data, $result=[]))
            ->with('result', [])
            ->with('combobox', $combobox);
	}

    /**
     * refer M0130 from detail_no M0120
     * @param  Request $request [description]
     * @return [type]           [description]
     */
    public function getTreatment(Request $request)
    {
        $params['company_cd'] = session_data()->company_cd;
        $params['detail_no'] = $request->input('detail_no', 0);
        $validator = Validator::make($params, [
            'detail_no' => 'integer'
        ]);
        if ($validator->passes()) {
            $result = Dao::executeSql('SPC_M0130_INQ1', $params);
            if(isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return view('Master::m0130.refer', ['result' => $result[0]]);
        }else{
            return response()->view('errors.query',[],501);
        }
    }

    /**
     * Save data
     * @author sondh
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
                    $params['json']         	=   $this->respon['data_sql'];
                    $params['cre_user']    	    =   session_data()->user_id;
                    $params['cre_ip']      	    =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   	=   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_M0130_ACT1',$params);
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

    /**
     * Delete data
     * @author sondh
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ( $request->ajax() )
        {
            try {
                $params['json']                 =   json_encode($request->all());
                $params['cre_user']     		=   session_data()->user_id;
                $params['cre_ip']       		=   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   		=   session_data()->company_cd;
                //
                $result = Dao::executeSql('SPC_M0130_ACT2',$params);
                // check exception
                if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                }else if(isset($result[0]) && !empty($result[0])){
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
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