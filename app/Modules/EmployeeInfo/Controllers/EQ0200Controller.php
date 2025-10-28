<?php

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\EmployeeInformation\Communication;
use App\Services\EmployeeInformation\PersonalRegistration;
use App\Helpers\Service;
use Validator;

class EQ0200Controller extends Controller
{
     protected $communication_service;
     protected $personal_registration_service;

     public function __construct(Communication $communication_service, PersonalRegistration $personal_registration_service)
     {
          parent::__construct();
          $this->communication_service = $communication_service;
          $this->personal_registration_service = $personal_registration_service;
     }

     /**
      * index
      *
      * @param  Request $request
      * @return void
      */
     public function getIndex(Request $request)
     {
          $data['title'] = trans('messages.employee_communication');
          $data['list'] = [];
          $data['paging'] = [
               "totalRecord" => "20",
               "pageMax" => "1",
               "page" => "1",
               "pagesize" => "20",
               "offset" => "1",
          ];
          $data['open_popup'] = $this->getPermission()??0;

          // init data
          $company_cd = session_data()->company_cd ?? 0;
          $communication = $this->communication_service->findCommunication($company_cd);
          $data['init_data'] = $communication[0][0] ?? [];
          $data['floors'] = $communication[1] ?? [];
          if (isset($communication[0][0]['error_typ']) && $communication[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          // organizations
          $organizations = $this->getOrganization($request);
          // seat chart
          $params['company_cd'] = $company_cd;
          $params['employee_cd'] = session_data()->employee_cd ?? '';
          $personal_registration = $this->personal_registration_service->getPersonalRegistration($params);
          $floor_id = $personal_registration[0][0]['initial_floor_id'] ?? 0;
          $request->merge(['floor_id' => $floor_id]);
          $request->merge(['search_key' => '']);
          $seats = $this->referSeat($request);
          $data['floor_id'] = $floor_id;
          // search
          $data['organization_group'] = getCombobox('M0022', 1, 61) ?? [];
          $data['combo_organization'] = getCombobox('M0020', 1, 61) ?? [];
          $m9101 = getCombobox('M9101', 1, 6) ?? [];
          $data['cert_use_typ'] = $m9101[0]['cert_use_typ'] ?? 0;
          $data['resume_use_typ'] = $m9101[0]['resume_use_typ'] ?? 0;
          $data['items'] = getCombobox('M5202', 1, 6) ?? [];
          $data['employee_cd'] = $params['employee_cd'];
          $data['btn_seat_register'] = $seats['floor']['btn_seat_register'] ?? 0;
          $data['seating_chart_typ'] = $seats['floor']['seating_chart_typ'] ?? 2;
          return view('EmployeeInfo::eq0200.index', array_merge($organizations, $data, $seats));
     }

     /**
      * getOrganization
      *
      * @param  Request $request
      * @return void
      */
     public function getOrganization(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'search_key' => 'max:100'
          ]);
          // validate Laravel
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          //  validateCommandOS
          if (!validateCommandOS($request->search_key ?? '')) {
               $this->respon['status']     = 164;
			return response()->json($this->respon);
          }
          $company_cd = session_data()->company_cd;
          $user_id = session_data()->user_id;
          $search_key = SQLEscape($request->search_key ?? '');
          $organization_charts = $this->communication_service->referOrganizationCharts($company_cd, $user_id, $search_key);
          if (isset($organization_charts[0][0]['error_typ']) && $organization_charts[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['organization_firsts'] = $organization_charts[0];
          $data['organization_seconds'] = $organization_charts[1];
          if ($request->isMethod('post')) {
               return view('EmployeeInfo::eq0200.organization', $data);
          }
          return $data;
     }

     /**
      * referSeat
      *
      * @param  Request $request
      * @return void
      */
     public function referSeat(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'floor_id' => 'integer',
               'search_key' => 'max:100'
          ]);
          // validate Laravel
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $floor_id = $request->floor_id ?? 0;
          $search_key = $request->search_key ?? '';
          $company_cd = session_data()->company_cd;
          $user_id = session_data()->user_id;
          $seat_charts = $this->communication_service->referSeatCharts($company_cd, $user_id, $floor_id, $search_key);
          if (isset($seat_charts[0][0]['error_typ']) && $seat_charts[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['floor'] = $seat_charts[0][0] ?? [];
          $data['seats'] = $seat_charts[1] ?? [];
          if (isset($data['floor']['btn_seat_register']) && $data['floor']['btn_seat_register'] == 1) {
               $employees = $this->getEmployees($request);
               $data['employees'] = $employees ?? [];
          }
          if(isset($employees ['error_typ']) && $employees['error_typ'] == '999'){
               return response()->view('errors.query',[],501);
          }
          if ($request->isMethod('post')) {
               return view('EmployeeInfo::eq0200.seat', $data);
          }
          return $data;
     }

     /**
     * get left content
     * @author trinhdt
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
     public function getEmployees(Request $request)
     {
         $validator = Validator::make($request->all(), [
               'current_page' => 'integer',
	          'search' => 'max:50',
               'mode' => 'int'
         ]);
	     // validate Laravel
	     if ($validator->fails()) {
	     	return response()->view('errors.query', [], 501);
	     }
	     //  validateCommandOS
	     if ($validator->passes()) {
               $mode = $request->mode ?? '';
               $params = [
                   'search' => SQLEscape($request->search) ?? '',
                   'current_page' => $request->current_page??1,
                   'page_size' => 20,
                   'company_cd' => session_data()->company_cd, // set for demo
               ];
               // $data = $params;
               $data['search_key'] = htmlspecialchars($request->search) ?? '';
               // $res = Dao::executeSql('SPC_M0030_LST1', $params);
               $res = $this->communication_service->referEmployee($params);
             
               $data['list'] = $res[0] ?? [];
               $data['paging'] = $res[1][0] ?? [];
               // render view
               if ($mode != '') {
                    if ((isset($res['error_typ']) && $res['error_typ'] == '999')) {
                         return response()->view('errors.query', [], 501);
                    }
                    $response['employees'] = $data;
                    return view('EmployeeInfo::eq0200.employees', $response);
               }
               return $data;
          }else{
                if ( $request->ajax() ){
	           	return response()->view('errors.query',[],501);
	           }else{
	           	return array('error_typ'=>'999');
	           }
          }                                                                                       
     }

     /**
      * add Seat
      *
      * @param  Request $request
      * @return void
      */
     public function addSeat(Request $request)
     {
          $validator = Validator::make($request->all(), [
               'floor_id' => 'integer',
               'employee_cd' => 'max:10',
               'x' => 'numeric',
               'y' => 'numeric',
          ]);
          // validate Laravel
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          $floor_id = $request->floor_id;
          $employee_cd = $request->employee_cd;
          $x = $request->x;
          $y = $request->y;
          try {
               $response['status'] = OK;
               $response['errors'] = [];
               $seat = $this->communication_service->addSeatChart($floor_id, $employee_cd, $x, $y);
               if (isset($seat[0]) && !empty($seat[0])) {
                    $response['status'] = NG;
                    foreach ($seat[0] as $temp) {
                         array_push($response['errors'], $temp);
                    }
               }
               $response['seat'] = $seat[1][0] ?? [];
          } catch (\Exception $e) {
               $response['status'] = EX;
               $response['Exception'] = $e->getMessage();
          }
          return response()->json($response);
     }

     /**
      * search
      *
      * @param  Request $request
      * @return void
      */
     function search(Request $request)
     {
          $payload = $request->json()->all() ?? [];
          // validate
          if (!validateCommandOS($request->search_key ?? '')) {
               $this->respon['status']     = 164;
			return response()->json($this->respon);
          }
          $validator = Validator::make($payload, [
               'employee_cd' => ['nullable', 'max:10'],
               'employee_nm' => ['nullable', 'max:101'],
               'belong_cd1' => ['nullable', 'max:20'],
               'belong_cd2' => ['nullable', 'max:20'],
               'belong_cd3' => ['nullable', 'max:20'],
               'belong_cd4' => ['nullable', 'max:20'],
               'belong_cd5' => ['nullable', 'max:20'],
               'cert_use_typ' => ['nullable', 'max:50'],
               'resume_use_typ' => ['nullable', 'max:50'],
               'page_size' => ['nullable', 'integer'],
               'page' => ['nullable', 'integer'],
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          // json items
          $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
          if (!validateJsonFormat($json)) {
               // return 501 error
               return response()->view('errors.query', [], 501);
          }
          $json = preventOScommand($json);
          $result = $this->communication_service->searchEmployeeInformation($json);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               // return 501 error
               return response()->view('errors.query', [], 501);
          }
          $data['views']  = $result[0] ?? [];
          $data['paging'] = $result[1][0] ?? [];
          $data['M0022'] = getCombobox('M0022', 1, 61);
          // dd($data);
          //return request ajax
          return view('EmployeeInfo::eq0200.search_result', $data);
     }

     /**
     * Delete seats
     * @author trinhdt
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function delSeat(Request $request)
    {
        if ( $request->ajax() )
        {
            try {
                $this->valid($request);
                if($this->respon['status'] == OK)
                {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    //
                    $result = $this->communication_service->deleteSeats($params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
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
     * exportExcel
     *
     * @param  Request $request
     * @return void
     */
     public function exportExcel(Request $request)
     {
          $payload = $request->json()->all() ?? [];
          $validator = Validator::make($payload, [
               'search_key' => 'max:255',
          ]);
          if ($validator->fails()) {
               return response()->json('Error', 501);
          }
          
          try {
               $search_key = $payload[0] ?? '';
               $params = array(
                    $search_key,
                    session_data()->user_id,
                    session_data()->company_cd,
               );
               // 
               $store_name = 'SPC_eQ0200_LST1';
               $typeReport = 'FNC_OUT_EXL';
               $screen = 'EQ0200';
               $file_name = 'EQ0200_' . time() . '.xlsx';
               $service = new Service();
               $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
               if (isset($result['filename'])) {
                    $result['path_file'] =  '/download/' . $result['filename'];
               }
               $name = '社員コミュニケ―ション_';
               if (session_data()->language == 'en') {
                    $name = 'EmployeeCommunication_';
               }
               $result['fileNameSave'] =   $name . time() . '.xlsx';
               $this->respon = $result;
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          // return http request
          return response()->json($this->respon);
     } 
     public static function getPermission()
     {
          $auth = session_data();
          $permission		= 1; // 0.not view 1. view & update
          $excepts = $auth->excepts;
          $current_screen_prefix = 'screen_employeeinfo_ei0200';

		//screen click event
		$current_screen_prefix_event = substr($current_screen_prefix,  0, strlen($current_screen_prefix) - strpos(strrev($current_screen_prefix), '_') - 1);

          if (property_exists($excepts, $current_screen_prefix)) {
               $button = $excepts->$current_screen_prefix;
               // authority = 0.not view 1.view 2.update
               if ($button->authority < 1) {
                    $permission		= 0;
               }
          }
          //screen click event
          if (property_exists($excepts, $current_screen_prefix_event)) {
               $button = $excepts->$current_screen_prefix_event;
               // authority = 0.not view 1.view 2.update
               if ($button->authority <1) {
                    $permission		= 0;
               }
          }

          return $permission;
     }
}
