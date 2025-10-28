<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\YearTargetService;
use App\Services\OneOnOneService;
use Validator;

class OM0100Controller extends Controller
{
    protected $YearTargetService;
    public function __construct(YearTargetService $YearTargetService, OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->YearTargetService = $YearTargetService;
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:25:42
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('messages.personal_master');
        $data['category'] = trans('messages.1on1_master');
        $data['category_icon'] = 'fa fa-list-alt';
        $params['company_cd'] = session_data()->company_cd;
        $data_year     =  $this->one_on_one_service->getCurrentFiscalYear($params['company_cd']);
        $today = $data_year['fiscal_year'] ?? date("Y");
        $res = $this->YearTargetService->getYearTarget($params['company_cd'], $today);
        if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        return view('OneOnOne::om0100.index', array_merge($data, $res))
            ->with('result', $res[0][0] ?? [])
            ->with('today', $today)
            ->with('data', $res[1][0] ?? []);
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:25:42
     * @return \Illuminate\Http\Response
     */
    public function referData(Request $request)
    {
        $params = [
            'fiscal_year' => $request->fiscal_year ?? 0,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer',
            'company_cd'  => 'integer'
        ]);
        if ($validator->passes()) {
            $res = $this->YearTargetService->getYearTarget($params['company_cd'], $params['fiscal_year']);
            if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
                return response()->view('errors.query', [], 501);
            }
            $this->respon['status']  = OK;
            $this->respon['data']    = $res;
        } else {
            return response()->view('errors.query', [], 501);
        }
        return response()->json($this->respon);
    }
    /**
     * Save data
     * @author nghianm
     * @created at 2020-09-25
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        try {
            $this->valid($request);
            if ($this->respon['status'] == OK) {
                $params['json']         =   $this->respon['data_sql'];
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $res = $this->YearTargetService->saveYearTarget($params['company_cd'], $params);
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
                if (isset($res[1][0])) {
                    $this->respon['authority_cd']     = $res[1][0]['authority_cd'];
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
     * @author nghianm
     * @created at 2020/10/23
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        try {
            $params = [
                'fiscal_year' => $request->fiscal_year ?? 0,
                'company_cd' => session_data()->company_cd, // set for demo
            ];
            $validator = Validator::make($params, [
                'fiscal_year' => 'integer',
                'company_cd'  => 'integer'
            ]);
            if ($validator->passes()) {
                //
                $res = $this->YearTargetService->deleteYearTarget($params['company_cd'], $params['fiscal_year']);
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
            } else {
                return response()->view('errors.query', [], 501);
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
