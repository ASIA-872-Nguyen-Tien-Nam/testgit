<?php

namespace App\Http\Middleware;

use Closure;

class Logined
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
        $exceptPaths = [
            'om0110',
            'om0010',
            'om0400',
            'rm0100'
        ];
        // check login by MIRAC customer
        if (session()->has(CUSTOMER_KEY) && !session()->has(AUTHORITY_KEY)) 
        {
            $screen = $request->segment(2);
            if (\in_array($screen, $exceptPaths)) 
            {
                return $next($request);
            }
        }else if (!session()->has(AUTHORITY_KEY)){  // check login by user into system
            return redirect('/'); // login
        }
        return $next($request);
    }
}
