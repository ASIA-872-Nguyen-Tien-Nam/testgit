<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use App\Services\QuestionaryService;
use App\Services\OneOnOneService;

class OQ3010Controller extends Controller
{
    protected $QuestionaryService;
    public function __construct(QuestionaryService $QuestionaryService, OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->QuestionaryService = $QuestionaryService;
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author nghianm@ans-asia.com 
     * @created at 2020-12-08 08:32:54
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = 'アンケート';
        $data['category_icon'] = 'fa fa-clipboard';
        $data['title'] = trans('messages.questionnaire_sending_settings');
        $left = $this->getRightContent($request);
        return view('OneOnOne::oq3010.index', array_merge($data, $left));
    }
    /**
     * Right Content
     * @author nghianm@ans-asia.com 
     * @created at 2020-12-08 08:32:54
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $company_cd = session_data()->company_cd;
        $data_year     =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
        $data['today']  = $data_year['fiscal_year'] ?? date("Y");
        $fiscal_year = $request->fiscal_year ?? $data['today'];
        $params = [
            'search_key' => SQLEscape($request->search_key) ?? '',
            'current_page' => $request->current_page ?? 1,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd,
        ];
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer',
            'current_page' => 'integer',
            'page_size' => 'integer'
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $list_coach = $this->QuestionaryService->findQuestionarys($params['company_cd'],$params['search_key'],0,10,1,1);
        if (isset($list_coach[0][0]['error_typ']) && $list_coach[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $list_member  = $this->QuestionaryService->findQuestionarys($params['company_cd'],$params['search_key'],0,10,2,1);
        if (isset($list_member[0][0]['error_typ']) && $list_member[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $res = Dao::executeSql('SPC_OQ3010_INQ1', ["company_cd" => $company_cd, "fiscal_year" => $fiscal_year]);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list_coach']         = $list_coach[0] ?? '';
        $data['list_member']        = $list_member[0] ?? '';
        $data['list_group']         = $res[0] ?? [];
        $data['list_time_check']    = $res[1] ?? [];
        $data['list']               = $res[2] ?? [];
        // render view
        if ($request->ajax()) {
            return view('OneOnOne::oq3010.rightcontent', $data);
        } else {
            return $data;
        }
    }

    /**
     * Save
     * @author nghianm@ans-asia.com  
     * @created at 2020-12-08 07:46:26
     * @return void
     */
    public function postSave(Request $request)
    {
        try {
            $param_json = $request->json()->all() ?? [];
            // validate
            $validator = Validator::make($param_json, [
                'fiscal_year'        =>  'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            if (count($param_json) == 0) {
                $param_json['fiscal_year']                      = date('Y');
                $param_json['list_group']                       = [];
            }
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //      
            if (!validateJsonFormat($json)) {
                return response()->view('errors.query', [], 501);
            }
            $params['json']         =   $json;
            $params['cre_user']     =   session_data()->user_id;
            $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
            $params['company_cd']   =   session_data()->company_cd;
            $result = Dao::executeSql('SPC_OQ3010_ACT1', $params);
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
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
