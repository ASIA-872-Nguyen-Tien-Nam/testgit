<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\YearTargetService;
use App\Services\OneOnOneService;
use Validator;
use Dao;
use Crypt;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;

class OQ2020Controller extends Controller
{
     protected $YearTargetService;
     public function __construct(YearTargetService $YearTargetService, OneOnOneService $OneOnOneService)
     {
          parent::__construct();
          $this->YearTargetService = $YearTargetService;
          $this->one_on_one_service = $OneOnOneService;
     }
     /**
      * Show the application index.
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:32:13
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['category'] = '実施';
          $data['category_icon'] = 'fa fa-users';
          $data['title'] = trans('messages.1on1_personal_history');
          $company_cd = session_data()->company_cd ?? 0;
          $current_year = date('Y');
          $redirect_param = $request->redirect_param ?? '';
          if ($redirect_param != '') {
               try {
                    $redirect_param = json_decode(Crypt::decryptString($redirect_param));
               } catch (DecryptException $e) {
                    return response()->view('errors.403');
               }
          }
          $data_year               =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          if (isset($data_year[0][0]['error_typ']) && $data_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['current_year']    = $data_year['fiscal_year'] ?? date("Y");
          $reqs = [
               'employee_cd'  => $redirect_param->employee_cd ?? session_data()->employee_cd,
               'fiscal_year'  => $redirect_param->fiscal_year_1on1 ?? $data['current_year'],
               'from'         => $redirect_param->from ?? '',
          ];
          $validator = Validator::make($reqs, [
               'fiscal_year'       => ['integer'],
               'from'  => [
                    'string',
                    Rule::in(['oq2010', 'odashboard']),
               ],
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $data['employee_check_cd']    = $reqs['employee_cd'];
          $data['fiscal_year']          = $reqs['fiscal_year'];
          $data['w_1on1_authority_typ'] = session_data()->w_1on1_authority_typ ?? 0;
          $data['from']                 = $reqs['from'];

          $data['check'] = 0; //0:a member , 1: is not a member
          $params = [
               'company_cd'   => $company_cd,
               'employee_cd'  => $data['employee_check_cd'],
          ];
          if ($reqs['employee_cd'] != '' || $data['w_1on1_authority_typ'] == 1) {
               $res = Dao::executeSql('SPC_OQ2020_INQ1', $params);
               $data['employee_name'] = $res[0][0]['employee_nm'] ?? '';
          } else {
               $res = $this->YearTargetService->getYearTarget($params['company_cd'], $current_year);
               $data['target'] = $res[0];
               $data['check']  = 1;
          }
          if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['target_can_edited'] = 0;
          $data['coach_comment_can_edited'] = 0;
          $object = $this->one_on_one_service->getLoginUser1on1Object($company_cd,$reqs['fiscal_year'],$reqs['employee_cd'],session_data()->employee_cd,0);
          if($object == 1 || $object == 3 || $object == 5){
               $data['target_can_edited'] = 1;
          }
          if($object == 20 || $object == 21 || $object == 3 || $object == 5  || $object == 2){
               $data['coach_comment_can_edited'] = 1;
          }
          return view('OneOnOne::oq2020.index', $data);
     }
     /**
      * Search
      * @author nghianm
      * @created at 2020/12/14
      * @return \Illuminate\Http\Response
      */
     public function postSearch(Request $request)
     {
          $params = [
               'company_cd'   => session_data()->company_cd,
               'fiscal_year'  => $request->fiscal_year ?? date('Y'),
               'employee_cd'  => $request->employee_cd ?? '',
               'start_date'   => $request->start_date ?? NULL,
               'finish_date'  => $request->finish_date ?? NULL,
               'time_to'      => $request->time_to ?? 0,
               'time_from'    => $request->time_from ?? 0,
          ];
          $validator = Validator::make($params, [
               'fiscal_year'  => 'integer',
               'time_to'      => 'integer',
               'time_from'    => 'integer',
               'start_date'    => 'date',
               'finish_date'    => 'date',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $target_person = $this->YearTargetService->getYearTargetPerson($params['company_cd'], $params['fiscal_year'], $params['employee_cd']);
          if (isset($target_person[0][0]['error_typ']) && $target_person[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $params['cre_user']     =   session_data()->user_id;
          $res = Dao::executeSql('SPC_OQ2020_LST1', $params);
          if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['target'] = $target_person[0] ?? [];
          $data['list_result'] = $res[0] ?? [];
          $data['check'] = 0; //0:a member , 1: is not a member
          $data['permission']     = $res[1][0]['permission'] ?? 0;
          
          $data['target_can_edited'] = 0;
          $data['coach_comment_can_edited'] = 0;
          $object = $this->one_on_one_service->getLoginUser1on1Object(session_data()->company_cd,$params['fiscal_year'],$params['employee_cd'],session_data()->employee_cd,0);
          if($object == 1 || $object == 3 || $object == 5){
               $data['target_can_edited'] = 1;
          }
          if($object == 20 || $object == 21 || $object == 3 || $object == 5 || $object == 2){
               $data['coach_comment_can_edited'] = 1;
          }
          // render view
          return view('OneOnOne::oq2020.search', $data);
     }

     /**
      * Save
      * @author nghianm
      * @created at 2020-12-08 07:46:26
      * @return void
      */
     public function postSave(Request $request)
     {
          try {
               $this->valid($request);
               if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    $res = Dao::executeSql('SPC_OQ2020_ACT1', $params);
                    // check exception
                    if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                         return response()->view('errors.query', [], 501);
                    } else if (isset($res[0]) && !empty($res[0])) {
                         $this->respon['status'] = NG;
                         foreach ($res[0] as $temp) {
                              array_push($this->respon['errors'], $temp);
                         }
                    }
                    if (isset($res[1][0])) {
                         $this->respon['authority_cd']     = $res[1][0]['authority_cd'];
                    }
               }
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          return response()->json($this->respon);
     }
          
     /**
      * getAuthorityOfUserLogin
      *
      * @param  string $employee_cd
      * @param  string $login_employee_cd
      * @param  integer $authority_typ_1on1
      * @return integer 1.member 2.coach 3.admin 0.other
      */
     private function getAuthorityOfUserLogin($company_cd,$fiscal_year = 0,$employee_cd = '',$login_employee_cd = '')
     {
          $object = $this->one_on_one_service->getLoginUser1on1Object($company_cd,$fiscal_year, $employee_cd,$login_employee_cd,0);

     }
}
