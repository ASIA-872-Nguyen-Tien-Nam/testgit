<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * I1040Controller
 *
 * 処理概要/process overview   : I1040Controller
 * 作成日/create date   : 2018-06-25 02:22:10
 * 作成者/creater    : namnb
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
class I1040Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author namnb 
	 * @created at 2018-06-25 02:22:10
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category']       = trans('messages.process_fiscal_year');
		$data['category_icon']  = 'fa fa-refresh';
		$data['title']          = trans('messages.schedule_setting');
		$refer = $this->postRefer($request);
		if(isset($refer['error_typ']) && $refer['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
		return view('Master::i1040.index',array_merge($data,$refer));
	}
	 /**
	 * get data table
	 * @author datnt
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function postRefer(Request $request)
	{
		$user_id                = session_data()->user_id;
		$cache          		= getCache('i1040',$user_id);
		if($cache){
			$fiscal_year           = $cache['fiscal_year'];
			$period_cd             = $cache['period_cd'];
		}
		deleteCache('i1040',$user_id);
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'fiscal_year' 		=>	$request->fiscal_year ??($fiscal_year??0),
			'period_cd' 		=>	$request->period_cd ?? ($period_cd??0) ,
			'language'			=>  session_data()->language,
		];
		$rules = [
			'fiscal_year' => 'integer', //Must be a number and length of value is 8
			'period_cd' => 'integer', //Must be a number and length of value is 8
		];
		$validator = Validator::make($params, $rules);
		if ($validator->passes()) {
			$data = $params;
			$res = Dao::executeSql('SPC_I1040_FND1', $params);
			$data['period_year'] 	= $res[0][0]??[];
			$data['result'] 		= $res[1] ?? [];
			$data['count'] 			= $res[2][0]['category_count'] ?? 1;
			$data['mess_typ'] 		= getCombobox(11);
			$data['F0010']          = getCombobox('F0010',1); 
			$data['M0101']          = getCombobox('M0101',1); 
			// render view
			if ( $request->ajax() ){
				if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
					return response()->view('errors.query',[],501);
				}
				return view('Master::i1040.refer', $data);
			}
			else{
				if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
					return array('error_typ'=>'999');
				} 
				return $data;
			}
		}else{
			if ( $request->ajax() ){
				return response()->view('errors.query',[],501);
			}else{
				return array('error_typ'=>'999');
			}
		}
	}
	/*
	 * save
	 * @author DATNT
	 * @created at 2018-09-28
	 * @return \Illuminate\Http\Response
	 */
	public function postReferCopy(Request $request)
	{
		if ( $request->ajax() )
		{
			try {
				if($this->respon['status'] == OK)
				{
					$params = [
						'company_cd'    	=> 	session_data()->company_cd,
						'fiscal_year' 		=>	$request->fiscal_year ??0,
						'period_cd' 		=>	$request->period_cd ?? 0 ,
					];
					//
					$rules = [
						'fiscal_year' => 'integer', //Must be a number and length of value is 8
						'period_cd' => 'integer', //Must be a number and length of value is 8
					];
					$validator = Validator::make($params, $rules);
					if ($validator->passes()) {
						$result = Dao::executeSql('SPC_I1040_FND2',$params);
						if(isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999'){
							return response()->view('errors.query',[],501);
						}
						// check exception
						$this->respon['result'] = $result[0][0]??[];
					}else{
						return response()->view('errors.query',[],501);
					}
				}
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();
			}
			return response()->json($this->respon);
		}
	}
	/*
	 * save
	 * @author DATNT
	 * @created at 2018-09-28
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
					$params['json']          =   $this->respon['data_sql'];
					$params['cre_user']      =   session_data()->user_id;
					$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_I1040_ACT1',$params);
					// check exception
					if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
						return response()->view('errors.query',[],501);
					}else if(isset($result[0]) && !empty($result[0])){
						$this->respon['status'] = NG;
						foreach ($result[0] as $temp) {
							array_push($this->respon['errors'], $temp);
						}
					}
					//$this->respon['xxx'] = $params;
				}
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();
			}
			return response()->json($this->respon);
		}
	}
	
}