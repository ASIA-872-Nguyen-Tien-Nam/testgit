<?php

/**
 ****************************************************************************
 * MIRAI
 * APIController
 *
 * 処理概要/process overview   : I1010Controller
 * 作成日/create date   : 2018-06-25 03:01:47
 * 作成者/creater    : viettd
 *
 * 更新日/update date    : 2022/04/25
 * 更新者/updater    : namnt
 * 更新内容 /update content  : upgrade version freeeapi
 *
 *
 * @package         :  BasicSetting
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\BasicSetting\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Dao;
use Session;
use GuzzleHttp\Psr7;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Client;
use App\Services\APIService;
use App\Modules\BasicSetting\Controllers\A0003Controller;
use Validator;

class APIController extends Controller
{
    /**
     * get 認可コード
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    private $api_service;
    protected $A0003Controller;
    protected $header;
    public function __construct(
        APIService $api_service,
        A0003Controller $A0003Controller
    ) {
        parent::__construct();
        $this->api_service = $api_service;
        $this->A0003Controller = $A0003Controller;
    }

    public function getAuthorizationCode(Request $request)
    {
        $company_cd_refer       = session_data()->company_cd;
        $path = $request->getSchemeAndHttpHost();
        $query = http_build_query([
            'client_id' => CLIENT_ID,
            'redirect_uri' => '' . $path . '/basicsetting/a0003/get-access-token',
            'response_type' => 'code',
            'scope' => ''
            // 'state' => $state,
        ]);
        $access_token   = config('mirai_api.' . $company_cd_refer . '.accessToken');
        $refresh_token  = config('mirai_api.' . $company_cd_refer . '.refreshToken');
        // check neu chua co access token thi chuyen den man yeu cau access token | co thi goi api lay thong tin nguoi dung
        if ($access_token == null || $access_token == '') {
            return redirect('https://accounts.secure.freee.co.jp/public_api/authorize?' . $query);
        } else {
            $data = $this->getLoginInfo($access_token, $refresh_token);
            if ($data['API_status'] == 'OK') {
                return redirect('/basicsetting/a0003');
            } else {
                return redirect('https://accounts.secure.freee.co.jp/public_api/authorize?' . $query);
            }
        }
    }
    /**
     * get アクセストークン
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function getAccessToken(Request $request)
    {
        $http                   = new \GuzzleHttp\Client;
        $path                   = $request->getSchemeAndHttpHost();
        $company_cd             = session_data()->company_cd;
        $url = 'https://accounts.secure.freee.co.jp/public_api/token';
        try {
            $response = $http->post($url, [
                'form_params' => [
                    'grant_type'    => 'authorization_code',
                    'client_id'     => CLIENT_ID,
                    'client_secret' => CLIENT_SECRET,
                    'redirect_uri'  => '' . $path . '/basicsetting/a0003/get-access-token',
                    'code'          => $request->code,
                    'http_errors' => false
                ],
            ]);
        } catch (ClientException $e) {
            //  when reject authen
            return redirect('/basicsetting/a0003');
        }
        // write log
        $method = 'POST';
        $status = $response->getStatusCode();
        $data_respone =  json_decode($response->getBody(), true);
        // edit by namnt 2022/04/26
        $this->setLog($company_cd, $url, '', $method, $status, $data['errors'][0]['messages'][0] ?? '');
        // end write log

        $access_token     =    $data_respone['access_token'];
        $refresh_token     =     $data_respone['refresh_token'];
        $data_login = $this->getLoginInfo($access_token, $refresh_token);
        // $api_office_cd = $data_login['companies'][0]['id']??0;
        // /// viet them vaof file config
        // if($company_cd != ''){
        //     writeConfigFileAPI('ADD',$company_cd,$access_token,$refresh_token,$api_office_cd);
        // }

        return redirect('/basicsetting/a0003');
    }
    /**
     * get infomation of login user
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function getLoginInfo($access_token, $refresh_token = '')
    {
        $user_id                = session_data()->user_id;
        $cache_api              = getCache('a0003_api', $user_id);
        $company_cd_refer       = session_data()->company_cd;
        $api_office_cd = '';
        // deleteCache('a0003_api',$user_id);
        //
        $http = new \GuzzleHttp\Client;
        $headers = [
            'Authorization' => 'Bearer ' . $access_token,
            'Accept'        => 'application/json',
            'FREEE-VERSION' => '2022-02-01'
        ];
        $url = 'https://api.freee.co.jp/hr/api/v1/users/me';
        try {
            $data_api = $http->get($url, [
                'headers' => $headers,
                'http_errors' => false
            ]);
        } catch (ClientException $e) {
            echo Psr7\str($e->getRequest());
            echo Psr7\str($e->getResponse());
        }
        // get status api if 401 -> access_token expire or something wrong
        $status = $data_api->getStatusCode();
        $data = json_decode((string) $data_api->getBody(), true);
        // edit by namnt 2022/04/26
        $this->setLog($company_cd_refer, $url, $access_token, 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
        switch ($status) {
            case 200:
                $data['API_status'] = 'OK';
                //check number of companies
                if (isset($data['companies']) && count($data['companies']) > 1) {
                    // $data['data_api'] = json_encode($data['companies']);
                    Session::put($company_cd_refer . 'api', $data['companies']);
                    unset($data['companies']);
                    $data['err']  = 1;
                    $data_to_cache = $cache_api + $data;
                    writeConfigFileAPI('ADD', $company_cd_refer, $access_token, $refresh_token, $api_office_cd);
                } else if (isset($data['companies']) && count($data['companies']) == 1) {
                    $data_to_cache = $data['companies'][0] + $cache_api;
                    $api_office_cd = $data['companies'][0]['id'];
                    writeConfigFileAPI('ADD', $company_cd_refer, $access_token, $refresh_token, $api_office_cd);
                } else {
                    $data['err']  = 2;
                    $data_to_cache = $cache_api + $data;
                    writeConfigFileAPI('REMOVE', $company_cd_refer);
                }
                setcache($data_to_cache);
                break;
            case 401: // unauthorize
                /////////////lay access token bang refresh token/////////////////////////////////////
                $data =  $this->getAccessTokenByRefreshToken($company_cd_refer, $refresh_token);
                //////////////////////////////////////////////////////////////////////////////////////
                if ($data['status'] == 'OK') {
                    $data = $this->getLoginInfo($data['access_token'], $data['refresh_token']);
                } else {
                    $data['API_status'] = 'NG';
                }
                break;
            default:
                dd('something wrong in function getLoginInfo');
        }
        return $data;
    }
    /**
     *  processing api
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function processApi(Request $request)
    {
        //company phair cos trong a0003
        $company_cd_refer = session_data()->company_cd;
        $api_office_cd    = $request->api_office_cd;
        $option = array(
            'api_employee_use'    => $request->api_employee_use ?? '',
            'api_position_use'    => $request->api_position_use ?? '',
            'api_organization_use' => $request->api_organization_use ?? '',
        );
        $refresh_token = config('mirai_api.' . $company_cd_refer . '.refreshToken');
        // always use refresh token to take access token
        $data_access =  $this->getAccessTokenByRefreshToken($company_cd_refer, $refresh_token);
        $this->respon['file_content'] = $data_access['file_content'];

        if ($data_access['status'] == 'OK') {
            //----------api 1 --> employee
            $data_emp = $this->execApiEmployee($company_cd_refer, $api_office_cd, $data_access['access_token']);
            //----------api 2 --> position and group
            $data_mebership = $this->execApiGroup($company_cd_refer, $api_office_cd, $data_access['access_token']);
            if ($data_emp['API_status'] == 'OK' && $data_mebership['API_status'] == 'OK') {
                //Convert type of gender after upgrade api
                for ($i = 0; $i < count($data_emp) - 1; $i++) {
                    if ($data_emp[$i]['profile_rule']['gender'] == 'male') {
                        $data_emp[$i]['profile_rule']['gender'] = 1;
                    } else if ($data_emp[$i]['profile_rule']['gender'] == 'female') {
                        $data_emp[$i]['profile_rule']['gender'] = 2;
                    } else {
                        $data_emp[$i]['profile_rule']['gender'] = 0;
                    }
                }
                for ($i = 0; $i < count($data_mebership['employee_group_memberships']); $i++) {
                    if ($data_mebership['employee_group_memberships'][$i]['gender'] == 'male') {
                        $data_mebership['employee_group_memberships'][$i]['gender'] = 1;
                    } else if ($data_mebership['employee_group_memberships'][$i]['gender'] == 'female') {
                        $data_mebership['employee_group_memberships'][$i]['gender'] = 2;
                    } else {
                        $data_mebership['employee_group_memberships'][$i]['gender'] = 0;
                    }
                }
                unset($data_emp['API_status']);
                unset($data_mebership['API_status']);
                $params['json1']                    =   json_encode($data_emp ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params['json2']                    =   json_encode($data_mebership ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params['api_employee_use']         =   $option['api_employee_use'];
                $params['api_position_use']         =   $option['api_position_use'];
                $params['api_organization_use']     =   $option['api_organization_use'];
                $params['cre_user']                 =   class_exists('session_data') ? session_data()->user_id : 'user.bat';
                $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'] ?? 'mirai.bat';
                $params['company_cd']               =   $company_cd_refer;
                $result = Dao::executeSql('SPC_A0002_ACT1', $params);
                // check result
                $this->respon['status'] = OK;
                $this->respon['message'] = '';
                if (isset($result[0]) && !empty($result[0])) {
                    $this->respon['status'] = NG;
                }
                if ($request->ajax() && isset($result[1]) && count($result[1]) > 1) {
                    $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                    $csvname = 'O0100' . $date . '.csv';
                    $fileNameError =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                    $fileNameReturn  = $this->saveCSV_error($fileNameError, $result[1]);
                    $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    $this->respon['status'] = 'ERR_CHECK';
                }
                // edit by namnt 2022/04/26    
            } else if ($data_emp['API_status'] != 'OK') {
                $this->respon['status'] = $data_emp['API_status'];
                $this->respon['message'] = $data_emp['message'];
                // add by namnt 2022/04/26       
            } else {
                $this->respon['status'] = $data_mebership['API_status'];
                $this->respon['message'] = $data_mebership['message'];
            }
        } else {
            $this->respon['status'] = 401;
            $this->respon['message'] = '';
        }
        return response()->json($this->respon);
    }
    /**
     *  execApiEmployee
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function execApiEmployee($company_cd_refer, $api_office_cd, $access_token)
    {
        $date = Carbon::now();
        // loop all data from api
        $page_size = 1;
        $offset = 0;
        $sql_arr_1 = array(
            'API_status' => 'OK'
        );
        do {
            $offset = ($page_size - 1) * 100;
            $http = new \GuzzleHttp\Client;
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
                'Accept'        => 'application/json',
                'FREEE-VERSION' => '2022-02-01'
            ];
            $url = 'https://api.freee.co.jp/hr/api/v1/employees';
            $data_api = $http->get($url, [
                'headers' => $headers,
                'query' => [
                    'company_id' => $api_office_cd ?? '',
                    'year' => $date->year,
                    'month' => $date->month,
                    'limit' => 100,
                    'offset' => $offset,
                    'with_no_payroll_calculation' => true,
                ],
                'http_errors' => false
            ]);
            $status = $data_api->getStatusCode();
            $data =  json_decode($data_api->getBody(), true);
            $this->setLog($company_cd_refer, $url, $access_token, 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
            // Has error
            if ($status != 200) {
                $sql_arr_1 = array(
                    'API_status'    => $status,
                    'message'       => $data['errors'][0]['messages'][0] ?? $data['message']
                );
                break;
            }
            // lọc data sử dụng những trường cần thiết trong api
            foreach ($data['employees'] as $key => $value) {
                unset($value['health_insurance_rule'], $value['welfare_pension_insurance_rule'], $value['dependent_rules'], $value['bank_account_rule']);
                array_push($sql_arr_1, $value);
            }
            $page_size++;
        } while (count($data['employees']) > 0);
        return  $sql_arr_1;
    }
    /**
     *  execApiGroup
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function execApiGroup($company_cd_refer, $api_office_cd, $access_token)
    {
        $date = Carbon::now();
        // loop all data from api
        $page_size = 1;
        $offset = 0;
        $sql_arr_1 = array(
            'API_status' => 'OK'
        );
        $employee_group_memberships = [];
        do {
            $offset = ($page_size - 1) * 100;
            $http = new \GuzzleHttp\Client;
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
                'Accept'        => 'application/json',
                'FREEE-VERSION' => '2022-02-01'
            ];
            $url = 'https://api.freee.co.jp/hr/api/v1/employee_group_memberships';
            $data_api_2 = $http->get($url, [
                'headers' => $headers,
                'query' => [
                    'company_id' => $api_office_cd ?? '',
                    'base_date' => $date->format('Y-m-d'),
                    'limit' => 100,
                    'offset' => $offset,
                    'with_no_payroll_calculation' => true,
                ],
                'http_errors' => false
            ]);
            $status = $data_api_2->getStatusCode();
            $data = json_decode($data_api_2->getBody(), true);
            $this->setLog($company_cd_refer, $url, $access_token, 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
            if ($status != 200) {
                $sql_arr_1 = array(
                    'API_status'    => $status,
                    'message'       => $data['errors'][0]['messages'][0] ?? ''
                );
                break;
            }
            foreach ($data['employee_group_memberships'] as $key => $value) {
                array_push($employee_group_memberships, $value);
            }
            $page_size++;
        } while (count($data['employee_group_memberships']) > 0);
        $sql_arr_1['employee_group_memberships'] = $employee_group_memberships;
        return  $sql_arr_1;
    }
    /**
     * passing into sql
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function getAccessTokenByRefreshToken($company_cd, $refresh_token)
    {
        $http = new \GuzzleHttp\Client;
        $url = 'https://accounts.secure.freee.co.jp/public_api/token';
        $response = $http->post($url, [
            'form_params' => [
                'grant_type'    => 'refresh_token',
                'refresh_token' => $refresh_token,
                'client_id'     => CLIENT_ID,
                'client_secret' =>  CLIENT_SECRET,
                'scope'         => '',
            ],
            'http_errors' => false
        ]);
        $data_respone   =  json_decode($response->getBody(), true);
        $status = $response->getStatusCode();
        // edit by namnt 2022/04/26   
        $this->setLog($company_cd, $url, $refresh_token, 'POST', $status, $data['errors'][0]['messages'][0] ?? '');
        if (isset($data_respone['error'])) {
            $result['file_content'] =  writeConfigFileAPI('REMOVE', $company_cd);
            $result['status'] = 'NG';
        } else {
            $access_token     =    $data_respone['access_token'];
            $refresh_token     =     $data_respone['refresh_token'];
            $api_office_cd  =   config('mirai_api.' . $company_cd . '.api_office_cd');
            $result = array(
                'access_token'  =>  $access_token,
                'refresh_token' =>  $refresh_token,
                'status' => 'OK'
            );
            $result['file_content'] = writeConfigFileAPI('ADD', $company_cd, $access_token, $refresh_token, $api_office_cd);
        }
        return $result;
    }
    /**
     * Log api
     * @author datnt
     * @created at 2020-06-25 07:46:26
     * @return void
     */
    public function setLog($company_cd, $link_api, $access_token, $method, $status, $message)
    {
        //    Logging
        $debug_api = 'company-refer: ' . $company_cd . ',  ' . $link_api . ' ,access token: ' . $access_token . ' , method: ' . $method . ' ,  status: ' . $status . ', message:  ' . $message;
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_API.log'),
            'a+'
        );
        // link url / method / status
        fwrite($logFile, $time . ': ' . $debug_api . PHP_EOL);
        fclose($logFile);
    }
    public function saveCSV_error($file_name, $data)
    {
        $return = "";
        try {
            if (isset($data)) {
                $this->handle = fopen($file_name, 'w');
                $BOM = "\xEF\xBB\xBF";
                fwrite($this->handle, $BOM);
                //write file
                $count = count($data);
                $index = 1;
                foreach ($data as $item) {
                    $value = array_values($item);
                    //                    $this->writeLine($value);

                    $this->writeLine($value, $index, $count);
                    //
                    $index = $index + 1;
                }
                //
                fclose($this->handle);
                // dowload fie
                $return = basename($file_name);
            }
        } catch (Exception $e) {
            pr($e);
        }
        return $return;
    }
    /**
     *  processing api
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function processApiKot(Request $request)
    {
        $company_cd_refer = session_data()->company_cd;
        $option = array(
            'kot_api_employee_use'    => $request->kot_api_employee_use ?? 0,
            'kot_api_organization_use'    => $request->kot_api_organization_use ?? 0,
            'kot_api_employee_typ_use' => $request->kot_api_employee_typ_use ?? 0,
        );
        $validator = Validator::make($option, [
            'kot_api_employee_use' => 'integer',
            'kot_api_organization_use' => 'integer',
            'kot_api_employee_typ_use' => 'integer',
        ]);
        // validate Laravel
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $check_token = $this->checkTokenValidate($request);
        if (isset(json_decode($check_token->getContent())->API_status) && json_decode($check_token->getContent())->API_status == '401') {
            $this->respon['status'] = 401;
            $this->respon['message'] = '';
            $this->setLog(session_data()->company_cd, '', '', 'GET', $this->respon['status'], $this->respon['message'] ?? '');

            return response()->json($this->respon);
        }
        //----------api 1 --> employee
        $data_emp = [];
        if ($option['kot_api_employee_use'] == 1) {
            $data_emp = $this->execApiKotEmployee();
        }
        //----------api 2 --> position and group
        $data_division = [];
        if ($option['kot_api_organization_use'] == 1) {
            $data_division = $this->execApiKotGroup();
        }
        //----------api 3 --> position and group
        $data_employee_typ = [];
        if ($option['kot_api_employee_typ_use'] == 1) {
            $data_employee_typ = $this->execApiKotEmployeeTyp();
        }
        if ((!is_array($data_emp) && isset(json_decode($data_emp->getContent())->Exception)) || (!is_array($data_emp) && isset(json_decode($data_division->getContent())->Exception)) || (!is_array($data_emp) && isset(json_decode($data_employee_typ->getContent())->Exception))) {
            $this->respon['status'] = NG;
            $this->respon['message'] = json_decode($data_emp->getContent())->Exception;
            $this->setLog(session_data()->company_cd, '', json_decode($data_emp->getContent())->access_token, 'GET', $this->respon['status'], $this->respon['message'] ?? '');
            return response()->json($this->respon);
        }
        if (is_array($data_emp) && is_array($data_division) && is_array($data_employee_typ)) {
            //     //Convert type of gender after upgrade api
            for ($i = 0; $i < count($data_emp) - 1; $i++) {

                if (isset($data_emp[$i]['emailAddresses'])) {
                    $data_emp[$i]['emailAddresses'] = $data_emp[$i]['emailAddresses'][0];
                } else {
                    $data_emp[$i]['emailAddresses'] = '';
                }
                unset($data_emp[$i]["key"]);
                unset($data_emp[$i]["typeName"]);
            }
            for ($i = 0; $i < count($data_division); $i++) {
                unset($data_division[$i]["dayBorderTime"]);
            }
            $params['json1']                    =   json_encode($data_emp ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json2']                    =   json_encode($data_division ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json3']                    =   json_encode($data_employee_typ ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['kot_api_employee_use']         =   $option['kot_api_employee_use'];
            $params['kot_api_organization_use']     =   $option['kot_api_organization_use'];
            $params['kot_api_employee_typ_use']     =   $option['kot_api_employee_typ_use'];
            $params['cre_user']                 =   class_exists('session_data') ? session_data()->user_id : 'user.bat';
            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'] ?? 'mirai.bat';
            $params['company_cd']               =   $company_cd_refer;
            $result = Dao::executeSql('SPC_A0004_ACT1', $params);
            if ($request->ajax() && isset($result[1]) && count($result[1]) >= 1) {
                $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                $csvname = 'A0003' . $date . '.csv';
                $fileNameError =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                $fileNameReturn  = $this->saveCSV_error($fileNameError, $result[1]);
                $this->respon['FileName'] = '/download/' . $fileNameReturn;
                $this->respon['status'] = 'ERR_CHECK';
            }
        }
        return response()->json($this->respon);
    }
    /**
     * Excecute api employee
     * @author namnt
     * @created at 2024-10-29
     * @return \Illuminate\Http\Response
     */
    public function execApiKotEmployee()
    {
        try {
            $http = new \GuzzleHttp\Client;
            $access_token = $this->api_service->getKotData(session_data()->company_cd, 0);
            if ($access_token == '') {
                $this->respon['status'] = NG;
                $this->respon['API_status'] = 401;
                return response()->json($this->respon);
            }
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
            ];
            $url = '';
            $employee_list = [];
            $data_api = $http->get('https://api.kingtime.jp/v1.0/employees?additionalFields=emailAddresses,lastNamePhonetics,firstNamePhonetics,hiredDate,birthDate,resignationDate', [
                'headers' => $headers,
            ]);

            $status = $data_api->getStatusCode();
            $data =  json_decode($data_api->getBody(), true);
            $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/employees', session()->get('access_token'), 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
            // Has error
            if ($status != 200) {
                $employee_list = array(
                    'API_status'    => $status,
                    'message'       => $data['errors'][0]['messages'][0] ?? $data['message']
                );
            }
            // lọc data sử dụng những trường cần thiết trong api
            foreach ($data as $key => $value) {
                array_push($employee_list, $value);
            }
            return  $employee_list;
        } catch (\Exception $e) {
            $this->respon['status'] = NG;
            $this->respon['API_status'] = 401;
            $this->respon['access_token']    = $access_token;
            $this->respon['messages'] = json_decode($e->getMessage());
            $this->respon['Exception']  =  json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message ?? '';
            return response()->json($this->respon);
        }
    }
    /**
     *  execApiGroup
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function execApiKotGroup()
    {

        try {
            $http = new \GuzzleHttp\Client;
            $access_token = $this->api_service->getKotData(session_data()->company_cd, 0);
            if ($access_token == '') {
                $this->respon['status'] = NG;
                $this->respon['API_status'] = 401;
                return response()->json($this->respon);
            }
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
            ];
            $url = '';
            $group_list = [];
            $data_api = $http->get('https://api.kingtime.jp/v1.0/divisions', [
                'headers' => $headers,
            ]);

            $status = $data_api->getStatusCode();
            $data =  json_decode($data_api->getBody(), true);

            $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/divisions', session()->get('access_token'), 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
            // Has error
            if ($status != 200) {
                $group_list = array(
                    'API_status'    => $status,
                    'access_token'    => $access_token,
                    'message'       => $data['errors'][0]['messages'][0] ?? $data['message']
                );
            }
            // lọc data sử dụng những trường cần thiết trong api
            foreach ($data as $key => $value) {
                array_push($group_list, $value);
            }
            return  $group_list;
        } catch (\Exception $e) {
            $this->respon['status'] = NG;
            $this->respon['messages'] = json_decode($e->getMessage());
            $this->respon['access_token']    = $access_token;
            $this->respon['Exception']  =  json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message ?? '';
            return response()->json($this->respon);
        }
    }
    /**
     *  execApiEmployeeTyp
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function execApiKotEmployeeTyp()
    {
        try {
            $http = new \GuzzleHttp\Client;
            $access_token = $this->api_service->getKotData(session_data()->company_cd, 0);
            if ($access_token == '') {
                $this->respon['status'] = NG;
                $this->respon['API_status'] = 401;
                return response()->json($this->respon);
            }
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
            ];
            $url = '';
            $group_list = [];
            $data_api = $http->get('https://api.kingtime.jp/v1.0/working-types', [
                'headers' => $headers,
            ]);

            $status = $data_api->getStatusCode();
            $data =  json_decode($data_api->getBody(), true);

            $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/working-types', session()->get('access_token'), 'GET', $status, $data['errors'][0]['messages'][0] ?? '');
            // Has error
            if ($status != 200) {
                $group_list = array(
                    'API_status'    => $status,
                    'access_token'    => $access_token,
                    'message'       => $data['errors'][0]['messages'][0] ?? $data['message']
                );
            }
            // lọc data sử dụng những trường cần thiết trong api
            foreach ($data as $key => $value) {
                array_push($group_list, $value);
            }
            return  $group_list;
        } catch (\Exception $e) {
            $this->respon['status'] = NG;
            $this->respon['messages'] = json_decode($e->getMessage());
            $this->respon['access_token']    = $access_token;
            $this->respon['Exception']  =  json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message ?? '';
            return response()->json($this->respon);
        }
    }
    /**
     *  check token validate
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function checkTokenValidate($request)
    {
        $client = new Client();
        $access_token = $this->api_service->getKotData(session_data()->company_cd, 0);
        if ($access_token == '') {
            $this->respon['status'] = NG;
            $this->respon['API_status'] = 401;
            return response()->json($this->respon);
        }
        $response = $client->request('GET', 'https://api.kingtime.jp/v1.0/tokens/' . $access_token . '/available');
        if (isset(json_decode($response->getBody(), true)['available']) && json_decode($response->getBody(), true)['available'] == false) {
            $http                   = new \GuzzleHttp\Client;
            try {
                $response = $http->post('https://api.kingtime.jp/v1.0/tokens/' . $access_token . '', [
                    'headers' => [
                        'Authorization' => 'Bearer ' . $access_token,
                        'Accept' => 'application/json',
                        // Thêm các header khác nếu cần
                    ],
                    'form_params' => [
                        'token'     => $access_token,
                    ],
                ]);
                $data_respone =  json_decode($response->getBody(), true);
            } catch (\Exception $e) {
                $this->respon['status'] = NG;
                $this->respon['Exception']  = $e->getMessage();
                return response()->json($this->respon);
            }

            $params['company_cd']   =   session_data()->company_cd;
            $params['access_token'] =   $data_respone['token'];
            $params['refresh_token'] =   null;
            $params['effective_date'] =   null;
            $params['status'] =   0;
            $params['cre_user']     =   session_data()->user_id;
            $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_A0003_ACT2', $params);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $this->respon['status'] = OK;
        }
        $this->respon['status'] = OK;
        return response()->json($this->respon);
    }
    /**
     *  exec Api Upload Employee
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function execApiKotEmployeeUpload(Request $request)
    {
        $check_token = $this->checkTokenValidate($request);
        if(isset(json_decode($check_token->getContent())->API_status) && json_decode($check_token->getContent())->API_status=='401')
        {
            $this->respon['status'] = 401;
            $this->respon['message'] = '';
            $this->setLog(session_data()->company_cd, '', '', 'GET', $this->respon['status'], $this->respon['message'] ?? '');
            return response()->json($this->respon);
        }
        $language = session_data()->language ?? 'jp';
        $date = Carbon::now();
        $time_upd = $date->format('Y-m-d');
        $params['api_organization_use']     =   1;
        $params['cre_user']                 =   class_exists('session_data') ? session_data()->user_id : 'user.bat';
        $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'] ?? 'mirai.bat';
        $params['company_cd']               =   session_data()->company_cd;
        $employee_lists = $this->api_service->getKotData(session_data()->company_cd, 1);

        $this->api_service->updateStatusUpload($params);
        $http = new \GuzzleHttp\Client;
        $url = '';

        $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
        $csvname = 'A0003' . $date . '.csv';
        $fileNameError =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
        $data = [];
        $data[0]['employee_cd'] = '従業員コード';
        $data[0]['employee_nm'] = '姓又は名';
        $data[0]['message'] = 'エラー';
        if ($language == 'en') {
            $data[0]['employee_cd'] = 'employee code';
            $data[0]['employee_nm'] = 'employee name';
            $data[0]['message'] = 'error';
        }
        if (count($employee_lists) > 0) {

            foreach ($employee_lists as $employee_list) {
                $access_token = $employee_list['access_token'];
                $employee_mail = $employee_list['emailAddresses'];
                $employee_list['emailAddresses'] = [];
                $employee_list['emailAddresses'][] = $employee_mail ?? '';
                $code = $this->checkExistsEmployee($employee_list['code']);
                if($code['API_status']==NG) {
                    $this->respon['status'] = 201;
                    $this->respon['message'] = '';

                    return response()->json($this->respon);
                }
                if ($code['key'] != '' && $code['key'] != null) {
                    try {

                        $response = $http->put('https://api.kingtime.jp/v1.0/employees/' .  $code['key'] . '?updateDate=' . $time_upd, [
                            'headers' => [
                                'Authorization' => 'Bearer ' . $access_token,
                                'Accept' => 'application/json',
                                // Thêm các header khác nếu cần
                            ],
                            'body' => json_encode($employee_list, JSON_UNESCAPED_UNICODE),
                        ]);
                        
                        $this->setLog(session_data()->company_cd, $url, $access_token, 'PUT', '200', $data['errors'][0]['messages'][0] ?? '');
                        $this->respon['status'] = OK;
                        $this->respon['message'] = '';
                    } catch (\Exception $e) {
                        $this->respon['status'] = NG;
                        $this->respon['Exception']  = json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message ?? '';;
                        $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/employees/', $access_token, 'PUT', '400', $this->respon['Exception'] ?? '');
                        
                        array_push($data, [$employee_list['code'], $employee_list['lastName'], $this->respon['Exception']]);
                        
                    }
                } else {
                        try{
                           
                           $response = $http->post('https://api.kingtime.jp/v1.0/employees', [
                            'headers' => [
                                'Authorization' => 'Bearer ' . $access_token,
                                'Accept' => 'application/json',
                                // Thêm các header khác nếu cần
                            ],
                            'body' =>json_encode($employee_list,JSON_UNESCAPED_UNICODE),
                            ]);
                       
                            $this->setLog('', $url, $access_token, 'POST', '200', $data['errors'][0]['messages'][0] ?? '');
                           
                        } catch (\Exception $e) {
                            $this->respon['status'] = NG;
                            $this->respon['Exception']  = json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message??'';;
                            $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/employees/', $access_token, 'POST', '400', $this->respon['Exception'] ?? '');
                            if ($language == 'en') {
                                $data[0]['employee_cd'] = 'employee code';
                                $data[0]['employee_nm'] = 'employee name';
                                $data[0]['message'] = 'error';
                            }
                            array_push($data, [$employee_list['code'], $employee_list['lastName'], $this->respon['Exception']]);
                        }
                }
            }
            if (count($data) > 1) {
                $fileNameReturn  = $this->saveCSV_error($fileNameError,  $data);
                $this->respon['FileName'] = '/download/' . $fileNameReturn;
                $this->respon['status'] = 'ERR_CHECK';
                return response()->json($this->respon);
            }
            return response()->json($this->respon);
        }
        return response()->json($this->respon);
    }
    /**
     *  check Employee Exist in db
     * @author namnt
     * @created at 2024-10-29 07:46:26
     * @return void
     */
    public function checkExistsEmployee($employee_cd = '')
    {
        try {
            $http = new \GuzzleHttp\Client;
            $access_token = $this->api_service->getKotData(session_data()->company_cd, 0);
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
            ];
            $url = '';
            $employee_list = [];
            $data_api = $http->get('https://api.kingtime.jp/v1.0/employees/' . $employee_cd, [
                'headers' => $headers,
            ]);
            
            $data = json_decode($data_api->getBody(), true);
            $this->respon['key'] =  $data['key'] ?? '';
            $this->respon['API_status'] = OK;
            
        } catch (\Exception $e) {
            if($e->getResponse()->getStatusCode()==400) {
                $this->respon['key'] = '';
                $this->respon['API_status'] = OK;
            } else {
            $this->respon['API_status'] = NG;
            $this->respon['Exception']  = json_decode($e->getResponse()->getBody()->getContents())->errors[0]->message ?? '';;
            $this->setLog(session_data()->company_cd, 'https://api.kingtime.jp/v1.0/employees/', $access_token, 'GET', '400', $this->respon['Exception'] ?? '');
            }
        }
        return  $this->respon;
    }
}
