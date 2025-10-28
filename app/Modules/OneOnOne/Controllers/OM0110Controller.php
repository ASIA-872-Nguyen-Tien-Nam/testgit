<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\QuestionService;
use Dao;
use Validator;
use App\Helpers\UploadCore;

class OM0110Controller extends Controller
{
    protected $questionService;

    public function __construct(QuestionService $questionService)
    {
        parent::__construct();
        $this->questionService = $questionService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:26:28
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('messages.question_master');
        $data['category'] = trans('messages.1on1_master');
        $data['category_icon'] = 'fa fa-list-alt';
        $left = $this->getLeftContent($request) ?? [];
        if ((isset($left['error_typ']) && $left['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        return view('OneOnOne::om0110.index', array_merge($data, $left));
    }

    /**
     * get left content
     * @author duongntt
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'search_key' => 'max:50'
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
            'company_cd'    => session_data()->company_cd,
        ];
        $data = [
            'search_key'    => htmlspecialchars($request->search_key) ?? '',
        ];
        $res = $this->questionService->findQuestions($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['list']       = $res[0] ?? [];
        $data['paging']     = $res[1][0] ?? [];
        $data['check_mc']   = $res[2][0] ?? [];
        // render view
        if ($request->ajax()) {
            return view('OneOnOne::om0110.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * get left content
     * @author DUONGNTT
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category1_cd'      => 'integer',
            'company_cd'        => 'integer',
            'refer_kbn'         => 'integer',
        ]);
        if ($validator->passes()) {
            $params = [
                'category1_cd' => $request->category1_cd ?? 1,
                'company_cd'   => $request->company_cd ?? 0,
                'refer_kbn'    => $request->refer_kbn ?? 0,
            ];
            $res = $this->questionService->getQuestion($params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $data = $res[0] ?? [];
            //
            return view('OneOnOne::om0110.rightcontent')
                ->with('data', $data);
        } else {
            return response()->view('errors.query', [], 501);
        }
    }

    /**
     * Save data
     * @author duongntt
     * @created at 2018-08-28
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $param = $request->list_data;
                $rules = [
                    'category1_cd'                 => 'int',
                    'category2_cd'                 => 'int',
                    'category3_cd'                 => 'int',
                    'question_cd'                 => 'int',
                    'cate2_no'                     => 'int',
                    'cate3_no'                     => 'int',
                    'company_cd_refer'             => 'int',
                    'refer_kbn'                 => 'int',
                ];
                $validator = \Validator::make($param, $rules);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                $params['json']         =   json_encode($request->list_data ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP);
                $params['cre_user']        =   session_data()->user_id;
                $params['cre_ip']          =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $result = $this->questionService->saveQuestion($params);
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
    }

    /**
     * Delete data
     * @author duongntt
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['category1_cd']               =   $request->category1_cd;
                $params['company_cd_refer']           =   $request->company_cd_refer;
                $params['refer_kbn']                   =   $request->refer_kbn;
                //
                $validator = Validator::make($params, [
                    'category1_cd'      => 'integer',
                    'company_cd_refer'  => 'integer',
                    'refer_kbn'         => 'integer',
                ]);
                //
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                $params['cre_user']                 =   session_data()->user_id;
                $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']               =   session_data()->company_cd;
                // 
                $result = $this->questionService->deleteQuestion($params);
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
            $params['category1_cd']     =   $request->category1_cd;
            $params['company_cd']       =   $request->company_cd_refer;
            $params['refer_kbn']        =   $request->refer_kbn;
            $params['language']         =   session_data()->language;
            //
            $validator = Validator::make($params, [
                'category1_cd'      => 'integer',
                'company_cd'        => 'integer',
                'refer_kbn'         => 'integer',
            ]);
            //
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $result = Dao::executeSql('SPC_oM0110_RPT1', $params);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            //
            $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
            $csvname  = 'oM0110' . $date . '.csv';
            $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;

            if (count($result[0]) == 1) {
                $this->respon['status']     = NG;
                $this->respon['message']      = L0020::getText(21)->message;
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
            $file = $request->except('_token')['file'];
            // rename file upload
            if ($file != 'undefined') {
                ini_set('memory_limit', '-1');
                ini_set('post_max_size', '40M');
                ini_set('upload_max_filesize', '240M');
                //
                $request['rules'] = 'mimes:csv,txt,html';
                $request['folder'] = 'om0110';
                $rename_upload  = 'om0110_' . time();
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
                $i          =   0;
                $r          =   0;
                // check file exists 
                $content    =   file_get_contents($path_file);

                if (mb_detect_encoding($content, 'SJIS', true) == true) {
                    $content = mb_convert_encoding($content, 'UTF-8', 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS');
                }
                $rows  = str_getcsv($content, "\n"); //parse the rows
                $error = 0;
                $arr_cnt_category2 = [];
                $arr_cnt_category3 = [];
                foreach ($rows as $row) {
                    if ($row != '') {
                        $tmp            =   explode(',', $row); //parse the items in rows
                        if (count($tmp) != 8) {
                            $error++;
                        }
                        $tmp = str_replace('"', '', $tmp);
                        if ($r > 0 & count($tmp) == 8) {
                            $arrData[$i]['category1_cd']        =   $tmp[0];
                            $arrData[$i]['category1_nm']        =   $tmp[1];
                            $arrData[$i]['category2_cd']        =   $tmp[2];
                            $arrData[$i]['category2_nm']           =   $tmp[3];
                            $arrData[$i]['category3_cd']           =   $tmp[4];
                            $arrData[$i]['category3_nm']           =   $tmp[5];
                            $arrData[$i]['question_cd']         =   $tmp[6];
                            $arrData[$i]['question']              =   $tmp[7];


                            //
                            if (isset($arr_cnt_category2[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']])) {
                                $arr_cnt_category2[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']]++;
                            } else {
                                $arr_cnt_category2[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']] = 1;
                            }

                            if (isset($arr_cnt_category3[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']][$arrData[$i]['category3_cd']])) {
                                $arr_cnt_category3[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']][$arrData[$i]['category3_cd']]++;
                            } else {
                                $arr_cnt_category3[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']][$arrData[$i]['category3_cd']] = 1;
                            }
                            //
                            $arrData[$i]['num_cate2']      =   $arr_cnt_category2[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']];
                            $arrData[$i]['num_cate3']      =   $arr_cnt_category3[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']][$arrData[$i]['category3_cd']];
                            $i++;
                        }
                    }
                    $r++;
                }
                //set row_span
                for ($i = 0; $i < count($arrData); $i++) {
                    $arrData[$i]['row_span_cate2']      =   $arr_cnt_category2[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']];
                    $arrData[$i]['row_span_cate3']      =   $arr_cnt_category3[$arrData[$i]['category1_cd']][$arrData[$i]['category2_cd']][$arrData[$i]['category3_cd']];
                }
                // check eoor
                if ($error > 0) {
                    $this->respon['status']     = 207;
                } else {
                    $data_import = view('OneOnOne::om0110.import')->with([
                        'data_import' => $arrData
                    ])->render();
                    $this->respon['status']         = 200;
                    $this->respon['data_import']      = $data_import;
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
