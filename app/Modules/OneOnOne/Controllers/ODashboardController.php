<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use App\Services\OneOnOneService;
use App\Services\AdequacyService;
use App\Services\YearTargetService;
use Carbon\Carbon;
use Dao;

class ODashboardController extends Controller
{
     protected $one_on_one_service;
     protected $year_target_service;
     protected $adequacyService;
     //
     public function __construct(AdequacyService $adequacyService, OneOnOneService $OneOnOneService, YearTargetService $YearTargetService)
     {
          parent::__construct();
          $this->one_on_one_service = $OneOnOneService;
          $this->year_target_service = $YearTargetService;
          $this->adequacyService = $adequacyService;
     }
     /**
      * index
      *
      * @param  mixed $request
      * @return void
      */
     public function index(Request $request)
     {
          $data['title'] = trans('messages.dashboard_coach');
          $data['category'] = trans('messages.home');
          $data['category_icon'] = 'fa fa-home';
          $data['F2001']                     = getCombobox('F2001', 1);
          //
          $reqs = [
               'fiscal_year_1on1'  => $request->fiscal_year_1on1 ?? 0,
               'group_cd_1on1'     => $request->group_cd_1on1 ?? 0,
          ];
          $validator = Validator::make($reqs, [
               'fiscal_year_1on1'  => ['integer'],
               'group_cd_1on1'     => ['integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          //
          $company_cd = session_data()->company_cd;
          // default fiscal_year
          $data_year                    =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          if ((isset($data_year[0][0]['error_typ']) && $data_year[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $request['fiscal_year_1on1']  = 0;
          if (isset($data_year['fiscal_year'])) {
               foreach ($data['F2001'] as  $value) {
                    if ($value['fiscal_year'] == $data_year['fiscal_year']) {
                         $request['fiscal_year_1on1'] = $data_year['fiscal_year'];
                    }
               }
          }
          //
          $data['fiscal_year_1on1']     = $request['fiscal_year_1on1'];
          $left     = $this->postLeftCoachContent($request);
          $right    = $this->postRightCoachContent($request);
          return view('OneOnOne::odashboard.coach.index', array_merge($data, $left, $right));
     }

     /**
      * postLeftCoachContent
      *
      * @param  mixed $request
      * @return void
      */
     public function postLeftCoachContent(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1'       => 'integer',
               'group_cd_1on1'          => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          $data['F2001'] = getCombobox('F2001', 1);
          $company_cd = session_data()->company_cd;
          //
          $params = [
               'fiscal_year_1on1'            => $request->fiscal_year_1on1 ?? 0,
               'group_cd_1on1'               => $request->group_cd_1on1 ?? -1,
               'times_from'                  => $request->times_from ?? 1,
               'company_cd'                  => session_data()->company_cd,
               'employee_cd'                 => session_data()->employee_cd,
               'w_1on1_authority_typ'        => session_data()->w_1on1_authority_typ,
               'screen'                      => 0, //0: screen coach ,1 :screen admin
               'language'                    => session_data()->language,
          ];
          //
          $members = Dao::executeSql('SPC_1ON1_DASHBOARD_COACH_FND1', $params);
          if (isset($members[0][0]['error_typ']) && $members[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['members'] = $members ?? [];
          $data['fiscal_year_1on1'] = $params['fiscal_year_1on1'] ?? 0;
          $data['group_oneonone']            = $members[3] ?? [];
          $data['group_cd_1on1']             = $members[4][0]['group_cd_1on1'] ?? 0;

          $getRemarkCombo                    = $this->adequacyService->getRemarkCombo($company_cd);
          if ((isset($getRemarkCombo[0][0]['error_typ']) && $getRemarkCombo[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $data['combo_remark']              = $getRemarkCombo ?? [];
          $data['employee_cd_login'] = session_data()->employee_cd;
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.coach.referLeftMembersForCoach', $data);
          } else {
               return $data;
          }
     }

     /**
      * postRightCoachContent
      *
      * @param  mixed $request
      * @return void
      */
     public function postRightCoachContent(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1'      => 'integer',
               'group_cd_1on1'          => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          //
          $params = [
               'fiscal_year_1on1'            => $request->fiscal_year_1on1 ?? 0,
               'group_cd_1on1'               => $request->group_cd_1on1 ?? -1,
               'company_cd'                  => session_data()->company_cd,
               'employee_cd'                 => session_data()->employee_cd,
               'w_1on1_authority_typ'        => session_data()->w_1on1_authority_typ,
          ];
          // schedules
          $schedules = $this->one_on_one_service->get1on1ScheduleList($params['company_cd'], $params['fiscal_year_1on1'], $params['employee_cd'], $params['w_1on1_authority_typ'], 1);
          // alerts
          $alerts = $this->one_on_one_service->getNotificationList($params['company_cd'], $params['employee_cd'], 2, $params['fiscal_year_1on1']);
          // reminds
          // $reminds = $this->one_on_one_service->getNotificationList($params['company_cd'], $params['employee_cd'], 1, $params['fiscal_year_1on1'],1);
          // coach_member
          $is_coach_member = $this->one_on_one_service->usedToCoachOrMember($params['company_cd'], $params['employee_cd']);
          //
          if ((isset($one_on_one_service[0][0]['error_typ']) && $one_on_one_service[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          // check error
          if (isset($members[0][0]['error_typ']) && $members[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($schedules[0][0]['error_typ']) && $schedules[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($alerts[0][0]['error_typ']) && $alerts[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($is_coach_member[0][0]['error_typ']) && $is_coach_member[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          // if (isset($reminds[0][0]['error_typ']) && $reminds[0][0]['error_typ'] == '999') {
          //      return response()->view('errors.query', [], 501);
          // }
          $data['schedules'] = $schedules[0] ?? [];
          $data['alerts'] = $alerts[0] ?? [];
          // $data['reminds'] = $reminds[0] ?? [];
          $data['is_coach_member'] = $is_coach_member[0][0] ?? [];
          //
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.coach.referRightForCoach', $data);
          } else {
               return $data;
          }
     }
     /**
      * getMember
      *
      * @param  mixed $request
      * @return void
      */
     public function getMember(Request $request)
     {
          $data['title'] = trans('messages.dashboard_member');
          $data['category'] = trans('messages.home');
          $data['category_icon'] = 'fa fa-home';
          $data['F2001'] = getCombobox('F2001', 1);
          $data['F2000'] = getCombobox('F2000', 1);

          $data_year  =  $this->one_on_one_service->getCurrentFiscalYear(session_data()->company_cd);
          if (isset($data_year[0][0]['error_typ']) && $data_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $request['fiscal_year_1on1_member']  = 0;
          if (isset($data_year['fiscal_year'])) {
               foreach ($data['F2001'] as  $value) {
                    if ($value['fiscal_year'] == $data_year['fiscal_year']) {
                         $request['fiscal_year_1on1_member'] = $data_year['fiscal_year'];
                    }
               }
          }
          // $request['fiscal_year_1on1_member']  = $data_year['fiscal_year'] ?? ($data['F2001'][0]['fiscal_year'] ?? 0);
          $target = $this->postLeftTargetForMember($request);
          $times = $this->postLeftTimesForMember($request);
          $right = $this->postRightMemberContent($request);
          $data['login_employee_nm'] = (session_data()->m0070->employee_nm ?? '') . trans('messages.san');
          return view('OneOnOne::odashboard.member.getMember', array_merge($data, $target, $times, $right));
     }
     /**
      * postLeftTimesForMember
      *
      * @param  mixed $request
      * @return void
      */
     public function postLeftTimesForMember(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1_member'      => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          //
          $params = [
               'fiscal_year_1on1_member' => $request->fiscal_year_1on1_member ?? 0,
               'company_cd' => session_data()->company_cd,
               'employee_cd' => session_data()->employee_cd,
               'w_1on1_authority_typ' => session_data()->w_1on1_authority_typ,
               'language'               => session_data()->language,
          ];
          //
          $times = Dao::executeSql('SPC_1ON1_DASHBOARD_MEMBER_FND1', $params);
          if (isset($times[0][0]['error_typ']) && $times[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['times'] = $times[0] ?? [];
          $data['fiscal_year_1on1_member']     = $request->fiscal_year_1on1_member ?? 0;
          $getRemarkCombo                    = $this->adequacyService->getRemarkCombo(session_data()->company_cd);
          if (isset($getRemarkCombo[0][0]['error_typ']) && $getRemarkCombo[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['combo_remark']              = $getRemarkCombo ?? [];
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.member.referLeftTimesForMember', $data);
          } else {
               return $data;
          }
     }

     /**
      * get target of member
      *
      * @param  mixed $request
      * @return void
      */
     public function postLeftTargetForMember(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1_member'      => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          // call service
          $company_cd = session_data()->company_cd ?? 0;
          $fiscal_year = $request->fiscal_year_1on1_member ?? 0;
          $employee_cd = session_data()->employee_cd ?? '';
          $target = $this->year_target_service->getYearTargetPerson($company_cd, $fiscal_year, $employee_cd);
          if (isset($target[0][0]['error_typ']) && $target[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['target'] = $target[0][0] ?? [];
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.member.referTargetMember', $data);
          } else {
               return $data;
          }
     }
     /**
      * postRightMemberContent
      *
      * @param  mixed $request
      * @return void
      */
     public function postRightMemberContent(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1_member'      => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          // group
          $company_cd = session_data()->company_cd;
          $fiscal_year = $request->fiscal_year_1on1_member ?? 0;
          $employee_cd = $request->employee_cd ?? '';
          $group = $this->one_on_one_service->findGroupForMember($company_cd, $fiscal_year, $employee_cd);
          // check error
          if (isset($group[0][0]['error_typ']) && $group[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          //
          $params = [
               'fiscal_year_1on1_member' => $fiscal_year,
               'group_cd_1on1' => $group[0][0]['w_1on1_group_cd'] ?? -1,
               'company_cd' => $company_cd,
               'employee_cd' => session_data()->employee_cd,
               'w_1on1_authority_typ' => session_data()->w_1on1_authority_typ,
          ];
          // schedules
          $schedules = $this->one_on_one_service->get1on1ScheduleList($params['company_cd'], $params['fiscal_year_1on1_member'], $params['employee_cd'], $params['w_1on1_authority_typ'], 0);
          // alerts
          $alerts = $this->one_on_one_service->getNotificationList($params['company_cd'], $params['employee_cd'], 2, $params['fiscal_year_1on1_member']);
          // reminds
          $notifications = $this->one_on_one_service->getNotificationList($params['company_cd'], $params['employee_cd'], 3, $params['fiscal_year_1on1_member']);
          // reminds
          // $reminds = $this->one_on_one_service->getNotificationList($params['company_cd'], $params['employee_cd'], 1, $params['fiscal_year_1on1_member'],2);
          // coach_member
          $is_coach_member = $this->one_on_one_service->usedToCoachOrMember($params['company_cd'], $params['employee_cd']);
          // check error
          if (isset($members[0][0]['error_typ']) && $members[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($schedules[0][0]['error_typ']) && $schedules[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($alerts[0][0]['error_typ']) && $alerts[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          // if (isset($reminds[0][0]['error_typ']) && $reminds[0][0]['error_typ'] == '999') {
          //      return response()->view('errors.query', [], 501);
          // }
          if (isset($notifications[0][0]['error_typ']) && $notifications[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if (isset($is_coach_member[0][0]['error_typ']) && $is_coach_member[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['schedules'] = $schedules[0] ?? [];
          $data['alerts'] = $alerts[0] ?? [];
          // $data['reminds'] = $reminds[0] ?? [];
          $data['notifications'] = $notifications[0] ?? [];
          $data['is_coach_member'] = $is_coach_member[0][0] ?? [];
          //
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.member.referRightForMember', $data);
          } else {
               return $data;
          }
     }
     /**
      * getPopup
      *
      * @param  mixed $request
      * @return void
      */
     public function getPopup(Request $request)
     {
          $data['title'] = '';
          $data['module'] = 'oneonone';
          $target = $this->postDetailPopupTarget($request);
          return view('OneOnOne::odashboard.target.popupMember', array_merge($target, $data));
     }
     /**
      * postSavePopupTarget
      *
      * @param  mixed $request
      * @return void
      */
     public function postSavePopupTarget(Request $request)
     {
          if ($request->ajax()) {
               //return request ajax
               try {
                    $request->rules = [
                         'fiscal_year_1on1_target' => 'integer'
                    ];
                    $this->valid($request);
                    if ($this->respon['status'] == OK) {
                         $params['json']                 =   $this->respon['data_sql'];
                         $params['login_employee_cd']    =   session_data()->employee_cd;
                         $params['cre_user']             =   session_data()->user_id;
                         $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                         $params['company_cd']           =   session_data()->company_cd;
                         //
                         $result = Dao::executeSql('SPC_1ON1_DASHBOARD_MEMBER_ACT1', $params);
                         // check exception
                         if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                              // $this->respon['status']     = EX;
                              // $this->respon['Exception']  = $result[0][0]['remark'];
                              return response()->view('errors.query', [], 501);
                         } else if (isset($result[0]) && !empty($result[0])) {
                              $this->respon['status'] = NG;
                              foreach ($result[0] as $temp) {
                                   array_push($this->respon['errors'], $temp);
                              }
                         } else {
                              $this->respon['status'] = OK;
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
      * postDeletePopupTarget
      *
      * @param  mixed $request
      * @return void
      */
     public function postDeletePopupTarget(Request $request)
     {
          if ($request->ajax()) {
               //return request ajax
               try {
                    $validator = Validator::make($request->all(), [
                         'fiscal_year_1on1_target'      => 'integer',
                    ]);
                    if ($validator->fails()) {
                         return response()->json('Error', 501);
                    }
                    //
                    $params['fiscal_year']   =   $request->fiscal_year_1on1_target ?? 0;
                    $params['employee_cd']   =   session_data()->employee_cd;
                    $params['cre_user']      =   session_data()->user_id;
                    $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']    =   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_1ON1_DASHBOARD_MEMBER_ACT2', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                         return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                         $this->respon['status'] = NG;
                         foreach ($result[0] as $temp) {
                              array_push($this->respon['errors'], $temp);
                         }
                    } else {
                         $this->respon['status'] = OK;
                    }
               } catch (\Exception $e) {
                    $this->respon['status']     = EX;
                    $this->respon['Exception']  = $e->getMessage();
               }
               return response()->json($this->respon);
          }
     }
     /**
      * postDetailPopupTarget
      *
      * @param  mixed $request
      * @return void
      */
     public function postDetailPopupTarget(Request $request)
     {
          // get target information
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1_target'      => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          $years[] = Carbon::now()->subYears(3)->year;
          $years[] = Carbon::now()->subYears(2)->year;
          $years[] = Carbon::now()->subYears(1)->year;
          $years[] = Carbon::now()->year;
          $years[] = Carbon::now()->addYears(1)->year;
          $years[] = Carbon::now()->addYears(2)->year;
          $years[] = Carbon::now()->addYears(3)->year;
          $data['years'] = $years;
          $data['current_year'] = $request->fiscal_year_1on1_target ?? 0;
          // call service
          $company_cd = session_data()->company_cd ?? 0;
          $fiscal_year = $data['current_year'];
          $employee_cd = session_data()->employee_cd ?? '';
          $target = $this->year_target_service->getYearTargetPerson($company_cd, $fiscal_year, $employee_cd);
          if (isset($target[0][0]['error_typ']) && $target[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          // return data
          $data['target'] = $target[0][0] ?? [];
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.target.popupMemberDetail', $data);
          } else {
               return $data;
          }
     }

     /**
      * index
      *
      * @param  mixed $request
      * @return void
      */
     public function getAdmin(Request $request)
     {
          $data['title'] = trans('messages.dashboard');
          $data['category'] = trans('messages.home');
          $data['category_icon'] = 'fa fa-home';
          $data['F2001']                     = getCombobox('F2001', 1);
          //
          $reqs = [
               'fiscal_year_1on1'  => $request->fiscal_year_1on1 ?? 0,
               'group_cd_1on1'     => $request->group_cd_1on1 ?? 0,
          ];
          $validator = Validator::make($reqs, [
               'fiscal_year_1on1'  => ['integer'],
               'group_cd_1on1'     => ['integer'],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          //
          $company_cd = session_data()->company_cd;
          $employee_cd = session_data()->employee_cd;
          // default fiscal_year
          $data_year                    =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          // coach_member
          $is_coach_member = $this->one_on_one_service->usedToCoachOrMember($company_cd, $employee_cd);
          //
          if ((isset($data_year[0][0]['error_typ']) && $data_year[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          if ((isset($is_coach_member[0][0]['error_typ']) && $is_coach_member[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $request['fiscal_year_1on1']  = 0;
          if (isset($data_year['fiscal_year'])) {
               foreach ($data['F2001'] as  $value) {
                    if ($value['fiscal_year'] == $data_year['fiscal_year']) {
                         $request['fiscal_year_1on1'] = $data_year['fiscal_year'];
                    }
               }
          }
          //
          $data['fiscal_year_1on1']    = $request['fiscal_year_1on1'];
          $data['is_coach_member']     = $is_coach_member[0][0] ?? [];
          $left     = $this->postLeftAdminContent($request);
          return view('OneOnOne::odashboard.admin.index', array_merge($data, $left));
     }

     /**
      * postLeftAdminContent
      *
      * @param  mixed $request
      * @return void
      */
     public function postLeftAdminContent(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year_1on1'       => 'integer',
               'group_cd_1on1'          => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          $data['F2001'] = getCombobox('F2001', 1);
          $company_cd = session_data()->company_cd;
          //
          $params = [
               'fiscal_year_1on1'            => $request->fiscal_year_1on1 ?? 0,
               'group_cd_1on1'               => $request->group_cd_1on1 ?? -1,
               'times_from'                  => $request->times_from ?? 1,
               'company_cd'                  => session_data()->company_cd,
               'employee_cd'                 => session_data()->employee_cd,
               'w_1on1_authority_typ'        => session_data()->w_1on1_authority_typ,
               'screen'                      => 1, //0: screen coach ,1 :screen admin
               'language'                    => session_data()->language,
          ];
          //
          $members = Dao::executeSql('SPC_1ON1_DASHBOARD_COACH_FND1', $params);
          if (isset($members[0][0]['error_typ']) && $members[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['members'] = $members ?? [];
          $data['fiscal_year_1on1'] = $params['fiscal_year_1on1'] ?? 0;
          $data['group_oneonone']            = $members[3] ?? [];
          $data['group_cd_1on1']             = $members[4][0]['group_cd_1on1'] ?? 0;

          $getRemarkCombo                    = $this->adequacyService->getRemarkCombo($company_cd);
          if ((isset($getRemarkCombo[0][0]['error_typ']) && $getRemarkCombo[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $data['combo_remark']              = $getRemarkCombo ?? [];
          $data['employee_cd_login'] = session_data()->employee_cd;
          if ($request->ajax()) {
               return view('OneOnOne::odashboard.admin.referLeftMembersForAdmin', $data);
          } else {
               return $data;
          }
     }
}
