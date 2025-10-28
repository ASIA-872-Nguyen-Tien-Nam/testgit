<?php

namespace App\Modules\Multiview\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Crypt;
use Dao;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Mail;
use App\Mail\InputReview;
use App\Services\OneOnOneService;
use App\Services\GoogleService;

class MI2000Controller extends Controller
{
    protected $one_on_one_service;
    //
    public function __construct(OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author NGHIANM 
     * @created at 2020-11-16 06:49:48
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.multi_review');
        $data['category_icon'] = 'fa fa-users';
        $data['title'] = trans('messages.input_review');
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $year_target   =  $redirect_param->fiscal_year ?? 0;
        $reqs = [
            'employee_cd'  => $redirect_param->employee_cd ?? '',
            'detail_no'    => $redirect_param->detail_no ?? 0,
            'from'         => $redirect_param->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'detail_no'     =>  'integer',
            'from'  => [
                'string',
                Rule::in(['mdashboardsupporter', 'mdashboard', 'mq2000']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $params = [
            'company_cd'                => session_data()->company_cd ?? 0,
            'employee_cd'               => $reqs['employee_cd'],
            'detail_no'                 => $reqs['detail_no'],
            'cre_user'                  => session_data()->user_id,
            'fiscal_year'               => $year_target
        ];
        $res = Dao::executeSql('SPC_MI2000_INQ1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['result']               = $res[0][0] ?? [];
        $data['employee_data']        = $res[1][0] ?? [];
        $data['supporter_data']       = $res[2][0] ?? [];
        $data['permission']           = $res[3][0]['permission'] ?? 0;
        $data['fiscal_year']          = $res[0][0]['fiscal_year'] ?? $year_target;
        $data['from']                 = $reqs['from'] ?? '';
        //permission
        if ($data['permission'] == 0) {
            return view('errors.403');
        }
        return view('Multiview::mi2000.index', $data);
    }
    /**
     * Save data
     * @author nghianm
     * @created at 2021/01/05
     * @return \Illuminate\Http\Response
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
                $res = Dao::executeSql('SPC_MI2000_ACT1', $params);
                // check exception
                if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                // check error in store return
                if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
                    }
                } else {
                    // check error not exists email
                    if (isset($res[1]) && !empty($res[1])) {
                        $this->respon['status'] = NG;
                        $this->respon['error_no'] = $res[1][0]['error_no'];
                        $this->respon['error_nm'] = $res[1][0]['error_nm'];
                    }
                    // send mail
                    $this->respon['mail_info']  =   $res[2] ?? [];
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
     * @created at 2021/01/06
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params = [
                    'employee_cd'               => $request->employee_cd ?? '',
                    'detail_no'                 => $request->detail_no ?? 0,
                    'company_cd'                => session_data()->company_cd, // set for demo
                ];
                $validator = Validator::make($params, [
                    'company_cd'        => 'integer',
                    'detail_no'         => 'integer',
                ]);
                if ($validator->passes()) {
                    $params['employee_cd']                  =   $params['employee_cd'];
                    $params['detail_no']                    =   $params['detail_no'];
                    $params['company_cd']                   =   session_data()->company_cd;
                    $params['cre_user']                     =   session_data()->user_id;
                    $params['cre_ip']                       =   $_SERVER['REMOTE_ADDR'];
                    $res = Dao::executeSql('SPC_MI2000_ACT2', $params);
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
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }

    /**
     * postSendMail
     *
     * @param  mixed $request
     * @return void
     */
    public function postSendMail(Request $request)
    {
        $this->respon['status'] = OK;
        $this->respon['errors'] = [];
        $mail_info = $request->mail_info ?? [];
        $googleMail = new GoogleService();
        try {
          
            if (isset($mail_info) && !empty($mail_info)) {
                $mail['subject']        = 'マルチレビュー通知';
                 foreach ($mail_info as $value) {
                    $member_mail    = $value['mail']??'';
                    $mail['title']          = $value['infomation_title']??'';
                    $mail['message']        = $value['infomation_message']??'';
                    $mail['language']       = $value['language']??'1';
                    $mail['screen_id']      = 'mi2000';
    
                    // Send mail
                        $result = $googleMail->sendInputReview($member_mail,$mail);
                        // mail send success
                        if ($result['Exception']) {
                            $this->respon['status']    = NG;
                            $this->respon['Exception'] = $result['Exception'];
                            // Log
                            $this->writeLog('This mail [' . $member_mail . '] is not sent');
                            return response()->json($this->respon);
                        }
                        $this->writeLog('This mail address [' . $member_mail . '] is successful');
                        $this->respon['status']     = OK;
                        return response()->json($this->respon);
                    // Mail::to($member_mail)->send(new InputReview($subject, $title, $message));
                 }
            }
        } catch (\Exception $e) {
            $this->respon['status'] = EX;
            $this->respon['Exception'] = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
	 * writeLog
	 *
	 * @param  string $content
	 * @return void
	 */
	private function writeLog($content, $payloads = [])
	{
		$time = date("Y-m-d H:i:s");
		$logFile = fopen(
			storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_INPUT_REVIEW.log'),
			'a+'
		);
		fwrite($logFile, $time . ': ' . $content . PHP_EOL);
		// if $payloads is exits 
		if (!empty($payloads)) {
			foreach ($payloads as $payload) {
				fwrite($logFile, '∟ ' . $payload . PHP_EOL);
			}
		}
		// close file
		fclose($logFile);
	}
}
