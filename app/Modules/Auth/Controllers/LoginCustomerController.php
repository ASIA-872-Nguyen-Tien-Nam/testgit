<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * LoginCustomerController
 *
 * 処理概要/process overview   : LoginCustomerController
 * 作成日/create date   : 2018-09-06 02:52:49
 * 作成者/creater    : mail@ans-asia.com
 * 
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : edit address redirect(add 'customer') 
 * 
 * 
 * @package         :  Auth
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Auth\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Cookie;
use Session;
use Carbon\Carbon;
use Dao;
use \Cache;
use App\L0020;
class LoginCustomerController extends Controller
{
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
    protected $redirectTo = 'customer/master/q0001';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->respon['status']     = OK; 
        $this->respon['errors']     = [];
        $this->respon['data_sql'] = json_encode([]);
        $this->middleware('guest:'.CUSTOMER_KEY, ['except' => 'getLogoutCustomer']);
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
       
        if($lang == null) {
            $lang = 'jp';
        };
        config(['app.locale' => $lang]);
        $data['title'] = trans('messages.login');
        Session::put('login_typ', 0);
        $_data_login_customer   = $request->cookie('_data_login_customer');
        $remember_id            = isset($_data_login_customer['remember_id']) ? $_data_login_customer['remember_id'] : '';
        $remember_contract_cd   = isset($_data_login_customer['remember_contract_cd']) ? $_data_login_customer['remember_contract_cd'] : '';
        $data['user_id'] = '';
        $data['contract_cd'] = '';
        if ( !empty($remember_id) ) {
            $data['user_id'] = isset($_data_login_customer['user_id']) ? $_data_login_customer['user_id'] : '';
        }
        if ( !empty($remember_contract_cd) ) {
            $data['contract_cd'] = isset($_data_login_customer['contract_cd']) ? $_data_login_customer['contract_cd'] : '';
        }
        $data['remember_id']            = $remember_id;
        $data['remember_contract_cd']   = $remember_contract_cd;
        // $data['_text'] = app('messages')->text(false);
        return view('Auth::guest.logincustomer',$data);
    }

    /**
     * Handle a login request to the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse|\Illuminate\Http\Response
     */
    public function postLoginCustomer(Request $request)
    {
        try {
            $params = [
                'user_id'=>$request->user_id ?? '',
                'contract_cd'=>$request->contract_cd ?? '',
                'password'=>$request->password ?? '',
            ];
            $query = Dao::executeSql('SPC_S0010_INQ3', [
                'json'=>json_encode($params,JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
                'cre_ip'=>$request->ip()
            ]);

            $user = $query[0][0] ?? [];
            $errors = $query[1][0] ?? [];

            // Error Query
            if(isset($user['error_typ']) && $user['error_typ'] == '999') {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $query['remark'];
                return response()->json($this->respon,401);
            }

            // Error 30
            if(!empty($errors) || empty($user)) {
                $this->respon['status']     = NG;
                $this->respon['message']  = L0020::getText($errors['message_no'])->message;
                return response()->json($this->respon,401);
            }

            if(!empty($user)){
                $timeout = config('session.lifetime');
                Cookie::queue('_data_login_customer', [
                    'user_id'  =>'',
                    'contract_cd'  =>'',
                    'remember_id'  =>'',
                    'remember_contract_cd'  =>'',
                    'language' => $user['language'],
                    'time'      =>Carbon::now()
                ], $timeout);
                Cookie::queue('language', [
                    'language'              =>$user['language'],
                ], $timeout);
                $remember_id            =   isset($request->remember_id)&&($request->remember_id==1) ? true : false;
                $remember_contract_cd   =   isset($request->remember_contract_cd)&&($request->remember_contract_cd==1) ? true : false;
                if($remember_id || $remember_contract_cd) {
                    $request->user_id = $remember_id ? $request->user_id : '';
                    $request->contract_cd = $remember_contract_cd ? $request->contract_cd : '';
                    $data =  [
                            'user_id'               =>$request->user_id,
                            'contract_cd'           =>$request->contract_cd,
                            'remember_id'           =>$request->remember_id,
                            'remember_contract_cd'  =>$request->remember_contract_cd,
                            'time'                  =>Carbon::now()
                        ];
                    // Cookie::forever('_data_login_customer', $data);
                    // Cookie::queue('_data_login_customer', $data, 43200); // save account 30 days
                    Cookie::queue('_data_login_customer', $data, $timeout);
                    Cookie::queue('language', [
                        'language'              =>$user['language'],
                    ], $timeout);
                } 
            }

            $now = Carbon::now();
            $today = Carbon::today();
            $user_end_dt = isset($user['user_end_dt']) && $user['user_end_dt'] !='' && $user['user_end_dt'] != null ? Carbon::parse($user['user_end_dt']) : null; 
            
            if($user_end_dt != null && $today->gt($user_end_dt)) {
                $this->respon['status']     = NG;
                $this->respon['message']  = L0020::getText(36)->message;
                return response()->json($this->respon,401);
            }

            $pass_change_datetime = isset($user['pass_change_datetime']) && $user['pass_change_datetime'] !='' && $user['pass_change_datetime'] != null ? Carbon::parse($user['pass_change_datetime']) : null; 
            $password_age = $user['password_age'] ?? 0;
           

            if($pass_change_datetime != null && $password_age > 0) {
                $subMonths = $now->subMonths($password_age);
                if($subMonths->gte($pass_change_datetime)) {
                    $this->respon['status']     = NG;
                    $this->respon['message']  = L0020::getText(30)->message;
                    return response()->json($this->respon,401);
                }
            }
            
            $login                      = new \stdClass();
            foreach($user as $key=>$value) {
                $login->$key = $value;
            }
            $login->m0070               = new \stdClass();
            $login->excepts              = new \stdClass();
            $login->screens              = new \stdClass();
            $login->currentScreenPrefix  = null;
            $login->prefix               = null;

            session([CUSTOMER_KEY=>$login]);
            return response()->json([
                'message'=>'Login success!',
                'status'=>OK,
                'redirectTo'=>$this->redirectTo,
            ]);
        } catch(\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
            return response()->json($this->respon,401);
        }

    }

    /**
     * Log the user out of the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function getLogoutCustomer(Request $request)
    {
        session()->forget(CUSTOMER_KEY);
        // $this->guard()->logout();
        deleteCache(NULL,$request->user_id);
        // Cache::flush();
        if (!session(AUTHORITY_KEY)) {
            $request->session()->flush();
        }
        return redirect('/logincustomer');
    }
}