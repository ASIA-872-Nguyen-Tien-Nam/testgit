<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\PairService;
use App\Services\OneOnOneService;
use App\Helpers\UploadCore;
use Validator;

class OI1020Controller extends Controller
{
	public $respon = [];
	public $rules = [];
	private $enclosure  = '"';
	private $delimiter  = ',';
	private $lineEnding = PHP_EOL;
	const FROM_ENCODING = 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS';
	const TO_ENCODING = 'UTF-8';
	protected $scheduleService;
	public function __construct(ScheduleService $scheduleService, PairService $pairService, OneOnOneService $oneononeService)
	{
		parent::__construct();
		$this->scheduleService   = $scheduleService;
		$this->pairService       = $pairService;
		$this->oneononeService   = $oneononeService;
	}
	/**
	 * Show the application index.
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:54
	 * @return \Illuminate\Http\Response
	 */
	public function index(Request $request)
	{
		$data['category']       = trans('messages.preparation');
		$data['category_icon']  = 'fa fa-book';
		$data['title']          = trans('messages.1on1_pair_setting');
		$data_schedule_service  = $this->scheduleService->getOption();
		$data_oneonone_service 	= $this->oneononeService->getCurrentFiscalYear(session_data()->company_cd);
		if ((isset($data_oneonone_service[0][0]['error_typ']) && $data_oneonone_service[0][0]['error_typ'] == '999') ||
			(isset($data_schedule_service[0][0]['error_typ']) && $data_schedule_service[0][0]['error_typ'] == '999')
		) {
			return response()->view('errors.query', [], 501);
		}
		$data['fiscal_year']        = $data_oneonone_service['fiscal_year'];
		$data['oneonone_group']     = $data_schedule_service[1] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1) ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 2) ?? [];
		$data['combo_position']     = getCombobox('M0040', 1) ?? [];
		return view('OneOnOne::oi1020.index', $data);
	}
	/**
	 * postRefer
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12
	 * @return void
	 */
	public function postRefer(Request $request)
	{
		$data_request = $request->json()->all();
		$rules = [
			'fiscal_year'                           => 'integer',
			'oneonone_group_list.oneonone_group'    => 'integer',
		];
		$validator = \Validator::make($data_request, $rules);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$company_cd         	= session_data()->company_cd;
		$fiscal_year           	= $data_request['fiscal_year']     ?? 0;
		$oneonone_group_list    = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$data_schedule_service  = $this->scheduleService->findSchedule($company_cd, $fiscal_year, $oneonone_group_list);
		if (isset($data_schedule_service[0][0]['error_typ']) && $data_schedule_service[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['table_info']     = $data_schedule_service[0][0] ?? [];
		$data['table_schedule'] = $data_schedule_service[1] ?? [];
		$error_141              = $data_schedule_service[2][0]['error_141'] ?? 0;
		$view = view('OneOnOne::oi1020.refer', $data)->render();
		return response()->json(array('view' => $view, 'error_141' => $error_141));
	}
	/**
	 * postSearch
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12
	 * @return void
	 */
	public function postSearch(Request $request)
	{
		$data_request = $request->json()->all()['data_sql'];
		$validator = Validator::make($data_request, [
			'fiscal_year' 	=> 'integer',
			'group_cd'    	=> 'integer',
			'date_from'   	=> 'date',
			'date_to'     	=> 'date',
			'position_cd' 	=> 'integer',
			'page_size'   	=> 'integer',
			'page'        	=> 'integer',
			'mode'        	=> 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$company_cd 			= session_data()->company_cd;
		$json                   = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$data_pair_service      = $this->pairService->findPairs($company_cd, $json);
		if (isset($data_pair_service[0][0]['error_typ']) && $data_pair_service[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['table_data']     = $data_pair_service[0] ?? [];
		$data['table_header']   = $data_pair_service[1] ?? [];
		$data['start_for']      = $data_pair_service[2][0]['start_for'] ?? 0;
		$data['end_for']        = $data_pair_service[2][0]['end_for'] ?? 0;
		$data['times']          = $data_pair_service[2][0]['times'] ?? 0;
		$data['fiscal_year']    = $data_pair_service[2][0]['fiscal_year'] ?? 0;
		$error                  = $data_pair_service[2][0]['error'] ?? [];
		$data['paging'] 		= $data_pair_service[6][0] ?? [];
		if (isset($data_pair_service[5][0]['employee_cd']) && !empty($data_pair_service[5][0]['employee_cd'])) {
			$temp_data = $data['table_data'];
			unset($data['table_data']);
			$data['table_data'] =   [];
			foreach ($temp_data as $item) {
				$value = $item;
				$emp_cd = $item['employee_cd'];
				foreach ($data_pair_service[5] as $item2) {
					if ($emp_cd == $item2['employee_cd']) {
						$value      =   array_merge($value, $item2);
					}
				}
				array_push($data['table_data'], $value);
			}
		}
		$data['combo_interview']      = json_decode(html_entity_decode($data_pair_service[3][0]['json_combo_interview'] ?? ''), true);
		$data['organization_group']   = getCombobox('M0022', 1) ?? [];
		$view = view('OneOnOne::oi1020.search', $data)->render();
		return response()->json(array('view' => $view, 'error' => $error));
	}

	/**
	 * postSave
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:54
	 * @return void
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			$this->respon['status'] = OK;
			$this->respon['errors'] = [];
			$data_request = $request->json()->all();
			$validator = Validator::make($data_request, [
				'fiscal_year'               => 'integer',
				'group_cd'                	=> 'integer',
				'list_pair.*.row_index'     => 'integer',
				'list_pair.*.times'       	=> 'integer',
				'list_pair.*.interview_cd'	=> 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$company_cd	= session_data()->company_cd;
			$json      	= json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			$res        = $this->pairService->savePairs($company_cd, $json);
			if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			if (isset($res[0]) && !empty($res[0])) {
				$this->respon['status'] = NG;
				foreach ($res[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			}
			return response()->json($this->respon);
		}
		// return http request
	}
	/**
	 * Delete data
	 * @author nghianm
	 * @created at 2020/10/23
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->respon['status'] = OK;
				$this->respon['errors'] = [];
				$data_request = $request->json()->all();
				$validator = Validator::make($data_request, [
					'fiscal_year'				=> 'integer',
					'group_cd'   				=> 'integer',
					'list_pair.*.ck_item'     	=> 'integer',
					'list_pair.*.times'       	=> 'integer',
					'list_pair.*.interview_cd'	=> 'integer',
				]);
				if ($validator->passes()) {
					//
					$company_cd   = session_data()->company_cd;
					$json         = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
					$res = $this->pairService->deletePairs($company_cd, $json);
					// check exception
					if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					}
					if (isset($res[0]) && !empty($res[0])) {
						$this->respon['status'] = NG;
						foreach ($res[0] as $temp) {
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
	 * import
	 * @author datnt
	 * @created at 2018-10-03 08:13:36
	 * @return void
	 */
	public function postImport(Request $request)
	{
		try {
			$file               = $request->except('_token')['file'];
			$times              = $request->times ?? 0;
			$count_organization = $request->count_organization ?? 0;
			// rename file upload
			if ($file != 'undefined') {
				ini_set('memory_limit', '-1');
				ini_set('post_max_size', '40M');
				ini_set('upload_max_filesize', '240M');
				//
				$request['rules']         = 'mimes    :csv,txt,html';
				$request['folder']        = 'oi1020';
				$rename_upload            = 'oi1020' . time();
				$request['rename_upload'] = $rename_upload;
				$upload                   = UploadCore::start($request);
				$fileName                 = $upload['file']['name'];
				$pos = strpos($fileName, ".");
				$checkFormat = substr($fileName, $pos, 4);
				if ($checkFormat != '.csv') {
					$this->respon['status']   = 206;
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
				$i             = 0;
				$r             = 0;
				// check file exists
				$content       = file_get_contents($path_file);
				//
				if (!mb_detect_encoding($content) || mb_detect_encoding($content, 'SJIS', true) == true) {
					$content = mb_convert_encoding($content, 'UTF-8', 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS');
				}
				//
				$rows = str_getcsv($content, "\n"); //parse the rows
				$error_cnt = 0;
				$error_bag = [];
				// dd($rows);
				foreach ($rows as $r => $row) {
					$tmp = explode(',', $row); //parse the items in rows
					$tmp = str_replace('"', '', $tmp);
					// first row header
					if ($r == 0) {
						$tmp_error = $tmp;
						$tmp_error[] = trans('messages.error_contents');
						$error_bag[] = 	$tmp_error;
					}
					// leave first row for header
					if ($r > 0) {
						$employee_times = [];
						// loop times
						for ($index = 1; $index <= $times; $index++) {
							$start_pos = ($index - 1) * 5;
							// get employee_time
							$employee_time['employee_cd'] = $tmp[1]; //社員番号
							$employee_time['coach_cd'] = $tmp[$start_pos + 11 + $count_organization] ?? ''; //コーチコード
							$employee_time['interview_cd'] = $tmp[$start_pos + 13 + $count_organization] ?? ''; //1on1シートコード
							$employee_time['times'] = $index; //回数
							$employee_time['row_index'] = $r;
							array_push($employee_times,$employee_time);
 						}
						// json param for save
						$params['list_pair'] = $employee_times;
						$params['fiscal_year'] = $tmp[0]; //年度
						$params['group_cd'] = $tmp[7 + $count_organization];	//1on1グループコード
						$company_cd	= session_data()->company_cd;
						$json      	= json_encode($params, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
						$res        = $this->pairService->savePairs($company_cd, $json);
						// check exception
						if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
							return response()->view('errors.query', [], 501);
						}
						$message_errors = '';
						if (isset($res[0]) && !empty($res[0])) {
							$error_cnt++;
							foreach ($res[0] as $temp) {
								if($temp['error_typ'] == 5){
									$message_errors .= $temp['remark'].$temp['message_content'].'|';
								}else{
									$message_errors .= $temp['message_content'].'|';
								}
							}
							// add error message into table $error_bag
							$tmp_error = $tmp;
							$tmp_error[] = $message_errors;
							$error_bag[] = 	$tmp_error;	
						}
						// i plus 1
						$i++;
					}
				}
				// check error
				if ($error_cnt > 0) {
					$this->respon['status'] = 9999;
					// log file errors
					$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
					$csv_name = 'oI1020' . $date . '.csv';
					$file_name = $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csv_name;
					$file_name_return = $this->saveCSVI1020($error_bag, $file_name);
					if ($file_name_return != '') {
						$this->respon['FileName'] = '/download/' . $file_name_return;
					} else {
						$this->respon['FileName'] = '';
					};
				} else {
					$this->respon['status'] = 200;
					$this->respon['times']  = $times;
				}
			}
			//
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * postExport
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12
	 * @return void
	 */
	public function postExport(Request $request)
	{
		$this->respon['status'] = OK;
		$this->respon['errors'] = [];
		$data_request = $request->json()->all()['data_sql'];
		$validator = Validator::make($data_request, [
			'fiscal_year' 	=> 'integer',
			'group_cd'    	=> 'integer',
			'date_from'   	=> 'date',
			'date_to'     	=> 'date',
			'position_cd' 	=> 'integer',
			'page_size'   	=> 'integer',
			'page'        	=> 'integer',
			'mode'        	=> 'integer',
			'organization_step1.*.organization_cd_1' => 'integer',
			//
			'organization_step2.*.organization_cd_1' => 'integer',
			'organization_step2.*.organization_cd_2' => 'integer',
			'organization_step2.*.organization_cd_3' => 'integer',
			'organization_step2.*.organization_cd_4' => 'integer',
			'organization_step2.*.organization_cd_5' => 'integer',
			//
			'organization_step3.*.organization_cd_1' => 'integer',
			'organization_step3.*.organization_cd_2' => 'integer',
			'organization_step3.*.organization_cd_3' => 'integer',
			'organization_step3.*.organization_cd_4' => 'integer',
			'organization_step3.*.organization_cd_5' => 'integer',
			// org 4
			'organization_step4.*.organization_cd_1' => 'integer',
			'organization_step4.*.organization_cd_2' => 'integer',
			'organization_step4.*.organization_cd_3' => 'integer',
			'organization_step4.*.organization_cd_4' => 'integer',
			'organization_step4.*.organization_cd_5' => 'integer',
			//5
			'organization_step5.*.organization_cd_1' => 'integer',
			'organization_step5.*.organization_cd_2' => 'integer',
			'organization_step5.*.organization_cd_3' => 'integer',
			'organization_step5.*.organization_cd_4' => 'integer',
			'organization_step5.*.organization_cd_5' => 'integer',

		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
	
		$company_cd	       = session_data()->company_cd;
		$json      	       = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$data_pair_service = $this->pairService->findPairs($company_cd, $json);
		$title             = $data_pair_service[4];
		// push tilte to array export first
		$data_export = $title;
		$times       = $data_pair_service[2][0]['times'];
		$result      = $data_pair_service[0] ?? [];
		// merge column > 250
		if (
			isset($data_pair_service[5][0]['employee_cd']) && !empty($data_pair_service[5][0]['employee_cd'])
			&& isset($data_pair_service[6][0]['employee_cd']) && !empty($data_pair_service[6][0]['employee_cd'])
		) {
			$result = [];
			//$data_pair_service[5] is array data which has column > 250
			//$data_pair_service[6] is array header which has column > 250
			// append column > 250
			foreach ($data_pair_service[0] as $item) {
				$value  = $item;
				$emp_cd = $item['employee_cd'];
				foreach ($data_pair_service[5] as $item2) {
					if ($emp_cd == $item2['employee_cd']) {
						// remove key (company_cd, employee_cd)
						$value = array_merge($value, $item2);
					}
				}
				array_push($result, $value);
			}
			// append column header which  > 250 times
			$data_export[0] = array_merge($data_export[0],$data_pair_service[6][0]);
			// array_push($data_export[0], $data_pair_service[6][0]);
		}
		// expand data of each time
		//	convert data time from json to array
		foreach ($result as $key => $row) {
			for ($i = 1; $i <= $times; $i++) {
				$temp_data_time = json_decode(html_entity_decode($row['time' . $i]), true);
				$result[$key]   = array_merge($result[$key]??[], array_values($temp_data_time??[]));
				unset($result[$key]['time' . $i]);
			}
			array_push($data_export, $result[$key]);
		}
		//
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '1') {
			$this->respon['status']     = NG;
			$this->respon['errors']     = $result[0];
		}
		$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
		$csvname = 'oI1020' . $date . '.csv';
		$fileName = $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
		$fileNameReturn = $this->saveCSVI1020($data_export, $fileName);
		if ($fileNameReturn != '') {
			$this->respon['FileName'] = '/download/' . $fileNameReturn;
		} else {
			$this->respon['FileName'] = '';
		};
		return response()->json($this->respon);
	}
	/**
	 * saveCSV
	 * @author longvv@ans-asia.com
	 * @return array
	 * @author BaoNC  update
	 */
	public function saveCSVI1020($data, $file_name)
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

					$this->writeLineI1020($value, $index, $count);
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
	public function writeLineI1020($values = null, $index = null, $count = null)
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
			// Write to file
			//            fwrite($this->handle, "\xEF\xBB\xBF");
			fwrite($this->handle, $line);
		} else {
			throw new Exception("Invalid data row passed to CSV writer.");
		}
	}
}
