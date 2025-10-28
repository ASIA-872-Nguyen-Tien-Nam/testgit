<?php

/**
 ****************************************************************************
 * MIRAI
 * DashboardController
 *
 * 処理概要/process overview   : DashboardController
 * 作成日/create date   : 2018-06-26 03:53:04
 * 作成者/creater    : mail@gmail.com
 *
 * 更新日/update date    :
 * 更新者/updater    :
 * 更新内容 /update content  :
 *
 *
 * @package         :  Dashboard
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\Dashboard\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use Illuminate\Validation\Rule;

class DashboardController extends Controller
{
    /**
     * Show the application index.
     * @author mail@gmail.com
     * @created at 2018-06-26 03:53:04
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $reqs = [
            'from'  => $request->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $user_id                       =     session_data()->user_id;
        if ($reqs['from'] == 'i2010') {
            $cache  =   getCache('dashboard_i2010', $user_id);
            deleteCache('dashboard_i2010', $user_id);
        }else if($reqs['from'] == 'i2020'){
            $cache  =   getCache('dashboard_i2020', $user_id);
            deleteCache('dashboard_i2020', $user_id);
        }
        $data['select_period']         =   0;
        $data['select_category_typ']   =   0;

        if (isset($cache) && !empty($cache)) {
            $data['sheet_cd_refer']     = $cache['sheet_cd'] ?? 0;
            $data['fiscal_year']        = $cache['fiscal_year'] ?? 0;
            $param1 = [
                'select_period'         =>      $cache['select_period'] ?? 0,
                'select_category_typ'   =>      $cache['select_category_typ'] ?? 0,
                'company_cd'            =>      session_data()->company_cd ?? '',
                'fiscal_year'           =>     $cache['fiscal_year'] ?? 0,
                'user_id'               =>      session_data()->user_id,
            ];
            $result1                =   Dao::executeSql('SPC_DASHBOARD_FND1', $param1);
            $data['list_status']    =   $result1[0] ?? [];

            //
            $param2 = [
                'status_cd'             =>      $cache['status_cd'] ?? 0,
                'select_period'         =>      $cache['select_period'] ?? 0,
                'select_category_typ'   =>      $cache['select_category_typ'] ?? 0,
                'company_cd'            =>      session_data()->company_cd ?? '',
                'fiscal_year'           =>      $cache['fiscal_year'] ?? 0,
                'user_id'               =>      session_data()->user_id,
            ];
            $result2                =   Dao::executeSql('SPC_DASHBOARD_FND2', $param2);
            $data['status']         =   $result2[0][0] ?? [];
            $data['listemployee']   =   $result2[1] ?? [];
            //
            $data['select_period']          =   $cache['select_period'] ?? 0;
            $data['select_category_typ']    =   $cache['select_category_typ'] ?? 0;
            if ((isset($result1[0][0]['error_typ']) && $result1[0][0]['error_typ'] == '999')
            || (isset($result2[0][0]['error_typ']) && $result2[0][0]['error_typ'] == '999')) {
                return response()->view('errors.query', [], 501);
            }
        }

        //  call
        $params = [
            'company_cd'            =>  session_data()->company_cd ?? '',
            'employee_cd'           =>  session_data()->employee_cd ?? '',
            'user_id'               =>  session_data()->user_id
        ];
        $res   =   Dao::executeSql('SPC_DASHBOARD_INQ1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }

        $data['list_period']        =   $res[0] ?? [];
        $data['list_status']        =   $res[1] ?? [];
        $data['list_infomation']    =   $res[2] ?? [];
        $data['employee_login_typ'] =   $res[3][0]['employee_login_typ'] ?? 1;
        $data['fiscal_year']        =   $res[4][0]['fiscal_year'];
        $data['title']              =   isset($res[3][0]['company_nm']) ? $res[3][0]['company_nm'] . trans('messages.mail_looks') : trans('messages.miraic');
        $data['home_flg']           =   '1';
        $m0022 = getCombobox('M0022', 1);
        $m0020 = getCombobox('M0020', 1);
        $data['m0022'] = $m0022 ?? [];
        $data['m0020'] = $m0020 ?? [];
        $data['F0010'] = getCombobox('f0010', 1) ?? [];
        $data['authority_typ']       =   session_data()->authority_typ;

        return view('Dashboard::dashboard.index', $data);
    }

    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function liststatus(Request $request)
    {
        $params = [
            'select_period'         => $request->ajax() ? ($request->select_period ?? 0) : 0,
            'select_category_typ'   => $request->ajax() ? ($request->select_category_typ ?? 0) : 0,  // 0:目標、1:定性評価
            'company_cd'            => session_data()->company_cd ?? '',
            'fiscal_year'           => $request->ajax() ? ($request->fiscal_year ?? 0) : 0,
            'user_id'               =>  session_data()->user_id,
            'organization_cd'       =>   $request->ajax() ? ($request->organization_cd ?? '') : '',
        ];
        $res                        =   Dao::executeSql('SPC_DASHBOARD_FND1', $params);
        $data['list_status']        =   $res[0] ?? [];
        // render view
        if ($request->ajax()) {
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            return view('Dashboard::dashboard.liststatus', $data)->render();
        } else {
            return $data;
        }
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function listemployee(Request $request)
    {
        $params = [
            'status_cd'                 =>  $request->ajax() ? ($request->status_cd ?? 0) : 0,
            'select_period'             =>  $request->ajax() ? ($request->select_period ?? 0) : 0,
            'select_category_typ'       =>  $request->ajax() ? ($request->select_category_typ ?? 0) : 0, // 0:目標、1:定性評価
            'company_cd'                =>  session_data()->company_cd ?? '',
            'fiscal_year'               =>  $request->ajax() ? ($request->fiscal_year ?? 0) : 0,
            'user_id'                   =>  session_data()->user_id,
            'organization_cd'           =>  $request->ajax() ? ($request->organization_cd ?? '') : '',
        ];
        $res                        =   Dao::executeSql('SPC_DASHBOARD_FND2', $params);
        $data['status']                =   $res[0][0] ?? [];
        $data['listemployee']       =   $res[1] ?? [];
        $m0022 = getCombobox('M0022', 1);
        $m0020 = getCombobox('M0020', 1);
        $data['m0022'] = $m0022 ?? [];
        $data['m0020'] = $m0020 ?? [];
        $data['company_cd'] = session_data()->company_cd ?? '';
        // render view
        if ($request->ajax()) {
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            return view('Dashboard::dashboard.listemployee', $data)->render();
        } else return $data;
    }
    /**
     * Show the application index.
     * @author datnt@ans-asia.com 
     * @created at 2018-06-22 06:22:17
     * @return void
     */
    public function updateauthority(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['authority_typ']    =   $request->authority_typ;
                $params['cre_user']         =   session_data()->user_id;
                $params['cre_ip']           =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']       =   session_data()->company_cd;
                //
                $result = Dao::executeSql('SPC_DASHBOARD_ACT1', $params);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($result[0]) && !empty($result[0])) {
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
                    }
                }else{
                    $login                      = new \stdClass();
                    $login = session(AUTHORITY_KEY);
                    $login->authority_typ = "6";
                    session([AUTHORITY_KEY => $login]);
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
}
