<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\AuthorityService;
use Validator;

class OS0020Controller extends Controller
{
	protected $authorityService;

	public function __construct(AuthorityService $authorityService)
	{
		parent::__construct();
		$this->authorityService = $authorityService;
	}
	/**
	 * Show the application index.
	 * @author namnb 
	 * @created at 2018-07-04 06:49:48
	 * @return \Illuminate\Http\Response
	 */
	public function index(Request $request)
	{
		$data['category'] = trans('messages.set');
		$data['category_icon'] = 'fa fa-cogs';
		$data['title'] = trans('messages.os0020');
		$left = $this->getLeftContent($request) ?? [];
		$params['company_cd']  = session_data()->company_cd;
		$params['language']    = session_data()->language;
		$res = $this->authorityService->referData($params, 2);
		if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')
			||	(isset($left['error_typ']) && $left['error_typ'] == '999')
		) {
			return response()->view('errors.query', [], 501);
		}
		return view('OneOnOne::os0020.index', array_merge($data, $left))
			->with('result', $res[0] ?? [])
			->with('combobox', $res[1] ?? [])
			->with('lvl1', $res[2] ?? [])
			->with('lvl2', $res[3] ?? [])
			->with('lvl3', $res[4] ?? [])
			->with('lvl4', $res[5] ?? [])
			->with('lvl5', $res[6] ?? [])
			->with('M0022', getCombobox('M0022', 1) ?? [])
			->with('search_key', $left['search_key'] ?? '');
	}

	/**
	 * get left content
	 * @author namnb
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function getLeftContent(Request $request)
	{
		$params = [
			'search_key' 	=> SQLEscape($request->search_key) ?? '',
			'current_page' 	=> $request->current_page ?? 1,
			'page_size' 	=> $request->page_size ?? 10,
			'company_cd' 	=> session_data()->company_cd, // set for demo
		];
		$data = [
			'search_key' => htmlspecialchars($request->search_key) ?? '',
		];
		$validator = Validator::make($params, [
			'current_page'      => 'integer',
			'page_size'   		=> 'integer'
		]);
		if ($validator->fails()) {
			if ($request->ajax()) {
				return response()->view('errors.query', [], 501);
			} else {
				return array('error_typ' => '999');
			}
		}
		if (!validateCommandOS($request->search_key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		$res = $this->authorityService->searchAuthority($params, 2);
		$data['list'] = $res[0] ?? [];
		$data['paging'] = $res[1][0] ?? [];
		// render view
		if ($request->ajax()) {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return response()->view('errors.query', [], 501);
			}
			return view('OneOnOne::os0020.leftcontent', $data);
		} else {
			if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
				return array('error_typ' => '999');
			}
			return $data;
		}
	}

	/**
	 * get left content
	 * @author namnb
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function getRightContent(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'authority_cd'      => 'integer',
		]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params = [
			'authority_cd' => $request->authority_cd ?? 1,
			'company_cd' => session_data()->company_cd ?? '', // set for demo
		];
		$res = $this->authorityService->getAuthority($params, 2);
		if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
			return response()->view('errors.query', [], 501);
		}
		$data0 	= $res[0] ?? [];
		$data1 	= $res[1] ?? [];
		$data2 	= $res[2] ?? [];
		$lvl 	= $res[3] ?? [];
		return response()->json(
			compact('data0', 'data1', 'data2', 'lvl')
		);
	}

	/**
	 * Save data
	 * @author sondh
	 * @created at 2018-08-28
	 * @return \Illuminate\Http\Response
	 */
	public function postSave(Request $request)
	{
		try {
			$this->valid($request);
			if ($this->respon['status'] == OK) {
				$params['json']         	=   $this->respon['data_sql'];
				$params['cre_user']    	=   session_data()->user_id;
				$params['cre_ip']      	=   $_SERVER['REMOTE_ADDR'];
				$params['company_cd']   	=   session_data()->company_cd;
				$result = $this->authorityService->saveAuthority($params, 2);
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
					$this->respon['authority_cd']     = $result[1][0]['authority_cd'];
				}
			}
		} catch (\Exception $e) {
			$this->respon['status']     = EX;
			$this->respon['Exception']  = $e->getMessage();
		}
		return response()->json($this->respon);
	}


	/**
	 * Delete data
	 * @author sondh
	 * @created at 2018-08-16
	 * @return \Illuminate\Http\Response
	 */
	public function postDelete(Request $request)
	{
		try {
			$params['authority_cd']   		=   $request->authority_cd;
			$params['cre_user']     			=   session_data()->user_id;
			$params['cre_ip']       			=   $_SERVER['REMOTE_ADDR'];
			$params['company_cd']   			=   session_data()->company_cd;
			//
			$result = $this->authorityService->deleteAuthority($params, 2);
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
