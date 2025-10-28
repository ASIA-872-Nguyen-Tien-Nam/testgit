<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use App\Services\WeeklyReport\SheetService;

class RM0200Controller extends Controller
{
	protected $sheetService;

	public function __construct(SheetService $sheetService)
	{
		parent::__construct();
		$this->sheetService       = $sheetService;
	}
	/**
	 * Show the application index.
	 * @author namnt 
	 * @created at 2023/04/10
	 * @return \Illuminate\Http\Response
	 */
	public function index(Request $request)
	{
		$data['title']           = trans('rm0200.rm0200');
		// render view 
		$left = $this->postLeft($request);
		$right = $this->postRefer($request);
		return view('WeeklyReport::rm0200.index',  array_merge($data, $left, $right));
	}
	/**
     * save
     * @author namnt 
     * @created at 2023/04/10
     * @return \Illuminate\Http\Response
     */
	public function postSave(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->respon['status'] = OK;
				$this->respon['errors'] = [];
				$payload = $request->json()->all();
				$params = $payload['data_sql'];
				$params['adequacy_use_typ'] = $payload['adequacy_use_typ'] ?? 0;
				$params['busyness_use_typ'] = $payload['busyness_use_typ'] ?? 0;
				$params['other_use_typ'] = $payload['other_use_typ'] ?? 0;
				$params['list_questions'] = json_encode($payload['data_sql']['list_questions']);
				$params['comment_use_typ'] = $payload['comment_use_typ'] ?? 0;
				$rules = [
					'sheet_cd' 			    => 'int',
					'application_date' 		=> 'date',
					'busyness_use_typ' 		=> 'int',
					'other_use_typ' 		=> 'int',
					'adequacy_use_typ' 		=> 'int',
					'comment_use_typ' 		=> 'int',
				];
				$validator = \Validator::make($params, $rules);
				if ($validator->fails()) {
					return response()->view('errors.query', [], 501);
				}
				$params['cre_user']     =   session_data()->user_id;
				$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
				$params['company_cd']   =   session_data()->company_cd;
				//
				$res = $this->sheetService->register($params);
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
     * Show the left
     * @author namnt 
     * @created at 2023/04/10
     * @return \Illuminate\Http\Response
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
		if (!validateCommandOS($request->search_key ?? '')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		$params['key_search']			= SQLEscape($request->search_key ?? '');
		$params['company_cd'] 			= session_data()->company_cd;
		$params['report_kind'] 			= SQLEscape($request->report_kind ?? 0);
		$params['sheet_cd'] 			= SQLEscape($request->sheet_cd ?? 0);
		$params['application_date'] 	= SQLEscape($request->application_date ?? '');
		$params['page']			        = $request->page ?? 1;
		$params['page_size'] 			= 20;
		$params['language'] 			= session_data()->language;
		// $data_service 			= $this->sheetService->findSheets($company_cd, $key_search, $page, $page_size);

		$data = $this->sheetService->getLeftContent($params);
		if ($request->ajax()) {
			return view('WeeklyReport::rm0200.leftcontent', $data);
			//return request ajax
		}
		return $data;
	}
	/**
     * refer
     * @author namnt 
     * @created at 2023/04/10
     * @return \Illuminate\Http\Response
     */
	public function postRefer(Request $request)
	{
		$rules = [
			'sheet_cd' 		=> 'int',
			'report_kind' 	=> 'int',
		];
		$validator = \Validator::make($request->all(), $rules);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params['company_cd'] 		    = session_data()->company_cd;
		$params['report_kind']		    = $request->report_kind 	?? 0;
		$params['sheet_cd'] 		    = $request->sheet_cd 	?? 0;
		$params['adaption_date'] 		= $request->adaption_date 	?? NULL;
		$params['language'] 			= session_data()->language;
		$data = $this->sheetService->getRightContent($params);
		if ($request->ajax()) {
			return view('WeeklyReport::rm0200.rightcontent', $data);
			//return request ajax
		}
		return $data;
	}
	/**
     * DELETE	
     * @author namnt 
     * @created at 2023/04/10
     * @return \Illuminate\Http\Response
     */
	public function postDelete(Request $request)
	{
		if ($request->ajax()) {
			try {
				$this->respon['status'] = OK;
				$this->respon['errors'] = [];
				$rules = [
					'report_kind' 	 => 'int',
					'sheet_cd'  => 'int',
				];
				$validator = \Validator::make($request->all(), $rules);
				if ($validator->fails()) {
					return response()->view('errors.query', [], 501);
				}
				$params['company_cd'] 		    = session_data()->company_cd;
				$params['report_kind']		    = $request->report_kind 	?? 0;
				$params['sheet_cd'] 		    = $request->sheet_cd 	?? 0;
				$params['adaption_date'] 		= $request->adaption_date 	?? NULL;
				$params['cre_user']     =   session_data()->user_id;
				$params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
				$result = $this->sheetService->delete($params);
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
