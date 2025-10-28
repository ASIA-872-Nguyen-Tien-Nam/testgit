<?php

/**
 ****************************************************************************
 * MIRAI
 * I2040Controller
 *
 * 処理概要/process overview   : I1020Controller
 * 作成日/create date          : 2018-06-25 07:46:26
 * 作成者/creater              : sondh
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
use Dao;
use Carbon\Carbon;
use File;
use Validator;

class I1020Controller extends Controller
{
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-06-21 07:46:26
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.process_fiscal_year');
        $data['category_icon'] = 'fa fa-refresh';
        $data['title'] = trans('messages.weight_setting');
        $data['f0010'] = getCombobox('F0010', 1);
        $data['m0200'] = getCombobox('M0200', 1);

        $params = [
            'fiscal_year' => 0,
            'company_cd'  => session_data()->company_cd,
            'check_fiscal' => 0,
            'check_treatment'=>0,
            'treatment_applications_no' => 0,
        ];

        $res = Dao::executeSql('SPC_I1020_INQ1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $a_data_group = [];
        if (isset($res[0][0]['treatment_applications_no'])) {
            //lap de get con
            foreach ($res[0] as $row) {
                $i = 0;
                $treatment_applications_no = $row['treatment_applications_no'];
                $a_child_group = [];
                $data_value_group = [];
                foreach ($res[1] as $item) {
                    $treatment_applications_no_chk = $item['treatment_applications_no'];
                    if ($treatment_applications_no == $treatment_applications_no_chk) {
                        $data_value_group['group_cd'] = $item['group_cd'];
                        $data_value_group['count_row'] = $item['count_row'];
                        $data_value_group['group_nm'] = $item['group_nm'];
                        $data_value_group['check_group'] = $item['check_group'];
                        //
                        $a_child_group[$i] = $data_value_group;
                        //
                        $i = $i + 1;
                    }
                }
                $a_data_group[$treatment_applications_no] = $a_child_group;
            }
        }

        $a_data_sheet = [];
        if (isset($res[1][0]['group_cd'])) {
            //lap de get con
            foreach ($res[1] as $row) {
                $i = 0;
                $group_cd = $row['check_group'];
                $a_child_sheet = [];
                $data_value_sheet = [];
                foreach ($res[1] as $item) {
                    $group_cd_chk = $item['check_group'];
                    if ($group_cd == $group_cd_chk) {
                        $data_value_sheet['detail_no'] = $item['detail_no'];
                        $data_value_sheet['sheet_cd'] = $item['sheet_cd'];
                        $data_value_sheet['weight'] = $item['weight'];
                        $data_value_sheet['check_group'] = $item['check_group'];
                        //add by vietdt cr 2022/03/10
                        $data_value_sheet['class_weight'] = $item['class_weight'];
                        //
                        $a_child_sheet[$i] = $data_value_sheet;
                        //
                        $i = $i + 1;
                    }
                }
                $a_data_sheet[$group_cd] = $a_child_sheet;
            }
        }
        return view('Master::i1020.index', $data)
            ->with('f0010', $data['f0010'])
            ->with('m0200', $data['m0200'])
            ->with('treatment',$res[0])
            ->with('group',$res[1])
            ->with('fiscal', $res[2][0]['fiscal_year'])
            ->with('btn', $res[3][0]['btn']??'')
            ->with('sheet', $a_data_sheet)
            ->with('result', $res[0])
            ->with('text', $res[3][0]['text']??'');
    }
    /**
     * referData
     * @author sondh
     * @created at 2018-09-26
     * @return \Illuminate\Http\Response
     */
    public function postRefer(Request $request)
    {
        if ($request->ajax()) {
            $params = [
                'fiscal_year' => $request->fiscal_year ?? 0,
                'company_cd'  => session_data()->company_cd, // set for demo
                'check_fiscal' => 1,
                'check_treatment'=> $request->check_treatment ?? 0,
                'treatment_applications_no'=> $request->treatment_applications_no ?? 0,
            ];
            //$data['m0200'] = getCombobox('M0200', 1);
            $rules = [
                'fiscal_year' => 'integer', //Must be a number and length of value is 8
                'check_treatment' => 'integer', //Must be a number and length of value is 8
                'treatment_applications_no' => 'integer', //Must be a number and length of value is 8

            ];
            $validator = Validator::make($params, $rules);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $res = Dao::executeSql('SPC_I1020_INQ1', $params);
                if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $a_data_group = [];
                if (isset($res[0][0]['treatment_applications_no'])) {
                    //lap de get con
                    foreach ($res[0] as $row) {
                        $i = 0;
                        $treatment_applications_no = $row['treatment_applications_no'];
                        $a_child_group = [];
                        $data_value_group = [];
                        foreach ($res[1] as $item) {
                            $treatment_applications_no_chk = $item['treatment_applications_no'];
                            if ($treatment_applications_no == $treatment_applications_no_chk) {
                                $data_value_group['group_cd'] = $item['group_cd'];
                                $data_value_group['count_row'] = $item['count_row'];
                                $data_value_group['group_nm'] = $item['group_nm'];
                                $data_value_group['check_group'] = $item['check_group'];
                                //
                                $a_child_group[$i] = $data_value_group;
                                //
                                $i = $i + 1;
                            }
                        }
                        $a_data_group[$treatment_applications_no] = $a_child_group;
                    }
                }

                $a_data_sheet = [];
                if (isset($res[1][0]['group_cd'])) {
                    //lap de get con
                    foreach ($res[1] as $row) {
                        $i = 0;
                        $group_cd = $row['check_group'];
                        $a_child_sheet = [];
                        $data_value_sheet = [];
                        foreach ($res[1] as $item) {
                            $group_cd_chk = $item['check_group'];
                            if ($group_cd == $group_cd_chk) {
                                $data_value_sheet['detail_no'] = $item['detail_no'];
                                $data_value_sheet['sheet_cd'] = $item['sheet_cd'];
                                $data_value_sheet['weight'] = $item['weight'];
                                $data_value_sheet['check_group'] = $item['check_group'];
                                //add by vietdt cr 2022/03/10
                                $data_value_sheet['class_weight'] = $item['class_weight'];
                                //
                                $a_child_sheet[$i] = $data_value_sheet;
                                //
                                $i = $i + 1;
                            }
                        }
                        $a_data_sheet[$group_cd] = $a_child_sheet;
                    }
                }

                $html = view('Master::i1020.refer')
                        ->with('treatment',$res[0])
                        ->with('group',$res[1])
                        ->with('fiscal', $res[2][0]['fiscal_year'])
                        ->with('text', $res[3][0]['text']??'')
                        ->render();

                return response()->json([
                    'html' => $html,
                    'data_check' => $res[3],
                ]);
            }
        }
    }
    /**
     * Save data
     * @author sondh
     * @created at 2018-08-28
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['json']         =   json_encode($request->list_row ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP);
                $params['fiscal_year']  =   $request->fiscal_year;
                $params['treatment_applications_no']  =   $request->treatment_applications_no;
                $params['mode']  =   $request->mode;
                $params['update']  =   $request->update;
                $params['w_m_999']  =   $request->w_m_999??0;
                $params['list_use_typ'] =   json_encode($request->list_use_typ ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP);
                $params['cre_user']        =   session_data()->user_id;
                $params['cre_ip']          =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $rules = [
                    'fiscal_year' => 'integer', //Must be a number and length of value is 8
                    'treatment_applications_no' => 'integer', //Must be a number and length of value is 8
                    'mode' => 'integer', //Must be a number and length of value is 8
                ];
                $validator = Validator::make($params, $rules);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    $result = Dao::executeSql('SPC_I1020_ACT1', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    if (isset($result[1][0]['authority_cd'])) {
                        $this->respon['authority_cd']     = $result[1][0]['authority_cd'];
                    }
                    if (isset($result[1]) && count($result[1]) > 0) {
                        $this->respon['status'] = 999;
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
     * Save data
     * @author sondh
     * @created at 2018-08-28
     * @return \Illuminate\Http\Response
     */
    public function postRefertreatment(Request $request)
    {
        if ($request->ajax()) {
            $params = [
                'fiscal_year' => $request->fiscal_year,
                'company_cd'  => session_data()->company_cd,
                'check_fiscal' => 1,
                'check_treatment'=>0,
                'treatment_applications_no' => 0,
            ];   
            //
            $rules = [
                'fiscal_year' => 'integer', //Must be a number and length of value is 8
            ];
            $validator = Validator::make($params, $rules);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            } else {
                $result =  Dao::executeSql('SPC_I1020_INQ1', $params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                return response()->json([
                    'data' => $result[0],
                    'data_check' => $result[3],
                ]);
            }
        }
    }
}
