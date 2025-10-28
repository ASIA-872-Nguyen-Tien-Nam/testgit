<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * I1010Controller
 *
 * 処理概要/process overview   : M0060Controller
 * 作成日/create date   : 2018-07-6 010:044:47
 * 作成者/creater    : datnt
 * 
 * 更新日/update date    : 
 * 更新者/updater    : 
 * 更新内容 /update content  : 
 * 
 * 
 * @package         :  BasicSetting
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\BasicSetting\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Carbon\Carbon;
use File;
use Log;
use Dao;

class M0060Controller extends Controller
{
	/**
     * Show the application index.
     * @author viettd 
     * @created at 2018-06-25 03:01:47
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.employee_classification_master');
        // render view
        $left = $this->getLeftContent($request);
        if(isset($left['error_typ']) && $left['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
        }
		return view('BasicSetting::m0060.index', array_merge($data, $left));
	}

    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'search_key' => 'max:50'
        ]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->search_key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
        $params = [
            'search_key' => SQLEscape($request->search_key??''),
            'current_page' => $request->current_page ?? 1,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        // $data = $params;
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
        $res = Dao::executeSql('SPC_M0060_LST1', $params);
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        // render view
        if ( $request->ajax() ){
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return view('BasicSetting::M0060.leftcontent', $data);
        }
        else{
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return array('error_typ'=>'999');
            } 
            return $data;
        }
    }

    /**
     * get right content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $request_all         = $request->all();
        $validator = Validator::make($request_all, [
            'employee_typ' => 'integer',
        ]);
		// validate
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
        if ( $request->ajax() )
        {       
            $params = [
                'employee_typ' => $request->employee_typ ?? 0,
                'company_cd' => session_data()->company_cd, // set for demo
            ];
            $res = Dao::executeSql('SPC_M0060_INQ1', $params);
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return $res[0][0] ?? [];
        }
    }

    /**
     * Save data
     * @author namnb 
     * @created at 2018-08-16
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
                    $result = Dao::executeSql('SPC_M0060_ACT1',$params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    if(isset($result[1][0])){
                        $this->respon['employee_typ']     = $result[1][0]['employee_typ'];
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
     * @author namnb 
     * @created at 2018-08-16
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
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_M0060_ACT2',$params);
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