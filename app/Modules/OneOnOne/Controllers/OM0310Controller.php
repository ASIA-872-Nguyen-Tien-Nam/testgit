<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;

class OM0310Controller extends Controller
{
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.preparation');
        $data['category_icon'] = 'fa fa-book';
        $data['title'] = trans('messages.1on1_flow_setting');
        $content = $this->getContent($request) ?? [];
        if ((isset($content['error_typ']) && $content['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        return view('OneOnOne::om0310.index', array_merge($data, $content));
    }
    /**
     * get Content
     * @author duongntt@ans-asia.com 
     * @created at 2020-09-04 08:30:59
     * @return \Illuminate\Http\Response
     */
    public function getContent(Request $request)
    {
        $params = [
            'company_cd'     => session_data()->company_cd
        ];
        $result = Dao::executeSql('SPC_oM0310_INQ1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list']       = $result[0] ?? [];
        $data['position']   = getCombobox('M0040',1);
        $data['interview']  = $result[1] ?? [];
        // render view
        if ($request->ajax()) {
            return view('OneOnOne::om0310.search', $data);
        } else {
            return $data;
        }
    }
    /**
     * Save data
     * @author duongntt@ans-asia.com 
     * @created at 2020-09-04 08:30:59
     * @return void
     */
    public function postSave(Request $request)
    {
        try {
            $this->valid($request);
            if ($this->respon['status'] == OK) {
                $params['json']         =   $this->respon['data_sql'];
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $res = Dao::executeSql('SPC_oM0310_ACT1', $params);
                // check exception
                if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
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

    /**
     * Delete data
     * @author duongntt
     * @created at 2018-08-16
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        try {
            $params['cre_user']                 =   session_data()->user_id;
            $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
            $params['company_cd']               =   session_data()->company_cd;
            // 
            $result = Dao::executeSql('SPC_oM0310_ACT2', $params);
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
