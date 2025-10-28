<?php

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\EmployeeInformation\SettingView;

class EM0100Controller extends Controller
{
     protected $setting_view_service;

     public function __construct(SettingView $setting_view_service)
     {
          parent::__construct();
          $this->setting_view_service = $setting_view_service;
     }

     /**
      * Show the application index.
      * @author manhnd 
      * @created at 2024/03/28
      * @return View
      */
     public function index(Request $request)
     {
          $params['company_cd'] = session_data()->company_cd;
          $params['language'] = session_data()->language;
          $result = $this->setting_view_service->getTabsAndAuthorities($params);
          $data['title'] = trans('messages.function_nm5');
          $data['tabs'] = $result[0] ?? [];
          $data['authorities'] = $result[1] ?? [];
          return view('EmployeeInfo::em0100.index', $data);
     }

     /**
      * Save data
      * @author manhnd 
      * @created at 2024/03/28
      * @return \Illuminate\Http\Response
      */
     public function postSave(Request $request)
     {
          if ($request->ajax()) {
               try {
                    $this->valid($request);
                    if ($this->respon['status'] == OK) {
                         $params['json']         =   $this->respon['data_sql'];
                         $params['cre_user']     =   session_data()->user_id;
                         $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                         $params['company_cd']   =   session_data()->company_cd;
                         // call service
                         $result = $this->setting_view_service->saveTabAuthority($params);
                         // check exception
                         if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                              return response()->view('errors.query', [], 501);
                         } else if (isset($result[0]) && !empty($result[0])) {
                              $this->respon['status'] = NG;
                              foreach ($result[0] as $temp) {
                                   array_push($this->respon['errors'], $temp);
                              }
                         }
                    }
               } catch (\Exception $e) {
                    $this->respon['status']     = EX;
                    $this->respon['Exception']  = $e->getMessage();
               }
               return response()->json($this->respon);
          }
     }
}
