<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\AnalysisService;
use Validator;
use Dao;
use App\Services\AdequacyService;
use App\Helpers\Service;
use App\Services\OneOnOneService;

class OQ2033Controller extends Controller
{
    protected $scheduleService;
    protected $analysisService;
    protected $adequacyService;
    protected $one_on_one_service;

    public function __construct(ScheduleService $scheduleService, AnalysisService $analysisService, AdequacyService $adequacyService, OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->scheduleService   = $scheduleService;
        $this->analysisService   = $analysisService;
        $this->adequacyService   = $adequacyService;
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:33:57
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.analysis');
        $data['category_icon'] = 'fa fa-line-chart';
        $data['title'] = trans('messages.analysis_cross_tabulation');
        $company_cd    = session_data()->company_cd;
        $schedule_service        = $this->scheduleService->getOption();
        if (isset($schedule_service[0][0]['error_typ']) && $schedule_service[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $current_fiscal_year     =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
        if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['fiscal_year']     =  $current_fiscal_year['fiscal_year'] ?? date("Y");
        $data['oneonone_group']  =  $schedule_service[1] ?? [];
        $data['organization_group']    = getCombobox('M0022', 1) ?? [];
        $data['combo_organization']    = getCombobox('M0020', 1, 2) ?? [];
        $data['combo_position']        = getCombobox('M0040', 1) ?? [];
        $data['combo_job']             = getCombobox('M0030', 1) ?? [];
        $data['combo_grade']           = getCombobox('M0050', 1) ?? [];
        //header
        $params['fiscal_year']         = $data['fiscal_year'];
        $params['company_cd']          = $company_cd;
        $result                        = Dao::executeSql('SPC_1on1_GET_YEAR_MONTHS_FND1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['header']                = $result[0] ?? [];
        return view('OneOnOne::oq2033.index', $data);
    }

    /**
     * Search 
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:29:12 
     * @return void
     */
    public function postSearch(Request $request)
    {
        $data_request = $request->json()->all()['data_sql'];
        $validator = Validator::make($data_request, [
            'fiscal_year'                                => 'integer',
            'combination_vertical'                       => 'integer',
            'combination_horizontal'                     => 'integer',
            'position_cd'                                => 'integer',
            'job_cd'                                     => 'integer',
            'organization_step1.*.organization_cd_1'     =>  'integer',
            //
            'organization_step2.*.organization_cd_1'     =>  'integer',
            'organization_step2.*.organization_cd_2'     =>  'integer',
            //
            'organization_step3.*.organization_cd_1'     =>  'integer',
            'organization_step3.*.organization_cd_2'     =>  'integer',
            'organization_step3.*.organization_cd_3'     =>  'integer',
            // org 4
            'organization_step4.*.organization_cd_1'     =>  'integer',
            'organization_step4.*.organization_cd_2'     =>  'integer',
            'organization_step4.*.organization_cd_3'     =>  'integer',
            'organization_step4.*.organization_cd_4'     =>  'integer',
            //5
            'organization_step5.*.organization_cd_1'     =>  'integer',
            'organization_step5.*.organization_cd_2'     =>  'integer',
            'organization_step5.*.organization_cd_3'     =>  'integer',
            'organization_step5.*.organization_cd_4'     =>  'integer',
            'organization_step5.*.organization_cd_5'     =>  'integer',
            //grade
            'list_grade.*.grade'                         =>  'integer',
            //group_cd_1on1
            'list_group_1on1.*.group_cd_1on1'             =>  'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
      
        // success
        $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $params['user_id']            =  session_data()->user_id;
        $params['company_cd']         =  session_data()->company_cd;
        $params['mode']               =  2; // 0.search 1.csv 2.cross
        $combination_vertical = $data_request['combination_vertical'] ?? 0;
        $combination_horizontal = $data_request['combination_horizontal'] ?? 0;
        
        $result                       =  $this->analysisService->getCrossResult($params, $combination_vertical, $combination_horizontal);
    
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list']                 =  $result ?? [];
        $remarkCombo                  =  $this->adequacyService->getRemarkCombo(session_data()->company_cd, 1, 2);
        if (isset($remarkCombo[0][0]['error_typ']) && $remarkCombo[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['remark']               =  $remarkCombo ?? [];
        $data['fiscal_year']          =  $data_request['fiscal_year'] ?? 0;
        // render view
        if ($request->ajax()) {
            if ($combination_vertical == $combination_horizontal || empty($data['list'])) {
                return view('OneOnOne::oq2033.search');
            }
            if ($combination_vertical == 1 && $combination_horizontal == 3) {
                return view('OneOnOne::oq2033.table1', $data);
            }
            if ($combination_vertical == 1 && $combination_horizontal == 2) {
                return view('OneOnOne::oq2033.table2', $data);
            }
            if ($combination_vertical == 2 && $combination_horizontal == 1) {
                return view('OneOnOne::oq2033.table3', $data);
            }
            if ($combination_vertical == 2 && $combination_horizontal == 3) {
                return view('OneOnOne::oq2033.table4', $data);
            }
            if ($combination_vertical == 3 && $combination_horizontal == 1) {
                return view('OneOnOne::oq2033.table5', $data);
            }
            if ($combination_vertical == 3 && $combination_horizontal == 2) {
                return view('OneOnOne::oq2033.table6', $data);
            }
        } else {
            return $data;
        }
    }
    /**
     * outCSV
     * @author duongntt
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function postExportExcel(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $data_request = $request->json()->all()['data_sql'];
            $validator = Validator::make($data_request, [
                'fiscal_year'                                => 'integer',
                'combination_vertical'                       => 'integer',
                'combination_horizontal'                     => 'integer',
                'position_cd'                                => 'integer',
                'job_cd'                                     => 'integer',
                'organization_step1.*.organization_cd_1'     =>  'integer',
                //
                'organization_step2.*.organization_cd_1'     =>  'integer',
                'organization_step2.*.organization_cd_2'     =>  'integer',
                //
                'organization_step3.*.organization_cd_1'     =>  'integer',
                'organization_step3.*.organization_cd_2'     =>  'integer',
                'organization_step3.*.organization_cd_3'     =>  'integer',
                // org 4
                'organization_step4.*.organization_cd_1'     =>  'integer',
                'organization_step4.*.organization_cd_2'     =>  'integer',
                'organization_step4.*.organization_cd_3'     =>  'integer',
                'organization_step4.*.organization_cd_4'     =>  'integer',
                //5
                'organization_step5.*.organization_cd_1'     =>  'integer',
                'organization_step5.*.organization_cd_2'     =>  'integer',
                'organization_step5.*.organization_cd_3'     =>  'integer',
                'organization_step5.*.organization_cd_4'     =>  'integer',
                'organization_step5.*.organization_cd_5'     =>  'integer',
                //grade
                'list_grade.*.grade'                         =>  'integer',
                //group_cd_1on1
                'list_group_1on1.*.group_cd_1on1'             =>  'integer',
            ]);
            // 
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            try {
                // success
                $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params['user_id']            =  session_data()->user_id;
                $params['company_cd']         =  session_data()->company_cd;
                $params['mode']               =  2; // 0.search 1.csv 2.cross
                $combination_vertical = $data_request['combination_vertical'] ?? 0;
                $combination_horizontal = $data_request['combination_horizontal'] ?? 0;
                $result                       =  $this->analysisService->getCrossResult($params, $combination_vertical, $combination_horizontal);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['list']                 =  $result ?? [];
                $remarkCombo                  =  $this->adequacyService->getRemarkCombo(session_data()->company_cd, 1, 2);
                if (isset($remarkCombo[0][0]['error_typ']) && $remarkCombo[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['remark']               =  $remarkCombo ?? [];
                $length_list = count($result);
                $length_remark = count($remarkCombo);
                if ($combination_vertical == 1) {
                    if (!empty($result)) {
                        for ($j = 0; $j < $length_list; $j++) {
                            $list[$j] = $result[90 - ($j * 10)];
                        }
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[($k + 1)];
                        }
                    }
                }
                if ($combination_vertical == 2) {
                    if (!empty($result)) {
                        for ($j = 0; $j < $length_list; $j++) {
                            $list[$j] = $result["item_no_" . ($j + 1)];
                        }
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[($k + 1)];
                        }
                    }
                }
                if ($combination_vertical == 3) {
                    if (!empty($result)) {
                        for ($j = 0; $j < $length_list; $j++) {
                            $list[$j] = $result["questionnaire_" . (10 - $j)];
                        }
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[($k + 1)];
                        }
                    }
                }
                //////////////////////////////////////////////////////////////////
                // get search conditions 
                $param_conditions = $params;
                unset($param_conditions['mode']);
                $search_conditions = Dao::executeSql('SPC_1on1_GET_SEARCH_CONDITIONS_INQ1', $param_conditions);
                array_push($list,$search_conditions[0][0]);
                //////////////////////////////////////////////////////////////////
                $result_data =  json_encode($list);
                $store_name = '';
                $typeReport = 'FNC_OUT_EXL';
                $screen = '';
                if ($combination_vertical == $combination_horizontal || empty($data['list'])) {
                    //msg
                }
                if ($combination_vertical == 1 && $combination_horizontal == 3) {
                    $screen = 'OQ2033_13';
                }
                if ($combination_vertical == 1 && $combination_horizontal == 2) {
                    $screen = 'OQ2033_12';
                }
                if ($combination_vertical == 2 && $combination_horizontal == 1) {
                    $screen = 'OQ2033_21';
                }
                if ($combination_vertical == 2 && $combination_horizontal == 3) {
                    $screen = 'OQ2033_23';
                }
                if ($combination_vertical == 3 && $combination_horizontal == 1) {
                    $screen = 'OQ2033_31';
                }
                if ($combination_vertical == 3 && $combination_horizontal == 2) {
                    $screen = 'OQ2033_32';
                }
                $file_name = 'OQ2033_' . time() . '.xlsx';
                date_default_timezone_set('Asia/Tokyo');
                $time = date('YmdHis');
                $service = new Service();
                $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name, $result_data);
                if (isset($result['filename'])) {
                    $result['path_file'] =  '/download/' . $result['filename'];
                }
                $name = '分析_クロス集計_';
                if (session_data()->language == 'en') {
                    $name = 'Analysis_CrossTabulation_';
                }
                $result['fileNameSave'] =   $name . time() . '.xlsx';
                $this->respon = $result;
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
}
