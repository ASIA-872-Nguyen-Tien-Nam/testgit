<?php

/**
 ****************************************************************************
 * MIRAI
 * I2020Controller
 *
 * 処理概要/process overview   : I2020Controller
 * 作成日/create date   : 2018-06-21 07:13:05
 * 作成者/creater    : namnb
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
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;

use File;
use Dao;
use Validator;
use Crypt;

class I2020Controller extends Controller
{
    /**
     * Show the application index.
     * @author namnb
     * @created at 2018-06-21 07:13:05
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       =   trans('messages.personnel_assessment');
        $data['category_icon']  =   'fa fa-line-chart';
        $data['title']          =   trans('messages.qualitative_evaluation_sheet');
        // get data from url query
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        //
        $reqs = [
            'fiscal_year'   => $redirect_param->fiscal_year ?? 0,
            'employee_cd'   => $redirect_param->employee_cd ?? '',
            'sheet_cd'  => $redirect_param->sheet_cd ?? 0,
            'from'  => $redirect_param->from ?? '',
            'from_source'  => $redirect_param->from_source ?? '',
        ];
        $validator = Validator::make($reqs, [
            'fiscal_year' => ['integer'],
            'sheet_cd' => ['integer'],
            'from'  => [
                'string',
                'required',
                Rule::in(['portal', 'dashboard', 'q2010', 'q2030', 'q0071', 'i2040', 'i2050', 'information', 'evaluator', 'm0070']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $params = [
            'fiscal_year'       => $reqs['fiscal_year'] ?? 0,
            'employee_cd_refer' => $reqs['employee_cd'] ?? '',
            'sheet_cd'          => $reqs['sheet_cd'] ?? 0,
            'company_cd'        => session_data()->company_cd ?? 0,
            'user_id'           => session_data()->user_id ?? '',
        ];
        // $data                   =   $params;
        $data['from']   =   htmlspecialchars($reqs['from']);
        $data['from_source']   =   htmlspecialchars($reqs['from_source']);
        ////////////////////////////////////////////////////
        $res = Dao::executeSql('SPC_I2020_INQ1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            // return 501 error
            return response()->view('errors.query', [], 501);
        } else {
            $data['fiscal_year']            = $params['fiscal_year'];
            $data['employee_cd_refer']      = $res[0][0]['employee_cd'] ?? '';
            $data['sheet_cd']               = $params['sheet_cd'];
            //
            $data['list']           =   $res[0][0] ?? [];
            $data['table']          =   $res[1] ?? [];
            $data['combobox']       =   $res[2] ?? [];
            $data['total']          =   $res[3][0] ?? [];
            $data['comment']        =   $res[4][0] ?? [];
            $data['point']          =   $res[5] ?? [];
            $data['button']         =   $res[6][0] ?? [];
            $data['ItemFLG']        =   $res[7][0] ?? NULL;
            $data['M0200']          =   $res[8][0] ?? NULL;
            $data['M0100']          =   $res[9][0] ?? NULL;
            $data['data10']         =   $res[10] ?? [];
            $data['data11']         =   $res[11] ?? [];
            // get 汎用 status
            $data['generic_comment_status1']                =   $res[8][0]['generic_comment_status1'] ?? 0;
            $data['generic_comment_status2']                =   $res[8][0]['generic_comment_status2'] ?? 0;
            $data['generic_comment_status3']                =   $res[8][0]['generic_comment_status3'] ?? 0;
            $data['generic_comment_status4']                =   $res[8][0]['generic_comment_status4'] ?? 0;
            $data['generic_comment_status5']                =   $res[8][0]['generic_comment_status5'] ?? 0;
            $data['generic_comment_status6']                =   $res[8][0]['generic_comment_status6'] ?? 0;
            $data['generic_comment_status7']                =   $res[8][0]['generic_comment_status7'] ?? 0;
            $data['generic_comment_status8']                =   $res[8][0]['generic_comment_status8'] ?? 0;
            $data['generic_comment_width']                  =   $res[8][0]['generic_comment_width'] ?? 0;
            //
            $data['weight_display_nm']                      =   $res[0][0]['weight_display_nm'] ?? '';
            $picture = isset($data['list']['picture']) ? $data['list']['picture'] : '';
            if (isset($data['list']['picture']) && !File::exists(public_path($picture))) {
                $data['list']['picture'] = '';
            }
            //
            if (isset($res[0][0]['sheet_nm']) && $res[0][0]['sheet_nm'] != '') {
                $data['screen_title'] = trans('messages.qualitative_evaluation_sheet') . '（' . $res[0][0]['sheet_nm'] . '）';
            } else {
                $data['screen_title'] = trans('messages.qualitative_evaluation_sheet');
            }
            return view('Master::i2020.index', $data);
        }
    }
    /**
     * Show the application index.
     * @author namnb
     * @created at 2018-06-21 07:13:05
     * @return void
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
                    $params['user_id']      =   session_data()->user_id ?? '';
                    //
                    $result = Dao::executeSql('SPC_I2020_ACT1', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        // return 501 error
                        return response()->view('errors.query', [], 501);
                        // $this->respon['status']     = EX;
                        // $this->respon['Exception']  = $result[0][0]['remark'];
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    $this->respon['alert_message'] = $result[1][0]['message_cd'] ?? 0;
                    $this->respon['status_cd'] = $result[2][0]['status_cd'] ?? 0;
                    $this->respon['employee_cd'] = $result[2][0]['employee_cd'] ?? '';
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
     * postComment
     * @author viettd
     * @created at 2020-10-09
     * @return void
     */
    public function postComment(Request $request)
    {
        if ($request->ajax()) {
            //return request ajax
            try {
                if ($this->respon['status'] == OK) {
                    $params['json']                 =   json_encode($request->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                    $params['cre_user']             =   session_data()->user_id;
                    $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']           =   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_I2020_ACT2', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    } else {
                        $this->respon['status'] = OK;
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
