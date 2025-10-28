<?php
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0010Controller
 *
 * 処理概要/process overview   : M0010Controller
 * 作成日/create date   : 2018-06-25 11:37:16
 * 作成者/creater    : viettd
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
use App\Helpers\Dao;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use File;
use Validator;
class M0010Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author viettd
	 * @created at 2018-06-25 11:37:16
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{	
		$data['category'] =	trans('messages.home');
		$data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.office_master');
		$left = $this->getLeftContent($request);
        $res = Dao::executeSql('SPC_M0001_COOPORATE_INQ1', ['company_cd'=>session_data()->company_cd]);
        if((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')){
        	return response()->view('errors.query',[],501);
        }else{
        	return view('BasicSetting::m0010.index', array_merge($data, $left))
            ->with('button',$res[0][0]);
		//return view('BasicSetting::m0010.index',$data);
        }
	}

	/**
	 * Show the application index.
	 * @author tuantv
	 * @created at 2018-08-16 11:37:16
	 * @return void
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
					$params['cre_user']     =   session_data()->user_id;;
					$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0010_ACT1',$params);
					// check exception
					if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
						return response()->view('errors.query',[],501);
					}else if(isset($result[0]) && !empty($result[0])){
						$this->respon['status'] = NG;
						foreach ($result[0] as $temp) {
							array_push($this->respon['errors'], $temp);
						}
					}
					$this->respon['flag_office_cd'] = $result[1][0]['office_cd'];
				}
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();

			}
			return response()->json($this->respon);
		}
	}

	/**
	 * Delete data
	 * @author tuantv
	 * @created at 2018-08-17
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
					$params['cre_user']     =   session_data()->user_id;;//session_data()->user_id;
					$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
					$params['json']         =   $this->respon['data_sql'];
					//
					$result = Dao::executeSql('SPC_M0010_ACT2',$params);
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
	 * search data
	 * @author tuantv
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
			'current_page' => $request->current_page??1,
			'page_size' => 10,
			'company_cd' => session_data()->company_cd, // set for demo
		];
		// $data = $params;
		$data['search_key'] = htmlspecialchars($request->search_key) ?? '';
		$res = Dao::executeSql('SPC_M0010_LST1', $params);
		if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		// render view
		if ( $request->ajax() ){
			return view('BasicSetting::m0010.leftcontent', $data);
		}
		else{
			return $data;
		}		
	}

	/**
	 * refer office cd
	 * @author tuantv
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function referOffice(Request $request)
	{
		$request_all         = $request->all();
        $validator = Validator::make($request_all, [
			'office_cd' => 'integer',
        ]);
		// validate
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['company_cd']   = session_data()->company_cd ?? 0;
		$params['office_cd'] 	= $request->office_cd ?? 0;
		$data = Dao::executeSql('SPC_M0010_INQ1', $params);
		if(isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999'){
				return response()->view('errors.query',[],501);
		}else{
			$result = [
				'status'=>200,
				'data' => $data[0][0],
			];
			return json_encode($result);
		}		
	}
}