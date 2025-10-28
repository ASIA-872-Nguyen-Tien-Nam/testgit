<?php

namespace App\Modules\Multiview\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\Service;
use Validator;
use Dao;
use App\Helpers\UploadCore;
use App\Services\OneOnOneService;
use App\L0020;

class MI1010Controller extends Controller
{
     protected $one_on_one_service;
     public function __construct(OneOnOneService $OneOnOneService)
     {
          parent::__construct();
          $this->one_on_one_service = $OneOnOneService;
     }
     /**
      * Show the application index. 
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:42:48
      * @return \Illuminate\Http\Response
      */
     public function index(Request $request)
     {
          $data['category'] = trans('messages.set');;
          $data['category_icon'] = 'fa fa-cogs';
          $data['title'] = trans('messages.supporter_setting');
          $company_cd    = session_data()->company_cd;
          $current_fiscal_year    =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
          if (isset($current_fiscal_year[0][0]['error_typ']) && $current_fiscal_year[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['fiscal_year']    =  $current_fiscal_year['fiscal_year'] ?? date("Y");
          $params['company_cd']   =  $company_cd;
          $result                 =  Dao::executeSql('SPC_mI1010_INQ3', $params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['browsing_kbn_flg'] =  $result[0][0]['browsing_kbn'] ?? 0;
          $data['list_position_cd'] =  $result[1] ?? [];
          return view('Multiview::mi1010.index', $data);
     }

     /**
      * Search
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postSearch(Request $request)
     {
          $this->respon['status'] = OK;
          $this->respon['errors'] = [];
          $data_request = $request->json()->all()['data_sql'];
          $validator = Validator::make($data_request, [
               'fiscal_year'                      => 'integer',    
               'check_mulitireview_typ'           => 'integer'
          ]);
          if ($validator->fails()) {
               return response()->view('errors.query', [], 501);
          }
          // check data mulitireview_typ
          $check_mulitireview_typ = $data_request['check_mulitireview_typ'] ?? 0;
          if ($check_mulitireview_typ == 1) {
               $params['company_cd']         =  session_data()->company_cd ?? 0;
               $params['employee_cd']        =  $data_request['employee_cd'] ?? '';
               $params['fiscal_year']        =  $data_request['fiscal_year'] ?? 0;
               $result                       =  Dao::executeSql('SPC_mI1010_CHK1', $params);
               if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
               }
               $multireview_typ = $result[0][0]['multireview_typ'] ?? 1;
               $this->respon['rater_employee_nm_1_string'] = $result[0][0]['rater_employee_nm_1_string'] ?? '';
               // if $multireview_typ = 0 then not use mulitireview service
               if ($multireview_typ == 0) {
                    $this->respon['status'] = NG;
               }
               return response()->json($this->respon);
          }
          // search data
          $params['company_cd']         =  session_data()->company_cd;
          $params['fiscal_year']        =  $data_request['fiscal_year'];
          $params['employee_cd']        =  $data_request['employee_cd'];
          $result                       =  Dao::executeSql('SPC_mI1010_INQ1', $params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['employee_info']        =  $result[0] ?? [];
          $data['list']                 =  $result[1] ?? [];
          //
          $param['company_cd']          =  $params['company_cd'];
          $results                      =  Dao::executeSql('SPC_mI1010_INQ3', $param);
          if (isset($results[0][0]['error_typ']) && $results[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['browsing_kbn_flg']               =  $results[0][0]['browsing_kbn'] ?? 0;
          $data['list_position_cd']               =  $results[1] ?? [];
          $data['rater_employee_nm_1_string']     =  $result[0][0]['rater_employee_nm_1_string'] ?? '';
          // render view
          if ($request->ajax()) {
               return view('Multiview::mi1010.search', $data);
          }
     }

     /**
      * Refer 
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:29:12
      * @return void
      */
     public function postRefer(Request $request)
     {
          try {
               $data_request = $request->json()->all()['data_sql'];
               $param['company_cd']          =  session_data()->company_cd;
               $param['employee_cd']         =  $data_request['supporter_cd'];
               $result                       =  Dao::executeSql('SPC_REFER_EMPLOYEE_INQ2', $param);
               if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
               }
               $data['list_info']            =  $result[0][0] ?? [];
               if (isset($result[0][0]['employee_cd']) && ($result[0][0]['employee_cd'] != '')) {
                    $this->respon['list_info']     = $data['list_info'];
                    $this->respon['flg']           = 1;     //co thong tin employee refer
               } else {
                    $this->respon['flg']           = 0;
               }
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          return response()->json($this->respon);
     }

     /**
      * Save
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:31:50
      * @return void
      */
     public function postSave(Request $request)
     {
          try {
               $this->respon['status'] = OK;
               $this->respon['errors'] = [];
               $data_request = $request->json()->all()['data_sql'];
               $validator = Validator::make($data_request, [
                    'fiscal_year'                           =>   'integer',
                    'list_supporters.*.other_browsing_kbn'  =>   'integer',
               ]);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $params['company_cd']       = session_data()->company_cd;
               $params['json']             = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $params['cre_user']         = session_data()->user_id;
               $params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
               $res = Dao::executeSql('SPC_mI1010_ACT1', $params);
               if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
               } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                         array_push($this->respon['errors'], $temp);
                    }
               }
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          return response()->json($this->respon);
     }

     /**
      * Show popup
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:42:48
      * @return void
      */
     public function popupSupporter(Request $request)
     {
          $data['title'] = trans('messages.supporters_viewing_settings');
          $params['company_cd']   =  session_data()->company_cd;
          $params['language'] = session_data()->language;
          $result                 =  Dao::executeSql('SPC_mI1010_INQ2', $params);
          if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
               return response()->view('errors.query', [], 501);
          }
          $data['lvl1']           =  $result[0] ?? [];
          $data['lvl2']           =  $result[1] ?? [];
          return view('Multiview::mi1010.popupsupporter', $data);
     }

     /**
      * Save popup
      * @author mail@ans-asia.com
      * @created at 2020-09-04 08:32:04
      * @return void
      */
     public function postSavePopup(Request $request)
     {
          try {
               $this->respon['status'] = OK;
               $this->respon['errors'] = [];
               $data_request = $request->json()->all()['data_sql'];
               $validator = Validator::make($data_request, [
                    'list_browsing.*.browsing_kbn'      =>  'integer',
                    'list_browsing.*.position_cd'       =>  'integer',
               ]);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $params['company_cd']   = session_data()->company_cd;
               $params['user_id']      = session_data()->user_id;
               $params['cre_ip']       = $_SERVER['REMOTE_ADDR'];
               $params['json']         = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
               $res = Dao::executeSql('SPC_mI1010_ACT2', $params);
               if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
               } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                         array_push($this->respon['errors'], $temp);
                    }
               }
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          return response()->json($this->respon);
     }

     /**
      * get excel file from button 目標一覧表出力
      * @author namnb
      * @created at 2020-10-12
      * @return void
      */
     public function postExportExcel(Request $request)
     {
          $param_json = $request->json()->all() ?? [];
          $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
          //
          if (!validateJsonFormat($json)) {
               return response()->view('errors.query', [], 501);
          }
          try {
               $params = array(
                    preventOScommand($json),   session_data()->company_cd
               );
               //
               $store_name = 'SPC_mI1010_RPT1';
               $typeReport = 'FNC_OUT_EXL';
               $screen = 'MI1010';
               $file_name = 'MI1010_' . time() . '.xlsx';
               $service = new Service();
               $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
               if (isset($result['filename'])) {
                    $result['path_file'] =  '/download/' . $result['filename'];
               }
               $result['fileNameSave'] =   'サポーター設定'.'_' . time() . '.xlsx';
               if (session_data()->language == 'en') {
                    $result['fileNameSave'] =   'SupporterSettings'.'_' . time() . '.xlsx';
               }
               $this->respon = $result;
          } catch (\Exception $e) {
               $this->respon['status']     = EX;
               $this->respon['Exception']  = $e->getMessage();
          }
          // return http request
          return response()->json($this->respon);
     }

     /**
      * export
      * @author viettd
      * @created at 2017-12-13 08:13:36
      * @return void
      */
     public function exportCsv(Request $request)
     {
          try {
               $params['language'] = session_data()->language;
               $params['fiscal_year']   = $request->fiscal_year;
               $params['company_cd']    = session_data()->company_cd;
               //
               $validator = Validator::make($params, [
                    'fiscal_year'       => 'integer',
               ]);
               //
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               $result = Dao::executeSql('SPC_mI1010_RPT2', $params);
               if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
               }
               //
               $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
               $csvname  = 'mI1010' . $date . '.csv';
               $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;

               if (count($result[0]) == 1) {
                    $this->respon['status']        = NG;
                    // $this->respon['message']       = L0020::getText(21)->message;
                    $this->respon['errors']           = L0020::getText(21)->message;
                    $this->respon['message']  = L0020::getText(21)->message;
                    return response()->json($this->respon);
               } else {
                    $fileNameReturn  = $this->saveCSV($fileName, $result);
                    if ($fileNameReturn != '') {
                         $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    } else {
                         $this->respon['FileName'] = '';
                    }
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
     public function importCsv(Request $request)
     {
          try {
               $file = $request->except('_token')['file'];
               //get fiscal_year
               $params['fiscal_year']   = $request->fiscal_year;
               $validator = Validator::make($params, [
                    'fiscal_year'       => 'integer',
               ]);
               if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
               }
               // rename file upload
               if ($file != 'undefined') {
                    ini_set('memory_limit', '-1');
                    ini_set('post_max_size', '40M');
                    ini_set('upload_max_filesize', '240M');
                    //
                    $request['rules'] = 'mimes:csv,txt,html';
                    $request['folder'] = 'mi1010';
                    $rename_upload  = 'mi1010_' . time();
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
                    $arraysData =  $this->loadCSV($path_file);
                    $length = count($arraysData);
                    $arrDataHeader = $arraysData[0];
                    $error = 0;
                    for ($i = 1; $i < $length; $i++) {
                         $tmp = $arraysData[$i];
                         if (count($tmp) != 32) {
                              $error++;
                         }
                         if (count($tmp) == 32) {
                              $row_id = $row_id + 1;
                              $arrData =   array();
                              $arrData['employee_cd']      =   $tmp[0];
                              $arrData['employee_nm']      =   $tmp[1];
                              $arrData['supporter_cd1']    =   $tmp[2];
                              $arrData['supporter_cd2']    =   $tmp[3];
                              $arrData['supporter_cd3']    =   $tmp[4];
                              $arrData['supporter_cd4']    =   $tmp[5];
                              $arrData['supporter_cd5']    =   $tmp[6];
                              $arrData['supporter_cd6']    =   $tmp[7];
                              $arrData['supporter_cd7']    =   $tmp[8];
                              $arrData['supporter_cd8']    =   $tmp[9];
                              $arrData['supporter_cd9']    =   $tmp[10];
                              $arrData['supporter_cd10']   =   $tmp[11];
                              $arrData['supporter_cd11']   =   $tmp[12];
                              $arrData['supporter_cd12']   =   $tmp[13];
                              $arrData['supporter_cd13']   =   $tmp[14];
                              $arrData['supporter_cd14']   =   $tmp[15];
                              $arrData['supporter_cd15']   =   $tmp[16];
                              $arrData['supporter_cd16']   =   $tmp[17];
                              $arrData['supporter_cd17']   =   $tmp[18];
                              $arrData['supporter_cd18']   =   $tmp[19];
                              $arrData['supporter_cd19']   =   $tmp[20];
                              $arrData['supporter_cd20']   =   $tmp[21];
                              $arrData['supporter_cd21']   =   $tmp[22];
                              $arrData['supporter_cd22']   =   $tmp[23];
                              $arrData['supporter_cd23']   =   $tmp[24];
                              $arrData['supporter_cd24']   =   $tmp[25];
                              $arrData['supporter_cd25']   =   $tmp[26];
                              $arrData['supporter_cd26']   =   $tmp[27];
                              $arrData['supporter_cd27']   =   $tmp[28];
                              $arrData['supporter_cd28']   =   $tmp[29];
                              $arrData['supporter_cd29']   =   $tmp[30];
                              $arrData['supporter_cd30']   =   $tmp[31];
                              //
                              $params['json']              =   json_encode($arrData);
                              $params['session_key']       =   session_data()->user_id . session_data()->company_cd . $row_id;
                              $params['company_cd']        =   session_data()->company_cd;
                              $params['cre_user']          =   session_data()->user_id;
                              $params['cre_ip']            =   $_SERVER['REMOTE_ADDR'];
                              $params['no']                =   $row_id;
                              $params['count']             =   $length - 1;
                              $result = Dao::executeSql('SPC_mI1010_ACT3', $params);
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

                    //error column
                    if ($error > 0) {
                         $this->respon['status']     = 206;
                    }
                    if (!empty($arrError) && $error <= 0) {
                         $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                         $csvname = 'mi1010' . $date . '.csv';
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
     /**
      * save CSV_error
      * @author sondh
      * @created at 2017-12-13 08:13:36
      * @return void
      */
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
          } catch (\Exception $e) {
               pr($e);
          }
          return $return;
     }
}
