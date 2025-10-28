<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * I1041Controller
 *
 * 処理概要/process overview   : I1041Controller
 * 作成日/create date   : 2018-06-25 02:24:17
 * 作成者/creater    : namnb
 *
 * 更新日/update date    : 2022/08/08
 * 更新者/updater    :	namnt
 * 更新内容 /update content  : target table
 *
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

class I1041Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author namnb
	 * @created at 2018-06-25 02:24:17
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.set');
		$data['category_icon'] = 'fa fa-cogs';
		$data['title']			= trans('messages.email_sending_setting');
		$user_id                = session_data()->user_id;
		$data['cache']          = getCache('i1040', $user_id);
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'category' 			=>	$data['cache']['category']  ?? 0,
			'language'			=>  session_data()->language,
		];
		$refer = $this->postRefer($request);
		if (isset($refer['error_typ']) && $refer['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$res = Dao::executeSql('SPC_I1041_INQ1', $params);

		$data['category_cb'] 		= $res[0] ?? [];
		$data['status_cd_cb'] 		= $res[1] ?? [];
		return view('Master::i1041.index', array_merge($data, $refer));
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
		$cache         			= getCache('i1040', $user_id);
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'category' 			=>	$request->category ?? ($cache['category'] ?? '0'),
			'status_cd' 		=>	$request->status_cd ?? ($cache['status_cd'] ?? '0'),
		];
		$params_refer_target = [
			'company_cd'    	=> 	session_data()->company_cd,
			'category' 			=>	$request->category  ?? 0,
			'language'			=>  session_data()->language,
		];
		//$data = $params;
		$rules = [
			'status_cd' => 'integer', //Must be a number and length of value is 8
			'category' => 'integer', //Must be a number and length of value is 8
		];
		$validator = Validator::make($params, $rules);
		if ($validator->passes()) {
			$res = Dao::executeSql('SPC_I1041_FND1', $params);
			$target = Dao::executeSql('SPC_I1041_INQ1', $params_refer_target);
			$data['L0010']			= $target[2] ?? [];
			$data['result'] 		= $res[0][0] ?? [];
			$check_lang	= session_data()->language;

			// render view
			if ($request->ajax()) {
				if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				}
				if ($params['category'] != '0' && $params['status_cd'] != '' && $params['status_cd'] != '-1') {
					if (!isset($data['result']['notice_message']) || $data['result']['notice_message'] == '') {
						if ($check_lang == 'en') {
							$check_alert = file_exists(resource_path('views/mail_templete/alert_en/alert_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							if ($check_alert) {
								$alert_message = File::get(resource_path('views/mail_templete/alert_en/alert_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							} else {
								$alert_message = '';
							}
							$check_notice = file_exists(resource_path('views/mail_templete/information_en/notice_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							if ($check_notice) {
								$notice_message = File::get(resource_path('views/mail_templete/information_en/notice_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							} else {
								$notice_message = '';
							}
							$data['result']['alert_message'] = $alert_message;
							$data['result']['notice_message'] = $notice_message;
						}
						if ($check_lang != 'en') {
							$check_alert = file_exists(resource_path('views/mail_templete/alert/alert_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							if ($check_alert) {
								$alert_message = File::get(resource_path('views/mail_templete/alert/alert_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							} else {
								$alert_message = '';
							}
							$check_notice = file_exists(resource_path('views/mail_templete/information/notice_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							if ($check_notice) {
								$notice_message = File::get(resource_path('views/mail_templete/information/notice_' . $params['category'] . '_' . $params['status_cd'] . '.blade.php'));
							} else {
								$notice_message = '';
							}
							$data['result']['alert_message'] = $alert_message;
							$data['result']['notice_message'] = $notice_message;
						}
					}
				}
				return view('Master::i1041.refer', $data);
			} else {
				if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
					return array('error_typ' => '999');
				}
				return $data;
			}
		} else {
			if ($request->ajax()) {
				return response()->view('errors.query', [], 501);
			} else {
				return array('error_typ' => '999');
			}
		}
	}
	/**
	 * Show the application index.
	 * @author namnb
	 * @created at 2018-06-25 02:24:17
	 * @return void
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json']          =   $this->respon['data_sql'];
					$params['cre_user']      =   session_data()->user_id;
					$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']    =   session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_I1041_ACT1', $params);
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
	/**
	 * Delete data
	 * @author datnt
	 * @created at 2018-10-04
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		try {
			$params['category']     =   $request->category ?? 0;
			$params['status_cd']    =   $request->status_cd ?? 0;
			$params['cre_user']     =   session_data()->user_id;
			$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
			$params['company_cd']   =   session_data()->company_cd;
			//
			$rules = [
				'status_cd' => 'integer', //Must be a number and length of value is 8
				'category' => 'integer', //Must be a number and length of value is 8
			];
			$validator = Validator::make($params, $rules);
			if ($validator->passes()) {
				$result = Dao::executeSql('SPC_I1041_ACT2', $params);
				// check exception
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				}
			} else {
				return response()->view('errors.query', [], 501);
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * Show the application index.
	 * @author namnb
	 * @created at 2018-06-25 02:24:17
	 * @return \Illuminate\Http\Response
	 */
	public function getStatus(Request $request)
	{
		$user_id                = session_data()->user_id;
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'category' 			=>	$request->category  ?? 0,
			'language'			=>  session_data()->language,
		];
		$validator = Validator::make($request->all(), [
			'category' => 'integer'
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		} else {
			$res = Dao::executeSql('SPC_I1041_INQ1', $params);
			$data['category_cb'] 		= $res[0] ?? [];
			$data['status_cd_cb'] 		= $res[1] ?? [];
			$data['target'] 			= $res[2] ?? [];
			return response()->json($data);
		}
	}
}
