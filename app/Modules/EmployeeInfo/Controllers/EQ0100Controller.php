<?php

namespace App\Modules\EmployeeInfo\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\EmployeeInformation\EmployeeInfor;
use Validator;
use Dao;
use Carbon\Carbon;
use File;

class EQ0100Controller extends Controller
{
	protected $employee_infor;

	public function __construct(EmployeeInfor $employee_infor)
	{
		parent::__construct();
		$this->employee_infor = $employee_infor;
	}

	/**
	 * Show the application index.
	 * @author trinhdt
	 * @created at 2024-04-15
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.home');
		$data['category_icon'] = 'fa fa-home';
		$data['title'] = trans('messages.employee_information_search');
		$post['list'] = [];
		$post['paging'] = [];
		$data['organization_group'] = getCombobox('M0022',1) ?? [];
        $data['authority_eq0101'] = $this->getPermission();
		// $data['combo_organization'] = getCombobox('M0020', 1, 4) ?? [];
		return view('EmployeeInfo::eq0100.index', array_merge($data, $post));
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
		$validator = Validator::make($payload, [
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
		$result = $this->employee_infor->searchEmployeeInfor($json);
		if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
			 // return 501 error
			 return response()->view('errors.query', [], 501);
		}
        if (isset($result[2][0]['error_typ'])) {
            $this->respon['status'] = NG;
            foreach ($result[2] as $temp) {
                array_push($this->respon['errors'], $temp);
            }
            return response()->json($this->respon);
        }
		$data['views']  = $result[0] ?? [];
		$data['paging'] = $result[1][0] ?? [];
		$data['organization_group'] = getCombobox('M0022', 1) ?? [];
        $data['authority_eq0101'] = $this->getPermission();
		//return request ajax
		return view('EmployeeInfo::eq0100.search', $data);
	}

	/**
      * export
      *
      * @param  Request $request
      * @return void
      */
	public function export(Request $request)
    {
        try {
            $params['table_key']        =   $request->table_key;
            $json_param['screen']             =  $request->screen??'[]';
            $json_param['employee']             =  $request->employee??'[]';
            $json_param['type']             =  $request->type??0;
            $params['json']             =   json_encode($json_param)??'[]';
            $params['company_cd']       =   session_data()->company_cd;
            $params['user_id']          =  session_data()->user_id;
            $params['language']         =  session_data()->language;
            if($request->data_screen == null) {
                $params['json_filter']             =   '[]';
            } else {
            $params['json_filter']             =   json_encode($request->data_screen)??'[]';
            }
            //'

            $result = Dao::executeSql('SPC_O0100_INQ1', $params);
            //
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($params['table_key'] == 9) {
                $number_of_table = $result[0][0]['number_of_item'];
                $array_file_name = [];
                $array_real_file_name = [];
                for ($i = 1; $i <= $number_of_table; $i++) {
                    # code...
                    $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                    $csvname = 'O0100' . $date . '.csv';
                    $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                    $data_table[0] = $result[$i] ?? [];
                    array_push($array_real_file_name, $result[$i][1]['item_nm'] ?? '');
                    if ($data_table[0][1]['employee_cd'] == '') {
                        unset($data_table[0][1]);
                    }
                    $temp_file_name  = $this->saveCSV($fileName, $data_table);
                    array_push($array_file_name, $temp_file_name);
                }
                $fileNameReturn = json_encode($array_file_name);
                $real_file_name = json_encode($array_real_file_name);
            } else {
                $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                $csvname = 'O0100' . $date . '.csv';
                $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                $fileNameReturn  = $this->saveCSV($fileName, $result);
            }
            if ($fileNameReturn != '') {
                $this->respon['FileName'] = $fileNameReturn;
                $this->respon['real_file_name'] = $real_file_name ?? '';
            } else {
                $this->respon['FileName'] = '';
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    public static function getPermission()
     {
          $auth = session_data();
          $permission		= 1; // 0.not view 1. view & update
          $excepts = $auth->excepts;
          $current_screen_prefix = 'screen_employeeinfo_eq0101';

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
