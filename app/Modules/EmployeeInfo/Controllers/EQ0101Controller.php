<?php

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use File;
use Dao;
use App\Services\ItemService;
use Illuminate\Validation\Rule;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;
use App\Services\EmployeeTabAuthorityService;
use App\Helpers\Service;

class EQ0101Controller extends Controller
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
	 * getIndex
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.home');
		$data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.employee_information_view');
		$data['disabled'] = 'disabled';
		$data['screen_use'] = 'EQ0101';
		// get data from url query
		$redirect_param = $request->redirect_param ?? '';
		if ($redirect_param != '') {
			try {
				$redirect_param = json_decode(Crypt::decryptString($redirect_param));
			} catch (DecryptException $e) {
				return response()->view('errors.403');
			}
		}
		$reqs = [
			'from'  => $redirect_param->from ?? '',
			'employee_cd'   => $redirect_param->employee_cd ?? '',
		];
		$validator = Validator::make($reqs, [
			'from'  => [
				'string',
				Rule::in(['q0070', 'sq0070', 'eq0100']),
			],
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data['screen_from']           = htmlspecialchars($reqs['from']);
		
		$request->employee_cd     =     $redirect_param->employee_cd ?? '';
		
		$refer = $this->referDefault($request);

		$data['tab_01'] = $this->refer01($request);
		// tab_02
		$refer['tab_02'] = $this->referTab02($request);
		// tab_03
		$refer['tab_03'] = $this->referTab03($request);
		// tab_05
		$refer['tab_05'] = $this->referTab05($request);
		// tab_08
		$refer['tab_08'] = $this->referTab08($request);
		// tab_09
		$refer['tab_09'] = $this->referTab09($request);
		// tab_13
		$refer['tab_12'] = $this->referTab12($request);
		// tab_13
		$refer['tab_13'] = $this->referTab13($request);
		// tab_06
		$refer['tab_06'] = $this->referTab06($request);
		// tab_18
		$refer['tab_18'] = $this->referTab18($request);
		// tab_04
		$refer['tab_04'] = $this->referTab04($request);
		// tab_07
		$refer['tab_07'] = $this->referTab07($request);
		// tab_10
		$refer['tab_10'] = $this->referTab10($request);
		// tab_11
		$refer['tab_11'] = $this->referTab11($request);
		if (isset($refer['error_typ']) && $refer['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		return view('EmployeeInfo::eq0101.index', array_merge($data, $refer));
	}

	public function referDefault(Request $request)
	{
		$selected_employee_cd 			=	$request->employee_cd ?? '';
		$params1['employee_cd'] 		= 	$selected_employee_cd;
		$params1['company_cd'] 			= 	session_data()->company_cd;
		$params1['language'] 			= 	session_data()->language;
		$sql1 = Dao::executeSql('SPC_EQ0101_INQ1', $params1);
		// header
		$data['employee_cd'] 			=	$selected_employee_cd;
		$data['table1'] 				= 	$sql1[0][0] ?? [];
		// tab employee
		$data['table2'] 				= 	$sql1[1][0] ?? [];
		// department
		$data['table3'] 				= 	$sql1[2][0] ?? [];
		// m0073
		$data['table4'] 				= 	$sql1[3] ?? [];
		// history
		$data['table5'] 				= 	$sql1[4] ?? [];
		$data['year_grade'] 			= 	$sql1[5][0]['year_grade'] ?? '';
		$data['year_depart'] 			= 	$sql1[6][0]['year_depart'] ?? '';
		// COMMON
		$data['organization_group'] = getCombobox('M0022', 1, 6) ?? [];
		$data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id, 0, $selected_employee_cd);

		// get marcopolo
		$data['marcopolo_use_typ'] 		= 	$sql1[7][0]['marcopolo_use_typ'] ?? 0;
		return $data;
	}

	/**
	 * Refer index tab 02
	 * @author hainn
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function referTab02(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$data['qualification_cd'] = json_encode(getCombobox('M5010', 1, 6), true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 2);
			$data['list']	= $list[0];
			$data['disabled_tab02'] = checkM0070TabIsUsed('M0070_02') == 2?'disabled':'';
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
	public function	referHeader(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 0);
			$data['list']	= $list[0];
			$data['table1'] = $list[0][0] ?? [];
			$data['keep_emp'] = $list[0][0]['keep_emp'] ?? '';
			$data['employee_cd'] = $list[0][0]['employee_cd'] ?? '';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
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
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'], $param['employee_cd'], $param['user_id'], 1);
				$data['data_tab_01'] = $list_data[0][0] ?? [];
			}
			$data['blood_type'] = getCombobox(52) ?? [];
			$data['headquarters_prefectures'] = getCombobox('L0011', 1, 6) ?? [];
			$data['possibility_transfer'] = getCombobox(53) ?? [];
			$data['nationality'] = json_encode(getCombobox('L0012', 1, 6), true) ?? '';
			$data['status_residence'] = getCombobox(54) ?? [];
			$data['permission_activities'] = getCombobox(55) ?? [];
			$data['disability_classification'] = getCombobox(56) ?? [];
			$data['style'] = getCombobox(18) ?? [];
			$data['company_cd'] = $param['company_cd'];
			$data['disabled_tab01'] = 'disabled';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 05
	 * @author hainn
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab05(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? ''; //mode:1 for refer and not mode return data
			$data['final_education_kbn'] = getCombobox(61) ?? [];
			$data['graduation_school_cd'] = json_encode(getCombobox('L0013', 1, 4) ?? '');
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 5);
			$data['m0078']	= $list[0];
			$data['m0079']	= $list[1];
			$data['disabled_tab05'] = checkM0070TabIsUsed('M0070_05') == 2?'disabled':'';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 09
	 * @author quanlh
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab09(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}

			$employee_cd = $request->employee_cd ?? '';
			//mode:1 for refer and not mode return data
			// $mode = $request->mode ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 9);
			$data['list']	= $list[0];
			$data['disabled_tab09'] = checkM0070TabIsUsed('M0070_09') == 2?'disabled':'';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 13
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab13(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
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

			$data['group_trp'] = json_encode($result[0], true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'], $param['employee_cd'], $param['user_id'], 13);
			$data['list']	= $list[0];
			$data['disabled_tab13'] = checkM0070TabIsUsed('M0070_13') == 2?'disabled':'';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 06
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab06(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
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
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'], $param['employee_cd'], $param['user_id'], 6);
				$data['data_tab_06'] = $list_data[0][0] ?? [];
			}
			$data['owning_house_kbn'] = getCombobox(62) ?? [];
			$data['relationship'] = json_encode(getCombobox(63), true) ?? '';
			$data['company_cd'] = $param['company_cd'];
			$data['disabled_tab06'] = checkM0070TabIsUsed('M0070_06') == 2?'disabled':'';
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
	public function referTab08(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
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
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 8);
			$data['list']	= $list;
			$data['disabled_tab08'] = checkM0070TabIsUsed('M0070_08') == 2?'disabled':'';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}
	/**
	 * Refer index tab 12
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab12(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
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
				$list_data = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'], $param['employee_cd'], $param['user_id'], 12);
				$data['data_tab_12'] = $list_data[0][0] ?? [];
			}
			$data['company_cd'] = $param['company_cd'];
			$data['disabled_tab12'] = checkM0070TabIsUsed('M0070_12') == 2?'disabled':'';
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
	public function referTab03(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			// $mode = $request->mode ?? '';
			$data['M5031'] = getCombobox('M5031', 1, 6) ?? [];
			$data['M5032'] = getCombobox('M5032', 1, 6) ?? [];
			$data['L0010_59'] = getCombobox(59);
			$data['L0010_60'] = getCombobox(60);
			$data['trainings'] = json_encode(getCombobox('M5030', 1, 6), true) ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 3);
			$data['list']	= $list[0];
			$data['disabled_tab03'] = 'disabled';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer m0070 tab 18
	 * @author manhnd
	 * @created at 2024/04/03 
	 * @return \Illuminate\Http\Response
	 */
	public function referTab18(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			$mode = $request->mode ?? '';
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 18);
			$data['list']	= $list[0][0]['fiscal_year'] != '' ? $list[0] : [];
			$data['head']	= $list[1] ?? [];
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
	public function	referTab04(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			//mode:1 for refer and not mode return data
			$mode = $request->mode ?? '';

			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 4);
			if ((isset($list[0][0]['error_typ']) && $list[0][0]['error_typ'] == '999')) {
				return response()->view('errors.query', [], 501);
			}
			$data['list_data_1'] = $list[0] ?? [];
			$data['list_data_2'] = $list[1] ?? [];
			$data['disabled_tab04'] = 'disabled';
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 07
	 * @author quanlh
	 * @created at 
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab07(Request $request)
	{
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

			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab($param['company_cd'], $param['employee_cd'], $param['user_id'], 7);
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
	public function	referTab10(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				// 'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			// $mode = $request->mode ?? ''; //mode:1 for refer and not mode return data

			$data['data_76'] = getCombobox(76) ?? [];
			$list = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd,$employee_cd, session_data()->user_id, 10);
			$data['language'] = $list[0][0] ?? [];
			$data['m0088'] = $list[1] ?? [];
			$data['disabled_tab10'] = checkM0070TabIsUsed('M0070_10') == 2?'disabled':'';
			// if ($mode != '') {
			// 	if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
			// 		return response()->view('errors.query', [], 501);
			// 	}
			// 	$response['tab_10'] = $data;
			// 	$response['check_lang'] = session_data()->language ?? '';
			// 	$response['disabled'] = '';
			// 	return view('BasicSetting::m0070.m0070_10', $response);
			// }
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	 * Refer index tab 11
	 * @author hainn
	 * @created at
	 * @return \Illuminate\Http\Response
	 */
	public function	referTab11(Request $request)
	{
		try {
			$validator = Validator::make($request->all(), [
				'employee_cd' 			=> 'max:10',
				// 'mode'					=> 'int'
			]);

			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$employee_cd = $request->employee_cd ?? '';
			// $mode = $request->mode ?? ''; //mode:1 for refer and not mode return data

			$data['data_71'] = getCombobox(71) ?? [];
			$data['data_72'] = json_encode(getCombobox(72) ?? []);
			$data['data_73'] = json_encode(getCombobox(73) ?? []);
			$data['data_74'] = json_encode(getCombobox(74) ?? []);
			$data['list'] = $this->employeeTabAuthorityService->findEmployeeInformationByTab(session_data()->company_cd, $employee_cd, session_data()->user_id, 11);
			$data['m0090'] = $data['list'][0][0] ?? [];
			$data['disabled_tab11'] = checkM0070TabIsUsed('M0070_11') == 2?'disabled':'';
			// if ($mode != '') {
			// 	if ((isset($data['list'][0][0]['error_typ']) && $data['list'][0][0]['error_typ'] == '999')) {
			// 		return response()->view('errors.query', [], 501);
			// 	}
			// 	$response['tab_11'] = $data;
			// 	$response['check_lang'] = session_data()->language ?? '';
			// 	$response['disabled'] = '';
			// 	return view('BasicSetting::m0070.m0070_11', $response);
			// }
			return $data;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
	}

	/**
	* get excel file 分析（提出率）
	* @author quanlh
	* @created at 2024-04-15
	* @return void
	*/
   public function postExportExcel(Request $request)
   {     
	try {	
			$data_request = $request->json()->all()['data_sql'];
			$employee_cd = $data_request['employee_cd'] ?? '';
		   	$params = array(
				$employee_cd, session_data()->company_cd, session_data()->user_id
		   	);
		   
		   $store_name = 'SPC_eQ0101_RPT1';
		   $typeReport = 'FNC_OUT_EXL';
		   $screen = 'EQ0101';
		   $file_name = 'eQ0101_' . time() . '.xlsx';
		   date_default_timezone_set('Asia/Tokyo');
		   $time = date('YmdHis');
		   $service = new Service();
		   $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
		   //dd($result);
		   if (isset($result['filename'])) {
			   $result['path_file'] =  '/download/' . $result['filename'];
		   }
		   $name = '社員情報閲覧_';
		   if (session_data()->language == 'en') {
			   $name = 'EmployeeInformationView_';
		   }
		   $result['fileNameSave'] =   $name . $time . '.xlsx';
		   $this->respon = $result;
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		// return http request
		return response()->json($this->respon);
	}
}
