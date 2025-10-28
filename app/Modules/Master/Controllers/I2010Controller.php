<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * I2010Controller
 *
 * 処理概要/process overview   : I2010Controller
 * 作成日/create date          : 2018-06-22 10:48:39
 * 作成者/creater              : mail@ans-asia.com
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
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\View;

use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;
use File;
use Dao;
use Validator;
use Crypt;

class I2010Controller extends Controller
{
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2018-06-22 10:48:39
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.personnel_assessment');
        $data['category_icon'] = 'fa fa-line-chart';
        $data['title'] = trans('messages.goal_management_sheet');
        $data['M0022']  =   getCombobox('M0022', 1);
        // get data from url query
        $redirect_param = $request->redirect_param ?? '';
        if($redirect_param != ''){
            try{
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            }catch(DecryptException $e){
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
                Rule::in(['portal', 'dashboard', 'q2010', 'q2030', 'q0071', 'i2040', 'i2050','information','evaluator','m0070']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        //
        $params['fiscal_year']          = $reqs['fiscal_year'] ?? 0;
        $params['sheet_cd']             = $reqs['sheet_cd'] ?? 0;
        $params['employee_cd']          = $reqs['employee_cd'] ?? '';
        $params['login_employee_cd']    = session_data()->employee_cd;
        $params['cre_user']             = session_data()->user_id;
        $params['company_cd']           = session_data()->company_cd;
        //
        $result = Dao::executeSql('SPC_I2010_INQ1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            // return 501 error
            return response()->view('errors.query', [], 501);
        } else {
            // check picture
            if (isset($result[1][0]['picture']) && !File::exists(public_path($result[1][0]['picture']))) {
                $result[1][0]['picture'] = '';
            }
            $data['authority_typ']  = session_data()->authority_typ ?? 0;
            $data['from']  = htmlspecialchars($reqs['from']);
            $data['from_source']  = htmlspecialchars($reqs['from_source']);
            //
            $data['data0']  =   $result[0][0] ?? [];
            $data['data1']  =   $result[1][0] ?? [];
            $data['data2']  =   $result[2][0] ?? [];
            $data['data3']  =   $result[3]  ?? [];
            $data['data4']  =   $result[4][0] ?? [];
            $data['data5']  =   $result[5] ?? [];
            $data['data6']  =   $result[6] ?? [];
            $data['data7']  =   $result[7] ?? [];
            $data['data8']  =   $result[8] ?? [];
            $data['data9']  =   $result[9] ?? [];
            // $data['data10'] =   $result[10] ?? [];

            // get 汎用 status
            $data['generic_comment_status1']                =   $result[2][0]['generic_comment_status1'] ?? 0;
            $data['generic_comment_status2']                =   $result[2][0]['generic_comment_status2'] ?? 0;
            $data['generic_comment_status3']                =   $result[2][0]['generic_comment_status3'] ?? 0;
            $data['generic_comment_status4']                =   $result[2][0]['generic_comment_status4'] ?? 0;
            $data['generic_comment_status5']                =   $result[2][0]['generic_comment_status5'] ?? 0;
            $data['generic_comment_status6']                =   $result[2][0]['generic_comment_status6'] ?? 0;
            $data['generic_comment_status7']                =   $result[2][0]['generic_comment_status7'] ?? 0;
            $data['generic_comment_status8']                =   $result[2][0]['generic_comment_status8'] ?? 0;
            $data['generic_comment_width']                  =   $result[2][0]['generic_comment_width'] ?? 0;
            // get 評価シート入力
            $data['goal_number']                            =   $result[2][0]['goal_number'] ?? 0;
            $data['item_title_status']                      =   $result[2][0]['item_title_status'] ?? 0;
            $data['item_display_status_1']                  =   $result[2][0]['item_display_status_1'] ?? 0;
            $data['item_display_status_2']                  =   $result[2][0]['item_display_status_2'] ?? 0;
            $data['item_display_status_3']                  =   $result[2][0]['item_display_status_3'] ?? 0;
            $data['item_display_status_4']                  =   $result[2][0]['item_display_status_4'] ?? 0;
            $data['item_display_status_5']                  =   $result[2][0]['item_display_status_5'] ?? 0;
            $data['weight_display_status']                  =   $result[2][0]['weight_display_status'] ?? 0;
            $data['weight_display_nm']                      =   $result[2][0]['weight_display_nm'] ?? '';
            $data['challenge_level_display_status']         =   $result[2][0]['challenge_level_display_status'] ?? 0;
            $data['detail_self_progress_comment_display_status'] =   $result[2][0]['detail_self_progress_comment_display_status'] ?? 0;
            $data['detail_progress_comment_display_status'] =   $result[2][0]['detail_progress_comment_display_status'] ?? 0;
            $data['progress_comment_display_status']        =   $result[2][0]['progress_comment_display_status'] ?? 0;
            $data['progress_comment_display_status1']       =   $result[2][0]['progress_comment_display_status1'] ?? 0;
            $data['progress_comment_display_status2']       =   $result[2][0]['progress_comment_display_status2'] ?? 0;
            $data['progress_comment_display_status3']       =   $result[2][0]['progress_comment_display_status3'] ?? 0;
            $data['progress_comment_display_status4']       =   $result[2][0]['progress_comment_display_status4'] ?? 0;
            $data['detail_comment_display_status1']          =   $result[2][0]['detail_comment_display_status1'] ?? 0;
            $data['detail_comment_display_status2']          =   $result[2][0]['detail_comment_display_status2'] ?? 0;
            $data['detail_comment_display_status3']          =   $result[2][0]['detail_comment_display_status3'] ?? 0;
            $data['detail_comment_display_status4']          =   $result[2][0]['detail_comment_display_status4'] ?? 0;
            $data['detail_myself_comment_display_status']   =   $result[2][0]['detail_myself_comment_display_status'] ?? 0;
            //
            $data['evaluation_display_status0']             =   $result[2][0]['evaluation_display_status0'] ?? 0;
            $data['evaluation_display_status1']             =   $result[2][0]['evaluation_display_status1'] ?? 0;
            $data['evaluation_display_status2']             =   $result[2][0]['evaluation_display_status2'] ?? 0;
            $data['evaluation_display_status3']             =   $result[2][0]['evaluation_display_status3'] ?? 0;
            $data['evaluation_display_status4']             =   $result[2][0]['evaluation_display_status4'] ?? 0;
            $data['total_score_display_status']             =   $result[2][0]['total_score_display_status'] ?? 0;
            //
            $data['point_criteria_display_status']          =   $result[2][0]['point_criteria_display_status'] ?? 0;
            $data['challengelevel_criteria_display_status'] =   $result[2][0]['challengelevel_criteria_display_status'] ?? 0;
            $data['self_assessment_comment_display_status'] =   $result[2][0]['self_assessment_comment_display_status'] ?? 0;
            $data['evaluation_comment_display_status']      =   $result[2][0]['evaluation_comment_display_status'] ?? 0;
            // view data
            if (isset($result[1][0]) && $result[1][0]['sheet_nm'] != '') {
                $data['screen_title'] = trans('messages.goal_management_sheet') . '（' . $result[1][0]['sheet_nm'] . '）';
            } else {
                $data['screen_title'] = trans('messages.goal_management_sheet');
            }
            //
            return view('Master::i2010.index', $data);
        }
    }
    /**
     * Show the application index.
     * @author namnb
     * @created at 2018-06-21 07:13:05
     * @return \Illuminate\Http\Response
     */
    public function getInterview(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'stt' => 'integer'
        ]);
        if ($validator->fails()) {
            return response()->json('Error', 501);
        } else {
            $stt  = Input::get('stt', 1);
            $data['title'] = trans('messages.interview_record');
            if (!View::exists('Master::i2010.interview.stt' . $stt)) {
                return view('Master::i2010.interview.stt', $data);
            }
            return view('Master::i2010.interview.stt' . $stt, $data);
        }
    }

    /**
     * Show the application index.
     * @author namnb
     * @created at 2018-06-21 07:13:05
     * @return \Illuminate\Http\Response
     */
    public function getRate(Request $request)
    {
        $data['title'] = trans('messages.goal_management_sheet');
        return view('Master::i2010.rate', $data);
    }
    /**
     * save
     * @author viettd
     * @created at 2018-09-17
     * @return void
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            //return request ajax
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']                 =   $this->respon['data_sql'];
                    $params['login_employee_cd']    =   session_data()->employee_cd;
                    $params['cre_user']             =   session_data()->user_id;
                    $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']           =   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_I2010_ACT1', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        // $this->respon['status']     = EX;
                        // $this->respon['Exception']  = $result[0][0]['remark'];
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    } else {
                        $this->respon['status'] = OK;
                        $this->respon['alert_message'] = $result[1][0]['message_cd'] ?? 0;
                        $this->respon['status_cd'] = $result[2][0]['status_cd'] ?? 0;
                        $this->respon['employee_cd'] = $result[2][0]['employee_cd'] ?? '';
                        $this->respon['target_employee_cd'] = $result[2][0]['target_employee_cd'] ?? '';
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
     * approve
     * @author viettd
     * @created at 2018-09-17
     * @return void
     */
    public function postApprove(Request $request)
    {
        if ($request->ajax()) {
            //return request ajax
            try {
                if ($this->respon['status'] == OK) {
                    $validator = Validator::make($request->all(), [
                        'fiscal_year' => 'integer',
                        'sheet_cd' => 'integer',
                        'mode' => 'integer',
                    ]);
                    //
                    if ($validator->fails()) {
                        return response()->json('Error', 501);
                    } else {
                        $params['fiscal_year']          =   $request->fiscal_year ?? 0;
                        $params['employee_cd']          =   $request->employee_cd ?? '';
                        $params['sheet_cd']             =   $request->sheet_cd ?? 0;
                        $params['mode']                 =   $request->mode ?? 0;
                        $params['generic_comment_3']    =   $request->generic_comment_3 ?? '';    // add by viettd 2020/03/16
                        $params['generic_comment_4']    =   $request->generic_comment_4 ?? '';    // add by viettd 2020/03/16
                        $params['login_employee_cd']    =   session_data()->employee_cd;
                        $params['cre_user']             =   session_data()->user_id;
                        $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                        $params['company_cd']           =   session_data()->company_cd;
                        //
                        $result = Dao::executeSql('SPC_I2010_ACT2', $params);
                        // check exception
                        if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                            return response()->view('errors.query', [], 501);
                            // $this->respon['status']     = EX;
                            // $this->respon['Exception']  = $result[0][0]['remark'];
                        } else if (isset($result[0]) && !empty($result[0])) {
                            $this->respon['status'] = NG;
                            foreach ($result as $temp) {
                                array_push($this->respon['errors'], $temp);
                            }
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
    /**
     * approve
     * @author viettd
     * @created at 2018-09-17
     * @return void
     */
    public function postApproveComment(Request $request)
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
                    $result = Dao::executeSql('SPC_I2010_ACT3', $params);
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
