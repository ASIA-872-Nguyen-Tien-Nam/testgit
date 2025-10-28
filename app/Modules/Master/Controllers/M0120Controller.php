<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0120Controller
 *
 * 処理概要/process overview   : M0120Controller
 * 作成日/create date   : 2018-06-22 03:05:22
 * 作成者/creater    : datnt@ans-asia.com
 * 
 * 更新日/update date    : 2018/09/04
 * 更新者/updater    : binhnn
 * 更新内容 /update content  : all
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
class M0120Controller extends Controller
{
	/**
     * Show the application index.
     * @author datnt@ans-asia.com 
     * @created at 2018-06-22 03:05:22
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
        $data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
		$data['title'] = trans('messages.point_master');
		// render view
		$left = $this->getLeftContent($request);
		if(isset($left['error_typ']) && $left['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
		return view('Master::m0120.index', array_merge($data, $left));
	}

	/**
	 * get left content
	 * @author binhnn
	 * @created at 2018-09-05
	 * @return \Illuminate\Http\Response
	 */
	public function getLeftContent(Request $request)
	{
		$validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'search_key' => 'max:20'
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
			'search_key' => SQLEscape($request->search_key) ?? '',
			'current_page' => $request->current_page??1,
			'page_size' => 10,
			'company_cd' => session_data()->company_cd, // set for demo
		];
		// $data = $params;
		$data['search_key'] = htmlspecialchars($request->search_key) ?? '';
		$res = Dao::executeSql('SPC_M0120_LST1', $params);
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		// render view
		if ( $request->ajax() ){
			if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
				return response()->view('errors.query',[],501);
			}
			return view('Master::m0120.leftcontent', $data);
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
	 * @author binhnn
	 * @created at 2018-09-05
	 * @return \Illuminate\Http\Response
	 */
	public function getRightContent(Request $request)
	{
		if ($request->ajax()){
			$params = [
				'point_kinds' => $request->point_kinds ?? 0,
				'company_cd' => session_data()->company_cd, // set for demo
			];
			$validator = Validator::make($params, [
				'current_page' => 'integer',
				'page_size' => 'integer'
			]);
			if ($validator->passes()) {
				$data = Dao::executeSql('SPC_M0120_INQ1', $params);
				if(isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999'){
					return response()->view('errors.query',[],501);
				}
				//
				return view('Master::m0120.rightcontent')
					->with('data', $data);
				}
			}else{
				return response()->view('errors.query',[],501);
			}
	}
	/**
	 * Save data
	 * @author binhnn
	 * @created at 2018-09-05
	 * @return \Illuminate\Http\Response
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()){
			try {
				$this->valid($request);
				if($this->respon['status'] == OK)
				{
					$params['json']         =   $this->respon['data_sql'];
					$params['cre_user']     =   session_data()->user_id;
					$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0120_ACT1',$params);
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
						$this->respon['point_kinds']     = $result[1][0]['point_kinds'];
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
	 * @author binhnn
	 * @created at 2018-09-05
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		if ($request->ajax()){
			try {
				$params = $request->all();
				$params['cre_user']     =   session_data()->user_id;
				$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
				$params['company_cd']   =   session_data()->company_cd;
				//
				$result = Dao::executeSql('SPC_M0120_ACT2',$params);
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