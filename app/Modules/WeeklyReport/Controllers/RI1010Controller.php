<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\MiraiService;
use Validator;
use Dao;

class RI1010Controller extends Controller
{
     protected $weeklyReportService;
     protected $mirai_service;
     public function __construct(WeeklyReportService $weeklyReportService, MiraiService $mirai_service)
     {
          parent::__construct();
          $this->weeklyReportService     = $weeklyReportService;
          $this->mirai_service   = $mirai_service;
     }
     /**
      * Show the application index.
      * @author quangnd@ans-asia.com
      * @created at 2023-02-10 08:30:22
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['title']           = trans('ri1010.schedule_settings');
          $data['fiscal_year']     = $this->mirai_service->findFiscalYearFromDate(session_data()->company_cd, 5) ?? 0;
          $report_kinds            = $this->weeklyReportService->getReportKinds(session_data()->company_cd);
          $data['report_kinds']    = $report_kinds[0] ?? [];
          // $data['report_group']    =getCombobox('M4600', 1) ?? [];
          $data['report_group'] = $this->weeklyReportService->getGroupForSheet($data['report_kinds'][0]['report_kind']??0);
          $data['month_s'] = $this->weeklyReportService->getScheduleSetting(session_data()->company_cd , 5, $data['fiscal_year']);
          return view('WeeklyReport::ri1010.index', $data);
     }
     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postRefer(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year'  => 'integer',
               'month'        => 'integer',
               'report_kind'  => 'integer',
               'group_cd'     => 'integer',
               'report_group_list.report_group' => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $params['company_cd']    = session_data()->company_cd ?? 0;
          $params['fiscal_year']   = $request->fiscal_year ?? 0;
          $params['month']         = $request->month ?? 0;
          $params['report_kind']   = $request->report_kind ?? 0;
          $params['group_cd']      = $request->group_cd ?? 0;
          $params['language']      = session_data()->language;
          $report_group_list       = json_encode($request->report_group_list, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
          $data_table_info          = $this->weeklyReportService->getSchedule($params['company_cd'], $report_group_list);
          if (isset($data_table_info[0][0]['error_typ']) && $data_table_info[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          //
          $res = Dao::executeSql('SPC_rI1010_INQ1', $params);
          // check exception
          if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $data['table_info']      = $data_table_info[0][0] ?? [];
          $data['table_schedule']  = $res[0] ?? [];
          if ($request->ajax()) {
               return view('WeeklyReport::ri1010.refer', $data);
          } else {
               return $data;
          }
     }
     /**
      * postSave
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:30:22
      * @return void
      */
     public function postSave(Request $request)
     {
          try {
               $data_request = $request->json()->all()['data_sql'];
               $rules = [
                    'fiscal_year'                        => 'integer',
                    'report_kind'                        => 'integer',
                    'report_group_list.report_group'     => 'integer',
                    'list_schedule.detail_no'            => 'integer',
                    'list_schedule.year_n'               => 'integer',
                    'list_schedule.month_n'              => 'integer',
                    'list_schedule.start_date'           => 'date',
                    'list_schedule.deadline_date'        => 'date',
                    'list_schedule.report_alert'         => 'integer',
                    'list_schedule.report_user_typ'      => 'integer',
               ];
               $validator = \Validator::make($data_request, $rules);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $params['json']          = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $params['company_cd']    = session_data()->company_cd ?? 0;
               $params['cre_user']      =   session_data()->user_id;; //session_data()->user_id;
               $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];

               $res         =  Dao::executeSql('SPC_rI1010_ACT1', $params);

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
     /**
      * postDelete
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:30:22
      * @return void
      */
     public function postDelete(Request $request)
     {
          try {
               $data_request = $request->all();
               $rules = [
                    'fiscal_year'  => 'integer',
                    'report_kind'  => 'integer',
                    'report_group_list.report_group' => 'integer',
                    'detail_no.detail_no' => 'integer',
                    'month'   => 'integer',
               ];
               $validator = Validator::make($data_request, $rules);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $params['json']          = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $params['company_cd']    = session_data()->company_cd ?? 0;
               $params['cre_user']      = session_data()->user_id;; //session_data()->user_id;
               $params['cre_ip']        = $_SERVER['REMOTE_ADDR'];
               $params['month']         = $request->all()['month']??-1;
               $res                 = Dao::executeSql('SPC_rI1010_ACT2', $params);
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
     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postReferGroup(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'report_kind'  => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $params['report_kind']   = $request->report_kind ?? 0;
          $data['report_group'] = $this->weeklyReportService->getGroupForSheet($params['report_kind']);
          if (isset($data_table_info[0][0]['error_typ']) && $data_table_info[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          return response()->json($data);
     }
}
