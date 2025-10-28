<?php

namespace App\Modules\Auth\Controllers;

/**
 ****************************************************************************
 * UNITE_MEDICAL
 * LoginController
 *
 * 処理概要/process overview   : LoginController
 * 作成日/create date   : 2017-10-12 08:20:28
 * 作成者/creater    : tannq@ans-asia.com
 *
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : add function login by get method
 *
 *
 * @package         :  Auth
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use Cookie;
use Session;
use Dao;
use App\L0020;
use Illuminate\Support\Facades\Crypt;

class LoginController extends Controller
{
    use AuthenticatesUsers;
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |

    */

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/menu';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest:' . AUTHORITY_KEY, ['except' => 'getLogout']);
        $this->respon['status']     = OK;
        $this->respon['errors']     = [];
        $this->respon['data_sql'] = json_encode([]);
    }

    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2017-10-12 06:48:34
     * @return \Illuminate\Http\Response
     */
    public function getLogin(Request $request)
    {   
        $lang = 'jp';
        if(isset(Cookie::get('language')['language'])) {
            $lang = Cookie::get('language')['language'];
        }
        if ($lang == null) {
            $lang = 'jp';
        };
        config(['app.locale' => $lang]);
        $data['title'] = trans('messages.login');
        Session::put('login_typ', 0);
        $_data_login = $request->cookie('_data_login');
        $remember_id            = isset($_data_login['remember_id']) ? $_data_login['remember_id'] : '';
        $remember_contract_cd   = isset($_data_login['remember_contract_cd']) ? $_data_login['remember_contract_cd'] : '';
        $data['user_id'] = '';
        $data['contract_cd'] = '';
        if (!empty($remember_id)) {
            $data['user_id'] = isset($_data_login['user_id']) ? $_data_login['user_id'] : '';
        }
        if (!empty($remember_contract_cd)) {
            $data['contract_cd'] = isset($_data_login['contract_cd']) ? $_data_login['contract_cd'] : '';
        }
        $data['remember_id']            = $remember_id;
        $data['remember_contract_cd']   = $remember_contract_cd;
        // $data['_text'] = app('messages')->text(false);
        $is_maintain = env('APP_MAINTAIN', false);
        if ($is_maintain) {
            return view('Auth::guest.maintain');
        } else {
            return view('Auth::guest.login', $data);
        }
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2017-10-12 06:48:34
     * @return \Illuminate\Http\Response
     */
    public function getLoginCustomer(Request $request)
    {
        $lang = 'jp';
        if(isset(Cookie::get('language')['language'])) {
            $lang = Cookie::get('language')['language'];
        }
        if ($lang == null) {
            $lang = 'jp';
        };
        $data['title'] = 'ログイン';
        Session::put('login_typ', 1);
        return view('Auth::guest.logincustomer', $data);
    }

    /**
     * Handle a login request to the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse|\Illuminate\Http\Response
     */
    public function postLogin(Request $request)
    {
        try {
            $this->rules = [
                '#contract_cd'  => 'required',
                '#user_id'     => 'required|string',
                '#password'     => 'required|string',
            ];
            $this->valid($request);
            $json = $this->respon['data_sql'];
            $cre_ip = $request->ip();
            $query = Dao::executeSql('SPC_S0010_INQ1', [
                'json' => $json,
                'cre_ip' => $cre_ip
            ]);
            $user = $query[0][0] ?? [];
            $errors = $query[1][0] ?? [];
            // Error Query
            if (isset($user['error_typ']) && $user['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            // Error 30
            if (!empty($errors) || empty($user)) {
                $this->respon['status']     = NG;
                $this->respon['message']  = L0020::getText($errors['message_no'])->message;
                return response()->json($this->respon);
            }
            $now = Carbon::now();
            if (!empty($user)) {
                $timeout = config('session.lifetime');
                Cookie::queue('_data_login', [
                    'user_id'  => '',
                    'contract_cd'  => '',
                    'remember_id'  => '',
                    'remember_contract_cd'  => '',
                    'time'      => $now
                ], $timeout);
                Cookie::queue('language', [
                    'language'              => $user['language'],
                ], $timeout);

                $payload                =   json_decode($json);
                $remember_id            =   isset($payload->remember_id) && ($payload->remember_id == 1) ? true : false;
                $remember_contract_cd   =   isset($payload->remember_contract_cd) && ($payload->remember_contract_cd == 1) ? true : false;
                if ($remember_id || $remember_contract_cd) {
                    $payload->user_id = $remember_id ? $payload->user_id : '';
                    $payload->contract_cd = $remember_contract_cd ? $payload->contract_cd : '';
                    $data =  [
                        'user_id'               => $payload->user_id,
                        'contract_cd'           => $payload->contract_cd,
                        'remember_id'           => $payload->remember_id,
                        'remember_contract_cd'  => $payload->remember_contract_cd,
                        'time'                  => $now
                    ];
                    Cookie::queue('_data_login', $data, $timeout);
                }
            }
            // change 1on1_use_typ to  _1on1_use_typ
            $user['_1on1_use_typ']  = $user['1on1_use_typ'];
            $pass_change_datetime = isset($user['pass_change_datetime']) && $user['pass_change_datetime'] != '' && $user['pass_change_datetime'] != null ? Carbon::parse($user['pass_change_datetime']) : null;
            $password_age = $user['password_age'] ?? 0;
            if ($pass_change_datetime != null && $password_age > 0) {
                $subMonths = $now->subMonths($password_age);
                if ($subMonths->gte($pass_change_datetime)) {
                    $this->respon['status']     = NG;
                    $this->respon['message']  = L0020::getText(30)->message;
                    return response()->json($this->respon);
                }
            }
            $login = new \stdClass();
            foreach ($user as $key => $value) {
                $login->$key = htmlspecialchars_decode($value);
            }
            $login->m0070 = new \stdClass();
            $login->excepts = new \stdClass();
            $login->screens = new \stdClass();
            session([AUTHORITY_KEY => $login]);
            Session::put('ans_user_id', $payload->user_id);
            Session::put('website_language', $user['language']);
            return response()->json([
                'message' => 'Login success!',
                'status' => OK,
                'redirectTo' => $this->redirectTo,
            ]);
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
            return response()->json($this->respon);
        }
    }

    /**
     * Login by get method.
     * @author namnt@ans-asia.com
     * @created at 2022-04-20
     *
     */
    public function redirectLogin(Request $request)
    {
        try {
            $data_login = Crypt::decryptString($request->query('param'));
            $json = $data_login;
            $cre_ip = $request->ip();
            $query = Dao::executeSql('SPC_S0010_INQ5', [
                'json' => $json,
                'cre_ip' => $cre_ip
            ]);
            $user = $query[0][0] ?? [];
            $errors = $query[1][0] ?? [];
            // Error Query
            if (isset($user['error_typ']) && $user['error_typ'] == '999') {
                return redirect('/');
            }
            // Error 30
            if (!empty($errors) || empty($user)) {
                $this->respon['status']     = NG;
                $this->respon['message']  = L0020::getText($errors['message_no'])->message;
                return redirect('/');
            }
            if (!empty($user)) {
                $timeout = config('session.lifetime');
                Cookie::queue('_data_login', [
                    'user_id'  => '',
                    'contract_cd'  => '',
                    'remember_id'  => '',
                    'remember_contract_cd'  => '',
                    'time'      => Carbon::now()
                ], $timeout);
                $request = json_decode($json);
                $remember_id = isset($request->remember_id) && ($request->remember_id == 1) ? true : false;
                $remember_contract_cd = isset($request->remember_contract_cd) && ($request->remember_contract_cd == 1) ? true : false;
                if ($remember_id || $remember_contract_cd) {
                    $request->user_id = $remember_id ? $request->user_id : '';
                    $request->contract_cd = $remember_contract_cd ? $request->contract_cd : '';
                    $data =  [
                        'user_id'               => $request->user_id,
                        'contract_cd'           => $request->contract_cd,
                        'remember_id'           => $request->remember_id,
                        'remember_contract_cd'  => $request->remember_contract_cd,
                        'time'                  => Carbon::now()
                    ];
                    Cookie::queue('_data_login', $data, $timeout);
                }
            }
            $user['_1on1_use_typ']  = $user['1on1_use_typ'];
            $now = Carbon::now();
            $today = Carbon::today();
            $user_end_dt = isset($user['user_end_dt']) && $user['user_end_dt'] != '' && $user['user_end_dt'] != null ? Carbon::parse($user['user_end_dt']) : null;

            // if($user_end_dt != null && $today->gt($user_end_dt)) {
            //     $this->respon['status']     = NG;
            //     $this->respon['message']  = L0020::getText(36)->message;
            //     return response()->json($this->respon,401);
            // }

            $pass_change_datetime = isset($user['pass_change_datetime']) && $user['pass_change_datetime'] != '' && $user['pass_change_datetime'] != null ? Carbon::parse($user['pass_change_datetime']) : null;
            $password_age = $user['password_age'] ?? 0;
            // dump($now->diffInMonths($pass_change_datetime));
            // dd($now->diffInMonths($pass_change_datetime) > $password_age);
            if ($pass_change_datetime != null && $password_age > 0) {
                $subMonths = $now->subMonths($password_age);
                // dump($subMonths);
                // dd($subMonths->gte($pass_change_datetime)); // subMonths >= pass_change_datetime
                if ($subMonths->gte($pass_change_datetime)) {
                    $this->respon['status']     = NG;
                    $this->respon['message']  = L0020::getText(30)->message;
                    return response()->json($this->respon);
                }
            }

            $login                      = new \stdClass();
            foreach ($user as $key => $value) {
                $login->$key = htmlspecialchars_decode($value);
            }

            $login->m0070               = new \stdClass();
            $login->excepts              = new \stdClass();
            $login->screens              = new \stdClass();
            session([AUTHORITY_KEY => $login]);
            Session::put('ans_user_id', $request->user_id);
            return redirect('/');
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
            return redirect('/');
        }
    }

    /**
     * Get the login user_cd to be used by the controller.
     *
     * @return string
     */
    public function username()
    {
        return 'user_id';
    }

    /**
     * Log the user out of the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function getLogout(Request $request)
    {
        // Delete reports cache
        $login_key = session(AUTHORITY_KEY)->login_key ?? '';
        deleteCacheReports($login_key);
        // 
        $ans_user_id = session()->get('ans_user_id');
        session()->forget(AUTHORITY_KEY);
        session()->forget(CUSTOMER_KEY);
        // $this->guard()->logout();
        deleteCache(NULL, $ans_user_id);
        // Cache::flush();
        $request->session()->flush();
        // goto login
        return redirect('/');
    }

    /**
     * Get the guard to be used during authentication.
     *
     * @return \Illuminate\Contracts\Auth\StatefulGuard
     */
    protected function guard()
    {
        return Auth::guard('web');
    }
}
