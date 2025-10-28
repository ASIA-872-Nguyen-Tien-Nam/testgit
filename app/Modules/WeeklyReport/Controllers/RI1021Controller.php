<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Helpers\UploadCore;
use App\Services\MiraiService;
use Validator;
use Dao;

class RI1021Controller extends Controller
{
	private $enclosure  = '"';
	private $delimiter  = ',';
	protected $weeklyReportService;
	protected $mirai_service;
	public function __construct(WeeklyReportService $weeklyReportService, MiraiService $mirai_service)
	{
		parent::__construct();
		$this->weeklyReportService     = $weeklyReportService;
		$this->mirai_service   = $mirai_service;
	}
	/**
	 * 
	 * @author namnt
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function index(Request $request)
	{
		$data['title'] = trans('ri1021.viewer_setting');
		$params['company_cd']  = session_data()->company_cd ?? 0;
		$data['fiscal_year_today'] = $this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5) ?? 0;
		$data['fiscal_year']   = $this->weeklyReportService->getScheduleSetting($params['company_cd'], 1) ?? [];
		$data['report_kinds']  = $this->weeklyReportService->getScheduleSetting($params['company_cd'], 0) ?? [];
		//$data['report_group']  = $this->weeklyReportService->getScheduleSetting($params['company_cd'], 4, $data['fiscal_year_today']) ?? [];
		$data['organization_group']    = getCombobox('M0022', 1, 5) ?? [];
		$data['combo_organization']    = getCombobox('M0020', 1, 5) ?? [];
		$data['combo_employee_type']   = getCombobox('M0060', 1, 5) ?? [];
		$data['combo_position']        = getCombobox('M0040', 1, 5) ?? [];
		//dd($data);
		return view('WeeklyReport::ri1021.index', $data);
	}
	/**
	 * Search
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12 
	 * @return void
	 */
	public function postSearch(Request $request)
	{
		$data_request = $request->json()->all()['data_sql'];
		$validator = Validator::make($data_request, [
			'page_size'                                  => 'integer',
			'page'                                       => 'integer',
			'report_kinds'                               => 'integer',
			'fiscal_year'                                => 'integer',
			'report_group'                               => 'integer',
			'employee_typ'                               => 'integer',
			'list_position_cd.*.position_cd'             =>  'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// success
		$params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params['user_id']            =  session_data()->user_id;
		$params['company_cd']         =  session_data()->company_cd;
		$params['mode']				  =	 0;
		$result = Dao::executeSql('SPC_rI1021_FND1', $params);
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['list']                 	=  $result[0] ?? [];
		$data['paging']              	=  $result[1][0] ?? [];
		$data['organization_group']     =  getCombobox('M0022', 1, 5) ?? [];
		if ($request->ajax()) {
			return view('WeeklyReport::ri1021.list_content', $data);
		} else {
			return $data;
		}
	}
	/**
	 * save
	 * @author quangnd
	 * @created at 22023/04/25
	 * @return \Illuminate\Http\Response
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			try {
				$data_request = $request->json()->all();
				$validator = Validator::make($data_request, [
					'report_kinds'                  => 'integer',
					'fiscal_year'                   => 'integer',
					'list_employee.*.employee_cd'    => 'max:10',
					'list_employee.list_viewer_employee_cd.*.viewer_employee_cd'    => 'max:10',
				]);
				if ($validator->fails()) {
					return response()->view('errors.query', [], 501);
				}
				$params['json']          =   json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				$params['cre_user']      =   session_data()->user_id;
				$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
				$params['company_cd']    =   session_data()->company_cd;

				$result =  Dao::executeSql('SPC_rI1021_ACT1', $params);
				// check exception
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
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
	}
	/**
	 * save
	 * @author quangnd
	 * @created at 22023/04/25
	 * @return \Illuminate\Http\Response
	 */
	public function getGroup(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'fiscal_year'          	=> 'integer',
				'report_kind'          	=> 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$company_cd   	 	=   session_data()->company_cd ?? 0;
			$fiscal_year_today 	= 	$this->mirai_service->findFiscalYearFromDate($company_cd, 5) ?? 0;
			$fiscal_year   		=  	$request->fiscal_year ?? $fiscal_year_today;
			$report_kind		= 	$request->report_kind?? 0;
			$result =  $this->weeklyReportService->getScheduleSetting($company_cd, 4, $fiscal_year, $report_kind) ?? [];
			// check exception
			$this->respon['status']           = 200;
			$this->respon['data']             = $result ?? [];
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * export
	 * @author tuantv
	 * @created at 2018-10-03 08:13:36
	 * @return void
	 */
	public function export(Request $request)
	{
		$data_request = $request->json()->all()['data_sql'];
		$validator = Validator::make($data_request, [
			'page_size'                                  => 'integer',
			'page'                                       => 'integer',
			'report_kinds'                               => 'integer',
			'fiscal_year'                                => 'integer',
			'report_group'                               => 'integer',
			'employee_typ'                               => 'integer',
			'list_position_cd.*.position_cd'             =>  'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// success
		$params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params['user_id']            =  session_data()->user_id;
		$params['company_cd']         =  session_data()->company_cd;
		$params['mode']				  =	 1;
		$result = Dao::executeSql('SPC_rI1021_FND1', $params);
		if (empty($result[0]) | count($result[0]) == 1) {
			$this->respon['status']     = NG; // no data
			return response()->json($this->respon);
		}
		//
		$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
		$csvname = 'rI2021' . $date . '.csv';
		$fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
		$fileNameReturn  = $this->saveCSV($fileName, $result);
		if ($fileNameReturn != '') {
			$this->respon['FileName'] = '/download/' . $fileNameReturn;
		} else {
			$this->respon['FileName'] = '';
		}
		//
		return response()->json($this->respon);
	}
	/**
	 * import
	 * @author quangnd
	 * @created at 22023/04/25
	 * @return \Illuminate\Http\Response
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
				$request['folder'] = 'i1021';
				$rename_upload  = 'RI1021_' . time();
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
				$fiscal_year = $request->fiscal_year ?? 0;
				$report_kinds = $request->report_kinds ?? 0;
				$error_cnt = 0;
				$error_bag = [];
				foreach ($rows as $row) {
					if ($row != '') {
						$tmp            =   explode(',', $row); //parse the items in rows
						if (count($tmp) < 2) {
							$this->respon['status']     = 208;
							return response()->json($this->respon);
						}
						$tmp = str_replace('"', '', $tmp);
						// header $r = 0
						if ($r == 0) {
							$tmp_error = $tmp;
							$tmp_error[] = trans('messages.error_contents');
							$error_bag[] = 	$tmp_error;
						}
						// body $r > 0
						if ($r > 0) {
							$params['company_cd'] 			= session_data()->company_cd;
							$params['fiscal_year'] 			= $fiscal_year;
							$params['employee_cd'] 			= empty($tmp[0]) ? '' : $tmp[0];
							$params['report_kinds'] 		= $report_kinds;
							$params['viewer_employee_cd'] 	= empty($tmp[1]) ? '' : $tmp[1];
							// get from session
							$params['cre_user']      		= session_data()->user_id;
							$params['cre_ip']        		= $_SERVER['REMOTE_ADDR'];
							$params['language']      		= session_data()->language;
							$result = Dao::executeSql('SPC_RI1021_ACT2', $params);
							if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
								return response()->view('errors.query', [], 501);
							}
							$message_errors = '';
							if (isset($result[0]) && !empty($result[0])) {
								$error_cnt++;
								foreach ($result[0] as $temp) {
									$message_errors .= $temp['remark'] . $temp['message_content'] . '';
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
					$csv_name = 'RI1021' . $date . '.csv';
					$file_name = $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csv_name;
					$file_name_return = $this->saveCSVRI1021($error_bag, $file_name);
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
	//
	public function saveCSVRI1021($data, $file_name)
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

					$this->writeLine($value, $index, $count);
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
	 * approvalLastest
	 * @author quangnd
	 * @created at 22023/04/25
	 * @return \Illuminate\Http\Response
	 */
	public function approvalLastest(Request $request)
	{
		$data_request = $request->json()->all()['data_sql'];
		$validator = Validator::make($data_request, [
			'page_size'                                  => 'integer',
			'page'                                       => 'integer',
			'report_kinds'                               => 'integer',
			'fiscal_year'                                => 'integer',
			'report_group'                               => 'integer',
			'employee_typ'                               => 'integer',
			'list_position_cd.*.position_cd'             =>  'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// success
		$params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params['user_id']            =  session_data()->user_id;
		$params['company_cd']         =  session_data()->company_cd;
		$params['mode']				  =	 2;
		$result = Dao::executeSql('SPC_rI1021_FND1', $params);
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['list']                 	=  $result[0] ?? [];
		$data['paging']              	=  $result[1][0] ?? [];
		$data['organization_group']     =  getCombobox('M0022', 1, 5) ?? [];
		//dd($data);
		return view('WeeklyReport::ri1021.list_content', $data);
	}
	/**
	 * editEmployee
	 *
	 * @param  Request $request
	 * @return View|Json
	 */
	public function viewerSetting(Request $request)
	{
		$data['title'] 			= trans('messages.viewer_setting');
		$validator = Validator::make($request->all(), [
			'report_kind'  => 'integer',
			'fiscal_year'  => 'integer',
			'group_cd'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['fiscal_year'] = $request->fiscal_year??0;
		$params['employee_cd'] = $request->employee_cd??'';
		$params['report_kind'] = $request->report_kind?? -1;
		$params['report_no'] = $request->report_no?? -1;
		$params['page'] = $request->page?? 1;
		$params['page_size'] = $request->page_size?? 20;
		$params['employee_cd_key'] =  $request->employee_cd_key??'';
        $params['employee_nm_key'] = $request->employee_nm_key??'';
        $params['employee_typ'] = $request->employee_typ??-1;
        $params['belong_cd1'] = $request->belong_cd1 ?? '-1';
        $params['belong_cd2'] = $request->belong_cd2 ?? '-1';
        $params['belong_cd3'] =$request->belong_cd3 ?? '-1';
        $params['belong_cd4'] = $request->belong_cd4 ?? '-1';
        $params['belong_cd5'] = $request->belong_cd5 ?? '-1';
        $params['job_cd'] = $request->job_cd ?? -1;
        $params['position_cd'] = $request->position_cd  ?? -1;
        $params['group_screen'] = $request->mygroup_cd  ?? -1;
        $params['company_cd'] = session_data()->company_cd ?? 0;
        $params['login_employee_cd'] = session_data()->user_id ?? '';

		if ($request->isMethod('post')) {
			$params['mode']  =  0;
		} else {
			$params['mode']  =  1;
		}
		$res 				   = 	Dao::executeSql('SPC_VIEWER_SETTING_FND1', $params);
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['organization_group'] 	= 	getCombobox('M0022', 1, 5) ?? [];
		if (!$request->isMethod('post')) {
		$data['list'] 			= $res[0] ?? [];
		}
		$data['shares'] 			=  $res[0] ?? [];
		$data['paging'] 		= $res[1][0] ?? [];
		$data['info'] 			= $res[2][0] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, 5) ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 5) ?? [];
		$data['M0030'] = getCombobox('M0030', 1, 5) ?? [];
		$data['M0040'] = getCombobox('M0040', 1, 5) ?? [];
		$data['M0060'] = getCombobox('M0060', 1, 5) ?? [];
		$data['M4600'] = getCombobox('M4600', 1, 5) ?? [];
		$data['F4010'] = getCombobox('F4010', 1, 5) ?? [];
		$data['login_employee_cd'] = session_data()->employee_cd ?? '';
		$data['fiscal_year'] = $request->fiscal_year??0;
		$data['is_viewer'] = true;
		$data['fiscal_year'] = $request->fiscal_year??0;
		$data['employee_cd'] = $request->employee_cd??0;
		$data['report_kind'] = $request->report_kind??0;
		$data['group_cd_screen'] = $request->group_cd??0;
		//dd($params);
		// post method
		if ($request->isMethod('post')) {
			return view('Common::popup.search_report_employee_share', array_merge($data));
		}
		return view('Common::popup.report_employee_share', array_merge($data));
	}
	   /**
     * refer sheet group
     * @author tuantv
     * @created at 2018-09-26
     * @return \Illuminate\Http\Response
     */
    public function referEmployee(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
				'report_kind'  => 'integer',
				'fiscal_year'  => 'integer',
				'group_cd'  => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['company_cd']   =  session_data()->company_cd;
			$params['fiscal_year'] 	= $request->fiscal_year??0;
			$params['report_kind'] 	= $request->report_kind??0;
			$params['group_cd']    	= $request->group_cd??1;
            $params['employee_cd']  =  $request->employee_cd??'';
            $res = Dao::executeSql('SPC_rI1021_INQ2', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            //
            $this->respon['status']           = 200;
            $this->respon['data']             = $res[0][0] ?? [];
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
	   /**
     * 
     * @author 
     * @created at 
     * @return \Illuminate\Http\Response
     */
    public function deleteData(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
				'report_kind'  => 'integer',
				'fiscal_year'  => 'integer',
				'group_cd'  => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
			$data_request = $request->json()->all()['data_sql'];
            $params['company_cd']   =  session_data()->company_cd;
			$params['json'] = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			$params['cre_user']     =   session_data()->user_id;
            $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
            $res = Dao::executeSql('SPC_rI1021_ACT3', $params);
			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($res[0]) && !empty($res[0])) {
				$this->respon['status'] = NG;
				foreach ($res[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			}
            //
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
