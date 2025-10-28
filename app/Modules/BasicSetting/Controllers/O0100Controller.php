<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * O0100Controller
 *
 * 処理概要/process overview   : O0100Controller
 * 作成日/create date   : 2018-07-30 06:38:52
 * 作成者/creater    : datnt@ans-asia.com
 *
 * 更新日/update date    : 2018-10-01 08:38:52
 * 更新者/updater    : sondh sondh@ans-asia.com
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
use Carbon\Carbon;
use Dao;
use App\Helpers\UploadCore;

class O0100Controller extends Controller
{
    /**
     * Show the application index.
     * @author datnt@ans-asia.com
     * @created at 2018-07-30 06:38:52
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.import_export');
        return view('BasicSetting::o0100.index', $data);
    }
    /**
     * export
     * @author viettd
     * @created at 2017-12-13 08:13:36
     * @return void
     */

    public function export(Request $request)
    {
        try {
            $params['table_key']        =   $request->table_key;
            $json_param['screen']             =  $request->screen??'[]';
            $json_param['employee']             =  $request->employee??'[]';
            $json_param['type']             =  $request->type??0;
            $params['json']             =   json_encode($json_param)??'[]';
            $params['company_cd']       =   session_data()->company_cd;
            $params['user_id']          =  session_data()->user_id;
            $params['language']         =  session_data()->language;
            $params['json_filter']         =   '[]';
            //'

            $result = Dao::executeSql('SPC_O0100_INQ1', $params);
            //
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if ($params['table_key'] == 9) {
                $number_of_table = $result[0][0]['number_of_item'];
                $array_file_name = [];
                $array_real_file_name = [];
                for ($i = 1; $i <= $number_of_table; $i++) {
                    # code...
                    $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                    $csvname = 'O0100' . $date . '.csv';
                    $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                    $data_table[0] = $result[$i] ?? [];
                    array_push($array_real_file_name, $result[$i][1]['item_nm'] ?? '');
                    if ($data_table[0][1]['employee_cd'] == '') {
                        unset($data_table[0][1]);
                    }
                    $temp_file_name  = $this->saveCSV($fileName, $data_table);
                    array_push($array_file_name, $temp_file_name);
                }
                $fileNameReturn = json_encode($array_file_name);
                $real_file_name = json_encode($array_real_file_name);
            } else {
                $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                $csvname = 'O0100' . $date . '.csv';
                $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                $fileNameReturn  = $this->saveCSV($fileName, $result);
            }
            if ($fileNameReturn != '') {
                $this->respon['FileName'] = $fileNameReturn;
                $this->respon['real_file_name'] = $real_file_name ?? '';
            } else {
                $this->respon['FileName'] = '';
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
     * import
     * @author sondh
     * @created at 2017-12-13 08:13:36
     * @return void
     */
    public function import(Request $request)
    {
        try {
            $file = $request->except('_token')['file'];
            // rename file upload
            if ($file != 'undefined') {
                ini_set('memory_limit', '-1');
                ini_set('post_max_size', '40M');
                ini_set('upload_max_filesize', '240M');
                //
                $request['rules'] = 'mimes:csv,txt,html';
                $request['folder'] = 'o0100';
                $rename_upload  = 'o0100_' . time();
                $request['rename_upload'] = $rename_upload;
                $upload =  UploadCore::start($request);
                $fileName = $upload['file']['name'];
                $pos = strpos($fileName, ".");
                $checkFormat = substr($fileName, $pos, 4);
                if ($checkFormat != '.csv') {
                    $this->respon['status']     = 205;
                    $this->respon['message']  = '';
                    return response()->json($this->respon);
                }
                if (!$upload['errors'] && isset($upload['file'])) {
                    $array = $upload['file'];
                    if ($array['status'] !== OK) {
                        $this->respon['status'] = NG;
                        return response()->json($this->respon);
                    }
                }
                //
                $path_file  =  public_path() . $upload['file']['path'];
                //
                $arrData        =   array();
                $arrDataHeader  =   array();
                $i              =   0;
                $r              =   0;
                $a              =   1;          // 0 is header error
                $row_id         =   0;
                $arrError       =   array();
                // check file exists

                //                $fp = fopen($path_file, "r");
                //                fseek($fp, 3);

                //                $content    =   file_get_contents($path_file);
                //                if(mb_detect_encoding($content, 'SJIS',true)==true)
                //                {
                //                    $content = mb_convert_encoding($content,'UTF-8','SJIS');
                //                }
                //                $old_rows = str_getcsv($content,"\n");

                /*2018/11/27*/
                // ANS BaoNC
                $arraysData =  $this->loadCSV($path_file);
                $length = count($arraysData);

                $arrDataHeader = $arraysData[0];
                $error = 0;
                $table_key = $request->table_key;
                //
                if ($table_key == 1) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 11) {
                            $error++;
                        }
                        if (count($tmp) == 11) {
                            $row_id = $row_id + 1;
                            $arrData =   array();
                            $arrData['office_cd']        =   $tmp[0];
                            $arrData['office_nm']        =   $tmp[1];
                            $arrData['office_ab_nm']     =   $tmp[2];
                            $arrData['zip_cd']           =   $tmp[3];
                            $arrData['address1']         =   $tmp[4];
                            $arrData['address2']         =   $tmp[5];
                            $arrData['address3']         =   $tmp[6];
                            $arrData['tel']              =   $tmp[7];
                            $arrData['fax']              =   $tmp[8];
                            $arrData['responsible_cd']   =   $tmp[9];
                            $arrData['arrange_order']    =   str_replace("\r", '', $tmp[10]);

                            $params['json']              =   json_encode($arrData);
                            $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']        =   session_data()->company_cd;
                            $params['cre_user']          =   session_data()->user_id;
                            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                =   $row_id;
                            $params['count']             =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT1', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 2) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 11) {
                            $error++;
                        }
                        if (count($tmp) == 11) {

                            $row_id = $row_id + 1;
                            $arrData =   array();
                            $arrData['organization_typ']        =   $tmp[0];
                            $arrData['organization_cd_1']       =   $tmp[1];
                            $arrData['organization_cd_2']       =   $tmp[2];
                            $arrData['organization_cd_3']       =   $tmp[3];
                            $arrData['organization_cd_4']       =   $tmp[4];
                            $arrData['organization_cd_5']       =   $tmp[5];
                            $arrData['organization_nm']         =   $tmp[6];
                            $arrData['organization_ab_nm']      =   $tmp[7];
                            $arrData['responsible_cd']          =   $tmp[8];
                            $arrData['import_cd']               =   $tmp[9];
                            $arrData['arrange_order']           =   str_replace("\r", '', $tmp[10]);

                            $params['json']                         =   json_encode($arrData);
                            $params['session_key']                  =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']                   =   session_data()->company_cd;
                            $params['cre_user']                     =   session_data()->user_id;
                            $params['cre_ip']                       =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                           =   $row_id;
                            $params['count']                        =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT2', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 3) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 4) {
                            $error++;
                        }
                        if (count($tmp) == 4) {
                            $row_id = $row_id + 1;
                            $arrData =   array();
                            $arrData['job_cd']           =   $tmp[0];
                            $arrData['job_nm']           =   $tmp[1];
                            $arrData['job_ab_nm']        =   $tmp[2];
                            $arrData['arrange_order']    =   str_replace("\r", '', $tmp[3]);
                            $params['json']                  =   json_encode($arrData);
                            $params['session_key']           =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']            =   session_data()->company_cd;
                            $params['cre_user']              =   session_data()->user_id;
                            $params['cre_ip']                =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                    =   $row_id;
                            $params['count']                 =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT3', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 4) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 5) {
                            $error++;
                        }
                        if (count($tmp) == 5) {
                            $row_id = $row_id + 1;
                            $arrData    = array();
                            $arrData['position_cd']      =   $tmp[0];
                            $arrData['position_nm']      =   $tmp[1];
                            $arrData['position_ab_nm']   =   $tmp[2];
                            $arrData['import_cd']        =   $tmp[3];
                            $arrData['arrange_order']    =   str_replace("\r", '', $tmp[4]);

                            $params['json']              =   json_encode($arrData);
                            $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']        =   session_data()->company_cd;
                            $params['cre_user']          =   session_data()->user_id;
                            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                =   $row_id;
                            $params['count']             =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT4', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 5) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 3) {
                            $error++;
                        }
                        if (count($tmp) == 3) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['grade']            =   $tmp[0];
                            $arrData['grade_nm']         =   $tmp[1];
                            $arrData['arrange_order']    =   str_replace("\r", '', $tmp[2]);

                            $params['json']              =   json_encode($arrData);
                            $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']        =   session_data()->company_cd;
                            $params['cre_user']          =   session_data()->user_id;
                            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                =   $row_id;
                            $params['count']             =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT5', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 6) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 4) {
                            $error++;
                        }
                        if (count($tmp) == 4) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_typ']     =   $tmp[0];
                            $arrData['employee_typ_nm']  =   $tmp[1];
                            $arrData['import_cd']        =   $tmp[2];
                            $arrData['arrange_order']    =   str_replace("\r", '', $tmp[3]);

                            $params['json']              =   json_encode($arrData);
                            $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']        =   session_data()->company_cd;
                            $params['cre_user']          =   session_data()->user_id;
                            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                =   $row_id;
                            $params['count']             =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT6', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 7) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 31) {
                            $error++;
                        }
                        if (count($tmp) == 31) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['employee_last_nm']        =   $tmp[1];
                            $arrData['employee_first_nm']       =   $tmp[2];
                            $arrData['employee_nm']             =   $tmp[3];
                            $arrData['furigana']                =   $tmp[4];
                            $arrData['gender']                  =   $tmp[5];
                            $arrData['mail']                    =   $tmp[6];
                            $arrData['birth_date']              =   $tmp[7];
                            $arrData['company_in_dt']           =   $tmp[8];
                            $arrData['company_out_dt']          =   $tmp[9];
                            $arrData['retirement_reason_typ']   =   $tmp[10];
                            $arrData['retirement_reason']       =   $tmp[11];
                            $arrData['evaluated_typ']           =   $tmp[12];
                            $arrData['oneonone_typ']            =   $tmp[13];
                            $arrData['multireview_typ']         =   $tmp[14];
                            $arrData['report_typ']              =   $tmp[15];
                            $arrData['office_cd']               =   $tmp[16];
                            $arrData['belong_cd1']              =   $tmp[17];
                            $arrData['belong_cd2']              =   $tmp[18];
                            $arrData['belong_cd3']              =   $tmp[19];
                            $arrData['belong_cd4']              =   $tmp[20];
                            $arrData['belong_cd5']              =   $tmp[21];
                            $arrData['job_cd']                  =   $tmp[22];
                            $arrData['position_cd']             =   $tmp[23];
                            $arrData['employee_typ']            =   $tmp[24];
                            $arrData['grade']                   =   $tmp[25];
                            $arrData['salary_grade']            =   str_replace(",", '', $tmp[26]);
                            $arrData['company_mobile_number']   =   $tmp[27];
                            $arrData['extension_number']        =   $tmp[28];
                            $arrData['sso_user']                =   $tmp[29];
                            $arrData['user_id']                 =   str_replace("\r", '', $tmp[30]);
                            // $arrData['user_id']             =   str_replace(",",'',$tmp[20]);
                            $params['json']              =   json_encode($arrData);
                            $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']        =   session_data()->company_cd;
                            $params['cre_user']          =   session_data()->user_id;
                            $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                =   $row_id;
                            $params['count']             =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT7', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 8) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...

                        $tmp = $arraysData[$i];
                        if (count($tmp) != 12) {
                            $error++;
                        }
                        if (count($tmp) == 12) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']         =   $tmp[0];
                            $arrData['application_date']    =   $tmp[1];
                            $arrData['office_cd']           =   $tmp[2];
                            $arrData['belong_cd1']          =   $tmp[3];
                            $arrData['belong_cd2']          =   $tmp[4];
                            $arrData['belong_cd3']          =   $tmp[5];
                            $arrData['belong_cd4']          =   $tmp[6];
                            $arrData['belong_cd5']          =   $tmp[7];
                            $arrData['job_cd']              =   $tmp[8];
                            $arrData['position_cd']         =   $tmp[9];
                            $arrData['employee_typ']        =   $tmp[10];
                            $arrData['grade']               =   str_replace("\r", '', $tmp[11]);

                            $params['json']                 =   json_encode($arrData);
                            $params['session_key']          =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']           =   session_data()->company_cd;
                            $params['cre_user']             =   session_data()->user_id;
                            $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                   =   $row_id;
                            $params['count']                =  $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT8', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 9) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 5 && count($tmp) != 6) {
                            $error++;
                        }
                        if (count($tmp) == 5 || count($tmp) == 6) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['item_cd']                 =   $tmp[1];
                            $arrData['item_nm']                 =   $tmp[2];
                            $arrData['item_no']                 =   $tmp[3];
                            $arrData['item_value']              =   $tmp[4];
                            $arrData['item_value_kind_4_5']     =   '';
                            if(count($tmp) == 6) {
                            $arrData['item_value_kind_4_5']              =   $tmp[5];
                            }
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT9', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 10) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 2) {
                            $error++;
                        }
                        if (count($tmp) == 2) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['password']                =   str_replace("]", '', str_replace("[", '', $tmp[1]));
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT10', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 11) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 25) {
                            $error++;
                        }
                        if (count($tmp) == 25) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                 =   $tmp[0];
                            $arrData['blood_type']                  =   $tmp[1];
                            $arrData['headquarters_prefectures']    =   $tmp[2];
                            $arrData['headquarters_other']          =   $tmp[3];
                            $arrData['possibility_transfer']        =   $tmp[4];
                            $arrData['nationality']                 =   $tmp[5];
                            $arrData['residence_card_no']           =   $tmp[6];
                            $arrData['status_residence']            =   $tmp[7];
                            $arrData['expiry_date']                 =   $tmp[8];
                            $arrData['permission_activities']       =   $tmp[9];
                            $arrData['disability_classification']   =   $tmp[10];
                            $arrData['disability_recognition_date'] =   $tmp[11];
                            $arrData['disability_content']          =   $tmp[12];
                            $arrData['common_name']                 =   $tmp[13];
                            $arrData['common_name_furigana']        =   $tmp[14];
                            $arrData['maiden_name']                 =   $tmp[15];
                            $arrData['maiden_name_furigana']        =   $tmp[16];
                            $arrData['business_name']               =   $tmp[17];
                            $arrData['business_name_furigana']      =   $tmp[18];
                            $arrData['base_style']                  =   $tmp[19];
                            $arrData['sub_style']                   =   $tmp[20];
                            $arrData['driver_point']                =   $tmp[21];
                            $arrData['analytical_point']            =   $tmp[22];
                            $arrData['expressive_point']            =   $tmp[23];
                            $arrData['amiable_point']               =   $tmp[24];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT11', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 12) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 7) {
                            $error++;
                        }
                        if (count($tmp) == 7) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                 =   $tmp[0];
                            $arrData['detail_no']                   =   $tmp[1];
                            $arrData['qualification_cd']            =   $tmp[2];
                            $arrData['qualification_typ']           =   $tmp[3];
                            $arrData['headquarters_other']          =   $tmp[4];
                            $arrData['possibility_transfer']        =   $tmp[5];
                            $arrData['remarks']                     =   $tmp[6];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT12', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 13) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 10) {
                            $error++;
                        }
                        if (count($tmp) == 10) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                  =   $tmp[0];
                            $arrData['detail_no']                    =   $tmp[1];
                            $arrData['final_education_kbn']          =   $tmp[2];
                            $arrData['final_education_other']        =   $tmp[3];
                            $arrData['graduation_year']              =   $tmp[4];
                            $arrData['graduation_school_cd']         =   $tmp[5];
                            $arrData['name']                         =   $tmp[6];
                            $arrData['graduation_school_other']      =   $tmp[7];
                            $arrData['faculty']                     =   $tmp[8];
                            $arrData['major']                       =   $tmp[9];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT13', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 14) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 18) {
                            $error++;
                        }
                        if (count($tmp) == 18) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                         =   $tmp[0];
                            $arrData['owning_house_kbn']                    =   $tmp[1];
                            $arrData['head_household']                      =   $tmp[2];
                            $arrData['post_code']                           =   $tmp[3];
                            $arrData['address1']                            =   $tmp[4];
                            $arrData['address2']                            =   $tmp[5];
                            $arrData['address3']                            =   $tmp[6];
                            $arrData['home_phone_number']                   =   $tmp[7];
                            $arrData['personal_phone_number']               =   $tmp[8];
                            $arrData['personal_email_address']              =   $tmp[9];
                            $arrData['emergency_contact_name']              =   $tmp[10];
                            $arrData['emergency_contact_relationship']      =   $tmp[11];
                            $arrData['emergency_contact_birthday']          =   $tmp[12];
                            $arrData['emergency_contact_post_code']         =   $tmp[13];
                            $arrData['emergency_contact_addres1']           =   $tmp[14];
                            $arrData['emergency_contact_addres2']           =   $tmp[15];
                            $arrData['emergency_contact_addres3']           =   $tmp[16];
                            $arrData['emergency_contact_phone_number']      =   $tmp[17];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT14', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                }else if ($table_key == 15) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 10) {
                            $error++;
                        }
                        if (count($tmp) == 10) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']                         =   $tmp[0];
                            $arrData['detail_no']                           =   $tmp[1];
                            $arrData['commuting_method']                    =   $tmp[2];
                            $arrData['commuting_distance']                  =   $tmp[3];
                            $arrData['drivinglicense_renewal_deadline']     =   $tmp[4];
                            $arrData['commuting_method_detail']             =   $tmp[5];
                            $arrData['departure_point']                     =   $tmp[6];
                            $arrData['arrival_point']                       =   $tmp[7];
                            $arrData['commuter_ticket_classification']      =   $tmp[8];
                            $arrData['commuting_expenses']                  =   $tmp[9];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT15', $params);

                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 16) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 10) {
                            $error++;
                        }
                        if (count($tmp) == 10) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                     =   $tmp[0];
                            $arrData['marital_status']                  =   $tmp[1];
                            $arrData['detail_no']                       =   $tmp[2];
                            $arrData['full_name']                       =   $tmp[3];
                            $arrData['full_name_furigana']              =   $tmp[4];
                            $arrData['relationship']                    =   $tmp[5];
                            $arrData['gender']                          =   $tmp[6];
                            $arrData['birthday']                        =   $tmp[7];
                            $arrData['residential_classification']      =   $tmp[8];
                            $arrData['profession']                      =   $tmp[9];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT16', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 17) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 5) {
                            $error++;
                        }
                        if (count($tmp) == 5) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['detail_no']               =   $tmp[1];
                            $arrData['leave_absence_startdate'] =   $tmp[2];
                            $arrData['leave_absence_enddate']   =   $tmp[3];
                            $arrData['remarks']                 =   $tmp[4];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT17', $params);

                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 18) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 8) {
                            $error++;
                        }
                        if (count($tmp) == 8) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['employment_contract_no']  =   $tmp[1];
                            $arrData['detail_no']               =   $tmp[2];
                            $arrData['start_date']              =   $tmp[3];
                            $arrData['expiration_date']         =   $tmp[4];
                            $arrData['contract_renewal_kbn']    =   $tmp[5];
                            $arrData['reason_resignation']      =   $tmp[6];
                            $arrData['remarks']                 =   $tmp[7];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT18', $params);

                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                }else if ($table_key == 19) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 16) {
                            $error++;
                        }
                        if (count($tmp) == 16) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']                             =   $tmp[0];
                            $arrData['employment_insurance_no']                 =   $tmp[1];
                            $arrData['basic_pension_no']                        =   $tmp[2];
                            $arrData['employment_insurance_status']             =   $tmp[3];
                            $arrData['health_insurance_status']                 =   $tmp[4];
                            $arrData['health_insurance_reference_no']           =   $tmp[5];
                            $arrData['employees_pension_insurance_status']      =   $tmp[6];
                            $arrData['employees_pension_reference_no']          =   $tmp[7];
                            $arrData['welfare_pension_status']                  =   $tmp[8];
                            $arrData['employees_pension_member_no']             =   $tmp[9];
                            $arrData['social_insurance_kbn']                    =   $tmp[10];
                            $arrData['detail_no']                               =   $tmp[11];
                            $arrData['joining_date']                            =   $tmp[12];
                            $arrData['date_of_loss']                            =   $tmp[13];
                            $arrData['reason_for_loss_kbn']                     =   $tmp[14];
                            $arrData['reason_for_loss']                         =   $tmp[15];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT19', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 20) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 3) {
                            $error++;
                        }
                        if (count($tmp) == 3) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['base_salary']             =   $tmp[1];
                            $arrData['basic_annual_income']     =   $tmp[2];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT20', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 21) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 15) {
                            $error++;
                        }
                        if (count($tmp) == 15) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']                 =   $tmp[0];
                            $arrData['detail_no']                   =   $tmp[1];
                            $arrData['training_cd']                 =   $tmp[2];
                            $arrData['training_nm']                 =   $tmp[3];
                            $arrData['training_category_cd']        =   $tmp[4];
                            $arrData['training_course_format_cd']   =   $tmp[5];
                            $arrData['lecturer_name']               =   $tmp[6];
                            $arrData['training_date_from']          =   $tmp[7];
                            $arrData['training_date_to']            =   $tmp[8];
                            $arrData['training_status']             =   $tmp[9];
                            $arrData['passing_date']                =   $tmp[10];
                            $arrData['report_submission']           =   $tmp[11];
                            $arrData['report_submission_date']      =   $tmp[12];
                            $arrData['report_storage_location']     =   $tmp[13];
                            $arrData['nationality']                 =   $tmp[14];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT21', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 22) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 10) {
                            $error++;
                        }
                        if (count($tmp) == 10) {
                            $row_id = $row_id + 1;
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['work_history_kbn']        =   $tmp[1];
                            $arrData['detail_no']               =   $tmp[2];
                            $arrData['item_id']                 =   $tmp[3];
                            $arrData['item_title']              =   $tmp[4];
                            $arrData['date_from']               =   $tmp[5];
                            $arrData['date_to']                 =   $tmp[6];
                            $arrData['text_item']               =   $tmp[7];
                            $arrData['select_item']             =   $tmp[8];
                            $arrData['number_item']             =   $tmp[9];

                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =   $row_id;
                            $params['count']                    =   $length - 1;
                            $params['language']                 =  session_data()->language;

                            $result = Dao::executeSql('SPC_O0100_ACT22', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                } else if ($table_key == 24) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 6) {
                            $error++;
                        }
                        if (count($tmp) == 6) {
                            $row_id = $row_id + 1;
                            //array
                            $arrData = array();
                            $arrData['employee_cd']             =   $tmp[0];
                            $arrData['detail_no']               =   $tmp[1];
                            $arrData['reward_punishment_typ']   =   $tmp[2];
                            $arrData['decision_date']           =   $tmp[3];
                            $arrData['reason']                  =   $tmp[4];
                            $arrData['remarks']                 =   $tmp[5];
                            //Param
                            $params['json']                     =   json_encode($arrData);
                            $params['session_key']              =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']               =   session_data()->company_cd;
                            $params['cre_user']                 =   session_data()->user_id;
                            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                       =    $row_id;
                            $params['count']                    =     $length - 1;
                            $params['language']            =  session_data()->language;
                            $result = Dao::executeSql('SPC_O0100_ACT24', $params);
                            //
                            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            } else if (isset($result[0]) && !empty($result[0])) {
                                $error_sql = '';
                                foreach ($result[0] as $temp) {
                                    $error_sql .= $temp['remark'] . ':' . (app('messages')->getText($temp['message_no'])->message);
                                }
                                array_push($arrData, $error_sql);
                                $arrError[$a] = $arrData;
                                $a++;
                            } else {
                                $this->respon['status'] = OK;
                            }
                        }
                    }
                }
                else if ($table_key == 23) {
                    $this->respon['status']     = 163;
                }
                //error column
                if ($error > 0) {
                    $this->respon['status']     = 206;
                }
                if (!empty($arrError) && $error <= 0) {
                    $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                    $csvname = 'O0100' . $date . '.csv';
                    $fileNameError =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                    array_push($arrDataHeader, "error");
                    $arrCheckError = array();
                    $arrCheckError[0] =  $arrDataHeader;
                    foreach ($arrError as $key => $value) {
                        $arrCheckError[$key + 1] = $value;
                    }
                    $fileNameReturn  = $this->saveCSV_error($fileNameError, $arrCheckError);
                    $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    $this->respon['status'] = 207;
                }
            }
            //
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
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
}
