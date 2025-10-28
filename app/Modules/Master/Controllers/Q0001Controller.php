<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * Q0001Controller
 *
 * 処理概要/process overview   : Q0001Controller
 * 作成日/create date   : 2018-06-25 10:46:22
 * 作成者/creater    : viettd
 * 
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  :  return url encrypted
 * 
 * 更新日/update date    : 2022/02/13
 * 更新者/updater    : namnt
 * 更新内容 /update content  :  fix sql inject
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Master\Controllers;

use App\Helpers\Dao;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use File;
use Validator;
use Illuminate\Support\Facades\Crypt;

class Q0001Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author viettd 
	 * @created at 2018-06-25 10:46:22
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.basic_master');
		$data['category_icon'] = 'fa fa-database';
		$data['title'] = trans('messages.customer_search');
		$data['library_data']  = getCombobox(2, 0);
		// $user_id	= session_data()->user_id;
		// $cache = getCache('q0001',$user_id);

		//$refer = $this->postRefer($request);
		$user_id                		= session_data()->user_id;
		$cache                  		= getCache('q0001', $user_id);
		$data['cache']    				= $cache ?? [];
		deleteCache('q0001', $user_id);
		return view('Master::q0001.index', $data);
	}

	/**
	 * Show the application index.
	 * @author viettd 
	 * @created at 2018-06-25 10:46:22
	 * @return void
	 */
	public function postRefer(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'company_cd' 			=> 'integer',
			'company_nm' 			=> 'max:100',
			'incharge_nm' 			=> 'max:20',
			'contract_attribute' 	=> 'integer',
			'check_account' 		=> 'integer',
			'page' 					=> 'integer',
			'page_size' 			=> 'integer',
		]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// data check os
		$data_os = [
			'company_nm' 	=> $request->company_nm ?? '',
			'incharge_cd' 	=> $request->incharge_cd ?? '',
			'incharge_nm' 	=> $request->incharge_nm ?? '',
			'year_month' 	=> $request->year_month ?? '',
		];
		//  validateCommandOS
		if (!validateCommandOSArray($data_os)) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}

		$params = [
			'company_cd' 			=> $request->company_cd,
			'company_nm' 			=> SQLEscape($request->company_nm ?? ''),
			'incharge_cd' 			=> SQLEscape($request->incharge_cd ?? ''),
			'incharge_nm' 			=> SQLEscape($request->incharge_nm ?? ''),
			'evaluation_contract' 	=> $request->evaluation_contract ?? 0,
			'oneonone_contract' 	=> $request->oneonone_contract ?? 0,
			'multiview_contract' 	=> $request->multiview_contract ?? 0,
			'report_contract' 		=> $request->report_contract ?? 0,
			'check_account' 	    => $request->check_account,
			'year_month' 			=> SQLEscape($request->year_month ?? ''),
			'page' 					=> $request->page ?? 1,
			'page_size' 			=> $request->page_size ?? 10,
			'language'              => session_data()->language,
		];
		$sql = Dao::executeSql('SPC_Q0001_FND1', $params);
		for ($i = 0; $i < sizeof($sql[0]); $i++) {
			$sql[0][$i]['param'] = Crypt::encryptString('{"contract_cd":"' . $sql[0][$i]['contract_cd'] . '","user_id":"' . $sql[0][$i]['user_id'] . '","password":"' . $sql[0][$i]['password'] . '","sso_id":"' . $sql[0][$i]['sso_user'] . '","remember_contract_cd":"1","remember_id":"1"}');
			if ($sql[0][$i]['SSO_use_typ'] == '1') {
				$sql[0][$i]['domain'] = env('DOMAIN_SSO');
			} else {
				$sql[0][$i]['domain'] = env('DOMAIN_NORMAL_LOGIN');
			};
		};
		$data['data'] 			= $sql[0] ?? 0;
		$data['paging'] 		= $sql[1][0] ?? [];
		$data['check_account'] 	= $sql[2][0] ?? [];
		// render view
		if ($request->ajax()) {
			return view('Master::q0001.refer', $data)->render();
		} else {
			return $data;
		}
	}
	/**
	 * outCSV
	 * @author longvv
	 * @created at 2018-09-05
	 * @return \Illuminate\Http\Response
	 */
	public function outputcsv(Request $request)
	{
		try {
			if ($request->ajax()) {
				//return request ajax
				$this->valid($request);
			}
			$params = [
				'json' => $this->respon['data_sql'] ?? 0,
				'language' => session_data()->language,
			];
			$result = Dao::executeSql('SPC_Q0001_RPT1', $params);
			$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
			$csvname = 'Q0001' . $date . '.csv';
			$fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
			$fileNameReturn  = $this->saveCSV($fileName, $result);
			if (!isset($result[0][1]['company_cd'])) {
				$this->respon['status']	=	NG;
			} else if ($fileNameReturn != '') {
				$this->respon['FileName'] = '/download/' . $fileNameReturn;
			} else {
				$this->respon['FileName'] = '';
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * deletetemp
	 * @author longvv@ans-asia.com
	 * @return array
	 */
	public  function deletetemp(Request $request)
	{
		if ($request->ajax()) {
			try {
				$filedownload  = $_SERVER['DOCUMENT_ROOT'] . $request->fileName;
				unlink(mb_convert_encoding($filedownload, 'SJIS', 'UTF-8'));
			} catch (Exception $ex) {
			}
		}
	}
}
