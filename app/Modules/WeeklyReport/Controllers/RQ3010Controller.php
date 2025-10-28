<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\AnalysisService;
use App\Services\MiraiService;
use App\Helpers\Service;
use Validator;
use Dao;

class RQ3010Controller extends Controller
{
    protected $weeklyReportService;
    protected $mirai_service;
    protected $analysis_service;
    public function __construct(WeeklyReportService $weeklyReportService, MiraiService $mirai_service, AnalysisService $analysis_service)
    {
        parent::__construct();
        $this->weeklyReportService = $weeklyReportService;
        $this->mirai_service = $mirai_service;
        $this->analysis_service = $analysis_service;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:33:02
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('rq3010.title');
        $params['company_cd']          = session_data()->company_cd ?? 0;
        $data['fiscal_year_today']     = $this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5) ?? date("Y");
        $data['fiscal_year']           = $this->weeklyReportService->getScheduleSetting($params['company_cd'], 1) ?? [];
        $report_kinds                  = $this->weeklyReportService->getReportKinds($params['company_cd']);
        $data['report_kinds']          = $report_kinds[0] ?? [];
        $data['organization_group']    = getCombobox('M0022', 1, 5) ?? [];
        $data['combo_organization']    = getCombobox('M0020', 1, 5) ?? [];
        $data['employee_type']         = getCombobox('M0060', 1, 5) ?? [];
        $data['combo_position']        = getCombobox('M0040', 1, 5) ?? [];
        $data['report_group']          = getCombobox('M4600', 1, 5) ?? [];
        $data['combo_grade']           = getCombobox('M0050', 1, 5) ?? [];
        $data['job']                   = getCombobox('M0030', 1, 5) ?? [];
        //dd($data);
        return view('WeeklyReport::rq3010.index', $data);
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
            'position_cd'                           => 'integer',
            'job_cd'                                => 'integer',
            'list_group_cd.*.group_cd'              => 'integer',
            'list_grade.*.grade'                    => 'integer',
            'list_report_kind.*.report_kind'        => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // success
        $json = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $reports = $this->analysis_service->getSubmissionRateAnalysis($json, 0);
        $data['list']                 =  $reports[0] ?? [];
        $data['header']               =  $reports[1] ?? [];
        //return request ajax
        return view('WeeklyReport::rq3010.search', $data);
    }

    /**
     * get excel file 分析（提出率）
     * @author namnb
     * @created at 2020-10-12
     * @return void
     */
    public function postExportExcel(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $data_request = $request->json()->all()['data_sql'];
            $validator = Validator::make($data_request, [
                'fiscal_year'                           => 'integer',
                'position_cd'                           => 'integer',
                'job_cd'                                => 'integer',
                'list_group_cd.*.group_cd'              => 'integer',
                'list_grade.*.grade'                    => 'integer',
                'list_report_kind.*.report_kind'        => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }

            try {
                $json = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params = array(
                    preventOScommand($json), session_data()->company_cd, session_data()->user_id, 1
                );
                //
                $store_name = 'SPC_rQ3010_FND1';
                $typeReport = 'FNC_OUT_EXL';
                $screen = 'RQ3010';
                $file_name = 'Rq3010_' . time() . '.xlsx';
                date_default_timezone_set('Asia/Tokyo');
                $time = date('YmdHis');
                $service = new Service();
                $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
                //dd($result);
                if (isset($result['filename'])) {
                    $result['path_file'] =  '/download/' . $result['filename'];
                }
                $name = '分析_提出率_';
                if (session_data()->language == 'en') {
                    $name = 'Analysis_SubmitRate_';
                }
                $result['fileNameSave'] =   $name . $time . '.xlsx';
                $this->respon = $result;
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            // return http request
            return response()->json($this->respon);
        }
    }
}
