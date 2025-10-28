<?php

namespace App\Modules\BasicSetting\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use File;
use Dao;
use App\Helpers\Helper;
use App\Helpers\UploadCore;
use App\Services\ItemService;
use Illuminate\Validation\Rule;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;
use App\Mail\PasswordNotification;
use Illuminate\Support\Facades\Mail;
use App\Services\EmployeeTabAuthorityService;
use Carbon\Carbon;
use App\Services\GoogleService;

class M0070Controller extends Controller
{
	protected $itemService;
	protected $employeeTabAuthorityService;

	public function __construct(ItemService $itemService, EmployeeTabAuthorityService $employeeTabAuthorityService)
	{
		parent::__construct();
		$this->itemService = $itemService;
		$this->employeeTabAuthorityService = $employeeTabAuthorityService;
	}
	/**
	 * Show the application index.
	 * @author datnt
	 * @created at 2018-06-25 03:01:47
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.home');
		$data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.employee_master');
		$data['disabled'] = '';
		// get data from url query
		$redirect_param = $request->redirect_param ?? '';
		if ($redirect_param != '') {
			try {
				$redirect_param = json_decode(Crypt::decryptString($redirect_param));
			} catch (DecryptException $e) {
				return response()->view('errors.403');
			}
		}
		//
		$reqs = [
			'from'  => $redirect_param->from ?? '',
			'employee_cd'   => $redirect_param->employee_cd ?? '',
		];
		$validator = Validator::make($reqs, [
			'from'  => [
				'string',
				Rule::in(['q0070', 'sq0070']),
			],
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data['screen_from'] 		= htmlspecialchars($reqs['from']);
		$request->employee_cd	=	$redirect_param->employee_cd ?? '';
		$refer = $this->refer($request);
		$left = $this->getLeftContent($request);
	
		// tab_01
		$refer['tab_01'] = $this->refer01($request);
		// tab_02
		$refer['tab_02'] = $this->referTab02($request);

		// tab_03
		$refer['tab_03'] = $this->referTab03($request);

		// tab_05
		$refer['tab_05'] = $this->referTab05($request);

		// tab_08
		$refer['tab_8'] = $this->referTab08($request);

		// tab_09
		$refer['tab_09'] = $this->referTab09($request);

		// tab_13
		$refer['tab_12'] = $this->referTab12($request);

		// tab_13
		$refer['tab_13'] = $this->referTab13($request);

		// tab_06
		$refer['tab_06'] = $this->referTab06($request);
		// tab_04
		$refer['tab_04'] = $this->referTab04($request);
		// tab_07
		$refer['tab_07'] = $this->referTab07($request);

		// tab_11
		$refer['tab_11'] = $this->referTab11($request);

		// tab_10
		$refer['tab_10'] = $this->referTab10($request);

		if ((isset($refer['error_typ']) && $refer['error_typ'] == '999')
			|| (isset($left['error_typ']) && $left['error_typ'] == '999')
		) {
			return response()->view('errors.query', [], 501);
		}
		return view('BasicSetting::m0070.index', array_merge($data, $refer, $left));
	}
	/**
	 * get left content
	 * @author datnt
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function getLeftContent(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'search_key' 			=> 'max:50',
			'company_out_dt_flg' 	=> 'integer',
			'current_page' 			=> 'integer',
			'page_size' 			=> 'integer',
		]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->search_key ?? '')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		$param_json['list_organization_step1']          = json_decode($request->organization_step1) ?? [];
		$param_json['list_organization_step2']          = [];
		$param_json['list_organization_step3']          = [];
		$param_json['list_organization_step4']          = [];
		$param_json['list_organization_step5']          = [];
		$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params = [
			'search_key' 			=> SQLEscape($request->search_key ?? ''),
			'organization_cd' 		=> $json ?? '',
			'company_out_dt_flg' 	=> $request->company_out_dt_flg ?? 0,
			'current_page' 			=> $request->current_page ?? 1,
			'page_size' 			=> $request->page_size ?? 15,
			'company_cd' 			=> session_data()->company_cd, // set for demo
			'user_id' 				=> session_data()->user_id,
			'employee_cd' 			=> $request->employee_cd ?? '',
			'language'			 	=> session_data()->language ?? ''
		];
		$data['search_key'] = htmlspecialchars($request->search_key) ?? '';
		//
		$res = Dao::executeSql('SPC_M0070_LST1', $params);
		$data['list'] 				= $res[0] ?? [];
		$data['paging'] 			= $res[1][0] ?? [];
		$data['drop_org'] 			= getCombobox('M0020', 1, 4);
		$data['organization_cd'] 	= $res[3][0]['organization_cd'] ?? [];
		$data['company_out_dt_flg'] 	= $res[3][0]['company_out_dt_flg'] ?? [];
		// render view
		if ($request->ajax()) {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			return view('BasicSetting::m0070.leftcontent', $data);
		} else {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}
	/**
	 * refer
	 * @author datnt
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function refer(Request $request)
	{
		$employee_cd = $request->employee_cd ?? '';
		$param['employee_cd'] = $employee_cd;
		$param['company_cd'] = session_data()->company_cd;
		$data['organization_group_total']['2'] = null;
		$data['organization_group_total']['3'] = null;
		$data['organization_group_total']['4'] = null;
		$data['organization_group_total']['5'] = null;
		$param['user_id'] = session_data()->user_id;
		$param['language'] = session_data()->language ?? '';
		//$sql
		$sql = Dao::executeSql('SPC_M0070_INQ1', $param);
		$data['table1'] = $sql[0][0] ?? [];
		$data['l0014'] = $sql[14] ?? [];
		$data['keep_emp'] = $sql[0][0]['keep_emp'] ?? '';
		$data['multilingual_option_use_typ'] = $sql[15][0]['multilingual_option_use_typ'] ?? 0;
		$data['table2'] = $sql[1] ?? [];
		$data['table4'] = $sql[2][0] ?? [];
		$data['year_depart'] = $sql[3][0] ?? [];
		$data['year_grade'] = $sql[4][0] ?? [];
		$data['organization_group_1'] = $sql[5] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, 4) ?? [];
		$data['SSO_use_typ'] = $sql[6][0]['SSO_use_typ']  ?? 0;
		$data['marcopolo_use_typ'] = $sql[6][0]['marcopolo_use_typ']  ?? 0;
		$data['organization_group_total']['2'] = $sql[7] ?? null;
		$data['organization_group_total']['3'] = $sql[8] ?? null;
		$data['organization_group_total']['4'] = $sql[9] ?? null;
		$data['organization_group_total']['5'] = $sql[10] ?? null;
		$data['count_organization_cd'] = $sql[11][0]['count_organization_cd'] ?? 0;
		$data['list_org'] = $sql[12] ?? null;
		//$sql2
		$param2['company_cd'] = session_data()->company_cd;
		$param2['user_id'] = session_data()->user_id;
		$sql2 = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param2);
		$data['combo_office_cd'] = $sql2[0] ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 4);
		$data['combo_job_cd'] = getCombobox('M0030', 1, 4);
		$data['combo_position_cd'] = getCombobox('M0040', 1, 4);
		$data['combo_grade'] = getCombobox('M0050', 1, 4);
		$data['combo_employee_typ'] = getCombobox('M0060', 1, 4);
		$data['employee_cd'] = $employee_cd;
		$data['L0010'] = getCombobox(18);
		// authority
		$param3['company_cd'] = session_data()->company_cd;
		$sql3 = Dao::executeSql('SPC_M0070_GET_AUTHORITY', $param3);
		$data['combo_authority'] 						= $sql3[0];
		$data['combo_oneonone_authority'] 			= $sql3[1];
		$data['combo_multi_authority'] 				= $sql3[2];
		$data['commbo_setting_authority'] 			= $sql3[3];
		$data['combo_weekly_report_authority'] 		= $sql3[4];
		$data['combo_empinfo_authority'] 			= $sql3[5];
		$data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id, 0, $employee_cd);
		$data['screen_use'] = 'M0070';
		$data['disabled'] = '';
		$picture = isset($data['table1']['picture']) ? $data['table1']['picture'] : '';
		$data['disabled_tab_default'] = checkM0070TabIsUsed('M0070')==2?'disabled':'';
		$data['tab_01'] = $this->refer01($request);
		$data['tab_02'] = $this->referTab02($request);
		$data['tab_03'] = $this->referTab03($request);
		$data['tab_05'] = $this->referTab05($request);
		$data['tab_08'] = $this->referTab08($request);
		$data['tab_09'] = $this->referTab09($request);
		$data['tab_12'] = $this->referTab12($request);
		$data['tab_13'] = $this->referTab13($request);
		$data['tab_06'] = $this->referTab06($request);
		$data['tab_04'] = $this->referTab04($request);
		$data['tab_07'] = $this->referTab07($request);
		$data['tab_11'] = $this->referTab11($request);
		$data['tab_10'] = $this->referTab10($request);
		$multireview_use_typ = 0;
		$oneonone_use_typ = 0;
		$evaluation_use_typ = 0;
		$report_use_typ = 0;
		if (session()->has(AUTHORITY_KEY)) {
			$user = session(AUTHORITY_KEY);
			$multireview_use_typ 	= $user->multireview_use_typ;
			$oneonone_use_typ 		= $user->_1on1_use_typ;
			$evaluation_use_typ 	= $user->evaluation_use_typ;
			$report_use_typ 	= $user->report_use_typ;
			$empinfo_authority_typ 	= $user->empinfo_authority_typ;
		}

		$data['multireview_use_typ'] = $multireview_use_typ;
		$data['oneonone_use_typ'] = $oneonone_use_typ;
		$data['evaluation_use_typ'] = $evaluation_use_typ;
		$data['report_use_typ'] = $report_use_typ;
		$data['empinfo_authority_typ'] = $empinfo_authority_typ;
		if (isset($data['table1']['picture']) && !File::exists(public_path($picture))) {
			$data['table1']['picture'] = '';
		}
		// render view
		if ($request->ajax()) {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			return view('BasicSetting::m0070.refer', $data)->render();
		} else {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}
	/**
	 * postSave
	 * @author datnt
	 * @created at 2018-06-25 03:01:47
	 * @return void
	 */
	public function postSaveEmployeeHeader(Request $request)
	{
		try {
			$json = $request->head;
			$json = json_decode($json);
			$employee_cd = $json->data_sql->employee_cd;
			$file = $request->except('_token')['file'];
			$uploadPath = '';
			$company_cd = session_data()->company_cd??'';
			$request['folder'] = "m0070/avatar/$company_cd";
			$this->respon['employee_cd'] = '';
			$timestamp =  Carbon::now()->format('Ymd_His');
			// rename file upload
			$employee_cd = $this->sanitizeEmployeeCode($employee_cd);
			config(["filesystems.options.rename_upload" => "m0070_{$employee_cd}_{$timestamp}"]);
			if ($file != 'undefined') {
				$upload =  UploadCore::start($request);
				//var_dump($upload);
				if (!$upload['errors'] && isset($upload['file'])) {
					$array = $upload['file'];
					if ($array['status'] !== 200) {
						$errors = $array['errors'];
						$this->respon['status']     = 404;
						$this->respon['errors'][0] =  [
							"message_no" => "27",
							"item" => "#file_error",
							"order_by" => "0",
							"error_typ" => "0",
							"value1" => "0",
							"value2" => "0",
							"remark" => "password length",
						];
						return response()->json($this->respon);
					}
					$uploadPath = $array['path'];
				}
			}
			// dd($uploadPath);
			$organization_step1 = explode("|", $json->data_sql->organization_step1 ?? '');
			$organization_step2 = explode("|", $json->data_sql->organization_step2 ?? '');
			$organization_step3 = explode("|", $json->data_sql->organization_step3 ?? '');
			$organization_step4 = explode("|", $json->data_sql->organization_step4 ?? '');
			$organization_step5 = explode("|", $json->data_sql->organization_step5 ?? '');
			$json->data_sql->organization_step1 = $organization_step1[0] ?? 0;
			$json->data_sql->organization_step2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
			$json->data_sql->organization_step3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
			$json->data_sql->organization_step4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
			$json->data_sql->organization_step5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);
			$array = [
				'json' => json_encode($json->data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
				'path' => $uploadPath,
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];
			$result = Dao::executeSql('SPC_M0070_HEADER_ACT1', $array);
			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 502);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
				if (isset($result[1][0])) {
					$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					$old_picture = $result[1][0]['old_picture'];
					// delete old image
					// if ($old_picture != '' && $uploadPath != '' && $old_picture != $uploadPath) {
					// 	if (File::exists(public_path($old_picture))) {
					// 		File::delete(public_path($old_picture));
					// 	}
					// }
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		
		return response()->json($this->respon);
	}

	/**
	 * postSave
	 * @author datnt
	 * @created at 2018-06-25 03:01:47
	 * @return void
	 */
	public function postSave(Request $request)
	{
		try {
			$json = $request->head;
			$json = json_decode($json);
			$employee_cd = $json->data_sql->employee_cd;
			$file = $request->except('_token')['file'];
			$uploadPath = '';
			$company_cd  = session_data()->company_cd;
			$request['folder'] = "m0070/avatar/$company_cd";
			$this->respon['employee_cd'] = '';
			$company_cd = session_data()->company_cd;
			$organization_step1 = explode("|", $json->data_sql->organization_step1 ?? '');
			$organization_step2 = explode("|", $json->data_sql->organization_step2 ?? '');
			$organization_step3 = explode("|", $json->data_sql->organization_step3 ?? '');
			$organization_step4 = explode("|", $json->data_sql->organization_step4 ?? '');
			$organization_step5 = explode("|", $json->data_sql->organization_step5 ?? '');
			$json->data_sql->organization_step1 = $organization_step1[0] ?? 0;
			$json->data_sql->organization_step2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
			$json->data_sql->organization_step3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
			$json->data_sql->organization_step4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
			$json->data_sql->organization_step5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);
			$array = [
				'json' => json_encode($json->data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
				'path' => $uploadPath,
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];
			$result = Dao::executeSql('SPC_M0070_LOGIN_INFO', $array);
			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 502);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
				if (isset($result[1][0])) {
					$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					$old_picture = $result[1][0]['old_picture'];
					// delete old image
					// if ($old_picture != '' && $uploadPath != '' && $old_picture != $uploadPath) {
					// 	if (File::exists(public_path($old_picture))) {
					// 		File::delete(public_path($old_picture));
					// 	}
					// }
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}

		return response()->json($this->respon);
	}
	/**
	 * postSaveEmpInfo
	 * @author datnt
	 * @created at 2018-06-25 03:01:47
	 * @return void
	 */
	public function postSaveEmpInfo(Request $request)
	{
		try {
			$json = $request->head;
			$json = json_decode($json);
			$employee_cd = $json->data_sql->employee_cd;
			$uploadPath = '';
			$request['folder'] = '/m0070';
			$this->respon['employee_cd'] = '';
			// rename file upload

			// dd($uploadPath);
			for($i=0;$i<count($json->data_sql->row_data_02);$i++) {
			$organization_step1 = explode("|", $json->data_sql->row_data_02[$i]->organization_cd1 ?? '');
			$organization_step2 = explode("|", $json->data_sql->row_data_02[$i]->organization_cd2 ?? '');
			$organization_step3 = explode("|", $json->data_sql->row_data_02[$i]->organization_cd3 ?? '');
			$organization_step4 = explode("|", $json->data_sql->row_data_02[$i]->organization_cd4 ?? '');
			$organization_step5 = explode("|", $json->data_sql->row_data_02[$i]->organization_cd5 ?? '');
			if($i == 1) {
				$json->data_sql->row_data_02[$i]->organization_step1 = $organization_step1[0] ?? 0;
				$json->data_sql->row_data_02[$i]->organization_step2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
				$json->data_sql->row_data_02[$i]->organization_step3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
				$json->data_sql->row_data_02[$i]->organization_step4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
				$json->data_sql->row_data_02[$i]->organization_step5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);
				$json->data_sql->list[0]->organization_step1 = $organization_step1[0] ?? 0;
				$json->data_sql->list[0]->organization_step2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
				$json->data_sql->list[0]->organization_step3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
				$json->data_sql->list[0]->organization_step4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
				$json->data_sql->list[0]->organization_step5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);
				$json->data_sql->organization_step1 = $organization_step1[0] ?? 0;
				$json->data_sql->organization_step2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
				$json->data_sql->organization_step3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
				$json->data_sql->organization_step4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
				$json->data_sql->organization_step5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);

			} else {
					$json->data_sql->row_data_02[$i]->organization_cd1 = $organization_step1[0] ?? 0;
					$json->data_sql->row_data_02[$i]->organization_cd2 = $organization_step2[1] ?? ($organization_step2[0] ?? 0);
					$json->data_sql->row_data_02[$i]->organization_cd3 = $organization_step3[2] ?? ($organization_step3[0] ?? 0);
					$json->data_sql->row_data_02[$i]->organization_cd4 = $organization_step4[3] ?? ($organization_step4[0] ?? 0);
					$json->data_sql->row_data_02[$i]->organization_cd5 = $organization_step5[4] ?? ($organization_step5[0] ?? 0);
				}
			}

			$array = [
				'json' => json_encode($json->data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
				'path' => $uploadPath,
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];

			$result = Dao::executeSql('SPC_M0070_EMPLOYEE_INFO', $array);

			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 500);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
				if (isset($result[1][0])) {
					$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					$old_picture = $result[1][0]['old_picture'];
					// delete old image
					if ($old_picture != '' && $uploadPath != '' && $old_picture != $uploadPath) {
						if (File::exists(public_path($old_picture))) {
							File::delete(public_path($old_picture));
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
	/**
	 * randomPass
	 * @author viettd
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function randomPass(Request $request)
	{
		try {
			$this->respon['status']     = OK;
			$params['company_cd']   =   session_data()->company_cd;
			//
			$result = Dao::executeSql('SPC_M0070_LST2', $params);
			if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			if ($result[0]) {
				$this->respon['password'] = $result[0][0]['password'] ?? 0;
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * Delete data
	 * @author namnb
	 * @created at 2018-08-16
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		try {
			$valid = $this->valid($request);
			$params['json']         =   $this->respon['data_sql'];
			$params['cre_user']     =   session_data()->user_id;
			$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
			$params['company_cd']   =   session_data()->company_cd;
			//
			$result = Dao::executeSql('SPC_M0070_ACT2', $params);
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
	/**
	 * getYear
	 * @author viettd
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function getYear(Request $request)
	{
		try {
			$params['date_from']     =   $request->date_from ?? '';
			$params['date_to']       =   $request->date_to ?? '';
			$params['mode']          =   $request->mode ?? 0;
			$params['language'] 	 =   session_data()->language ?? '';
			//
			$result = Dao::executeSql('SPC_M0070_LST3', $params);
			if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			if (isset($result[0][0]) && !empty($result[0][0])) {
				$this->respon['status']         = OK;
				$this->respon['year_num']       = $result[0][0]['year_num'] ?? 0;
				$this->respon['year_check']     = $result[1][0]['year_check'] ?? 0;
			} else {
				$this->respon['status']     = NG;
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * getYear
	 * @author viettd
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function getPopupRetired(Request $request)
	{
		$data = $this->referPopup($request);
		return view('BasicSetting::m0070.popupretired', $data);
	}
	/**
	 * getYear
	 * @author viettd
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function referPopup(Request $request)
	{
		$employee_cd	=	$request->employee_cd ?? 0;
		$params['company_cd']       	=   session_data()->company_cd;
		$params['user_id']       		=   session_data()->user_id;
		$params['employee_cd']          =   $request->employee_cd ?? '';
		$params['company_out_dt']		=	$request->company_out_dt ?? '';
		//
		$result = Dao::executeSql('SPC_M0070_LST4', $params);
		$data['L0010'] = getCombobox(17);
		$data['title'] = trans('messages.retire_process');
		$data['condition'] = $result[0][0] ?? [];
		$data['table'] = $result[1] ?? [];
		$data['disable_status'] = $result[2][0]['disable_status'] ?? 0;
		$data['employee_cd'] = $employee_cd;
		if ($request->ajax()) {
			return view('BasicSetting::m0070.popupRetiredRefer', $data);
		} else {
			return $data;
		}
	}
	/**
	 * postPopupSave
	 * @author datnt
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function postPopupSave(Request $request)
	{
		$pre_json = $request->json()->all();
		$json = json_encode($pre_json ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params['company_cd']       	=   session_data()->company_cd;
		$params['cre_ip']       		=   $_SERVER['REMOTE_ADDR'];
		$params['cre_user']     		=   session_data()->user_id;
		$params['employee_cd']          =   $json;

		//
		$result = Dao::executeSql('SPC_M0070_ACT4', $params);
		if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		} else if (isset($result[0]) && !empty($result[0])) {
			$this->respon['status'] = NG;
			foreach ($result[0] as $temp) {
				array_push($this->respon['errors'], $temp);
			}
		} else {
			$this->respon['status']     = OK;
		}
		return response()->json($this->respon);
	}
	/**
	 * postPopupSave
	 * @author datnt
	 * @created at 2018-08-30
	 * @return \Illuminate\Http\Response
	 */
	public function postPopupCancel(Request $request)
	{
		$pre_json = $request->json()->all();
		$json = json_encode($pre_json ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		$params['company_cd']       	=   session_data()->company_cd;
		$params['cre_ip']       		=   $_SERVER['REMOTE_ADDR'];
		$params['cre_user']     		=   session_data()->user_id;
		$params['employee_cd']          =   $json;

		//
		$result = Dao::executeSql('SPC_M0070_ACT5', $params);
		if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		} else if (isset($result[0]) && !empty($result[0])) {
			$this->respon['status'] = NG;
			foreach ($result[0] as $temp) {
				array_push($this->respon['errors'], $temp);
			}
		} else {
			$this->respon['status']     = OK;
		}
		return response()->json($this->respon);
	}
	/**
	 * postPassNotification
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function postPassNotification(Request $request)
	{
		// start process
		
		date_default_timezone_set('Asia/Tokyo');
		$current =  date("Y-m-d H:i:s");
		$this->writeLog('============= M0070 Start process send mail at ( ' . $current . ' ) =============');
		$googleMail = new GoogleService();
		$mail_address = $request->mail ?? '';
		$mail['subject'] = 'MIRAIC ログインパスワードの通知';
		$mail['employee_nm'] = $request->employee_nm ?? '';
		$mail['password'] = $request->password ?? '';
		$mail['language'] =  $request->language ?? '';
		$mail['screen_id'] = 'm0070';
		// check mail format is not correct
		if (!filter_var($mail_address, FILTER_VALIDATE_EMAIL)) {
			$this->writeLog('Mail format is not correct');
			$this->respon['status']     = NG;
			return response()->json($this->respon);
		}
		// Send mail
	
			$result = $googleMail->sendPasswordNotification($mail_address,$mail);
			// mail send success
			if ($result['Exception']) {
				$this->respon['status']     = NG;
				// Log
				$this->writeLog('This mail [' . $mail_address . '] is not sent');
				return response()->json($this->respon);
			}
			$this->writeLog('This mail address [' . $mail_address . '] is successful');
			$this->respon['status']     = OK;
			return response()->json($this->respon);

	}
	/**
	 * writeLog
	 *
	 * @param  string $content
	 * @return void
	 */
	private function writeLog($content, $payloads = [])
	{
		$time = date("Y-m-d H:i:s");
		$logFile = fopen(
			storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_PASS_NOTIFICATION.log'),
			'a+'
		);
		fwrite($logFile, $time . ': ' . $content . PHP_EOL);
		// if $payloads is exits 
		if (!empty($payloads)) {
			foreach ($payloads as $payload) {
				fwrite($logFile, '∟ ' . $payload . PHP_EOL);
			}
		}
		// close file
		fclose($logFile);
	}

	/**
	 * Show index tab 01
	 * @author trinhdt
	 * @created at 2021/03
	 * @return \Illuminate\Http\Response
	 */
	public function refer01(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode' 					=> 'int'
			]);
			// validate Laravel
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$param['employee_cd'] = $employee_cd;
			$param['company_cd'] = session_data()->company_cd;
			$param['user_id'] = session_data()->user_id;
			if ($employee_cd != '') {
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'],$param['employee_cd'],$param['user_id'],1);
				$data['data_tab_01'] = $list_data[0][0] ?? [];
			}			
			$data['blood_type'] = getCombobox(52) ?? [];
			$data['headquarters_prefectures'] = getCombobox('L0011', 1, 6) ?? [];
			$data['possibility_transfer'] = getCombobox(53) ?? [];
			$data['nationality'] = json_encode(getCombobox('L0012', 1, 6),true) ?? '';
			$data['status_residence'] = getCombobox(54) ?? [];
			$data['permission_activities'] = getCombobox(55) ?? [];
			$data['disability_classification'] = getCombobox(56) ?? [];
			$data['style'] = getCombobox(18) ?? [];
			$data['company_cd'] = $param['company_cd'];
			$data['disabled_tab01'] = checkM0070TabIsUsed('M0070_01')==2?'disabled':'';

			if ($mode != '') {
				if ((isset($data['data_tab_01'][0][0]['error_typ']) && $data['data_tab_01'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_01'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_01', $response)->render();
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * postSave01
	 * @author trinhdt
	 * @created at 2018-06-25 03:01:47
	 * @return void
	 */
	public function postSave01(Request $request)
	{
		try {
			ini_set('memory_limit', '-1');
            ini_set('post_max_size', '40M');
            ini_set('upload_max_filesize', '240M');
            $json = $request->head;
            $json = json_decode($json);
            $employee_cd = session_data()->user_id;
            $company_cd  = session_data()->company_cd;
            $uploadPath = [];
            $upload_file_name = [];
			for ($i=1; $i < 6; $i++) { 
				$file_name = $employee_cd.'_personal_certificate_'.time().$i;
				$sub_request = new Request();
				$sub_request['file'] = $request->except('_token')['file'.$i];
				$sub_request['rename_upload'] = $file_name;
				$sub_request['rules'] = 'mimes:pdf';
                $sub_request['folder'] = "m0070/$company_cd/employee_information";
                $upload =  UploadCore::start($sub_request);
				if (!$upload['errors'] && isset($upload['file'])) {
                    $array = $upload['file'];
                    if ($array['status'] !== 200) {
                        $this->respon['status'] = 405;
                        return response()->json($this->respon);
                    }
                    $uploadPath[$i]         = $array['path'];
                    $upload_file_name[$i]   = $array['name'];
                }
			}
			$json->data_sql->attached_file1 = $upload_file_name[1] ?? $json->data_sql->attached_file1;
			$json->data_sql->attached_file2 = $upload_file_name[2] ?? $json->data_sql->attached_file2;
			$json->data_sql->attached_file3 = $upload_file_name[3] ?? $json->data_sql->attached_file3;
			$json->data_sql->attached_file4 = $upload_file_name[4] ?? $json->data_sql->attached_file4;
			$json->data_sql->attached_file5 = $upload_file_name[5] ?? $json->data_sql->attached_file5;
            $array = [
                'json'          =>   json_encode($json->data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
                'cre_user'      =>   session_data()->user_id,
                'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
                'company_cd'    =>   session_data()->company_cd,
            ];
            $result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array,1);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} 
			else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status'] = OK;
				if (isset($result[1][0])) {
					$attached_file1_old = $result[1][0]['attached_file1_old'];
					$attached_file2_old = $result[1][0]['attached_file2_old'];
					$attached_file3_old = $result[1][0]['attached_file3_old'];
					$attached_file4_old = $result[1][0]['attached_file4_old'];
					$attached_file5_old = $result[1][0]['attached_file5_old'];
					// delete old file
					if ($attached_file1_old != ''  && $attached_file1_old != $result[1][0]['attached_file1']) {
						$address_file1 = 'uploads/m0070/'.$company_cd.'/employee_information/'.$attached_file1_old;
						if (File::exists(public_path($address_file1))) {
							File::delete(public_path($address_file1));
						}
					}
					if ($attached_file2_old != ''  && $attached_file2_old != $result[1][0]['attached_file2']) {
						$address_file2 = 'uploads/m0070/'.$company_cd.'/employee_information/'.$attached_file2_old;
						if (File::exists(public_path($address_file2))) {
							File::delete(public_path($address_file2));
						}
					}
					if ($attached_file3_old != ''  && $attached_file3_old != $result[1][0]['attached_file3']) {
						$address_file3 = 'uploads/m0070/'.$company_cd.'/employee_information/'.$attached_file3_old;
						if (File::exists(public_path($address_file3))) {
							File::delete(public_path($address_file3));
						}
					}
					if ($attached_file4_old != ''  && $attached_file4_old != $result[1][0]['attached_file4']) {
						$address_file4 = 'uploads/m0070/'.$company_cd.'/employee_information/'.$attached_file4_old;
						if (File::exists(public_path($address_file4))) {
							File::delete(public_path($address_file4));
						}
					}
					if ($attached_file5_old != ''  && $attached_file5_old != $result[1][0]['attached_file5']) {
						$address_file5 = 'uploads/m0070/'.$company_cd.'/employee_information/'.$attached_file5_old;
						if (File::exists(public_path($address_file5))) {
							File::delete(public_path($address_file5));
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

	/**
	 * Save data tab 02
	 * @author hainn
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab02(Request $request)
	{
		try {
			$param = $request->data_sql??[];
			$array = [
				'json' => json_encode($param),
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];
			$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 2);

			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
				if (isset($result[1][0])) {
					$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
				}
			}

		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 02
	 * @author hainn
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab02(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$data['qualification_cd'] = json_encode(getCombobox('M5010', 1, 6),true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 2);
			$data['list']	= $list[0];
			$data['disabled_tab02'] = checkM0070TabIsUsed('M0070_02') == 2?'disabled':'';

			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_02'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_02', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * referHeader
	 * @author namnt
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referHeader(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 0);
			$data['list']	= $list[0];
			$data['table1'] = $list[0][0] ?? [];
			$data['keep_emp'] = $list[0][0]['keep_emp'] ?? '';
			$data['employee_cd'] = $list[0][0]['employee_cd'] ?? '';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$data['tab_02'] = $data;
				$data['check_lang'] = session_data()->language ?? '';
				$data['disabled'] = '';
				$data['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.header_employee', $data);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * referHeader
	 * @author namnt
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referLoginInfo(Request $request) {
		$employee_cd = $request->employee_cd ?? '';
		$param['employee_cd'] = $employee_cd;
		$param['company_cd'] = session_data()->company_cd;
		$data['organization_group_total']['2'] = null;
		$data['organization_group_total']['3'] = null;
		$data['organization_group_total']['4'] = null;
		$data['organization_group_total']['5'] = null;
		$param['user_id'] = session_data()->user_id;
		$param['language'] = session_data()->language ?? '';
		//$sql
		$sql = Dao::executeSql('SPC_M0070_INQ1', $param);
		$data['table1'] = $sql[0][0] ?? [];
		$data['l0014'] = $sql[14] ?? [];
		$data['keep_emp'] = $sql[0][0]['keep_emp'] ?? '';
		$data['multilingual_option_use_typ'] = $sql[15][0]['multilingual_option_use_typ'] ?? 0;
		$data['table2'] = $sql[1] ?? [];
		$data['table4'] = $sql[2][0] ?? [];
		$data['year_depart'] = $sql[3][0] ?? [];
		$data['year_grade'] = $sql[4][0] ?? [];
		$data['organization_group_1'] = $sql[5] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, 4) ?? [];
		$data['SSO_use_typ'] = $sql[6][0]['SSO_use_typ']  ?? 0;
		$data['marcopolo_use_typ'] = $sql[6][0]['marcopolo_use_typ']  ?? 0;
		$data['organization_group_total']['2'] = $sql[7] ?? null;
		$data['organization_group_total']['3'] = $sql[8] ?? null;
		$data['organization_group_total']['4'] = $sql[9] ?? null;
		$data['organization_group_total']['5'] = $sql[10] ?? null;		
		$data['count_organization_cd'] = $sql[11][0]['count_organization_cd'] ?? 0;
		//$sql2
		$param2['company_cd'] = session_data()->company_cd;
		$param2['user_id'] = session_data()->user_id;
		$sql2 = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param2);
		$data['combo_office_cd'] = $sql2[0] ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 4);
		$data['combo_job_cd'] = getCombobox('M0030', 1, 4);
		$data['combo_position_cd'] = getCombobox('M0040', 1, 4);
		$data['combo_grade'] = getCombobox('M0050', 1, 4);
		$data['combo_employee_typ'] = getCombobox('M0060', 1, 4);
		$data['employee_cd'] = $employee_cd;
		$data['L0010'] = getCombobox(18);
		// authority
		$param3['company_cd'] = session_data()->company_cd;
		$sql3 = Dao::executeSql('SPC_M0070_GET_AUTHORITY', $param3);
		$data['combo_authority'] 						= $sql3[0];
		$data['combo_oneonone_authority'] 			= $sql3[1];
		$data['combo_multi_authority'] 				= $sql3[2];
		$data['commbo_setting_authority'] 			= $sql3[3];
		$data['combo_weekly_report_authority'] 		= $sql3[4];
		$data['combo_empinfo_authority'] 			= $sql3[5];
		$data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id, 0, $employee_cd);
		$data['screen_use'] = 'M0070';
		$data['disabled'] = '';
		$picture = isset($data['table1']['picture']) ? $data['table1']['picture'] : '';

		$data['tab_01'] = $this->refer01($request);
		$data['tab_02'] = $this->referTab02($request);
		$data['tab_09'] = $this->referTab09($request);
		$multireview_use_typ = 0;
		$oneonone_use_typ = 0;
		$evaluation_use_typ = 0;
		$report_use_typ = 0;
		$data['disabled_tab_default'] = checkM0070TabIsUsed('M0070')==2?'disabled':'';
		if (session()->has(AUTHORITY_KEY)) {
			$user = session(AUTHORITY_KEY);
			$multireview_use_typ 	= $user->multireview_use_typ;
			$oneonone_use_typ 		= $user->_1on1_use_typ;
			$evaluation_use_typ 	= $user->evaluation_use_typ;
			$report_use_typ 	= $user->report_use_typ;
			$empinfo_authority_typ 	= $user->empinfo_authority_typ;
		}
		$data['multireview_use_typ'] = $multireview_use_typ;
		$data['oneonone_use_typ'] = $oneonone_use_typ;
		$data['evaluation_use_typ'] = $evaluation_use_typ;
		$data['report_use_typ'] = $report_use_typ;
		$data['empinfo_authority_typ'] = $empinfo_authority_typ;
		if (isset($data['table1']['picture']) && !File::exists(public_path($picture))) {
			$data['table1']['picture'] = '';
		}
		// render view
		if ($request->ajax()) {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			return view('BasicSetting::m0070.login_information', $data)->render();
		} else {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}
	public function	referEmpInfo(Request $request) {
		$employee_cd = $request->employee_cd ?? '';
		$param['employee_cd'] = $employee_cd;
		$param['company_cd'] = session_data()->company_cd;
		$data['organization_group_total']['2'] = null;
		$data['organization_group_total']['3'] = null;
		$data['organization_group_total']['4'] = null;
		$data['organization_group_total']['5'] = null;
		$param['user_id'] = session_data()->user_id;
		$param['language'] = session_data()->language ?? '';
		//$sql
		$sql = Dao::executeSql('SPC_M0070_INQ1', $param);
		$data['table1'] = $sql[0][0] ?? [];
		$data['keep_emp'] = $sql[0][0]['keep_emp'] ?? '';
		$data['multilingual_option_use_typ'] = $sql[15][0]['multilingual_option_use_typ'] ?? 0;
		$data['table2'] = $sql[1] ?? [];
		$data['table4'] = $sql[2][0] ?? [];
		$data['year_depart'] = $sql[3][0] ?? [];
		$data['year_grade'] = $sql[4][0] ?? [];
		$data['organization_group_1'] = $sql[5] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, 4) ?? [];
		$data['SSO_use_typ'] = $sql[6][0]['SSO_use_typ']  ?? 0;
		$data['marcopolo_use_typ'] = $sql[6][0]['marcopolo_use_typ']  ?? 0;
		$data['organization_group_total']['2'] = $sql[7] ?? null;
		$data['organization_group_total']['3'] = $sql[8] ?? null;
		$data['organization_group_total']['4'] = $sql[9] ?? null;
		$data['organization_group_total']['5'] = $sql[10] ?? null;		$data['count_organization_cd'] = $sql[11][0]['count_organization_cd'] ?? 0;
		$data['list_org'] = $sql[12] ?? null;
		$data['disabled_tab_default'] = checkM0070TabIsUsed('M0070')==2?'disabled':'';
		//$sql2
		$param2['company_cd'] = session_data()->company_cd;
		$param2['user_id'] = session_data()->user_id;
		$sql2 = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param2);
		$data['combo_office_cd'] = $sql2[0] ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 4);
		$data['combo_job_cd'] = getCombobox('M0030', 1, 4);
		$data['combo_position_cd'] = getCombobox('M0040', 1, 4);
		$data['combo_grade'] = getCombobox('M0050', 1, 4);
		$data['combo_employee_typ'] = getCombobox('M0060', 1, 4);
		$data['employee_cd'] = $employee_cd;
		$data['L0010'] = getCombobox(18);
		// authority
		$param3['company_cd'] = session_data()->company_cd;
		$sql3 = Dao::executeSql('SPC_M0070_GET_AUTHORITY', $param3);
		$data['combo_authority'] 					= $sql3[0];
		$data['combo_oneonone_authority'] 			= $sql3[1];
		$data['combo_multi_authority'] 				= $sql3[2];
		$data['commbo_setting_authority'] 			= $sql3[3];
		$data['combo_weekly_report_authority'] 		= $sql3[4];
		$data['combo_empinfo_authority'] 			= $sql3[5];
		$data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id, 0, $employee_cd);
		$data['screen_use'] = 'M0070';
		$data['disabled'] = '';
		$picture = isset($data['table1']['picture']) ? $data['table1']['picture'] : '';

		$data['tab_01'] = $this->refer01($request);
		$data['tab_02'] = $this->referTab02($request);
		$data['tab_09'] = $this->referTab09($request);
		$multireview_use_typ = 0;
		$oneonone_use_typ = 0;
		$evaluation_use_typ = 0;
		$report_use_typ = 0;
		if (session()->has(AUTHORITY_KEY)) {
			$user = session(AUTHORITY_KEY);
			$multireview_use_typ 	= $user->multireview_use_typ;
			$oneonone_use_typ 		= $user->_1on1_use_typ;
			$evaluation_use_typ 	= $user->evaluation_use_typ;
			$report_use_typ 	= $user->report_use_typ;
			$empinfo_authority_typ 	= $user->empinfo_authority_typ;
		}
		$data['multireview_use_typ'] = $multireview_use_typ;
		$data['oneonone_use_typ'] = $oneonone_use_typ;
		$data['evaluation_use_typ'] = $evaluation_use_typ;
		$data['report_use_typ'] = $report_use_typ;
		$data['empinfo_authority_typ'] = $empinfo_authority_typ;
		$data['disabled_tab_default'] = checkM0070TabIsUsed('M0070')==2?'disabled':'';
		if (isset($data['table1']['picture']) && !File::exists(public_path($picture))) {
			$data['table1']['picture'] = '';
		}
		// render view
		if ($request->ajax()) {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			return view('BasicSetting::m0070.employee_information', $data)->render();
		} else {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}
	public function	referDepartment(Request $request) {
		$employee_cd = $request->employee_cd ?? '';
		$param['employee_cd'] = $employee_cd;
		$param['company_cd'] = session_data()->company_cd;
		$data['organization_group_total']['2'] = null;
		$data['organization_group_total']['3'] = null;
		$data['organization_group_total']['4'] = null;
		$data['organization_group_total']['5'] = null;
		$param['user_id'] = session_data()->user_id;
		$param['language'] = session_data()->language ?? '';
		//$sql
		$sql = Dao::executeSql('SPC_M0070_INQ1', $param);
		$data['table1'] = $sql[0][0] ?? [];
		$data['keep_emp'] = $sql[0][0]['keep_emp'] ?? '';
		$data['multilingual_option_use_typ'] = $sql[15][0]['multilingual_option_use_typ'] ?? 0;
		$data['table2'] = $sql[1] ?? [];
		$data['table4'] = $sql[2][0] ?? [];
		$data['year_depart'] = $sql[3][0] ?? [];
		$data['year_grade'] = $sql[4][0] ?? [];
		$data['organization_group_1'] = $sql[5] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, 4) ?? [];
		$data['SSO_use_typ'] = $sql[6][0]['SSO_use_typ']  ?? 0;
		$data['marcopolo_use_typ'] = $sql[6][0]['marcopolo_use_typ']  ?? 0;
		$data['organization_group_total']['2'] = $sql[7] ?? null;
		$data['organization_group_total']['3'] = $sql[8] ?? null;
		$data['organization_group_total']['4'] = $sql[9] ?? null;
		$data['organization_group_total']['5'] = $sql[10] ?? null;
		$data['count_organization_cd'] = $sql[11][0]['count_organization_cd'] ?? 0;
		$data['list_org'] = $sql[12] ?? null;		//$sql2
		$param2['company_cd'] = session_data()->company_cd;
		$param2['user_id'] = session_data()->user_id;
		$sql2 = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param2);
		$data['combo_office_cd'] = $sql2[0] ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 4);
		$data['combo_job_cd'] = getCombobox('M0030', 1, 4);
		$data['combo_position_cd'] = getCombobox('M0040', 1, 4);
		$data['combo_grade'] = getCombobox('M0050', 1, 4);
		$data['combo_employee_typ'] = getCombobox('M0060', 1, 4);
		$data['employee_cd'] = $employee_cd;
		$data['L0010'] = getCombobox(18);
		$data['disabled_tab_default'] = checkM0070TabIsUsed('M0070')==2?'disabled':'';
		// authority
		$param3['company_cd'] = session_data()->company_cd;
		$sql3 = Dao::executeSql('SPC_M0070_GET_AUTHORITY', $param3);
		$data['combo_authority'] 						= $sql3[0];
		$data['combo_oneonone_authority'] 			= $sql3[1];
		$data['combo_multi_authority'] 				= $sql3[2];
		$data['commbo_setting_authority'] 			= $sql3[3];
		$data['combo_weekly_report_authority'] 		= $sql3[4];
		$data['combo_empinfo_authority'] 			= $sql3[5];
		$data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id, 0, $employee_cd);
		$data['screen_use'] = 'M0070';
		$data['disabled'] = '';
		$picture = isset($data['table1']['picture']) ? $data['table1']['picture'] : '';

		$multireview_use_typ = 0;
		$oneonone_use_typ = 0;
		$evaluation_use_typ = 0;
		$report_use_typ = 0;
		if (session()->has(AUTHORITY_KEY)) {
			$user = session(AUTHORITY_KEY);
			$multireview_use_typ 	= $user->multireview_use_typ;
			$oneonone_use_typ 		= $user->_1on1_use_typ;
			$evaluation_use_typ 	= $user->evaluation_use_typ;
			$report_use_typ 	= $user->report_use_typ;
			$empinfo_authority_typ 	= $user->empinfo_authority_typ;
		}
		$data['multireview_use_typ'] = $multireview_use_typ;
		$data['oneonone_use_typ'] = $oneonone_use_typ;
		$data['evaluation_use_typ'] = $evaluation_use_typ;
		$data['report_use_typ'] = $report_use_typ;
		$data['empinfo_authority_typ'] = $empinfo_authority_typ;
		if (isset($data['table1']['picture']) && !File::exists(public_path($picture))) {
			$data['table1']['picture'] = '';
		}
		// render view
		if ($request->ajax()) {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			return view('BasicSetting::m0070.department_information', $data)->render();
		} else {
			if ((isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') || (isset($sql2[0][0]['error_typ']) && $sql2[0][0]['error_typ'] == '999')) {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}

	/**
	 * Refer index tab 05
	 * @author hainn
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab05(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? ''; //mode:1 for refer and not mode return data
			$data['final_education_kbn'] = getCombobox(61) ?? [];
			$data['graduation_school_cd'] = json_encode(getCombobox('L0013', 1, 4) ?? '' );
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 5);
			$data['m0078']	= $list[0];
			$data['m0079']	= $list[1];
			$data['disabled_tab05'] = checkM0070TabIsUsed('M0070_05') == 2?'disabled':'';

			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_05'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_05', $response);
			}

			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 05
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab05(Request $request)
	{
		try {
			$param = $request->data_sql;

			$validator = Validator::make($param, [
				'employee_cd' 				=> 'max:10',
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$array = [
				'json' => json_encode($param),
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];
			$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 5);

			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
				if (isset($result[1][0])) {
					$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
				}
			}

		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Save data tab 09
	 * @author quanlh
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab09(Request $request)
	{
		try {
			$param = $request->data_sql??[];
			$array = [
				'json' => json_encode($param),
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];

			$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 9);

			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
			}

		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 09
	 * @author quanlh
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab09(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			//mode:1 for refer and not mode return data
			$mode = $request->mode ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 9);
			$data['list']	= $list[0];
			$data['disabled_tab09'] = checkM0070TabIsUsed('M0070_09') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_09'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_09', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 13
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab13(Request $request)
	{
		try {
			$param = $request->data_sql??[];
			$array = [
				'json' => json_encode($param),
				'cre_user'     =>   session_data()->user_id,
				'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   =>   session_data()->company_cd,
			];
		
			$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 13);
		
			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
			}

		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 13
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab13(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$param['employee_cd'] = $employee_cd;
			$param['company_cd'] = session_data()->company_cd;
			$param['user_id'] = session_data()->user_id;
			$param['language'] = session_data()->language ?? '';
			$result = Dao::executeSql('[SPC_M0070_13_LST1]', $param);
			
			$data['group_trp'] = json_encode($result[0],true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'],$param['employee_cd'],$param['user_id'], 13);
			$data['list']	= $list[0];
			$data['disabled_tab13'] = checkM0070TabIsUsed('M0070_13') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_13'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_13', $response);
			}
			// dd($data);

			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * Save data tab 06
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab06(Request $request)
	{
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$param = $this->respon['data_sql'];
				$array = [
					'json' 			=> 	 $param,
					'cre_user'     	=>   session_data()->user_id,
					'cre_ip'       	=>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   	=>   session_data()->company_cd,
				];
			
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 6);
			
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 06
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab06(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$param['employee_cd'] = $employee_cd;
			$param['company_cd'] = session_data()->company_cd;
			$param['user_id'] = session_data()->user_id;
			$param['language'] = session_data()->language ?? '';
			if ($employee_cd != '') {
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'],$param['employee_cd'],$param['user_id'],6);
				$data['data_tab_06'] = $list_data[0][0] ?? [];
			}	
			$data['owning_house_kbn'] = getCombobox(62) ?? [];
			$data['relationship'] = json_encode(getCombobox(63),true) ?? '';
			$data['company_cd'] = $param['company_cd'];	
			$data['disabled_tab06'] = checkM0070TabIsUsed('M0070_06') == 2?'disabled':'';

			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_06'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_06', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 08
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab08(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? ''; //mode:1 for refer and not mode return data
			$data['marital_status'] = getCombobox(67) ?? [];
			$data['relationship'] = json_encode(getCombobox(63) ?? []);
			$data['gender'] = getCombobox(68) ?? [];
			$data['residential_classification'] = getCombobox(69) ?? [];
			$data['profession'] = json_encode(getCombobox(70) ?? []);
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 8);
			$data['list']	= $list;
			$data['disabled_tab08'] = checkM0070TabIsUsed('M0070_08') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_08'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_08', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 08
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab08(Request $request)
	{
		try {
			// $this->valid($request);
			// if($this->respon['status'] == OK)
			// {
				$param =  $request->data_sql;
				$array = [
					'json' => json_encode($param),
					'cre_user'     =>   session_data()->user_id,
					'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   =>   session_data()->company_cd,
				];
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 8);

				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
					if (isset($result[1][0])) {
						$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					}
				}
			// }
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Save data tab 12
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab12(Request $request)
	{
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$param = $this->respon['data_sql'];
				$array = [
					'json' 			=> 	 $param,
					'cre_user'     	=>   session_data()->user_id,
					'cre_ip'       	=>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   	=>   session_data()->company_cd,
				];
			
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 12);
			
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 12
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab12(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$param['employee_cd'] = $employee_cd;
			$param['company_cd'] = session_data()->company_cd;
			$param['user_id'] = session_data()->user_id;
			$param['language'] = session_data()->language ?? '';
			if ($employee_cd != '') {
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'],$param['employee_cd'],$param['user_id'],12);
				$data['data_tab_12'] = $list_data[0][0] ?? [];
			}	
			$data['company_cd'] = $param['company_cd'];	
			$data['disabled_tab12'] = checkM0070TabIsUsed('M0070_12') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_12'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_12', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * Refer index tab 04
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab04(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			//mode:1 for refer and not mode return data
			$mode = $request->mode ?? '';

			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 4);
			if ((isset($list[0][0]['error_typ']) && $list[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			$data['list_data_1'] = $list[0] ?? [];
			$data['list_data_2'] = $list[1] ?? [];
			$data['disabled_tab04'] = checkM0070TabIsUsed('M0070_04')==2?'disabled':'';
			if ($mode != '') {
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['tab_04'] = $data;
				return view('BasicSetting::m0070.m0070_04', $response)->render();
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * Refer m0070 tab 3
	 * @author manhnd
	 * @created at 2024/04/03 
	 * @return \Illuminate\Http\Response
	 */
	public function referTab03(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$data['M5031'] = getCombobox('M5031', 1, 6) ?? [];
        	$data['M5032'] = getCombobox('M5032', 1, 6) ?? [];
			$data['L0010_59'] = getCombobox(59);
			$data['L0010_60'] = getCombobox(60);
			$data['trainings'] = json_encode(getCombobox('M5030', 1, 6),true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 3);
			$data['list']	= $list[0];
			$data['disabled_tab03'] = checkM0070TabIsUsed('M0070_03')==2?'disabled':'';
			if ($mode == '1') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_03'] = $data;
				$response['disabled'] = '';
				return view('BasicSetting::m0070.m0070_03', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 03
	 * @author manhnd
	 * @created at 2024/04/03 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab03(Request $request)
	{
		try {
			$json = $request->head;
			$data_sql = json_decode($json, true)['data_sql'];
			// upload files
			// if ($request->hasFile('files')) {
			if (!empty($request->file('files'))) {
				$files_index = $request->files_index;
				$files = $request->file('files');
				foreach ($files as $index => $file) {
					$random_suffix = mt_rand(100000, 999999);
					$file_name = session_data()->employee_cd . '_training_history_' . $random_suffix;
					$sub_request = new Request();
					$sub_request['rules'] = 'mimes:pdf';
					$sub_request['folder'] = "m0070/".session_data()->company_cd.'/training_history';
					$sub_request['file_' . $index] = $file;
					$sub_request['rename_upload'] = $file_name;
					UploadCore::start($sub_request);
					// 
					$originalFileName = $file->getClientOriginalName();
					$fileInfo = pathinfo($originalFileName);
					$newName = $originalFileName;
					if (strlen($fileInfo['basename']) > 50) {
						// $newName = substr($fileInfo['filename'], 0, 46) . $fileInfo['dirname'] . $fileInfo['extension'];
						$newName = substr($originalFileName, 0, 50);
					}

					$row_index = (int) $files_index[$index];
                    $data_sql['list_tab_03'][$row_index]["diploma_file"] = $file_name . '.pdf';
                    $data_sql['list_tab_03'][$row_index]["diploma_file_name"] = $newName;
				}
			}

			$params['json']              =   json_encode($data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['cre_user']          =   session_data()->user_id;
            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];	
            $params['company_cd']        =   session_data()->company_cd;
			
			$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($params, 3);
			if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($result[0]) && !empty($result[0])) {
				$this->respon['status'] = NG;
				foreach ($result[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			} else {
				$this->respon['status']     = OK;
			}
		} catch (\Exception $e) {
			\Log::info('error');
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Save data tab 04
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab04(Request $request)
	{
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$array = [
					'json' 		   => $this->respon['data_sql'],
					'cre_user'     =>   session_data()->user_id,
					'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   =>   session_data()->company_cd,
				];
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 4);
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Refer index tab 11
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab11(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? ''; //mode:1 for refer and not mode return data

			$data['data_71'] = getCombobox(71) ?? [];
			$data['data_72'] = json_encode(getCombobox(72) ?? []);
			$data['data_73'] = json_encode(getCombobox(73) ?? []);
			$data['data_74'] = json_encode(getCombobox(74) ?? []);
			$data['list'] = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 11);
			$data['m0090'] = $data['list'][0][0] ?? [];
			$data['disabled_tab11'] = checkM0070TabIsUsed('M0070_11') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_11'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				return view('BasicSetting::m0070.m0070_11', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 11
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab11(Request $request){
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$array = [
					'json' => $this->respon['data_sql'],
					'cre_user'     =>   session_data()->user_id,
					'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   =>   session_data()->company_cd,
				];
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 11);

				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
					if (isset($result[1][0])) {
						$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					}
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}

	/**
	 * Save data tab 07
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab07(Request $request)
	{
		try {					
			$param = $request->data_sql;
			$array = [
				'json' 			=> json_encode($param),
				'cre_user'     	=>   session_data()->user_id,
				'cre_ip'       	=>   $_SERVER['REMOTE_ADDR'],
				'company_cd'   	=>   session_data()->company_cd,
			];
			$rules = [
				'detail_no_tab07' => 'integer', //Must be a number and length of value is 8
				'commuting_method' => 'integer',
				'commuting_distance' =>  'regex',
				'drivinglicense_renewal_deadline' => 'date',
				'commuting_method_detail' => 'text',
				'departure_point' => 'text',
				'arrival_point' => 'text',
				'commuter_ticket_classification' => 'integer',
				'commuting_expenses' => 'numeric',
			];
			$validator = Validator::make($array, $rules);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}else {
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 7);
			
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}


	/**
	 * Refer index tab 07
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab07(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$param['employee_cd'] = $employee_cd;
			$param['company_cd'] = session_data()->company_cd;
			$param['user_id'] = session_data()->user_id;
			$param['language'] = session_data()->language ?? '';

			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'],$param['employee_cd'],$param['user_id'],7);
			$data['data_tab_07']	= $list[0];
			$data['total_expenses']	= $list[1][0];
			$data['commuting_method'] = getCombobox(64) ?? [];
			$data['commuter_ticket_classification1'] = getCombobox(65) ?? [];
			$data['commuter_ticket_classification2'] = getCombobox(66) ?? [];
			$data['company_cd'] = $param['company_cd'];	
			$data['disabled_tab07'] = checkM0070TabIsUsed('M0070_07') == 2?'disabled':'';

			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_07'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				$response['marcopolo_use_typ'] = $list_data[1][0]['marcopolo_use_typ'] ?? '';
				return view('BasicSetting::m0070.m0070_07', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 10
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab10(Request $request) {
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? ''; //mode:1 for refer and not mode return data

			$data['data_76'] = getCombobox(76) ?? [];
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 10);
			$data['language'] = $list[0][0] ?? [];
			$data['m0088'] = $list[1] ?? [];
			$data['disabled_tab10'] = checkM0070TabIsUsed('M0070_10') == 2?'disabled':'';
			if ($mode != '') {
				if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
					return response()->view('errors.query', [], 501);
				}
				$response['tab_10'] = $data;
				$response['check_lang'] = session_data()->language ?? '';
				$response['disabled'] = '';
				return view('BasicSetting::m0070.m0070_10', $response);
			}
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Save data tab 10
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function postSaveTab10(Request $request){
		try {
			$this->valid($request);
			if($this->respon['status'] == OK)
			{
				$array = [
					'json' => $this->respon['data_sql'],
					'cre_user'     =>   session_data()->user_id,
					'cre_ip'       =>   $_SERVER['REMOTE_ADDR'],
					'company_cd'   =>   session_data()->company_cd,
				];
				$result = $this->employeeTabAuthorityService->saveEmployeeInformationByTab($array, 10);

				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($result[0]) && !empty($result[0])) {
					$this->respon['status'] = NG;
					foreach ($result[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				} else {
					$this->respon['status']     = OK;
					if (isset($result[1][0])) {
						$this->respon['employee_cd']     = $result[1][0]['employee_cd'];
					}
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}
	/**
	 * remove invalid characters from employee code
	 * @author namnt
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	function sanitizeEmployeeCode($employee_cd) {
		return str_replace(['\\','/',':','*','?','"','<','>','|'], '', $employee_cd);
	}
}
