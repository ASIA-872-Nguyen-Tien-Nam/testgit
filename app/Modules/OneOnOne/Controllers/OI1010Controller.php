<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\OneOnOneService;

class OI1010Controller extends Controller
{
     protected $scheduleService;
     public function __construct(ScheduleService $scheduleService, OneOnOneService $oneononeService)
     {
          parent::__construct();
          $this->scheduleService = $scheduleService;
          $this->oneononeService       = $oneononeService;
     }
     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:30:22
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['category']         = trans('messages.preparation');
          $data['category_icon']    = 'fa fa-book';
          $data['title']            = trans('messages.1on1_schedule_setting');
          $data_service             = $this->scheduleService->getOption();
          $data_service_fiscal_year = $this->oneononeService->getCurrentFiscalYear(session_data()->company_cd);
          if (isset($data_service[0][0]['error_typ']) && $data_service[0][0]['error_typ'] == '999'
          || isset($data_service_fiscal_year[0][0]['error_typ']) && $data_service_fiscal_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['fiscal_year']      = $data_service_fiscal_year['fiscal_year'];
          $data['oneonone_group']   = $data_service[1] ?? [];
          return view('OneOnOne::oi1010.index', $data);
     }

     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postRefer(Request $request)
     {
          $data_request = $request->json()->all();
          $rules = [
               'fiscal_year'                        => 'integer',
               'oneonone_group_list.oneonone_group' => 'integer',
          ];
          $validator = \Validator::make($data_request, $rules);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $company_cd             = session_data()->company_cd;
          $fiscal_year            = $data_request['fiscal_year']      ?? 0;
          $oneonone_group_list    = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
          $data_service           = $this->scheduleService->findSchedule($company_cd, $fiscal_year, $oneonone_group_list);
          if (isset($data_service[0][0]['error_typ']) && $data_service[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['table_info']     = $data_service[0][0] ?? [];
          $data['table_schedule'] = $data_service[1] ?? [];

          if ($request->ajax()) {
               return view('OneOnOne::oi1010.refer', $data)->render();
               //return request ajax
          } else {
               return $data;
          }
     }
     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:30:22
      * @return void
      */
     public function postSave(Request $request)
     {
          try {
               $this->respon['status'] = OK;
               $this->respon['errors'] = [];
               $data_request = $request->json()->all()['data_sql'];
               $rules = [
                    'fiscal_year'                        => 'integer',
                    'oneonone_group_list.oneonone_group' => 'integer',
                    'list_schedule.times'                => 'integer',
                    'list_schedule.start_date'           => 'date',
                    'list_schedule.deadline_date'        => 'date',
                    'list_schedule.oneonone_alert'       => 'integer',
               ];
               $validator = \Validator::make($data_request, $rules);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $company_cd  = session_data()->company_cd;
               $fiscal_year = $data_request['fiscal_year']      ?? 0;
               $json        = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $res         = $this->scheduleService->saveSchedule($company_cd, $fiscal_year, $json);
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
      * @created at 2020-09-04 08:30:22
      * @return void
      */
     public function postDelete(Request $request)
     {
          try {
               $this->respon['status'] = OK;
               $this->respon['errors'] = [];
               $data_request = $request->all();

               $rules = [
                    'fiscal_year'                        => 'integer',
                    'oneonone_group_list.oneonone_group' => 'integer',
               ];
               $validator = \Validator::make($data_request, $rules);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $company_cd          = session_data()->company_cd;
               $fiscal_year         = $data_request['fiscal_year']      ?? 0;
               $oneonone_group_list = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $res                 = $this->scheduleService->deleteSchedule($company_cd, $fiscal_year, $oneonone_group_list);
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
