<?php

/**
 ****************************************************************************
 * MIRAI
 * EM0200Controller
 *
 * 処理概要/process overview   : EM0200Controller
 * 作成日/create date          : 2024/03/04
 * 作成者/creater              : manhnd
 * 
 * 更新日/update date          : 
 * 更新者/updater              : 
 * 更新内容 /update content    : 
 * 
 * 
 * @package         :  EmployeeInfo
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\UploadCore;
use App\Services\EmployeeInformation\Communication;

class EM0200Controller extends Controller
{
    protected $communication_service;

    public function __construct(Communication $communication_service)
    {
        parent::__construct();
        $this->communication_service = $communication_service;
    }

    /**
     * Show the application index.
     * @author manhnd 
     * @created at 2024/03/04
     * @return View
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['L0010_9'] = getCombobox(9);
        $data['L0010_77'] = getCombobox(77);
        $data['title'] = trans('messages.function_nm6');
        $data['employee_cd'] = session_data()->employee_cd ?? '';
        //
        $communication = $this->communication_service->findCommunication(session_data()->company_cd);
        $data['head'] = $communication[0][0] ?? [];
        $data['details'] = $communication[1] ?? [];
        return view('EmployeeInfo::em0200.index', $data);
    }

    /**
     * Save data
     * @author namnb 
     * @created at 2024/03/26
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json = $request->head;
                $data_sql = json_decode($json, true)['data_sql'];
                $employee_cd = session_data()->user_id;
                $company_cd  = session_data()->company_cd;
                // upload files
                if ($request->hasFile('files')) {
                    $files_index = $request->files_index;
                    $files = $request->file('files');
                   
                    foreach ($files as $index => $file) {
                        $random_suffix = mt_rand(100000, 999999);
                        $file_name = 'seating_chart_layout_' . $employee_cd . '_' . $random_suffix;
                        $sub_request = new Request();
                        $sub_request['rules'] = 'mimes:pdf';
                        $sub_request['folder'] = "em0200/$company_cd";
                        $sub_request['file_' . $index] = $file;
                        $sub_request['rename_upload'] = $file_name;
                        UploadCore::pdfToImg($sub_request);
                        // 
                        // $file_arr['row_index'] = $files_index[$index];
                        // $file_arr['file_name'] = $file_name . '.pdf';
                        // $data_sql['json_filename'][] = $file_arr; 

                        $row_index = (int) $files_index[$index] - 1;
                        $data_sql['tr'][$row_index]["floor_map"] = $file_name . '.pdf';
                        $data_sql['tr'][$row_index]["floor_map_name"] = $file->getClientOriginalName();
                    }
                }

                if ($this->respon['status'] == OK) {
                    $params['json']              =   json_encode($data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                    $params['cre_user']          =   session_data()->user_id;
                    $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']        =   session_data()->company_cd;
                
                    // call service
                    $result = $this->communication_service->saveCommunication($params);
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
