<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\AdequacyService;
use Validator;

class RM0110Controller extends Controller
{
     protected $adequacyService;
     public function __construct(AdequacyService $adequacyService)
     {
          parent::__construct();
          $this->adequacyService = $adequacyService;
     }
     /**
      * Show the application index.
      * @author quangnd 
      * @created at 2023/02/07
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['title'] = trans('messages.mark_master');
          $refer         = $this->getAdequacyService();
          return view('WeeklyReport::rm0110.index', array_merge($data, $refer));
     }
     /**
      * refer call services and change key
      * @author quangnd 
      * @created at 2023/04/13
      * @return \Illuminate\Http\Response
      */
     function getAdequacyService($mark_kbn = 1, $mark_typ = 1, $mode = 1)
     {
          $data_adequacy_service = $this->adequacyService->getAdequacy($mark_kbn, $mark_typ, $mode);
          if ((isset($data_adequacy_service[0][0]['error_typ']) && $data_adequacy_service[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $data['data_select']     = getCombobox(31);
          $data['data_radio']      = getCombobox(32);
          $data['data_header']     = $data_adequacy_service[0][0] ?? [];
          $data['data_table']      = $data_adequacy_service[1] ?? [];
          $data['data_name']       = $data_adequacy_service[2] ?? [];
          return $data;
     }
     /**
      * refer data from search button.
      * @author quangnd 
      * @created at 2023/04/13
      * @return \Illuminate\Http\Response
      */
     public function refer(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'mark_kbn'             => 'integer',
               'mark_typ'             => 'integer',
               'mode'                 => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $mark_kbn          = $request->mark_kbn ?? 1;
          $mark_typ          = $request->mark_typ ?? 1;
          $mode              = $request->mode ?? 1;
          if($mode == 1){
               $mark_typ = 1;
          }
          $data =  $this->getAdequacyService($mark_kbn, $mark_typ, $mode);
          return view('WeeklyReport::rm0110.refer', $data);
     }
     /**
      * Save data
      * @author quangnd
      * @created at 2023/04/07
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
                         $result = $this->adequacyService->saveAdequacy($params);
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
     /**
      * remove data.
      * @author quangnd
      * @created at 2023/04/07
      * @return \Illuminate\Http\Response
      */
     public function postDelete(Request $request)
     {
          if ($request->ajax()) {
               try {
                    $validator = Validator::make($request->all(), [
                         'mark_kbn'             => 'integer',
                    ]);
                    if ($validator->fails()) {
                         return response()->view('errors.query', [], 501);
                    }
                    $mark_kbn          = $request->mark_kbn ?? 0;
                    $result = $this->adequacyService->deleteAdequacy($mark_kbn);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                         return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                         $this->respon['status'] = NG;
                         foreach ($result[0] as $temp) {
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
}
