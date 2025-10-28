<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\SheetService;
use App\Services\AdequacyService;
use App\Services\YearTargetService;
use App\Services\OneOnOneService;

class OM0200Controller extends Controller
{
	protected $sheetService;
	protected $yearTargetService;
	protected $adequacyService;
	protected $one_on_one_service;
	public function __construct(AdequacyService $adequacyService, SheetService $sheetService, OneOnOneService $OneOnOneService, YearTargetService $yearTargetService)
	{
		parent::__construct();
		$this->one_on_one_service = $OneOnOneService;
		$this->sheetService       = $sheetService;
		$this->adequacyService    = $adequacyService;
		$this->yearTargetService  = $yearTargetService;
	}
	/**
	 * Show the application index.
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12
	 * @return \Illuminate\Http\Response
	 */
	public function index(Request $request)
	{
		$data['title']         = trans('messages.1on1_sheet_master');
		$data['category']      = trans('messages.1on1_master');
		$data['category_icon'] = 'fa fa-list-alt';
		$data_left             = $this->postLeft($request);
		$data_right            = $this->postRefer($request);
		return view('OneOnOne::om0200.index', array_merge($data, $data_left, $data_right));
	}
	/**
	 * postLeft
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:25:42
	 * @return void
	 */
	public function postLeft(Request $request)
	{
		$this->respon['status'] = OK;
		$this->respon['errors'] = [];
		$validator = \Validator::make($request->all(), [
            'page' => 'integer',
			'search_key' => 'max:50'
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
		$company_cd 			= session_data()->company_cd;
		$key_search 			= SQLEscape($request->search_key?? '');
		$page 					= $request->page 		?? 1;
		$page_size 				= 10;
		$data_service 			= $this->sheetService->findSheets($company_cd, $key_search, $page, $page_size);
		$data['list_sheet'] 	= $data_service[0];
		$data['paging'] 		= $data_service[1][0];
		$data['search_key'] 	= $request->search_key?? '';
		if ($request->ajax()) {
			return view('OneOnOne::om0200.leftcontent', $data);
			//return request ajax
		} else {
			return $data;
		}
	}
	/**
	 * postRefer
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:12
	 * @return void
	 */
	public function postRefer(Request $request)
	{
		$rules = [
			'interview_cd' 		=> 'int',
			'adaption_date' 	=> 'date',
		];
		$validator = \Validator::make($request->all(), $rules);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		} else {
			$company_cd 		 = session_data()->company_cd;
			$interview_cd		 = $request->interview_cd 	?? 0;
			$adaption_date 		 = $request->adaption_date 	?? NULL;
			$data_sheet_service  = $this->sheetService->getSheet($company_cd, $interview_cd, $adaption_date);
			$adequacy_service    = $this->adequacyService->getRemarkCombo($company_cd);
			$fiscal_year 		 = $this->one_on_one_service->getCurrentFiscalYear($company_cd)['fiscal_year'] ?? 0;
			$year_target_service = $this->yearTargetService->getYearTarget($company_cd, $fiscal_year);
			if ((isset($data_sheet_service[0][0]['error_typ']) 	&& $data_sheet_service[0][0]['error_typ']   == '999') ||
				(isset($adequacy_service[0][0]['error_typ']) 	&& $adequacy_service[0][0]['error_typ']     == '999') ||
				(isset($year_target_service[0][0]['error_typ']) && $year_target_service[0][0]['error_typ']  == '999')
			) {
				return response()->view('errors.query', [], 501);
			}
			$data['data_refer'] 			= $data_sheet_service[0][0] ?? [];
			$data['year_target_service']    = $year_target_service[0][0] ?? [];
			$data['question_table'] 		= $data_sheet_service[1] ?? [];
			$data['combo_remark']       	= $adequacy_service ?? [];
			$data['data_remark']			= $this->adequacyService->getAdequacy($company_cd)[0][0] ?? [];
			if ($request->ajax()) {
				return view('OneOnOne::om0200.rightcontent', $data);
				//return request ajax
			} else {
				return $data;
			}
		}
	}
	/**
	 * postSave
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:02
	 * @return void
	 */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->respon['status'] = OK;
				$this->respon['errors'] = [];
				$param = $request->json()->all()['data_sql'];
				$rules = [
					'interview_cd' 			=> 'int',
					'adaption_date' 		=> 'date',
					'target1_use_typ' 		=> 'int',
					'target2_use_typ' 		=> 'int',
					'target3_use_typ' 		=> 'int',
					'comment_use_typ' 		=> 'int',
					'free_question_use_typ' => 'int',
					'member_comment_typ' 	=> 'int',
					'coach_comment1_typ' 	=> 'int',
					'next_action_typ' 		=> 'int',
					'coach_comment2_typ' 	=> 'int',
				];
				$validator = \Validator::make($param, $rules);
				if ($validator->fails()) {
					return response()->view('errors.query', [], 501);
				}
				$res = $this->sheetService->saveSheet(json_encode($param, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE));
				// check exception
				if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
					return response()->view('errors.query', [], 501);
				} else if (isset($res[0]) && !empty($res[0])) {
					$this->respon['status'] = NG;
					foreach ($res[0] as $temp) {
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
	 * postDelete
	 * @author mail@ans-asia.com
	 * @created at 2020-09-04 08:29:02
	 * @return void
	 */
	public function postDelete(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->respon['status'] = OK;
				$this->respon['errors'] = [];
				$rules = [
					'interview_cd' 	 => 'int',
					'adaption_date'  => 'date',
				];
				$validator = \Validator::make($request->all(), $rules);
				if ($validator->fails()) {
					return response()->view('errors.query', [], 501);
				}
				$interview_cd 	=  	$request->interview_cd ?? 0;
				$adaption_date 	=	$request->adaption_date ?? '';
				$result 		= 	$this->sheetService->deleteSheet($interview_cd, $adaption_date);
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
}
