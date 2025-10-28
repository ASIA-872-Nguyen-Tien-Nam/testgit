<?php

namespace App\Modules\Common\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
// use Illuminate\Routing\Controller;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\View;
use Dao, App, File;
use Validator;
use Illuminate\Support\Facades\Crypt;
use Redirect;
class CommonController extends Controller
{
    /**
     * [download]
     * @param  [type] $path_file [description]
     * @param  [type] $options   [description]
     * @return [type]            [description]
     */
    public function download(Request $request)
    {
        $params         = $request->all();
        $source_file    = preventOScommand($params['source_file']);
        $file_name      = preventOScommand($params['file_name']);
        $delete_flag    = (int)$params['delete_flag'];
        $file = mb_convert_encoding(storage_path() . '\\exports\\' . $source_file, "SJIS", "auto");
        // var_dump(is_readable($file));die;
        if (file_exists($file)) {
            $type = filetype($file);
            header("Content-type: $type");
            header("Content-Disposition: attachment;filename=$file_name");
            header("Content-Transfer-Encoding: binary");
            header('Pragma: no-cache');
            header('Expires: 0');
            set_time_limit(0);
            readfile($file);
            // check delete file after download
            if ($delete_flag == 1) {
                @unlink($file);
            }
            exit();
        } else {
            exit(NG);
        }
    }
    /**
     * deletetemp
     * @author longvv@ans-asia.com
     * @return array
     */
    public  function deletetemp(Request $request)
    {
        if ($request->ajax()) {
            try {
                $filedownload  = $_SERVER['DOCUMENT_ROOT'] . preventOScommand($request->fileName);
                unlink(mb_convert_encoding($filedownload, 'SJIS', 'UTF-8'));
            } catch (Exception $ex) {
            }
        }
    }
    /**
     * setCahe
     * @author longvv@ans-asia.com
     * @return array
     */
    public  function validateLogin(Request $request)
    {
        try {
            if (session()->has(AUTHORITY_KEY) || session()->has(CUSTOMER_KEY)) {
                $this->respon['status']     = OK;
            } else {
                $this->respon['status']     = NG;
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json(isset($this->respon) ? $this->respon : '');
    }
    /**
     * setCahe
     * @author longvv@ans-asia.com
     * @return array
     */
    public  function setCache(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params = $request->params;
                $rules = [
                    'fiscal_year' => 'integer',
                    'sheet_cd' => 'integer',
                    'sheet_kbn' => 'integer',
                    'period_cd' => 'integer',
                    'category' => 'integer',
                    'status_cd' => 'integer',
                    'employee_typ' => 'integer',
                    'depart_organization_cd' => 'integer',
                    'division_organization_cd' => 'integer',
                    'position_cd' => 'integer',
                    'grade' => 'integer',
                    'group_cd' => 'integer',
                    'ck_search' => 'integer',
                    'page' => 'integer',
                    'page_size' => 'integer',
                ];
                $validator = Validator::make($params, $rules);
                if ($validator->passes()) {
                    // add by viettd 2020/05/18
                    $param['fiscal_year']      =   $params['fiscal_year'] ?? 0;
                    $param['employee_cd']      =   $params['employee_cd'] ?? '';
                    $param['sheet_cd']         =   $params['sheet_cd'] ?? 0;
                    $param['user_id']          =   session_data()->user_id;
                    $param['company_cd']       =   session_data()->company_cd;
                    $param['mode']             =   0; // COMMON
                    //
                    $data   = Dao::executeSql('SPC_PERMISSION_CHK1', $param);
                    if (isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    }
                    //
                    if (isset($data[0][0]['chk']) && $data[0][0]['chk'] == 0) {
                        $this->respon['status']     = NG;
                    } else {
                        // set cache
                        $result = setCache($params);
                        if ($result) {
                            $this->respon['status']     = OK;
                        }
                    }
                } else {
                    return response()->view('errors.query', [], 501);
                }
            } catch (Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json(isset($this->respon) ? $this->respon : '');
        }
    }
    /**
     * setCachecustomer
     * @author longvv@ans-asia.com
     * @return array
     */
    public  function setCachecustomer(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params = $request->params;
                $rules = [
                    'fiscal_year' => 'integer',
                    'sheet_cd' => 'integer',
                    'sheet_kbn' => 'integer',
                    'period_cd' => 'integer',
                    'category' => 'integer',
                    'status_cd' => 'integer',
                    'employee_typ' => 'integer',
                    'depart_organization_cd' => 'integer',
                    'division_organization_cd' => 'integer',
                    'position_cd' => 'integer',
                    'grade' => 'integer',
                    'group_cd' => 'integer',
                    'ck_search' => 'integer',
                    'page' => 'integer',
                    'page_size' => 'integer',
                ];
                $validator = Validator::make($params, $rules);
                if ($validator->passes()) {
                    $result = setCache($params);
                    if ($result) {
                        $this->respon['status']     = OK;
                    }
                } else {
                    return response()->view('errors.query', [], 501);
                }
            } catch (Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json(isset($this->respon) ? $this->respon : '');
        }
    }
    /**
     * postRedirectScreen
     *
     * @param  mixed $request
     * @return void
     */
    public function postRedirectScreen(Request $request)
    {
        $payload = $request->all();
        // validate
        $validator = Validator::make($payload, [
            'fiscal_year' => 'integer',
            'sheet_cd' => 'integer',
            'status_cd' => 'integer',
            'select_category_typ' => 'integer',
            'select_period' => 'integer',
            'from' => 'string|required',
        ]);
        // error
        if ($validator->fails()) {
            return response()->json('Error', 501);
        }
        //
        try {
            // remove html
            $payload_removed = $payload;
            if(isset($payload_removed['html'])){
                unset($payload_removed['html']);
            }
            //
            $params = [
                'company_cd' => session_data()->company_cd,
                'payload' => json_encode($payload_removed)
            ];
            //
            $result = Dao::executeSql('SPC_REDIRECT_CHK1', $params);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                // return 501 error
                return response()->view('errors.query', [], 501);
            } else {
                $this->respon['status']     = OK;
                $this->respon['redirect_status'] = $result[0][0]['redirect_status'] ?? '';
                $this->respon['redirect_url'] = $result[0][0]['redirect_url'] ?? '';
                $this->respon['redirect_from'] = htmlspecialchars_decode($result[0][0]['redirect_from']) ?? '';
                // Crypt
                $redirect_param = htmlspecialchars_decode($result[0][0]['redirect_param']) ?? '';
                $this->respon['redirect_param'] = Crypt::encryptString($redirect_param);
                // check if redirect_status = true
                if (isset($payload['save_cache']) && $payload['save_cache'] == 'true') {
                    $payload['user_id']          =   session_data()->user_id;
                    setCache($payload);
                }
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}
