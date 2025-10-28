<?php

/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 07:46:26
 * 作成者/creater              : viettd
 *
 * 更新日/update date          :
 * 更新者/updater              :
 * 更新内容 /update content    :
 *
 *
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Master\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\Service;
use App\Services\ItemService;
use Validator;
use Dao;
use Illuminate\Validation\Rule;

class Q2010Controller extends Controller
{
    protected $itemService;

    public function __construct(ItemService $itemService)
    {
        parent::__construct();
        $this->itemService = $itemService;
    }
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-21 07:46:26
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.personnel_assessment');
        $data['category_icon'] = 'fa fa-line-chart';
        $data['title'] = trans('messages.evaluation_sheet_list');
        $reqs = [
            'from'  => $request->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020', 'i2040', 'q0071']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['M0020']          = getCombobox('M0020', 1);
        $data['F0010']          = getCombobox('F0010', 1);
        $data['M0060']          = getCombobox('M0060', 1);
        $data['M0040']          = getCombobox('M0040', 1);
        $data['M0050']          = getCombobox('M0050', 1);
        $data['M0022']          = getCombobox('M0022', 1);
        $data['libraryno7']     = getCombobox(7);
        $data['views']          = [];
        //
        $user_id                = session_data()->user_id;
        $authority_typ          = session_data()->authority_typ;
        $html                   = '';
        if ($reqs['from'] == 'i2010') {
            $cache              = getCache('q2010_i2010', $user_id);
        } else if ($reqs['from'] == 'i2020') {
            $cache              = getCache('q2010_i2020', $user_id);
        } else if ($reqs['from'] == 'q0071') {
            $cache              = getCache('q2010_q0071', $user_id);
        } else if ($reqs['from'] == 'i2040') {
            $cache              = getCache('q2010_i2040', $user_id);
        }
        if (isset($cache['html'])){
            $html               = htmlspecialchars_decode($cache['html'], ENT_QUOTES) ??  '';
        }
        // 
        $data['html']           =  $html;
        $data['authority_typ']  =  $authority_typ;
        $data['employee_cd']    =   '';
        $data['employee_nm']    =   '';
        if (isset(session_data()->m0070->employee_cd)) {
            $data['employee_cd']    = session_data()->m0070->employee_cd;
        }
        if (isset(session_data()->m0070->employee_nm)) {
            $data['employee_nm']    = session_data()->m0070->employee_nm;
        }
        //
        $data['sheet_khn']                          = 0;
        $data['target_self_assessment_typ']         = 0;
        $data['target_evaluation_typ_1']            = 0;
        $data['target_evaluation_typ_2']            = 0;
        $data['target_evaluation_typ_3']            = 0;
        $data['target_evaluation_typ_4']            = 0;
        $data['evaluation_self_assessment_typ']     = 0;
        $data['evaluation_typ_1']                   = 0;
        $data['evaluation_typ_2']                   = 0;
        $data['evaluation_typ_3']                   = 0;
        $data['evaluation_typ_4']                   = 0;
        // get items data
        $data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id ?? 0);
        return view('Master::q2010.index', $data);
    }

    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postSearch(Request $request)
    {
        $payload = $request->json()->all() ?? [];
        // validate
        $validator = Validator::make($payload, [
            'fiscal_year'       =>  'integer',
            'evaluation_typ'    =>  'integer',
            'status_cd'         =>  'integer',
            'category_typ'      =>  'integer',
            'sheet_cd'          =>  'integer',
            'employee_cd'       =>  'string',
            'employee_typ'      =>  'integer',
            'position_cd'       =>  'integer',
            'grade'             =>  'integer',
        ]);
        //
        if ($validator->fails()) {
            return response()->json('Error', 501);
        } else {
            if (count($payload) == 0) {
                $payload['fiscal_year']                      = date('Y');
                $payload['evaluation_typ']                   = 0;
                $payload['status_cd']                        = -1;
                $payload['category_typ']                     = -1;
                $payload['sheet_cd']                         = -1;
                $payload['employee_cd']                      = '';
                $payload['employee_typ']                     = -1;
                $payload['position_cd']                      = -1;
                $payload['grade']                            = -1;
                $payload['list_treatment_applications_no']   = [];
                $payload['treatment_applications_no']        = [];
                $payload['list_organization_step1']          = [];
                $payload['list_organization_step2']          = [];
                $payload['list_organization_step3']          = [];
                $payload['list_organization_step4']          = [];
                $payload['list_organization_step5']          = [];
                $payload['page_size']                        = 20;
                $payload['page']                             = 1;
            }
            $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            if (!validateJsonFormat($json)) {
                // return 501 error
                return response()->view('errors.query', [], 501);
            } else {
                $params['language']     =   session_data()->language;
                $params['json']         =   preventOScommand($json);
                $params['employee_cd']  =   session_data()->employee_cd;
                $params['cre_user']     =   session_data()->user_id;
                $params['company_cd']   =   session_data()->company_cd;
                $params['mode']         =   0; // mode search
                $result = Dao::executeSql('SPC_Q2010_FND1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    // return 501 error
                    return response()->view('errors.query', [], 501);
                } else {
                    $data['views']  = $result[0] ?? [];
                    $data['paging'] = $result[1][0] ?? [];
                    //$data['router'] = $result[2][0] ?? [];
                    $data['sheet_khn']                          = $result[2][0]['sheet_khn'] ?? 0;
                    $data['target_self_assessment_typ']         = $result[2][0]['target_self_assessment_typ'] ?? 0;
                    $data['target_evaluation_typ_1']            = $result[2][0]['target_evaluation_typ_1'] ?? 0;
                    $data['target_evaluation_typ_2']            = $result[2][0]['target_evaluation_typ_2'] ?? 0;
                    $data['target_evaluation_typ_3']            = $result[2][0]['target_evaluation_typ_3'] ?? 0;
                    $data['target_evaluation_typ_4']            = $result[2][0]['target_evaluation_typ_4'] ?? 0;
                    $data['evaluation_self_assessment_typ']     = $result[2][0]['evaluation_self_assessment_typ'] ?? 0;
                    $data['evaluation_typ_1']                   = $result[2][0]['evaluation_typ_1'] ?? 0;
                    $data['evaluation_typ_2']                   = $result[2][0]['evaluation_typ_2'] ?? 0;
                    $data['evaluation_typ_3']                   = $result[2][0]['evaluation_typ_3'] ?? 0;
                    $data['evaluation_typ_4']                   = $result[2][0]['evaluation_typ_4'] ?? 0;
                    $data['M0022']                              = getCombobox('M0022', 1);
                    //return request ajax
                    return view('Master::q2010.search', $data);
                }
            }
        }
    }
    /**
     * copy
     * @author viettd
     * @created at 2018-09-17
     * @return void
     */
    public function postCopy(Request $request)
    {
        if ($request->ajax()) {
            //return request ajax
            $validator = Validator::make($request->all(), [
                'fiscal_year' => 'integer|required|min:1900'
            ]);
            //
            if ($validator->fails()) {
                // $this->respon['status'] = NG;
                // return response()->json($this->respon);
                return response()->view('errors.query', [], 501);
            } else {
                try {
                    if ($this->respon['status'] == OK) {
                        $json = json_encode($request->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                        if (validateJsonFormat($json)) {
                            $params['json']                 =   preventOScommand($json);
                            $params['cre_user']             =   session_data()->user_id;
                            $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                            $params['employee_cd']          =   session_data()->employee_cd;
                            $params['company_cd']           =   session_data()->company_cd;
                            //
                            $result = Dao::executeSql('SPC_Q2010_ACT1', $params);
                            // check exception
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                // $this->respon['status']     = EX;
                                // $this->respon['Exception']  = $result[0][0]['remark'];
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $this->respon['status'] = NG;
                                $this->respon['errors'] = $result[0];
                            } else {
                                $this->respon['status'] = OK;
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
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postListExcel(Request $request)
    {
        if ($request->ajax()) {
            $param_json = $request->json()->all() ?? [];
            if (count($param_json) == 0) {
                $param_json['fiscal_year']                      = date('Y');
                $param_json['evaluation_typ']                   = 0;
                $param_json['status_cd']                        = -1;
                $param_json['category_typ']                     = -1;
                $param_json['sheet_cd']                         = -1;
                $param_json['employee_cd']                      = '';
                $param_json['employee_typ']                     = -1;
                $param_json['position_cd']                      = -1;
                $param_json['grade']                            = -1;
                $param_json['list_treatment_applications_no']   = [];
                $param_json['treatment_applications_no']        = [];
                $param_json['treatment_applications_no']        = [];
                $param_json['list_department_cd']               = [];
                $param_json['list_team_cd']                     = [];
                $param_json['page_size']                        = 20;
                $param_json['page']                             = 1;
            }
            $param_json['employee_cd'] = SQLEscape(preventOScommand($param_json['employee_cd']));
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //

            if (!validateJsonFormat($json)) {
                // $this->respon['status']     = NG;
                // return response()->json($this->respon);
                return response()->view('errors.query', [], 501);
            } else {
                try {
                    $params = array(
                        preventOScommand($json),   session_data()->employee_cd,   session_data()->user_id,   session_data()->company_cd,   1           // mode print
                    );
                    //
                    $store_name = 'SPC_Q2010_FND1';
                    $typeReport = 'FNC_OUT_EXL';
                    $screen = 'Q2010_LIST';
                    $file_name = 'Q2010_LIST_' . time() . '.xlsx';
                    $service = new Service();
                    $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
                    if (isset($result['filename'])) {
                        $result['path_file'] =  '/download/' . $result['filename'];
                    }
                    $name = '評価シート一覧_';
                    if (session_data()->language == 'en') {
                        $name = 'EvaluationSheetList_';
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
        }
    }
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postExcel(Request $request)
    {
        if ($request->ajax()) {
            $param_json = $request->json()->all() ?? [];
            if (count($param_json) == 0) {
                $param_json['fiscal_year'] = date('Y');
                $param_json['list'] = [];
            }
            //
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if (!validateJsonFormat($json)) {
                // $this->respon['status']     = NG;
                // return response()->json($this->respon);
                return response()->view('errors.query', [], 501);
            } else {
                try {
                    $params = array(
                        preventOScommand($json),   session_data()->employee_cd,   session_data()->user_id,   session_data()->company_cd
                    );
                    //
                    $store_name = 'SPC_Q2010_RPT1';
                    $typeReport = 'FNC_OUT_EXL';
                    $screen = 'Q2010';
                    $file_name = 'Q2010_' . time() . '.xlsx';
                    $service = new Service();
                    $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
                    if (isset($result['filename'])) {
                        $result['path_file'] =  '/download/' . $result['filename'];
                    }
                    $name = '評価表出力_';
                    if (session_data()->language == 'en') {
                        $name = 'EvaluationTableOutput_';
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
        }
    }
    /**
     * get excel file from button 目標一覧表出力
     * @author namnb
     * @created at 2020-10-12
     * @return void
     */
    public function postExcel3(Request $request)
    {
        if ($request->ajax()) {
            $param_json = $request->json()->all() ?? [];
            if (count($param_json) == 0) {
                $param_json['fiscal_year'] = date('Y');
                $param_json['list'] = [];
            }
            //
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if (!validateJsonFormat($json)) {
                // $this->respon['status']     = NG;
                // return response()->json($this->respon);
                return response()->view('errors.query', [], 501);
            } else {
                try {
                    $params = array(
                        preventOScommand($json),   session_data()->employee_cd,   session_data()->user_id,   session_data()->company_cd
                    );
                    //
                    $store_name = 'SPC_Q2010_RPT2';
                    $typeReport = 'FNC_OUT_EXL';
                    $screen = 'Q2010_EVAL';
                    $file_name = 'Q2010_' . time() . '.xlsx';
                    $service = new Service();
                    $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
                    if (isset($result['filename'])) {
                        $result['path_file'] =  '/download/' . $result['filename'];
                    }
                    $name = '目標一覧表出力_';
                    if (session_data()->language == 'en') {
                        $name = 'OutputTargetList_';
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
        }
    }
}
