<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Carbon\Carbon;
use App\Services\WeeklyReport\PersonalTargetService;
use App\Services\MiraiService;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\AdequacyService;

class RDashboardController extends Controller
{
     /** PersonalTargetService */
     public $target_service;
     /** MiraiService */
     public $mirai_service;
     /** WeeklyReportService */
     public $weeklyreport_service;
     /** AdequacyService */
     public $adequacy_service;

     public function __construct(
          PersonalTargetService $target_service,
          MiraiService $mirai_service,
          AdequacyService $adequacy_service,
          WeeklyReportService $weeklyreport_service
     ) {
          parent::__construct();
          $this->target_service = $target_service;
          $this->mirai_service = $mirai_service;
          $this->adequacy_service = $adequacy_service;
          $this->weeklyreport_service = $weeklyreport_service;
     }

     /**
      * get Rdashboard Admin
      * @author namnt
      * @created at 2023-02-02
      * @return \Illuminate\Http\Response
      */
     public function admin(Request $request)
     {
          $data['title'] = trans('rdashboard.rdashboard_admin');
          $company_cd = session_data()->company_cd ?? 0;
          $employee_cd = session_data()->employee_cd ?? '';
          $params = $request->all();
          $validator = Validator::make($params, [
               'fiscal_year' => ['nullable', 'integer'],
               'year' => ['nullable', 'integer'],
               'month' => ['nullable', 'integer'],
               'times' => ['nullable', 'integer'],
               'report_kind' => ['nullable', 'integer'],
               'mygroup_cd' => ['nullable', 'integer'],
               'belong_cd1' => ['nullable', 'max:20'],
               'belong_cd2' => ['nullable', 'max:20'],
               'belong_cd3' => ['nullable', 'max:20'],
               'belong_cd4' => ['nullable', 'max:20'],
               'belong_cd5' => ['nullable', 'max:20'],
               'shared_report' => ['nullable', 'integer'],
               'approved_show' => ['nullable', 'integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          // report_kind
          $report_kinds_data = $this->weeklyreport_service->getScheduleSetting($company_cd, 0);
          // fiscal_year
          if (isset($params['fiscal_year'])) {
               $fiscal_year = $params['fiscal_year'];
          } else {
               $fiscal_year = $this->mirai_service->findFiscalYearFromDate($company_cd, 5);
          }
          $fiscal_year_month = 0;
          // get month
          $month = -1;
          if (isset($params['month'])) {
               $month = $params['month'];
          } else {
               $now = Carbon::now();
               $current_month = $this->weeklyreport_service->getScheduleSetting($company_cd, 6, $fiscal_year, 0, $now->month, 0, 0, $now->year);
               if (isset($current_month[0]) && !empty($current_month[0])) {
                    $month = (int)(substr($current_month[0]['month_nm'], -2));
                    $fiscal_year_month = $current_month[0]['month'] ?? 0;
               }
          }
          // get all months
          $months = $this->weeklyreport_service->getScheduleSetting($company_cd, 5, $fiscal_year, 0, 0, 0, 0);
          $year = -1;
          if (isset($months) && !empty($months)) {
               foreach ($months as $value) {
                    if ($value['month'] == $fiscal_year_month) {
                         $year = (int)(substr($value['month_nm'], 0, 4));
                    }
               }
          }
          $filter['fiscal_year'] = $fiscal_year;
          $filter['fiscal_year_month'] = $fiscal_year_month;
          $years = $this->weeklyreport_service->getScheduleSetting($company_cd, 1);
          $filter['years'] = $years;
          $filter['month'] = $month;
          $filter['months'] = [];
          foreach ($years as $key => $value) {
               if ($fiscal_year == $value['fiscal_year']) {
                    $filter['months'] = $months;
               }
          }
          $filter['times_list'] = $this->weeklyreport_service->getScheduleSetting($company_cd, 3, $fiscal_year, 5, $fiscal_year_month);
          $filter['year'] = $params['year'] ?? $year;
          $filter['times'] = $params['times'] ?? -1;
          if (isset($params['report_kind'])) {
               $filter['report_kind'] = $params['report_kind'];
          } else {
               $filter['report_kind'] = -1;
          }
          $filter['mygroup_cd'] = $params['mygroup_cd'] ?? -1;
          $filter['belong_cd1'] = $params['belong_cd1'] ?? '-1';
          $filter['belong_cd2'] = $params['belong_cd2'] ?? '-1';
          $filter['belong_cd3'] = $params['belong_cd3'] ?? '-1';
          $filter['belong_cd4'] = $params['belong_cd4'] ?? '-1';
          $filter['belong_cd5'] = $params['belong_cd5'] ?? '-1';
          $filter['shared_report'] = $params['shared_report'] ?? 0;
          $filter['approved_show'] = $params['approved_show'] ?? 0;
          $filter['mygroups'] = getCombobox('F4010', 1, 5);
          $filter['M0022'] = getCombobox('M0022', 1, 5);
          $filter['M0020'] = getCombobox('M0020', 1, 5);
          $filter['report_authority_typ'] = 0;
          if (session()->has(AUTHORITY_KEY)) {
               $user = session(AUTHORITY_KEY);
               $filter['report_authority_typ'] = (int)$user->report_authority_typ ?? 0;
          }
          // 
          $report_kinds = $this->weeklyreport_service->getReportKinds($company_cd, 'desc');

          $reports['report_kinds'] = $report_kinds[0] ?? [];
          $reports['reports'][] = $this->weeklyreport_service->getReportsForViewers(
               $employee_cd,
               $filter['fiscal_year'],
               $filter['year'],
               $filter['month'],
               $filter['times'],
               $filter['report_kind'],
               $filter['mygroup_cd'],
               $filter['shared_report'],
               $filter['approved_show'],
               $filter['belong_cd1'],
               $filter['belong_cd2'],
               $filter['belong_cd3'],
               $filter['belong_cd4'],
               $filter['belong_cd5']
          );
          $adequacy = $this->getAdequacy();
          // POST METHOD
          if ($request->isMethod('post')) {
               $screen['screen'] = 'admin';
               return view('WeeklyReport::rdashboard.referLeftReports', array_merge($reports, $filter, $adequacy, $screen));
          }
          // 
          $reactions['reactions'] = $this->weeklyreport_service->getInfomations(3, $filter['fiscal_year'], $employee_cd);
          $alerts['alerts'] = $this->weeklyreport_service->getInfomations(2, $filter['fiscal_year'], $employee_cd);
          $notifications['notifications'] = $this->weeklyreport_service->getInfomations(1, $filter['fiscal_year'], $employee_cd);
          $shares['shares'] = $this->weeklyreport_service->getInfomations(4, $filter['fiscal_year'], $employee_cd);
          $report_kinds['report_kinds'] = $report_kinds_data;
          // dd(array_merge($reports, $reactions, $notifications, $data, $filter, $shares, $adequacy, $report_kinds));
          return view('WeeklyReport::rdashboard.admin.getAdmin', array_merge($reports, $reactions, $notifications, $data, $filter, $shares, $adequacy, $report_kinds));
     }

     /**
      * get Rdashboard Reporter (報告者)
      * @author namnt
      * @created at 2023-02-02
      * @return \Illuminate\Http\Response
      */
     public function reporter(Request $request)
     {
          $data['title'] = trans('rdashboard.rdashboard_reporter');
          $company_cd = session_data()->company_cd ?? 0;
          $employee_cd = session_data()->employee_cd ?? '';
          $params = $request->all();
          // 
          $now = Carbon::now();
          $current_year = $now->year;
          $filter['year'][] = $now->year - 3;
          $filter['year'][] = $now->year - 2;
          $filter['year'][] = $now->year - 1;
          $filter['year'][] = $current_year;
          $filter['year'][] = $now->year + 1;
          $filter['year'][] = $now->year + 2;
          $filter['year'][] = $now->year + 3;
          $validator = Validator::make($params, [
               'year' => ['nullable', 'integer'],
               'month' => ['nullable', 'integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $filter['month'] = $params['month'] ?? $now->month;
          $filter['current_year'] = $params['year'] ?? $current_year;
          $filter['report_authority_typ'] = 0;
          if (session()->has(AUTHORITY_KEY)) {
               $user = session(AUTHORITY_KEY);
               $filter['report_authority_typ'] = (int)$user->report_authority_typ ?? 0;
          }
          // report
          $reports['reports'] = $this->weeklyreport_service->getReportsForReporter($employee_cd, $filter['current_year'], $filter['month']);
          $adequacy = $this->getAdequacy();
          // POST METHOD
          if ($request->isMethod('post')) {
               return view('WeeklyReport::rdashboard.reporter.referLeftReportsForReporter', array_merge($filter, $reports, $adequacy));
          }
          $fiscal_year = $this->mirai_service->findFiscalYearFromDate($company_cd, 5);
          $target['target'] = $this->target_service->find($company_cd, $fiscal_year, $employee_cd, 0);
          $filter['fiscal_year'] = $fiscal_year;
          // report
          $reactions['reactions'] = $this->weeklyreport_service->getInfomations(3, $fiscal_year, $employee_cd);
          $alerts['alerts'] = $this->weeklyreport_service->getInfomations(2, $fiscal_year, $employee_cd);
          $noti_1 = $this->weeklyreport_service->getInfomations(1, $fiscal_year, $employee_cd);
          $noti_5 = $this->weeklyreport_service->getInfomations(5, $fiscal_year, $employee_cd);
          // $notifications['notifications'] = $this->weeklyreport_service->getInfomations(1, $fiscal_year, $employee_cd);
          $notifications['notifications'] = array_merge($noti_1, $noti_5);
          $shares['shares'] = $this->weeklyreport_service->getInfomations(4, $fiscal_year, $employee_cd);
          // dd(array_merge($reactions, $reports, $notifications, $alerts, $data, $target, $filter, $shares, $adequacy));
          return view('WeeklyReport::rdashboard.reporter.getReporter', array_merge($reactions, $reports, $notifications, $alerts, $data, $target, $filter, $shares, $adequacy));
     }

     /**
      * get Rdashboard Approver
      * @author namnt
      * @created at 2023-02-02
      * @return \Illuminate\Http\Response
      */
     public function approver(Request $request)
     {
          $data['title'] = trans('rdashboard.rdashboard_approver');
          $company_cd = session_data()->company_cd ?? 0;
          $employee_cd = session_data()->employee_cd ?? '';
          $params = $request->all();
          $validator = Validator::make($params, [
               'fiscal_year' => ['nullable', 'integer'],
               'year' => ['nullable', 'integer'],
               'month' => ['nullable', 'integer'],
               'times' => ['nullable', 'integer'],
               'mygroup_cd' => ['nullable', 'integer'],
               'belong_cd1' => ['nullable', 'max:20'],
               'belong_cd2' => ['nullable', 'max:20'],
               'belong_cd3' => ['nullable', 'max:20'],
               'unapproved_only' => ['nullable', 'integer'],
               'approved_show' => ['nullable', 'integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          // get fiscal_year
          if (isset($params['fiscal_year'])) {
               $fiscal_year = $params['fiscal_year'];
          } else {
               $fiscal_year = $this->mirai_service->findFiscalYearFromDate($company_cd, 5);
          }
          $fiscal_year_month = 0;
          // get month
          $month = -1;
          if (isset($params['month'])) {
               $month = $params['month'];
          } else {
               $now = Carbon::now();
               $current_month = $this->weeklyreport_service->getScheduleSetting($company_cd, 6, $fiscal_year, 0, $now->month, 0, 0, $now->year);
               if (isset($current_month[0]) && !empty($current_month[0])) {
                    $month = (int)(substr($current_month[0]['month_nm'], -2));
                    $fiscal_year_month = $current_month[0]['month'] ?? 0;
               }
          }
          // get all months
          $months = $this->weeklyreport_service->getScheduleSetting($company_cd, 5, $fiscal_year, 0, 0, 0, 0);
          $year = -1;
          if (isset($months) && !empty($months)) {
               foreach ($months as $value) {
                    if ($value['month'] == $fiscal_year_month) {
                         $year = (int)(substr($value['month_nm'], 0, 4));
                    }
               }
          }
          $years = $this->weeklyreport_service->getScheduleSetting($company_cd, 1);
          $filter['fiscal_year'] = $fiscal_year;
          $filter['fiscal_year_month'] = $fiscal_year_month;
          $filter['years'] = $years;
          $filter['month'] = $month;
          $filter['months'] = [];
          foreach ($years as $key => $value) {
               if ($fiscal_year == $value['fiscal_year']) {
                    $filter['months'] = $months;
               }
          }
          $filter['times_list'] = $this->weeklyreport_service->getScheduleSetting($company_cd, 3, $fiscal_year, 5, $fiscal_year_month);
          $filter['year'] = $params['year'] ?? $year;
          $filter['times'] = $params['times'] ?? -1;
          $filter['unapproved_only'] = $params['unapproved_only'] ?? 0;
          $filter['approved_show'] = $params['approved_show'] ?? 0;
          $filter['mygroup_cd'] = $params['mygroup_cd'] ?? -1;
          $filter['mygroups'] = getCombobox('F4010', 1, 5);
          $filter['M0022'] = getCombobox('M0022', 1, 5);
          $filter['M0020'] = getCombobox('M0020', 1, 5);
          $filter['belong_cd1'] = $params['belong_cd1'] ?? '-1';
          $filter['belong_cd2'] = $params['belong_cd2'] ?? '-1';
          $filter['belong_cd3'] = $params['belong_cd3'] ?? '-1';
          $report_kinds = $this->weeklyreport_service->getReportKinds($company_cd, 'desc');
          $reports['report_kinds'] = $report_kinds[0] ?? [];
          $reports['reports'] = [];
          if (isset($report_kinds[0])) {
               foreach ($report_kinds[0] as $key => $value) {
                    $reports['reports'][] = $this->weeklyreport_service->getReportsForApprover(
                         $employee_cd,
                         $fiscal_year,
                         $value['report_kind'],
                         $filter['year'],
                         $filter['month'],
                         $filter['times'],
                         $filter['mygroup_cd'],
                         $filter['belong_cd1'],
                         $filter['belong_cd2'],
                         $filter['belong_cd3'],
                         $filter['unapproved_only'],
                         $filter['approved_show']
                    );
               }
          }
          $adequacy = $this->getAdequacy();
          // POST METHOD
          if ($request->isMethod('post')) {
               $screen['screen'] = 'approver';
               return view('WeeklyReport::rdashboard.referLeftReports', array_merge($reports, $filter, $adequacy, $screen));
          }
          $reactions['reactions'] = $this->weeklyreport_service->getInfomations(3, $fiscal_year, $employee_cd);
          $alerts['alerts'] = $this->weeklyreport_service->getInfomations(2, $fiscal_year, $employee_cd);
          $notifications['notifications'] = $this->weeklyreport_service->getInfomations(1, $fiscal_year, $employee_cd);
          $shares['shares'] = $this->weeklyreport_service->getInfomations(4, $fiscal_year, $employee_cd);
          // dd(array_merge($reports, $notifications, $alerts, $reactions, $data, $filter, $shares, $adequacy));
          return view('WeeklyReport::rdashboard.approver.getApprover', array_merge($reports, $notifications, $alerts, $reactions, $data, $filter, $shares, $adequacy));
     }

     /**
      * get Adequacy from Master 
      *
      * @return Array
      */
     public function getAdequacy()
     {
          // 充実度 & 繁忙度 & その他
          $adequacy['adequacy'] = $this->adequacy_service->getAdequacyByMarkKbn(1);
          $adequacy['busyness'] = $this->adequacy_service->getAdequacyByMarkKbn(2);
          $adequacy['other'] = $this->adequacy_service->getAdequacyByMarkKbn(3);
          return $adequacy;
     }

     /**
      * postRead
      *
      * @param  Request $request
      * @return void
      */
     public function postRead(Request $request)
     {
          $params = $request->all();
          $validator = Validator::make($params, [
               'fiscal_year' => ['integer'],
               'infomation_typ' => ['integer'],
               'employee_cd' => ['max:10'],
               'report_kind' => ['integer'],
               'report_no' => ['integer'],
               'from_employee_cd' => ['max:10'],
               'to_employee_cd' => ['max:10'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          try {
               $response['status'] = OK;
               $response['errors'] = [];
               $report = $this->weeklyreport_service->readNotification($params);
               if (isset($report[0]) && !empty($report[0])) {
                    $response['status'] = NG;
                    foreach ($report[0] as $temp) {
                         array_push($response['errors'], $temp);
                    }
               }
          } catch (\Exception $e) {
               $response['status'] = EX;
               $response['Exception'] = $e->getMessage();
          }
          return response()->json($response);
     }

     /**
      * postCache
      *
      * @param  Request $request
      * @return void
      */
     public function postCache(Request $request)
     {
          $params = $request->all();
          $validator = Validator::make($params, [
               'reports.*.fiscal_year' => ['integer'],
               'reports.*.employee_cd' => ['max:10'],
               'reports.*.report_kind' => ['integer'],
               'reports.*.report_no' => ['integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          try {
               $response['status'] = OK;
               $response['errors'] = [];
               $report = $this->mirai_service->cacheReports(json_encode($params));
               if (isset($report[0]) && !empty($report[0])) {
                    $response['status'] = NG;
                    foreach ($report[0] as $temp) {
                         array_push($response['errors'], $temp);
                    }
               }
          } catch (\Exception $e) {
               $response['status'] = EX;
               $response['Exception'] = $e->getMessage();
          }
          return response()->json($response);
     }
}
