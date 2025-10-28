<?php

namespace App\Http\Middleware;

use Closure;

class Customer
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if (!session()->has(CUSTOMER_KEY)) {
            return redirect('/'); 
        }
        $auth = session(CUSTOMER_KEY);
        // not exists user_id
        if (!isset($auth->user_id)) {
            return redirect('/logout'); 
        }
        app()->bind('session_data', function() use($auth) {
            return $auth;
        });
        return $next($request);
    }
}
