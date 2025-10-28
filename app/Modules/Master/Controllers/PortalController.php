<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * PortalController
 *
 * 処理概要/process overview   : PortalController
 * 作成日/create date   : 2018-06-25 03:08:53
 * 作成者/creater    : mail@ans-asia.com
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
use Carbon\Carbon;
use Dao;
use Validator;
use Illuminate\Validation\Rule;

class PortalController extends Controller
{
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('messages.portal_page');
        $data['home_flg'] = '1';
        $reqs = [
            'from'  => $request->from ?? '',
            'fiscal_year' => $request->fiscal_year ?? 0,
        ];
        $validator = Validator::make($reqs, [
            'fiscal_year' => ['integer'],
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $now = Carbon::now();
        $current_year = $now->year;
        $fiscal_year = $request->fiscal_year ?? $current_year;
        $params = [
            'fiscal_year'           =>  $fiscal_year,
            'company_cd'            =>  session_data()->company_cd ?? '',
            'user_id'               =>  session_data()->user_id ?? '',
            'evaluation_typ'        =>  -1,
            'evaluation_stage'      =>  -1,
            'period'                =>  -1,
        ];
        $params['belong_cd_1'] = '';
        $params['belong_cd_2'] = '';
        $params['belong_cd_3'] = '';
        $res =   Dao::executeSql('SPC_PORTAL_INQ2', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list_fiscal_year']   =   $res[0] ?? [];
        $data['list_status']        =   $res[1] ?? [];
        $data['list_infomation']    =   $res[2] ?? [];
        $data['current_year']       =   $res[3][0]['current_year'] ?? NULL;
        $data['list_employee']      =   $res[4] ?? [];
        $data['M0022']              =   getCombobox('M0022', 1) ?? [];
		$data['M0020']              =   getCombobox('M0020', 1) ?? [];
        $data['M0101']              =   getCombobox('M0101',1); 
        $data['evaluation_typ']     =   $res[5]['evaluation_typ'] ?? -1;
        return view('Master::portal.index', $data);
    }

    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function indexRefer(Request $request)
    {
        $params = [
            'fiscal_year'           => $request->ajax() ? $request->fiscal_year ?? '1900' : '1900',
            'company_cd'            => session_data()->company_cd ?? '',
            'user_id'               => session_data()->user_id ?? '',
            'evaluation_typ'        => $request->ajax() ? $request->evaluation_typ ?? -1:-1,
            'evaluation_stage'      => $request->ajax() ? $request->evaluation_stage ??  -1:-1,
            'period'                => $request->ajax() ? $request->period ?? -1:-1,
        ];
        $rules = [
            'fiscal_year' => 'integer', //Must be a number
        ];
        $mode = $request->mode ?? 0;
        $json_array = [];
        $json_array['list_organization_step1'] = ($request->organization_cd)['list_organization_step1'] ?? [];
        $json_array['list_organization_step2'] = ($request->organization_cd)['list_organization_step2'] ?? [];
        $json_array['list_organization_step3'] = ($request->organization_cd)['list_organization_step3'] ?? [];
        $json_array['list_organization_step4'] = ($request->organization_cd)['list_organization_step4'] ?? [];
        $json_array['list_organization_step5'] = ($request->organization_cd)['list_organization_step5'] ?? [];
        $json = json_encode($json_array, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $params['belong_cd_1'] =  $request->ajax() ? $request->organization_cd_1 ??  -1:-1;
        $params['belong_cd_2'] =  $request->ajax() ? $request->organization_cd_2 ??  -1:-1;
        $params['belong_cd_3'] =  $request->ajax() ? $request->organization_cd_3 ??  -1:-1;
        $validator = Validator::make($params, $rules);
        if ($validator->passes()) {
            $res                        =   Dao::executeSql('SPC_PORTAL_INQ2', $params);
            $data['list_fiscal_year']   =   $res[0] ?? [];
            $data['list_status']        =   $res[1] ?? [];
            $data['list_infomation']    =   $res[2] ?? [];
            $data['current_year']       =   $res[3][0]['current_year'] ?? NULL;
            $data['list_employee']      =   $res[4] ?? [];
            $data['evaluation_typ']     =   $res[5][0]['evaluation_typ'] ?? -1;
            if($mode == 1) {
                $data['evaluation_stage']   =   $res[5][0]['evaluation_stage'] ?? -1;
            }
            $data['M0022'] = getCombobox('M0022', 1) ?? [];
		    $data['M0020'] = getCombobox('M0020', 1) ?? [];
            $data['M0101']              =   getCombobox('M0101',1); 
            $data['evaluation_stage_option']   =   $res[6] ?? [];
            // render view
            if ($request->ajax()) {
                if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                if($mode == 0) {
                    return view('Master::portal.indexRefer', $data)->render();
                } else{
                    return view('Master::portal.sheet', $data)->render();
                }
            } else {
                return $data;
            }
        } else {
            return response()->view('errors.query', [], 501);
        }
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function getEvaluator(Request $request)
    {
        $data['title'] = trans('messages.portal_page');
        $from                       =   $request->from;
        $data['button_active']      =   (isset($from) && $from == "dashboard") || (session_data()->authority_typ != 1) ? 'active' : '';
        $data['home_flg']           =   '1';
        $user_id                    =   session_data()->user_id;
        $cache                      =   getCache('evaluator', $user_id);
        if ($cache) {
            $request->fiscal_year   =   isset($cache['fiscal_year']) ? $cache['fiscal_year'] : '0';
        }
        $params = [
            'fiscal_year'           =>  $request->fiscal_year ?? '0',
            'company_cd'            =>  session_data()->company_cd ?? '',
            'user_id'               =>  session_data()->user_id ?? '',
        ];
        $rules = [
            'fiscal_year' => 'integer', //Must be a number
        ];
        $validator = Validator::make($params, $rules);
        if ($validator->passes()) {
            $res                        =   Dao::executeSql('SPC_PORTAL_INQ1', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $data['list_fiscal_year']   =   $res[0] ?? [];
            $data['list_status']        =   $res[1] ?? [];
            $data['list_infomation']    =   $res[2] ?? [];
            $data['current_year']       =   $res[3][0]['current_year'] ?? NULL;
            $data['screen_from2']       =   htmlspecialchars($from) ?? '';
            return view('Master::portal.evaluator', $data);
        } else {
            return response()->view('errors.query', [], 501);
        }
    }

    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2018-06-25 03:08:53
     * @return \Illuminate\Http\Response
     */
    public function evaluatorRefer(Request $request)
    {
        $params = [
            'fiscal_year'           => $request->ajax() ? $request->fiscal_year ?? '1900' : '1900',
            'company_cd'            => session_data()->company_cd ?? '',
            'user_id'               => session_data()->user_id ?? '',
        ];
        $rules = [
            'fiscal_year' => 'integer', //Must be a number
        ];
        $validator = Validator::make($params, $rules);
        if ($validator->passes()) {
            $res                        =   Dao::executeSql('SPC_PORTAL_INQ1', $params);
            $data['list_fiscal_year']   =   $res[0] ?? [];
            $data['list_status']        =   $res[1] ?? [];
            $data['list_infomation']    =   $res[2] ?? [];
            $data['current_year']       =   $res[3][0]['current_year'] ?? NULL;
            // render view
            if ($request->ajax()) {
                if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                return view('Master::portal.EvaluatorRefer', $data)->render();
            } else {
                return $data;
            }
        } else {
            return response()->view('errors.query', [], 501);
        }
    }
}
