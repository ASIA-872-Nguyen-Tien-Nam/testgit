<?php 
/**
 ****************************************************************************
 * 
 * RedirectifAuthenticated.php
 *
 * 処理概要/process overview   : 
 * 作成日/create date   : 
 * 作成者/creater    : 
 * 
 * 更新日/update date    : 2022/04/20
 * 更新者/updater    : namnt
 * 更新内容 /update content  : forget old session
 * 
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class RedirectIfAuthenticated
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function handle($request, Closure $next, $guard = null)
    {
        if($request->path() == 'redirect_login') {
            session()->forget(AUTHORITY_KEY);
        };
        if (session()->has($guard) && $guard == AUTHORITY_KEY) {
            
            $redirectTo = '/menu';
            // $authority_typ = $this->auth($guard)->authority_typ;
            // switch ($authority_typ) {
            //     case 1:
            //         $redirectTo = '/master/portal/evaluator';
            //         break;
            //     case 2:
            //         $redirectTo = '/master/portal';
            //         break;
            //     case 3:
            //         $redirectTo = '/dashboard';
            //         break;
            //     default:
            //         $redirectTo = '/master/portal/evaluator';
            //         break;
            // }
            return redirect($redirectTo);
        } else if (session()->has($guard) && $guard == CUSTOMER_KEY && isset($this->auth($guard)->user_id)) {
            $authority_typ = $this->auth($guard)->authority_typ;
            $redirectTo = '/customer/master/q0001';
            return redirect($redirectTo);
        }

        return $next($request);
    }

    protected function auth($guard) 
    {
        return session($guard);
    }
}
