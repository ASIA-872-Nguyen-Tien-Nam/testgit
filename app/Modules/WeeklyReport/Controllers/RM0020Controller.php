<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\PersonalTargetService;
use Validator;

class RM0020Controller extends Controller
{
    protected $PersonalTargetService;
    public function __construct(PersonalTargetService $PersonalTargetService)
    {
        parent::__construct();
        $this->PersonalTargetService = $PersonalTargetService;
    }
    /**
     * Show the application index.
     * @author quangnd
     * @created at 2023/02/07
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('messages.personal_master');
        $params['company_cd'] = session_data()->company_cd;
        $res = $this->PersonalTargetService->get($params['company_cd']);
        if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        $today = $res[2][0]['fiscal_year'] ?? date("Y");
        return view('WeeklyReport::rm0020.index',$data)
            ->with('result', $res[0][0] ?? [])
            ->with('today', $today)
            ->with('data', $res[1][0] ?? []);
    }
    /**
     * Show referData .
     * @author quangnd
     * @created at 2023/04/05
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
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $res = $this->PersonalTargetService->get($params['company_cd'], $params['fiscal_year']);
        if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        return view('WeeklyReport::rm0020.refer')
            ->with('result', $res[0][0] ?? [])
            ->with('data', $res[1][0] ?? []);
    }
    /**
     * Save data
     * @author quangnd
     * @created at 2023/04/05
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
                $res = $this->PersonalTargetService->register($params);

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
     * @author quangnd
     * @created at 2023/04/05
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
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            //
            $res = $this->PersonalTargetService->delete($params['company_cd'], $params['fiscal_year']);
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
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
