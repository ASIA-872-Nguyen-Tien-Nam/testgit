<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use Illuminate\Support\Facades\View;

class OI1011Controller extends Controller
{
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:30:37
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.set');
        $data['category_icon'] = 'fa fa-cogs';
        $data['title'] = trans('messages.email_settings');
        return view('OneOnOne::oi1011.index', $data);
    }
    /**
     * Refer data
     * @author nghianm
     * @created at 2020/11/10
     * @return \Illuminate\Http\Response
     */
    public function postRefer(Request $request)
    {
        try {
            $params = [
                'mail_kbn'          => $request->mail_kbn ?? 0,
                'company_cd'        => session_data()->company_cd, // set for demo
            ];
            $validator = Validator::make($params, [
                'mail_kbn'          => 'integer',
                'company_cd'        => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $res = Dao::executeSql('SPC_OI1011_INQ1', $params);
            // check exception
            if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999')) {
                return response()->view('errors.query', [], 501);
            }
            $this->respon['status']  = OK;
            $this->respon['data']    = $res;
            //
            $mail_kbn =  $request->mail_kbn ?? 0;
            $message = '';
            $title = '';
            // 1.1on1リマインドメール
            if ($mail_kbn == 1) {
                if (View::exists('mail_templete.oneonone.redmine')) {
                    $message = htmlspecialchars(view('mail_templete.oneonone.redmine')->render());
                }
                if (View::exists('mail_templete.oneonone.redmine_title')) {
                    $title = htmlspecialchars(view('mail_templete.oneonone.redmine_title')->render());
                }
                // 2.1on1アラートメール
            } else if ($mail_kbn == 2) {
                if (View::exists('mail_templete.oneonone.alert')) {
                    $message = htmlspecialchars(view('mail_templete.oneonone.alert')->render());
                }
                if (View::exists('mail_templete.oneonone.alert_title')) {
                    $title = htmlspecialchars(view('mail_templete.oneonone.alert_title')->render());
                }
                // 3.アンケートアラートメール
            } else if ($mail_kbn == 3) {
                if (View::exists('mail_templete.oneonone.questionnaire_alert')) {
                    $message = htmlspecialchars(view('mail_templete.oneonone.questionnaire_alert')->render());
                }
                if (View::exists('mail_templete.oneonone.questionnaire_alert_title')) {
                    $title = htmlspecialchars(view('mail_templete.oneonone.questionnaire_alert_title')->render());
                }
            }
            $this->respon['message']   =   $message;
            $this->respon['title']     =   $title;
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
     * Save
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:30:37
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
                $res = Dao::executeSql('SPC_OI1011_ACT1', $params);
                // check exception
                if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
                    }
                }
                if (isset($res[1][0])) {
                    $this->respon['authority_cd']     = $res[1][0]['authority_cd'];
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
     * @author nghianm
     * @created at 2020/11/10
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        try {
            $params = [
                'mail_kbn'          => $request->mail_kbn ?? 0,
                'company_cd'        => session_data()->company_cd, // set for demo
            ];
            $validator = Validator::make($params, [
                'mail_kbn'          => 'integer',
                'company_cd'        => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['mail_kbn']             =   $request->mail_kbn;
            $params['cre_user']             =   session_data()->user_id;
            $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
            $params['company_cd']           =   session_data()->company_cd;
            //
            $res = Dao::executeSql('SPC_OI1011_ACT2', $params);
            //
            // check exception
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
}
