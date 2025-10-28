<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\AnalysisService;
use App\Services\WeeklyReport\ReactionService;
use App\Services\WeeklyReport\AdequacyService;
use App\Services\MiraiService;
use App\Helpers\Service;
use Validator;
use Dao;

class RQ3040Controller extends Controller
{
    protected $weeklyReportService;
    protected $mirai_service;
    protected $analysis_service;
    /** ReactionService */
    public $reaction_service;
    /** AdequacyService */
    public $adequacy_service;

    public function __construct(
        WeeklyReportService $weeklyReportService, 
        MiraiService $mirai_service, 
        AnalysisService $analysis_service, 
        ReactionService $reaction_service,
        AdequacyService $adequacy_service    
    )
    {
        parent::__construct();
        $this->weeklyReportService = $weeklyReportService;
        $this->mirai_service = $mirai_service;
        $this->analysis_service = $analysis_service;
        $this->reaction_service = $reaction_service;
        $this->adequacy_service = $adequacy_service;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:33:02
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('rq3040.title');
        $params['company_cd']    = session_data()->company_cd ?? 0;
        $data['fiscal_year_today']     = $this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5) ?? date("Y");
        $data['fiscal_year']           = $this->weeklyReportService->getScheduleSetting($params['company_cd'], 1) ?? [];
        $data['organization_group']    = getCombobox('M0022', 1, 5) ?? [];
        $data['combo_organization']    = getCombobox('M0020', 1, 5) ?? [];
        $data['combo_employee_type']   = getCombobox('M0060', 1, 5) ?? [];
        $data['combo_position']        = getCombobox('M0040', 1, 5) ?? [];
        $data['report_group']          = getCombobox('M4600', 1, 5) ?? [];
        $data['combo_grade']           = getCombobox('M0050', 1, 5) ?? [];
        $data['job']                   = getCombobox('M0030', 1, 5) ?? [];
        //dd($data);
        return view('WeeklyReport::rq3040.index', $data);
    }
    /**
     * Search
     * @author nghianm
     * @created at 2020-12-02 07:46:26
     * @return void
     */
    public function postSearch(Request $request)
    {
        $data_request = $request->json()->all()['data_sql'];
        $validator = Validator::make($data_request, [
            'fiscal_year'                           => 'integer',
            'combination_vertical'                  => 'integer',
            'combination_horizontal'                => 'integer',
            'position_cd'                           => 'integer',
            'job_cd'                                => 'integer',
            'adequacy_type'                         => 'integer',
            'employee_role'                         => 'integer',
            'list_grade.*.grade'                    => 'integer',
            'list_group_cd.*.group_cd'              => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // success
        $combination_vertical = $data_request['combination_vertical'] ?? 0;
        $combination_horizontal = $data_request['combination_horizontal'] ?? 0;
        $json = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $result =  $this->analysis_service->getCrossAnalysis($json, $combination_vertical, $combination_horizontal);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //$mark_typ = $data_request['employee_role'] == 2 ? 3 : 2;
        $mark_typ = 2;
        $data['list'] =  $result ?? [];
        $data['fiscal_year'] = $data_request['fiscal_year'] ?? 0;
        // render view
        if ($request->ajax()) {
            if ($combination_vertical == $combination_horizontal || empty($data['list'])) {
                return view('WeeklyReport::rq3040.search');
            }
            if ($combination_vertical == 1 && $combination_horizontal == 3) {
                $data['remark'] = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                $data['combination'] = 13;
                return view('WeeklyReport::rq3040.table2', $data);
            }
            if ($combination_vertical == 1 && $combination_horizontal == 2) {
                $data['combination'] = 12;
                $data['remark'] = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                return view('WeeklyReport::rq3040.table2', $data);
            }
            if ($combination_vertical == 2 && $combination_horizontal == 1) {
                $data['combination'] = 21;
                $data['remark'] = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                return view('WeeklyReport::rq3040.table3', $data);
            }
            if ($combination_vertical == 2 && $combination_horizontal == 3) {
                $data['combination'] = 23;
                $data['remark'] = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                $data['remark_reactions'] = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                return view('WeeklyReport::rq3040.table4', $data);
            }
            if ($combination_vertical == 3 && $combination_horizontal == 1) {
                $data['combination'] = 31;
                $data['remark'] = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                return view('WeeklyReport::rq3040.table3', $data);
            }
            if ($combination_vertical == 3 && $combination_horizontal == 2) {
                $data['combination'] = 32;
                $data['remark'] = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                $data['remark_reactions'] = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                // dd($data);
                return view('WeeklyReport::rq3040.table1', $data);
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
                'fiscal_year'                           => 'integer',
                'combination_vertical'                  => 'integer',
                'combination_horizontal'                => 'integer',
                'position_cd'                           => 'integer',
                'job_cd'                                => 'integer',
                'adequacy_type'                         => 'integer',
                'employee_role'                         => 'integer',
                'list_grade.*.grade'                    => 'integer',
                'list_group_cd.*.group_cd'              => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            try {
                // success
                $combination_vertical = $data_request['combination_vertical'] ?? 0;
                $combination_horizontal = $data_request['combination_horizontal'] ?? 0;
                $json = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $result =  $this->analysis_service->getCrossAnalysis($json, $combination_vertical, $combination_horizontal);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                //$mark_typ = $data_request['employee_role'] == 2 ? 3 : 2;
                $mark_typ = 2;
                $data['list'] =  $result ?? [];
                $length_list = count($result);
                $store_name = '';
                $typeReport = 'FNC_OUT_EXL';
                $screen = '';
                //dd($result);
                if ($combination_vertical == $combination_horizontal || empty($data['list'])) {
                    $screen = '';
                    $list=[];
                }
                if ($combination_vertical == 1 && $combination_horizontal == 3) {
                    $screen = 'RQ3040_13';
                    $remarkCombo = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                    $length_remark = count($remarkCombo);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result[90 - ($j * 10)];
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[$k];
                        }
                    }
                }
                if ($combination_vertical == 1 && $combination_horizontal == 2) {
                    $screen = 'RQ3040_12';
                    $remarkCombo = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                    $length_remark = count($remarkCombo);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result[90 - ($j * 10)];
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[$k];
                        }
                    }
                }
                if ($combination_vertical == 2 && $combination_horizontal == 1) {      
                    $screen = 'RQ3040_21';
                    $remarkCombo = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                    $length_remark = count($remarkCombo);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result["item_no_" . ($j + 1)];
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[$k];
                        }
                    }
                }
                if ($combination_vertical == 2 && $combination_horizontal == 3) {
                    $screen = 'RQ3040_23';
                    $remarkCombo2 = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                    $remarkCombo3 = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                    $length_remark2 = count($remarkCombo2);
                    $length_remark3 = count($remarkCombo3);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result["item_no_" . ($j + 1)];
                    }
                    if (!empty($remarkCombo2)) {
                        for ($k = 0; $k < $length_remark2; $k++) {
                            $list[($length_list + $k)] = $remarkCombo2[$k];
                        }
                    }
                    if (!empty($remarkCombo3)) {
                        for ($h = 0; $h < $length_remark3; $h++) {
                            $list[($length_list + $length_remark2 + $h)] = $remarkCombo3[$h];
                        }
                    }
                }
                if ($combination_vertical == 3 && $combination_horizontal == 1) {
                    $screen = 'RQ3040_31';
                    $remarkCombo = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                    $length_remark = count($remarkCombo);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result["item_no_" . ($j + 1)];
                    }
                    if (!empty($remarkCombo)) {
                        for ($k = 0; $k < $length_remark; $k++) {
                            $list[($length_list + $k)] = $remarkCombo[$k];
                        }
                    }
                }
                if ($combination_vertical == 3 && $combination_horizontal == 2) {
                    $screen = 'RQ3040_32';
                    $remarkCombo3 = $this->adequacy_service->getAdequacyByMarkKbn($data_request['adequacy_type']);
                    $remarkCombo2 = $this->reaction_service->getReactionByMarkKbn($mark_typ);
                    $length_remark2 = count($remarkCombo2);
                    $length_remark3 = count($remarkCombo3);
                    for ($j = 0; $j < $length_list; $j++) {
                        $list[$j] = $result["item_no_" . ($j + 1)];
                    }
                    if (!empty($remarkCombo2)) {
                        for ($k = 0; $k < $length_remark2; $k++) {
                            $list[($length_list + $k)] = $remarkCombo2[$k];
                        }
                    }
                    if (!empty($remarkCombo3)) {
                        for ($h = 0; $h < $length_remark3; $h++) {
                            $list[($length_list + $length_remark2 + $h)] = $remarkCombo3[$h];
                        }
                    }
                }

                //////////////////////////////////////////////////////////////////
                // get search conditions 
                $params['json']               =  $json;
                $params['user_id']            =  session_data()->user_id;
                $params['company_cd']         =  session_data()->company_cd;
                $param_conditions = $params;
                $search_conditions = Dao::executeSql('SPC_WeeklyReport_GET_SEARCH_CONDITIONS_INQ1', $param_conditions);
                array_push($list, $search_conditions[0][0]);
                if(empty($data['list'])){
                    $list = [];
                }

                //////////////////////////////////////////////////////////////////
                $result_data =  json_encode($list);
                $store_name = '';
                $typeReport = 'FNC_OUT_EXL';           
                $file_name = 'RQ3040_' . time() . '.xlsx';
                date_default_timezone_set('Asia/Tokyo');
                $time = date('YmdHis');
                $service = new Service();
                $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name, $result_data);
                if (isset($result['filename'])) {
                    $result['path_file'] =  '/download/' . $result['filename'];
                }
                $name = '分析_クロス集計_';
                if (session_data()->language == 'en') {
                    $name = 'Analysis_Cross_Reference_';
                }
                $result['fileNameSave'] =   $name . $time . '.xlsx';
                $this->respon = $result;
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    
    }
}