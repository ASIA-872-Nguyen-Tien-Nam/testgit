<?php

namespace App\Http\Middleware;

use Closure;
use File;
use Session;
use App\Modules\Auth\Controllers\LoginController;

class SessionTimeout
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    //public function handle()
    {
        date_default_timezone_set('Asia/Tokyo');
        $timeout = config('session.lifetime');
        $token = Session::get('user.unique'); // unique for each session
        if ( empty($token) || auth()->guard('web')->user() == null )
        {
            return redirect('/login');
        }
        # make file to save the last access time
        $filepath = storage_path('framework/sessions/timeout/' . $token . '.txt');
        $exists = File::exists($filepath);
        $last_access_datetime = time();
        if ( $exists )
        {
        	$last_access_datetime = File::get($filepath);
	        $secs = time() - $last_access_datetime; // == <seconds between the two times>
        	if ( $secs > $timeout*60 )
        	{
        		File::delete($filepath);
		        $login = new LoginController();
		        return $login->getLogout($request);
        	}
        	else
        	{
        		File::put($filepath, time());
        	}
        	// $d1 = date('Y-m-d H:i:s', $last_access_datetime);
        	// $d2 = date('Y-m-d H:i:s', time());
        	// echo "$d1------$d2------$secs";
        }
        else
        {
        	File::put($filepath, $last_access_datetime);
        }

        return $next($request);
    }
}
