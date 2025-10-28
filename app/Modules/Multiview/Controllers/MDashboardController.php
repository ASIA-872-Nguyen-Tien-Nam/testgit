<?php

/**
 ****************************************************************************
 * MIRAIC 
 * MDashboardController
 *
 * 処理概要/process overview   : MDashboardController
 * 作成日/create date   : 2020-09-04 03:53:04
 * 作成者/creater    : mail@gmail.com
 *
 * 更新日/update date    :
 * 更新者/updater    :
 * 更新内容 /update content  : 
 *
 *
 * @package         :  Dashboard
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Multiview\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\ScheduleService;
use App\Services\OneOnOneService;
use Validator;
use Dao;
use Crypt;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;

class MDashboardController extends Controller
{
     protected $scheduleService;
     public function __construct(ScheduleService $scheduleService, OneOnOneService $OneOnOneService)
     {
          parent::__construct();
          $this->scheduleService   = $scheduleService;
          $this->one_on_one_service = $OneOnOneService;
     }
     /**
      * Show the application index.
      * @author mail@gmail.com
      * @created at 2020-09-04 03:53:04
      * @return \Illuminate\Http\Response
      */
     public function getManager(Request $request)
     {
          $data['category'] = trans('messages.home');
          $data['category_icon'] = 'fa fa-home';
          $data['title'] = trans('messages.dashboard_rater_admin');
          $company_cd    = session_data()->company_cd;
          $current_fiscal_year     = $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $current_fiscal_year = $current_fiscal_year['fiscal_year'] ?? date("Y");
          $data['years'] = $this->getFiscalYear($current_fiscal_year);
          // 
          $data['fiscal_year']     = $current_fiscal_year;
          $request['fiscal_year']  = $data['fiscal_year'];
          $request['screen_flg']             = 0; // ダッシュボード（評価者・管理者用）
          $left     = $this->postSearch($request);
          return view('Multiview::mdashboard.manager.index', array_merge($data, $left));
     }
     /**
      * Show the application index.
      * @author mail@gmail.com
      * @created at 2020-09-04 03:53:04
      * @return \Illuminate\Http\Response
      */
     public function getSupporter(Request $request)
     {
          $data['category'] = trans('messages.home');
          $data['category_icon'] = 'fa fa-home';
          $data['title'] = trans('messages.dashboard_(supporter)');
          //
          $redirect_param = $request->redirect_param ?? '';
          if ($redirect_param != '') {
               try {
                    $redirect_param = json_decode(Crypt::decryptString($redirect_param));
               } catch (DecryptException $e) {
                    return response()->view('errors.403');
               }
          }
          $reqs = [
               'fiscal_year'          => $redirect_param->fiscal_year ?? 0,
               'from'                 => $redirect_param->from ?? '',
          ];
          $validator = Validator::make($reqs, [
               'fiscal_year'          => ['integer'],
               'from'  => [
                    'string',
                    Rule::in(['mdashboard']),
               ],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $company_cd    = session_data()->company_cd;
          $current_fiscal_year      =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          if ($reqs['fiscal_year'] != 0) {
               // $data['fiscal_year'] = $reqs['fiscal_year'];
               $current_fiscal_year = $reqs['fiscal_year'];
          } else {
               $current_fiscal_year = $current_fiscal_year['fiscal_year'] ?? date("Y");
          }
          $data['fiscal_year'] = $current_fiscal_year;
          $data['years'] = $this->getFiscalYear($current_fiscal_year);
          $request['fiscal_year']  = $current_fiscal_year;
          $request['screen_flg']   = 1; //mode supporter　ダッシュボード（サポーター用）
          $data['user_is_rater_1'] = session_data()->user_is_rater_1 ?? 0;
          $data['multireview_authority_typ'] = session_data()->multireview_authority_typ ?? 0;
          $left     = $this->postSearch($request);
          return view('Multiview::mdashboard.supporter.index', array_merge($data, $left));
     }
     /**
      * Search
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postSearch(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'fiscal_year'  => 'integer'
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $fiscal_year                  =  $request->fiscal_year ?? 0;
          $params['company_cd']         =  session_data()->company_cd;
          $params['fiscal_year']        =  $fiscal_year;
          $params['supporter_cd']       =  session_data()->employee_cd;
          $params['cre_user']           =  session_data()->user_id;
          $params['screen_flg']         =  $request->screen_flg;
          $result                       =  Dao::executeSql('SPC_mDashboard_FND1', $params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $current_fiscal_year      =  $this->one_on_one_service->getCurrentFiscalYear(session_data()->company_cd);
          if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['list1']                =  $result[0] ?? [];
          $confirm_flg                  =  $result[1][0]['confirm_flg'] ?? 2; //0: on unlock-btn, 1 on btn-unconfirm , 2 not view btn
          $data['list2']                =  $result[2] ?? [];
          $data['fiscal_year']          =  $fiscal_year;
          $data['years']                =  $this->getFiscalYear($current_fiscal_year['fiscal_year']);
          //
          $user = session(AUTHORITY_KEY);
          $multireview_authority_typ = (int)$user->multireview_authority_typ ?? 0;
          //New manager can be used
          //0: on unlock-btn, 1 on btn-unconfirm , 2 not view btn
          // add by viettd 2021/05/17 : when multireview_authority_typ  >= 5 then use this function
          if ($confirm_flg == 0 && $multireview_authority_typ >= 4) {
               $data['confirm_button_is_show'] = 0;
          } elseif ($confirm_flg == 1 && $multireview_authority_typ >= 4) {
               $data['confirm_button_is_show'] = 1;
          } else {
               $data['confirm_button_is_show'] = 2;
          }
          // render view
          if ($request->ajax()) {
               if ($request->screen_flg == 0) {
                    return view('Multiview::mdashboard.manager.search', $data);
               }
               if ($request->screen_flg == 1) {
                    return view('Multiview::mdashboard.supporter.search', $data);
               }
          } else {
               return $data;
          }
     }
     /**
      * Save
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:31:50
      * @return void
      */
     public function postSave(Request $request)
     {
          if ($request->ajax()) {
               $this->respon['status'] = OK;
               $this->respon['errors'] = [];
               $data_request = $request->json()->all()['data_sql'];
               $validator = Validator::make($data_request, [
                    'fiscal_year'                 =>   'integer',
                    'confirm_flg'                 =>   'integer',
               ]);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $params['company_cd']       = session_data()->company_cd;
               $params['fiscal_year']      = $data_request['fiscal_year'];
               $params['confirm_flg']      = $data_request['confirm_flg'];;
               $params['cre_user']         = session_data()->user_id;
               $params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
               $res = Dao::executeSql('SPC_mDashboard_ACT1', $params);
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
      * get all years of current year
      *
      * @param  mixed $current_fiscal_year
      * @return void
      */
     public function getFiscalYear($current_fiscal_year = 0)
     {
          if ($current_fiscal_year == 0) {
               return [];
          }
          // 
          $result[] = $current_fiscal_year - 3;
          $result[] = $current_fiscal_year - 2;
          $result[] = $current_fiscal_year - 1;
          $result[] = $current_fiscal_year;
          $result[] = $current_fiscal_year + 1;
          $result[] = $current_fiscal_year + 2;
          $result[] = $current_fiscal_year + 3;
          return $result;
     }
}
