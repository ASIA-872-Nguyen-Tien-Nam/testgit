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
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Master\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Carbon\Carbon;
use File;
use Dao;
use Session;

class M0001Controller extends Controller
{
    protected  $client_id = '';
    protected  $client_secret = '';
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-25 04:28:05
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.basic_master');
        $data['category_icon']  = 'fa fa-database';
        $data['title']          = trans('messages.customer_master');
        $data['library_data']   = getCombobox(2, 0);
        $data['library_sso']    = getCombobox(15, 0);
        $user_id                = session_data()->user_id;
        $cache                  = getCache('q0001', $user_id);
        $cache_api              = getCache('m0001_api', $user_id);
        $data_api = [];
        $from = $request->from ?? '';
        //  $html = htmlspecialchars_decode($cache_api['html']??'',ENT_QUOTES)??'';
        //  $html = htmlspecialchars_decode($html,ENT_QUOTES)??'';
        if ($cache_api) {
            deleteCache('m0001_api', $user_id);
            unset($cache_api['html']);
        }
        if ($cache) {
            $request->company_cd    = $request->company_cd ?? ($cache['company_cd_refer'] ?? '-1');
            deleteCache('q0001', $user_id, 'company_cd_refer');
            deleteCache('q0001', $user_id, 'company_cd');
        }
        $data['company_refer'] = $request->company_cd;
        // render view
        $right  = $this->getRightContent($request) ?? [];
        $left   = $this->getLeftContent($request) ?? [];
        if ((isset($left['error_typ']) && $left['error_typ'] == '999') || (isset($right['error_typ']) && $right['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        return view('Master::m0001.index', array_merge($data, $right, $left, $cache_api));
    }

    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $params = [
            'search_key' => SQLEscape($request->search_key) ?? '',
            'current_page' => $request->current_page ?? 1,
            'page_size' => $request->page_size ?? 10,
            'company_cd' => session_data()->company_cd ?? 1, // set for demo
        ];
        $data = $params;
        $rules = [
            'current_page' => 'integer', //Must be a number
            'page_size' => 'integer', //Must be a number
        ];
        $validator = Validator::make($params, $rules);
        if (!validateCommandOS($request->search_key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
        if ($validator->passes()) {
            $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
            $res = Dao::executeSql('SPC_M0001_LST1', $params);
            $data['list'] = $res[0] ?? [];
            $data['paging'] = $res[1][0] ?? [];
            // render view
            if ($request->ajax()) return view('Master::m0001.leftcontent', $data);
            else return $data;
            if ($request->ajax()) {
                if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                return view('Master::m0001.leftcontent', $data);
            } else {
                if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                    return array('error_typ' => '999');
                }
                return $data;
            }
        } else {
            if ($request->ajax()) {
                return response()->view('errors.query', [], 501);
            } else {
                return array('error_typ' => '999');
            }
        }
    }

    /**
     * get right content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {

        // if ( $request->ajax() )
        // {
        $params = [
            'company_cd' => $request->company_cd ?? '-1',
        ];
        $rules = [
            'company_cd' => 'integer', //Must be a number
        ];
        $validator = Validator::make($params, $rules);
        if ($validator->passes()) {
            $rows = Dao::executeSql('SPC_M0001_INQ1', $params);
            $data['row1'] = $rows[0][0] ?? [];
            $data['row2'] = $rows[1] ?? [];
            $data['row3'] = $rows[2] ?? [];
            $data['row4'] = $rows[3][0] ?? [];
            $data['library_data']  = getCombobox(2, 0);
            $data['library_sso']    = getCombobox(15, 0);
            // render view
            if ($request->ajax()) {
                if (isset($rows[0][0]['error_typ']) && $rows[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                return view('Master::m0001.rightcontent', $data)->render();
            } else {
                if (isset($rows[0][0]['error_typ']) && $rows[0][0]['error_typ'] == '999') {
                    return array('error_typ' => '999');
                }
                return $data;
            }
        } else {
            if ($request->ajax()) {
                return response()->view('errors.query', [], 501);
            } else {
                return array('error_typ' => '999');
            }
        }
        // }
    }
    /**
     * Save data
     * @author namnb
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $sso_use_typ = $request->json()->all()['data_sql']['SSO_use_typ'];
                if ($sso_use_typ == 1) {
                    $this->rules = [
                        '#sp_NameIDFormat'          => 'required',
                        '#sp_x509cert'              => 'required',
                        '#sp_entityId'              => 'required',
                        '#sp_singleLogoutService'   => 'required',
                        '#idp_entityId'             => 'required',
                        '#idp_singleSignOnService'  => 'required',
                        '#idp_singleLogoutService'  => 'required',
                        '#idp_x509cert'             => 'required'
                    ];
                }
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $result = Dao::executeSql('SPC_M0001_ACT1', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    } else {
                        // unset($this->respon['data_sql']);
                        $data = json_decode($params['json']);
                        if ($data->SSO_use_typ ?? 0 == 1) {
                            //create new file config
                            $this->writeConfigFile($data, 'New');
                            //update udp_id to saml2_setting.php
                            $this->writeConfigFile($data, 'Change');
                        }
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
        return 'Silent is golden.';
    }

    /**
     * Delete data
     * @author namnb
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                // $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $company_cd             =   $request->company_cd ?? 0;
                    $params['company_cd']   =    $company_cd;
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $result = Dao::executeSql('SPC_M0001_ACT2', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    writeConfigFileAPI('REMOVE', $company_cd);
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
        return 'Silent is golden.';
    }
    /**
     * Show the application index.
     * @author longvv
     * @created at 2018-06-25 07:46:26
     * @return void
     */
    public function popup(Request $request, $company_cd = '', $sso_use_typ = '')
    {
        $params = [
            'company_cd' => $company_cd ?? 0,
        ];
        $validator = Validator::make($params, [
            'company_cd'     =>  'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $result =   Dao::executeSql('SPC_M0001_INQ2', $params);
        //
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['title']          =   trans('messages.user_created');
        $data['company_cd']     =   $company_cd ?? 0;
        $data['sso_use_typ']    =   $sso_use_typ ?? 0;
        $data['data']           =   $result[0][0] ?? [];
        //
        return view('Master::m0001.popup', $data);
    }
    /**
     * Save data
     * @author longvv
     * @created at 2019-09-05
     * @return \Illuminate\Http\Response
     */
    public function postSavepopup(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $result = Dao::executeSql('SPC_M0001_ACT3', $params);
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
        return 'Silent is golden.';
    }

    /**
     * writeConfigFile
     *
     * @param  mixed $data
     * @param  mixed $mode
     * @return void
     */
    public function writeConfigFile($data = [], $mode = '')
    {
        $contract_cd = $data->contract_cd ?? 'test';
        if ($contract_cd == '') {
            $contract_cd = 'test';
        }
        $temp = config('saml2_settings');
        if (!empty($temp)) {
            if ($mode == 'New') {
                $temp['sp']['NameIDFormat']           = $data->sp_NameIDFormat;
                $temp['sp']['x509cert']               = preg_replace("/\r|\n/", "", $data->sp_x509cert);
                $temp['sp']['privateKey']             = $data->sp_privateKey;
                $temp['sp']['entityId']               = $data->sp_entityId;
                $temp['sp']['singleLogoutService']['url']    = $data->sp_singleLogoutService;
                $temp['idp']['entityId']               = $data->idp_entityId;
                $temp['idp']['singleSignOnService']['url']    = $data->idp_singleSignOnService;
                $temp['idp']['singleLogoutService']['url']    = $data->idp_singleLogoutService;
                $temp['idp']['x509cert']               = preg_replace("/\r|\n/", "", $data->idp_x509cert);
            } else if ($mode == 'Change') {
                if (!in_array($contract_cd, $temp['idpNames'])) {
                    array_unshift($temp['idpNames'], $contract_cd);
                }
                // $temp['idpNames']               = $data->sp_NameIDFormat;
            }
            $final_str = '';
            foreach ($temp as $key => $value) {
                if (gettype($value) != 'array') {
                    $final_str .= "\t'" . $key . "'=>" . "'" . $value . "',\n";
                } else if ((gettype($value) == 'array')) {
                    $str = '';
                    foreach ($value as $ke => $vl) {
                        if (gettype($vl) != 'array') {
                            if ($vl == '1' && $key != 'idpNames') {
                                $str .= "\t\t'" . $ke . "'=>true,\n";
                            } else if ($vl =='0' && $key != 'idpNames') {
                                $str .= "\t\t'" . $ke . "'=>false,\n";
                            } else {
                                $str .= "\t\t'" . $ke . "'=>'" . $vl . "',\n";
                            }
                        } else {
                            $str2 = '';
                            foreach ($vl as $k => $v) {
                                $str2 .= "\t\t\t'" . $k . "'=>'" . $v . "',\n";
                            }
                            $str .= "\t\t'" . $ke . "'=>array(\n" . $str2 . "\t\t" . '),' . "\n";
                        }
                    };
                    $final_str .= "\t'" . $key . "'=>array(\n" . $str . "\t),\n";
                }
            }
            // $dir = config_path('saml2_settings.php');
            // if(!file_exists($dir)){
            //     mkdir ($dir, 0744);
            // }
            if ($mode == 'New') {
                // if file exists
                if (file_exists(config_path('saml2_' . $contract_cd . '_settings.php'))) {
                    // if file can write
                    if (is_writable(config_path('saml2_' . $contract_cd . '_settings.php'))) {
                        $fp = fopen(config_path('saml2_' . $contract_cd . '_settings.php'), 'w');
                        $this->writeFileContent($fp, $final_str);
                    }
                } else {
                    $fp = fopen(config_path('saml2_' . $contract_cd . '_settings.php'), 'w');
                    $this->writeFileContent($fp, $final_str);
                }
            } else if ($mode == 'Change') {
                // if file can write
                if (is_writable(config_path('saml2_settings.php'))) {
                    $fp = fopen(config_path('saml2_settings.php'), 'w');
                    $this->writeFileContent($fp, $final_str);
                }
            }
        }
        //         fwrite($fp,'<?php
        // //This is variable is an example - Just make sure that the urls in the "idp" config are ok.
        // $idp_host = "https://idp.ssocircle.com:443";
        // $idp_config = include("sso_idp.php");
        // $idp_nm = $idp_config["idp_url"];
        // return $settings = array('."\n".$final_str.');');
        //         fclose($fp);
    }

    /**
     * writeFileContent
     *
     * @param  mixed $fp
     * @param  mixed $final_str
     * @return void
     */
    public function writeFileContent($fp, $final_str)
    {
        fwrite($fp, '<?php
//This is variable is an example - Just make sure that the urls in the "idp" config are ok.
$idp_host = "https://idp.ssocircle.com:443";
$idp_config = include("sso_idp.php");
$idp_nm = $idp_config["idp_url"];
return $settings = array(' . "\n" . $final_str . ');');
        fclose($fp);
    }
}
