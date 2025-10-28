<?php

namespace App\Modules\Common\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Dao;
use DateTime;
use App\Mail\InterviewSchedule;
use App\Services\MyPurposeService;
use Illuminate\Support\Facades\Mail;
use Session;
use Cookie;
use App\Services\MiraiService;
use App\Services\WeeklyReport\PersonalTargetService;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\SettingService;
use App\Services\EmployeeInformation\PersonalRegistration;
use App\Helpers\UploadCore;
use Carbon\Carbon;
use App\Services\EmployeeTabAuthorityService;
use App\Services\EmployeeInformation\EmployeeInfor;
use App\Services\GoogleService;

class PopupController extends Controller
{
	/** MyPurposeService */
	private $my_purpose;
	/** MiraiService */
	private $mirai_service;
	/** PersonalTargetService */
	public $target_service;
	/** WeeklyReportService */
	public $weeklyreport_service;
	/** SettingService */
	public $setting_service;
	/** PersonalRegistration */
	public $personal_service;
	/** employeeTabAuthorityService */
	protected $employee_tab_auth_service;
	/** employeeTabAuthorityService */
	protected $employee_infor;

	public function __construct(
		MyPurposeService $my_purpose,
		MiraiService $mirai_service,
		PersonalTargetService $target_service,
		WeeklyReportService $weeklyreport_service,
		SettingService $setting_service,
		PersonalRegistration $personal_service,
		EmployeeTabAuthorityService $employee_tab_auth_service,
		EmployeeInfor $employee_infor
	) {
		parent::__construct();
		$this->my_purpose = $my_purpose;
		$this->mirai_service = $mirai_service;
		$this->target_service = $target_service;
		$this->weeklyreport_service = $weeklyreport_service;
		$this->setting_service = $setting_service;
		$this->personal_service = $personal_service;
		$this->employee_tab_auth_service = $employee_tab_auth_service;
		$this->employee_infor = $employee_infor;
	}

	/**
	 * Show the application index.
	 * @author viettd
	 * @created at 2017-08-18 06:38:35
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['title'] = 'Common';
		return view('Common::popup.index', $data);
	}

	/**
	 * change password
	 * @author tuantv
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function change_pass(Request $request)
	{
		$data['title'] = trans('messages.change_password');
		$data['user_id']      =   session_data()->user_id;
		return view('Common::popup.change_pass', $data);
	}

	/**
	 * change_language
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function change_language(Request $request)
	{
		$data['title'] = trans('messages.language_setting');
		$data['user_id']      =   session_data()->user_id;
		$data['language'] = Session::get('website_language');
		$data['L0010'] = getCombobox('29', 0) ?? [];
		return view('Common::popup.change_language', $data);
	}

	/**
	 * change_language_save
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function change_language_save(Request $request)
	{
		if ($request->ajax()) {
			try {
				$params['company_cd'] = session_data()->company_cd;
				$params['user_id'] = session_data()->user_id;
				$params['language'] = $request->id ?? 1;
				$params['cre_user'] = session_data()->user_id;
				$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
				//
				$result = Dao::executeSql('SPC_CHANGE_LANGUAGE_ACT1', $params);
				// check exception
				if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				}
			} catch (\Exception $e) {
				$this->respon['status'] = EX;
				$this->respon['Exception'] = $e->getMessage();
			}
			if ($request->id == 2) {
				session_data()->language = 'en';
				Session::put('website_language', 'en');
				config(['app.locale' => 'en']);
				$timeout = config('session.lifetime');
				Cookie::queue('language', [
					'language'              => 'en',
				], $timeout);
			} else {
				Session::put('website_language', 'jp');
				session_data()->language = 'jp';
				config(['app.locale' => 'jp']);
				$timeout = config('session.lifetime');
				Cookie::queue('language', [
					'language'              => 'jp',
				], $timeout);
			}
			return response()->json($this->respon);
		}
	}

	/**
	 * change password save
	 * @author tuantv
	 * @created at 2018-09-11 12:00:00
	 * @return void
	 */
	public function change_pass_save(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json'] = $this->respon['data_sql'];
					$params['cre_user'] = session_data()->user_id;
					$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
					$params['company_cd'] = session_data()->company_cd;
					//
					$result = Dao::executeSql('SPC_CHANGE_PASS_ACT1', $params);
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
						$this->respon['job_cd'] = $result[1][0]['job_cd'];
					}
				}
			} catch (\Exception $e) {
				$this->respon['status'] = EX;
				$this->respon['Exception'] = $e->getMessage();
			}
			return response()->json($this->respon);
		}
	}

	/**
	 * show list employee in 人事評価
	 * @author viettd
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getEmployee(Request $request)
	{
		$data['title'] = trans('messages.employee_search');
		$param['company_cd'] = session_data()->company_cd;
		$param['user_id'] = session_data()->user_id;
		$authority_typ = session_data()->authority_typ;
		$system = 1;
		// add by viettd 2021/06/11
		$parent_url = explode('/', $_SERVER['HTTP_REFERER']);
		$prefix = $parent_url[3];
		if ($prefix == 'basicsetting') {
			$system = 4;
			$referSearch = $this->postSearch($request, 4);
		} else {
			$system = 1;
			$referSearch = $this->postSearch($request, 1);
		}
		$data['system'] = $system;
		$param['system'] = $system;
		$data_init = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['data_init'] 				= 	$data_init ?? [];
		$data['organization_group'] 	= 	getCombobox('M0022', 1) ?? [];
		$data['authority_typ']          = 	$authority_typ;
		if (isset($referSearch['error_typ']) && $referSearch['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		return view('Common::popup.employee', array_merge($data, $referSearch));
	}
	/**
	 * show list employee in mulitireview
	 * @author datnt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getMultiSelectEmployee(Request $request)
	{
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['title'] 					= 	trans('messages.employee_search');
		$param['company_cd'] 			= 	session_data()->company_cd;
		$param['user_id'] 				= 	session_data()->user_id;
		$param['system'] 				= 	3;
		$authority_typ					=	session_data()->authority_typ;
		$data_init 						= 	Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['data_init'] 				= 	$data_init ?? [];
		$data['organization_group'] 	= 	getCombobox('M0022', 1) ?? [];
		$data['authority_typ']          = 	$authority_typ;
		$data['fiscal_year']          	= 	$param_reqs['fiscal_year'] ?? 0;
		$data['mulitiselect_mode']      = 	$param_reqs['mulitiselect_mode'] ?? 0;
		$data['class_select']      		= 	$param_reqs['class_select'] ?? '';
		$referSearch 					= 	$this->postSearchMulitiselect($request);
		return view('Common::popup.multiselectemployee', array_merge($data, $referSearch));
	}
	/**
	 *  post search employee in mulitireview search data
	 * @author datnt
	 * @created at 2018-08-21
	 * @return \Illuminate\Http\Response
	 */
	public function postSearch(Request $request, $system = 1)
	{
		$validator = Validator::make($request->all(), [
			'fiscal_year'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//add vietdt 2022/04/08
		$fiscal_year = $request->fiscal_year ?? date('Y');
		if ($fiscal_year <= 0) {
			$fiscal_year = date('Y');
		}
		//initial
		$data = [
			'company_cd' 			=> session_data()->company_cd,
			'user_id' 				=> session_data()->user_id,
			'employee_cd' 			=> '',
			'employee_ab_nm' 		=> '',
			'office_cd'				=> -1,
			'list_org' 				=> '',
			'job_cd' 				=> -1,
			'position_cd'			=> -1,
			'company_out_dt_flg' 	=> 0,
			'fiscal_year'  			=> $fiscal_year ?? 0,
			'page_size' 			=> 20,
			'page'					=> 1,
			'system'				=> $system,
		];
		$res = Dao::executeSql('SPC_EMPLOYEE_FND1', $data);
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			return ['error_typ' => '999'];
		}
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, $system) ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, $system);
		// get request with param =>> check security
		if ($request->ajax()) {
			$data 							= 	$request->data;
			$validator = Validator::make($data, [
				'employee_cd'				=> 'max:10',
				'employee_ab_nm'			=> 'max:50',
				'page' 						=> 'integer', //Must be a number and length of value is 8
				'page_size' 				=> 'integer',
				'office_cd'					=> 'integer',
				'job_cd'					=> 'integer',
				'position_cd'				=> 'integer',
				'company_out_dt_flg'		=> 'integer',
				'fiscal_year'  				=> 'integer',
			]);
			// validate
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			// data check os
			$data_os = [
				'employee_cd' 		=> $data['employee_cd'] ?? '',
				'employee_ab_nm'	=> $data['employee_ab_nm'] ?? ''
			];
			if (!validateCommandOSArray($data_os)) {
				return response()->view('errors.query', [], 400);
			}
			// $authority_typ					=	session_data()->authority_typ;
			$param_json['list_organization_step1']          = json_decode($data['organization_step1']) ?? [];
			$param_json['list_organization_step2']          = json_decode($data['organization_step2']) ?? [];
			$param_json['list_organization_step3']          = json_decode($data['organization_step3']) ?? [];
			$param_json['list_organization_step4']          = json_decode($data['organization_step4']) ?? [];
			$param_json['list_organization_step5']          = json_decode($data['organization_step5']) ?? [];
			//TODO Handle your data
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			//
			$params = [
				'company_cd' 		=> 	session_data()->company_cd,
				'user_id' 			=> 	session_data()->user_id,
				'employee_cd' 		=> 	$data['employee_cd'] ?? '',
				'employee_ab_nm' 	=> 	$data['employee_ab_nm'] ?? '',
				'office_cd' 		=>  $data['office_cd'] ?? -1,
				'list_org' 			=> 	$json ?? '',
				'job_cd' 			=>  $data['job_cd'] ?? -1,
				'position_cd'		=>  $data['position_cd'] ?? -1,
				'company_out_dt_flg' =>  $data['company_out_dt_flg'] ?? 0,
				'fiscal_year'		=> 	$data['fiscal_year'] ?? 0,
				'page_size' 		=>  $data['page_size'] ?? 20,
				'page' 				=>  $data['page'] ?? 1,
				'system'			=>	$data['system'] ?? 1,
			];
			$res = Dao::executeSql('SPC_EMPLOYEE_FND1', $params);
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			$data['list'] = $res[0] ?? [];
			$data['paging'] = $res[1][0] ?? [];
			$data['organization_group'] = getCombobox('M0022', 1, $system) ?? [];
			$data['combo_organization'] = getCombobox('M0020', 1, $system);
			$mode = $data['mode'] ?? 0;
			if ($mode == 1) {
				return view('Common::popup.search_multiselect_employee', $data)->render();
			} else {
				return view('Common::popup.search_employee', $data)->render();
			}
		} else {
			return $data;
		}
	}

	/**
	 * postSearchMulitiselect
	 *
	 * @param  mixed $request
	 * @return void
	 */
	public function postSearchMulitiselect(Request $request)
	{
		//initial
		$validator = Validator::make($request->all(), [
			'fiscal_year'  => 'integer',
			'mulitiselect_mode' => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data = [
			'company_cd' 		=> session_data()->company_cd,
			'user_id' 			=> session_data()->user_id,
			'employee_cd' 		=>  '',
			'employee_ab_nm' 	=>  '',
			'office_cd'			=>  -1,
			'list_org' 			=>  '',
			'job_cd' 			=>  -1,
			'position_cd'		=>   -1,
			'company_out_dt_flg' =>  0,
			'fiscal_year'  		=>  $request->fiscal_year ?? 0,
			'page_size' 		=>   20,
			'page'				=>   1,
			'mulitiselect_mode'	=>	$request->mulitiselect_mode ?? 1,
		];

		$res = Dao::executeSql('SPC_MULITISELECT_EMPLOYEE_FND1', $data);
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			return ['error_typ' => '999'];
		}
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1) ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 3);
		// get request with param =>> check security
		if ($request->ajax()) {
			$data 							= 	$request->data;
			$validator = Validator::make($data, [
				'employee_cd'				=> 'max:10',
				'employee_ab_nm'			=> 'max:50',
				'page' 						=> 'integer', //Must be a number and length of value is 8
				'page_size' 				=> 'integer',
				'office_cd'					=> 'integer',
				'job_cd'					=> 'integer',
				'position_cd'				=> 'integer',
				'company_out_dt_flg'		=> 'integer',
				'mulitiselect_mode' 		=> 'integer',
				'fiscal_year'  				=> 'integer',
			]);
			// validate
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			// data check os
			$data_os = [
				'employee_cd' 		=> $data['employee_cd'] ?? '',
				'employee_ab_nm'	=> $data['employee_ab_nm'] ?? ''
			];
			if (!validateCommandOSArray($data_os)) {
				return response()->view('errors.query', [], 400);
			}
			$param_json['list_organization_step1']          = json_decode($data['organization_step1']) ?? [];
			$param_json['list_organization_step2']          = json_decode($data['organization_step2']) ?? [];
			$param_json['list_organization_step3']          = json_decode($data['organization_step3']) ?? [];
			$param_json['list_organization_step4']          = json_decode($data['organization_step4']) ?? [];
			$param_json['list_organization_step5']          = json_decode($data['organization_step5']) ?? [];
			//TODO Handle your data
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			//
			$params = [
				'company_cd' 			=> 	session_data()->company_cd,
				'user_id' 				=> 	session_data()->user_id,
				'employee_cd' 			=> 	$data['employee_cd'] ?? '',
				'employee_ab_nm' 		=> 	$data['employee_ab_nm'] ?? '',
				'office_cd' 			=>  $data['office_cd'] ?? -1,
				'list_org' 				=> 	$json ?? '',
				'job_cd' 				=>  $data['job_cd'] ?? -1,
				'position_cd'			=>  $data['position_cd'] ?? -1,
				'company_out_dt_flg'	=>  $data['company_out_dt_flg'] ?? 0,
				'fiscal_year'			=> 	$data['fiscal_year'] ?? 0,
				'page_size' 			=>  $data['page_size'] ?? 20,
				'page' 					=>  $data['page'] ?? 1,
				'mulitiselect_mode'		=>	$data['mulitiselect_mode'] ?? 1,
			];
			$res = Dao::executeSql('SPC_MULITISELECT_EMPLOYEE_FND1', $params);
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			$data['list'] = $res[0] ?? [];
			$data['paging'] = $res[1][0] ?? [];
			$data['organization_group'] = getCombobox('M0022', 1) ?? [];
			$data['combo_organization'] = getCombobox('M0020', 1, 3);
			$mode = $data['mode'] ?? 0;
			if ($mode == 1) {
				return view('Common::popup.search_multiselect_employee', $data)->render();
			} else {
				return view('Common::popup.search_employee', $data)->render();
			}
		} else {
			return $data;
		}
	}
	/**
	 * show list employee in customer module
	 * @author tuantv
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getEmployeeCustomer(Request $request)
	{
		$data['title'] 			= trans('messages.employee_search');
		//$params = $request->all();
		$data['customer_typ']	= $request->customer_typ ?? 0;
		$data['organization_group'] 	= 	getCombobox('M0022', 1) ?? [];
		$left = $this->postSearchCustomer($request);
		return view('Common::popup.employee_customer', array_merge($data, $left));
	}
	/**
	 * search data employee in customer module
	 * @author tuantv
	 * @created at 2018-08-21
	 * @return \Illuminate\Http\Response
	 */
	public function postSearchCustomer(Request $request)
	{
		$data 			= $request->data;
		$customer_typ	= $data['customer_typ'] ?? 0;
		$param_json['list_organization_step1']          = json_decode($data['organization_step1']??'') ?? [];
		$param_json['list_organization_step2']          = json_decode($data['organization_step2']??'') ?? [];
		$param_json['list_organization_step3']          = json_decode($data['organization_step3']??'') ?? [];
		$param_json['list_organization_step4']          = json_decode($data['organization_step4']??'') ?? [];
		$param_json['list_organization_step5']          = json_decode($data['organization_step5']??'') ?? [];
		//
		$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
		if (!validateCommandOSArray($data)) {
			return abort(500);
		} else {
			$params = [
				'company_cd' 		=> 1,  // customer search only company = 1
				'user_id' 			=> session_data()->user_id,
				'employee_cd' 		=> SQLEscape(preventOScommand($data['employee_cd']??'')) ?? '',
				'employee_ab_nm' 	=> SQLEscape(preventOScommand($data['employee_ab_nm']??'')) ?? '',
				'office_cd' 		=> intval($data['office_cd']??'') > 0 ? intval(preventOScommand($data['office_cd']??'')) : -1,
				'list_org' 			=> $json ?? '',
				'job_cd' 			=> intval($data['job_cd']??'') > 0 ? intval(preventOScommand($data['job_cd']??'')) : -1,
				'position_cd' 		=>  intval($data['position_cd']??'') > 0 ? intval(preventOScommand($data['position_cd']??'')) : -1,
				'company_out_dt_flg' => intval(preventOScommand($data['company_out_dt_flg']??'')) ?? 0,
				'fiscal_year'		=> 	date('Y'),
				'page_size' 		=>  intval($data['page_size']??'') > 0 ? intval(preventOScommand($data['page_size']??'')) : 20,
				'page' 				=>  intval($data['page']??'') > 0 ? intval(preventOScommand($data['page']??'')) : 1,
			];
			//
			$param2['company_cd'] 		= 1;
			$data_init = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param2);
			$data = $params;
			$res = Dao::executeSql('SPC_EMPLOYEE_FND1', $params);
			$data['data_init'] = $data_init ?? [];
			$data['list'] = $res[0] ?? [];
			$data['paging'] = $res[1][0] ?? [];
			$data['organization_group'] = getCombobox('M0022', 1) ?? [];
			$data['combo_organization'] = getCombobox('M0020', 1, 1);
			// render view
			if ($request->ajax()) {
				return view('Common::popup.search_employee_customer', $data)->render();
			} else {
				return $data;
			}
		}
	}

	/**
	 * show list getInformation
	 * @author longvv
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getInformation(Request $request)
	{
		$data['title'] 					= 	trans('messages.information');
		//
		if ($this->validateDate($request->infomation_date)) {
			$infomation_date		=	$request->infomation_date;
		} else {
			$infomation_date	=	NULL;
		}
		//
		$param['company_cd'] 			= 	$request->company_cd ?? 0;
		$param['category'] 				= 	preventOScommand($request->category) ?? 0;
		$param['status_cd'] 			= 	preventOScommand($request->status_cd) ?? 0;
		$param['infomationn_typ']		=	preventOScommand($request->infomationn_typ) ?? 0;
		$param['infomation_date']		= 	$infomation_date;
		$param['target_employee_cd']	=	SQLEscape(preventOScommand($request->target_employee_cd)) ?? '';
		$param['sheet_cd']				=	preventOScommand($request->sheet_cd) ?? 0;
		$param['employee_cd']			=	SQLEscape(preventOScommand($request->employee_cd)) ?? '';
		$param['fiscal_year']			=	$request->fiscal_year;
		$param['cre_user']         		=   session_data()->user_id;
		$param['cre_ip']           		=   $_SERVER['REMOTE_ADDR'];

		$rules = [
			'company_cd' 		=> 'integer', //Must be a number
			'category' 			=> 'integer',
			'status_cd' 		=> 'integer',
			'infomationn_typ' 	=> 'integer',
			'sheet_cd' 			=> 'integer',
			'fiscal_year' 		=> 'integer',
		];

		$validator = Validator::make($param, $rules);
		if ($validator->passes()) {
			$result							= 	Dao::executeSql('SPC_INFORMATION_INQ1', $param);
			if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			$data['row'] 					= 	$result[0][0] ?? [];
			return view('Common::popup.getinformation', $data);
		} else {
			return response()->view('errors.query', [], 501);
		}
	}
	/**
	 * information search
	 * @author longvv
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function Information(Request $request)
	{
		$data['title'] 			   = trans('messages.information_search');
		$user_id                   = session_data()->user_id;
		$cache                     = getCache('searchinfomation', $user_id);
		if ($cache) {
			$request->data 			=	$cache;
		}
		$data['cache']             	= 	$cache ?? [];
		$referSearch 				= 	$this->postSearchInformation($request);
		return view('Common::popup.information', array_merge($data, $referSearch));
	}

	/**
	 * information post search
	 * @author tuantv
	 * @created at 2018-08-21
	 * @return \Illuminate\Http\Response
	 */
	public function postSearchInformation(Request $request)
	{
		$params = [
			'infomation_date_from' 			=> 	'',
			'infomation_date_to' 			=> 	'',
			'infomation_title' 				=> 	'',
			'confirmation_datetime_flg' 	=> 	0,
			'company_cd' 					=> 	session_data()->company_cd,
			'user_id' 						=> 	session_data()->user_id,
			'page_size' 					=>  20,
			'page' 							=>  1,
		];
		$res = Dao::executeSql('SPC_INFORMATION_FND1', $params);
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		// render view
		if ($request->ajax()) {
			$data 			= $request->data;
			$validator = Validator::make($data, [
				'confirmation_datetime_flg' => 'integer',
				'page_size'	 				=> 'integer',
				'page' 						=> 'integer',
				'infomation_date_from'		=> 'date_format:"Y/m/d"',
				'infomation_date_to' 		=> 'date_format:"Y/m/d"',
				'infomation_title'			=> 'max:50'
			]);
			// validate
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			// data check os
			$data_os = [
				'infomation_date_from' 			=> 	$data['infomation_date_from'] ?? '',
				'infomation_date_to' 			=> 	$data['infomation_date_to'] ?? '',
				'infomation_title' 				=> 	$data['infomation_title'] ?? '',
			];
			if (!validateCommandOSArray($data_os)) {
				return response()->view('errors.query', [], 400);
			}
			$params = [
				'infomation_date_from' 			=> 	$data['infomation_date_from'] ?? '',
				'infomation_date_to' 			=> 	$data['infomation_date_to'] ?? '',
				'infomation_title' 				=> 	SQLEscape($data['infomation_title']) ?? '',
				'confirmation_datetime_flg' 	=> 	$data['confirmation_datetime_flg'] ?? 0,
				'company_cd' 					=> 	session_data()->company_cd,
				'user_id' 						=> 	session_data()->user_id,
				'page_size' 					=>  $data['page_size'] ?? 20,
				'page' 							=>  $data['page'] ?? 1,
			];
			$res = Dao::executeSql('SPC_INFORMATION_FND1', $params);
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			$data['list'] = $res[0] ?? [];
			$data['paging'] = $res[1][0] ?? [];
			return view('Common::popup.search_information', $data)->render();
		} else {
			return $data;
		}
	}
	/**
	 * show list document
	 * @author viettd
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getDocument(Request $request)
	{
		if (session()->has(CUSTOMER_KEY) || session()->has(AUTHORITY_KEY)) {
			$data['title'] 		= 	'ダウンロード';
			$param_reqs = $request->all() ?? [];
			$validator = Validator::make($param_reqs, [
				'module_typ'  => 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$module_typ = $param_reqs['module_typ'] ?? 1;	// 1. eval 2.1on1 3.mulitireview
			// default eval
			$folder = public_path() . '/manual/';
			// 1on1
			if ($module_typ == 2) {
				$folder = public_path() . '/oneonone_manual/';
				// mulitireview
			} else if ($module_typ == 3) {
				$folder = public_path() . '/mulitiview_manual/';
			}
			// 
			if (!file_exists($folder)) {
				return;
			}
			$files1 = array_diff(scandir($folder), array('..', '.'));
			foreach ($files1 as $key => $value) {
				$files1[$key] = mb_convert_encoding(trim($files1[$key]), "UTF-8", "ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS");
			}
			$data['files']	=	$files1;
			$data['module_typ'] = $module_typ;
			//
			return view('Common::popup.document', $data);
		} else {
			return response()->view('errors.405');
		}
	}

	/**
	 * validateDate
	 *
	 * @param  date $date
	 * @return date
	 */
	function validateDate($date)
	{
		$d = DateTime::createFromFormat('Y/m/d', $date);
		return $d && $d->format('Y/m/d') == $date;
	}

	/**
	 * getOrganization
	 *
	 * @param  mixed $request
	 * @return void
	 */
	public function getOrganization(Request $request)
	{
		$res = Dao::executeSql('SPC_M0020_INQ2', ['company_cd' => session_data()->company_cd]);
		$data['title'] =  trans('messages.change_org_name');
		$data['data'] = $res[0] ?? [];
		if ((session_data()->language == 'en')) {
			foreach ($data['data'] as $i => $val) {
				if (mb_convert_kana($val['organization_group_nm'], "rnaskhc") == '組織' . ($i + 1)) {
					$data['data'][$i]['organization_group_nm'] = 'Department ' . ($i + 1);
				}
			}
		}
		if ((session_data()->language == 'jp')) {
			foreach ($data['data'] as $i => $val) {
				if ($val['organization_group_nm'] == 'Department ' . ($i + 1)) {
					$data['data'][$i]['organization_group_nm'] = '組織' . ($i + 1);
				}
			}
		}
		return view('Common::popup.get_organization', $data);
	}
	/**
	 * show list question
	 * @author duongntt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function Question(Request $request)
	{
		$data['title'] 				= trans('messages.question_search');
		$company_cd                 = session_data()->company_cd;
		$cache                      = getCache('searchinfomation', $company_cd);
		if ($cache) {
			$request->data 			=	$cache;
		}
		$data['cache']             	= 	$cache ?? [];
		$referSearch 				= 	$this->postSearchQuestion($request);
		return view('Common::popup.question', array_merge($data, $referSearch));
	}
	/**
	 * popup meeting setting
	 * @author duongntt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function settingMeeting(Request $request)
	{
		$params = [
			'company_cd' 					=> 	session_data()->company_cd,
			'fiscal_year' 					=>  $request->fiscal_year ?? '',
			'employee_cd' 					=>  $request->employee_cd ?? '',
			'times' 						=>  $request->times ?? '',
			'from' 							=>  $request->from ?? '',
			'cre_employee_cd' 				=>	session_data()->employee_cd,
		];
		$data = $params;
		$res = Dao::executeSql('SPC_1on1_GET_SETTING_METTING_INQ1', $params);
		$data['title'] = trans('messages.scheduled_registration');
		$data['data'] = $res[0][0] ?? [];
		$data['permission'] = $res[1][0]['permission'] ?? 0;
		return view('Common::popup.setupMetting', $data);
	}
	/**
	 * popup meeting setting
	 * @author duongntt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function saveSettingMeeting(Request $request)
	{
		if ($request->ajax()) {
			$this->respon['status'] = OK;
			$this->respon['errors'] = [];
			$data_request = $request->json()->all()['data_sql'];
			$validator = Validator::make($data_request, [
				'fiscal_year' => 'integer',
				'times' => 'integer',
				'mail_check' => 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$params['company_cd']       = session_data()->company_cd;
			$params['json']             = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			$params['cre_user']         = session_data()->user_id;
			$params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
			$res = Dao::executeSql('SPC_SETTING_MEETING_ACT1', $params);
			$mail_info = $res[1][0] ?? [];
			// check error
			if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			} else if (isset($res[0]) && !empty($res[0])) {
				$this->respon['status'] = NG;
				foreach ($res[0] as $temp) {
					array_push($this->respon['errors'], $temp);
				}
			}
			// when not error
			$mail_info['subject']	= '1on1実施予定日が登録されました。';
			$this->respon['mail_info'] = $mail_info;
			$this->respon['mail_check'] = $data_request['mail_check'] ?? 0;

			// $member_mail 			= $mail_info['member_mail'] ?? '';
			// $coach_mail 			= $mail_info['coach_mail'] ?? '';
			// $mail_check 			= $data_request['mail_check'] ?? 0;
			// 
			// if ($mail_check == 1) {
			// 	try {
			// 		// check member_mail blank
			// 		if ($member_mail == '' && $coach_mail == '') {
			// 			$this->respon['status_mail'] = 134; // message_no = 134.メールアドレスが設定されていません。
			// 		} else {
			// 			if ($member_mail != '') {
			// 				Mail::to($member_mail)->send(new InterviewSchedule($mail_info));
			// 			}
			// 			// 
			// 			if ($coach_mail != '') {
			// 				Mail::to($coach_mail)->send(new InterviewSchedule($mail_info));
			// 			}
			// 		}
			// 	} catch (\Exception $e) {
			// 		$this->respon['status_mail'] = EX;
			// 	}
			// }
			// return http request
			return response()->json($this->respon);
		}
	}
	/**
	 * sendMeetingMail
	 *
	 * @param  mixed $request
	 * @return void
	 */
	public function sendMeetingMail(Request $request)
	{
		$this->respon['status'] = OK;
		$this->respon['errors'] = [];
		$mail_info = $request->all();

		$member_mail = $mail_info['member_mail'] ?? '';
		$coach_mail = $mail_info['coach_mail'] ?? '';
		
		$googleMail = new GoogleService();
		try {
			// if $member_mail is exists 
			if ($member_mail != '') {
				if ($mail_info['language_member'] == 2) {
					$mail_info['subject']	= 'The scheduled 1on1 implementation date has been registered.';
					$mail_info['language']	= '2';
				} else {
					$mail_info['language']	= '1';
				}
				

				if (!filter_var($member_mail, FILTER_VALIDATE_EMAIL)) {
					$this->writeLog('Mail format is not correct');
					$this->respon['status']     = NG;
					return response()->json($this->respon);
				}
				// Send mail
					$mail_info['screen_id'] = 'schedule_mail_popup';
					$result = $googleMail->sendInterviewSchedule($member_mail,$mail_info);
					// mail send success
					if ($result['Exception']) {
						$this->respon['status']     = NG;
						// Log
						$this->writeLog('This mail [' . $member_mail . '] is not sent');
						return response()->json($this->respon);
					}
					$this->writeLog('This mail address [' . $member_mail . '] is successful');
				// Mail::to($member_mail)->send(new InterviewSchedule($mail_info));
			}
			// if $coach_mail is exists  
			if ($coach_mail != '') {
		
				if ($mail_info['language_coach'] == 2) {
					$mail_info['subject']	= 'The scheduled 1on1 implementation date has been registered.';
					$mail_info['language']	= '2';
				} else {
					$mail_info['subject']	= '1on1実施予定日が登録されました。';
					$mail_info['language']	= '1';
				}
				if (!filter_var($coach_mail, FILTER_VALIDATE_EMAIL)) {
					$this->writeLog('Mail format is not correct');
					$this->respon['status']     = NG;
					return response()->json($this->respon);
				}
				// Send mail
					$mail_info['screen_id'] = 'schedule_mail_popup';
					$result = $googleMail->sendInterviewSchedule($coach_mail,$mail_info);
					// mail send success
					if ($result['Exception']) {
						$this->respon['status']     = NG;
						// Log
						$this->writeLog('This mail [' . $coach_mail . '] is not sent');
						return response()->json($this->respon);
					}
					$this->writeLog('This mail address [' . $coach_mail . '] is successful');
				// Mail::to($member_mail)->send(new InterviewSchedule($mail_info));
				//Mail::to($coach_mail)->send(new InterviewSchedule($mail_info));
			}
			$this->respon['status']     = OK;
			return response()->json($this->respon);
		} catch (\Exception $e) {
			$this->respon['status'] = EX;
			$this->respon['Exception'] = $e->getMessage();
		}
		return response()->json($this->respon);
		
	}
	/**
	 * popup meeting setting
	 * @author duongntt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function deleteSettingMeeting(Request $request)
	{
		if ($request->ajax()) {
			$this->respon['status'] = OK;
			$this->respon['errors'] = [];
			$data_request = $request->json()->all()['data_sql'];
			$validator = Validator::make($data_request, [
				'fiscal_year'                        => 'integer',
				'times'                              => 'integer',
				'mail_check'                         => 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			} else {
				$params['company_cd']       = session_data()->company_cd;
				$params['json']             = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				$params['cre_user']         = session_data()->user_id;
				$params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
				$res = Dao::executeSql('SPC_SETTING_MEETING_ACT2', $params);
				$mail_info = $res[1] ?? [];
				if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($res[0]) && !empty($res[0])) {
					$this->respon['status'] = NG;
					foreach ($res[0] as $temp) {
						array_push($this->respon['errors'], $temp);
					}
				}
			}
		}
		// return http request
		return response()->json($this->respon);
	}
	/**
	 * search data
	 * @author tuantv
	 * @created at 2018-08-21
	 * @return \Illuminate\Http\Response
	 */
	public function postSearchQuestion(Request $request)
	{
		$params = [
			'category1_cd' 			=> 	$request->category1_cd ?? 0,
			'category2_cd' 			=> 	$request->category2_cd ?? 0,
			'category3_cd' 			=> 	$request->category3_cd ?? 0,
			'refer_kbn' 			=> 	$request->refer_kbn ?? 0,
			'company_cd' 			=> 	session_data()->company_cd,
			'page_size'				=>	$request->page_size ?? 20,
			'page'					=>	$request->page ?? 1,
		];
		$data = $params;
		$rules = [
			'category1_cd'  => 'integer', //Must be a number and length of value is 8
			'category2_cd' 	=> 'integer',
			'category3_cd' 	=> 'integer',
			'refer_kbn'		=> 'integer',
			'page_size'		=> 'integer',
			'page'			=> 'integer',
		];
		$validator = Validator::make($data, $rules);
		if ($validator->passes()) {
			$res = Dao::executeSql('SPC_QUESTION_FND1', $params);
			$data['category1'] = $res[0] ?? [];
			$data['category2'] = $res[1] ?? [];
			$data['category3'] = $res[2] ?? [];
			$data['list'] 	   = $res[3] ?? [];
			$data['paging']   = $res[4][0] ?? [];
		} else {
			return response()->view('errors.query', [], 501);
		}
		if ($request->ajax()) {
			return view('Common::popup.search_question', $data)->render();
		} else {
			return $data;
		}
	}
	/**
	 * show list employee 1on1
	 * @author nghianm
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function getEmployee1on1(Request $request)
	{
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['title'] 					= 	trans('messages.employee_search');
		$param['company_cd'] 			= 	session_data()->company_cd;
		$param['user_id'] 				= 	session_data()->user_id;
		$param['system'] 				= 	2;
		$authority_typ					=	session_data()->authority_typ;
		$data_init 						= 	Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['data_init'] 				= 	$data_init ?? [];
		$data['organization_group'] 					= 	getCombobox('M0022', 1) ?? [];
		$data['system']					=	2;
		$data['authority_typ']          = 	$authority_typ;
		$data['fiscal_year']          	= 	$param_reqs['fiscal_year'] ?? 0;
		$referSearch 					= 	$this->postSearch($request, 2);
		return view('Common::popup.employee', array_merge($data, $referSearch));
	}

	/**
	 * getEmployeeMulitireview
	 *
	 * @param  mixed $request
	 * @return void
	 */
	public function getEmployeeMulitireview(Request $request)
	{
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data['title'] 					= 	trans('messages.employee_search');
		$param['company_cd'] 			= 	session_data()->company_cd;
		$param['user_id'] 				= 	session_data()->user_id;
		$param['system'] 				= 	3;
		$authority_typ					=	session_data()->authority_typ;
		$data_init 						= 	Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['data_init'] 				= 	$data_init ?? [];
		$data['organization_group'] 					= 	getCombobox('M0022', 1) ?? [];
		$data['system']					=	3;
		$data['authority_typ']          = 	$authority_typ;
		$data['fiscal_year']          	= 	$param_reqs['fiscal_year'] ?? 0;
		$referSearch 					= 	$this->postSearch($request, 3);
		return view('Common::popup.employee', array_merge($data, $referSearch));
	}

	/**
	 * getEmployeeWeeklyReport
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function getEmployeeWeeklyReport(Request $request)
	{
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year'  => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data['title'] 					= 	trans('messages.employee_search');
		$param['company_cd'] 			= 	session_data()->company_cd;
		$param['user_id'] 				= 	session_data()->user_id;
		$param['system'] 				= 	5;	// 
		$authority_typ					=	session_data()->authority_typ;
		$data_init 						= 	Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['data_init'] 				= 	$data_init ?? [];
		$data['organization_group'] 	= 	getCombobox('M0022', 1, 5) ?? [];
		$data['system']					=	5;
		$data['authority_typ']          = 	$authority_typ;
		$data['fiscal_year']          	= 	$param_reqs['fiscal_year'] ?? 0;
		$referSearch 					= 	$this->postSearch($request, 5);
		return view('Common::popup.employee', array_merge($data, $referSearch));
	}

	/**
	 * getEmployeeInformation
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function getEmployeeInformation(Request $request)
	{
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year'  => 'integer',
			'system' => 'nullable|integer'
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$system = $param_reqs['system'] ?? 6;
		$data['title'] = trans('messages.employee_search');
		$param['company_cd'] = session_data()->company_cd;
		$param['user_id'] = session_data()->user_id;
		$param['system'] = $system;
		$authority_typ = session_data()->empinfo_authority_typ;
		$data_init = Dao::executeSql('SPC_EMPLOYEE_INQ1', $param);
		// errors
		if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['data_init'] = $data_init ?? [];
		$data['organization_group'] = getCombobox('M0022', 1, $system) ?? [];
		$data['system'] = $system;
		$data['authority_typ'] = $authority_typ;
		$data['fiscal_year'] = $param_reqs['fiscal_year'] ?? 0;
		$referSearch =  $this->postSearch($request, $system);
		return view('Common::popup.employee', array_merge($data, $referSearch));
	}

	/**
	 * show list Employee Comprehensive Manager
	 * @author vietdt
	 * @created at 2021-05-17
	 * @return void
	 */
	public function getEmployeeComprehensiveManager(Request $request)
	{
		$data['title'] 					= 	trans('messages.administrator_list');
		$referSearch 					= 	$this->postSearchEmployeeComprehensiveManager($request);
		if (isset($referSearch['error_typ']) && $referSearch['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		return view('Common::popup.employee_comprehensive_manager', array_merge($data, $referSearch));
	}
	/**
	 * postSearch Employee Comprehensive Manager
	 * @author vietdt
	 * @created at  2021-05-17
	 * @return void
	 */
	public function postSearchEmployeeComprehensiveManager(Request $request)
	{
		$data_request = $request->all() ?? [];
		$validator = Validator::make($data_request, [
			'page_size'        => 'integer',
			'page'             => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['company_cd']       =  session_data()->company_cd;
		$params['page_size']       	=  $request->page_size ?? 20;
		$params['page']         	=  $request->page ?? 1;
		$result                     =  Dao::executeSql('SPC_COMPREHENSIVE_EMPLOYEE_FND1', $params);
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		//
		$data['list']                 	=  $result[0] ?? [];
		$data['paging']               	=  $result[1][0] ?? [];
		$data['organization_group'] 	= 	getCombobox('M0022', 1) ?? [];
		// render view
		if ($request->ajax()) {
			return view('Common::popup.search_employee_comprehensive_manager', $data);
		} else {
			return $data;
		}
	}
	/**
	 * rI0020
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function rI0020(Request $request)
	{
		// POST METHOD
		if ($request->isMethod('post')) {
			try {
				if ($this->respon['status'] == OK) {
					$data_request = $request->all() ?? [];
					$validator = Validator::make($data_request, [
						'fiscal_year'	   => 'integer',
					]);
					if ($validator->fails()) {
						return response()->view('errors.query', [], 501);
					}
					$res = $this->target_service->save($data_request);
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
		// GET METHOD
		$company_cd = session_data()->company_cd ?? 0;
		$employee_cd = session_data()->employee_cd ?? '';
		$fiscal_year = (int)$this->mirai_service->findFiscalYearFromDate($company_cd, 5);
		$target = $this->target_service->find($company_cd, $fiscal_year, $employee_cd, 1);
		$target['years'] = getCombobox('M4000', 1, 5);
		return view('Common::popup.popup_ri0020', $target);
	}

	/**
	 * refer data for rI0020
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function referDatarI0020(Request $request)
	{
		try {
			$data_request = $request->all() ?? [];
			$validator = Validator::make($data_request, [
				'fiscal_year'	   => 'integer',
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			$company_cd = session_data()->company_cd ?? 0;
			$employee_cd = session_data()->employee_cd ?? '';
			$res = $this->target_service->find($company_cd, $data_request['fiscal_year'], $employee_cd, 1);
			// check exception
			if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			$res['years'] = getCombobox('M4000', 1, 5);
			$res['fiscal_year'] = $data_request['fiscal_year'];
			return view('Common::popup.popup_ri0020_detail', $res);
		} catch (\Exception $e) {
			$response['status'] = EX;
			$response['Exception']  = $e->getMessage();
			return response()->view('errors.query', [], 501);
		}
	}

	/**
	 * show list question
	 * @author duongntt
	 * @created at 2017-08-18 06:38:35
	 * @return void
	 */
	public function reportQuestion(Request $request)
	{
		$data_request = $request->all() ?? [];
		$validator = Validator::make($data_request, [
			'report_kind'	   => 'integer',
			'page_size'        => 'integer',
			'page'             => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['report_kind']      =  $request->report_kind ?? 0;
		$params['page']         	=  $request->page ?? 1;
		$params['page_size']       	=  $request->page_size ?? 20;
		$params['company_cd']       =  session_data()->company_cd;
		$params['language']      	=  session_data()->language;
		$result	=  Dao::executeSql('SPC_Report_Question_FND1', $params);
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['title'] 	= trans('messages.question_search');
		$data['list'] 	= $result[0] ?? [];
		$data['paging'] = $result[1][0] ?? [];
		$data['report_kind'] = $params['report_kind'];
		if ($request->isMethod('post')) {
			return view('Common::popup.search_report_question', $data);
		}
		return view('Common::popup.report_question', $data);
	}

	/**
	 * sticky
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function sticky(Request $request)
	{
		$data['title']  = trans('ri2010.sticky_choice_popup');
		$params['fiscal_year'] = $request->fiscal_year ?? 0;
		$params['employee_cd'] = $request->employee_cd ?? '';
		$params['report_kind'] = $request->report_kind ?? 0;
		$params['report_no'] = $request->report_no ?? 0;
		$params['note_no'] = $request->note_no ?? 0;
		$params['note_explanation'] = $request->note_explanation ?? '';
		$validator = Validator::make($params, [
			'fiscal_year' => ['integer'],
			'report_kind' => ['integer'],
			'report_no' => ['integer'],
			'employee_cd' => ['max:10'],
			'note_no' => ['nullable', 'integer'],
			'note_explanation' => ['nullable', 'max:200'],
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// post method
		if ($request->isMethod('post')) {
			try {
				$this->respon['status']     = OK;
				$params['login_employee_cd'] = session_data()->employee_cd ?? '';
				$params['cre_user'] = session_data()->user_id ?? '';
				$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
				$params['company_cd'] = session_data()->company_cd ?? 0;
				$result =  Dao::executeSql('SPC_rI2010_ACT5', $params);
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
		$data = $params;
		$data['notes'] = getCombobox('M4101', 1, 5);
		$note = $this->weeklyreport_service->findReportDetailByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no']);
		$data['note'] = $note[0][0] ?? [];
		return view('Common::popup.sticky', $data);
	}

	/**
	 * comment
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function comment(Request $request)
	{
		$data['title']  = trans('ri2010.comment_popup');
		return view('Common::popup.comment', $data);
	}

	/**
	 * 週報共有ポップアップ
	 *
	 * @param  Request $request
	 * @return View|Json
	 */
	public function shareEmployeeReport(Request $request)
	{
		$data['title'] 					= 	trans('ri2010.weekly_report_sharing');
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year' => ['integer'],
			'employee_cd' => ['max:10'],
			'report_kind' => ['integer'],
			'report_no' => ['integer'],
			'page' => ['integer'],
			'page_size' => ['integer'],
			// NULLABLE
			'employee_cd_key' => ['nullable', 'max:10'],
			'employee_nm_key' => ['nullable', 'max:50'],
			'employee_typ' => ['nullable', 'integer'],
			'belong_cd1' => ['nullable', 'max:20'],
			'belong_cd2' => ['nullable', 'max:20'],
			'belong_cd3' => ['nullable', 'max:20'],
			'belong_cd4' => ['nullable', 'max:20'],
			'belong_cd5' => ['nullable', 'max:20'],
			'job_cd' => ['nullable', 'integer'],
			'position_cd' => ['nullable', 'integer'],
			'group_cd' => ['nullable', 'integer'],
			'mygroup_cd' => ['nullable', 'integer'],

		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$param_reqs['employee_cd_key'] = SQLEscape(($param_reqs['employee_cd_key'] ?? ''));
		$param_reqs['employee_nm_key'] = SQLEscape(($param_reqs['employee_nm_key'] ?? ''));
		$data['organization_group'] = getCombobox('M0022', 1, 5) ?? [];
		$data['combo_organization'] = getCombobox('M0020', 1, 5) ?? [];
		$data['M0030'] = getCombobox('M0030', 1, 5) ?? [];
		$data['M0040'] = getCombobox('M0040', 1, 5) ?? [];
		$data['M0060'] = getCombobox('M0060', 1, 5) ?? [];
		$data['M4600'] = getCombobox('M4600', 1, 5) ?? [];
		$data['F4010'] = getCombobox('F4010', 1, 5) ?? [];
		$data['login_employee_cd'] = session_data()->employee_cd ?? '';
		$company_cd = session_data()->company_cd ?? 0;
		$data['setting'] = $this->setting_service->find($company_cd);
		$shares = $this->weeklyreport_service->getSharingEmployeesForReport(
			$param_reqs
		);
		$data['shares'] = $shares[0] ?? [];
		$data['paging'] = $shares[1][0] ?? [];
		// dd(array_merge($data, $param_reqs));
		if ($request->isMethod('post')) {
			return view('Common::popup.search_report_employee_share', array_merge($param_reqs, $data));
		}
		return view('Common::popup.report_employee_share', array_merge($data, $param_reqs));
	}

	/**
	 * 週報共有ポップアップ (Share Action)
	 *
	 * @param  Request $request
	 * @return View|Json
	 */
	public function shareEmployeeReportShare(Request $request)
	{
		$params = $request->all();
		$validator = Validator::make($params, [
			'fiscal_year' => ['integer'],
			'employee_cd' => ['max:10'],
			'report_kind' => ['integer'],
			'report_no' => ['integer'],
			'share_explanation' => ['nullable', 'max:200'],
			'share_kbn' => ['nullable', 'integer'],
			'employees.*.employee_cd' => ['nullable', 'max:10'],
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		try {
			$response['status'] = OK;
			$response['errors'] = [];
			$report = $this->weeklyreport_service->shareReport($params);
			if (isset($report[0]) && !empty($report[0])) {
				$response['status'] = NG;
				foreach ($report[0] as $temp) {
					array_push($response['errors'], $temp);
				}
			}
		} catch (\Exception $e) {
			$response['status'] = EX;
			$response['Exception'] = $e->getMessage();
		}
		return response()->json($response);
	}

	/**
	 * 閲覧者ポップアップ
	 *
	 * @param  Request $request
	 * @return View|Json
	 */
	public function viewerConfirm(Request $request)
	{
		$data['title'] = trans('ri2010.viewer_list');
		$param_reqs = $request->all() ?? [];
		$validator = Validator::make($param_reqs, [
			'fiscal_year' => ['integer'],
			'employee_cd' => ['max:10'],
			'report_kind' => ['integer'],
			'report_no' => ['integer'],
			'page' => ['integer'],
			'page_size' => ['integer'],
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$data['organization_group'] 	= 	getCombobox('M0022', 1, 5) ?? [];
		$viewers = $this->weeklyreport_service->getViewersForReport(
			$param_reqs['fiscal_year'],
			$param_reqs['employee_cd'],
			$param_reqs['report_kind'],
			$param_reqs['report_no'],
			$param_reqs['page'],
			$param_reqs['page_size']
		);
		$data['viewers'] = $viewers[0] ?? [];
		$data['paging'] = $viewers[1][0] ?? [];
		if ($request->isMethod('post')) {
			return view('Common::popup.search_viewer', array_merge($param_reqs, $data));
		}
		return view('Common::popup.viewer', array_merge($param_reqs, $data));
	}
	/**
	 * マイパーパス登録
	 *
	 * @param  Request $request
	 * @return View|Json
	 */
	public function mypurpose(Request $request)
	{
		// POST METHOD
		if ($request->isMethod('post')) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json'] = $this->respon['data_sql'];
					$params['employee_cd'] = session_data()->employee_cd;
					$params['cre_user'] = session_data()->user_id;
					$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
					$params['company_cd'] = session_data()->company_cd;
					$result = $this->my_purpose->register($params);
					// process errors
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
				$this->respon['status'] = EX;
				$this->respon['Exception'] = $e->getMessage();
			}
			return response()->json($this->respon);
		}
		// GET METHOD
		$data['title'] = trans('messages.my_purpose_register');
		$data['module'] = $request->segment(1);
		// 
		$my_purpose = $this->my_purpose->get(session_data()->company_cd, session_data()->employee_cd);
		if (isset($my_purpose[0][0]['error_typ']) && $my_purpose[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['my_purpose'] = $my_purpose[0][0] ?? [];
		return view('Common::popup.my_purpose', $data);
	}

	/**
	 * 差戻しする
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function reject(Request $request)
	{
		// POST METHOD
		if ($request->isMethod('post')) {
			$params = $request->all();
			$validator = Validator::make($params, [
				'fiscal_year' => ['integer'],
				'employee_cd' => ['max:10'],
				'report_kind' => ['integer'],
				'report_no' => ['integer'],
				'reject_comment' => ['max:500'],
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			try {
				$response['status'] = OK;
				$response['errors'] = [];
				// 
				$params['login_user_type'] = $this->weeklyreport_service->findLoginUserType($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no']);
				$params['login_employee_cd'] = session_data()->employee_cd ?? '';
				$params['cre_user'] = session_data()->user_id ?? '';
				$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
				$params['company_cd'] = session_data()->company_cd ?? 0;
				$report = Dao::executeSql('SPC_rI2010_ACT7', $params);
				if (isset($report[0]) && !empty($report[0])) {
					$response['status'] = NG;
					foreach ($report[0] as $temp) {
						array_push($response['errors'], $temp);
					}
				}
			} catch (\Exception $e) {
				$response['status'] = EX;
				$response['Exception'] = $e->getMessage();
			}
			return response()->json($response);
		}
		// GET METHOD
		$data['is_required'] = true;
		if((int) session_data()->report_authority_typ == 5 ) {
			$data['is_required'] = false;
		}
		$data['title'] = trans('ri2010.reject_reason');
		return view('Common::popup.reject', $data);
	}

	/**
	 * コメントオプション
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function commentOptions(Request $request)
	{
		// POST METHOD
		if ($request->isMethod('post')) {
			$params = $request->all();
			$validator = Validator::make($params, [
				'detail_no' => ['integer'],
				'comment' => ['nullable', 'max:30'],
				'comment_typ' => ['integer'],
				'mode' => ['integer'],
			]);
			if ($validator->fails()) {
				return response()->view('errors.query', [], 501);
			}
			try {
				$response['status'] = OK;
				$response['errors'] = [];
				$response['comment_option'] = [];
				// 
				$params['login_employee_cd'] = session_data()->employee_cd ?? '';
				$params['cre_user'] = session_data()->user_id ?? '';
				$params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
				$params['company_cd'] = session_data()->company_cd ?? 0;
				$report = Dao::executeSql('SPC_rI2010_ACT8', $params);
				if (isset($report[0]) && !empty($report[0])) {
					$response['status'] = NG;
					foreach ($report[0] as $temp) {
						array_push($response['errors'], $temp);
					}
				} else if (isset($report[1][0]) && !empty($report[1][0])) {
					$response['comment_option'] = $report[1][0];
				}
			} catch (\Exception $e) {
				$response['status'] = EX;
				$response['Exception'] = $e->getMessage();
			}
			return response()->json($response);
		}
		// GET METHOD
		$data['title'] = trans('ri2010.comment_options');
		$params = $request->all();
		$validator = Validator::make($params, [
			'comment_typ' => ['integer']
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['login_employee_cd'] = session_data()->employee_cd ?? '';
		$params['company_cd'] = session_data()->company_cd ?? 0;
		$comment_options = Dao::executeSql('SPC_rI2010_LST5', $params);
		if (isset($comment_options[0][0]['error_typ']) && $comment_options[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data['comment_options'] = $comment_options[0] ?? [];
		return view('Common::popup.comment_options', $data);
	}

	/**
	 * eI0200 個人データ登録
	 *
	 * @param  Request $request
	 * @return void
	 */
	public function ei0200(Request $request)
	{
		// POST METHOD
		if ($request->isMethod('post')) {
			try {
				$json = $request->body;
				$data_sql = json_decode($json, true)['data_sql'];
				// process upload file 
				if ($request->hasFile('file')) {
					$now = Carbon::now()->setTimezone('Asia/Ho_Chi_Minh');
					$time = $now->format('YmdHis');
					$file_name = 'personal_picture_' . session_data()->employee_cd . '_' . $time;
					$request['folder'] = 'ei0200/' . session_data()->company_cd;
					$request['rename_upload'] = $file_name;
					$upload =  UploadCore::start($request);
					if (!$upload['errors'] && isset($upload['file'])) {
						$array = $upload['file'];
						if ($array['status'] !== 200) {
							$this->respon['status'] = 405;
							return response()->json($this->respon);
						}
						$data_sql['file_name']		=	$array['name'];
					}
				}
				$params['json']              		=   json_encode($data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				$params['cre_user']          		=   session_data()->user_id;
				$params['cre_ip']            		=   $_SERVER['REMOTE_ADDR'];
				$params['company_cd']        		=   session_data()->company_cd;
				// call service
				$result = $this->personal_service->savePersonalData($params);
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
		// GET METHOD
		$params['company_cd'] = session_data()->company_cd ?? 0;
		$params['employee_cd'] = session_data()->employee_cd ?? '';
		$result = $this->personal_service->getPersonalRegistration($params);
		$data['header'] = $result[0][0] ?? [];
		$data['combobox'] = $result[1] ?? [];
		$data['fields'] = $result[2] ?? [];
		$data['title'] = trans('messages.personal_data_setting');
		$data['organization_group'] = getCombobox('M0022', 1, 6) ?? [];
		return view('Common::popup.popup_ei0200', $data);
	}

	/**
	 * EQ0200Board コミュニケ―ションボード
	 * @author manhnd 
	 * @created at 2024/03/05
	 * @return View
	 */
	public function eq0200Board(Request $request)
	{
		// GET METHOD
		$params['company_cd'] = session_data()->company_cd ?? 0;
		$params['employee_cd'] = $request->employee_cd ?? '';
		// validate
		$validator = Validator::make($params, [
			'employee_cd'				=> 'max:10',
			'company_cd'				=> 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$result = $this->personal_service->getPersonalRegistration($params);
		$data['header'] = $result[0][0] ?? [];
		$data['fields'] = $result[2] ?? [];
		$data['title'] = trans('messages.communication_board');
		$M9101 = getCombobox('M9101', 1, 6) ?? [];
		$data['M9101'] = $M9101[0];
		$tabs = $this->employee_tab_auth_service->findEmployeeInformationByTab($params['company_cd'], $params['employee_cd'], '', 2);
		$data['qualifications'] = $tabs[0] ?? [];
		$list_tab2 = $this->employee_tab_auth_service->findEmployeeInformationByTab($params['company_cd'], $params['employee_cd'], '', 4);
		$data['list_tab2'] = $list_tab2[0];
		$data['organization_group'] = getCombobox('M0022', 1, 6) ?? [];
		return view('Common::popup.popup_eq0200_board', $data);
	}

	/**
	 * show list filter
	 * @author trinhdt
	 * @return void
	 */
	public function getFilterList(Request $request)
	{
		$data['title']          =  trans('messages.employee_information_output');
		return view('Common::popup.popup_eq0100_list', $data);
	}
	/**
	 * show filter add search
	 * @author trinhdt
	 * @return void
	 */
	public function getFilter(Request $request)
	{
		$params['user_id'] = session_data()->user_id ?? '';
		$params['company_cd'] = session_data()->company_cd ?? 0;
		$data['title'] =  trans('messages.add_conditions');
		$data['combobox'] = $this->employee_infor->getCombobox($params);
		$data['M0020']  = getCombobox('M0020', 1, 6);
		$data['M0022']  = getCombobox('M0022', 1, 6);
		$data['M0040'] = getCombobox('M0040', 1, 6);
		$data['M0030'] = getCombobox('M0030', 1);
		$data['gender'] = getCombobox(68) ?? [];
		$data['combo_employee_type'] = getCombobox('M0060', 1) ?? [];
		$data['combo_grade']           = getCombobox('M0050', 1) ?? [];
		$data['headquarters_prefectures'] = getCombobox('L0011', 1, 6) ?? [];
		$data['possibility_transfer'] = getCombobox(53) ?? [];
		$data['nationality'] = getCombobox('L0012', 1, 6) ?? [];
		$data['style'] = getCombobox(18) ?? [];
		$data['qualification_cd'] = getCombobox('M5010', 1, 6) ?? [];
		$data['rank_cd'] = getCombobox('M0130', 1);
		$data['final_education_kbn'] = getCombobox(61) ?? [];
		$data['owning_house_kbn'] = getCombobox(62) ?? [];
		$data['reward_punishment_typ'] = getCombobox(75) ?? [];
		$data['office_cd'] = getCombobox('M0010', 1) ?? [];
		$data['yes_no'] = getCombobox(55) ?? [];
		$data['l0010_56'] = getCombobox(56) ?? [];
		$data['marital_status'] = getCombobox(67) ?? [];
		$data['trainings'] = getCombobox('M5030', 1, 6) ?? [];
		return view('Common::popup.popup_eq0100', $data);
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
			storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_INTERVIEW_SCHEDULE_.log'),
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
}
