<?php

/**
 ****************************************************************************
 * MIRAI
 * I2040Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 07:46:26
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
use Illuminate\Support\Facades\Input;
use Carbon\Carbon;
use File;
use Validator;
use App\Services\ItemService;
use Illuminate\Support\Facades\Crypt;
use Dao;
use App\Helpers\ANSFile;
use App\Helpers\UploadCore;
use Illuminate\Validation\Rule;

class I2040Controller extends Controller
{
    protected $itemService;

    public function __construct(ItemService $itemService)
    {
        parent::__construct();
        $this->itemService = $itemService;
    }
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-06-21 07:46:26
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.personnel_assessment');
        $data['category_icon']  = 'fa fa-line-chart';
        $data['title'] = trans('messages.overall_evaluation');
        $data['F0010'] = getCombobox('f0010', 1) ?? [];
        $data['M0020'] = getCombobox('M0020', 1) ?? [];
        $data['M0020_2']        = getCombobox('M0020_2', 1) ?? [];
        $data['M0020'] = getCombobox('M0020', 1) ?? [];
        $data['M0060'] = getCombobox('M0060', 1) ?? [];
        $data['M0040'] = getCombobox('M0040', 1) ?? [];
        $data['M0050'] = getCombobox('M0050', 1) ?? [];
        $data['L0010'] = getCombobox('14', 0) ?? [];
        $data['organization_group'] = getCombobox('M0022', 1) ?? [];
        $data['combo_organization'] = getCombobox('M0020', 1) ?? [];
        //
        $user_id               = session_data()->user_id;
        $data['authority_typ'] = session_data()->authority_typ;
        $from = $request->from ?? '';
        $reqs = [
            'from'  => $from,
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020', 'i2040', 'q0071', 'q2010','q2030']),
            ],
        ]);
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        if (!validateCommandOS($from)) {
            return view('errors.query', [], 500);
        } else {
            $data['screen_id']          = $from;
            $html                   = '';
            if ($from == 'i2010') {
                $cache              = getCache('i2040_i2010', $user_id);
            }
            if ($from == 'i2020') {
                $cache              = getCache('i2040_i2020', $user_id);
            }
            if ($from == 'q0071') {
                $cache              = getCache('i2040_q0071', $user_id);
            }
            //
            if (isset($cache)) {
                $html               = htmlspecialchars_decode($cache['html'] ?? '', ENT_QUOTES) ??  '';
            }
            $data['html']           =  $html;
            $params['company_cd']   =   session_data()->company_cd;
            $params['user_id']      =   session_data()->user_id;
            $result = Dao::executeSql('SPC_I2040_INQ1', $params);
            $data['button'] = $result[0][0] ?? [];
            $data['employee_cd']    =   '';
            $data['employee_nm']    =   '';
            $data['tbl_title']    =  $tbl_title[0] ?? [];
            $data['authority_typ']  = $result[1][0]['authority_typ'] ?? 0;
            $params2['company_cd']   =   session_data()->company_cd;
            $params2['user_id']      =   session_data()->user_id;
            $params2['fiscal_year']   =  0;
            $params2['mode']         =   1;
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $tbl_title =  Dao::executeSql('SPC_I2040_INQ3', $params2);
            if (isset($tbl_title[0][0]['error_typ']) && $tbl_title[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $data['emp_info_header']         = $tbl_title[0] ?? [];
            $data['prev_year_header']        = $tbl_title[1] ?? [];
            if (isset(session_data()->m0070->employee_cd)) {
                $data['employee_cd']    = session_data()->m0070->employee_cd;
            }
            if (isset(session_data()->m0070->employee_nm)) {
                $data['employee_nm']    = session_data()->m0070->employee_nm;
            }
            $data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id ?? 0);
            $data['fiscal_year_redirect'] = $redirect_param->fiscal_year??0;
            $data['employee_cd_redirect'] = $redirect_param->employee_cd_refer??'';
            $data['employee_nm_redirect'] = $redirect_param->employee_nm_refer??'';
            $data['treatment_redirect'] = $redirect_param->treatment_applications_no??0;
            return view('Master::i2040.index', $data);
        }
    }
    /**
     * Show the application index.
     * @author datnt
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postSearch(Request $request)
    {
        if ($request->ajax()) {
            $pre_json = $request->json()->all();
            $validator = Validator::make($pre_json, [
                'employee_typ'                          => 'integer',
                'position_cd'                           => 'integer',
                'grade'                                 => 'integer',
                'fiscal_year'                           => 'integer',
                'group_cd'                              => 'integer',
                'ck_search'                             => 'integer',
                'page_size'                             => 'integer',
                'page'                                  => 'integer',
                'list_character.*.character_item'       =>  'string',
                'list_character.*.item_cd'              =>  'integer',
                'list_date.*.date_item'                 =>  'date',
                'list_date.*.item_cd'                   =>  'integer',
                'list_number_item.*.number_item'        =>  'numeric',
                'list_number_item.*.item_cd'            =>  'integer',
            ]);

            $json = json_encode($pre_json ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            if ($validator->passes()) {
                $params['json']         =   $json;
                $params['company_cd']   =   session_data()->company_cd;
                $params['user_id']      =   session_data()->user_id;
                $params['cur_page']      =   $pre_json['page'] ?? 1;
                $params['page_size']      =  $pre_json['cb_page'] ?? 20;
                $result = Dao::executeSql('SPC_I2040_FND1', $params);
                $params2['company_cd']   =   session_data()->company_cd;
                $params2['user_id']      =   session_data()->user_id;
                $params2['fiscal_year']   =   $result[2][0]['fiscal_year'] ?? '';
                $params2['mode']         =   1;
                $tbl_title =  Dao::executeSql('SPC_I2040_INQ3', $params2);
                if ((isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') || (isset($tbl_title[0][0]['error_typ']) && $tbl_title[0][0]['error_typ'] == '999')) {
                    return response()->view('errors.query', [], 501);
                }
                //
                $data['table']          = $result[0] ?? [];

                $data['sheet']          = $result[1] ?? [];
                $data['fiscal_year']    = $result[2][0]['fiscal_year'] ?? '';
                $data['paging']         = $result[3][0] ?? [];
                $data['max_sheet']      = $result[4][0]['max_sheet'] ?? [];
                $data['f0100_step']     = $result[5][0]['f0100_step'] ?? [];
                $data['sheet_use_typ']      = $result[6][0]['sheet_use_typ'] ?? 0;
                $data['emp_info_header']         = $tbl_title[0] ?? [];
                $data['prev_year_header']         = $tbl_title[1] ?? [];
                //  $data['paging'] = $result[1][0] ?? [];
                //dd(htmlspecialchars_decode($result[3][0]['JsonRank']));
                //return request ajax
                return view('Master::i2040.search', $data);
            } else {
                return response()->view('errors.query', [], 501);
            }
        }
        // return http request
    }
    /**
     * Show the application index.
     * @author datnt
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json']         =   $json;
            $params['company_cd']   =   session_data()->company_cd;
            $params['user_id']      =   session_data()->user_id;
            $params['cre_ip']      =    $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_I2040_ACT1', $params);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            } else if (isset($result[0]) && !empty($result[0])) {
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $this->respon['status']     = OK;
            }
            return response()->json($this->respon);
        }
        // return http request
    }

    /**
     * Show the application index.
     * @author datnt
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postConfirm(Request $request)
    {
        if ($request->ajax()) {
            $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json']         =   $json;
            $params['company_cd']   =   session_data()->company_cd;
            $params['user_id']      =   session_data()->user_id;
            $params['cre_ip']      =    $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_I2040_ACT2', $params);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            } else if (isset($result[0]) && !empty($result[0])) {
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $this->respon['status']     = OK;
                // $employees = '';
                // $employees_array = [];
                // if (isset($result[1]) && !empty($result[1])) {
                //     for ($i=0; $i < count($result[1]); $i++) { 
                //         $employees_array[$i]['employee_cd_rater'] = $result[1][$i]['employee_cd_rater'];
                //         $employees_array[$i]['employee_cd'] = $result[1][$i]['employee_cd'];
                //     }
                //     // 
                //     $employees = json_encode($employees_array);
                // }
                $this->respon['employees'] = $result[1] ?? [];
            }
            return response()->json($this->respon);
        }
        // return http request
    }
    /**
     * Show the application index.
     * @author datnt
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postCancelDecision(Request $request)
    {
        if ($request->ajax()) {
            $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json']         =   $json;
            $params['company_cd']   =   session_data()->company_cd;
            $params['user_id']      =   session_data()->user_id;
            $params['cre_ip']      =    $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_I2040_ACT3', $params);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            } else if (isset($result[0]) && !empty($result[0])) {
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $this->respon['status']     = OK;
            }
            return response()->json($this->respon);
        }
        // return http request
    }
    /**
     * Show the application index.
     * @author datnt
     * @created at 2018-06-21 07:46:26
     * @return void
     */
    public function postFeedBack(Request $request)
    {
        if ($request->ajax()) {
            $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['json']         =   $json;
            $params['company_cd']   =   session_data()->company_cd;
            $params['user_id']      =   session_data()->user_id;
            $params['cre_ip']      =    $_SERVER['REMOTE_ADDR'];
            $result = Dao::executeSql('SPC_I2040_ACT4', $params);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            } else if (isset($result[0]) && !empty($result[0])) {
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $this->respon['status']     = OK;
                $this->respon['employees'] = $result[1] ?? [];
            }
            return response()->json($this->respon);
        }
        // return http request
    }
    /**
     * export
     * @author datnt
     * @created at 2018-10-03 08:13:36
     * @return void
     */
    public function postExport(Request $request)
    {
        if ($request->ajax()) {
            try {
                $pre_json = $request->json()->all();
                $validator = Validator::make($pre_json, [
                    'employee_typ'                          => 'integer',
                    'position_cd'                           => 'integer',
                    'grade'                                 => 'integer',
                    'fiscal_year'                           => 'integer',
                    'group_cd'                              => 'integer',
                    'ck_search'                             => 'integer',
                    'page_size'                             => 'integer',
                    'page'                                  => 'integer',
                    'list_character.*.character_item'       =>  'string',
                    'list_character.*.item_cd'              =>  'integer',
                    'list_date.*.date_item'                 =>  'date',
                    'list_date.*.item_cd'                   =>  'integer',
                    'list_number_item.*.number_item'        =>  'numeric',
                    'list_number_item.*.item_cd'            =>  'integer',
                ]);
                $json = json_encode($pre_json ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if ($validator->passes()) {

                    $params = [
                        'json' =>  $json,
                        'company_cd' =>   session_data()->company_cd,
                        'user_id'    =>   session_data()->user_id
                    ];
                    // Info::log($json);
                    //
                    $result = Dao::executeSql('SPC_I2040_RPT1', $params);
                    if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    }
                    if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '1') {
                        $this->respon['status']     = NG;
                        $this->respon['errors']     = $result[0];
                    }
                    // var_dump($result);
                    $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                    $csvname = 'I2040' . $date . '.csv';
                    $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                    $fileNameReturn  = $this->saveCSV($fileName, $result);
                    if ($fileNameReturn != '') {
                        $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    } else {
                        $this->respon['FileName'] = '';
                    }
                } else {
                    return response()->view('errors.query', [], 501);
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
     * import
     * @author tuantv
     * @created at 2018-10-03 08:13:36
     * @return void
     */
    public function postImport(Request $request)
    {
        try {
            //
            $file = $request->except('_token')['file'];
            $json = $request->list_treatment_applications_no;
            // step
            // $final_step = $request->final_step??0;
            $fiscal_year = $request->fiscal_year ?? 0;
            $params = [
                'company_cd'  => session_data()->company_cd,
                'fiscal_year' => $fiscal_year,
                'json' => $json
            ];
            // $params2 = [
            //     'company_cd'    => session_data()->company_cd,
            //     'user_id'       =>session_data()->user_id,
            //     'fiscal_year'   => $fiscal_year,
            //     'mode'          =>1
            // ];
            //
            $rank = Dao::executeSql('SPC_I2040_INQ2', $params);
            if ((isset($rank[0][0]['error_typ']) && $rank[0][0]['error_typ'] == '999')
                ||  (isset($label[0][0]['error_typ']) && $label[0][0]['error_typ'] == '999')
            ) {
                return response()->view('errors.query', [], 501);
            }
            //restruct array of $rank from 0=>[rank_cd=>xxx,rank_nm=>yyy] to rank_nm=>[rank_cd=>xxx]
            $re_rank = array();
            foreach ($rank[0] as $val) {
                $temp = [];
                $temp[$val['rank_nm']] =  $val;
                $re_rank += $temp;
            }
            $M0050 = array();
            foreach ($rank[1] as $val) {
                $temp = [];
                $temp[$val['grade_nm']] =  $val;
                $M0050 += $temp;
            }
            // rename file upload
            if ($file != 'undefined') {
                ini_set('memory_limit', '-1');
                ini_set('post_max_size', '40M');
                ini_set('upload_max_filesize', '240M');
                //
                $request['rules'] = 'mimes:csv,txt,html';
                $request['folder'] = 'i2040';
                $rename_upload  = 'i2040_' . time();
                $request['rename_upload'] = $rename_upload;
                $upload =  UploadCore::start($request);
                $fileName = $upload['file']['name'];
                $pos = strpos($fileName, ".");
                $checkFormat = substr($fileName, $pos, 4);
                if ($checkFormat != '.csv') {
                    $this->respon['status']   = 206;
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
                $path_file  =  public_path() . $upload['file']['path'];
                $arrData       = array();
                $i             = 0;
                $r             = 0;
                $content       = file_get_contents($path_file);
                if (mb_detect_encoding($content, 'SJIS', true) == true) {
                    $content = mb_convert_encoding($content, 'UTF-8', 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS');
                }
                $rows = str_getcsv($content, "\n"); //parse the rows
                $error = 0;
                if ($rows != '') {
                    $header =  explode(',', $rows[0]);
                }
                $position_rater1 = 0;
                $position_rater2 = 0;
                $position_rater3 = 0;
                $position_rater4 = 0;
                $position_rater_final = 0;
                $position_employee_cd = 0;
                $position_comment = 0;
                //find positon of each reater in excel file
                if (array_search('社員番号', $header)) {
                    $position_employee_cd = array_search('社員番号', $header);
                }
                if (array_search('(一次評価)評価点', $header)) {
                    $position_rater1 = array_search('(一次評価)評価点', $header);
                }
                if (array_search('(二次評価)評価点', $header)) {
                    $position_rater2 = array_search('(二次評価)評価点', $header);
                }
                if (array_search('(三次評価)評価点', $header)) {
                    $position_rater3 = array_search('(三次評価)評価点', $header);
                }
                if (array_search('(四次評価)評価点', $header)) {
                    $position_rater4 = array_search('(四次評価)評価点', $header);
                }
                if (array_search('(最終評価)評価点', $header)) {
                    $position_rater_final = array_search('(最終評価)評価点', $header);
                }
                if (array_search('コメント', $header)) {
                    $position_comment = array_search('コメント', $header);
                }
                foreach ($rows as $r => $row) {
                    $tmp            = explode(',', $row); //parse the items in rows
                    $col            = count($tmp);
                    $tmp = str_replace('"', '', $tmp);
                    if ($r >= 1) {
                        $tmp                                        =   explode(',', $row); //parse the items in rows
                        $tmp                                        =   str_replace('"', '', $tmp);
                        $arrData[$i]['employee_cd']                 =   $tmp[($position_employee_cd)] ?? '';
                        if (array_search('(一次評価)評価点', $header)) {
                            $arrData[$i]['point_sum1']              =   $tmp[$position_rater1];
                            $arrData[$i]['adjust_point1']           =   $tmp[$position_rater1 + 1];
                            $arrData[$i]['rank_kinds1']             =   empty($tmp[$position_rater1 + 2]) ? '' : ($re_rank[$tmp[$position_rater1 + 2]]['rank_cd'] ?? '');
                        }
                        if (array_search('(二次評価)評価点', $header)) {
                            $arrData[$i]['point_sum2']              =   $tmp[$position_rater2];
                            $arrData[$i]['adjust_point2']           =   $tmp[$position_rater2 + 1];
                            $arrData[$i]['rank_kinds2']             =   empty($tmp[$position_rater2 + 2]) ? '' : ($re_rank[$tmp[$position_rater2 + 2]]['rank_cd'] ?? '');
                        }
                        if (array_search('(三次評価)評価点', $header)) {
                            $arrData[$i]['point_sum3']              =   $tmp[$position_rater3];
                            $arrData[$i]['adjust_point3']           =   $tmp[$position_rater3 + 1];
                            $arrData[$i]['rank_kinds3']             =   empty($tmp[$position_rater3 + 2]) ? '' : ($re_rank[$tmp[$position_rater3 + 2]]['rank_cd'] ?? '');
                        }
                        if (array_search('(四次評価)評価点', $header)) {
                            $arrData[$i]['point_sum4']              =   $tmp[$position_rater4];
                            $arrData[$i]['adjust_point4']           =   $tmp[$position_rater4 + 1];
                            $arrData[$i]['rank_kinds4']             =   empty($tmp[$position_rater4 + 2]) ? '' : ($re_rank[$tmp[$position_rater4 + 2]]['rank_cd'] ?? '');
                        }
                        if (array_search('(最終評価)評価点', $header)) {
                            $arrData[$i]['point_sum5']              =   $tmp[($position_rater_final)] ?? '';
                            $arrData[$i]['rank_kinds5']             =   empty($tmp[($position_rater_final + 1)]) ? '' : ($re_rank[$tmp[($position_rater_final + 1)]]['rank_cd'] ?? '');
                        }
                        $arrData[$i]['comment']                     =   $tmp[($position_comment)] ?? '';
                        $arrData[$i]['treatment_applications_no']   =   $tmp[($position_comment + 1)] ?? '';
                        $arrData[$i]['treatment_applications_nm']   =   $tmp[($position_comment + 2)] ?? '';
                        $i++;
                    }
                }
                // }
                // check error
                if ($error > 0) {
                    $this->respon['status']     = 207;
                } else {
                    $this->respon['status']     = 200;
                    $this->respon['data_import']  = $arrData;
                }
            }
            //
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
        //        return json_encode($result);
    }
    /**
     * export
     * @author datnt
     * @created at 2018-10-03 08:13:36
     * @return void
     */
    public function postGetRank(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $fiscal_year = $request->fiscal_year ?? 0;
                $params = [
                    'company_cd'    =>   session_data()->company_cd,
                    'fiscal_year'   =>   $fiscal_year,
                    'json'          =>   $request->json ?? '',
                ];
                $rules = [
                    'company_cd' => 'integer', //Must be a number
                ];
                $validator = Validator::make($params, $rules);
                if ($validator->passes()) {
                    //
                    $result = Dao::executeSql('SPC_I2040_INQ2', $params);
                    if ((isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999')) {
                        return response()->view('errors.query', [], 501);
                    }
                } else {
                    return response()->view('errors.query', [], 501);
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($result);
        }
    }
    /**
     * show list employee
     * @author viettd
     * @created at 2017-08-18 06:38:35
     * @return void
     */
    public function i2040Label(Request $request)
    {
        $data['title']             = trans('messages.item_settings');
        //$params = $request->all();
        $params = [
            'company_cd' => session_data()->company_cd,
            'user_id'     => session_data()->user_id,
        ];
        $res = Dao::executeSql('SPC_I2040_INQ3', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['data'] = $res[0];
        return view('Master::i2040.i2040_label', $data);
        /*return view('Common::popup.employee')
			->with('data',$data)
			->with('data_init',$data_init);*/
    }

    /**
     * show list employee
     * @author viettd
     * @created at 2017-08-18 06:38:35
     * @return void
     */
    public function i2040Comment(Request $request)
    {
        $data['title']             = trans('messages.comment');
        // $params = $request->all();
        $params = [
            'company_cd'                => session_data()->company_cd,
            'fiscal_year'               => $request->fiscal_year ?? 0,
            'employee_cd'               => $request->employee_cd ?? '',
            'treatment_applications_no' => $request->treatment_applications_no ?? '',
            'valuation_step'            => $request->valuation_step ?? 0,
            'language'                  => session_data()->language,
        ];
        $res = Dao::executeSql('SPC_I2040_INQ4', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['data'] = $res[0];
        return view('Master::i2040.i2040_comment', $data);
        /*return view('Common::popup.employee')
			->with('data',$data)
			->with('data_init',$data_init);*/
    }
    /**
     * export
     * @author datnt
     * @created at 2018-10-03 08:13:36
     * @return void
     */
    public function postSavePopup(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json =  json_encode($request->get('data_sql'), JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if (!validateJsonFormat($json)) {
                    return view('errors.query', [], 500);
                } else {
                    $params = [
                        'json'          =>   $json,
                        'company_cd'    =>   session_data()->company_cd,
                        'user_id'       =>   session_data()->user_id,
                        'cre_ip'        =>   $_SERVER['REMOTE_ADDR']
                    ];
                    //
                    $result = Dao::executeSql('SPC_I2040_ACT5', $params);
                    if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($result);
        }
    }
}
