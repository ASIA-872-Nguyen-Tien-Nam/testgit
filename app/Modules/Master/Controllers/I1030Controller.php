<?php

/**
 ****************************************************************************
 * 評価者設定
 *
 * 処理概要/process overview   	: I1030Controller
 * 作成日/create date   		: 2018-06-25 03:23:30
 * 作成者/creater    			: viettd
 *
 * 更新日/update date    		:	2021/01/27
 * 更新者/updater    			:	viettd
 * 更新内容 /update content  	:	check validate group_cd ( add isExistedGroupMaster function) 
 *
 *
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    		:  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Master\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use App\Helpers\UploadCore;
use App\L0020;
use Validator;

class I1030Controller extends Controller
{
	private $enclosure  = '"';
	private $delimiter  = ',';
	private $lineEnding = PHP_EOL;
	const FROM_ENCODING = 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS';
	const TO_ENCODING = 'UTF-8';
	/**
	 * Show the application index.
	 * @author viettd
	 * @created at 2018-06-25 03:23:30
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.process_fiscal_year');
		$data['category_icon'] = 'fa fa-refresh';
		$data['title'] = trans('messages.rater_setting');
		$combobox = $this->getCombobox();
		$rater = $this->getRater();
		$data['Rater'] = $rater['data'];
		$data['sheetX'] = $rater['sheet'];
		$params['company_cd']  		=  session_data()->company_cd;
		$params['group_cd']		 	= '-1';
		// $data['m0102'] 				= getCombobox('M0102',1)??[];
		$data['M0022'] = getCombobox('M0022', 1) ?? [];
		$data['M0020'] = getCombobox('M0020', 1) ?? [];
		return view('Master::i1030.index', array_merge($data, $combobox));
	}
	/*
	 * getRater
	 * @author tuantv
	 * @created at 2018-09-26
	 * @return \Illuminate\Http\Response
	 */
	public function getRater()
	{
		$res = Dao::executeSql('SPC_I1030_INQ1', array(session_data()->company_cd, 0));
		//
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			// return 501 error
			return response()->view('errors.query', [], 501);
		} else {
			$data 		= $res[3][0] ?? [];
			$sheet = $res[2] ?? [];
			return compact('data', 'sheet');
		}
	}
	/*
	 * getCombobox
	 * @author tuantv
	 * @created at 2018-09-26
	 * @return \Illuminate\Http\Response
	 */
	public function getCombobox()
	{
		$data = [];
		$res = Dao::executeSql('SPC_I1030_INQ1', array(session_data()->company_cd, 0));
		//
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			// return 501 error
			return response()->view('errors.query', [], 501);
		} else {
			$data['combo_year'] = $res[0] ?? [];
			$data['combo_group'] = $res[1] ?? [];
			return $data;
		}
	}
	/**
	 * refer sheet group
	 * @author tuantv
	 * @created at 2018-09-26
	 * @return \Illuminate\Http\Response
	 */
	public function referGroup(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'group_cd' => 'integer'
		]);
		//
		if ($validator->fails()) {
			return response()->json('Error', 501);
		} else {
			$params['company_cd']   =  session_data()->company_cd;
			$params['group_cd'] 	=  (int)$request->group_cd ?? -1;
			$data = Dao::executeSql('SPC_I1030_INQ2', $params);
			if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
				// return 501 error
				return response()->view('errors.query', [], 501);
			} else {
				// edited by viettd 2020/07/21
				if (
					empty($data[0])
					&&	empty($data[1])
					&&	empty($data[2])
					&&	empty($data[3])
				) {
					$result = [
						'status' => 202,
						'nodata' => L0020::getText(21)->message
					];
				} else {
					if (isset($data[0])) {
						$data[0] = implode(',',array_column($data[0], 'employee_typ_nm'));
					}
					if (isset($data[1])) {
						$data[1] = implode(',',array_column($data[1], 'job_nm'));
					}
					if (isset($data[2])) {
						$data[2] = implode(',',array_column($data[2], 'position_nm'));
					}
					if (isset($data[3])) {
						$data[3] = implode(',',array_column($data[3], 'grade_nm'));
					}
					$result = [
						'status' => 200,
						'data' => $data
					];
				}
				return json_encode($result);
			}
		}
	}
	/**
	 * search employee
	 * @author tuantv
	 * @created at 2018-09-26
	 * @return \Illuminate\Http\Response
	 */
	public function postSearch(Request $request)
	{
		if ($request->ajax()) {
			$param_json = $request->json()->all() ?? [];
			if (count($param_json) == 0) {
				$param_json['fiscal_year']                      = date('Y');
				$param_json['group_cd']                   		= -1;
				$param_json['ck_search']                   		= 0;
				$param_json['list_treatment_applications_no']   = [];
				$param_json['list_organization_step1']          = [];
				$param_json['list_organization_step2']          = [];
				$param_json['list_organization_step3']          = [];
				$param_json['list_organization_step4']          = [];
				$param_json['list_organization_step5']          = [];
				$param_json['page']                   			= 1;
				$param_json['page_size']                   		= 20;
			}
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			if (!validateJsonFormat($json)) {
				return response()->view('errors.query', [], 501);
			} else {
				$params['json']         =   preventOScommand($json);
				$params['user_id']      =   session_data()->user_id;
				$params['company_cd']   =   session_data()->company_cd;
				$params['mode']			=	0;	// 0.search
				//
				$result = Dao::executeSql('SPC_I1030_FND1', $params);
				$res_sheet =  Dao::executeSql('SPC_I1030_INQ1', array(session_data()->company_cd, $param_json['fiscal_year']));
				//
				if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
					// return 501 error
					return response()->view('errors.query', [], 501);
				} else if (isset($res_sheet[0][0]['error_typ']) && $res_sheet[0][0]['error_typ'] == '999') {
					// return 501 error
					return response()->view('errors.query', [], 501);
				} else {
					$data['list']  			= $result[0] ?? NULL;
					$data['check'] 			= $result[1] ?? NULL;
					$data['res_treatment'] 	= $result[2] ?? NULL;
					$data['sheet'] 			= $res_sheet[2] ?? NULL;
					$data['Rater'] 			= $result[3][0] ?? [];
					$data['paging'] 		= $result[4][0] ?? [];
					$data['M0022']         	= getCombobox('M0022', 1);
					//return request ajax
					return view('Master::i1030.list_content', $data);
				}
			}
		}
	}
	/**
	 * [employeeautocomplete screen i1030]
	 * @author tuantv
	 * @created at 2018-10-09 07:46:26
	 * @param  [type] $path_file [description]
	 * @param  [type] $options   [description]
	 * @return [type]            [description]
	 */
	public function rateEmpAutocomplete(Request $request)
	{
		$request_all         = $request->all();
		$validator = Validator::make($request_all, [
			'fiscal_year' => 'integer'
		]);
		// validate
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// 
		if (!validateCommandOSArray($request_all)) {
			return response()->view('errors.query', [], 501);
		}
		try {
			$params = [
				'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
				'company_cd'        => session_data()->company_cd,
				'user_id'           => session_data()->user_id,
				'fiscal_year'       => $request_all['fiscal_year'] ?? 0,
			];
			$data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
			if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
				// return 501 error
				return response()->view('errors.query', [], 501);
			} else {
				if ($data[0]) {
					foreach ($data[0] as $i => $result) {
						$response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
						$response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
						$response[$i]['id']             = $result['id'];
						$i++;
					}
				}
			}
		} catch (Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json(isset($response) ? $response : '');
	}

	/**
	 * raterSearch
	 *
	 * @param  mixed $request
	 * @return void
	 */
	public function raterSearch(Request $request)
	{
		$params = [
			'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
			'company_cd'        => session_data()->company_cd,
			'user_id'           => session_data()->user_id
		];
		$data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
		if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
			// return 501 error
			return response()->view('errors.query', [], 501);
		} else {
			$response = [];
			$employee_cd = $request->employee_cd;
			$cd = $request->cd;
			$nm = $request->nm;
			if ($data[0]) {
				foreach ($data[0] as $i => $result) {
					$response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
					$response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
					$response[$i]['id']             = $result['id'];
					$i++;
				}
			}
			return response()->json(compact('response', 'employee_cd', 'cd', 'nm'));
		}
	}
	/**
	 * [employeeautocomplete screen i1030]
	 * @author tuantv
	 * @created at 2018-10-09 07:46:26
	 * @param  [type] $path_file [description]
	 * @param  [type] $options   [description]
	 * @return [type]            [description]
	 */
	public function empAutocomplete(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'fiscal_year' => 'integer'
			]);
			//
			if ($validator->fails()) {
				return response()->json('Error', 501);
			} else {
				$fiscal_year = $request->fiscal_year;
				if (is_numeric($fiscal_year) == false || $fiscal_year < 1900) {
					$fiscal_year = date('Y');
				}
				$params = [
					'key'               => SQLEscape(preventOScommand($request->key)) ?? '',
					'company_cd'        => session_data()->company_cd,
					'fiscal_year'       => (int)$fiscal_year,
					'user_id'      		=> session_data()->user_id,
					'authority_cd'      => session_data()->authority_cd,
					'authority_typ'     => session_data()->authority_typ,
				];
				$data = Dao::executeSql('SPC_I1030_INQ6', $params);
				if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
					// return 501 error
					return response()->view('errors.query', [], 501);
				} else {
					if ($data[0]) {
						foreach ($data[0] as $i => $result) {
							$response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
							$response[$i]['value']          = $result['id'];
							$response[$i]['id']             = $result['id'];
							$i++;
						}
					}
				}
			}
		} catch (Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json(isset($response) ? $response : '');
	}
	/*
	 * save
	 * @author tuantv
	 * @created at 2018-09-28
	 * @return \Illuminate\Http\Response
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
					$result = Dao::executeSql('SPC_I1030_ACT1', $params);
					if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					} else if (isset($result[0]) && !empty($result[0])) {
						$res = [
							'status' => NG,
							'errors' => $result[0]
						];
						return response()->json($res);
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
	 * apply_latest
	 * @author tuantv
	 * @created at 2018-11-22
	 * @return \Illuminate\Http\Response
	 */
	public function apply_latest(Request $request)
	{
		if ($request->ajax()) {
			$param_json = $request->json()->all() ?? [];
			if (count($param_json) == 0) {
				$param_json['fiscal_year']                      = date('Y');
				$param_json['group_cd']                   		= -1;
				$param_json['ck_search']                   		= 0;
				$param_json['list_treatment_applications_no']   = [];
				$param_json['list_organization_step1']          = [];
				$param_json['list_organization_step2']          = [];
				$param_json['list_organization_step3']          = [];
				$param_json['list_organization_step4']          = [];
				$param_json['list_organization_step5']          = [];
				$param_json['page']                   			= 1;
				$param_json['page_size']                   		= 20;
			}
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			if (!validateJsonFormat($json)) {
				return response()->view('errors.query', [], 501);
			} else {
				$params['json']         =   preventOScommand($json);
				$params['user_id']      =   session_data()->user_id;
				$params['company_cd']   =   session_data()->company_cd;
				$params['mode']			=	2;	// 2.apply_latest
				//
				$result = Dao::executeSql('SPC_I1030_FND1', $params);
				$res_sheet =  Dao::executeSql('SPC_I1030_INQ1', array(session_data()->company_cd, $param_json['fiscal_year']));
				if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($res_sheet[0][0]['error_typ']) && $res_sheet[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else {
					$data['list']  			= $result[0] ?? NULL;
					$data['check'] 			= $result[1] ?? NULL;
					$data['res_treatment'] 	= $result[2] ?? NULL;
					$data['sheet'] 			= $res_sheet[2] ?? NULL;
					$data['Rater'] 			= $result[3][0] ?? [];
					$data['paging'] 		= $result[4][0] ?? [];
					$data['M0022']         	= getCombobox('M0022', 1);
					//return request ajax
					return view('Master::i1030.list_content', $data);
				}
			}
		}
	}
	/**
	 * export
	 * @author tuantv
	 * @created at 2018-10-03 08:13:36
	 * @return void
	 */
	public function export(Request $request)
	{
		if ($request->ajax()) {
			$param_json = $request->json()->all() ?? [];
			if (count($param_json) == 0) {
				$param_json['fiscal_year']                      = date('Y');
				$param_json['group_cd']                   		= -1;
				$param_json['ck_search']                   		= 0;
				$param_json['list_treatment_applications_no']   = [];
				$param_json['list_organization_step1']          = [];
				$param_json['list_organization_step2']          = [];
				$param_json['list_organization_step3']          = [];
				$param_json['list_organization_step4']          = [];
				$param_json['list_organization_step5']          = [];
			}
			//
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			if (!validateJsonFormat($json)) {
				return response()->view('errors.query', [], 501);
			} else {
				$params['json']         =   preventOScommand($json);
				$params['user_id']      =   session_data()->user_id;
				$params['company_cd']   =   session_data()->company_cd;
				$params['mode']			=	1;	// 0.csv
				//
				$result = Dao::executeSql('SPC_I1030_FND1', $params);
				//$res_sheet =  Dao::executeSql('SPC_I1030_INQ1',array(session_data()->company_cd));
				if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
					$this->respon['status']     = EX;
					$this->respon['Exception']  = $e->getMessage();
					return response()->json($this->respon);
				} else {
					if (empty($result[0])) {
						$this->respon['status']     = NG; // no data
						return response()->json($this->respon);
					} else {
						//
						$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
						$csvname = 'I1030' . $date . '.csv';
						$fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
						$fileNameReturn  = $this->saveCSV($fileName, $result);
						if ($fileNameReturn != '') {
							$this->respon['FileName'] = '/download/' . $fileNameReturn;
						} else {
							$this->respon['FileName'] = '';
						}
					}
					//
					return response()->json($this->respon);
				}
			}
		}
	}
	/**
	 * import
	 * @author tuantv
	 * @created at 2018-10-03 08:13:36
	 * @return void
	 */
	public function import(Request $request)
	{
		try {
			$file = $request->except('_token');
			// rename file upload
			if (isset($file['file'])) {
				ini_set('memory_limit', '-1');
				ini_set('post_max_size', '40M');
				ini_set('upload_max_filesize', '240M');
				$request['rules'] = 'mimes:csv,txt,html';
				$request['folder'] = 'i1030';
				$rename_upload  = 'i1030_' . time();
				$request['rename_upload'] = $rename_upload;
				$upload =  UploadCore::start($request);
				$fileName = $upload['file']['name'];
				$pos = strpos($fileName, ".");
				$checkFormat = substr($fileName, $pos, 4);
				if ($checkFormat != '.csv') {
					$this->respon['status']     = 206;
					$this->respon['message']  = '';
					return response()->json($this->respon);
				}
				if (!$upload['errors'] && isset($upload['file'])) {
					$array = $upload['file'];
					if ($array['status'] !== OK) {
						$this->respon['status'] = NG;
						return response()->json($this->respon);
					}
				}
				$path_file  =  public_path() . $upload['file']['path'];
				$arrData    =   array();
				$arrDataHeader = array();
				$i          =   0;
				$r          =   0;
				$a          =   1;
				// check file exists
				$content    =   file_get_contents($path_file);
				$arraysData =  $this->loadCSV($path_file);
				$arrDataHeader = $arraysData[0];
				if (!mb_detect_encoding($content) || mb_detect_encoding($content, 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS', true) == true) {
					$content = mb_convert_encoding($content, 'UTF-8', 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS');
				}
				$rows = str_getcsv($content, "\n"); //parse the rows
				// check csv is empty
				if (count($rows) < 2) {
					$this->respon['status']     = 202;
					return response()->json($this->respon);
				}
				// get params
				$fiscal_year = $file['fiscal_year'] ?? 0;
				$treatment_applications_no = $file['treatment_applications_no'] ?? '';
				$error_cnt = 0;
				$error_bag = [];
				foreach ($rows as $row) {
					if ($row != '') {
						$tmp            =   explode(',', $row); //parse the items in rows
						if (count($tmp) < 12) {
							$this->respon['status']     = 208;
							return response()->json($this->respon);
						}
						$tmp = str_replace('"', '', $tmp);
						// header $r = 0
						if($r == 0){
							$tmp_error = $tmp;
							$tmp_error[] = trans('messages.error_contents');
							$error_bag[] = 	$tmp_error;
						}
						// body $r > 0
						if ($r > 0) {
							$params['company_cd'] = session_data()->company_cd;
							$params['fiscal_year'] = $fiscal_year;
							$params['treatment_applications_no'] = $treatment_applications_no;
							// get from csv
							$params['group_cd'] = empty($tmp[0]) ? 0 : $tmp[0];;
							$params['employee_cd'] = empty($tmp[2]) ? '' : $tmp[2];
							$params['rater_employee_cd_1'] = empty($tmp[4]) ? '' : $tmp[4];
							$params['rater_employee_cd_2'] = empty($tmp[6]) ? '' : $tmp[6];
							$params['rater_employee_cd_3'] = empty($tmp[8]) ? '' : $tmp[8];
							$params['rater_employee_cd_4'] = empty($tmp[10]) ? '' : $tmp[10];
							// get from session
							$params['cre_user']      =   session_data()->user_id;
							$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
							$result = Dao::executeSql('SPC_I1030_ACT2', $params);
							if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
								return response()->view('errors.query', [], 501);
							}
							$message_errors = '';
							if (isset($result[0]) && !empty($result[0])) {
								$error_cnt++;
								foreach ($result[0] as $temp) {
									$message_errors .= $temp['remark'].$temp['message_content'].'|';
								}
								// add error message into table $error_bag
								$tmp_error = $tmp;
								$tmp_error[] = $message_errors;
								$error_bag[] = 	$tmp_error;	
							}
							// 
							$i++;
						}
					}
					$r++;
				}
				//  check errors
				if ($error_cnt > 0) {
					$this->respon['status'] = 207;
					// log file errors
					$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
					$csv_name = 'I1030' . $date . '.csv';
					$file_name = $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csv_name;
					$file_name_return = $this->saveCSVI1030($error_bag, $file_name);
					if ($file_name_return != '') {
						$this->respon['FileName'] = '/download/' . $file_name_return;
					} else {
						$this->respon['FileName'] = '';
					};
				} else {
					$this->respon['status'] = 200;
				}

				// dd($arraysData)

				// validate
				// $result[0] = $this->validateCSV($arrData);
				//
				// if (isset($result[0][0]['message_no']) && !empty($result[0][0]['message_no'])) {
				// 	$error_sql	=	[];
				// 	$count = count($arrData[0]);
				// 	foreach ($arrData as $key => $value) {
				// 		$error_sql[$key]	=	'';
				// 		foreach ($result[0] as $temp) {
				// 			if ($temp['value2'] == $key) {
				// 				$error_sql[$key] .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
				// 			}
				// 		}
				// 		$arrData[$key][$count]	=	$error_sql[$key];
				// 	}
				// 	$arrError[$a] = $arrData;
				// 	$a++;
				// }




				// if (!empty($arrError) && $error <= 0) {
				// 	$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
				// 	$csvname = 'I1030' . $date . '.csv';
				// 	$fileNameError =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
				// 	array_push($arrDataHeader, "エラー");
				// 	$arrCheckError = array();
				// 	$arrCheckError[0] =  $arrDataHeader;
				// 	foreach ($arrError[1] as $key => $value) {
				// 		$arrCheckError[$key + 1] = $value;
				// 	}
				// 	$fileNameReturn  = $this->saveCSV_error($fileNameError, $arrCheckError);
				// 	$this->respon['FileName'] = '/download/' . $fileNameReturn;
				// 	$this->respon['status'] = 207;
				// 	$this->respon['result'] = $result;
				// 	$this->respon['data'] = $arrData;
				// } else {
				// 	$this->respon['status']     = 200;
				// 	$this->respon['data_import']  = $arrData;
				// }
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	// /**
	//  * validate import csv data
	//  *
	//  * @param  [type] $arrData [description]
	//  * @return [type]          [description]
	//  */
	// public function validateCSV($arrData)
	// {
	// 	$errors = [];
	// 	$regex = '/^\d+|-1$/';
	// 	foreach ($arrData as $k => $tmp) {
	// 		// check group_cd is not integer
	// 		if (!preg_match($regex, $tmp['group_cd'])) {
	// 			array_push($errors, $this->itemError(11, $k, 'グループコード', 'group_cd', $tmp['group_cd']));
	// 		}
	// 		// check maxlength group_cd
	// 		if (mb_strlen($tmp['group_cd']) > 4) {
	// 			// error 28: グループコード group_cd
	// 			array_push($errors, $this->itemError(28, $k, 'グループコード', 'group_cd', $tmp['group_cd']));
	// 		}
	// 		// check group_cd is not exists
	// 		if (!$this->isExistedGroupMaster(($tmp['group_cd']))) {
	// 			// error 21: グループコード group_cd
	// 			array_push($errors, $this->itemError(21, $k, 'グループコード', 'group_cd', $tmp['group_cd']));
	// 		}
	// 		// check maxlength employee_cd
	// 		if (mb_strlen($tmp['employee_cd']) > 10) {
	// 			// error 28: 社員コード employee_cd
	// 			array_push($errors, $this->itemError(28, $k, '社員コード', 'employee_cd', $tmp['employee_cd']));
	// 		}
	// 	}
	// 	return $errors;
	// }

	// /**
	//  * isExistedGroupMaster
	//  *
	//  * @param  mixed $group_cd
	//  * @return bool  true : existed false : not existed
	//  */
	// private function isExistedGroupMaster($group_cd = 0)
	// {
	// 	// if $group_cd <= 0 return
	// 	if ($group_cd <= 0) {
	// 		return false;
	// 	}
	// 	// get group_cd from master
	// 	$groups = getCombobox('m0150', 1);
	// 	// if groups is empty
	// 	if (empty($groups)) {
	// 		return false;
	// 	}
	// 	// loop groups
	// 	foreach ($groups as $group) {
	// 		if ($group['group_cd'] == $group_cd) {
	// 			return true;
	// 		}
	// 	}
	// 	// 
	// 	return false;
	// }

	// /**
	//  * itemError
	//  *
	//  * @param  int $m
	//  * @param  string $v
	//  * @param  int $r
	//  * @param  int $v3
	//  * @param  string $v4
	//  * @param  int $error_typ
	//  * @return void
	//  */
	// public function itemError($m, $v, $r, $v3 = '', $v4 = '', $error_typ = 1)
	// {
	// 	return [
	// 		'message_no' => $m,
	// 		'item' => '',
	// 		'order_by' => '',
	// 		'error_typ' => $error_typ,
	// 		'value1' => '',
	// 		'value2' => $v,
	// 		'value3' => $v3,
	// 		'value4' => $v4,
	// 		'remark' => $r
	// 	];
	// }
	// /**
	//  * import
	//  * @author tuantv
	//  * @created at 2019-01-02 08:13:36
	//  * @return void
	//  */
	// public function saveCSV_error($file_name, $data)
	// {
	// 	$return = "";
	// 	try {
	// 		if (isset($data)) {
	// 			$this->handle = fopen($file_name, 'w');
	// 			$BOM = "\xEF\xBB\xBF";
	// 			fwrite($this->handle, $BOM);
	// 			//write file
	// 			$count = count($data);
	// 			$index = 1;
	// 			foreach ($data as $item) {
	// 				$value = array_values($item);
	// 				$this->writeLine($value, $index, $count);
	// 				//
	// 				$index = $index + 1;
	// 			}
	// 			//
	// 			fclose($this->handle);
	// 			// dowload fie
	// 			$return = basename($file_name);
	// 		}
	// 	} catch (Exception $e) {
	// 		pr($e);
	// 	}
	// 	return $return;
	// }
	/**
	 * refer sheet group
	 * @author tuantv
	 * @created at 2018-09-26
	 * @return \Illuminate\Http\Response
	 */
	public function referEmployee(Request $request)
	{
		// $params         = $request->all();
		$validator = Validator::make($request->all(), [
			'fiscal_year' 	=> 'integer',	'group_cd'		=> 'integer'
		]);
		//
		if ($validator->fails()) {
			return response()->json('Error', 501);
		} else {
			$fiscal_year = $request->fiscal_year;
			//
			if (is_numeric($fiscal_year) == false || $fiscal_year < 1900) {
				$fiscal_year = date('Y');
			}
			$params['company_cd']   =  session_data()->company_cd;
			$params['fiscal_year'] 	=  (int)$fiscal_year;
			$params['group_cd'] 	=  (int)$request->group_cd;
			$params['employee_cd'] 	=  $request->employee_cd;
			$params['user_id']      =   session_data()->user_id;
			// get json
			$params['list_treatment_applications_no'] = json_encode($request->list_treatment_applications_no, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			//
			$res_sheet =  Dao::executeSql('SPC_I1030_INQ1', array(session_data()->company_cd, $fiscal_year));
			$res = Dao::executeSql('SPC_I1030_INQ3', $params);
			//
			if (isset($res_sheet[0][0]['error_typ']) && $res_sheet[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else {
				//
				$data = view('Master::i1030.result_row_employee')->with([
					'list' => $res[0] ?? NULL,
					'sheet' => $res_sheet[2] ?? NULL,
					'Rater' => $res[3][0] ?? [],
					'M0022' => getCombobox('M0022', 1) ?? [],
				])->render();
				$this->respon['status']   		= 200;
				$this->respon['data']  			= $data;
				$this->respon['check_msg87']  	= $res[0][0]['check_msg87'] ?? NULL;
				return response()->json($this->respon);
			}
		}
	}
	/**
	 * saveCSV
	 * @author longvv@ans-asia.com
	 * @return array
	 * @author BaoNC  update
	 */
	public function saveCSVI1030($data, $file_name)
	{
		try {
			if (isset($data)) {
				$this->data   = $data;
				$this->handle = fopen($file_name, 'w');
				$BOM = "\xEF\xBB\xBF";
				fwrite($this->handle, $BOM);
				$count = count($this->data);
				//fill data to CSV
				$index = 1;
				foreach ($this->data as $row => $item) {
					$value = [];
					$value = array_values($item);

					$this->writeLineI1030($value, $index, $count);
					$index = $index + 1;
				}
				fclose($this->handle);
				$return = basename($file_name);
			}
		} catch (Exception $e) {
			\Log::info($e);
		}
		return $return;
	}
	/**
	 * writeLine
	 * @author duongntt@ans-asia.com
	 * @return array
	 * @author
	 */
	public function writeLineI1030($values = null, $index = null, $count = null)
	{
		if (is_array($values)) {
			// No leading delimiter
			$writeDelimiter = false;
			// Build the line
			$line = '';
			foreach ($values as $element) {
				// Escape enclosures
				$element = str_replace($this->enclosure, $this->enclosure . $this->enclosure, $element);
				// remove delimeter in data
				$element = str_replace(',','', $element);
				$element = html_entity_decode($element);
				$element = '"' . $element . '"';
				// Add delimiter
				if ($writeDelimiter) {
					$line .= $this->delimiter;
				} else {
					$writeDelimiter = true;
				}
				// Add enclosed string
				if (strpos($element, ',') !== false) {
					$line .= $this->enclosure . $element . $this->enclosure;
				} else {
					$line .=  $element;
				}
			}
			// Add line ending
			if ($index != null && $count != null && $count != $index) {
				$line .= $this->lineEnding;
			}
			fwrite($this->handle, $line);
		} else {
			throw new Exception("Invalid data row passed to CSV writer.");
		}
	}

	/**
	 * refer group with treatment_no and use_type = 1 in F0020
	 * @param  integer $fiscal_year
	 * @param  array   $treatment_json
	 * @return array
	 */
	public function referGroupWithUseTypOne(Request $request)
	{
		$fiscal_year = $request->input('fiscal_year', 0);
		$treatment_json = $request->input('treatment_json', '[]');
		$res = Dao::executeSql('SPC_I1030_INQ7', [session_data()->company_cd, $fiscal_year, $treatment_json]);
		return response()->json($res[0]);
	}
}
