<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use App\Services\WeeklyReport\FlowService;
use App\Services\WeeklyReport\WeeklyReportService;

class RM0310Controller extends Controller
{
    protected $settingFlowService;
    protected $weeklyReportService;
    public function __construct(FlowService $settingFlowService,WeeklyReportService $weeklyReportService)
	{
		parent::__construct();
		$this->settingFlowService       = $settingFlowService;
        $this->weeklyReportService       = $weeklyReportService;
	}
    /**
     * Show the application index.
     * @author namnt@ans-asia.com 
     * @created at 2023/02/10 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.preparation');
        $data['category_icon'] = 'fa fa-book';
        $data['title'] = trans('rm0310.title');
        $data['group']    = getCombobox('M4600', 1) ?? [];
        $report_kinds            = $this->weeklyReportService->getReportKinds(session_data()->company_cd);
        $data['report_kinds']    = $report_kinds[0] ?? [];
        $params['company_cd'] = session_data()->company_cd;
        $params['report_kinds'] =-1;
        $params['group_cd'] = -1;
        $params['language'] = session_data()->language;
        $data['data'] = $this->settingFlowService->refer($params);
        return view('WeeklyReport::rm0310.index', array_merge($data));
    }
    /**
     * save
     * @author namnt@ans-asia.com 
     * @created at 2023/02/10 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                
                $param_json = $request->json()->all()['data_sql'] ?? [];
                $validator = Validator::make($param_json, [
                    'report'        =>  'integer',
                    'group'        =>  'integer',
                ]);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                if (count($param_json) == 0) {
                    $param_json['group_cd']     = 0;
                    $param_json['group_nm']     = '';
                }
              
                $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if (!validateJsonFormat($json)) {
                    return response()->view('errors.query', [], 501);
                }
              
                $params['json']         =   json_encode($request->json()->all()['data_sql']['data_group']);
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
               
                $res = $this->settingFlowService->register($params);
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
     * save
     * @author namnt@ans-asia.com 
     * @created at 2023/02/10 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function postSearch(Request $request)
{
                $params['company_cd'] = session_data()->company_cd;
                $params['report_kinds'] = $request->report_kinds??0;
                $params['group_cd'] = $request->group_cd??0;
                $params['language'] = session_data()->language;
               
                $data['data'] = $this->settingFlowService->refer($params);

            return view('WeeklyReport::rm0310.search', array_merge($data));
        }

    /**
     * delete
     * @author namnt@ans-asia.com 
     * @created at 2023/02/10 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params = [
                    'company_cd'        => session_data()->company_cd, // set for demo
                ];
                $validator = Validator::make($params, [
                    'company_cd'        => 'integer',
                ]);
                if ($validator->passes()) {
                    $params['cre_user']             =   session_data()->user_id;
                    $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']           =   session_data()->company_cd;
                    $params['report_kinds'] = $request->report_kinds??0;
                    $params['group_cd'] = $request->group_cd??0;
                    //
                    $res = $this->settingFlowService->delete($params);
                    // check exception
                    if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($res[0]) && !empty($res[0])) {
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
}
