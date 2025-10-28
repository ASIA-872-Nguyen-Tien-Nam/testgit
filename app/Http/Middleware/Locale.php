<?php

namespace App\Http\Middleware;

use Closure;

class Locale
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
        $language = \Session::get('website_language', config('app.locale'));
        // Get the data stored in the Session, if not, return the default from the config

        config(['app.locale' => $language]);
        // Switch the app to the selected language
        return $next($request);
    }
}
