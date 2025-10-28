<?php

namespace App\Modules\Master\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use Illuminate\Validation\Rule;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;

class I2030Controller extends Controller
{
    /**
     * Show the application index.
     * @author datnt@ans-asia.com
     * @created at 2017-07-28 02:01:29
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']         = trans('messages.personnel_assessment');
        $data['category_icon']     = 'fa fa-line-chart';
        $data['title'] = trans('messages.interview_record');
        // get data from url query
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        //
        $reqs = [
            'fiscal_year'   => $redirect_param->fiscal_year ?? 0,
            'employee_cd'   => $redirect_param->employee_cd ?? '',
            'sheet_cd'  => $redirect_param->sheet_cd ?? 0,
            'from_source'  => $redirect_param->from_source ?? '',
            'from'  => $redirect_param->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'fiscal_year' => ['integer'],
            'sheet_cd' => ['integer'],
            'from'  => [
                'string',
                'required',
                Rule::in(['i2010', 'i2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // 
        $params = [
            'company_cd'         => session_data()->company_cd ?? 0,
            'fiscal_year'         => $reqs['fiscal_year'] ?? 0,
            'employee_cd'         => $reqs['employee_cd'] ?? '',
            'sheet_cd'          => $reqs['sheet_cd'] ?? 0,
            'user_id'           => session_data()->user_id ?? '',
        ];
        $res = Dao::executeSql('SPC_I2030_INQ1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list']           = $res[0] ?? [];
        $data['hidden']         = $res[1][0] ?? [];
        $data['data2']          = $res[2][0] ?? [];
        $data['from_source']    = htmlspecialchars($reqs['from_source']);
        $data['from']           = htmlspecialchars($reqs['from']);
        $data['sheet_cd']       = $reqs['sheet_cd'];
        return view('Master::i2030.index', $data);
    }
    /**
     * save
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // //
                    $result = Dao::executeSql('SPC_I2030_ACT1', $params);
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
