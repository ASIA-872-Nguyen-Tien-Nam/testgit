<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\ApproverService;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Helpers\UploadCore;
use App\Services\MiraiService;
use App\Services\WeeklyReport\SettingGroupService;
use Validator;
use Dao;

class RI1020Controller extends Controller
{
	private $enclosure  = '"';
	private $delimiter  = ',';
	protected $approverService;
	protected $PersonalTargetService;
	protected $weeklyReportService;
	protected $mirai_service;
	protected $settingGroupService;
	private $lineEnding = PHP_EOL;
	const FROM_ENCODING = 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS';
	const TO_ENCODING = 'UTF-8';
	public function __construct(ApproverService $approverService,WeeklyReportService $weeklyReportService, MiraiService $mirai_service, SettingGroupService $settingGroupService)
	{
		parent::__construct();
		$this->approverService     = $approverService;
		$this->weeklyReportService     = $weeklyReportService;
		$this->mirai_service   = $mirai_service;
		$this->settingGroupService       = $settingGroupService;
	}
     /**
      * Show the application index.
      * @author quangnd@ans-asia.com
      * @created at 2023-02-10 08:30:22
      * @return \Illuminate\Http\Response
      */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.process_fiscal_year');
		$data['category_icon'] = 'fa fa-refresh';
		$data['title'] = trans('ri1020.title');
		$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
		$data['combo_organization'] 	= getCombobox('M0020', 1,5);
		$params['company_cd'] = session_data()->company_cd ?? 0;
		$params['fiscal_year'] =  0;
		$params['report_kind'] = 0;
		$params['group_cd'] = 0;
		$params['detail_no'] = 0;
		$params['lang'] =  session_data()->language ?? 'jp';
		// $data['report_kinds'] = $this->weeklyReportService->getReportKinds($params['company_cd']);
		$data['fiscal_year'] = (int)$this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5);
		$data['count_organization_cd'] 			= 0;
		$data['check_lang'] 				= 'en';
		$data['organization_group_total'] 			= 0;
		$data['report_kinds'] = $this->weeklyReportService->getScheduleSetting($params['company_cd'],0);
		$data['fiscal_year_weekly'] = $this->weeklyReportService->getScheduleSetting($params['company_cd'],1);
		$data['group'] = $this->weeklyReportService->getScheduleSetting($params['company_cd'],4,$data['fiscal_year']);
		return view('WeeklyReport::ri1020.index', array_merge($data));
	}
	/**
     * Search
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
    public function postSearch(Request $request)
    {
		$param_json = $request->json()->all();
		$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        //return request ajax
		$params['json']         =   preventOScommand($json);
		$params['user_id']      =   session_data()->user_id;
		$params['company_cd']   =   session_data()->company_cd;
		$params['mode']   		=   0;
		$result = Dao::executeSql('SPC_RI1020_FND1', $params);
		$data['list']  			= $result[0] ?? NULL;
		$data['paging'] 		= $result[1][0] ?? [];
		$data['sheet'] 			= $result[2] ?? [];
		$data['col'] 			= $result[3] ??[];
		$data['M0022']         	= getCombobox('M0022', 1);
		$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
		$data['fiscal_year'] = (int)$this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5);
        return view('WeeklyReport::ri1020.list_content',$data);
    }
    public function addRow(Request $request)
    {
		$param_json = $request->json()->all();
		$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        //return request ajax
		$params['json']         =   preventOScommand($json);
		$params['user_id']      =   session_data()->user_id;
		$params['company_cd']   =   session_data()->company_cd;
		$params['mode']   		=   0;
		$result = Dao::executeSql('SPC_RI1020_INQ2', $params);
		$data['row']  			= $result[0][0] ?? NULL;
		$data['paging'] 		= $result[1][0] ?? [];
		$data['sheet'] 			= $result[2] ?? [];
		$data['col'] 			= $result[3] ??[];
		$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
		$data['fiscal_year'] = (int)$this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5);
        return view('WeeklyReport::ri1020.result_row_employee',$data);
    }
	public function referOrganization(Request $request)
    {
		try {
            $validator = Validator::make($request->all(), [
				'group_cd'          		=> 'integer',
            ]);
			$params['company_cd']   	=  session_data()->company_cd;
			$params['group_cd']   		=  $request->all()['group_cd'];
			$params['user_id']   		=   session_data()->user_id;
			$params_group['group_cd']   =  $request->all()['group_cd'];
			$params_group['company_cd'] =  session_data()->company_cd;
			$result = Dao::executeSql('SPC_rI1020_INQ1', $params);
			$res = $this->settingGroupService->get($params_group);
			$data['list_organization'] 	=  $result[0][0]??[];

			$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
			$data['check_lang'] 				= 'en';
			$data['combo_organization'] 	= getCombobox('M0020', 1,5);
			$data['count_organization_cd'] 			= 0;
			$data['organization_group_total']['2'] 	= $result[1] ?? null;
			$data['organization_group_total']['3'] 	= $result[2] ?? null;
			$data['organization_group_total']['4'] 	= $result[3] ?? null;
			$data['organization_group_total']['5'] 	= $result[4] ?? null;
			return view('WeeklyReport::ri1020.organization',$data);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
			$data = $this->weeklyReportService->getScheduleSetting(session_data()->company_cd,$request->mode,$request->fiscal_year,$request->report_kind,$request->month);
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
		return response()->view('errors.query', [], 501);
    }
	/**
     * export
     * @author namnt
     * @created at 2023-05-09
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
				$param_json = $request->json()->all();
				$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				//return request ajax
				$params['json']         =   preventOScommand($json);
				$params['user_id']      =   session_data()->user_id;
				$params['company_cd']   =   session_data()->company_cd;
				$params['mode']   		=   1;
				$result = Dao::executeSql('SPC_RI1020_FND1', $params);
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
						$csvname = 'RI1020' . $date . '.csv';
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
				$rename_upload  = 'RI1020_' . time();
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
				$fiscal_year = $request->fiscal_year??0;
				$report_kinds = $request->report_kinds??0;
				$group_cd = $request->group_cd??0;
				$month = $request->month??0;
				$times = $request->times??0;
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
							$params['employee_cd'] = empty($tmp[2]) ? '' : $tmp[2];
							$params['report_kinds'] = $report_kinds;
							$params['month'] = $month;
							$params['times'] = $times;
							// get from csv
							$params['group_cd'] = empty($tmp[0]) ? '' : $tmp[0];
							$params['approver_employee_cd_1'] = empty($tmp[4]) ? '' : $tmp[4];
							$params['approver_employee_cd_2'] = empty($tmp[6]) ? '' : $tmp[6];
							$params['approver_employee_cd_3'] = empty($tmp[8]) ? '' : $tmp[8];
							$params['approver_employee_cd_4'] = empty($tmp[10]) ? '' : $tmp[10];
							
							// get from session
							$params['cre_user']      =   session_data()->user_id;
							$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
							$params['lang']        =  session_data()->language ?? 'jp';
							$result = Dao::executeSql('SPC_RI1020_ACT2', $params);
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
					$csv_name = 'RI1020' . $date . '.csv';
					$file_name = $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csv_name;
					$file_name_return = $this->saveCSVRI1020($error_bag, $file_name);
					if ($file_name_return != '') {
						$this->respon['FileName'] = '/download/' . $file_name_return;
					} else {
						$this->respon['FileName'] = '';
					};
				} else {
					$this->respon['status'] = 200;
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
     * applyLastest
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
	public function applyLastest(Request $request) {
		$param_json = $request->json()->all();
		$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        //return request ajax
		$params['json']         =   preventOScommand($json);
		$params['user_id']      =   session_data()->user_id;
		$params['company_cd']   =   session_data()->company_cd;
		$params['mode']   		=   2;
		$params['json_approval'] = json_encode($request->json()->all()['approval_json']['data_sql']);
		$result = Dao::executeSql('SPC_RI1020_FND1', $params);
		$data['list']  			= $result[0] ?? NULL;
		$data['paging'] 		= $result[1][0] ?? [];
		$data['sheet'] 			= $result[2] ?? [];
		$data['col'] 			= $result[3] ??[];
		$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
        return view('WeeklyReport::ri1020.list_content',$data);
	}
	/**
     * save
     * @author namnt
     * @created at 2023-05-09
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
					$result = Dao::executeSql('SPC_RI1020_ACT1', $params);
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
	/**
     * save
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
	public function postDel(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json']          =   $this->respon['data_sql'];
					$params['cre_user']      =   session_data()->user_id;
					$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']    =   session_data()->company_cd;
					$result = Dao::executeSql('SPC_RI1020_ACT3', $params);
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
	/**
     * referGroup
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
	public function referGroup(Request $request)
	{
		//
			$params['company_cd']   =  session_data()->company_cd;
			$params['group_cd'] 	=  $request->group_cd ?? -1;
			$report_group       = json_encode($params['group_cd'], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			$data          = $this->weeklyReportService->getSchedule($params['company_cd'], $report_group);
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
					if (isset($data[0]['employee_typ_nm'])) {
						$data[0] = implode(array_column($data[0]['employee_typ_nm'], 'employee_typ_nm'), ',');
					}
					if (isset($data[0]['grade_nm'])) {
						$data[0] = implode(array_column($data[0]['grade_nm'], 'grade_nm'), ',');
					}
					if (isset($data[0]['job_nm'])) {
						$data[0] = implode(array_column($data[0]['job_nm'], 'job_nm'), ',');
					}
					if (isset($data[0]['position_nm'])) {
						$data[0] = implode(array_column($data[0]['position_nm'], 'position_nm'), ',');
					}
					if (isset($data[0]['oragnization_nm'])) {
						$data[0] = implode(array_column($data[0]['oragnization_nm'], 'oragnization_nm'), ',');
					}
					$result = [
						'status' => 200,
						'data' => $data
					];
				}
				return json_encode($result);
			}
	}
	/**
     * getParams
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
	public function getParams(Request $request)
    {
		try {
            $validator = Validator::make($request->all(), [
                'report_kind'          	=> 'integer',
				'fiscal_year'          	=> 'integer',
				'mode'          		=> 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
			$data = $this->weeklyReportService->getScheduleSetting(session_data()->company_cd,$request->mode,$request->fiscal_year,$request->report_kind,$request->month,$request->group,$request->detail_no);
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return json_encode($data);
    }
	public function approvalLastest(Request $request) {
		try {
			$param_json = $request->json()->all();
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			//return request ajax
			$params['json']         =   preventOScommand($json);
			$params['user_id']      =   session_data()->user_id;
			$params['company_cd']   =   session_data()->company_cd;
			$params['mode']   		=   2;
			$params['json_approval'] = json_encode($request->json()->all()['approval_json']['data_sql']);
			$result = Dao::executeSql('SPC_RI1020_FND1', $params);
			$data['list']  			= $result[0] ?? NULL;
			$data['paging'] 		= $result[1][0] ?? [];
			$data['sheet'] 			= $result[2] ?? [];
			$data['col'] 			= $result[3] ??[];
			$data['M0022']         	= getCombobox('M0022', 1);
			$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
			return view('WeeklyReport::ri1020.list_content',$data);
		}catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
	}
	public function saveCSVRI1020($data, $file_name)
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

					$this->writeLineRI1020($value, $index, $count);
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
	public function writeLineRI1020($values = null, $index = null, $count = null)
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
}
