<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
class RedirectIfTimeout
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next,$guard = null)
    {   
        return $next($request);
        $lifetimeKey       = url('').'.user.lifetime';
        $lifetimeKey       = md5($lifetimeKey);
        $timeoutSessionKey = md5('redirectIfTimeOut');

        define('TIMEOUT_REQUEST_SESSION_KEY',$timeoutSessionKey);
        define('TIMEOUT_SESSION_KEY',$lifetimeKey);

        // screen sleep timeout
        $sleeptime   = config('session.sleeptime'); 
        $totalSleepTime = $sleeptime;

        $now       = Carbon::now()->timestamp;

        view()->composer('*', function($view) use ($sleeptime){
            $view->with('loginTimeOut', $sleeptime); // 1 minute
        });
        
        if($this->hasCheckTimeOut($request)) {
            // if(!session()->has(TIMEOUT_REQUEST_SESSION_KEY)) {
            //     session([TIMEOUT_REQUEST_SESSION_KEY=>$now]); 
            // }
            $redirectIfTimeOut = session(TIMEOUT_REQUEST_SESSION_KEY); 

            return response()->json([
                'redirectIfTimeOut'=>$redirectIfTimeOut,
                'sleeptime'        =>$sleeptime - ($now - $redirectIfTimeOut),
                'now'                =>$now,
                'redirectIfTimeOut'                =>$redirectIfTimeOut,
                'secure'            => Auth::guard('web')->check(), 
             ]);
        } else {
            session([
                TIMEOUT_REQUEST_SESSION_KEY => $now,
            ]);
        }
        // dump($sleeptime);
        // dump($now - session(TIMEOUT_REQUEST_SESSION_KEY));
        

        // timeout
        $timeout   = config('session.lifetime');

        $lastLogin = session(TIMEOUT_SESSION_KEY);
        $totalTime = $lastLogin + $timeout*60;
        if($now >= $totalTime)
        {
            Auth::guard($guard)->logout();
            if($request->segment(1)!='login')
            {
                return redirect()->guest(url('login'));
            }
            /*return redirect()->guest(url('login'));*/
        }

        return $next($request);
    }

    private function hasCheckTimeOut($request) {
        if($request->ajax() && $request->has('checkTimeOut') && $request->has('getResponse')) {
            return true;
        }
        return false;
    }
}
