<?php

namespace App\Http\Middleware;

use Closure;
use Dao;
use Session;

class Permission{

    protected $prefix = 'screen_';
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        // get current path : /master/screen
        $path = $request->path();
        // get current module
        $module = $request->segment(1);
        // get current screen
        $screen2 = '';
        // check exists segment(1)
        if ($request->segment(1)) {
            $screen2 =  $this->prefix . $request->segment(1);
        }
        // check exists segment(2)
        if ($request->segment(2)) {
            $screen2 =  $screen2 . '_' . $request->segment(2);
        }
        // get segment 3 if it has '/customer'/ in path.
        if ($request->segment(1) == 'customer' && $request->segment(3)) {
            $screen2 =  $screen2 . '_' . $request->segment(3);
        }
        // if login & logout then next request
        $exceptPaths            = ['/', 'login', 'logout', 'loggedin', 'redirect_login'];
        $exceptCustomerPaths    = ['logincustomer', 'logoutcustomer'];
        // add sso routes
        if (config()->has('saml2_settings.idpNames')) {
            foreach (config('saml2_settings.idpNames') as $key => $value) {
                array_push($exceptPaths, $value . '/login');
                array_push($exceptPaths, $value . '/acs');
                array_push($exceptPaths, $value . '/logout');
            }
        }
        // check login & login_customer
        if (in_array($path, $exceptPaths) || in_array($path, $exceptCustomerPaths)) {
            return $next($request);
        }
        // get data
        $auth                           = $this->buildScreens($request);
        $excepts                        = $auth->excepts;   // 人事評価システム 
        // process
        define('SCREEN_PREFIX', $this->prefix);
        // bind session_data of $auth into application
        app()->bind('session_data', function () use ($auth) {
            return $auth;
        });
        // if module = common then return next request
        if ($module == 'common') {
            define('AUTHORITY', -1);
            return $next($request);
        }
        // check ajax 
        if ($request->ajax()) {
            if (property_exists($excepts, strtolower($screen2))) {
                return $next($request);
            }
        }
        // response error page if not accept  
        if (!property_exists($excepts, strtolower($screen2))) {
            if ($request->ajax()) {
                return response()->json([
                    'errors' => 'Permission denied'
                ], 403);
            }
            return response()->view('errors.403');
        }
        // get authority
        $authority = 0;
        if (property_exists($excepts, strtolower($screen2))) {
            $authority = $excepts->$screen2->authority ?? 0;
        }
        define('AUTHORITY', $authority);
        if ($authority == 0 && $screen2 != 'screen_weeklyreport_ri2010') {
            if ($request->ajax()) {
                return response()->json([
                    'errors' => 'Permission denied'
                ], 405);
            }
            return response()->view('errors.405');
        }
        return $next($request);
    }

    /**
     * build auth
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return Object
     */
    private function buildScreens($request)
    {
        $path = $request->path();
        $path = str_replace('/', '_', $path); //namnt
        if (strpos($path, 'customer') !== false && session(CUSTOMER_KEY)) {
            $auth = session(CUSTOMER_KEY);
        } else {
            $auth = session(AUTHORITY_KEY) ?? session(CUSTOMER_KEY) ?? new \stdClass();
        }
        $from                       = $request->from;
        $cache                      = [];
        $employee_cd                = '';
        if ($from) {
            $user_id = $auth->user_id ?? '';
            $cache                  = getCache($from, $user_id);
            if (isset($cache)) {
                $employee_cd        = $cache['employee_cd'] ?? '';
            }
        }
        $query = Dao::executeSql('SPC_S0010_INQ2', [
            'company_cd'  => $auth->company_cd ?? 0,
            'user_id'     => $auth->user_id ?? '',
            'employee_cd' => $employee_cd ?? ''
        ]);
        // 人事評価
        $authority = [
            'authority_typ' => 0,
            'w_1on1_authority_typ' => 0,
            'multireview_authority_typ' => 0,
            'setting_authority_typ' => 0,
            'report_authority_typ' => 0,
        ];
        $screens = $query[0] ?? [];
        $m0070 = $query[1][0] ?? [];
        if (isset($query[2][0]) && !empty($query[2][0])) {
            $authority = $query[2][0];
        }
        $auth->language = $query[2][0]['language'];
        if (strpos($path, 'customer') !== false && session(CUSTOMER_KEY)) {
            session([CUSTOMER_KEY => $auth]);
        } else {
            if (session(AUTHORITY_KEY)) {
                session([AUTHORITY_KEY => $auth]);
            } else {
                session([CUSTOMER_KEY => $auth]);
            }
        }
        Session::put('website_language', $query[2][0]['language']);
        //
        $auth->currentScreenPrefix = $this->prefix . str_replace('/', '_', $path);
        $auth->prefix = $this->prefix;
        if (!empty($query) && !isset($query['error_typ'])) {
            $auth->excepts = $this->screens($screens);
            $auth->authority_typ = $authority['authority_typ'];
            $auth->w_1on1_authority_typ = $authority['w_1on1_authority_typ'];
            $auth->multireview_authority_typ = $authority['multireview_authority_typ'];
            $auth->setting_authority_typ = $authority['setting_authority_typ'];
            $auth->report_authority_typ = $authority['report_authority_typ'];
            //  get data employee master into session
            if (isset($m0070) && !empty($m0070)) {
                foreach ($m0070 as $key => $item) {
                    $auth->m0070->$key = $item;
                }
                $auth->m0070->mypurpose = '';
                $auth->m0070->mypurpose_use_typ = 0;
                if (isset($query[3][0])) {
                    $auth->m0070->mypurpose = $query[3][0]['mypurpose'] ?? '';
                    $auth->m0070->mypurpose_use_typ = $query[3][0]['mypurpose_use_typ'] ?? '';
                }
            }
        }
        return $auth;
    }
    
    /**
     * build screen
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return Object
     */
    private function screens(array $array)
    {
        $data = new \stdClass();
        foreach ($array as $row) {
            $function_id = strtolower($row['function_id']);
            $function_id = str_replace('/', '_', $function_id);
            $screen = $this->prefix . $function_id;
            $data->$screen = new \stdClass();
            foreach ($row as $key => $value) {
                if ($key == 'function_id') {
                    $data->$screen->$key = strtolower($value);
                } else {
                    $data->$screen->$key = $value;
                }
            }
        }
        return $data;
    }
}