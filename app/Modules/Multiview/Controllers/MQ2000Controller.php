<?php

namespace App\Modules\Multiview\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Dao;
use App\Helpers\Service;
use Crypt;
use App\Services\OneOnOneService;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;

class MQ2000Controller extends Controller
{
    protected $one_on_one_service;
    //
    public function __construct(OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author NGHIANM 
     * @created at 2020-11-16 06:49:48
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.multi_review');
        $data['category_icon'] = 'fa fa-users';
        $data['title'] = trans('messages.review_list');
        $data['redirect_flg'] = 0; //0: from menu ,1: from dashboard 
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
                $data['redirect_flg']  = 1;
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $reqs = [
            'employee_cd'  =>$redirect_param->employee_cd ?? '',
            'fiscal_year'  => $redirect_param->fiscal_year ?? 0,
            'from'         => $redirect_param->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'fiscal_year'   =>  'integer',
            'from'  => [
                'string',
                Rule::in(['mdashboardsupporter', 'mdashboard']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $company_cd    = session_data()->company_cd;
        $data_year     =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
        if ($data['redirect_flg'] == 1) {
            $data['current_year']  = $reqs['fiscal_year'] ?? date("Y");
            $data['employee_cd']   = $reqs['employee_cd'] ?? '';
            $params = [
                'company_cd'       => $company_cd,
                'employee_cd'      => $reqs['employee_cd'],
            ];
            $res = Dao::executeSql('SPC_MQ2000_INQ1', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                // return 501 error
                return response()->view('errors.query', [], 501);
            }
            $data['employee_name']      = $res[0][0]['employee_nm'] ?? '';
        } else {
            $data['current_year']  = $data_year['fiscal_year'] ?? date("Y");
        }
        // 
        $years[] = (int)$data['current_year'] - 3;
        $years[] = (int)$data['current_year'] - 2;
        $years[] = (int)$data['current_year'] - 1;
        $years[] = (int)$data['current_year'];
        $years[] = (int)$data['current_year'] + 1;
        $years[] = (int)$data['current_year'] + 2;
        $years[] = (int)$data['current_year'] + 3;
        $data['years'] = $years;
        $data['M0020'] = getCombobox('M0020', 1, 3) ?? [];
        $data['M0060'] = getCombobox('M0060', 1, 3) ?? [];
        $data['M0040'] = getCombobox('M0040', 1, 3) ?? [];
        $data['M0030'] = getCombobox('M0030', 1, 3) ?? [];
        $data['M0050'] = getCombobox('M0050', 1, 3) ?? [];
        $data['M0022'] = getCombobox('M0022', 1, 3);
        $data['supporter_permission_typ'] = $this->getPermissionSupporter();
        $data['from']   = $reqs['from'];
        if ($data['redirect_flg'] == 0){
            $left = $this->postSearch($request);
            return view('Multiview::mq2000.index', array_merge($data, $left));
        }else{
            return view('Multiview::mq2000.index',$data);
        }
    }
    /**
     * Show the application index.
     * @author nghianm
     * @created at 2021-01-06 07:46:26
     * @return void
     */
    public function postSearch(Request $request)
    {
        $payload = $request->json()->all() ?? [];
        // validate
        $validator = Validator::make($payload, [
            'fiscal_year'       =>  'integer',
            'page_size'         =>  'integer',
            'page'              =>  'integer',
        ]);
        //
        if ($validator->fails()) {
            return response()->json('Error', 501);
        }
        $company_cd    = session_data()->company_cd;
        $data_year     =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
        if (count($payload) == 0) {
            $payload['fiscal_year']                      = $data_year['fiscal_year'] ?? date("Y");
            $payload['review_date_from']                 = null;
            $payload['review_date_to']                   = null;
            $payload['project_title']                    = '';
            $payload['list_position_cd']                 = [];
            $payload['list_grade']                       = [];
            $payload['list_job_cd']                      = [];
            $payload['list_employee_typ']                = [];
            $payload['list_organization_step1']          = [];
            $payload['list_organization_step2']          = [];
            $payload['list_organization_step3']          = [];
            $payload['list_organization_step4']          = [];
            $payload['list_organization_step5']          = [];
            $payload['list_employee_cd']                 = [];
            $payload['list_supporter_cd']                = [];
            $payload['list_rater_employee_cd']           = [];
            $payload['page_size']                        = 20;
            $payload['page']                             = 1;
        }
        if (!validateCommandOS($payload['project_title'] )) {
            $this->respon['status']     = 164;
			return response()->json($this->respon);
        }
        $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        if (!validateJsonFormat($json)) {
            // return 501 error
            return response()->view('errors.query', [], 501);
        }
        $params['language']     =   session_data()->language;
        $params['json']         =   $json;
        $params['employee_cd']  =   session_data()->employee_cd;
        $params['cre_user']     =   session_data()->user_id;
        $params['company_cd']   =   session_data()->company_cd;
        $params['mode']         =   0;   //mode search
        $result = Dao::executeSql('SPC_MQ2000_FND1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            // return 501 error
            return response()->view('errors.query', [], 501);
        }
        $data['views']      = $result[0] ?? [];
        $data['paging']     = $result[1][0] ?? [];
        $data['sum_total']  = $result[2][0]['sum_total'] ?? 0;
        // $data['multireview_authority_typ'] = session_data()->multireview_authority_typ ?? 0;
        // $data['authority_typ']  = session_data()->authority_typ ?? 0;
        $authority_typ = session_data()->multireview_authority_typ;
        $data['supporter_permission_typ'] = $this->getPermissionSupporter();
        $data['current_user'] = session_data()->employee_cd;
        $data['enable_link'] = false;
        if($authority_typ>2) {
            $data['enable_link'] = true;
        }
        if ($request->ajax()) {
            return view('Multiview::mq2000.search', $data);
        } else {
            return $data;
        }
    }
    /**
     * Save data
     * @author nghianm
     * @created at 2020/10/26
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
                    $res = Dao::executeSql('SPC_MQ2000_ACT1', $params);
                    // check exception
                    if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($res[0]) && !empty($res[0])) {
                        $this->respon['status'] = NG;
                        foreach ($res[0] as $temp) {
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
     * get excel file from button 個別詳細ダウンロード
     * @author nghianm
     * @created at 2020-10-12
     * @return void
     */
    public function postExportExcel(Request $request)
    {
        if ($request->ajax()) {
            $param_json = $request->json()->all() ?? [];
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if (!validateJsonFormat($json)) {
                return response()->view('errors.query', [], 501);
            }
            $params = array(
                preventOScommand($json), session_data()->employee_cd, session_data()->user_id, session_data()->company_cd, 1
            );
            //
            $store_name = 'SPC_MQ2000_FND1';
            $typeReport = 'FNC_OUT_EXL';
            $screen = 'Mq2000';
            $file_name = 'Mq2000_' . time() . '.xlsx';
            $service = new Service();
            $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
            if (isset($result['filename'])) {
                $result['path_file'] =  '/download/' . $result['filename'];
            }
            $name = '個別詳細_';
            if (session_data()->language == 'en') {
                $name = 'IndividualDetails_';
            }
            $result['fileNameSave'] =   $name . time() . '.xlsx';
            $this->respon = $result;
            // return http request
            return response()->json($this->respon);
        }
    }
    /**
     * get excel file from button 平均点一覧ダウンロード
     * @author nghianm
     * @created at 2020-10-12
     * @return void
     */
    public function postExportExcelAvg(Request $request)
    {
        if ($request->ajax()) {
            $param_json = $request->json()->all() ?? [];
            $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if (!validateJsonFormat($json)) {
                return response()->view('errors.query', [], 501);
            }
            $params = array(
                preventOScommand($json), session_data()->employee_cd, session_data()->user_id, session_data()->company_cd, 2
            );
            $store_name = 'SPC_MQ2000_FND1';
            $typeReport = 'FNC_OUT_EXL';
            $screen = 'Mq2000_AVG';
            $file_name = 'Mq2000_AVG_' . time() . '.xlsx';
            $service = new Service();
            $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
            if (isset($result['filename'])) {
                $result['path_file'] =  '/download/' . $result['filename'];
            }
            $name = '平均点一覧_';
            if (session_data()->language == 'en') {
                $name = 'ListOfAveragePoints_';
            }
            $result['fileNameSave'] =   $name . time() . '.xlsx';
            $this->respon = $result;
            // return http request
            return response()->json($this->respon);
        }
    }    
    /**
     * get permission of supporter
     *
     * @return int      0. not use | 1.only supporter | 2.supporter & rater_1 | 3.admin
     */
    protected function getPermissionSupporter()
    {
        $multireview_authority_typ = session_data()->multireview_authority_typ ?? 0;
        $user_is_rater_1 = session_data()->user_is_rater_1 ?? 0;
        // $authority_typ = session_data()->authority_typ ?? 0;
        // when not supporter || admin
        if($multireview_authority_typ < 2){
            return 0;
        }
        // when only supporter
        if ($multireview_authority_typ == 2 && $user_is_rater_1 == 0){
            return 1;
        }
        // when 2.supporter & rater_1
        if($multireview_authority_typ == 2 && $user_is_rater_1 == 1){
            return 2;
        }
        // when admin
        if($multireview_authority_typ >= 3){
            return 3;
        }
        return 0;
    }
}