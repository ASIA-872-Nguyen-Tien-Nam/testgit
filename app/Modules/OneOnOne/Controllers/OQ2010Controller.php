<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\AdequacyService;
use Validator;
use Dao;
use Crypt;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;
use App\Services\OneOnOneService;
use App\Services\YearTargetService;

class OQ2010Controller extends Controller
{
   protected $scheduleService;
   protected $adequacyService;
   protected $one_on_one_service;
   protected $YearTargetService;
   public function __construct(ScheduleService $scheduleService, AdequacyService $adequacyService, OneOnOneService $OneOnOneService, YearTargetService $YearTargetService)
   {
      parent::__construct();
      $this->scheduleService   = $scheduleService;
      $this->adequacyService   = $adequacyService;
      $this->one_on_one_service = $OneOnOneService;
      $this->YearTargetService = $YearTargetService;
   }
   /**
    * Show the application index.
    * @author mail@ans-asia.com
    * @created at 2020-09-04 08:32:04
    * @return \Illuminate\Http\Response
    */
   public function index(Request $request)
   {
      $company_cd = session_data()->company_cd;
      $data['category'] = trans('messages.implement');
      $data['category_icon'] = 'fa fa-users';
      $data['image'] = 'template/image/icon/icon_2_write.png';
      $data['title'] = trans('messages.list_of_1on1_implementation');
      $data['authority_typ_1on1']    = session_data()->w_1on1_authority_typ;
      $data['redirect_flg'] = 0;
      //
      $redirect_param = $request->redirect_param ?? '';
      if ($redirect_param != '') {
         try {
            $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            $data['redirect_flg']  = 1;
         } catch (DecryptException $e) {
            return response()->view('errors.403');
         }
      }
      $reqs = [
         'fiscal_year_1on1'          => $redirect_param->fiscal_year_1on1 ?? '',
         'group_cd_1on1'             => $redirect_param->group_cd_1on1 ?? '',
         'employee_cd'               => $redirect_param->employee_cd ?? session_data()->employee_cd,
         'times'                     => $redirect_param->times ?? 0,
         'from'                      => $redirect_param->from ?? '',
      ];
      $validator = Validator::make($reqs, [
         'fiscal_year_1on1'       => ['integer'],
         'group_cd_1on1'          => ['integer'],
         'times'                  => ['integer'],
         'from'  => [
            'string',
            Rule::in(['odashboard', 'odashboardmember']),
         ],
      ]);
      if ($validator->fails()) {
         return response()->view('errors.query', [], 501);
      }
      //
      $params = [
         'company_cd'                => $company_cd,
         'employee_cd'               => $reqs['employee_cd'],
      ];
      if ($data['redirect_flg'] == 1 || $data['authority_typ_1on1'] == 1) {
         $res = Dao::executeSql('SPC_OQ2020_INQ1', $params);
         if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
         }
         if ($reqs['from'] == "odashboard") {
            $data['coach_cd']        = $res[0][0]['employee_cd'] ?? '';
            $data['coach_name']      = $res[0][0]['employee_nm'] ?? '';
         } else {
            $data['employee_cd']        = $res[0][0]['employee_cd'] ?? '';
            $data['employee_name']      = $res[0][0]['employee_nm'] ?? '';
         }
      }
      //
      $schedule_service              = $this->scheduleService->getOption();
      if (isset($schedule_service[0][0]['error_typ']) && $schedule_service[0][0]['error_typ'] == '999') {
         return response()->view('errors.query', [], 501);
      }
      $current_fiscal_year           = $this->one_on_one_service->getCurrentFiscalYear($company_cd);
      if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
         return response()->view('errors.query', [], 501);
      }
      $remark_combo                  = $this->adequacyService->getRemarkCombo($company_cd);
      if (isset($remark_combo[0][0]['error_typ']) && $remark_combo[0][0]['error_typ'] == '999') {
         return response()->view('errors.query', [], 501);
      }
      if ($reqs['fiscal_year_1on1'] != '') {
         $data['fiscal_year']        = $reqs['fiscal_year_1on1'];
      } else {
         $data['fiscal_year']        = $current_fiscal_year['fiscal_year'] ?? date("Y");
      }
      $data['current_fiscal_year']   = $current_fiscal_year['fiscal_year'] ?? date("Y");
      $data['group_cd_1on1']         = $reqs['group_cd_1on1'] ?? '';
      $data['redirect_times']        = $reqs['times'] ?? 0;
      $data['oneonone_group']        = $schedule_service[1] ?? [];
      $data['organization_group']    = getCombobox('M0022', 1) ?? [];
      $data['combo_organization']    = getCombobox('M0020', 1, 2) ?? [];
      $data['mark_cd']               = getCombobox('M2121', 1) ?? [];
      $data['combo_position']        = getCombobox('M0040', 1) ?? [];
      $data['combo_job']             = getCombobox('M0030', 1) ?? [];
      $data['combo_grade']           = getCombobox('M0050', 1) ?? [];
      $data['combo_employee_type']   = getCombobox('M0060', 1) ?? [];
      $data['combo_remark']          = $remark_combo ?? [];
      $target = $this->YearTargetService->getYearTarget($company_cd, $data['fiscal_year']);
      if ((isset($target[0][0]['error_typ']) && $target[0][0]['error_typ'] == '999')) {
         return response()->view('errors.query', [], 501);
      }
      $group_hd_default = 16;
      if ((isset($target[0][0]['target1_use_typ']) && $target[0][0]['target1_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['target2_use_typ']) && $target[0][0]['target2_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['target3_use_typ']) && $target[0][0]['target3_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['comment_use_typ']) && $target[0][0]['comment_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      $data['data_target']           = $target ?? [];
      $data['group_hd_default']      = $group_hd_default ?? 16;
      return view('OneOnOne::oq2010.index', $data);
   }

   /**
    * postSearch
    * @author mail@ans-asia.com
    * @created at 2020-09-04 08:29:12
    * @return void
    */
   public function postSearch(Request $request)
   {
      $this->respon['status'] = OK;
      $this->respon['errors'] = [];
      $data_request = $request->json()->all()['data_sql'];
      $validator = Validator::make($data_request, [
         'fiscal_year'              => 'integer',
         'group_cd'                 => 'integer',
         'fullfillment_type'        => 'integer',
         'position_cd'              => 'integer',
         'job_cd'                   => 'integer',
         'grade'                    => 'integer',
         'employee_typ'             => 'integer',
         'only_admin_comments'      => 'integer',
         'fullfillment_type'        => 'integer',
         'current_page'             => 'integer',
         'page_size'                => 'integer',
         'organization_step1.*.organization_cd_1'       =>  'integer',
         //
         'organization_step2.*.organization_cd_1'       =>  'integer',
         'organization_step2.*.organization_cd_2'       =>  'integer',
         //
         'organization_step3.*.organization_cd_1'       =>  'integer',
         'organization_step3.*.organization_cd_2'       =>  'integer',
         'organization_step3.*.organization_cd_3'       =>  'integer',
         // org 4
         'organization_step4.*.organization_cd_1'       =>  'integer',
         'organization_step4.*.organization_cd_2'       =>  'integer',
         'organization_step4.*.organization_cd_3'       =>  'integer',
         'organization_step4.*.organization_cd_4'       =>  'integer',
         //5
         'organization_step5.*.organization_cd_1'       =>  'integer',
         'organization_step5.*.organization_cd_2'       =>  'integer',
         'organization_step5.*.organization_cd_3'       =>  'integer',
         'organization_step5.*.organization_cd_4'       =>  'integer',
         'organization_step5.*.organization_cd_5'       =>  'integer',
      ]);
      if ($validator->fails()) {
         return response()->view('errors.query', [], 501);
      }
      $params['company_cd']         =  session_data()->company_cd;
      $params['user_id']            =  session_data()->user_id;
      $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
      $result                       =  Dao::executeSql('SPC_oQ2010_FND1', $params);
      if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
         return response()->view('errors.query', [], 501);
      }
      //

      $data['list']                 =  $result[0] ?? [];
      $data['times']                =  $result[1][0] ?? [];
      $data['group_time']           =  $result[2] ?? [];
      $data['check']                =  $result[3][0] ?? [];
      $data['paging']               =  $result[4][0] ?? [];
      $data['group_header']         =  $result[5] ?? [];
      $data['organization_header']  =  $result[6] ?? [];
      $data['info_column']          =  $result[7] ?? [];
      if (isset($result[8][0]) && !empty($result[8][0])) {
         $temp_data = $data['list'];
         unset($data['list']);
         $data['list'] =   [];
         foreach ($temp_data as $item) {
            $value = $item;
            $emp_cd = $item['employee_cd'];
            foreach ($result[8] as $item2) {
               if ($emp_cd == $item2['employee_cd']) {
                  $value      =   array_merge($value, $item2);
               }
            }
            array_push($data['list'], $value);
         }
      }
      //
      $target = $this->YearTargetService->getYearTarget($params['company_cd'], $data_request['fiscal_year']);
      $group_hd_default = 16;
      if ((isset($target[0][0]['target1_use_typ']) && $target[0][0]['target1_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['target2_use_typ']) && $target[0][0]['target2_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['target3_use_typ']) && $target[0][0]['target3_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      if ((isset($target[0][0]['comment_use_typ']) && $target[0][0]['comment_use_typ'] == '0')) {
         $group_hd_default =  $group_hd_default - 1;
      }
      $data['group_hd_default']      = $group_hd_default ?? 16;
      $data['data_target']           = $target ?? [];
      // render view
      if ($request->ajax()) {
         return view('OneOnOne::oq2010.search', $data);
      } else {
         return $data;
      }
   }

   /**
    * Save
    * @author mail@ans-asia.com
    * @created at 2020-09-04 08:32:04
    * @return void
    */
   public function postSave(Request $request)
   {
      if ($request->ajax()) {
         $this->respon['status'] = OK;
         $this->respon['errors'] = [];
         $data_request = $request->json()->all()['data_sql'];
         $validator = Validator::make($data_request, [
            'list_check_display.*.item_cd'        =>  'integer',
            'list_check_display.*.order_no'       =>  'integer',
            'list_check_display.*.display_kbn'    =>  'integer',
         ]);
         if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
         }
         $params['company_cd']   = session_data()->company_cd;
         $params['user_id']      = session_data()->user_id;
         $params['cre_ip']       = $_SERVER['REMOTE_ADDR'];
         $params['json']         = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
         $res = Dao::executeSql('SPC_oQ2010_ACT1', $params);
         if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
         } else if (isset($res[0]) && !empty($res[0])) {
            $this->respon['status'] = NG;
            foreach ($res[0] as $temp) {
               array_push($this->respon['errors'], $temp);
            }
         }

         return response()->json($this->respon);
      }
   }
   /**
    * Show popup
    * @author mail@ans-asia.com
    * @created at 2020-09-04 08:32:04
    * @return void
    */
   public function getPopupSetup(Request $request)
   {
      $validator = Validator::make($request->all(), [
         'group_cd_1on1'     =>  'integer',
         'fiscal_year'       =>  'integer',
      ]);
      if ($validator->fails()) {
         return response()->view('errors.query', [], 501);
      }
      $params['company_cd']   =  session_data()->company_cd;
      $params['user_id']      =  session_data()->user_id;
      $params['fiscal_year']  =  $request->fiscal_year ?? 0;
      $result                 =  Dao::executeSql('SPC_oQ2010_INQ1', $params);
      if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
         return response()->view('errors.query', [], 501);
      }
      $data['title']          =  trans('messages.item_settings');
      $data['list']           =  $result[0] ?? [];
      $data['chk_all']        =  $result[1][0]['check_all'] ?? 0;
      $data['group_cd_1on1']  =  $request->group_cd_1on1 ?? -1;
      return view('OneOnOne::oq2010.popupSetup', $data);
   }
}
