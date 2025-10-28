<?php

namespace App\Modules\Common\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Dao;
use Illuminate\Support\Facades\Mail;
use App\Mail\EvaluationNotification;
use App\Services\WeeklyReport\WeeklyReportService;
use Illuminate\Support\Arr;
use SebastianBergmann\CodeCoverage\Report\Xml\Report;
use App\Services\GoogleService;

class ReferController extends Controller
{
    protected $weeklyReportService;
    public function __construct(WeeklyReportService $weeklyReportService)
    {
        parent::__construct();
        $this->weeklyReportService     = $weeklyReportService;
    }
    /**
     * loadOrganization
     *
     * @author      :   longvv - 2018/08/24 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function loadOrganization(Request $request)
    {
        if ($request->ajax()) {
            $reqs = $request->json()->all() ?? [];
            $validator = Validator::make($reqs, [
                'organization_typ' => 'integer',
                'system' => 'integer',
            ]);
            // 
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $json = json_encode($reqs, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            if (!validateCommandOS($json)) {
                return abort(501);
            }
            if (!validateJsonFormat($json)) {
                return abort(501);
            } else {
                $params['json']             =   preventOScommand($json);
                $params['user_id']          =   session_data()->user_id;
                $params['company_cd']       =   session_data()->company_cd;
                $params['system']           =   $reqs['system'] ?? 1;
                //
                $result             = Dao::executeSql('SPC_REFER_ORGANIZATION_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * CustomerloadOrganization
     *
     * @author      :   longvv - 2018/08/24 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function CustomerloadOrganization(Request $request)
    {
        if ($request->ajax()) {
            $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if (!validateJsonFormat($json)) {
                return abort(501);
            } else {
                $params['json']             =   preventOScommand($json);
                $params['user_id']          =   session_data()->user_id;
                $params['company_cd']       =   session_data()->company_cd;
                //
                $result             = Dao::executeSql('SPC_REFER_ORGANIZATION_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                return response()->json($data);
            }
        }
    }
    /**
     * loadStatus
     *
     * @author      :   viettd - 2019/09/26 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function loadStatus(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'evaluation_typ' => 'integer'
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $evaluation_typ                 =   preventOScommand($request->evaluation_typ);
                $params['evaluation_typ']       =   (int)$evaluation_typ ?? 0;
                $params['company_cd']           =   session_data()->company_cd;
                $params['language']             =   session_data()->language;
                //
                $result             = Dao::executeSql('SPC_REFER_STATUS_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * loadSheetcd
     *
     * @author      :   viettd - 2019/09/26 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function loadSheetcd(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'fiscal_year' => 'integer|min:1900',
                'category_typ' => 'integer',
                'evaluation_typ' => 'integer',
            ]);
            //
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $fiscal_year = (int)preventOScommand($request->fiscal_year);
                $category_typ = preventOScommand($request->category_typ);
                $evaluation_typ = preventOScommand($request->evaluation_typ);
                //
                $params['fiscal_year']          =   $fiscal_year;
                $params['category_typ']         =   (int)$category_typ;
                $params['evaluation_typ']       =   (int)$evaluation_typ;
                $params['company_cd']           =   session_data()->company_cd;
                //
                $result             = Dao::executeSql('SPC_REFER_SHEET_CD_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * loadTreatmentApplicationsNo
     *
     * @author      :   viettd - 2018/08/24 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function loadTreatmentApplicationsNo(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'fiscal_year' => 'integer|min:1900'
            ]);
            //
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $fiscal_year    = (int)$request->fiscal_year;
                $from_screen_id = $request->from_screen_id ?? '';
                //
                $params['fiscal_year']         =   $fiscal_year;
                $params['company_cd']          =   session_data()->company_cd;
                $params['from_screen_id']      =   $from_screen_id;
                //
                $result             = Dao::executeSql('SPC_REFER_TREATMENT_APPLICATION_NO_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * [employeeautocomplete]
     * @author longvv
     * @created at 2018-08-21 07:46:26
     * @param  [type] $path_file [description]
     * @param  [type] $options   [description]
     * @return [type]            [description]
     */
    public function employeeautocomplete(Request $request)
    {
        $params         = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer'
        ]);
        // validate
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        }
        //add vietdt 2022/04/08
        $fiscal_year = $params['fiscal_year'] ??  date('Y');
        if ($fiscal_year <= 0) {
            $fiscal_year = date('Y');
        }
        try {
            $params = [
                'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                'company_cd'        => session_data()->company_cd,
                'user_id'           => session_data()->user_id,
                'fiscal_year'       => $fiscal_year,
                'system'            => 1,
            ];
            $data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($data[0]) {
                foreach ($data[0] as $i => $result) {
                    $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                    $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                    $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                    $i++;
                }
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($response) ? $response : '');
    }

    /**
     * employeeautocomplete1on1
     *
     * @param  object $request
     * @return json
     */
    public function employeeautocomplete1on1(Request $request)
    {
        $params         = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer|min:1900'
        ]);
        // validate
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $params = [
                'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                'company_cd'        => session_data()->company_cd,
                'user_id'           => session_data()->user_id,
                'fiscal_year'       => $params['fiscal_year'] ?? 0,
                'system'            => 2,
            ];
            $data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($data[0]) {
                foreach ($data[0] as $i => $result) {
                    $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                    $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                    $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                    $i++;
                }
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($response) ? $response : '');
    }
    /**
     * employeeautocompletemulitireview
     *
     * @param  object $request
     * @return json
     */
    public function employeeautocompletemulitireview(Request $request)
    {
        $params         = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer|min:1900'
        ]);
        // validate
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $params = [
                'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                'company_cd'        => session_data()->company_cd,
                'user_id'           => session_data()->user_id,
                'fiscal_year'       => $params['fiscal_year'] ?? 0,
                'system'            => 3,
            ];
            $data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($data[0]) {
                foreach ($data[0] as $i => $result) {
                    $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                    $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                    $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                    $i++;
                }
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($response) ? $response : '');
    }
    /**
     * employeeautocompletemulitiselect
     *
     * @param  object $request
     * @return json
     */
    public function employeeautocompletemulitiselect(Request $request)
    {
        $params         = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer|min:1900',
            'mulitiselect_mode' => 'integer',
        ]);
        // validate
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $params = [
                'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                'company_cd'        => session_data()->company_cd,
                'user_id'           => session_data()->user_id,
                'fiscal_year'       => $params['fiscal_year'] ?? 0,
                'mulitiselect_mode' => $params['mulitiselect_mode'] ?? 1,
            ];
            $data = Dao::executeSql('SPC_REFER_MULITISELECT_EMPLOYEE_INQ1', $params);
            // 
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($data[0]) {
                foreach ($data[0] as $i => $result) {
                    $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                    $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                    $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                    $i++;
                }
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($response) ? $response : '');
    }

    /**
     * employeeautocompleteWeeklyReport
     *
     * @param  object $request
     * @return json
     */
    public function employeeautocompleteWeeklyReport(Request $request)
    {
        $params         = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => 'integer|min:1900'
        ]);
        // validate
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $params = [
                'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                'company_cd'        => session_data()->company_cd,
                'user_id'           => session_data()->user_id,
                'fiscal_year'       => $params['fiscal_year'] ?? 0,
                'system'            => 5,
            ];
            $data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($data[0]) {
                foreach ($data[0] as $i => $result) {
                    $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                    $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                    $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                    $i++;
                }
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($response) ? $response : '');
    }

    /**
     * [referEmployee]
     * @author longvv
     * @created at 2018-08-21 07:46:26
     * @param  [type] $path_file [description]
     * @param  [type] $options   [description]
     * @return [type]            [description]
     */
    public function referEmployee(Request $request)
    {
        if ($request->ajax()) {
            if (!validateCommandOS($request->employee_cd)) {
                return response()->view('errors.query', [], 406);
            } else {
                try {
                    if ($this->respon['status'] == OK) {
                        $params['company_cd']   = session_data()->company_cd;
                        $params['employee_cd']  = SQLEscape(preventOScommand($request->employee_cd));
                        // //
                        $result = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ2', $params);
                        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                            return response()->view('errors.query', [], 501);
                        }
                        if (isset($result[0][0])) {
                            $data       = $result[0][0];
                        } else {
                            $data       = [];
                        }
                        $this->respon['data'] = $data;
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
     * [employeecustomerautocomplete]
     * @author longvv
     * @created at 2018-08-21 07:46:26
     * @param  [type] $path_file [description]
     * @param  [type] $options   [description]
     * @return [type]            [description]
     */
    public function employeecustomerautocomplete(Request $request)
    {
        $params         = $request->all();
        if (!validateCommandOSArray($params)) {
            return response()->view('errors.query', [], 501);
        } else {
            try {
                $params = [
                    'search_key'        => SQLEscape(preventOScommand($request->key)) ?? '',
                    'company_cd'        => 1,
                    'user_id'           => session_data()->user_id,
                    'fiscal_year'       => date('Y'),
                ];
                $data = Dao::executeSql('SPC_REFER_EMPLOYEE_INQ1', $params);
                if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                if ($data[0]) {
                    foreach ($data[0] as $i => $result) {
                        $response[$i]['label']          = mb_convert_encoding($result['label'], "UTF-8", "auto");
                        $response[$i]['value']          = mb_convert_encoding($result['value'], "UTF-8", "auto");
                        $response[$i]['id']             = mb_convert_encoding($result['id'], "UTF-8", "auto");
                        $i++;
                    }
                }
            } catch (Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json(isset($response) ? $response : '');
        }
    }
    /**
     * loadGroupFromFiscalYear1on1
     *
     * @param  mixed $request
     * @return void
     */
    public function loadGroupFromFiscalYear1on1(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'fiscal_year' => 'integer|min:1900'
            ]);
            //
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $fiscal_year    = (int)$request->fiscal_year;
                //
                $params['fiscal_year']         =   $fiscal_year;
                $params['employee_cd']         =   session_data()->employee_cd;
                $params['company_cd']          =   session_data()->company_cd;
                //
                $result = Dao::executeSql('SPC_REFER_GROUP_FROM_YEAR_1ON1_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * Load Times from group_cd in 1on1
     *
     * @author      :   nghianm - 2020/11/30 - create
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function loadTimesFromGroup1on1(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'fiscal_year'     => 'integer|min:1900',
                'group_cd'         => 'integer',
            ]);
            //
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $fiscal_year    = (int)$request->fiscal_year;
                $group_cd        = (int)$request->group_cd;
                //
                $params['company_cd']          =   session_data()->company_cd;
                $params['fiscal_year']         =   $fiscal_year;
                $params['group_cd']             =   $group_cd;
                //
                $result  = Dao::executeSql('SPC_REFER_TIMES_FROM_GROUP_1ON1_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $data['rows']       = $result[0] ?? [];
                //
                return response()->json($data);
            }
        }
    }
    /**
     * sendMailPopup
     *
     * @param  Request $request
     * @return void
     */
    public function sendMailPopup(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status']     = OK;
            if (!validateCommandOS($request->employee_cd)) {
                return response()->view('errors.query', [], 501);
            }
            // 
            try {
                date_default_timezone_set('Asia/Tokyo');
                $current =  date("Y-m-d H:i:s");
                $this->writeLog('============= Start send evaluation notification at ( ' . $current . ' ) =============');
                $params['company_cd']   = session_data()->company_cd ?? 0;
                $mail_type = $request->mail_type ?? 0;
                if (!is_numeric($mail_type)) {
                    $mail_type = 0;
                }
                // if mail_type = 2 , 3, 4 then employee_cd is json
                if ($mail_type == 2 || $mail_type == 3 || $mail_type == 4) {
                    $params['employee_cd'] = $request->employee_cd ?? '';
                } else {
                    $params['employee_cd']  = SQLEscape(preventOScommand($request->employee_cd));
                }
                $params['mail_type']   = $mail_type;
                $target_employee_cd = $request->target_employee_cd ?? '';
                $params['target_employee_cd']  = SQLEscape(preventOScommand($target_employee_cd));
                $params['mail_message'] = $request->mail_message ?? '';
                $params['cre_user'] = session_data()->user_id;
                $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
                $result = Dao::executeSql('SPC_EVALUATION_NOTIFICATION_MAIL_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    // return response()->view('errors.query', [], 501);
                    $this->writeLog($result[0][0]['remark']);
                }
                // if mail_type = 2. 総合評価確定
                if ($mail_type == 2) {
                    // $mail_raters = $result[0] ?? [];
                    // $mail_employees = $result[1] ?? [];
                    // $send_success = 0;
                    // if (empty($mail_raters)) {
                    //     $this->respon['status']     = NG;
                    // } else {
                    //     foreach ($mail_raters as $mail_rater) {
                    //         $payload = $mail_rater;
                    //         $employee_cd = $mail_rater['employee_cd'];
                    //         $mail_address = $mail_rater['mail'];
                    //         $temp = [];
                    //         foreach ($mail_employees as $mail_employee) {
                    //             if ($mail_employee['employee_cd_rater'] == $employee_cd) {
                    //                 $temp[] = [
                    //                     'employee_cd' => $mail_employee['employee_cd'],
                    //                     'employee_nm' => $mail_employee['employee_nm'],
                    //                 ];
                    //             }
                    //         }
                    //         // send mail
                    //         if ($mail_address != '') {
                    //             $payload['employees'] = $temp;
                    //             $payload['mail_message'] = $request->mail_message ?? '';
                    //             $this->send($mail_address, $payload, $mail_type);
                    //             $send_success++;
                    //             // delay 3s for times to send mail
                    //             sleep(3);
                    //         } else {
                    //             $this->writeLog('Employee:' . $employee_cd . ': mail address is empty');
                    //         }
                    //     }
                    //     // if not send mail
                    //     if ($send_success == 0) {
                    //         $this->respon['status']     = NG;
                    //     }
                    // }

                    // Send mail by batch process
                    $this->respon['status']     = OK;

                    // if mail_type = 3. 本人フィードバック
                } else if ($mail_type == 3) {
                    // $mail_employees = $result[0] ?? [];
                    // $send_success = 0;
                    // if (empty($mail_employees)) {
                    //     $this->respon['status']     = NG;
                    // } else {
                    //     foreach ($mail_employees as $mail_employee) {
                    //         $payload = $mail_employee;
                    //         $mail_address = $mail_employee['mail'];
                    //         // send mail
                    //         if ($mail_address != '') {
                    //             $payload['employees'] = [];
                    //             $payload['mail_message'] = $request->mail_message ?? '';
                    //             $this->send($mail_address, $payload, $mail_type);
                    //             $send_success++;
                    //             // delay 3s for times to send mail
                    //             sleep(3);
                    //         } else {
                    //             $this->writeLog('Employee:' . $mail_employee['employee_cd'] . ': mail address is empty');
                    //         }
                    //     }
                    //     // if not send mail
                    //     if ($send_success == 0) {
                    //         $this->respon['status']     = NG;
                    //     }
                    // }

                    // Send mail by batch process
                    $this->respon['status']     = OK;
                } else if ($mail_type == 4) {
                    $mail_employees = $result[0] ?? [];
                    $send_success = 0;
                    if (empty($mail_employees)) {
                        $this->respon['status']     = NG;
                    } else {
                        foreach ($mail_employees as $mail_employee) {
                            $payload = $mail_employee;
                            $mail_address = $mail_employee['mail'];
                            // send mail
                            if ($mail_address != '') {
                                $payload['employees'] = [];
                                $payload['mail_message'] = $request->mail_message ?? '';
                                $this->send($mail_address, $payload, $mail_type);
                                $send_success++;
                                // delay 3s for times to send mail
                                sleep(3);
                            } else {
                                $this->writeLog('Employee:' . $mail_employee['employee_cd_rater'] . ': mail address is empty');
                            }
                        }
                        // if not send mail
                        if ($send_success == 0) {
                            $this->respon['status']     = NG;
                        }
                    }
                } else {
                    $mail = $result[0][0] ?? [];
                    $mail['mail_message'] = $request->mail_message ?? '';
                    $mail['employees'] = [];
                    if ($mail['mail'] == '') {
                        $this->respon['status']     = NG;
                    } else {
                        $this->send($mail['mail'], $mail, $mail_type);
                        // delay 3s for times to send mail
                        sleep(3);
                    }
                }
                // finished process
                $this->writeLog('============= Finished send evaluation notification at ( ' . $current . ' ) =============');
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
     * writeLog
     *
     * @param  string $content
     * @return void
     */
    private function writeLog($content, $payloads = [])
    {
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_EVALUATION_NOTIFICATION_MAIL.log'),
            'a+'
        );
        fwrite($logFile, $time . ': ' . $content . PHP_EOL);
        // if $payloads is exits 
        if (!empty($payloads)) {
            foreach ($payloads as $payload) {
                fwrite($logFile, '∟ ' . $payload . PHP_EOL);
            }
        }
        // close file
        fclose($logFile);
    }

    /**
     * send
     *
     * @param  string $mail_address
     * @param  array $mail_payload
     * @return void
     */
    private function send($mail_address = '', $mail_payload = [], $mail_type = 0)
    {
        $mail_payload['mail_type'] = $mail_type;
        $mail_send_logs = [];
        try {
            // send mail
            $googleMail = new GoogleService();
            // Mail::to($mail_address)->send(new EvaluationNotification($mail_payload));
            // check mail send error
            // Send mail
            $mail_payload['screen_id'] = 'mail_popup';
            $result = $googleMail->sendEvaluationNotification($mail_address, $mail_payload);
            // mail send success
            if ($result['Exception']) {
                $this->respon['status']     = EX;
                // Log
                $this->writeLog('This mail [' . $mail_address . '] is not sent');
                return response()->json($this->respon);
            }
            $this->writeLog('This mail address [' . $mail_address . '] is successful');
            $this->respon['status']     = OK;
            return response()->json($this->respon);
            // Mail::to($member_mail)->send(new InterviewSchedule($mail_info));
        } catch (\Swift_TransportException $th) {
            $mail_send_logs[] = $th->getMessage();
        }
        // log 
        $this->writeLog('Mail information sent ', $mail_send_logs);
    }
    /**
     * getTimes
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
    public function getTimes(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'report_kind'              => 'integer',
                'fiscal_year'              => 'integer',
                'month'                 => 'integer'
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $company_cd     = session_data()->company_cd;
            $fiscal_year    = $request->fiscal_year ?? 0;
            $report_kind    = $request->report_kind ?? 0;
            $month          = $request->month ?? 1;
            $data = $this->weeklyReportService->getScheduleSetting($company_cd, 3, $fiscal_year, $report_kind, $month);
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return json_encode($data);
    }
    /**
     * getTimes
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
    public function getMonths(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'fiscal_year'              => 'integer',
                'report_kind'              => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $mode           =  $request->screen == 'schedule' ? 5 : 2;
            $company_cd     = session_data()->company_cd;
            $fiscal_year    = $request->fiscal_year ?? 0;
            $report_kind    = $request->report_kind ?? 0;
            $data = $this->weeklyReportService->getScheduleSetting($company_cd, $mode, $fiscal_year, $report_kind);
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return json_encode($data);
    }
}
