<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * EO0100Controller
 *
 * 処理概要/process overview   : EO0100Controller
 * 作成日/create date   : 
 * 作成者/creater    : trinhdt
 *
 *
 *
 * @package         :  EmployeeInfo
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use App\Helpers\UploadCore;

class EO0100Controller extends Controller
{
    /**
     * Show the application index.
     * @author trinhdt
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.import_export');
        return view('EmployeeInfo::eo0100.index', $data);
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
                $request['folder'] = 'eO0100';
                $request['rename_upload'] = 'eO0100_' . time();
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
                $path_file      =   public_path() . $upload['file']['path'];
                //
                $arrData        =   array();
                $arrDataHeader  =   array();
                $i              =   0;
                $r              =   0;
                $a              =   1;          // 0 is header error
                $row_id         =   0;
                $arrError       =   array();

                $arraysData     =   $this->loadCSV($path_file);
                $length         =   count($arraysData);

                $arrDataHeader = $arraysData[0];
                $error = 0;
                $target_employee_field = $request->target_employee_field;
                //
                if ($target_employee_field == 1) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 5) {
                            $error++;
                        }
                        if (count($tmp) == 5) {
                            $row_id = $row_id + 1;
                            $arrData =   array();
                            $arrData['qualification_cd']            =   $tmp[0];
                            $arrData['qualification_nm']            =   $tmp[1];
                            $arrData['qualification_ab_nm']         =   $tmp[2];
                            $arrData['qualification_typ']           =   $tmp[3];
                            $arrData['arrange_order']               =   $tmp[4];

                            $params['json']                         =   json_encode($arrData);
                            $params['session_key']                  =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']                   =   session_data()->company_cd;
                            $params['cre_user']                     =   session_data()->user_id;
                            $params['cre_ip']                       =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                           =   $row_id;
                            $params['count']                        =   $length;
                            $params['language']                     =  session_data()->language;
                            
                            $result = Dao::executeSql('SPC_eO0100_ACT1', $params);
                            
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
                
                if ($target_employee_field == 2) {
                    for ($i = 1; $i < $length; $i++) {
                        # code...
                        $tmp = $arraysData[$i];
                        if (count($tmp) != 7) {
                            $error++;
                        }
                        if (count($tmp) == 7) {
                            $row_id = $row_id + 1;
                            $arrData =   array();
                            $arrData['training_cd']                 =   $tmp[0];
                            $arrData['training_nm']                 =   $tmp[1];
                            $arrData['training_ab_nm']              =   $tmp[2];
                            $arrData['training_category_cd']        =   $tmp[3];
                            $arrData['training_course_format_cd']   =   $tmp[4];
                            $arrData['editable_kbn']                =   $tmp[5];
                            $arrData['arrange_order']               =   $tmp[6];

                            $params['json']                         =   json_encode($arrData);
                            $params['session_key']                  =   session_data()->user_id . session_data()->company_cd . $row_id;
                            $params['company_cd']                   =   session_data()->company_cd;
                            $params['cre_user']                     =   session_data()->user_id;
                            $params['cre_ip']                       =   $_SERVER['REMOTE_ADDR'];
                            $params['no']                           =   $row_id;
                            $params['count']                        =   $length;
                            $params['language']                     =  session_data()->language;

                            // call store
                            $result = Dao::executeSql('SPC_eO0100_ACT2', $params);
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
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }

    /**
     * export
     * @author manhnd
     * @created at 2024-04-16
     * @return void
     */
    public function export(Request $request)
    {
        try {
            $params['target_employee_field']        =   $request->target_employee_field;
            $params['company_cd']                   =   session_data()->company_cd;
            $params['language']                     =   session_data()->language;
            //
            $result = Dao::executeSql('SPC_EO0100_INQ1', $params);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
            $csvname = 'eO0100' . $date . '.csv';
            $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
            $fileNameReturn  = $this->saveCSV($fileName, $result);
            $this->respon['FileName'] = $fileNameReturn ?? '';
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
