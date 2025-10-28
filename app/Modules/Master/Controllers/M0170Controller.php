<?php

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * M0170Controller
 *
 * 処理概要/process overview   : M0170Controller
 * 作成日/create date   : 2018-06-22 06:22:11
 * 作成者/creater    : datnt@ans-asia.com
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
use App\Helpers\ANSFile;
use App\Helpers\UploadCore;

class M0170Controller extends Controller
{
    /**
     * Show the application index.
     * @author datnt@ans-asia.com
     * @created at 2018-06-22 06:22:11
     * @author tuantv
     * @updated at 2018-09-14 08:20:20
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
        $data['title'] = trans('messages.evaluation_sheet_master');
        $left = $this->getLeftContent($request);
        if (isset($left['error_typ']) && $left['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $right = $this->getRightContent($request);
        if (isset($right['error_typ']) && $right['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return view('Master::m0170.index', array_merge($data, $left), array_merge($data, $right));
    }

    /**
     * search data
     * @author tuantv
     * @created at 2018-09-14
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_page'  => 'integer',
			'search_key'    => 'max:50'
        ]);
		// validate Laravel
		if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->search_key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
        $params = [
            'search_key'    => SQLEscape($request->search_key) ?? '',
            'current_page'  => $request->current_page ?? 1,
            'page_size'     => 10,
            'company_cd'    => session_data()->company_cd, // set for demo
        ];
        $data = $params;
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
        $res = Dao::executeSql('SPC_M0170_LST1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return ['error_typ' => '999'];
        }
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        // render view
        if ($request->ajax()) return view('Master::m0170.leftcontent', $data);
        else return $data;
    }

    /**
     * search data
     * @author tuantv
     * @created at 2018-09-14
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $params = [
            'company_cd' => session_data()->company_cd, // set for demo
            'language'   => session_data()->language
        ];
        // $data = $params;
        $res2 = Dao::executeSql('SPC_M0170_INQ2', $params);
        if (isset($res2[0][0]['error_typ']) && $res2[0][0]['error_typ'] == '999') {
            if ($request->ajax()) {
                return response()->view('errors.query', [], 501);
            } else {
                return array('error_typ' => '999');
            }
        }
        $data['combo_category'] = $res2[0] ?? [];
        $data['combo_point_kinds'] = $res2[1] ?? [];
        $data['rad_evaluation_period'] = $res2[2] ?? [];
        $data['rad_point_calculation_typ'] = $res2[3] ?? [];
        //add by vietdt CR 2022/03/10
        $data['evaluation_self_assessment_typ'] = $res2[4][0]['evaluation_self_assessment_typ'] ?? 0;
        $data['lib2']   = getCombobox('16', 0);
        // render view
        if ($request->ajax()) return view('Master::m0170.rightcontent', $data);
        else return $data;
    }

    /**
     * refer sheet cd
     * @author tuantv
     * @created at 2018-09-14
     * @return \Illuminate\Http\Response
     */
    public function referSheet(Request $request)
    {
      
        $params['company_cd']   =  session_data()->company_cd;
        $params['sheet_cd']     = $request->sheet_cd;
        $validator = Validator::make($params, [
            'sheet_cd' => 'integer',
            'width_table3' => 'integer',
            'width_table4' => 'integer'
        ]);
        if ($validator->passes()) {
            $width_table3 = $request->width_table3 ?? 100;
            $width_table4 = $request->width_table4 ?? 100;
        
            $res2 = Dao::executeSql('SPC_M0170_INQ2', array(session_data()->company_cd,session_data()->language));
           
            if (isset($res2[0][0]['error_typ']) && $res2[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $data = Dao::executeSql('SPC_M0170_INQ1', $params);
           
          
            if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if (!isset($data[0][0])) {
                $result = [
                    'status' => 202
                ];
            } else {
               
                $data_refer = view('Master::m0170.refer')->with([
                    'data_single' => $data[0][0],
                    'data_tbl2' => $data,
                    'lib2'  => getCombobox('16', 0),
                    'combo_category' => $res2[0] ?? [],
                    'combo_point_kinds' => $res2[1] ?? [],
                    'rad_evaluation_period' => $res2[2] ?? [],
                    'rad_point_calculation_typ' => $res2[3] ?? [],
                    'width_table3' =>   $width_table3,
                    'width_table4' =>   $width_table4
                ])->render();
           
                $result = [
                    'status' => 200,
                    'data' => $data[0][0],
                    'data_refer' => $data_refer
                ];
            }
          
            return json_encode($result);
        } else {
            return response()->view('errors.query', [], 501);
        }
    }

    /**
     * Show the application index.
     * @author tuantv
     * @created at 2018-09-17 11:37:16
     * @return void
     */

    public function postSave(Request $request)
    {
        try {
            $json = $request->head;
            $json = json_decode($json);
            $file = $request->except('_token')['file'];
            if ($file != 'undefined') {
                $json->data_sql->upload_file_nm = $file->getClientOriginalName();
            }
            $employee_cd = session_data()->user_id;
            $company_cd  = session_data()->company_cd;
            $uploadPath = '';
            $upload_file_name = '';
            $upload_file_nm = $json->data_sql->upload_file_nm;
            $file_address = $json->data_sql->file_address;

            // rename file upload
            config(["filesystems.options.rename_upload" => "file_m0170_$employee_cd"]);
            if ($file != 'undefined') {
                $request['rules'] = 'mimes:pdf';
                $request['folder'] = "m0170/$company_cd";
                $upload =  UploadCore::start($request);
                if (!$upload['errors'] && isset($upload['file'])) {
                    $array = $upload['file'];
                    if ($array['status'] !== 200) {
                        $this->respon['status'] = 405;
                        return response()->json($this->respon);
                    }
                    $uploadPath         = $array['path'];
                    $upload_file_name   = $array['name'];
                }
            }

            if (($file == 'undefined') && ($json->data_sql->upload_file_nm != '')) {
                $upload_file_name = $json->data_sql->upload_file_nm;
            }

            $array = [
                'json'          =>   json_encode($json->data_sql),
                'upload_file'   =>   $upload_file_name,
                'cre_user'      =>   session_data()->user_id,
                'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
                'company_cd'    =>   session_data()->company_cd,
            ];
            $result = Dao::executeSql('SPC_M0170_ACT1', $array);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                if ($uploadPath != '') {
                    unlink(public_path($uploadPath));
                }
                return response()->view('errors.query', [], 501);
            } else if (isset($result[0]) && !empty($result[0])) {
                if ($uploadPath != '') {
                    unlink(public_path($uploadPath));
                }
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $this->respon['status']     = OK;
                if (isset($result[1][0])) {
                    $upload_file  = $result[1][0]['upload_file'];
                }
                if ($uploadPath != '') {
                    rename(public_path($uploadPath), public_path("uploads/m0170/$company_cd/$upload_file"));
                }
                if ($upload_file_nm == '' && $file_address != '') {
                    unlink(public_path($file_address));
                }
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }

    /**
     * Delete data
     * @author tuantv
     * @created at 2018-09-19
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['company_cd']           =   session_data()->company_cd;
                $params['sheet_cd']               =   $request->sheet_cd;
                $params['cre_user']             =   session_data()->user_id;
                $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                //
                $result = Dao::executeSql('SPC_M0170_ACT2', $params);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($result[0]) && !empty($result[0])) {
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
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

    public function popup(Request $request)
    {
        $data['title'] = '評価項目設定';
        return view('Master::m0170.popup', $data);
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
            $params['sheet_cd']         =   (int)$request->sheet_cd;
            $params['company_cd']       =   session_data()->company_cd;
            $params['language']			=   session_data()->language;
            //
            $result = Dao::executeSql('SPC_M0170_RPT1', $params,true);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            //
            $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
            $csvname = 'M0170' . $date . '.csv';
            $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;

            if (count($result[0]) == 1) {
                $this->respon['status']     = NG;
                $this->respon['message']  = L0020::getText(21)->message;
                return response()->json($this->respon, 401);
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
     * @author viettd
     * @created at 2017-12-13 08:13:36
     * @return void
     */
    public function import(Request $request)
    {
        try {
            //
        
            $file = $request->except('_token')['file'];
            $sheet_cd = $request->except('_token')['sheet_cd'];
            // rename file upload
            if ($file != 'undefined') {
                ini_set('memory_limit', '-1');
                ini_set('post_max_size', '40M');
                ini_set('upload_max_filesize', '240M');
                //
                $request['rules'] = 'mimes:csv,txt,html';
                $request['folder'] = 'm0170';
                $rename_upload  = 'm0170_' . time();
                $request['rename_upload'] = $rename_upload;
                $upload =  UploadCore::start($request);
                $fileName = $upload['file']['name'];
                $pos = strpos($fileName, ".");
                $checkFormat = substr($fileName, $pos, 4);
                if ($checkFormat != '.csv') {
                    $this->respon['status']     = 206;
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
                $arrData    =   array();
                $arrDataHeader = array();
                $i          =   0;
                $r          =   0;
                // check file exists
                $content    =   file_get_contents($path_file);
                if (mb_detect_encoding($content, 'SJIS', true) == true) {
                    $content = mb_convert_encoding($content, 'UTF-8', 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS');
                }
                $content2 = explode(",", $content);
                $arrDataHeader['item_title_1'] = str_replace('"', '', $content2[3]);
                $arrDataHeader['item_title_2'] = str_replace('"', '', $content2[4]);
                $arrDataHeader['item_title_3'] = str_replace('"', '', $content2[5]);
                $error = 0;
                //locale
                $oldLocale = setlocale(LC_ALL, 0);
                setlocale(LC_ALL, 
                    setlocale(LC_ALL, 'ja_JP.UTF-8') ?: 
                    setlocale(LC_ALL, 'ja_JP.utf8') ?: 
                    setlocale(LC_ALL, 'Japanese_Japan.65001') ?: 
                    setlocale(LC_ALL, 'ja.UTF-8') ?: 
                    'C'
                );
                if (($handle = fopen($path_file, "r")) !== FALSE) {
                    while (($row = fgetcsv($handle, 0, ",", "\"", "\"")) !== false) {
                        if (!empty($row)) {
                            //\Log::error($row);
                            if (count($row) != 7) {
                                $error++;
                                $this->respon['status']     = 207;
                                break; //continue;
                            }
                            if($r>0){
                                $arrData[$i]['sheet_cd']        = $row[0];
                                $arrData[$i]['sheet_nm']        = $row[1];
                                $arrData[$i]['item_no']         = $row[2];
                                $arrData[$i]['item_detail_1']   = mb_substr(preg_replace("/\r/", "",$row[3]), 0, 1000, 'UTF-8');
                                $arrData[$i]['item_detail_2']   = mb_substr(preg_replace("/\r/", "",$row[4]), 0, 1000, 'UTF-8');
                                $arrData[$i]['item_detail_3']   = mb_substr(preg_replace("/\r/", "",$row[5]), 0, 1000, 'UTF-8');
                                $arrData[$i]['weight']          = mb_substr($row[6], 0, 3, 'UTF-8');
                                $i++;  
                            }                           
                            $r++;                      
                        }
                    }
                    fclose($handle);
                }
                setlocale(LC_ALL, $oldLocale);
                // check eoor
                if ($error == 0) {
                    $params['company_cd']   =  session_data()->company_cd;
                    $params['sheet_cd']     =  $sheet_cd;
                    $validator = Validator::make($params, [
                        'sheet_cd' => 'integer',
                    ]);
                    if ($validator->passes()) {
                        $data = Dao::executeSql('SPC_M0170_INQ1', $params);
                        if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                            return response()->view('errors.query', [], 501);
                        }
                        $data_import = view('Master::m0170.import')->with([
                            'data_import' => $arrData,
                            'arrDataHeader' => $data[0][0] ?? []
                        ])->render();
                        $data_table_target = view('Master::m0170.table_target')->with([
                            'data_single' => $data[0][0] ?? []
                        ])->render();
                        $this->respon['status']     = 200;
                        $this->respon['data_import']  = $data_import;
                        $this->respon['data_table_target']  = $data_table_target;
                    }
                }
            }
            //
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
