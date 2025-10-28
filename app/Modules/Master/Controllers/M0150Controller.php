<?php 
/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 09:46:26
 * 作成者/creater              : tannq
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
use Validator;
use Carbon\Carbon;
use File;
use Dao;
class M0150Controller extends Controller
{
	/**
     * Show the application index.
     * @author tannq
     * @created at 2018-06-21 09:46:26
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		// $data = $this->referLeftData($request);
		$data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
		$data['title'] = trans('messages.group_master');
		$data = array_merge($this->referLeftData($request),$this->referRightData($request),$data);
		return view('Master::m0150.index',$data);
	}

	/**
     * 
     * @author tannq
     * @created at 2018-06-21 09:46:26
     * @return \Illuminate\Http\Response
     */
	public function getLeftcontent(Request $request)
	{
		$validator = Validator::make($request->all(), [
            'page' 		=> 'integer',
			'group_nm'  => 'max:20'
        ]);
		// validate Laravel
		if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->group_nm??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		$data = $this->referLeftData($request);
		return view('Master::m0150.leftcontent',$data)->render();	
	}

	/**
     * 
     * @author tannq
     * @created at 2018-06-21 09:46:26
     * @return \Illuminate\Http\Response
     */
	public function getRightcontent(Request $request)
	{
		$data = $this->referRightData($request);
		return view('Master::m0150.rightcontent',$data)->render();	
	}
	/**
     * 
     * @author tannq
     * @created at 2018-06-21 09:46:26
     * @return \Illuminate\Http\Response
     */
	public function postSave(Request $request)
	{
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$params['json']         =   $this->respon['data_sql'];
				$params['cre_user']    	=   session_data()->user_id;
				$params['cre_ip']      	=   $request->ip();
				$params['company_cd']   =   session_data()->company_cd;
				//
				$result = Dao::executeSql('SPC_M0150_ACT1',$params);
				$this->respon['group_cd'] = '';
				// check exception
				if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
					return response()->view('errors.query',[],501);
				}else if(isset($result[0]) && !empty($result[0])){
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$res = $result[1][0] ?? []; 
					$this->respon['group_cd'] =$res['group_cd'];
				}
				
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	
	/**
     * @created at 2018-06-21 09:46:26
     * @return array
     */
	public function referLeftData($request) 
	{
		$validator = Validator::make($request->all(), [
			'page' => 'integer'
		]);
		if ($validator->passes()) {
			$query = Dao::executeSql('SPC_M0150_LST1', [
				'group_nm'   =>SQLEscape($request->group_nm) ?? '',
				'page'       =>$request->page??1,
				'company_cd' =>session_data()->company_cd ?? 0,
			]);
			
			if(!empty($query) && isset($query[0]['error_typ'])) {
				$data = [
					'views'=>[],
					'paging'=>[],
				];
			} else {
				$data['views'] = $query[0] ?? [];
				$data['paging'] = $query[1][0] ?? [];
			}
			return $data;	
		}else{
			return response()->view('errors.query',[],501);
		}
	}

	/**
     * @created at 2018-06-21 09:46:26
     * @return array
     */
	public function referRightData($request) 
	{
		$validator = Validator::make($request->all(), [
			'group_cd' => 'integer'
		]);
		if ($validator->passes()) {
		$query = Dao::executeSql('SPC_M0150_INQ1', [
			'company_cd' =>session_data()->company_cd ?? 0,
			'group_cd'   => preventOScommand($request->group_cd),
        ]);
		
		if(!empty($query) && isset($query[0]['error_typ'])) {
			$data['m0060'] =[];
			$data['m0030'] =[];
			$data['m0040'] =[];
			$data['m0050'] =[];
			$data['m0150'] =[
				'group_cd'=>null,
				'group_nm'=>null,
				'arrange_order'=>null,
			];
		} else {
			$data['m0060'] = $query[0] ?? [];
			$data['m0030'] = $query[1] ?? [];
			$data['m0040'] = $query[2] ?? [];
			$data['m0050'] = $query[3] ?? [];
			$data['m0150'] = $query[4][0] ?? [];
		}
		return $data;	
		}else{
			return response()->view('errors.query',[],501);
		}
	}

	 /**
     * postDelete 
     * @author viettd@ans-asia.com 
     * @created at 2017-10-12 08:13:36
     * @return void
     */
    public function postDelete(Request $request) 
    {
        if($request->ajax()) 
        {
            //return request ajax
            try {
                $params['group_cd']  	=   $request->group_cd ?? '';
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $request->ip();
                $params['company_cd']   =   session_data()->company_cd;
                //
                $result = Dao::executeSql('SPC_M0150_ACT2',$params);
                // check exception
                if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                } else if(isset($result[0]) && !empty($result[0])){
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {                            
                        array_push($this->respon['errors'],$temp);   
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
        // return http request
    }
}