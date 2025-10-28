<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\AnalysisService;
use Validator;
use Dao;
use App\Helpers\Service;
use App\Services\OneOnOneService;

class OQ2030Controller extends Controller
{
     protected $scheduleService;
     protected $analysisService;
     protected $one_on_one_service;
     public function __construct(ScheduleService $scheduleService, AnalysisService $analysisService, OneOnOneService $OneOnOneService)
     {
          parent::__construct();
          $this->scheduleService   = $scheduleService;
          $this->analysisService   = $analysisService;
          $this->one_on_one_service = $OneOnOneService;
     }
     /**
      * Show the application index. 
      * @author mail@ans-asia.com 
      * @created at 2020-09-04 08:33:40
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['category'] = trans('messages.analysis');
          $data['category_icon'] = 'fa fa-line-chart';
          $data['title'] = trans('messages.analysis_1on1_status');
          $company_cd    = session_data()->company_cd;
          $schedule_service   = $this->scheduleService->getOption();
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
          $data['combo_employee_type']   = getCombobox('M0060', 1) ?? [];
        
          //header
          $params['fiscal_year']         = $data['fiscal_year'];
          $params['company_cd']          = $company_cd;
          $result                        = Dao::executeSql('SPC_1on1_GET_YEAR_MONTHS_FND1', $params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['header']                = $result[0] ?? [];
          return view('OneOnOne::oq2030.index', $data);
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
               'position_cd'                                => 'integer',
               'job_cd'                                     => 'integer',
               'employee_typ'                               => 'integer',
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
               'list_group.*.group_cd_1on1'                 =>  'integer',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          // success
          $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
          $params['user_id']            =  session_data()->user_id;
          $params['company_cd']         =  session_data()->company_cd;
          $params['mode']               =  0;
          $result = $this->analysisService->getImplementationStatus($params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['list']                 =  $result[0] ?? [];
          $data['header']               =  $result[1] ?? [];
          // render view
          if ($request->ajax()) {
               return view('OneOnOne::oq2030.search', $data);
          } else {
               return $data;
          }
     }
     
     /**
      * get excel file from button 目標一覧表出力
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
                    'fiscal_year'                                => 'integer',
                    'position_cd'                                => 'integer',
                    'job_cd'                                     => 'integer',
                    'employee_typ'                               => 'integer',
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
                    'list_group.*.group_cd_1on1'                 =>  'integer',
               ]);
               // 
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               try {
                    $json = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                    $params = array(
                         preventOScommand($json), session_data()->user_id, session_data()->company_cd, 1
                    );
                    //
                    $store_name = 'SPC_oQ2030_FND1';
                    $typeReport = 'FNC_OUT_EXL';
                    $screen = 'OQ2030';
                    $file_name = 'OQ2030_' . time() . '.xlsx';
                    date_default_timezone_set('Asia/Tokyo');
                    $time = date('YmdHis');
                    $service = new Service();
                    $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
                    if (isset($result['filename'])) {
                         $result['path_file'] =  '/download/' . $result['filename'];
                    }
                    $name = '分析_1on1実施状況_';
                    if (session_data()->language == 'en') {
                         $name = 'Analysis_1on1Status_';
                    }
                    $result['fileNameSave'] =   $name . time() . '.xlsx';
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
