<?php

/**
 ****************************************************************************
 * MIRAI
 * Q2010Controller
 *
 * 処理概要/process overview   : Q2010Controller
 * 作成日/create date          : 2018-06-21 07:46:26
 * 作成者/creater              : viettd
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
use Carbon\Carbon;
use File;
use Dao;
use Validator;
use App\Helpers\UploadCore;
use Illuminate\Http\UploadedFile;

class M0160Controller extends Controller
{
    /**
     * Show the application index.
     * @author longvv
     * @created at 2018-06-25 07:46:26
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.evaluation_master');
        $data['category_icon']  = 'fa fa-server';
        $data['title'] = trans('messages.target_sheet_master');
        $data['m0120'] = getCombobox('M0120', 1);
        $data['m0101'] = getCombobox('M0101', 1);
        $data['lib']   = getCombobox('6', 0);
        $data['lib2']  = getCombobox('16', 0);
        
        $left = $this->getLeftContent($request);
        if (isset($left['error_typ']) && $left['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $params = [
            'sheet_cd'      => $request->sheet_cd ?? 0,
            'company_cd'    => session_data()->company_cd, // set for demo
        ];
        $res = Dao::executeSql('SPC_M0160_INQ1', $params);
        return view('Master::m0160.index', array_merge($data, $left))
            ->with('m0120', $data['m0120'])
            ->with('m0101', $data['m0101'])
            ->with('lib', $data['lib'])
            ->with('lib2', $data['lib2'])
            ->with('check', $res[1][0]['check_challenge_level'])
            //add vietdt cr 2022/03/10
            ->with('target_self_assessment_typ', $res[1][0]['target_self_assessment_typ']);
    }
    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
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
        //$data = $params;
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
        $res = Dao::executeSql('SPC_M0160_LST1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return ['error_typ' => '999'];
        }
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        // render view
        if ($request->ajax()) {
            return view('Master::m0160.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'sheet_cd' => 'integer',
            'width_table3' => 'integer',
            'width_table4' => 'integer'
        ]);
        if ($validator->passes()) {
            $width_table3 = $request->width_table3 ?? 100;
            $width_table4 = $request->width_table4 ?? 100;
            $params = [
                'sheet_cd'      => $request->sheet_cd ?? 0,
                'company_cd'    => session_data()->company_cd, // set for demo
            ];
            $data['m0120'] = getCombobox('M0120', 1);
            $data['m0101'] = getCombobox('M0101', 1);
            $data['lib']   = getCombobox('6', 0);
            $data['lib2']   = getCombobox('16', 0);

            $res = Dao::executeSql('SPC_M0160_INQ1', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                if ($request->ajax()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    return array('error_typ' => '999');
                }
            }
            // render view
            if (isset($res[0][0]['sheet_cd']) && $res[0][0]['sheet_cd'] != '') {
                return view('Master::m0160.refer')
                    ->with('result', $res[0])
                    ->with('m0120', $data['m0120'])
                    ->with('m0101', $data['m0101'])
                    ->with('lib', $data['lib'])
                    ->with('lib2', $data['lib2'])
                    ->with('check', $res[1][0]['check_challenge_level'])
                    ->with('tbl2', $res[2])
                    ->with('list', $res[3])
                    ->with('width_table3', $width_table3)
                    ->with('width_table4', $width_table4);
            } else {
                return view('Master::m0160.rightcontent')
                    ->with('m0120', $data['m0120'])
                    ->with('m0101', $data['m0101'])
                    ->with('lib', $data['lib'])
                    ->with('lib2', $data['lib2'])
                    ->with('check', $res[1][0]['check_challenge_level'])
                    ->with('tbl2', $res[2])
                    ->with('list', $res[3])
                    ->with('width_table3', $width_table3)
                    ->with('width_table4', $width_table4);
            }
        } else {
            if ($request->ajax()) {
                return response()->view('errors.query', [], 501);
            } else {
                return array('error_typ' => '999');
            }
        }
    }
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-09-18
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
            $file_adress = $json->data_sql->file_adress;

            // rename file upload
            config(["filesystems.options.rename_upload" => "file_m0160_$employee_cd"]);
            if ($file != 'undefined') {
                $request['rules'] = 'mimes:pdf';
                $request['folder'] = "m0160/$company_cd";
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
                //                $upload_file_name = $json->data_sql->upload_file_nm;
                $upload_file_name = $json->data_sql->upload_file_old;
            }

            $array = [
                'json'          =>   json_encode($json->data_sql, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
                'upload_file'   =>   $upload_file_name,
                'cre_user'      =>   session_data()->user_id,
                'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
                'company_cd'    =>   session_data()->company_cd,
            ];
            $result = Dao::executeSql('SPC_M0160_ACT1', $array);
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
                    $sheet_cd     = $result[1][0]['sheet_cd'];
                    $upload_file  = $result[2][0]['upload_file'];
                }
                if ($uploadPath != '') {
                    rename(public_path($uploadPath), public_path("uploads/m0160/$company_cd/$upload_file"));
                }
                if ($upload_file_nm == '' && $file_adress != '') {
                    unlink(public_path($file_adress));
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
     * @author sondh
     * @created at 2018-09-18
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['sheet_cd']               =   $request->sheet_cd;
                $params['cre_user']             =   session_data()->user_id;
                $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']           =   session_data()->company_cd;
                //
                $result = Dao::executeSql('SPC_M0160_ACT2', $params);
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
    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function listRow(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'number_of_row' => 'integer'
        ]);
        if ($validator->passes()) {
            $params = [
                'company_cd'        => session_data()->company_cd, // set for demo
                'number_of_row'     => $request->number_of_row ?? 0, // set for demo
                'sheet_cd'          => $request->sheet_cd ?? 0, // set for demo
                'language'          => session_data()->language,
            ];
            $data = $params;
            $res = Dao::executeSql('SPC_M0160_LST2', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return ['error_typ' => '999'];
            }
            $data['list'] = $res[0] ?? [];
            $data['point_calculation_typ2'] = $request -> point_calculation_typ2 ?? '' ; 
            // render view
            return view('Master::m0160.listRow', $data);
        } else {

            return response()->view('errors.query', [], 501);
        }
    }
}
