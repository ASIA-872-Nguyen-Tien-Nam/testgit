<?php

/**
 ****************************************************************************
 * MIRAIC
 * M0140Controller
 *
 * 処理概要/process overview   : M0140Controller
 * 作成日/create date   : 2018-06-22 06:22:17
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
use Dao;

class M0140Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author datnt@ans-asia.com 
	 * @created at 2018-06-22 06:22:17
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category']       = trans('messages.evaluation_master');
		$data['category_icon']  = 'fa fa-server';
		$data['title'] = trans('messages.flow_setting');
		$left = $this->postLeftContent($request);
		$right = $this->postRightContent($request);
		if ((isset($left['error_typ']) && $left['error_typ'] == '999') || (isset($right['error_typ']) && $right['error_typ'] == '999')) {
			return response()->view('errors.query', [], 501);
		}
		return view('Master::m0140.index', array_merge($data, $left, $right));
	}

	/**
	 * get left content
	 * @author namnb
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function postLeftContent(Request $request)
	{
		$validator = Validator::make($request->all(), [
            'current_page'  => 'integer',
			'search_key'    => 'max:20'
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
		//
		$params = [
			'search_key'    => SQLEscape($request->search_key ?? ''),
			'current_page'  => $request->current_page ?? 1,
			'page_size'     => 10,
			'company_cd'    => session_data()->company_cd, // set for demo
			'authority_cd'  => session_data()->authority_cd,
			'authority_typ' => session_data()->authority_typ,
		];
		//
		$data = $params;
		$data['search_key'] = htmlspecialchars($request->search_key) ?? '';
		$res = Dao::executeSql('SPC_M0140_LST1', $params);
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		// render view
		if ($request->ajax()) {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			return view('Master::m0140.leftcontent', $data);
		} else {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return array('error_typ' => '999');
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
	public function postRightContent(Request $request)
	{
		$params = [
			'company_cd'    	=> session_data()->company_cd, // set for demo
			'organization_cd' 	=>	$request->organization_cd ?? '',
			'user_id'  			=> session_data()->user_id,
		];
		$data = $params;
		// $validator = Validator::make($params, [
		// 	'organization_cd' => 'integer'
		// ]);
		$res = Dao::executeSql('SPC_M0140_FND1', $params);
		$data['combo_organization_cd'] 	= getCombobox('M0020', 1);
		$data['organization_group'] = getCombobox('M0022', 1) ?? [];
		$data['result'] 				= $res[0] ?? [];
		$data['combo_position_cd'] 		= $res[1] ?? [];
		$data['Rater'] = $res[2][0] ?? [];
		// render view
		if ($request->ajax()) {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			return view('Master::m0140.rightcontent', $data);
		} else {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return array('error_typ' => '999');
			}
			return $data;
		}
		// if ($validator->passes()) {

		// } else {
		// 	if ($request->ajax()) {
		// 		return response()->view('errors.query', [], 501);
		// 	} else {
		// 		return array('error_typ' => '999');
		// 	}
		// }
	}
	/**
	 * Show the application index.
	 * @author datnt@ans-asia.com 
	 * @created at 2018-06-22 06:22:17
	 * @return void
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json']         =   $this->respon['data_sql'];
					$params['cre_user']     =   session_data()->user_id;
					$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']   =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_M0140_ACT1', $params);
					// check exception
					if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					} else if (isset($result[0]) && !empty($result[0])) {
						$this->respon['status'] = NG;
						foreach ($result[0] as $temp) {
							array_push($this->respon['errors'], $temp);
						}
					}
					if (isset($result[1][0])) {
						$this->respon['position_cd']     = $result[1][0]['position_cd'];
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
	 * Delete data
	 * @author namnb 
	 * @created at 2018-08-16
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		if ($request->ajax()) {
			try {
				if ($this->respon['status'] == OK) {
					$params = [
						'organization_cd' 	=>	$request->organization_cd ?? '',
						'cre_user'     		=>   session_data()->user_id,
						'cre_ip'       		=>   $_SERVER['REMOTE_ADDR'],
						'company_cd'   		=>   session_data()->company_cd,
					];
					//
					$result = Dao::executeSql('SPC_M0140_ACT2', $params);
					// check exception
					if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					} else if (isset($result[0]) && !empty($result[0])) {
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
