<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\AdequacyService;
use Validator;

class OM0120Controller extends Controller
{
     protected $adequacyService;
     public function __construct(AdequacyService $adequacyService)
     {
          parent::__construct();
          $this->adequacyService = $adequacyService;
     }
     /**
      * Show the application index.
      * @author datnt@ans-asia.com
      * @created at 2020-09-04 08:29:02
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data = $this->getAdequacyService(1, 2);
          $data['category']        = trans('messages.1on1_master');
          $data['category_icon']   = 'fa fa-list-alt';
          $data['title']           = trans('messages.mark_master');
          return view('OneOnOne::om0120.index', $data);
     }

     /**
      * refer data from search button.
      * @author datnt@ans-asia.com
      * @created at 2020-09-04 08:29:02
      * @return \Illuminate\Http\Response
      */
     public function refer(Request $request)
     {
          $data_sql = $request->all()['data_sql'];
          $validator = Validator::make($data_sql, [
               'remark_typ'               => 'integer',
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $mark_typ                    = $data_sql['remark_typ'] ?? 1;
          $data =  $this->getAdequacyService($mark_typ);
          return view('OneOnOne::om0120.refer', $data);
     }
     /**
      * refer call services and change key
      * @author datnt@ans-asia.com
      * @created at 2020-09-04 08:29:02
      * @return \Illuminate\Http\Response
      */
     function getAdequacyService($mark_typ, $mode = 1)
     {
          $company_cd                = session_data()->company_cd;
          $data_adequacy_service            = $this->adequacyService->getAdequacy($company_cd, $mark_typ, $mode);
          if ((isset($data_adequacy_service[0][0]['error_typ']) && $data_adequacy_service[0][0]['error_typ'] == '999')) {
               return response()->view('errors.query', [], 501);
          }
          $data['data_header']     = $data_adequacy_service[0][0] ?? [];
          $data['data_table']      = $data_adequacy_service[1] ?? [];
          $data['mark_combobox']   = $data_adequacy_service[2] ?? [];
          $data['mark_type']       = $data_adequacy_service[3][0]['mark_type'] ?? [];
          $data['data_radio']      = getCombobox(21);
          return $data;
     }
     /**
      * save data.
      * @author datnt@ans-asia.com
      * @created at 2020-09-04 08:29:02
      * @return void
      */
     public function postSave(Request $request)
     {
          if ($request->ajax()) {
               $service_response = $this->adequacyService->saveAdequacy($request);
               if ($service_response['status'] == 999) {
                    return response()->view('errors.query', [], 501);
               }
               return response()->json($service_response);
          }
     }

     /**
      * remove data.
      * @author datnt@ans-asia.com
      * @created at 2020-09-04 08:29:02
      * @return void
      */
     public function postDelete(Request $request)
     {
          if ($request->ajax()) {
               $mark_typ = $request->mark_typ ?? 1;
               $validator = Validator::make(array('remark_typ' => $mark_typ), [
                    'remark_typ'               => 'integer',
               ]);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $service_response = $this->adequacyService->deleteAdequacy($mark_typ);
               if ($service_response['status'] == 999) {
                    return response()->view('errors.query', [], 501);
               }
               return response()->json($service_response);
          }
     }
}
