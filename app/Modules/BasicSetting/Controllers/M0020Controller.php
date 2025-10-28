<?php
/**
 ****************************************************************************
 * MIRAI
 * M0020Controller
 * organization_typ nao thi dien organization_cd den day
 * va dien same_level phu hop.
 * Chua co ban ghi nao thi organization_typ: 1 va same_level = 0,
 * mac dinh khi moi load trang
 * hoac tuong duong voi tao cap 1.
 *
 * 処理概要/process overview   : M0020Controller
 * 作成日/create date          : 2018-08-22 07:46:26
 * 作成者/creater              : SonDH
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
use Dao;
use File;
use Validator;
class M0020Controller extends Controller
{
	private $page_size = 10;
	/**
	 * Show the application index.
	 * @author sondh
	 * @created at 2018-06-25 07:46:26
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{

		$data['category'] = trans('messages.home');
		$data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.organization_master');
		$res = Dao::executeSql('SPC_M0001_COOPORATE_INQ1', ['company_cd'=>session_data()->company_cd]);
		if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
				return response()->view('errors.query',[],501);
		}else{
		// insert default M0022
		Dao::executeSql('SPC_M0020_ACT7', [
			session_data()->user_id,
			$_SERVER['REMOTE_ADDR'],
			session_data()->company_cd
		]);

		$data1 = $this->leftData('', 1);
		if(isset($data1['error_typ']) && $data1['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}else{
			return view('BasicSetting::m0020.index', array_merge($data))
				->with('paging',$data1['paging'])
				->with('button', $res[0][0]);
			}
		}

	}
	public function leftData($key, $current_page)
	{
		$data = Dao::executeSql(
			'SPC_M0020_INQ3',
			[$key, $current_page, $this->page_size, session_data()->company_cd]
		);
		if(isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999'){
			return ['error_typ'=>'999'];
		}else{
			$lvl1 = $data[0] ?? [];
			$lvl2 = $data[1] ?? [];
			$lvl3 = $data[2] ?? [];
			$lvl4 = $data[3] ?? [];
			$lvl5 = $data[4] ?? [];
			$paging = $data[5][0] ?? [];
			$paging = \Paging::show($paging, 1, true);
			return compact('lvl1', 'lvl2', 'lvl3', 'lvl4', 'lvl5', 'paging');
		}

	}
	public function getAjaxLeft(Request $request) {
		$validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'key' => 'max:50'
        ]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		$data = $this->leftData(
			$request->input('key', ''),
			$request->input('current_page', 1)
		);
		if(isset($data['error_typ']) && $data['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}else{
			return response()->json($data);
		}
	}
	public function postCheckEmployee(Request $request)
	{
		$exists = \DB::table('M0070')
			->where('company_cd', session_data()->company_cd)
			->where('employee_cd', $request->input('employee_cd', ''))
			->whereNull('del_datetime')
			->exists();
		return response()->json(compact('exists'));
	}

	public function getRightContent(Request $request)
	{
		$cd = explode('-', $request->input('cd', ''));
		$cd1 = str_replace("|@|","-",$cd[0]) ?? '';
		$cd2 =  str_replace("|@|","-",$cd[1]) ?? '';
		$cd3 =  str_replace("|@|","-",$cd[2]) ?? '';
		$cd4 =  str_replace("|@|","-",$cd[3]) ?? '';
		$cd5 =  str_replace("|@|","-",$cd[4]) ?? '';
		$data = Dao::executeSql(
			'SPC_M0020_INQ4',
			[
				$request->input('organization_typ', 0),
				$cd1,
				$cd2,
				$cd3,
				$cd4,
				$cd5,
				session_data()->company_cd
			]
		);
		$default = [
			'organization_typ' => '0',
			'organization_cd_1' => '',
			'organization_cd_2' => '',
			'organization_cd_3' => '',
			'organization_cd_4' => '',
			'organization_cd_5' => '',
			'organization_nm' => '',
			'organization_ab_nm' => '',
			'responsible_cd' => '0',
			'arrange_order' => '0',
			'employee_nm' => ''
		];
		if(isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}else{
			return response()->json($data[0][0] ?? $default);
		}
	}

	/**
	 * Save data
	 * @author sondh
	 * @created at 2018-08-16
	 * @return \Illuminate\Http\Response
	 */
	public function postSave(Request $request)
	{
		if ( $request->ajax() )
		{
			try {
				if($this->respon['status'] == OK)
				{
					$params['json']         =   json_encode($request->all(),JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
					$params['cre_user']    	=   session_data()->user_id;
					$params['cre_ip']      	=   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0020_ACT5',$params);
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
				if($this->respon['status'] == OK)
				{
					$params['json']         =   json_encode($request->all(),JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
					$params['cre_user']    	=   session_data()->user_id;
					$params['cre_ip']      	=   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0020_ACT6',$params);
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

	public function getOrg(Request $request)
	{
		$res = Dao::executeSql('SPC_M0020_INQ2', ['company_cd'=>session_data()->company_cd]);
		if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}else{
			$data['title'] = '組織名の変更';
			$data['data'] = $res[0] ?? [];
			return view('BasicSetting::m0020.org', $data);
		}
	}

	public function saveOrg(Request $request)
	{
		if ( $request->ajax() )
		{
			try {
				if($this->respon['status'] == OK)
				{
					$params['json']         =   $request->getContent();
					$params['cre_user']    	=   session_data()->user_id;
					$params['cre_ip']      	=   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$empty = false;
					// set error 97
					$error = $this->getErrorPosition($params['json']);
					if (!empty($error['positions'])) {
						$this->respon['status'] = NG;
						foreach ($error['positions'] as $k) {
							$tmp = [
								'message_no' => "97",
								'item' => "#use_typ".($k+1)."+label",
								'order_by' => "0",
								'error_typ' => "0",
								'value1' => "0",
								'value2' => "0",
								'remark' => "organization_group_nm not be in order",
							];
							array_push($this->respon['errors'], $tmp);
						}
					}else{
						$result = Dao::executeSql('SPC_M0020_ACT4',$params);
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
	 * [getErrorPosition description]
	 *
	 * @param  [array] $data [list of organization_group_nm and type]
	 * @return [array]       [where to mark errors, next to use_typ=0]
	 */
	public function getErrorPosition($data) {
		$data = json_decode($data, true);
		$positions = [];

		foreach ($data as $k => $v) {
			if (!isset($data[$k+1])) continue;
			if ($v['use_typ'] === 0 && $data[$k+1]['use_typ'] === 1) {
				array_push($positions, $k+1);
			}
		}
		return compact('data', 'positions');
	}
}