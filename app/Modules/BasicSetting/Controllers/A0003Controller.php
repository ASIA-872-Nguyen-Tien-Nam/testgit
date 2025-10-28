<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0001Controller
 *
 * 処理概要/process overview   : M0001Controller
 * 作成日/create date   : 2018-06-25 04:28:05
 * 作成者/creater    : viettd
 *
 * 更新日/update date    :
 * 更新者/updater    :
 * 更新内容 /update content  :
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
use Dao;
class A0003Controller extends Controller
{
    public  $client_id;
    public  $client_secret;
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-25 04:28:05
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.home');
        $data['category_icon']  = 'fa fa-home';
        $data['title']          = trans('messages.api_linkage');
        $data['library_data']   = getCombobox(2, 0);
        $data['library_sso']    = getCombobox(15, 0);
        $user_id                = session_data()->user_id;
        $cache                  = getCache('q0001', $user_id);
        $cache_api              = getCache('a0003_api', $user_id);
        $data_api = [];
        //  $html = htmlspecialchars_decode($cache_api['html']??'',ENT_QUOTES)??'';
        //  $html = htmlspecialchars_decode($html,ENT_QUOTES)??'';
        $params = array('company_cd' => session_data()->company_cd);
        $rows = Dao::executeSql('SPC_M0001_INQ1', $params);
        $data['row1'] = $rows[0][0] ?? [];
        if ($cache_api) {
            deleteCache('a0003_api', $user_id);
            unset($cache_api['html']);
        }
        if ($cache) {
            $request->company_cd    = $request->company_cd ?? ($cache['company_cd_refer'] ?? '');
            deleteCache('q0001', $user_id, 'company_cd_refer');
        }

        $data['company_refer'] = $request->company_cd;
        return view('BasicSetting::a0003.index', array_merge($data, $cache_api));
    }

    /**
     * Save data
     * @author namnb
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        try {
            $this->valid($request);
            if ($this->respon['status'] == OK) {
                $params['company_cd']   =   session_data()->company_cd;
                $params['json']         =   $this->respon['data_sql'];
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $result = Dao::executeSql('SPC_A0003_ACT1', $params);
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

    /**
     * Save data
     * @author namnb
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function popup(Request $request)
    {
        $company_cd     = session_data()->company_cd;
        $data_api       = session($company_cd . 'api');
        session()->forget($company_cd . 'api');
        return view('BasicSetting::a0003.popup', ['data' => $data_api]);
    }
    /**
     * Save data
     * @author namnbp
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function writeConfig(Request $request)
    {
        $company_cd     = session_data()->company_cd;
        $api_office_cd  = $request->api_office_cd;
        writeConfigFileAPI('A0003P', $company_cd, '', '', $api_office_cd);
    }
    /**
     * call authorize king of time
     * @author namnt
     * @created at 2024-10-29
     * @return \Illuminate\Http\Response
     */
    public function callRedirectKOT()
    {
        if ($this->respon['status'] == OK) {
            $params['company_cd']   =   session_data()->company_cd;
            $params['json']         =   json_encode(getCache('a0003_kot', session_data()->user_id));
            $params['cre_user']     =   session_data()->user_id;
            $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_A0003_ACT1', $params);
            session(['client_id' => $result[1][0]['client_id'] ?? '']);
            session(['client_secret' => $result[1][0]['client_secret'] ?? '']);
            $this->client_id = $result[1][0]['client_id'] ?? '';
            $this->client_secret = $result[1][0]['client_secret'] ?? '';
            // check exception
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
        }
        $query = http_build_query([
            'response_type' => 'code',
            'client_id' => $this->client_id, //gắn tạm
            'redirect_uri' => env('KOT_REDIRECT_URI'),
            'state' => csrf_token(),
            'response_type' => 'code',
            'response_mode' => 'form_post',
        ]);
        $authorizationUrl = 'https://api.kingtime.jp/connect/kot/authorize' . '?' . $query;
        return redirect($authorizationUrl);
    }
    /**
     * callback from kot
     * @author namnt
     * @created at 2024-10-29
     * @return \Illuminate\Http\Response
     */
    public function handleProviderCallback(Request $request)
    {
        $http                   = new \GuzzleHttp\Client;
        $response = $http->post('https://api.kingtime.jp/connect/kot/token', [
            'form_params' => [
                'grant_type'    => 'authorization_code',
                'client_id'     => session()->get('client_id'),
                'client_secret' => session()->get('client_secret'),
                'redirect_uri'  => env('KOT_REDIRECT_URI'),
                'code'          => $request->code,
            ],
        ]);

        $data_respone =  json_decode($response->getBody(), true);
        $params['company_cd']   =   session_data()->company_cd;
        $params['access_token'] =   $data_respone['access_token'];
        $params['refresh_token'] =   null;
        $params['effective_date'] =   null;
        $params['status'] =   0;
        $params['cre_user']     =   session_data()->user_id;
        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
        $result = Dao::executeSql('SPC_A0003_ACT2', $params);
        if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        session(['access_token' => $data_respone['access_token'] ?? '']);
        return redirect('/basicsetting/a0003');
    }
}
